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
	let accountInteractor: AccountInteractor

	init(
		solutionsInteractor: SolutionsInteractor,
		analysisInteractor: AnalysisInteractor,
		hintsInteractor: HintsInteractor,
		accountInteractor: AccountInteractor
	) {
		self.solutionsInteractor = solutionsInteractor
		self.analysisInteractor = analysisInteractor
		self.hintsInteractor = hintsInteractor
		self.accountInteractor = accountInteractor
	}

	static var stub: Self {
		.init(
			solutionsInteractor: SolutionsInteractorStub(),
			analysisInteractor: AnalysisInteractorStub(),
			hintsInteractor: HintsInteractorStub(),
			accountInteractor: AccountInteractorStub(appState: Store(AppState()))
		)
	}
}
