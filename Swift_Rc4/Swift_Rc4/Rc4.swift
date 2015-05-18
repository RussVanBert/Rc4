import Foundation

class Rc4 {
  func byteArr(str: String) -> [UInt8] {
    var result = [UInt8]()
    for strByte in str.utf8 {
      result.append(strByte)
    }
    
    return result
  }
  
  // decrypt really just calls encrypt. Amazing right?
  func decrypt(data: [UInt8], key: [UInt8]) -> [UInt8] {
    return encrypt(data, key: key)
  }

  func encrypt(data: [UInt8], key: [UInt8]) -> [UInt8] {
    let swappedArray = keyScheduler(key)
    return cipherArray(data, swappedArr: swappedArray)
  }
  
  func keyScheduler(key: [UInt8]) -> [UInt8] {
    let keySwap = initialKeyArrays(key)
    var iS = keySwap.iS
    var iK = keySwap.iK
    var j = 0
    for i in 0..<256 {
      let swapValue: UInt8 = iS[i]
      j = (j + Int(iS[i]) + Int(iK[i])) % 256
      iS[i] = iS[j]
      iS[j] = swapValue
    }
    
    return iS
  }
  
  func initialKeyArrays(keyArr: [UInt8]) -> (iS: [UInt8], iK: [UInt8]) {
    var iS = [UInt8]()
    var iK = [UInt8]()
    let keyLength = keyArr.count
    for i in 0..<256 {
      iS.append(UInt8(i))
      iK.append(keyArr[i % keyLength])
    }
        
    return (iS, iK)
  }
  
  func cipherArray(dataArr: [UInt8], swappedArr: [UInt8]) -> [UInt8] {
    var iPos = 0
    var jPos = 0
    var cipher = dataArr
    var cipherPos = 0
    for cipherPos in 0..<dataArr.count {
      iPos = (iPos + 1) % 256
      var is_i = Int(swappedArr[iPos])
      
      jPos = (jPos + is_i) % 256
      let is_j = Int(swappedArr[jPos])
      
      let swap = swappedArr[(is_i + is_j) % 256]
      
      let ch = dataArr[cipherPos]
      cipher[cipherPos] = ch ^ swap
    }
    
    return cipher
  }
}