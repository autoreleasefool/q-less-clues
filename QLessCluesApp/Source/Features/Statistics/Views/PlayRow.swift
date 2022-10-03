//
//  PlayRow.swift
//  QLessClues
//
//  Created by Joseph Roque on 2022-09-18.
//

import RealmSwift
import SwiftUI

struct PlayRow: View {

	@ObservedRealmObject var play: Play

	var body: some View {
		NavigationLink(destination: PlayDetailView(play: play)) {
			Text(play.letters)
				.frame(maxWidth: .infinity, alignment: .leading)
			Text(outcome)
		}
	}
}

// MARK: - Content

extension PlayRow {
	private var outcome: String {
		String(play.outcome.rawValue.first ?? "❓")
	}
}
