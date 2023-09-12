import Foundation
import CoreData
import CloudKit

public extension SearchWordEntity {
    
    static var recordType: RecordType { .searchWord }
    static var notificationName: Notification.Name { .didUpdateWord }
    
    static func entity(matching record: CKRecord, context: NSManagedObjectContext) -> SearchWordEntity? {
        existingWord(matching: record, context: context)
    }
    
    static func record(matching entity: SearchWordEntity) async throws -> CKRecord? {
        try await PublicDatabase.record(matching: entity.asSearchWord)
    }
    
    func fill(with record: CKRecord) {
        self.id = record.id
        self.singular = record.singular
        self.spellings = record.spellings
        self.createdAt = record.createdAt
        self.updatedAt = record.updatedAt
        self.isTrashed = record.isTrashed ?? false
    }
    
    func merge(with record: CKRecord, context: NSManagedObjectContext) {
        
        let previousID = self.id!
        self.id = record.id /// Use the record's ID regardless of how recent our version is

        /// If the record is more recent than this version
        /// *Note: The `updatedAt` time is used instead of CloudKit's `modificationDate`, so that we are comparing
        /// when the records were actually updated on their respective devices, and not when they were saved in CloudKit
        /// (to account for situations such as the network not being available).*
        if isLessRecent(than: record) {
            /// Use all its values, discarding our changes (singular might change too if it had a diacritic)
            fill(with: record)

            /// Make sure we're not setting this to be synced any more in case it was set to `false` by changes we have now discarded
            isSynced = true
        } else {
            /// If our version is more recent then we retain any changes we may have made (and the potential `isSynced = false`), which will be subsequently uploaded.
        }

        /// Replace the `id` in any entities that may have used the old one (if it's different to what we have)
        if previousID != id {
            Self.replaceWordID(previousID, with: record.id!, context: context)
        }
    }
    
    func update(record: CKRecord, context: NSManagedObjectContext) async {
        
        /// **Important** `id` of the `CKRecord` never changes
        record[.singular] = self.singular! as CKRecordValue
        if let spellingsString {
            record[.spellingsString] = spellingsString as CKRecordValue
        } else {
            record[.spellingsString] = nil
        }
        record[.isTrashed] = isTrashed as CKRecordValue
        record[.updatedAt] = updatedAt! as CKRecordValue

        if id != record.id {
            await context.performInBackgroundAndMergeWithMainContext(
                mainContext: PublicStore.mainContext
            ) {
                /// Replace the `id` anywhere the old one is used
                Self.replaceWordID(self.id!, with: record.id!, context: context)

                /// Set the `CKRecord.id` here if different, as it's the source of truth
                self.id = record.id
            }
        }
    }
    
    static func replaceWordID(_ old: UUID, with new: UUID, context: NSManagedObjectContext) {
        DatasetFoodEntity.replaceWordID(old, with: new, context: context)
        VerifiedFoodEntity.replaceWordID(old, with: new, context: context)
    }
}
