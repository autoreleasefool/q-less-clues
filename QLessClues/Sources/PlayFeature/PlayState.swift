import AnalysisFeature
import ComposableArchitecture
import PlaysDataProviderInterface
import SharedModelsLibrary
import SolverServiceInterface

public struct PlayState: Equatable {
	public var play: Play
	public var deleteAlert: AlertState<DeletePlayAlertAction>?
	public var analysis = AnalysisState()

	public init(play: Play) {
		self.play = play
		self.analysis.letters = play.letters
	}
}

public enum PlayAction: Equatable {
	case alert(DeletePlayAlertAction)
	case deleteButtonTapped
	case analysis(AnalysisAction)
	case playDeleted
	case onDisappear
}

public struct PlayEnvironment: Sendable {
	public var playsDataProvider: PlaysDataProvider
	public var solverService: SolverService

	public init(playsDataProvider: PlaysDataProvider, solverService: SolverService) {
		self.playsDataProvider = playsDataProvider
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
	.init { state, action, environment in
		switch action {
		case .alert(.nevermindButtonTapped), .alert(.dismissed):
			state.deleteAlert = nil
			return .none

		case .alert(.deleteButtonTapped):
			state.deleteAlert = nil
			return .task { [play = state.play] in
				try await environment.playsDataProvider.delete(play)
				return .playDeleted
			}

		case .playDeleted:
			return .none

		case .deleteButtonTapped:
			state.deleteAlert = deleteAlert
			return .none

		case .analysis:
			return .none

		case .onDisappear:
			return .none
		}
	}
)
