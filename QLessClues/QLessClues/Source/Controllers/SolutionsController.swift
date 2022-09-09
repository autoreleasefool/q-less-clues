//
//  SolutionsController.swift
//  QLessClues
//
//  Created by Joseph Roque on 2022-09-07.
//

import Combine
import Foundation

final class SolutionsController: ObservableObject {

	private var currentJob: UUID?
	@Published var isRunning = false
	@Published var solutions: [Solution] = []
	private var solutionsGenerated: Set<[String]> = []

	private let solver: Solver

	private var cancellables: [AnyCancellable] = []

	init(solver: Solver = BacktrackingSolver(validator: BasicValidator())) {
		self.solver = solver
	}

	func generateSolutions(fromLetters letters: String) {
		cancel()

		isRunning = true
		let (id, publisher) = solver.generateSolutions(fromLetters: letters)
		currentJob = id
		publisher
			.receive(on: DispatchQueue.main)
			.filter { !self.solutionsGenerated.contains($0.words) }
			.sink(receiveCompletion: { _ in
				self.isRunning = false
			}, receiveValue: {
				self.solutionsGenerated.insert($0.words)
				self.solutions.append($0)
			})
			.store(in: &cancellables)
	}

	func cancel() {
		isRunning = false
		solutions.removeAll()
		solutionsGenerated.removeAll()
		cancellables.removeAll()

		if let currentJob {
			solver.cancelJob(id: currentJob)
			self.currentJob = nil
		}
	}
}
