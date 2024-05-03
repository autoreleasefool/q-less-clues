import ComposableArchitecture
import PlayDetailsFeature
import RecordPlayFeature
import SharedModelsLibrary
import StatisticsFeature
import SwiftUI
import ViewsLibrary

@ViewAction(for: PlaysList.self)
public struct PlaysListView: View {
	@Bindable public var store: StoreOf<PlaysList>

	public init(store: StoreOf<PlaysList>) {
		self.store = store
	}

	public var body: some View {
		List {
			if let statistics = store.statistics {
				StatisticsOverview(statistics: statistics)
			} else {
				ProgressView()
			}

			Section {
				Button {
					send(.didTapViewAllButton)
				} label: {
					Text("View more")
				}
				.buttonStyle(.navigation)
			}

			recentPlaysSection
		}
		.navigationTitle("Plays")
		.toolbar {
			ToolbarItem(placement: .navigationBarTrailing) {
				Button {
					send(.didTapRecordButton)
				} label: {
					Image(systemName: "plus")
				}
			}
		}
		.sheet(
			item: $store.scope(state: \.destination?.record, action: \.internal.destination.record)
		) { store in
			NavigationStack {
				RecordPlayView(store: store)
			}
		}
		.navigationDestination(
			item: $store.scope(state: \.destination?.details, action: \.internal.destination.details)
		) {
			PlayDetailsView(store: $0)
		}
		.navigationDestination(
			item: $store.scope(state: \.destination?.statistics, action: \.internal.destination.statistics)
		) {
			StatisticsListView(store: $0)
		}
		.task { await send(.task).finish() }
	}

	private var recentPlaysSection: some View {
		Section("Recent Plays") {
			if store.plays.isEmpty {
				Text("You haven't added any plays yet")
			} else {
				ForEach(store.plays) { play in
					Button {
						send(.didTapPlay(play))
					} label: {
						Text(play.letters)
							.frame(maxWidth: .infinity, alignment: .leading)
						Text(String(play.outcome.description.first ?? "❓"))
					}
					.buttonStyle(.navigation)
				}
				.onDelete { send(.didDelete($0)) }
			}
		}
	}
}
