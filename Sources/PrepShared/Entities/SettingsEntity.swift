import Foundation
import CoreData

@objc(SettingsEntity)
public class SettingsEntity: NSManagedObject, Identifiable, Entity { }

extension SettingsEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SettingsEntity> {
        return NSFetchRequest<SettingsEntity>(entityName: "SettingsEntity")
    }

    @NSManaged public var createdAt: Date?
    @NSManaged public var settingsData: Data?
    @NSManaged public var updatedAt: Date?

}
