public struct RDIValue: Hashable, Codable, Equatable {
    public var bound: Bound
    public var ageRange: Bound? = nil
    public var sex: BiometricSex? = nil
    public var pregnancyStatus: PregnancyStatus? = nil
    public var isSmoker: Bool? = nil
    
    public init(
        bound: Bound,
        ageRange: Bound? = nil,
        sex: BiometricSex? = nil,
        pregnancyStatus: PregnancyStatus? = nil,
        isSmoker: Bool? = nil
    ) {
        self.bound = bound
        self.ageRange = ageRange
        self.sex = sex
        self.pregnancyStatus = pregnancyStatus
        self.isSmoker = isSmoker
    }
}
