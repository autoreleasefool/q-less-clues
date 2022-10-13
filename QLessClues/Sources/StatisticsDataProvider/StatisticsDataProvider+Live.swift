import Combine
import PersistenceServiceInterface
import PersistentModelsLibrary
import RealmSwift
import SharedModelsLibrary
import StatisticsDataProviderInterface

extension StatisticsDataProvider {
	public struct Live {
		private let persistenceService: PersistenceService

		public init(persistenceService: PersistenceService) {
			self.persistenceService = persistenceService
		}

		private func calculateStatistics(for plays: Results<PersistentPlay>) -> Statistics {
			let pureWins = plays.where { $0.outcome.equals(.solved) }.count
			let winsWithHints = plays.where { $0.outcome.equals(.solvedWithHints) }.count
			let losses = plays.where { $0.outcome.equals(.unsolved) }.count
			return .init(pureWins: pureWins, winsWithHints: winsWithHints, losses: losses)
		}

		@Sendable func fetch() -> AsyncStream<Statistics> {
			.init { continuation in
				persistenceService.read {
					let plays = $0.objects(PersistentPlay.self)
					let token = plays.observe { _ in
						continuation.yield(calculateStatistics(for: plays))
					}

					continuation.onTermination = { _ in
						token.invalidate()
					}
				}
			}
		}
	}
}

extension StatisticsDataProvider {
	public static func live(with statisticsDataProviderLive: Live) -> Self {
		.init(fetch: statisticsDataProviderLive.fetch)
	}
}
