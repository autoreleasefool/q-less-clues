import Foundation
import SharedModelsLibrary

extension Play {
	public static let mock = Play(
		id: UUID(uuidString: "00000000-0000-0000-0000-000000000000")!,
		createdAt: Date(),
		letters: "ABCDEFGHIJKL",
		outcome: .solved,
		difficulty: .novice
	)

	public static let mock2 = Play(
		id: UUID(uuidString: "00000000-0000-0000-0000-000000000001")!,
		createdAt: Date(),
		letters: "ABCDEFGHIJKM",
		outcome: .unsolved,
		difficulty: nil
	)
}
