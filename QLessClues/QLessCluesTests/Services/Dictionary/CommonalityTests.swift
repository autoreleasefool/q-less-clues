//
//  CommonalityTests.swift
//  QLessCluesTests
//
//  Created by Joseph Roque on 2022-09-05.
//

import XCTest
@testable import QLessClues

final class CommonalityTests: XCTestCase {

	func testLetterCommonality() {
		let letterSet = LetterSet(letters: "abc")
		let wordSet = WordSet(letterSet: letterSet, words: ["a", "bb", "ccc"])
		let commonality = LetterCommonality(letterSet: letterSet, wordSet: wordSet)

		XCTAssertEqual(commonality.commonality, ["A": 1, "B": 2, "C": 3])
		XCTAssertEqual("ABC", String(letterSet.letters.sorted(by: commonality.sortByCommonality)))
	}
}
