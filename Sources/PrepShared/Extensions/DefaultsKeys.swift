import Foundation

public struct DefaultsKeys {
    
    public static func latestModificationDate(for recordType: RecordType) -> String {
        "latestModificationDate_\(recordType.name)"
    }
    
//    public static let didCreateDatasetFoodsSubscription = "didCreateDatasetFoodsSubscription"

//    public static let hasPendingUpdates = "hasPendingUpdates"
}

public enum DefaultKey: String {
//    case hasPendingUpdates
    case didCreateDatasetFoodsSubscription
}

public struct Defaults {
    public static func set(_ key: DefaultKey, _ value: Any?) {
        UserDefaults.standard.setValue(value, forKey: key.rawValue)
    }

    public static func bool(_ key: DefaultKey) -> Bool {
        UserDefaults.standard.bool(forKey: key.rawValue)
    }
}
