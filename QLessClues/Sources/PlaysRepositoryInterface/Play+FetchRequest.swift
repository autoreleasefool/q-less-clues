import SharedModelsLibrary

// MARK: FetchRequest

extension Play {
	public struct FetchRequest {
		public let ordering: Ordering

		public init(ordering: Ordering) {
			self.ordering = ordering
		}
	}
}

extension Play.FetchRequest {
	public enum Ordering {
		case byDate
	}
}

// MARK: SingleFetchRequest

extension Play {
	public struct SingleFetchRequest {
		public let id: Play.ID

		public init(id: Play.ID) {
			self.id = id
		}
	}
}
