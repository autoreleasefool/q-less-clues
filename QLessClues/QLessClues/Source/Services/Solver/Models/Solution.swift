//
//  Solution.swift
//  QLessClues
//
//  Created by Joseph Roque on 2022-09-04.
//

import Foundation

struct Solution: Identifiable, Codable, Equatable, Hashable {
	let id: UUID
	let letterPositions: [Position: String]
	let words: [String]
	let rows: ClosedRange<Int>
	let columns: ClosedRange<Int>

	var letters: String {
		Array(letterPositions.values).sorted().joined()
	}

	init(board: [Position: Character]) {
		self.id = UUID()
		self.letterPositions = board.reduce(into: [:]) { dict, entry in dict[entry.key] = String(entry.value) }
		self.words = (Self.findHorizontalWords(board) + Self.findVerticalWords(board)).sorted()
		self.rows = board.rows
		self.columns = board.columns
	}

	func characterAt(row: Int, column: Int) -> Character {
		let letter = letterPositions[Position(row, column)] ?? " "
		return letter[letter.startIndex]
	}
}

// MARK: - Letter

extension Solution {
	struct LetterPosition: Codable, Equatable, Hashable, CustomStringConvertible {
		let letter: String
		let position: Position

		var description: String {
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
