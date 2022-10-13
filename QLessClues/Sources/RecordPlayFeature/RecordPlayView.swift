import AnalysisFeature
import ComposableArchitecture
import SharedModelsLibrary
import SwiftUI

public struct RecordPlayView: View {
	let store: Store<RecordPlayState, RecordPlayAction>

	struct ViewState: Equatable {
		let letters: String
		let outcome: Play.Outcome
		let isPlayable: Bool

		init(state: RecordPlayState) {
			self.letters = state.letters
			self.outcome = state.outcome
			self.isPlayable = state.letters.count == 12
		}
	}

	enum ViewAction {
		case saveButtonTapped
		case lettersChanged(String)
		case outcomeChanged(Play.Outcome)
	}

	public init(store: Store<RecordPlayState, RecordPlayAction>) {
		self.store = store
	}

	public var body: some View {
		WithViewStore(store, observe: ViewState.init, send: RecordPlayAction.init) { viewStore in
			List {
				Section("Game") {
					TextField(
						"Letters",
						text: viewStore.binding(get: \.letters, send: ViewAction.lettersChanged)
					)
					Picker(
						"Outcome",
						selection: viewStore.binding(get: \.outcome, send: ViewAction.outcomeChanged)
					) {
						ForEach(Play.Outcome.allCases, id: \.hashValue) {
							Text($0.rawValue).tag($0)
						}
					}
				}

				IfLetStore(store.scope(state: \.analysisState, action: RecordPlayAction.analysis)) {
					AnalysisView(store: $0)
				}
			}
			.navigationTitle("New Play")
			.toolbar {
				ToolbarItem(placement: .navigationBarTrailing) {
					Button("Save") { viewStore.send(.saveButtonTapped) }
						.disabled(!viewStore.isPlayable)
				}
			}
		}
	}
}

extension RecordPlayAction {
	init(action: RecordPlayView.ViewAction) {
		switch action {
		case .saveButtonTapped:
			self = .saveButtonTapped
		case let .lettersChanged(letters):
			self = .lettersChanged(letters)
		case let .outcomeChanged(outcome):
			self = .outcomeChanged(outcome)
		}
	}
}
