import ComposableArchitecture
import SharedModelsLibrary
import StatisticsDataProviderInterface

public struct DetailedStatistics: ReducerProtocol {
	public struct State: Equatable {
		public var letter: String
		public var statistics: Statistics?

		public init(letter: String) {
			self.letter = letter
		}
	}

	public enum Action: Equatable {
		case subscribeToStatistics
		case statisticsResponse(Statistics)
	}

	public init() {}

	@Dependency(\.statisticsDataProvider) var statisticsDataProvider

	public var body: some ReducerProtocol<State, Action> {
		Reduce { state, action in
			switch action {
			case .subscribeToStatistics:
				return .run { [letter = state.letter] send in
					for try await statistics in statisticsDataProvider.fetch(.init(letter: letter)) {
						await send(.statisticsResponse(statistics))
					}
				}

			case let .statisticsResponse(statistics):
				state.statistics = statistics
				return .none
			}
		}
	}
}
