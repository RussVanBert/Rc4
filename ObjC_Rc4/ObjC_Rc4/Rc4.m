#import "Rc4.h"

@implementation Rc4

+ (NSArray *) byteArr:(NSString *)str {
  NSMutableArray *result = [NSMutableArray arrayWithCapacity:str.length];
  for (int i = 0; i < str.length; i++) {
    [result addObject:[NSNumber numberWithChar:[str characterAtIndex:i]]];
  }
  
  return result;
}

// decrypt really just calls encrypt. Amazing right?
+ (NSArray *) decrypt:(NSArray *)data forKey:(NSArray *)key {
  return [self encrypt:data forKey:key];
}

+ (NSArray *) encrypt:(NSArray *)data forKey:(NSArray *)key {
  NSMutableArray *iS = [[NSMutableArray alloc] initWithCapacity:256];
  NSMutableArray *iK = [[NSMutableArray alloc] initWithCapacity:256];
  
  NSUInteger keyLength = key.count;
  int i;
  for (i = 0; i < 256; i++) {
    [iS addObject:[NSNumber numberWithInt:i]];
    int chr = [key[i % keyLength] charValue];
    [iK addObject:[NSNumber numberWithChar:chr]];
  }
  
  int j = 0;
  for (i = 0; i < 256; i++) {
    UniChar is = [iS[i] charValue];
    UniChar ik = [iK[i] charValue];
    j = (j + is + ik) % 256;
    [self swap:iS forIndex:i andIndex:j];
  }
  
  return [self cipherArray:data swapArray:iS];
}

+ (void) swap:(NSMutableArray *)iS forIndex:(int)firstIndex andIndex:(int)secondIndex {
  NSNumber *temp = iS[firstIndex];
  [iS replaceObjectAtIndex:firstIndex withObject:iS[secondIndex]];
  [iS replaceObjectAtIndex:secondIndex withObject:temp];
}

+ (NSMutableArray *)cipherArray:(NSArray *)data swapArray:(NSMutableArray *)iS {
  int i = 0;
  int j = 0;
  NSMutableArray *cipher = [NSMutableArray arrayWithArray:data];
  NSUInteger dataLength = cipher.count;
  for (int x = 0; x < dataLength; x++) {
    i = (i + 1) % 256;
    int is_i = [iS[i] intValue];
    
    j = (j + is_i) % 256;
    int is_j = [iS[j] intValue];
    
    int k = [iS[(is_i + is_j) % 256] intValue];
    
    int ch = [data[x] charValue];
    UniChar exclusiveOr = ch ^ k;
    NSNumber *cipherCharacter = [NSNumber numberWithInt:exclusiveOr];
    
    cipher[x] = cipherCharacter;
  }
  return cipher;
}

@end
