import Foundation

public struct HealthKitFetchSettings: Hashable, Codable {
    public var intervalType: HealthIntervalType
    public var interval: HealthInterval
    public var correction: Correction?

    public init(
        intervalType: HealthIntervalType = .average,
        interval: HealthInterval = .init(3, .day),
        correction: Correction? = nil
    ) {
        self.intervalType = intervalType
        self.interval = interval
        self.correction = correction
    }
    public struct Correction: Hashable, Codable {
        public let type: CorrectionType
        public let value: Double
        
        public init(
            type: CorrectionType,
            value: Double
        ) {
            self.type = type
            self.value = value
        }
    }
}
