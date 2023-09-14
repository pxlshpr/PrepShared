import CoreData
import SwiftSugar
import OSLog

//MARK: New Methods

let coreDataLogger = Logger(subsystem: "CoreData", category: "Background")

extension NSManagedObjectContext {
    func performAndMergeWith(
        _ mainContext: NSManagedObjectContext,
        _ block: @escaping () throws -> ()
    ) async throws {
        try await performInBackgroundContext(
            self,
            mainContext: mainContext,
            performBlock: block
        )
    }
}

func performInBackgroundContext(
    _ context: NSManagedObjectContext,
    mainContext: NSManagedObjectContext,
    performBlock: @escaping () throws -> ()
) async throws {
    try await withCheckedThrowingContinuation { continuation in
        do {
            try performInBackgroundContext(
                context,
                mainContext: mainContext,
                performBlock: performBlock
            ) {
                continuation.resume()
            }
        } catch {
            continuation.resume(throwing: error)
        }
    }
}

func performInBackgroundContext(
    _ context: NSManagedObjectContext,
    mainContext: NSManagedObjectContext,
    performBlock: @escaping () throws -> (),
    completion: @escaping () -> ()
) throws {
    
    try context.performAndWait {
        try performBlock()
        
        let observer = NotificationCenter.default.addObserver(
            forName: .NSManagedObjectContextDidSave,
            object: context,
            queue: .main
        ) { (notification) in
            mainContext.mergeChanges(fromContextDidSave: notification)
            completion()
        }
        
        try context.performAndWait {
            try context.save()
        }
        NotificationCenter.default.removeObserver(observer)
    }
}

//MARK: _ Legacy
//public extension NSManagedObjectContext {
//    func performInBackgroundAndMergeWithMainContext(
//        mainContext: NSManagedObjectContext,
//        posting notificationName: Notification.Name? = nil,
//        performBlock: @escaping () -> ()
//    ) async {
//        await performInBackgroundContextAndMergeWithMainContext(
//            bgContext: self,
//            mainContext: mainContext,
//            posting: notificationName,
//            performBlock: performBlock
//        )
//    }
//}
//
//public func performInBackgroundContextAndMergeWithMainContext(
//    bgContext: NSManagedObjectContext,
//    mainContext: NSManagedObjectContext,
//    posting notificationName: Notification.Name? = nil,
//    performBlock: @escaping () -> ()
//) async {
//    await performInBackgroundContextAndMergeWithMainContext(
//        bgContext: bgContext,
//        mainContext: mainContext,
//        performBlock: performBlock,
//        didSaveHandler: {
//            if let notificationName {
//                post(notificationName)
//            }
//        }
//    )
//}
//
//public func performInBackgroundContextAndMergeWithMainContext(
//    bgContext: NSManagedObjectContext,
//    mainContext: NSManagedObjectContext,
//    performBlock: @escaping () throws -> (),
//    didSaveHandler: @escaping () -> (),
//    errorHandler: ((Error) -> ())? = nil
//) async {
//    await bgContext.perform {
//        
//        do {
//            try performBlock()
//        } catch {
//            errorHandler?(error)
//        }
//        
//        do {
//            let observer = NotificationCenter.default.addObserver(
//                forName: .NSManagedObjectContextDidSave,
//                object: bgContext,
//                queue: .main
//            ) { (notification) in
//                mainContext.mergeChanges(fromContextDidSave: notification)
//                didSaveHandler()
//            }
//            
//            try bgContext.performAndWait {
//                try bgContext.save()
//            }
//            NotificationCenter.default.removeObserver(observer)
//
//        } catch {
//            //TODO: Handle CoreData error here
//            errorHandler?(error)
//        }
//    }
//}
