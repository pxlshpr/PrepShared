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

    static func entity(matching record: CKRecord, in context: NSManagedObjectContext) -> Self?
    static func record(matching entity: Self) async throws -> CKRecord?
    func fill(with record: CKRecord)
    
    func merge(with record: CKRecord, in context: NSManagedObjectContext)
    
    func update(record: CKRecord, in context: NSManagedObjectContext) async throws
}

//MARK: Default Implementations
public extension PublicEntity {
    func merge(with record: CKRecord, in context: NSManagedObjectContext) {
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
    ) async throws -> FetchResult {
        
        func persist(record: CKRecord) async throws -> Bool {
            
            var didPersist = true
            
            try await PublicStore.perform(in: context) {
                 if let existing = Self.entity(matching: record, in: context) {
                     
                     guard existing.updatedAt != record.updatedAt else {
                         PublicStore.logger.trace("\(record.recordType) exists and has the same updatedAt timestamp, skipping over...")
                         didPersist = false
                         return
                     }
                     PublicStore.logger.trace("\(record.recordType) exists, merging...")
                     existing.merge(with: record, in: context)

                } else {
                    PublicStore.logger.trace("\(record.recordType) does not exist, creating...")
                    let entity = Self(context: context)
                    entity.fill(with: record)
                    entity.isSynced = true
                    context.insert(entity)
                }
            }
            
            return didPersist
        }
        
        let result = try await fetchUpdatedRecords(recordType, desiredKeys, context, persist)
        if result.didPersistRecords {
            PublicStore.logger.trace("FetchResult for \(recordType.name) has didPersistRecords set, so sending notification")
            await MainActor.run {
                post(notificationName)
            }
        } else {
            PublicStore.logger.trace("FetchResult for \(recordType.name) does not have didPersistRecords set, so NOT sending notification")
        }
        return result
    }
    
    static func uploadPendingEntities(_ context: NSManagedObjectContext) async throws {
        
        let entities = self.entities(
            in: context,
            predicateFormat: "isSynced == NO"
        ) as! [Self]
        
        PublicStore.logger.debug("Uploading \(entities.count) \(Self.recordType.name) entities")

        for entity in entities {
            guard let record = try await fetchOrCreateRecord(for: entity, in: context) else {
                continue
            }
            
            /// Now call the `CKDatabase.save()` function
            try await PublicDatabase.save(record)
            PublicStore.logger.info("✅ Record Saved")

            /// Once saved, set isSynced to `true`
            try await PublicStore.perform(in: context) {
                entity.isSynced = true
            }
        }
    }
    
    static func fetchOrCreateRecord(for entity: Self, in context: NSManagedObjectContext) async throws -> CKRecord? {

        /// Fetch existing record
        if let existingRecord = try await record(matching: entity) {

            /// Sanity check that `entity.updatedAt` time is more recent
            guard entity.updatedAt! > existingRecord.updatedAt! else {

                PublicStore.logger.trace("Existing (more up-to-date) record found, merging and discarding local changes")

                /// If not more recent, merge record and abandon local changes
                try await PublicStore.perform(in: context) {
                    entity.merge(with: existingRecord, in: context)
                    entity.isSynced = true
                }
                return nil
            }

            PublicStore.logger.trace("Existing (outdated) record found, updating with entity")

            /// Update the fetched record with entity
            try await entity.update(record: existingRecord, in: context)
            
            return existingRecord
            
        } else {
            /// Otherwise, create a new record using `.asCKRecord`
            PublicStore.logger.trace("No existing record found, creating a new one")
            return entity.asCKRecord
        }
    }
    
}
