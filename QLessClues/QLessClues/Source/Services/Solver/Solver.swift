//
//  Solver.swift
//  QLessClues
//
//  Created by Joseph Roque on 2022-09-04.
//

import Combine

protocol Solver {
	func generateSolutions(fromLetters: String) -> AnyPublisher<Solution, Never>
}
