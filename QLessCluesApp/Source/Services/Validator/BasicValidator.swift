//
//  BasicValidator.swift
//  QLessClues
//
//  Created by Joseph Roque on 2022-09-05.
//

import DictionaryLibrary
import Foundation

class BasicValidator: Validator {
	private lazy var englishWords = Set(WordSet.englishSet.words)

	func validate(solution: Solution) -> Bool {
		allWordsValid(in: solution) && allLettersConnected(in: solution)
	}

	private func allWordsValid(in solution: Solution) -> Bool {
		solution.words.allSatisfy { englishWords.contains($0) }
	}

	private func allLettersConnected(in solution: Solution) -> Bool {
		var unvisited = Set(solution.letterPositions.keys)
		var toExplore: Set<Position> = []

		guard let first = unvisited.popFirst() else { return false }
		toExplore.insert(first)

		while !toExplore.isEmpty {
			let node = toExplore.popFirst()!
			unvisited.remove(node)
			node.surrounding
				.filter { unvisited.contains($0) }
				.forEach { toExplore.insert($0) }
		}

		return unvisited.isEmpty
	}
}
