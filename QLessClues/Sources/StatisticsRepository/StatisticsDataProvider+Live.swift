import Combine
import Dependencies
import GRDB
import PersistenceServiceInterface
import PersistentModelsLibrary
import SharedModelsLibrary
import StatisticsRepositoryInterface

extension StatisticsDataProvider: DependencyKey {
	public static var liveValue = Self(
		fetchCounts: {
			.init { continuation in
				let task = Task {
					func fetchCounts(_ db: Database) throws -> [LetterPlayCount] {
						try "ABCDEFGHIJKLMNOPQRSTUVWXYZ".map {
							let count = try Play.all().filter(Column("letters").like("%\($0)%")).fetchCount(db)
							return .init(letter: String($0), plays: count)
						}
					}

					do {
						@Dependency(\.persistenceService) var persistenceService: PersistenceService
						let db = persistenceService.reader()
						let observation = ValueObservation.tracking(fetchCounts(_:))

						for try await statistics in observation.values(in: db) {
							continuation.yield(statistics)
						}

						continuation.finish()
					} catch {
						continuation.finish(throwing: error)
					}
				}

				continuation.onTermination = { _ in task.cancel() }
			}
		},
		fetch: { request in
			return .init { continuation in
				let task = Task {
					do {
						@Dependency(\.persistenceService) var persistenceService: PersistenceService
						let db = persistenceService.reader()
						let observation = ValueObservation.tracking(request.fetchValue(_:))

						for try await statistics in observation.values(in: db) {
							continuation.yield(statistics)
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
