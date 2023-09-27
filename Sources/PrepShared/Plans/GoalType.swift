import Foundation

public enum GoalType: Hashable, Codable {
    case energy(EnergyGoalType)
    case macro(NutrientGoalType, Macro)
    case micro(NutrientGoalType, Micro, NutrientUnit)
}

public extension GoalType {
    var isCalculated: Bool {
        switch self {
        case .energy(let type):         !type.isFixed
        case .macro(let type, _):       !type.isFixedQuantity
        case .micro(let type, _, _):    !type.isFixedQuantity
        }
    }
}

public extension GoalType {
    var name: String {
        switch self {
        case .energy(let type):         type.name
        case .macro(let type, _):       type.name
        case .micro(let type, _, _):    type.name
        }
    }
    
    var nutrientName: String {
        switch self {
        case .energy:                   "Energy"
        case .macro(_, let macro):      macro.name
        case .micro(_, let micro, _):   micro.name
        }
    }
}

public extension GoalType {
    
    var lowerBoundLabel: String {
        switch energyDelta {
        case .deficit:      "Maximum deficit"
        case .surplus:      "Minimum surplus"
        case .deviation:    "Deficit"
        default:            "Minimum"
        }
    }
    
    var upperBoundLabel: String {
        switch energyDelta {
        case .deficit:      "Minimum deficit"
        case .surplus:      "Maximum surplus"
        case .deviation:    "Surplus"
        default:            "Maximum"
        }
    }
    
    var footerMessage: String? {
        switch self {
        case .energy(let type):
            switch type {
            case .fixed:
                nil
            case .fromMaintenance, .percentFromMaintenance:
                "This goal will automatically update with your maintenance energy."
            }
        default:
            switch nutrientGoalType {
            case .some(let type):
                switch type {
                case .fixed: nil
                case .quantityPerBodyMass(let bodyMassType, _, _, _):
                    "This goal will automatically update with your \(bodyMassType.name.lowercased())."
                case .percentageOfEnergy, .quantityPerEnergy:
                    "This goal will automatically update with your energy goal."
                }
            case .none: nil
            }
        }
    }
}

public extension GoalType {
    
    var shouldSwapBounds: Bool {
        switch energyDelta {
        case .deficit:  true
        default:        false
        }
    }

    var onlySupportsClosedBound: Bool {
        switch energyDelta {
        case .deviation:    true
        default:            false
        }
    }

    /// A hash value that is independent of the associated values
    var identifyingHashValue: String {
        switch self {
        case .energy:                           "energy"
        case .macro(_, let macro):              "macro_\(macro.rawValue)"
        case .micro(_, let nutrientType, _):    "macro_\(nutrientType.rawValue)"
        }
    }
    
    var isMacro: Bool {
        macro != nil
    }
    var isMicro: Bool {
        micro != nil
    }
    
    var dependsOnEnergy: Bool {
        nutrientGoalType?.dependsOnEnergy ?? false
    }
    
    var energyGoalType: EnergyGoalType? {
        switch self {
        case .energy(let energyGoalType):   energyGoalType
        default:                            nil
        }
    }
    
    var nutrientGoalType: NutrientGoalType? {
        switch self {
        case .macro(let nutrientGoalType, _):       nutrientGoalType
        case .micro(let nutrientGoalType, _, _):    nutrientGoalType
        default:                                    nil
        }
    }

    var isEnergy: Bool {
        switch self {
        case .energy:   true
        default:        false
        }
    }
    
    var macro: Macro? {
        switch self {
        case .macro(_, let macro):  macro
        default:                    nil
        }
    }
    
    var micro: Micro? {
        switch self {
        case .micro(_, let micro, _):   micro
        default:                        nil
        }
    }
    
    var isDualBounded: Bool {
        !isSingleBounded
    }
    
    var isSingleBounded: Bool {
        switch self {
        case .energy(let energyGoalType):
            switch energyGoalType {
            case .fromMaintenance(_, let delta):        delta == .deviation
            case .percentFromMaintenance(let delta):    delta == .deviation
            default:                                    false
            }
        default: false
        }
    }
    
    var showsEquivalentValues: Bool {
        switch self {
        case .energy(let energyGoalType):
            switch energyGoalType {
            case .fixed:    false
            default:        true
            }
        case .macro(let macroGoalType, _):
            switch macroGoalType {
            case .fixed:    false
            default:        true
            }
        case .micro(let microGoalType, _, _):
            switch microGoalType {
            case .fixed:    false
            default:        true
            }
        }
    }
}

import SwiftUI

public extension GoalType {
    
    func labelColor(for colorScheme: ColorScheme) -> Color {
        switch self {
        case .energy:               .accentColor
        case .macro(_, let macro):  macro.textColor(for: colorScheme)
        case .micro:                .gray
        }
    }
}

