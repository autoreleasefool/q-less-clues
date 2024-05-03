import Dependencies
import Foundation
import GRDB
import PersistenceServiceInterface
import PersistentModelsLibrary
import PlaysRepositoryInterface
import SharedModelsLibrary

extension PlaysRepository: DependencyKey {
	public static var liveValue = Self(
		save: { play in
			@Dependency(\.persistence) var persistence
			@Dependency(\.playsPersistence) var playsPersistence
			try await persistence.write {
				try await $0.write { db in
					try playsPersistence.create(play, db)
				}
			}
		},
		delete: { play in
			@Dependency(\.persistence) var persistence
			@Dependency(\.playsPersistence) var playsPersistence
			try await persistence.write {
				try await $0.write { db in
					try playsPersistence.delete(play, db)
				}
			}
		},
		update: { play in
			@Dependency(\.persistence) var persistence
			@Dependency(\.playsPersistence) var playsPersistence
			try await persistence.write {
				try await $0.write { db in
					try playsPersistence.update(play, db)
				}
			}
		},
		fetchAll: { request in
			@Dependency(\.persistence) var persistence
			return .init { continuation in
				let task = Task {
					do {
						let db = persistence.reader()
						let observation = ValueObservation.tracking(request.fetchValue(_:))

						for try await plays in observation.values(in: db) {
							continuation.yield(plays)
						}

						continuation.finish()
					} catch {
						continuation.finish(throwing: error)
					}
				}

				continuation.onTermination = { _ in task.cancel() }
			}
		},
		fetchOne: { request in
			@Dependency(\.persistence) var persistence
			return .init { continuation in
				let task = Task {
					do {
						let db = persistence.reader()
						let observation = ValueObservation.tracking(request.fetchValue(_:))

						for try await play in observation.values(in: db) {
							if let play {
								continuation.yield(play)
							} else {
								break
							}
						}

						continuation.finish()
					} catch {
						continuation.finish(throwing: error)
					}
				}

				continuation.onTermination = { _ in task.cancel() }
			}
		}
	)
}
