//
//  StatisticsScreen.swift
//  QLessClues
//
//  Created by Joseph Roque on 2022-09-04.
//

import Foundation
import RealmSwift
import SwiftUI

struct StatisticsView: View {

	@ObservedRealmObject var group: PlayGroup
	@State private var newPlay: Play?
	@State private var settingsOpen = false

	var body: some View {
		List {
			statistics(Statistics(group: group))

			if group.plays.isEmpty {
				Section("Recent Plays") {
					emptyState
				}
			} else {
				playsList
			}
		}
		.navigationTitle("Statistics")
		.toolbar {
			ToolbarItem(placement: .navigationBarLeading) {
				Button(action: openSettings) {
					Image(systemName: "gear")
				}
			}

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
		.sheet(isPresented: $settingsOpen) {
			NavigationStack {
				SettingsView()
			}
		}
	}
}

// MARK: - Content

extension StatisticsView {
	@ViewBuilder private func statistics(_ stats: Statistics) -> some View {
		HStack {
			Spacer()
			VStack(alignment: .center) {
				Text(stats.pureWinPercentage)
					.font(.largeTitle)
				Text("Wins")
			}
			Spacer()
			VStack(alignment: .center) {
				Text(stats.overallWinPercentage)
					.font(.largeTitle)
				Text("With hints")
			}
			Spacer()
		}
		LabeledContent("Wins", value: "\(stats.pureWins)")
		LabeledContent("Wins (with hints)", value: "\(stats.winsWithHints)")
		LabeledContent("Losses", value: "\(stats.losses)")
		LabeledContent("Total Plays", value: "\(stats.totalPlays)")
	}

	private var emptyState: some View {
		Text("You haven't added any plays yet")
	}

	private var playsList: some View {
		ForEach(group.plays.sectioned(by: \.createdAtRelative, ascending: false)) { section in
			Section(section.key) {
				ForEach(section) { play in
					PlayRow(play: play)
				}.onDelete(perform: $group.plays.remove)
			}
		}
	}
}

// MARK: - Actions

extension StatisticsView {
	private func openSettings() {
		settingsOpen.toggle()
	}

	private func addNewPlay() {
		newPlay = Play()
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
