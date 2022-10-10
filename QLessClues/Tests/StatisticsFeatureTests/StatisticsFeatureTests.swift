import ComposableArchitecture
import StatisticsFeature
import SharedModelsLibrary
import SharedModelsLibraryMocks
import SolverServiceInterface
import ValidatorServiceInterface
import XCTest

@MainActor
final class StatisticsFeatureTests: XCTestCase {
	let mockEnvironment: StatisticsEnvironment = .init(
		solverService: .init { _ in
			XCTFail("Unimplemented")
			return AsyncStream<SolverService.Event>.streamWithContinuation().stream
		}
	)

	func testLoadsPlays() async {
		let store = TestStore(
			initialState: StatisticsState(),
			reducer: statisticsReducer,
			environment: mockEnvironment
		)

		_ = await store.send(.onAppear) {
			$0.plays = [.mock]
		}
	}
}
