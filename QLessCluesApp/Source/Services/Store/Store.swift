//
//  Store.swift
//  QLessClues
//
//  Created by Joseph Roque on 2022-09-22.
//

import Combine

typealias Store<Value> = CurrentValueSubject<Value, Never>

extension Store {
	subscript<T>(keyPath: WritableKeyPath<Output, T>) -> T where T: Equatable {
		get { value[keyPath: keyPath] }
		set {
			var value = self.value
			if value[keyPath: keyPath] != newValue {
				value[keyPath: keyPath] = newValue
				self.value = value
			}
		}
	}
}
