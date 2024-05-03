import AnalysisFeature
import ComposableArchitecture
import SharedModelsLibrary
import SwiftUI

@ViewAction(for: PlayDetails.self)
public struct PlayDetailsView: View {
	@Bindable public var store: StoreOf<PlayDetails>

	public init(store: StoreOf<PlayDetails>) {
		self.store = store
	}

	public var body: some View {
		List {
			Section {
				Text(store.play.letters)
				LabeledContent("Outcome", value: "\(store.play.outcome)")
				LabeledContent("Played", value: store.play.createdAt.formattedRelative)
			}

			AnalysisView(store: store.scope(state: \.analysis, action: \.internal.analysis))

			Section {
				Button("Delete", role: .destructive) { send(.didTapDeleteButton) }
					.frame(maxWidth: .infinity)
			}
		}
		.navigationBarTitleDisplayMode(.inline)
		.alert($store.scope(state: \.alert, action: \.internal.alert))
	}
}
