import Foundation

public struct Bound: Hashable, Codable {
    public var lower: Double?
    public var upper: Double?
    
    public init(lower: Double? = nil, upper: Double? = nil) {
        self.lower = lower
        self.upper = upper
    }
    
    public init?(_ type: BoundType, _ lower: Double, _ upper: Double) {
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

public extension Bound {
    var isValid: Bool {
        switch (lower, upper) {
        case (.some(let lower), .some(let upper)):
            lower >= 0 && upper >= 0 && upper > lower
        case (.some(let lower), nil):
            lower >= 0
        case (nil, .some(let upper)):
            upper >= 0
        case (.none, .none):
            false
        }
    }
}

public extension Bound {
    var type: BoundType {
        switch (lower, upper) {
        case (.some, .some):    .closed
        case (.some, .none):    .lower
        case (.none, .some):    .upper
        case (.none, .none):    .none
        }
    }
}

public extension Bound {
    func contains(_ value: Double) -> Bool {
        switch (lower, upper) {
        case (.some(let lower), .some(let upper)):
            value >= lower && value < upper
        case (.some(let lower), nil):
            value >= lower
        case (nil, .some(let upper)):
            upper < upper
        case (.none, .none):
            false
        }
    }
}
