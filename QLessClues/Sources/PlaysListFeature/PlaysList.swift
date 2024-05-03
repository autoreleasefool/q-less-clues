import ComposableArchitecture
import Foundation
import PlayDetailsFeature
import PlaysRepositoryInterface
import RecordPlayFeature
import SharedModelsLibrary
import StatisticsFeature

@Reducer
public struct PlaysList: Reducer {
	@ObservableState
	public struct State: Equatable {
		public var plays: IdentifiedArrayOf<Play> = []
		public var statistics: Statistics?

		@Presents public var destination: Destination.State?

		public init() {}
	}

	public enum Action: ViewAction {
		@CasePathable public enum View {
			case task
			case didTapPlay(Play)
			case didTapRecordButton
			case didTapViewAllButton
			case didDelete(IndexSet)
		}

		@CasePathable public enum Internal {
			case playResponse(Result<Play, Error>)
			case playsResponse(Result<[Play], Error>)
			case deletedPlayResponse(Result<Void, Error>)
			case didReceiveStatistics(Result<Statistics, Error>)

			case destination(PresentationAction<Destination.Action>)
		}

		case view(View)
		case `internal`(Internal)
	}

	@Reducer(state: .equatable)
	public enum Destination {
		case record(RecordPlay)
		case details(PlayDetails)
		case statistics(StatisticsList)
	}

	public init() {}

	@Dependency(\.playsDataProvider) var playsDataProvider // TODO: rename to repository
	@Dependency(\.statisticsDataProvider) var statisticsDataProvider

	public var body: some ReducerOf<Self> {
		Reduce { state, action in
			switch action {
			case let .view(viewAction):
				switch viewAction {
				case .task:
					return .merge(
						.run { send in
							for try await plays in playsDataProvider.fetchAll(.init(ordering: .byDate)) {
								await send(.internal(.playsResponse(.success(plays))))
							}
						} catch: { error, send in
							await send(.internal(.playsResponse(.failure(error))))
						},
						.run { send in
							for try await statistics in statisticsDataProvider.fetch(.init()) {
								await send(.internal(.didReceiveStatistics(.success(statistics))))
							}
						} catch: { error, send in
							await send(.internal(.didReceiveStatistics(.failure(error))))
						}
					)

				case .didTapViewAllButton:
					state.destination = .statistics(.init())
					return .none

				case .didTapRecordButton:
					state.destination = .record(.init())
					return .none

				case let .didTapPlay(play):
					state.destination = .details(.init(play: play))
					return .none

				case let .didDelete(indexSet):
					guard let index = indexSet.first, index < state.plays.count else {
						return .none
					}

					let play = state.plays[index]
					state.plays.remove(at: index)
					return .run { [play = play] send in
						await send(.internal(.deletedPlayResponse(Result {
							try await playsDataProvider.delete(play)
						})))
					}
				}

			case let .internal(internalAction):
				switch internalAction {
				case let .didReceiveStatistics(.success(statistics)):
					state.statistics = statistics
					return .none

				case let .playResponse(.success(play)):
					state.destination = .details(.init(play: play))
					return .none

				case let .playsResponse(.success(plays)):
					state.plays = .init(uniqueElements: plays)
					return .none

				case .deletedPlayResponse(.success):
					return .none

				case .playResponse(.failure), .playsResponse(.failure), .deletedPlayResponse(.failure),
						.didReceiveStatistics(.failure):
					// TODO: Error handling
					return .none

				case .destination(.dismiss),
						.destination(.presented(.details(.internal))), .destination(.presented(.details(.view))),
						.destination(.presented(.record(.binding))), .destination(.presented(.record(.internal))),
						.destination(.presented(.record(.view))),
						.destination(.presented(.statistics(.view))), .destination(.presented(.statistics(.internal))):
					return .none
				}
			}
		}
		.ifLet(\.$destination, action: \.internal.destination)
	}
}
