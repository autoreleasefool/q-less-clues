import ComposableArchitecture
import HintsFeature
import SharedModelsLibrary
import SharedModelsLibraryMocks
import XCTest

@MainActor
final class HintsFeatureTests: XCTestCase {
	func testGivesHint() async {
		let store = TestStore(
			initialState: HintsState(solutions: [Solution.multiWordMock]),
			reducer: hintsReducer,
			environment: .init()
		)

		_ = await store.send(.hintButtonTapped) {
			$0.hints = ["ART"]
		}
	}

	func testGivesNoAdditionalHints() async {
		var initialState = HintsState(solutions: [Solution.multiWordMock])
		initialState.hints = ["ART"]

		let store = TestStore(
			initialState: initialState,
			reducer: hintsReducer,
			environment: .init()
		)

		_ = await store.send(.hintButtonTapped)
	}
}
