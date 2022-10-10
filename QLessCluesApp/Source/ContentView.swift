import AppFeature
import ComposableArchitecture
import SolverServiceLive
import SwiftUI
import ValidatorServiceLive

struct ContentView: View {
	let store = Store(
		initialState: AppState(),
		reducer: appReducer,
		environment: AppEnvironment(
			solverService: .live(solverServiceLive: .init(validatorService: .live)),
			validatorService: .live
		)
	)

	var body: some View {
		AppView(store: store)
	}
}
