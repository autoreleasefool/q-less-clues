import ComposableArchitecture
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
	case playsList(PlaysListAction)
}

public struct StatisticsEnvironment: Sendable {
	public var solverService: SolverService

	public init(solverService: SolverService) {
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
	.init { state, action, _ in
		switch action {
		case .onAppear:
			// TODO: load plays list
			return .none

		case .playsList:
			return .none
		}
	}
)
