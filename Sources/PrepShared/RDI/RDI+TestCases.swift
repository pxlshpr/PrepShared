import Foundation

public let vitaminC_nih = RDI(
    micro: .vitaminC_ascorbicAcid,
    unit: .mg,
    url: "https://ods.od.nih.gov/factsheets/VitaminC-Consumer/",
    type: .fixed,
    values: [
        v(l(40), ageRange: b(0, 0.5)),
        v(l(50), ageRange: b(0.5, 1.0)),
        v(b(15, 400), ageRange: b(1, 4)),
        v(b(25, 650), ageRange: b(4, 9)),
        v(b(45, 1200), ageRange: b(9, 14)),
        v(b(75, 1800), ageRange: b(14, 19), gender: .male),
        v(b(65, 1800), ageRange: b(14, 19), gender: .female, pregnant: false, lactating: false),
        v(b(80, 1800), ageRange: b(14, 19), gender: .female, pregnant: true, lactating: false),
        v(b(115, 1800), ageRange: b(14, 19), gender: .female, pregnant: false, lactating: true),
        v(b(90, 2000), ageRange: l(19), gender: .male, smoker: false),
        v(b(125, 2000), ageRange: l(19), gender: .male, smoker: true),
        v(b(75, 2000), ageRange: l(19), gender: .female, pregnant: false, lactating: false, smoker: false),
        v(b(110, 2000), ageRange: l(19), gender: .female, pregnant: false, lactating: false, smoker: true),
        v(b(85, 2000), ageRange: l(19), gender: .female, pregnant: true, lactating: false, smoker: false),
        v(b(120, 2000), ageRange: l(19), gender: .female, pregnant: false, lactating: true, smoker: false),
    ]
)

public let transFat_who = RDI(
    micro: .transFat,
    unit: .g,
    url: "https://www.who.int/news-room/questions-and-answers/item/nutrition-trans-fat",
    type: .percentageOfEnergy,
    values: [
        v(u(1)),
    ]
)

public let fiber_mayoClinic = RDI(
    micro: .dietaryFiber,
    unit: .g,
    url: "https://www.mayoclinic.org/healthy-lifestyle/nutrition-and-healthy-eating/in-depth/high-fiber-foods/art-20050948",
    type: .fixed,
    values: [
        v(b(21, 25), gender: .female),
        v(b(30, 38), gender: .male),
    ]
)

public let fiber_eatRight = RDI(
    micro: .dietaryFiber,
    unit: .g,
    url: "https://www.eatright.org/health/essential-nutrients/carbohydrates/fiber",
    type: .quantityPerEnergy(1000, .kcal),
    values: [
        v(l(14)),
    ]
)

//MARK: - Helpers

public func v(
    _ bound: GoalBound,
    ageRange: GoalBound? = nil,
    gender: BiometricSex? = nil,
    pregnant: Bool? = nil,
    lactating: Bool? = nil,
    smoker: Bool? = nil
) -> RDIValue {
    RDIValue(
        bound: bound,
        ageRange: ageRange,
        gender: gender,
        isPregnant: pregnant,
        isLactating: lactating,
        isSmoker: smoker
    )
}

public func b(_ lower: Double, _ upper: Double) -> GoalBound {
    GoalBound(lower: lower, upper: upper)
}

public func l(_ lower: Double) -> GoalBound {
    GoalBound(lower: lower)
}

public func u(_ upper: Double) -> GoalBound {
    GoalBound(upper: upper)
}
