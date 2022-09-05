//
//  StatisticsScreen.swift
//  QLessClues
//
//  Created by Joseph Roque on 2022-09-04.
//

import SwiftUI

struct StatisticsScreen: View {

	@StateObject private var playsController = PlaysController()
	@State private var newPlay: Play?

	var body: some View {
		List(playsController.plays) { _ in
			EmptyView()
		}
		.navigationTitle("Statistics")
		.toolbar {
			ToolbarItemGroup(placement: .navigationBarTrailing) {
				Button {
					newPlay = playsController.new()
				} label: {
					Image(systemName: "plus")
				}
			}
		}
		.sheet(item: $newPlay) { newPlay in
			NavigationStack {
				RecordPlayScreen(newPlay)
			}
		}
	}
}
