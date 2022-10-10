import SharedModelsLibrary
import SolverServiceInterface
import ValidatorServiceInterface
import ValidatorServiceLive

public struct SolverServiceLive {
	private let validatorService: ValidatorService

	public init(validatorService: ValidatorService) {
		self.validatorService = validatorService
	}

	@Sendable public func findSolutions(letters: String) -> AsyncStream<SolverService.Event> {
		.init { continutation in
			Task {
				await BacktrackingSolver(validator: validatorService)
					.findSolutions(forLetters: letters, to: continutation)
			}
		}
	}
}

extension SolverService {
	public static func live(solverServiceLive: SolverServiceLive) -> Self {
		.init(findSolutions: solverServiceLive.findSolutions(letters:))
	}
}
