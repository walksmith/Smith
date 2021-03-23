import XCTest
@testable import Smith

final class CalendarTests: XCTestCase {
    func testLeadingWeekdays() {
        var calendar = Calendar(identifier: .gregorian)
        calendar.firstWeekday = 1
        XCTAssertEqual(0, calendar.leadingWeekdays(year: 2021, month: 8, day: 1))
        XCTAssertEqual(1, calendar.leadingWeekdays(year: 2021, month: 8, day: 2))
        XCTAssertEqual(2, calendar.leadingWeekdays(year: 2021, month: 8, day: 3))
        XCTAssertEqual(3, calendar.leadingWeekdays(year: 2021, month: 8, day: 4))
        calendar.firstWeekday = 2
        XCTAssertEqual(6, calendar.leadingWeekdays(year: 2021, month: 8, day: 1))
        XCTAssertEqual(0, calendar.leadingWeekdays(year: 2021, month: 8, day: 2))
        XCTAssertEqual(1, calendar.leadingWeekdays(year: 2021, month: 8, day: 3))
        XCTAssertEqual(2, calendar.leadingWeekdays(year: 2021, month: 8, day: 4))
        calendar.firstWeekday = 3
        XCTAssertEqual(5, calendar.leadingWeekdays(year: 2021, month: 8, day: 1))
        XCTAssertEqual(6, calendar.leadingWeekdays(year: 2021, month: 8, day: 2))
        XCTAssertEqual(0, calendar.leadingWeekdays(year: 2021, month: 8, day: 3))
        XCTAssertEqual(1, calendar.leadingWeekdays(year: 2021, month: 8, day: 4))
        calendar.firstWeekday = 4
        XCTAssertEqual(4, calendar.leadingWeekdays(year: 2021, month: 8, day: 1))
        XCTAssertEqual(5, calendar.leadingWeekdays(year: 2021, month: 8, day: 2))
        XCTAssertEqual(6, calendar.leadingWeekdays(year: 2021, month: 8, day: 3))
        XCTAssertEqual(0, calendar.leadingWeekdays(year: 2021, month: 8, day: 4))
    }
}
