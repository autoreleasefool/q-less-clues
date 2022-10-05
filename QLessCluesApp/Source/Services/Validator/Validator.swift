//
//  Validator.swift
//  QLessClues
//
//  Created by Joseph Roque on 2022-09-05.
//

import Foundation
import SharedModelsLibrary

protocol Validator {
	func validate(solution: Solution) -> Bool
}
