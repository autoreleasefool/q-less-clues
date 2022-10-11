import AnalysisFeature
import ComposableArchitecture
import SharedModelsLibrary
import SolverServiceInterface

public struct PlayState: Equatable {
	public var play: Play
	public var deleteAlert: AlertState<DeletePlayAlertAction>?
	public var analysis: AnalysisState

	public init(play: Play) {
		self.play = play
		self.analysis = AnalysisState(letters: play.letters)
	}
}

public enum PlayAction: Equatable {
	case alert(DeletePlayAlertAction)
	case deleteButtonTapped
	case analysis(AnalysisAction)
}

public struct PlayEnvironment: Sendable {
	public var solverService: SolverService

	public init(solverService: SolverService) {
		self.solverService = solverService
	}
}

public let playReducer = Reducer<PlayState, PlayAction, PlayEnvironment>.combine(
	analysisReducer
		.pullback(
			state: \.analysis,
			action: /PlayAction.analysis,
			environment: {
				AnalysisEnvironment(solverService: $0.solverService)
			}
		),
	.init { state, action, _ in
		switch action {
		case .alert(.nevermindButtonTapped), .alert(.dismissed), .alert(.deleteButtonTapped):
			state.deleteAlert = nil
			return .none

		case .deleteButtonTapped:
			state.deleteAlert = deleteAlert
			return .none

		case .analysis:
			return .none
		}
	}
)
