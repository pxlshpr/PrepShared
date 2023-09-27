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
//        let id = UUID()
        do {
            
            try ContextPerformer(mainContext: mainContext) {
                continuation.resume()
            }
            .performInBackgroundContext(
                context,
                performBlock: performBlock
            )
            
//            try performInBackgroundContext(
//                context,
//                mainContext: mainContext,
//                performBlock: performBlock
//            ) {
//                continuation.resume()
//            }
        } catch {
            continuation.resume(throwing: error)
        }
    }
}

class ContextPerformer {
    
    let id = UUID()
    let mainContext: NSManagedObjectContext
    let completion: () -> ()
    
    init(
        mainContext: NSManagedObjectContext,
        completion: @escaping () -> ()
    ) {
        self.mainContext = mainContext
        self.completion = completion
    }
    
    func performInBackgroundContext(
        _ context: NSManagedObjectContext,
        performBlock: @escaping () throws -> ()
    ) throws {

        try context.performAndWait {
            try performBlock()
            
            NotificationCenter.default.addObserver(
                self,
                selector: #selector(didSave),
                name: .NSManagedObjectContextDidSave,
                object: context
            )
            
            try context.performAndWait {
                try context.save()
            }
        }
    }
    
    @objc func didSave(notification: Notification) {
        DispatchQueue.main.async {
            NotificationCenter.default.removeObserver(self)
            self.mainContext.mergeChanges(fromContextDidSave: notification)
            self.completion()
        }
    }
}

/// This was our legacy function that is now deprecated since there is an edge case where:
/// - `newBackgroundContext` might sometimes return an existing context (with the same pointer address), especially when invoked in quick succession
/// - this would result in the observer block sometimes being called more than once between the `.save()` and `.removeObserver(:)` calls (once for the actual call, the second time being for the call on the re-used context—since the notification is tied to the context itself).
/// - this isn't an issue on itself, but when using continuations above to invoke this asynchronously—we get an error where `completion()` being called multiple times causes the continuation also resume multiple times, which is an error in Swift.
/// - So we re-wrote this with the `ContextPerformer` class above, which uses a selector based notification scheme so that we're able to remove the observer before actually calling completion.
//func performInBackgroundContext(
//    _ context: NSManagedObjectContext,
//    mainContext: NSManagedObjectContext,
//    performBlock: @escaping () throws -> (),
//    completion: @escaping () -> ()
//) throws {
//
//    try context.performAndWait {
//        try performBlock()
//                
//        let observer = NotificationCenter.default.addObserver(
//            forName: .NSManagedObjectContextDidSave,
//            object: context,
//            queue: .main
//        ) { (notification) in
//            mainContext.mergeChanges(fromContextDidSave: notification)
//            completion()
//        }
//        
//        try context.performAndWait {
//            try context.save()
//        }
//        NotificationCenter.default.removeObserver(observer)
//    }
//}
