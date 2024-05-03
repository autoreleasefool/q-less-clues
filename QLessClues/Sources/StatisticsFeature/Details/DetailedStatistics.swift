import ComposableArchitecture
import SharedModelsLibrary
import StatisticsRepositoryInterface

@Reducer
public struct DetailedStatistics: Reducer {
	@ObservableState
	public struct State: Equatable {
		public var letter: String
		public var statistics: Statistics?

		public init(letter: String) {
			self.letter = letter
		}
	}

	public enum Action: ViewAction {
		@CasePathable public enum View {
			case task
		}
		@CasePathable public enum Internal {
			case didReceiveStatistics(Result<Statistics, Error>)
		}

		case view(View)
		case `internal`(Internal)
	}

	public init() {}

	@Dependency(\.statisticsDataProvider) var statisticsDataProvider

	public var body: some ReducerOf<Self> {
		Reduce { state, action in
			switch action {
			case let .view(viewAction):
				switch viewAction {
				case .task:
					return .run { [letter = state.letter] send in
						for try await statistics in statisticsDataProvider.fetch(.init(letter: letter)) {
							await send(.internal(.didReceiveStatistics(.success(statistics))))
						}
					} catch: { error, send in
						await send(.internal(.didReceiveStatistics(.failure(error))))
					}
				}

			case let .internal(internalAction):
				switch internalAction {
				case let .didReceiveStatistics(.success(statistics)):
					state.statistics = statistics
					return .none

				case .didReceiveStatistics(.failure):
					// TODO: Error handling
					return .none
				}
			}
		}
	}
}
