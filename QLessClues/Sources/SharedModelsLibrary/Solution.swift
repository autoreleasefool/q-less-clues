import ExtensionsLibrary
import Foundation

public struct Solution: Identifiable, Codable, Equatable, Hashable {
	public let id: UUID
	public let letterPositions: [Position: String]
	public let words: [String]
	public let rows: ClosedRange<Int>
	public let columns: ClosedRange<Int>

	public var letters: String {
		Array(letterPositions.values).sorted().joined()
	}

	public var description: String {
		words.joined(separator: ", ")
	}

	public init(board: [Position: Character]) {
		self.id = UUID()
		self.letterPositions = board.reduce(into: [:]) { dict, entry in dict[entry.key] = String(entry.value) }
		self.words = (Self.findHorizontalWords(board) + Self.findVerticalWords(board)).sorted()
		self.rows = board.rows
		self.columns = board.columns
	}

	public func characterAt(row: Int, column: Int) -> Character {
		let letter = letterPositions[Position(row, column)] ?? " "
		return letter[letter.startIndex]
	}
}

// MARK: - Letter

extension Solution {
	public struct LetterPosition: Codable, Equatable, Hashable, CustomStringConvertible {
		public let letter: String
		public let position: Position

		public var description: String {
			"(\(position), \(letter))"
		}
	}
}

// MARK: - Helpers

extension Solution {
	private static func findVerticalWords(_ positions: [Position: Character]) -> [String] {
		var words: [String] = []

		for column in positions.columns {
			var word = ""
			for row in positions.rows {
				if let letter = positions[Position(row, column)] {
					word += String(letter)
				} else {
					if word.count > 1 {
						words.append(word)
					}
					word = ""
				}
			}

			if word.count > 1 {
				words.append(word)
			}
		}

		return words
	}

	private static func findHorizontalWords(_ positions: [Position: Character]) -> [String] {
		var words: [String] = []

		for row in positions.rows {
			var word = ""
			for column in positions.columns {
				if let letter = positions[Position(row, column)] {
					word += String(letter)
				} else {
					if word.count > 1 {
						words.append(word)
					}
					word = ""
				}
			}

			if word.count > 1 {
				words.append(word)
			}
		}

		return words
	}
}

// MARK: - Dictionary

extension Dictionary where Key == Position, Value == Character {
	public var columns: ClosedRange<Int> {
		let (min, max) = self.keys.reduce(into: (min: 0, max: 0)) { out, next in
			out.max = Swift.max(out.max, next.column)
			out.min = Swift.min(out.min, next.column)
		}

		return min...max
	}

	public var rows: ClosedRange<Int> {
		let (min, max) = self.keys.reduce(into: (min: 0, max: 0)) { out, next in
			out.max = Swift.max(out.max, next.row)
			out.min = Swift.min(out.min, next.row)
		}

		return min...max
	}
}
