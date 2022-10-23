import ComposableArchitecture
import SwiftUI

public struct StatisticsListView: View {
	static let letters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ".map { String($0) }
	let store: StoreOf<StatisticsList>

	struct ViewState: Equatable {
		let gamesPlayed: [String: Int]
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
			List {
				ForEach(Self.letters, id: \.self) { letter in
					NavigationLink(
						destination: IfLetStore(
							store.scope(
								state: \.selection?.value,
								action: StatisticsList.Action.detailedStatistics
							)
						) {
							DetailedStatisticsView(store: $0)
						},
						tag: letter,
						selection: viewStore.binding(
							get: \.selection,
							send: StatisticsListView.ViewAction.setNavigation(selection:)
						)
					) {
						LabeledContent(letter, value: "\(viewStore.gamesPlayed[letter] ?? 0)")
					}
				}
			}
			.task { await viewStore.send(.subscribeToCounts).finish() }
			.navigationTitle("Statistics by Letter")
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
