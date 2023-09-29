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

extension Goal: Equatable {
    public static func ==(lhs: Goal, rhs: Goal) -> Bool {
        lhs.type == rhs.type
        && lhs.bound == rhs.bound
        && lhs.isAutoGenerated == rhs.isAutoGenerated
        && lhs.calculatedBound == rhs.calculatedBound
        /// Ignoring `calculatedAt`
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
    
    var energyGoal: Goal? {
        first(where: { $0.type.isEnergy })
    }
    
    var hasEnergyGoal: Bool {
        energyGoal != nil
    }

    var manualEnergyGoal: Goal? {
        first(where: { $0.type.isEnergy && !$0.isAutoGenerated })
    }

    var autoEnergyGoal: Goal? {
        first(where: { $0.type.isEnergy && $0.isAutoGenerated })
    }

    var hasManualEnergyGoal: Bool {
        manualEnergyGoal != nil
    }

    var hasAutoEnergyGoal: Bool {
        autoEnergyGoal != nil
    }

    var manualMacroGoals: [Goal] {
        filter { $0.type.isMacro && !$0.isAutoGenerated }
    }
    
    var allMacroGoalsAreClosed: Bool {
        manualMacroGoals.allSatisfy { $0.calculatedBound.type == .closed }
    }
    
    var allMacroGoalsHaveUpper: Bool {
        manualMacroGoals.allSatisfy { $0.calculatedBound.upper != nil }
    }
    
    var allMacroGoalsHaveLower: Bool {
        manualMacroGoals.allSatisfy { $0.calculatedBound.lower != nil }
    }
    
    var supportsOrHasAutoEnergyGoal: Bool {
        supportsAutoEnergyGoal || hasAutoEnergyGoal
    }
    
    var supportsAutoEnergyGoal: Bool {
        !hasManualEnergyGoal
        && manualMacroGoals.count == 3
        && (allMacroGoalsAreClosed || allMacroGoalsHaveLower || allMacroGoalsHaveUpper)
    }
    
    var missingMacro: Macro? {
        guard manualMacroGoals.count == 2 else { return nil }
        let macros = manualMacroGoals.compactMap { $0.type.macro }
        return Set(Macro.allCases).subtracting(Set(macros)).first
    }
    
    var autoMacroGoal: Goal? {
        first(where: { $0.type.isMacro && $0.isAutoGenerated })
    }
    
    var macrosWithGoals: [Macro] {
        compactMap { $0.type.macro }
            .removingDuplicates()
    }
    
    var hasAutoMacroGoal: Bool {
        autoMacroGoal != nil
    }
    
    var supportsOrHasAutoMacroGoal: Bool {
        supportsAutoMacroGoal || hasAutoMacroGoal
    }
    
    var supportsAutoMacroGoal: Bool {
        generatedAutoMacroGoal() != nil
    }
    
    var numberOfEnergyDependentGoals: Int {
        filter { $0.type.usesEnergyGoal }.count
    }
    
    var hasEnergyDependentGoals: Bool {
        numberOfEnergyDependentGoals > 0
    }
}

public extension Array where Element == Goal {
    
    func generatedAutoMacroGoal() -> Goal? {
        /// Gather 2 macro goals and energy goal
        guard
            let manualEnergyGoal,
            manualMacroGoals.count == 2,
            let missingMacro = manualMacroGoals.missingMacro
        else { return nil }

        let lower = manualMacroGoals.lowerMissingMacro(for: manualEnergyGoal)
        let upper = manualMacroGoals.upperMissingMacro(for: manualEnergyGoal)
        guard lower != nil || upper != nil else { return nil }

        let bound = GoalBound(lower: lower, upper: upper)

        return Goal(
            type: .macro(.fixed, missingMacro),
            bound: bound,
            isAutoGenerated: true,
            calculatedBound: bound,
            calculatedAt: Date.now
        )
    }
    
    var macroForAutoGoal: Macro? {
        guard !hasAutoMacroGoal else { return nil }
        guard let goal = generatedAutoMacroGoal() else { return nil }
        return goal.type.macro
    }
    
    func lowerMissingMacro(for energyGoal: Goal) -> Double? {
        guard
            let missingMacro,
            let energyUnit = energyGoal.type.energyUnit,
            let energyValue = energyGoal.bound.lower
        else { return nil }
        
        let e = energyUnit.convert(energyValue, to: .kcal)
        let f = fatBound?.upper
        let p = proteinBound?.upper
        let c = carbBound?.upper

        let value: Double
        switch missingMacro {
        case .carb:
            guard let f, let p else { return nil }
            value = (e - ((f * eF) + (p * eP))) / eC
            
        case .protein:
            guard let f, let c else { return nil }
            value = (e - ((f * eF) + (c * eC))) / eP
            
        case .fat:
            guard let p, let c else { return nil }
            value = (e - ((p * eP) + (c * eC))) / eF
        }
        return Swift.max(value, 0)
    }

    func upperMissingMacro(for energyGoal: Goal) -> Double? {
        guard
            let missingMacro,
            let energyUnit = energyGoal.type.energyUnit,
            let energyValue = energyGoal.bound.upper
        else { return nil }
        
        let e = energyUnit.convert(energyValue, to: .kcal)
        let p = proteinBound?.lower ?? 0
        let c = carbBound?.lower ?? 0
        let f = fatBound?.lower ?? 0
        
        let haveProtein = proteinBound != nil
        let haveFat = fatBound != nil
        let haveCarb = carbBound != nil

        let value: Double
        switch missingMacro {
        case .carb:
            guard haveFat, haveProtein else { return nil }
            value = (e - ((f * eF) + (p * eP))) / eC
            
        case .protein:
            guard haveFat, haveCarb else { return nil }
            value = (e - ((f * eF) + (c * eC))) / eP
            
        case .fat:
            guard haveProtein, haveCarb else { return nil }
            value = (e - ((p * eP) + (c * eC))) / eF
        }
        return Swift.max(value, 0)
    }

    var lowerEnergyInKcal: Double? {
        guard let carbBound, let fatBound, let proteinBound else { return nil }

        let c = carbBound.lower ?? 0
        let f = fatBound.lower ?? 0
        let p = proteinBound.lower ?? 0

        return (c * eC) + (f * eF) + (p * eP)
    }
    
    var upperEnergyInKcal: Double? {
        guard let carbBound, let fatBound, let proteinBound else { return nil }

        let c = carbBound.upper ?? 0
        let f = fatBound.upper ?? 0
        let p = proteinBound.upper ?? 0

        return (c * eC) + (f * eF) + (p * eP)
    }

    var upperOrLowerEnergyInKcal: Double? {
        guard
            let c = carbUpperOrLower,
            let f = fatUpperOrLower,
            let p = proteinUpperOrLower
        else {
            return nil
        }
        
        return (c * eC) + (f * eF) + (p * eP)
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
