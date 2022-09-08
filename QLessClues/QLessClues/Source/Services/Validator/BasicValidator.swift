//
//  BasicValidator.swift
//  QLessClues
//
//  Created by Joseph Roque on 2022-09-05.
//

import Foundation

class BasicValidator: Validator {
	private let englishWords = Set(WordSet.englishSet.words)

	func validate(solution: Solution) -> Bool {
		return solution.words.allSatisfy { englishWords.contains($0) }
	}
}
