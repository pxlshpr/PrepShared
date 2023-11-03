import XCTest
@testable import PrepShared

func assertEqual(_ goal: Goal?, _ other: Goal?) {
    switch (goal, other) {
    case (.some(let goal), .some(let other)):   assertEqual(goal, other)
    case (.none, .some), (.some, .none):        XCTFail()
    case (.none, .none):                        break
    }
}

func assertEqual(_ goal: Goal, _ other: Goal) {
    XCTAssertEqual(goal.type, other.type)
    assertEqual(goal.bound, other.bound)
    assertEqual(goal.calculatedBound, other.calculatedBound)
}

func assertEqual(_ bound: Bound, _ other: Bound) {
    assertEqual(bound.lower, other.lower)
    assertEqual(bound.upper, other.upper)
}

func assertEqual(_ double: Double?, _ other: Double?) {
    switch (double, other) {
    case (.some(let double), .some(let other)): assertEqual(toPlaces: 0, double, other)
    case (.none, .some), (.some, .none):        XCTFail()
    case (.none, .none):                        break
    }
}

func assertEqual(toPlaces places: Int = 2, _ double: Double, _ other: Double) {
    XCTAssertEqual(double.rounded(toPlaces: places), other.rounded(toPlaces: places))
}
