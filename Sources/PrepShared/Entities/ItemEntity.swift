import Foundation

public protocol ItemEntity: Entity {
    var amountData: Data? { get set }
    var carb: Double { get set }
    var createdAt: Date? { get set }
    var eatenAt: Date? { get set }
    var energy: Double { get set }
    var energyUnitValue: Int16 { get set }
    var fat: Double { get set }
    var id: UUID? { get set }
    var largestEnergyInKcal: Double { get set }
    var energyRatio: Double { get set }
    var microsData: Data? { get set }
    var protein: Double { get set }
    var sortPosition: Int16 { get set }
    var updatedAt: Date? { get set }
    var foodEntity: FoodEntity? { get set }
}

public extension ItemEntity {
    
    var micros: [FoodNutrient] {
        get {
            guard let microsData else { return [] }
            return try! JSONDecoder().decode([FoodNutrient].self, from: microsData)
        }
        set {
            self.microsData = try! JSONEncoder().encode(newValue)
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

    var amount: FoodValue {
        get {
            guard let amountData else {
                fatalError()
            }
            return try! JSONDecoder().decode(FoodValue.self, from: amountData)
        }
        set {
            self.amountData = try! JSONEncoder().encode(newValue)
        }
    }
}

public extension ItemEntity {
    func energy(in unit: EnergyUnit) -> Double {
        self.energyUnit.convert(energy, to: unit)
    }
    
    var energyInKcal: Double {
        energyUnit.convert(energy, to: .kcal)
    }
}
