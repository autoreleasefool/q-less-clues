import Foundation
import SharedModelsLibrary

public struct Statistics: Equatable {

	private static let formatter: NumberFormatter = {
		let formatter = NumberFormatter()
		formatter.maximumFractionDigits = 1
		return formatter
	}()

	let pureWins: Int
	let winsWithHints: Int
	let losses: Int

	var pureWinPercentage: String {
		let percent = totalPlays > 0 ? Float(pureWins) / Float(totalPlays) * 100 : 0
		let formatted = Self.formatter.string(from: NSNumber(value: percent))
		let rounded = formatted?.replacingOccurrences(of: ".0", with: "")
		return "\(rounded ?? "0")%"
	}

	var overallWinPercentage: String {
		let percent = totalPlays > 0 ? Float(pureWins + winsWithHints) / Float(totalPlays) * 100 : 0
		let formatted = Self.formatter.string(from: NSNumber(value: percent))
		let rounded = formatted?.replacingOccurrences(of: ".0", with: "")
		return "\(rounded ?? "0")%"
	}

	var totalPlays: Int {
		pureWins + winsWithHints + losses
	}

	init(plays: [Play]) {
		pureWins = plays.filter { $0.outcome == .solved }.count
		winsWithHints = plays.filter { $0.outcome == .solvedWithHints }.count
		losses = plays.filter { $0.outcome == .unsolved }.count
	}
}
