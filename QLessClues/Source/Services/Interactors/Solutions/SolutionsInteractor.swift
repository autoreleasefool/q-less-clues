//
//  SolutionsInteractor.swift
//  QLessClues
//
//  Created by Joseph Roque on 2022-09-18.
//

import Combine
import Foundation

protocol SolutionsInteractor {
	func solutions(forLetters: String, solutions: LoadableSubject<[Solution]>)
}

struct SolutionsInteractorImpl: SolutionsInteractor {

	private let solver: GameSolver

	init(solver: GameSolver) {
		self.solver = solver
	}

	func solutions(forLetters letters: String, solutions: LoadableSubject<[Solution]>) {
		let cancelBag = CancelBag()
		solutions.wrappedValue.setIsLoading(cancelBag: cancelBag)

		var existingSolutions: Set<[String]> = []
		solver.solutions(forLetters: letters)
			.filter { !existingSolutions.contains($0.words) }
			.receive(on: DispatchQueue.main)
			.sink {
				if case let .failure(error) = $0 {
					solutions.wrappedValue = .failed(error)
				} else if let output = solutions.wrappedValue.value {
					solutions.wrappedValue = .loaded(output)
				}
			} receiveValue: {
				existingSolutions.insert($0.words)
				solutions.wrappedValue = .isLoading(last: (solutions.wrappedValue.value ?? []) + [$0], cancelBag: cancelBag)
			}
			.store(in: cancelBag)
	}
}

struct SolutionsInteractorStub: SolutionsInteractor {
	func solutions(forLetters: String, solutions: LoadableSubject<[Solution]>) {
		solutions.wrappedValue = .loaded([])
	}
}
