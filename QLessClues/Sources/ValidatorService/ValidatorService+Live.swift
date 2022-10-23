import Dependencies
import DictionaryLibrary
import Foundation
import SharedModelsLibrary
import ValidatorServiceInterface

extension ValidatorService: DependencyKey {
	public static let liveValue = Self(
		validate: { solution, dictionary in
			guard solution.words.allSatisfy({ dictionary.contains($0) }) else {
				return false
			}

			var unvisited = Set(solution.letterPositions.keys)
			var toExplore: Set<Position> = []

			guard let first = unvisited.popFirst() else {
				return false
			}

			toExplore.insert(first)

			while !toExplore.isEmpty {
				let node = toExplore.popFirst()!
				unvisited.remove(node)
				node.surrounding
					.filter { unvisited.contains($0) }
					.forEach { toExplore.insert($0) }
			}

			return unvisited.isEmpty
		}
	)
}
