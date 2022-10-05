import Combine
import Foundation
import SwiftUI

public typealias LoadableSubject<Value> = Binding<Loadable<Value>>

public enum Loadable<T> {

	case notRequested
	case isLoading(last: T?, cancelBag: CancelBag)
	case loaded(T)
	case failed(Error)

	public var value: T? {
		switch self {
		case .notRequested, .failed:
			return nil
		case .isLoading(let last, _):
			return last
		case .loaded(let value):
			return value
		}
	}

	public var error: Error? {
		switch self {
		case .notRequested, .isLoading, .loaded:
			return nil
		case .failed(let error):
			return error
		}
	}
}

public extension Loadable {
	mutating func setIsLoading(cancelBag: CancelBag) {
		self = .isLoading(last: value, cancelBag: cancelBag)
	}
}

extension Loadable: Equatable where T: Equatable {
	public static func == (lhs: Loadable<T>, rhs: Loadable<T>) -> Bool {
		switch (lhs, rhs) {
		case (.notRequested, .notRequested): return true
		case let (.isLoading(lhsV, _), .isLoading(rhsV, _)): return lhsV == rhsV
		case let (.loaded(lhsV), .loaded(rhsV)): return lhsV == rhsV
		case let (.failed(lhsE), .failed(rhsE)):
			return lhsE.localizedDescription == rhsE.localizedDescription
		case (.notRequested, _), (.isLoading, _), (.loaded, _), (.failed, _):
			return false
		}
	}
}
