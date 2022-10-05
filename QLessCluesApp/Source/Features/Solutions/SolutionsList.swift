//
//  SolutionsList.swift
//  QLessClues
//
//  Created by Joseph Roque on 2022-09-07.
//

import SharedModelsLibrary
import SwiftUI

struct SolutionsList: View {

	let solutions: [Solution]
	@State private var search = ""

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
		List(filteredSolutions, id: \.id) {
			SolutionRow(solution: $0)
		}
		.searchable(text: $search)
	}
}

// MARK: - Content

extension SolutionsList {
	private var filteredSolutions: [Solution] {
		let filter = search.uppercased()
		return solutions
			.filter { filter.isEmpty || $0.description.contains(filter) }
	}
}
