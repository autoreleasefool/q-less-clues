import ComposableArchitecture
import SharedModelsLibrary
import StatisticsDataProviderInterface

public struct StatisticsReducer: ReducerProtocol {
	public struct State: Equatable {
		public var statistics: Statistics?

		public init() {}
	}

	public enum Action: Equatable {
		case onAppear
		case onDisappear
		case statisticsResponse(Statistics)
	}

	private enum StatisticsCancellable {}

	public init() {}

	@Dependency(\.statisticsDataProvider) var statisticsDataProvider

	public var body: some ReducerProtocol<State, Action> {
		Reduce { state, action in
			switch action {
			case .onAppear:
				return .run { send in
					for try await statistics in statisticsDataProvider.fetch() {
						await send(.statisticsResponse(statistics))
					}
				}
				.cancellable(id: StatisticsCancellable.self)

			case .onDisappear:
				return .cancel(id: StatisticsCancellable.self)

			case let .statisticsResponse(statistics):
				state.statistics = statistics
				return .none
			}
		}
	}
}
