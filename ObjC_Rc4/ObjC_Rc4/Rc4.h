#import <Foundation/Foundation.h>

@interface Rc4 : NSObject

+ (void)byteArr:(UInt8 *)array forString:(NSString *)string;

+ (void)decrypt:(UInt8 *)data cipher:(UInt8 *)cipher cipherLength:(int)cipherLength key:(UInt8 *)key keyLength:(int)keyLength;
+ (void)encrypt:(UInt8 *)cipher data:(UInt8 *)data dataLength:(int)dataLength key:(UInt8 *)key keyLength:(int)keyLength;

@end