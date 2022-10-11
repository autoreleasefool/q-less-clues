import Combine
import SharedModelsLibrary

public struct SolverService: Sendable {
	public var findSolutions: @Sendable (String) -> AsyncStream<Event>

	public init(findSolutions: @escaping @Sendable (String) -> AsyncStream<Event>) {
		self.findSolutions = findSolutions
	}

	public enum Event: Equatable {
		case solution(Solution)
		case progress(Double)
	}
}
