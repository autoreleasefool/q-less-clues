//
//  BasicValidator.swift
//  QLessClues
//
//  Created by Joseph Roque on 2022-09-05.
//

import Foundation

class BasicValidator: Validator {
	private typealias Board = [[Character]]
	private typealias Metadata = [Int: EntryMetadata]

	func validate(solution: Solution) -> Bool {
		var board: Board = []
		var metadata: Metadata = [:]

		insertFirstWord(solution.entries.first!.word, into: &board, with: &metadata)

		for entry in solution.entries.dropFirst() {
			let direction = getDirection(forEntry: entry, with: metadata)
			insertEntry(entry, into: &board, with: &metadata)
		}

		fatalError("not implemented")
	}

	private func insertEntry(_ entry: Solution.Entry, into board: inout Board, with metadata: inout Metadata) {
		let direction = getDirection(forEntry: entry, with: metadata)
		switch direction {
		case .vertical:
			insertVerticalEntry(entry, into: &board, with: &metadata)
		case .horizontal:
			insertHorizontalEntry(entry, into: &board, with: &metadata)
		}
	}

	private func insertVerticalEntry(_ entry: Solution.Entry, into board: inout Board, with metadata: inout Metadata) {
		guard let intersection = entry.intersection,
					let intersectingEntry = metadata[intersection.intersectingEntryIndex] else {
			fatalError("Missing intersecting word")
		}

		let intersectingWordPosition = intersectingEntry.firstLetterPosition
		let intersectingLetterPosition = (row: intersectingWordPosition.row, column: intersectingWordPosition.column + intersection.intersectingEntryLetterIndex)
		let missingRowsBefore = intersectingLetterPosition.row - intersection.selfIntersectingIndex
		let missingRowsAfter = intersectingLetterPosition.row
	}

	private func insertHorizontalEntry(_ entry: Solution.Entry, into board: inout Board, with metadata: inout Metadata) {

	}

	private func insertFirstWord(_ word: String, into board: inout Board, with metadata: inout Metadata) {
		board.append(Array(word))
		metadata[0] = EntryMetadata(firstLetterPosition: (0, 0), direction: .horizontal)
	}

	private func getDirection(forEntry entry: Solution.Entry, with metadata: Metadata) -> Direction {
		guard let intersection = entry.intersection,
					let intersectingDirection = metadata[intersection.intersectingEntryIndex]?.direction else {
			fatalError("Intersecting word not found in metadata")
		}

		return intersectingDirection.next
	}
}

extension BasicValidator {
	private enum Direction {
		case horizontal
		case vertical

		var next: Direction {
			switch self {
			case .horizontal: return .vertical
			case .vertical: return .horizontal
			}
		}
	}

	private struct EntryMetadata {
		var firstLetterPosition: (row: Int, column: Int)
		let direction: Direction
	}
}
