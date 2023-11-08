import Foundation

public extension Double {
    func string(withDecimalPlaces places: Int) -> String {
        let rounded = self.rounded(toPlaces: places)
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        let number = NSNumber(value: rounded)
        
        guard let formatted = numberFormatter.string(from: number) else {
            return "\(rounded)"
        }
        return formatted
    }
}

public extension Double {
    
    var healthString: String {
        rounded(toPlaces: 1).clean
    }
    
    var formattedNutrient: String {
        let rounded: Double
        if self < 50 {
            rounded = self.rounded(toPlaces: 1)
        } else {
            rounded = self.rounded()
        }
        return rounded.formattedWithCommas
    }

    /// Used during animations. We only show decimals if it's below 1.
    var animatedNutrientValue2: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        let number: NSNumber
        if self > 1 {
            formatter.maximumFractionDigits = 0
            number = NSNumber(value: Int(self))
        } else {
            formatter.maximumFractionDigits = 0
            number = NSNumber(value: self)
        }
        
        guard let formatted = formatter.string(from: number) else {
            return "\(Int(self))"
        }
        return formatted
    }

    var animatedNutrientValue: String {
        formattedNutrientValue
    }
    
    var formattedNutrientValue: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        let number: NSNumber
        if self > 10 {
            formatter.maximumFractionDigits = 0
            number = NSNumber(value: Int(self))
        } else {
            formatter.maximumFractionDigits = self > 1 ? 1 : 2
            number = NSNumber(value: self)
        }
        
        guard let formatted = formatter.string(from: number) else {
            return "\(Int(self))"
        }
        return formatted
    }

    var animatedItemAmount: String {
        animatedNutrientValue2
    }

    var formattedItemAmount: String {
        self.cleanAmount
    }

    /// no commas, but rounds it off
    var formattedMacro: String {
        "\(Int(self.rounded()))"
    }
    
    /// uses commas, rounds it off
    var formattedEnergy: String {
        let rounded = self.rounded()
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        let number = NSNumber(value: Int(rounded))
        
        guard let formatted = numberFormatter.string(from: number) else {
            return "\(Int(rounded))"
        }
        return formatted
    }
    
//    func matches(_ other: Double) -> Bool {
//        self.rounded(toPlaces: 1) == other.rounded(toPlaces: 1)
//    }
}

public extension Double {
    var formattedWithCommas: String {
        guard self >= 1000 else {
            return cleanAmount
        }
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        let number = NSNumber(value: Int(self))
        
        guard let formatted = formatter.string(from: number) else {
            return "\(Int(self))"
        }
        return formatted
    }
}


public extension Double {
    func matches(_ other: Double) -> Bool {
        self.rounded(toPlaces: 1) == other.rounded(toPlaces: 1)
    }
}
