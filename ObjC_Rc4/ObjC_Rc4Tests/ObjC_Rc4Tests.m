#import <XCTest/XCTest.h>
#import "Rc4.h"

#define ARRAY_LENGTH(x)  (sizeof(x) / sizeof(x[0]))

@interface Rc4Tests : XCTestCase
@end

@implementation Rc4Tests

- (void)testRc4EncryptsPedia {
  // arrange
  NSString *key = @"Wiki";
  NSString *data = @"pedia";
  NSArray  *keyHex  = [Rc4 byteArr:key];
  NSArray  *dataHex = [Rc4 byteArr:data];
  UniChar  expectedCipher[] = { 0x10, 0x21, 0xbf, 0x04, 0x20 };
  
  // act
  NSArray *resultCipher = [Rc4 encrypt:dataHex forKey:keyHex];
  
  // assert
  NSUInteger len = resultCipher.count;
  for (int i = 0; i < len; i++) {
    UniChar expected = expectedCipher[i];
    UniChar result = [resultCipher[i] integerValue];
    XCTAssert(result == expected, @"result didn't match expected");
  }
}

- (void)testRc4DecryptsPedia {
  // arrange
  NSString *key = @"Wiki";
  UniChar  cipher[] = { 0x10, 0x21, 0xbf, 0x04, 0x20 };
  NSString *data = [NSString stringWithCharacters:cipher length:ARRAY_LENGTH(cipher)];
  NSArray  *keyHex  = [Rc4 byteArr:key];
  NSArray  *dataHex = [Rc4 byteArr:data];
  NSString *expectedString = @"pedia";
  
  // act
  NSArray *resultString = [Rc4 encrypt:dataHex forKey:keyHex];
  
  // assert
  for (int i = 0; i < resultString.count; i++) {
    UniChar expected = [expectedString characterAtIndex:i];
    UniChar result = [resultString[i] charValue];
    XCTAssert(result == expected, @"result didn't match expected");
  }
}

- (void)testRc4EncryptPerformance {
  // arrange
  NSString *key = @"SomeKeyForMyString";
  NSBundle *testBundle = [NSBundle bundleForClass:[self class]];
  BOOL     small_test = NO; // or YES?
  NSString *path = small_test ? @"small.txt" : @"large.txt";
  NSError  *err;
  NSString *data = [NSString stringWithContentsOfFile:[testBundle pathForResource:path ofType:nil]
                                             encoding:NSUTF8StringEncoding
                                                error:&err];
  NSArray *keyHex  = [Rc4 byteArr:key];
  NSArray *dataHex = [Rc4 byteArr:data];
  
  if (err) {
    NSLog(@"err: %@", err);
    XCTFail(@"error reading the file");
  }
  
  NSLog(@"data length is %lu bytes", (unsigned long)data.length);
  
  [self measureBlock:^{
    // act
    NSArray *cipher = [Rc4 encrypt:dataHex forKey:keyHex];
    
    // assert? not really, but you can see in the console it executes ten times
    NSLog(@"first byte encrypted to: %@", cipher[0]);
  }];
}

@end
