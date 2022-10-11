import Foundation
import PersistenceServiceInterface
import PersistentModelsLibrary
import PlaysDataProviderInterface
import SharedModelsLibrary

extension PlaysDataProvider {
	public struct Live {

		private let persistenceService: PersistenceService

		public init(persistenceService: PersistenceService) {
			self.persistenceService = persistenceService
		}

		private func resumeOrThrow(_ error: Error?, continuation: CheckedContinuation<Void, Error>) {
			if let error {
				continuation.resume(throwing: error)
			} else {
				continuation.resume(returning: ())
			}
		}

		@Sendable func save(play: Play) async throws {
			try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
				persistenceService.writeAsync({ realm in
					realm.add(play.asPersistent())
				}, {
					resumeOrThrow($0, continuation: continuation)
				})
			}
		}

		@Sendable func delete(play: Play) async throws {
			try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
				persistenceService.writeAsync({ realm in
					realm.delete(play.asPersistent())
				}, {
					resumeOrThrow($0, continuation: continuation)
				})
			}
		}

		@Sendable func update(play: Play) async throws {
			try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
				persistenceService.writeAsync({ realm in
					realm.create(PersistentPlay.self, value: play.asPersistent(), update: .modified)
				}, {
					resumeOrThrow($0, continuation: continuation)
				})
			}
		}

		@Sendable func fetchAll() async -> [Play] {
			await withCheckedContinuation { continuation in
				persistenceService.read { realm in
					let plays = realm.objects(PersistentPlay.self)
					continuation.resume(returning: plays.map { $0.asPlay() })
				}
			}
		}

		@Sendable func fetchOne(id: UUID) async -> Play? {
			await withCheckedContinuation { continuation in
				persistenceService.read { realm in
					let play = realm.objects(PersistentPlay.self)
						.filter("id = %@", id).first

					continuation.resume(returning: play?.asPlay())
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
