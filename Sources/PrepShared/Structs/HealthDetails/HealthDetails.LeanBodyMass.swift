import Foundation

extension HealthDetails {
    public struct LeanBodyMass: Hashable, Codable {
        public var leanBodyMassInKg: Double? = nil
        public var measurements: [LeanBodyMassMeasurement]
        public var deletedHealthKitMeasurements: [LeanBodyMassMeasurement]
        
        public init(
            leanBodyMassInKg: Double? = nil,
            measurements: [LeanBodyMassMeasurement] = [],
            deletedHealthKitMeasurements: [LeanBodyMassMeasurement] = []
        ) {
            self.leanBodyMassInKg = leanBodyMassInKg
            self.measurements = measurements
            self.deletedHealthKitMeasurements = deletedHealthKitMeasurements
        }
    }
}
