//
//  LetterEntry.swift
//  QLessClues
//
//  Created by Joseph Roque on 2022-09-04.
//

import SwiftUI

struct LetterEntry: View {

	@Binding var entry: String
	@State private var letters = ""

	var body: some View {
		Group {
			TextField("Letters", text: $letters)
				.onChange(of: letters, perform: updateLetters)

//			Button(action: self.captureLetters) {
//				HStack {
//					Image(systemName: "camera.viewfinder")
//					Text("Capture")
//				}
//			}
		}

	}

	private func captureLetters() {
		fatalError("not implemented")
	}

	private func updateLetters(_ letters: String) {
		var updatedLetters = letters.replacing(/[^A-Za-z]/, with: "")
		updatedLetters = updatedLetters.uppercased()
		if updatedLetters.count > 12 {
			updatedLetters = String(letters.prefix(12))
		}
		self.letters = updatedLetters
		self.entry = updatedLetters
	}
}

#if DEBUG
struct LetterEntryPreview: PreviewProvider {
	static var previews: some View {
		Form {
			LetterEntry(entry: .constant("ABC"))
		}
	}
}
#endif
