import Foundation
import CoreData
import CloudKit
import OSLog
import SwiftSugar

private let UploadPollInterval: TimeInterval = 3

extension PublicStore {
    public static func startUploadPoller() {
        shared.startUploadPoller()
    }
    
    func startUploadPoller() {
        uploadTask?.cancel()
        uploadTask = Task.detached(priority: .medium) {
            while true {
                await self.uploadChanges()
                try await sleepTask(UploadPollInterval, tolerance: 1)
                try Task.checkCancellation()
            }
        }
    }
}

extension PublicStore {
    func uploadChanges() async {
        let context = PublicStore.newBackgroundContext()
        do {
            for syncEntity in syncEntities {
                guard syncEntity.direction.shouldUpload else { continue }
                try await syncEntity.type.uploadPendingEntities(context)
            }
        } catch {
            logger.error("Error during upload: \(error.localizedDescription)")
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

