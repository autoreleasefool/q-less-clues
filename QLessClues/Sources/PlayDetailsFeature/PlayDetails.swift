import AnalysisFeature
import ComposableArchitecture
import Dependencies
import PlaysRepositoryInterface
import SharedModelsLibrary

@Reducer
public struct PlayDetails: Reducer {
	@ObservableState
	public struct State: Equatable {
		public var play: Play
		public var analysis = Analysis.State()

		@Presents public var alert: AlertState<DeletePlayAlertAction>?

		public init(play: Play) {
			self.play = play
			self.analysis.letters = play.letters
		}
	}

	public enum Action: ViewAction {
		@CasePathable public enum View {
			case didTapDeleteButton
		}

		@CasePathable public enum Internal {
			case deletedPlayResponse(Result<Void, Error>)

			case alert(PresentationAction<DeletePlayAlertAction>)
			case analysis(Analysis.Action)
		}

		case view(View)
		case `internal`(Internal)
	}

	public init() {}

	@Dependency(\.dismiss) var dismiss
	@Dependency(\.playsDataProvider) var playsDataProvider

	public var body: some ReducerOf<Self> {
		Scope(state: \.analysis, action: \.internal.analysis) {
			Analysis()
		}

		Reduce { state, action in
			switch action {
			case let .view(viewAction):
				switch viewAction {
				case .didTapDeleteButton:
					state.alert = deleteAlert
					return .none
				}

			case let .internal(internalAction):
				switch internalAction {
				case .deletedPlayResponse(.success):
					return .run { _ in await dismiss() }

				case .deletedPlayResponse(.failure):
					// TODO: handle errors
					return .none

				case .alert(.presented(.didTapDeleteButton)):
					state.alert = nil
					return .run { [play = state.play] send in
						await send(.internal(.deletedPlayResponse(Result {
							try await playsDataProvider.delete(play)
						})))
					}

				case .alert(.presented(.didTapCancelButton)), .alert(.dismiss):
					state.alert = nil
					return .none

				case .analysis(.view), .analysis(.binding), .analysis(.internal):
					return .none
				}
			}
		}
	}
}
