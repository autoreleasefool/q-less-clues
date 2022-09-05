//
//  SolvedState.swift
//  QLessClues
//
//  Created by Joseph Roque on 2022-09-04.
//

import Foundation

enum SolvedState: CaseIterable, Codable, Equatable {
	case solved
	case solvedWithHints
	case unsolved
}
