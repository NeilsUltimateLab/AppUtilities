import XCTest
@testable import AppConfiguration

final class AppConfigurationTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(AppConfiguration().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
