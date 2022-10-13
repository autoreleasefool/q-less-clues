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
	public var plays: [Play] = []
	public var recordPlay: RecordPlayState?
	public var play: PlayState?
	public var statistics = StatisticsState()

	public init() {}
}

public enum PlaysListAction: Equatable {
	case onAppear
	case playsResponse([Play])
	case addButtonTapped
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
		.optional()
		.pullback(
			state: \.play,
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
			state.plays = plays
			return .none

		case let .delete(indexSet):
			state.plays.remove(atOffsets: indexSet)
			// TODO: persist deletion
			return .none

		case .play(.alert(.deleteButtonTapped)):
			// TODO: delete the given play
			state.play = nil
			return .none

		case .addButtonTapped:
			state.recordPlay = .init()
			return .none

		case .recordPlay, .play, .statistics:
			return .none
		}
	}
)
