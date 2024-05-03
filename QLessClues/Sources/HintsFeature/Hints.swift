import ComposableArchitecture
import DictionaryLibrary
import SharedModelsLibrary

@Reducer
public struct Hints: Reducer {
	@ObservableState
	public struct State: Equatable {
		public var solution: Solution?
		public var hints: [String] = []

		public var hasMoreHints: Bool {
			(solution?.words.count ?? 0) - hints.count > 1
		}

		public init(solutions: [Solution]) {
			self.solution = solutions.last
			// TODO: mock WordFrequency bundle so tests can run
//			.map { (solution: $0, freq: WordFrequency(words: Set($0.words))) }
//			.sorted { $0.freq.totalFrequency < $1.freq.totalFrequency }
		}
	}

	public enum Action: ViewAction {
		@CasePathable public enum View {
			case didTapHintButton
		}

		case view(View)
	}

	public init() {}

	public var body: some ReducerOf<Self> {
		Reduce { state, action in
			switch action {
			case let .view(viewAction):
				switch viewAction {
				case .didTapHintButton:
					guard let solution = state.solution,
								state.hasMoreHints,
								let hint = Set(solution.words).subtracting(state.hints).sorted().first
					else {
						return .none
					}

					state.hints.append(hint)
					return .none
				}
			}
		}
	}
}
