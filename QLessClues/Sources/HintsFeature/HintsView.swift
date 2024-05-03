import ComposableArchitecture
import SwiftUI

@ViewAction(for: Hints.self)
public struct HintsView: View {
	public var store: StoreOf<Hints>

	public init(store: StoreOf<Hints>) {
		self.store = store
	}

	public var body: some View {
		Section {
			ForEach(store.hints, id: \.self) {
				Text($0)
			}

			if store.hasMoreHints {
				Button("New Hint") { send(.didTapHintButton) }
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
