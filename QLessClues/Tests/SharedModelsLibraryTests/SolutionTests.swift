import XCTest
import SharedModelsLibrary
import SharedModelsLibraryMocks

final class SolutionTests: XCTestCase {
	func testCharacterAtIsCorrect() {
		XCTAssertEqual(Solution.mock.characterAt(row: 0, column: 0), "R")
		XCTAssertEqual(Solution.mock.characterAt(row: 0, column: 1), "A")
		XCTAssertEqual(Solution.mock.characterAt(row: 0, column: 2), "T")
		XCTAssertEqual(Solution.mock.characterAt(row: 0, column: 3), " ")
	}

	func testLetterPositionsIsCorrect() {
		XCTAssertEqual(Solution.mock.letterPositions.count, 3)
		XCTAssertEqual(Solution.mock.letterPositions[Position(0, 0)], "R")
		XCTAssertEqual(Solution.mock.letterPositions[Position(0, 1)], "A")
		XCTAssertEqual(Solution.mock.letterPositions[Position(0, 2)], "T")
	}

	func testRowsIsCorrect() {
		XCTAssertEqual(Solution.mock.rows, 0...0)
	}

	func testColumnsIsCorrect() {
		XCTAssertEqual(Solution.mock.columns, 0...2)
	}

	func testWordsIsCorrect() {
		XCTAssertEqual(Solution.mock.words, ["RAT"])
	}

	func testLettersIsCorrect() {
		XCTAssertEqual(Solution.mock.letters, "ART")
	}
}
