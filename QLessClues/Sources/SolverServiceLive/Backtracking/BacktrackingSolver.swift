import DictionaryLibrary
import SharedModelsLibrary
import SolverServiceInterface
import ValidatorServiceInterface

struct BacktrackingSolver {
	private let validator: ValidatorService

	init(validator: ValidatorService) {
		self.validator = validator
	}

	func findSolutions(forLetters letters: String, to continuation: AsyncStream<SolverService.Event>.Continuation) async {
		guard !letters.isEmpty else {
			continuation.finish()
			return
		}

		var state = State(initialLetters: letters, continuation: continuation)

		continuation.yield(.progress(0))
		await generateSolutions(state: &state)

		continuation.finish()
	}

	private func generateSolutions(state: inout State) async {
		if state.remainingLetters.isEmpty {
			let solution = Solution(board: state.board)
			if await validator.validate(solution, WordSet.englishSet) {
				state.continuation.yield(.solution(solution))
			}
			return
		}

		if state.board.isEmpty {
			await generateWithFirstWord(state: &state)
		} else {
			await generateWithRemainingWords(state: &state)
		}
	}

	private func generateWithFirstWord(state: inout State) async {
		let firstWords = state.wordSet
			.limitBy(.containingLeastFrequentLetter)
			.limitBy(.mostPopular)
			.words

		print("Total first words: \(firstWords.count), \(firstWords)")

		for (index, word) in firstWords.enumerated() {
			print("Solving with firstWord \(index)")

			insertFirstWord(word, in: &state)
			state.remainingLetters.substract(letters: Array(word))
			// TODO: perf improvement - update wordset
			await generateSolutions(state: &state)
			state.remainingLetters.add(letters: Array(word))
			removeFirstWord(from: &state)

			state.continuation.yield(.progress(Double(index + 1) / Double(firstWords.count)))
		}
	}

	private func insertFirstWord(_ word: String, in state: inout State) {
		for (index, letter) in word.enumerated() {
			state.board[Position(0, index)] = letter
		}
	}

	private func removeFirstWord(from state: inout State) {
		state.board.removeAll()
	}

	private func generateWithRemainingWords(state: inout State) async {
		let expressions = enumerateRowsAndColumns(for: state)

		for word in state.wordSet.limitBy(.mostPopular).words {
			for rowColumn in expressions {
				guard word.firstMatch(of: rowColumn.regex) != nil else {
					continue
				}

				for lettersUsed in getInsertionsOf(word, at: rowColumn, in: state) {
					insert(lettersUsed, in: &state)
					state.remainingLetters.substract(letters: lettersUsed.map { $0.letter })
					// TODO: perf improvement - update wordset
					await generateSolutions(state: &state)
					state.remainingLetters.add(letters: lettersUsed.map { $0.letter })
					remove(lettersUsed, in: &state)
				}
			}
		}
	}

	private func getInsertionsOf(
		_ word: String,
		at rowColumn: RowColumn,
		in state: State
	) -> [[LetterPosition]] {
		var insertions: [[LetterPosition]] = []
		let minStartPosition: Int
		let maxStartPosition: Int

		switch rowColumn.direction {
		case .horizontal:
			let columns = state.board.columns
			minStartPosition = columns.lowerBound - (word.count - 1)
			maxStartPosition = columns.upperBound
		case .vertical:
			let rows = state.board.rows
			minStartPosition = rows.lowerBound - (word.count - 1)
			maxStartPosition = rows.upperBound
		}

		for startPosition in minStartPosition...maxStartPosition {
			var counts = state.remainingLetters.counts
			var lettersUsed: [LetterPosition] = []
			var isValid = true
			for wordPosition in startPosition..<(startPosition + word.count) {
				let index = wordPosition - startPosition
				let position = rowColumn.direction == .horizontal
					? Position(rowColumn.index, wordPosition)
					: Position(wordPosition, rowColumn.index)

				let letter = word[word.index(word.startIndex, offsetBy: index)]
				if state.board[position] == nil {
					lettersUsed.append(LetterPosition(letter, position))
					if counts[letter]! > 0 {
						counts[letter] = counts[letter]! - 1
					} else {
						isValid = false
						break
					}
				} else if state.board[position] != letter {
					isValid = false
					break
				}
			}

			if !lettersUsed.isEmpty && isValid {
				insertions.append(lettersUsed)
			}
		}

		return insertions
	}

	private func insert(_ letters: [LetterPosition], in state: inout State) {
		for letter in letters {
			state.board[letter.position] = letter.letter
		}
	}

	private func remove(_ letters: [LetterPosition], in state: inout State) {
		for letter in letters {
			state.board[letter.position] = nil
		}
	}

	private func enumerateRowsAndColumns(for state: State) -> [RowColumn] {
		var output: [RowColumn] = []
		let letters = state.remainingLetters.letters.map { String($0) }
		let letterGroup = "[\(letters.joined())]*"

		for row in state.board.rows {
			var rawRegex = "\(letterGroup)"
			for column in state.board.columns {
				if let letter = state.board[Position(row, column)] {
					rawRegex += "\(letter)\(letterGroup)"
				}
			}

			if let regex = try? Regex(rawRegex) {
				output.append(RowColumn(direction: .horizontal, index: row, regex: regex))
			}
		}

		for column in state.board.columns {
			var rawRegex = "\(letterGroup)"
			for row in state.board.rows {
				if let letter = state.board[Position(row, column)] {
					rawRegex += "\(letter)\(letterGroup)"
				}
			}

			if let regex = try? Regex(rawRegex) {
				output.append(RowColumn(direction: .vertical, index: column, regex: regex))
			}
		}

		return output
	}
}
