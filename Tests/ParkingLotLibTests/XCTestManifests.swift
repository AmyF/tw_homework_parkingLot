import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(ParkingLotTests.allTests),
        testCase(RegularParkingBoyTests.allTests),
    ]
}
#endif
