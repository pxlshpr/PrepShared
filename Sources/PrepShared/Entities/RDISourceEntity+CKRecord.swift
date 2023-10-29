import Foundation
import CoreData
import CloudKit

public extension RDISourceEntity {
    
    static var recordType: RecordType { .rdiSource }
    static var notificationName: Notification.Name { .didUpdateRDISource }
    
    static func entity(matching record: CKRecord, in context: NSManagedObjectContext) -> RDISourceEntity? {
        entity(in: context, with: record.id!)
    }
}

public extension RDISourceEntity {
    func fill(fields: RDISourceFields) {
        self.abbreviation = fields.abbreviation
        self.name = fields.name
        self.detail = fields.detail
        self.url = fields.url
    }
}

public extension RDISourceEntity {
    func fill(with record: CKRecord) {
        self.id = record.id
        self.createdAt = record.createdAt
        self.updatedAt = record.updatedAt
        self.isTrashed = record.isTrashed ?? false
        
        self.abbreviation = record.abbreviation
        self.name = record.name
        self.detail = record.detail
        self.url = record.url
    }
    
    func update(record: CKRecord, in context: NSManagedObjectContext) async throws {
        record[.isTrashed] = isTrashed as CKRecordValue
        record[.abbreviation] = abbreviation as? CKRecordValue
        record[.name] = name as? CKRecordValue
        record[.detail] = detail as? CKRecordValue
        record[.url] = url as? CKRecordValue
        record[.updatedAt] = Date.now as CKRecordValue
    }
    
    var asCKRecord: CKRecord {
        
        let record = CKRecord(recordType: Self.recordType.name)
        
        if let id { record[.id] = id.uuidString as CKRecordValue }
        if let name { record[.name] = name as CKRecordValue }
        if let detail { record[.detail] = detail as CKRecordValue }
        if let url { record[.url] = url as CKRecordValue }
        if let abbreviation { record[.abbreviation] = abbreviation as CKRecordValue }
        
        if let createdAt { record[.createdAt] = createdAt as CKRecordValue }
        if let updatedAt { record[.updatedAt] = updatedAt as CKRecordValue }
        record[.isTrashed] = isTrashed as CKRecordValue
        
        return record
    }
}
