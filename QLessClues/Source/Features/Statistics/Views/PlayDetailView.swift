//
//  PlayDetailView.swift
//  QLessClues
//
//  Created by Joseph Roque on 2022-09-18.
//

import RealmSwift
import SwiftUI

struct PlayDetailView: View {

	@ObservedRealmObject var play: Play

	var body: some View {
		VStack {
			Text(play.letters)
			Button("Delete") {
				if let deletable = play.thaw(), let realm = deletable.realm {
					try? realm.write {
						realm.delete(deletable)
					}
				}
			}
		}
	}
}
