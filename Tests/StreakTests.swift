import XCTest
@testable import Smith

final class StreakTests: XCTestCase {
    private var archive: Archive!
    
    override func setUp() {
        archive = .init()
        Memory.shared = .init()
        Memory.shared.subs = .init()
    }
    
    func testEmpty() {
        XCTAssertNotNil(archive.streak)
    }
    
    func testStreak() {
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
    
    func testCalendar() {
        let monday = Calendar.current.date(from: .init(year: 2021, month: 3, day: 15))!
        let wednesday = Calendar.current.date(from: .init(year: 2021, month: 3, day: 17))!
        let thursday = Calendar.current.date(from: .init(year: 2021, month: 3, day: 18))!
        let saturday = Calendar.current.date(from: .init(year: 2021, month: 3, day: 20))!
        
        archive.walks = [
            .init(date: monday, duration: 1),
            .init(date: wednesday, duration: 1),
            .init(date: thursday, duration: 1),
            .init(date: saturday, duration: 1),
            .init(date: saturday, duration: 1)]
        
        XCTAssertEqual([
                        Year(value: 2021,
                             months: [
                                .init(value: 3, days: [
                                    [.init(value: 1, hit: false),
                                     .init(value: 2, hit: false),
                                     .init(value: 3, hit: false),
                                     .init(value: 4, hit: false),
                                     .init(value: 5, hit: false),
                                     .init(value: 6, hit: false),
                                     .init(value: 7, hit: false)],
                                    [.init(value: 8, hit: false),
                                     .init(value: 9, hit: false),
                                     .init(value: 10, hit: false),
                                     .init(value: 11, hit: false),
                                     .init(value: 12, hit: false),
                                     .init(value: 13, hit: false),
                                     .init(value: 14, hit: false)],
                                    [.init(value: 15, hit: true),
                                     .init(value: 16, hit: false),
                                     .init(value: 17, hit: true),
                                     .init(value: 18, hit: true),
                                     .init(value: 19, hit: false),
                                     .init(value: 20, hit: true),
                                     .init(value: 21, hit: false)],
                                    [.init(value: 22, hit: false),
                                     .init(value: 23, hit: false),
                                     .init(value: 24, hit: false),
                                     .init(value: 25, hit: false),
                                     .init(value: 26, hit: false),
                                     .init(value: 27, hit: false),
                                     .init(value: 28, hit: false)],
                                     [.init(value: 29, hit: false),
                                     .init(value: 30, hit: false),
                                     .init(value: 31, hit: false)]
                                ])])], archive.calendar)
    }
}
