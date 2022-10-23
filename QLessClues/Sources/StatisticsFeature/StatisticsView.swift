import ComposableArchitecture
import SharedModelsLibrary
import SwiftUI

public struct StatisticsView: View {
	let store: StoreOf<StatisticsReducer>

	struct ViewState: Equatable {
		let statistics: Statistics?
		let isShowingList: Bool

		init(state: StatisticsReducer.State) {
			self.statistics = state.statistics
			self.isShowingList = state.statisticsList != nil
		}
	}

	enum ViewAction {
		case viewAllButtonTapped
		case subscribeToStatistics
		case dismissList
	}

	public init(store: StoreOf<StatisticsReducer>) {
		self.store = store
	}

	public var body: some View {
		WithViewStore(store, observe: ViewState.init, send: StatisticsReducer.Action.init) { viewStore in
			Section {
				if let statistics = viewStore.statistics {
					StatisticsOverview(statistics: statistics)
				} else {
					ProgressView()
				}
			} header: {
				Text("Statistics")
			} footer: {
				NavigationLink(
					destination: IfLetStore(
						store.scope(
							state: \.statisticsList,
							action: StatisticsReducer.Action.statisticsList
						)
					) {
						StatisticsListView(store: $0)
					},
					isActive: viewStore.binding(
						get: \.isShowingList,
						send: { $0 ? .viewAllButtonTapped : .dismissList }
					)
				) {
					Text("View All")
				}
			}
			.task { await viewStore.send(.subscribeToStatistics).finish() }
		}
	}
}

extension StatisticsReducer.Action {
	init(action: StatisticsView.ViewAction) {
		switch action {
		case .subscribeToStatistics:
			self = .subscribeToStatistics
		case .viewAllButtonTapped:
			self = .viewAllButtonTapped
		case .dismissList:
			self = .dismissList
		}
	}
}
