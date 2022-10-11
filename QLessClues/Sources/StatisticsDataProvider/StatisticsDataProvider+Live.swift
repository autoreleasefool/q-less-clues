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

		@Sendable func fetch() async -> Statistics {
			await withCheckedContinuation { continuation in
				persistenceService.read { realm in
					let plays = realm.objects(PersistentPlay.self)

					let pureWins = plays.where { $0.outcome.equals(.solved) }.count
					let winsWithHints = plays.where { $0.outcome.equals(.solvedWithHints) }.count
					let losses = plays.where { $0.outcome.equals(.unsolved) }.count

					continuation.resume(returning: .init(
						pureWins: pureWins,
						winsWithHints: winsWithHints,
						losses: losses
					))
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
