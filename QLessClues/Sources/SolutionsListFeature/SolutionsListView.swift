import ComposableArchitecture
import SharedModelsLibrary
import SwiftUI

public struct SolutionsListView: View {
	let store: StoreOf<SolutionsList>

	struct ViewState: Equatable {
		var solutions: [Solution]
		var filter: String

		var filteredSolutions: [Solution] {
			let filter = self.filter.uppercased()
			return solutions
				.filter { filter.isEmpty || $0.description.contains(filter) }
		}

		init(state: SolutionsList.State) {
			self.solutions = state.solutions
			self.filter = state.solutionsFilter
		}
	}

	enum ViewAction {
		case listSearched(String)
	}

	public init(store: StoreOf<SolutionsList>) {
		self.store = store
	}

	public var body: some View {
		WithViewStore(self.store, observe: ViewState.init, send: SolutionsList.Action.init) { viewStore in
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

extension SolutionsList.Action {
	init(action: SolutionsListView.ViewAction) {
		switch action {
		case let .listSearched(filter):
			self = .listSearched(filter)
		}
	}
}
