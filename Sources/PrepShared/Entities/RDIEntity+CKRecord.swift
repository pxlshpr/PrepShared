import Foundation
import CoreData
import CloudKit

public extension RDIEntity {
    
    static var recordType: RecordType { .rdi }
    static var notificationName: Notification.Name { .didUpdateRDI }
    
    static func entity(matching record: CKRecord, in context: NSManagedObjectContext) -> RDIEntity? {
        entity(in: context, with: record.id!)
    }
}

public extension RDIEntity {
    func fill(fields: RDIFields) {
        self.micro = fields.micro
        self.unit = fields.unit
        self.type = fields.type
        self.url = fields.url
        self.values = fields.values
        //TODO: Handle source!
//        self.source = fields.source
    }
}

public extension RDIEntity {
    func fill(with record: CKRecord) {
        self.id = record.id
        self.createdAt = record.createdAt
        self.updatedAt = record.updatedAt
        self.isTrashed = record.isTrashed ?? false
        
        self.micro = record.rdiMicro!
        self.unit = record.rdiUnit!
        self.type = record.rdiType!
        self.url = record.url!
        self.values = record.rdiValues!
        
        //TODO: Handle source
//        self.source = record.rdiSourceID
    }
    
    func update(record: CKRecord, in context: NSManagedObjectContext) async throws {
        record[.rdiMicroValue] = microValue as CKRecordValue
        record[.rdiUnitValue] = unitValue as CKRecordValue
        record[.rdiTypeData] = typeData as? CKRecordValue
        record[.rdiValuesData] = valuesData as? CKRecordValue
        record[.url] = url as? CKRecordValue
        
        record[.isTrashed] = isTrashed as CKRecordValue
        record[.updatedAt] = Date.now as CKRecordValue
    }
    
    var asCKRecord: CKRecord {
        
        let record = CKRecord(recordType: RecordType.searchWord.name)

        if let id { record[.id] = id.uuidString as CKRecordValue }
        if let createdAt { record[.createdAt] = createdAt as CKRecordValue }
        if let updatedAt { record[.updatedAt] = updatedAt as CKRecordValue }
        record[.isTrashed] = isTrashed as CKRecordValue

        record[.rdiMicroValue] = microValue as CKRecordValue
        record[.rdiUnitValue] = unitValue as CKRecordValue
        if let typeData { record[.rdiTypeData] = typeData as CKRecordValue }
        if let url { record[.url] = url as CKRecordValue }
        if let valuesData { record[.rdiValuesData] = valuesData as CKRecordValue }
        
        return record
    }
}
