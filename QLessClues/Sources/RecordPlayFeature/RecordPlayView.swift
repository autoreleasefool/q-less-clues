import AnalysisFeature
import ComposableArchitecture
import Foundation
import SharedModelsLibrary
import SwiftUI

@ViewAction(for: RecordPlay.self)
public struct RecordPlayView: View {
	@Bindable public var store: StoreOf<RecordPlay>

	public init(store: StoreOf<RecordPlay>) {
		self.store = store
	}

	public var body: some View {
		List {
			Section("Game") {
				TextField(
					"Letters",
					text: $store.letters
				)
				DatePicker(
					"Played On",
					selection: $store.date,
					displayedComponents: [.date]
				)
				Picker(
					"Outcome",
					selection: $store.outcome
				) {
					ForEach(Play.Outcome.allCases) {
						Text($0.description).tag($0)
					}
				}
			}

			AnalysisView(store: store.scope(state: \.analysis, action: \.internal.analysis))
		}
		.navigationTitle("New Play")
		.toolbar {
			ToolbarItem(placement: .navigationBarTrailing) {
				Button("Save") { send(.didTapSaveButton) }
					.disabled(!store.isPlayable)
			}
		}
	}
}
