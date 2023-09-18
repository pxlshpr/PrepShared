import Foundation

public enum VolumeUnit: Int, Codable, CaseIterable {
    
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
    
    var explicitName: String {
        switch self {
        case .mL:                               return "Milliliter"
        case .liter:                            return "Liter"
            
        case .cupUSLegal:                       return "US Legal"
        case .cupUSCustomary:                   return "US Customary"
        case .cupImperial:                      return "Imperial"
        case .cupMetric:                        return "Metric"
        case .cupCanada:                        return "Canada"
        case .cupLatinAmerica:                  return "Latin America"
        case .cupJapanTraditional:              return "Japan Traditional"
        case .cupJapanModern:                   return "Japan Modern"
        case .cupRussianProper:                 return "Russian Cup Proper"
        case .cupRussianGlassRegular:           return "Russian Glass (Regular)"
        case .cupRussianGlassLarge:             return "Russian Glass (Large)"
            
        case .teaspoonMetric:                   return "Metric"
        case .teaspoonUS:                       return "US Customary"
            
        case .tablespoonMetric:                 return "Metric"
        case .tablespoonUS:                     return "US"
        case .tablespoonAustralia:              return "Australia"
            
        case .fluidOunceUSNutritionLabeling:    return "US Nutrition Labeling"
        case .fluidOunceUSCustomary:            return "US Customary"
        case .fluidOunceImperial:               return "Imperial"
            
        case .pintUSLiquid:                     return "US Liquid"
        case .pintUSDry:                        return "US Dry"
        case .pintImperial:                     return "Imperial"
        case .pintMetric:                       return "Metric"
        case .pintFlemishPintje:                return "Flemish Pintje"
        case .pintIndia:                        return "India"
        case .pintSouthAustralia:               return "South Australia"
        case .pintAustralia:                    return "Australia"
        case .pintRoyal:                        return "Royal"
        case .pintCanada:                       return "Canada"
            
        case .quartUSLiquid:                    return "US Liquid"
        case .quartUSDry:                       return "US Dry"
        case .quartImperial:                    return "Imperial"
            
        case .gallonUSLiquid:                   return "US Liquid"
        case .gallonUSDry:                      return "US Dry"
        case .gallonImperial:                   return "Imperial"
        }
    }
    
    var equivalentMilliliters: Double {
        switch self {
        case .mL:                               return 1
        case .liter:                            return 1000
            
        case .cupUSLegal:                       return 240
        case .cupUSCustomary:                   return 236.59
        case .cupImperial:                      return 284.13
        case .cupMetric:                        return 250
        case .cupCanada:                        return 227.30
        case .cupLatinAmerica:                  return 200
        case .cupJapanTraditional:              return 180.39
        case .cupJapanModern:                   return 200
        case .cupRussianProper:                 return 100
        case .cupRussianGlassRegular:           return 200
        case .cupRussianGlassLarge:             return 250
            
        case .teaspoonMetric:                   return 5
        case .teaspoonUS:                       return 4.93
            
        case .tablespoonMetric:                 return 15
        case .tablespoonUS:                     return 14.79
        case .tablespoonAustralia:              return 20
            
        case .fluidOunceUSNutritionLabeling:    return 30
        case .fluidOunceUSCustomary:            return 29.57
        case .fluidOunceImperial:               return 28.41
            
        case .pintUSLiquid:                     return 473.18
        case .pintUSDry:                        return 550.61
        case .pintImperial:                     return 568.26
        case .pintMetric:                       return 500
        case .pintFlemishPintje:                return 250
        case .pintIndia:                        return 330
        case .pintSouthAustralia:               return 425
        case .pintAustralia:                    return 570
        case .pintRoyal:                        return 952
        case .pintCanada:                       return 1136.52
            
        case .quartUSLiquid:                    return 946.35
        case .quartUSDry:                       return 1101.22
        case .quartImperial:                    return 1136.52
            
        case .gallonUSLiquid:                   return 3785.41
        case .gallonUSDry:                      return 4404.88
        case .gallonImperial:                   return 4546.09
            
        }
    }
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
