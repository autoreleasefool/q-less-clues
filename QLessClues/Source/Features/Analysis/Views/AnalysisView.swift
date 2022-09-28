//
//  AnalysisView.swift
//  QLessClues
//
//  Created by Joseph Roque on 2022-09-24.
//

import RealmSwift
import SwiftUI

struct AnalysisView: View {

	@Environment(\.container) private var container

	@ObservedRealmObject var play: Play
	@State private var analysis: Loadable<Analysis>
	@State private var hint: Loadable<Hint>

	private let hideDifficulty: Bool

	init(
		play: Play,
		hideDifficulty: Bool = false,
		analysis: Loadable<Analysis> = .notRequested,
		hint: Loadable<Hint> = .notRequested
	) {
		self.play = play
		self.hideDifficulty = hideDifficulty
		self._analysis = .init(initialValue: analysis)
		self._hint = .init(initialValue: hint)
	}

	var body: some View {
		content
			.onChange(of: play.letters) { _ in resetAnalysis() }
			.onChange(of: analysis.value?.difficulty) { difficulty in
				guard !hideDifficulty else { return }
				play.difficulty = difficulty
			}
	}

	@ViewBuilder private var content: some View {
		Section {
			Button("Analyze", action: beginAnalysis)
				.frame(maxWidth: .infinity)
				.disabled(analysisButtonDisabled)
		}

		if shouldShowHints {
			Section("Hints") {
				ForEach(hint.value?.words ?? [], id: \.self) {
					Text($0)
				}

				Button("New Hint", action: addHint)
					.frame(maxWidth: .infinity)
					.disabled(!moreHintsAvailable)
			}
		}

		if shouldShowAnalysis {
			Section("Analysis") {
				ProgressView(value: analysis.value?.progress)
				if !hideDifficulty {
					DifficultyView(difficulty: analysis.value?.difficulty)
				}
				NavigationLink {
					SolutionsList(solutions: analysis.value?.solutions ?? [])
				} label: {
					LabeledContent("Solutions", value: totalSolutionsFound)
				}
			}
		}
	}
}

// MARK: - Content

extension AnalysisView {
	private var shouldShowHints: Bool {
		analysis.value?.solutions.isEmpty == false
	}

	private var moreHintsAvailable: Bool {
		switch hint {
		case .notRequested:
			return analysis.value?.solutions.isEmpty == false
		case .isLoading(let hint, _):
			return hint?.moreHintsAvailable ?? false
		case .loaded(let hint):
			return hint.moreHintsAvailable
		case .failed:
			return false
		}
	}

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
}

// MARK: - Actions

extension AnalysisView {
	private func addHint() {
		container.interactors.hintsInteractor
			.receiveHint(from: analysis.value?.solutions ?? [], hint: $hint)
	}

	private func beginAnalysis() {
		container.interactors.analysisInteractor
			.analyze(letters: play.letters, analysis: $analysis)
	}

	private func resetAnalysis() {
		container.interactors.analysisInteractor
			.cancel()
		analysis = .notRequested
	}
}

// MARK: - Previews

#if DEBUG
struct AnalysisViewPreview: PreviewProvider {
	static var previews: some View {
		List {
			AnalysisView(play: Play())
		}
	}
}
#endif
