import Foundation
import SharedModelsLibrary

public struct PlaysDataProvider: Sendable {
	public var save: @Sendable (Play) async throws -> Void
	public var delete: @Sendable (Play) async throws -> Void
	public var update: @Sendable (Play) async throws -> Void

	public var fetchAll: @Sendable () async -> [Play]
	public var fetchOne: @Sendable (UUID) async -> Play?

	public init(
		save: @escaping @Sendable (Play) async throws -> Void,
		delete: @escaping @Sendable (Play) async throws -> Void,
		update: @escaping @Sendable (Play) async throws -> Void,
		fetchAll: @escaping @Sendable () async -> [Play],
		fetchOne: @escaping @Sendable (UUID) async -> Play?
	) {
		self.save = save
		self.delete = delete
		self.update = update
		self.fetchAll = fetchAll
		self.fetchOne = fetchOne
	}
}
