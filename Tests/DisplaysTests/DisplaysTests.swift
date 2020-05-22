import XCTest
@testable import Displays

final class DisplaysTests: XCTestCase {
    
    func testMain() {
        XCTAssertTrue(Display.main.id == CGMainDisplayID())
    }
    
    func testIsMain() {
        XCTAssertTrue(Display.main.isMain)
        if Display.active.count > 1 {
            for display in Display.active {
                if display != Display.main {
                    XCTAssertFalse(display.isMain)
                }
            }
        }
    }
    
    func testName() {
        for display in Display.active {
            XCTAssertFalse(display.name.isEmpty)
        }
    }
}
