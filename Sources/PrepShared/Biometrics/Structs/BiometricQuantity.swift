import Foundation

public struct BiometricQuantity: Hashable, Codable {
    public var source: BiometricSource
    public var quantity: Quantity?
}

public extension BiometricQuantity {
    
    mutating func removeDateIfNotNeeded() {
        switch source {
        case .health:       break
        case .userEntered:  quantity?.date = nil
        }
    }
}
