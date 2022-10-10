import ComposableArchitecture
import Foundation
import PlayFeature
import RecordPlayFeature
import SharedModelsLibrary
import SolverServiceInterface
import ValidatorServiceInterface

public struct PlaysListState: Equatable {
	public var plays: [Play]
	public var recordPlay: RecordPlayState?
	public var play: PlayState?

	public init(plays: [Play]) {
		self.plays = plays
	}
}

public enum PlaysListAction: Equatable {
	case addButtonTapped
	case delete(IndexSet)
	case recordPlay(RecordPlayAction)
	case play(PlayAction)
}

public struct PlaysListEnvironment: Sendable {
	public var solverService: SolverService

	public init(solverService: SolverService) {
		self.solverService = solverService
	}
}

public let playsListReducer = Reducer<PlaysListState, PlaysListAction, PlaysListEnvironment>.combine(
	recordPlayReducer
		.optional()
		.pullback(
			state: \.recordPlay,
			action: /PlaysListAction.recordPlay,
			environment: {
				RecordPlayEnvironment(solverService: $0.solverService)
			}
		),
	playReducer
		.optional()
		.pullback(
			state: \.play,
			action: /PlaysListAction.play,
			environment: {
				PlayEnvironment(solverService: $0.solverService)
			}
		),
	.init { state, action, _ in
		switch action {
		case let .delete(indexSet):
			state.plays.remove(atOffsets: indexSet)
			// TODO: persist deletion
			return .none

		case .play(.alert(.deleteButtonTapped)):
			// TODO: delete the given play
			state.play = nil
			return .none

		case .addButtonTapped:
			state.recordPlay = .init()
			return .none

		case .recordPlay, .play:
			return .none
		}
	}
)
