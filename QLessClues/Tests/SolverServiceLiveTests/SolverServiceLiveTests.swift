import SolverServiceLive
import XCTest
@testable import SolverServiceInterface
@testable import ValidatorServiceInterface

final class SolverServiceLiveTests: XCTestCase {
	func testsReturnsAllSolutions() async {
		let solver: SolverService = .live

		var validator = ValidatorService { _, _ in true }

		let possibleSolutions = Set([
			["ART"],
			["RAT"],
			["TAR"],
		])

		for await event in solver.findSolutions("ART", validator) {
			switch event {
			case .progress:
				break
			case let .solution(solution):
				XCTAssertTrue(possibleSolutions.contains(solution.words))
			}
		}
	}
}
