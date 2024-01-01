import SwiftUI

public protocol HealthUnit: Pickable {
    static var decimalPlaces: Int { get }
    static var secondaryUnit: String? { get }
    var hasTwoComponents: Bool { get }
    var abbreviation: String { get }
    func intComponent(_ value: Double, in other: Self) -> Int?
    func doubleComponent(_ value: Double, in other: Self) -> Double
}

public extension HealthUnit {
    static var decimalPlaces: Int { 1 }
    static var secondaryUnit: String? { nil }
    var hasTwoComponents: Bool { false }
}

extension EnergyUnit: HealthUnit {
    public static var decimalPlaces: Int { 0 }
    public func intComponent(_ value: Double, in other: Self) -> Int? { nil }
    public func doubleComponent(_ value: Double, in other: Self) -> Double { value }
}

//extension HeightUnit: HealthUnit {
//    public static var secondaryUnit: String? { "in" }
//    public var hasTwoComponents: Bool { self == .ft }
//}
//
//extension BodyMassUnit: HealthUnit {
//    public static var secondaryUnit: String? { "lb" }
//    public var hasTwoComponents: Bool { self == .st }
//}

extension NutrientUnit: HealthUnit {
    public func intComponent(_ value: Double, in other: Self) -> Int? { nil }
    public func doubleComponent(_ value: Double, in other: Self) -> Double { value }
}
