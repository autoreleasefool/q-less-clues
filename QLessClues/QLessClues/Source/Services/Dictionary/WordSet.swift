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

	let words: [String]
	let alphabet: String

	init(alphabet: String, words: [String] = Self.englishWords) {
		self.alphabet = String(alphabet.sorted())
		let letterSet = Set(alphabet)
		self.words = words
			.filter { Set($0).subtracting(letterSet).isEmpty }
		fatalError("not implemented")
	}

	func subtracting(_ letters: String) -> WordSet? {
		var newAlphabet = alphabet
		for letter in letters {
			guard let index = newAlphabet.firstIndex(of: letter) else {
				// We're trying to remove a letter that doesn't exist in the alphabet, so we haven't passed a valid word
				// and cannot return a valid Dictionary
				return nil
			}

			newAlphabet.remove(at: index)
		}

		fatalError("not implemented")
	}

}
