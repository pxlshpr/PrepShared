import Foundation

public extension NumberFormatter {
    static var foodValue: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        formatter.roundingMode = .halfUp
        return formatter
    }
    
    static var energyValue: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 0
        formatter.roundingMode = .halfUp
        return formatter
    }
}

public extension NumberFormatter {
    static func input(_ fractionDigits: Int? = nil) -> NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.usesGroupingSeparator = false
        if let fractionDigits {
            formatter.maximumFractionDigits = fractionDigits
            formatter.roundingMode = .halfUp
        }
        return formatter
    }
}

import SwiftUI

#Preview {
    let values: [Double] = [
        0.5,
        0.05,
        0.005,
        0.0005,
        0.00005,
        0.000005,
        0.0000005,
    ]
    
    func string(for value: Double) -> String {
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        let number = NSNumber(value: value)
        return "\(number.decimalValue)"
//        String(format: "%f", value)
//        "\(value)"
//        
//        let formatter = NumberFormatter.input()
//        let number = NSNumber(value: value)
//        return formatter.string(from: number) ?? ""
    }
    
    return NavigationStack {
        Form {
            ForEach(values, id: \.self) {
                Text(string(for: $0))
            }
        }
    }
}
