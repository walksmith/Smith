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
        let start = Date(timeIntervalSinceNow: -500)
        archive.walks = [.init(date: start, duration: 300, steps: 123, meters: 345, tiles: 75_000)]
        XCTAssertEqual(300, Int(archive.data.mutating(transform: Archive.init(data:)).walks.first!.duration))
        XCTAssertEqual(start.timestamp, archive.data.mutating(transform: Archive.init(data:)).walks.first!.date.timestamp)
        XCTAssertEqual(123, archive.data.mutating(transform: Archive.init(data:)).walks.first!.steps)
        XCTAssertEqual(345, archive.data.mutating(transform: Archive.init(data:)).walks.first!.meters)
        XCTAssertEqual(75_000, archive.data.mutating(transform: Archive.init(data:)).walks.first!.tiles)
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
    
    func testEnd() {
        let expect = expectation(description: "")
        archive.date = .distantPast
        archive.walks = [.init(date: .init(timeIntervalSinceNow: -10))]
        let date = Date()
        Memory.shared.save.sink {
            XCTAssertEqual(1, $0.walks.count)
            XCTAssertEqual(10, Int($0.walks.first!.duration))
            XCTAssertEqual(Date(timeIntervalSinceNow: -10).timestamp, $0.walks.first!.date.timestamp)
            XCTAssertGreaterThanOrEqual($0.date.timestamp, date.timestamp)
            expect.fulfill()
        }
        .store(in: &subs)
        archive.end()
        waitForExpectations(timeout: 1)
    }
    
    func testStartChallenge() {
        let expect = expectation(description: "")
        archive.date = .distantPast
        let date = Date()
        Memory.shared.save.sink {
            XCTAssertTrue($0.enrolled(.map))
            XCTAssertGreaterThanOrEqual($0.date.timestamp, date.timestamp)
            expect.fulfill()
        }
        .store(in: &subs)
        XCTAssertFalse(archive.enrolled(.map))
        archive.start(.map)
        waitForExpectations(timeout: 1)
    }
    
    func testStopChallenge() {
        let expect = expectation(description: "")
        archive.date = .distantPast
        let date = Date()
        archive.start(.map)
        Memory.shared.save.sink {
            XCTAssertFalse($0.enrolled(.map))
            XCTAssertGreaterThanOrEqual($0.date.timestamp, date.timestamp)
            expect.fulfill()
        }
        .store(in: &subs)
        XCTAssertTrue(archive.enrolled(.map))
        archive.stop(.map)
        waitForExpectations(timeout: 1)
    }
    
    func testWalking() throws {
        if case .none = archive.state {
            archive.start()
            if case let .walking(time) = archive.state {
                XCTAssertGreaterThan(time, 0)
                archive.end()
                if case .none = archive.state {
                    
                } else {
                    XCTFail()
                }
            } else {
                XCTFail()
            }
        } else {
            XCTFail()
        }
    }
}
