import ComposableArchitecture
import HintsFeature
import SharedModelsLibrary
import SolutionsListFeature
import SolverServiceInterface

public struct AnalysisState: Equatable {
	public var letters = ""
	public var solutions: [Solution] = []
	public var mode: Mode = .notStarted
	public var difficulty: Play.Difficulty?
	public var hints: HintsState?
	public var solutionsList: SolutionsListState = .init(solutions: [])

	var isPlayable: Bool {
		self.letters.count == 12
	}

	public init() {}
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
	case onDisappear
	case solverService(SolverService.Event)
	case solverServiceFinished
	case hints(HintsAction)
	case solutionsList(SolutionsListAction)
}

public struct AnalysisEnvironment: Sendable {
	public var solverService: SolverService

	public init(solverService: SolverService) {
		self.solverService = solverService
	}
}

public enum AnalysisTearDown {}

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
		switch action {
		case .beginButtonTapped:
			state.mode = .solving(progress: 0)
			return .run { [letters = state.letters] send in
				for await event in environment.solverService.findSolutions(letters) {
					await send(.solverService(event))
				}

				await send(.solverServiceFinished)
			}
			.cancellable(id: AnalysisTearDown.self)

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

		case .onDisappear:
			return .cancel(id: AnalysisTearDown.self)

		case .hints, .solutionsList:
			return .none
		}
	}
)
