import ComposableArchitecture
import PlayFeature
import SharedModelsLibrary
import SharedModelsLibraryMocks
import SolverServiceInterface
import XCTest

@MainActor
final class PlayFeatureTests: XCTestCase {
	func mockEnvironment() -> PlayEnvironment {
		.init(playsDataProvider: .mock(), solverService: .mock())
	}

	func testDeletePlay() async {
		let store = TestStore(
			initialState: PlayState(play: Play.mock),
			reducer: playReducer,
			environment: mockEnvironment()
		)

		let expectation = self.expectation(description: "deleted")
		store.environment.playsDataProvider.delete = { play in
			XCTAssertEqual(play.id, Play.mock.id)
			expectation.fulfill()
		}

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

		_ = await store.receive(.playDeleted)

		wait(for: [expectation], timeout: 1)
	}
}
