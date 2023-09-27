import Foundation

public struct Goal: Identifiable, Hashable, Codable {
    
    public let type: GoalType
    public var bound: GoalBound
    public var isAutoGenerated: Bool
    public var calculatedBound: GoalBound
    public var calculatedAt: Date
    
    public init(
        type: GoalType,
        bound: GoalBound,
        isAutoGenerated: Bool = false,
        calculatedBound: GoalBound,
        calculatedAt: Date = Date.now
    ) {
        self.type = type
        self.bound = bound
        self.isAutoGenerated = isAutoGenerated
        self.calculatedBound = calculatedBound
        self.calculatedAt = calculatedAt
    }
}

extension Goal: Comparable {
    var sortPosition: Int {
        switch type {
        case .energy:                   1
        case .macro(_, let macro):      macro.sortPosition
        case .micro(_, let micro, _):   micro.rawValue
        }
    }
    public static func <(lhs: Goal, rhs: Goal) -> Bool {
        return lhs.sortPosition < rhs.sortPosition
    }
}
public extension Goal {
    var id: String {
        type.identifyingHashValue
    }
    
//    var unit: any BiometricUnit {
//        switch type {
//        case .energy(let type):
//            switch type {
//            case .fixed(let unit):
//                unit
//            case .fromMaintenance(let unit, _):
//                unit
//            case .percentFromMaintenance:
//                SettingsStore.shared.settings.energyUnit
//            }
//        case .macro:
//            NutrientUnit.g
//        case .micro(_, _, let unit):
//            unit
//        }
//    }
}

public extension Array where Element == Goal {
    var micros: [Micro] {
        self.compactMap { $0.type.micro }
    }
    
    var macros: [Macro] {
        self.compactMap { $0.type.macro }
    }
    
    var containsEnergyGoal: Bool {
        self.contains(where: { $0.type.isEnergy })
    }
    
    var containsManualEnergyGoal: Bool {
        self.contains(where: { $0.type.isEnergy && !$0.isAutoGenerated })
    }
}

//import SwiftUI
//
//extension Goal {
//    func boundText(_ foregroundStyle: some ShapeStyle = .secondary) -> some View {
//        
//        func valueText(_ value: Double, _ withUnit: Bool) -> some View {
//            HStack(alignment: .firstTextBaseline, spacing: 3) {
//                Text("\(type.formattedString(for: value))")
//                    .animation(.default, value: value)
//                    .contentTransition(.numericText(value: value))
//                    .foregroundStyle(foregroundStyle)
//                if withUnit {
//                    text(unit.abbreviation)
//                }
//            }
//        }
//        
//        func text(_ string: String) -> some View {
//            Text(string)
//                .foregroundStyle(foregroundStyle)
//        }
//        
//        @ViewBuilder
//        func lowerText(withUnit: Bool = true) -> some View {
//            if let value = calculatedBound.lower {
//                valueText(value, withUnit)
//            }
//        }
//
//        @ViewBuilder
//        func upperText(withUnit: Bool = true) -> some View {
//            if let value = calculatedBound.upper {
//                valueText(value, withUnit)
//            }
//        }
//        
//        var maximum: some View {
//            Group {
//                text("Maximum")
//                upperText()
//            }
//        }
//        
//        return HStack {
//            switch calculatedBound.type {
//            case .lower:
//                text("Minimum")
//                lowerText()
//            case .upper:
//                maximum
//            case .closed:
//                if calculatedBound.lower == 0 {
//                    maximum
//                } else {
//                    HStack(spacing: 1) {
//                        lowerText(withUnit: false)
//                        text("-")
//                        upperText()
//                    }
//                }
//            case .none:
//                EmptyView()
//            }
//        }
//        .frame(maxWidth: .infinity, alignment: .trailing)
//    }
//}

public extension Array where Element == Goal {
    
    var manualMacroGoals: [Goal] {
        filter { $0.type.isMacro && !$0.isAutoGenerated }
    }

    var missingMacro: Macro? {
        guard manualMacroGoals.count == 2 else { return nil }
        let macros = manualMacroGoals.compactMap { $0.type.macro }
        return Set(Macro.allCases).subtracting(Set(macros)).first
    }
    
