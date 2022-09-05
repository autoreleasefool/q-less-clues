//
//  Solution.swift
//  QLessClues
//
//  Created by Joseph Roque on 2022-09-04.
//

import Foundation

struct Solution: Codable, Equatable, Hashable {
	private typealias Size = (width: Int, height: Int)

	let letters: [LetterPosition]
	let words: [String]

	init(letters: [LetterPosition]) {
		self.letters = letters

		var boardSize: Size = (width: 0, height: 0)
		let positions: [Position: String] = letters.reduce(into: [:]) { pos, letter in
			boardSize.width = max(boardSize.width, letter.position.column + 1)
			boardSize.height = max(boardSize.height, letter.position.row + 1)
			pos[letter.position] = letter.letter
		}

		self.words = (Self.findHorizontalWords(boardSize, positions) + Self.findVerticalWords(boardSize, positions))
			.sorted()
	}
}

// MARK: - Letter

extension Solution {
	struct LetterPosition: Codable, Equatable, Hashable {
		let letter: String
		let position: Position
	}
}

// MARK: - Position

extension Solution {
	struct Position: Codable, Equatable, Hashable {
		let row: Int
		let column: Int

		init(row: Int, column: Int) {
			self.row = row
			self.column = column
		}

		init(_ row: Int, _ column: Int) {
			self.row = row
			self.column = column
		}
	}
}

// MARK: - Helpers

private extension Solution {
	private static func findVerticalWords(_ boardSize: Size, _ positions: [Position: String]) -> [String] {
		var words: [String] = []
		for column in 0..<boardSize.width {
			var word = ""
			for row in 0..<boardSize.height {
				if let letter = positions[Position(row, column)] {
					word += letter
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

	private static func findHorizontalWords(_ boardSize: Size, _ positions: [Position: String]) -> [String] {
		var words: [String] = []
		for row in 0..<boardSize.height {
			var word = ""
			for column in 0..<boardSize.width {
				if let letter = positions[Position(row, column)] {
					word += letter
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
