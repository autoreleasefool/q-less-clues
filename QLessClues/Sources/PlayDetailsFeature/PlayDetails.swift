import AnalysisFeature
import ComposableArchitecture
import Dependencies
import PlaysDataProviderInterface
import SharedModelsLibrary

public struct PlayDetails: ReducerProtocol {
	public struct State: Equatable {
		public var play: Play
		public var deleteAlert: AlertState<DeletePlayAlertAction>?
		public var analysis = Analysis.State()

		public init(play: Play) {
			self.play = play
			self.analysis.letters = play.letters
		}
	}

	public enum Action: Equatable {
		case alert(DeletePlayAlertAction)
		case deleteButtonTapped
		case analysis(Analysis.Action)
		case playDeleted
	}

	public init() {}

	@Dependency(\.playsDataProvider) var playsDataProvider

	public var body: some ReducerProtocol<State, Action> {
		Scope(state: \.analysis, action: /PlayDetails.Action.analysis) {
			Analysis()
		}

		Reduce { state, action in
			switch action {
			case .alert(.nevermindButtonTapped), .alert(.dismissed):
				state.deleteAlert = nil
				return .none

			case .alert(.deleteButtonTapped):
				state.deleteAlert = nil
				return .task { [play = state.play] in
					try await playsDataProvider.delete(play)
					return .playDeleted
				}

			case .playDeleted:
				return .none

			case .deleteButtonTapped:
				state.deleteAlert = deleteAlert
				return .none

			case .analysis:
				return .none
			}
		}
	}
}
