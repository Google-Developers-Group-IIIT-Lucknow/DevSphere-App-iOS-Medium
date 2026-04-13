import Foundation

var totalPass = 0
var totalFail = 0

func pass(_ message: String) {
    totalPass += 1
    print("✅ \(message)")
}

func fail(_ message: String) {
    totalFail += 1
    print("❌ \(message)")
}

func assertEqual<T: Equatable>(_ actual: T, _ expected: T, _ message: String) {
    if actual == expected {
        pass(message)
    } else {
        fail("\(message) — expected \(expected), got \(actual)")
    }
}

func assertTrue(_ condition: Bool, _ message: String) {
    if condition {
        pass(message)
    } else {
        fail(message)
    }
}

func assertFalse(_ condition: Bool, _ message: String) {
    assertTrue(!condition, message)
}

func assertNotNil(_ value: Any?, _ message: String) {
    if value != nil {
        pass(message)
    } else {
        fail(message)
    }
}

func runAllTests() {
    testExchangeRateResponseDecoding()
    testLiveExchangeRateApiResponse()
    testLiveCurrencyConversion()
    testFetchExchangeRatesCompletes()
}

runAllTests()

print("")
print("Total: \(totalPass) passed, \(totalFail) failed")
exit(totalFail > 0 ? 1 : 0)
