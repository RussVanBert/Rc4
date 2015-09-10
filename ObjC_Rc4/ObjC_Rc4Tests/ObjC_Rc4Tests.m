#import <XCTest/XCTest.h>
#import "Rc4.h"

#define ARRAY_LENGTH(x)  (sizeof(x) / sizeof(x[0]))

@interface Rc4Tests : XCTestCase
@end

@implementation Rc4Tests

- (void)testRc4EncryptsPedia {
  NSString *keyString = @"Wiki";
  NSString *dataString = @"pedia";
  UInt8 expectedCipher[] = { 0x10, 0x21, 0xbf, 0x04, 0x20 };

  int dataLength = (int)dataString.length;
  int keyLength = (int)keyString.length;
  UInt8 *data = malloc(dataLength);
  UInt8 *key = malloc(keyLength);
  UInt8 *cipher = malloc(dataLength);
  [Rc4 byteArr:key forString:keyString];
  [Rc4 byteArr:data forString:dataString];

  [Rc4 encrypt:cipher data:data dataLength:dataLength key:key keyLength:keyLength];
  
  for (int i = 0; i < dataLength; i++) {
    XCTAssert(cipher[i] == expectedCipher[i], "cipher should match");
  }
    
  free(data);
  free(key);
  free(cipher);
}

- (void)testRc4DecryptsPedia {
  // arrange
  NSString *keyString = @"Wiki";
  UInt8  cipher[] = { 0x10, 0x21, 0xbf, 0x04, 0x20 };
  NSString *expectedString = @"pedia";
  
  int cipherLength = ARRAY_LENGTH(cipher);
  int keyLength = (int)keyString.length;
  UInt8 *key = malloc(keyLength);
  UInt8 *decipher = malloc(cipherLength + 1);
  [Rc4 byteArr:key forString:keyString];
  
  // act
  [Rc4 decrypt:decipher cipher:cipher cipherLength:cipherLength key:key keyLength:keyLength];
  
  // assert
  decipher[5] = '\0';
  NSString *resultString = [NSString stringWithUTF8String:(char *)decipher ];
  XCTAssert([resultString isEqualToString:expectedString], @"result didn't match expected");
  free(decipher);
}

- (void)testRc4EncryptPerformance {
  // arrange
  NSString *keyString = @"SomeKeyForMyString";
  BOOL     small_test = NO; // or YES?
  NSString *path = small_test ? @"small.txt" : @"large.txt";
  NSString *dataString = [self contentsOf:path];
  
  int dataLength = (int)dataString.length;
  int keyLength = (int)keyString.length;
  NSLog(@"data length is %d bytes", dataLength);
  
  UInt8 *data = malloc(dataLength);
  UInt8 *key = malloc(keyLength);
  UInt8 *cipher = malloc(dataLength);
  [Rc4 byteArr:key forString:keyString];
  [Rc4 byteArr:data forString:dataString];

  [self measureBlock:^{
    // act
    [Rc4 encrypt:cipher data:data dataLength:dataLength key:key keyLength:keyLength];
    
    // assert? not really, but you can see in the console it executes ten times
    NSLog(@"first byte encrypted to: %d", cipher[0]);
  }];

  free(data);
  free(key);
  free(cipher);
}

- (NSString *)contentsOf:(NSString *)path {
  NSBundle *testBundle = [NSBundle bundleForClass:[self class]];
  NSError  *err;
  NSString *fileString = [NSString stringWithContentsOfFile:[testBundle pathForResource:path ofType:nil]
                                                   encoding:NSUTF8StringEncoding
                                                      error:&err];
  if (err) {
    NSLog(@"err: %@", err);
    XCTFail(@"error reading the file");
  }
  
  return fileString;
}

@end
