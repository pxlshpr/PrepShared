import SwiftUI

public protocol HealthUnit: Pickable {
    static var decimalPlaces: Int { get }
    static var secondaryUnit: String? { get }
    var hasTwoComponents: Bool { get }
    var abbreviation: String { get }
    func intComponent(_ value: Double, in other: Self) -> Int?
    func doubleComponent(_ value: Double, in other: Self) -> Double
    
    var intUnitString: String? { get }
    var doubleUnitString: String  { get }
    
    static var upperSecondaryUnitValue: Double? { get }
    
    func convert(_ value: Double, to other: Self) -> Double
}

public extension HealthUnit {
    static var decimalPlaces: Int { 1 }
    static var secondaryUnit: String? { nil }
    var hasTwoComponents: Bool { false }
    static var upperSecondaryUnitValue: Double? { nil }
}

public extension HealthUnit {
    func convert(_ int: Int, _ double: Double, to other: Self) -> Double {
        let value = if self.hasTwoComponents, let upper = Self.upperSecondaryUnitValue {
            Double(int) + (double / upper)
        } else {
            double
        }
        return self.convert(value, to: other)
    }
}

extension EnergyUnit: HealthUnit {
    public static var decimalPlaces: Int { 0 }
    public func intComponent(_ value: Double, in other: Self) -> Int? { nil }
    public func doubleComponent(_ value: Double, in other: Self) -> Double { value }
    public var intUnitString: String? { nil }
    public var doubleUnitString: String  { self.abbreviation }
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
    public var intUnitString: String? { nil }
    public var doubleUnitString: String  { self.abbreviation }
}
