import ComposableArchitecture
import RecordPlayFeature
import SolverServiceInterface
import XCTest

@MainActor
final class RecordPlayFeatureTests: XCTestCase {
	let mockEnvironment: RecordPlayEnvironment = .init(
		solverService: .init { _ in
			XCTFail("Unimplemented")
			return AsyncStream<SolverService.Event>.streamWithContinuation().stream
		}
	)

	func testChangeLetters() async {
		let store = TestStore(
			initialState: .init(),
			reducer: recordPlayReducer,
			environment: mockEnvironment
		)

		_ = await store.send(.lettersChanged(""))

		_ = await store.send(.lettersChanged("a")) {
			$0.letters = "A"
		}

		_ = await store.send(.lettersChanged("AB")) {
			$0.letters = "AB"
		}
	}

	func testValidGameEntered() async {
		let store = TestStore(
			initialState: .init(),
			reducer: recordPlayReducer,
			environment: mockEnvironment
		)

		_ = await store.send(.lettersChanged("ABCDEFGHIJKL")) {
			$0.letters = "ABCDEFGHIJKL"
			$0.analysisState = .init(letters: "ABCDEFGHIJKL")
		}
	}

	func testOutcomeChanges() async {
		let store = TestStore(
			initialState: .init(),
			reducer: recordPlayReducer,
			environment: mockEnvironment
		)

		_ = await store.send(.outcomeChanged(.unsolved))
		_ = await store.send(.outcomeChanged(.solved)) {
			$0.outcome = .solved
		}
	}

	func testSavesPlay() async {
		// TODO: implement test
	}
}
