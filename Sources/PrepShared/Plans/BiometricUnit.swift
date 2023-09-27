import SwiftUI

public protocol BiometricUnit: Pickable {
    static var decimalPlaces: Int { get }
    static var secondaryUnit: String? { get }
    var hasTwoComponents: Bool { get }
    var abbreviation: String { get }
}

public extension BiometricUnit {
    static var decimalPlaces: Int { 1 }
    static var secondaryUnit: String? { nil }
    var hasTwoComponents: Bool { false }
}

extension EnergyUnit: BiometricUnit {
    public static var decimalPlaces: Int { 0 }
}

extension HeightUnit: BiometricUnit {
    public static var secondaryUnit: String? { "in" }
    public var hasTwoComponents: Bool { self == .ft }
}

extension BodyMassUnit: BiometricUnit {
    public static var secondaryUnit: String? { "lb" }
    public var hasTwoComponents: Bool { self == .st }
}

extension NutrientUnit: BiometricUnit {
        
}
