import RealmSwift

public class PersistentPlayGroup: Object, ObjectKeyIdentifiable {
	@Persisted(primaryKey: true) var _id: ObjectId
	@Persisted var plays = RealmSwift.List<PersistentPlay>()
}
