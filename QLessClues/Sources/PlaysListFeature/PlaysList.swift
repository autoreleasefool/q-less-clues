import ComposableArchitecture
import PlayFeature
import RecordPlayFeature
import SharedModelsLibrary
import StatisticsFeature
import SwiftUI

public struct PlaysList: View {
	let store: Store<PlaysListState, PlaysListAction>

	struct ViewState: Equatable {
		let plays: IdentifiedArrayOf<Play>
		let selection: Identified<Play.ID, PlayState>?
		let isSheetPresented: Bool

		init(state: PlaysListState) {
			self.plays = state.plays
			self.selection = state.selection
			self.isSheetPresented = state.recordPlay != nil
		}
	}

	enum ViewAction {
		case onAppear
		case onDisappear
		case setRecordSheet(isPresented: Bool)
		case setPlaySelection(selection: Play.ID?)
		case delete(IndexSet)
	}

	public init(store: Store<PlaysListState, PlaysListAction>) {
		self.store = store
	}

	public var body: some View {
		WithViewStore(store, observe: ViewState.init, send: PlaysListAction.init) { viewStore in
			List {
				StatisticsView(store: store.scope(state: \.statistics, action: PlaysListAction.statistics))
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
				IfLetStore(store.scope(state: \.recordPlay, action: PlaysListAction.recordPlay)) { scopedStore in
					NavigationStack {
						RecordPlayView(store: scopedStore)
					}
				}
			}
			.onAppear { viewStore.send(.onAppear) }
			.onDisappear { viewStore.send(.onDisappear) }
		}
	}

	private func recentPlaysSection(viewStore: ViewStore<ViewState, ViewAction>) -> some View {
		Section("Recent Plays") {
			if viewStore.plays.isEmpty {
				Text("You haven't added any plays yet")
			} else {
				ForEach(viewStore.plays) { play in
					NavigationLink(
						destination: IfLetStore(
							store.scope(
								state: \.selection?.value,
								action: PlaysListAction.play
							)
						) {
							PlayView(store: $0)
						},
						tag: play.id,
						selection: viewStore.binding(
							get: \.selection?.id,
							send: ViewAction.setPlaySelection(selection:)
						)
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
}

extension PlaysListAction {
	init(action: PlaysList.ViewAction) {
		switch action {
		case let .delete(indexSet):
			self = .delete(indexSet)
		case let .setRecordSheet(isPresented):
			self = .setRecordSheet(isPresented: isPresented)
		case let .setPlaySelection(selection):
			self = .setPlaySelection(selection: selection)
		case .onAppear:
			self = .onAppear
		case .onDisappear:
			self = .onDisappear
		}
	}
}
