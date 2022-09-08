//
//  Solver.swift
//  QLessClues
//
//  Created by Joseph Roque on 2022-09-04.
//

import Combine
import Foundation

protocol Solver {
	func generateSolutions(fromLetters: String) -> (UUID, AnyPublisher<Solution, Never>)
	func cancelJob(id: UUID)
}
