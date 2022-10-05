//
//  SolutionRow.swift
//  QLessClues
//
//  Created by Joseph Roque on 2022-09-28.
//

import SharedModelsLibrary
import SwiftUI

struct SolutionRow: View {
	let solution: Solution

	var body: some View {
		NavigationLink {
			SolutionDetailView(solution: solution)
		} label: {
			Text(solution.description)
		}
	}
}
