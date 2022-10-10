import AnalysisFeature
import ComposableArchitecture
import SharedModelsLibrary
import SolverServiceInterface
import ValidatorServiceInterface

public struct RecordPlayState: Equatable {
	public var letters = ""
	public var outcome: Play.Outcome = .unsolved
	public var analysisState: AnalysisState?

	public init() {}
}

public enum RecordPlayAction: Equatable {
	case lettersChanged(String)
	case outcomeChanged(Play.Outcome)
	case saveButtonTapped
	case analysis(AnalysisAction)
}

public struct RecordPlayEnvironment: Sendable {
	public var solverService: SolverService

	public init(solverService: SolverService) {
		self.solverService = solverService
	}
}

public let recordPlayReducer = Reducer<RecordPlayState, RecordPlayAction, RecordPlayEnvironment>.combine(
	analysisReducer
		.optional()
		.pullback(
			state: \.analysisState,
			action: /RecordPlayAction.analysis,
			environment: {
				AnalysisEnvironment(solverService: $0.solverService)
			}
		),
	.init { state, action, _ in
		switch action {
		case let .lettersChanged(letters):
			// TODO: replace non-A-Z characters
			state.letters = String(letters.uppercased().prefix(12))
			if state.letters.count == 12 {
				state.analysisState = .init(letters: state.letters)
			} else {
				state.analysisState = nil
				return .cancel(id: AnalysisTearDown.self)
			}

			return .none

		case let .outcomeChanged(outcome):
			state.outcome = outcome
			return .none

		case .saveButtonTapped:
			// TODO: save play to database
			return .none

		case .analysis(.analysisCancelled):
			state.analysisState = nil
			return .none

		case .analysis:
			return .none
		}
	}
)
