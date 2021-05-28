import UIKit
import XCTest

class Swift_Rc4Tests: XCTestCase {

  func testRc4EncryptsPedia() {
    // arrange
    let keyString  = "Wiki"
    let dataString = "pediapediapedia"
    let expected: [UInt8] = [0x10, 0x21, 0xbf, 0x04, 0x20,
                             0xc7, 0x8d, 0x83, 0xcd, 0xb7,
                             0x89, 0x9e, 0xb0, 0x2b, 0xe2]
    let rc4 = Rc4()
    let data = rc4.byteArr(dataString)
    let key  = rc4.byteArr(keyString)
    
    // act
    let result = rc4.encrypt(data, key: key)
    
    // assert
    for i in 0..<result.count {
      XCTAssert(result[i] == expected[i], "result didn't match expected")
    }
  }

  func testRc4DecryptsPedia() {
    // arrange
    let keyString  = "Wiki"
    let data: [UInt8] = [0x10, 0x21, 0xbf, 0x04, 0x20,
                         0xc7, 0x8d, 0x83, 0xcd, 0xb7,
                         0x89, 0x9e, 0xb0, 0x2b, 0xe2]
    let expectedString = "pediapediapedia"
    let rc4 = Rc4()
    let key = rc4.byteArr(keyString)
    
    // act
    let result = rc4.decrypt(data, key: key)
    
    // assert
    let resultString = stringFromBytes(result)
    XCTAssert(resultString == expectedString, "result didn't match expected")
  }

  func stringFromBytes(_ bytes: [UInt8]) -> String {
    return NSString(bytes: bytes, length: bytes.count, encoding: String.Encoding.ascii.rawValue)! as String
  }

  func testPerformanceRc4EncryptLarge() {
    // arrange
    let keyString  = "SomeKeyForMyString"
    let dataString = contentsOf("large.txt")
    print("data length is \(dataString.lengthOfBytes(using: String.Encoding.utf8)) bytes")
    let rc4 = Rc4()
    let data = rc4.byteArr(dataString)
    let key  = rc4.byteArr(keyString)

    self.measure() {
      // act
      let result = rc4.encrypt(data, key: key)

      // assert? not really, but you can see in the console it executes ten times
        print("first byte encrypted to: \(String(describing: result.first))")
    }
  }

  func contentsOf(_ fileName: String) -> String {
    let testBundle = Bundle(for: type(of: self))
    if let path = testBundle.path(forResource: fileName, ofType: nil) {
      do {
        let dataString = try NSString(contentsOfFile: path, encoding: String.Encoding.utf8.rawValue)
        return dataString as String
      } catch let error as NSError {
        XCTFail("unable to read the contents of the file: \(error.debugDescription)")
      }
    } else {
      XCTFail("cannot find the file: \(fileName)")
    }
    
    return ""
  }
}
