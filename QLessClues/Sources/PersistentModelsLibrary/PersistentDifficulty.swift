import RealmSwift
import SharedModelsLibrary

public enum PersistentDifficulty: String, CaseIterable, PersistableEnum {
	case novice
	case intermediate
	case advanced

	public func asDifficulty() -> Play.Difficulty {
		switch self {
		case .advanced:
			return .advanced
		case .intermediate:
			return .intermediate
		case .novice:
			return .novice
		}
	}
}

extension Play.Difficulty {
	public func asPersistent() -> PersistentDifficulty {
		switch self {
		case .novice:
			return .novice
		case .intermediate:
			return .intermediate
		case .advanced:
			return .advanced
		}
	}
}
