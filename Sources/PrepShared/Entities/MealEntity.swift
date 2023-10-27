import Foundation
import CoreData

@objc(MealEntity)
public class MealEntity: NSManagedObject, Identifiable { }

extension MealEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MealEntity> {
        return NSFetchRequest<MealEntity>(entityName: "MealEntity")
    }

    @NSManaged public var carb: Double
    @NSManaged public var energy: Double
    @NSManaged public var energyUnitValue: Int16
    @NSManaged public var fat: Double
    @NSManaged public var id: UUID?
    @NSManaged public var largestEnergyInKcal: Double
    @NSManaged public var microsData: Data?
    @NSManaged public var name: String?
    @NSManaged public var protein: Double
    @NSManaged public var timeString: String?
    @NSManaged public var dayEntity: DayEntity?
    @NSManaged public var mealItemEntities: NSSet?

}

// MARK: Generated accessors for mealItemEntities
extension MealEntity {

    @objc(addMealItemEntitiesObject:)
    @NSManaged public func addToMealItemEntities(_ value: MealItemEntity)

    @objc(removeMealItemEntitiesObject:)
    @NSManaged public func removeFromMealItemEntities(_ value: MealItemEntity)

    @objc(addMealItemEntities:)
    @NSManaged public func addToMealItemEntities(_ values: NSSet)

    @objc(removeMealItemEntities:)
    @NSManaged public func removeFromMealItemEntities(_ values: NSSet)

}
