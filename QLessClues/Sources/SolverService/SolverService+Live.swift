import Dependencies
import SharedModelsLibrary
import SolverServiceInterface
import ValidatorServiceInterface

extension SolverService: DependencyKey {
	public static var liveValue = Self(
		findSolutions: { letters in
			return .init { continuation in
				let task = Task(priority: .background) {
					continuation.yield(.progress(0.1))
					try? await BacktrackingSolver()
						.findSolutions(forLetters: letters, to: continuation)
				}

				continuation.onTermination = { _ in task.cancel() }
			}
		}
	)
}
