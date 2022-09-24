//
//  BacktrackingSolver.swift
//  QLessClues
//
//  Created by Joseph Roque on 2022-09-05.
//

import Combine
import Foundation

class BacktrackingSolver: GameSolver {

	private let validator: Validator

	private let queue = DispatchQueue(label: "BacktrackingSolver")
	private var queue_searchInProgress: State?

	init(validator: Validator = BasicValidator()) {
		self.validator = validator
	}

	func stop() {
		queue.async {
			self.queue_cancelSearchInProgress()
		}
	}

	func solutions(forLetters letters: String) -> AnyPublisher<Solution, SolverError> {
		queue.sync {
			self.queue_cancelSearchInProgress()
		}

		let solutionsSubject = PassthroughSubject<Solution, SolverError>()
		let progressSubject = CurrentValueSubject<Float, SolverError>(0)

		let state = State(
			solutionsSubject: solutionsSubject,
			progressSubject: progressSubject,
			initialLetters: letters
		)

		queue.sync {
			self.queue_searchInProgress = state
		}

		DispatchQueue.global().async { [weak self] in
			guard let self else { return }
			guard !letters.isEmpty else {
				self.stop()
				return
			}

			state.remainingLetters = LetterSet(letters: letters)
			state.wordSet = WordSet(letterSet: state.remainingLetters)

			self.generateSolutions(state: state)

			state.solutionsSubject.send(completion: .finished)
			state.progressSubject.send(completion: .finished)
		}

		return solutionsSubject.eraseToAnyPublisher()
	}

	func progress(forLetters letters: String) -> AnyPublisher<Float, SolverError> {
		var searchInProgress: State?
		queue.sync {
			searchInProgress = self.queue_searchInProgress
		}

		guard let searchInProgress, letters == searchInProgress.initialLetters else {
			return Just(1)
				.setFailureType(to: SolverError.self)
				.eraseToAnyPublisher()
		}

		let subject = searchInProgress.progressSubject

		return subject.eraseToAnyPublisher()
	}

	private func queue_cancelSearchInProgress() {
		queue_searchInProgress?.progressSubject.send(completion: .failure(.cancelled))
		queue_searchInProgress?.solutionsSubject.send(completion: .failure(.cancelled))
		queue_searchInProgress = nil
	}

	private func generateSolutions(state: State) {
		var searchInProgress: State?
		queue.sync {
			searchInProgress = queue_searchInProgress
		}

		guard state === searchInProgress else { return }

		if state.remainingLetters.isEmpty {
			let solution = Solution(board: state.board)
			if validator.validate(solution: solution) {
				state.solutionsSubject.send(solution)
			}
			return
		}

		if state.board.isEmpty {

			let firstWords = state.wordSet
				.limitBy(.containingLeastFrequentLetter)
				.limitBy(.mostPopular)
				.words

			print("Total first words: \(firstWords.count)")

			for (index, word) in firstWords.enumerated() {
				print("Solving with firstWord \(index)")
				insertFirstWord(word, in: state)
				state.remainingLetters.substract(letters: Array(word))
				// TODO: perf improvement - update wordset
				generateSolutions(state: state)
				state.remainingLetters.add(letters: Array(word))
				removeFirstWord(from: state)

				state.progressSubject.send(Float(index + 1) / Float(firstWords.count))
			}
			return
		}

		let expressions = enumerateRowsAndColumns(for: state)
		for word in state.wordSet.limitBy(.mostPopular).words {
			for rowColumn in expressions {
				guard word.firstMatch(of: rowColumn.regex) != nil else {
					continue
				}

				for lettersUsed in getInsertionsOf(word, at: rowColumn, in: state) {
					insert(lettersUsed, in: state)
					state.remainingLetters.substract(letters: lettersUsed.map { $0.letter })
					// TODO: perf improvement - update wordset
					generateSolutions(state: state)
					state.remainingLetters.add(letters: lettersUsed.map { $0.letter })
					remove(lettersUsed, in: state)
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
		in state: State
	) {
		for letter in letters {
			state.board[letter.position] = letter.letter
		}
	}

	private func remove(
		_ letters: [LetterPosition],
		in state: State
	) {
		for letter in letters {
			state.board[letter.position] = nil
		}
	}

	private func insertFirstWord(_ word: String, in state: State) {
		for (index, letter) in word.enumerated() {
			state.board[Position(0, index)] = letter
		}
	}

	private func removeFirstWord(from state: State) {
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
	class State {
		let solutionsSubject: PassthroughSubject<Solution, SolverError>
		let progressSubject: CurrentValueSubject<Float, SolverError>

		let initialLetters: String

		var board: [Position: Character] = [:]
		var remainingLetters: LetterSet!
		var wordSet: WordSet!

		init(
			solutionsSubject: PassthroughSubject<Solution, SolverError>,
			progressSubject: CurrentValueSubject<Float, SolverError>,
			initialLetters: String
		) {
			self.solutionsSubject = solutionsSubject
			self.progressSubject = progressSubject
			self.initialLetters = initialLetters
		}
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
