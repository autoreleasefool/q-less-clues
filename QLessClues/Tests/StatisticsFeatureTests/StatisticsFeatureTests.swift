import ComposableArchitecture
import StatisticsFeature
import SharedModelsLibrary
import SharedModelsLibraryMocks
import SolverServiceInterface
import XCTest

@MainActor
final class StatisticsFeatureTests: XCTestCase {
	func testLoadsPlays() async {
		let mockStatistics = Statistics(pureWins: 1, winsWithHints: 1, losses: 1)
		let mockEnvironment: StatisticsEnvironment = .init(
			statisticsDataProvider: .init {
				mockStatistics
			}
		)

		let store = TestStore(
			initialState: StatisticsState(),
			reducer: statisticsReducer,
			environment: mockEnvironment
		)

		_ = await store.send(.load)

		await store.receive(.statisticsResponse(mockStatistics)) {
			$0.statistics = mockStatistics
		}
	}
}
