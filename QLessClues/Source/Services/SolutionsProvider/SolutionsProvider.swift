//
//  SolutionsProvider.swift
//  QLessClues
//
//  Created by Joseph Roque on 2022-09-17.
//

import Combine
import Foundation

final class SolutionsProvider: ObservableObject {

	@Published var solutions: [Solution] = []
	@Published var isRunning = false
	private var solutionWords: Set<[String]> = []

	private var generator: SolutionGenerator
	private var cancellable: AnyCancellable?

	init(generator: SolutionGenerator) {
		self.generator = generator
	}

	func solve(letters: String) {
		cancel()

		isRunning = true
		generator.letters = letters
		cancellable = generator.solutions
			.receive(on: DispatchQueue.main)
			.filter { !self.solutionWords.contains($0.words) }
			.sink { _ in
				self.isRunning = false
			} receiveValue: {
				self.solutionWords.insert($0.words)
				self.solutions.append($0)
			}
	}

	func cancel() {
		cancellable?.cancel()
		solutions.removeAll()
		generator.letters = ""
		isRunning = false
	}
}
