import Foundation

public struct PlanFields: Hashable, Equatable {
    public var name: String = ""
    public var emoji: String = String.randomPlanEmoji
    public var goals: [Goal] = []
}

public extension PlanFields {
    var canBeSaved: Bool {
        !name.isEmpty
        && !emoji.isEmpty
        && !goals.isEmpty
    }
    
    mutating func fill(with plan: Plan) {
        name = plan.name
        emoji = plan.emoji
        goals = plan.goals
    }
}

public extension PlanFields {
    var energyGoal: Goal? {
        goals.first(where: { $0.type.isEnergy && !$0.isAutoGenerated })
    }

    /// Returns the auto energy goal if present
    var existingAutoEnergyGoal: Goal? {
        goals.first(where: { $0.type.isEnergy && $0.isAutoGenerated })
    }

    func indexOfGoal(matching goal: Goal) -> Int? {
        goals.firstIndex(where: { $0.type.nutrient == goal.type.nutrient })
    }
    
    mutating func save(_ goal: Goal) {
        if let index = indexOfGoal(matching: goal) {
            goals[index] = goal
        } else {
            goals.append(goal)
        }
    }
    
    mutating func delete(_ goal: Goal) {
        if goal.type.isEnergy {
            goals.removeAll(where: { $0.type.usesEnergyGoal })
        }
        goals.removeAll(where: { $0.type.nutrient == goal.type.nutrient })
    }
}

public extension PlanFields {
    var haveMicros: Bool {
        goals.contains(where: { $0.type.isMicro })
    }
    
    var haveMacros: Bool {
        goals.contains(where: { $0.type.isMacro })
    }
    
    var hasEnergy: Bool {
        goals.contains(where: { $0.type.isEnergy })
    }
}

public extension Plan {
    func matches(_ fields: PlanFields) -> Bool {
        if fields.name != name { return false }
        if fields.emoji != emoji { return false }
        return true
    }
}

public extension PlanFields {
    
    var haveClosedMacroGoal: Bool {
        macroGoals.contains(where: { $0.calculatedBound.type == .closed })
    }
    
    func generatedAutoMacroGoal() -> Goal? {
        /// Gather 2 macro goals and energy goal
        guard
            let energyGoal,
            macroGoals.count == 2,
            let missingMacro = macroGoals.missingMacro
        else { return nil }

        let bound: GoalBound
        
        if haveClosedMacroGoal {
            
            guard
                let lower = macroGoals.lowerMissingMacro(for: energyGoal),
                let upper = macroGoals.upperMissingMacro(for: energyGoal)
            else {
                return nil
            }
            bound = GoalBound(lower: lower, upper: upper)

        } else {
            return nil
        }
        
        return Goal(
            type: .macro(.fixed, missingMacro),
            bound: bound,
            isAutoGenerated: true,
            calculatedBound: bound,
            calculatedAt: Date.now
        )
        /// If any of them have a closed bound, we're creating a closed bound goal
        /// - What do we do if some are lower and some are upper? (Macro follows energy)
        ///     - 2 macros upper, energy lower: macro lower
        ///     - 1 macro + energy upper, 1 macro lower: macro upper
        ///     - energy upper, 2 macro lower: macro upper
        ///     - all 3 upper: macro upper
        ///     - all 3 lower: macro lower
        /// - Now calculate the goals
        
    }
}

public extension PlanFields {
    func generatedAutoEnergyGoal(using unit: EnergyUnit) -> Goal? {
        
        /// Gather all macro goals
        guard macroGoals.count == 3 else { return nil }

        /// If any of them have a closed bound, we're creating a closed bound goal
        let bound: GoalBound
        if haveClosedMacroGoal {
            
            guard
                let lowerInKcal = macroGoals.lowerEnergyInKcal,
                let upperInKcal = macroGoals.upperOrLowerEnergyInKcal
            else {
                return nil
            }
            
            let lower = EnergyUnit.kcal.convert(lowerInKcal, to: unit)
            let upper = EnergyUnit.kcal.convert(upperInKcal, to: unit)

            guard let energyBound = GoalBound(.closed, lower, upper) else {
                return nil
            }
            bound = energyBound
        } else {
            let upperCount = macroGoals.filter { $0.calculatedBound.upper != nil }.count
            let lowerCount = macroGoals.filter { $0.calculatedBound.lower != nil }.count
            
            /// Set a maximum for energy only if all macros are also maximum. Otherwise, set a minimum with a total of any minimum bounds.
            switch (upperCount, lowerCount) {
            case (3, 0):    bound = GoalBound(upper: macroGoals.upperEnergyInKcal)
            default:        bound = GoalBound(lower: macroGoals.lowerEnergyInKcal)
            }
        }

        return Goal(
            type: .energy(.fixed(unit)),
            bound: bound,
            isAutoGenerated: true,
            calculatedBound: bound,
            calculatedAt: Date.now
        )
    }
}

public extension PlanFields {

    var macroGoals: [Goal] {
        goals.macroGoals
    }

    var microGoals: [Goal] {
        goals
            .filter { $0.type.isMicro }
            .filter { !$0.isAutoGenerated }
    }
    
    var showGoalsHeaderOnMicros: Bool {
        !hasEnergy && !haveMacros && haveMicros
    }
    
    var showGoalsHeaderOnMacros: Bool {
        !hasEnergy && !supportsAutoEnergyGoal && haveMacros
    }
    
    var showGoalsHeaderOnEnergy: Bool {
        hasEnergy || supportsAutoEnergyGoal
    }
    
    var showGoalsHeaderOnAdd: Bool {
        goals.isEmpty
    }
}

public extension PlanFields {
    
    var numberOfEnergyDependentGoals: Int {
        goals.filter { $0.type.usesEnergyGoal }.count
    }
    
    var hasEnergyDependentGoals: Bool {
        numberOfEnergyDependentGoals > 0
    }
}

public extension PlanFields {
    
    var autoMacroGoal: Goal? {
        goals.first(where: { $0.type.isMacro && $0.isAutoGenerated })
    }
    var hasAutoMacroGoal: Bool {
        autoMacroGoal != nil
    }

    var macrosWithGoals: [Macro] {
        goals
            .compactMap { $0.type.macro }
            .removingDuplicates()
    }
    
    var hasEnergyGoal: Bool {
        energyGoal != nil
    }
    
    var supportsAutoEnergyGoal: Bool {
        (!hasEnergyGoal && macrosWithGoals.count == 3)
        ||
        hasAutoEnergyGoal
    }
    
    var hasAutoEnergyGoal: Bool {
        goals
            .contains(where: { $0.type.isEnergy && $0.isAutoGenerated })
    }
    
    var supportsAutoMacroGoal: Bool {
        macroForAutoGoal != nil
    }
    
    var macroForAutoGoal: Macro? {
        
        /// Return the macro for the existing auto goal, if present
        if let macro = autoMacroGoal?.type.macro {
            return macro
        }
        
        /// Otherwise determine if there is a potential macro for an auto goal
        guard hasEnergyGoal else { return nil }
        let macros = macrosWithGoals
        guard macros.count == 2 else { return nil }
        return Set(Macro.allCases)
            .subtracting(Set(macros))
            .first
    }
}