import Dependencies
import DictionaryServiceInterface
import SolverService
@testable import SolverServiceInterface
@testable import ValidatorServiceInterface
import XCTest

final class SolverServiceTests: XCTestCase {
	@Dependency(\.solver) private var solver

	func testsReturnsAllSolutions() async {
		let solutions = withDependencies {
			$0.dictionary.englishWords = { [] }
			$0.dictionary.englishFrequencies = { [:] }
			$0.validator.validate = { _, _ in true }
			$0.solver.findSolutions = SolverService.liveValue.findSolutions
		} operation: {
			self.solver.findSolutions("ART")
		}

		let possibleSolutions = Set([
			["ART"],
			["RAT"],
			["TAR"],
		])

		let expectation = self.expectation(description: "did receive solutions")

		var iterator = solutions.makeAsyncIterator()
		while let event = await iterator.next() {
			switch event {
			case .progress:
				break
			case let .solution(solution):
				XCTAssertTrue(possibleSolutions.contains(solution.words))
				expectation.fulfill()
			}
		}

		await fulfillment(of: [expectation])
	}
}
