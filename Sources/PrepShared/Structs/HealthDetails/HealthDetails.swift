import Foundation

public typealias DatedHealthData = (date: Date, data: Any)

public struct HealthDetails: Hashable, Codable {
    
    public let date: Date
    
    public var maintenance: Maintenance
    
    public var weight: Weight
    public var height: Height
    public var leanBodyMass: LeanBodyMass
    public var fatPercentage: FatPercentage
    public var pregnancyStatus: PregnancyStatus
    
    public var dateOfBirthComponents: DateComponents?
    public var biologicalSex: BiologicalSex
    public var smokingStatus: SmokingStatus
    
    public var replacementsForMissing: ReplacementsForMissing
    
    public init(
        date: Date,
        maintenance: Maintenance = Maintenance(),
        weight: Weight = Weight(),
        height: Height = Height(),
        leanBodyMass: LeanBodyMass = LeanBodyMass(),
        fatPercentage: FatPercentage = FatPercentage(),
        pregnancyStatus: PregnancyStatus = .notSet,
        dateOfBirthComponents: DateComponents? = nil,
        biologicalSex: BiologicalSex = .notSet,
        smokingStatus: SmokingStatus = .notSet,
        replacementsForMissing: ReplacementsForMissing = ReplacementsForMissing()
    ) {
        self.date = date
        self.maintenance = maintenance
        self.weight = weight
        self.height = height
        self.leanBodyMass = leanBodyMass
        self.fatPercentage = fatPercentage
        self.pregnancyStatus = pregnancyStatus
        self.dateOfBirthComponents = dateOfBirthComponents
        self.biologicalSex = biologicalSex
        self.smokingStatus = smokingStatus
        self.replacementsForMissing = replacementsForMissing
    }
}

extension HealthDetails {
    public struct ReplacementsForMissing: Hashable, Codable {
        public var datedWeight: DatedWeight?
        public var datedHeight: DatedHeight?
        public var datedLeanBodyMass: DatedLeanBodyMass?
        public var datedFatPercentage: DatedFatPercentage?
        public var datedPregnancyStatus: DatedPregnancyStatus?
        public var datedMaintenance: DatedMaintenance?
        
        public init(
            datedWeight: DatedWeight? = nil,
            datedHeight: DatedHeight? = nil,
            datedLeanBodyMass: DatedLeanBodyMass? = nil,
            datedFatPercentage: DatedFatPercentage? = nil,
            datedPregnancyStatus: DatedPregnancyStatus? = nil,
            datedMaintenance: DatedMaintenance? = nil
        ) {
            self.datedWeight = datedWeight
            self.datedHeight = datedHeight
            self.datedLeanBodyMass = datedLeanBodyMass
            self.datedFatPercentage = datedFatPercentage
            self.datedPregnancyStatus = datedPregnancyStatus
            self.datedMaintenance = datedMaintenance
        }
    }
}

public extension HealthDetails.ReplacementsForMissing {
    func has(_ healthDetail: HealthDetail) -> Bool {
        switch healthDetail {
        case .weight:           datedWeight != nil
        case .height:           datedHeight != nil
        case .leanBodyMass:     datedLeanBodyMass != nil
        case .preganancyStatus: datedPregnancyStatus != nil
        case .fatPercentage:    datedFatPercentage != nil
        case .maintenance:      datedMaintenance != nil
        default:                false
        }
    }
}

public struct DatedWeight: Hashable, Codable {
    public let date: Date
    public var weight: HealthDetails.Weight
    
    public init(date: Date, weight: HealthDetails.Weight) {
        self.date = date
        self.weight = weight
    }
}

public struct DatedMaintenance: Hashable, Codable {
    public let date: Date
    public var maintenance: HealthDetails.Maintenance
    
    public init(date: Date, maintenance: HealthDetails.Maintenance) {
        self.date = date
        self.maintenance = maintenance
    }
}

public struct DatedHeight: Hashable, Codable {
    public let date: Date
    public var height: HealthDetails.Height
    
    public init(date: Date, height: HealthDetails.Height) {
        self.date = date
        self.height = height
    }
}

public struct DatedLeanBodyMass: Hashable, Codable {
    public let date: Date
    public var leanBodyMass: HealthDetails.LeanBodyMass
    
    public init(date: Date, leanBodyMass: HealthDetails.LeanBodyMass) {
        self.date = date
        self.leanBodyMass = leanBodyMass
    }
}

public struct DatedFatPercentage: Hashable, Codable {
    public let date: Date
    public var fatPercentage: HealthDetails.FatPercentage
    
