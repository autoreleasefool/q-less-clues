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
}

extension Play {
	enum Outcome: Codable, Equatable {
		case solved
		case solvedWithHints
		case unsolved
	}
}
