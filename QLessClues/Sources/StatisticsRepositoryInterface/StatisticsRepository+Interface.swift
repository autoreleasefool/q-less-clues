import Dependencies
import SharedModelsLibrary

public struct StatisticsRepository: Sendable {
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

extension StatisticsRepository: TestDependencyKey {
	public static var testValue = Self(
		fetchCounts: { unimplemented("\(Self.self).fetchCounts") },
		fetch: { _ in unimplemented("\(Self.self).fetch") }
	)
}

extension DependencyValues {
	public var statistics: StatisticsRepository {
		get { self[StatisticsRepository.self] }
		set { self[StatisticsRepository.self] = newValue }
	}
}
