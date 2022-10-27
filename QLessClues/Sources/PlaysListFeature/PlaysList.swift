import AnalysisFeature
import ComposableArchitecture
import Foundation
import PlayDetailsFeature
import PlaysDataProviderInterface
import RecordPlayFeature
import SharedModelsLibrary
import SolverServiceInterface
import StatisticsDataProviderInterface
import StatisticsFeature

public struct PlaysList: ReducerProtocol {
	public struct State: Equatable {
		public var plays: IdentifiedArrayOf<Play> = []
		public var selection: Identified<Play.ID, PlayDetails.State>?
		public var recordPlay: RecordPlay.State?
		public var statistics = StatisticsReducer.State()

		public init() {}
	}

	public enum Action: Equatable {
		case subscribeToPlays
		case playsResponse([Play])
		case setRecordSheet(isPresented: Bool)
		case setPlaySelection(selection: Play.ID?)
		case playResponse(Play)
		case delete(IndexSet)
		case playDeleted
		case recordPlay(RecordPlay.Action)
		case play(PlayDetails.Action)
		case statistics(StatisticsReducer.Action)
	}

	public init() {}

	@Dependency(\.playsDataProvider) var playsDataProvider

	public var body: some ReducerProtocol<State, Action> {
		Scope(state: \.statistics, action: /PlaysList.Action.statistics) {
			StatisticsReducer()
		}

		Reduce { state, action in
			switch action {
			case .subscribeToPlays:
				return .run { send in
					for try await plays in playsDataProvider.fetchAll(.init(ordering: .byDate)) {
						await send(.playsResponse(plays))
					}
				}

			case let .playsResponse(plays):
				state.plays = IdentifiedArrayOf(uniqueElements: plays)
				return .none

			case let .delete(indexSet):
				guard let index = indexSet.first, index < state.plays.count else {
					return .none
				}

				let play = state.plays[index]
				state.plays.remove(at: index)
				return .task { [play = play] in
					try await playsDataProvider.delete(play)
					return .playDeleted
				}

			case .play(.playDeleted):
				return .none

			case let .setPlaySelection(selection: .some(id)):
				if let selection = state.plays[id: id] {
					state.selection = Identified(.init(play: selection), id: selection.id)
				}
				return .none

			case .setPlaySelection(selection: .none):
				state.selection = nil
				return .cancel(id: Analysis.TearDown.self)

			case let .playResponse(play):
				state.selection = Identified(PlayDetails.State(play: play), id: play.id)
				return .none

			case .setRecordSheet(isPresented: true):
				state.recordPlay = .init()
				return .none

			case .setRecordSheet(isPresented: false):
				state.recordPlay = nil
				return .cancel(id: Analysis.TearDown.self)

			case .recordPlay(.playSaved):
				state.recordPlay = nil
				return .none

			case .recordPlay, .play, .statistics, .playDeleted:
				return .none
			}
		}
		.ifLet(\.recordPlay, action: /PlaysList.Action.recordPlay) {
			RecordPlay()
		}
		.ifLet(\.selection, action: /PlaysList.Action.play) {
			Scope(state: \Identified<Play.ID, PlayDetails.State>.value, action: /.self) {
				PlayDetails()
			}
		}
	}
}
