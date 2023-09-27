import Foundation

public enum GoalEnergyUnit: String, Hashable, Codable, CaseIterable {
    case kcal = "kcal"
    case kJ = "kJ"
    case percent = "%"
}

public extension GoalEnergyUnit {
    var energyUnit: EnergyUnit? {
        switch self {
        case .kcal:     .kcal
        case .kJ:       .kJ
        case .percent:  nil
        }
    }
}

public extension EnergyUnit {
    var asGoalEnergyUnit: GoalEnergyUnit {
        switch self {
        case .kcal: .kcal
        case .kJ:   .kJ
        }
    }
}

extension GoalEnergyUnit: Pickable {
    public var pickedTitle: String { rawValue }
    public var menuTitle: String { rawValue }
    public static var `default`: GoalEnergyUnit { .kcal }
}
