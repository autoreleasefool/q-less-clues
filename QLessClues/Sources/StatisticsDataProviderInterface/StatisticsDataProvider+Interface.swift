import Dependencies
import SharedModelsLibrary

public struct StatisticsDataProvider: Sendable {
	public var fetch: @Sendable () -> AsyncThrowingStream<Statistics, Error>

	public init(fetch: @escaping @Sendable () -> AsyncThrowingStream<Statistics, Error>) {
		self.fetch = fetch
	}
}

extension StatisticsDataProvider: TestDependencyKey {
	public static var testValue = Self(
		fetch: { fatalError("\(Self.self).fetch") }
	)
}

extension DependencyValues {
	public var statisticsDataProvider: StatisticsDataProvider {
		get { self[StatisticsDataProvider.self] }
		set { self[StatisticsDataProvider.self] = newValue }
	}
}
