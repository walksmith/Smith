import XCTest
@testable import Smith

final class StreakTests: XCTestCase {
    private var archive: Archive!
    
    override func setUp() {
        archive = .init()
        Memory.shared = .init()
        Memory.shared.subs = .init()
    }
    
    func testBasic() {
        let daysAgo12 = Calendar.current.date(byAdding: .day, value: -12, to: .init())!
        let daysAgo8 = Calendar.current.date(byAdding: .day, value: -8, to: .init())!
        let daysAgo7_5 = Calendar.current.date(byAdding: .hour, value: -12, to: Calendar.current.date(byAdding: .day, value: -7, to: .init())!)!
        let daysAgo7 = Calendar.current.date(byAdding: .day, value: -7, to: .init())!
        let daysAgo5 = Calendar.current.date(byAdding: .day, value: -5, to: .init())!
        let daysAgo2 = Calendar.current.date(byAdding: .day, value: -2, to: .init())!
        
        archive.walks = [
            .init(date: daysAgo12, duration: 1),
            .init(date: daysAgo8, duration: 1),
            .init(date: daysAgo7_5, duration: 1),
            .init(date: daysAgo7, duration: 1),
            .init(date: daysAgo5, duration: 1),
            .init(date: daysAgo5, duration: 1),
            .init(date: daysAgo5, duration: 1),
            .init(date: daysAgo5, duration: 1),
            .init(date: daysAgo5, duration: 1),
            .init(date: daysAgo5, duration: 1),
            .init(date: daysAgo5, duration: 1),
            .init(date: daysAgo2, duration: 1)]
        
        XCTAssertEqual(2, archive.streak.maximum)
        XCTAssertEqual(0, archive.streak.current)
        
        archive.walks.append(.init(date: .init(), duration: 1))
        
        XCTAssertEqual(2, archive.streak.maximum)
        XCTAssertEqual(1, archive.streak.current)
    }
}
