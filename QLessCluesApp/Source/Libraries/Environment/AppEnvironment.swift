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
		let appState = Store(AppState())
		let repositories = configuredRepositories()
		let interactors = configuredInteractors(repositories: repositories, appState: appState)
		let container = configuredContainer(appState: appState, interactors: interactors)

		return AppEnvironment(container: container)
	}

	private static func configuredRepositories() -> Container.Repositories {
		let accountRepository = AccountRepositoryImpl(keychain: Keychain())

		return Container.Repositories(accountRepository: accountRepository)
	}

	private static func configuredInteractors(
		repositories: Container.Repositories,
		appState: Store<AppState>
	) -> Interactors {
		let validator = BasicValidator()
		let solver = BacktrackingSolver(validator: validator)
		let solutionsInteractor = SolutionsInteractorImpl(solver: solver)

		let analysisInteractor = AnalysisInteractorImpl(solutionsInteractor: solutionsInteractor)

		let hintsInteractor = HintsInteractorImpl()

		let accountInteractor = AccountInteractorImpl(repository: repositories.accountRepository, appState: appState)

		return Interactors(
			solutionsInteractor: solutionsInteractor,
			analysisInteractor: analysisInteractor,
			hintsInteractor: hintsInteractor,
			accountInteractor: accountInteractor
		)
	}

	private static func configuredContainer(appState: Store<AppState>, interactors: Interactors) -> Container {
		return Container(appState: appState, interactors: interactors)
	}
}

private extension Container {
	struct Repositories {
		let accountRepository: AccountRepository
	}
}
