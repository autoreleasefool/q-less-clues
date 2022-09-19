//
//  ContentView.swift
//  QLessClues
//
//  Created by Joseph Roque on 2022-09-18.
//

import RealmSwift
import SwiftUI

struct ContentView: View {

	@ObservedResults(PlayGroup.self) var groups

	var body: some View {
		if let group = groups.first {
			StatisticsView(group: group)
		} else {
			ProgressView()
				.onAppear {
					$groups.append(PlayGroup())
				}
		}
	}
}
