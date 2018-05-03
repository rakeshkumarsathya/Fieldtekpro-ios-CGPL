//
//  NSString+AESCrypt.h
//
//  Created by Michael Sedlaczek, Gone Coding on 2011-02-22
//

#import <Foundation/Foundation.h>
#import "NSData+AESCrypt.h"

@interface NSString (AESCrypt)

- (NSString *)AES128EncryptWithKey:(NSString *)key;
- (NSString *)AES128DecryptWithKey:(NSString *)key;
//-(NSString *)createSHA512:(NSString *)string second :(NSString * )  value  third:(NSString *) varable;
//-(NSString *)createSHA512:(NSString *)string;
//-(NSString *)createSHA512:(NSString *)string withKey:(NSString *)key;
//+ (NSString*)base64forData:(NSData*)theData ;

@end
