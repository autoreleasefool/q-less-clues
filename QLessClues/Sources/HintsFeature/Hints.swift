import ComposableArchitecture
import DictionaryLibrary
import SharedModelsLibrary

public struct Hints: ReducerProtocol {
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

	public enum Action: Equatable {
		case hintButtonTapped
	}

	public init() {}

	public var body: some ReducerProtocol<State, Action> {
		Reduce { state, action in
			switch action {
			case .hintButtonTapped:
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
