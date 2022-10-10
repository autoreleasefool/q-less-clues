import Foundation
import SharedModelsLibrary

extension Play {
	public static let mock = Play(
		id: "00000000-0000-0000-0000-000000000000",
		createdAt: Date(),
		letters: "ABCDEFGHIJKL",
		outcome: .solved,
		difficulty: .novice
	)
}
