import Foundation

public struct WordSet: Sendable {
	public private(set) var words: Set<String>
	public private(set) var alphabet: String
	public private(set) var frequency: WordFrequency

	public init(letterSet: LetterSet, baseDictionary: [String], baseFrequences: [String: Int]) {
		self.alphabet = String(Set(letterSet.letters).sorted()).uppercased()

		let words = baseDictionary
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
		self.words = Set(words)
		self.frequency = WordFrequency(words: Set(words), baseFrequencies: baseFrequences)
	}

	private init(wordSet: WordSet) {
		self.alphabet = wordSet.alphabet
		self.words = wordSet.words
		self.frequency = wordSet.frequency
	}

	public func contains(_ word: String) -> Bool {
		words.contains(word)
	}

	public func limitBy(_ filter: Filter) -> WordSet {
		var newSet = WordSet(wordSet: self)
		switch filter {
		case .containingLeastFrequentLetter:
			newSet.words = wordsContainingLeastFrequentLetter(inSet: LetterSet(letters: alphabet))
		case .mostPopular:
			newSet.words = mostPopularWords()
		}

		return newSet
	}

	private func wordsContainingLeastFrequentLetter(inSet letterSet: LetterSet) -> Set<String> {
		let frequency = LetterFrequency(letterSet: letterSet, wordSet: self)
		let leastFrequentLetter = letterSet.letters.sorted(by: frequency.sortByFrequency).first!
		return words.subtracting(words.filter { $0.firstIndex(of: leastFrequentLetter) == nil })
	}

	private func mostPopularWords() -> Set<String> {
		words.subtracting(words.filter { (frequency.ranking[$0] ?? Int.max) > 10_000 })
	}
}

extension WordSet {
	public enum Filter {
		case mostPopular
		case containingLeastFrequentLetter
	}
}
