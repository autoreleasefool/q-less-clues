//
//  AppEnvironment.swift
//  QLessClues
//
//  Created by Joseph Roque on 2022-09-18.
//

import Foundation

final class AppEnvironment: ObservableObject {
	let container: Container

	init(container: Container) {
		self.container = container
	}
}

extension AppEnvironment {

	static func bootstrap() -> AppEnvironment {
		let interactors = configuredInteractors()
		let container = configuredContainer(interactors: interactors)

		return AppEnvironment(container: container)
	}

	private static func configuredInteractors() -> Interactors {
		let validator = BasicValidator()
		let solver = BacktrackingSolver(validator: validator)
		let solutionsInteractor = SolutionsInteractorImpl(solver: solver)

		return Interactors(solutionsInteractor: solutionsInteractor)
	}

	private static func configuredContainer(interactors: Interactors) -> Container {
		return Container(interactors: interactors)
	}
}
