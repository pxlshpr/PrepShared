import Foundation

public enum RecordType {
    case subscriptionCredits
    case verifiedFood
    case datasetFood
    case searchWord
}

public extension RecordType {
    var name: String {
        switch self {
        case .subscriptionCredits:  "SubscriptionCredits"
        case .verifiedFood:         "VerifiedFood"
        case .datasetFood:          "DatasetFood"
        case .searchWord:           "SearchWord"
        }
    }
    
    var publicEntityType: (any PublicEntity.Type)? {
        switch self {
        case .subscriptionCredits:  nil
        case .verifiedFood:         VerifiedFoodEntity.self
        case .datasetFood:          DatasetFoodEntity.self
        case .searchWord:           SearchWordEntity.self
        }
    }
}

public extension RecordType {
    
    var latestModificationDate: Date? {
        let timeInterval = UserDefaults.standard.double(forKey: DefaultsKeys.latestModificationDate(for: self))
        guard timeInterval != 0 else { return nil }
        return Date(timeIntervalSince1970: timeInterval)
    }
    
    func setLatestModificationDate(_ unixTime: Double) {
        UserDefaults.standard.setValue(
            unixTime,
            forKey: DefaultsKeys.latestModificationDate(for: self)
        )
    }

    func setLatestModificationDate(_ date: Date) {
        setLatestModificationDate(date.timeIntervalSince1970)
    }
    
    func setPresetModificationDateIfNeeded(_ date: Date) {
        if latestModificationDate == nil {
            setLatestModificationDate(date)
        }
    }
}
