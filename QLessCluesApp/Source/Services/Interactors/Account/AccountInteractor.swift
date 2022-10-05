//
//  AccountInteractor.swift
//  QLessClues
//
//  Created by Joseph Roque on 2022-09-21.
//

import Foundation
import NetworkingService

protocol AccountInteractor {
	func load()
	func remove()
}

struct AccountInteractorImpl: AccountInteractor {
	let repository: AccountRepository
	let appState: Store<AppState>

	func load() {
		// Only allow one account to be loaded at a time
		guard case .notRequested = appState[\.account] else { return }

		let cancelBag = CancelBag()
		appState[\.account].setIsLoading(cancelBag: cancelBag)

		weak var weakState = appState
		repository.load()
			.receive(on: DispatchQueue.main)
			.sinkToLoadable { weakState?[\.account] = $0 }
			.store(in: cancelBag)
	}

	func remove() {
		appState[\.account] = .notRequested
		repository.remove()
	}
}

// MARK: - Stub

struct AccountInteractorStub: AccountInteractor {
	let appState: Store<AppState>

	func load() {
		appState[\.account] = .loaded(Account(id: UUID(uuidString: "ff8d9f90-9fa2-4943-a653-92e9bdb5be99")!, token: "token"))
	}

	func remove() {
		appState[\.account] = .notRequested
	}
}
