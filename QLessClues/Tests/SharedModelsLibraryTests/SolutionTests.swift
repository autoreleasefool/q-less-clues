import XCTest
@testable import SharedModelsLibrary

final class SolutionTests: XCTestCase {

	let mockSolution = Solution(board: [
		Position(0, 0): "R",
		Position(0, 1): "A",
		Position(0, 2): "T",
	])

	func testCharacterAtIsCorrect() {
		XCTAssertEqual(mockSolution.characterAt(row: 0, column: 0), "R")
		XCTAssertEqual(mockSolution.characterAt(row: 0, column: 1), "A")
		XCTAssertEqual(mockSolution.characterAt(row: 0, column: 2), "T")
		XCTAssertEqual(mockSolution.characterAt(row: 0, column: 3), " ")
	}

	func testLetterPositionsIsCorrect() {
		XCTAssertEqual(mockSolution.letterPositions.count, 3)
		XCTAssertEqual(mockSolution.letterPositions[Position(0, 0)], "R")
		XCTAssertEqual(mockSolution.letterPositions[Position(0, 1)], "A")
		XCTAssertEqual(mockSolution.letterPositions[Position(0, 2)], "T")
	}

	func testRowsIsCorrect() {
		XCTAssertEqual(mockSolution.rows, 0...0)
	}

	func testColumnsIsCorrect() {
		XCTAssertEqual(mockSolution.columns, 0...2)
	}

	func testWordsIsCorrect() {
		XCTAssertEqual(mockSolution.words, ["RAT"])
	}

	func testLettersIsCorrect() {
		XCTAssertEqual(mockSolution.letters, "ART")
	}
}
