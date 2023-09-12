import Foundation
import CoreData
import CloudKit

public extension PublicStore {
    static func fetchChanges(params: [FetchParam]) {
        shared.fetchChanges(params)
    }
}

extension PublicStore {

    func fetchChanges(_ params: [FetchParam]) {
        fetchTask?.cancel()
        fetchTask = Task.detached(priority: .utility) {
            await self.fetchChanges(params)
        }
    }
    
    private func fetchChanges(_ params: [FetchParam]) async {
        let context = PublicStore.newBackgroundContext()
        do {
//            var dates: [Date?] = []
            for param in params {
                
                /// If UserDefaults does not have a date set, and we have a preset available, set that
                if let presetDate = param.presetModificationDate {
                    param.recordType.setPresetModificationDateIfNeeded(presetDate)
                }
                
                let latestDate = try await param.type.fetchAndPersistUpdatedRecords(
                    context,
                    param.desiredKeys
                )
                
                /// If we fetched results and got returned the latest modification date, set that in the defaults
                if let latestDate {
                    param.recordType.setLatestModificationDate(latestDate)
                }
                
                try Task.checkCancellation()
            }
            
        } catch {
            logger.error("Error during download: \(error.localizedDescription)")
        }
    }
    
}
