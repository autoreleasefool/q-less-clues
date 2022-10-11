import ComposableArchitecture
import PlaysListFeature
import SwiftUI

public struct StatisticsView: View {
	let store: Store<StatisticsState, StatisticsAction>

	struct ViewState: Equatable {
		let statistics: Statistics

		init(state: StatisticsState) {
			self.statistics = state.statistics
		}
	}

	enum ViewAction {
		case onAppear
	}

	public init(store: Store<StatisticsState, StatisticsAction>) {
		self.store = store
	}

	public var body: some View {
		WithViewStore(store, observe: ViewState.init, send: StatisticsAction.init) { viewStore in
			List {
				HStack {
					Spacer()
					VStack(alignment: .center) {
						Text(viewStore.statistics.pureWinPercentage)
							.font(.largeTitle)
						Text("Wins")
					}
					Spacer()
					VStack(alignment: .center) {
						Text(viewStore.statistics.overallWinPercentage)
							.font(.largeTitle)
						Text("With hints")
					}
					Spacer()
				}
				LabeledContent("Wins", value: "\(viewStore.statistics.pureWins)")
				LabeledContent("Wins (with hints)", value: "\(viewStore.statistics.winsWithHints)")
				LabeledContent("Losses", value: "\(viewStore.statistics.losses)")
				LabeledContent("Total Plays", value: "\(viewStore.statistics.totalPlays)")

				IfLetStore(store.scope(state: \.playsList, action: StatisticsAction.playsList)) {
					PlaysList(store: $0)
				}
			}
			.navigationTitle("Statistics")
			.onAppear { viewStore.send(.onAppear) }
		}
	}
}

extension StatisticsAction {
	init(action: StatisticsView.ViewAction) {
		switch action {
		case .onAppear:
			self = .onAppear
		}
	}
}
