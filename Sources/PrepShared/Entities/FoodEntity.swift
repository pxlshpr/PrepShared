import Foundation
import CoreData

@objc(FoodEntity)
public final class FoodEntity: NSManagedObject, Identifiable, Entity { }

extension FoodEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FoodEntity> {
        return NSFetchRequest<FoodEntity>(entityName: "FoodEntity")
    }

    @NSManaged public var amountData: Data?
    @NSManaged public var barcodesString: String?
    @NSManaged public var brand: String?
    @NSManaged public var carb: Double
    @NSManaged public var createdAt: Date?
    @NSManaged public var datasetID: String?
    @NSManaged public var datasetValue: Int16
    @NSManaged public var densityData: Data?
    @NSManaged public var detail: String?
    @NSManaged public var emoji: String?
    @NSManaged public var energy: Double
    @NSManaged public var energyUnitValue: Int16
    @NSManaged public var fat: Double
    @NSManaged public var id: UUID?
    @NSManaged public var imageIDsData: Data?
    @NSManaged public var isPendingNotification: Bool
    @NSManaged public var isTrashed: Bool
    @NSManaged public var lastAmountData: Data?
    @NSManaged public var lastUsedAt: Date?
    @NSManaged public var microsData: Data?
    @NSManaged public var name: String?
    @NSManaged public var ownerID: String?
    @NSManaged public var previewAmountData: Data?
    @NSManaged public var protein: Double
    @NSManaged public var publishStatusValue: Int16
    @NSManaged public var searchTokensString: String?
    @NSManaged public var servingData: Data?
    @NSManaged public var sizesData: Data?
    @NSManaged public var typeValue: Int16
    @NSManaged public var updatedAt: Date?
    @NSManaged public var url: String?
    @NSManaged public var asIngredientItemEntities: NSSet?
    @NSManaged public var ingredientItemEntities: NSSet?
    @NSManaged public var mealItemEntities: NSSet?
    @NSManaged public var newVersion: FoodEntity?
    @NSManaged public var oldVersion: FoodEntity?

}

// MARK: Generated accessors for asIngredientItemEntities
extension FoodEntity {

    @objc(addAsIngredientItemEntitiesObject:)
    @NSManaged public func addToAsIngredientItemEntities(_ value: IngredientItemEntity)

    @objc(removeAsIngredientItemEntitiesObject:)
    @NSManaged public func removeFromAsIngredientItemEntities(_ value: IngredientItemEntity)

    @objc(addAsIngredientItemEntities:)
    @NSManaged public func addToAsIngredientItemEntities(_ values: NSSet)

    @objc(removeAsIngredientItemEntities:)
    @NSManaged public func removeFromAsIngredientItemEntities(_ values: NSSet)

}

// MARK: Generated accessors for ingredientItemEntities
extension FoodEntity {

    @objc(addIngredientItemEntitiesObject:)
    @NSManaged public func addToIngredientItemEntities(_ value: IngredientItemEntity)

    @objc(removeIngredientItemEntitiesObject:)
    @NSManaged public func removeFromIngredientItemEntities(_ value: IngredientItemEntity)

    @objc(addIngredientItemEntities:)
    @NSManaged public func addToIngredientItemEntities(_ values: NSSet)

    @objc(removeIngredientItemEntities:)
    @NSManaged public func removeFromIngredientItemEntities(_ values: NSSet)

}

// MARK: Generated accessors for mealItemEntities
extension FoodEntity {

    @objc(addMealItemEntitiesObject:)
    @NSManaged public func addToMealItemEntities(_ value: MealItemEntity)

    @objc(removeMealItemEntitiesObject:)
    @NSManaged public func removeFromMealItemEntities(_ value: MealItemEntity)

    @objc(addMealItemEntities:)
    @NSManaged public func addToMealItemEntities(_ values: NSSet)

    @objc(removeMealItemEntities:)
    @NSManaged public func removeFromMealItemEntities(_ values: NSSet)

}
