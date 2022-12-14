import ComposableArchitecture
import PlaysListFeature
import SwiftUI

public struct AppView: View {
	let store: StoreOf<App>

	struct ViewState: Equatable {
		public init(state: App.State) {}
	}

	enum ViewAction {
		case onAppear
	}

	public init(store: StoreOf<App>) {
		self.store = store
	}

	public var body: some View {
		WithViewStore(store, observe: ViewState.init, send: App.Action.init) { viewStore in
			NavigationView {
				PlaysListView(store: store.scope(state: \.playsList, action: App.Action.playsList))
					.onAppear { viewStore.send(.onAppear) }
			}
		}
	}
}

extension App.Action {
	init(action: AppView.ViewAction) {
		switch action {
		case .onAppear:
			self = .onAppear
		}
	}
}
