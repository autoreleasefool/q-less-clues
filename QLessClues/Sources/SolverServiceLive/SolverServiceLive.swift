import SharedModelsLibrary
import SolverServiceInterface
import ValidatorServiceLive

extension SolverService {
	public static let live = Self(
		findSolutions: { letters, validator in
			.init { continuation in
				Task {
					await BacktrackingSolver(validator: validator)
						.findSolutions(forLetters: letters, to: continuation)
				}
			}
		}
	)
}
