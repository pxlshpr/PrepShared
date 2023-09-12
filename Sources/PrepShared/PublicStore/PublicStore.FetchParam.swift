import Foundation
import CloudKit

public extension PublicStore {
    struct FetchParam {
        let type: any PublicEntity.Type
        let desiredKeys: [CKRecord.FieldKey]?
        
        public init(type: any PublicEntity.Type, desiredKeys: [CKRecord.FieldKey]? = nil) {
            self.type = type
            self.desiredKeys = desiredKeys
        }
    }
}
