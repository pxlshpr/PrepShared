import Foundation
import CoreData

@objc(PlanEntity)
public class PlanEntity: NSManagedObject, Identifiable { }

extension PlanEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PlanEntity> {
        return NSFetchRequest<PlanEntity>(entityName: "PlanEntity")
    }

    @NSManaged public var createdAt: Date?
    @NSManaged public var goalsData: Data?
    @NSManaged public var id: UUID?
    @NSManaged public var isDisabled: Bool
    @NSManaged public var isTrashed: Bool
    @NSManaged public var name: String?
    @NSManaged public var updatedAt: Date?

}
