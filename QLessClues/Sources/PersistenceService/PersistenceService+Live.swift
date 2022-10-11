import PersistenceServiceInterface
import RealmSwift

extension PersistenceService {
	public struct Live {

		private let realm: Realm

		public init() {
			do {
				realm = try Realm()
			} catch {
				fatalError("Failed to open Realm")
			}
		}

		@Sendable func read(_ block: @escaping (Realm) -> Void) {
			block(realm)
		}

		@Sendable func writeAsync(_ block: @escaping (Realm) -> Void, _ onComplete: ((Error?) -> Void)?) {
			realm.writeAsync({
				block(realm)
			}, onComplete: onComplete)
		}
	}
}

extension PersistenceService {
	public static func live(with persistenceServiceLive: Live) -> Self {
		.init(
			read: persistenceServiceLive.read,
			writeAsync: persistenceServiceLive.writeAsync
		)
	}
}
