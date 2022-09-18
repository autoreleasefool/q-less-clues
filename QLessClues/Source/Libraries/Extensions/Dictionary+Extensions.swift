//
//  Dictionary+Extensions.swift
//  QLessClues
//
//  Created by Joseph Roque on 2022-09-17.
//

import Foundation

extension Dictionary where Key == Position, Value == Character {
	var columns: ClosedRange<Int> {
		let (min, max) = self.keys.reduce(into: (min: 0, max: 0)) { out, next in
			out.max = Swift.max(out.max, next.column)
			out.min = Swift.min(out.min, next.column)
		}

		return min...max
	}

	var rows: ClosedRange<Int> {
		let (min, max) = self.keys.reduce(into: (min: 0, max: 0)) { out, next in
			out.max = Swift.max(out.max, next.row)
			out.min = Swift.min(out.min, next.row)
		}

		return min...max
	}
}
