import ComposableArchitecture
import SharedModelsLibrary
import StatisticsDataProviderInterface

private enum StatisticsCancellable {}

public struct StatisticsState: Equatable {
	public var statistics: Statistics?

	public init() {}
}

public enum StatisticsAction: Equatable {
	case onAppear
	case onDisappear
	case statisticsResponse(Statistics)
}

public struct StatisticsEnvironment: Sendable {
	public var statisticsDataProvider: StatisticsDataProvider

	public init(statisticsDataProvider: StatisticsDataProvider) {
		self.statisticsDataProvider = statisticsDataProvider
	}
}

public let statisticsReducer =
	Reducer<StatisticsState, StatisticsAction, StatisticsEnvironment> { state, action, environment in
		switch action {
		case .onAppear:
			return .run { send in
				for try await statistics in environment.statisticsDataProvider.fetch() {
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
