//
//  QLessCluesApp.swift
//  QLessClues
//
//  Created by Joseph Roque on 2022-09-04.
//

import SwiftUI

@main
struct QLessCluesApp: App {

	@StateObject var environment: AppEnvironment = .bootstrap()

	var body: some Scene {
		WindowGroup {
			NavigationStack {
				ContentView()
			}
			.environment(\.container, environment.container)
			.onAppear {
				DispatchQueue.global().async {
					_ = WordSet.englishSet
					_ = WordFrequency.englishFrequencies
				}
			}
		}
	}
}
