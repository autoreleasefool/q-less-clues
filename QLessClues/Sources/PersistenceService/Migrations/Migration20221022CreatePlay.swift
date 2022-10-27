import GRDB

struct Migration20221022CreatePlay: Migration {
	static func migrate(_ db: Database) throws {
		try db.create(table: "play") { t in
			t.column("id", .text).primaryKey()
			t.column("createdAt", .datetime).notNull()
			t.column("letters", .text).notNull()
			t.column("outcome", .integer).notNull()
			t.column("difficulty", .integer)
		}
	}
}
