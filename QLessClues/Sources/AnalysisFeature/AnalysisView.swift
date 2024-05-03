import ComposableArchitecture
import HintsFeature
import SharedModelsLibrary
import SolutionsListFeature
import SwiftUI

@ViewAction(for: Analysis.self)
public struct AnalysisView: View {
	@Bindable public var store: StoreOf<Analysis>

	public init(store: StoreOf<Analysis>) {
		self.store = store
	}

	public var body: some View {
		Section {
			Button("Analyze") { send(.didTapBeginButton) }
				.frame(maxWidth: .infinity)
				.disabled(store.mode.hasStarted || !store.isPlayable)
		}

		if let store = store.scope(state: \.hints, action: \.internal.hints) {
			HintsView(store: store)
		}

		if store.mode.hasStarted {
			Section("Analysis") {
				ProgressView(value: store.mode.progress)
				// TODO: difficulty view goes here
				NavigationLink {
					SolutionsListView(
						store: store.scope(
							state: \.solutionsList,
							action: \.internal.solutionsList
						)
					)
				} label: {
					LabeledContent("Solutions", value: "\(store.solutions.count)")
				}
			}
		}
	}
}
