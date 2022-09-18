//
//  RecordPlayScreen.swift
//  QLessClues
//
//  Created by Joseph Roque on 2022-09-04.
//

import Combine
import SwiftUI

struct RecordPlayScreen: View {

	@Environment(\.dismiss) private var dismiss

	@StateObject private var solutionsProvider: SolutionsProvider
	@State private var solutions: [Solution] = []
	@State private var play: Play = Play(letters: "")

	init(generator: SolutionGenerator = BacktrackingSolver()) {
		self._solutionsProvider = .init(wrappedValue: .init(generator: generator))
	}

	var body: some View {
		List {
			Section("Game") {
				LetterEntry($play.letters)
			}

			Section("Solutions") {
				Button(action: findSolutions) {
					if solutionsProvider.isRunning {
						ProgressView()
					} else {
						Text("Find Solutions")
					}
				}
				.disabled(play.letters.count != 12 || solutionsProvider.isRunning)

				NavigationLink {
					SolutionsListScreen(solutions: $solutionsProvider.solutions)
				} label: {
					HStack {
						Text("Solutions")
						Spacer()
						Text("\(solutionsProvider.solutions.count)")
					}
				}
			}
		}
		.navigationTitle("New Play")
		.onDisappear {
			solutionsProvider.cancel()
		}
	}

	private func findSolutions() {
		solutionsProvider.solve(letters: play.letters)
	}
}

#if DEBUG
struct RecordPlayScreenPreview: PreviewProvider {
	static var previews: some View {
		RecordPlayScreen()
	}
}
#endif
