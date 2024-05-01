import Dependencies
import SharedModelsLibrary

public struct StatisticsDataProvider: Sendable {
	public var fetchCounts: @Sendable () -> AsyncThrowingStream<[LetterPlayCount], Error>
	public var fetch: @Sendable (Statistics.FetchRequest) -> AsyncThrowingStream<Statistics, Error>

	public init(
		fetchCounts: @escaping @Sendable () -> AsyncThrowingStream<[LetterPlayCount], Error>,
		fetch: @escaping @Sendable (Statistics.FetchRequest) -> AsyncThrowingStream<Statistics, Error>
	) {
		self.fetchCounts = fetchCounts
		self.fetch = fetch
	}
}

extension StatisticsDataProvider: TestDependencyKey {
	public static var testValue = Self(
		fetchCounts: { fatalError("\(Self.self).fetchCounts") },
		fetch: { _ in fatalError("\(Self.self).fetch") }
	)
}

extension DependencyValues {
	public var statisticsDataProvider: StatisticsDataProvider {
		get { self[StatisticsDataProvider.self] }
		set { self[StatisticsDataProvider.self] = newValue }
	}
}
