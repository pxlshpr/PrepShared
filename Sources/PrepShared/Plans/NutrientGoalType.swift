import Foundation

public enum NutrientGoalType: Codable, Hashable {
    case fixed
    case quantityPerBodyMass(BodyMassType, BodyMassUnit, BodyMassSource, Double?)
    case percentageOfEnergy
    case quantityPerEnergy(Double, EnergyUnit) /// `Double` indicates the value we're using
}

public extension NutrientGoalType {
    func matches(other type: NutrientGoalType) -> Bool {
        switch (self, type) {
        case (.fixed, .fixed),
            (.quantityPerBodyMass, .quantityPerBodyMass),
            (.percentageOfEnergy, .percentageOfEnergy),
            (.quantityPerEnergy, .quantityPerEnergy):
            true
        default:
            false
        }
    }
}

public extension NutrientGoalType {
    
    var name: String {
        switch self {
        case .fixed:                "Fixed goal"
        case .quantityPerBodyMass:  "Relative to body mass"
        case .percentageOfEnergy:   "Portion of energy goal"
        case .quantityPerEnergy:    "Relative to energy goal"
        }
    }
    
    var nameWithParams: String {
        switch self {
        case .fixed:
            name
        case .quantityPerBodyMass(let bodyMassType, let bodyMassUnit, _, _):
            "Amount per \(bodyMassUnit.abbreviation) of \(bodyMassType.abbreviation)"
        case .percentageOfEnergy:
            "Portion of energy goal"
        case .quantityPerEnergy(let energyValue, let energyUnit):
            "Amount per \(energyValue.formattedEnergy) \(energyUnit.abbreviation) of energy goal"
        }
    }
}

public extension NutrientGoalType {
    
    var usesWeight: Bool {
        switch self {
        case .quantityPerBodyMass:  true
        default:                    false
        }
    }
    
    var isPercentageOfEnergy: Bool {
        switch self {
        case .percentageOfEnergy:   true
        default:                    false
        }
    }
    
    var isQuantityPerEnergy: Bool {
        switch self {
        case .quantityPerEnergy:    true
        default:                    false
        }
    }
    
    var dependsOnEnergy: Bool {
        switch self {
        case .percentageOfEnergy, .quantityPerEnergy:   true
        default:                                        false
        }
    }
    
    var isQuantityPerBodyMass: Bool {
        switch self {
        case .quantityPerBodyMass:  true
        default:                    false
        }
    }
    
    var isFixedQuantity: Bool {
        switch self {
        case .fixed:    true
        default:        false
        }
    }

}

public extension NutrientGoalType {
    var bodyMassType: BodyMassType? {
        get {
            switch self {
            case .quantityPerBodyMass(let bodyMassType, _, _, _): bodyMassType
            default:                                        nil
            }
        }
        set {
            guard let newValue else { return }
            switch self {
            case .quantityPerBodyMass(_, let unit, let source, let value):
                self = .quantityPerBodyMass(newValue, unit, source, value)
            default:
                break
            }
        }
    }
    
    var bodyMassSource: BodyMassSource? {
        get {
            switch self {
            case .quantityPerBodyMass(_, _, let source, _): source
            default:                                        nil
            }
        }
        set {
            guard let newValue else { return }
            switch self {
            case .quantityPerBodyMass(let type, let unit, _, let value):
                self = .quantityPerBodyMass(type, unit, newValue, value)
            default:
                break
            }
        }
    }
    
    var bodyMassValue: Double? {
        get {
            switch self {
            case .quantityPerBodyMass(_, _, _, let value):  value
            default:                                        nil
            }
        }
        set {
            guard let newValue else { return }
            switch self {
            case .quantityPerBodyMass(let type, let unit, let source, _):
                self = .quantityPerBodyMass(type, unit, source, newValue)
            default:
                break
            }
        }
    }
    
    var bodyMassUnit: BodyMassUnit? {
        get {
            switch self {
            case .quantityPerBodyMass(_, let bodyMassUnit, _, _): bodyMassUnit
            default:                                        nil
            }
        }
        set {
            guard let newValue else { return }
            switch self {
            case .quantityPerBodyMass(let bodyMassType, _, let source, let value):
                self = .quantityPerBodyMass(bodyMassType, newValue, source, value)
            default:
                break
            }
        }
    }
    
    var perEnergyValue: Double? {
        get {
            switch self {
            case .quantityPerEnergy(let value, _):  value
            default:                                nil
            }
        }
        set {
            guard let newValue else { return }
            switch self {
            case .quantityPerEnergy(_, let unit):
                self = .quantityPerEnergy(newValue, unit)
            default:
                break
            }
        }
    }
    
    var perEnergyUnit: EnergyUnit? {
        get {
            switch self {
            case .quantityPerEnergy(_, let unit):   unit
            default:                                nil
            }
        }
        set {
            guard let newValue else { return }
            switch self {
            case .quantityPerEnergy(let value, _):
                self = .quantityPerEnergy(value, newValue)
            default:
                break
            }
        }
    }
}
