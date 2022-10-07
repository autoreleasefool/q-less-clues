import SharedModelsLibrary
import SwiftUI

struct SolutionDetailsView: View {
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
