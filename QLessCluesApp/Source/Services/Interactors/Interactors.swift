//
//  Interactors.swift
//  QLessClues
//
//  Created by Joseph Roque on 2022-09-18.
//

struct Interactors {
	let analysisInteractor: AnalysisInteractor

	init(analysisInteractor: AnalysisInteractor) {
		self.analysisInteractor = analysisInteractor
	}

	static var stub: Self {
		.init(analysisInteractor: AnalysisInteractorStub())
	}
}
