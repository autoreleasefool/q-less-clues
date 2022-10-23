import ComposableArchitecture
import DictionaryLibrary
import PlaysListFeature
import PlaysDataProviderInterface
import SolverServiceInterface
import StatisticsDataProviderInterface

public struct App: ReducerProtocol {
	public struct State: Equatable {
		public var playsList = PlaysList.State()

		public init() {}
	}

	public enum Action: Equatable {
		case onAppear
		case playsList(PlaysList.Action)
	}

	public init() {}

	public var body: some ReducerProtocol<State, Action> {
		Scope(state: \.playsList, action: /App.Action.playsList) {
			PlaysList()
		}

		Reduce { state, action in
			switch action {
			case .onAppear:
				return .fireAndForget {
					_ = WordSet.englishSet
					_ = WordFrequency.englishFrequencies
				}

			case .playsList:
				return .none
			}
		}
	}
}
