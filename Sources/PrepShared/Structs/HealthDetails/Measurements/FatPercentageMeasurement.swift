import Foundation
import HealthKit

public struct FatPercentageMeasurement: Hashable, Identifiable, Codable {
    public let id: UUID
    public let source: MeasurementSource
    public let healthKitUUID: UUID?
    public let equation: LeanBodyMassAndFatPercentageEquation?
    public let date: Date
    public var percent: Double
    public let isConvertedFromLeanBodyMass: Bool

    init(
        id: UUID,
        date: Date,
        value: Double,
        healthKitUUID: UUID?
    ) {
        self.id = id
        self.source = if healthKitUUID != nil {
            .healthKit
        } else {
            .manual
        }
        self.healthKitUUID = healthKitUUID
        self.equation = nil
        self.date = date
        self.percent = value
        self.isConvertedFromLeanBodyMass = false
    }
    
    init(
        id: UUID = UUID(),
        date: Date,
        percent: Double,
        source: MeasurementSource,
        healthKitUUID: UUID?,
        equation: LeanBodyMassAndFatPercentageEquation? = nil,
        isConvertedFromLeanBodyMass: Bool = false
    ) {
        self.id = id
        self.source = source
        self.date = date
        self.percent = percent
        self.equation = equation
        self.isConvertedFromLeanBodyMass = isConvertedFromLeanBodyMass
        self.healthKitUUID = healthKitUUID
    }
}
