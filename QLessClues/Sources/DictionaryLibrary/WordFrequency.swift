import Foundation

public struct WordFrequency: Sendable {
	public let frequency: [String: Int]
	public let ranking: [String: Int]
	public let totalFrequency: Int

	public init(words: Set<String>, baseFrequencies: [String: Int]) {
		var frequency: [String: Int] = [:]
		var totalFrequency = 0
		for word in words {
			frequency[word] = baseFrequencies[word]
			totalFrequency += (baseFrequencies[word] ?? 0)
		}

		var ranking: [String: Int] = [:]
		for (index, word) in words
			.sorted(by: {
				(baseFrequencies[$0] ?? Int.min) < (baseFrequencies[$1] ?? Int.min)
			}).reversed().enumerated() {
			ranking[word] = index
		}

		self.frequency = frequency
		self.ranking = ranking
		self.totalFrequency = totalFrequency
	}
}
