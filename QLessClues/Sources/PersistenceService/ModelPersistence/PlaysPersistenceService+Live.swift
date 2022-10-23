import Dependencies
import GRDB
import PersistentModelsLibrary
import PersistenceServiceInterface
import SharedModelsLibrary

extension PlaysPersistenceService: DependencyKey {
	public static let liveValue = Self(
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
