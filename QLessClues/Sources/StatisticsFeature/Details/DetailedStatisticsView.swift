import ComposableArchitecture
import SharedModelsLibrary
import SwiftUI

public struct DetailedStatisticsView: View {
	let store: StoreOf<DetailedStatistics>

	struct ViewState: Equatable {
		let letter: String
		let statistics: Statistics?

		init(state: DetailedStatistics.State) {
			self.statistics = state.statistics
			self.letter = state.letter
		}
	}

	enum ViewAction {
		case subscribeToStatistics
	}

	public init(store: StoreOf<DetailedStatistics>) {
		self.store = store
	}

	public var body: some View {
		WithViewStore(store, observe: ViewState.init, send: DetailedStatistics.Action.init) { viewStore in
			List {
				Section {
					if let statistics = viewStore.statistics {
						StatisticsOverview(statistics: statistics)
					} else {
						ProgressView()
					}
				}
			}
			.task { await viewStore.send(.subscribeToStatistics).finish() }
			.navigationTitle("Statistics for \(viewStore.letter)")
		}
	}
}

extension DetailedStatistics.Action {
	init(action: DetailedStatisticsView.ViewAction) {
		switch action {
		case .subscribeToStatistics:
			self = .subscribeToStatistics
		}
	}
}
