import Foundation

public struct GoalBound: Hashable, Codable {
    public var lower: Double?
    public var upper: Double?
    
    public init(lower: Double? = nil, upper: Double? = nil) {
        self.lower = lower
        self.upper = upper
    }
    
    public init?(_ type: GoalBoundType, _ lower: Double, _ upper: Double) {
        switch type {
        case .none:
            return nil
        case .lower:
            self.lower = lower
            self.upper = nil
        case .upper:
            self.lower = nil
            self.upper = upper
        case .closed:
            self.lower = lower
            self.upper = upper
        }
    }
}

public extension GoalBound {
    var type: GoalBoundType {
        switch (lower, upper) {
        case (.some, .some):    .closed
        case (.some, .none):    .lower
        case (.none, .some):    .upper
        case (.none, .none):    .none
        }
    }
}
