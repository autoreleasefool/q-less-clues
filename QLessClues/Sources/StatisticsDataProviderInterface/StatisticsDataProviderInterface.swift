import Foundation
import SharedModelsLibrary

public struct StatisticsDataProvider: Sendable {
	public var fetch: @Sendable () async -> Statistics

	public init(fetch: @escaping @Sendable () async -> Statistics) {
		self.fetch = fetch
	}
}
