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
	@StateObject private var solutionsController = SolutionsController()

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
				Section("Analysis") {
					NavigationLink {
						SolutionsListScreen(solutionsController: solutionsController)
					} label: {
						HStack {
							Text("Solutions")
							Spacer()
							Text("\(solutionsController.solutions.count)")
						}
					}
				}
			}
		}
		.navigationTitle("New Play")
		.onChange(of: newPlay.letters.uppercased()) { letters in
			if letters.count == 12 {
				solutionsController.generateSolutions(fromLetters: letters)
			} else {
				solutionsController.cancel()
			}
		}
	}
}
