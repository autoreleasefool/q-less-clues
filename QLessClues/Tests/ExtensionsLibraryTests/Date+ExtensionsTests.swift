import XCTest
@testable import ExtensionsLibrary

final class DateExtensionsTests: XCTestCase {
	func testFormattedRelative() {
		XCTAssertEqual(Date().formattedRelative, "Today")
		XCTAssertEqual(Date().addingTimeInterval(-86_400).formattedRelative, "Yesterday")
	}
}
