import ComposableArchitecture
import SharedModelsLibrary
import SwiftUI

@ViewAction(for: SolutionsList.self)
public struct SolutionsListView: View {
	@Bindable public var store: StoreOf<SolutionsList>

	public init(store: StoreOf<SolutionsList>) {
		self.store = store
	}

	public var body: some View {
		List {
			if store.solutions.isEmpty {
				Text("No solutions have been found yet.")
			} else {
				ForEach(store.filteredSolutions) { solution in
					NavigationLink {
						SolutionDetailsView(solution: solution)
					} label: {
						Text(solution.description)
					}
				}
			}
		}
		.searchable(text: $store.solutionsFilter)
		.navigationTitle("Solutions")
	}
}
