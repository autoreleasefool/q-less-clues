//
//  AccountRepository.swift
//  QLessClues
//
//  Created by Joseph Roque on 2022-09-22.
//

import Combine
import Foundation
import KeychainAccess

enum AccountRepositoryError: Error {
	case notFound
	case keychainError(Error)
}

protocol AccountRepository {
	func load() -> AnyPublisher<Account, AccountRepositoryError>
	func remove()
	func save(account: Account)
}

struct AccountRepositoryImpl: AccountRepository {
	private enum Key: String {
		case account
	}

	private let keychain: Keychain

	private let accountEncoder = JSONEncoder()
	private let accountDecoder = JSONDecoder()

	init(keychain: Keychain) {
		self.keychain = keychain
	}

	func load() -> AnyPublisher<Account, AccountRepositoryError> {
		Future<Account, AccountRepositoryError> { promise in
			do {
				guard let accountData = try keychain.getData(Key.account.rawValue),
					let account = try? accountDecoder.decode(Account.self, from: accountData) else {
					return promise(.failure(AccountRepositoryError.notFound))
				}
				promise(.success(account))
			} catch {
				print("Error retrieving login: \(error)")
				promise(.failure(.keychainError(error)))
			}
		}
		.eraseToAnyPublisher()
	}

	func remove() {
		do {
			try keychain.remove(Key.account.rawValue)
		} catch {
			print("Failed to clear account: \(error)")
		}
	}

	func save(account: Account) {
		do {
			let accountData = try accountEncoder.encode(account)
			try keychain.set(accountData, key: Key.account.rawValue)
		} catch {
			print("Error saving login: \(error)")
		}
	}
}

struct AccountRepositoryMock: AccountRepository {
	func load() -> AnyPublisher<Account, AccountRepositoryError> {
		Just(Account(id: UUID(uuidString: "ff8d9f90-9fa2-4943-a653-92e9bdb5be99")!, token: "token"))
			.setFailureType(to: AccountRepositoryError.self)
			.eraseToAnyPublisher()
	}

	func remove() {}
	func save(account: Account) {}
}
