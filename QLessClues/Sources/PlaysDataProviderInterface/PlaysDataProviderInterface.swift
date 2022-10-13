import SharedModelsLibrary

public struct PlaysDataProvider: Sendable {
	public var save: @Sendable (Play) async throws -> Void
	public var delete: @Sendable (Play) async throws -> Void
	public var update: @Sendable (Play) async throws -> Void

	public var fetchAll: @Sendable () -> AsyncStream<[Play]>
	public var fetchOne: @Sendable (Play.ID) -> AsyncStream<Play>

	public init(
		save: @escaping @Sendable (Play) async throws -> Void,
		delete: @escaping @Sendable (Play) async throws -> Void,
		update: @escaping @Sendable (Play) async throws -> Void,
		fetchAll: @escaping @Sendable () -> AsyncStream<[Play]>,
		fetchOne: @escaping @Sendable (Play.ID) -> AsyncStream<Play>
	) {
		self.save = save
		self.delete = delete
		self.update = update
		self.fetchAll = fetchAll
		self.fetchOne = fetchOne
	}
}
