import SharedModelsLibrary
import XCTest
@testable import ValidatorService

final class BasicValidatorTests: XCTestCase {
	let wordList = ["HIP", "RAT"]

	func testAcceptsValidSolution() {
		let validator = BasicValidator(overridingDictionaryWith: wordList)
		let solution = Solution(board: [
			Position(0, 0): "R",
			Position(0, 1): "A",
			Position(0, 2): "T",
		])

		XCTAssertTrue(validator.validate(solution: solution))
	}

	func testRejectsSolutionWithInvalidWords() {
		let validator = BasicValidator(overridingDictionaryWith: wordList)
		let solution = Solution(board: [
			Position(0, 0): "H",
			Position(0, 1): "I",
		])

		XCTAssertFalse(validator.validate(solution: solution))
	}

	func testRejectsSolutionWithDisconnectedWords() {
		let validator = BasicValidator(overridingDictionaryWith: wordList)
		let solution = Solution(board: [
			Position(0, 0): "H",
			Position(0, 1): "I",
			Position(0, 2): "P",
			Position(2, 0): "R",
			Position(2, 1): "A",
			Position(2, 2): "T",
		])

		XCTAssertFalse(validator.validate(solution: solution))
	}
}
