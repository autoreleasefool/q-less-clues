import ComposableArchitecture
import StatisticsFeature
import SwiftUI

public struct AppView: View {
	let store: Store<AppState, AppAction>

	enum ViewAction {
		case onAppear
	}

	public init(store: Store<AppState, AppAction>) {
		self.store = store
	}

	public var body: some View {
		WithViewStore(store, observe: { $0 }, send: AppAction.init) { viewStore in
			NavigationStack {
				StatisticsView(store: store.scope(state: \.statistics, action: AppAction.statistics))
					.onAppear { viewStore.send(.onAppear) }
			}
		}
	}
}

extension AppAction {
	init(action: AppView.ViewAction) {
		switch action {
		case .onAppear:
			self = .onAppear
		}
	}
}
