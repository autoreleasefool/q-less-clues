//
//  SolutionsListScreen.swift
//  QLessClues
//
//  Created by Joseph Roque on 2022-09-07.
//

import SwiftUI

struct SolutionsListScreen: View {

	@ObservedObject var solutionsController: SolutionsController

	var body: some View {
		List(solutionsController.solutions, id: \.id) { solution in
			NavigationLink {
				SolutionDetailsScreen(solution: solution)
			} label: {
				Text(solution.words.joined(separator: ", "))
			}
		}
		.navigationTitle("Solutions")
	}
}
