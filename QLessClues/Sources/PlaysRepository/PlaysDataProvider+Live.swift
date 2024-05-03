import Dependencies
import Foundation
import GRDB
import PersistenceServiceInterface
import PersistentModelsLibrary
import PlaysRepositoryInterface
import SharedModelsLibrary

extension PlaysDataProvider: DependencyKey {
	public static var liveValue = Self(
		save: { play in
			@Dependency(\.persistenceService) var persistenceService: PersistenceService
			@Dependency(\.playsPersistenceService) var playsPersistenceService: PlaysPersistenceService
			try await persistenceService.write {
				try await $0.write { db in
					try playsPersistenceService.create(play, db)
				}
			}
		},
		delete: { play in
			@Dependency(\.persistenceService) var persistenceService: PersistenceService
			@Dependency(\.playsPersistenceService) var playsPersistenceService: PlaysPersistenceService
			try await persistenceService.write {
				try await $0.write { db in
					try playsPersistenceService.delete(play, db)
				}
			}
		},
		update: { play in
			@Dependency(\.persistenceService) var persistenceService: PersistenceService
			@Dependency(\.playsPersistenceService) var playsPersistenceService: PlaysPersistenceService
			try await persistenceService.write {
				try await $0.write { db in
					try playsPersistenceService.update(play, db)
				}
			}
		},
		fetchAll: { request in
			@Dependency(\.persistenceService) var persistenceService: PersistenceService
			return .init { continuation in
				let task = Task {
					do {
						let db = persistenceService.reader()
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
			@Dependency(\.persistenceService) var persistenceService: PersistenceService
			return .init { continuation in
				let task = Task {
					do {
						let db = persistenceService.reader()
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