    public init(date: Date, fatPercentage: HealthDetails.FatPercentage) {
        self.date = date
        self.fatPercentage = fatPercentage
    }
}

public struct DatedPregnancyStatus: Hashable, Codable {
    public let date: Date
    public var pregnancyStatus: PregnancyStatus

    public init(date: Date, pregnancyStatus: PregnancyStatus) {
        self.date = date
        self.pregnancyStatus = pregnancyStatus
    }
}

public extension Dictionary where Key == HealthDetail, Value == DatedHealthData {
    var datedWeight: DatedWeight? {
        guard let tuple = self[HealthDetail.weight],
              let weight = tuple.data as? HealthDetails.Weight
        else { return nil }
        return .init(date: tuple.date, weight: weight)
    }
    var weight: HealthDetails.Weight? {
        get { datedWeight?.weight }
        set {
            guard let newValue, let datedWeight else {
                self[HealthDetail.weight] = nil
                return
            }
            self[HealthDetail.weight] = (datedWeight.date, newValue)
        }
    }
    
    var datedLeanBodyMass: DatedLeanBodyMass? {
        guard let tuple = self[HealthDetail.leanBodyMass],
              let leanBodyMass = tuple.data as? HealthDetails.LeanBodyMass
        else { return nil }
        return .init(date: tuple.date, leanBodyMass: leanBodyMass)
    }
    var leanBodyMass: HealthDetails.LeanBodyMass? {
        get { datedLeanBodyMass?.leanBodyMass }
        set {
            guard let newValue, let datedLeanBodyMass else {
                self[HealthDetail.leanBodyMass] = nil
                return
            }
            self[HealthDetail.leanBodyMass] = (datedLeanBodyMass.date, newValue)
        }
    }
    
    var datedPregnancyStatus: DatedPregnancyStatus? {
        guard let tuple = self[HealthDetail.preganancyStatus],
              let pregnancyStatus = tuple.data as? PregnancyStatus
        else { return nil }
        return .init(date: tuple.date, pregnancyStatus: pregnancyStatus)
    }
    var pregnancyStatus: PregnancyStatus? {
        get { datedPregnancyStatus?.pregnancyStatus }
        set {
            guard let newValue, let datedPregnancyStatus else {
                self[HealthDetail.preganancyStatus] = nil
                return
            }
            self[HealthDetail.preganancyStatus] = (datedPregnancyStatus.date, newValue)
        }
    }
    
    var datedHeight: DatedHeight? {
        guard let tuple = self[HealthDetail.height],
              let height = tuple.data as? HealthDetails.Height
        else { return nil }
        return .init(date: tuple.date, height: height)
    }
    var height: HealthDetails.Height? {
        get { datedHeight?.height }
        set {
            guard let newValue, let datedHeight else {
                self[HealthDetail.height] = nil
                return
            }
            self[HealthDetail.height] = (datedHeight.date, newValue)
        }
    }
    
    var datedFatPercentage: DatedFatPercentage? {
        guard let tuple = self[HealthDetail.fatPercentage],
              let fatPercentage = tuple.data as? HealthDetails.FatPercentage
        else { return nil }
        return .init(date: tuple.date, fatPercentage: fatPercentage)
    }
    var fatPercentage: HealthDetails.FatPercentage? {
        get { datedFatPercentage?.fatPercentage }
        set {
            guard let newValue, let datedFatPercentage else {
                self[HealthDetail.fatPercentage] = nil
                return
            }
            self[HealthDetail.fatPercentage] = (datedFatPercentage.date, newValue)
        }
    }
    
    var datedMaintenance: DatedMaintenance? {
        guard let tuple = self[HealthDetail.maintenance],
              let maintenance = tuple.data as? HealthDetails.Maintenance
        else { return nil }
        return .init(date: tuple.date, maintenance: maintenance)
    }
    var maintenance: HealthDetails.Maintenance? {
        get { datedMaintenance?.maintenance }
        set {
            guard let newValue, let datedMaintenance else {
                self[HealthDetail.maintenance] = nil
                return
            }
            self[HealthDetail.maintenance] = (datedMaintenance.date, newValue)
        }
    }
    
    var dateOfBirthComponents: DateComponents? {
        self[HealthDetail.age]?.data as? DateComponents
    }
    
    var biologicalSex: BiologicalSex? {
        self[HealthDetail.biologicalSex]?.data as? BiologicalSex
    }
    
    var smokingStatus: SmokingStatus? {
        self[HealthDetail.smokingStatus]?.data as? SmokingStatus
    }
}
