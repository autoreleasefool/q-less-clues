import Dependencies
import GRDB
import PersistenceServiceInterface
import PersistentModelsLibrary
import SharedModelsLibrary

extension PlaysPersistenceService: DependencyKey {
	public static var liveValue = Self(
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
