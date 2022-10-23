import SharedModelsLibrary

public struct StatisticsDataProvider: Sendable {
	public var fetch: @Sendable () -> AsyncThrowingStream<Statistics, Error>

	public init(fetch: @escaping @Sendable () -> AsyncThrowingStream<Statistics, Error>) {
		self.fetch = fetch
	}
}

#if DEBUG
extension StatisticsDataProvider {
	public static func mock() -> Self {
		.init(fetch: { fatalError("\(Self.self).fetch") })
	}
}
#endif
