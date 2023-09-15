//import Foundation
//import CoreData
//
//@objc(FoodEntity)
//public final class FoodEntity: NSManagedObject, Identifiable { }
//
//extension FoodEntity {
//
//    @nonobjc public class func fetchRequest() -> NSFetchRequest<FoodEntity> {
//        return NSFetchRequest<FoodEntity>(entityName: "FoodEntity")
//    }
//
//    @NSManaged public var amountData: Data?
//    @NSManaged public var barcodesString: String?
//    @NSManaged public var brand: String?
//    @NSManaged public var carb: Double
//    @NSManaged public var createdAt: Date?
//    @NSManaged public var datasetID: String?
//    @NSManaged public var datasetValue: Int16
//    @NSManaged public var densityData: Data?
//    @NSManaged public var detail: String?
//    @NSManaged public var emoji: String?
//    @NSManaged public var energy: Double
//    @NSManaged public var energyUnitValue: Int16
//    @NSManaged public var fat: Double
//    @NSManaged public var id: UUID?
//    @NSManaged public var imageIDsData: Data?
//    @NSManaged public var isPendingNotification: Bool
//    @NSManaged public var isTrashed: Bool
//    @NSManaged public var lastAmountData: Data?
//    @NSManaged public var lastUsedAt: Date?
//    @NSManaged public var microsData: Data?
//    @NSManaged public var name: String?
//    @NSManaged public var ownerID: String?
//    @NSManaged public var previewAmountData: Data?
//    @NSManaged public var protein: Double
//    @NSManaged public var publishStatusValue: Int16
//    @NSManaged public var searchTokensString: String?
//    @NSManaged public var servingData: Data?
//    @NSManaged public var sizesData: Data?
//    @NSManaged public var typeValue: Int16
//    @NSManaged public var updatedAt: Date?
//    @NSManaged public var url: String?
//    @NSManaged public var asIngredientItemEntities: NSSet?
//    @NSManaged public var ingredientItemEntities: NSSet?
//    @NSManaged public var mealItemEntities: NSSet?
//    @NSManaged public var newVersion: FoodEntity?
//    @NSManaged public var oldVersion: FoodEntity?
//}
