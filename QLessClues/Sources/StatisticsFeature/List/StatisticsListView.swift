import ComposableArchitecture
import SharedModelsLibrary
import SwiftUI
import ViewsLibrary

@ViewAction(for: StatisticsList.self)
public struct StatisticsListView: View {
	@Bindable public var store: StoreOf<StatisticsList>

	public init(store: StoreOf<StatisticsList>) {
		self.store = store
	}

	public var body: some View {
		List(store.gamesPlayed) { letter in
			Button {
				send(.didTapGame(letter.id))
			} label: {
				LabeledContent(letter.letter, value: "\(letter.plays)")
			}
			.buttonStyle(.navigation)
		}
		.navigationTitle("Statistics by Letter")
		.navigationDestination(
			item: $store.scope(state: \.destination?.details, action: \.internal.destination.details)
		) {
			DetailedStatisticsView(store: $0)
		}
		.task { await send(.task).finish() }
	}
}
