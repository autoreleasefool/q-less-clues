//
//  Play.swift
//  QLessClues
//
//  Created by Joseph Roque on 2022-09-04.
//

import Boutique
import Foundation

struct Play: Codable, Equatable, Identifiable {
	let id: UUID
	let createdAt: Date
	var letters: String
	var solvedState: SolvedState

	init(
		id: UUID = UUID(),
		createdAt: Date = Date(),
		solvedState: SolvedState = .unsolved,
		letters: String
	) {
		self.id = id
		self.createdAt = createdAt
		self.letters = letters
		self.solvedState = solvedState
	}
}

// MARK: - Store

extension Store where Item == Play {
	static let playsStore = Store<Play>(
		storage: SQLiteStorageEngine.default(appendingPath: "Plays"),
		cacheIdentifier: \.id.uuidString
	)
}
