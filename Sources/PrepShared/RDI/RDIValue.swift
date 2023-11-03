public struct RDIValue: Hashable, Codable, Equatable {
    public var bound: GoalBound
    public var ageRange: GoalBound? = nil
    public var gender: BiometricSex? = nil
    public var pregnancyStatus: PregnancyStatus? = nil
    public var isSmoker: Bool? = nil
    
    public init(
        bound: GoalBound,
        ageRange: GoalBound? = nil,
        gender: BiometricSex? = nil,
        pregnancyStatus: PregnancyStatus? = nil,
        isSmoker: Bool? = nil
    ) {
        self.bound = bound
        self.ageRange = ageRange
        self.gender = gender
        self.pregnancyStatus = pregnancyStatus
        self.isSmoker = isSmoker
    }
}
