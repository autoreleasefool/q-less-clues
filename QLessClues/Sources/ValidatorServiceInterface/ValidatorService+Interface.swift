import Dependencies
import DependenciesMacros
import DictionaryLibrary
import SharedModelsLibrary

public struct ValidatorService: Sendable {
	public var validate: @Sendable (Solution, WordSet) async -> Bool

	public init(validate: @escaping @Sendable (Solution, WordSet) async -> Bool) {
		self.validate = validate
	}
}

extension ValidatorService: TestDependencyKey {
	public static var testValue = Self(
		validate: { _, _ in fatalError("\(Self.self).validate") }
	)
}

extension DependencyValues {
	public var validatorService: ValidatorService {
		get { self[ValidatorService.self] }
		set { self[ValidatorService.self] = newValue }
	}
}
