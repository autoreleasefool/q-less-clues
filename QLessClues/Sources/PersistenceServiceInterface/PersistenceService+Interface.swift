import Dependencies
import DependenciesMacros
import GRDB

public struct PersistenceService: Sendable {
	public var reader: @Sendable () -> DatabaseReader
	public var write: @Sendable (@escaping (any DatabaseWriter) async throws -> Void) async throws -> Void

	public init(
		reader: @escaping @Sendable () -> DatabaseReader,
		write: @escaping @Sendable (@escaping (any DatabaseWriter) async throws -> Void) async throws -> Void
	) {
		self.reader = reader
		self.write = write
	}
}

extension PersistenceService: TestDependencyKey {
	public static var testValue = Self(
		reader: { unimplemented("\(Self.self).reader") },
		write: { _ in unimplemented("\(Self.self).write") }
	)
}

extension DependencyValues {
	public var persistence: PersistenceService {
		get { self[PersistenceService.self] }
		set { self[PersistenceService.self] = newValue }
	}
}
