import Foundation

extension HealthDetails {
    public struct FatPercentage: Hashable, Codable {
        public var fatPercentage: Double? = nil
        public var measurements: [FatPercentageMeasurement]
        public var deletedHealthKitMeasurements: [FatPercentageMeasurement]
        
        public init(
            fatPercentage: Double? = nil,
            measurements: [FatPercentageMeasurement] = [],
            deletedHealthKitMeasurements: [FatPercentageMeasurement] = []
        ) {
            self.fatPercentage = fatPercentage
            self.measurements = measurements
            self.deletedHealthKitMeasurements = deletedHealthKitMeasurements
        }
    }
}
