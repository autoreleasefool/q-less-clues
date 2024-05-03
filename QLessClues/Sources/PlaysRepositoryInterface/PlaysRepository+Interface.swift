import Dependencies
import SharedModelsLibrary

public struct PlaysRepository: Sendable {
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

extension PlaysRepository: TestDependencyKey {
	public static var testValue = Self(
		save: { _ in unimplemented("\(Self.self).save") },
		delete: { _ in unimplemented("\(Self.self).delete") },
		update: { _ in unimplemented("\(Self.self).update") },
		fetchAll: { _ in unimplemented("\(Self.self).fetchAll") },
		fetchOne: { _ in unimplemented("\(Self.self).fetchOne") }
	)
}

extension DependencyValues {
	public var plays: PlaysRepository {
		get { self[PlaysRepository.self] }
		set { self[PlaysRepository.self] = newValue }
	}
}
