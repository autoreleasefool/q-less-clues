import Foundation
import GRDB
import PersistenceServiceInterface
import PersistentModelsLibrary
import PlaysDataProviderInterface
import SharedModelsLibrary

extension PlaysDataProvider {
	public struct Live {

		private let persistenceService: PersistenceService
		private let playsPersistenceService: PlaysPersistenceService

		public init(persistenceService: PersistenceService, playsPersistenceService: PlaysPersistenceService) {
			self.persistenceService = persistenceService
			self.playsPersistenceService = playsPersistenceService
		}

		@Sendable func save(play: Play) async throws {
			try await persistenceService.write {
				try await $0.write { db in
					try playsPersistenceService.create(play, db)
				}
			}
		}

		@Sendable func delete(play: Play) async throws {
			try await persistenceService.write {
				try await $0.write { db in
					try playsPersistenceService.delete(play, db)
				}
			}
		}

		@Sendable func update(play: Play) async throws {
			try await persistenceService.write {
				try await $0.write { db in
					try playsPersistenceService.update(play, db)
				}
			}
		}

		@Sendable func fetchAll(request: Play.FetchRequest) -> AsyncThrowingStream<[Play], Error> {
			.init { continuation in
				Task {
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
			}
		}

		@Sendable func fetchOne(request: Play.SingleFetchRequest) -> AsyncThrowingStream<Play, Error> {
			.init { continuation in
				Task {
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
			}
		}
	}
}

extension PlaysDataProvider {
	public static func live(with playsDataProviderLive: Live) -> Self {
		.init(
			save: playsDataProviderLive.save,
			delete: playsDataProviderLive.delete,
			update: playsDataProviderLive.update,
			fetchAll: playsDataProviderLive.fetchAll,
			fetchOne: playsDataProviderLive.fetchOne
		)
	}
}
