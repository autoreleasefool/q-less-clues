import Foundation

public struct Position: Codable, Equatable, Hashable, CustomStringConvertible {
	public let row: Int
	public let column: Int

	public init(row: Int, column: Int) {
		self.row = row
		self.column = column
	}

	public init(_ row: Int, _ column: Int) {
		self.row = row
		self.column = column
	}

	public var description: String {
		"(\(row), \(column))"
	}

	public var surrounding: [Position] {
		[Position(row - 1, column), Position(row, column + 1), Position(row + 1, column), Position(row, column - 1)]
	}
}
