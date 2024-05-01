import ComposableArchitecture
import SharedModelsLibrary
import StatisticsRepositoryInterface

public struct StatisticsReducer: ReducerProtocol {
	public struct State: Equatable {
		public var statistics: Statistics?
		public var statisticsList: StatisticsList.State?

		public init() {}
	}

	public enum Action: Equatable {
		case viewAllButtonTapped
		case subscribeToStatistics
		case statisticsResponse(Statistics)
		case dismissList
		case statisticsList(StatisticsList.Action)
	}

	public init() {}

	@Dependency(\.statisticsDataProvider) var statisticsDataProvider

	public var body: some ReducerProtocol<State, Action> {
		Reduce { state, action in
			switch action {
			case .subscribeToStatistics:
				return .run { send in
					for try await statistics in statisticsDataProvider.fetch(.init()) {
						await send(.statisticsResponse(statistics))
					}
				}

			case .viewAllButtonTapped:
				state.statisticsList = .init()
				return .none

			case .dismissList:
				state.statisticsList = nil
				return .none

			case let .statisticsResponse(statistics):
				state.statistics = statistics
				return .none

			case .statisticsList:
				return .none
			}
		}
		.ifLet(\.statisticsList, action: /StatisticsReducer.Action.statisticsList) {
			StatisticsList()
		}
	}
}
