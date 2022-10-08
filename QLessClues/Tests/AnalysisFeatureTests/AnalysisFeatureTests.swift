import AnalysisFeature
import ComposableArchitecture
import SharedModelsLibrary
import SharedModelsLibraryMocks
import SolverServiceInterface
import ValidatorServiceInterface
import XCTest

@MainActor
final class AnalysisFeatureTests: XCTestCase {
	func testBeginsAnalysis() async {
		let (solutions, _) = AsyncStream<SolverService.Event>.streamWithContinuation()
		let solverService: SolverService = .init { _, _ in solutions }
		let validatorService: ValidatorService = .init { _, _ in true }

		let store = TestStore(
			initialState: AnalysisState(letters: "RAT"),
			reducer: analysisReducer,
			environment: .init(
				solverService: solverService,
				validatorService: validatorService
			)
		)

		_ = await store.send(.beginButtonTapped) {
			$0.mode = .solving(progress: 0)
		}

		_ = await store.send(.analysisCancelled)
	}

	func testHandlesSolutions() async {
		let (solutions, continuation) = AsyncStream<SolverService.Event>.streamWithContinuation()
		let solverService: SolverService = .init { _, _ in solutions }
		let validatorService: ValidatorService = .init { _, _ in true }

		let store = TestStore(
			initialState: AnalysisState(letters: "RAT"),
			reducer: analysisReducer,
			environment: .init(
				solverService: solverService,
				validatorService: validatorService
			)
		)

		_ = await store.send(.beginButtonTapped) {
			$0.mode = .solving(progress: 0)
		}

		continuation.yield(.solution(Solution.mock))
		await store.receive(.solverService(.solution(Solution.mock))) {
			$0.solutions = [Solution.mock]
			$0.solutionsList = .init(solutions: [Solution.mock])
		}

		continuation.yield(.progress(0.2))
		await store.receive(.solverService(.progress(0.2))) {
			$0.mode = .solving(progress: 0.2)
		}

		_ = await store.send(.analysisCancelled)
	}

	func testHandlesSolverFinishes() async {
		let (solutions, continuation) = AsyncStream<SolverService.Event>.streamWithContinuation()
		let solverService: SolverService = .init { _, _ in solutions }
		let validatorService: ValidatorService = .init { _, _ in true }

		let store = TestStore(
			initialState: AnalysisState(letters: "RAT"),
			reducer: analysisReducer,
			environment: .init(
				solverService: solverService,
				validatorService: validatorService
			)
		)

		_ = await store.send(.beginButtonTapped) {
			$0.mode = .solving(progress: 0)
		}

		continuation.finish()

		await store.receive(.solverServiceFinished) {
			$0.mode = .solved
		}
	}
}