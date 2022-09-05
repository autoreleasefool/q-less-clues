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
		dispatchQueue.async {
			// TODO: generate solution
			subject.send(completion: .finished)
		}
		return subject.eraseToAnyPublisher()
	}
}
