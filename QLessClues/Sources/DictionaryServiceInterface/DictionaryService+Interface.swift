import Dependencies
import DependenciesMacros
import DictionaryLibrary

@DependencyClient
public struct DictionaryService: Sendable {
	public var englishWords: @Sendable () throws -> [String]
	public var englishFrequencies: @Sendable () throws -> [String: Int]
}

extension DictionaryService {
	public func englishWordSet() throws -> WordSet {
		try .init(letterSet: .fullAlphabet, baseDictionary: englishWords(), baseFrequences: englishFrequencies())
	}
}

extension DictionaryService: TestDependencyKey {
	public static var testValue = Self()
}

extension DependencyValues {
	public var dictionary: DictionaryService {
		get { self[DictionaryService.self] }
		set { self[DictionaryService.self] = newValue }
	}
}

extension DictionaryService {
	public enum ServiceError: Error {
		case dictionaryNotFound
	}
}
