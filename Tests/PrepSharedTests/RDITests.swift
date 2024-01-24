import XCTest
@testable import PrepShared

final class RDITests: XCTestCase {
    func testCalculateBounds() throws {
        for testCase in CalculateBoundsTestCases {
            let bound = testCase.rdi.calculateBound(
                params: testCase.params,
                energyInKcal: testCase.energyInKcal
            )
            XCTAssertEqual(bound, testCase.expectedBound)
        }
    }
    
    func testValidate() throws {
        for (rdi, expected) in ValidateTestCases {
            var formValues = rdi
                .values
                .map({ RDIFormValue(value: $0) })
            let error = formValues.validateAndSetErrors()
            
            XCTAssertEqual(error, expected)
        }
    }

    func testSanitizeValues() throws {
        for (array, expected) in SanitizeTestCases {
            XCTAssertEqual(array.sanitized(), expected)
        }
    }
    
    func testIsValidAfterAddingValue() throws {
        for (array, value, expected) in IsValidAfterAddingValueTestCases {
            XCTAssertEqual(array.errorAfterAdding(value) == nil, expected)
        }
    }
}

//MARK: - Test Cases
private let IsValidAfterAddingValueTestCases: [([RDIValue], RDIValue, Bool)] = [
    (
        [v(sex: .female, smoker: true)]
            .sanitized(),
        v(sex: .female, smoker: false),
        true
    ),
    (
        [v(sex: .female)]
            .sanitized(),
        v(),
        false
    ),
    (
        [v(sex: .female)]
            .sanitized(),
        v(ageRange: b(10, 20)),
        true
    ),
    (
        [v(sex: .female)]
            .sanitized(),
        v(sex: .female),
        false
    ),
    (
        [v(sex: .female, smoker: true)]
            .sanitized(),
        v(sex: .female),
        false
    ),
    (
        [v(sex: .female)]
            .sanitized(),
        v(sex: .male),
        true
    ),
    (
        [v(sex: .female, smoker: true)]
            .sanitized(),
        v(sex: .female, smoker: true),
        false
    )
]


private let ValidateTestCases: [(RDI, RDIError?)] = [
    (vitaminC_nih, nil),
    (transFat_who, nil),
    (fiber_mayoClinic, nil),
    (fiber_eatRight, nil),
    (
        RDI(
            micro: .dietaryFiber,
            unit: .g,
            type: .fixed,
            values: [
                v(b(21, 25), sex: .female),
                v(b(30, 38), sex: .female),
            ],
            source: .init(name: "NIH"),
            url: "https://ods.od.nih.gov/factsheets/VitaminC-Consumer/"
        ), .value(.duplicate)
    ),
    
    (
        RDI(
            micro: .vitaminC_ascorbicAcid,
            unit: .mg,
            type: .fixed,
            values: [
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
                v(b(75, 2000), ageRange: l(19), sex: .female, pregnancyStatus: .notPregnantOrLactating, smoker: false),
                v(b(110, 2000), ageRange: l(19), sex: .female, pregnancyStatus: .notPregnantOrLactating, smoker: true),
                v(b(85, 2000), ageRange: l(19), sex: .female, pregnancyStatus: .pregnant, smoker: false),
                v(b(120, 2000), ageRange: l(19), sex: .female, pregnancyStatus: .lactating, smoker: false),
            ],
            source: .init(name: "NIH"),
            url: "https://ods.od.nih.gov/factsheets/VitaminC-Consumer/"
        ), .incompleteValues
    )
]

private let CalculateBoundsTestCases: [RDITestCase] = [
    .init(
        rdi: fiber_eatRight,
        energyInKcal: 2000,
        expectedBound: l(28)
    ),
    .init(
        rdi: fiber_mayoClinic,
        params: .init(sex: .male),
        expectedBound: b(30, 38)
    ),
    .init(
        rdi: fiber_mayoClinic,
        expectedBound: nil /// no sex so we're unable to infer this
    ),
    .init(
        rdi: vitaminC_nih,
        params: .init(age: 36, sex: .male, isSmoker: false),
        expectedBound: b(90, 2000)
    ),
    .init(
        rdi: vitaminC_nih,
        params: .init(age: 36, sex: .male),
        expectedBound: nil /// smoking status is required
    ),
    .init(
        rdi: vitaminC_nih,
        params: .init(age: 17, sex: .female, pregnancyStatus: .lactating),
        expectedBound: b(115, 1800)
    ),
]

private let SanitizeTestCases: [([RDIValue], [RDIValue])] = [
    ([v(sex: .notSet)], [v()])
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
