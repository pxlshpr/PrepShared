import Foundation
import CloudKit

public extension PublicStore {
    enum SyncDirection {
        case both
        case downloadOnly
        case uploadOnly
        
        var shouldDownload: Bool {
            switch self {
            case .both, .downloadOnly:  true
            default:                    false
            }
        }

        var shouldUpload: Bool {
            switch self {
            case .both, .uploadOnly:    true
            default:                    false
            }
        }
    }
    
    struct SyncEntity {
        let type: any PublicEntity.Type
        let direction: SyncDirection
        let recordType: RecordType
        let presetModificationDate: Date?
        let desiredKeys: [CKRecord.FieldKey]?
        
        public init?(
            recordType: RecordType,
            direction: SyncDirection = .both,
            presetModificationDate: Date? = nil,
            desiredKeys: [CKRecord.FieldKey]? = nil
        ) {
            guard let type = recordType.publicEntityType else { return nil }
            self.type = type
            self.direction = direction
            self.recordType = recordType
            self.presetModificationDate = presetModificationDate
            self.desiredKeys = desiredKeys
        }
    }
}
