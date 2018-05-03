//
//  NSString+AESCrypt.m
//
//  Created by Michael Sedlaczek, Gone Coding on 2011-02-22
//

#import "NSString+AESCrypt.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonHMAC.h>
#import <CommonCrypto/CommonHMAC.h>
#import <Security/Security.h>


@implementation NSString (AESCrypt)

- (NSString *)AES128EncryptWithKey:(NSString *)key
{
    
   NSData *plainData = [self dataUsingEncoding:NSUTF8StringEncoding];
    
   NSData *encryptedData = [plainData AES128EncryptWithKey:key];
   
   NSString *encryptedString = [encryptedData base64Encoding];
   
   return encryptedString;
}

- (NSString *)AES128DecryptWithKey:(NSString *)key
{
   NSData *encryptedData = [NSData dataWithBase64EncodedString:self];
   NSData *plainData = [encryptedData AES128DecryptWithKey:key];

   NSString *plainString = [[NSString alloc] initWithData:plainData encoding:NSUTF8StringEncoding];
   
   return plainString ;

}
//-(NSString *)createSHA512:(NSString *)string second :(NSString * )  value  third:(NSString *) varable
//{
//    
//    NSLog(@" ta string  is %@",string);
//    NSLog(@"key string is %@",value);
//
//    NSLog(@"encrypted string is %@",varable);
//
//
//    const char *cstr = [string cStringUsingEncoding:NSUTF8StringEncoding];
//    const char *cstr2 = [value cStringUsingEncoding:NSUTF8StringEncoding];
//    const char *cstr3 = [varable cStringUsingEncoding:NSUTF8StringEncoding];
//    
//    
//
//
//    NSData *data = [NSData dataWithBytes:cstr length:string.length];
//    NSData *data1 = [NSData dataWithBytes:cstr2 length:value.length];
//
//    NSData *data2 = [NSData dataWithBytes:cstr3 length:varable.length];
//    
//    NSLog(@"ta data is %@",data);
//    NSLog(@"key data is %@",data1);
//
//    NSLog(@"encrypted data is %@",data2);
//
//    
//    NSMutableData *concatenatedData = [NSMutableData data];
//    [concatenatedData appendData:data];
//    [concatenatedData appendData:data1];
//    [concatenatedData appendData:data2];
//    
//    NSLog(@"merge data is %@",concatenatedData);
//    
//    uint8_t digest[CC_SHA512_DIGEST_LENGTH];
//    CC_SHA512(concatenatedData.bytes, concatenatedData.length ,digest);
//    NSMutableString* output = [NSMutableString  stringWithCapacity:CC_SHA512_DIGEST_LENGTH * 2];
//    
//    for(int i = 0; i < CC_SHA512_DIGEST_LENGTH; i++)
//        [output appendFormat:@"%02x", digest[i]];
//    return output;
//}
//

//-(NSString *)createSHA512:(NSString *)string 
//{
//    
//    
//   // NSLog(@"encrypted string is %@",string);
//    
//    const char *cstr = [string cStringUsingEncoding:NSUTF8StringEncoding];
//    
//    NSData *data = [NSData dataWithBytes:cstr length:string.length];
//        
//    uint8_t digest[CC_SHA512_DIGEST_LENGTH];
//    cchma(data.bytes, data.length ,digest);
//    NSMutableString* output = [NSMutableString  stringWithCapacity:CC_SHA512_DIGEST_LENGTH * 2];
//    
//    for(int i = 0; i < CC_SHA512_DIGEST_LENGTH; i++)
//        [output appendFormat:@"%02x", digest[i]];
//    return output;
//}

-(NSString *)createSHA512:(NSString *)string withKey:(NSString *)key
{
//    NSLog(@"key isss %@",key);
//    NSLog(@"string isss %@",string);
//
//    const char *cKey  = [key cStringUsingEncoding:NSASCIIStringEncoding];
//    const char *cData = [string cStringUsingEncoding:NSASCIIStringEncoding];
//    
//    unsigned char cHMAC[CC_SHA512_DIGEST_LENGTH];
//    
//    CCHmac(kCCHmacAlgSHA256, cKey, strlen(cKey), cData, strlen(cData), cHMAC);
//    
//    NSData *HMACData = [[NSData alloc] initWithBytes:cHMAC length:sizeof(cHMAC)];
//    
//    const unsigned char *buffer = (const unsigned char *)[HMACData bytes];
//    NSLog(@"bytes data is %@",HMACData);
//    
//    NSString *HMAC = [NSMutableString stringWithCapacity:HMACData.length * 2];
//    
//    for (int i = 0; i < HMACData.length; ++i)
//        HMAC = [HMAC stringByAppendingFormat:@"%02lx", (unsigned long)buffer[i]];
//    
//    return HMAC;
//


    const char *cKey  = [key cStringUsingEncoding:NSASCIIStringEncoding];
    const char *cData = [string cStringUsingEncoding:NSASCIIStringEncoding];

    unsigned char cHMAC[CC_SHA512_DIGEST_LENGTH];

    CCHmac(kCCHmacAlgSHA512, cKey, strlen(cKey), cData, strlen(cData), cHMAC);



// Gerating hased value
NSData *da =  [[NSData alloc] initWithBytes:cHMAC length:sizeof(cHMAC)];

return [da base64Encoding] ;

}
//+ (NSString*)base64forData:(NSData*)theData {
//    
//    const uint8_t* input = (const uint8_t*)[theData bytes];
//    NSInteger length = [theData length];
//    
//    static char table[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";
//    
//    NSMutableData* data = [NSMutableData dataWithLength:((length + 2) / 3) * 4];
//    uint8_t* output = (uint8_t*)data.mutableBytes;
//    
//    NSInteger i;
//    for (i=0; i < length; i += 3) {
//        NSInteger value = 0;
//        NSInteger j;
//        for (j = i; j < (i + 3); j++) {
//            value <<= 8;
//            
//            if (j < length) {
//                value |= (0xFF & input[j]);
//            }
//        }
//        
//        NSInteger theIndex = (i / 3) * 4;
//        output[theIndex + 0] =                    table[(value >> 18) & 0x3F];
//        output[theIndex + 1] =                    table[(value >> 12) & 0x3F];
//        output[theIndex + 2] = (i + 1) < length ? table[(value >> 6)  & 0x3F] : '=';
//        output[theIndex + 3] = (i + 2) < length ? table[(value >> 0)  & 0x3F] : '=';
//    }
//    
//    return [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding] ;
//}
//


@end
