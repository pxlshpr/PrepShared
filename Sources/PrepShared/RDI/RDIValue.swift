public struct RDIValue: Hashable, Codable, Equatable {
    public var bound: GoalBound
    public var ageRange: GoalBound? = nil
    public var gender: BiometricSex? = nil
    public var isPregnant: Bool? = nil
    public var isLactating: Bool? = nil
    public var isSmoker: Bool? = nil
    
    public init(
        bound: GoalBound,
        ageRange: GoalBound? = nil,
        gender: BiometricSex? = nil,
        isPregnant: Bool? = nil,
        isLactating: Bool? = nil,
        isSmoker: Bool? = nil
    ) {
        self.bound = bound
        self.ageRange = ageRange
        self.gender = gender
        self.isPregnant = isPregnant
        self.isLactating = isLactating
        self.isSmoker = isSmoker
    }
}

public extension GoalBound {
    func contains(_ value: Double) -> Bool {
        switch (lower, upper) {
        case (.some(let lower), .some(let upper)):
            value >= lower && value < upper
        case (.some(let lower), nil):
            value >= lower
        case (nil, .some(let upper)):
            upper < upper
        case (.none, .none):
            false
        }
    }
}
