import Foundation
import CoreData
import CloudKit

@objc(RDISourceEntity)
public final class RDISourceEntity: NSManagedObject, Identifiable, PublicEntity { }

extension RDISourceEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<RDISourceEntity> {
        return NSFetchRequest<RDISourceEntity>(entityName: "RDISourceEntity")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var createdAt: Date?
    @NSManaged public var updatedAt: Date?
    @NSManaged public var isTrashed: Bool
    @NSManaged public var isSynced: Bool

    @NSManaged public var abbreviation: String?
    @NSManaged public var name: String?
    @NSManaged public var detail: String?
    @NSManaged public var url: String?
    
    @NSManaged public var rdiEntities: NSSet?
}

extension RDISourceEntity {

    @objc(addRDIEntitiesObject:)
    @NSManaged public func addToRDIEntities(_ value: RDIEntity)

    @objc(removeRDIEntitiesObject:)
    @NSManaged public func removeFromRDIEntities(_ value: RDIEntity)

    @objc(addRDIEntities:)
    @NSManaged public func addToRDIEntities(_ values: NSSet)

    @objc(removeRDIEntities:)
    @NSManaged public func removeFromRDIEntities(_ values: NSSet)

}

public extension RDISourceEntity {
    convenience init(context: NSManagedObjectContext, fields: RDISourceFields) {
        self.init(context: context)
        self.id = UUID()
        self.createdAt = Date.now
        self.updatedAt = Date.now
        self.isTrashed = false
        self.isSynced = false
        self.fill(fields: fields)
    }
}

public extension RDISourceEntity {
    var asRDISource: RDISource {
        RDISource(
            id: id!,
            createdAt: createdAt!,
            updatedAt: updatedAt!,
            isTrashed: isTrashed,
            abbreviation: abbreviation!,
            name: name!,
            detail: detail,
            url: url
        )
    }
}
