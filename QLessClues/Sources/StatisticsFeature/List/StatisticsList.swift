import ComposableArchitecture
import SharedModelsLibrary

public struct StatisticsList: ReducerProtocol {
	public struct State: Equatable {
		public var gamesPlayed: IdentifiedArrayOf<LetterPlayCount> = []
		public var selection: Identified<String, DetailedStatistics.State>?

		public init() {}
	}

	public enum Action: Equatable {
		case subscribeToCounts
		case countsResponse([LetterPlayCount])
		case setNavigation(selection: String?)
		case detailedStatistics(DetailedStatistics.Action)
	}

	public init() {}

	@Dependency(\.statisticsDataProvider) var statisticsDataProvider

	public var body: some ReducerProtocol<State, Action> {
		Reduce { state, action in
			switch action {
			case .subscribeToCounts:
				return .run { send in
					for try await counts in statisticsDataProvider.fetchCounts() {
						await send(.countsResponse(counts))
					}
				}

			case let .countsResponse(counts):
				state.gamesPlayed = .init(uniqueElements: counts)
				return .none

			case let .setNavigation(selection: .some(letter)):
				state.selection = Identified(.init(letter: letter), id: letter)
				return .none

			case .setNavigation(selection: .none):
				state.selection = nil
				return .none

			case .detailedStatistics:
				return .none
			}
		}
//		.ifLet(\.selection, action: /StatisticsList.Action.detailedStatistics) {
//			Scope(state: \Identified<String, DetailedStatistics.State>.value, action: /.self) {
//				DetailedStatistics()
//			}
//		}
	}
}
