import XCTest
@testable import Smith

final class WalkTests: XCTestCase {
    func testEnd() {
        XCTAssertEqual(100,
                       Int(Walk(start: .init(timeIntervalSinceNow: -100), end: .init(timeIntervalSinceNow: -100))
                            .end
                            .duration))
    }
    
    func testEndAfter9Hours() {
        let start = Calendar.current.date(byAdding: .hour, value: -10, to: .init())!
        XCTAssertEqual(Int(start.timeIntervalSince(Calendar.current.date(byAdding: .hour, value: -1, to: start)!)),
                       Int(Walk(start: start, end: start)
                            .end
                            .duration))
    }
    
    func testActive() {
        XCTAssertTrue(Walk().active)
        XCTAssertFalse(Walk(start: .init(timeIntervalSinceNow: -1), end: .init()).active)
    }
}
