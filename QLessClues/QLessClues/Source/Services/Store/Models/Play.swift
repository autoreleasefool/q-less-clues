//
//  Play.swift
//  QLessClues
//
//  Created by Joseph Roque on 2022-09-17.
//

import Foundation

struct Play: Codable, Equatable, Identifiable {
	let id: UUID
	let createdAt: Date
	var letters: String
	var outcome: Outcome

	init(id: UUID = UUID(), createdAt: Date = Date(), letters: String, outcome: Outcome = .unsolved) {
		self.id = id
		self.createdAt = createdAt
		self.letters = letters
		self.outcome = outcome
	}

	var isPlayable: Bool {
		letters.count == 12
	}
}

extension Play {
	enum Outcome: CaseIterable, Codable, Equatable {
		case unsolved
		case solved
		case solvedWithHints

		var label: String {
			switch self {
			case .unsolved: return "❌ Unsolved"
			case .solved: return "✅ Solved"
			case .solvedWithHints: return "📝 Solved (with hints)"
			}
		}
	}
}
