//
//  Solution.swift
//  QLessClues
//
//  Created by Joseph Roque on 2022-09-04.
//

import Foundation

struct Solution: Identifiable, Codable, Equatable, Hashable {
	let id: UUID
	let letterPositions: [LetterPosition]
	let words: [String]
	var letters: [String] {
		letterPositions.map { $0.letter }
	}

	init(board: [Position: Character]) {
		self.id = UUID()
		self.letterPositions = board.map { LetterPosition(letter: String($0.value), position: $0.key) }
		self.words = (Self.findHorizontalWords(board) + Self.findVerticalWords(board)).sorted()
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
		let columns = positions.columns
		let rows = positions.rows

		for column in columns.min...columns.max {
			var word = ""
			for row in rows.min...rows.max {
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
		let columns = positions.columns
		let rows = positions.rows

		for row in rows.min...rows.max {
			var word = ""
			for column in columns.min...columns.max {
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
