import ComposableArchitecture
import SharedModelsLibrary

public struct SolutionsListState: Equatable {
	public var solutions: [Solution]
	public var solutionsFilter: String = ""

	public init(solutions: [Solution]) {
		self.solutions = solutions
	}
}

public enum SolutionsListAction: Equatable {
	case listSearched(String)
}

public struct SolutionsListEnvironment {
	public init() {}
}

public let solutionsListReducer =
	Reducer<SolutionsListState, SolutionsListAction, SolutionsListEnvironment> { state, action, _ in
		switch action {
		case let .listSearched(filter):
			state.solutionsFilter = filter
			return .none
		}
	}
