import RealmSwift

public struct PersistenceService: Sendable {
	public var read: @Sendable (@escaping (Realm) -> Void) -> Void
	public var writeAsync: @Sendable (@escaping (Realm) -> Void, ((Error?) -> Void)?) -> Void

	public init(
		read: @escaping @Sendable (@escaping (Realm) -> Void) -> Void,
		writeAsync: @escaping @Sendable (@escaping (Realm) -> Void, ((Error?) -> Void)?) -> Void
	) {
		self.read = read
		self.writeAsync = writeAsync
	}
}
