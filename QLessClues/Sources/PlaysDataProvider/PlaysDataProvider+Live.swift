import Foundation
import PersistenceServiceInterface
import PersistentModelsLibrary
import PlaysDataProviderInterface
import RealmSwift
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

		@Sendable func save(_ play: Play) async throws {
			try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
				persistenceService.write({ realm in
					realm.add(play.asPersistent())
				}, {
					resumeOrThrow($0, continuation: continuation)
				})
			}
		}

		@Sendable func delete(play: Play) async throws {
			try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
				persistenceService.write({ realm in
					realm.delete(play.asPersistent())
				}, {
					resumeOrThrow($0, continuation: continuation)
				})
			}
		}

		@Sendable func update(play: Play) async throws {
			try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
				persistenceService.write({ realm in
					realm.create(PersistentPlay.self, value: play.asPersistent(), update: .modified)
				}, {
					resumeOrThrow($0, continuation: continuation)
				})
			}
		}

		@Sendable func fetchAll() -> AsyncStream<[Play]> {
			.init { continuation in
				persistenceService.read {
					let plays = $0.objects(PersistentPlay.self)
					let token = plays.observe { _ in
						continuation.yield(plays.map { $0.asPlay() })
					}

					continuation.onTermination = { _ in
						token.invalidate()
					}
				}
			}
		}

		@Sendable func fetchOne(id: UUID) -> AsyncStream<Play> {
			.init { continuation in
				persistenceService.read {
					let play = $0.objects(PersistentPlay.self)
						.filter("id = %@", id)
						.first

					var token: NotificationToken?
					if let play {
						token = play.observe { _ in
							continuation.yield(play.asPlay())
						}
					} else {
						continuation.finish()
					}

					continuation.onTermination = { [token = token] _ in
						token?.invalidate()
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
