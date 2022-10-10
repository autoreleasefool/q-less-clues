import RealmSwift
import SharedModelsLibrary

public enum PersistentOutcome: String, CaseIterable, PersistableEnum {
	case unsolved
	case solvedWithHints
	case solved

	public func asOutcome() -> Play.Outcome {
		switch self {
		case .unsolved:
			return .unsolved
		case .solvedWithHints:
			return .solvedWithHints
		case .solved:
			return .solved
		}
	}
}

extension Play.Outcome {
	public func asPersistent() -> PersistentOutcome {
		switch self {
		case .unsolved:
			return .unsolved
		case .solved:
			return .solved
		case .solvedWithHints:
			return .solvedWithHints
		}
	}
}
