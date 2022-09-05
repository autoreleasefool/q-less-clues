//
//  Position.swift
//  QLessClues
//
//  Created by Joseph Roque on 2022-09-05.
//

import Foundation

struct Position: Codable, Equatable, Hashable {
	let row: Int
	let column: Int

	init(row: Int, column: Int) {
		self.row = row
		self.column = column
	}

	init(_ row: Int, _ column: Int) {
		self.row = row
		self.column = column
	}
}
