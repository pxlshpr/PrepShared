import Foundation
import CoreData
import CloudKit
import OSLog

public extension PublicStore {
    static func fetchChanges() {
        shared.fetchChanges()
    }
}

extension PublicStore {

    func fetchChanges() {
        fetchTask?.cancel()
        fetchTask = Task.detached(priority: .utility) {
            await self.fetchChanges()
        }
    }
    
    private func fetchChanges() async {
        let context = PublicStore.newBackgroundContext()
        do {
            for syncEntity in syncEntities {
                guard syncEntity.direction.shouldDownload else { continue }
                
                /// If UserDefaults does not have a date set, and we have a preset available, set that
                if let presetDate = syncEntity.presetModificationDate {
                    syncEntity.recordType.setPresetModificationDateIfNeeded(presetDate)
                }
                
                let latestDate = try await syncEntity.type.fetchAndPersistUpdatedRecords(
                    context,
                    syncEntity.desiredKeys
                )
                
                /// If we fetched results and got returned the latest modification date, set that in the defaults
                if let latestDate {
                    syncEntity.recordType.setLatestModificationDate(latestDate)
                }
                
                try Task.checkCancellation()
            }
            
        } catch {
            logger.error("Error during download: \(error.localizedDescription)")
        }
    }
}

func fetchUpdatedRecords(
    _ type: RecordType,
    _ desiredKeys: [CKRecord.FieldKey]?,
    _ context: NSManagedObjectContext,
    _ persistRecordHandler: @escaping (CKRecord) async throws -> ()
) async throws -> Date? {
    
    var latestModificationDate: Date? = nil
    
    func processRecords(for query: CKQuery? = nil, continuing cursor: CKQueryOperation.Cursor? = nil) async throws {
        let logger = PublicStore.logger
        do {

            logger.info("Fetching updated records for \(type.name)")

            let (results, cursor) = if let query {
                try await PublicDatabase.records(matching: query, desiredKeys: desiredKeys)
            } else {
                try await PublicDatabase.records(continuingMatchFrom: cursor!)
            }
            
            logger.info("Fetched \(results.count) \(type.name) records")
            
            latestModificationDate = results.latestModificationDate(ifAfter: latestModificationDate)
            
            for result in results {
                switch result.1 {
                case .success(let record):
                    try await persistRecordHandler(record)
                case .failure(let error):
                    throw error
                }
            }
            
            if let cursor {
                logger.trace("Cursor received for \(type.name), running a new query with that")
                try await processRecords(continuing: cursor)
            } else {
                logger.info("✅ Fetch is complete since no cursor received for \(type.name). Latest modification date was \(String(describing: latestModificationDate))")
            }
            
        } catch let error as CKError {
            if error.code == .unknownItem {
                logger.warning("Fetch failed for \(type.name) with unknownItem error. This indicates that the Record does not exist on CloudKit yet. Continuing without throwing an error.")
            } else {
                throw error
            }
        } catch {
            throw error
        }
    }
    
    let query = CKQuery.updatedRecords(of: type)
    try await processRecords(for: query)
    return latestModificationDate
}

