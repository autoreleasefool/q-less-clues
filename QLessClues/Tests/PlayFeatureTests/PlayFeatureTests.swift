import ComposableArchitecture
import PlayFeature
import SharedModelsLibrary
import SharedModelsLibraryMocks
import SolverServiceInterface
import ValidatorServiceInterface
import XCTest

@MainActor
final class PlayFeatureTests: XCTestCase {
	let mockEnvironment: PlayEnvironment = .init(
		solverService: .init { _, _ in
			XCTFail("Unimplemented")
			return AsyncStream<SolverService.Event>.streamWithContinuation().stream
		}, validatorService: .init { _, _ in
			XCTFail("Unimplemented")
			return false
		}
	)

	func testDeletePlay() async {
		let store = TestStore(
			initialState: PlayState(play: Play.mock),
			reducer: playReducer,
			environment: mockEnvironment
		)

		_ = await store.send(.deleteButtonTapped) {
			$0.deleteAlert = AlertState(
				title: .init("Do you want to delete this play?"),
				primaryButton: .destructive(
					TextState("Delete"),
					action: .send(.deleteButtonTapped)
				),
				secondaryButton: .cancel(
					.init("Nevermind"),
					action: .send(.nevermindButtonTapped)
				)
			)
		}

		_ = await store.send(.alert(.deleteButtonTapped)) {
			$0.deleteAlert = nil
		}
	}
}