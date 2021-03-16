import XCTest
@testable import Smith

final class SmithTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(Smith().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
