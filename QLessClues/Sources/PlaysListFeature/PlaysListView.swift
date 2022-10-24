import ComposableArchitecture
import PlayDetailsFeature
import RecordPlayFeature
import SharedModelsLibrary
import StatisticsFeature
import SwiftUI

public struct PlaysListView: View {
	let store: StoreOf<PlaysList>

	struct ViewState: Equatable {
		let plays: IdentifiedArrayOf<Play>
		let selection: Identified<Play.ID, PlayDetails.State>?
		let isSheetPresented: Bool

		init(state: PlaysList.State) {
			self.plays = state.plays
			self.selection = state.selection
			self.isSheetPresented = state.recordPlay != nil
		}
	}

	enum ViewAction {
		case subscribeToPlays
		case setRecordSheet(isPresented: Bool)
		case setPlaySelection(selection: Play.ID?)
		case delete(IndexSet)
	}

	public init(store: StoreOf<PlaysList>) {
		self.store = store
	}

	public var body: some View {
		WithViewStore(store, observe: ViewState.init, send: PlaysList.Action.init) { viewStore in
			List {
				StatisticsView(store: store.scope(state: \.statistics, action: PlaysList.Action.statistics))
				recentPlaysSection(viewStore: viewStore)
			}
			.navigationTitle("Plays")
			.toolbar {
				ToolbarItem(placement: .navigationBarTrailing) {
					Button {
						viewStore.send(.setRecordSheet(isPresented: true))
					} label: {
						Image(systemName: "plus")
					}
				}
			}
			.sheet(
				isPresented: viewStore.binding(
					get: \.isSheetPresented,
					send: ViewAction.setRecordSheet(isPresented:)
				)
			) {
				IfLetStore(store.scope(state: \.recordPlay, action: PlaysList.Action.recordPlay)) { scopedStore in
					NavigationView {
						RecordPlayView(store: scopedStore)
					}
				}
			}
			.task { await viewStore.send(.subscribeToPlays).finish() }
		}
	}

	private func recentPlaysSection(
		viewStore: ViewStore<PlaysListView.ViewState, PlaysListView.ViewAction>
	) -> some View {
		Section("Recent Plays") {
			if viewStore.plays.isEmpty {
				Text("You haven't added any plays yet")
			} else {
				ForEach(viewStore.plays) { play in
					NavigationLink(
						destination: IfLetStore(
							store.scope(
								state: \.selection?.value,
								action: PlaysList.Action.play
							)
						) {
							PlayDetailsView(store: $0)
						},
						tag: play.id,
						selection: viewStore.binding(
							get: \.selection?.id,
							send: ViewAction.setPlaySelection(selection:)
						)
					) {
						Text(play.letters)
							.frame(maxWidth: .infinity, alignment: .leading)
						Text(String(play.outcome.description.first ?? "❓"))
					}
				}
				.onDelete { viewStore.send(.delete($0)) }
			}
		}
	}
}

extension PlaysList.Action {
	init(action: PlaysListView.ViewAction) {
		switch action {
		case let .delete(indexSet):
			self = .delete(indexSet)
		case let .setRecordSheet(isPresented):
			self = .setRecordSheet(isPresented: isPresented)
		case let .setPlaySelection(selection):
			self = .setPlaySelection(selection: selection)
		case .subscribeToPlays:
			self = .subscribeToPlays
		}
	}
}
