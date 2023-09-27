import Foundation

public enum EnergyGoalType: Hashable, Codable {
    case fixed(EnergyUnit)
    
    /// Only used with diets
    case fromMaintenance(EnergyUnit, EnergyGoalDelta)
    case percentFromMaintenance(EnergyGoalDelta)
}

public extension EnergyGoalType {
    func matches(other type: EnergyGoalType) -> Bool {
        switch (self, type) {
        case (.fixed, .fixed),
            (.fromMaintenance, .fromMaintenance),
            (.percentFromMaintenance, .percentFromMaintenance):
            true
        default:
            false
        }
    }
}

public extension EnergyGoalType {
    var nameWithDelta: String {
        switch self {
        case .fixed:                                "Fixed goal"
        case .fromMaintenance(_, let delta):        "\(delta.name) \(delta.conjunction) maintenance"
        case .percentFromMaintenance(let delta):    "\(delta.name.lowercased()) % \(delta.conjunction) maintenance"
        }
    }
    
    var name: String {
        switch self {
        case .fixed:                    "Fixed goal"
        case .fromMaintenance:          "Relative to maintenance"
        case .percentFromMaintenance:   "Relative % to Maintenance"
        }
    }
}

public extension EnergyGoalType {
    
    var isFixed: Bool {
        switch self {
        case .fixed:    true
        default:        false
        }
    }

    var isPercentFromMaintenance: Bool {
        switch self {
        case .percentFromMaintenance:   true
        default:                        false
        }
    }

    var delta: EnergyGoalDelta? {
        switch self {
        case .fromMaintenance(_, let energyDelta):      energyDelta
        case .percentFromMaintenance(let energyDelta):  energyDelta
        default:                                        nil
        }
    }

    var energyUnit: EnergyUnit? {
        switch self {
        case .fixed(let unit):              unit
        case .fromMaintenance(let unit, _): unit
        case .percentFromMaintenance:       nil
        }
    }
}
