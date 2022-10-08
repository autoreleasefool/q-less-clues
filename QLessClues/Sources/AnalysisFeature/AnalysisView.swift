import ComposableArchitecture
import HintsFeature
import SharedModelsLibrary
import SolutionsListFeature
import SwiftUI

public struct AnalysisView: View {
	let store: Store<AnalysisState, AnalysisAction>

	struct ViewState: Equatable {
		var solutions: [Solution]
		var difficulty: Difficulty?
		var progress: Double
		var hasStarted: Bool

		init(state: AnalysisState) {
			self.solutions = state.solutions
			self.difficulty = state.difficulty
			self.progress = state.mode.progress
			self.hasStarted = !state.mode.hasStarted
		}
	}

	enum ViewAction {
		case beginButtonTapped
	}

	public init(store: Store<AnalysisState, AnalysisAction>) {
		self.store = store
	}

	public var body: some View {
		WithViewStore(store, observe: ViewState.init, send: AnalysisAction.init) { viewStore in
			Section {
				Button("Analyze") { viewStore.send(.beginButtonTapped) }
					.frame(maxWidth: .infinity)
					.disabled(!viewStore.hasStarted)
			}

			IfLetStore(store.scope(state: \.hints, action: AnalysisAction.hints)) {
				HintsView(store: $0)
			}

			if viewStore.hasStarted {
				Section("Analysis") {
					ProgressView(value: viewStore.progress)
					// TODO: difficulty view goes here
					NavigationLink {
						SolutionsList(
							store: store.scope(
								state: \.solutionsList,
								action: AnalysisAction.solutionsList
							)
						)
					} label: {
						LabeledContent("Solutions", value: "\(viewStore.solutions.count)")
					}
				}
			}
		}
	}
}

extension AnalysisAction {
	init(action: AnalysisView.ViewAction) {
		switch action {
		case .beginButtonTapped:
			self = .beginButtonTapped
		}
	}
}
