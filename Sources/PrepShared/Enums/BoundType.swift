import Foundation

public enum BoundType {
    case none
    case lower
    case upper
    case closed
}

public extension BoundType {
    var hasLower: Bool { self == .lower || self == .closed }
    var hasUpper: Bool { self == .upper || self == .closed }
}
