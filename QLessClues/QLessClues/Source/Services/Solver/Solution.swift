//
//  Solution.swift
//  QLessClues
//
//  Created by Joseph Roque on 2022-09-04.
//

import Foundation

struct Solution {
	let entries: [Entry]

	init(entries: [Entry]) {
		assert(!entries.isEmpty)
		assert(entries.first?.intersection == nil)
		assert(entries.dropFirst().allSatisfy { $0.intersection != nil })

		self.entries = entries
	}

	var words: [String] {
		entries.map(\.word)
	}
}

extension Solution {
	struct Entry {
		let intersection: Intersection?
		let word: String
	}
}

extension Solution.Entry {
	struct Intersection {
		// Index of the word in the `Solution.Entry` array that this entry intersects with
		let intersectingEntryIndex: Int
		// Index of the letter in the intersecting `Solution.Entry` that this entry specifically shares
		let intersectingEntryLetterIndex: Int
		// Index of the letter in _this_ entry that intersects the intersecting `Solution.Entry`
		let selfIntersectingIndex: Int
	}
}
