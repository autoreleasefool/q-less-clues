import ComposableArchitecture
import Foundation
import PlayFeature
import PlaysDataProviderInterface
import RecordPlayFeature
import SharedModelsLibrary
import SolverServiceInterface
import StatisticsDataProviderInterface
import StatisticsFeature

private enum PlaysCancellable {}
private enum PlayCancellable {}

public struct PlaysListState: Equatable {
	public var plays: IdentifiedArrayOf<Play> = []
	public var selection: Identified<Play.ID, PlayState>?
	public var recordPlay: RecordPlayState?
	public var statistics = StatisticsState()

	public init() {}
}

public enum PlaysListAction: Equatable {
	case onAppear
	case onDisappear
	case playsResponse([Play])
	case setRecordSheet(isPresented: Bool)
	case setPlaySelection(selection: Play.ID?)
	case playResponse(Play)
	case delete(IndexSet)
	case playDeleted
	case recordPlay(RecordPlayAction)
	case play(PlayAction)
	case statistics(StatisticsAction)
}

public struct PlaysListEnvironment: Sendable {
	public var playsDataProvider: PlaysDataProvider
	public var statisticsDataProvider: StatisticsDataProvider
	public var solverService: SolverService

	public init(
		playsDataProvider: PlaysDataProvider,
		statisticsDataProvider: StatisticsDataProvider,
		solverService: SolverService
	) {
		self.playsDataProvider = playsDataProvider
		self.statisticsDataProvider = statisticsDataProvider
		self.solverService = solverService
	}
}

public let playsListReducer = Reducer<PlaysListState, PlaysListAction, PlaysListEnvironment>.combine(
	recordPlayReducer
		.optional()
		.pullback(
			state: \.recordPlay,
			action: /PlaysListAction.recordPlay,
			environment: {
				RecordPlayEnvironment(
					playsDataProvider: $0.playsDataProvider,
					solverService: $0.solverService
				)
			}
		),
	playReducer
		.pullback(
			state: \Identified.value,
			action: .self,
			environment: { $0 }
		)
		.optional()
		.pullback(
			state: \.selection,
			action: /PlaysListAction.play,
			environment: {
				PlayEnvironment(
					playsDataProvider: $0.playsDataProvider,
					solverService: $0.solverService
				)
			}
		),
	statisticsReducer
		.pullback(
			state: \.statistics,
			action: /PlaysListAction.statistics,
			environment: {
				StatisticsEnvironment(statisticsDataProvider: $0.statisticsDataProvider)
			}
		),
	.init { state, action, environment in
		switch action {
		case .onAppear:
			return .run { send in
				for try await plays in environment.playsDataProvider.fetchAll(.init(ordering: .byDate)) {
					await send(.playsResponse(plays))
				}
			}
			.cancellable(id: PlaysCancellable.self)

		case .onDisappear:
			return .cancel(ids: [PlaysCancellable.self, PlayCancellable.self])

		case let .playsResponse(plays):
			state.plays = IdentifiedArrayOf(uniqueElements: plays)
			return .none

		case let .delete(indexSet):
			guard let index = indexSet.first, index < state.plays.count else {
				return .none
			}

			let play = state.plays[index]
			state.plays.remove(at: index)
			return .task { [play = play] in
				try await environment.playsDataProvider.delete(play)
				return .playDeleted
			}

		case .play(.playDeleted):
			return .none

		case .play(.onDisappear):
			state.selection = nil
			return .none

		case let .setPlaySelection(selection: .some(id)):
			return .task {
				for try await play in environment.playsDataProvider.fetchOne(.init(id: id)) {
					return .playResponse(play)
				}
				return .setPlaySelection(selection: nil)
			}
			.cancellable(id: PlayCancellable.self)

		case .setPlaySelection(selection: .none):
			state.selection = nil
			return .none

		case let .playResponse(play):
			state.selection = Identified(PlayState(play: play), id: play.id)
			return .none

		case .setRecordSheet(isPresented: true):
			state.recordPlay = .init()
			return .none

		case .setRecordSheet(isPresented: false):
			state.recordPlay = nil
			return .none

		case .recordPlay(.playSaved):
			state.recordPlay = nil
			return .none

		case .recordPlay, .play, .statistics, .playDeleted:
			return .none
		}
	}
)
