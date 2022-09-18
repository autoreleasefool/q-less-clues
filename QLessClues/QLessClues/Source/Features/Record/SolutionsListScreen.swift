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
		List(solutions, id: \.id) { solution in
			NavigationLink {
				SolutionDetailsScreen(solution: solution)
			} label: {
				Text(solution.words.joined(separator: ", "))
			}
		}
		.navigationTitle("Solutions")
	}
}
