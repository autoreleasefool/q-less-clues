import Foundation
import SharedModelsLibrary

public protocol Validator {
	func validate(solution: Solution) -> Bool
}
