import ComposableArchitecture
import SharedModelsLibrary
import SwiftUI

public struct SolutionsList: View {
	let store: Store<SolutionsListState, SolutionsListAction>

	struct ViewState: Equatable {
		var solutions: [Solution]
		var filter: String

		var filteredSolutions: [Solution] {
			let filter = self.filter.uppercased()
			return solutions
				.filter { filter.isEmpty || $0.description.contains(filter) }
		}

		init(state: SolutionsListState) {
			self.solutions = state.solutions
			self.filter = state.solutionsFilter
		}
	}

	enum ViewAction {
		case listSearched(String)
	}

	public init(store: Store<SolutionsListState, SolutionsListAction>) {
		self.store = store
	}

	public var body: some View {
		WithViewStore(self.store, observe: ViewState.init, send: SolutionsListAction.init) { viewStore in
			List {
				if viewStore.solutions.isEmpty {
					Text("No solutions have been found yet.")
				} else {
					ForEach(viewStore.filteredSolutions, id: \.id) { solution in
						NavigationLink {
							SolutionDetailsView(solution: solution)
						} label: {
							Text(solution.description)
						}
					}
					.searchable(text: viewStore.binding(get: \.filter, send: ViewAction.listSearched))
				}
			}
			.navigationTitle("Solutions")
		}
	}
}

// MARK: - ViewAction

extension SolutionsListAction {
	init(action: SolutionsList.ViewAction) {
		switch action {
		case let .listSearched(filter):
			self = .listSearched(filter)
		}
	}
}
