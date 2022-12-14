import AnalysisFeature
import ComposableArchitecture
import Foundation
import SharedModelsLibrary
import SwiftUI

public struct RecordPlayView: View {
	let store: StoreOf<RecordPlay>

	struct ViewState: Equatable {
		let letters: String
		let date: Date
		let outcome: Play.Outcome
		let isPlayable: Bool

		init(state: RecordPlay.State) {
			self.letters = state.letters
			self.outcome = state.outcome
			self.date = state.date
			self.isPlayable = state.letters.count == 12
		}
	}

	enum ViewAction {
		case saveButtonTapped
		case lettersChanged(String)
		case dateChanged(Date)
		case outcomeChanged(Play.Outcome)
	}

	public init(store: StoreOf<RecordPlay>) {
		self.store = store
	}

	public var body: some View {
		WithViewStore(store, observe: ViewState.init, send: RecordPlay.Action.init) { viewStore in
			List {
				Section("Game") {
					TextField(
						"Letters",
						text: viewStore.binding(get: \.letters, send: ViewAction.lettersChanged)
					)
					DatePicker(
						"Played On",
						selection: viewStore.binding(get: \.date, send: ViewAction.dateChanged),
						displayedComponents: [.date]
					)
					Picker(
						"Outcome",
						selection: viewStore.binding(get: \.outcome, send: ViewAction.outcomeChanged)
					) {
						ForEach(Play.Outcome.allCases) {
							Text($0.description).tag($0)
						}
					}
				}

				AnalysisView(store: store.scope(state: \.analysis, action: RecordPlay.Action.analysis))
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

extension RecordPlay.Action {
	init(action: RecordPlayView.ViewAction) {
		switch action {
		case .saveButtonTapped:
			self = .saveButtonTapped
		case let .lettersChanged(letters):
			self = .lettersChanged(letters)
		case let .outcomeChanged(outcome):
			self = .outcomeChanged(outcome)
		case let .dateChanged(date):
			self = .dateChanged(date)
		}
	}
}
