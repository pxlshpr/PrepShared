import Foundation

public protocol Pickable: Hashable, CaseIterable {
    var pickedTitle: String { get }
    var pluralPickedTitle: String { get }

    var menuTitle: String { get }
    var pluralMenuTitle: String { get }
    
    var menuImage: String { get }
    
    var detail: String? { get }
    
    var description: String? { get }
    static var `default`: Self { get }
    
    /// An optional option that is identified as "None", which would be placed in its own section
    static var noneOption: Self? { get }
}

public extension Pickable {
    var detail: String? { nil }
    var description: String? { nil }
    var menuImage: String { "" }
    var pluralMenuTitle: String { menuTitle }
    var pluralPickedTitle: String { pickedTitle }
    static var noneOption: Self? { nil }
}

//MARK: - Extensions

extension EnergyGoalDelta: Pickable {
    public var pickedTitle: String { name }
    public var menuTitle: String { name }
    public static var `default`: EnergyGoalDelta { .deficit }
}

extension NutrientUnit: Pickable {
    public var pickedTitle: String { abbreviation }
    public var menuTitle: String { abbreviation }
    public static var `default`: NutrientUnit { .g }
}

extension BodyMassType: Pickable {
    public var pickedTitle: String { name }
    public var menuTitle: String { name }
    public static var `default`: BodyMassType { .weight }
}

extension BodyMassUnit: Pickable {
    public var pickedTitle: String { abbreviation }
    public var menuTitle: String { abbreviation }
    public static var `default`: BodyMassUnit { .kg }
}

extension EnergyUnit: Pickable {
    public var pickedTitle: String { abbreviation }
    public var menuTitle: String { abbreviation }
    public static var `default`: EnergyUnit { .kcal }
}

extension VolumeUnit: Pickable {
    public var pickedTitle: String { explicitName }
    public var menuTitle: String { "\(explicitName) • \(equivalentMilliliters) mL" }
    public static var `default`: VolumeUnit { .mL }
}
