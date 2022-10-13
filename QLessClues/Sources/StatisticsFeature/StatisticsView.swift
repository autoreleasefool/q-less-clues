import ComposableArchitecture
import SharedModelsLibrary
import SwiftUI

public struct StatisticsView: View {
	let store: Store<StatisticsState, StatisticsAction>

	struct ViewState: Equatable {
		let statistics: Statistics?

		init(state: StatisticsState) {
			self.statistics = state.statistics
		}
	}

	enum ViewAction {
		case onAppear
		case onDisappear
	}

	public init(store: Store<StatisticsState, StatisticsAction>) {
		self.store = store
	}

	public var body: some View {
		WithViewStore(store, observe: ViewState.init, send: StatisticsAction.init) { viewStore in
			Section("Statistics") {
				if let statistics = viewStore.statistics {
					HStack {
						Spacer()
						VStack(alignment: .center) {
							Text(statistics.pureWinPercentage)
								.font(.largeTitle)
							Text("Wins")
						}
						Spacer()
						VStack(alignment: .center) {
							Text(statistics.overallWinPercentage)
								.font(.largeTitle)
							Text("With hints")
						}
						Spacer()
					}
					LabeledContent("Wins", value: "\(statistics.pureWins)")
					LabeledContent("Wins (with hints)", value: "\(statistics.winsWithHints)")
					LabeledContent("Losses", value: "\(statistics.losses)")
					LabeledContent("Total Plays", value: "\(statistics.totalPlays)")
				} else {
					ProgressView()
				}
			}
			.onAppear { viewStore.send(.onAppear) }
			.onDisappear { viewStore.send(.onDisappear) }
		}
	}
}

extension StatisticsAction {
	init(action: StatisticsView.ViewAction) {
		switch action {
		case .onAppear:
			self = .onAppear
		case .onDisappear:
			self = .onDisappear
		}
	}
}
