import Foundation
import GRDB
import PersistenceServiceInterface

extension PersistenceService {
	public static let liveValue: Self = {
		let appDb: AppDatabase
		do {
			let fileManager = FileManager.default
			let folderUrl = try fileManager
				.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
				.appending(path: "database", directoryHint: .isDirectory)

			try fileManager.createDirectory(at: folderUrl, withIntermediateDirectories: true)

			let dbUrl = folderUrl.appending(path: "db.sqlite")
			let dbPool = try DatabasePool(path: dbUrl.path())

			appDb = try AppDatabase(dbPool)
		} catch {
			// TODO: should notify user of failure to open DB
			fatalError("Unable to access persistence service, \(error)")
		}

		return Self(
			reader: {
				appDb.dbReader
			},
			write: { block in
				try await block(appDb.dbWriter)
			}
		)
	}()
}

struct AppDatabase {
	let dbWriter: any DatabaseWriter

	var dbReader: DatabaseReader {
		dbWriter
	}

	init(_ dbWriter: any DatabaseWriter) throws {
		self.dbWriter = dbWriter
		try migrator.migrate(dbWriter)
	}

	private var migrator: DatabaseMigrator {
		var migrator = DatabaseMigrator()

		#if DEBUG
		migrator.eraseDatabaseOnSchemaChange = true
		#endif

		migrator.registerMigration(Migration20221022CreatePlay.self)

		return migrator
	}
}
