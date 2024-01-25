import Foundation
import CoreData
import CloudKit

@objc(RDIEntity)
public final class RDIEntity: NSManagedObject, Identifiable, PublicEntity { }

extension RDIEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<RDIEntity> {
        return NSFetchRequest<RDIEntity>(entityName: "RDIEntity")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var createdAt: Date?
    @NSManaged public var updatedAt: Date?
    @NSManaged public var isTrashed: Bool
    @NSManaged public var isSynced: Bool
    
    @NSManaged public var microValue: Int16
    @NSManaged public var unitValue: Int16
    @NSManaged public var typeData: Data?
    @NSManaged public var url: String?
    @NSManaged public var valuesData: Data?
    
    @NSManaged public var rdiSourceEntity: RDISourceEntity?
}

public extension RDIEntity {
    
    var micro: Micro {
        get {
            Micro(rawValue: Int(microValue))!
        }
        set {
            microValue = Int16(newValue.rawValue)
        }
    }

    var unit: NutrientUnit {
        get {
            NutrientUnit(rawValue: Int(unitValue))!
        }
        set {
            unitValue = Int16(newValue.rawValue)
        }
    }

    var type: RDIType {
        get {
            guard let typeData else { fatalError() }
            return try! JSONDecoder().decode(RDIType.self, from: typeData)
        }
        set {
            self.typeData = try! JSONEncoder().encode(newValue)
        }
    }
    
    var values: [RDIValue] {
        get {
            guard let valuesData else { fatalError() }
            return try! JSONDecoder().decode([RDIValue].self, from: valuesData)
        }
        set {
            self.valuesData = try! JSONEncoder().encode(newValue)
        }
    }
    
    var source: RDISource? {
        guard let rdiSourceEntity else { return nil }
        return RDISource(from: rdiSourceEntity)
    }
}

public extension RDIEntity {
    convenience init(context: NSManagedObjectContext, fields: RDIFields, rdiSourceEntity: RDISourceEntity) {
        self.init(context: context)
        self.id = UUID()
        self.createdAt = Date.now
        self.updatedAt = Date.now
        self.isTrashed = false
        self.isSynced = false
        self.fill(fields: fields, rdiSourceEntity: rdiSourceEntity)
    }
}

public extension RDIEntity {
    var asRDI: RDI? {
        guard let source, let url else { return nil }
        return RDI(
            id: id!,
            createdAt: createdAt!,
            updatedAt: updatedAt!,
            micro: micro,
            unit: unit,
            type: type,
            values: values,
            source: source,
            url: url
        )
    }
}
