import ComposableArchitecture
import HintsFeature
import SharedModelsLibrary
import SolutionsListFeature
import SwiftUI

public struct AnalysisView: View {
	let store: StoreOf<Analysis>

	struct ViewState: Equatable {
		let solutions: [Solution]
		let difficulty: Play.Difficulty?
		let progress: Double
		let hasStarted: Bool
		let isPlayable: Bool

		init(state: Analysis.State) {
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

	public init(store: StoreOf<Analysis>) {
		self.store = store
	}

	public var body: some View {
		WithViewStore(store, observe: ViewState.init, send: Analysis.Action.init) { viewStore in
			Section {
				Button("Analyze") { viewStore.send(.beginButtonTapped) }
					.frame(maxWidth: .infinity)
					.disabled(viewStore.hasStarted || !viewStore.isPlayable)
			}
			.onDisappear { viewStore.send(.onDisappear) }

			IfLetStore(store.scope(state: \.hints, action: Analysis.Action.hints)) {
				HintsView(store: $0)
			}

			if viewStore.hasStarted {
				Section("Analysis") {
					ProgressView(value: viewStore.progress)
					// TODO: difficulty view goes here
					NavigationLink {
						SolutionsListView(
							store: store.scope(
								state: \.solutionsList,
								action: Analysis.Action.solutionsList
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

extension Analysis.Action {
	init(action: AnalysisView.ViewAction) {
		switch action {
		case .beginButtonTapped:
			self = .beginButtonTapped
		case .onDisappear:
			self = .onDisappear
		}
	}
}
