import Foundation

public enum Nutrient: Codable, Hashable {
    case energy
    case macro(Macro)
    case micro(Micro)
}

public extension Nutrient {
    static var allNutrients: [Nutrient] {
        [.energy] + allMacros + allMicros
    }
    
    static var allMacros: [Nutrient] {
        Macro.allCases.map { .macro($0) }
    }
    
    static var allMicros: [Nutrient] {
        Micro.allCases.map { .micro($0) }
    }
}

public extension Nutrient {
    var rdaGoal: Goal? {
        switch self {
        case .energy:           nil
        case .macro:            nil
        case .micro(let micro): micro.rdaGoal
        }
    }
}

public extension Nutrient {
    var description: String {
        switch self {
        case .energy:
            "Energy"
        case .macro(let macro):
            macro.name
        case .micro(let micro):
            micro.name
        }
    }
    
    var macro: Macro? {
        switch self {
        case .macro(let macro): macro
        default:                nil
        }
    }
    
    var isEnergy: Bool {
        switch self {
        case .energy:
            return true
        default:
            return false
        }
    }
    
    var micro: Micro? {
        switch self {
        case .micro(let micro):
            return micro
        default:
            return nil
        }
    }
    
    var isMandatory: Bool {
        switch self {
        case .micro:
            return false
        default:
            return true
        }
    }
    
    var defaultFoodLabelUnit: FoodLabelUnit {
        switch self {
        case .energy:
            .kcal
        case .macro:
            .g
        case .micro(let nutrientType):
            nutrientType.supportedNutrientUnits.first?.foodLabelUnit ?? .g
        }
    }
}

extension Nutrient: Identifiable {
    public var id: String { description }
}

public extension Nutrient {
    static var macros: [Nutrient] {
        [
            .macro(.carb),
            .macro(.fat),
            .macro(.protein),
        ]
    }
}
