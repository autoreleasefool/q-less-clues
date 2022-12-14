import ComposableArchitecture
import PlaysListFeature
import SharedModelsLibrary
import SharedModelsLibraryMocks
import SolverServiceInterface
import XCTest

@MainActor
final class PlaysListFeatureTests: XCTestCase {
	func mockEnvironment() -> PlaysListEnvironment {
		.init(
			playsDataProvider: .mock(),
			statisticsDataProvider: .mock(),
			solverService: .mock()
		)
	}

	func testDeletePlay() async {
		let store = TestStore(
			initialState: PlaysListState(),
			reducer: playsListReducer,
			environment: mockEnvironment()
		)

		let expectation = self.expectation(description: "deleted")
		store.environment.playsDataProvider.delete = { play in
			XCTAssertEqual(play, Play.mock)
			expectation.fulfill()
		}

		_ = await store.send(.playsResponse([.mock, .mock2])) {
			$0.plays = [.mock, .mock2]
		}

		_ = await store.send(.delete([0])) {
			$0.plays = [.mock2]
		}

		await store.receive(.playDeleted)

		wait(for: [expectation], timeout: 1)
	}

	func testAddingNewPlay() async {
		let store = TestStore(
			initialState: PlaysListState(),
			reducer: playsListReducer,
			environment: mockEnvironment()
		)

		_ = await store.send(.playsResponse([.mock, .mock2])) {
			$0.plays = [.mock, .mock2]
		}

		_ = await store.send(.setRecordSheet(isPresented: true)) {
			$0.recordPlay = .init()
		}

		_ = await store.send(.setRecordSheet(isPresented: false)) {
			$0.recordPlay = nil
		}
	}
}
