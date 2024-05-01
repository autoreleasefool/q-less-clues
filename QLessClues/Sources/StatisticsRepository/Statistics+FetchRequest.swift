import GRDB
import SharedModelsLibrary
import StatisticsRepositoryInterface

extension Statistics.FetchRequest {
	func fetchValue(_ db: Database) throws -> Statistics {
		let query: QueryInterfaceRequest<Play>
		if let letter {
			query = Play.all().filter(Column("letters").like("%\(letter)%"))
		} else {
			query = Play.all()
		}

		let outcome = Column("outcome")

		let pureWins = try query
			.filter(outcome == Play.Outcome.solved.rawValue)
			.fetchCount(db)
		let winsWithHints = try query
			.filter(outcome == Play.Outcome.solvedWithHints.rawValue)
			.fetchCount(db)
		let losses = try query
			.filter(outcome == Play.Outcome.unsolved.rawValue)
			.fetchCount(db)

		return .init(pureWins: pureWins, winsWithHints: winsWithHints, losses: losses)
	}
}
