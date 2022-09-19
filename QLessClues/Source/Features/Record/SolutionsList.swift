//
//  SolutionsList.swift
//  QLessClues
//
//  Created by Joseph Roque on 2022-09-07.
//

import SwiftUI

struct SolutionsList: View {

	@Binding private var solutions: Loadable<[Solution]>

	init(solutions: LoadableSubject<[Solution]>) {
		self._solutions = solutions
	}

	var body: some View {
		Group {
			if solutions.value?.isEmpty != false {
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
		List(solutions.value ?? [], id: \.id) { solution in
			NavigationLink {
				SolutionDetailsScreen(solution: solution)
			} label: {
				Text(solution.words.joined(separator: ", "))
			}
		}
	}
}
