import ComposableArchitecture
import PlaysListFeature
import SwiftUI

@ViewAction(for: App.self)
public struct AppView: View {
	public var store: StoreOf<App>

	public init(store: StoreOf<App>) {
		self.store = store
	}

	public var body: some View {
		NavigationStack {
			PlaysListView(store: store.scope(state: \.playsList, action: \.internal.playsList))
				.onAppear { send(.onAppear) }
		}
	}
}
