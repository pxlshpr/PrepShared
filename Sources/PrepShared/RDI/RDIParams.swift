public struct RDIParams {
    public var age: Double? = nil
    public var gender: BiometricSex? = nil
    public var pregnancyStatus: PregnancyStatus? = nil
    public var isSmoker: Bool? = nil
    
    public init(
        age: Double? = nil,
        gender: BiometricSex? = nil,
        pregnancyStatus: PregnancyStatus? = nil,
        isSmoker: Bool? = nil
    ) {
        self.age = age
        self.gender = gender
        self.pregnancyStatus = pregnancyStatus
        self.isSmoker = isSmoker
    }
}
