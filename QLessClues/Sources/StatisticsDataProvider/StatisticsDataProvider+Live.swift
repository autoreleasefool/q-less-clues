import Combine
import Dependencies
import GRDB
import PersistenceServiceInterface
import PersistentModelsLibrary
import SharedModelsLibrary
import StatisticsDataProviderInterface

extension StatisticsDataProvider: DependencyKey {
	public static let liveValue = Self(
		fetch: {
			return .init { continuation in
				@Sendable func calculateStatistics(_ db: Database) throws -> Statistics {
					let outcome = Column("outcome")
					let pureWins = try Play
						.filter(outcome == Play.Outcome.solved.rawValue)
						.fetchCount(db)
					let winsWithHints = try Play
						.filter(outcome == Play.Outcome.solvedWithHints.rawValue)
						.fetchCount(db)
					let losses = try Play
						.filter(outcome == Play.Outcome.unsolved.rawValue)
						.fetchCount(db)

					return .init(pureWins: pureWins, winsWithHints: winsWithHints, losses: losses)
				}

				Task {
					do {
						@Dependency(\.persistenceService) var persistenceService: PersistenceService
						let db = persistenceService.reader()
						let observation = ValueObservation.tracking(calculateStatistics(_:))

						for try await statistics in observation.values(in: db) {
							continuation.yield(statistics)
						}

						continuation.finish()
					} catch {
						continuation.finish(throwing: error)
					}
				}
			}
		}
	)
}
