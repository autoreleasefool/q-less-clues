import SolverService
import XCTest
@testable import SolverServiceInterface
@testable import ValidatorServiceInterface

final class SolverServiceTests: XCTestCase {
	func testsReturnsAllSolutions() async {
		let validator = ValidatorService { _, _ in true }
		let solver: SolverService = .live(with: .init(validatorService: validator))

		let possibleSolutions = Set([
			["ART"],
			["RAT"],
			["TAR"],
		])

		for await event in solver.findSolutions("ART") {
			switch event {
			case .progress:
				break
			case let .solution(solution):
				XCTAssertTrue(possibleSolutions.contains(solution.words))
			}
		}
	}
}
