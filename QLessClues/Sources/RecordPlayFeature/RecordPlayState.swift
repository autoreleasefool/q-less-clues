import AnalysisFeature
import ComposableArchitecture
import PlaysDataProviderInterface
import SharedModelsLibrary
import SolverServiceInterface

public struct RecordPlayState: Equatable {
	public var letters = ""
	public var outcome: Play.Outcome = .unsolved
	public var analysis = AnalysisState()

	public var play: Play {
		.init(letters: letters, outcome: outcome, difficulty: nil)
	}

	public init() {}
}

public enum RecordPlayAction: Equatable {
	case lettersChanged(String)
	case outcomeChanged(Play.Outcome)
	case analysis(AnalysisAction)
	case saveButtonTapped
	case playSaved
}

public struct RecordPlayEnvironment: Sendable {
	public var playsDataProvider: PlaysDataProvider
	public var solverService: SolverService

	public init(playsDataProvider: PlaysDataProvider, solverService: SolverService) {
		self.playsDataProvider = playsDataProvider
		self.solverService = solverService
	}
}

public let recordPlayReducer = Reducer<RecordPlayState, RecordPlayAction, RecordPlayEnvironment>.combine(
	analysisReducer
		.pullback(
			state: \.analysis,
			action: /RecordPlayAction.analysis,
			environment: {
				AnalysisEnvironment(solverService: $0.solverService)
			}
		),
	.init { state, action, environment in
		switch action {
		case let .lettersChanged(letters):
			// TODO: replace non-A-Z characters
			state.letters = String(letters.uppercased().prefix(12))
			state.analysis.letters = state.letters
			return .none

		case let .outcomeChanged(outcome):
			state.outcome = outcome
			return .none

		case .saveButtonTapped:
			return .task { [play = state.play] in
				do {
					try await environment.playsDataProvider.save(play)
				} catch {
					print(error)
				}
				return .playSaved
			}

		case .playSaved:
			return .none

		case .analysis:
			return .none
		}
	}
)
