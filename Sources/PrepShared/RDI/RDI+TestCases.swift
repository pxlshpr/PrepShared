import Foundation

let vitaminCValues: [RDIValue] = [
    v(l(40), ageRange: b(0, 0.5)),
    v(l(50), ageRange: b(0.5, 1.0)),
    v(b(15, 400), ageRange: b(1, 4)),
    v(b(25, 650), ageRange: b(4, 9)),
    v(b(45, 1200), ageRange: b(9, 14)),
    v(b(75, 1800), ageRange: b(14, 19), sex: .male),
    v(b(65, 1800), ageRange: b(14, 19), sex: .female, pregnancyStatus: .notPregnantOrLactating),
    v(b(80, 1800), ageRange: b(14, 19), sex: .female, pregnancyStatus: .pregnant),
    v(b(115, 1800), ageRange: b(14, 19), sex: .female, pregnancyStatus: .lactating),
    v(b(90, 2000), ageRange: l(19), sex: .male, smoker: false),
    v(b(125, 2000), ageRange: l(19), sex: .male, smoker: true),
    v(b(75, 2000), ageRange: l(19), sex: .female, pregnancyStatus: .notPregnantOrLactating, smoker: false),
    v(b(110, 2000), ageRange: l(19), sex: .female, pregnancyStatus: .notPregnantOrLactating, smoker: true),
    v(b(85, 2000), ageRange: l(19), sex: .female, pregnancyStatus: .pregnant, smoker: false),
    v(b(120, 2000), ageRange: l(19), sex: .female, pregnancyStatus: .lactating, smoker: false),
]

public let vitaminC_nih = RDI(
    micro: .vitaminC_ascorbicAcid,
    unit: .mg,
    type: .fixed,
    
    values: vitaminCValues.sanitized(),
    source: .init(name: "NIH"),
    url: "https://ods.od.nih.gov/factsheets/VitaminC-Consumer/"

//    values: [
//        v(l(40), ageRange: b(0, 0.5), sex: .notSet, pregnancyStatus: .notSet, smoker: false),
//        v(l(50), ageRange: b(0.5, 1.0), sex: .notSet, pregnancyStatus: .notSet, smoker: false),
//        v(b(15, 400), ageRange: b(1, 4), sex: .notSet, pregnancyStatus: .notSet, smoker: false),
//        v(b(25, 650), ageRange: b(4, 9), sex: .notSet, pregnancyStatus: .notSet, smoker: false),
//        v(b(45, 1200), ageRange: b(9, 14), sex: .notSet, pregnancyStatus: .notSet, smoker: false),
//        v(b(75, 1800), ageRange: b(14, 19), sex: .male, pregnancyStatus: .notSet, smoker: false),
//        v(b(65, 1800), ageRange: b(14, 19), sex: .female, pregnancyStatus: .notPregnantOrLactating, smoker: false),
//        v(b(80, 1800), ageRange: b(14, 19), sex: .female, pregnancyStatus: .pregnant, smoker: false),
//        v(b(115, 1800), ageRange: b(14, 19), sex: .female, pregnancyStatus: .lactating, smoker: false),
//        v(b(90, 2000), ageRange: l(19), sex: .male, pregnancyStatus: .notSet, smoker: false),
//        v(b(125, 2000), ageRange: l(19), sex: .male, pregnancyStatus: .notSet, smoker: true),
//        v(b(75, 2000), ageRange: l(19), sex: .female, pregnancyStatus: .notPregnantOrLactating, smoker: false),
//        v(b(110, 2000), ageRange: l(19), sex: .female, pregnancyStatus: .notPregnantOrLactating, smoker: true),
//        v(b(85, 2000), ageRange: l(19), sex: .female, pregnancyStatus: .pregnant, smoker: false),
//        v(b(120, 2000), ageRange: l(19), sex: .female, pregnancyStatus: .lactating, smoker: false),
//    ]
)

public let transFat_who = RDI(
    micro: .transFat,
    unit: .p,
    type: .percentageOfEnergy,
    values: [
        v(u(1)),
    ],
    source: RDISource(abbreviation: "WHO", name: "World Health Organization", url: "https://www.who.int"),
    url: "https://www.who.int/news-room/questions-and-answers/item/nutrition-trans-fat"
)

public let fiber_mayoClinic = RDI(
    micro: .dietaryFiber,
    unit: .g,
    type: .fixed,
    values: [
        v(b(21, 25), sex: .female),
        v(b(30, 38), sex: .male),
    ],
    source: RDISource(name: "Mayo Clinic", url: "https://www.mayoclinic.org/healthy-lifestyle/nutrition-and-healthy-eating/basics/nutrition-basics/hlv-20049477"),
    url: "https://www.mayoclinic.org/healthy-lifestyle/nutrition-and-healthy-eating/in-depth/high-fiber-foods/art-20050948"
)

public let fiber_eatRight = RDI(
    micro: .dietaryFiber,
    unit: .g,
    type: .quantityPerEnergy(1000, .kcal),
    values: [
        v(l(14)),
    ],
    source: RDISource(name: "Academy of Nutrition and Dietetics", url: "https://www.eatright.org"),
    url: "https://www.eatright.org/health/essential-nutrients/carbohydrates/fiber"
)

//MARK: - Helpers

public func v(
    _ bound: Bound = b(0, 0),
    ageRange: Bound? = nil,
    sex: BiologicalSex? = nil,
    pregnancyStatus: PregnancyStatus? = nil,
    smoker: Bool? = nil
) -> RDIValue {
    RDIValue(
        bound: bound,
        ageRange: ageRange,
        biologicalSex: sex,
        pregnancyStatus: pregnancyStatus,
        isSmoker: smoker
    )
}

public func b(_ lower: Double, _ upper: Double) -> Bound {
    Bound(lower: lower, upper: upper)
}

public func l(_ lower: Double) -> Bound {
    Bound(lower: lower)
}

public func u(_ upper: Double) -> Bound {
    Bound(upper: upper)
}
