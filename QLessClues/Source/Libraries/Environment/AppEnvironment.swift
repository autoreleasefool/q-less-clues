//
//  AppEnvironment.swift
//  QLessClues
//
//  Created by Joseph Roque on 2022-09-18.
//

import Foundation

final class AppEnvironment: ObservableObject {
	let dependencies: Dependencies

	init(dependencies: Dependencies) {
		self.dependencies = dependencies
	}
}

extension AppEnvironment {

	static func bootstrap() -> AppEnvironment {
		let interactors = configuredInteractors()
		let dependencies = configuredDependencies(interactors: interactors)

		return AppEnvironment(dependencies: dependencies)
	}

	private static func configuredInteractors() -> Interactors {
		let validator = BasicValidator()
		let solver = BacktrackingSolver(validator: validator)
		let solutionsInteractor = SolutionsInteractorImpl(solver: solver)

		return Interactors(solutionsInteractor: solutionsInteractor)
	}

	private static func configuredDependencies(interactors: Interactors) -> Dependencies {
		return Dependencies(interactors: interactors)
	}
}
