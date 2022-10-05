import Combine
import XCTest
@testable import NetworkingService

final class CancelBagTests: XCTestCase {
	func testStoresSubscriptions() {
		let cancellable = CancelBag()

		Just(())
			.eraseToAnyPublisher()
			.sink { _ in }
			.store(in: cancellable)

		XCTAssertEqual(cancellable.subscriptions.count, 1)
	}

	func testCancelsSubscriptions() {
		let cancellable = CancelBag()
		Just(())
			.eraseToAnyPublisher()
			.sink { _ in }
			.store(in: cancellable)
		cancellable.cancel()

		XCTAssertEqual(cancellable.subscriptions.count, 0)
	}
}
