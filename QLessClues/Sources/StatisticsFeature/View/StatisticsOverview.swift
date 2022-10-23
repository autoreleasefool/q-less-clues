import SharedModelsLibrary
import SwiftUI

struct StatisticsOverview: View {
	let statistics: Statistics

	var body: some View {
		HStack {
			VStack(alignment: .center) {
				Text(statistics.pureWinPercentage)
					.font(.largeTitle)
				Text("Wins")
			}
			.frame(maxWidth: .infinity)
			VStack(alignment: .center) {
				Text(statistics.overallWinPercentage)
					.font(.largeTitle)
				Text("With hints")
			}
			.frame(maxWidth: .infinity)
		}
		LabeledContent("Wins", value: "\(statistics.pureWins)")
		LabeledContent("Wins (with hints)", value: "\(statistics.winsWithHints)")
		LabeledContent("Losses", value: "\(statistics.losses)")
		LabeledContent("Total Plays", value: "\(statistics.totalPlays)")
	}
}
