import SwiftUI

public extension Food {
    var fullName: String {
        var string = "\(emoji) \(name)"
        if let detail {
            string = "\(string), \(detail)"
        }
        if let brand {
            string = "\(string), \(brand)"
        }
        return string
    }
}

public extension Food {
    var energyString: String {
        NumberFormatter.energyValue.string(from: NSNumber(floatLiteral: energy)) ?? ""
    }
    
    var equivalentEnergyValue: Double {
        energyUnit.convert(energy,  to: equivalentEnergyUnit)
    }

    var equivalentEnergyString: String {
        NumberFormatter.energyValue.string(from: NSNumber(floatLiteral: equivalentEnergyValue)) ?? ""
    }
    
    var equivalentEnergyWithUnitString: String {
        "\(equivalentEnergyString) \(equivalentEnergyUnit.abbreviation)"
    }

    var equivalentEnergyUnit: EnergyUnit {
        energyUnit == .kcal ? .kJ : .kcal
    }
    
    func macroString(_ macro: Macro) -> String {
        let value = switch macro {
        case .carb:     carb
        case .fat:      fat
        case .protein:  protein
        }
        return NumberFormatter.foodValue.string(
            from: NSNumber(floatLiteral: value)
        ) ?? ""
    }
    
    var microGroups: [MicroGroup] {
        micros
            .compactMap { $0.micro?.group }
            .removingDuplicates()
            .sorted()
    }
    
    func nutrientValues(for group: MicroGroup) -> [NutrientValue] {
        micros
            .filter { $0.micro?.group == group }
            .compactMap { NutrientValue($0) }
    }

    func nutrients(for group: MicroGroup) -> [Nutrient] {
        micros
            .filter { $0.micro?.group == group }
            .compactMap { $0.micro }
            .map { Nutrient.micro($0) }
    }

    func microValueString(_ micro: Micro) -> String? {
        guard let value = value(for: .micro(micro))?.value else {
            return nil
        }
        return NumberFormatter.foodValue.string(
            from: NSNumber(floatLiteral: value)
        )
    }
    
    func rdaPercentageString(_ micro: Micro) -> String? {
//        guard micro.supportsPercentages else { return nil }
        /// If we have micro in something other than percentage and it can convert to percentage, return that
        guard
            let value = value(for: .micro(micro)),
            let percentage = micro.convertToRDApercentage(amount: value.value, unit: value.unit) else {
            return nil
        }
        return "\(Int(percentage)) %"
    }
    
    func microUnitString(_ micro: Micro) -> String? {
        guard let unit = value(for: .micro(micro))?.unit else {
            return nil
        }
        return unit.abbreviation
    }
}
