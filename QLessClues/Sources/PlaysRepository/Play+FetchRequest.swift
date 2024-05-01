import GRDB
import PlaysRepositoryInterface
import PersistentModelsLibrary
import SharedModelsLibrary

extension Play.FetchRequest {
	func fetchValue(_ db: Database) throws -> [Play] {
		return try Play.all()
			.order(Column("createdAt").desc)
			.fetchAll(db)
	}
}

extension Play.SingleFetchRequest {
	func fetchValue(_ db: Database) throws -> Play? {
		return try Play.fetchOne(db, id: id)
	}
}
