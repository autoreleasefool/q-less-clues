//
//  DifficultyView.swift
//  QLessClues
//
//  Created by Joseph Roque on 2022-09-24.
//

import SwiftUI

struct DifficultyView: View {

	let difficulty: Difficulty?

	var body: some View {
		LabeledContent("Difficulty", value: difficultyLabel)
	}
}

// MARK: - Content

extension DifficultyView {
	private var difficultyLabel: String {
		guard let difficulty else {
			return "❓ Undetermined"
		}

		return difficulty.rawValue
	}
}
