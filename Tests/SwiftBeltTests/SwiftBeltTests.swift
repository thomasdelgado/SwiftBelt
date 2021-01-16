import XCTest
@testable import SwiftBelt

final class SwiftBeltTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(SwiftBelt().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
