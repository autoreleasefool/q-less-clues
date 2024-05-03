import ComposableArchitecture
import HintsFeature
import SharedModelsLibrary
import SolutionsListFeature
import SolverServiceInterface

@Reducer
public struct Analysis: Reducer {
	@ObservableState
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

	public enum Action: ViewAction, BindableAction {
		@CasePathable public enum View {
			case didTapBeginButton
		}

		@CasePathable public enum Internal {
			case didReceiveSolverEvent(SolverService.Event)
			case solverDidFinish
			case hints(Hints.Action)
			case solutionsList(SolutionsList.Action)
		}

		case view(View)
		case `internal`(Internal)
		case binding(BindingAction<State>)
	}

	public enum CancelID: Hashable {
		case solver
	}

	public init() {}

	@Dependency(\.solverService) var solverService

	public var body: some ReducerOf<Self> {
		Scope(state: \.solutionsList, action: \.internal.solutionsList) {
			SolutionsList()
		}

		BindingReducer()
			.onChange(of: \.letters) { _, letters in
				Reduce { state, _ in
					if letters.count != 12 {
						state.mode = .notStarted
						state.solutions = []
						state.difficulty = nil
						return .cancel(id: CancelID.solver)
					} else {
						return .none
					}
				}
			}

		Reduce { state, action in
			switch action {
			case let .view(viewAction):
				switch viewAction {
				case .didTapBeginButton:
					state.mode = .solving(progress: 0)
					return .run { [letters = state.letters] send in
						for await event in solverService.findSolutions(letters) {
							await send(.internal(.didReceiveSolverEvent(event)))
						}

						await send(.internal(.solverDidFinish))
					}
					.cancellable(id: CancelID.solver)
				}

			case let .internal(internalAction):
				switch internalAction {
				case let .didReceiveSolverEvent(event):
					switch event {
					case let .progress(progress):
						state.mode = .solving(progress: progress)
						return .none

					case let .solution(solution):
						state.solutions.append(solution)
						state.solutionsList.solutions.append(solution)
						return .none
					}

				case .solverDidFinish:
					state.mode = .solved
					return .none

				case .hints(.view), .solutionsList(.binding), .solutionsList(.view):
					return .none
				}

			case .binding:
				return .none
			}
		}
		.ifLet(\.hints, action: \.internal.hints) {
			Hints()
		}
	}
}
