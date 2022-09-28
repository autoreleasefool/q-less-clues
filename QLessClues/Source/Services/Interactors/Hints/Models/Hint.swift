//
//  Hint.swift
//  QLessClues
//
//  Created by Joseph Roque on 2022-09-25.
//

import Foundation

struct Hint {
	let solution: Solution
	let words: [String]

	var moreHintsAvailable: Bool {
		Set(solution.words).subtracting(words).count > 1
	}
}
