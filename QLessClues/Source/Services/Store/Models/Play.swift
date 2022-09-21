//
//  Play.swift
//  QLessClues
//
//  Created by Joseph Roque on 2022-09-17.
//

import Foundation
import RealmSwift

class Play: Object, ObjectKeyIdentifiable {
	@Persisted(primaryKey: true) var _id: ObjectId
	@Persisted var createdAt = Date()
	@Persisted var letters = ""
	@Persisted var outcome: Outcome = .unsolved

	@Persisted(originProperty: "plays") var group: LinkingObjects<PlayGroup>

	var isPlayable: Bool {
		letters.count == 12
	}

	var createdAtRelative: String {
		Calendar.current.startOfDay(for: createdAt).formattedRelative
	}

	private static let formatter: RelativeDateTimeFormatter = {
		let formatter = RelativeDateTimeFormatter()
		formatter.dateTimeStyle = .named
		return formatter
	}()
}

extension Play {
	enum Outcome: String, CaseIterable, PersistableEnum {
		case unsolved = "❌ Unsolved"
		case solved = "✅ Solved"
		case solvedWithHints = "📝 Solved (with hints)"
	}
}
