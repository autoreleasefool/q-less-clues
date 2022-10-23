import Dependencies
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

extension PlaysPersistenceService: TestDependencyKey {
	public static var testValue = Self(
		create: { _, _ in fatalError("\(Self.self).create") },
		update: { _, _ in fatalError("\(Self.self).update") },
		delete: { _, _ in fatalError("\(Self.self).delete") }
	)
}

extension DependencyValues {
	public var playsPersistenceService: PlaysPersistenceService {
		get { self[PlaysPersistenceService.self] }
		set { self[PlaysPersistenceService.self] = newValue }
	}
}
