import XCTest

import xcconfig_genTests

var tests = [XCTestCaseEntry]()
tests += xcconfig_genTests.allTests()
XCTMain(tests)