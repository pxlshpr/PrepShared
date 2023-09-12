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
            var dates: [Date?] = []
            for param in params {
                let date = try await param.type.fetchAndPersistUpdatedRecords(context, param.desiredKeys)
                dates.append(date)
                try Task.checkCancellation()
            }
            
            if let latestDate = dates.latestDate {
                setLatestModificationDate(latestDate)
            }
        } catch {
            logger.error("Error during download: \(error.localizedDescription)")
        }
    }
    
}
