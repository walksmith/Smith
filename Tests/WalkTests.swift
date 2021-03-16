import XCTest
@testable import Smith

final class WalkTests: XCTestCase {
    func testEnd() {
        XCTAssertEqual(100,
                       Int(Walk(start: .init(timeIntervalSinceNow: -100), end: .init(timeIntervalSinceNow: -100))
                            .end
                            .duration))
    }
}