public extension GoalType {
    var usesEnergyDelta: Bool {
        switch self {
        case .energy(let energyGoalType):   !energyGoalType.isFixed
        default:                            false
        }
    }
    
    var usesEnergyUnit: Bool {
        switch self {
        case .energy:   true
        default:        false
        }
    }
    
    var energyDelta: EnergyGoalDelta? {
        get {
            switch self {
            case .energy(let energyGoalType):   energyGoalType.delta
            default:                            nil
            }
        }
        set {
            guard let newValue else { return }
            switch self {
            case .energy(let energyGoalType):
                switch energyGoalType {
                case .fromMaintenance(let energyUnit, _):
                    self = .energy(.fromMaintenance(energyUnit, newValue))
                case .percentFromMaintenance:
                    self = .energy(.percentFromMaintenance(newValue))
                default:
                    break
                }
            default:
                break
            }
        }
    }
    
    var bodyMassType: BodyMassType? {
        get {
            nutrientGoalType?.bodyMassType
        }
        set {
            guard let newValue else { return }
            switch self {
            case .macro(let type, let macro):
                var type = type
                type.bodyMassType = newValue
                self = .macro(type, macro)
            case .micro(let type, let micro, let nutrientUnit):
                var type = type
                type.bodyMassType = newValue
                self = .micro(type, micro, nutrientUnit)
            default:
                break
            }
        }
    }
    
    var bodyMassSource: BodyMassSource? {
        get {
            nutrientGoalType?.bodyMassSource
        }
        set {
            guard let newValue else { return }
            switch self {
            case .macro(let type, let macro):
                var type = type
                type.bodyMassSource = newValue
                self = .macro(type, macro)
            case .micro(let type, let micro, let nutrientUnit):
                var type = type
                type.bodyMassSource = newValue
                self = .micro(type, micro, nutrientUnit)
            default:
                break
            }
        }
    }

    var bodyMassValue: Double? {
        get {
            nutrientGoalType?.bodyMassValue
        }
        set {
            guard let newValue else { return }
            switch self {
            case .macro(let type, let macro):
                var type = type
                type.bodyMassValue = newValue
                self = .macro(type, macro)
            case .micro(let type, let micro, let nutrientUnit):
                var type = type
                type.bodyMassValue = newValue
                self = .micro(type, micro, nutrientUnit)
            default:
                break
            }
        }
    }

    var bodyMassUnit: BodyMassUnit? {
        get {
            nutrientGoalType?.bodyMassUnit
        }
        set {
            guard let newValue else { return }
            switch self {
            case .macro(let type, let macro):
                var type = type
                type.bodyMassUnit = newValue
                self = .macro(type, macro)
            case .micro(let type, let micro, let nutrientUnit):
                var type = type
                type.bodyMassUnit = newValue
                self = .micro(type, micro, nutrientUnit)
            default:
                break
            }
        }
    }
    
    var perEnergyValue: Double? {
        get {
            nutrientGoalType?.perEnergyValue
        }
        set {
            guard let newValue else { return }
            switch self {
            case .macro(let type, let macro):
                var type = type
                type.perEnergyValue = newValue
                self = .macro(type, macro)
            case .micro(let type, let micro, let nutrientUnit):
                var type = type
                type.perEnergyValue = newValue
                self = .micro(type, micro, nutrientUnit)
            default:
                break
            }
        }
    }
    
    var perEnergyUnit: EnergyUnit? {
        get {
            nutrientGoalType?.perEnergyUnit
        }
        set {
            guard let newValue else { return }
            switch self {
            case .macro(let type, let macro):
                var type = type
                type.perEnergyUnit = newValue
                self = .macro(type, macro)
            case .micro(let type, let micro, let nutrientUnit):
                var type = type
                type.perEnergyUnit = newValue
                self = .micro(type, micro, nutrientUnit)
            default:
                break
            }
        }
    }
    
    var perEnergyUnits: [NutrientUnit] {
        switch self {
        case .macro:                    [.p, .g]
        case .micro(_, let micro, _):   micro.units
        default:                        []
        }
    }
    
    var microNutrientUnit: NutrientUnit? {
        switch self {
        case .micro(_, _, let unit):    unit
        default:                        nil
        }
    }

    var goalPerEnergyUnit: NutrientUnit {
        get {
            switch self.nutrientGoalType {
            case .percentageOfEnergy:   .p
            case .quantityPerEnergy:    microNutrientUnit ?? .g
            default:                    .g
            }
        }
        set {
            switch self {
            case .macro(_, let macro):
                switch newValue {
                case .p:
                    self = .macro(.percentageOfEnergy, macro)
                default:
                    self = .macro(.quantityPerEnergy(perEnergyValue ?? 1000, perEnergyUnit ?? .default), macro)
                }
            case .micro(_, let micro, _):
                self = .micro(.quantityPerEnergy(perEnergyValue ?? 1000, perEnergyUnit ?? .default), micro, newValue)
            default:
                break
            }
        }
    }
    
