//
//  Frequency.swift
//  QLessClues
//
//  Created by Joseph Roque on 2022-09-05.
//

import Foundation

struct LetterFrequency {

	let frequency: [Character: Int]

	init(letterSet: LetterSet, wordSet: WordSet) {
		var frequency: [Character: Int] = letterSet.letters.reduce(into: [:]) { $0[$1] = 0 }
		frequency = wordSet.words.reduce(into: frequency) { frequency, word in
			word.forEach { frequency[$0] = frequency[$0]! + 1 }
		}
		self.frequency = frequency
	}

	func sortByFrequency(first: Character, second: Character) -> Bool {
		return frequency[first]! < frequency[second]!
	}
}

struct WordFrequency {

	private static let englishWordFrequencies: [String: Int] = {
		guard let freqListUrl = Bundle.main.url(forResource: "freq", withExtension: "csv"),
					let freqList = try? String(contentsOf: freqListUrl) else {
			fatalError("Could not load frequencyes")
		}

		return freqList
			.split(separator: "\n")
			.map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
			.filter { !$0.isEmpty }
			.reduce(into: [:]) { freq, line in
				let wordFreq = line.split(separator: ",")
				freq[String(wordFreq[0])] = Int(wordFreq[1])
			}
	}()

	static let englishFrequencies = WordFrequency(wordSet: .englishSet)

	let frequency: [String: Int]

	init(wordSet: WordSet) {
		var frequency: [String: Int] = [:]
		for word in wordSet.words {
			frequency[word] = Self.englishWordFrequencies[word]
		}
		self.frequency = frequency
	}
}
