import ComposableArchitecture
import SharedModelsLibrary

public struct SolutionsList: ReducerProtocol {
	public struct State: Equatable {
		public var solutions: [Solution]
		public var solutionsFilter: String = ""

		public init(solutions: [Solution]) {
			self.solutions = solutions
		}
	}

	public enum Action: Equatable {
		case listSearched(String)
	}

	public init() {}

	public var body: some ReducerProtocol<State, Action> {
		Reduce { state, action in
			switch action {
			case let .listSearched(filter):
				state.solutionsFilter = filter
				return .none
			}
		}
	}
}
