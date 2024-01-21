public struct RDIParams {
    public var age: Double? = nil
    public var sex: BiologicalSex? = nil
    public var pregnancyStatus: PregnancyStatus? = nil
    public var isSmoker: Bool? = nil
    
    public init(
        age: Double? = nil,
        sex: BiologicalSex? = nil,
        pregnancyStatus: PregnancyStatus? = nil,
        isSmoker: Bool? = nil
    ) {
        self.age = age
        self.sex = sex
        self.pregnancyStatus = pregnancyStatus
        self.isSmoker = isSmoker
    }
}
