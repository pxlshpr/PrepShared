import Foundation
import CoreData

@objc(DayEntity)
public class DayEntity: NSManagedObject, Identifiable { }

extension DayEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DayEntity> {
        return NSFetchRequest<DayEntity>(entityName: "DayEntity")
    }

    @NSManaged public var biometricsData: Data?
    @NSManaged public var carb: Double
    @NSManaged public var createdAt: Date?
    @NSManaged public var dateString: String?
    @NSManaged public var energy: Double
    @NSManaged public var energyUnitValue: Int16
    @NSManaged public var fat: Double
    @NSManaged public var microsData: Data?
    @NSManaged public var planData: Data?
    @NSManaged public var protein: Double
    @NSManaged public var updatedAt: Date?
    @NSManaged public var mealEntities: NSSet?

}
