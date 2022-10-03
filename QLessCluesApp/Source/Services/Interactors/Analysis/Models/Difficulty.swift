//
//  Difficulty.swift
//  QLessClues
//
//  Created by Joseph Roque on 2022-09-23.
//

import RealmSwift

enum Difficulty: String, CaseIterable, PersistableEnum {
	case novice = "🟢 Novice"
	case intermediate = "🟡 Intermediate"
	case advanced = "🔴 Advanced"
}
