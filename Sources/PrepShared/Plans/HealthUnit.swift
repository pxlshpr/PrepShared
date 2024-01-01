import SwiftUI

public protocol HealthUnit: Pickable {
    static var decimalPlaces: Int { get }
    static var secondaryUnit: String? { get }
    var hasTwoComponents: Bool { get }
    var abbreviation: String { get }
    func intComponent(_ value: Double, in other: any HealthUnit) -> Int?
    func doubleComponent(_ value: Double, in other: any HealthUnit) -> Double
}

public extension HealthUnit {
    static var decimalPlaces: Int { 1 }
    static var secondaryUnit: String? { nil }
    var hasTwoComponents: Bool { false }
    func intComponent(_ value: Double, in other: any HealthUnit) -> Int? { nil }
    func doubleComponent(_ value: Double, in other: any HealthUnit) -> Double { value }
}

extension EnergyUnit: HealthUnit {
    public static var decimalPlaces: Int { 0 }
}

extension HeightUnit: HealthUnit {
    public static var secondaryUnit: String? { "in" }
    public var hasTwoComponents: Bool { self == .ft }
}

extension BodyMassUnit: HealthUnit {
    public static var secondaryUnit: String? { "lb" }
    public var hasTwoComponents: Bool { self == .st }
}

extension NutrientUnit: HealthUnit {
        
}
