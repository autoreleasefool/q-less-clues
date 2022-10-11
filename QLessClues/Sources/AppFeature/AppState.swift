import ComposableArchitecture
import DictionaryLibrary
import PlaysListFeature
import PlaysDataProviderInterface
import SolverServiceInterface
import StatisticsDataProviderInterface

public struct AppState: Equatable {
	public var playsList = PlaysListState()

	public init() {}
}

public enum AppAction: Equatable {
	case onAppear
	case playsList(PlaysListAction)
}

public struct AppEnvironment: Sendable {
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

public let appReducer = Reducer<AppState, AppAction, AppEnvironment>.combine(
	playsListReducer
		.pullback(
			state: \.playsList,
			action: /AppAction.playsList,
			environment: {
				PlaysListEnvironment(
					playsDataProvider: $0.playsDataProvider,
					statisticsDataProvider: $0.statisticsDataProvider,
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

		case .playsList:
			return .none
		}
	}
)
