import Combine
import DictionaryLibrary
import SharedModelsLibrary
import SolverServiceInterface

extension BacktrackingSolver {
	struct State {
		let initialLetters: String
		let continuation: AsyncStream<SolverService.Event>.Continuation

		var board: [Position: Character] = [:]
		var remainingLetters: LetterSet
		var wordSet: WordSet

		init(initialLetters: String, continuation: AsyncStream<SolverService.Event>.Continuation) {
			self.initialLetters = initialLetters
			self.continuation = continuation
			let remainingLetters = LetterSet(letters: initialLetters)
			self.remainingLetters = remainingLetters
			self.wordSet = WordSet(letterSet: remainingLetters)
		}
	}
}

extension BacktrackingSolver {
	struct RowColumn {
		let direction: Direction
		let index: Int
		let regex: Regex<AnyRegexOutput>
	}
}

extension BacktrackingSolver {
	struct LetterPosition {
		let letter: Character
		let position: Position

		init(_ letter: Character, _ position: Position) {
			self.letter = letter
			self.position = position
		}
	}
}
