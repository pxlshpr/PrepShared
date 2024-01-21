import Foundation

public var cloudKitID: String? = nil

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

public extension ItemEntity {
    var food: Food {
        Food(foodEntity!)
    }
}

public extension Food {
    init(_ entity: FoodEntity) {
        self.init(
            id: entity.id!,
            emoji: entity.emoji!,
            name: entity.name!,
            detail: entity.detail,
            brand: entity.brand,
            amount: entity.amount,
            serving: entity.serving,
            previewAmount: entity.previewAmount,
            energy: entity.energy,
            energyUnit: entity.energyUnit,
            carb: entity.carb,
            protein: entity.protein,
            fat: entity.fat,
            micros: entity.micros,
            sizes: entity.sizes,
            density: entity.density,
            url: entity.url,
            imageIDs: entity.imageIDs,
            barcodes: entity.barcodes,
            type: entity.type,
            publishStatus: entity.publishStatus,
            dataset: entity.dataset,
            datasetID: entity.datasetID,
            lastAmount: entity.lastAmount,
            updatedAt: entity.updatedAt ?? entity.createdAt!,
            createdAt: entity.createdAt!,
            isTrashed: entity.isTrashed,
            childrenFoodItems: entity.ingredientItems,
            ownerID: entity.ownerID,
            isOwnedByMe: entity.ownerID == cloudKitID,
//            rejectionReasons: entity.rejectionReasons,
//            rejectionNotes: entity.rejectionNotes,
            searchTokens: entity.searchTokens,
            isPendingNotification: entity.isPendingNotification
        )
    }
}

public extension FoodEntity {
    
    var barcodes: [String] {
        get {
            guard let barcodesString, !barcodesString.isEmpty else { return [] }
            return barcodesString
                .components(separatedBy: BarcodesSeparator)
        }
        set {
            self.barcodesString = newValue
                .joined(separator: BarcodesSeparator)
        }
    }

    var searchTokens: [FlattenedSearchToken] {
        get {
            guard let searchTokensString else { return [] }
            return searchTokensString.searchTokens
        }
        set {
            self.searchTokensString = newValue.asString
        }
    }

//    var rejectionReasons: [RejectionReason]? {
//        get {
//            guard let rejectionReasonsData else { return nil }
//            return try! JSONDecoder().decode([RejectionReason].self, from: rejectionReasonsData)
//        }
//        set {
//            if let newValue {
//                self.rejectionReasonsData = try! JSONEncoder().encode(newValue)
//            } else {
//                self.rejectionReasonsData = nil
//            }
//        }
//    }
    
    var imageIDs: [UUID] {
        get {
            guard let imageIDsData else { return [] }
            return try! JSONDecoder().decode([UUID].self, from: imageIDsData)
        }
        set {
            self.imageIDsData = try! JSONEncoder().encode(newValue)
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

    var micros: [FoodNutrient] {
        get {
            guard let microsData else { fatalError() }
            return try! JSONDecoder().decode([FoodNutrient].self, from: microsData)
        }
        set {
            self.microsData = try! JSONEncoder().encode(newValue)
        }
    }

    var sizes: [FoodSize] {
        get {
            guard let sizesData else { fatalError() }
            return try! JSONDecoder().decode([FoodSize].self, from: sizesData)
        }
        set {
            self.sizesData = try! JSONEncoder().encode(newValue)
        }
    }

    var serving: FoodValue? {
        get {
            guard let servingData else {
                return nil
            }
            return try! JSONDecoder().decode(FoodValue.self, from: servingData)
        }
        set {
            if let newValue {
                self.servingData = try! JSONEncoder().encode(newValue)
            } else {
                self.servingData = nil
            }
        }
    }
    
    var previewAmount: FoodValue? {
        get {
            guard let previewAmountData else {
                return nil
            }
            return try! JSONDecoder().decode(FoodValue.self, from: previewAmountData)
        }
        set {
            if let newValue {
                self.previewAmountData = try! JSONEncoder().encode(newValue)
            } else {
                self.previewAmountData = nil
            }
        }
    }
    
    var lastAmount: FoodValue? {
        get {
            guard let lastAmountData else {
                return nil
            }
            return try! JSONDecoder().decode(FoodValue.self, from: lastAmountData)
        }
        set {
            if let newValue {
                self.lastAmountData = try! JSONEncoder().encode(newValue)
            } else {
                self.lastAmountData = nil
            }
        }
    }
    
    var density: FoodDensity? {
        get {
            guard let densityData else { return nil }
            return try! JSONDecoder().decode(FoodDensity.self, from: densityData)
        }
        set {
            if let newValue {
                self.densityData = try! JSONEncoder().encode(newValue)
            } else {
                self.densityData = nil
            }
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

    var type: FoodType {
        get {
            FoodType(rawValue: Int(typeValue)) ?? .food
        }
        set {
            typeValue = Int16(newValue.rawValue)
        }
    }

    var dataset: FoodDataset? {
        get {
            FoodDataset(rawValue: Int(datasetValue))
        }
        set {
            if let newValue {
                datasetValue = Int16(newValue.rawValue)
            } else {
                datasetValue = 0
            }
        }
    }

    var publishStatus: PublishStatus? {
        get {
            PublishStatus(rawValue: Int(publishStatusValue))
        }
        set {
            if let newValue {
                publishStatusValue = Int16(newValue.rawValue)
            } else {
                publishStatusValue = 0
            }
        }
    }
}

public extension FoodEntity {
    var ingredientItemEntitiesArray: [IngredientItemEntity] {
        ingredientItemEntities?.allObjects as? [IngredientItemEntity] ?? []
    }
    var ingredientItems: [FoodItem] {
        ingredientItemEntitiesArray
            .compactMap { FoodItem($0) }
            .sorted()
    }
    
    var mealItemEntitiesArray: [MealItemEntity] {
        mealItemEntities?.allObjects as? [MealItemEntity] ?? []
    }
    var mealItems: [FoodItem] {
        mealItemEntitiesArray
            .compactMap { FoodItem($0) }
            .sorted()
    }
    
    var asIngredientItemEntitiesArray: [IngredientItemEntity] {
        asIngredientItemEntities?.allObjects as? [IngredientItemEntity] ?? []
    }
    var asIngredientItems: [FoodItem] {
        asIngredientItemEntitiesArray
            .compactMap { FoodItem($0) }
            .sorted()
    }

}

public extension FoodEntity {
    var fullName: String {
        Food(self).fullName
    }
    
    var source: FoodSource {
        if self.dataset != nil {
            return .dataset
        }
        if self.ownerID == cloudKitID {
            return .private
        }
        return .public
    }
}
