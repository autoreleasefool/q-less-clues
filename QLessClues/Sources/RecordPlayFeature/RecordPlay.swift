import AnalysisFeature
import ComposableArchitecture
import Foundation
import PlayDetailsFeature
import PlaysDataProviderInterface
import SharedModelsLibrary
import SolverServiceInterface

public struct RecordPlay: ReducerProtocol {
	public struct State: Equatable {
		public var letters = ""
		public var date = Date()
		public var outcome: Play.Outcome = .unsolved
		public var analysis = Analysis.State()

		public var play: Play {
			.init(id: UUID(), createdAt: date, letters: letters, outcome: outcome, difficulty: nil)
		}

		public init() {}
	}

	public enum Action: Equatable {
		case lettersChanged(String)
		case dateChanged(Date)
		case outcomeChanged(Play.Outcome)
		case analysis(Analysis.Action)
		case saveButtonTapped
		case playSaved
	}

	public init() {}

	@Dependency(\.playsDataProvider) var playsDataProvider

	public var body: some ReducerProtocol<State, Action> {
		Scope(state: \.analysis, action: /RecordPlay.Action.analysis) {
			Analysis()
		}

		Reduce { state, action in
			switch action {
			case let .lettersChanged(letters):
				// TODO: replace non-A-Z characters
				state.letters = String(letters.uppercased().prefix(12))
				state.analysis.letters = state.letters
				return .none

			case let .dateChanged(date):
				state.date = date
				return .none

			case let .outcomeChanged(outcome):
				state.outcome = outcome
				return .none

			case .saveButtonTapped:
				return .task { [play = state.play] in
					do {
						try await playsDataProvider.save(play)
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
	}
}
