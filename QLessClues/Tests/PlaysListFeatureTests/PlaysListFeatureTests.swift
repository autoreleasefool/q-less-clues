import ComposableArchitecture
import PlaysListFeature
import SharedModelsLibrary
import SharedModelsLibraryMocks
import SolverServiceInterface
import ValidatorServiceInterface
import XCTest

@MainActor
final class PlaysListFeatureTests: XCTestCase {
	let mockEnvironment: PlaysListEnvironment = .init(
		solverService: .init { _ in
			XCTFail("Unimplemented")
			return AsyncStream<SolverService.Event>.streamWithContinuation().stream
		}
	)

	func testDeletePlay() async {
		let store = TestStore(
			initialState: PlaysListState(plays: [.mock, .mock]),
			reducer: playsListReducer,
			environment: mockEnvironment
		)

		_ = await store.send(.delete([0])) {
			$0.plays = [.mock]
		}
	}

	func testDeleteMultiplePlays() async {
		let store = TestStore(
			initialState: PlaysListState(plays: [.mock, .mock]),
			reducer: playsListReducer,
			environment: mockEnvironment
		)

		_ = await store.send(.delete([0, 1])) {
			$0.plays = []
		}
	}

	func testAddingNewPlay() async {
		let store = TestStore(
			initialState: PlaysListState(plays: [.mock, .mock]),
			reducer: playsListReducer,
			environment: mockEnvironment
		)

		_ = await store.send(.addButtonTapped) {
			$0.recordPlay = .init()
		}
	}
}
