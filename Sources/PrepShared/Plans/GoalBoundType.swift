import Foundation

public enum GoalBoundType {
    case none
    case lower
    case upper
    case closed
}

public extension GoalBoundType {
    var hasLower: Bool { self == .lower || self == .closed }
    var hasUpper: Bool { self == .upper || self == .closed }
}
