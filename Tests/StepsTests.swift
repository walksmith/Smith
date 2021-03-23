import XCTest
@testable import Smith

final class StepsTests: XCTestCase {
    private var archive: Archive!
    
    override func setUp() {
        archive = .init()
        Memory.shared = .init()
        Memory.shared.subs = .init()
    }
    
    func testEmpty() {
        XCTAssertEqual(0, archive.steps)
    }
    
    func testMax() {
        archive.walks.append(.init(date: .init(), steps: 1))
        XCTAssertEqual(1, archive.steps)
        archive.walks.append(.init(date: .init(), steps: 5))
        XCTAssertEqual(5, archive.steps)
        archive.walks.append(.init(date: .init(), steps: 3))
        XCTAssertEqual(5, archive.steps)
    }
}