    func lowerMissingMacro(for energyGoal: Goal) -> Double? {
        guard
            let missingMacro,
            let energyUnit = energyGoal.type.energyUnit,
            let energyValue = energyGoal.bound.lower ?? energyGoal.bound.upper
        else { return nil }
        
        let e = energyUnit.convert(energyValue, to: .kcal)
        
        switch missingMacro {
        case .carb:
            guard let fatBound, let proteinBound else { return nil }
            let f = fatBound.lower ?? 0
            let p = proteinBound.lower ?? 0
            return (e - (
                (f * Macro.fat.kcalsPerGram)
                + (p * Macro.protein.kcalsPerGram)
            )) / Macro.carb.kcalsPerGram
            
        case .protein:
            guard let fatBound, let carbBound else { return nil }
            let f = fatBound.lower ?? 0
            let c = carbBound.lower ?? 0
            return (e - (
                (f * Macro.fat.kcalsPerGram)
                + (c * Macro.carb.kcalsPerGram)
            )) / Macro.protein.kcalsPerGram
            
        case .fat:
            guard let proteinBound, let carbBound else { return nil }
            let p = proteinBound.lower ?? 0
            let c = carbBound.lower ?? 0
            return (e - (
                (p * Macro.protein.kcalsPerGram)
                + (c * Macro.carb.kcalsPerGram)
            )) / Macro.fat.kcalsPerGram
        }
    }

    func upperMissingMacro(for energyGoal: Goal) -> Double? {
        guard
            let missingMacro,
            let energyUnit = energyGoal.type.energyUnit,
            let energyValue = energyGoal.bound.upper ?? energyGoal.bound.lower
        else { return nil }
        
        let e = energyUnit.convert(energyValue, to: .kcal)
        
        switch missingMacro {
        case .carb:
            guard
                let fatBound,
                let proteinBound,
                let f = fatBound.upper ?? fatBound.lower,
                let p = proteinBound.upper ?? proteinBound.lower
            else { return nil }
            
            return (e - (
                (f * Macro.fat.kcalsPerGram)
                + (p * Macro.protein.kcalsPerGram)
            )) / Macro.carb.kcalsPerGram
            
        case .protein:
            guard
                let fatBound,
                let carbBound,
                let f = fatBound.upper ?? fatBound.lower,
                let c = carbBound.upper ?? carbBound.lower
            else { return nil }
            
            return (e - (
                (f * Macro.fat.kcalsPerGram)
                + (c * Macro.carb.kcalsPerGram)
            )) / Macro.protein.kcalsPerGram
            
        case .fat:
            guard
                let proteinBound,
                let carbBound,
                let p = proteinBound.upper ?? proteinBound.lower,
                let c = carbBound.upper ?? carbBound.lower
            else { return nil }
            
            return (e - (
                (p * Macro.protein.kcalsPerGram)
                + (c * Macro.carb.kcalsPerGram)
            )) / Macro.fat.kcalsPerGram
        }
    }

    var lowerEnergyInKcal: Double? {
        guard let carbBound, let fatBound, let proteinBound else { return nil }

        let c = carbBound.lower ?? 0
        let f = fatBound.lower ?? 0
        let p = proteinBound.lower ?? 0

        return (c * Macro.carb.kcalsPerGram)
        + (f * Macro.fat.kcalsPerGram)
        + (p * Macro.protein.kcalsPerGram)
    }
    
    var upperEnergyInKcal: Double? {
        guard let carbBound, let fatBound, let proteinBound else { return nil }

        let c = carbBound.upper ?? 0
        let f = fatBound.upper ?? 0
        let p = proteinBound.upper ?? 0

        return (c * Macro.carb.kcalsPerGram)
        + (f * Macro.fat.kcalsPerGram)
        + (p * Macro.protein.kcalsPerGram)
    }

    var upperOrLowerEnergyInKcal: Double? {
        guard
            let c = carbUpperOrLower,
            let f = fatUpperOrLower,
            let p = proteinUpperOrLower
        else {
            return nil
        }
        
        return (c * Macro.carb.kcalsPerGram)
        + (f * Macro.fat.kcalsPerGram)
        + (p * Macro.protein.kcalsPerGram)
    }

    var carbUpperOrLower: Double? { carbBound?.upper ?? carbBound?.lower }
    var fatUpperOrLower: Double? { fatBound?.upper ?? fatBound?.lower }
    var proteinUpperOrLower: Double? { proteinBound?.upper ?? proteinBound?.lower }

    var carbBound: GoalBound? { bound(for: .carb) }
    var fatBound: GoalBound? { bound(for: .fat) }
    var proteinBound: GoalBound? { bound(for: .protein) }

    func bound(for macro: Macro) -> GoalBound? {
        first(where: { $0.type.macro == macro })?.calculatedBound
    }
}
