import XCTest
@testable import PrepShared

final class RDITests: XCTestCase {
    func testRDI() throws {
        for testCase in testCases {
            let bound = testCase.dailyValue.bound(
                params: testCase.params,
                energyInKcal: testCase.energyInKcal
            )
            XCTAssertEqual(bound, testCase.expectedBound)
        }
    }
}

//MARK: - Test Cases

let testCases: [RDITestCase] = [
    .init(
        dailyValue: fiber_eatRight,
        energyInKcal: 2000,
        expectedBound: l(28)
    ),
    .init(
        dailyValue: fiber_mayoClinic,
        params: .init(gender: .male),
        expectedBound: b(30, 38)
    ),
    .init(
        dailyValue: fiber_mayoClinic,
        expectedBound: nil /// no gender so we're unable to infer this
    ),
    .init(
        dailyValue: vitaminC_nih,
        params: .init(age: 36, gender: .male, isSmoker: false),
        expectedBound: b(90, 2000)
    ),
    .init(
        dailyValue: vitaminC_nih,
        params: .init(age: 36, gender: .male),
        expectedBound: nil /// smoking status is required
    ),
    .init(
        dailyValue: vitaminC_nih,
        params: .init(age: 17, gender: .female, pregnancyStatus: .lactating),
        expectedBound: b(115, 1800)
    ),
]

struct RDITestCase {
    let dailyValue: RDI
    let params: RDIParams
    let energyInKcal: Double?
    let expectedBound: Bound?
    
    init(
        dailyValue: RDI,
        params: RDIParams = .init(),
        energyInKcal: Double? = nil,
        expectedBound: Bound?
    ) {
        self.dailyValue = dailyValue
        self.params = params
        self.energyInKcal = energyInKcal
        self.expectedBound = expectedBound
    }
}
