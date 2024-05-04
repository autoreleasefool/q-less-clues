import AppFeature
import ComposableArchitecture
import SwiftUI

struct ContentView: View {
	#if DEBUG
	let store = Store(
		initialState: App.State(),
		reducer: { App()._printChanges() }
	)
	#else
	let store = Store(
		initialState: App.State(),
		reducer: { App() }
	)
	#endif

	var body: some View {
		AppView(store: store)
	}
}
