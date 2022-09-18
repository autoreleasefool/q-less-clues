//
//  Solver.swift
//  QLessClues
//
//  Created by Joseph Roque on 2022-09-04.
//

import Combine
import Foundation

protocol SolutionGenerator {
	var solutions: AnyPublisher<Solution, Never> { get }
	var letters: String { get set }
}
