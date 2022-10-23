import SharedModelsLibrary

public struct PlaysDataProvider: Sendable {
	public var save: @Sendable (Play) async throws -> Void
	public var delete: @Sendable (Play) async throws -> Void
	public var update: @Sendable (Play) async throws -> Void

	public var fetchAll: @Sendable (Play.FetchRequest) -> AsyncThrowingStream<[Play], Error>
	public var fetchOne: @Sendable (Play.SingleFetchRequest) -> AsyncThrowingStream<Play, Error>

	public init(
		save: @escaping @Sendable (Play) async throws -> Void,
		delete: @escaping @Sendable (Play) async throws -> Void,
		update: @escaping @Sendable (Play) async throws -> Void,
		fetchAll: @escaping @Sendable (Play.FetchRequest) -> AsyncThrowingStream<[Play], Error>,
		fetchOne: @escaping @Sendable (Play.SingleFetchRequest) -> AsyncThrowingStream<Play, Error>
	) {
		self.save = save
		self.delete = delete
		self.update = update
		self.fetchAll = fetchAll
		self.fetchOne = fetchOne
	}
}

#if DEBUG
extension PlaysDataProvider {
	public static func mock() -> Self {
		.init(
			save: { _ in fatalError("\(Self.self).save") },
			delete: { _ in fatalError("\(Self.self).delete") },
			update: { _ in fatalError("\(Self.self).update") },
			fetchAll: { _ in fatalError("\(Self.self).fetchAll") },
			fetchOne: { _ in fatalError("\(Self.self).fetchOne") }
		)
	}
}
#endif
