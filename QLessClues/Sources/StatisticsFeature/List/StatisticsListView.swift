import ComposableArchitecture
import SharedModelsLibrary
import SwiftUI

public struct StatisticsListView: View {
	let store: StoreOf<StatisticsList>

	struct ViewState: Equatable {
		let gamesPlayed: IdentifiedArrayOf<LetterPlayCount>
		let selection: String?

		init(state: StatisticsList.State) {
			self.gamesPlayed = state.gamesPlayed
			self.selection = state.selection?.id
		}
	}

	enum ViewAction {
		case subscribeToCounts
		case setNavigation(selection: String?)
	}

	public var body: some View {
		WithViewStore(store, observe: ViewState.init, send: StatisticsList.Action.init) { viewStore in
			List(viewStore.gamesPlayed) { letter in
				NavigationLink(
					destination: IfLetStore(
						store.scope(
							state: \.selection?.value,
							action: StatisticsList.Action.detailedStatistics
						)
					) {
						DetailedStatisticsView(store: $0)
					},
					tag: letter.id,
					selection: viewStore.binding(
						get: \.selection,
						send: StatisticsListView.ViewAction.setNavigation(selection:)
					)
				) {
					LabeledContent(letter.letter, value: "\(letter.plays)")
				}
			}
			.navigationTitle("Statistics by Letter")
			.task { await viewStore.send(.subscribeToCounts).finish() }
		}
	}
}

extension StatisticsList.Action {
	init(action: StatisticsListView.ViewAction) {
		switch action {
		case .subscribeToCounts:
			self = .subscribeToCounts
		case let .setNavigation(selection):
			self = .setNavigation(selection: selection)
		}
	}
}
