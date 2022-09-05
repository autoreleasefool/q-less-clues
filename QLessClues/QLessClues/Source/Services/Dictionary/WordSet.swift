//
//  Dictionary.swift
//  QLessClues
//
//  Created by Joseph Roque on 2022-09-05.
//

import Foundation

struct WordSet {

	static let englishWords: [String] = {
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

	private(set) var words: [String]
	private(set) var alphabet: String

	init(alphabet: String, words: [String] = Self.englishWords) {
		self.alphabet = String(alphabet.sorted()).uppercased()
		let letterSet = Set(self.alphabet)
		self.words = words
			.filter { Set($0).subtracting(letterSet).isEmpty }
		// TODO: generate word set
	}
}
