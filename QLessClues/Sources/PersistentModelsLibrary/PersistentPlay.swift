import Foundation
import RealmSwift
import SharedModelsLibrary

public class PersistentPlay: Object, ObjectKeyIdentifiable {
	@Persisted(primaryKey: true) public var _id: UUID
	@Persisted public var createdAt = Date()
	@Persisted public var letters = ""
	@Persisted public var outcome: PersistentOutcome = .unsolved
	@Persisted public var difficulty: PersistentDifficulty?

	public func asPlay() -> Play {
		.init(
			id: _id,
			createdAt: createdAt,
			letters: letters,
			outcome: outcome.asOutcome(),
			difficulty: difficulty?.asDifficulty()
		)
	}
}

extension Play {
	public func asPersistent() -> PersistentPlay {
		let play = PersistentPlay()
		play._id = self.id
		play.createdAt = self.createdAt
		play.letters = self.letters
		play.outcome = self.outcome.asPersistent()
		play.difficulty = self.difficulty?.asPersistent()
		return play
	}
}
