import XCTest
@testable import PrepShared

final class StringTests: XCTestCase {
    func testSanitizedDouble() throws {
        let testCases: [(String, String)] = [
            
            ("2", "2"),
            ("2.35", "2.35"),
            ("2.", "2."),
            
            (".", "."),
            (".5", ".5"),
            (".512", ".512"),
            ("0.5", "0.5"),
            
            ("2.35.", "2.35"),
            ("2.35.25", "2.35"),
            ("2.3a5", "`2.3"),
        ]
        
        for testCase in testCases {
            XCTAssertEqual(testCase.0.sanitizedDouble, testCase.1)
        }
    }
}
