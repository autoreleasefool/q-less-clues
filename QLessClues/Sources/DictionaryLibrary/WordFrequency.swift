import Foundation

public struct WordFrequency: Sendable {

	public static let englishWordFrequencies: [String: Int] = {
		guard let freqListUrl = Bundle.main.url(forResource: "freq", withExtension: "csv"),
					let freqList = try? String(contentsOf: freqListUrl) else {
			fatalError("Could not load frequencies")
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

	public static let englishFrequencies = WordFrequency(words: WordSet.englishSet.words)

	public let frequency: [String: Int]
	public let ranking: [String: Int]
	public let totalFrequency: Int

	public init(words: Set<String>, baseFrequencies: [String: Int] = Self.englishWordFrequencies) {
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
