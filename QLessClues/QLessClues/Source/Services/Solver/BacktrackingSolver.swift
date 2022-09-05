//
//  BacktrackingSolver.swift
//  QLessClues
//
//  Created by Joseph Roque on 2022-09-05.
//

import Combine
import Foundation

class BacktrackingSolver: Solver {

	private let dispatchQueue = DispatchQueue(label: "BacktrackingSolver")

	func generateSolutions(fromLetters letters: String) -> AnyPublisher<Solution, Never> {
		let subject = PassthroughSubject<Solution, Never>()
		dispatchQueue.async { [weak self] in
			self?.generateSolutions(remainingLetters: letters, entries: [], subject: subject)
			subject.send(completion: .finished)
		}
		return subject.eraseToAnyPublisher()
	}

	private func generateSolutions(
		remainingLetters letters: String,
		entries: [Solution.Entry],
		subject: PassthroughSubject<Solution, Never>
	) {
		if letters.isEmpty {
			subject.send(Solution(entries: entries))
			return
		}

		fatalError("not implemented")
	}
}
