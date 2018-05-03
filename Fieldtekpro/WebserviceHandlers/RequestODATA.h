//
//  RequestODATA.h
//  PMCockpit
//
//  Created by Shyam Chandar on 29/03/15.
//  Copyright (c) 2015 Enstrapp IT Solutions. All rights reserved.
//

#import "Request.h"
#import "UrlConstraints.h"

//For Encryption
#import "NSData+AESCrypt.h"
#import "NSData+AESCrypt.h"
#import "NSString+AESCrypt.h"
#import <CommonCrypto/CommonCrypto.h>
#import "NullChecker.h"

@interface RequestODATA : Request
{
    NSString *requestParemeter;
}
@end
