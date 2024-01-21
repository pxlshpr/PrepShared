import Foundation
import HealthKit

public struct WeightMeasurement: Hashable, Identifiable, Codable {
    public let id: UUID
    public let healthKitUUID: UUID?
    public let date: Date
    public let weightInKg: Double

    public init(
        id: UUID = UUID(),
        date: Date,
        weightInKg: Double,
        healthKitUUID: UUID? = nil
    ) {
        self.init(id: id, date: date, value: weightInKg, healthKitUUID: healthKitUUID)
    }

    public init(
        id: UUID = UUID(),
        date: Date,
        value: Double,
        healthKitUUID: UUID? = nil
    ) {
        self.id = id
        self.healthKitUUID = healthKitUUID
        self.date = date
        self.weightInKg = value
    }
}
