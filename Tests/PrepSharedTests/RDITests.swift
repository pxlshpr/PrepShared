import XCTest
@testable import PrepShared

final class RDITests: XCTestCase {
    func testRDI() throws {
        for testCase in CalculatedBoundsTestCases {
            let bound = testCase.rdi.bound(
                params: testCase.params,
                energyInKcal: testCase.energyInKcal
            )
            XCTAssertEqual(bound, testCase.expectedBound)
        }
    }
    
    func testHasAllParamCombos() throws {
        for (bound, hasAllParamCombos) in HasAllParamCombosTestCases {
            XCTAssertEqual(bound.hasAllParamCombos, hasAllParamCombos)
        }
    }
}

//MARK: - Test Cases

private let HasAllParamCombosTestCases: [([RDIValue], Bool)] = [
    (vitaminC_nih.values, true),
    (transFat_who.values, true),
    (fiber_mayoClinic.values, true),
    (fiber_eatRight.values, true),
    
    ([
        v(b(21, 25), gender: .female),
        v(b(30, 38), gender: .female),
    ], false),
    
    ([
        v(l(40), ageRange: b(0, 0.5)),
        v(l(50), ageRange: b(0.5, 1.0)),
        v(b(15, 400), ageRange: b(1, 4)),
        v(b(25, 650), ageRange: b(4, 9)),
        v(b(45, 1200), ageRange: b(9, 14)),
        v(b(75, 1800), ageRange: b(14, 19), gender: .male),
        v(b(65, 1800), ageRange: b(14, 19), gender: .female, pregnancyStatus: .notPregnantOrLactating),
        v(b(80, 1800), ageRange: b(14, 19), gender: .female, pregnancyStatus: .pregnant),
        v(b(115, 1800), ageRange: b(14, 19), gender: .female, pregnancyStatus: .lactating),
        v(b(90, 2000), ageRange: l(19), gender: .male, smoker: false),
        v(b(75, 2000), ageRange: l(19), gender: .female, pregnancyStatus: .notPregnantOrLactating, smoker: false),
        v(b(110, 2000), ageRange: l(19), gender: .female, pregnancyStatus: .notPregnantOrLactating, smoker: true),
        v(b(85, 2000), ageRange: l(19), gender: .female, pregnancyStatus: .pregnant, smoker: false),
        v(b(120, 2000), ageRange: l(19), gender: .female, pregnancyStatus: .lactating, smoker: false),
    ], false)
]

private let CalculatedBoundsTestCases: [RDITestCase] = [
    .init(
        rdi: fiber_eatRight,
        energyInKcal: 2000,
        expectedBound: l(28)
    ),
    .init(
        rdi: fiber_mayoClinic,
        params: .init(gender: .male),
        expectedBound: b(30, 38)
    ),
    .init(
        rdi: fiber_mayoClinic,
        expectedBound: nil /// no gender so we're unable to infer this
    ),
    .init(
        rdi: vitaminC_nih,
        params: .init(age: 36, gender: .male, isSmoker: false),
        expectedBound: b(90, 2000)
    ),
    .init(
        rdi: vitaminC_nih,
        params: .init(age: 36, gender: .male),
        expectedBound: nil /// smoking status is required
    ),
    .init(
        rdi: vitaminC_nih,
        params: .init(age: 17, gender: .female, pregnancyStatus: .lactating),
        expectedBound: b(115, 1800)
    ),
]

struct RDITestCase {
    let rdi: RDI
    let params: RDIParams
    let energyInKcal: Double?
    let expectedBound: Bound?
    
    init(
        rdi: RDI,
        params: RDIParams = .init(),
        energyInKcal: Double? = nil,
        expectedBound: Bound?
    ) {
        self.rdi = rdi
        self.params = params
        self.energyInKcal = energyInKcal
        self.expectedBound = expectedBound
    }
}
