import ComposableArchitecture
import HintsFeature
import SharedModelsLibrary
import SolutionsListFeature
import SolverServiceInterface
import ValidatorServiceInterface

public struct AnalysisState: Equatable {
	public var letters: String
	public var solutions: [Solution] = []
	public var mode: Mode = .notStarted
	public var difficulty: Difficulty?
	public var hints: HintsState?
	public var solutionsList: SolutionsListState = .init(solutions: [])

	public init(letters: String) {
		self.letters = letters
	}
}

public enum Mode: Equatable {
	case notStarted
	case solving(progress: Double)
	case solved

	var progress: Double {
		if case let .solving(progress) = self { return progress }
		return 0
	}

	var hasStarted: Bool {
		switch self {
		case .notStarted:
			return false
		case .solving, .solved:
			return true
		}
	}
}

public enum AnalysisAction: Equatable {
	case beginButtonTapped
	case analysisCancelled
	case solverService(SolverService.Event)
	case solverServiceFinished
	case hints(HintsAction)
	case solutionsList(SolutionsListAction)
}

public struct AnalysisEnvironment: Sendable {
	public var solverService: SolverService
	public var validatorService: ValidatorService

	public init(solverService: SolverService, validatorService: ValidatorService) {
		self.solverService = solverService
		self.validatorService = validatorService
	}
}

public let analysisReducer = Reducer<AnalysisState, AnalysisAction, AnalysisEnvironment>.combine(
	solutionsListReducer
		.pullback(
			state: \.solutionsList,
			action: /AnalysisAction.solutionsList,
			environment: { _ in .init() }
		),
	hintsReducer
		.optional()
		.pullback(
			state: \.hints,
			action: /AnalysisAction.hints,
			environment: { _ in .init() }
		),
	.init { state, action, environment in
		enum CancelID {}

		switch action {
		case .analysisCancelled:
			return .cancel(id: CancelID.self)

		case .beginButtonTapped:
			state.mode = .solving(progress: 0)
			return .run { [letters = state.letters] send in
				for await event in environment.solverService.findSolutions(letters, environment.validatorService) {
					await send(.solverService(event))
				}

				await send(.solverServiceFinished)
			}
			.cancellable(id: CancelID.self)

		case .solverServiceFinished:
			state.mode = .solved
			return .none

		case let .solverService(.solution(solution)):
			state.solutions.append(solution)
			state.solutionsList.solutions.append(solution)
			return .none

		case let .solverService(.progress(progress)):
			state.mode = .solving(progress: progress)
			return .none

		case .hints, .solutionsList:
			return .none
		}
	}
)
