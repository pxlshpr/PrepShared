//import Foundation
//import CoreData
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
//    var biometrics: Biometrics?
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
//        biometrics: Biometrics? = nil
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
//        self.biometrics = biometrics
//    }
//    
//    init(_ entity: DayEntity) {
//        self.init(
//            dateString: entity.dateString!,
//            energy: entity.energy,
//            energyUnit: entity.energyUnit,
//            carb: entity.carb,
//            fat: entity.fat,
//            protein: entity.protein,
//            micros: entity.micros,
//            meals: entity.meals,
//            plan: entity.plan,
//            biometrics: entity.biometrics
//        )
//    }
//}
