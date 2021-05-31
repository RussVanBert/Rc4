#import "Rc4.h"

@implementation Rc4

+ (void)byteArr:(UInt8 *)array forString:(NSString *)string {
  for (int p = 0; p < (int)string.length; p++) {
    array[p] = [string characterAtIndex:p];
  }
}

+ (void)decrypt:(UInt8 *)data cipher:(UInt8 *)cipher cipherLength:(int)cipherLength key:(UInt8 *)key keyLength:(int)keyLength {
  [Rc4 encrypt:data data:cipher dataLength:cipherLength key:key keyLength:keyLength];
}

+ (void)encrypt:(UInt8 *)cipher data:(UInt8 *)data dataLength:(int)dataLength key:(UInt8 *)key keyLength:(int)keyLength {
  UInt8 iS[256];
  [Rc4 keyScheduler:iS key:key keyLength:keyLength];
  [Rc4 createCipher:cipher data:data dataLength:dataLength iS:iS];
}

+ (void)keyScheduler:(UInt8 *)iS key:(UInt8 *)key keyLength:(int)keyLength {
  UInt8 iK[256];
  int i;
  for (i = 0; i < 256; i++) {
    iS[i] = i;
    iK[i] = key[i % keyLength];
  }
  
  int j = 0;
  for (i = 0; i < 256; i++) {
    int is = iS[i];
    int ik = iK[i];
    j = (j + is + ik) % 256;
    [Rc4 swap:iS forIndex:i andIndex:j];
  }
}

+ (void)swap:(UInt8 *)a forIndex:(int)firstIndex andIndex:(int)secondIndex {
  UInt8 temp = a[firstIndex];
  a[firstIndex] = a[secondIndex];
  a[secondIndex] = temp;
}

+ (void)createCipher:(UInt8 *)cipher data:(UInt8 *)data dataLength:(int)dataLength iS:(UInt8 *)iS {
  int i = 0;
  int j = 0;
  for (int x = 0; x < dataLength; x++) {
    i = (i + 1) % 256;
    int is_i = iS[i];
    
    j = (j + is_i) % 256;
    int is_j = iS[j];

    [Rc4 swap:iS forIndex:i andIndex:j];

    int k = iS[(is_i + is_j) % 256];
    cipher[x] = data[x] ^ k;
  }
}

@end
