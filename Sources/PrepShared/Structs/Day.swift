//import Foundation
//
//struct Day: Codable, Hashable {
//    
//    let dateString: String
//    
//    var energy: Double
//    var energyUnit: EnergyUnit
//    var carb: Double
//    var fat: Double
//    var protein: Double
//    var micros: [FoodNutrient]
//    
//    var meals: [Meal]
//    
//    var plan: Plan?
//    var healthDetails: HealthDetails?
//    
//    init() {
//        self.init(dateString: Date.now.dateString)
//    }
//    
//    init(
//        dateString: String,
//        energy: Double = 0,
//        energyUnit: EnergyUnit = .kcal,
//        carb: Double = 0,
//        fat: Double = 0,
//        protein: Double = 0,
//        micros: [FoodNutrient] = [],
//        meals: [Meal] = [],
//        plan: Plan? = nil,
//        healthDetails: HealthDetails? = nil
//    ) {
//        self.dateString = dateString
//        self.energy = energy
//        self.energyUnit = energyUnit
//        self.carb = carb
//        self.fat = fat
//        self.protein = protein
//        self.micros = micros
//        self.meals = meals
//        self.plan = plan
//        self.healthDetails = healthDetails
//    }
//}
