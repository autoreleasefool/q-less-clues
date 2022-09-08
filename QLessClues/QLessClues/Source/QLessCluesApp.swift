//
//  QLessCluesApp.swift
//  QLessClues
//
//  Created by Joseph Roque on 2022-09-04.
//

import SwiftUI

@main
struct QLessCluesApp: App {
	var body: some Scene {
		WindowGroup {
			NavigationStack {
				StatisticsScreen()
			}
			.onAppear {
				DispatchQueue.global().async {
					_ = WordSet.englishSet
				}
			}
		}
	}
}
