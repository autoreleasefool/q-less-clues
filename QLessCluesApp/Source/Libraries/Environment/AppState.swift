//
//  AppState.swift
//  QLessClues
//
//  Created by Joseph Roque on 2022-09-22.
//

struct AppState: Equatable {
	var account: Loadable<Account> = .notRequested
}
