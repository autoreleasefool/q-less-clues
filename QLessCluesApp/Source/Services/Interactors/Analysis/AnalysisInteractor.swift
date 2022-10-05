//
//  AnalysisInteractor.swift
//  QLessClues
//
//  Created by Joseph Roque on 2022-09-23.
//

import Combine
import Foundation
import SharedModelsLibrary

protocol AnalysisInteractor {
	func analyze(letters: String, analysis: LoadableSubject<Analysis>)
	func cancel()
}

struct AnalysisInteractorImpl: AnalysisInteractor {
	private let solutionsInteractor: SolutionsInteractor

	init(solutionsInteractor: SolutionsInteractor) {
		self.solutionsInteractor = solutionsInteractor
	}

	func cancel() {
		solutionsInteractor.cancel()
	}

	func analyze(letters: String, analysis: LoadableSubject<Analysis>) {
		let cancelBag = CancelBag()
		analysis.wrappedValue.setIsLoading(cancelBag: cancelBag)

		var solutionsLoadable: Loadable<[Solution]> = .notRequested
		var progressLoadable: Loadable<Float> = .notRequested

		let solutions: LoadableSubject<[Solution]> = .init {
			solutionsLoadable
		} set: {
			solutionsLoadable = $0
			updateAnalysis(analysis, solutions: $0, progress: progressLoadable, cancelBag: cancelBag)
		}

		let progress: LoadableSubject<Float> = .init {
			progressLoadable
		} set: {
			progressLoadable = $0
			updateAnalysis(analysis, solutions: solutionsLoadable, progress: $0, cancelBag: cancelBag)
		}

		solutionsInteractor.solutions(forLetters: letters, solutions: solutions, progress: progress)
	}

	private func updateAnalysis(
		_ analysis: LoadableSubject<Analysis>,
		solutions: Loadable<[Solution]>,
		progress: Loadable<Float>,
		cancelBag: CancelBag
	) {
		switch solutions {
		case .notRequested:
			analysis.wrappedValue = .notRequested
		case .isLoading(let someSolutions, _):
			analysis.wrappedValue =
				.isLoading(last: compileAnalysis(from: someSolutions, progress: progress.value), cancelBag: cancelBag)
		case .loaded(let allSolutions):
			analysis.wrappedValue = .loaded(compileAnalysis(from: allSolutions, progress: progress.value))
		case .failed(let error):
			analysis.wrappedValue = .failed(error)
		}
	}

	private func compileAnalysis(from solutions: [Solution]?, progress: Float?) -> Analysis {
		guard let solutions, let progress else {
			return Analysis(progress: progress, difficulty: nil, solutions: solutions ?? [])
		}

		if solutions.count > 100 {
			return Analysis(progress: progress, difficulty: .novice, solutions: solutions)
		} else if solutions.count > 30 {
			if progress > 0.5 {
				return Analysis(progress: progress, difficulty: .intermediate, solutions: solutions)
			} else {
				return Analysis(progress: progress, difficulty: .novice, solutions: solutions)
			}
		} else {
			if progress > 0.5 {
				return Analysis(progress: progress, difficulty: .advanced, solutions: solutions)
			} else {
				return Analysis(progress: progress, difficulty: .intermediate, solutions: solutions)
			}
		}
	}
}

struct AnalysisInteractorStub: AnalysisInteractor {
	func analyze(letters: String, analysis: LoadableSubject<Analysis>) {
		analysis.wrappedValue = .loaded(Analysis(progress: 1, difficulty: .novice, solutions: []))
	}

	func cancel() {}
}
