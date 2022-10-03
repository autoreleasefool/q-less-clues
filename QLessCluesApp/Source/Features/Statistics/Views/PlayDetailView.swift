//
//  PlayDetailView.swift
//  QLessClues
//
//  Created by Joseph Roque on 2022-09-18.
//

import RealmSwift
import SwiftUI

struct PlayDetailView: View {

	@Environment(\.dismiss) private var dismiss

	@ObservedRealmObject var play: Play
	@State private var isDeleting = false

	var body: some View {
		List {
			Section {
				Text(play.letters)
				LabeledContent("Outcome", value: play.outcome.rawValue)
				DifficultyView(difficulty: play.difficulty)
			}

			AnalysisView(play: play, hideDifficulty: true)

			Section {
				Button("Delete", role: .destructive, action: toggleDeletePrompt)
					.frame(maxWidth: .infinity)
			}
		}
		.confirmationDialog("Are you sure?", isPresented: $isDeleting) {
			Button(role: .destructive, action: delete) {
				Text("Delete")
			}
		} message: {
			Text("You cannot undo this action")
		}
	}
}

// MARK: - Actions

extension PlayDetailView {
	private func toggleDeletePrompt() {
		isDeleting.toggle()
	}

	private func delete() {
		if let deletable = play.thaw(), let realm = deletable.realm {
			try? realm.write {
				realm.delete(deletable)
			}
			dismiss()
		}
	}
}

#if DEBUG
struct PlayDetailViewPreview: PreviewProvider {
	static let play: Play = {
		let play = Play()
		play.letters = "CULTORCHSYOF"
		return play
	}()

	static var previews: some View {
		PlayDetailView(play: play)
	}
}
#endif
