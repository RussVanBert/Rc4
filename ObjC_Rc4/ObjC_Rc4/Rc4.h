#import <Foundation/Foundation.h>

@interface Rc4 : NSObject

+ (NSArray *) byteArr:(NSString *)str;

+ (NSArray *) decrypt:(NSArray *)data forKey:(NSArray *)key;
+ (NSArray *) encrypt:(NSArray *)data forKey:(NSArray *)key;

@end