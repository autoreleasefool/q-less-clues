//
//  Dictionary.swift
//  QLessClues
//
//  Created by Joseph Roque on 2022-09-05.
//

import Foundation

struct WordSet {

	private static let englishWords: [String] = {
		guard let wordListUrl = Bundle.main.url(forResource: "words", withExtension: "txt"),
					let wordList = try? String(contentsOf: wordListUrl) else {
			fatalError("Could not load dictionary")
		}

		return wordList
			.split(separator: "\n")
			.map { $0.trimmingCharacters(in: .whitespacesAndNewlines).uppercased() }
			.filter { !$0.isEmpty }
			.sorted {
				return $0.count == $1.count ? $0 < $1 : $0.count > $1.count
			}
	}()

	static let fullEnglishSet: WordSet = WordSet(letterSet: LetterSet(letters: "ABCDEFGHIJKLMNOPQRSTUVWXYZ"))

	private(set) var words: [String]
	private(set) var alphabet: String

	init(letterSet: LetterSet, words: [String] = Self.englishWords) {
		self.alphabet = String(letterSet.letters.sorted()).uppercased()

		self.words = words
			.map { $0.uppercased() }
			.filter { Set($0).subtracting(Set(letterSet.letters)).isEmpty }
			.filter {
				var count = letterSet.counts
				for letter in $0 {
					count[letter] = count[letter]! - 1
					if count[letter]! < 0 {
						return false
					}
				}

				return true
			}
		// TODO: generate word set
	}

	func wordsContainingLeastCommonLetter(inSet letterSet: LetterSet) -> [String] {
		let commonality = LetterCommonality(letterSet: letterSet, wordSet: self)
		let leastCommonLetter = letterSet.letters.sorted(by: commonality.sortByCommonality).first!
		return self.words.filter { $0.firstIndex(of: leastCommonLetter) != nil }
	}
}
