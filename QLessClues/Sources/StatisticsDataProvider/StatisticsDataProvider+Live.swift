import Combine
import GRDB
import PersistenceServiceInterface
import PersistentModelsLibrary
import SharedModelsLibrary
import StatisticsDataProviderInterface

extension StatisticsDataProvider {
	public struct Live {
		private let persistenceService: PersistenceService

		public init(persistenceService: PersistenceService) {
			self.persistenceService = persistenceService
		}

		private func calculateStatistics(_ db: Database) throws -> Statistics {
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

		@Sendable func fetch() -> AsyncThrowingStream<Statistics, Error> {
			.init { continuation in
				Task {
					do {
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
//				persistenceService.read {
//					let plays = $0.objects(PersistentPlay.self)
//					let token = plays.observe { _ in
//						continuation.yield(calculateStatistics(for: plays))
//					}
//
//					continuation.onTermination = { _ in
//						token.invalidate()
//					}
//				}
			}
		}
	}
}

extension StatisticsDataProvider {
	public static func live(with statisticsDataProviderLive: Live) -> Self {
		.init(fetch: statisticsDataProviderLive.fetch)
	}
}
