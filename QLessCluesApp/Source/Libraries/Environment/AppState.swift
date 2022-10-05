//
//  AppState.swift
//  QLessClues
//
//  Created by Joseph Roque on 2022-09-22.
//

import NetworkingService

struct AppState: Equatable {
	var account: Loadable<Account> = .notRequested
}
