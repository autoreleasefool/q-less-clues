//
//  Container.swift
//  QLessClues
//
//  Created by Joseph Roque on 2022-09-18.
//

import SwiftUI

struct Container: EnvironmentKey {
	let interactors: Interactors

	static var defaultValue: Self { Self.default }
	private static let `default` = Self(interactors: .stub)
}

extension EnvironmentValues {
	var container: Container {
		get { self[Container.self] }
		set { self[Container.self] = newValue }
	}
}
