import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(AppConfigurationTests.allTests),
        testCase(CGAffineTransformExtensionTests.allTests),
    ]
}
#endif
