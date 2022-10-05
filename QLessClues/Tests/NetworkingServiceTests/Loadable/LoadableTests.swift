import XCTest
@testable import NetworkingService

enum MockError: Error {
	case mock
}

final class LoadableTests: XCTestCase {
	func testIsLoadingRetainsValue() {
		var loadable: Loadable<String> = .loaded("value")
		loadable.setIsLoading(cancelBag: CancelBag())

		if case let .isLoading(value, _) = loadable {
			XCTAssertEqual(value, "value")
		} else {
			XCTFail("Loadable is not loading")
		}
	}

	func testValueIsCorrect() {
		let notRequested: Loadable<String> = .notRequested
		XCTAssertNil(notRequested.value)

		let loadingWithValue: Loadable<String> = .isLoading(last: "value", cancelBag: CancelBag())
		XCTAssertEqual(loadingWithValue.value, "value")

		let loadingWithoutValue: Loadable<String> = .isLoading(last: nil, cancelBag: CancelBag())
		XCTAssertNil(loadingWithoutValue.value)

		let loaded: Loadable<String> = .loaded("value")
		XCTAssertEqual(loaded.value, "value")

		let failed: Loadable<String> = .failed(MockError.mock)
		XCTAssertNil(failed.value)
	}

	func testErrorIsCorrect() {
		let notRequested: Loadable<String> = .notRequested
		XCTAssertNil(notRequested.error)

		let loadingWithValue: Loadable<String> = .isLoading(last: "value", cancelBag: CancelBag())
		XCTAssertNil(loadingWithValue.error)

		let loadingWithoutValue: Loadable<String> = .isLoading(last: nil, cancelBag: CancelBag())
		XCTAssertNil(loadingWithoutValue.error)

		let loaded: Loadable<String> = .loaded("value")
		XCTAssertNil(loaded.error)

		let failed: Loadable<String> = .failed(MockError.mock)
		XCTAssertNotNil(failed.error)
	}
}
