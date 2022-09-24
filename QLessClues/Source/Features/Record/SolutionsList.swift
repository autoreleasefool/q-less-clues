//
//  SolutionsList.swift
//  QLessClues
//
//  Created by Joseph Roque on 2022-09-07.
//

import SwiftUI

struct SolutionsList: View {

	let solutions: [Solution]

	var body: some View {
		Group {
			if solutions.isEmpty == false {
				solutionsList
			} else {
				emptyState
			}
		}
		.navigationTitle("Solutions")
	}

	private var emptyState: some View {
		List {
			Text("No solutions have been found yet.")
		}
	}

	private var solutionsList: some View {
		List(solutions, id: \.id) { solution in
			NavigationLink {
				SolutionDetailView(solution: solution)
			} label: {
				Text(solution.words.joined(separator: ", "))
			}
		}
	}
}
