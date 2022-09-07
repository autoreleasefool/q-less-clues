//
//  RecordPlayScreen.swift
//  QLessClues
//
//  Created by Joseph Roque on 2022-09-04.
//

import Combine
import SwiftUI

struct RecordPlayScreen: View {

	let solver = BacktrackingSolver(validator: BasicValidator())

	@Environment(\.dismiss) private var dismiss

	@StateObject private var playsController = PlaysController()
	@StateObject private var vm = VM()

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

class VM: ObservableObject {
	let solver = BacktrackingSolver(validator: BasicValidator())
	private var cancellables: [AnyCancellable] = []

	init() {
		solver.generateSolutions(fromLetters: "zreoltwhmuck")
			.receive(on: DispatchQueue.main)
			.sink(receiveCompletion: { _ in
				print("Completed")
			}, receiveValue: {
				print("Solution: \($0.words)")
			})
			.store(in: &cancellables)
	}
}
