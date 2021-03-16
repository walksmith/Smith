import XCTest
import Combine
@testable import Smith

final class ArchiveTests: XCTestCase {
    private var archive: Archive!
    private var subs = Set<AnyCancellable>()
    
    override func setUp() {
        archive = .init()
        Memory.shared = .init()
        Memory.shared.subs = .init()
    }
    
    func testDate() {
        let date0 = Date()
        archive = .init()
        XCTAssertGreaterThanOrEqual(archive.data.mutating(transform: Archive.init(data:)).date.timestamp, date0.timestamp)
        let date1 = Date(timeIntervalSince1970: 1)
        archive.date = date1
        XCTAssertGreaterThanOrEqual(archive.data.mutating(transform: Archive.init(data:)).date.timestamp, date1.timestamp)
    }
    
    func testChallenges() {
        archive.challenges.insert(.steps)
        archive.challenges.insert(.map)
        XCTAssertEqual([.map, .steps], archive.data.mutating(transform: Archive.init(data:)).challenges)
    }
    
    func testWalks() {
        archive.walks = [.init(start: .init(timeIntervalSinceNow: -500), end: .init())]
        XCTAssertEqual(500, Int(archive.data.mutating(transform: Archive.init(data:)).walks.first!.duration))
    }
    
    func testStart() {
        let expect = expectation(description: "")
        archive.date = .distantPast
        let date = Date()
        Memory.shared.save.sink {
            XCTAssertEqual(1, $0.walks.count)
            XCTAssertEqual(0, $0.walks.first?.duration)
            XCTAssertGreaterThanOrEqual($0.walks.first!.date.timestamp, date.timestamp)
            XCTAssertGreaterThanOrEqual($0.date.timestamp, date.timestamp)
            expect.fulfill()
        }
        .store(in: &subs)
        archive.start()
        waitForExpectations(timeout: 1)
    }
}
