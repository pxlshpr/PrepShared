import Foundation

public extension Array where Element == Date? {
    var latestDate: Date? {
        self.compactMap { $0 }
            .sorted()
            .last
    }
}

public extension Date {

    init?(fromDateString string: String) {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy_MM_dd"
        guard let date = dateFormatter.date(from: string) else {
            return nil
        }
        self = date
    }

    init?(fromTimeString string: String) {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy_MM_dd-HH_mm"
        guard let date = dateFormatter.date(from: string) else {
            return nil
        }
        self = date
    }

    var backupString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy_MM_dd-HH_mm_ss"
        return dateFormatter.string(from: self).lowercased()
    }

    var dateString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy_MM_dd"
        return dateFormatter.string(from: self).lowercased()
    }

    var timeString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy_MM_dd-HH_mm"
        return dateFormatter.string(from: self).lowercased()
    }

//    var year: Int {
//        Calendar.current.dateComponents([.year], from: self).year ?? 0
//    }
    
    func longDateString(longDayNames: Bool = true) -> String {
        let formatter = DateFormatter()
        if self.year == Date().year {
            formatter.dateFormat = "EEE\(longDayNames ? "E" : "") d MMM"
        } else {
            formatter.dateFormat = "EEE\(longDayNames ? "E" : "") d MMM yy"
        }
        return formatter.string(from: self)
    }
    
    var longDateString: String {
        longDateString(longDayNames: true)
    }

    func logDateString(longDayNames: Bool = true) -> String {
        if isToday {
            "Today"
        } else if isYesterday {
            "Yesterday"
        } else if isTomorrow {
            "Tomorrow"
        } else {
            longDateString(longDayNames: longDayNames)
        }
    }
    
    var logDateString: String {
        logDateString()
    }

//    var startOfDay: Date {
//        Calendar.current.startOfDay(for: self)
//    }

//    var isToday: Bool {
//        startOfDay == Date().startOfDay
//    }
//    
//    var isYesterday: Bool {
//        startOfDay == Date().startOfDay.addingTimeInterval(-24 * 3600)
//    }
//    
//    var isTomorrow: Bool {
//        startOfDay == Date().startOfDay.addingTimeInterval(24 * 3600)
//    }

//    func moveDayBy(_ dateIncrement: Int) -> Date {
//        var components = DateComponents()
//        components.day = dateIncrement
//        return Calendar.current.date(byAdding: components, to: self)!
//    }

    func moveYearBy(_ yearIncrement: Int) -> Date {
        var components = DateComponents()
        components.year = yearIncrement
        return Calendar.current.date(byAdding: components, to: self)!
    }

    var shortTimeString: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        return formatter.string(from: self)
    }
}
