import Foundation

public enum VolumeUnitType: Int, CaseIterable, Codable {
    case gallon = 1
    case quart
    case pint
    case cup
    case fluidOunce
    case tablespoon
    case teaspoon
    case mL
    case liter
}

public extension VolumeUnitType {
    static var settingsOptions: [VolumeUnitType] {
        [.cup, .teaspoon, .tablespoon, .fluidOunce, .pint, .quart, .gallon]
    }
}

extension VolumeUnitType: Unit {
    
    public var name: String {
        switch self {
        case .gallon:       "gallons"
        case .quart:        "quarts"
        case .pint:         "pints"
        case .cup:          "cups"
        case .fluidOunce:   "fluid ounces"
        case .tablespoon:   "tablespoons"
        case .teaspoon:     "teaspoons"
        case .mL:           "milliliters"
        case .liter:        "liters"
        }
    }
    
    public var abbreviation: String {
        switch self {
        case .gallon:       "gal"
        case .quart:        "qt"
        case .pint:         "pt"
        case .cup:          "cup"
        case .fluidOunce:   "fl oz"
        case .tablespoon:   "tbsp"
        case .teaspoon:     "tsp"
        case .mL:           "mL"
        case .liter:        "L"
        }
    }
}

public extension VolumeUnitType {
    static var primaryUnits: [VolumeUnitType] {
        [.mL, .cup, .fluidOunce, .tablespoon, .teaspoon]
    }
    
    static var secondaryUnits: [VolumeUnitType] {
        [.gallon, .liter, .pint, .quart]
    }
}

public extension VolumeUnitType {
    var defaultVolumeUnit: VolumeUnit {
        switch self {
        case .gallon:       .gallonUSLiquid
        case .quart:        .quartUSLiquid
        case .pint:         .pintMetric
        case .cup:          .cupMetric
        case .fluidOunce:   .fluidOunceUSNutritionLabeling
        case .tablespoon:   .tablespoonMetric
        case .teaspoon:     .teaspoonMetric
        case .mL:           .mL
        case .liter:        .liter
        }
    }
}

public extension VolumeUnitType {
    var units: [VolumeUnit] {
        switch self {
        case .cup:
            return [
                .cupMetric,
                .cupUSLegal,
                .cupUSCustomary,
                .cupImperial,
                .cupCanada,
                .cupLatinAmerica,
                .cupJapanTraditional,
                .cupJapanModern,
                .cupRussianProper,
                .cupRussianGlassRegular,
                .cupRussianGlassLarge,
            ]
        case .teaspoon:
            return [
                .teaspoonMetric,
                .teaspoonUS
            ]
        case .tablespoon:
            return [
                .tablespoonMetric,
                .tablespoonUS,
                .tablespoonAustralia
            ]
        case .fluidOunce:
            return [
                .fluidOunceUSNutritionLabeling,
                .fluidOunceUSCustomary,
                .fluidOunceImperial
            ]
        case .pint:
            return [
                .pintUSLiquid,
                .pintMetric,
                .pintImperial,
                .pintFlemishPintje,
                .pintIndia,
                .pintSouthAustralia,
                .pintAustralia,
                .pintRoyal,
                .pintCanada,
            ]
        case .quart:
            return [
                .quartUSLiquid,
                .quartImperial,
            ]
        case .gallon:
            return [
                .gallonUSLiquid,
                .gallonImperial,
            ]
        default:
            return []
        }
    }
}
