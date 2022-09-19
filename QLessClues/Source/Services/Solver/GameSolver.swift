//
//  GameSolver.swift
//  QLessClues
//
//  Created by Joseph Roque on 2022-09-04.
//

import Combine
import Foundation

enum SolverError: Error {
	case cancelled
}

protocol GameSolver {
	func solutions(forLetters: String) -> AnyPublisher<Solution, SolverError>
}
