//
//  PlayGroup.swift
//  QLessClues
//
//  Created by Joseph Roque on 2022-09-18.
//

import RealmSwift

class PlayGroup: Object, ObjectKeyIdentifiable {
	@Persisted(primaryKey: true) var _id: ObjectId
	@Persisted var plays = RealmSwift.List<Play>()
}
