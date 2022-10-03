//
//  SolutionDetailView.swift
//  QLessClues
//
//  Created by Joseph Roque on 2022-09-07.
//

import SwiftUI

struct SolutionDetailView: View {

	let solution: Solution

	var body: some View {
		ScrollView([.vertical, .horizontal]) {
			Grid {
				ForEach(solution.rows, id: \.self) { row in
					GridRow {
						ForEach(solution.columns, id: \.self) { column in
							Tile(character: solution.characterAt(row: row, column: column))
						}
					}
				}
			}
			.padding()
		}
	}
}
