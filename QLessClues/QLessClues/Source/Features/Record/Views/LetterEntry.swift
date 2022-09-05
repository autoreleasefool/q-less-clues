//
//  LetterEntry.swift
//  QLessClues
//
//  Created by Joseph Roque on 2022-09-04.
//

import SwiftUI

struct LetterEntry: View {

	@Binding private var letters: String

	init(_ letters: Binding<String>) {
		self._letters = letters
	}

	var body: some View {
		Group {
			TextField("Letters", text: $letters)
				.onChange(of: letters, perform: updateLetters)

			Button(action: self.captureLetters) {
				HStack {
					Image(systemName: "camera.viewfinder")
					Text("Capture")
				}
			}
		}

	}

	private func captureLetters() {

	}

	private func updateLetters(_ letters: String) {
		var updatedLetters = letters.replacing(/[^A-Za-z]/, with: "")
		updatedLetters = updatedLetters.uppercased()
		if updatedLetters.count > 12 {
			updatedLetters = String(letters.prefix(12))
		}
		self.letters = updatedLetters
	}
}
