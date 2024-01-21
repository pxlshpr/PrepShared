import Foundation

public struct HealthInterval: Hashable, Codable, Equatable {
    public var value: Int
    public var period: HealthPeriod
    public var date: Date?
    
    public init(_ value: Int, _ period: HealthPeriod, date: Date? = nil) {
        self.value = value
        self.period = period
        self.date = date
    }
    
    public static var `default`: HealthInterval {
        .init(1, .week)
    }
}

public extension HealthInterval {
    
    var weeks: Int? {
        get {
            guard period == .week else { return nil }
            return value
        }
        set {
            guard let newValue else {
                return
            }
            self.value = newValue
            self.period = .week
        }
    }
    
    var numberOfDays: Int {
        switch period {
        case .day:      value
        case .week:     value * 7
            
        /// [ ]  Use the date to precisely find out how many days ago was `value` months (get the current day `value` months back, and calculate the number of days)
        case .month:    value * 30
        }
    }
}

public extension HealthInterval {
    
    func equalsWithoutTimestamp(_ other: HealthInterval) -> Bool {
        value == other.value && period == other.period
    }
    
    var greaterIntervals: [HealthInterval] {
        let all = Self.allIntervals
        guard let index = all.firstIndex(where: { $0.value == self.value && $0.period == self.period }),
              index + 1 < all.count
        else { return [] }
        return Array(all[index+1..<all.count])
    }
    
    static var allIntervals: [HealthInterval] {
        /// Prefill `(1, .day)` because 1 isn't included in the possible values for `.day`
        var intervals: [HealthInterval] = [.init(1, .day)]
        for period in HealthPeriod.allCases {
            for value in period.minValue...period.maxValue {
                intervals.append(.init(value, period))
            }
        }
        return intervals
    }

    static var healthKitEnergyIntervals: [HealthInterval] {
        [
            .init(1, .day),
            .init(2, .day),
            .init(3, .day),
            .init(4, .day),
            .init(5, .day),
            .init(6, .day),
            .init(1, .week),
            .init(2, .week),
        ]
    }

    var intervalType: HealthIntervalType {
        get {
            switch period {
            case .day:
                switch value {
                case 0:     .sameDay
                case 1:     .previousDay
                default:    .average
                }
            default:    .average
            }
        }
        set {
            switch newValue {
            case .average:
                value = 2
                period = .week
            case .sameDay:
                value = 0
                period = .day
            case .previousDay:
                value = 1
                period = .day
            }
        }
    }
    
    mutating func correctIfNeeded() {
        if value < period.minValue {
            value = period.minValue
        }
        if value > period.maxValue {
            value = period.maxValue
        }
    }

    func startDate(with date: Date) -> Date {
        let calendar = Calendar(identifier: .gregorian)
        let endDate = calendar.startOfDay(for: date)
        return calendar.date(
            byAdding: period.calendarComponent,
            value: -value,
            to: endDate
        )!
    }
    
    func dateRange(with date: Date) -> ClosedRange<Date> {
        let calendar = Calendar(identifier: .gregorian)
        let startDate = startDate(with: date)
        let endDate = calendar.startOfDay(for: date)
        switch (value, period) {
        case (0, .day):
            return startDate.moveDayBy(-1)...endDate
        default:
            return startDate.moveDayBy(-1)...endDate.moveDayBy(-1)
        }
    }
    
    var dateRange: ClosedRange<Date>? {
        period.dateRangeOfPast(value)
    }
    
    var isLatest: Bool {
        value == 1 && period == .day
    }
    
    var isToday: Bool {
        value == 0 && period == .day
    }
}

extension HealthInterval: CustomStringConvertible {
    public var description: String {
        "\(value) \(period.name)\(value > 1 ? "s" : "")"
    }
}
