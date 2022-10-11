import DictionaryLibrary
import SharedModelsLibrary
import XCTest
import ValidatorService
import ValidatorServiceInterface

final class ValidatorServiceTests: XCTestCase {
	let dictionary = WordSet(letterSet: .fullAlphabet, baseDictionary: ["HIP", "RAT"])

	func testAcceptsValidSolution() async {
		let validator: ValidatorService = .live
		let solution = Solution(board: [
			Position(0, 0): "R",
			Position(0, 1): "A",
			Position(0, 2): "T",
		])

		let result = await validator.validate(solution, dictionary)
		XCTAssertTrue(result)
	}

	func testRejectsSolutionWithInvalidWords() async {
		let validator: ValidatorService = .live
		let solution = Solution(board: [
			Position(0, 0): "H",
			Position(0, 1): "I",
		])

		let result = await validator.validate(solution, dictionary)
		XCTAssertFalse(result)
	}

	func testRejectsSolutionWithDisconnectedWords() async {
		let validator: ValidatorService = .live
		let solution = Solution(board: [
			Position(0, 0): "H",
			Position(0, 1): "I",
			Position(0, 2): "P",
			Position(2, 0): "R",
			Position(2, 1): "A",
			Position(2, 2): "T",
		])

		let result = await validator.validate(solution, dictionary)
		XCTAssertFalse(result)
	}
}
