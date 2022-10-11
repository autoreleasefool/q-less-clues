import ComposableArchitecture
import PlayFeature
import SharedModelsLibrary
import StatisticsFeature
import SwiftUI

public struct PlaysList: View {
	let store: Store<PlaysListState, PlaysListAction>

	struct ViewState: Equatable {
		let plays: IdentifiedArrayOf<Play>

		init(state: PlaysListState) {
			self.plays = .init(uniqueElements: state.plays)
		}
	}

	enum ViewAction {
		case addButtonTapped
		case delete(IndexSet)
	}

	public init(store: Store<PlaysListState, PlaysListAction>) {
		self.store = store
	}

	public var body: some View {
		WithViewStore(store, observe: ViewState.init, send: PlaysListAction.init) { viewStore in
			List {
				StatisticsView(store: store.scope(state: \.statistics, action: PlaysListAction.statistics))

				Section("Recent Plays") {
					if viewStore.plays.isEmpty {
						Text("You haven't added any plays yet")
					} else {
						ForEach(viewStore.plays) { play in
							NavigationLink(
								destination: IfLetStore(
									store.scope(
										state: \.play,
										action: PlaysListAction.play
									)
								) {
									PlayView(store: $0)
								}
							) {
								Text(play.letters)
									.frame(maxWidth: .infinity, alignment: .leading)
								Text(String(play.outcome.rawValue.first ?? "❓"))
							}
						}
						.onDelete { viewStore.send(.delete($0)) }
					}
				}
			}
			.toolbar {
				ToolbarItem(placement: .navigationBarTrailing) {
					Button {
						viewStore.send(.addButtonTapped)
					} label: {
						Image(systemName: "plus")
					}
				}
			}
		}
	}
}

extension PlaysListAction {
	init(action: PlaysList.ViewAction) {
		switch action {
		case let .delete(indexSet):
			self = .delete(indexSet)
		case .addButtonTapped:
			self = .addButtonTapped
		}
	}
}
