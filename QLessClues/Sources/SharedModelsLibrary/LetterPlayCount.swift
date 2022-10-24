public struct LetterPlayCount: Equatable, Identifiable {
	public let letter: String
	public let plays: Int

	public var id: String { letter }

	public init(letter: String, plays: Int) {
		self.letter = letter
		self.plays = plays
	}
}
