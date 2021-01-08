import XCTest

import XcodeGenCLITests

var tests = [XCTestCaseEntry]()
tests += XcodeGenCLITests.allTests()
XCTMain(tests)
