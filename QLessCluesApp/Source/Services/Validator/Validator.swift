//
//  Validator.swift
//  QLessClues
//
//  Created by Joseph Roque on 2022-09-05.
//

import Foundation

protocol Validator {
	func validate(solution: Solution) -> Bool
}
