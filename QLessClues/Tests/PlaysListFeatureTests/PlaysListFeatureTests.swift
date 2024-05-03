import ComposableArchitecture
import PlaysListFeature
import SharedModelsLibrary
import SharedModelsMocksLibrary
import SolverServiceInterface
import XCTest

@MainActor
final class PlaysListFeatureTests: XCTestCase {
	func mockEnvironment() -> PlaysListEnvironment {
		.init(
			plays: .mock(),
			statistics: .mock(),
			solver: .mock()
		)
	}

	func testDeletePlay() async {
		let store = TestStore(
			initialState: PlaysListState(),
			reducer: playsListReducer,
			environment: mockEnvironment()
		)

		let expectation = self.expectation(description: "deleted")
		store.environment.plays.delete = { play in
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
