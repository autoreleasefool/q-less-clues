import ExtensionsLibrary
import Foundation

public struct Play: Equatable, Identifiable, Hashable, Codable {
	public let id: UUID
	public let createdAt: Date
	public let letters: String
	public let outcome: Outcome
	public let difficulty: Difficulty?

	public init(
		id: UUID,
		createdAt: Date,
		letters: String,
		outcome: Outcome,
		difficulty: Difficulty?
	) {
		self.id = id
		self.createdAt = createdAt
		self.letters = letters
		self.outcome = outcome
		self.difficulty = difficulty
	}

	var createdAtRelative: String {
		Calendar.current.startOfDay(for: createdAt).formattedRelative
	}
}

extension Play {
	public enum Outcome: Int, CaseIterable, Codable, CustomStringConvertible, Identifiable {
		case unsolved
		case solved
		case solvedWithHints

		public var id: Int { rawValue }

		public var description: String {
			switch self {
			case .unsolved: return "❌ Unsolved"
			case .solved: return "✅ Solved"
			case .solvedWithHints: return "📝 Solved (with hints)"
			}
		}
	}
}

extension Play {
	public enum Difficulty: Int, CaseIterable, Codable, CustomStringConvertible {
		case novice
		case intermediate
		case advanced

		public var description: String {
			switch self {
			case .novice: return "🟢 Novice"
			case .intermediate: return "🟡 Intermediate"
			case .advanced: return "🔴 Advanced"
			}
		}
	}
}
