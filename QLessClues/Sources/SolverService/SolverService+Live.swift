import Dependencies
import SharedModelsLibrary
import SolverServiceInterface
import ValidatorServiceInterface

extension SolverService: DependencyKey {
	public static let liveValue = Self(
		findSolutions: { letters in
			.init {continuation in
				Task {
					@Dependency(\.validatorService) var validatorService: ValidatorService
					await BacktrackingSolver(validator: validatorService)
						.findSolutions(forLetters: letters, to: continuation)
				}
			}
		}
	)
}
