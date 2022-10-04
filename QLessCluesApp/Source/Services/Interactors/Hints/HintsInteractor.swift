//
//  HintsInteractor.swift
//  QLessClues
//
//  Created by Joseph Roque on 2022-09-24.
//

import DictionaryLibrary
import Foundation

enum HintsError: Error {
	case noSolutions
}

protocol HintsInteractor {
	func receiveHint(from solutions: [Solution], hint: LoadableSubject<Hint>)
}

struct HintsInteractorImpl: HintsInteractor {
	func receiveHint(from solutions: [Solution], hint: LoadableSubject<Hint>) {
		DispatchQueue.global().async {
			self.determineHint(from: solutions, hint: hint)
		}
	}

	private func determineHint(from solutions: [Solution], hint: LoadableSubject<Hint>) {
		var result: Loadable<Hint> = .notRequested
		defer {
			DispatchQueue.main.async {
				hint.wrappedValue = result
			}
		}

		let hintableSolution = hint.wrappedValue.value?.solution ?? chooseSolution(from: solutions)

		guard let solution = hintableSolution else {
			result = .failed(HintsError.noSolutions)
			return
		}

		result = selectHint(from: solution, withExistingHints: hint.wrappedValue.value?.words)
	}

	private func chooseSolution(from solutions: [Solution]) -> Solution? {
		solutions
			.map { (solution: $0, frequency: WordFrequency(words: $0.words)) }
			.sorted { $0.frequency.totalFrequency < $1.frequency.totalFrequency }
			.reversed()
			.first?.solution
	}

	private func selectHint(from solution: Solution, withExistingHints: [String]?) -> Loadable<Hint> {
		let hints = withExistingHints ?? []

		// There aren't enough words remaining in the solution to give as hints
		if hints.count >= solution.words.count - 1 {
			return .loaded(Hint(solution: solution, words: hints))
		}

		guard let nextHint = Set(solution.words).subtracting(hints).randomElement() else {
			return .loaded(Hint(solution: solution, words: hints))
		}

		return .loaded(Hint(solution: solution, words: hints + [nextHint]))
	}
}

struct HintsInteractorStub: HintsInteractor {
	func receiveHint(from solutions: [Solution], hint: LoadableSubject<Hint>) {
		guard let solution = solutions.first, let word = solution.words.first else {
			hint.wrappedValue = .failed(HintsError.noSolutions)
			return
		}

		hint.wrappedValue = .loaded(Hint(solution: solution, words: [word]))
	}
}
