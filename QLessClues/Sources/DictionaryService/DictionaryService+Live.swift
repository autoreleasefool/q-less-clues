import Dependencies
import DictionaryLibrary
import DictionaryServiceInterface
import Foundation

extension DictionaryService: DependencyKey {
	public static var liveValue = Self(
		englishWords: {
			guard let wordListUrl = Bundle.main.url(forResource: "words", withExtension: "txt") else {
				throw ServiceError.dictionaryNotFound
			}

			let wordList = try String(contentsOf: wordListUrl)

			return wordList
				.split(separator: "\n")
				.map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
				.filter { !$0.isEmpty }
				.sorted {
					return $0.count == $1.count ? $0 < $1 : $0.count > $1.count
				}
		},
		englishFrequencies: {
			guard let freqListUrl = Bundle.main.url(forResource: "freq", withExtension: "csv") else {
				throw ServiceError.dictionaryNotFound
			}

			let freqList = try String(contentsOf: freqListUrl)

			return freqList
				.split(separator: "\n")
				.map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
				.filter { !$0.isEmpty }
				.reduce(into: [:]) { freq, line in
					let wordFreq = line.split(separator: ",")
					freq[String(wordFreq[0])] = Int(wordFreq[1])
				}
		}
	)
}
