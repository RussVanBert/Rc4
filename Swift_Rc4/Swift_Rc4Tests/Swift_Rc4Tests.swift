import UIKit
import XCTest

class Swift_Rc4Tests: XCTestCase {

  func testRc4EncryptsPedia() {
    // arrange
    let keyString  = "Wiki"
    let dataString = "pedia"
    let expected: [UInt8] = [0x10, 0x21, 0xbf, 0x04, 0x20]
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
    let data: [UInt8] = [0x10, 0x21, 0xbf, 0x04, 0x20]
    let expectedString = "pedia"
    let rc4 = Rc4()
    let key = rc4.byteArr(keyString)
    
    // act
    let result = rc4.decrypt(data, key: key)
    
    // assert
    let resultString = stringFromBytes(result)
    XCTAssert(resultString == expectedString, "result didn't match expected")
  }

  func stringFromBytes(bytes: [UInt8]) -> String {
    return NSString(bytes: bytes, length: bytes.count, encoding: NSASCIIStringEncoding)! as String
  }

  func testPerformanceRc4EncryptLarge() {
    // arrange
    let keyString  = "SomeKeyForMyString"
    let dataString = contentsOf("large.txt")
    print("data length is \(dataString.lengthOfBytesUsingEncoding(NSUTF8StringEncoding)) bytes")
    let rc4 = Rc4()
    let data = rc4.byteArr(dataString)
    let key  = rc4.byteArr(keyString)

    self.measureBlock() {
      // act
      let result = rc4.encrypt(data, key: key)

      // assert? not really, but you can see in the console it executes ten times
      print("first byte encrypted to: \(result.first)")
    }
  }

  func contentsOf(fileName: String) -> String {
    let testBundle = NSBundle(forClass: self.dynamicType)
    let path = testBundle.pathForResource(fileName, ofType: nil)
    if (path == nil) {
      XCTFail("cannot find the file")
    }
    
    let err = NSErrorPointer()
    let dataString: NSString?
    do {
      dataString = try NSString(contentsOfFile: path!, encoding: NSUTF8StringEncoding)
    } catch let error as NSError {
      err.memory = error
      dataString = nil
      print("error reading file: \(err.debugDescription)")
      XCTFail("unable to read the contents of the file")
    }
    
    return dataString! as String
  }
}
