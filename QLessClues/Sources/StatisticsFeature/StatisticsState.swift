import ComposableArchitecture
import PlaysDataProviderInterface
import PlaysListFeature
import SharedModelsLibrary
import SolverServiceInterface
import ValidatorServiceInterface

public struct StatisticsState: Equatable {
	public var statistics: Statistics = .init(plays: [])
	public var plays: [Play]?
	public var playsList: PlaysListState?

	public init() {}
}

public enum StatisticsAction: Equatable {
	case onAppear
	case playsResponse([Play])
	case playsList(PlaysListAction)
}

public struct StatisticsEnvironment: Sendable {
	public var playsDataProvider: PlaysDataProvider
	public var solverService: SolverService

	public init(playsDataProvider: PlaysDataProvider, solverService: SolverService) {
		self.playsDataProvider = playsDataProvider
		self.solverService = solverService
	}
}

public let statisticsReducer = Reducer<StatisticsState, StatisticsAction, StatisticsEnvironment>.combine(
	playsListReducer
		.optional()
		.pullback(
			state: \.playsList,
			action: /StatisticsAction.playsList,
			environment: {
				PlaysListEnvironment(solverService: $0.solverService)
			}
		),
	.init { state, action, environment in
		switch action {
		case .onAppear:
			return .task {
				await .playsResponse(environment.playsDataProvider.fetchAll())
			}

		case let .playsResponse(plays):
			state.plays = plays
			state.statistics = .init(plays: plays)
			state.playsList = .init(plays: plays)
			return .none

		case .playsList:
			return .none
		}
	}
)
