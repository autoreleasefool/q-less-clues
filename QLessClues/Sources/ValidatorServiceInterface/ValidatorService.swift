import DictionaryLibrary
import SharedModelsLibrary
import XCTestDynamicOverlay

public struct ValidatorService: Sendable {
	public var validate: @Sendable (Solution, WordSet) async -> Bool

	public init(validate: @escaping @Sendable (Solution, WordSet) async -> Bool) {
		self.validate = validate
	}
}
