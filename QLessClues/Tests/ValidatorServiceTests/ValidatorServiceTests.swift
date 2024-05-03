import Dependencies
import DictionaryLibrary
import SharedModelsLibrary
import ValidatorService
import ValidatorServiceInterface
import XCTest

final class ValidatorServiceTests: XCTestCase {
	@Dependency(\.validator) private var validator

	let dictionary = WordSet(letterSet: .fullAlphabet, baseDictionary: ["HIP", "RAT"], baseFrequences: [:])

	func testAcceptsValidSolution() async {
		let solution = Solution(board: [
			Position(0, 0): "R",
			Position(0, 1): "A",
			Position(0, 2): "T",
		])

		let result = await withDependencies {
			$0.validator.validate = ValidatorService.liveValue.validate
		} operation: {
			await self.validator.validate(solution, dictionary)
		}

		XCTAssertTrue(result)
	}

	func testRejectsSolutionWithInvalidWords() async {
		let solution = Solution(board: [
			Position(0, 0): "H",
			Position(0, 1): "I",
		])

		let result = await withDependencies {
			$0.validator.validate = ValidatorService.liveValue.validate
		} operation: {
			await self.validator.validate(solution, dictionary)
		}

		XCTAssertFalse(result)
	}

	func testRejectsSolutionWithDisconnectedWords() async {
		let solution = Solution(board: [
			Position(0, 0): "H",
			Position(0, 1): "I",
			Position(0, 2): "P",
			Position(2, 0): "R",
			Position(2, 1): "A",
			Position(2, 2): "T",
		])

		let result = await withDependencies {
			$0.validator.validate = ValidatorService.liveValue.validate
		} operation: {
			await self.validator.validate(solution, dictionary)
		}

		XCTAssertFalse(result)
	}
}
