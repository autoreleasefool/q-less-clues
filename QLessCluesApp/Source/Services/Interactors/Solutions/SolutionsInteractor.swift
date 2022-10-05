//
//  SolutionsInteractor.swift
//  QLessClues
//
//  Created by Joseph Roque on 2022-09-18.
//

import Combine
import Foundation
import NetworkingService
import SharedModelsLibrary

protocol SolutionsInteractor {
	func solutions(forLetters: String, solutions: LoadableSubject<[Solution]>, progress: LoadableSubject<Float>?)
	func cancel()
}

struct SolutionsInteractorImpl: SolutionsInteractor {

	private let solver: GameSolver

	init(solver: GameSolver) {
		self.solver = solver
	}

	func cancel() {
		solver.stop()
	}

	func solutions(
		forLetters letters: String,
		solutions: LoadableSubject<[Solution]>,
		progress: LoadableSubject<Float>? = nil
	) {
		let cancelBag = CancelBag()

		startSolver(forLetters: letters, solutions: solutions, cancelBag: cancelBag)

		guard let progress else { return }

		trackProgress(forLetters: letters, progress: progress, cancelBag: cancelBag)
	}

	private func startSolver(forLetters letters: String, solutions: LoadableSubject<[Solution]>, cancelBag: CancelBag) {
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

	private func trackProgress(forLetters letters: String, progress: LoadableSubject<Float>, cancelBag: CancelBag) {
		progress.wrappedValue.setIsLoading(cancelBag: cancelBag)

		solver.progress(forLetters: letters)
			.receive(on: DispatchQueue.main)
			.sink {
				if case let .failure(error) = $0 {
					progress.wrappedValue = .failed(error)
				} else {
					progress.wrappedValue = .loaded(1)
				}
			} receiveValue: {
				progress.wrappedValue = .isLoading(last: $0, cancelBag: cancelBag)
			}
			.store(in: cancelBag)
	}
}

struct SolutionsInteractorStub: SolutionsInteractor {
	func solutions(forLetters: String, solutions: LoadableSubject<[Solution]>, progress: LoadableSubject<Float>? = nil) {
		solutions.wrappedValue = .loaded([])
		progress?.wrappedValue = .loaded(1)
	}

	func cancel() {}
}
