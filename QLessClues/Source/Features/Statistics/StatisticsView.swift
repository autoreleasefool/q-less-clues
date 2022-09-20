//
//  StatisticsScreen.swift
//  QLessClues
//
//  Created by Joseph Roque on 2022-09-04.
//

import RealmSwift
import SwiftUI

struct StatisticsView: View {

	@ObservedRealmObject var group: PlayGroup
	@State private var newPlay: Play?

	var body: some View {
		List {
			ForEach(group.plays) { play in
				PlayRow(play: play)
			}.onDelete(perform: $group.plays.remove)
		}
		.navigationTitle("Statistics")
		.toolbar {
			ToolbarItem(placement: .navigationBarTrailing) {
				Button(action: addNewPlay) {
					Image(systemName: "plus")
				}
			}
		}
		.sheet(item: $newPlay) { newPlay in
			NavigationStack {
				RecordPlayView(play: newPlay, group: group)
			}
		}
	}

	private func addNewPlay() {
		self.newPlay = Play()
	}
}

#if DEBUG
struct StatisticsViewPreview: PreviewProvider {
	static var previews: some View {
		NavigationStack {
			StatisticsView(group: PlayGroup())
		}
	}
}
#endif
