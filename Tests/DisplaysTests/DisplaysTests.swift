import XCTest
@testable import Displays

final class DisplaysTests: XCTestCase {
    
    func testMain() {
        XCTAssertTrue(Display.main.id == CGMainDisplayID())
    }
}
