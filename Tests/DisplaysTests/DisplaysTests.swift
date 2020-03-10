import XCTest
@testable import Displays

final class DisplaysTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(Displays().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
