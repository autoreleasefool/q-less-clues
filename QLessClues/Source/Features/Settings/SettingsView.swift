//
//  SettingsView.swift
//  QLessClues
//
//  Created by Joseph Roque on 2022-09-28.
//

import AuthenticationServices
import SwiftUI

struct SettingsView: View {

	@Environment(\.container) private var container

	@State private var account: Loadable<Account>
	@State private var isLoggingOut = false

	init(account: Loadable<Account> = .notRequested) {
		self._account = .init(initialValue: account)
	}

	var body: some View {
		List {
			accountSettings
		}
		.confirmationDialog("Are you sure?", isPresented: $isLoggingOut) {
			Button(role: .destructive, action: logout) {
				Text("Logout")
			}
		}
	}
}

// NARK: - Account Settings

extension SettingsView {

	@ViewBuilder private var accountSettings: some View {
		switch account {
		case .notRequested:
			accountNotRequested
		case .isLoading:
			ProgressView()
		case .loaded(let account):
			accountView(account)
		case .failed:
			logInButton
		}
	}

	private var accountNotRequested: some View {
		Text("")
			.onAppear(perform: loadAccount)
	}

	private var logInButton: some View {
		Section {
			SignInWithAppleButton(onRequest: { _ in }, onCompletion: { _ in })
				.padding(0)
//				.listRowInsets(.)
		}
	}

	private func accountView(_ account: Account) -> some View {
		Section("Account") {
			Button(role: .destructive, action: promptLogout) {
				Text("Logout")
			}
		}
	}
}

// MARK: - Actions

extension SettingsView {
	private func loadAccount() {
		container.interactors.accountInteractor.load()
	}

	private func promptLogout() {
		isLoggingOut.toggle()
	}

	private func logout() {
		container.interactors.accountInteractor.remove()
	}
}
