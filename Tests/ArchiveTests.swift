import XCTest
@testable import Smith

final class ArchiveTests: XCTestCase {
    private var archive: Archive!
    
    override func setUp() {
        archive = .init()
        Memory.shared = .init()
        Memory.shared.subs = .init()
    }
    
    func testDate() {
        let date0 = Date()
        archive = .init()
        XCTAssertGreaterThanOrEqual(date0.timestamp, archive.data.mutating(transform: Archive.init(data:)).date.timestamp)
        let date1 = Date(timeIntervalSince1970: 1)
        archive.date = date1
        XCTAssertGreaterThanOrEqual(date1.timestamp, archive.data.mutating(transform: Archive.init(data:)).date.timestamp)
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
}
