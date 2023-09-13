import Foundation

public struct DefaultsKeys {
    
    public static func latestModificationDate(for recordType: RecordType) -> String {
        "latestModificationDate_\(recordType.name)"
    }
}

public enum DefaultKey: String {
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
