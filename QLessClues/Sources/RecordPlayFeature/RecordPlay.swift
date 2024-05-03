import AnalysisFeature
import ComposableArchitecture
import Foundation
import PlayDetailsFeature
import PlaysRepositoryInterface
import SharedModelsLibrary
import SolverServiceInterface

@Reducer
public struct RecordPlay: Reducer {
	@ObservableState
	public struct State: Equatable {
		public var letters = ""
		public var date = Date()
		public var outcome: Play.Outcome = .unsolved
		public var analysis = Analysis.State()

		public var play: Play {
			.init(id: UUID(), createdAt: date, letters: letters, outcome: outcome, difficulty: nil)
		}

		var isPlayable: Bool {
			letters.count == 12
		}

		public init() {}
	}

	public enum Action: ViewAction, BindableAction {
		@CasePathable public enum View {
			case didTapSaveButton
		}
		@CasePathable public enum Internal {
			case savedPlayResponse(Result<Void, Error>)
			case analysis(Analysis.Action)
		}

		case view(View)
		case `internal`(Internal)
		case binding(BindingAction<State>)
	}

	public init() {}

	@Dependency(\.dismiss) var dismiss
	@Dependency(\.playsDataProvider) var playsDataProvider

	public var body: some ReducerOf<Self> {
		BindingReducer()

		Scope(state: \.analysis, action: \.internal.analysis) {
			Analysis()
		}

		Reduce { state, action in
			switch action {
			case let .view(viewAction):
				switch viewAction {
				case .didTapSaveButton:
					return .run { [play = state.play] send in
						await send(.internal(.savedPlayResponse(Result {
							try await playsDataProvider.save(play)
						})))
					}
				}

			case let .internal(internalAction):
				switch internalAction {
				case .savedPlayResponse(.success):
					return .run { _ in await dismiss() }

				case .savedPlayResponse(.failure):
					// TODO: Error handling
					return .none

				case .analysis(.binding), .analysis(.view), .analysis(.internal):
					return .none
				}

			case .binding(\.letters):
				state.letters = String(state.letters.uppercased().prefix(12))
				// TODO: Used @Shared for letters?
				state.analysis.letters = state.letters
				return .none

			case .binding:
				return .none
			}
		}
	}
}
