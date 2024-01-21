import Foundation

public struct Meal: Identifiable, Codable, Hashable {
    public let id: UUID
    public var name: String
    public var time: Date
    public var date: Date
    
    public var energy: Double
    public var energyUnit: EnergyUnit
    public var carb: Double
    public var fat: Double
    public var protein: Double
    public var micros: [FoodNutrient]

    public var largestEnergyInKcal: Double

    public var foodItems: [FoodItem]
    
    public init(
        id: UUID = UUID(),
        name: String = "",
        time: Date = Date.now,
        date: Date = Date.now,
        energy: Double = 0,
        energyUnit: EnergyUnit = .kcal,
        carb: Double = 0,
        fat: Double = 0,
        protein: Double = 0,
        micros: [FoodNutrient] = [],
        largestEnergyInKcal: Double = 0,
        foodItems: [FoodItem] = []
    ) {
        self.id = id
        self.name = name
        self.time = time
        self.date = date
        self.energy = energy
        self.energyUnit = energyUnit
        self.carb = carb
        self.fat = fat
        self.protein = protein
        self.micros = micros
        self.largestEnergyInKcal = largestEnergyInKcal
        self.foodItems = foodItems
    }
    
    public init(_ entity: MealEntity) {
        self.init(
            id: entity.id!,
            name: entity.name!,
            time: entity.time,
            date: Date(fromDateString: entity.dayEntity!.dateString!)!,
            energy: entity.energy,
            energyUnit: entity.energyUnit,
            carb: entity.carb,
            fat: entity.fat,
            protein: entity.protein,
            micros: entity.micros,
            largestEnergyInKcal: entity.largestEnergyInKcal,
            foodItems: entity.foodItems
        )
    }
}
