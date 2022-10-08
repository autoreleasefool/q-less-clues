import ComposableArchitecture
import DictionaryLibrary
import SharedModelsLibrary

public struct HintsState: Equatable {
	public var solution: Solution?
	public var hints: [String] = []

	public init(solutions: [Solution]) {
		self.solution = solutions
			// TODO: mock WordFrequency bundle so tests can run
//			.map { (solution: $0, freq: WordFrequency(words: Set($0.words))) }
//			.sorted { $0.freq.totalFrequency < $1.freq.totalFrequency }
			.last
	}

	public var hasMoreHints: Bool {
		(solution?.words.count ?? 0) - hints.count > 1
	}
}

public enum HintsAction: Equatable {
	case hintButtonTapped
}

public struct HintsEnvironment: Sendable {
	public init() {}
}

public let hintsReducer = Reducer<HintsState, HintsAction, HintsEnvironment> { state, action, _ in
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
