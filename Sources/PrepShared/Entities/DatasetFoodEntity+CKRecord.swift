import Foundation
import CoreData
import CloudKit

public extension DatasetFoodEntity {
    
    static var recordType: RecordType { .datasetFood }
    static var notificationName: Notification.Name { .didUpdateFood }

    static func entity(matching record: CKRecord, in context: NSManagedObjectContext) -> DatasetFoodEntity? {
        entity(in: context, with: record.id!)
    }
    
    func fill(with record: CKRecord) {

        id = record.id!

        name = record.name!
        emoji = record.emoji!
        detail = record.detail
        brand = record.brand

        amount = record.amount!
        serving = record.serving
        previewAmount = record.previewAmount

        energy = record.energy!
        energyUnit = record.energyUnit!
        carb = record.carb!
        fat = record.fat!
        protein = record.protein!

        micros = record.micros!
        sizes = record.sizes!
        density = record.density
        type = record.type ?? .food

        datasetID = record.datasetID
        dataset = record.dataset!

        barcodes = record.barcodes
        searchTokens = record.searchTokens

        updatedAt = record.updatedAt!
        createdAt = record.createdAt!
        isTrashed = record.isTrashed ?? false
    }
    
    func update(record: CKRecord, in context: NSManagedObjectContext) async throws {
        /// Make sure the `id` of the `CKRecord` never changes
        record[.name] = name! as CKRecordValue
        record[.emoji] = emoji! as CKRecordValue
        if let detail {
            record[.detail] = detail as CKRecordValue
        } else {
            record[.detail] = nil
        }
        if let brand {
            record[.brand] = brand as CKRecordValue
        } else {
            record[.brand] = nil
        }
        if let searchTokensString {
            record[.searchTokensString] = searchTokensString as CKRecordValue
        } else {
            record[.searchTokensString] = nil
        }
        
        /// Fields to be added here as required
        
        /// This was added in to allow fixing units for micros (namely Vitamin K2)
        if let microsData {
            record[.microsData] = microsData as CKRecordValue
        } else {
            record[.microsData] = nil
        }
        
        record[.isTrashed] = isTrashed as CKRecordValue
        record[.updatedAt] = updatedAt! as CKRecordValue
    }
}

//public extension CKRecord {
//    func update(withDatasetFoodEntity entity: DatasetFoodEntity) {
//        /// Make sure the `id` of the `CKRecord` never changes
//        self[.name] = entity.name! as CKRecordValue
//        self[.emoji] = entity.emoji! as CKRecordValue
//        if let detail = entity.detail {
//            self[.detail] = detail as CKRecordValue
//        } else {
//            self[.detail] = nil
//        }
//        if let brand = entity.brand {
//            self[.brand] = brand as CKRecordValue
//        } else {
//            self[.brand] = nil
//        }
//        if let searchTokensString = entity.searchTokensString {
//            self[.searchTokensString] = searchTokensString as CKRecordValue
//        } else {
//            self[.searchTokensString] = nil
//        }
//        self[.isTrashed] = entity.isTrashed as CKRecordValue
//        self[.updatedAt] = entity.updatedAt! as CKRecordValue
//    }
//}
