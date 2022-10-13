import ExtensionsLibrary
import Foundation

public struct Play: Hashable, Identifiable, Equatable {
	public let id: UUID
	public let createdAt: Date
	public let letters: String
	public let outcome: Outcome
	public let difficulty: Difficulty?

	public init(
		id: UUID = UUID(),
		createdAt: Date = Date(),
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
	public enum Outcome: String, CaseIterable {
		case unsolved = "❌ Unsolved"
		case solved = "✅ Solved"
		case solvedWithHints = "📝 Solved (with hints)"
	}
}

extension Play {
	public enum Difficulty: String {
		case novice = "🟢 Novice"
		case intermediate = "🟡 Intermediate"
		case advanced = "🔴 Advanced"
	}
}
