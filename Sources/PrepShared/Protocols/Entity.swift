import Foundation
import CoreData

public protocol Entity: NSManagedObject, Fetchable { }

public extension Entity {
    static var entityName : String {
        return NSStringFromClass(self).components(separatedBy: ".").last!
    }
    static func countAll(in context: NSManagedObjectContext) -> Int {
        do {
            let request = NSFetchRequest<FetchableType>(entityName: entityName)
            return try context.count(for: request)
        } catch {
            fatalError()
        }
    }

    static func entities(
        predicateFormat: String,
        sortDescriptors: [NSSortDescriptor]? = nil,
        fetchLimit: Int? = nil,
        fetchOffset: Int? = nil,
        in context: NSManagedObjectContext
    ) -> [FetchableType] {
        entities(
            predicate: NSPredicate(format: predicateFormat),
            sortDescriptors: sortDescriptors,
            fetchLimit: fetchLimit,
            fetchOffset: fetchOffset,
            in: context
        )
    }
    
    static func entities(
        predicate: NSPredicate? = nil,
        sortDescriptors: [NSSortDescriptor]? = nil,
        fetchLimit: Int? = nil,
        fetchOffset: Int? = nil,
        in context: NSManagedObjectContext
    ) -> [FetchableType] {
        do {
            let request = NSFetchRequest<FetchableType>(entityName: entityName)
            request.predicate = predicate
            if let fetchLimit {
                request.fetchLimit = fetchLimit
            }
            if let sortDescriptors {
                request.sortDescriptors = sortDescriptors
            }
            if let fetchOffset {
                request.fetchOffset = fetchOffset
            }
            return try context.fetch(request)
        } catch {
            fatalError()
        }
    }
    
    static func entity(with id: UUID, in context: NSManagedObjectContext) -> FetchableType? {
        do {
            let request = NSFetchRequest<FetchableType>(entityName: entityName)
//            request.predicate = NSPredicate(format: "id == %@", id.uuidString)
            request.predicate = NSPredicate(format: "id == '\(id)'")
            let objects = try context.fetch(request)
            return objects.first
        } catch {
            fatalError()
        }
    }
}
