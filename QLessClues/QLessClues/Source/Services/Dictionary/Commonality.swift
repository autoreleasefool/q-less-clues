//
//  Commonality.swift
//  QLessClues
//
//  Created by Joseph Roque on 2022-09-05.
//

import Foundation

enum LetterCommonality {

	static let fullAlphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"

	static let commonality: [Character: Int] = {
		var commonality: [Character: Int] = fullAlphabet.reduce(into: [:]) { $0[$1] = 0 }
		commonality = WordSet.englishWords.reduce(into: commonality) { commonality, word in
			word.forEach { commonality[$0] = commonality[$0]! + 1 }
		}
		return commonality
	}()

	static let sortedByLeastCommon: [Character] = {
		fullAlphabet.sorted { commonality[$0]! < commonality[$1]! }
	}()

	static let sortedByMostCommon: [Character] = {
		sortedByLeastCommon.reversed()
	}()
}
