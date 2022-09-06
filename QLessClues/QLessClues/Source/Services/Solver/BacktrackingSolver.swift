//
//  BacktrackingSolver.swift
//  QLessClues
//
//  Created by Joseph Roque on 2022-09-05.
//

import Combine
import Foundation

class BacktrackingSolver: Solver {

	typealias SolutionSubject = PassthroughSubject<Solution, Never>

	private let dispatchQueue = DispatchQueue(label: "BacktrackingSolver")
	private let validator: Validator

	init(validator: Validator) {
		self.validator = validator
	}

	func generateSolutions(fromLetters letters: String) -> AnyPublisher<Solution, Never> {
		let subject = SolutionSubject()
		dispatchQueue.async { [weak self] in
			var letterSet = LetterSet(letters: letters)
			var wordSet = WordSet(letterSet: letterSet)
			var board: [Position: String] = [:]
			self?.generateSolutions(remainingLetters: &letterSet, board: &board, wordSet: &wordSet, subject: subject)
			subject.send(completion: .finished)
		}
		return subject.eraseToAnyPublisher()
	}

	private func generateSolutions(
		remainingLetters: inout LetterSet,
		board: inout [Position: String],
		wordSet: inout WordSet,
		subject: SolutionSubject
	) {
		if remainingLetters.isEmpty {
			let solution = Solution(board: board)
			subject.send(solution)
			return
		}

		for word in wordSet.words {
			for position in positions(for: word, in: board) {
				let lettersUsed = insert(word, at: position, in: &board)
				remainingLetters.substract(letters: lettersUsed)
				// TODO: updateWordSet
//				generateSolutions(fromLetters: )
				remainingLetters.add(letters: lettersUsed)
				remove(word, from: position, in: &board)
			}
		}
	}

	private func positions(for word: String, in board: [Position: String]) -> [Position] {
		fatalError("not implemented")
	}

	private func insert(_ word: String, at position: Position, in board: inout [Position: String]) -> String {
		fatalError("not implemented")
	}

	private func remove(_ word: String, from position: Position, in board: inout [Position: String]) {
		fatalError("not implemented")
	}
}
