import Combine
import Dependencies
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

extension SolverService: TestDependencyKey {
	public static var testValue = Self(
		findSolutions: { _ in fatalError("\(Self.self).findSolutions") }
	)
}

extension DependencyValues {
	public var solverService: SolverService {
		get { self[SolverService.self] }
		set { self[SolverService.self] = newValue }
	}
}
