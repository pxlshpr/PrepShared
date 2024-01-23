import Foundation

public struct Day: Codable, Hashable {
    
    public let dateString: String
    
    public var energy: Double
    public var energyUnit: EnergyUnit
    public var carb: Double
    public var fat: Double
    public var protein: Double
    public var micros: [FoodNutrient]
    
    public var meals: [Meal]
    
    public var plan: Plan?
    public var healthDetails: HealthDetails?
    
    public var dietaryEnergyPoint: DietaryEnergyPoint?

    public var useDailyValues: Bool
    public var dailyValues: [Micro : DailyValue]
    
    public init() {
        self.init(dateString: Date.now.dateString)
    }
    
    public init(
        dateString: String,
        energy: Double = 0,
        energyUnit: EnergyUnit = .kcal,
        carb: Double = 0,
        fat: Double = 0,
        protein: Double = 0,
        micros: [FoodNutrient] = [],
        meals: [Meal] = [],
        plan: Plan? = nil,
        healthDetails: HealthDetails? = nil,
        dietaryEnergyPoint: DietaryEnergyPoint? = nil,
        useDailyValues: Bool = false,
        dailyValues: [Micro : DailyValue] = [:]
    ) {
        self.dateString = dateString
        self.energy = energy
        self.energyUnit = energyUnit
        self.carb = carb
        self.fat = fat
        self.protein = protein
        self.micros = micros
        self.meals = meals
        self.plan = plan
        self.healthDetails = healthDetails
        self.dietaryEnergyPoint = dietaryEnergyPoint
        self.useDailyValues = useDailyValues
        self.dailyValues = dailyValues
    }
}

public extension Day {
    var energyInKcal: Double? {
        energy
    }
    
    var date: Date? {
        Date(fromDateString: dateString)
    }
}
