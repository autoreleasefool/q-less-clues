import ComposableArchitecture
import SharedModelsLibrary

@Reducer
public struct SolutionsList: Reducer {
	@ObservableState
	public struct State: Equatable {
		public var solutions: [Solution]
		public var solutionsFilter: String = ""

		var filteredSolutions: [Solution] {
			let filter = solutionsFilter.uppercased()
			return solutions
				.filter { filter.isEmpty || $0.description.contains(filter) }
		}

		public init(solutions: [Solution]) {
			self.solutions = solutions
		}
	}

	public enum Action: BindableAction, ViewAction {
		@CasePathable public enum View {
			case didSearchList(String)
		}

		case view(View)
		case binding(BindingAction<State>)
	}

	public init() {}

	public var body: some ReducerOf<Self> {
		BindingReducer()
	}
}
