import ComposableArchitecture
import SharedModelsLibrary
import SwiftUI

@ViewAction(for: DetailedStatistics.self)
public struct DetailedStatisticsView: View {
	public var store: StoreOf<DetailedStatistics>

	public init(store: StoreOf<DetailedStatistics>) {
		self.store = store
	}

	public var body: some View {
		List {
			Section {
				if let statistics = store.statistics {
					StatisticsOverview(statistics: statistics)
				} else {
					ProgressView()
				}
			}
		}
		.task { await send(.task).finish() }
		.navigationTitle("Statistics for \(store.letter)")
	}
}
