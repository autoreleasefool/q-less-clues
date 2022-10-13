import ComposableArchitecture
import HintsFeature
import SharedModelsLibrary
import SolutionsListFeature
import SwiftUI

public struct AnalysisView: View {
	let store: Store<AnalysisState, AnalysisAction>

	struct ViewState: Equatable {
		let solutions: [Solution]
		let difficulty: Play.Difficulty?
		let progress: Double
		let hasStarted: Bool
		let isPlayable: Bool

		init(state: AnalysisState) {
			self.solutions = state.solutions
			self.difficulty = state.difficulty
			self.progress = state.mode.progress
			self.hasStarted = state.mode.hasStarted
			self.isPlayable = state.isPlayable
		}
	}

	enum ViewAction {
		case beginButtonTapped
		case onDisappear
	}

	public init(store: Store<AnalysisState, AnalysisAction>) {
		self.store = store
	}

	public var body: some View {
		WithViewStore(store, observe: ViewState.init, send: AnalysisAction.init) { viewStore in
			Section {
				Button("Analyze") { viewStore.send(.beginButtonTapped) }
					.frame(maxWidth: .infinity)
					.disabled(viewStore.hasStarted || !viewStore.isPlayable)
			}
			.onDisappear { viewStore.send(.onDisappear) }

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
		case .onDisappear:
			self = .onDisappear
		}
	}
}
