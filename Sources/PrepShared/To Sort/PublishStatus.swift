import Foundation

public enum PublishStatus: Int, Codable {
    case hidden = 1
    
    case pendingReview
    case inReview
    case revoked
    
    case verified = 100
    
    case rejected = 200
}

extension PublishStatus {
    var title: String {
        switch self {
        case .hidden:           "Private"
        case .pendingReview:    "Submitted"
        case .inReview:         "In Review"
        case .revoked:          "Revoked"
        case .verified:         "Verified"
        case .rejected:         "Rejected"
        }
    }
    
    static var myFoodsCases: [PublishStatus] {
        [.pendingReview, .verified, .rejected]
    }
}
