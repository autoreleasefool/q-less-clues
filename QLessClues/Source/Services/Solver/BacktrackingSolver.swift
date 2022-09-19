//
//  BacktrackingSolver.swift
//  QLessClues
//
//  Created by Joseph Roque on 2022-09-05.
//

import Combine
import Foundation

class BacktrackingSolver: GameSolver {

	private var subject: PassthroughSubject<Solution, SolverError>?

	private let dispatchQueue = DispatchQueue(label: "BacktrackingSolver")
	private let validator: Validator

	init(validator: Validator = BasicValidator()) {
		self.validator = validator
	}

	func solutions(forLetters letters: String) -> AnyPublisher<Solution, SolverError> {
		subject?.send(completion: .failure(.cancelled))
		let newSubject = PassthroughSubject<Solution, SolverError>()
		self.subject = newSubject

		DispatchQueue.main.async {
			self.generateSolutions(fromLetters: letters, to: newSubject)
		}

		return newSubject
			.filter { [weak self] _ in self?.subject === newSubject }
			.eraseToAnyPublisher()
	}

	private func generateSolutions(fromLetters letters: String, to subject: any Subject<Solution, SolverError>) {
		guard !letters.isEmpty else {
			subject.send(completion: .finished)
			return
		}

		dispatchQueue.async { [weak self] in
			guard let self else { return }
			let letterSet = LetterSet(letters: letters)
			let wordSet = WordSet(letterSet: letterSet)

			var state = State(initialLetters: letters, remainingLetters: letterSet, wordSet: wordSet, board: [:])

			self.generateSolutions(state: &state, to: subject)
			subject.send(completion: .finished)
		}
	}

	private func generateSolutions(state: inout State, to subject: any Subject<Solution, SolverError>) {
		guard subject === self.subject else { return }

		if state.remainingLetters.isEmpty {
			let solution = Solution(board: state.board)
			if validator.validate(solution: solution) {
				subject.send(solution)
			}
			return
		}

		if state.board.isEmpty {
			for word in state.wordSet.limitBy(.containingLeastFrequentLetter).limitBy(.mostPopular).words {
				insertFirstWord(word, in: &state)
				state.remainingLetters.substract(letters: Array(word))
				// TODO: perf improvement - update wordset
				generateSolutions(state: &state, to: subject)
				state.remainingLetters.add(letters: Array(word))
				removeFirstWord(from: &state)
			}
			return
		}

		let expressions = enumerateRowsAndColumns(for: state)
		for word in state.wordSet.limitBy(.mostPopular).words {
			for rowColumn in expressions {
				guard word.firstMatch(of: rowColumn.regex) != nil else {
					continue
				}

				for lettersUsed in getInsertionsOf(word, at: rowColumn, in: &state) {
					insert(lettersUsed, in: &state)
					state.remainingLetters.substract(letters: lettersUsed.map { $0.letter })
					// TODO: perf improvement - update wordset
					generateSolutions(state: &state, to: subject)
					state.remainingLetters.add(letters: lettersUsed.map { $0.letter })
					remove(lettersUsed, in: &state)
				}
			}
		}
	}

	private func getInsertionsOf(
		_ word: String,
		at rowColumn: RowColumn,
		in state: inout State
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
					lettersUsed.append(LetterPosition(letter: letter, position: position))
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

	private func insert(
		_ letters: [LetterPosition],
		in state: inout State
	) {
		for letter in letters {
			state.board[letter.position] = letter.letter
		}
	}

	private func remove(
		_ letters: [LetterPosition],
		in state: inout State
	) {
		for letter in letters {
			state.board[letter.position] = nil
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

private extension BacktrackingSolver {
	struct State {
		let initialLetters: String
		var remainingLetters: LetterSet
		var wordSet: WordSet
		var board: [Position: Character]
	}
}

private extension BacktrackingSolver {
	struct RowColumn {
		let direction: Direction
		let index: Int
		let regex: Regex<AnyRegexOutput>
	}
}

private extension BacktrackingSolver {
	struct LetterPosition: CustomStringConvertible {
		let letter: Character
		let position: Position

		var description: String {
			"(\(position), \(letter))"
		}
	}
}
