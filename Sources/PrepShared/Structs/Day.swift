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
        dietaryEnergyPoint: DietaryEnergyPoint? = nil
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
    }
}
