import SharedModelsLibrary

extension Statistics {
	public struct FetchRequest {
		public let letter: String?

		public init(letter: String? = nil) {
			self.letter = letter
		}
	}
}
