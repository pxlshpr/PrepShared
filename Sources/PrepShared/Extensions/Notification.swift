import Foundation

public extension Notification.Name {
    static var didUpdateFood: Notification.Name { return .init("didUpdateFood") }
    static var didUpdateWord: Notification.Name { return .init("didUpdateWord") }
    static var didUpdateRDISource: Notification.Name { return .init("didUpdateRDISource") }
    static var didUpdateRDI: Notification.Name { return .init("didUpdateRDI") }
    static var networkDidBecomeOnline: Notification.Name { return .init("networkDidBecomeOnline") }
    
    /// UI Changes
    static var safeAreaDidChange: Notification.Name { return .init("safeAreaDidChange") }
    static var didTapToday: Notification.Name { return .init("didTapToday") }
    static var didTapAddFood: Notification.Name { return .init("didTapAddFood") }
    static var didTapMealItem: Notification.Name { return .init("didTapMealItem") }
    static var scrollItemFormToQuantity: Notification.Name { return .init("scrollItemFormToQuantity") }

    /// Backend Changes
    static var didPopulate: Notification.Name { return .init("didPopulate") }
    static var didUpdateDay: Notification.Name { return .init("didUpdateDay") }
}

//public extension Notification {
//    enum Keys: String {
//        case food = "food"
//    }
//}

public extension Notification {
    enum PrepKeys: String {
        case day = "day"
        case date = "date"
        case meal = "meal"
        case food = "food"
        case settings = "settings"
        case foodItem = "foodItem"
        case safeArea = "safeArea"
        case foodIDToRemove = "foodIDToRemove"

        case isCurrentHealth = "isCurrentHealth"
        case health = "health"
        case plan = "plan"
    }
}

public func post(_ name: Notification.Name, _ userInfo: [Notification.PrepKeys : Any]? = nil) {
    NotificationCenter.default.post(name: name, object: nil, userInfo: userInfo)
}

public extension Notification {
    func value(for key: Notification.PrepKeys) -> Any? {
        userInfo?[key]
    }
    
    var foodItem: FoodItem? {
        value(for: .foodItem) as? FoodItem
    }
    var foodIDToRemove: UUID? {
        value(for: .foodIDToRemove) as? UUID
    }
    
    var food: Food? {
        value(for: .food) as? Food
    }
    
    var isCurrentHealth: Bool? {
        value(for: .isCurrentHealth) as? Bool
    }    
}

//public func post(_ name: Notification.Name, _ userInfo: [Notification.Keys : Any]? = nil) {
//    NotificationCenter.default.post(name: name, object: nil, userInfo: userInfo)
//}
//
//public extension Notification {
//    func value(for key: Notification.Keys) -> Any? {
//        userInfo?[key]
//    }
//    
//    var food: Food? {
//        value(for: .food) as? Food
//    }
//}
