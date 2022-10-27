import Dependencies
import SharedModelsLibrary
import SolverServiceInterface
import ValidatorServiceInterface

extension SolverService: DependencyKey {
	public static let liveValue = Self(
		findSolutions: { letters in
			@Dependency(\.validatorService) var validatorService: ValidatorService

			return .init { continuation in
				let task = Task(priority: .background) {
					continuation.yield(.progress(0.1))
					await BacktrackingSolver(validator: validatorService)
						.findSolutions(forLetters: letters, to: continuation)
				}

				continuation.onTermination = { _ in task.cancel() }
			}
		}
	)
}
