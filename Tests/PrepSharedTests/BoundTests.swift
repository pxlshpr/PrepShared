import XCTest
@testable import PrepShared

final class BoundTests: XCTestCase {
    func testBoundSort() throws {
        for testCase in SortTestCases {
            let shuffled = testCase.shuffled()
            let sorted = shuffled.sorted()
            XCTAssertEqual(sorted, testCase)
        }
    }
    
    func testSpansZeroToInfinity() throws {
        for (testCase, bool) in SpansZeroToInfinityTestCases {
            XCTAssertEqual(testCase.spansZeroToInfinity, bool)
        }
    }
}

//MARK: - Test Cases

/// Each case is an array of the sorted bounds
private let SortTestCases: [[Bound]] = [
    [
        b(0, 0.5),
        b(0.5, 1.0),
        b(1, 4),
        b(4, 9),
        b(9, 14),
        b(14, 19),
        l(19)
    ],
    [
        u(0.5),
        b(4, 9),
        l(19)
    ],
]

private let SpansZeroToInfinityTestCases: [([Bound], Bool)] = [
    ([
        b(0, 0.5),
        b(0.5, 1.0),
        b(1, 4),
        b(4, 9),
        b(9, 14),
        b(14, 19),
        l(19)
    ], true),
    
    ([
        u(0.5),
        b(0.5, 1.0),
        b(1, 4),
        b(4, 9),
        b(9, 14),
        b(14, 19),
        l(19)
    ], true),

    ([
        l(0.5),
        b(0.5, 1.0),
        b(1, 4),
        b(4, 9),
        b(9, 14),
        b(14, 19),
        l(19)
    ], false),

    ([
        u(0.5),
        b(0.5, 1.0),
        b(1, 4),
        b(9, 14),
        b(14, 19),
        l(19)
    ], false),
    
    ([
        b(0, 0.5),
        b(0.5, 1.0),
        b(1, 4),
        b(4, 9),
        b(9, 14),
        b(14, 19)
    ], false),
]
