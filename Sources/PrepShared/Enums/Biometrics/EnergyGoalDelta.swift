import Foundation

public enum EnergyGoalDelta: Int16, Hashable, Codable, CaseIterable {
    case deficit
    case surplus
    case deviation
}

public extension EnergyGoalDelta {
    var name: String {
        switch self {
        case .deficit:      "Deficit"
        case .surplus:      "Surplus"
        case .deviation:    "Deficit and surplus"
        }
    }

    var conjunction: String {
        switch self {
        case .deficit:      "from"
        case .surplus:      "to"
        case .deviation:    "around"
        }
    }
}
