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
	@Environment(\.container) private var container
	@Environment(\.realm) private var realm

	@ObservedRealmObject var play: Play
	@ObservedRealmObject var group: PlayGroup
	@State private var analysis: Loadable<Analysis>

	init(play: Play, group: PlayGroup, analysis: Loadable<Analysis> = .notRequested) {
		self.play = play
		self.group = group
		self._analysis = .init(initialValue: analysis)
	}

	var body: some View {
		List {
			Section("Game") {
				LetterEntry(entry: $play.letters)
				Picker("Outcome", selection: $play.outcome) {
					ForEach(Play.Outcome.allCases, id: \.hashValue) {
						Text($0.rawValue).tag($0)
					}
				}
			}

			Section {
				Button("Analyze", action: beginAnalysis)
					.frame(maxWidth: .infinity)
					.disabled(analysisButtonDisabled)
			}

			if shouldShowAnalysis {
				Section("Analysis") {
					ProgressView(value: analysis.value?.progress)
					LabeledContent("Difficulty", value: difficulty)
					NavigationLink {
						SolutionsList(solutions: analysis.value?.solutions ?? [])
					} label: {
						LabeledContent("Solutions", value: totalSolutionsFound)
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
		.onChange(of: play.letters) { _ in resetAnalysis() }
	}
}

// MARK: - Content

extension RecordPlayView {
	private var shouldShowAnalysis: Bool {
		guard play.isPlayable else { return false }
		switch analysis {
		case .isLoading, .loaded: return true
		case .failed, .notRequested: return false
		}
	}

	private var analysisButtonDisabled: Bool {
		guard play.isPlayable else { return true }

		switch analysis {
		case .isLoading, .loaded: return true
		case .notRequested, .failed: return false
		}
	}

	private var analysisButtonText: String {
		switch analysis {
		case .isLoading: return "Analyzing..."
		case .loaded: return "Analysis Complete"
		case .notRequested, .failed: return "Analyze"
		}
	}

	private var totalSolutionsFound: String {
		switch analysis {
		case .isLoading(let value, _): return "\(value?.solutions.count ?? 0)"
		case .loaded(let value): return "\(value.solutions.count)"
		case .notRequested, .failed: return "N/A"
		}
	}

	private var difficulty: String {
		guard let difficulty = analysis.value?.difficulty else {
			return "❓ Undetermined"
		}

		return difficulty.rawValue
	}
}

// MARK: - Actions

extension RecordPlayView {
	private func beginAnalysis() {
		container.interactors.analysisInteractor
			.analyze(letters: play.letters, analysis: $analysis)
	}

	private func resetAnalysis() {
		container.interactors.analysisInteractor
			.cancel()
		analysis = .notRequested
	}

	private func save() {
		play.letters = String(play.letters.sorted())
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
