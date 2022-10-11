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
			return .task {
				await .statisticsResponse(environment.statisticsDataProvider.fetch())
			}

		case let .statisticsResponse(statistics):
			state.statistics = statistics
			return .none
		}
	}
