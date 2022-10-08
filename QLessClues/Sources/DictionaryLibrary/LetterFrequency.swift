public struct LetterFrequency {
	public let frequency: [Character: Int]

	public init(letterSet: LetterSet, wordSet: WordSet) {
		var frequency: [Character: Int] = letterSet.letters.reduce(into: [:]) { $0[$1] = 0 }
		frequency = wordSet.words.reduce(into: frequency) { frequency, word in
			word.forEach { frequency[$0] = frequency[$0]! + 1 }
		}
		self.frequency = frequency
	}

	public func sortByFrequency(first: Character, second: Character) -> Bool {
		return frequency[first]! < frequency[second]!
	}
}
