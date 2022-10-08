import ComposableArchitecture
import SwiftUI

public struct HintsView: View {
	let store: Store<HintsState, HintsAction>

	struct ViewState: Equatable {
		var hints: [String]
		var hasMoreHints: Bool

		init(state: HintsState) {
			self.hints = state.hints
			self.hasMoreHints = state.hasMoreHints
		}
	}

	enum ViewAction: Equatable {
		case hintButtonTapped
	}

	public init(store: Store<HintsState, HintsAction>) {
		self.store = store
	}

	public var body: some View {
		WithViewStore(store, observe: ViewState.init, send: HintsAction.init) { viewStore in
			Section {
				ForEach(viewStore.hints, id: \.self) {
					Text($0)
				}

				if viewStore.hasMoreHints {
					Button("New Hint") { viewStore.send(.hintButtonTapped) }
				}
			} header: {
				Text("Hints")
			} footer: {
				Text(
					"Each hint is a word that appears in one potential solution. " +
					"You can request additional hints, until there's only word unrevealed word remaining in the solution. " +
					"Then, it's up to you."
				)
			}
		}
	}
}

extension HintsAction {
	init(action: HintsView.ViewAction) {
		switch action {
		case .hintButtonTapped:
			self = .hintButtonTapped
		}
	}
}
