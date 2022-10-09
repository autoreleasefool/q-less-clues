import ComposableArchitecture
import DictionaryLibrary
import SolverServiceInterface
import StatisticsFeature
import ValidatorServiceInterface

public struct AppState: Equatable {
	public var statistics = StatisticsState()

	public init() {}
}

public enum AppAction: Equatable {
	case onAppear
	case statistics(StatisticsAction)
}

public struct AppEnvironment: Sendable {
	public var solverService: SolverService
	public var validatorService: ValidatorService

	public init(solverService: SolverService, validatorService: ValidatorService) {
		self.solverService = solverService
		self.validatorService = validatorService
	}
}

public let appReducer = Reducer<AppState, AppAction, AppEnvironment>.combine(
	statisticsReducer
		.pullback(
			state: \.statistics,
			action: /AppAction.statistics,
			environment: {
				StatisticsEnvironment(
					solverService: $0.solverService,
					validatorService: $0.validatorService
				)
			}
		),
	.init { state, action, _ in
		switch action {
		case .onAppear:
			return .fireAndForget {
				_ = WordSet.englishSet
				_ = WordFrequency.englishFrequencies
			}

		case .statistics:
			return .none
		}
	}
)
