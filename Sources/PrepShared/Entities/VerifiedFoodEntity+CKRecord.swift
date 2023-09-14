import Foundation
import CoreData
import CloudKit

public extension VerifiedFoodEntity {
    
    static var recordType: RecordType { .verifiedFood }
    static var notificationName: Notification.Name { .didUpdateFood }

    static func entity(matching record: CKRecord, in context: NSManagedObjectContext) -> VerifiedFoodEntity? {
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
        type = record.type!

//        datasetID = record.datasetID
//        dataset = record.dataset

        barcodes = record.barcodes
        searchTokens = record.searchTokens

        updatedAt = record.updatedAt!
        createdAt = record.createdAt!
        isTrashed = record.isTrashed ?? false

        url = record.url
        publishStatus = record.publishStatus
        ownerID = record.ownerID
        
        reviewerID = record.reviewerID
        rejectionReasons = record.rejectionReasons
        rejectionNotes = record.rejectionNotes
        
        if let url = (record["image1"] as? CKAsset)?.fileURL {
            image1 = try! Data(contentsOf: url)
        }
        if let url = (record["image2"] as? CKAsset)?.fileURL {
            image2 = try! Data(contentsOf: url)
        }
        if let url = (record["image3"] as? CKAsset)?.fileURL {
            image3 = try! Data(contentsOf: url)
        }
        if let url = (record["image4"] as? CKAsset)?.fileURL {
            image4 = try! Data(contentsOf: url)
        }
        if let url = (record["image5"] as? CKAsset)?.fileURL {
            image5 = try! Data(contentsOf: url)
        }
    }
    
    func update(record: CKRecord, in context: NSManagedObjectContext) async throws {
        record[.isTrashed] = isTrashed as CKRecordValue
        record[.publishStatusValue] = publishStatusValue as CKRecordValue
        record[.rejectionReasonsData] = rejectionReasonsData as? CKRecordValue
        record[.rejectionNotes] = rejectionNotes as? CKRecordValue
        record[.reviewerID] = reviewerID as? CKRecordValue
        record[.searchTokensString] = searchTokensString as? CKRecordValue
        record[.updatedAt] = Date.now as CKRecordValue
    }
    
    var asCKRecord: CKRecord {
        
        let record = CKRecord(recordType: Self.recordType.name)

        if let id { record[.id] = id.uuidString as CKRecordValue }
        if let name { record[.name] = name as CKRecordValue }
        if let detail { record[.detail] = detail as CKRecordValue }
        if let brand { record[.brand] = brand as CKRecordValue }
        if let emoji { record[.emoji] = emoji as CKRecordValue }

        record[.energy] = energy as CKRecordValue
        record[.energyUnitValue] = energyUnitValue as CKRecordValue
        record[.carb] = carb as CKRecordValue
        record[.fat] = fat as CKRecordValue
        record[.protein] = protein as CKRecordValue
        if let microsData { record[.microsData] = microsData as CKRecordValue }
        if let amountData { record[.amountData] = amountData as CKRecordValue }
        if let servingData { record[.servingData] = servingData as CKRecordValue }
        if let densityData { record[.densityData] = densityData as CKRecordValue }
        if let previewAmountData { record[.previewAmountData] = previewAmountData as CKRecordValue }
        if let sizesData { record[.sizesData] = sizesData as CKRecordValue }
        
        if let barcodesString { record[.barcodesString] = barcodesString as CKRecordValue }
        if let searchTokensString { record[.searchTokensString] = searchTokensString as CKRecordValue }

        if let createdAt { record[.createdAt] = createdAt as CKRecordValue }
        if let updatedAt { record[.updatedAt] = updatedAt as CKRecordValue }
        record[.isTrashed] = isTrashed as CKRecordValue

        record[.typeValue] = typeValue as CKRecordValue
        if let url { record[.url] = url as CKRecordValue }
        if let ownerID { record[.ownerID] = ownerID as CKRecordValue }
        record[.publishStatusValue] = publishStatusValue as CKRecordValue

        /// Fetch each image and attach it to the record
        for index in imageIDs.indices {
            let imageID = imageIDs[index]
            guard ImageManager.imageExists(imageID) else { continue }
            let imageURL = ImageManager.url(for: imageID)
            let asset = CKAsset(fileURL: imageURL)
            record["image\(index+1)"] = asset
        }

        return record
    }
}

