import Foundation

public struct DefaultsKeys {
    
    public static func latestModificationDate(for recordType: RecordType) -> String {
        "latestModificationDate_\(recordType.name)"
    }
    public static let didCreateDatasetFoodsSubscription = "didCreateDatasetFoodsSubscription"
}

//public func setLatestModificationDate(_ date: Date, for recordType: RecordType) {
//    setLatestModificationDate(date.timeIntervalSince1970, for: recordType)
//}

//public func setLatestModificationDate(_ unixTime: Double, for recordType: RecordType) {
//    UserDefaults.standard.setValue(unixTime, forKey: DefaultsKeys.latestModificationDate(for: recordType))
//}

//public func hasLatestModificationDate(for recordType: RecordType) -> Bool {
//    latestModificationDate(for: recordType) != nil
//}

//public func latestModificationDate(for recordType: RecordType) -> Date? {
//    let timeInterval = UserDefaults.standard.double(forKey: DefaultsKeys.latestModificationDate(for: recordType))
//    guard timeInterval != 0 else { return nil }
//    return Date(timeIntervalSince1970: timeInterval)
//}
