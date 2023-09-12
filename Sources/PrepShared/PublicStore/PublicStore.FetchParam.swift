import Foundation
import CloudKit

public extension PublicStore {
    struct FetchParam {
        let type: any PublicEntity.Type
        let recordType: RecordType
        let presetModificationDate: Date?
        let desiredKeys: [CKRecord.FieldKey]?
        
        public init?(
            recordType: RecordType,
            presetModificationDate: Date? = nil,
            desiredKeys: [CKRecord.FieldKey]? = nil
        ) {
            guard let type = recordType.publicEntityType else { return nil }
            self.type = type
            self.recordType = recordType
            self.presetModificationDate = presetModificationDate
            self.desiredKeys = desiredKeys
        }
    }
}

public extension PublicStore.FetchParam {
    var name: String {
        String(describing: type)
    }
}
