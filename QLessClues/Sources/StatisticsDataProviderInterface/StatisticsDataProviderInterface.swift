import SharedModelsLibrary

public struct StatisticsDataProvider: Sendable {
	public var fetch: @Sendable () -> AsyncStream<Statistics>

	public init(fetch: @escaping @Sendable () -> AsyncStream<Statistics>) {
		self.fetch = fetch
	}
}
