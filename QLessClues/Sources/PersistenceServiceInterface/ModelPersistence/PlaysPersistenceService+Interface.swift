import GRDB
import SharedModelsLibrary

public struct PlaysPersistenceService: Sendable {
	public var create: @Sendable (Play, Database) throws -> Void
	public var update: @Sendable (Play, Database) throws -> Void
	public var delete: @Sendable (Play, Database) throws -> Void

	public init(
		create: @escaping @Sendable (Play, Database) throws -> Void,
		update: @escaping @Sendable (Play, Database) throws -> Void,
		delete: @escaping @Sendable (Play, Database) throws -> Void
	) {
		self.create = create
		self.update = update
		self.delete = delete
	}
}
