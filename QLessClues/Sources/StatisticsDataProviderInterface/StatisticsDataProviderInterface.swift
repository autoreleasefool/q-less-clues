import SharedModelsLibrary

public struct StatisticsDataProvider: Sendable {
	public var fetch: @Sendable () -> AsyncStream<Statistics>

	public init(fetch: @escaping @Sendable () -> AsyncStream<Statistics>) {
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
