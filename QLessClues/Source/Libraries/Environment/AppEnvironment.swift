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
		let appState = Store(AppState())
		let interactors = configuredInteractors()
		let container = configuredContainer(appState: appState, interactors: interactors)

		return AppEnvironment(container: container)
	}

	private static func configuredInteractors() -> Interactors {
		let validator = BasicValidator()
		let solver = BacktrackingSolver(validator: validator)
		let solutionsInteractor = SolutionsInteractorImpl(solver: solver)

		let analysisInteractor = AnalysisInteractorImpl(solutionsInteractor: solutionsInteractor)

		let hintsInteractor = HintsInteractorImpl()

		return Interactors(
			solutionsInteractor: solutionsInteractor,
			analysisInteractor: analysisInteractor,
			hintsInteractor: hintsInteractor
		)
	}

	private static func configuredContainer(appState: Store<AppState>, interactors: Interactors) -> Container {
		return Container(appState: appState, interactors: interactors)
	}
}
