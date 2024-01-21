import Foundation

extension HealthDetails {
    public struct Height: Hashable, Codable {
        public var heightInCm: Double?
        public var measurements: [HeightMeasurement]
        public var deletedHealthKitMeasurements: [HeightMeasurement]
        
        public init(
            heightInCm: Double? = nil,
            measurements: [HeightMeasurement] = [],
            deletedHealthKitMeasurements: [HeightMeasurement] = []
        ) {
            self.heightInCm = heightInCm
            self.measurements = measurements
            self.deletedHealthKitMeasurements = deletedHealthKitMeasurements
        }
    }
}
