import ComposableArchitecture
import HintsFeature
import SharedModelsLibrary
import SolutionsListFeature
import SolverServiceInterface

public struct Analysis: ReducerProtocol {
	public enum TearDown {}

	public struct State: Equatable {
		public var letters: String
		public var solutions: [Solution] = []
		public var mode: Mode = .notStarted
		public var difficulty: Play.Difficulty?
		public var hints: Hints.State?
		public var solutionsList: SolutionsList.State = .init(solutions: [])

		var isPlayable: Bool {
			self.letters.count == 12
		}

		public init(letters: String = "") {
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

	public enum Action: Equatable {
		case beginButtonTapped
		case solverService(SolverService.Event)
		case solverServiceFinished
		case lettersChanged(String)
		case hints(Hints.Action)
		case solutionsList(SolutionsList.Action)
	}

	public init() {}

	@Dependency(\.solverService) var solverService

	public var body: some ReducerProtocol<State, Action> {
//		Scope(state: \.solutionsList, action: /Action.solutionsList) {
//			SolutionsList()
//		}

		Reduce { state, action in
			switch action {
			case let .lettersChanged(letters):
				if letters.count != 12 {
					state.mode = .notStarted
					state.solutions = []
					state.difficulty = nil
					return .cancel(id: TearDown.self)
				} else {
					return .none
				}

			case .beginButtonTapped:
				state.mode = .solving(progress: 0)
				return .run { [letters = state.letters] send in
					for await event in solverService.findSolutions(letters) {
						await send(.solverService(event))
					}

					await send(.solverServiceFinished)
				}
				.cancellable(id: TearDown.self)

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
		.ifLet(\.hints, action: /Analysis.Action.hints) {
			Hints()
		}
	}
}
