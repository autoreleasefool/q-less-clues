//
//  SolutionsListScreen.swift
//  QLessClues
//
//  Created by Joseph Roque on 2022-09-07.
//

import SwiftUI

struct SolutionsListScreen: View {

	@Binding private var solutions: [Solution]

	init(solutions: Binding<[Solution]>) {
		self._solutions = solutions
	}

	var body: some View {
		Group {
			if solutions.isEmpty {
				emptyState
			} else {
				solutionsList
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
				SolutionDetailsScreen(solution: solution)
			} label: {
				Text(solution.words.joined(separator: ", "))
			}
		}
	}
}
