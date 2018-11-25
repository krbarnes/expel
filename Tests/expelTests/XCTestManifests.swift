import XCTest

#if !os(macOS)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(xcconfig_genTests.allTests),
    ]
}
#endif