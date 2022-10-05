import XCTest
@testable import SharedModelsLibrary

final class PositionTests: XCTestCase {
	func testSurrounding() {
		let position = Position(0, 0)
		XCTAssertEqual(Set(position.surrounding), Set([Position(-1, 0), Position(1, 0), Position(0, -1), Position(0, 1)]))
	}
}
