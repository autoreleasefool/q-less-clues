import ComposableArchitecture
import SharedModelsLibrary

@Reducer
public struct StatisticsList: Reducer {
	@ObservableState
	public struct State: Equatable {
		public var gamesPlayed: IdentifiedArrayOf<LetterPlayCount> = []

		@Presents public var destination: Destination.State?

		public init() {}
	}

	public enum Action: ViewAction {
		@CasePathable public enum View {
			case task
			case didTapGame(LetterPlayCount.ID)
		}
		@CasePathable public enum Internal {
			case didReceiveCounts(Result<[LetterPlayCount], Error>)
			case destination(PresentationAction<Destination.Action>)
		}

		case view(View)
		case `internal`(Internal)
	}

	@Reducer(state: .equatable)
	public enum Destination {
		case details(DetailedStatistics)
	}

	public init() {}

	@Dependency(\.statistics) var statistics

	public var body: some ReducerOf<Self> {
		Reduce { state, action in
			switch action {
			case let .view(viewAction):
				switch viewAction {
				case .task:
					return .run { send in
						for try await counts in statistics.fetchCounts() {
							await send(.internal(.didReceiveCounts(.success(counts))))
						}
					} catch: { error, send in
						await send(.internal(.didReceiveCounts(.failure(error))))
					}

				case let .didTapGame(id):
					state.destination = .details(.init(letter: id))
					return .none
				}

			case let .internal(internalAction):
				switch internalAction {
				case let .didReceiveCounts(.success(counts)):
					state.gamesPlayed = .init(uniqueElements: counts)
					return .none

				case .didReceiveCounts(.failure):
					// TODO: Error handling
					return .none

				case .destination(.dismiss),
						.destination(.presented(.details(.internal))), .destination(.presented(.details(.view))):
					return .none
				}
			}
		}
		.ifLet(\.$destination, action: \.internal.destination)
	}
}
