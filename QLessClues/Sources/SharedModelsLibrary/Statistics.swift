import Foundation

public struct Statistics: Equatable {

	private static let formatter: NumberFormatter = {
		let formatter = NumberFormatter()
		formatter.maximumFractionDigits = 1
		return formatter
	}()

	public let pureWins: Int
	public let winsWithHints: Int
	public let losses: Int

	public var pureWinPercentage: String {
		let percent = totalPlays > 0 ? Float(pureWins) / Float(totalPlays) * 100 : 0
		let formatted = Self.formatter.string(from: NSNumber(value: percent))
		let rounded = formatted?.replacingOccurrences(of: ".0", with: "")
		return "\(rounded ?? "0")%"
	}

	public var overallWinPercentage: String {
		let percent = totalPlays > 0 ? Float(pureWins + winsWithHints) / Float(totalPlays) * 100 : 0
		let formatted = Self.formatter.string(from: NSNumber(value: percent))
		let rounded = formatted?.replacingOccurrences(of: ".0", with: "")
		return "\(rounded ?? "0")%"
	}

	public var totalPlays: Int {
		pureWins + winsWithHints + losses
	}

	public init(pureWins: Int, winsWithHints: Int, losses: Int) {
		self.pureWins = pureWins
		self.winsWithHints = winsWithHints
		self.losses = losses
	}
}
