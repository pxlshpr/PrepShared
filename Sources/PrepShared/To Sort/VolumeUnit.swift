import Foundation

public enum VolumeUnit: Int, Codable {
    
    case mL = 1

    case liter = 10

    case cupUSLegal = 100
    case cupUSCustomary
    case cupImperial
    case cupMetric
    case cupCanada
    case cupLatinAmerica
    case cupJapanTraditional
    case cupJapanModern
    case cupRussianProper
    case cupRussianGlassRegular
    case cupRussianGlassLarge
    
    case teaspoonMetric = 200
    case teaspoonUS

    case tablespoonMetric = 300
    case tablespoonUS
    case tablespoonAustralia

    case fluidOunceUSNutritionLabeling = 400
    case fluidOunceUSCustomary
    case fluidOunceImperial

    case pintUSLiquid = 500
    case pintUSDry
    case pintImperial
    case pintMetric
    case pintFlemishPintje
    case pintIndia
    case pintSouthAustralia
    case pintAustralia
    case pintRoyal
    case pintCanada

    case quartUSLiquid = 600
    case quartUSDry
    case quartImperial

    case gallonUSLiquid = 700
    case gallonUSDry
    case gallonImperial

}

public extension VolumeUnit {
    var type: VolumeUnitType {
        switch self {
            
        case .mL:
            return .mL
            
        case .liter:
            return .liter
            
        case .cupUSLegal, .cupUSCustomary, .cupImperial, .cupMetric, .cupCanada, .cupLatinAmerica, .cupJapanTraditional, .cupJapanModern, .cupRussianProper, .cupRussianGlassRegular, .cupRussianGlassLarge:
            return .cup
            
        case .teaspoonMetric, .teaspoonUS:
            return .teaspoon
            
        case .tablespoonMetric, .tablespoonUS, .tablespoonAustralia:
            return .tablespoon
            
        case .fluidOunceUSNutritionLabeling, .fluidOunceUSCustomary, .fluidOunceImperial:
            return .fluidOunce
            
        case .pintUSLiquid, .pintUSDry, .pintImperial, .pintMetric, .pintFlemishPintje, .pintIndia, .pintSouthAustralia, .pintAustralia, .pintRoyal, .pintCanada:
            return .pint
            
        case .quartUSLiquid, .quartUSDry, .quartImperial:
            return .quart
            
        case .gallonUSLiquid, .gallonUSDry, .gallonImperial:
            return .gallon
            
        }
    }
}

public extension VolumeUnit {
    
    var name: String {
        type.name
    }
    
    var abbreviation: String {
        type.abbreviation
    }
}

extension VolumeUnit {
    static func settingsUnits(for type: VolumeUnitType) -> [VolumeUnit] {
        switch type {
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
