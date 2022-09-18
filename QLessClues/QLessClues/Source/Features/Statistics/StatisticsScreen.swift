//
//  StatisticsScreen.swift
//  QLessClues
//
//  Created by Joseph Roque on 2022-09-04.
//

import SwiftUI

struct StatisticsScreen: View {

	@State private var addingPlay = false

	var body: some View {
		Group {
			Text("Statistics")
		}
		.navigationTitle("Statistics")
		.toolbar {
			ToolbarItemGroup(placement: .navigationBarTrailing) {
				Button {
					addingPlay = true
				} label: {
					Image(systemName: "plus")
				}
			}
		}
		.sheet(isPresented: $addingPlay) {
			NavigationStack {
				RecordPlayScreen()
			}
		}
	}
}
