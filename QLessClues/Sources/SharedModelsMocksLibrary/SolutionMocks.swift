import SharedModelsLibrary

extension Solution {
	public static let mock = Solution(board: [
		Position(0, 0): "R",
		Position(0, 1): "A",
		Position(0, 2): "T",
	])

	public static let multiWordMock = Solution(board: [
		Position(0, 0): "R",
		Position(0, 1): "A",
		Position(0, 2): "T",
		Position(1, 1): "R",
		Position(2, 1): "T",
	])
}
