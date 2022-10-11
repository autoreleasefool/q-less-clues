import AppFeature
import ComposableArchitecture
import SolverService
import SwiftUI
import ValidatorService

struct ContentView: View {
	let store = Store(
		initialState: AppState(),
		reducer: appReducer,
		environment: AppEnvironment(
			solverService: .live(with: .init(validatorService: .live)),
			validatorService: .live
		)
	)

	var body: some View {
		AppView(store: store)
	}
}
