import Foundation

extension HealthDetails {
    public struct Maintenance: Hashable, Codable {
        
        public var type: MaintenanceType
        public var kcal: Double?
        public var adaptive: Adaptive
        public var estimate: Estimate
        public var useEstimateAsFallback: Bool
        public var hasConfigured: Bool
        
        public init(
            type: MaintenanceType = .estimated,
            kcal: Double? = nil,
            adaptive: Adaptive = Adaptive(),
            estimate: Estimate = Estimate(),
            useEstimateAsFallback: Bool = true,
            hasConfigured: Bool = false
        ) {
            self.type = type
            self.kcal = kcal
            self.adaptive = adaptive
            self.estimate = estimate
            self.useEstimateAsFallback = useEstimateAsFallback
            self.hasConfigured = hasConfigured
        }
        
        public struct Adaptive: Hashable, Codable {
            public var kcal: Double?
            public var interval: HealthInterval
            public var dietaryEnergy = DietaryEnergy()
            public var weightChange = WeightChange()
            
            public init(
                kcal: Double? = nil,
                interval: HealthInterval = .init(1, .week),
                dietaryEnergyPoints points: [DietaryEnergyPoint] = [],
                weightChange: WeightChange = WeightChange()
            ) {
                self.kcal = kcal
                self.interval = interval
                self.dietaryEnergy = .init(points: points)
                self.weightChange = weightChange

                self.kcal = self.calculateIfValid()
            }

            public struct DietaryEnergy: Hashable, Codable {
                public var kcalPerDay: Double?

                public init(kcalPerDay: Double? = nil) {
                    self.kcalPerDay = kcalPerDay
                }
                
                public init(points: [DietaryEnergyPoint]) {
                    var points = points
                    points.fillAverages()
                    self.kcalPerDay = points.kcalPerDay
                }
                
                public static func calculateKcalPerDay(for points: [DietaryEnergyPoint]) -> Double? {
                    var points = points
                    points.fillAverages()
                    return points.kcalPerDay
                }
            }
        }
        
        public struct Estimate: Hashable, Codable {
            public var kcal: Double?
            public var restingEnergy: RestingEnergy
            public var activeEnergy: ActiveEnergy
            
            public init(
                kcal: Double? = nil,
                restingEnergy: RestingEnergy = RestingEnergy(),
                activeEnergy: ActiveEnergy = ActiveEnergy()
            ) {
                self.kcal = kcal
                self.restingEnergy = restingEnergy
                self.activeEnergy = activeEnergy
            }
            
            public struct RestingEnergy: Hashable, Codable {
                public var kcal: Double?
                public var source: RestingEnergySource
                public var equation: RestingEnergyEquation?
                public var preferLeanBodyMass: Bool
                public var healthKitFetchSettings: HealthKitFetchSettings?
                
                public init(
                    kcal: Double? = nil,
                    source: RestingEnergySource = .equation,
                    equation: RestingEnergyEquation? = .katchMcardle,
                    preferLeanBodyMass: Bool = true,
                    healthKitFetchSettings: HealthKitFetchSettings? = nil
                ) {
                    self.kcal = kcal
                    self.source = source
                    self.equation = equation
                    self.preferLeanBodyMass = preferLeanBodyMass
                    self.healthKitFetchSettings = healthKitFetchSettings
                }
            }
            
            public struct ActiveEnergy: Hashable, Codable {
                public var kcal: Double?
                public var source: ActiveEnergySource
                public var activityLevel: ActivityLevel?
                public var healthKitFetchSettings: HealthKitFetchSettings?
                
                public init(
                    kcal: Double? = nil,
                    source: ActiveEnergySource = .activityLevel,
                    activityLevel: ActivityLevel? = .lightlyActive,
                    healthKitFetchSettings: HealthKitFetchSettings? = nil
                ) {
                    self.kcal = kcal
                    self.source = source
                    self.activityLevel = activityLevel
                    self.healthKitFetchSettings = healthKitFetchSettings
                }
            }
        }
    }
}

public let MinimumAdaptiveEnergyInKcal: Double = 1000

public extension HealthDetails.Maintenance.Adaptive {
    static func calculate(
        interval: HealthInterval,
        weightChange: WeightChange,
        dietaryEnergy: DietaryEnergy
    ) -> Double? {
        guard let weightDeltaInKcal = weightChange.energyEquivalentInKcal,
              let kcalPerDay = dietaryEnergy.kcalPerDay else {
            return nil
        }
        let totalKcal = kcalPerDay * Double(interval.numberOfDays)
        return (totalKcal - weightDeltaInKcal) / Double(interval.numberOfDays)
    }
    
    func calculateIfValid() -> Double? {
        guard let kcal = Self.calculate(
            interval: interval,
            weightChange: weightChange,
            dietaryEnergy: dietaryEnergy
        ) else { return nil }

        guard kcal >= MinimumAdaptiveEnergyInKcal else { return nil }
        return kcal
    }
    
    static func minimumEnergyString(in energyUnit: EnergyUnit) -> String {
        let converted = EnergyUnit.kcal.convert(MinimumAdaptiveEnergyInKcal, to: energyUnit)
        return "\(converted.formattedEnergy) \(energyUnit.abbreviation)"
    }
}
