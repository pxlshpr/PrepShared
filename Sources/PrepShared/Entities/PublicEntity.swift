import Foundation
import CoreData
import CloudKit

public protocol PublicEntity: Entity {
    var id: UUID? { get set }
    var updatedAt: Date? { get set }
    var isSynced: Bool { get set }
    
    var asCKRecord: CKRecord { get }

    static var recordType: RecordType { get }
    static var notificationName: Notification.Name { get }

    static func entity(matching record: CKRecord, context: NSManagedObjectContext) -> Self?
    static func record(matching entity: Self) async throws -> CKRecord?
    func fill(with record: CKRecord)
    
    func merge(with record: CKRecord, context: NSManagedObjectContext)
    
    func update(record: CKRecord, context: NSManagedObjectContext) async
}

//MARK: Default Implementations
public extension PublicEntity {
    func merge(with record: CKRecord, context: NSManagedObjectContext) {
        /// Make sure the record is more recent than this version
        guard isLessRecent(than: record) else {
            /// If our version is more recent then we retain any changes we may have made, which will be
            /// subsequently uploaded during the sync.
            return
        }
        /// Use all its values (that could have possibly changed), discarding our changes and resetting `isSynced` to `false`
        fill(with: record)
        isSynced = true
    }
    
    static func record(matching entity: Self) async throws -> CKRecord? {
        try await PublicDatabase.record(id: entity.id!, recordType: recordType)
    }
}

//MARK: Convenience Helpers
public extension PublicEntity {
    func setAsUpdated() {
        self.updatedAt = Date.now
        self.isSynced = false
    }
    
    func isLessRecent(than record: CKRecord) -> Bool {
        /// Always favour the CloudKit record when we have a timestamp missing
        guard let updatedAt = self.updatedAt else { return true }
        guard let recordUpdatedAt = record.updatedAt else { return true }
        
        return recordUpdatedAt > updatedAt
    }
    
    static func fetchAndPersistUpdatedRecords(
        _ context: NSManagedObjectContext,
        _ desiredKeys: [CKRecord.FieldKey]?
    ) async throws -> Date? {
        
        func persist(record: CKRecord) async throws {
            
            try await context.performAndMergeWith(PublicStore.mainContext) {
                if let existing = Self.entity(matching: record, context: context) {
                    PublicStore.logger.trace("\(record.recordType) already exists, merging...")
                    existing.merge(with: record, context: context)
                } else {
                    PublicStore.logger.trace("\(record.recordType) does not exist, creating...")
                    let entity = Self(context: context)
                    entity.fill(with: record)
                    entity.isSynced = true
                    context.insert(entity)
                }
            }
        }
        
        let date = try await fetchUpdatedRecords(recordType, desiredKeys, context, persist)
        await MainActor.run {
            post(notificationName)
        }
        return date
    }
    
    static func uploadPendingEntities(_ context: NSManagedObjectContext) async throws {
        
        let entities = self.objects(
            predicateFormat: "isSynced == NO",
            context: context
        ) as! [Self]
        
        PublicStore.logger.debug("We have: \(entities.count) foods to upload")

        for entity in entities {
            guard let record = try await fetchOrCreateRecord(for: entity, in: context) else {
                continue
            }
            
            /// Now call the `CKDatabase.save()` function
            try await PublicDatabase.save(record)
            
            await context.performInBackgroundAndMergeWithMainContext(
                mainContext: PublicStore.mainContext
            ) {
                /// Once saved, set isSynced to `true`
                entity.isSynced = true
            }
        }
    }
    
    static func fetchOrCreateRecord(for entity: Self, in context: NSManagedObjectContext) async throws -> CKRecord? {

        /// Fetch existing record
        if let existingRecord = try await record(matching: entity) {

            /// Sanity check that `entity.updatedAt` time is more recent
            guard entity.updatedAt! > existingRecord.updatedAt! else {

                /// If not more recent, merge record and abandon local changes
                try await context.performAndMergeWith(PublicStore.mainContext) {
                    entity.merge(with: existingRecord, context: context)
                    entity.isSynced = true
                }
                return nil
            }
            
            /// Update the fetched record with entity
            await entity.update(record: existingRecord, context: context)
            
            return existingRecord
            
        } else {
            /// Otherwise, create a new record using `.asCKRecord`
//                return entity.asCKRecord
            fatalError()
        }
    }
    
}
