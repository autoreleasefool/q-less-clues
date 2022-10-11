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
	let store: Store<AppState, AppAction> = {
		let persistenceService: PersistenceService = .live(with: .init())
		let playsDataProvider: PlaysDataProvider = .live(with: .init(persistenceService: persistenceService))
		let statisticsDataProvider: StatisticsDataProvider = .live(with: .init(persistenceService: persistenceService))
		let validatorService: ValidatorService = .live
		let solverService: SolverService = .live(with: .init(validatorService: validatorService))

		return Store(
			initialState: AppState(),
			reducer: appReducer,
			environment: AppEnvironment(
				playsDataProvider: playsDataProvider,
				statisticsDataProvider: statisticsDataProvider,
				solverService: solverService
			)
		)
	}()

	var body: some View {
		AppView(store: store)
	}
}
