import Foundation

public struct FoodNutrient: Codable, Hashable {
    
    static let ArraySeparator = "¦"
    static let Separator = "_"
    
    /**
     This can only be `nil` for USDA imported nutrients that aren't yet supported (and must therefore have a `usdaType` if so).
     */
    public var micro: Micro?
    
    /**
     This is used to store the id of a USDA nutrient.
     */
    public var usdaType: Int?
    public var value: Double
    public var unit: NutrientUnit
    
    public init(micro: Micro? = nil, usdaType: Int? = nil, value: Double, unit: NutrientUnit) {
        self.micro = micro
        self.usdaType = usdaType
        self.value = value
        self.unit = unit
    }
}

public extension FoodNutrient {
    
    init?(_ nutrientValue: NutrientValue) {
        guard let micro = nutrientValue.micro else { return nil }
        self.init(
            micro: micro,
            usdaType: nil,
            value: nutrientValue.value,
            unit: nutrientValue.unit
        )
    }
}

public extension FoodNutrient {
    var valueInGrams: Double {
        switch unit {
        case .g:
            return value
        case .mg, .mgAT, .mgNE, .mgGAE:
            return value / 1000.0
        case .mcg, .mcgDFE, .mcgRAE:
            return value / 1000000.0
        default:
            return 0
        }
    }
}

public extension Array where Element == DatasetFoodEntity {
    
    var withNoneZeroVitaminK2: [DatasetFoodEntity] {
        foodsWithNonZeroMicro(.vitaminK2_menaquinone)
    }

    var withSubstantialVitaminK2: [DatasetFoodEntity] {
        foodsWithSubstantialMicro(.vitaminK2_menaquinone)
    }

    var withSubstantialVitaminK1: [DatasetFoodEntity] {
        foodsWithSubstantialMicro(.vitaminK1_phylloquinone)
    }

    var withSubstantialChloride: [DatasetFoodEntity] {
        foodsWithSubstantialMicro(.chloride)
    }

    var withSubstantialCopper: [DatasetFoodEntity] {
        foodsWithSubstantialMicro(.copper)
    }

    func foodsWithSubstantialMicro(_ micro: Micro) -> [DatasetFoodEntity] {
        foodsWithMicro(micro, minimum: 1)
    }

    func foodsWithNonZeroMicro(_ micro: Micro) -> [DatasetFoodEntity] {
        foodsWithMicro(micro, minimum: 0)
    }
    
    func foodsWithMicro(_ micro: Micro, minimum: Double) -> [DatasetFoodEntity] {
        filter {
            guard let micro = $0.micros.micro(micro) else { return false }
            return micro.value > minimum
        }
    }
}

public extension DatasetFoodEntity {
    var vitaminK2: FoodNutrient? {
        micros.vitaminK2
    }

    var vitaminK1: FoodNutrient? {
        micros.micro(.vitaminK1_phylloquinone)
    }

    var copper: FoodNutrient? {
        micros.micro(.copper)
    }
    var chloride: FoodNutrient? {
        micros.micro(.chloride)
    }

}

public extension Array where Element == FoodNutrient {
    func contains(_ micro: Micro) -> Bool {
        contains(where: { $0.micro == micro })
    }
    
    var vitaminK2: FoodNutrient? {
        micro(.vitaminK2_menaquinone)
    }
    
    func micro(_ micro: Micro) -> FoodNutrient? {
        first(where: { $0.micro == micro })
    }
}
