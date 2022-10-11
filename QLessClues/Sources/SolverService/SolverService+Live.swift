import SharedModelsLibrary
import SolverServiceInterface
import ValidatorServiceInterface
import ValidatorService

extension SolverService {
	public struct Live {
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
}

extension SolverService {
	public static func live(with solverServiceLive: SolverService.Live) -> Self {
		.init(findSolutions: solverServiceLive.findSolutions(letters:))
	}
}
