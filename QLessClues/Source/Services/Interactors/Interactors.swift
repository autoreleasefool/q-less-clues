//
//  Interactors.swift
//  QLessClues
//
//  Created by Joseph Roque on 2022-09-18.
//

struct Interactors {
	let solutionsInteractor: SolutionsInteractor
	let analysisInteractor: AnalysisInteractor

	init(solutionsInteractor: SolutionsInteractor, analysisInteractor: AnalysisInteractor) {
		self.solutionsInteractor = solutionsInteractor
		self.analysisInteractor = analysisInteractor
	}

	static var stub: Self {
		.init(solutionsInteractor: SolutionsInteractorStub(), analysisInteractor: AnalysisInteractorStub())
	}
}
