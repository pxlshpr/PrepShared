import CoreData

public protocol Store {
    static var shared: Self { get }
    static var mainContext: NSManagedObjectContext { get }
}

extension Store {
    public static func perform(
        in context: NSManagedObjectContext,
        _ block: @escaping () -> ()
    ) async throws {
        try await shared.perform(in: context, block)
    }

    /// Performs the `block` of code in the provided `context` and then merges the changes with the `viewContext` on the main thread
    func perform(
        in context: NSManagedObjectContext,
        _ block: @escaping () -> ()
    ) async throws {
        try await context.performAndMergeWith(Self.mainContext, block)
    }
}
