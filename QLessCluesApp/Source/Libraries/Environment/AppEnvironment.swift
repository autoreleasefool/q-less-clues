//
//  AppEnvironment.swift
//  QLessClues
//
//  Created by Joseph Roque on 2022-09-18.
//

import Foundation
import KeychainAccess
import ValidatorService

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
		let analysisInteractor = AnalysisInteractorImpl(solutionsInteractor: solutionsInteractor)

		return Interactors(analysisInteractor: analysisInteractor)
	}

	private static func configuredContainer(interactors: Interactors) -> Container {
		return Container(interactors: interactors)
	}
}
