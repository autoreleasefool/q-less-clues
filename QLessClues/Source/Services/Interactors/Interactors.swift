//
//  Interactors.swift
//  QLessClues
//
//  Created by Joseph Roque on 2022-09-18.
//

struct Interactors {
	let solutionsInteractor: SolutionsInteractor
	let analysisInteractor: AnalysisInteractor
	let hintsInteractor: HintsInteractor

	init(
		solutionsInteractor: SolutionsInteractor,
		analysisInteractor: AnalysisInteractor,
		hintsInteractor: HintsInteractor
	) {
		self.solutionsInteractor = solutionsInteractor
		self.analysisInteractor = analysisInteractor
		self.hintsInteractor = hintsInteractor
	}

	static var stub: Self {
		.init(
			solutionsInteractor: SolutionsInteractorStub(),
			analysisInteractor: AnalysisInteractorStub(),
			hintsInteractor: HintsInteractorStub()
		)
	}
}
