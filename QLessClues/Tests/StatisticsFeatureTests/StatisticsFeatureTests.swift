import ComposableArchitecture
import SharedModelsLibrary
import SharedModelsMocksLibrary
import SolverServiceInterface
import StatisticsFeature
import XCTest

@MainActor
final class StatisticsFeatureTests: XCTestCase {
	func testLoadsPlays() async {
		let (statistics, continuation) = AsyncStream<Statistics>.streamWithContinuation()
		let mockEnvironment: StatisticsEnvironment = .init(
			statisticsDataProvider: .init { statistics }
		)

		let mockStatistics = Statistics(pureWins: 1, winsWithHints: 1, losses: 1)

		let store = TestStore(
			initialState: StatisticsState(),
			reducer: statisticsReducer,
			environment: mockEnvironment
		)

		_ = await store.send(.onAppear)

		continuation.yield(mockStatistics)

		await store.receive(.statisticsResponse(mockStatistics)) {
			$0.statistics = mockStatistics
		}

		_ = await store.send(.onDisappear)
	}
}
