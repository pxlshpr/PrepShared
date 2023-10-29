public struct RDIParams {
    public var age: Double? = nil
    public var gender: BiometricSex? = nil
    public var isPregnant: Bool? = nil
    public var isLactating: Bool? = nil
    public var isSmoker: Bool? = nil
    
    public init(
        age: Double? = nil,
        gender: BiometricSex? = nil,
        isPregnant: Bool? = nil,
        isLactating: Bool? = nil,
        isSmoker: Bool? = nil
    ) {
        self.age = age
        self.gender = gender
        self.isPregnant = isPregnant
        self.isLactating = isLactating
        self.isSmoker = isSmoker
    }
}
