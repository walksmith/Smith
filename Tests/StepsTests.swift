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
        XCTAssertEqual(0, archive.maxSteps)
        XCTAssertTrue(archive.steps.isEmpty)
    }
    
    func testMax() {
        archive.walks.append(.init(date: .init(), steps: 1))
        XCTAssertEqual(1, archive.maxSteps)
        archive.walks.append(.init(date: .init(), steps: 5))
        XCTAssertEqual(5, archive.maxSteps)
        archive.walks.append(.init(date: .init(), steps: 3))
        XCTAssertEqual(5, archive.maxSteps)
    }
    
    func testStepsMax10() {
        archive.walks = [
            .init(date: .init(), duration: 1, steps: 3),
            .init(date: .init(), duration: 1, steps: 4),
            .init(date: .init(), duration: 1, steps: 5),
            .init(date: .init(), duration: 1, steps: 2),
            .init(date: .init(), duration: 1, steps: 6),
            .init(date: .init(), duration: 1, steps: 7),
            .init(date: .init(), duration: 1, steps: 8),
            .init(date: .init(), duration: 1, steps: 4),
            .init(date: .init(), duration: 1, steps: 10),
            .init(date: .init(), duration: 1, steps: 0),
            .init(date: .init(), duration: 1, steps: 1),
            .init(date: .init(), duration: 1, steps: 5),
            .init(date: .init(), duration: 1, steps: 3)]
        XCTAssertEqual([
                        0.2,
                        0.6,
                        0.7,
                        0.8,
                        0.4,
                        1,
                        0,
                        0.1,
                        0.5,
                        0.3], archive.steps)
    }
    
    func testStepsZero() {
        archive.walks = [
            .init(date: .init(), duration: 1, steps: 0),
            .init(date: .init(), duration: 1, steps: 0),
            .init(date: .init(), duration: 1, steps: 0)]
        XCTAssertEqual([
                        0,
                        0,
                        0], archive.steps)
    }
}
