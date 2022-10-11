import ComposableArchitecture
import DictionaryLibrary
import PlaysDataProviderInterface
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
	public var playsDataProvider: PlaysDataProvider
	public var solverService: SolverService

	public init(playsDataProvider: PlaysDataProvider, solverService: SolverService) {
		self.playsDataProvider = playsDataProvider
		self.solverService = solverService
	}
}

public let appReducer = Reducer<AppState, AppAction, AppEnvironment>.combine(
	statisticsReducer
		.pullback(
			state: \.statistics,
			action: /AppAction.statistics,
			environment: {
				StatisticsEnvironment(
					playsDataProvider: $0.playsDataProvider,
					solverService: $0.solverService
				)
			}
		),
	.init { _, action, _ in
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
