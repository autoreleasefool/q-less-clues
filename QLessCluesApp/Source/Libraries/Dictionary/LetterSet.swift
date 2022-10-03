//
//  LetterSet.swift
//  QLessClues
//
//  Created by Joseph Roque on 2022-09-05.
//

import Foundation

struct LetterSet {

	static let fullAlphabet = LetterSet(letters: Array(repeating: "ABCDEFGHIJKLMNOPQRSTUVWXYZ", count: 3).joined())

	private var characterCounts: [Character: Int]

	var letters: [Character] {
		characterCounts
			.filter { $0.value > 0 }
			.map { Array(repeating: $0.key, count: $0.value) }
			.flatMap { $0 }
	}

	var counts: [Character: Int] {
		characterCounts
	}

	var characters: Set<Character> {
		Set(letters)
	}

	var isEmpty: Bool {
		return characterCounts.isEmpty || characterCounts.allSatisfy { $0.value == 0 }
	}

	// MARK: Inita

	init(letters: String) {
		self.characterCounts = letters
			.uppercased()
			.reduce(into: [:]) { dict, letter in
				if dict[letter] == nil {
					dict[letter] = 0
				}

				dict[letter] = dict[letter]! + 1
			}
	}

	// MARK: Mutators

	mutating func substract(letters toRemove: [Character]) {
		toRemove.forEach {
			characterCounts[$0] = characterCounts[$0]! - 1
		}
	}

	mutating func add(letters toAdd: [Character]) {
		toAdd.forEach {
			characterCounts[$0] = characterCounts[$0]! + 1
		}
	}
}
