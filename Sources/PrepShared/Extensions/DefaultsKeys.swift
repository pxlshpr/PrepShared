import Foundation

public struct DefaultsKeys {
    
    public static func latestModificationDate(for recordType: RecordType) -> String {
        "latestModificationDate_\(recordType.name)"
    }
    
    public static let didCreateDatasetFoodsSubscription = "didCreateDatasetFoodsSubscription"

    public static let hasPendingUpdates = "hasPendingUpdates"
}

public enum DefaultKey: String {
    case hasPendingUpdates
}

public func setDefault(_ key: DefaultKey, _ value: Any?) {
    UserDefaults.standard.setValue(value, forKey: key.rawValue)
}
