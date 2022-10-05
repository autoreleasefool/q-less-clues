//
//  GameSolver.swift
//  QLessClues
//
//  Created by Joseph Roque on 2022-09-04.
//

import Combine
import Foundation
import SharedModelsLibrary

enum SolverError: Error {
	case cancelled
}

protocol GameSolver {
	func solutions(forLetters: String) -> AnyPublisher<Solution, SolverError>
	func progress(forLetters: String) -> AnyPublisher<Float, SolverError>
	func stop()
}
