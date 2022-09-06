//
//  Commonality.swift
//  QLessClues
//
//  Created by Joseph Roque on 2022-09-05.
//

import Foundation

struct LetterCommonality {

	let commonality: [Character: Int]

	init(letterSet: LetterSet, wordSet: WordSet) {
		var commonality: [Character: Int] = letterSet.letters.reduce(into: [:]) { $0[$1] = 0 }
		commonality = wordSet.words.reduce(into: commonality) { commonality, word in
			word.forEach { commonality[$0] = commonality[$0]! + 1 }
		}
		self.commonality = commonality
	}

	func sortByCommonality(first: Character, second: Character) -> Bool {
		return commonality[first]! < commonality[second]!
	}
}
