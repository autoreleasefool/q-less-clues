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
