import Foundation
import CoreData
import CloudKit
import OSLog
import SwiftSugar

private let UploadPollInterval: TimeInterval = 3

extension PublicStore {
    
    public static func uploadPendingEntities() {
        shared.uploadPendingEntities()
    }
    
    func uploadPendingEntities() {
        
        uploadTask?.cancel()
        uploadTask = Task.detached(priority: .medium) {
            while true {
                let didComplete = await self.uploadPendingEntities()
                
                /// Only continue polling if we haven't completed the update (in case it failed from the network being lost etc)
                guard !didComplete else { break }
                
                try await sleepTask(UploadPollInterval, tolerance: 1)
                try Task.checkCancellation()
            }
        }
    }
}

extension PublicStore {
    func uploadPendingEntities() async -> Bool {
        let context = PublicStore.newBackgroundContext()
        do {
            /// For each sync entity, in the order provided
            for syncEntity in syncEntities {
                
                /// Ensure the SyncEntity is set to be uploaded
                guard syncEntity.direction.shouldUpload else { continue }
                
                /// Upload any pending entities
                try await syncEntity.type.uploadPendingEntities(context)

                try Task.checkCancellation()
            }
            
            /// Return true once all pending entities have been uploaded
            return true
            
        } catch {
            logger.error("Error during upload: \(error.localizedDescription)")
            return false
        }
    }
}

//extension PublicStore {
    
//    func uploadSearchWords(_ context: NSManagedObjectContext) async throws {
//        
//        func updatedOrCreatedRecord(for entity: SearchWordEntity) async throws -> CKRecord? {
//            /// First try and fetch the existing record for the id
//            if let existingRecord = try await PublicDatabase.record(matching: entity.asSearchWord) {
//                /// If it was fetched, first do a sanity check and ensure our `updatedAt` time is more recent (in case changes occurred and were synced between the download and upload calls during the sync)
//                guard entity.updatedAt! > existingRecord.updatedAt! else {
//                    /// Otherwise merging the CloudKit copy and abandoning our changes
//                    await context.performInBackgroundAndMergeWithMainContext(
//                        mainContext: PublicStore.mainContext
//                    ) {
//                        entity.merge(with: existingRecord, context: context)
//                        entity.isSynced = true
//                    }
//                    return nil
//                }
//                
//                let previousID = entity.id!
//
//                /// If our copy is in fact more recent, update the fetched record with it
////                existingRecord.update(withSearchWordEntity: entity)
//                
//                await context.performInBackgroundAndMergeWithMainContext(
//                    mainContext: PublicStore.mainContext
//                ) {
//                    /// Replace the ID in any entities that may have used the old ID if it's different to what we have
//                    if previousID != existingRecord.id {
//                        DatasetFoodEntity.replaceWordID(previousID, with: existingRecord.id!, context: context)
//                    }
//                }
//                
//                return existingRecord
//                
//            } else {
//                /// Otherwise, create a new record using `.asCKRecord`
//                return entity.asCKRecord
//            }
//        }
//        
//        let entities = SearchWordEntity.objects(
//            predicateFormat: "isSynced == NO",
//            context: context
//        )
//
//        if entities.count > 0 {
//            logger.debug("\(entities.count) words to upload")
//        }
//        
//        for entity in entities {
//            guard let record = try await updatedOrCreatedRecord(for: entity) else {
//                continue
//            }
//            
//            /// Now call the `CKDatabase.save()` function
//            try await PublicDatabase.save(record)
//            
//            await context.performInBackgroundAndMergeWithMainContext(
//                mainContext: PublicStore.mainContext
//            ) {
//                /// Once saved, set isSynced to `true`
//                entity.isSynced = true
//            }
//        }
//    }
    
//    func uploadDatasetFoods(_ context: NSManagedObjectContext) async throws {
//        
//        func updatedOrCreatedRecord(for entity: DatasetFoodEntity) async throws -> CKRecord? {
//            /// First try and fetch the existing record for the id
//            if let existingRecord = try await PublicDatabase.record(id: entity.id!, recordType: .datasetFood) {
//                /// If it was fetched, first do a sanity check and ensure our `updatedAt` time is more recent (in case changes occurred and were synced between the download and upload calls during the sync)
//                guard entity.updatedAt! > existingRecord.updatedAt! else {
//                    /// Otherwise merging the CloudKit copy and abandoning our changes
//                    await context.performInBackgroundAndMergeWithMainContext(
//                        mainContext: PublicStore.mainContext
//                    ) {
//                        entity.merge(with: existingRecord, context: context)
//                        entity.isSynced = true
//                    }
//                    return nil
//                }
//                
//                /// If our copy is in fact more recent, update the fetched record with it
//                existingRecord.update(withDatasetFoodEntity: entity)
//                
//                return existingRecord
//                
//            } else {
//                /// Otherwise, create a new `CKRecord` (not supported yet)
//                fatalError()
//            }
//        }
//        
//        let entities = DatasetFoodEntity.objects(
//            predicateFormat: "isSynced == NO",
//            context: context
//        )
//        logger.debug("We have: \(entities.count) foods to upload")
//
//        for entity in entities {
//            guard let record = try await updatedOrCreatedRecord(for: entity) else {
//                continue
//            }
//            
//            /// Now call the `CKDatabase.save()` function
//            try await PublicDatabase.save(record)
//            
//            await context.performInBackgroundAndMergeWithMainContext(
//                mainContext: PublicStore.mainContext
//            ) {
//                /// Once saved, set isSynced to `true`
//                entity.isSynced = true
//            }
//        }
//    }
//}

