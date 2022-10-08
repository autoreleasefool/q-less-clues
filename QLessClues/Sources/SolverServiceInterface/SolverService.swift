import Combine
import SharedModelsLibrary
import ValidatorServiceInterface

public struct SolverService: Sendable {
	public var findSolutions: @Sendable (String, ValidatorService) -> AsyncStream<Event>

	public init(findSolutions: @escaping @Sendable (String, ValidatorService) -> AsyncStream<Event>) {
		self.findSolutions = findSolutions
	}

	public enum Event: Equatable {
		case solution(Solution)
		case progress(Double)
	}
}
