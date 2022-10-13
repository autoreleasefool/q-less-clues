import Foundation
import PersistenceServiceInterface
import RealmSwift

extension PersistenceService {
	public class Live {

		private var realm: Realm!
		private let queue: DispatchQueue

		public init(queue: DispatchQueue = .init(label: "PersistenceService")) {
			self.queue = queue
			queue.sync {
				do {
					self.realm = try Realm(queue: queue)
				} catch {
					fatalError("Failed to open Realm")
				}
			}
		}

		@Sendable func read(_ block: (Realm) -> Void) {
			queue.sync {
				block(self.realm)
			}
		}

		@Sendable func write(_ block: @escaping (Realm) -> Void, _ onComplete: ((Error?) -> Void)?) {
			realm.writeAsync({
				block(self.realm)
			}, onComplete: onComplete)
		}
	}
}

extension PersistenceService {
	public static func live(with persistenceServiceLive: Live) -> Self {
		.init(
			read: persistenceServiceLive.read,
			write: persistenceServiceLive.write
		)
	}
}
