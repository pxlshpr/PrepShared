import Foundation
import CoreData
import CloudKit
import OSLog

import Zip

private let overviewLogger = Logger(subsystem: "PublicStore", category: "Overview")

let PresetModifiedDate = Date(timeIntervalSince1970: 1690830000) /// 1 Aug 2023

@Observable public final class PublicStore: Store {
    
    static let shared = PublicStore()
    
    let container: Container

    let logger = Logger(subsystem: "PublicStore", category: "")
    public static var logger: Logger { shared.logger }
    
    var uploadTask: Task<Void, Error>? = nil
    var fetchTask: Task<Void, Error>? = nil
    
    var syncEntities: [SyncEntity] = []
    
    public static var syncEntities: [SyncEntity] {
        get { shared.syncEntities }
        set { shared.syncEntities = newValue }
    }

    public convenience init() {
        self.init(container: Container())
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    }
    
    init(container: Container) {
        self.container = container
        setupSubscription()
    }

    public static var mainContext: NSManagedObjectContext {
        shared.container.viewContext
    }
    
    public static func newBackgroundContext() -> NSManagedObjectContext {
        shared.container.newBackgroundContext()
    }
}

extension PublicStore {
    public static func populateIfEmpty() {
        let start = CFAbsoluteTimeGetCurrent()
        var count = DatasetFoodEntity.countAll(in: shared.container.viewContext)
        guard count == 0 else {
            logger.debug("Not populating DatasetFoods")
            return
        }
        
        let zipURL = Bundle.main.url(forResource: "DatasetFoods", withExtension: "zip")!
        let unzipURL = try! Zip.quickUnzipFile(zipURL)
        let sqliteURL = unzipURL.appending(path: "DatasetFoods.sqlite")

        shared.replacePersisteStore(with: sqliteURL)

        /// Remove unzipped folder as we don't need these any more
        try! FileManager.default.removeItem(at: unzipURL)

        count = DatasetFoodEntity.countAll(in: shared.container.viewContext)
        logger.debug("Populated \(count) DatasetFoods in \(CFAbsoluteTimeGetCurrent()-start)s")
    }

    public static func replacePersisteStore(with url: URL) {
        shared.replacePersisteStore(with: url)
    }
    
    func replacePersisteStore(with url: URL) {
        container.replacePersisteStore(with: url)
        container.loadPersistentStores { description, error in
            if let error {
                fatalError("Failed to load CoreData: \(error)")
            }
        }
    }
}
