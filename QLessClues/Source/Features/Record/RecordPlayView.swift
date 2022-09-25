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

			AnalysisView(play: play)
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

// MARK: - Actions

extension RecordPlayView {
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
