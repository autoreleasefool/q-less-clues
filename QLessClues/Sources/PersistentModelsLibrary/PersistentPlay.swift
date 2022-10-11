import Foundation
import RealmSwift
import SharedModelsLibrary

public class PersistentPlay: Object, ObjectKeyIdentifiable {
	@Persisted(primaryKey: true) var _id: UUID
	@Persisted var createdAt = Date()
	@Persisted var letters = ""
	@Persisted var outcome: PersistentOutcome = .unsolved
	@Persisted var difficulty: PersistentDifficulty?

	@Persisted(originProperty: "plays") var group: LinkingObjects<PersistentPlayGroup>

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
