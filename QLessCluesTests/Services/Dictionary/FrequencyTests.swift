//
//  FrequencyTests.swift
//  QLessCluesTests
//
//  Created by Joseph Roque on 2022-09-05.
//

import XCTest
@testable import QLessClues

final class FrequencyTests: XCTestCase {

	func testLetterFrequency() {
		let letterSet = LetterSet(letters: "aaabbbccc")
		let wordSet = WordSet(letterSet: letterSet, baseDictionary: ["a", "bb", "ccc"])
		let frequency = LetterFrequency(letterSet: letterSet, wordSet: wordSet)

		XCTAssertEqual(frequency.frequency, ["A": 1, "B": 2, "C": 3])
		XCTAssertEqual("AAABBBCCC", String(letterSet.letters.sorted(by: frequency.sortByFrequency)))
	}
}
