import SharedModelsLibrary
import SwiftUI

public struct StatisticsOverview: View {
	let statistics: Statistics

	public init(statistics: Statistics) {
		self.statistics = statistics
	}

	public var body: some View {
		Section {
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

				VStack(alignment: .center) {
					Text(statistics.lossPercentage)
						.font(.largeTitle)
					Text("Losses")
				}
				.frame(maxWidth: .infinity)
			}
		}

		Section {
			LabeledContent("Wins", value: "\(statistics.pureWins)")
			LabeledContent("Wins (with hints)", value: "\(statistics.winsWithHints)")
			LabeledContent("Losses", value: "\(statistics.losses)")
			LabeledContent("Total Plays", value: "\(statistics.totalPlays)")
		}
	}
}
