//
//  Interactors.swift
//  QLessClues
//
//  Created by Joseph Roque on 2022-09-18.
//

struct Interactors {
	let solutionsInteractor: SolutionsInteractor

	init(solutionsInteractor: SolutionsInteractor) {
		self.solutionsInteractor = solutionsInteractor
	}

	static var stub: Self {
		.init(solutionsInteractor: SolutionsInteractorStub())
	}
}
