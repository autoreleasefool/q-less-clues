import AnalysisFeature
import ComposableArchitecture
import SharedModelsLibrary
import SwiftUI

public struct PlayDetailsView: View {
	let store: StoreOf<PlayDetails>

	struct ViewState: Equatable {
		let playedOn: Date
		let letters: String
		let outcome: Play.Outcome

		init(state: PlayDetails.State) {
			self.playedOn = state.play.createdAt
			self.letters = state.play.letters
			self.outcome = state.play.outcome
		}
	}

	enum ViewAction {
		case deleteButtonTapped
	}

	public init(store: StoreOf<PlayDetails>) {
		self.store = store
	}

	public var body: some View {
		WithViewStore(store, observe: ViewState.init, send: PlayDetails.Action.init) { viewStore in
			List {
				Section {
					Text(viewStore.letters)
					LabeledContent("Outcome", value: "\(viewStore.outcome)")
					LabeledContent("Played", value: viewStore.playedOn.formattedRelative)
				}

				AnalysisView(store: store.scope(state: \.analysis, action: PlayDetails.Action.analysis))

				Section {
					Button("Delete", role: .destructive) { viewStore.send(.deleteButtonTapped) }
						.frame(maxWidth: .infinity)
				}
			}
			.navigationBarTitleDisplayMode(.inline)
			.alert(
				store.scope(state: \.deleteAlert, action: PlayDetails.Action.alert),
				dismiss: .dismissed
			)
		}
	}
}

extension PlayDetails.Action {
	init(action: PlayDetailsView.ViewAction) {
		switch action {
		case .deleteButtonTapped:
			self = .deleteButtonTapped
		}
	}
}
