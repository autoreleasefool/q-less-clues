import ComposableArchitecture
import Foundation
import PlayFeature
import PlaysDataProviderInterface
import RecordPlayFeature
import SharedModelsLibrary
import SolverServiceInterface
import StatisticsDataProviderInterface
import StatisticsFeature

public struct PlaysListState: Equatable {
	public var plays: IdentifiedArrayOf<Play> = []
	public var selection: Identified<Play.ID, PlayState>?
	public var recordPlay: RecordPlayState?
	public var statistics = StatisticsState()

	public init() {}
}

public enum PlaysListAction: Equatable {
	case onAppear
	case playsResponse([Play])
	case setRecordSheet(isPresented: Bool)
	case setPlaySelection(selection: Play.ID?)
	case delete(IndexSet)
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
				RecordPlayEnvironment(solverService: $0.solverService)
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
				PlayEnvironment(solverService: $0.solverService)
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
				for await plays in environment.playsDataProvider.fetchAll() {
					await send(.playsResponse(plays))
				}
			}

		case let .playsResponse(plays):
			state.plays = IdentifiedArrayOf(uniqueElements: plays)
			return .none

		case let .delete(indexSet):
			state.plays.remove(atOffsets: indexSet)
			// TODO: persist deletion
			return .none

		case .play(.alert(.deleteButtonTapped)):
			// TODO: delete the given play
			state.selection = nil
			return .none

		case let .setPlaySelection(.some(id)):
			if let play = state.plays[id: id] {
				state.selection = Identified(PlayState(play: play), id: id)
			}
			return .none

		case .setPlaySelection(selection: .none):
			state.selection = nil
			return .none

		case .setRecordSheet(isPresented: true):
			state.recordPlay = .init()
			return .none

		case .setRecordSheet(isPresented: false):
			state.recordPlay = nil
			return .none

		case .recordPlay, .play, .statistics:
			return .none
		}
	}
)
