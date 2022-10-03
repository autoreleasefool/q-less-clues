//
//  StatisticsCalculator.swift
//  QLessClues
//
//  Created by Joseph Roque on 2022-09-19.
//

import Foundation

struct Statistics {

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

	init(group: PlayGroup) {
		pureWins = group.plays.where({ $0.outcome.equals(.solved) }).count
		winsWithHints = group.plays.where({ $0.outcome.equals(.solvedWithHints) }).count
		losses = group.plays.where({ $0.outcome.equals(.unsolved) }).count
	}
}
