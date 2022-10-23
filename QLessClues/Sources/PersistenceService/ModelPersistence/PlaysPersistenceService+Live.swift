import GRDB
import PersistentModelsLibrary
import PersistenceServiceInterface
import SharedModelsLibrary

extension PlaysPersistenceService {
	public static let live = Self(
		create: { play, db in
			try play.insert(db)
		},
		update: { play, db in
			try play.update(db)
		},
		delete: { play, db in
			try play.delete(db)
		}
	)
}
