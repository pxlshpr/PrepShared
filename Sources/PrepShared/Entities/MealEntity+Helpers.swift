import Foundation

public extension MealEntity {
    
    var mealItemEntitiesArray: [MealItemEntity] {
        mealItemEntities?.allObjects as? [MealItemEntity] ?? []
    }
    
    var foodItems: [FoodItem] {
        mealItemEntitiesArray
            .compactMap { FoodItem($0) }
            .sorted(by: { $0.sortPosition < $1.sortPosition })
    }
}

public extension MealEntity {
    var time: Date {
        get {
            guard let timeString,
                  let date = Date(fromTimeString: timeString)
            else { fatalError() }
            return date
        }
        set {
            self.timeString = newValue.timeString
        }
    }
    
    var energyUnit: EnergyUnit {
        get {
            EnergyUnit(rawValue: Int(energyUnitValue)) ?? .kcal
        }
        set {
            energyUnitValue = Int16(newValue.rawValue)
        }
    }
    
    var micros: [FoodNutrient] {
        get {
            guard let microsData else { return [] }
            return try! JSONDecoder().decode([FoodNutrient].self, from: microsData)
        }
        set {
            self.microsData = try! JSONEncoder().encode(newValue)
        }
    }
}
