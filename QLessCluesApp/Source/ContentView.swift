import AppFeature
import ComposableArchitecture
import PersistenceService
import PersistenceServiceInterface
import PlaysDataProvider
import PlaysDataProviderInterface
import SolverService
import SolverServiceInterface
import StatisticsDataProvider
import StatisticsDataProviderInterface
import SwiftUI
import ValidatorService
import ValidatorServiceInterface

struct ContentView: View {
	let store = Store(
		initialState: App.State(),
		reducer: App()._printChanges()
	)

	var body: some View {
		AppView(store: store)
	}
}
