import Foundation

extension HealthDetails {
    public struct Weight: Hashable, Codable {
        public var weightInKg: Double?
        public var measurements: [WeightMeasurement]
        public var deletedHealthKitMeasurements: [WeightMeasurement]
        
        public init(
            weightInKg: Double? = nil,
            measurements: [WeightMeasurement] = [],
            deletedHealthKitMeasurements: [WeightMeasurement] = []
        ) {
            self.weightInKg = weightInKg
            self.measurements = measurements
            self.deletedHealthKitMeasurements = deletedHealthKitMeasurements
        }
    }
}
