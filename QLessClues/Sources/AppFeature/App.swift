import ComposableArchitecture
import DictionaryLibrary
import PlaysListFeature

@Reducer
public struct App: Reducer {
	@ObservableState
	public struct State: Equatable {
		public var playsList = PlaysList.State()

		public init() {}
	}

	public enum Action: ViewAction {
		@CasePathable public enum View {
			case onAppear
		}
		@CasePathable public enum Internal {
			case playsList(PlaysList.Action)
		}

		case view(View)
		case `internal`(Internal)
	}

	public init() {}

	public var body: some ReducerOf<Self> {
		Scope(state: \.playsList, action: \.internal.playsList) {
			PlaysList()
		}

		Reduce<State, Action> { _, action in
			switch action {
			case let .view(viewAction):
				switch viewAction {
				case .onAppear:
					return .run { _ in

//						_ = WordSet.englishSet
//						_ = WordFrequency.englishFrequencies
					}
				}

			case let .internal(internalAction):
				switch internalAction {
				case .playsList(.view), .playsList(.internal):
					return .none
				}
			}
		}
	}
}
