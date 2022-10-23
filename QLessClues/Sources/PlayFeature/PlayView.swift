import AnalysisFeature
import ComposableArchitecture
import SharedModelsLibrary
import SwiftUI

public struct PlayView: View {
	let store: Store<PlayState, PlayAction>

	struct ViewState: Equatable {
		let playedOn: Date
		let letters: String
		let outcome: Play.Outcome

		init(state: PlayState) {
			self.playedOn = state.play.createdAt
			self.letters = state.play.letters
			self.outcome = state.play.outcome
		}
	}

	enum ViewAction {
		case deleteButtonTapped
		case onDisappear
	}

	public init(store: Store<PlayState, PlayAction>) {
		self.store = store
	}

	public var body: some View {
		WithViewStore(store, observe: ViewState.init, send: PlayAction.init) { viewStore in
			List {
				Section {
					Text(viewStore.letters)
					LabeledContent("Outcome", value: "\(viewStore.outcome)")
					LabeledContent("Played", value: viewStore.playedOn.formattedRelative)
				}

				AnalysisView(store: store.scope(state: \.analysis, action: PlayAction.analysis))

				Section {
					Button("Delete", role: .destructive) { viewStore.send(.deleteButtonTapped) }
						.frame(maxWidth: .infinity)
				}
			}
			.navigationBarTitleDisplayMode(.inline)
			.onDisappear { viewStore.send(.onDisappear) }
			.alert(
				store.scope(state: \.deleteAlert, action: PlayAction.alert),
				dismiss: .dismissed
			)
		}
	}
}

extension PlayAction {
	init(action: PlayView.ViewAction) {
		switch action {
		case .deleteButtonTapped:
			self = .deleteButtonTapped
		case .onDisappear:
			self = .onDisappear
		}
	}
}
