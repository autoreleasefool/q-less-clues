//
//  RecordPlayScreen.swift
//  QLessClues
//
//  Created by Joseph Roque on 2022-09-04.
//

import SwiftUI

struct RecordPlayScreen: View {

	@Environment(\.dismiss) private var dismiss

	@StateObject private var playsController = PlaysController()

	@State private var newPlay: Play

	init(_ play: Play) {
		self._newPlay = .init(initialValue: play)
	}

	var body: some View {
		Form {
			Section("Game") {
				LetterEntry($newPlay.letters)
			}

			if newPlay.letters.count == 12 {
				Section("Hints") {
					Text("Here's a hint")
				}
			}
		}
		.navigationTitle("New Play")
	}
}
