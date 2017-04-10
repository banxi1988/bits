import Foundation
import XCTest
@testable import Bits

class BytesTests: XCTestCase {
    static var allTests = [
        ("testStringError", testStringError),
        ("testPatternMatch", testPatternMatch),
        ("testPatternArrayMatch", testPatternArrayMatch),
        ("testBytesSlicePatternMatching", testBytesSlicePatternMatching),
        ("testEasyAppend", testEasyAppend),
        ("testHexInt", testHexInt),
        ("testDecimalInt", testDecimalInt),
        ("testDecimalIntError", testDecimalIntError),
        ("testStringConvertible", testStringConvertible),
        ("testDataConvertible", testDataConvertible),
    ]

    func testStringError() {
        // ✨ = [226, 156, 168]
        let bytes: Bytes = [226, 156]
        XCTAssertEqual(bytes.makeString(), "")
    }

    func testPatternMatch() {
        switch [Byte.a] {
        case [.a]:
            break
        default:
            XCTFail("Pattern match failed.")
        }
    }

    func testPatternArrayMatch() {
        switch Byte.a {
        case [Byte.a, Byte.f]:
            break
        default:
            XCTFail("Pattern match failed.")
        }
    }

    func testBytesSlicePatternMatching() {
        let arr: Bytes = [1, 2, 3]
        switch arr[0...1] {
        case [3, 4]:
            XCTFail()
        case [1, 2]:
            break
        default:
            XCTFail()
        }

        switch arr[1...2] {
        case arr:
            XCTFail()
        default:
            break
        }
    }

    func testEasyAppend() {
        var bytes: Bytes = [0x00]
        bytes += 0x42

        XCTAssertEqual(bytes, [0x00, 0x42])

        bytes += BytesSlice(arrayLiteral: 0x55, 0x6F)
        XCTAssertEqual(bytes, [0x00, 0x42, 0x55, 0x6F])
    }

    func testHexInt() {
        XCTAssertEqual("aBf89".makeBytes().hexInt, 704393)
    }

    func testDecimalInt() {
        let test = "1337"
        XCTAssertEqual(test.makeBytes().decimalInt, 1337)
    }

    func testDecimalIntError() {
        let test = "13ferret37"
        XCTAssertEqual(test.makeBytes().decimalInt, nil)
    }

    func testStringConvertible() throws {
        let bytes: Bytes = [0x64, 0x65]
        let string = String(bytes: bytes)
        XCTAssertEqual(string.makeBytes(), bytes)
    }

    func testDataConvertible() throws {
        let bytes: Bytes = [0x64, 0x65]
        let data = Data(bytes: bytes)
        XCTAssertEqual(data.makeBytes(), bytes)
    }
    
    func testStringPerformance() {
        let bytes = Bytes(repeating: 65, count: 4_194_304)
        measure {
            _ = bytes.makeString()
        }
    }
}
