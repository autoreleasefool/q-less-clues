public struct LetterSet {

	static let fullAlphabet = LetterSet(letters: Array(repeating: "ABCDEFGHIJKLMNOPQRSTUVWXYZ", count: 3).joined())

	private var characterCounts: [Character: Int]

	public var letters: [Character] {
		characterCounts
			.filter { $0.value > 0 }
			.map { Array(repeating: $0.key, count: $0.value) }
			.flatMap { $0 }
	}

	public var counts: [Character: Int] {
		characterCounts
	}

	public var characters: Set<Character> {
		Set(letters)
	}

	public var isEmpty: Bool {
		return characterCounts.isEmpty || characterCounts.allSatisfy { $0.value == 0 }
	}

	// MARK: Inita

	public init(letters: String) {
		self.characterCounts = letters
			.uppercased()
			.reduce(into: [:]) { dict, letter in
				if dict[letter] == nil {
					dict[letter] = 0
				}

				dict[letter] = dict[letter]! + 1
			}
	}

	// MARK: Mutators

	public mutating func substract(letters toRemove: [Character]) {
		toRemove.forEach {
			characterCounts[$0] = characterCounts[$0]! - 1
		}
	}

	public mutating func add(letters toAdd: [Character]) {
		toAdd.forEach {
			characterCounts[$0] = characterCounts[$0]! + 1
		}
	}
}
