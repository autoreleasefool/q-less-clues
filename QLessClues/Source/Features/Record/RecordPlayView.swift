//
//  RecordPlayView.swift
//  QLessClues
//
//  Created by Joseph Roque on 2022-09-04.
//

import Combine
import RealmSwift
import SwiftUI

struct RecordPlayView: View {

	@Environment(\.dismiss) private var dismiss
	@Environment(\.dependencies) private var dependencies
	@Environment(\.realm) private var realm

	@ObservedRealmObject var play: Play
	@ObservedRealmObject var group: PlayGroup
	@State private var solutions: Loadable<[Solution]>

	init(play: Play, group: PlayGroup, solutions: Loadable<[Solution]> = .notRequested) {
		self.play = play
		self.group = group
		self._solutions = .init(initialValue: solutions)
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
				Section("Solutions") {
					findSolutionsButton

					NavigationLink {
						SolutionsList(solutions: $solutions)
					} label: {
						HStack {
							Text("Solutions")
							Spacer()
							Text("\(solutions.value?.count ?? 0)")
						}
					}
				}
			}
		}
		.navigationTitle("New Play")
		.toolbar {
			ToolbarItem(placement: .navigationBarTrailing) {
				Button("Save", action: save)
					.disabled(!play.isPlayable)
			}
		}
	}
}

// MARK: - Content

extension RecordPlayView {
	private var findSolutionsButton: some View {
		Button(findSolutionsText, action: findSolutions)
			.disabled(findSolutionsButtonDisabled)
	}

	private var findSolutionsText: String {
		switch solutions {
		case .isLoading: return "Finding..."
		case .loaded: return "Finished"
		case .notRequested, .failed: return "Find Solutions"
		}
	}

	private var findSolutionsButtonDisabled: Bool {
		switch solutions {
		case .isLoading, .loaded: return true
		case .notRequested, .failed: return false
		}
	}
}

// MARK: - Actions

extension RecordPlayView {
	private func findSolutions() {
		dependencies.interactors.solutionsInteractor
			.solutions(forLetters: play.letters, solutions: $solutions)
	}

	private func save() {
		$group.plays.append(play)
		dismiss()
	}
}

// MARK: - Previews

#if DEBUG
struct RecordPlayViewPreview: PreviewProvider {
	static var previews: some View {
		NavigationStack {
			RecordPlayView(play: Play(), group: PlayGroup())
		}
	}
}
#endif
