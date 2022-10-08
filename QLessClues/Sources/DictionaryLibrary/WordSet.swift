import Foundation

public struct WordSet: Sendable {

	public static let englishWords: [String] = {
		guard let wordListUrl = Bundle.main.url(forResource: "words", withExtension: "txt"),
					let wordList = try? String(contentsOf: wordListUrl) else {
			fatalError("Could not load dictionary")
		}

		return wordList
			.split(separator: "\n")
			.map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
			.filter { !$0.isEmpty }
			.sorted {
				return $0.count == $1.count ? $0 < $1 : $0.count > $1.count
			}
	}()

	public static let englishSet: WordSet = WordSet(letterSet: .fullAlphabet)

	public private(set) var words: Set<String>
	public private(set) var alphabet: String
	public private(set) lazy var frequency: WordFrequency = WordFrequency(words: words)

	public init(letterSet: LetterSet, baseDictionary: [String] = WordSet.englishWords) {
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
	}

	private init(wordSet: WordSet) {
		self.alphabet = wordSet.alphabet
		self.words = wordSet.words
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
		words.subtracting(words.filter { (WordFrequency.englishFrequencies.ranking[$0] ?? Int.max) > 10_000 })
	}
}

extension WordSet {
	public enum Filter {
		case mostPopular
		case containingLeastFrequentLetter
	}
}