    var goalEnergyUnit: GoalEnergyUnit? {
        get {
            switch self.energyGoalType {
            case .percentFromMaintenance:
                .percent
            default:
                energyUnit?.asGoalEnergyUnit
            }
        }
        set {
            switch newValue {
            case .percent:
                switch energyGoalType {
                case .some:
                    switch energyDelta {
                    case .some(let delta):
                        self = .energy(.percentFromMaintenance(delta))
                    default:
                        self = .energy(.percentFromMaintenance(.default))
                    }
                default:
                    break
                }
                
            case .kJ, .kcal:
                guard let unit = newValue?.energyUnit else { return }
                switch energyGoalType {
                case .fixed:
                    self = .energy(.fixed(unit))
                case .fromMaintenance(_, let delta):
                    self = .energy(.fromMaintenance(unit, delta))
                case .percentFromMaintenance(let delta):
                    self = .energy(.fromMaintenance(unit, delta))
                case .none:
                    break
                }
            case .none:
                break
            }
        }
    }
    
    var energyUnit: EnergyUnit? {
        get {
            switch self {
            case .energy(let type):   type.energyUnit
            default:                  nil
            }
        }
        set {
            guard let newValue else { return }
            switch self {
            case .energy(let type):
                switch type {
                case .fixed:
                    self = .energy(.fixed(newValue))
                case .fromMaintenance(_, let delta):
                    self = .energy(.fromMaintenance(newValue, delta))
                case .percentFromMaintenance(let delta):
                    self = .energy(.percentFromMaintenance(delta))
                }
            default:
                break
            }
        }
    }

    var microUnit: NutrientUnit? {
        get {
            switch self {
            case .micro(_, _, let unit):    unit
            default:                        nil
            }
        }
        set {
            guard let newValue else { return }
            switch self {
            case .micro(let type, let micro, _):
                self = .micro(type, micro, newValue)
            default:
                break
            }
        }
    }
    var nutrient: Nutrient {
        get {
            switch self {
            case .energy:
                    .energy
            case .macro(_, let macro):
                    .macro(macro)
            case .micro(_, let micro, _):
                    .micro(micro)
            }
        }
        set {
            switch self {
            case .energy:
                switch newValue {
                case .energy:
                    break
                case .macro(let macro):
                    self = .macro(.fixed, macro)
                case .micro(let micro):
                    self = .micro(.fixed, micro, micro.defaultUnit)
                }
                
            case .macro:
                switch newValue {
                case .energy:
                    self = .energy(.fixed(.kcal))
                case .macro:
                    break
                case .micro(let micro):
                    self = .micro(.fixed, micro, micro.defaultUnit)
                }
                
            case .micro:
                switch newValue {
                case .energy:
                    self = .energy(.fixed(.kcal))
                case .macro(let macro):
                    self = .macro(.fixed, macro)
                case .micro:
                    break
                }
            }
        }
    }
}

public extension GoalType {
    
    var usesBodyMass: Bool {
        guard let nutrientGoalType else { return false }
        switch nutrientGoalType {
        case .quantityPerBodyMass:
            return true
        default:
            return false
        }
    }

    var usesPerEnergyValue: Bool {
        guard let nutrientGoalType else { return false }
        return switch nutrientGoalType {
        case .quantityPerEnergy:    true
        default:                    false
        }
    }
    
    var usesEnergyGoal: Bool {
        guard let nutrientGoalType else { return false }
        switch nutrientGoalType {
        case .percentageOfEnergy, .quantityPerEnergy:
            return true
        default:
            return false
        }
    }

    var usesMaintenanceEnergy: Bool {
        guard let energyGoalType else { return false }
        return switch energyGoalType {
        case .percentFromMaintenance, .fromMaintenance:
            true
        default:
            false
        }
    }

}

public extension GoalType {
    var amountUnit: NutrientUnit {
        get {
            switch self {
            case .energy(let type):
                type.energyUnit?.nutrientUnit ?? .kcal
            case .macro:
                .g
            case .micro(_, _, let unit):
                unit
            }
        }
        set {
            switch self {
            case .energy(let type):
                let unit = newValue.energyUnit ?? .kcal
                switch type {
                case .fixed:
                    self = .energy(.fixed(unit))
                case .fromMaintenance(_, let delta):
                    self = .energy(.fromMaintenance(unit, delta))
                case .percentFromMaintenance:
                    break
                }
            case .macro:
                break
            case .micro(let type, let micro, _):
                self = .micro(type, micro, newValue)
            }
        }
    }
}

public extension GoalType {
    func formattedString(for value: Double) -> String {
        switch self {
        case .energy:   value.formattedEnergy
        case .macro:    value.formattedMacro
        case .micro:    value.formattedNutrient
        }
    }
}
