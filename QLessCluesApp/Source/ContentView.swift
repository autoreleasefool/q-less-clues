import AppFeature
import ComposableArchitecture
import PersistenceService
import PlaysDataProvider
import SolverService
import SwiftUI
import ValidatorService

struct ContentView: View {
	let store = Store(
		initialState: AppState(),
		reducer: appReducer,
		environment: AppEnvironment(
			playsDataProvider: .live(with: .init(persistenceService: .live(with: .init()))),
			solverService: .live(with: .init(validatorService: .live))
		)
	)

	var body: some View {
		AppView(store: store)
	}
}
