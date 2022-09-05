//
//  PlaysController.swift
//  QLessClues
//
//  Created by Joseph Roque on 2022-09-04.
//

import Boutique
import Foundation

final class PlaysController: ObservableObject {

	@Stored var plays: [Play]

	init(store: Store<Play> = .playsStore) {
		self._plays = Stored(in: store)
	}

	func new(withLetters letters: String = "") -> Play {
		Play(letters: letters)
	}

	func save(play: Play) async throws {
		try await self.$plays.add(play)
	}

	func remove(play: Play) async throws {
		try await self.$plays.remove(play)
	}
}
