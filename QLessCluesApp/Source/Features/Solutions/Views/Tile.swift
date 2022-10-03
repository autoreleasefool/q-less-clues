//
//  Tile.swift
//  QLessClues
//
//  Created by Joseph Roque on 2022-09-07.
//

import SwiftUI

struct Tile: View {

	let character: Character

	var body: some View {
		if character == " " {
			Text(String(character))
				.frame(width: 48, height: 48)
		} else {
			Text(String(character))
				.frame(width: 48, height: 48)
				.background(Color(red: 0.78, green: 0.61, blue: 0.48))
				.shadow(color: .black, radius: 4, x: 2, y: 2)
		}
	}
}
