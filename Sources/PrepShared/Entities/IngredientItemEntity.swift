import Foundation
import CoreData

@objc(IngredientItemEntity)
public class IngredientItemEntity: NSManagedObject, Identifiable, ItemEntity { }

extension IngredientItemEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<IngredientItemEntity> {
        return NSFetchRequest<IngredientItemEntity>(entityName: "IngredientItemEntity")
    }

    @NSManaged public var amountData: Data?
    @NSManaged public var carb: Double
    @NSManaged public var createdAt: Date?
    @NSManaged public var eatenAt: Date?
    @NSManaged public var energy: Double
    @NSManaged public var energyUnitValue: Int16
    @NSManaged public var fat: Double
    @NSManaged public var id: UUID?
    @NSManaged public var largestEnergyInKcal: Double
    @NSManaged public var energyRatio: Double
    @NSManaged public var microsData: Data?
    @NSManaged public var protein: Double
    @NSManaged public var sortPosition: Int16
    @NSManaged public var updatedAt: Date?
    @NSManaged public var foodEntity: FoodEntity?
    @NSManaged public var recipeFoodEntity: FoodEntity?

}
