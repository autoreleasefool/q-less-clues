import ComposableArchitecture
import SharedModelsLibrary
import StatisticsDataProviderInterface

public struct StatisticsState: Equatable {
	public var statistics: Statistics?

	public init() {}
}

public enum StatisticsAction: Equatable {
	case load
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
		case .load:
			return .run { send in
				for try await statistics in environment.statisticsDataProvider.fetch() {
					await send(.statisticsResponse(statistics))
				}
			}

		case let .statisticsResponse(statistics):
			state.statistics = statistics
			return .none
		}
	}
