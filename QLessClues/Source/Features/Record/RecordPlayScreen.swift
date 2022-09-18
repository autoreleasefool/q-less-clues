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
	@State private var play: Play = Play()

	init(generator: SolutionGenerator = BacktrackingSolver()) {
		self._solutionsProvider = .init(wrappedValue: .init(generator: generator))
	}

	var body: some View {
		List {
			Section("Game") {
				LetterEntry($play.letters)
				Picker("Outcome", selection: $play.outcome) {
					ForEach(Play.Outcome.allCases, id: \.hashValue) {
						Text($0.rawValue).tag($0)
					}
				}
			}

			if play.isPlayable {
				if solutionsProvider.isRunning {
					ProgressView()
				}

				Section("Solutions") {
					Button("Find Solutions", action: findSolutions)
						.disabled(solutionsProvider.isRunning)

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
		}
		.navigationTitle("New Play")
		.toolbar {
			ToolbarItem(placement: .navigationBarTrailing) {
				Button("Save", action: savePlay)
					.disabled(!play.isPlayable)
			}
		}
		.onDisappear {
			solutionsProvider.cancel()
		}
	}

	private func findSolutions() {
		solutionsProvider.solve(letters: play.letters)
	}

	private func savePlay() {

	}
}

#if DEBUG
struct RecordPlayScreenPreview: PreviewProvider {
	static var previews: some View {
		NavigationStack {
			RecordPlayScreen()
		}
	}
}
#endif
