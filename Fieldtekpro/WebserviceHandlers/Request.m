//
//  Request.m
//  eCollection
//
//  Created by Harish Kishenchand on 26/11/12.
//  Copyright (c) 2012 HTC. All rights reserved.
//

 #import "Request.h"
 #import "ConnectionManager.h"
 #import <Security/Security.h>
 #include <ifaddrs.h>
#include <arpa/inet.h>
#import <sys/utsname.h>

#import "RequestODATA.h"

static Request *request;
@implementation Request

#pragma mark -
#pragma mark public methods

+ (void)makeWebServiceRequest:(WebServiceRequest)requestId parameters:(NSDictionary *)parameters delegate:(id<requestDelegate>)delegate{
    
    if (![[ConnectionManager defaultManager] isReachable]) {
        //[AlertView showAlertMessage:@"Fieldtekpro can't connect to the internet. Please check your connection and try again."];
        return;
    }
    
    else{
        
        if (request) {
            request = nil;
        }
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        
        if ([[defaults objectForKey:@"ENDPOINT"] isEqual:@"SOAP"])
        {
            request = [[Request alloc] init];
        }
        else
        {
            request = [[RequestODATA alloc] init];
        }
        
        [request makeWebServiceRequest:requestId parameters:parameters delegate:delegate];
    }
    
 }

+ (void)stopRequest
{
    if (request) {
        [request.connection cancel];
        request = nil;
     }
}

+(NSString*)encodeToPercentEscapeString:(NSString *)string {
    return (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,
                                                                                 (CFStringRef) string,
                                                                                 NULL,
                                                                                 (CFStringRef) @"!*'();:@&=+$,/?%#[]",
                                                                                 kCFStringEncodingUTF8));
}

// Decode a percent escape encoded string.
+ (NSString*)decodeFromPercentEscapeString:(NSString *)string {
    return (NSString *)
    CFBridgingRelease(CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL,
                                                                              (CFStringRef) string,
                                                                              CFSTR(""),
                                                                              kCFStringEncodingUTF8));
}

-(NSString*)getcodeforkeys:(NSString*)str_code{
    
    str_code = [str_code stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"];
    str_code = [str_code stringByReplacingOccurrencesOfString:@"<" withString:@"&lt;"];
    str_code = [str_code stringByReplacingOccurrencesOfString:@">" withString:@"&gt;"];
    str_code = [str_code stringByReplacingOccurrencesOfString:@"'" withString:@"&apos;"];
    str_code = [str_code stringByReplacingOccurrencesOfString:@"\"" withString:@"&quot;"];
    str_code = [str_code stringByReplacingOccurrencesOfString:@"/" withString:@""];
    
    
    return str_code;
}

#pragma mark-
#pragma mark- Instance method

-(void)decryptforBasicAuth{
    
    NSString *key = @"";
    // NSLog(@"total key is %@",key);
    NSString *str_UserName = [defaults objectForKey:@"userName"];
    decryptedUserName = [str_UserName AES128DecryptWithKey:key];
    NSString *str_Pasword = [defaults objectForKey:@"password"];
    decryptedPassword = [str_Pasword AES128DecryptWithKey:key];
    
    //        decryptedUserName = [defaults objectForKey:@"userName"];
    //        decryptedPassword = [defaults objectForKey:@"password"];
}

- (void)makeWebServiceRequest:(WebServiceRequest)requestId parameters:(NSDictionary *)parameters delegate:(id)delegate
{
    defaults = [NSUserDefaults standardUserDefaults];
    
    switch (requestId) {
            
        case LOGIN:
            
            request.dataType = NORMAL_DATA;
            request.requestType = requestId;
            
            request.connectionRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@:%@%@%@",URL_HOST,URL_PORT,URL_PATH,URL_LOGIN]] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:120.0f];
            
            request.resultDelegate = delegate;
            
            if (1) {
                
                NSMutableString *soapString = [[NSMutableString alloc] init];
                [soapString appendString:[request mxmlPrefix:requestId]];
                [soapString appendString:[request mxmlBodyWithKeys:parameters Values:nil Action:[self actionWithWebServiceRequest:requestId]]];
                [soapString appendString:[request mxmlSuffix]];
                NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapString length]];
                
                [request.connectionRequest addValue:@"application/soap+xml;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
                
                [request.connectionRequest addValue:msgLength forHTTPHeaderField:@"Content-Length"];
                
                [request.connectionRequest addValue:@"nosniff" forHTTPHeaderField:@"X-Content-Type-Options"];
                
                [request.connectionRequest addValue:@"1" forHTTPHeaderField:@"X-XSS-Protection"];
                [request.connectionRequest addValue:@"DENY" forHTTPHeaderField:@"X-Frame-Options"];
                
                [request.connectionRequest addValue:@"gzip, deflate" forHTTPHeaderField:@"Accept-Encoding"];
                
                NSData *decodedData = [[NSData alloc] initWithBase64EncodedString:passWord options:0];
                NSString *decodedString = [[NSString alloc] initWithData:decodedData encoding:NSUTF8StringEncoding];
                NSLog(@"Decode String Value: %@", decodedString);
                
                NSString *authStr = [NSString stringWithFormat:@"%@:%@",userName,decodedString];
                NSData *authData = [authStr dataUsingEncoding:NSUTF8StringEncoding];
                
                NSString *authValue = [authData base64EncodedStringWithOptions:0];
                
                [request.connectionRequest addValue:[NSString stringWithFormat:@"Basic %@",authValue] forHTTPHeaderField:@"Authorization"];
                
                [request.connectionRequest setHTTPMethod: @"POST"];
                
                [request.connectionRequest setHTTPBody:[soapString dataUsingEncoding:NSUTF8StringEncoding]];
            }
            
            break;
            
        case GET_SYNC_MAP_DATA:
            
            request.dataType = NORMAL_DATA;
            request.requestType = requestId;
            request.connectionRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@:%@%@%@",URL_HOST,URL_PORT,URL_PATH,URL_GET_SYNC_MAP_DATA]] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:120.0f];
            request.resultDelegate = delegate;
            
            if (1) {
                
                NSMutableString *soapString = [[NSMutableString alloc] init];
                [soapString appendString:[request mxmlPrefix:requestId]];
                [soapString appendString:[request mxmlBodyWithKeys:parameters Values:nil Action:[self actionWithWebServiceRequest:requestId]]];
                [soapString appendString:[request mxmlSuffix]];
                NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapString length]];
                
                [request.connectionRequest addValue:@"application/soap+xml;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
                
                [request.connectionRequest addValue:msgLength forHTTPHeaderField:@"Content-Length"];
                
                [request.connectionRequest addValue:@"nosniff" forHTTPHeaderField:@"X-Content-Type-Options"];
                
                [request.connectionRequest addValue:@"1" forHTTPHeaderField:@"X-XSS-Protection"];
                [request.connectionRequest addValue:@"DENY" forHTTPHeaderField:@"X-Frame-Options"];
                
                [request.connectionRequest addValue:@"gzip, deflate" forHTTPHeaderField:@"Accept-Encoding"];
                
                [self decryptforBasicAuth];
                
                NSString *authStr = [NSString stringWithFormat:@"%@:%@",decryptedUserName,decryptedPassword];
                
                NSData *authData = [authStr dataUsingEncoding:NSUTF8StringEncoding];
                
                NSString *authValue = [authData base64EncodedStringWithOptions:0];
                
                
                [request.connectionRequest addValue:[NSString stringWithFormat:@"Basic %@",authValue] forHTTPHeaderField:@"Authorization"];
                
                [request.connectionRequest setHTTPMethod: @"POST"];
                
                [request.connectionRequest setHTTPBody:[soapString dataUsingEncoding:NSUTF8StringEncoding]];
            }
            
            break;
            
        case GET_LOAD_SETTINGS:
            
            request.dataType = NORMAL_DATA;
            request.requestType = requestId;
            request.connectionRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@:%@%@",URL_HOST,URL_PORT,[parameters objectForKey:@"URL_ENDPOINT"]]] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:120.0f];
            request.resultDelegate = delegate;
            
            if (1) {
                
                NSMutableString *soapString = [[NSMutableString alloc] init];
                [soapString appendString:[request mxmlPrefix:requestId]];
                [soapString appendString:[request mxmlBodyWithKeys:parameters Values:nil Action:[self actionWithWebServiceRequest:requestId]]];
                [soapString appendString:[request mxmlSuffix]];
                NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapString length]];
                
                [request.connectionRequest addValue:@"application/soap+xml;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
                
                [request.connectionRequest addValue:@"nosniff" forHTTPHeaderField:@"X-Content-Type-Options"];
                [request.connectionRequest addValue:@"1" forHTTPHeaderField:@"X-XSS-Protection"];
                [request.connectionRequest addValue:@"DENY" forHTTPHeaderField:@"X-Frame-Options"];
                
                [request.connectionRequest addValue:msgLength forHTTPHeaderField:@"Content-Length"];
                
                [request.connectionRequest addValue:@"gzip, deflate" forHTTPHeaderField:@"Accept-Encoding"];
                
                [self decryptforBasicAuth];
                
                NSString *authStr = [NSString stringWithFormat:@"%@:%@",decryptedUserName,decryptedPassword];
                
                NSData *authData = [authStr dataUsingEncoding:NSUTF8StringEncoding];
                
                NSString *authValue = [authData base64EncodedStringWithOptions:0];
                
                [request.connectionRequest addValue:[NSString stringWithFormat:@"Basic %@",authValue] forHTTPHeaderField:@"Authorization"];
                
                [request.connectionRequest setHTTPMethod: @"POST"];
                
                [request.connectionRequest setHTTPBody:[soapString dataUsingEncoding:NSUTF8StringEncoding]];
            }
            
            break;
            
        case GET_VALUE_HELPS:
            
            request.dataType = NORMAL_DATA;
            request.requestType = requestId;
            request.connectionRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@:%@%@",URL_HOST,URL_PORT,[parameters objectForKey:@"URL_ENDPOINT"]]] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:120.0f];
            request.resultDelegate = delegate;
            
            if (1) {
                
                NSMutableString *soapString = [[NSMutableString alloc] init];
                [soapString appendString:[request mxmlPrefix:requestId]];
                [soapString appendString:[request mxmlBodyWithKeys:parameters Values:nil Action:[self actionWithWebServiceRequest:requestId]]];
                [soapString appendString:[request mxmlSuffix]];
                NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapString length]];
                
                [request.connectionRequest addValue:@"application/soap+xml;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
                
                [request.connectionRequest addValue:msgLength forHTTPHeaderField:@"Content-Length"];
                
                [request.connectionRequest addValue:@"nosniff" forHTTPHeaderField:@"X-Content-Type-Options"];
                [request.connectionRequest addValue:@"1" forHTTPHeaderField:@"X-XSS-Protection"];
                [request.connectionRequest addValue:@"DENY" forHTTPHeaderField:@"X-Frame-Options"];
                
                [request.connectionRequest addValue:@"gzip, deflate" forHTTPHeaderField:@"Accept-Encoding"];
                
                [self decryptforBasicAuth];
                
                NSString *authStr = [NSString stringWithFormat:@"%@:%@",decryptedUserName,decryptedPassword];
                
                NSData *authData = [authStr dataUsingEncoding:NSUTF8StringEncoding];
                
                NSString *authValue = [authData base64EncodedStringWithOptions:0];
                
                [request.connectionRequest addValue:[NSString stringWithFormat:@"Basic %@",authValue] forHTTPHeaderField:@"Authorization"];
                
                [request.connectionRequest setHTTPMethod: @"POST"];
                
                [request.connectionRequest setHTTPBody:[soapString dataUsingEncoding:NSUTF8StringEncoding]];
            }
            
            
            break;
            
        case GET_ACTIVITY_TYPE:
            
            request.dataType = NORMAL_DATA;
            request.requestType = requestId;
            request.connectionRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@:%@%@",URL_HOST,URL_PORT,[parameters objectForKey:@"URL_ENDPOINT"]]] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:120.0f];
            request.resultDelegate = delegate;
            
            if (1) {
                
                NSMutableString *soapString = [[NSMutableString alloc] init];
                [soapString appendString:[request mxmlPrefix:requestId]];
                [soapString appendString:[request mxmlBodyWithKeys:parameters Values:nil Action:[self actionWithWebServiceRequest:requestId]]];
                [soapString appendString:[request mxmlSuffix]];
                NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapString length]];
                
                [request.connectionRequest addValue:@"application/soap+xml;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
                [request.connectionRequest addValue:@"nosniff" forHTTPHeaderField:@"X-Content-Type-Options"];
                [request.connectionRequest addValue:@"1" forHTTPHeaderField:@"X-XSS-Protection"];
                [request.connectionRequest addValue:@"DENY" forHTTPHeaderField:@"X-Frame-Options"];
                [request.connectionRequest addValue:msgLength forHTTPHeaderField:@"Content-Length"];
                [request.connectionRequest addValue:@"gzip, deflate" forHTTPHeaderField:@"Accept-Encoding"];
                
                [self decryptforBasicAuth];
                
                NSString *authStr = [NSString stringWithFormat:@"%@:%@",decryptedUserName,decryptedPassword];
                
                NSData *authData = [authStr dataUsingEncoding:NSUTF8StringEncoding];
                
                NSString *authValue = [authData base64EncodedStringWithOptions:0];
                
                [request.connectionRequest addValue:[NSString stringWithFormat:@"Basic %@",authValue] forHTTPHeaderField:@"Authorization"];
                
                [request.connectionRequest setHTTPMethod: @"POST"];
                
                [request.connectionRequest setHTTPBody:[soapString dataUsingEncoding:NSUTF8StringEncoding]];
            }
            
            break;
            
            
        case GET_APP_SETTINGS:
            
            request.dataType = NORMAL_DATA;
            request.requestType = requestId;
            request.connectionRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@:%@%@",URL_HOST,URL_PORT,[parameters objectForKey:@"URL_ENDPOINT"]]] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:120.0f];
            request.resultDelegate = delegate;
            
            if (1) {
                
                NSMutableString *soapString = [[NSMutableString alloc] init];
                [soapString appendString:[request mxmlPrefix:requestId]];
                [soapString appendString:[request mxmlBodyWithKeys:parameters Values:nil Action:[self actionWithWebServiceRequest:requestId]]];
                [soapString appendString:[request mxmlSuffix]];
                NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapString length]];
                
                [request.connectionRequest addValue:@"application/soap+xml;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
                
                [request.connectionRequest addValue:@"nosniff" forHTTPHeaderField:@"X-Content-Type-Options"];
                [request.connectionRequest addValue:@"1" forHTTPHeaderField:@"X-XSS-Protection"];
                [request.connectionRequest addValue:@"DENY" forHTTPHeaderField:@"X-Frame-Options"];
                [request.connectionRequest addValue:msgLength forHTTPHeaderField:@"Content-Length"];
                [request.connectionRequest addValue:@"gzip, deflate" forHTTPHeaderField:@"Accept-Encoding"];
                
                [self decryptforBasicAuth];
                
                NSString *authStr = [NSString stringWithFormat:@"%@:%@",decryptedUserName,decryptedPassword];
                
                NSData *authData = [authStr dataUsingEncoding:NSUTF8StringEncoding];
                
                NSString *authValue = [authData base64EncodedStringWithOptions:0];
                
                [request.connectionRequest addValue:[NSString stringWithFormat:@"Basic %@",authValue] forHTTPHeaderField:@"Authorization"];
                
                [request.connectionRequest setHTTPMethod: @"POST"];
                
                [request.connectionRequest setHTTPBody:[soapString dataUsingEncoding:NSUTF8StringEncoding]];
            }
            
            break;
            
        case NOTIFICATION_TYPES:
            
            request.dataType = NORMAL_DATA;
            request.requestType = requestId;
            request.connectionRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@:%@%@",URL_HOST,URL_PORT,[parameters objectForKey:@"URL_ENDPOINT"]]] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:120.0f];
            request.resultDelegate = delegate;
            
            if (1) {
                
                NSMutableString *soapString = [[NSMutableString alloc] init];
                [soapString appendString:[request mxmlPrefix:requestId]];
                [soapString appendString:[request mxmlBodyWithKeys:parameters Values:nil Action:[self actionWithWebServiceRequest:requestId]]];
                [soapString appendString:[request mxmlSuffix]];
                NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapString length]];
                
                [request.connectionRequest addValue:@"application/soap+xml;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
                
                [request.connectionRequest addValue:@"nosniff" forHTTPHeaderField:@"X-Content-Type-Options"];
                [request.connectionRequest addValue:@"1" forHTTPHeaderField:@"X-XSS-Protection"];
                [request.connectionRequest addValue:@"DENY" forHTTPHeaderField:@"X-Frame-Options"];
                
                [request.connectionRequest addValue:msgLength forHTTPHeaderField:@"Content-Length"];
                
                [request.connectionRequest addValue:@"gzip, deflate" forHTTPHeaderField:@"Accept-Encoding"];
                
                [self decryptforBasicAuth];
                
                NSString *authStr = [NSString stringWithFormat:@"%@:%@",decryptedUserName,decryptedPassword];
                
                NSData *authData = [authStr dataUsingEncoding:NSUTF8StringEncoding];
                
                NSString *authValue = [authData base64EncodedStringWithOptions:0];
                
                [request.connectionRequest addValue:[NSString stringWithFormat:@"Basic %@",authValue] forHTTPHeaderField:@"Authorization"];
                
                [request.connectionRequest setHTTPMethod: @"POST"];
                
                [request.connectionRequest setHTTPBody:[soapString dataUsingEncoding:NSUTF8StringEncoding]];
            }
            
            break;
            
        case NOTIFICATION_PRIORITY_TYPES:
            
            request.dataType = NORMAL_DATA;
            request.requestType = requestId;
            request.connectionRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@:%@%@",URL_HOST,URL_PORT,[parameters objectForKey:@"URL_ENDPOINT"]]] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:120.0f];
            request.resultDelegate = delegate;
            
            if (1) {
                
                NSMutableString *soapString = [[NSMutableString alloc] init];
                [soapString appendString:[request mxmlPrefix:requestId]];
                [soapString appendString:[request mxmlBodyWithKeys:parameters Values:nil Action:[self actionWithWebServiceRequest:requestId]]];
                [soapString appendString:[request mxmlSuffix]];
                NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapString length]];
                
                [request.connectionRequest addValue:@"application/soap+xml;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
                
                [request.connectionRequest addValue:@"nosniff" forHTTPHeaderField:@"X-Content-Type-Options"];
                [request.connectionRequest addValue:@"1" forHTTPHeaderField:@"X-XSS-Protection"];
                [request.connectionRequest addValue:@"DENY" forHTTPHeaderField:@"X-Frame-Options"];
                
                [request.connectionRequest addValue:msgLength forHTTPHeaderField:@"Content-Length"];
                
                [request.connectionRequest addValue:@"gzip, deflate" forHTTPHeaderField:@"Accept-Encoding"];
                
                [self decryptforBasicAuth];
                
                NSString *authStr = [NSString stringWithFormat:@"%@:%@",decryptedUserName,decryptedPassword];
                
                NSData *authData = [authStr dataUsingEncoding:NSUTF8StringEncoding];
                
                NSString *authValue = [authData base64EncodedStringWithOptions:0];
                
                [request.connectionRequest addValue:[NSString stringWithFormat:@"Basic %@",authValue] forHTTPHeaderField:@"Authorization"];
                
                [request.connectionRequest setHTTPMethod: @"POST"];
                
                [request.connectionRequest setHTTPBody:[soapString dataUsingEncoding:NSUTF8StringEncoding]];
            }
            
            break;
            
        case ORDER_PRIORITY_TYPES:
            
            request.dataType = NORMAL_DATA;
            request.requestType = requestId;
            request.connectionRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@:%@%@",URL_HOST,URL_PORT,[parameters objectForKey:@"URL_ENDPOINT"]]] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:120.0f];
            request.resultDelegate = delegate;
            
            if (1) {
                
                NSMutableString *soapString = [[NSMutableString alloc] init];
                [soapString appendString:[request mxmlPrefix:requestId]];
                [soapString appendString:[request mxmlBodyWithKeys:parameters Values:nil Action:[self actionWithWebServiceRequest:requestId]]];
                [soapString appendString:[request mxmlSuffix]];
                NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapString length]];
                
                [request.connectionRequest addValue:@"application/soap+xml;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
                
                [request.connectionRequest addValue:@"nosniff" forHTTPHeaderField:@"X-Content-Type-Options"];
                [request.connectionRequest addValue:@"1" forHTTPHeaderField:@"X-XSS-Protection"];
                [request.connectionRequest addValue:@"DENY" forHTTPHeaderField:@"X-Frame-Options"];
                
                [request.connectionRequest addValue:msgLength forHTTPHeaderField:@"Content-Length"];
                
                [request.connectionRequest addValue:@"gzip, deflate" forHTTPHeaderField:@"Accept-Encoding"];
                
                [self decryptforBasicAuth];
                
                NSString *authStr = [NSString stringWithFormat:@"%@:%@",decryptedUserName,decryptedPassword];
                
                NSData *authData = [authStr dataUsingEncoding:NSUTF8StringEncoding];
                
                NSString *authValue = [authData base64EncodedStringWithOptions:0];
                
                [request.connectionRequest addValue:[NSString stringWithFormat:@"Basic %@",authValue] forHTTPHeaderField:@"Authorization"];
                
                [request.connectionRequest setHTTPMethod: @"POST"];
                
                [request.connectionRequest setHTTPBody:[soapString dataUsingEncoding:NSUTF8StringEncoding]];
            }
            
            break;
            
            
        case ORDER_TYPES:
            
            request.dataType = NORMAL_DATA;
            request.requestType = requestId;
            request.connectionRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@:%@%@",URL_HOST,URL_PORT,[parameters objectForKey:@"URL_ENDPOINT"]]] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:120.0f];
            request.resultDelegate = delegate;
            
            if (1) {
                
                NSMutableString *soapString = [[NSMutableString alloc] init];
                [soapString appendString:[request mxmlPrefix:requestId]];
                [soapString appendString:[request mxmlBodyWithKeys:parameters Values:nil Action:[self actionWithWebServiceRequest:requestId]]];
                [soapString appendString:[request mxmlSuffix]];
                NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapString length]];
                
                [request.connectionRequest addValue:@"application/soap+xml;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
                
                [request.connectionRequest addValue:@"nosniff" forHTTPHeaderField:@"X-Content-Type-Options"];
                [request.connectionRequest addValue:@"1" forHTTPHeaderField:@"X-XSS-Protection"];
                [request.connectionRequest addValue:@"DENY" forHTTPHeaderField:@"X-Frame-Options"];
                
                [request.connectionRequest addValue:msgLength forHTTPHeaderField:@"Content-Length"];
                
                [request.connectionRequest addValue:@"gzip, deflate" forHTTPHeaderField:@"Accept-Encoding"];
                
                [self decryptforBasicAuth];
                
                NSString *authStr = [NSString stringWithFormat:@"%@:%@",decryptedUserName,decryptedPassword];
                
                NSData *authData = [authStr dataUsingEncoding:NSUTF8StringEncoding];
                
                NSString *authValue = [authData base64EncodedStringWithOptions:0];
                
                [request.connectionRequest addValue:[NSString stringWithFormat:@"Basic %@",authValue] forHTTPHeaderField:@"Authorization"];
                
                [request.connectionRequest setHTTPMethod: @"POST"];
                
                [request.connectionRequest setHTTPBody:[soapString dataUsingEncoding:NSUTF8StringEncoding]];
            }
            
            break;
            
        case GET_UNITS:
            
            request.dataType = NORMAL_DATA;
            request.requestType = requestId;
            request.connectionRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@:%@%@",URL_HOST,URL_PORT,[parameters objectForKey:@"URL_ENDPOINT"]]] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:120.0f];
            request.resultDelegate = delegate;
            
            if (1) {
                
                NSMutableString *soapString = [[NSMutableString alloc] init];
                [soapString appendString:[request mxmlPrefix:requestId]];
                [soapString appendString:[request mxmlBodyWithKeys:parameters Values:nil Action:[self actionWithWebServiceRequest:requestId]]];
                [soapString appendString:[request mxmlSuffix]];
                NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapString length]];
                
                [request.connectionRequest addValue:@"application/soap+xml;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
                
                [request.connectionRequest addValue:@"nosniff" forHTTPHeaderField:@"X-Content-Type-Options"];
                [request.connectionRequest addValue:@"1" forHTTPHeaderField:@"X-XSS-Protection"];
                [request.connectionRequest addValue:@"DENY" forHTTPHeaderField:@"X-Frame-Options"];
                
                [request.connectionRequest addValue:msgLength forHTTPHeaderField:@"Content-Length"];
                
                [request.connectionRequest addValue:@"gzip, deflate" forHTTPHeaderField:@"Accept-Encoding"];
                
                [self decryptforBasicAuth];
                
                NSString *authStr = [NSString stringWithFormat:@"%@:%@",decryptedUserName,decryptedPassword];
                
                NSData *authData = [authStr dataUsingEncoding:NSUTF8StringEncoding];
                
                NSString *authValue = [authData base64EncodedStringWithOptions:0];
                
                [request.connectionRequest addValue:[NSString stringWithFormat:@"Basic %@",authValue] forHTTPHeaderField:@"Authorization"];
                
                [request.connectionRequest setHTTPMethod: @"POST"];
                
                [request.connectionRequest setHTTPBody:[soapString dataUsingEncoding:NSUTF8StringEncoding]];
            }
            
            break;
            
        case ACCIND_TYPES:
            request.dataType = NORMAL_DATA;
            request.requestType = requestId;
            request.connectionRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@:%@%@",URL_HOST,URL_PORT,[parameters objectForKey:@"URL_ENDPOINT"]]] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:120.0f];
            request.resultDelegate = delegate;
            
            if (1) {
                
                NSMutableString *soapString = [[NSMutableString alloc] init];
                [soapString appendString:[request mxmlPrefix:requestId]];
                [soapString appendString:[request mxmlBodyWithKeys:parameters Values:nil Action:[self actionWithWebServiceRequest:requestId]]];
                [soapString appendString:[request mxmlSuffix]];
                NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapString length]];
                
                [request.connectionRequest addValue:@"application/soap+xml;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
                
                [request.connectionRequest addValue:@"nosniff" forHTTPHeaderField:@"X-Content-Type-Options"];
                [request.connectionRequest addValue:@"1" forHTTPHeaderField:@"X-XSS-Protection"];
                [request.connectionRequest addValue:@"DENY" forHTTPHeaderField:@"X-Frame-Options"];
                
                [request.connectionRequest addValue:msgLength forHTTPHeaderField:@"Content-Length"];
                
                [request.connectionRequest addValue:@"gzip, deflate" forHTTPHeaderField:@"Accept-Encoding"];
                
                [self decryptforBasicAuth];
                
                NSString *authStr = [NSString stringWithFormat:@"%@:%@",decryptedUserName,decryptedPassword];
                
                NSData *authData = [authStr dataUsingEncoding:NSUTF8StringEncoding];
                
                NSString *authValue = [authData base64EncodedStringWithOptions:0];
                
                [request.connectionRequest addValue:[NSString stringWithFormat:@"Basic %@",authValue] forHTTPHeaderField:@"Authorization"];
                
                [request.connectionRequest setHTTPMethod: @"POST"];
                
                [request.connectionRequest setHTTPBody:[soapString dataUsingEncoding:NSUTF8StringEncoding]];
            }
            
            break;
            
        case GET_LIST_OF_PLANTS:
            
            request.dataType = NORMAL_DATA;
            request.requestType = requestId;
            request.connectionRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@:%@%@",URL_HOST,URL_PORT,[parameters objectForKey:@"URL_ENDPOINT"]]] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:120.0f];
            request.resultDelegate = delegate;
            
            if (1) {
                
                NSMutableString *soapString = [[NSMutableString alloc] init];
                [soapString appendString:[request mxmlPrefix:requestId]];
                [soapString appendString:[request mxmlBodyWithKeys:parameters Values:nil Action:[self actionWithWebServiceRequest:requestId]]];
                [soapString appendString:[request mxmlSuffix]];
                NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapString length]];
                
                [request.connectionRequest addValue:@"application/soap+xml;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
                
                [request.connectionRequest addValue:@"nosniff" forHTTPHeaderField:@"X-Content-Type-Options"];
                [request.connectionRequest addValue:@"1" forHTTPHeaderField:@"X-XSS-Protection"];
                [request.connectionRequest addValue:@"DENY" forHTTPHeaderField:@"X-Frame-Options"];
                
                [request.connectionRequest addValue:msgLength forHTTPHeaderField:@"Content-Length"];
                
                [request.connectionRequest addValue:@"gzip, deflate" forHTTPHeaderField:@"Accept-Encoding"];
                
                [self decryptforBasicAuth];
                
                NSString *authStr = [NSString stringWithFormat:@"%@:%@",decryptedUserName,decryptedPassword];
                
                NSData *authData = [authStr dataUsingEncoding:NSUTF8StringEncoding];
                
                NSString *authValue = [authData base64EncodedStringWithOptions:0];
                
                [request.connectionRequest addValue:[NSString stringWithFormat:@"Basic %@",authValue] forHTTPHeaderField:@"Authorization"];
                
                [request.connectionRequest setHTTPMethod: @"POST"];
                
                [request.connectionRequest setHTTPBody:[soapString dataUsingEncoding:NSUTF8StringEncoding]];
            }
            
            break;
            
        case GET_LIST_OF_STORAGELOCATION:
            
            request.dataType = NORMAL_DATA;
            request.requestType = requestId;
            request.connectionRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@:%@%@",URL_HOST,URL_PORT,[parameters objectForKey:@"URL_ENDPOINT"]]] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:120.0f];
            request.resultDelegate = delegate;
            
            if (1) {
                
                NSMutableString *soapString = [[NSMutableString alloc] init];
                [soapString appendString:[request mxmlPrefix:requestId]];
                [soapString appendString:[request mxmlBodyWithKeys:parameters Values:nil Action:[self actionWithWebServiceRequest:requestId]]];
                [soapString appendString:[request mxmlSuffix]];
                NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapString length]];
                
                [request.connectionRequest addValue:@"application/soap+xml;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
                
                [request.connectionRequest addValue:@"nosniff" forHTTPHeaderField:@"X-Content-Type-Options"];
                [request.connectionRequest addValue:@"1" forHTTPHeaderField:@"X-XSS-Protection"];
                [request.connectionRequest addValue:@"DENY" forHTTPHeaderField:@"X-Frame-Options"];
                
                [request.connectionRequest addValue:msgLength forHTTPHeaderField:@"Content-Length"];
                
                [request.connectionRequest addValue:@"gzip, deflate" forHTTPHeaderField:@"Accept-Encoding"];
                
                [self decryptforBasicAuth];
                
                NSString *authStr = [NSString stringWithFormat:@"%@:%@",decryptedUserName,decryptedPassword];
                
                NSData *authData = [authStr dataUsingEncoding:NSUTF8StringEncoding];
                
                NSString *authValue = [authData base64EncodedStringWithOptions:0];
                
                [request.connectionRequest addValue:[NSString stringWithFormat:@"Basic %@",authValue] forHTTPHeaderField:@"Authorization"];
                
                [request.connectionRequest setHTTPMethod: @"POST"];
                
                [request.connectionRequest setHTTPBody:[soapString dataUsingEncoding:NSUTF8StringEncoding]];
            }
            
            break;
            
            
        case COSTCENTER_LIST:
            
            request.dataType = NORMAL_DATA;
            request.requestType = requestId;
            request.connectionRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@:%@%@",URL_HOST,URL_PORT,[parameters objectForKey:@"URL_ENDPOINT"]]] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:120.0f];
            request.resultDelegate = delegate;
            
            if (1) {
                
                NSMutableString *soapString = [[NSMutableString alloc] init];
                [soapString appendString:[request mxmlPrefix:requestId]];
                [soapString appendString:[request mxmlBodyWithKeys:parameters Values:nil Action:[self actionWithWebServiceRequest:requestId]]];
                [soapString appendString:[request mxmlSuffix]];
                NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapString length]];
                
                [request.connectionRequest addValue:@"application/soap+xml;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
                
                [request.connectionRequest addValue:@"nosniff" forHTTPHeaderField:@"X-Content-Type-Options"];
                [request.connectionRequest addValue:@"1" forHTTPHeaderField:@"X-XSS-Protection"];
                [request.connectionRequest addValue:@"DENY" forHTTPHeaderField:@"X-Frame-Options"];
                
                [request.connectionRequest addValue:msgLength forHTTPHeaderField:@"Content-Length"];
                
                [request.connectionRequest addValue:@"gzip, deflate" forHTTPHeaderField:@"Accept-Encoding"];
                
                [self decryptforBasicAuth];
                
                NSString *authStr = [NSString stringWithFormat:@"%@:%@",decryptedUserName,decryptedPassword];
                
                NSData *authData = [authStr dataUsingEncoding:NSUTF8StringEncoding];
                
                NSString *authValue = [authData base64EncodedStringWithOptions:0];
                
                [request.connectionRequest addValue:[NSString stringWithFormat:@"Basic %@",authValue] forHTTPHeaderField:@"Authorization"];
                
                [request.connectionRequest setHTTPMethod: @"POST"];
                
                [request.connectionRequest setHTTPBody:[soapString dataUsingEncoding:NSUTF8StringEncoding]];
            }
            
            break;
            
        case USER_DATA:
            
            request.dataType = NORMAL_DATA;
            request.requestType = requestId;
            request.connectionRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@:%@%@",URL_HOST,URL_PORT,[parameters objectForKey:@"URL_ENDPOINT"]]] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:120.0f];
            request.resultDelegate = delegate;
            
            if (1) {
                
                NSMutableString *soapString = [[NSMutableString alloc] init];
                [soapString appendString:[request mxmlPrefix:requestId]];
                [soapString appendString:[request mxmlBodyWithKeys:parameters Values:nil Action:[self actionWithWebServiceRequest:requestId]]];
                [soapString appendString:[request mxmlSuffix]];
                NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapString length]];
                
                [request.connectionRequest addValue:@"application/soap+xml;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
                
                [request.connectionRequest addValue:@"nosniff" forHTTPHeaderField:@"X-Content-Type-Options"];
                [request.connectionRequest addValue:@"1" forHTTPHeaderField:@"X-XSS-Protection"];
                [request.connectionRequest addValue:@"DENY" forHTTPHeaderField:@"X-Frame-Options"];
                
                [request.connectionRequest addValue:msgLength forHTTPHeaderField:@"Content-Length"];
                
                [request.connectionRequest addValue:@"gzip, deflate" forHTTPHeaderField:@"Accept-Encoding"];
                
                [self decryptforBasicAuth];
                
                NSString *authStr = [NSString stringWithFormat:@"%@:%@",decryptedUserName,decryptedPassword];
                
                NSData *authData = [authStr dataUsingEncoding:NSUTF8StringEncoding];
                
                NSString *authValue = [authData base64EncodedStringWithOptions:0];
                
                [request.connectionRequest addValue:[NSString stringWithFormat:@"Basic %@",authValue] forHTTPHeaderField:@"Authorization"];
                
                [request.connectionRequest setHTTPMethod: @"POST"];
                
                [request.connectionRequest setHTTPBody:[soapString dataUsingEncoding:NSUTF8StringEncoding]];
            }
            
            break;
            
        case ALLNOTIFICATION_CODES:
            
            request.dataType = NORMAL_DATA;
            request.requestType = requestId;
            request.connectionRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@:%@%@",URL_HOST,URL_PORT,[parameters objectForKey:@"URL_ENDPOINT"]]] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:120.0f];
            request.resultDelegate = delegate;
            
            if (1) {
                
                NSMutableString *soapString = [[NSMutableString alloc] init];
                [soapString appendString:[request mxmlPrefix:requestId]];
                [soapString appendString:[request mxmlBodyWithKeys:parameters Values:nil Action:[self actionWithWebServiceRequest:requestId]]];
                [soapString appendString:[request mxmlSuffix]];
                NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapString length]];
                
                [request.connectionRequest addValue:@"application/soap+xml;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
                
                [request.connectionRequest addValue:@"nosniff" forHTTPHeaderField:@"X-Content-Type-Options"];
                [request.connectionRequest addValue:@"1" forHTTPHeaderField:@"X-XSS-Protection"];
                [request.connectionRequest addValue:@"DENY" forHTTPHeaderField:@"X-Frame-Options"];
                
                [request.connectionRequest addValue:msgLength forHTTPHeaderField:@"Content-Length"];
                
                [request.connectionRequest addValue:@"gzip, deflate" forHTTPHeaderField:@"Accept-Encoding"];
                
                [self decryptforBasicAuth];
                
                NSString *authStr = [NSString stringWithFormat:@"%@:%@",decryptedUserName,decryptedPassword];
                
                NSData *authData = [authStr dataUsingEncoding:NSUTF8StringEncoding];
                
                NSString *authValue = [authData base64EncodedStringWithOptions:0];
                
                [request.connectionRequest addValue:[NSString stringWithFormat:@"Basic %@",authValue] forHTTPHeaderField:@"Authorization"];
                
                [request.connectionRequest setHTTPMethod: @"POST"];
                
                [request.connectionRequest setHTTPBody:[soapString dataUsingEncoding:NSUTF8StringEncoding]];
            }
            
            break;
            
        case FUNCTIONLOC_COSTCENTER:
            request.dataType = NORMAL_DATA;
            request.requestType = requestId;
            request.connectionRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@:%@%@",URL_HOST,URL_PORT,[parameters objectForKey:@"URL_ENDPOINT"]]] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:120.0f];
            request.resultDelegate = delegate;
            
            if (1) {
                
                NSMutableString *soapString = [[NSMutableString alloc] init];
                [soapString appendString:[request mxmlPrefix:requestId]];
                [soapString appendString:[request mxmlBodyWithKeys:parameters Values:nil Action:[self actionWithWebServiceRequest:requestId]]];
                [soapString appendString:[request mxmlSuffix]];
                NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapString length]];
                
                [request.connectionRequest addValue:@"application/soap+xml;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
                
                [request.connectionRequest addValue:@"nosniff" forHTTPHeaderField:@"X-Content-Type-Options"];
                [request.connectionRequest addValue:@"1" forHTTPHeaderField:@"X-XSS-Protection"];
                [request.connectionRequest addValue:@"DENY" forHTTPHeaderField:@"X-Frame-Options"];
                
                [request.connectionRequest addValue:msgLength forHTTPHeaderField:@"Content-Length"];
                
                [request.connectionRequest addValue:@"gzip, deflate" forHTTPHeaderField:@"Accept-Encoding"];
                
                [self decryptforBasicAuth];
                
                NSString *authStr = [NSString stringWithFormat:@"%@:%@",decryptedUserName,decryptedPassword];
                
                NSData *authData = [authStr dataUsingEncoding:NSUTF8StringEncoding];
                
                NSString *authValue = [authData base64EncodedStringWithOptions:0];
                
                [request.connectionRequest addValue:[NSString stringWithFormat:@"Basic %@",authValue] forHTTPHeaderField:@"Authorization"];
                
                [request.connectionRequest setHTTPMethod: @"POST"];
                
                [request.connectionRequest setHTTPBody:[soapString dataUsingEncoding:NSUTF8StringEncoding]];
            }
            
            break;
            
        case FUNCTIONLOC_EQUIPMENT:
            
            request.dataType = NORMAL_DATA;
            request.requestType = requestId;
            request.connectionRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@:%@%@",URL_HOST,URL_PORT,[parameters objectForKey:@"URL_ENDPOINT"]]] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:120.0f];
            request.resultDelegate = delegate;
            
            if (1) {
                
                NSMutableString *soapString = [[NSMutableString alloc] init];
                [soapString appendString:[request mxmlPrefix:requestId]];
                [soapString appendString:[request mxmlBodyWithKeys:parameters Values:nil Action:[self actionWithWebServiceRequest:requestId]]];
                [soapString appendString:[request mxmlSuffix]];
                NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapString length]];
                
                [request.connectionRequest addValue:@"application/soap+xml;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
                
                [request.connectionRequest addValue:@"nosniff" forHTTPHeaderField:@"X-Content-Type-Options"];
                [request.connectionRequest addValue:@"1" forHTTPHeaderField:@"X-XSS-Protection"];
                [request.connectionRequest addValue:@"DENY" forHTTPHeaderField:@"X-Frame-Options"];
                
                [request.connectionRequest addValue:msgLength forHTTPHeaderField:@"Content-Length"];
                
                [request.connectionRequest addValue:@"gzip, deflate" forHTTPHeaderField:@"Accept-Encoding"];
                
                [self decryptforBasicAuth];
                
                NSString *authStr = [NSString stringWithFormat:@"%@:%@",decryptedUserName,decryptedPassword];
                
                NSData *authData = [authStr dataUsingEncoding:NSUTF8StringEncoding];
                
                NSString *authValue = [authData base64EncodedStringWithOptions:0];
                
                [request.connectionRequest addValue:[NSString stringWithFormat:@"Basic %@",authValue] forHTTPHeaderField:@"Authorization"];
                
                [request.connectionRequest setHTTPMethod: @"POST"];
                
                [request.connectionRequest setHTTPBody:[soapString dataUsingEncoding:NSUTF8StringEncoding]];
            }
            
            break;
            
        case EQUIPMENT_COSTCENTER:
            
            request.dataType = NORMAL_DATA;
            request.requestType = requestId;
            request.connectionRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@:%@%@",URL_HOST,URL_PORT,[parameters objectForKey:@"URL_ENDPOINT"]]] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:120.0f];
            request.resultDelegate = delegate;
            
            if (1) {
                
                NSMutableString *soapString = [[NSMutableString alloc] init];
                [soapString appendString:[request mxmlPrefix:requestId]];
                [soapString appendString:[request mxmlBodyWithKeys:parameters Values:nil Action:[self actionWithWebServiceRequest:requestId]]];
                [soapString appendString:[request mxmlSuffix]];
                NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapString length]];
                
                [request.connectionRequest addValue:@"application/soap+xml;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
                
                [request.connectionRequest addValue:@"nosniff" forHTTPHeaderField:@"X-Content-Type-Options"];
                [request.connectionRequest addValue:@"1" forHTTPHeaderField:@"X-XSS-Protection"];
                [request.connectionRequest addValue:@"DENY" forHTTPHeaderField:@"X-Frame-Options"];
                
                [request.connectionRequest addValue:msgLength forHTTPHeaderField:@"Content-Length"];
                
                [request.connectionRequest addValue:@"gzip, deflate" forHTTPHeaderField:@"Accept-Encoding"];
                
                [self decryptforBasicAuth];
                
                NSString *authStr = [NSString stringWithFormat:@"%@:%@",decryptedUserName,decryptedPassword];
                
                NSData *authData = [authStr dataUsingEncoding:NSUTF8StringEncoding];
                
                NSString *authValue = [authData base64EncodedStringWithOptions:0];
                
                [request.connectionRequest addValue:[NSString stringWithFormat:@"Basic %@",authValue] forHTTPHeaderField:@"Authorization"];
                
                [request.connectionRequest setHTTPMethod: @"POST"];
                
                [request.connectionRequest setHTTPBody:[soapString dataUsingEncoding:NSUTF8StringEncoding]];
            }
            
            break;
            
        case EQUIPMENT_FUNCLOC:
            
            request.dataType = NORMAL_DATA;
            request.requestType = requestId;
            request.connectionRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@:%@%@",URL_HOST,URL_PORT,[parameters objectForKey:@"URL_ENDPOINT"]]] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:120.0f];
            request.resultDelegate = delegate;
            
            if (1) {
                
                NSMutableString *soapString = [[NSMutableString alloc] init];
                [soapString appendString:[request mxmlPrefix:requestId]];
                [soapString appendString:[request mxmlBodyWithKeys:parameters Values:nil Action:[self actionWithWebServiceRequest:requestId]]];
                [soapString appendString:[request mxmlSuffix]];
                NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapString length]];
                
                [request.connectionRequest addValue:@"application/soap+xml;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
                
                [request.connectionRequest addValue:@"nosniff" forHTTPHeaderField:@"X-Content-Type-Options"];
                [request.connectionRequest addValue:@"1" forHTTPHeaderField:@"X-XSS-Protection"];
                [request.connectionRequest addValue:@"DENY" forHTTPHeaderField:@"X-Frame-Options"];
                
                [request.connectionRequest addValue:msgLength forHTTPHeaderField:@"Content-Length"];
                
                [request.connectionRequest addValue:@"gzip, deflate" forHTTPHeaderField:@"Accept-Encoding"];
                
                [self decryptforBasicAuth];
                
                NSString *authStr = [NSString stringWithFormat:@"%@:%@",decryptedUserName,decryptedPassword];
                
                NSData *authData = [authStr dataUsingEncoding:NSUTF8StringEncoding];
                
                NSString *authValue = [authData base64EncodedStringWithOptions:0];
                
                [request.connectionRequest addValue:[NSString stringWithFormat:@"Basic %@",authValue] forHTTPHeaderField:@"Authorization"];
                
                [request.connectionRequest setHTTPMethod: @"POST"];
                
                [request.connectionRequest setHTTPBody:[soapString dataUsingEncoding:NSUTF8StringEncoding]];
            }
            
            break;
            
        case GET_LIST_OF_COMPONENTS:
            
            request.dataType = NORMAL_DATA;
            request.requestType = requestId;
            request.connectionRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@:%@%@",URL_HOST,URL_PORT,[parameters objectForKey:@"URL_ENDPOINT"]]] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:120.0f];
            request.resultDelegate = delegate;
            
            if (1) {
                
                NSMutableString *soapString = [[NSMutableString alloc] init];
                [soapString appendString:[request mxmlPrefix:requestId]];
                [soapString appendString:[request mxmlBodyWithKeys:parameters Values:nil Action:[self actionWithWebServiceRequest:requestId]]];
                [soapString appendString:[request mxmlSuffix]];
                NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapString length]];
                
                [request.connectionRequest addValue:@"application/soap+xml;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
                
                [request.connectionRequest addValue:@"nosniff" forHTTPHeaderField:@"X-Content-Type-Options"];
                [request.connectionRequest addValue:@"1" forHTTPHeaderField:@"X-XSS-Protection"];
                [request.connectionRequest addValue:@"DENY" forHTTPHeaderField:@"X-Frame-Options"];
                
                [request.connectionRequest addValue:msgLength forHTTPHeaderField:@"Content-Length"];
                
                [request.connectionRequest addValue:@"gzip, deflate" forHTTPHeaderField:@"Accept-Encoding"];
                
                [self decryptforBasicAuth];
                
                NSString *authStr = [NSString stringWithFormat:@"%@:%@",decryptedUserName,decryptedPassword];
                
                NSData *authData = [authStr dataUsingEncoding:NSUTF8StringEncoding];
                
                NSString *authValue = [authData base64EncodedStringWithOptions:0];
                
                [request.connectionRequest addValue:[NSString stringWithFormat:@"Basic %@",authValue] forHTTPHeaderField:@"Authorization"];
                
                [request.connectionRequest setHTTPMethod: @"POST"];
                
                [request.connectionRequest setHTTPBody:[soapString dataUsingEncoding:NSUTF8StringEncoding]];
            }
            
            break;
            
        case GET_CUSTOM_FIELDS:
            
            request.dataType = NORMAL_DATA;
            request.requestType = requestId;
            request.connectionRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@:%@%@",URL_HOST,URL_PORT,[parameters objectForKey:@"URL_ENDPOINT"]]] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:120.0f];
            request.resultDelegate = delegate;
            
            if (1) {
                
                NSMutableString *soapString = [[NSMutableString alloc] init];
                [soapString appendString:[request mxmlPrefix:requestId]];
                [soapString appendString:[request mxmlBodyWithKeys:parameters Values:nil Action:[self actionWithWebServiceRequest:requestId]]];
                [soapString appendString:[request mxmlSuffix]];
                NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapString length]];
                
                [request.connectionRequest addValue:@"application/soap+xml;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
                
                [request.connectionRequest addValue:@"nosniff" forHTTPHeaderField:@"X-Content-Type-Options"];
                [request.connectionRequest addValue:@"1" forHTTPHeaderField:@"X-XSS-Protection"];
                [request.connectionRequest addValue:@"DENY" forHTTPHeaderField:@"X-Frame-Options"];
                
                [request.connectionRequest addValue:msgLength forHTTPHeaderField:@"Content-Length"];
                
                [request.connectionRequest addValue:@"gzip, deflate" forHTTPHeaderField:@"Accept-Encoding"];
                
                [self decryptforBasicAuth];
                
                NSString *authStr = [NSString stringWithFormat:@"%@:%@",decryptedUserName,decryptedPassword];
                
                NSData *authData = [authStr dataUsingEncoding:NSUTF8StringEncoding];
                
                NSString *authValue = [authData base64EncodedStringWithOptions:0];
                
                [request.connectionRequest addValue:[NSString stringWithFormat:@"Basic %@",authValue] forHTTPHeaderField:@"Authorization"];
                
                [request.connectionRequest setHTTPMethod: @"POST"];
                
                [request.connectionRequest setHTTPBody:[soapString dataUsingEncoding:NSUTF8StringEncoding]];
            }
            
            break;
            
        case SEARCH_FUNCLOC_EQUIPMENTS:
            
            request.dataType = NORMAL_DATA;
            request.requestType = requestId;
            request.connectionRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@:%@%@",URL_HOST,URL_PORT,[parameters objectForKey:@"URL_ENDPOINT"]]] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:120.0f];
            request.resultDelegate = delegate;
            
            if (1) {
                
                NSMutableString *soapString = [[NSMutableString alloc] init];
                [soapString appendString:[request mxmlPrefix:requestId]];
                [soapString appendString:[request mxmlBodyWithKeys:parameters Values:nil Action:[self actionWithWebServiceRequest:requestId]]];
                [soapString appendString:[request mxmlSuffix]];
                NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapString length]];
                
                [request.connectionRequest addValue:@"application/soap+xml;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
                
                [request.connectionRequest addValue:@"nosniff" forHTTPHeaderField:@"X-Content-Type-Options"];
                [request.connectionRequest addValue:@"1" forHTTPHeaderField:@"X-XSS-Protection"];
                [request.connectionRequest addValue:@"DENY" forHTTPHeaderField:@"X-Frame-Options"];
                
                [request.connectionRequest addValue:msgLength forHTTPHeaderField:@"Content-Length"];
                
                [request.connectionRequest addValue:@"gzip, deflate" forHTTPHeaderField:@"Accept-Encoding"];
                
                [self decryptforBasicAuth];
                
                NSString *authStr = [NSString stringWithFormat:@"%@:%@",decryptedUserName,decryptedPassword];
                
                NSData *authData = [authStr dataUsingEncoding:NSUTF8StringEncoding];
                
                NSString *authValue = [authData base64EncodedStringWithOptions:0];
                
                [request.connectionRequest addValue:[NSString stringWithFormat:@"Basic %@",authValue] forHTTPHeaderField:@"Authorization"];
                
                [request.connectionRequest setHTTPMethod: @"POST"];
                
                [request.connectionRequest setHTTPBody:[soapString dataUsingEncoding:NSUTF8StringEncoding]];
            }
            
            break;
            
        case GET_LIST_OF_MOVEMENTTYPES:
            
            request.dataType = NORMAL_DATA;
            request.requestType = requestId;
            request.connectionRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@:%@%@",URL_HOST,URL_PORT,[parameters objectForKey:@"URL_ENDPOINT"]]] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:120.0f];
            request.resultDelegate = delegate;
            
            if (1) {
                
                NSMutableString *soapString = [[NSMutableString alloc] init];
                [soapString appendString:[request mxmlPrefix:requestId]];
                [soapString appendString:[request mxmlBodyWithKeys:parameters Values:nil Action:[self actionWithWebServiceRequest:requestId]]];
                [soapString appendString:[request mxmlSuffix]];
                NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapString length]];
                
                [request.connectionRequest addValue:@"application/soap+xml;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
                
                [request.connectionRequest addValue:@"nosniff" forHTTPHeaderField:@"X-Content-Type-Options"];
                [request.connectionRequest addValue:@"1" forHTTPHeaderField:@"X-XSS-Protection"];
                [request.connectionRequest addValue:@"DENY" forHTTPHeaderField:@"X-Frame-Options"];
                
                [request.connectionRequest addValue:msgLength forHTTPHeaderField:@"Content-Length"];
                
                [request.connectionRequest addValue:@"gzip, deflate" forHTTPHeaderField:@"Accept-Encoding"];
                
                [self decryptforBasicAuth];
                
                NSString *authStr = [NSString stringWithFormat:@"%@:%@",decryptedUserName,decryptedPassword];
                
                NSData *authData = [authStr dataUsingEncoding:NSUTF8StringEncoding];
                
                NSString *authValue = [authData base64EncodedStringWithOptions:0];
                
                [request.connectionRequest addValue:[NSString stringWithFormat:@"Basic %@",authValue] forHTTPHeaderField:@"Authorization"];
                
                [request.connectionRequest setHTTPMethod: @"POST"];
                
                [request.connectionRequest setHTTPBody:[soapString dataUsingEncoding:NSUTF8StringEncoding]];
            }
            
            break;
            
        case GET_LIST_OF_WORKCENTER:
            
            request.dataType = NORMAL_DATA;
            request.requestType = requestId;
            request.connectionRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@:%@%@",URL_HOST,URL_PORT,[parameters objectForKey:@"URL_ENDPOINT"]]] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:120.0f];
            request.resultDelegate = delegate;
            
            if (1) {
                
                NSMutableString *soapString = [[NSMutableString alloc] init];
                [soapString appendString:[request mxmlPrefix:requestId]];
                [soapString appendString:[request mxmlBodyWithKeys:parameters Values:nil Action:[self actionWithWebServiceRequest:requestId]]];
                [soapString appendString:[request mxmlSuffix]];
                NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapString length]];
                
                [request.connectionRequest addValue:@"application/soap+xml;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
                
                [request.connectionRequest addValue:@"nosniff" forHTTPHeaderField:@"X-Content-Type-Options"];
                [request.connectionRequest addValue:@"1" forHTTPHeaderField:@"X-XSS-Protection"];
                [request.connectionRequest addValue:@"DENY" forHTTPHeaderField:@"X-Frame-Options"];
                
                [request.connectionRequest addValue:msgLength forHTTPHeaderField:@"Content-Length"];
                
                [request.connectionRequest addValue:@"gzip, deflate" forHTTPHeaderField:@"Accept-Encoding"];
                
                [self decryptforBasicAuth];
                
                NSString *authStr = [NSString stringWithFormat:@"%@:%@",decryptedUserName,decryptedPassword];
                
                NSData *authData = [authStr dataUsingEncoding:NSUTF8StringEncoding];
                
                NSString *authValue = [authData base64EncodedStringWithOptions:0];
                
                [request.connectionRequest addValue:[NSString stringWithFormat:@"Basic %@",authValue] forHTTPHeaderField:@"Authorization"];
                
                [request.connectionRequest setHTTPMethod: @"POST"];
                
                [request.connectionRequest setHTTPBody:[soapString dataUsingEncoding:NSUTF8StringEncoding]];
            }
            
            break;
            
        case GET_LIST_OF_NOTIFICATIONS:
            
            request.dataType = NORMAL_DATA;
            request.requestType = requestId;
            request.connectionRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@:%@%@",URL_HOST,URL_PORT,[parameters objectForKey:@"URL_ENDPOINT"]]] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:120.0f];
            request.resultDelegate = delegate;
            
            if (1) {
                
                NSMutableString *soapString = [[NSMutableString alloc] init];
                [soapString appendString:[request mxmlPrefix:requestId]];
                [soapString appendString:[request mxmlBodyWithKeys:parameters Values:nil Action:[self actionWithWebServiceRequest:requestId]]];
                [soapString appendString:[request mxmlSuffix]];
                NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapString length]];
                
                [request.connectionRequest addValue:@"application/soap+xml;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
                
                [request.connectionRequest addValue:@"nosniff" forHTTPHeaderField:@"X-Content-Type-Options"];
                [request.connectionRequest addValue:@"1" forHTTPHeaderField:@"X-XSS-Protection"];
                [request.connectionRequest addValue:@"DENY" forHTTPHeaderField:@"X-Frame-Options"];
                
                [request.connectionRequest addValue:msgLength forHTTPHeaderField:@"Content-Length"];
                
                [request.connectionRequest addValue:@"gzip, deflate" forHTTPHeaderField:@"Accept-Encoding"];
                
                [self decryptforBasicAuth];
                
                NSString *authStr = [NSString stringWithFormat:@"%@:%@",decryptedUserName,decryptedPassword];
                
                NSData *authData = [authStr dataUsingEncoding:NSUTF8StringEncoding];
                
                NSString *authValue = [authData base64EncodedStringWithOptions:0];
                
                [request.connectionRequest addValue:[NSString stringWithFormat:@"Basic %@",authValue] forHTTPHeaderField:@"Authorization"];
                
                [request.connectionRequest setHTTPMethod: @"POST"];
                
                [request.connectionRequest setHTTPBody:[soapString dataUsingEncoding:NSUTF8StringEncoding]];
            }
            
            break;
            
        case GET_LIST_OF_OPEN_NOTIFICATIONS:
            
            request.dataType = NORMAL_DATA;
            request.requestType = requestId;
            request.connectionRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@:%@%@",URL_HOST,URL_PORT,[parameters objectForKey:@"URL_ENDPOINT"]]] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:120.0f];
            request.resultDelegate = delegate;
            
            if (1) {
                
                NSMutableString *soapString = [[NSMutableString alloc] init];
                [soapString appendString:[request mxmlPrefix:requestId]];
                [soapString appendString:[request mxmlBodyWithKeys:parameters Values:nil Action:[self actionWithWebServiceRequest:requestId]]];
                [soapString appendString:[request mxmlSuffix]];
                NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapString length]];
                
                [request.connectionRequest addValue:@"application/soap+xml;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
                
                [request.connectionRequest addValue:@"nosniff" forHTTPHeaderField:@"X-Content-Type-Options"];
                [request.connectionRequest addValue:@"1" forHTTPHeaderField:@"X-XSS-Protection"];
                [request.connectionRequest addValue:@"DENY" forHTTPHeaderField:@"X-Frame-Options"];
                
                [request.connectionRequest addValue:msgLength forHTTPHeaderField:@"Content-Length"];
                
                [request.connectionRequest addValue:@"gzip, deflate" forHTTPHeaderField:@"Accept-Encoding"];
                
                [self decryptforBasicAuth];
                
                NSString *authStr = [NSString stringWithFormat:@"%@:%@",decryptedUserName,decryptedPassword];
                
                NSData *authData = [authStr dataUsingEncoding:NSUTF8StringEncoding];
                
                NSString *authValue = [authData base64EncodedStringWithOptions:0];
                
                [request.connectionRequest addValue:[NSString stringWithFormat:@"Basic %@",authValue] forHTTPHeaderField:@"Authorization"];
                
                [request.connectionRequest setHTTPMethod: @"POST"];
                
                [request.connectionRequest setHTTPBody:[soapString dataUsingEncoding:NSUTF8StringEncoding]];
            }
            
            break;
            
        case GET_NOTIFICATIONNO_DETAILS:
            
            request.dataType = NORMAL_DATA;
            request.requestType = requestId;
            request.connectionRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@:%@%@",URL_HOST,URL_PORT,[parameters objectForKey:@"URL_ENDPOINT"]]] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:120.0f];
            request.resultDelegate = delegate;
            
            if (1) {
                
                NSMutableString *soapString = [[NSMutableString alloc] init];
                [soapString appendString:[request mxmlPrefix:requestId]];
                [soapString appendString:[request mxmlBodyWithKeys:parameters Values:nil Action:[self actionWithWebServiceRequest:requestId]]];
                [soapString appendString:[request mxmlSuffix]];
                NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapString length]];
                
                [request.connectionRequest addValue:@"application/soap+xml;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
                
                [request.connectionRequest addValue:@"nosniff" forHTTPHeaderField:@"X-Content-Type-Options"];
                [request.connectionRequest addValue:@"1" forHTTPHeaderField:@"X-XSS-Protection"];
                [request.connectionRequest addValue:@"DENY" forHTTPHeaderField:@"X-Frame-Options"];
                
                [request.connectionRequest addValue:msgLength forHTTPHeaderField:@"Content-Length"];
                
                [request.connectionRequest addValue:@"gzip, deflate" forHTTPHeaderField:@"Accept-Encoding"];
                
                [self decryptforBasicAuth];
                
                NSString *authStr = [NSString stringWithFormat:@"%@:%@",decryptedUserName,decryptedPassword];
                
                NSData *authData = [authStr dataUsingEncoding:NSUTF8StringEncoding];
                
                NSString *authValue = [authData base64EncodedStringWithOptions:0];
                
                [request.connectionRequest addValue:[NSString stringWithFormat:@"Basic %@",authValue] forHTTPHeaderField:@"Authorization"];
                
                [request.connectionRequest setHTTPMethod: @"POST"];
                
                [request.connectionRequest setHTTPBody:[soapString dataUsingEncoding:NSUTF8StringEncoding]];
            }
            
            break;
            
        case NOTIFICATION_CREATE:
            
            request.dataType = NORMAL_DATA;
            request.requestType = requestId;
            request.connectionRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@:%@%@",URL_HOST,URL_PORT,[parameters objectForKey:@"URL_ENDPOINT"]]] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:120.0f];
            request.resultDelegate = delegate;
            
            if (1) {
                
                NSMutableString *soapString = [[NSMutableString alloc] init];
                [soapString appendString:[request mxmlPrefix:requestId]];
                [soapString appendString:[request mxmlBodyWithKeys:parameters Values:nil Action:[self actionWithWebServiceRequest:requestId]]];
                [soapString appendString:[request mxmlSuffix]];
                NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapString length]];
                
                [request.connectionRequest addValue:@"application/soap+xml;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
                
                [request.connectionRequest addValue:@"nosniff" forHTTPHeaderField:@"X-Content-Type-Options"];
                [request.connectionRequest addValue:@"1" forHTTPHeaderField:@"X-XSS-Protection"];
                [request.connectionRequest addValue:@"DENY" forHTTPHeaderField:@"X-Frame-Options"];
                
                [request.connectionRequest addValue:msgLength forHTTPHeaderField:@"Content-Length"];
                
                [request.connectionRequest addValue:@"gzip, deflate" forHTTPHeaderField:@"Accept-Encoding"];
                
                [self decryptforBasicAuth];
                
                NSString *authStr = [NSString stringWithFormat:@"%@:%@",decryptedUserName,decryptedPassword];
                
                NSData *authData = [authStr dataUsingEncoding:NSUTF8StringEncoding];
                
                NSString *authValue = [authData base64EncodedStringWithOptions:0];
                
                [request.connectionRequest addValue:[NSString stringWithFormat:@"Basic %@",authValue] forHTTPHeaderField:@"Authorization"];
                
                [request.connectionRequest setHTTPMethod: @"POST"];
                
                [request.connectionRequest setHTTPBody:[soapString dataUsingEncoding:NSUTF8StringEncoding]];
            }
            
            break;
            
        case NOTIFICATION_CHANGE:
            
            request.dataType = NORMAL_DATA;
            request.requestType = requestId;
            request.connectionRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@:%@%@",URL_HOST,URL_PORT,[parameters objectForKey:@"URL_ENDPOINT"]]] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:120.0f];
            request.resultDelegate = delegate;
            
            if (1) {
                
                NSMutableString *soapString = [[NSMutableString alloc] init];
                [soapString appendString:[request mxmlPrefix:requestId]];
                [soapString appendString:[request mxmlBodyWithKeys:parameters Values:nil Action:[self actionWithWebServiceRequest:requestId]]];
                [soapString appendString:[request mxmlSuffix]];
                NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapString length]];
                
                [request.connectionRequest addValue:@"application/soap+xml;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
                
                [request.connectionRequest addValue:@"nosniff" forHTTPHeaderField:@"X-Content-Type-Options"];
                [request.connectionRequest addValue:@"1" forHTTPHeaderField:@"X-XSS-Protection"];
                [request.connectionRequest addValue:@"DENY" forHTTPHeaderField:@"X-Frame-Options"];
                
                [request.connectionRequest addValue:msgLength forHTTPHeaderField:@"Content-Length"];
                
                [request.connectionRequest addValue:@"gzip, deflate" forHTTPHeaderField:@"Accept-Encoding"];
                
                [self decryptforBasicAuth];
                
                NSString *authStr = [NSString stringWithFormat:@"%@:%@",decryptedUserName,decryptedPassword];
                
                NSData *authData = [authStr dataUsingEncoding:NSUTF8StringEncoding];
                
                NSString *authValue = [authData base64EncodedStringWithOptions:0];
                
                [request.connectionRequest addValue:[NSString stringWithFormat:@"Basic %@",authValue] forHTTPHeaderField:@"Authorization"];
                
                [request.connectionRequest setHTTPMethod: @"POST"];
                
                //[request.connectionRequest setHTTPBody:[soapString dataUsingEncoding:NSUTF8StringEncoding]];
                
                [request.connectionRequest setHTTPBody:[soapString dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES]];
                
                //                NSData *postData = [soapString dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
            }
            
            break;
            
        case NOTIFICATION_CANCEL:
            
            request.dataType = NORMAL_DATA;
            request.requestType = requestId;
            request.connectionRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@:%@%@",URL_HOST,URL_PORT,[parameters objectForKey:@"URL_ENDPOINT"]]] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:120.0f];
            request.resultDelegate = delegate;
            
            if (1) {
                
                NSMutableString *soapString = [[NSMutableString alloc] init];
                [soapString appendString:[request mxmlPrefix:requestId]];
                [soapString appendString:[request mxmlBodyWithKeys:parameters Values:nil Action:[self actionWithWebServiceRequest:requestId]]];
                [soapString appendString:[request mxmlSuffix]];
                NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapString length]];
                
                [request.connectionRequest addValue:@"application/soap+xml;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
                
                [request.connectionRequest addValue:@"nosniff" forHTTPHeaderField:@"X-Content-Type-Options"];
                [request.connectionRequest addValue:@"1" forHTTPHeaderField:@"X-XSS-Protection"];
                [request.connectionRequest addValue:@"DENY" forHTTPHeaderField:@"X-Frame-Options"];
                
                [request.connectionRequest addValue:msgLength forHTTPHeaderField:@"Content-Length"];
                
                [request.connectionRequest addValue:@"gzip, deflate" forHTTPHeaderField:@"Accept-Encoding"];
                
                [self decryptforBasicAuth];
                
                NSString *authStr = [NSString stringWithFormat:@"%@:%@",decryptedUserName,decryptedPassword];
                
                NSData *authData = [authStr dataUsingEncoding:NSUTF8StringEncoding];
                
                NSString *authValue = [authData base64EncodedStringWithOptions:0];
                
                [request.connectionRequest addValue:[NSString stringWithFormat:@"Basic %@",authValue] forHTTPHeaderField:@"Authorization"];
                
                [request.connectionRequest setHTTPMethod: @"POST"];
                
                [request.connectionRequest setHTTPBody:[soapString dataUsingEncoding:NSUTF8StringEncoding]];
            }
            
            break;
            
        case NOTIFICATION_COMPLETE:
            
            request.dataType = NORMAL_DATA;
            request.requestType = requestId;
            request.connectionRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@:%@%@",URL_HOST,URL_PORT,[parameters objectForKey:@"URL_ENDPOINT"]]] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:120.0f];
            request.resultDelegate = delegate;
            
            if (1) {
                
                NSMutableString *soapString = [[NSMutableString alloc] init];
                [soapString appendString:[request mxmlPrefix:requestId]];
                [soapString appendString:[request mxmlBodyWithKeys:parameters Values:nil Action:[self actionWithWebServiceRequest:requestId]]];
                [soapString appendString:[request mxmlSuffix]];
                NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapString length]];
                
                [request.connectionRequest addValue:@"application/soap+xml;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
                
                [request.connectionRequest addValue:@"nosniff" forHTTPHeaderField:@"X-Content-Type-Options"];
                [request.connectionRequest addValue:@"1" forHTTPHeaderField:@"X-XSS-Protection"];
                [request.connectionRequest addValue:@"DENY" forHTTPHeaderField:@"X-Frame-Options"];
                
                [request.connectionRequest addValue:msgLength forHTTPHeaderField:@"Content-Length"];
                
                [request.connectionRequest addValue:@"gzip, deflate" forHTTPHeaderField:@"Accept-Encoding"];
                
                [self decryptforBasicAuth];
                
                NSString *authStr = [NSString stringWithFormat:@"%@:%@",decryptedUserName,decryptedPassword];
                
                NSData *authData = [authStr dataUsingEncoding:NSUTF8StringEncoding];
                
                NSString *authValue = [authData base64EncodedStringWithOptions:0];
                
                [request.connectionRequest addValue:[NSString stringWithFormat:@"Basic %@",authValue] forHTTPHeaderField:@"Authorization"];
                
                [request.connectionRequest setHTTPMethod: @"POST"];
                
                [request.connectionRequest setHTTPBody:[soapString dataUsingEncoding:NSUTF8StringEncoding]];
            }
            
            break;
            
        case GET_LIST_OF_DUE_NOTIFICATIONS:
            
            request.dataType = NORMAL_DATA;
            request.requestType = requestId;
            request.connectionRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@:%@%@",URL_HOST,URL_PORT,[parameters objectForKey:@"URL_ENDPOINT"]]] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:120.0f];
            request.resultDelegate = delegate;
            
            if (1) {
                
                NSMutableString *soapString = [[NSMutableString alloc] init];
                [soapString appendString:[request mxmlPrefix:requestId]];
                [soapString appendString:[request mxmlBodyWithKeys:parameters Values:nil Action:[self actionWithWebServiceRequest:requestId]]];
                [soapString appendString:[request mxmlSuffix]];
                NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapString length]];
                
                [request.connectionRequest addValue:@"application/soap+xml;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
                
                [request.connectionRequest addValue:@"nosniff" forHTTPHeaderField:@"X-Content-Type-Options"];
                [request.connectionRequest addValue:@"1" forHTTPHeaderField:@"X-XSS-Protection"];
                [request.connectionRequest addValue:@"DENY" forHTTPHeaderField:@"X-Frame-Options"];
                
                [request.connectionRequest addValue:msgLength forHTTPHeaderField:@"Content-Length"];
                
                [request.connectionRequest addValue:@"gzip, deflate" forHTTPHeaderField:@"Accept-Encoding"];
                
                [self decryptforBasicAuth];
                
                NSString *authStr = [NSString stringWithFormat:@"%@:%@",decryptedUserName,decryptedPassword];
                
                NSData *authData = [authStr dataUsingEncoding:NSUTF8StringEncoding];
                
                NSString *authValue = [authData base64EncodedStringWithOptions:0];
                
                [request.connectionRequest addValue:[NSString stringWithFormat:@"Basic %@",authValue] forHTTPHeaderField:@"Authorization"];
                
                [request.connectionRequest setHTTPMethod: @"POST"];
                
                [request.connectionRequest setHTTPBody:[soapString dataUsingEncoding:NSUTF8StringEncoding]];
            }
            
            break;
            
        case GET_ORDERNO_DETAILS:
            
            request.dataType = NORMAL_DATA;
            request.requestType = requestId;
            request.connectionRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@:%@%@",URL_HOST,URL_PORT,[parameters objectForKey:@"URL_ENDPOINT"]]] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:120.0f];
            request.resultDelegate = delegate;
            
            if (1) {
                
                NSMutableString *soapString = [[NSMutableString alloc] init];
                [soapString appendString:[request mxmlPrefix:requestId]];
                [soapString appendString:[request mxmlBodyWithKeys:parameters Values:nil Action:[self actionWithWebServiceRequest:requestId]]];
                [soapString appendString:[request mxmlSuffix]];
                NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapString length]];
                
                [request.connectionRequest addValue:@"application/soap+xml;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
                
                [request.connectionRequest addValue:@"nosniff" forHTTPHeaderField:@"X-Content-Type-Options"];
                [request.connectionRequest addValue:@"1" forHTTPHeaderField:@"X-XSS-Protection"];
                [request.connectionRequest addValue:@"DENY" forHTTPHeaderField:@"X-Frame-Options"];
                
                [request.connectionRequest addValue:msgLength forHTTPHeaderField:@"Content-Length"];
                
                [request.connectionRequest addValue:@"gzip, deflate" forHTTPHeaderField:@"Accept-Encoding"];
                
                [self decryptforBasicAuth];
                
                NSString *authStr = [NSString stringWithFormat:@"%@:%@",decryptedUserName,decryptedPassword];
                
                NSData *authData = [authStr dataUsingEncoding:NSUTF8StringEncoding];
                
                NSString *authValue = [authData base64EncodedStringWithOptions:0];
                
                [request.connectionRequest addValue:[NSString stringWithFormat:@"Basic %@",authValue] forHTTPHeaderField:@"Authorization"];
                
                [request.connectionRequest setHTTPMethod: @"POST"];
                
                [request.connectionRequest setHTTPBody:[soapString dataUsingEncoding:NSUTF8StringEncoding]];
            }
            
            break;
            
            
        case ORDER_CREATE:
            
            request.dataType = NORMAL_DATA;
            request.requestType = requestId;
            request.connectionRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@:%@%@",URL_HOST,URL_PORT,[parameters objectForKey:@"URL_ENDPOINT"]]] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:120.0f];
            request.resultDelegate = delegate;
            
            if (1) {
                
                NSMutableString *soapString = [[NSMutableString alloc] init];
                [soapString appendString:[request mxmlPrefix:requestId]];
                [soapString appendString:[request mxmlBodyWithKeys:parameters Values:nil Action:[self actionWithWebServiceRequest:requestId]]];
                [soapString appendString:[request mxmlSuffix]];
                NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapString length]];
                
                [request.connectionRequest addValue:@"application/soap+xml;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
                
                [request.connectionRequest addValue:@"nosniff" forHTTPHeaderField:@"X-Content-Type-Options"];
                [request.connectionRequest addValue:@"1" forHTTPHeaderField:@"X-XSS-Protection"];
                [request.connectionRequest addValue:@"DENY" forHTTPHeaderField:@"X-Frame-Options"];
                
                [request.connectionRequest addValue:msgLength forHTTPHeaderField:@"Content-Length"];
                
                [request.connectionRequest addValue:@"gzip, deflate" forHTTPHeaderField:@"Accept-Encoding"];
                
                [self decryptforBasicAuth];
                
                NSString *authStr = [NSString stringWithFormat:@"%@:%@",decryptedUserName,decryptedPassword];
                
                NSData *authData = [authStr dataUsingEncoding:NSUTF8StringEncoding];
                
                NSString *authValue = [authData base64EncodedStringWithOptions:0];
                
                [request.connectionRequest addValue:[NSString stringWithFormat:@"Basic %@",authValue] forHTTPHeaderField:@"Authorization"];
                
                [request.connectionRequest setHTTPMethod: @"POST"];
                
                [request.connectionRequest setHTTPBody:[soapString dataUsingEncoding:NSUTF8StringEncoding]];
            }
            
            break;
            
        case GET_LIST_OF_ORDERS:
            
            request.dataType = NORMAL_DATA;
            request.requestType = requestId;
            request.connectionRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@:%@%@",URL_HOST,URL_PORT,[parameters objectForKey:@"URL_ENDPOINT"]]] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:120.0f];
            request.resultDelegate = delegate;
            
            if (1) {
                
                NSMutableString *soapString = [[NSMutableString alloc] init];
                [soapString appendString:[request mxmlPrefix:requestId]];
                [soapString appendString:[request mxmlBodyWithKeys:parameters Values:nil Action:[self actionWithWebServiceRequest:requestId]]];
                [soapString appendString:[request mxmlSuffix]];
                NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapString length]];
                
                [request.connectionRequest addValue:@"application/soap+xml;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
                
                [request.connectionRequest addValue:@"nosniff" forHTTPHeaderField:@"X-Content-Type-Options"];
                [request.connectionRequest addValue:@"1" forHTTPHeaderField:@"X-XSS-Protection"];
                [request.connectionRequest addValue:@"DENY" forHTTPHeaderField:@"X-Frame-Options"];
                
                [request.connectionRequest addValue:msgLength forHTTPHeaderField:@"Content-Length"];
                
                [request.connectionRequest addValue:@"gzip, deflate" forHTTPHeaderField:@"Accept-Encoding"];
                
                [self decryptforBasicAuth];
                
                NSString *authStr = [NSString stringWithFormat:@"%@:%@",decryptedUserName,decryptedPassword];
                
                NSData *authData = [authStr dataUsingEncoding:NSUTF8StringEncoding];
                
                NSString *authValue = [authData base64EncodedStringWithOptions:0];
                
                [request.connectionRequest addValue:[NSString stringWithFormat:@"Basic %@",authValue] forHTTPHeaderField:@"Authorization"];
                
                [request.connectionRequest setHTTPMethod: @"POST"];
                
                [request.connectionRequest setHTTPBody:[soapString dataUsingEncoding:NSUTF8StringEncoding]];
            }
            
            break;
            
        case GET_LIST_OF_OPEN_ORDERS:
            
            request.dataType = NORMAL_DATA;
            request.requestType = requestId;
            request.connectionRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@:%@%@",URL_HOST,URL_PORT,[parameters objectForKey:@"URL_ENDPOINT"]]] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:120.0f];
            request.resultDelegate = delegate;
            
            if (1) {
                
                NSMutableString *soapString = [[NSMutableString alloc] init];
                [soapString appendString:[request mxmlPrefix:requestId]];
                [soapString appendString:[request mxmlBodyWithKeys:parameters Values:nil Action:[self actionWithWebServiceRequest:requestId]]];
                [soapString appendString:[request mxmlSuffix]];
                NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapString length]];
                
                [request.connectionRequest addValue:@"application/soap+xml;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
                
                [request.connectionRequest addValue:@"nosniff" forHTTPHeaderField:@"X-Content-Type-Options"];
                [request.connectionRequest addValue:@"1" forHTTPHeaderField:@"X-XSS-Protection"];
                [request.connectionRequest addValue:@"DENY" forHTTPHeaderField:@"X-Frame-Options"];
                
                [request.connectionRequest addValue:msgLength forHTTPHeaderField:@"Content-Length"];
                
                [request.connectionRequest addValue:@"gzip, deflate" forHTTPHeaderField:@"Accept-Encoding"];
                
                [self decryptforBasicAuth];
                
                NSString *authStr = [NSString stringWithFormat:@"%@:%@",decryptedUserName,decryptedPassword];
                
                NSData *authData = [authStr dataUsingEncoding:NSUTF8StringEncoding];
                
                NSString *authValue = [authData base64EncodedStringWithOptions:0];
                
                [request.connectionRequest addValue:[NSString stringWithFormat:@"Basic %@",authValue] forHTTPHeaderField:@"Authorization"];
                
                [request.connectionRequest setHTTPMethod: @"POST"];
                
                [request.connectionRequest setHTTPBody:[soapString dataUsingEncoding:NSUTF8StringEncoding]];
            }
            
            break;
            
        case ORDER_CHANGE:
            
            request.dataType = NORMAL_DATA;
            request.requestType = requestId;
            request.connectionRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@:%@%@",URL_HOST,URL_PORT,[parameters objectForKey:@"URL_ENDPOINT"]]] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:120.0f];
            request.resultDelegate = delegate;
            
            if (1) {
                
                NSMutableString *soapString = [[NSMutableString alloc] init];
                [soapString appendString:[request mxmlPrefix:requestId]];
                [soapString appendString:[request mxmlBodyWithKeys:parameters Values:nil Action:[self actionWithWebServiceRequest:requestId]]];
                [soapString appendString:[request mxmlSuffix]];
                
                
                NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapString length]];
                
                [request.connectionRequest addValue:@"application/soap+xml;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
                
                [request.connectionRequest addValue:@"nosniff" forHTTPHeaderField:@"X-Content-Type-Options"];
                [request.connectionRequest addValue:@"1" forHTTPHeaderField:@"X-XSS-Protection"];
                [request.connectionRequest addValue:@"DENY" forHTTPHeaderField:@"X-Frame-Options"];
                
                [request.connectionRequest addValue:msgLength forHTTPHeaderField:@"Content-Length"];
                
                [request.connectionRequest addValue:@"gzip, deflate" forHTTPHeaderField:@"Accept-Encoding"];
                
                [self decryptforBasicAuth];
                
                NSString *authStr = [NSString stringWithFormat:@"%@:%@",decryptedUserName,decryptedPassword];
                
                NSData *authData = [authStr dataUsingEncoding:NSUTF8StringEncoding];
                
                NSString *authValue = [authData base64EncodedStringWithOptions:0];
                
                [request.connectionRequest addValue:[NSString stringWithFormat:@"Basic %@",authValue] forHTTPHeaderField:@"Authorization"];
                
                [request.connectionRequest setHTTPMethod: @"POST"];
                
                [request.connectionRequest setHTTPBody:[soapString dataUsingEncoding:NSUTF8StringEncoding]];
            }
            
            break;
            
        case ORDER_WOCO:
            
            request.dataType = NORMAL_DATA;
            request.requestType = requestId;
            request.connectionRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@:%@%@",URL_HOST,URL_PORT,[parameters objectForKey:@"URL_ENDPOINT"]]] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:120.0f];
            request.resultDelegate = delegate;
            
            if (1) {
                
                NSMutableString *soapString = [[NSMutableString alloc] init];
                [soapString appendString:[request mxmlPrefix:requestId]];
                [soapString appendString:[request mxmlBodyWithKeys:parameters Values:nil Action:[self actionWithWebServiceRequest:requestId]]];
                [soapString appendString:[request mxmlSuffix]];
                
                
                NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapString length]];
                
                [request.connectionRequest addValue:@"application/soap+xml;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
                
                [request.connectionRequest addValue:@"nosniff" forHTTPHeaderField:@"X-Content-Type-Options"];
                [request.connectionRequest addValue:@"1" forHTTPHeaderField:@"X-XSS-Protection"];
                [request.connectionRequest addValue:@"DENY" forHTTPHeaderField:@"X-Frame-Options"];
                
                [request.connectionRequest addValue:msgLength forHTTPHeaderField:@"Content-Length"];
                
                [request.connectionRequest addValue:@"gzip, deflate" forHTTPHeaderField:@"Accept-Encoding"];
                
                [self decryptforBasicAuth];
                
                NSString *authStr = [NSString stringWithFormat:@"%@:%@",decryptedUserName,decryptedPassword];
                
                NSData *authData = [authStr dataUsingEncoding:NSUTF8StringEncoding];
                
                NSString *authValue = [authData base64EncodedStringWithOptions:0];
                
                [request.connectionRequest addValue:[NSString stringWithFormat:@"Basic %@",authValue] forHTTPHeaderField:@"Authorization"];
                
                [request.connectionRequest setHTTPMethod: @"POST"];
                
                [request.connectionRequest setHTTPBody:[soapString dataUsingEncoding:NSUTF8StringEncoding]];
            }
            
            break;
            
            
        case ORDER_CANCEL:
            
            request.dataType = NORMAL_DATA;
            request.requestType = requestId;
            request.connectionRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@:%@%@",URL_HOST,URL_PORT,[parameters objectForKey:@"URL_ENDPOINT"]]] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:120.0f];
            request.resultDelegate = delegate;
            
            if (1) {
                
                NSMutableString *soapString = [[NSMutableString alloc] init];
                [soapString appendString:[request mxmlPrefix:requestId]];
                [soapString appendString:[request mxmlBodyWithKeys:parameters Values:nil Action:[self actionWithWebServiceRequest:requestId]]];
                [soapString appendString:[request mxmlSuffix]];
                NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapString length]];
                
                [request.connectionRequest addValue:@"application/soap+xml;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
                
                [request.connectionRequest addValue:@"nosniff" forHTTPHeaderField:@"X-Content-Type-Options"];
                [request.connectionRequest addValue:@"1" forHTTPHeaderField:@"X-XSS-Protection"];
                [request.connectionRequest addValue:@"DENY" forHTTPHeaderField:@"X-Frame-Options"];
                
                [request.connectionRequest addValue:msgLength forHTTPHeaderField:@"Content-Length"];
                
                [request.connectionRequest addValue:@"gzip, deflate" forHTTPHeaderField:@"Accept-Encoding"];
                
                [self decryptforBasicAuth];
                
                NSString *authStr = [NSString stringWithFormat:@"%@:%@",decryptedUserName,decryptedPassword];
                
                NSData *authData = [authStr dataUsingEncoding:NSUTF8StringEncoding];
                
                NSString *authValue = [authData base64EncodedStringWithOptions:0];
                
                [request.connectionRequest addValue:[NSString stringWithFormat:@"Basic %@",authValue] forHTTPHeaderField:@"Authorization"];
                
                [request.connectionRequest setHTTPMethod: @"POST"];
                
                [request.connectionRequest setHTTPBody:[soapString dataUsingEncoding:NSUTF8StringEncoding]];
            }
            
            break;
            
        case ORDER_CONFIRM:
            
            request.dataType = NORMAL_DATA;
            request.requestType = requestId;
            request.connectionRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@:%@%@",URL_HOST,URL_PORT,[parameters objectForKey:@"URL_ENDPOINT"]]] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:120.0f];
            request.resultDelegate = delegate;
            
            if (1) {
                
                NSMutableString *soapString = [[NSMutableString alloc] init];
                [soapString appendString:[request mxmlPrefix:requestId]];
                [soapString appendString:[request mxmlBodyWithKeys:parameters Values:nil Action:[self actionWithWebServiceRequest:requestId]]];
                [soapString appendString:[request mxmlSuffix]];
                NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapString length]];
                
                [request.connectionRequest addValue:@"application/soap+xml;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
                
                [request.connectionRequest addValue:@"nosniff" forHTTPHeaderField:@"X-Content-Type-Options"];
                [request.connectionRequest addValue:@"1" forHTTPHeaderField:@"X-XSS-Protection"];
                [request.connectionRequest addValue:@"DENY" forHTTPHeaderField:@"X-Frame-Options"];
                
                [request.connectionRequest addValue:msgLength forHTTPHeaderField:@"Content-Length"];
                
                [request.connectionRequest addValue:@"gzip, deflate" forHTTPHeaderField:@"Accept-Encoding"];
                
                [self decryptforBasicAuth];
                
                NSString *authStr = [NSString stringWithFormat:@"%@:%@",decryptedUserName,decryptedPassword];
                
                NSData *authData = [authStr dataUsingEncoding:NSUTF8StringEncoding];
                
                NSString *authValue = [authData base64EncodedStringWithOptions:0];
                
                [request.connectionRequest addValue:[NSString stringWithFormat:@"Basic %@",authValue] forHTTPHeaderField:@"Authorization"];
                
                [request.connectionRequest setHTTPMethod: @"POST"];
                
                [request.connectionRequest setHTTPBody:[soapString dataUsingEncoding:NSUTF8StringEncoding]];
            }
            
            break;
            
        case ORDER_COLLECTIVE_CONFIRMATION:
            
            request.dataType = NORMAL_DATA;
            request.requestType = requestId;
            request.connectionRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@:%@%@",URL_HOST,URL_PORT,[parameters objectForKey:@"URL_ENDPOINT"]]] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:120.0f];
            request.resultDelegate = delegate;
            
            if (1) {
                
                NSMutableString *soapString = [[NSMutableString alloc] init];
                [soapString appendString:[request mxmlPrefix:requestId]];
                [soapString appendString:[request mxmlBodyWithKeys:parameters Values:nil Action:[self actionWithWebServiceRequest:requestId]]];
                [soapString appendString:[request mxmlSuffix]];
                NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapString length]];
                
                [request.connectionRequest addValue:@"application/soap+xml;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
                
                [request.connectionRequest addValue:@"nosniff" forHTTPHeaderField:@"X-Content-Type-Options"];
                [request.connectionRequest addValue:@"1" forHTTPHeaderField:@"X-XSS-Protection"];
                [request.connectionRequest addValue:@"DENY" forHTTPHeaderField:@"X-Frame-Options"];
                
                [request.connectionRequest addValue:msgLength forHTTPHeaderField:@"Content-Length"];
                
                [request.connectionRequest addValue:@"gzip, deflate" forHTTPHeaderField:@"Accept-Encoding"];
                
                [self decryptforBasicAuth];
                
                NSString *authStr = [NSString stringWithFormat:@"%@:%@",decryptedUserName,decryptedPassword];
                
                NSData *authData = [authStr dataUsingEncoding:NSUTF8StringEncoding];
                
                NSString *authValue = [authData base64EncodedStringWithOptions:0];
                
                [request.connectionRequest addValue:[NSString stringWithFormat:@"Basic %@",authValue] forHTTPHeaderField:@"Authorization"];
                
                [request.connectionRequest setHTTPMethod: @"POST"];
                
                [request.connectionRequest setHTTPBody:[soapString dataUsingEncoding:NSUTF8StringEncoding]];
            }
            
            break;
            
        case GET_LIST_OF_DUE_ORDERS:
            
            request.dataType = NORMAL_DATA;
            request.requestType = requestId;
            request.connectionRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@:%@%@",URL_HOST,URL_PORT,[parameters objectForKey:@"URL_ENDPOINT"]]] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:120.0f];
            request.resultDelegate = delegate;
            
            if (1) {
                
                NSMutableString *soapString = [[NSMutableString alloc] init];
                [soapString appendString:[request mxmlPrefix:requestId]];
                [soapString appendString:[request mxmlBodyWithKeys:parameters Values:nil Action:[self actionWithWebServiceRequest:requestId]]];
                [soapString appendString:[request mxmlSuffix]];
                NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapString length]];
                
                [request.connectionRequest addValue:@"application/soap+xml;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
                
                [request.connectionRequest addValue:@"nosniff" forHTTPHeaderField:@"X-Content-Type-Options"];
                [request.connectionRequest addValue:@"1" forHTTPHeaderField:@"X-XSS-Protection"];
                [request.connectionRequest addValue:@"DENY" forHTTPHeaderField:@"X-Frame-Options"];
                
                [request.connectionRequest addValue:msgLength forHTTPHeaderField:@"Content-Length"];
                
                [request.connectionRequest addValue:@"gzip, deflate" forHTTPHeaderField:@"Accept-Encoding"];
                
                [self decryptforBasicAuth];
                
                NSString *authStr = [NSString stringWithFormat:@"%@:%@",decryptedUserName,decryptedPassword];
                
                NSData *authData = [authStr dataUsingEncoding:NSUTF8StringEncoding];
                
                NSString *authValue = [authData base64EncodedStringWithOptions:0];
                
                [request.connectionRequest addValue:[NSString stringWithFormat:@"Basic %@",authValue] forHTTPHeaderField:@"Authorization"];
                
                [request.connectionRequest setHTTPMethod: @"POST"];
                
                [request.connectionRequest setHTTPBody:[soapString dataUsingEncoding:NSUTF8StringEncoding]];
            }
            
            break;
            
        case GET_LIST_OF_PM_BOMS:
            
            request.dataType = LARGE_DATA;
            request.requestType = requestId;
            request.connectionRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@:%@%@",URL_HOST,URL_PORT,[parameters objectForKey:@"URL_ENDPOINT"]]] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:120.0f];
            request.resultDelegate = delegate;
            
            if (1) {
                
                NSMutableString *soapString = [[NSMutableString alloc] init];
                [soapString appendString:[request mxmlPrefix:requestId]];
                [soapString appendString:[request mxmlBodyWithKeys:parameters Values:nil Action:[self actionWithWebServiceRequest:requestId]]];
                [soapString appendString:[request mxmlSuffix]];
                NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapString length]];
                
                [request.connectionRequest addValue:@"application/soap+xml;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
                
                [request.connectionRequest addValue:@"nosniff" forHTTPHeaderField:@"X-Content-Type-Options"];
                [request.connectionRequest addValue:@"1" forHTTPHeaderField:@"X-XSS-Protection"];
                [request.connectionRequest addValue:@"DENY" forHTTPHeaderField:@"X-Frame-Options"];
                
                [request.connectionRequest addValue:msgLength forHTTPHeaderField:@"Content-Length"];
                
                [request.connectionRequest addValue:@"gzip, deflate" forHTTPHeaderField:@"Accept-Encoding"];
                
                [self decryptforBasicAuth];
                
                NSString *authStr = [NSString stringWithFormat:@"%@:%@",decryptedUserName,decryptedPassword];
                
                NSData *authData = [authStr dataUsingEncoding:NSUTF8StringEncoding];
                
                NSString *authValue = [authData base64EncodedStringWithOptions:0];
                
                [request.connectionRequest addValue:[NSString stringWithFormat:@"Basic %@",authValue] forHTTPHeaderField:@"Authorization"];
                
                [request.connectionRequest setHTTPMethod: @"POST"];
                
                [request.connectionRequest setHTTPBody:[soapString dataUsingEncoding:NSUTF8StringEncoding]];
            }
            
            break;
            
        case UTILITY_RESERVE:
            
            request.dataType = NORMAL_DATA;
            request.requestType = requestId;
            request.connectionRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@:%@%@",URL_HOST,URL_PORT,[parameters objectForKey:@"URL_ENDPOINT"]]] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:120.0f];
            request.resultDelegate = delegate;
            
            if (1) {
                
                NSMutableString *soapString = [[NSMutableString alloc] init];
                [soapString appendString:[request mxmlPrefix:requestId]];
                [soapString appendString:[request mxmlBodyWithKeys:parameters Values:nil Action:[self actionWithWebServiceRequest:requestId]]];
                [soapString appendString:[request mxmlSuffix]];
                NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapString length]];
                
                [request.connectionRequest addValue:@"application/soap+xml;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
                
                [request.connectionRequest addValue:@"nosniff" forHTTPHeaderField:@"X-Content-Type-Options"];
                [request.connectionRequest addValue:@"1" forHTTPHeaderField:@"X-XSS-Protection"];
                [request.connectionRequest addValue:@"DENY" forHTTPHeaderField:@"X-Frame-Options"];
                
                [request.connectionRequest addValue:msgLength forHTTPHeaderField:@"Content-Length"];
                
                [request.connectionRequest addValue:@"gzip, deflate" forHTTPHeaderField:@"Accept-Encoding"];
                
                [self decryptforBasicAuth];
                
                NSString *authStr = [NSString stringWithFormat:@"%@:%@",decryptedUserName,decryptedPassword];
                
                NSData *authData = [authStr dataUsingEncoding:NSUTF8StringEncoding];
                
                NSString *authValue = [authData base64EncodedStringWithOptions:0];
                
                [request.connectionRequest addValue:[NSString stringWithFormat:@"Basic %@",authValue] forHTTPHeaderField:@"Authorization"];
                
                [request.connectionRequest setHTTPMethod: @"POST"];
                
                [request.connectionRequest setHTTPBody:[soapString dataUsingEncoding:NSUTF8StringEncoding]];
            }
            
            break;
            
        case GET_STOCK_DATA:
            
            request.dataType = NORMAL_DATA;
            request.requestType = requestId;
            request.connectionRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@:%@%@",URL_HOST,URL_PORT,[parameters objectForKey:@"URL_ENDPOINT"]]] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:120.0f];
            request.resultDelegate = delegate;
            
            if (1) {
                
                NSMutableString *soapString = [[NSMutableString alloc] init];
                [soapString appendString:[request mxmlPrefix:requestId]];
                [soapString appendString:[request mxmlBodyWithKeys:parameters Values:nil Action:[self actionWithWebServiceRequest:requestId]]];
                [soapString appendString:[request mxmlSuffix]];
                NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapString length]];
                
                [request.connectionRequest addValue:@"application/soap+xml;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
                
                [request.connectionRequest addValue:@"nosniff" forHTTPHeaderField:@"X-Content-Type-Options"];
                [request.connectionRequest addValue:@"1" forHTTPHeaderField:@"X-XSS-Protection"];
                [request.connectionRequest addValue:@"DENY" forHTTPHeaderField:@"X-Frame-Options"];
                
                [request.connectionRequest addValue:msgLength forHTTPHeaderField:@"Content-Length"];
                
                [request.connectionRequest addValue:@"gzip, deflate" forHTTPHeaderField:@"Accept-Encoding"];
                
                [self decryptforBasicAuth];
                
                NSString *authStr = [NSString stringWithFormat:@"%@:%@",decryptedUserName,decryptedPassword];
                
                NSData *authData = [authStr dataUsingEncoding:NSUTF8StringEncoding];
                
                NSString *authValue = [authData base64EncodedStringWithOptions:0];
                
                [request.connectionRequest addValue:[NSString stringWithFormat:@"Basic %@",authValue] forHTTPHeaderField:@"Authorization"];
                
                [request.connectionRequest setHTTPMethod: @"POST"];
                
                [request.connectionRequest setHTTPBody:[soapString dataUsingEncoding:NSUTF8StringEncoding]];
            }
            
            break;
            
        case GET_LOG_DATA:
            
            request.dataType = NORMAL_DATA;
            request.requestType = requestId;
            request.connectionRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@:%@%@",URL_HOST,URL_PORT,[parameters objectForKey:@"URL_ENDPOINT"]]] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:120.0f];
            request.resultDelegate = delegate;
            
            if (1) {
                
                NSMutableString *soapString = [[NSMutableString alloc] init];
                [soapString appendString:[request mxmlPrefix:requestId]];
                [soapString appendString:[request mxmlBodyWithKeys:parameters Values:nil Action:[self actionWithWebServiceRequest:requestId]]];
                [soapString appendString:[request mxmlSuffix]];
                NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapString length]];
                
                [request.connectionRequest addValue:@"application/soap+xml;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
                
                [request.connectionRequest addValue:@"nosniff" forHTTPHeaderField:@"X-Content-Type-Options"];
                [request.connectionRequest addValue:@"1" forHTTPHeaderField:@"X-XSS-Protection"];
                [request.connectionRequest addValue:@"DENY" forHTTPHeaderField:@"X-Frame-Options"];
                
                [request.connectionRequest addValue:msgLength forHTTPHeaderField:@"Content-Length"];
                
                [request.connectionRequest addValue:@"gzip, deflate" forHTTPHeaderField:@"Accept-Encoding"];
                
                [self decryptforBasicAuth];
                
                NSString *authStr = [NSString stringWithFormat:@"%@:%@",decryptedUserName,decryptedPassword];
                
                NSData *authData = [authStr dataUsingEncoding:NSUTF8StringEncoding];
                
                NSString *authValue = [authData base64EncodedStringWithOptions:0];
                
                [request.connectionRequest addValue:[NSString stringWithFormat:@"Basic %@",authValue] forHTTPHeaderField:@"Authorization"];
                
                [request.connectionRequest setHTTPMethod: @"POST"];
                
                [request.connectionRequest setHTTPBody:[soapString dataUsingEncoding:NSUTF8StringEncoding]];
            }
            
            break;
            
        case GET_MATERIAL_AVAILABILITY_CHECK:
            
            request.dataType = NORMAL_DATA;
            request.requestType = requestId;
            request.connectionRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@:%@%@",URL_HOST,URL_PORT,[parameters objectForKey:@"URL_ENDPOINT"]]] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:120.0f];
            request.resultDelegate = delegate;
            
            if (1) {
                
                NSMutableString *soapString = [[NSMutableString alloc] init];
                [soapString appendString:[request mxmlPrefix:requestId]];
                [soapString appendString:[request mxmlBodyWithKeys:parameters Values:nil Action:[self actionWithWebServiceRequest:requestId]]];
                [soapString appendString:[request mxmlSuffix]];
                NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapString length]];
                
                [request.connectionRequest addValue:@"application/soap+xml;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
                
                [request.connectionRequest addValue:@"nosniff" forHTTPHeaderField:@"X-Content-Type-Options"];
                [request.connectionRequest addValue:@"1" forHTTPHeaderField:@"X-XSS-Protection"];
                [request.connectionRequest addValue:@"DENY" forHTTPHeaderField:@"X-Frame-Options"];
                
                [request.connectionRequest addValue:msgLength forHTTPHeaderField:@"Content-Length"];
                
                [request.connectionRequest addValue:@"gzip, deflate" forHTTPHeaderField:@"Accept-Encoding"];
                
                [self decryptforBasicAuth];
                
                NSString *authStr = [NSString stringWithFormat:@"%@:%@",decryptedUserName,decryptedPassword];
                
                NSData *authData = [authStr dataUsingEncoding:NSUTF8StringEncoding];
                
                NSString *authValue = [authData base64EncodedStringWithOptions:0];
                
                [request.connectionRequest addValue:[NSString stringWithFormat:@"Basic %@",authValue] forHTTPHeaderField:@"Authorization"];
                
                [request.connectionRequest setHTTPMethod: @"POST"];
                
                [request.connectionRequest setHTTPBody:[soapString dataUsingEncoding:NSUTF8StringEncoding]];
            }
            
            break;
            
        case GET_PERMITS_DATA:
            
            request.dataType = NORMAL_DATA;
            request.requestType = requestId;
            request.connectionRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@:%@%@",URL_HOST,URL_PORT,[parameters objectForKey:@"URL_ENDPOINT"]]] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:120.0f];
            request.resultDelegate = delegate;
            
            if (1) {
                
                NSMutableString *soapString = [[NSMutableString alloc] init];
                [soapString appendString:[request mxmlPrefix:requestId]];
                [soapString appendString:[request mxmlBodyWithKeys:parameters Values:nil Action:[self actionWithWebServiceRequest:requestId]]];
                [soapString appendString:[request mxmlSuffix]];
                NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapString length]];
                
                [request.connectionRequest addValue:@"application/soap+xml;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
                
                [request.connectionRequest addValue:@"nosniff" forHTTPHeaderField:@"X-Content-Type-Options"];
                [request.connectionRequest addValue:@"1" forHTTPHeaderField:@"X-XSS-Protection"];
                [request.connectionRequest addValue:@"DENY" forHTTPHeaderField:@"X-Frame-Options"];
                
                [request.connectionRequest addValue:msgLength forHTTPHeaderField:@"Content-Length"];
                
                [request.connectionRequest addValue:@"gzip, deflate" forHTTPHeaderField:@"Accept-Encoding"];
                
                [self decryptforBasicAuth];
                
                NSString *authStr = [NSString stringWithFormat:@"%@:%@",decryptedUserName,decryptedPassword];
                
                NSData *authData = [authStr dataUsingEncoding:NSUTF8StringEncoding];
                
                NSString *authValue = [authData base64EncodedStringWithOptions:0];
                
                [request.connectionRequest addValue:[NSString stringWithFormat:@"Basic %@",authValue] forHTTPHeaderField:@"Authorization"];
                
                [request.connectionRequest setHTTPMethod: @"POST"];
                
                [request.connectionRequest setHTTPBody:[soapString dataUsingEncoding:NSUTF8StringEncoding]];
            }
            
            break;
            
        case GET_CONFRIM_REASON:
            
            request.dataType = NORMAL_DATA;
            request.requestType = requestId;
            request.connectionRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@:%@%@",URL_HOST,URL_PORT,[parameters objectForKey:@"URL_ENDPOINT"]]] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:120.0f];
            request.resultDelegate = delegate;
            
            if (1) {
                
                NSMutableString *soapString = [[NSMutableString alloc] init];
                [soapString appendString:[request mxmlPrefix:requestId]];
                [soapString appendString:[request mxmlBodyWithKeys:parameters Values:nil Action:[self actionWithWebServiceRequest:requestId]]];
                [soapString appendString:[request mxmlSuffix]];
                NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapString length]];
                
                [request.connectionRequest addValue:@"application/soap+xml;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
                
                [request.connectionRequest addValue:@"nosniff" forHTTPHeaderField:@"X-Content-Type-Options"];
                [request.connectionRequest addValue:@"1" forHTTPHeaderField:@"X-XSS-Protection"];
                [request.connectionRequest addValue:@"DENY" forHTTPHeaderField:@"X-Frame-Options"];
                
                [request.connectionRequest addValue:msgLength forHTTPHeaderField:@"Content-Length"];
                
                [request.connectionRequest addValue:@"gzip, deflate" forHTTPHeaderField:@"Accept-Encoding"];
                
                [self decryptforBasicAuth];
                
                NSString *authStr = [NSString stringWithFormat:@"%@:%@",decryptedUserName,decryptedPassword];
                
                NSData *authData = [authStr dataUsingEncoding:NSUTF8StringEncoding];
                
                NSString *authValue = [authData base64EncodedStringWithOptions:0];
                
                [request.connectionRequest addValue:[NSString stringWithFormat:@"Basic %@",authValue] forHTTPHeaderField:@"Authorization"];
                
                [request.connectionRequest setHTTPMethod: @"POST"];
                
                [request.connectionRequest setHTTPBody:[soapString dataUsingEncoding:NSUTF8StringEncoding]];
            }
            
            break;
            
        case GET_DOCUMENTS:
            
            request.dataType = NORMAL_DATA;
            request.requestType = requestId;
            request.connectionRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@:%@%@",URL_HOST,URL_PORT,[parameters objectForKey:@"URL_ENDPOINT"]]] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:120.0f];
            request.resultDelegate = delegate;
            
            if (1) {
                
                NSMutableString *soapString = [[NSMutableString alloc] init];
                [soapString appendString:[request mxmlPrefix:requestId]];
                [soapString appendString:[request mxmlBodyWithKeys:parameters Values:nil Action:[self actionWithWebServiceRequest:requestId]]];
                [soapString appendString:[request mxmlSuffix]];
                NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapString length]];
                
                [request.connectionRequest addValue:@"application/soap+xml;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
                
                [request.connectionRequest addValue:@"nosniff" forHTTPHeaderField:@"X-Content-Type-Options"];
                [request.connectionRequest addValue:@"1" forHTTPHeaderField:@"X-XSS-Protection"];
                [request.connectionRequest addValue:@"DENY" forHTTPHeaderField:@"X-Frame-Options"];
                
                [request.connectionRequest addValue:msgLength forHTTPHeaderField:@"Content-Length"];
                
                [request.connectionRequest addValue:@"gzip, deflate" forHTTPHeaderField:@"Accept-Encoding"];
                
                [self decryptforBasicAuth];
                
                NSString *authStr = [NSString stringWithFormat:@"%@:%@",decryptedUserName,decryptedPassword];
                
                NSData *authData = [authStr dataUsingEncoding:NSUTF8StringEncoding];
                
                NSString *authValue = [authData base64EncodedStringWithOptions:0];
                
                [request.connectionRequest addValue:[NSString stringWithFormat:@"Basic %@",authValue] forHTTPHeaderField:@"Authorization"];
                
                [request.connectionRequest setHTTPMethod: @"POST"];
                
                [request.connectionRequest setHTTPBody:[soapString dataUsingEncoding:NSUTF8StringEncoding]];
            }
            
            break;
            
        case CREATE_NOTIF_ORDER:
            
            request.dataType = NORMAL_DATA;
            request.requestType = requestId;
            request.connectionRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@:%@%@",URL_HOST,URL_PORT,[parameters objectForKey:@"URL_ENDPOINT"]]] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:120.0f];
            request.resultDelegate = delegate;
            
            if (1) {
                
                NSMutableString *soapString = [[NSMutableString alloc] init];
                [soapString appendString:[request mxmlPrefix:requestId]];
                [soapString appendString:[request mxmlBodyWithKeys:parameters Values:nil Action:[self actionWithWebServiceRequest:requestId]]];
                [soapString appendString:[request mxmlSuffix]];
                NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapString length]];
                
                [request.connectionRequest addValue:@"application/soap+xml;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
                
                [request.connectionRequest addValue:@"nosniff" forHTTPHeaderField:@"X-Content-Type-Options"];
                [request.connectionRequest addValue:@"1" forHTTPHeaderField:@"X-XSS-Protection"];
                [request.connectionRequest addValue:@"DENY" forHTTPHeaderField:@"X-Frame-Options"];
                
                [request.connectionRequest addValue:msgLength forHTTPHeaderField:@"Content-Length"];
                
                [request.connectionRequest addValue:@"gzip, deflate" forHTTPHeaderField:@"Accept-Encoding"];
                
                [self decryptforBasicAuth];
                
                NSString *authStr = [NSString stringWithFormat:@"%@:%@",decryptedUserName,decryptedPassword];
                
                NSData *authData = [authStr dataUsingEncoding:NSUTF8StringEncoding];
                
                NSString *authValue = [authData base64EncodedStringWithOptions:0];
                
                [request.connectionRequest addValue:[NSString stringWithFormat:@"Basic %@",authValue] forHTTPHeaderField:@"Authorization"];
                
                [request.connectionRequest setHTTPMethod: @"POST"];
                
                [request.connectionRequest setHTTPBody:[soapString dataUsingEncoding:NSUTF8StringEncoding]];
            }
            
            break;
            
        case GET_SETTINGS_DATA:
            
            request.dataType = NORMAL_DATA;
            request.requestType = requestId;
            request.connectionRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@:%@%@",URL_HOST,URL_PORT,[parameters objectForKey:@"URL_ENDPOINT"]]] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:120.0f];
            request.resultDelegate = delegate;
            
            if (1) {
                
                NSMutableString *soapString = [[NSMutableString alloc] init];
                [soapString appendString:[request mxmlPrefix:requestId]];
                [soapString appendString:[request mxmlBodyWithKeys:parameters Values:nil Action:[self actionWithWebServiceRequest:requestId]]];
                [soapString appendString:[request mxmlSuffix]];
                NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapString length]];
                
                [request.connectionRequest addValue:@"application/soap+xml;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
                
                [request.connectionRequest addValue:@"nosniff" forHTTPHeaderField:@"X-Content-Type-Options"];
                [request.connectionRequest addValue:@"1" forHTTPHeaderField:@"X-XSS-Protection"];
                [request.connectionRequest addValue:@"DENY" forHTTPHeaderField:@"X-Frame-Options"];
                
                [request.connectionRequest addValue:msgLength forHTTPHeaderField:@"Content-Length"];
                
                [request.connectionRequest addValue:@"gzip, deflate" forHTTPHeaderField:@"Accept-Encoding"];
                
                [self decryptforBasicAuth];
                
                NSString *authStr = [NSString stringWithFormat:@"%@:%@",decryptedUserName,decryptedPassword];
                
                NSData *authData = [authStr dataUsingEncoding:NSUTF8StringEncoding];
                
                NSString *authValue = [authData base64EncodedStringWithOptions:0];
                
                [request.connectionRequest addValue:[NSString stringWithFormat:@"Basic %@",authValue] forHTTPHeaderField:@"Authorization"];
                
                [request.connectionRequest setHTTPMethod: @"POST"];
                
                [request.connectionRequest setHTTPBody:[soapString dataUsingEncoding:NSUTF8StringEncoding]];
            }
            
            break;
            
        case GET_AUTH_DATA:
            
            request.dataType = NORMAL_DATA;
            request.requestType = requestId;
            request.connectionRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@:%@%@",URL_HOST,URL_PORT,[parameters objectForKey:@"URL_ENDPOINT"]]] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:120.0f];
            request.resultDelegate = delegate;
            
            if (1) {
                
                NSMutableString *soapString = [[NSMutableString alloc] init];
                [soapString appendString:[request mxmlPrefix:requestId]];
                [soapString appendString:[request mxmlBodyWithKeys:parameters Values:nil Action:[self actionWithWebServiceRequest:requestId]]];
                [soapString appendString:[request mxmlSuffix]];
                NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapString length]];
                
                [request.connectionRequest addValue:@"application/soap+xml;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
                
                [request.connectionRequest addValue:@"nosniff" forHTTPHeaderField:@"X-Content-Type-Options"];
                [request.connectionRequest addValue:@"1" forHTTPHeaderField:@"X-XSS-Protection"];
                [request.connectionRequest addValue:@"DENY" forHTTPHeaderField:@"X-Frame-Options"];
                
                [request.connectionRequest addValue:msgLength forHTTPHeaderField:@"Content-Length"];
                
                [request.connectionRequest addValue:@"gzip, deflate" forHTTPHeaderField:@"Accept-Encoding"];
                
                [self decryptforBasicAuth];
                
                NSString *authStr = [NSString stringWithFormat:@"%@:%@",decryptedUserName,decryptedPassword];
                
                NSData *authData = [authStr dataUsingEncoding:NSUTF8StringEncoding];
                
                NSString *authValue = [authData base64EncodedStringWithOptions:0];
                
                [request.connectionRequest addValue:[NSString stringWithFormat:@"Basic %@",authValue] forHTTPHeaderField:@"Authorization"];
                
                [request.connectionRequest setHTTPMethod: @"POST"];
                
                [request.connectionRequest setHTTPBody:[soapString dataUsingEncoding:NSUTF8StringEncoding]];
            }
            
            break;
            
        case SEARCH_PLANTMAINT:
            
            request.dataType = NORMAL_DATA;
            request.requestType = requestId;
            request.connectionRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@:%@%@",URL_HOST,URL_PORT,[parameters objectForKey:@"URL_ENDPOINT"]]] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:120.0f];
            request.resultDelegate = delegate;
            
            if (1) {
                
                NSMutableString *soapString = [[NSMutableString alloc] init];
                [soapString appendString:[request mxmlPrefix:requestId]];
                [soapString appendString:[request mxmlBodyWithKeys:parameters Values:nil Action:[self actionWithWebServiceRequest:requestId]]];
                [soapString appendString:[request mxmlSuffix]];
                NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapString length]];
                
                [request.connectionRequest addValue:@"application/soap+xml;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
                
                [request.connectionRequest addValue:@"nosniff" forHTTPHeaderField:@"X-Content-Type-Options"];
                [request.connectionRequest addValue:@"1" forHTTPHeaderField:@"X-XSS-Protection"];
                [request.connectionRequest addValue:@"DENY" forHTTPHeaderField:@"X-Frame-Options"];
                
                [request.connectionRequest addValue:msgLength forHTTPHeaderField:@"Content-Length"];
                
                [request.connectionRequest addValue:@"gzip, deflate" forHTTPHeaderField:@"Accept-Encoding"];
                
                [self decryptforBasicAuth];
                
                NSString *authStr = [NSString stringWithFormat:@"%@:%@",decryptedUserName,decryptedPassword];
                
                NSData *authData = [authStr dataUsingEncoding:NSUTF8StringEncoding];
                
                NSString *authValue = [authData base64EncodedStringWithOptions:0];
                
                [request.connectionRequest addValue:[NSString stringWithFormat:@"Basic %@",authValue] forHTTPHeaderField:@"Authorization"];
                
                [request.connectionRequest setHTTPMethod: @"POST"];
                
                [request.connectionRequest setHTTPBody:[soapString dataUsingEncoding:NSUTF8StringEncoding]];
            }
            
            break;
            
        case GET_WSM_MASTERDATA:
            
            request.dataType = NORMAL_DATA;
            request.requestType = requestId;
            request.connectionRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@:%@%@",URL_HOST,URL_PORT,[parameters objectForKey:@"URL_ENDPOINT"]]] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:120.0f];
            request.resultDelegate = delegate;
            
            if (1) {
                
                NSMutableString *soapString = [[NSMutableString alloc] init];
                [soapString appendString:[request mxmlPrefix:requestId]];
                [soapString appendString:[request mxmlBodyWithKeys:parameters Values:nil Action:[self actionWithWebServiceRequest:requestId]]];
                [soapString appendString:[request mxmlSuffix]];
                NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapString length]];
                
                [request.connectionRequest addValue:@"application/soap+xml;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
                
                [request.connectionRequest addValue:@"nosniff" forHTTPHeaderField:@"X-Content-Type-Options"];
                [request.connectionRequest addValue:@"1" forHTTPHeaderField:@"X-XSS-Protection"];
                [request.connectionRequest addValue:@"DENY" forHTTPHeaderField:@"X-Frame-Options"];
                
                [request.connectionRequest addValue:msgLength forHTTPHeaderField:@"Content-Length"];
                
                [request.connectionRequest addValue:@"gzip, deflate" forHTTPHeaderField:@"Accept-Encoding"];
                
                [self decryptforBasicAuth];
                
                NSString *authStr = [NSString stringWithFormat:@"%@:%@",decryptedUserName,decryptedPassword];
                
                NSData *authData = [authStr dataUsingEncoding:NSUTF8StringEncoding];
                
                NSString *authValue = [authData base64EncodedStringWithOptions:0];
                
                [request.connectionRequest addValue:[NSString stringWithFormat:@"Basic %@",authValue] forHTTPHeaderField:@"Authorization"];
                
                [request.connectionRequest setHTTPMethod: @"POST"];
                
                [request.connectionRequest setHTTPBody:[soapString dataUsingEncoding:NSUTF8StringEncoding]];
            }
            
            break;
            
        case BREAKDOWN_STATISTICS:
            
            request.dataType = NORMAL_DATA;
            request.requestType = requestId;
            
            request.connectionRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@:%@%@",URL_HOST,URL_PORT,[parameters objectForKey:@"URL_ENDPOINT"]]] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:120.0f];
            
            //            request.connectionRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://103.6.157.25:3227/sap/bc/srt/pm/sap/zemt_pmapp_ws_bi_bkdn_stat/800/local/zemt_ftekpro/1/binding_t_http_a_http_zemt_pmapp_ws_bi_bkdn_stat_zemt_ftekpro_l"] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:120.0f];
            
            request.resultDelegate = delegate;
            
            if (1) {
                
                NSMutableString *soapString = [[NSMutableString alloc] init];
                [soapString appendString:[request mxmlPrefix:requestId]];
                [soapString appendString:[request mxmlBodyWithKeys:parameters Values:nil Action:[self actionWithWebServiceRequest:requestId]]];
                [soapString appendString:[request mxmlSuffix]];
                NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapString length]];
                
                [request.connectionRequest addValue:@"application/soap+xml;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
                
                [request.connectionRequest addValue:@"nosniff" forHTTPHeaderField:@"X-Content-Type-Options"];
                [request.connectionRequest addValue:@"1" forHTTPHeaderField:@"X-XSS-Protection"];
                [request.connectionRequest addValue:@"DENY" forHTTPHeaderField:@"X-Frame-Options"];
                
                [request.connectionRequest addValue:msgLength forHTTPHeaderField:@"Content-Length"];
                
                [request.connectionRequest addValue:@"gzip, deflate" forHTTPHeaderField:@"Accept-Encoding"];
                
                [self decryptforBasicAuth];
                
                NSString *authStr = [NSString stringWithFormat:@"%@:%@",decryptedUserName,decryptedPassword];
                //NSString *authStr = [NSString stringWithFormat:@"kamal:enst786"];
                
                NSData *authData = [authStr dataUsingEncoding:NSUTF8StringEncoding];
                
                NSString *authValue = [authData base64EncodedStringWithOptions:0];
                
                [request.connectionRequest addValue:[NSString stringWithFormat:@"Basic %@",authValue] forHTTPHeaderField:@"Authorization"];
                
                [request.connectionRequest setHTTPMethod: @"POST"];
                
                [request.connectionRequest setHTTPBody:[soapString dataUsingEncoding:NSUTF8StringEncoding]];
                
            }
            
            break;
            
        case NOTIFICATION_ANALYSIS:
            
            request.dataType = NORMAL_DATA;
            request.requestType = requestId;
            
            //            request.connectionRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@:%@%@%@",URL_HOST,URL_PORT,URL_PATH,URL_NOTIFICATIONS_REPORT]] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:120.0f];
            //            request.connectionRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@:%@%@%@",URL_HOST,URL_PORT,URL_PATH,URL_NOTIFICATIONS_REPORT]] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:120.0f];
            //            request.connectionRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://103.6.157.25:3227/sap/bc/srt/rfc/sap/zemt_pmapp_ws_bi_notif_rep/800/bi_notif_rep/binding"] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:120.0f];
            
            request.connectionRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@:%@%@",URL_HOST,URL_PORT,[parameters objectForKey:@"URL_ENDPOINT"]]] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:120.0f];
            
            request.resultDelegate = delegate;
            
            if (1) {
                
                NSMutableString *soapString = [[NSMutableString alloc] init];
                [soapString appendString:[request mxmlPrefix:requestId]];
                [soapString appendString:[request mxmlBodyWithKeys:parameters Values:nil Action:[self actionWithWebServiceRequest:requestId]]];
                [soapString appendString:[request mxmlSuffix]];
                NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapString length]];
                
                [request.connectionRequest addValue:@"application/soap+xml;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
                
                [request.connectionRequest addValue:@"nosniff" forHTTPHeaderField:@"X-Content-Type-Options"];
                [request.connectionRequest addValue:@"1" forHTTPHeaderField:@"X-XSS-Protection"];
                [request.connectionRequest addValue:@"DENY" forHTTPHeaderField:@"X-Frame-Options"];
                
                [request.connectionRequest addValue:msgLength forHTTPHeaderField:@"Content-Length"];
                
                [request.connectionRequest addValue:@"gzip, deflate" forHTTPHeaderField:@"Accept-Encoding"];
                
                [self decryptforBasicAuth];
                
                NSString *authStr = [NSString stringWithFormat:@"%@:%@",decryptedUserName,decryptedPassword];
                //                NSString *authStr = [NSString stringWithFormat:@"kamal:enst786"];
                
                NSData *authData = [authStr dataUsingEncoding:NSUTF8StringEncoding];
                
                NSString *authValue = [authData base64EncodedStringWithOptions:0];
                
                [request.connectionRequest addValue:[NSString stringWithFormat:@"Basic %@",authValue] forHTTPHeaderField:@"Authorization"];
                
                [request.connectionRequest setHTTPMethod: @"POST"];
                
                [request.connectionRequest setHTTPBody:[soapString dataUsingEncoding:NSUTF8StringEncoding]];
                
            }
            
            break;
            
        case ORDER_ANALYSIS:
            
            request.dataType = NORMAL_DATA;
            request.requestType = requestId;
            
            request.connectionRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@:%@%@",URL_HOST,URL_PORT,[parameters objectForKey:@"URL_ENDPOINT"]]] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:120.0f];
            
            //             request.connectionRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://103.6.157.25:3227/sap/bc/srt/rfc/sap/zemt_pmapp_ws_bi_ord_rep/800/bi_ord_rep/binding"] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:120.0f];
            request.resultDelegate = delegate;
            
            if (1) {
                
                NSMutableString *soapString = [[NSMutableString alloc] init];
                [soapString appendString:[request mxmlPrefix:requestId]];
                [soapString appendString:[request mxmlBodyWithKeys:parameters Values:nil Action:[self actionWithWebServiceRequest:requestId]]];
                [soapString appendString:[request mxmlSuffix]];
                NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapString length]];
                
                [request.connectionRequest addValue:@"application/soap+xml;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
                
                [request.connectionRequest addValue:@"nosniff" forHTTPHeaderField:@"X-Content-Type-Options"];
                [request.connectionRequest addValue:@"1" forHTTPHeaderField:@"X-XSS-Protection"];
                [request.connectionRequest addValue:@"DENY" forHTTPHeaderField:@"X-Frame-Options"];
                
                [request.connectionRequest addValue:msgLength forHTTPHeaderField:@"Content-Length"];
                
                [request.connectionRequest addValue:@"gzip, deflate" forHTTPHeaderField:@"Accept-Encoding"];
                
                [self decryptforBasicAuth];
                
                NSString *authStr = [NSString stringWithFormat:@"%@:%@",decryptedUserName,decryptedPassword];
                //                NSString *authStr = [NSString stringWithFormat:@"kamal:enst786"];
                
                NSData *authData = [authStr dataUsingEncoding:NSUTF8StringEncoding];
                
                NSString *authValue = [authData base64EncodedStringWithOptions:0];
                
                [request.connectionRequest addValue:[NSString stringWithFormat:@"Basic %@",authValue] forHTTPHeaderField:@"Authorization"];
                
                [request.connectionRequest setHTTPMethod: @"POST"];
                
                [request.connectionRequest setHTTPBody:[soapString dataUsingEncoding:NSUTF8StringEncoding]];
                
            }
            
            break;
            
            
        case MAINTAINANCE_SET_CHECK_LIST:
            
            request.dataType = NORMAL_DATA;
            request.requestType = requestId;
            request.connectionRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@:%@%@zemt_pmapp_ws_set_mchk_list/800/local/zemt_ftekpro/1/binding_t_http_a_http_zemt_pmapp_ws_set_mchk_list_zemt_ftekpro_l",URL_HOST,URL_PORT,URL_PATH]] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:120.0f];
            request.resultDelegate = delegate;
            
            if (1) {
                
                NSMutableString *soapString = [[NSMutableString alloc] init];
                [soapString appendString:[request mxmlPrefix:requestId]];
                [soapString appendString:[request mxmlBodyWithKeys:parameters Values:nil Action:[self actionWithWebServiceRequest:requestId]]];
                [soapString appendString:[request mxmlSuffix]];
                NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapString length]];
                
                [request.connectionRequest addValue:@"application/soap+xml;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
                
                [request.connectionRequest addValue:@"nosniff" forHTTPHeaderField:@"X-Content-Type-Options"];
                [request.connectionRequest addValue:@"1" forHTTPHeaderField:@"X-XSS-Protection"];
                [request.connectionRequest addValue:@"DENY" forHTTPHeaderField:@"X-Frame-Options"];
                
                [request.connectionRequest addValue:msgLength forHTTPHeaderField:@"Content-Length"];
                
                [request.connectionRequest addValue:@"gzip, deflate" forHTTPHeaderField:@"Accept-Encoding"];
                
                [self decryptforBasicAuth];
                
                NSString *authStr = [NSString stringWithFormat:@"%@:%@",decryptedUserName,decryptedPassword];
                
                NSData *authData = [authStr dataUsingEncoding:NSUTF8StringEncoding];
                
                NSString *authValue = [authData base64EncodedStringWithOptions:0];
                
                [request.connectionRequest addValue:[NSString stringWithFormat:@"Basic %@",authValue] forHTTPHeaderField:@"Authorization"];
                
                [request.connectionRequest setHTTPMethod: @"POST"];
                
                [request.connectionRequest setHTTPBody:[soapString dataUsingEncoding:NSUTF8StringEncoding]];
                
                // NSLog(@"MAINTAINANCE_SET_CHECK_LIST : %@",soapString);
            }
            
            break;
            
        case MAINTAINANCE_GET_CHECK_LIST:
            
            request.dataType = NORMAL_DATA;
            request.requestType = requestId;
            
            request.connectionRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@:%@%@zemt_pmapp_ws_get_mchk_list/800/local/zemt_ftekpro/1/binding_t_http_a_http_zemt_pmapp_ws_get_mchk_list_zemt_ftekpro_l",URL_HOST,URL_PORT,URL_PATH]] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:120.0f];
            
            request.resultDelegate = delegate;
            
            if (1) {
                
                NSMutableString *soapString = [[NSMutableString alloc] init];
                [soapString appendString:[request mxmlPrefix:requestId]];
                [soapString appendString:[request mxmlBodyWithKeys:parameters Values:nil Action:[self actionWithWebServiceRequest:requestId]]];
                [soapString appendString:[request mxmlSuffix]];
                NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapString length]];
                
                [request.connectionRequest addValue:@"application/soap+xml;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
                
                [request.connectionRequest addValue:@"nosniff" forHTTPHeaderField:@"X-Content-Type-Options"];
                [request.connectionRequest addValue:@"1" forHTTPHeaderField:@"X-XSS-Protection"];
                [request.connectionRequest addValue:@"DENY" forHTTPHeaderField:@"X-Frame-Options"];
                
                [request.connectionRequest addValue:msgLength forHTTPHeaderField:@"Content-Length"];
                
                [request.connectionRequest addValue:@"gzip, deflate" forHTTPHeaderField:@"Accept-Encoding"];
                
                [self decryptforBasicAuth];
                
                NSString *authStr = [NSString stringWithFormat:@"%@:%@",decryptedUserName,decryptedPassword];
                
                NSData *authData = [authStr dataUsingEncoding:NSUTF8StringEncoding];
                
                NSString *authValue = [authData base64EncodedStringWithOptions:0];
                
                [request.connectionRequest addValue:[NSString stringWithFormat:@"Basic %@",authValue] forHTTPHeaderField:@"Authorization"];
                
                [request.connectionRequest setHTTPMethod: @"POST"];
                
                [request.connectionRequest setHTTPBody:[soapString dataUsingEncoding:NSUTF8StringEncoding]];
            }
            
            break;
            
        case GET_NFC_SETTINGS:
            
            request.dataType = NORMAL_DATA;
            request.requestType = requestId;
            
            request.connectionRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@:%@%@",URL_HOST,URL_PORT,[parameters objectForKey:@"URL_ENDPOINT"]]] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:120.0f];
            
            request.resultDelegate = delegate;
            
            if (1) {
                
                NSMutableString *soapString = [[NSMutableString alloc] init];
                [soapString appendString:[request mxmlPrefix:requestId]];
                [soapString appendString:[request mxmlBodyWithKeys:parameters Values:nil Action:[self actionWithWebServiceRequest:requestId]]];
                [soapString appendString:[request mxmlSuffix]];
                NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapString length]];
                
                [request.connectionRequest addValue:@"application/soap+xml;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
                
                [request.connectionRequest addValue:@"nosniff" forHTTPHeaderField:@"X-Content-Type-Options"];
                [request.connectionRequest addValue:@"1" forHTTPHeaderField:@"X-XSS-Protection"];
                [request.connectionRequest addValue:@"DENY" forHTTPHeaderField:@"X-Frame-Options"];
                
                [request.connectionRequest addValue:msgLength forHTTPHeaderField:@"Content-Length"];
                
                [request.connectionRequest addValue:@"gzip, deflate" forHTTPHeaderField:@"Accept-Encoding"];
                
                [self decryptforBasicAuth];
                
                NSString *authStr = [NSString stringWithFormat:@"%@:%@",decryptedUserName,decryptedPassword];
                
                NSData *authData = [authStr dataUsingEncoding:NSUTF8StringEncoding];
                
                NSString *authValue = [authData base64EncodedStringWithOptions:0];
                
                [request.connectionRequest addValue:[NSString stringWithFormat:@"Basic %@",authValue] forHTTPHeaderField:@"Authorization"];
                
                [request.connectionRequest setHTTPMethod: @"POST"];
                
                [request.connectionRequest setHTTPBody:[soapString dataUsingEncoding:NSUTF8StringEncoding]];
            }
            
            break;
            
        case PERMIT_REPORT:
            
            request.dataType = NORMAL_DATA;
            request.requestType = requestId;
            
            //            request.connectionRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@:%@%@%@",URL_HOST,URL_PORT,URL_PATH,URL_PERMIT_REPORT]] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:120.0f];
            //            request.connectionRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@:%@%@",URL_HOST,URL_PORT,[parameters objectForKey:@"URL_ENDPOINT"]]] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:120.0f];
            //            //http://103.6.157.25:3227"+ "/sap/bc/srt/rfc/sap/zemt_pmapp_ws_bi_permit_rep/800/bi_permit_rep/binding
            
            request.connectionRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@:%@%@",URL_HOST,URL_PORT,[parameters objectForKey:@"URL_ENDPOINT"]]] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:120.0f];
            request.resultDelegate = delegate;
            
            if (1) {
                
                NSMutableString *soapString = [[NSMutableString alloc] init];
                [soapString appendString:[request mxmlPrefix:requestId]];
                [soapString appendString:[request mxmlBodyWithKeys:parameters Values:nil Action:[self actionWithWebServiceRequest:requestId]]];
                [soapString appendString:[request mxmlSuffix]];
                NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapString length]];
                
                [request.connectionRequest addValue:@"application/soap+xml;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
                
                [request.connectionRequest addValue:@"nosniff" forHTTPHeaderField:@"X-Content-Type-Options"];
                [request.connectionRequest addValue:@"1" forHTTPHeaderField:@"X-XSS-Protection"];
                [request.connectionRequest addValue:@"DENY" forHTTPHeaderField:@"X-Frame-Options"];
                
                [request.connectionRequest addValue:msgLength forHTTPHeaderField:@"Content-Length"];
                
                [request.connectionRequest addValue:@"gzip, deflate" forHTTPHeaderField:@"Accept-Encoding"];
                
                [self decryptforBasicAuth];
                
                NSString *authStr = [NSString stringWithFormat:@"%@:%@",decryptedUserName,decryptedPassword];
                //                NSString *authStr = [NSString stringWithFormat:@"kamal:enst786"];
                
                NSData *authData = [authStr dataUsingEncoding:NSUTF8StringEncoding];
                
                NSString *authValue = [authData base64EncodedStringWithOptions:0];
                
                [request.connectionRequest addValue:[NSString stringWithFormat:@"Basic %@",authValue] forHTTPHeaderField:@"Authorization"];
                
                [request.connectionRequest setHTTPMethod: @"POST"];
                
                [request.connectionRequest setHTTPBody:[soapString dataUsingEncoding:NSUTF8StringEncoding]];
                
            }
            
            break;
            
        case GET_INITIAL_ZIP:
            
            request.dataType = NORMAL_DATA;
            request.requestType = requestId;
            
            request.connectionRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@:%@%@%@",URL_HOST,URL_PORT,URL_PATH,URL_GET_INITIAL_ZIP]] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:120.0f];
            
            request.resultDelegate = delegate;
            
            if (1) {
                
                NSMutableString *soapString = [[NSMutableString alloc] init];
                [soapString appendString:[request mxmlPrefix:requestId]];
                [soapString appendString:[request mxmlBodyWithKeys:parameters Values:nil Action:[self actionWithWebServiceRequest:requestId]]];
                [soapString appendString:[request mxmlSuffix]];
                NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapString length]];
                
                [request.connectionRequest addValue:@"application/soap+xml;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
                
                [request.connectionRequest addValue:@"nosniff" forHTTPHeaderField:@"X-Content-Type-Options"];
                [request.connectionRequest addValue:@"1" forHTTPHeaderField:@"X-XSS-Protection"];
                [request.connectionRequest addValue:@"DENY" forHTTPHeaderField:@"X-Frame-Options"];
                
                [request.connectionRequest addValue:msgLength forHTTPHeaderField:@"Content-Length"];
                
                [request.connectionRequest addValue:@"gzip, deflate" forHTTPHeaderField:@"Accept-Encoding"];
                
                [self decryptforBasicAuth];
                
                NSString *authStr = [NSString stringWithFormat:@"%@:%@",decryptedUserName,decryptedPassword];
                
                NSData *authData = [authStr dataUsingEncoding:NSUTF8StringEncoding];
                
                NSString *authValue = [authData base64EncodedStringWithOptions:0];
                
                [request.connectionRequest addValue:[NSString stringWithFormat:@"Basic %@",authValue] forHTTPHeaderField:@"Authorization"];
                
                [request.connectionRequest setHTTPMethod: @"POST"];
                
                [request.connectionRequest setHTTPBody:[soapString dataUsingEncoding:NSUTF8StringEncoding]];
                
            }
            
            break;
            
        case AVAILABILITY_REPORT:
            
            request.dataType = NORMAL_DATA;
            request.requestType = requestId;
            
            request.connectionRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@:%@%@",URL_HOST,URL_PORT,[parameters objectForKey:@"URL_ENDPOINT"]]] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:120.0f];
            
            request.resultDelegate = delegate;
            
            if (1) {
                
                NSMutableString *soapString = [[NSMutableString alloc] init];
                [soapString appendString:[request mxmlPrefix:requestId]];
                [soapString appendString:[request mxmlBodyWithKeys:parameters Values:nil Action:[self actionWithWebServiceRequest:requestId]]];
                [soapString appendString:[request mxmlSuffix]];
                NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapString length]];
                
                [request.connectionRequest addValue:@"application/soap+xml;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
                
                [request.connectionRequest addValue:@"nosniff" forHTTPHeaderField:@"X-Content-Type-Options"];
                [request.connectionRequest addValue:@"1" forHTTPHeaderField:@"X-XSS-Protection"];
                [request.connectionRequest addValue:@"DENY" forHTTPHeaderField:@"X-Frame-Options"];
                
                [request.connectionRequest addValue:msgLength forHTTPHeaderField:@"Content-Length"];
                
                [request.connectionRequest addValue:@"gzip, deflate" forHTTPHeaderField:@"Accept-Encoding"];
                
                [self decryptforBasicAuth];
                NSString *authStr = [NSString stringWithFormat:@"%@:%@",decryptedUserName,decryptedPassword];
                
                NSData *authData = [authStr dataUsingEncoding:NSUTF8StringEncoding];
                
                NSString *authValue = [authData base64EncodedStringWithOptions:0];
                
                [request.connectionRequest addValue:[NSString stringWithFormat:@"Basic %@",authValue] forHTTPHeaderField:@"Authorization"];
                
                [request.connectionRequest setHTTPMethod: @"POST"];
                
                [request.connectionRequest setHTTPBody:[soapString dataUsingEncoding:NSUTF8StringEncoding]];
            }
            
            break;
            
        case MONITOR_EQUIP_HISTORY:
            
            request.dataType = NORMAL_DATA;
            request.requestType = requestId;
            request.connectionRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@:%@%@",URL_HOST,URL_PORT,[parameters objectForKey:@"URL_ENDPOINT"]]] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:120.0f];
            request.resultDelegate = delegate;
            
            if (1) {
                
                NSMutableString *soapString = [[NSMutableString alloc] init];
                [soapString appendString:[request mxmlPrefix:requestId]];
                [soapString appendString:[request mxmlBodyWithKeys:parameters Values:nil Action:[self actionWithWebServiceRequest:requestId]]];
                [soapString appendString:[request mxmlSuffix]];
                NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapString length]];
                
                [request.connectionRequest addValue:@"application/soap+xml;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
                
                [request.connectionRequest addValue:msgLength forHTTPHeaderField:@"Content-Length"];
                
                [request.connectionRequest addValue:@"nosniff" forHTTPHeaderField:@"X-Content-Type-Options"];
                
                [request.connectionRequest addValue:@"1" forHTTPHeaderField:@"X-XSS-Protection"];
                [request.connectionRequest addValue:@"DENY" forHTTPHeaderField:@"X-Frame-Options"];
                
                [request.connectionRequest addValue:@"gzip, deflate" forHTTPHeaderField:@"Accept-Encoding"];
                
                [self decryptforBasicAuth];
                
                NSString *authStr = [NSString stringWithFormat:@"%@:%@",decryptedUserName,decryptedPassword];
                
                NSData *authData = [authStr dataUsingEncoding:NSUTF8StringEncoding];
                
                NSString *authValue = [authData base64EncodedStringWithOptions:0];
                
                
                [request.connectionRequest addValue:[NSString stringWithFormat:@"Basic %@",authValue] forHTTPHeaderField:@"Authorization"];
                
                [request.connectionRequest setHTTPMethod: @"POST"];
                
                [request.connectionRequest setHTTPBody:[soapString dataUsingEncoding:NSUTF8StringEncoding]];
            }
            
            break;
            
        case MONITOR_GET_EQUIP_MDOCS:
            
            //  http://103.6.157.25:3227/sap/bc/srt/pm/sap/zemt_pm_ws_get_measdoc_equi/800/local/zemt_ftekpro/1/binding_t_http_a_http_zemt_pm_ws_get_measdoc_equi_zemt_ftekpro_l
            
            
            request.dataType = NORMAL_DATA;
            request.requestType = requestId;
            request.connectionRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@:%@%@",URL_HOST,URL_PORT,[parameters objectForKey:@"URL_ENDPOINT"]]] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:120.0f];
            request.resultDelegate = delegate;
            
            if (1) {
                
                NSMutableString *soapString = [[NSMutableString alloc] init];
                [soapString appendString:[request mxmlPrefix:requestId]];
                [soapString appendString:[request mxmlBodyWithKeys:parameters Values:nil Action:[self actionWithWebServiceRequest:requestId]]];
                [soapString appendString:[request mxmlSuffix]];
                NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapString length]];
                
                [request.connectionRequest addValue:@"application/soap+xml;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
                
                [request.connectionRequest addValue:msgLength forHTTPHeaderField:@"Content-Length"];
                
                [request.connectionRequest addValue:@"nosniff" forHTTPHeaderField:@"X-Content-Type-Options"];
                
                [request.connectionRequest addValue:@"1" forHTTPHeaderField:@"X-XSS-Protection"];
                [request.connectionRequest addValue:@"DENY" forHTTPHeaderField:@"X-Frame-Options"];
                
                [request.connectionRequest addValue:@"gzip, deflate" forHTTPHeaderField:@"Accept-Encoding"];
                
                [self decryptforBasicAuth];
                
                NSString *authStr = [NSString stringWithFormat:@"%@:%@",decryptedUserName,decryptedPassword];
                
                NSData *authData = [authStr dataUsingEncoding:NSUTF8StringEncoding];
                
                NSString *authValue = [authData base64EncodedStringWithOptions:0];
                
                
                [request.connectionRequest addValue:[NSString stringWithFormat:@"Basic %@",authValue] forHTTPHeaderField:@"Authorization"];
                
                [request.connectionRequest setHTTPMethod: @"POST"];
                
                [request.connectionRequest setHTTPBody:[soapString dataUsingEncoding:NSUTF8StringEncoding]];
            }
            
            break;
            
            
        case MONITOR_SET_EQUIP_MDOCS:
            
            
            request.dataType = NORMAL_DATA;
            request.requestType = requestId;
            request.connectionRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@:%@%@",URL_HOST,URL_PORT,[parameters objectForKey:@"URL_ENDPOINT"]]] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:120.0f];
            request.resultDelegate = delegate;
            
            if (1) {
                
                NSMutableString *soapString = [[NSMutableString alloc] init];
                [soapString appendString:[request mxmlPrefix:requestId]];
                [soapString appendString:[request mxmlBodyWithKeys:parameters Values:nil Action:[self actionWithWebServiceRequest:requestId]]];
                [soapString appendString:[request mxmlSuffix]];
                NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapString length]];
                
                [request.connectionRequest addValue:@"application/soap+xml;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
                
                [request.connectionRequest addValue:msgLength forHTTPHeaderField:@"Content-Length"];
                
                [request.connectionRequest addValue:@"nosniff" forHTTPHeaderField:@"X-Content-Type-Options"];
                
                [request.connectionRequest addValue:@"1" forHTTPHeaderField:@"X-XSS-Protection"];
                [request.connectionRequest addValue:@"DENY" forHTTPHeaderField:@"X-Frame-Options"];
                
                [request.connectionRequest addValue:@"gzip, deflate" forHTTPHeaderField:@"Accept-Encoding"];
                
                [self decryptforBasicAuth];
                
                NSString *authStr = [NSString stringWithFormat:@"%@:%@",decryptedUserName,decryptedPassword];
                
                NSData *authData = [authStr dataUsingEncoding:NSUTF8StringEncoding];
                
                NSString *authValue = [authData base64EncodedStringWithOptions:0];
                
                
                [request.connectionRequest addValue:[NSString stringWithFormat:@"Basic %@",authValue] forHTTPHeaderField:@"Authorization"];
                
                [request.connectionRequest setHTTPMethod: @"POST"];
                
                [request.connectionRequest setHTTPBody:[soapString dataUsingEncoding:NSUTF8StringEncoding]];
            }
            
            break;
            
        case NOTIFICATION_RELEASE:
            
            request.dataType = NORMAL_DATA;
            request.requestType = requestId;
            request.connectionRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@:%@%@",URL_HOST,URL_PORT,[parameters objectForKey:@"URL_ENDPOINT"]]] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:120.0f];
            request.resultDelegate = delegate;
            
            if (1) {
                
                NSMutableString *soapString = [[NSMutableString alloc] init];
                [soapString appendString:[request mxmlPrefix:requestId]];
                [soapString appendString:[request mxmlBodyWithKeys:parameters Values:nil Action:[self actionWithWebServiceRequest:requestId]]];
                [soapString appendString:[request mxmlSuffix]];
                NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapString length]];
                
                [request.connectionRequest addValue:@"application/soap+xml;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
                
                [request.connectionRequest addValue:msgLength forHTTPHeaderField:@"Content-Length"];
                
                [request.connectionRequest addValue:@"nosniff" forHTTPHeaderField:@"X-Content-Type-Options"];
                
                [request.connectionRequest addValue:@"1" forHTTPHeaderField:@"X-XSS-Protection"];
                [request.connectionRequest addValue:@"DENY" forHTTPHeaderField:@"X-Frame-Options"];
                
                [request.connectionRequest addValue:@"gzip, deflate" forHTTPHeaderField:@"Accept-Encoding"];
                
                [self decryptforBasicAuth];
                
                NSString *authStr = [NSString stringWithFormat:@"%@:%@",decryptedUserName,decryptedPassword];
                
                NSData *authData = [authStr dataUsingEncoding:NSUTF8StringEncoding];
                
                NSString *authValue = [authData base64EncodedStringWithOptions:0];
                
                
                [request.connectionRequest addValue:[NSString stringWithFormat:@"Basic %@",authValue] forHTTPHeaderField:@"Authorization"];
                
                [request.connectionRequest setHTTPMethod: @"POST"];
                
                [request.connectionRequest setHTTPBody:[soapString dataUsingEncoding:NSUTF8StringEncoding]];
            }
            
            break;
            
        case ORDER_RELEASE:
            
            request.dataType = NORMAL_DATA;
            request.requestType = requestId;
            request.connectionRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@:%@%@",URL_HOST,URL_PORT,[parameters objectForKey:@"URL_ENDPOINT"]]] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:120.0f];
            request.resultDelegate = delegate;
            
            if (1) {
                
                NSMutableString *soapString = [[NSMutableString alloc] init];
                [soapString appendString:[request mxmlPrefix:requestId]];
                [soapString appendString:[request mxmlBodyWithKeys:parameters Values:nil Action:[self actionWithWebServiceRequest:requestId]]];
                [soapString appendString:[request mxmlSuffix]];
                NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapString length]];
                
                [request.connectionRequest addValue:@"application/soap+xml;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
                
                [request.connectionRequest addValue:msgLength forHTTPHeaderField:@"Content-Length"];
                
                [request.connectionRequest addValue:@"nosniff" forHTTPHeaderField:@"X-Content-Type-Options"];
                
                [request.connectionRequest addValue:@"1" forHTTPHeaderField:@"X-XSS-Protection"];
                [request.connectionRequest addValue:@"DENY" forHTTPHeaderField:@"X-Frame-Options"];
                
                [request.connectionRequest addValue:@"gzip, deflate" forHTTPHeaderField:@"Accept-Encoding"];
                
                [self decryptforBasicAuth];
                
                NSString *authStr = [NSString stringWithFormat:@"%@:%@",decryptedUserName,decryptedPassword];
                
                NSData *authData = [authStr dataUsingEncoding:NSUTF8StringEncoding];
                
                NSString *authValue = [authData base64EncodedStringWithOptions:0];
                
                
                [request.connectionRequest addValue:[NSString stringWithFormat:@"Basic %@",authValue] forHTTPHeaderField:@"Authorization"];
                
                [request.connectionRequest setHTTPMethod: @"POST"];
                
                [request.connectionRequest setHTTPBody:[soapString dataUsingEncoding:NSUTF8StringEncoding]];
            }
            
            break;
            
        case ORDER_MDOCS:
            
            request.dataType = NORMAL_DATA;
            request.requestType = requestId;
            
            request.connectionRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@:%@%@",URL_HOST,URL_PORT,[parameters objectForKey:@"URL_ENDPOINT"]]] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:120.0f];
            
            request.resultDelegate = delegate;
            
            if (1) {
                
                NSMutableString *soapString = [[NSMutableString alloc] init];
                [soapString appendString:[request mxmlPrefix:requestId]];
                [soapString appendString:[request mxmlBodyWithKeys:parameters Values:nil Action:[self actionWithWebServiceRequest:requestId]]];
                [soapString appendString:[request mxmlSuffix]];
                NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapString length]];
                
                [request.connectionRequest addValue:@"application/soap+xml;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
                
                [request.connectionRequest addValue:@"nosniff" forHTTPHeaderField:@"X-Content-Type-Options"];
                [request.connectionRequest addValue:@"1" forHTTPHeaderField:@"X-XSS-Protection"];
                [request.connectionRequest addValue:@"DENY" forHTTPHeaderField:@"X-Frame-Options"];
                
                [request.connectionRequest addValue:msgLength forHTTPHeaderField:@"Content-Length"];
                
                [request.connectionRequest addValue:@"gzip, deflate" forHTTPHeaderField:@"Accept-Encoding"];
                
                [self decryptforBasicAuth];
                NSString *authStr = [NSString stringWithFormat:@"%@:%@",decryptedUserName,decryptedPassword];
                
                NSData *authData = [authStr dataUsingEncoding:NSUTF8StringEncoding];
                
                NSString *authValue = [authData base64EncodedStringWithOptions:0];
                
                [request.connectionRequest addValue:[NSString stringWithFormat:@"Basic %@",authValue] forHTTPHeaderField:@"Authorization"];
                
                [request.connectionRequest setHTTPMethod: @"POST"];
                
                [request.connectionRequest setHTTPBody:[soapString dataUsingEncoding:NSUTF8StringEncoding]];
            }
            
            break;
            
        case EQUIPMENT_BREAKDOWN:
            
            request.dataType = NORMAL_DATA;
            request.requestType = requestId;
            
            request.connectionRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@:%@%@",URL_HOST,URL_PORT,[parameters objectForKey:@"URL_ENDPOINT"]]] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:120.0f];
            
            request.resultDelegate = delegate;
            
            if (1) {
                
                NSMutableString *soapString = [[NSMutableString alloc] init];
                [soapString appendString:[request mxmlPrefix:requestId]];
                [soapString appendString:[request mxmlBodyWithKeys:parameters Values:nil Action:[self actionWithWebServiceRequest:requestId]]];
                [soapString appendString:[request mxmlSuffix]];
                NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapString length]];
                
                [request.connectionRequest addValue:@"application/soap+xml;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
                
                [request.connectionRequest addValue:@"nosniff" forHTTPHeaderField:@"X-Content-Type-Options"];
                [request.connectionRequest addValue:@"1" forHTTPHeaderField:@"X-XSS-Protection"];
                [request.connectionRequest addValue:@"DENY" forHTTPHeaderField:@"X-Frame-Options"];
                
                [request.connectionRequest addValue:msgLength forHTTPHeaderField:@"Content-Length"];
                
                [request.connectionRequest addValue:@"gzip, deflate" forHTTPHeaderField:@"Accept-Encoding"];
                
                [self decryptforBasicAuth];
                
                NSString *authStr = [NSString stringWithFormat:@"%@:%@",decryptedUserName,decryptedPassword];
                
                NSData *authData = [authStr dataUsingEncoding:NSUTF8StringEncoding];
                
                NSString *authValue = [authData base64EncodedStringWithOptions:0];
                
                [request.connectionRequest addValue:[NSString stringWithFormat:@"Basic %@",authValue] forHTTPHeaderField:@"Authorization"];
                
                [request.connectionRequest setHTTPMethod: @"POST"];
                
                [request.connectionRequest setHTTPBody:[soapString dataUsingEncoding:NSUTF8StringEncoding]];
                
            }
            
            break;
            
        case INSPECTION_MPLAN:
            
            request.dataType = NORMAL_DATA;
            request.requestType = requestId;
            request.connectionRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@:%@%@",URL_HOST,URL_PORT,[parameters objectForKey:@"URL_ENDPOINT"]]] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:120.0f];
            request.resultDelegate = delegate;
            
            if (1) {
                
                NSMutableString *soapString = [[NSMutableString alloc] init];
                [soapString appendString:[request mxmlPrefix:requestId]];
                [soapString appendString:[request mxmlBodyWithKeys:parameters Values:nil Action:[self actionWithWebServiceRequest:requestId]]];
                [soapString appendString:[request mxmlSuffix]];
                NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapString length]];
                
                [request.connectionRequest addValue:@"application/soap+xml;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
                
                [request.connectionRequest addValue:@"nosniff" forHTTPHeaderField:@"X-Content-Type-Options"];
                [request.connectionRequest addValue:@"1" forHTTPHeaderField:@"X-XSS-Protection"];
                [request.connectionRequest addValue:@"DENY" forHTTPHeaderField:@"X-Frame-Options"];
                
                [request.connectionRequest addValue:msgLength forHTTPHeaderField:@"Content-Length"];
                
                [request.connectionRequest addValue:@"gzip, deflate" forHTTPHeaderField:@"Accept-Encoding"];
                
                [self decryptforBasicAuth];
                
                NSString *authStr = [NSString stringWithFormat:@"%@:%@",decryptedUserName,decryptedPassword];
                
                NSData *authData = [authStr dataUsingEncoding:NSUTF8StringEncoding];
                
                NSString *authValue = [authData base64EncodedStringWithOptions:0];
                
                [request.connectionRequest addValue:[NSString stringWithFormat:@"Basic %@",authValue] forHTTPHeaderField:@"Authorization"];
                
                [request.connectionRequest setHTTPMethod: @"POST"];
                
                [request.connectionRequest setHTTPBody:[soapString dataUsingEncoding:NSUTF8StringEncoding]];
            }
            
            break;
            
        case DEVICE_TOKEN:
            
            request.dataType = NORMAL_DATA;
            request.requestType = requestId;
            request.connectionRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@:%@%@",URL_HOST,URL_PORT,[parameters objectForKey:@"URL_ENDPOINT"]]] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:120.0f];
            request.resultDelegate = delegate;
            
            if (1) {
                
                NSMutableString *soapString = [[NSMutableString alloc] init];
                [soapString appendString:[request mxmlPrefix:requestId]];
                [soapString appendString:[request mxmlBodyWithKeys:parameters Values:nil Action:[self actionWithWebServiceRequest:requestId]]];
                [soapString appendString:[request mxmlSuffix]];
                NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapString length]];
                
                [request.connectionRequest addValue:@"application/soap+xml;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
                
                [request.connectionRequest addValue:msgLength forHTTPHeaderField:@"Content-Length"];
                
                [request.connectionRequest addValue:@"nosniff" forHTTPHeaderField:@"X-Content-Type-Options"];
                
                [request.connectionRequest addValue:@"1" forHTTPHeaderField:@"X-XSS-Protection"];
                [request.connectionRequest addValue:@"DENY" forHTTPHeaderField:@"X-Frame-Options"];
                
                [request.connectionRequest addValue:@"gzip, deflate" forHTTPHeaderField:@"Accept-Encoding"];
                
                [self decryptforBasicAuth];
                
                NSString *authStr = [NSString stringWithFormat:@"%@:%@",decryptedUserName,decryptedPassword];
                
                NSData *authData = [authStr dataUsingEncoding:NSUTF8StringEncoding];
                
                NSString *authValue = [authData base64EncodedStringWithOptions:0];
                
                
                [request.connectionRequest addValue:[NSString stringWithFormat:@"Basic %@",authValue] forHTTPHeaderField:@"Authorization"];
                
                [request.connectionRequest setHTTPMethod: @"POST"];
                
                [request.connectionRequest setHTTPBody:[soapString dataUsingEncoding:NSUTF8StringEncoding]];
            }
            
            break;
            
        case SET_DEVICETOKENID:
            
            request.dataType = NORMAL_DATA;
            request.requestType = requestId;
            request.connectionRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@:%@%@",URL_HOST,URL_PORT,[parameters objectForKey:@"URL_ENDPOINT"]]] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:120.0f];
            request.resultDelegate = delegate;
            
            if (1) {
                
                NSMutableString *soapString = [[NSMutableString alloc] init];
                [soapString appendString:[request mxmlPrefix:requestId]];
                [soapString appendString:[request mxmlBodyWithKeys:parameters Values:nil Action:[self actionWithWebServiceRequest:requestId]]];
                [soapString appendString:[request mxmlSuffix]];
                NSLog(@"soap Request is %@",soapString);
                
                NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapString length]];
                
                [request.connectionRequest addValue:@"application/soap+xml;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
                
                [request.connectionRequest addValue:msgLength forHTTPHeaderField:@"Content-Length"];
                
                [request.connectionRequest addValue:@"nosniff" forHTTPHeaderField:@"X-Content-Type-Options"];
                
                [request.connectionRequest addValue:@"1" forHTTPHeaderField:@"X-XSS-Protection"];
                [request.connectionRequest addValue:@"DENY" forHTTPHeaderField:@"X-Frame-Options"];
                
                [request.connectionRequest addValue:@"gzip, deflate" forHTTPHeaderField:@"Accept-Encoding"];
                
                [self decryptforBasicAuth];
                
                NSString *authStr = [NSString stringWithFormat:@"%@:%@",decryptedUserName,decryptedPassword];
                
                NSData *authData = [authStr dataUsingEncoding:NSUTF8StringEncoding];
                
                NSString *authValue = [authData base64EncodedStringWithOptions:0];
                
                
                [request.connectionRequest addValue:[NSString stringWithFormat:@"Basic %@",authValue] forHTTPHeaderField:@"Authorization"];
                
                [request.connectionRequest setHTTPMethod: @"POST"];
                
                [request.connectionRequest setHTTPBody:[soapString dataUsingEncoding:NSUTF8StringEncoding]];
            }
            
            break;
            
        case GEOTAG_SYNCALL:
            
            request.dataType = NORMAL_DATA;
            request.requestType = requestId;
            
            request.connectionRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@:%@%@",URL_HOST,URL_PORT,[parameters objectForKey:@"URL_ENDPOINT"]]] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:120.0f];
            
            request.resultDelegate = delegate;
            
            if (1) {
                
                NSMutableString *soapString = [[NSMutableString alloc] init];
                [soapString appendString:[request mxmlPrefix:requestId]];
                [soapString appendString:[request mxmlBodyWithKeys:parameters Values:nil Action:[self actionWithWebServiceRequest:requestId]]];
                [soapString appendString:[request mxmlSuffix]];
                NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapString length]];
                
                [request.connectionRequest addValue:@"application/soap+xml;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
                
                [request.connectionRequest addValue:@"nosniff" forHTTPHeaderField:@"X-Content-Type-Options"];
                [request.connectionRequest addValue:@"1" forHTTPHeaderField:@"X-XSS-Protection"];
                [request.connectionRequest addValue:@"DENY" forHTTPHeaderField:@"X-Frame-Options"];
                
                [request.connectionRequest addValue:msgLength forHTTPHeaderField:@"Content-Length"];
                
                [request.connectionRequest addValue:@"gzip, deflate" forHTTPHeaderField:@"Accept-Encoding"];
                
                [self decryptforBasicAuth];
                
                NSString *authStr = [NSString stringWithFormat:@"%@:%@",decryptedUserName,decryptedPassword];
                
                NSData *authData = [authStr dataUsingEncoding:NSUTF8StringEncoding];
                
                NSString *authValue = [authData base64EncodedStringWithOptions:0];
                
                [request.connectionRequest addValue:[NSString stringWithFormat:@"Basic %@",authValue] forHTTPHeaderField:@"Authorization"];
                
                [request.connectionRequest setHTTPMethod: @"POST"];
                
                [request.connectionRequest setHTTPBody:[soapString dataUsingEncoding:NSUTF8StringEncoding]];
                
            }
            
            break;
            
        default:
            break;
    }
    
    [self startConnection];
}

- (void)startConnection
{
    if (self.connectionRequest) {
        self.connection =  [[NSURLConnection alloc] initWithRequest:self.connectionRequest delegate:self];
        [self.connection start];
    }
}

#pragma mark - connection Delegate

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response;
{
    if(receivedData==nil)
        receivedData=[NSMutableData new];
    else
        receivedData =nil;
    
    if (self.requestType == GET_INITIAL_ZIP) {
        
        NSData *urlData = [NSData dataWithContentsOfURL:request.connectionRequest.URL];
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        NSString *path = [paths  objectAtIndex:0];
        
        //Save the data
        //NSLog(@"Saving");
        NSString *dataPath = [path stringByAppendingPathComponent:@"InitialData.zip"];
        dataPath = [dataPath stringByStandardizingPath];
        [urlData writeToFile:dataPath atomically:YES];
    }
    else
    {
        filepathString = [[NSString alloc] initWithString:[NSTemporaryDirectory() stringByAppendingPathComponent:@"tempData.xml"]];
        
        if ([[NSFileManager defaultManager] fileExistsAtPath:filepathString]) {
            [[NSFileManager defaultManager] removeItemAtPath:filepathString error:nil];
        }
        
        dataToFileStream = [[NSOutputStream alloc] initToFileAtPath:filepathString append:YES];
        [dataToFileStream open];
    }
    
    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
    responseStatusCode = (int)[httpResponse statusCode];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data;
{
    switch (self.dataType) {
        case NORMAL_DATA:
            [receivedData appendData:data];
            break;
        case LARGE_DATA:
            [dataToFileStream write:[data bytes] maxLength:[data length]];
            break;
        default:
            break;
    }
    
    /*if(webdata==nil)
     webdata=[[NSMutableData alloc] init];
     
     // [webdata appendData:data];
     [dataToFileStream write:[data bytes] maxLength:[data length]];
     currentsize = currentsize+[data length];
     percentage = ((double)currentsize/(double)filesize)*100.0;
     if (percentage>98.0) {
     percentage = 98.0;
     }
     if (percentage <= 0) {
     [(NSObject *)self.parentControl performSelector:@selector(processLevel:) withObject:[NSArray arrayWithObjects:[NSString stringWithString:self.typeOfMAster],[NSString stringWithFormat:@"%.2f",((double)currentsize/1024.0)/1024.0], nil]];
     }
     else
     {
     [(NSObject *)self.parentControl performSelector:@selector(processLevel:) withObject:[NSArray arrayWithObjects:[NSString stringWithString:self.typeOfMAster],[NSNumber numberWithFloat:percentage], nil]];
     }*/
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [dataToFileStream close];
    [[NSFileManager defaultManager] removeItemAtPath:filepathString error:nil];
    [self.resultDelegate resultData:[NSDictionary dictionary] withErrorDescription:error.localizedDescription  requestID:self.requestType :responseStatusCode];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSDictionary *dataDictionary;
    NSString *xmlString;
    
    switch (self.dataType) {
            
        case NORMAL_DATA:
            
            xmlString = [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding];
            
            dataDictionary = [NSDictionary dictionaryWithXMLString:xmlString];
            
            break;
            
        case LARGE_DATA:
            
            [dataToFileStream close];
            
            dataDictionary = [NSDictionary dictionaryWithXMLFile:filepathString];
            
            break;
            
        default:
            break;
    }
    
    [self.resultDelegate resultData:dataDictionary withErrorDescription:@""  requestID:self.requestType :responseStatusCode];
}

- (BOOL) connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace{
    
    BOOL authResult;
    
    authResult= [protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust];
    
    if(authResult)
    {
        // NSLog(@"Auth is Ok");
    }
    
    return authResult;
}

- (void) connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
    
    // NSLog(@"___didReceiveAuthenticationChallenge");
    if([challenge.protectionSpace.authenticationMethod isEqualToString: NSURLAuthenticationMethodServerTrust]) {
        //
        if ([challenge.protectionSpace.host isEqualToString: challenge.protectionSpace.host]) {
            // NSLog(@"trusting connection to host %@", challenge.protectionSpace.host);
            
            NSURLCredential *credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
            [challenge.sender useCredential:credential forAuthenticationChallenge:challenge];
            return;
        }
    }
    
    [challenge.sender continueWithoutCredentialForAuthenticationChallenge:challenge];
}

#pragma mark private methods

+(NSString*)machineName
{
    struct utsname systemInfo;
    uname(&systemInfo);
    
    return [NSString stringWithCString:systemInfo.machine
                              encoding:NSUTF8StringEncoding];
}

+ (NSString *)getIPAddress {
    
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL) {
            if(temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                    
                }
                
            }
            
            temp_addr = temp_addr->ifa_next;
        }
    }
    // Free memory
    freeifaddrs(interfaces);
    return address;
}

/*+ (NSString *)UDID{
 #ifndef __IPHONE_6_0
 return [[[UIDevice currentDevice] identifierForVendor] UUIDString];
 #else
 NSString *UDID = [SSKeychain passwordForService:@"ecollection" account:@"user"];
 if (UDID.length == 0) {
 UDID = [self createNewUUID];
 [SSKeychain setPassword:UDID forService:@"ecollection" account:@"user"];
 }
 return UDID;
 #endif
 }
 
 + (NSString *)createNewUUID {
 CFUUIDRef theUUID = CFUUIDCreate(NULL);
 CFStringRef string = CFUUIDCreateString(NULL, theUUID);
 CFRelease(theUUID);
 return CFBridgingRelease(string);
 }*/

- (NSString *)actionWithWebServiceRequest:(WebServiceRequest)requestId{
    switch (requestId) {
            
        case LOGIN:
            return @"urn:ZemtPmAuthnticateLoginData";
            break;
        case GET_ACTIVITY_TYPE:
            return @"urn:ZemtPmGetActivityType";
            break;
        case GET_APP_SETTINGS:
            return @"urn:ZemtPmGetSettingsData";
            break;
        case GET_SYNC_MAP_DATA:
            return @"urn:ZemtPmGetSyncMapData";
            break;
        case NOTIFICATION_TYPES:
            return @"urn:ZemtPmGetNotifTypes";
            break;
        case NOTIFICATION_PRIORITY_TYPES:
            return @"urn:ZemtPmGetNotifPriority";
            break;
        case ORDER_PRIORITY_TYPES:
            return @"urn:ZemtPmGetOrdPriority";
            break;
        case ORDER_TYPES:
            return @"urn:ZemtPmGetOrdTypes";
            break;
        case ACCIND_TYPES:
            return @"urn:ZemtPmGetOrdAccInd";
            break;
        case GET_LIST_OF_PLANTS:
            return @"urn:ZemtPmGetPlants";
            break;
        case GET_LIST_OF_STORAGELOCATION:
            return @"urn:ZemtPmGetSloc";
            break;
        case GET_UNITS:
            return @"urn:ZemtPmGetUnits";
            break;
        case USER_DATA:
            return @"urn:ZemtPmGetUserData";
            break;
        case USER_FUNCTION:
            return @"urn:ZemtPmGetUserFunction";
            break;
        case COSTCENTER_LIST:
            return @"urn:ZemtPmListCostCenter";
            break;
        case ALLNOTIFICATION_CODES:
            return @"urn:ZemtPmGetNotifCodesAll";
            break;
        case FUNCTIONLOC_COSTCENTER:
            return @"urn:ZemtPmSearchFloc";
            break;
        case FUNCTIONLOC_EQUIPMENT:
            return @"urn:ZemtPmSearchFlocEquip";
            break;
        case EQUIPMENT_COSTCENTER:
            return @"urn:ZemtPmSearchEquip";
            break;
        case EQUIPMENT_FUNCLOC:
            return @"urn:ZemtPmGetEquiinsFromFloc";
            break;
            
        case SEARCH_FUNCLOC_EQUIPMENTS:
            return @"urn:ZemtPmSearchFlocEquip";
            break;
            
        case NOTIFICATION_CREATE:
            return @"urn:ZemtPmCreateNotification";
            break;
            
        case NOTIFICATION_CHANGE:
            return @"urn:ZemtPmChangeNotification";
            break;
            
        case NOTIFICATION_CANCEL:
            return @"urn:ZemtPmCancelNotification";
            break;
            
        case NOTIFICATION_COMPLETE:
            return @"urn:ZemtPmNotifComplete";
            break;
            
        case GET_LIST_OF_DUE_NOTIFICATIONS:
            return @"urn:ZemtPmDueNotification";
            break;
            
        case ORDER_CREATE:
            return @"urn:ZemtPmCreateServiceOrd";
            break;
            
        case ORDER_CHANGE:
            
            return @"urn:ZemtPmChangeServiceOrd";
            
            break;
            
        case ORDER_WOCO:
            
            return @"urn:ZemtPmChangeServiceOrd";
            
            break;
            
        case ORDER_CANCEL:
            return @"urn:ZemtPmCancelServiceOrd";
            break;
            
        case ORDER_CONFIRM:
            return @"urn:ZemtPmConfirmOrder";
            break;
            
        case GET_LIST_OF_DUE_ORDERS:
            return @"urn:ZemtPmDueOrders";
            break;
            
        case UTILITY_RESERVE:
            return @"urn:ZemtPmReservBomComp";
            break;
            
        case GET_LIST_OF_COMPONENTS:
            return @"urn:ZemtPmListOfComponents";
            break;
            
        case GET_LIST_OF_MOVEMENTTYPES:
            return @"urn:ZemtPmListMovementTypes";
            break;
            
        case GET_LIST_OF_WORKCENTER:
            return @"urn:ZemtPmGetWkctr";
            break;
            
        case GET_LIST_OF_NOTIFICATIONS:
            return @"urn:ZemtPmListNotification";
            break;
            
        case GET_LIST_OF_OPEN_NOTIFICATIONS:
            return @"urn:ZemtPmListOpenNotification";
            break;
            
        case GET_LIST_OF_ORDERS:
            return @"urn:ZemtPmListOfOrder";
            break;
            
        case GET_LIST_OF_OPEN_ORDERS:
            return @"urn:ZemtPmSearchOpenOrders";
            break;
            
        case GET_LIST_OF_PM_BOMS:
            return @"urn:ZemtPmListOfEqboms";
            break;
            
        case GET_STOCK_DATA:
            return @"urn:ZemtPmGetStockData";
            break;
            
        case GET_LOG_DATA:
            
            return @"urn:ZemtPmGetLogData";
            break;
            
        case GET_MATERIAL_AVAILABILITY_CHECK:
            
            return @"urn:ZemtPmMatAvailCheck";
            break;
            
        case GET_PERMITS_DATA:
            
            return @"urn:ZemtPm_GET_PERMITS_ALL";
            
            break;
            
        case GET_CUSTOM_FIELDS:
            
            return @"urn:ZemtPmGetCustomFields";
            
            break;
            
        case GET_CONFRIM_REASON:
            
            return @"urn:ZemtPmGetConfReason";
            
            break;
            
        case GET_VALUE_HELPS:
            
            return @"urn:ZemtPmGetVhlpData";
            
            break;
            
        case GET_LOAD_SETTINGS:
            
            return @"urn:ZemtPmGetLoadSettings";
            
            break;
            
        case GET_DOCUMENTS:
            
            return @"urn:ZemtPmGetDocUrl";
            
            break;
            
        case CREATE_NOTIF_ORDER:
            
            return @"urn:ZemtPmCreateNotifOrder";
            
            break;
            
        case GET_NOTIFICATIONNO_DETAILS:
            
            return @"urn:ZemtPmNotifGetDetailM";
            
            break;
            
        case GET_ORDERNO_DETAILS:
            
            return @"urn:ZemtPmOrderGetDetailM";
            
            break;
            
        case GET_SETTINGS_DATA:
            
            return @"urn:ZemtPmGetSettingsData";
            
            break;
            
        case GET_AUTH_DATA:
            
            return @"urn:ZemtPmGetAuthData";
            
            break;
            
        case SEARCH_PLANTMAINT:
            
            return @"urn:ZemtPmGetMsoData";
            
            break;
            
        case ORDER_COLLECTIVE_CONFIRMATION:
            
            return @"urn:ZemtPmConfirmOrderColl";
            
            break;
            
        case GET_WSM_MASTERDATA:
            return @"urn:ZemtPmWsmGetMasterData";
            
            break;
            
        case BREAKDOWN_STATISTICS:
            return @"urn:ZemtPmappBiBkdnStat";
            
            break;
            
        case  NOTIFICATION_ANALYSIS:
            return @"urn:ZemtPmappBiNotifRep";
            
            break;
            
        case  ORDER_ANALYSIS:
            return @"urn:ZemtPmappBiOrdRep";
            
            break;
            
        case MAINTAINANCE_SET_CHECK_LIST:
            return @"urn:ZemtPmappSetMchkList";
            
            break;
            
        case MAINTAINANCE_GET_CHECK_LIST:
            return @"urn:ZemtPmappGetMchkList";
            
            break;
            
        case GET_NFC_SETTINGS:
            
            return @"urn:ZemtPmGetNfcSettings";
            
            break;
            
        case PERMIT_REPORT:
            
            return @"urn:ZemtPmappBiPermitRep";
            
            break;
            
        case GET_INITIAL_ZIP:
            
            return @"urn:ZemtPmGetInilZip";
            
            break;
            
        case AVAILABILITY_REPORT:
            
            return @"urn:ZemtPmappBiPmavrRep";
            
            break;
            
        case MONITOR_EQUIP_HISTORY:
            
            return @"urn:ZemtPmGetEquiHistory";
            
            break;
            
        case MONITOR_GET_EQUIP_MDOCS:
            
            return @"urn:ZemtPmGetMeasdocEqui";
            
            break;
            
        case MONITOR_SET_EQUIP_MDOCS:
            
            return @"urn:ZemtPmMeasdocProcess";
            
            break;
            
        case NOTIFICATION_RELEASE:
            return @"urn:ZemtPmNotifRelease";
            break;
            
        case ORDER_RELEASE:
            return @"urn:ZemtPmOrderRelease";
            break;
            
        case ORDER_MDOCS:
            
            return @"urn:ZemtPmSearchImptt";
            
            break;
            
        case EQUIPMENT_BREAKDOWN:
            
            return @"urn:ZemtPmappBiEqbkStat";
            
            break;
            
        case INSPECTION_MPLAN:
            
            return @"urn:ZemtPmGetEquiMsoData";
            
            break;
            
        case DEVICE_TOKEN:
            
            return @"urn:ZemtMsGetDeviceToken";
            
            break;
            
        case SET_DEVICETOKENID:
            
            return @"urn:ZemtMsSetDeviceToken";
            
            break;
        case GEOTAG_SYNCALL:
            
            return @"urn:ZemtPmSetGeoData";
            
            break;
            
        default:
            return @"";
            break;
    }
}

#pragma mark -
#pragma mark xml methods

- (NSString *)mxmlPrefix:(WebServiceRequest)requestID{
    
    return @"<soap:Envelope xmlns:soap=\"http://www.w3.org/2003/05/soap-envelope\" xmlns:urn=\"urn:sap-com:document:sap:soap:functions:mc-style\"><soap:Header/><soap:Body>";
}

- (NSString *)mxmlSuffix{
    
    return @"</soap:Body></soap:Envelope>";
}

- (NSString *)mxmlBodyWithKeys:(NSDictionary *)requestData Values:(NSArray *)values Action:(NSString *)action{
    
    NSMutableString *soapMessage = [[NSMutableString alloc] initWithString:@""];
    [soapMessage appendString:[NSString stringWithFormat:@"<%@>",action]];
    
    switch (self.requestType) {
            
        case LOGIN:
            
            userName = [requestData objectForKey:@"USERNAME"];
            passWord = [requestData objectForKey:@"PASSWORD"];
            
            //[[[UIDevice currentDevice] identifierForVendor] UUIDString]
            [soapMessage appendFormat:@"<!--Optional:--><IsDevice><Muser>%@</Muser><Deviceid>%@</Deviceid><Devicesno></Devicesno><Udid></Udid></IsDevice>",[[requestData objectForKey:@"USERNAME"] uppercaseString],[[[UIDevice currentDevice] identifierForVendor] UUIDString]];
            
            
            [soapMessage appendFormat:@"<!--Optional:--><IvLanguage>%@</IvLanguage><IvPassword>%@</IvPassword><IvUsername>%@</IvUsername>",[requestData objectForKey:@"LANGUAGE"],[requestData objectForKey:@"PASSWORD"],[requestData objectForKey:@"USERNAME"]];
            
            break;
            
        case GET_SYNC_MAP_DATA:
            
            [soapMessage appendFormat:@"<!--Optional:--><IsDevice><Muser>%@</Muser><Deviceid>%@</Deviceid><Devicesno></Devicesno><Udid></Udid></IsDevice><!--Optional:--><IvTransmitType>%@</IvTransmitType>",[[requestData objectForKey:@"REPORTEDBY"] uppercaseString],[[[UIDevice currentDevice] identifierForVendor] UUIDString],[requestData objectForKey:@"TRANSMITTYPE"]];
            
            break;
            
        case GET_VALUE_HELPS:
            
            [soapMessage appendFormat:@"<!--Optional:--><IsDevice><Muser>%@</Muser><Deviceid>%@</Deviceid><Devicesno></Devicesno><Udid></Udid></IsDevice><!--Optional:--><IvTransmitType>%@</IvTransmitType>",[[requestData objectForKey:@"REPORTEDBY"] uppercaseString],[[[UIDevice currentDevice] identifierForVendor] UUIDString],[requestData objectForKey:@"TRANSMITTYPE"]];
            
            break;
            
        case GET_LOAD_SETTINGS:
            
            [soapMessage appendFormat:@"<!--Optional:--><IsDevice><Muser>%@</Muser><Deviceid>%@</Deviceid><Devicesno></Devicesno><Udid></Udid></IsDevice><!--Optional:--><IvTransmitType>%@</IvTransmitType>",[[requestData objectForKey:@"REPORTEDBY"] uppercaseString],[[[UIDevice currentDevice] identifierForVendor] UUIDString],[requestData objectForKey:@"TRANSMITTYPE"]];
            
            break;
            
        case GET_APP_SETTINGS:
            
            [soapMessage appendFormat:@"<!--Optional:--><IsDevice><Muser>%@</Muser><Deviceid>%@</Deviceid><Devicesno></Devicesno><Udid></Udid></IsDevice><!--Optional:--><IvTransmitType>%@</IvTransmitType>",[[requestData objectForKey:@"REPORTEDBY"] uppercaseString],[[[UIDevice currentDevice] identifierForVendor] UUIDString],[requestData objectForKey:@"TRANSMITTYPE"]];
            
            break;
            
        case GET_NFC_SETTINGS:
            
            [soapMessage appendFormat:@"<!--Optional:--><IsDevice><Muser>%@</Muser><Deviceid>%@</Deviceid><Devicesno></Devicesno><Udid></Udid></IsDevice><!--Optional:--><IvTransmitType>%@</IvTransmitType>",[[requestData objectForKey:@"REPORTEDBY"] uppercaseString],[[[UIDevice currentDevice] identifierForVendor] UUIDString],[requestData objectForKey:@"TRANSMITTYPE"]];
            
            break;
            
        case NOTIFICATION_TYPES:
            //For all F4 Helps No body required
            break;
            
        case NOTIFICATION_PRIORITY_TYPES:
            //For all F4 Helps No body required
            break;
            
        case ORDER_PRIORITY_TYPES:
            //For all F4 Helps No body required
            break;
            
        case ORDER_TYPES:
            //For all F4 Helps No body required
            break;
            
        case ACCIND_TYPES:
            //For all F4 Helps No body required
            break;
            
        case COSTCENTER_LIST:
            //For all F4 Helps No body required
            break;
            
        case ALLNOTIFICATION_CODES:
            //For all F4 Helps No body required
            break;
            
        case GET_UNITS:
            //For all F4 Helps No body required
            break;
            
        case GET_LIST_OF_PLANTS:
            //For all F4 Helps No body required
            break;
            
        case GET_LIST_OF_STORAGELOCATION:
            //For all F4 Helps No body required
            break;
            
        case GET_CONFRIM_REASON:
            //For all F4 Helps No body required
            break;
            
        case GET_LIST_OF_COMPONENTS:
            
            [soapMessage appendFormat:@"<!--Optional:--><IvDeviceId>%@</IvDeviceId><!--Optional:--><IvLgort>%@</IvLgort><!--Optional:--><IvMaterialDesc>%@</IvMaterialDesc><!--Optional:--><IvTransmitType>%@</IvTransmitType><!--Optional:--><IvUser>%@</IvUser><!--Optional:--><IvWerks>%@</IvWerks>",[[[UIDevice currentDevice] identifierForVendor] UUIDString],[requestData objectForKey:@"STORAGELOCATION"],[requestData objectForKey:@"MATERIALDESCRIPTION"],[requestData objectForKey:@"TRANSMITTYPE"],[[requestData objectForKey:@"REPORTEDBY"] uppercaseString],[requestData objectForKey:@"PLANT"]];
            
            break;
            
        case USER_DATA:
            
            userName = [requestData objectForKey:@"REPORTEDBY"];
            [soapMessage appendFormat:@"<IvUsername>%@</IvUsername>",[requestData objectForKey:@"REPORTEDBY"]];
            
            break;
            
        case USER_FUNCTION:
            
            userName = [requestData objectForKey:@"REPORTEDBY"];
            
            [soapMessage appendFormat:@"<IvUser>%@</IvUser>",[requestData objectForKey:@"REPORTEDBY"]];
            
            break;
            
        case GET_CUSTOM_FIELDS:
            
            //For All F4 Helps No body required.
            
            break;
            
        case FUNCTIONLOC_COSTCENTER:
            
            [soapMessage appendFormat:@"<!--Optional:--><IvCcenter>%@</IvCcenter><!--Optional:--><IvText>%@</IvText>",[requestData objectForKey:@"COSTCENTER"],[requestData objectForKey:@"TEXT"]];
            
            break;
            
        case FUNCTIONLOC_EQUIPMENT:
            
            [soapMessage appendFormat:@"<!--Optional:--><IvEqunr>%@</IvEqunr>",[requestData objectForKey:@"EQUNR"]];
            
            break;
            
        case EQUIPMENT_COSTCENTER:
            
            [soapMessage appendFormat:@"<!--Optional:--><IvCcenter>%@</IvCcenter><!--Optional:--><IvText>%@</IvText>",[requestData objectForKey:@"COSTCENTER"],[requestData objectForKey:@"TEXT"]];
            
            break;
            
        case EQUIPMENT_FUNCLOC:
            
            [soapMessage appendFormat:@"<!--Optional:--><IvFloc>%@</IvFloc>",[requestData objectForKey:@"FUNCLOC"]];
            
            break;
            
        case SEARCH_FUNCLOC_EQUIPMENTS:
            
            [soapMessage appendFormat:@"<!--Optional:--><IsDevice><Muser>%@</Muser><Deviceid>%@</Deviceid><Devicesno></Devicesno><Udid></Udid></IsDevice>",[[requestData objectForKey:@"REPORTEDBY"] uppercaseString],[[[UIDevice currentDevice] identifierForVendor] UUIDString]];
            
            [soapMessage appendFormat:@"<!--Optional:--><IvCcenter></IvCcenter><!--Optional:--><IvMaxRecords></IvMaxRecords><!--Optional:--><IvText></IvText><!--Optional:--><IvTransmitType>%@</IvTransmitType><!--Optional:--><IvUser>%@</IvUser>",[requestData objectForKey:@"TRANSMITTYPE"],[[requestData objectForKey:@"REPORTEDBY"] uppercaseString]];
            
            
            break;
            
        case GET_LIST_OF_OPEN_NOTIFICATIONS:
            
            //Equipment Number
            if ([[requestData objectForKey:@"EQUIPFROM"] isEqualToString:@""]) {
                if ([[requestData objectForKey:@"EQUIPTO"] isEqualToString:@""]) {
                    strEquipNo = @"";
                    
                }
                else{
                    strEquipNo = [NSString stringWithFormat:@"<IvEqunr><!--Zero or more repetitions:--><item><Sign>I</Sign><Option>EQ</Option><Low>%@</Low><High>%@</High></item></IvEqunr>",[requestData objectForKey:@"EQUIPFROM"],[requestData objectForKey:@"EQUIPTO"]];
                }
            }
            else if ([[requestData objectForKey:@"EQUIPTO"] isEqualToString:@""]){
                strEquipNo = [NSString stringWithFormat:@"<IvEqunr><!--Zero or more repetitions:--><item><Sign>I</Sign><Option>EQ</Option><Low>%@</Low><High>%@</High></item></IvEqunr>",[requestData objectForKey:@"EQUIPFROM"],[requestData objectForKey:@"EQUIPTO"]];
            }
            else
                strEquipNo = [NSString stringWithFormat:@"<IvEqunr><!--Zero or more repetitions:--><item><Sign>I</Sign><Option>BT</Option><Low>%@</Low><High>%@</High></item></IvEqunr>",[requestData objectForKey:@"EQUIPFROM"],[requestData objectForKey:@"EQUIPTO"]];
            
            ///MalFunction Date
            
            if ([[requestData objectForKey:@"DATEFROM"] isEqualToString:@""]) {
                if ([[requestData objectForKey:@"DATETO"] isEqualToString:@""]) {
                    strErdat = @"";
                }
                else{
                    strErdat = [NSString stringWithFormat:@"<IvErdat><!--Zero or more repetitions:--><item><Sign>I</Sign><Option>EQ</Option><Low>%@</Low><High>%@</High></item></IvErdat>",[requestData objectForKey:@"DATEFROM"],[requestData objectForKey:@"DATETO"]];
                }
            }
            else if ([[requestData objectForKey:@"DATETO"] isEqualToString:@""])  {
                strErdat = [NSString stringWithFormat:@"<IvErdat><!--Zero or more repetitions:--><item><Sign>I</Sign><Option>EQ</Option><Low>%@</Low><High>%@</High></item></IvErdat>",[requestData objectForKey:@"DATEFROM"],[requestData objectForKey:@"DATETO"]];
            }
            else
                strErdat = [NSString stringWithFormat:@"<IvErdat><!--Zero or more repetitions:--><item><Sign>I</Sign><Option>BT</Option><Low>%@</Low><High>%@</High></item></IvErdat>",[requestData objectForKey:@"DATEFROM"],[requestData objectForKey:@"DATETO"]];
            
            // FuncLocation
            if ([[requestData objectForKey:@"FUNCLOCFROM"] isEqualToString:@""]) {
                if ([[requestData objectForKey:@"FUNCLOCTO"] isEqualToString:@""]) {
                    strFuncLoc = @"";
                }
                else
                    strFuncLoc = [NSString stringWithFormat:@"<IvFloc><!--Zero or more repetitions:--><item><Sign>I</Sign><Option>EQ</Option><Low>%@</Low><High>%@</High></item></IvFloc>",[requestData objectForKey:@"FUNCLOCFROM"],[requestData objectForKey:@"FUNCLOCTO"]];
            }
            else if ([[requestData objectForKey:@"FUNCLOCTO"] isEqualToString:@""]){
                strFuncLoc = [NSString stringWithFormat:@"<IvFloc><!--Zero or more repetitions:--><item><Sign>I</Sign><Option>EQ</Option><Low>%@</Low><High>%@</High></item></IvFloc>",[requestData objectForKey:@"FUNCLOCFROM"],[requestData objectForKey:@"FUNCLOCTO"]];
            }
            else
                strFuncLoc = [NSString stringWithFormat:@"<IvFloc><!--Zero or more repetitions:--><item><Sign>I</Sign><Option>BT</Option><Low>%@</Low><High>%@</High></item><IvFloc>",[requestData objectForKey:@"FUNCLOCFROM"],[requestData objectForKey:@"FUNCLOCTO"]];
            
            ///Notification Number
            
            if ([[requestData objectForKey:@"NOTIFNOFROM"] isEqualToString:@""]) {
                if ([[requestData objectForKey:@"NOTIFNOTO"] isEqualToString:@""]) {
                    strNotifNo = @"";
                }
                else
                    strNotifNo = [NSString stringWithFormat:@"<IvQmnum><!--Zero or more repetitions:--><item><Sign>I</Sign><Option>EQ</Option><Low>%@</Low><High>%@</High></item></IvQmnum>",[requestData objectForKey:@"NOTIFNOFROM"],[requestData objectForKey:@"NOTIFNOTO"]];
            }
            else if ([[requestData objectForKey:@"NOTIFNOTO"] isEqualToString:@""]){
                strNotifNo = [NSString stringWithFormat:@"<IvQmnum><!--Zero or more repetitions:--><item><Sign>I</Sign><Option>EQ</Option><Low>%@</Low><High>%@</High></item></IvQmnum>",[requestData objectForKey:@"NOTIFNOFROM"],[requestData objectForKey:@"NOTIFNOTO"]];
            }
            else
                strNotifNo = [NSString stringWithFormat:@"<IvQmnum><!--Zero or more repetitions:--><item><Sign>I</Sign><Option>BT</Option><Low>%@</Low><High>%@</High></item></IvQmnum>",[requestData objectForKey:@"NOTIFNOFROM"],[requestData objectForKey:@"NOTIFNOTO"]];
            
            [soapMessage appendFormat:@"<!--Optional:-->%@<!--Optional:-->%@<!--Optional:-->%@<!--Optional:--><IvNotifType>%@</IvNotifType><!--Optional:-->%@<!--Optional:--><IvUser>%@</IvUser>",strEquipNo,strErdat,strFuncLoc,[requestData objectForKey:@"NOTIFTYPE"],strNotifNo,[requestData objectForKey:@"REPORTEDBY"]];
            
            break;
            
        case NOTIFICATION_CREATE:
            
            [soapMessage appendFormat:@"<!--Optional:--><IsDevice><Muser>%@</Muser><Deviceid>%@</Deviceid><Devicesno></Devicesno><Udid></Udid></IsDevice>",[[requestData objectForKey:@"REPORTEDBY"] uppercaseString],[[[UIDevice currentDevice] identifierForVendor] UUIDString]];
            
            if ([[requestData objectForKey:@"ATTACHMENTS"] count]) {
                
                attachDocs = [NSMutableString new];
                
                NSArray *attachmentsArray = [requestData objectForKey:@"ATTACHMENTS"];
                
                for (int i =0; i<[attachmentsArray count]; i++) {
                    
                    [attachDocs appendFormat:@"<item><Zobjid></Zobjid><Zdoctype>Q</Zdoctype><ZdoctypeItem>QH</ZdoctypeItem><Filename>%@</Filename><Filetype>%@</Filetype><Fsize>%@</Fsize><Content>%@</Content><DocId></DocId><DocType></DocType><Objtype>%@</Objtype></item>",[[attachmentsArray objectAtIndex:i] objectAtIndex:3],[[attachmentsArray objectAtIndex:i] objectAtIndex:4],[[attachmentsArray objectAtIndex:i] objectAtIndex:5],[[attachmentsArray objectAtIndex:i] objectAtIndex:7],[[attachmentsArray objectAtIndex:i] objectAtIndex:2]];
                }
                
                if ([attachDocs length]) {
                    [soapMessage appendFormat:@"<!--Optional:--><ItDocs><!--Zero or more repetitions:-->%@</ItDocs>",attachDocs];
                }
            }
            
            customFieldsString = @"";
            customHeaderItemFieldsString = [[NSMutableString alloc]initWithString:@""];
            
            if ([[requestData objectForKey:@"CFH"] count]) {
                NSArray *customHeaderDetailsArray = [requestData objectForKey:@"CFH"];
                for (int i =0; i<[customHeaderDetailsArray count]; i++) {
                    
                    
                    [customHeaderItemFieldsString appendFormat:@"<item><Zdoctype>Q</Zdoctype><ZdoctypeItem>QH</ZdoctypeItem><Tabname>%@</Tabname><Fieldname>%@</Fieldname><Value>%@</Value><Flabel>%@</Flabel><Datatype>%@</Datatype><Sequence>%@</Sequence><Length>%@</Length></item>",[[customHeaderDetailsArray objectAtIndex:i] objectAtIndex:2],[[customHeaderDetailsArray objectAtIndex:i] objectAtIndex:3],[[customHeaderDetailsArray objectAtIndex:i] objectAtIndex:4],[[customHeaderDetailsArray objectAtIndex:i] objectAtIndex:5],[[customHeaderDetailsArray objectAtIndex:i] objectAtIndex:6],[[customHeaderDetailsArray objectAtIndex:i] objectAtIndex:7],[[customHeaderDetailsArray objectAtIndex:i] objectAtIndex:8]];
                    
                }
                
                customFieldsString = [NSString stringWithFormat:@"<Fields><!--Zero or more repetitions:-->%@</Fields>",customHeaderItemFieldsString];
            }
            
            
            if ([NullChecker isNull:[requestData objectForKey:@"WORKCENTERID"]]) {
                
                workCenterString = @"";
            }
            else{
                
                workCenterString = [self getcodeforkeys:[requestData objectForKey:@"WORKCENTERID"]];
            }
            
            if ([NullChecker isNull:[requestData objectForKey:@"PLANTID"]]) {
                str_Plant = @"";
            }
            else{
                str_Plant = [requestData objectForKey:@"PLANTID"];
            }
            
            
            if ([[requestData objectForKey:@"RSDATE"] length]) {
                
                 NSString *tempString=[[requestData objectForKey:@"RSDATE"] copy];
                 reqStartDate=[tempString substringToIndex:10];
                 reqStartTime=[tempString substringFromIndex:11];
                
            }
            else{
                reqStartDate=@"";
                reqStartTime=@"";
            }
            
            if ([[requestData objectForKey:@"REDATE"] length]) {
                reqEndDate=[[requestData objectForKey:@"REDATE"] substringToIndex:10];
                reqEndTime=[[requestData objectForKey:@"REDATE"] substringFromIndex:11];
            }
            else{
                reqEndDate=@"";
                reqEndTime=@"";
            }
            
            
            if ([[requestData objectForKey:@"SDATE"] length]) {
                reqMStartDate=[[requestData objectForKey:@"SDATE"] substringToIndex:10];
                reqMStartTime=[[requestData objectForKey:@"SDATE"] substringFromIndex:11];
            }
            else{
                reqMStartDate=@"";
                reqMStartTime=@"";
            }
            
            if ([[requestData objectForKey:@"EDATE"] length]) {
                reqMEndDate=[[requestData objectForKey:@"EDATE"] substringToIndex:10];
                reqMEndTime=[[requestData objectForKey:@"EDATE"] substringFromIndex:11];
            }
            else{
                reqMEndDate=@"";
                reqMEndTime=@"";
            }
            
            
            
            //
            //            [soapMessage appendFormat:@"<ItNotifHeader><!--Zero or more repetitions:--><item><NotifType>%@</NotifType><Qmnum>%@</Qmnum><NotifShorttxt>%@</NotifShorttxt><FunctionLoc>%@</FunctionLoc><Equipment>%@</Equipment><ReportedBy>%@</ReportedBy><MalfuncStdate>%@</MalfuncStdate><MalfuncEddate>%@</MalfuncEddate><MalfuncSttime>%@</MalfuncSttime><MalfuncEdtime>%@</MalfuncEdtime><BreakdownInd>%@</BreakdownInd><Priority>%@</Priority><Ingrp></Ingrp><Arbpl></Arbpl><Werks></Werks><Strmn>%@</Strmn><Ltrmn>%@</Ltrmn><Strur>%@</Strur><Ltrur>%@</Ltrur><Aufnr>%@</Aufnr><ParnrVw>%@</ParnrVw><NameVw>%@</NameVw><Docs>%@</Docs><Closed></Closed><Completed></Completed><Createdon></Createdon><Auswk>%@</Auswk><Shift>%@</Shift><Noofperson>%@</Noofperson>%@</item></ItNotifHeader>",[requestData objectForKey:@"NID"],[requestData objectForKey:@"OBJECTID"],[requestData objectForKey:@"SHORTTEXT"],[requestData objectForKey:@"FID"],[requestData objectForKey:@"EQID"],[requestData objectForKey:@"NREPORTEDBY"],reqMStartDate,reqMEndDate,reqMStartTime,reqMEndTime,[requestData objectForKey:@"BREAKDOWN"],[requestData objectForKey:@"NPID"],reqStartDate,reqEndDate,reqStartTime,reqEndTime,[requestData objectForKey:@"AUFNR"],[requestData objectForKey:@"PARNRID"],[requestData objectForKey:@"PARNRTEXT"],[requestData objectForKey:@"DOCS"],[requestData objectForKey:@"EFFECTID"],[requestData objectForKey:@"SHIFT"],[requestData objectForKey:@"NOOFPERSON"],customFieldsString];
            
 
            [soapMessage appendFormat:@"<ItNotifHeader><!--Zero or more repetitions:--><item><NotifType>%@</NotifType><Qmnum></Qmnum><NotifShorttxt>%@</NotifShorttxt><FunctionLoc>%@</FunctionLoc><Equipment>%@</Equipment><ReportedBy>%@</ReportedBy><MalfuncStdate>%@</MalfuncStdate><MalfuncEddate>%@</MalfuncEddate><MalfuncSttime>%@</MalfuncSttime><MalfuncEdtime>%@</MalfuncEdtime><BreakdownInd>%@</BreakdownInd><Priority>%@</Priority><Ingrp>%@</Ingrp><Arbpl>%@</Arbpl><Werks>%@</Werks><Strmn>%@</Strmn><Ltrmn>%@</Ltrmn><Strur>%@</Strur><Ltrur>%@</Ltrur><Aufnr>%@</Aufnr><ParnrVw>%@</ParnrVw><NameVw>%@</NameVw><Docs>%@</Docs><Closed></Closed><Completed></Completed><Createdon></Createdon><Ingrpname>%@</Ingrpname><Auswk>%@</Auswk><Shift>%@</Shift><Noofperson>%@</Noofperson><Usr01>%@</Usr01><Usr02>%@</Usr02>%@</item></ItNotifHeader>",[requestData objectForKey:@"NID"],[requestData objectForKey:@"SHORTTEXT"],[requestData objectForKey:@"FID"],[requestData objectForKey:@"EQID"],[requestData objectForKey:@"REPORTEDBY"],reqMStartDate,reqMEndDate,reqMStartTime,reqMEndTime,[requestData objectForKey:@"BREAKDOWN"],[requestData objectForKey:@"NPID"],[requestData objectForKey:@"PLANNERGROUP"],workCenterString,str_Plant,reqStartDate,reqEndDate,reqStartTime,reqEndTime,[requestData objectForKey:@"AUFNR"],[requestData objectForKey:@"PARNRID"],[requestData objectForKey:@"PARNRTEXT"],[requestData objectForKey:@"DOCS"],[requestData objectForKey:@"PLANNERGROUPNAME"],[requestData objectForKey:@"EFFECTID"],[requestData objectForKey:@"SHIFT"],[requestData objectForKey:@"NOOFPERSON"],[requestData objectForKey:@"USR01"],[requestData objectForKey:@"USR02"],customFieldsString];
 
            
            if ([[requestData objectForKey:@"ITEMS"] count]) {
                NSArray *causeCodeDetailsArray = [requestData objectForKey:@"ITEMS"];
                [soapMessage appendString:@"<!--Optional:--><ItNotifItems><!--Zero or more repetitions:-->"];
                for (int i = 0; i<[causeCodeDetailsArray count]; i++) {
                    
                    customFieldsString = @"";
                    [customHeaderItemFieldsString setString:@""];
                    
                    for (int x = 0; x<[[[causeCodeDetailsArray objectAtIndex:i] objectAtIndex:1] count]; x++) {
                        
                        [customHeaderItemFieldsString appendFormat:@"<item><Zdoctype>Q</Zdoctype><ZdoctypeItem>%@</ZdoctypeItem><Tabname>%@</Tabname><Fieldname>%@</Fieldname><Value>%@</Value><Flabel>%@</Flabel><Datatype>%@</Datatype><Sequence>%@</Sequence><Length>%@</Length></item>",[[[[causeCodeDetailsArray objectAtIndex:i] objectAtIndex:1] objectAtIndex:x] objectAtIndex:1],[[[[causeCodeDetailsArray objectAtIndex:i] objectAtIndex:1] objectAtIndex:x] objectAtIndex:2],[[[[causeCodeDetailsArray objectAtIndex:i] objectAtIndex:1] objectAtIndex:x] objectAtIndex:3],[[[[causeCodeDetailsArray objectAtIndex:i] objectAtIndex:1] objectAtIndex:x] objectAtIndex:4],[[[[causeCodeDetailsArray objectAtIndex:i] objectAtIndex:1] objectAtIndex:x] objectAtIndex:5],[[[[causeCodeDetailsArray objectAtIndex:i] objectAtIndex:1] objectAtIndex:x] objectAtIndex:6],[[[[causeCodeDetailsArray objectAtIndex:i] objectAtIndex:1] objectAtIndex:x] objectAtIndex:7],[[[[causeCodeDetailsArray objectAtIndex:i] objectAtIndex:1] objectAtIndex:x] objectAtIndex:8]];
                    }
                    
                    for (int x = 0; x<[[[causeCodeDetailsArray objectAtIndex:i] lastObject] count]; x++) {
                        
                        [customHeaderItemFieldsString appendFormat:@"<item><Zdoctype>Q</Zdoctype><ZdoctypeItem>%@</ZdoctypeItem><Tabname>%@</Tabname><Fieldname>%@</Fieldname><Value>%@</Value><Flabel>%@</Flabel><Datatype>%@</Datatype><Sequence>%@</Sequence><Length>%@</Length></item>",[[[[causeCodeDetailsArray objectAtIndex:i] lastObject] objectAtIndex:x] objectAtIndex:1],[[[[causeCodeDetailsArray objectAtIndex:i] lastObject] objectAtIndex:x] objectAtIndex:2],[[[[causeCodeDetailsArray objectAtIndex:i] lastObject] objectAtIndex:x] objectAtIndex:3],[[[[causeCodeDetailsArray objectAtIndex:i] lastObject] objectAtIndex:x] objectAtIndex:4],[[[[causeCodeDetailsArray objectAtIndex:i] lastObject] objectAtIndex:x] objectAtIndex:5],[[[[causeCodeDetailsArray objectAtIndex:i] lastObject] objectAtIndex:x] objectAtIndex:6],[[[[causeCodeDetailsArray objectAtIndex:i] lastObject] objectAtIndex:x] objectAtIndex:7],[[[[causeCodeDetailsArray objectAtIndex:i] lastObject] objectAtIndex:x] objectAtIndex:8]];
                    }
                    customFieldsString = [NSString stringWithFormat:@"<Fields><!--Zero or more repetitions:-->%@</Fields>",customHeaderItemFieldsString];
                    
                    [soapMessage appendFormat:@"<item><Qmnum></Qmnum><ItempartGrp>%@</ItempartGrp><Partgrptext>%@</Partgrptext><ItempartCod>%@</ItempartCod><Partcodetext>%@</Partcodetext><ItemdefectGrp>%@</ItemdefectGrp><ItemKey>%@</ItemKey><ItemdefectCod>%@</ItemdefectCod><ItemdefectShtxt>%@</ItemdefectShtxt><CauseKey>%@</CauseKey><CauseGrp>%@</CauseGrp><CauseCod>%@</CauseCod><CauseShtxt>%@</CauseShtxt>%@<Action>I</Action></item>",[[[causeCodeDetailsArray objectAtIndex:i] firstObject] objectAtIndex:16],[[[causeCodeDetailsArray objectAtIndex:i] firstObject] objectAtIndex:18],[[[causeCodeDetailsArray objectAtIndex:i] firstObject] objectAtIndex:17],[[[causeCodeDetailsArray objectAtIndex:i] firstObject] objectAtIndex:19],[[[causeCodeDetailsArray objectAtIndex:i] firstObject] objectAtIndex:2],[[[causeCodeDetailsArray objectAtIndex:i] firstObject] objectAtIndex:12],[[[causeCodeDetailsArray objectAtIndex:i] firstObject] objectAtIndex:4],[[[causeCodeDetailsArray objectAtIndex:i] firstObject] objectAtIndex:10],[[[causeCodeDetailsArray objectAtIndex:i] firstObject] objectAtIndex:13],[[[causeCodeDetailsArray objectAtIndex:i] firstObject] objectAtIndex:6],[[[causeCodeDetailsArray objectAtIndex:i] firstObject] objectAtIndex:8],[[[causeCodeDetailsArray objectAtIndex:i] firstObject] objectAtIndex:11],customFieldsString];
                }
                
                [soapMessage appendString:@"</ItNotifItems>"];
            }
            
            //LongText
            if ([[requestData objectForKey:@"LONGTEXT"] length]) {
                NSArray *longTextArray = [[requestData objectForKey:@"LONGTEXT"] componentsSeparatedByString:@"\n"];
                [soapMessage appendString:@"<!--Optional:--><ItNotifLongtext><!--Zero or more repetitions:-->"];
                for (int i=0; i<[longTextArray count]; i++) {
                    [soapMessage appendFormat:@"<item><Qmnum></Qmnum><TextLine>%@</TextLine></item>",[longTextArray objectAtIndex:i]];
                }
                [soapMessage appendString:@"</ItNotifLongtext><!--Optional:-->"];
            }
            
            //notif tasks
            if ([[requestData objectForKey:@"TASKS"] count]) {
                
                NSArray *taskCodeDetailsArray = [requestData objectForKey:@"TASKS"];
                [soapMessage appendString:@"<!--Optional:--><ItNotifTasks><!--Zero or more repetitions:-->"];
                
                for (int i = 0; i<[taskCodeDetailsArray count]; i++) {
                    
                    customFieldsString = @"";
                    [customHeaderItemFieldsString setString:@""];
                    
                    id taskDetails=[[taskCodeDetailsArray objectAtIndex:i] lastObject];
                    
                    for (int x = 0; x<[taskDetails count]; x++) {
                        
                        if ([[taskDetails objectAtIndex:0] isKindOfClass:[NSArray class]]) {
                            
                            [customHeaderItemFieldsString appendFormat:@"<item><Zdoctype>Q</Zdoctype><ZdoctypeItem>%@</ZdoctypeItem><Tabname>%@</Tabname><Fieldname>%@</Fieldname><Value>%@</Value><Flabel>%@</Flabel><Datatype>%@</Datatype><Sequence>%@</Sequence><Length>%@</Length></item>",[[taskDetails objectAtIndex:x] objectAtIndex:1],[[taskDetails objectAtIndex:x] objectAtIndex:2],[[taskDetails objectAtIndex:x] objectAtIndex:3],[[taskDetails objectAtIndex:x] objectAtIndex:4],[[taskDetails objectAtIndex:x] objectAtIndex:5],[[taskDetails objectAtIndex:x] objectAtIndex:6],[[taskDetails objectAtIndex:x] objectAtIndex:7],[[taskDetails objectAtIndex:x] objectAtIndex:8]];
                        }
                        else{
                            
                            [customHeaderItemFieldsString appendFormat:@"<item><Zdoctype>Q</Zdoctype><ZdoctypeItem>%@</ZdoctypeItem><Tabname>%@</Tabname><Fieldname>%@</Fieldname><Value>%@</Value><Flabel>%@</Flabel><Datatype>%@</Datatype><Sequence>%@</Sequence><Length>%@</Length></item>",[taskDetails  objectAtIndex:1],[taskDetails  objectAtIndex:2],[taskDetails  objectAtIndex:3],[taskDetails  objectAtIndex:4],[taskDetails  objectAtIndex:5],[taskDetails  objectAtIndex:6],[taskDetails  objectAtIndex:7],[taskDetails  objectAtIndex:8]];
                        }
                        
                        
                    }
                    
                    customFieldsString = [NSString stringWithFormat:@"<Fields><!--Zero or more repetitions:-->%@</Fields>",customHeaderItemFieldsString];
                    
                    [soapMessage appendFormat:@"<item><Qmnum></Qmnum><ItemKey>%@</ItemKey><ItempartGrp></ItempartGrp><Partgrptext></Partgrptext><ItempartCod></ItempartCod><Partcodetext></Partcodetext><ItemdefectGrp></ItemdefectGrp><Defectgrptext></Defectgrptext><ItemdefectCod></ItemdefectCod><Defectcodetext></Defectcodetext><ItemdefectShtxt></ItemdefectShtxt><TaskKey>%@</TaskKey><TaskGrp>%@</TaskGrp><Taskgrptext>%@</Taskgrptext><TaskCod>%@</TaskCod><Taskcodetext>%@</Taskcodetext><TaskShtxt>%@</TaskShtxt><Pster>%@</Pster><Peter>%@</Peter><Pstur>%@</Pstur><Petur>%@</Petur><Parvw>%@</Parvw><Parnr>%@</Parnr><Erlnam>%@</Erlnam><Erldat>%@</Erldat><Erlzeit>%@</Erlzeit><Release>%@</Release><Complete>%@</Complete><Success>%@</Success><UserStatus></UserStatus><SysStatus></SysStatus><Smsttxt></Smsttxt><Smastxt></Smastxt><Usr01></Usr01><Usr02></Usr02><Usr03></Usr03><Usr04></Usr04><Usr05></Usr05>",[[[taskCodeDetailsArray objectAtIndex:i] firstObject] objectAtIndex:16],[[[taskCodeDetailsArray objectAtIndex:i] firstObject] objectAtIndex:2],[[[taskCodeDetailsArray objectAtIndex:i] firstObject] objectAtIndex:3],[self getcodeforkeys:[[[taskCodeDetailsArray objectAtIndex:i] firstObject] objectAtIndex:4]],[[[taskCodeDetailsArray objectAtIndex:i] firstObject] objectAtIndex:5],[[[taskCodeDetailsArray objectAtIndex:i] firstObject] objectAtIndex:6],[[[taskCodeDetailsArray objectAtIndex:i] firstObject] objectAtIndex:7],[[[taskCodeDetailsArray objectAtIndex:i] firstObject] objectAtIndex:11],[[[taskCodeDetailsArray objectAtIndex:i] firstObject] objectAtIndex:12],[[[taskCodeDetailsArray objectAtIndex:i] firstObject] objectAtIndex:36],[[[taskCodeDetailsArray objectAtIndex:i] firstObject] objectAtIndex:37],[[[taskCodeDetailsArray objectAtIndex:i] firstObject] objectAtIndex:8],[[[taskCodeDetailsArray objectAtIndex:i] firstObject] objectAtIndex:10],[[[taskCodeDetailsArray objectAtIndex:i] firstObject] objectAtIndex:40],[[[taskCodeDetailsArray objectAtIndex:i] firstObject] objectAtIndex:38],[[[taskCodeDetailsArray objectAtIndex:i] firstObject] objectAtIndex:39],[[[taskCodeDetailsArray objectAtIndex:i] firstObject] objectAtIndex:13],[[[taskCodeDetailsArray objectAtIndex:i] firstObject] objectAtIndex:14],[[[taskCodeDetailsArray objectAtIndex:i] firstObject] objectAtIndex:15]];
                    
                    //                    [soapMessage appendFormat:@"<Fields><!--Zero or more repetitions:--><item><Zdoctype></Zdoctype><ZdoctypeItem></ZdoctypeItem><Tabname></Tabname><Fieldname></Fieldname><Datatype></Datatype><Value></Value><Flabel></Flabel><Sequence></Sequence><Length></Length></item></Fields>"];
                    
                    [soapMessage appendFormat:@"%@<Action>I</Action>",customFieldsString];
                    
                    [soapMessage appendFormat:@"</item>"];
                }
                
                [soapMessage appendString:@"</ItNotifTasks>"];
            }
            
            [soapMessage appendString:@"<!--Optional:--><IvCommit>X</IvCommit>"];
            
            [soapMessage appendFormat:@"<!--Optional:--><IvTransmitType>%@</IvTransmitType>",[requestData objectForKey:@"TRANSMITTYPE"]];
            
            break;
            
        case NOTIFICATION_CHANGE:
            
            [soapMessage appendFormat:@"<!--Optional:--><IsDevice><Muser>%@</Muser><Deviceid>%@</Deviceid><Devicesno></Devicesno><Udid></Udid></IsDevice>",[[requestData objectForKey:@"REPORTEDBY"] uppercaseString],[[[UIDevice currentDevice] identifierForVendor] UUIDString]];
            
            //            if ([[requestData objectForKey:@"LATITUDE"] length] && [[requestData objectForKey:@"LONGITUDE"] length]) {
            //                [soapMessage appendFormat:@"<!--Optional:--><IsGeo><Latitude>%@</Latitude><Longitude>%@</Longitude><Altitude></Altitude></IsGeo>",[requestData objectForKey:@"LATITUDE"],[requestData objectForKey:@"LONGITUDE"]];
            //            }
            
            if ([[requestData objectForKey:@"ATTACHMENTS"] count]) {
                attachDocs = [NSMutableString new];
                NSArray *attachmentsArray = [requestData objectForKey:@"ATTACHMENTS"];
                for (int i =0; i<[attachmentsArray count]; i++) {
                    
                    [attachDocs appendFormat:@"<item><Zobjid>%@</Zobjid><Zdoctype>Q</Zdoctype><ZdoctypeItem>QH</ZdoctypeItem><Filename>%@</Filename><Filetype>%@</Filetype><Fsize>%@</Fsize><Content>%@</Content><DocId></DocId><DocType></DocType><Objtype></Objtype></item>",[requestData objectForKey:@"OBJECTID"],[[attachmentsArray objectAtIndex:i] objectAtIndex:3],[[attachmentsArray objectAtIndex:i] objectAtIndex:4],[[attachmentsArray objectAtIndex:i] objectAtIndex:5],[[attachmentsArray objectAtIndex:i] objectAtIndex:7]];
                }
                
                if ([attachDocs length]) {
                    [soapMessage appendFormat:@"<!--Optional:--><ItDocs><!--Zero or more repetitions:-->%@</ItDocs>",attachDocs];
                }
            }
            
            ///////////////////*/
            
            customFieldsString = @"";
            customHeaderItemFieldsString = [[NSMutableString alloc]initWithString:@""];
            
            
            
            if ([[requestData objectForKey:@"CFH"] count]) {
                NSArray *customHeaderDetailsArray = [requestData objectForKey:@"CFH"];
                for (int i =0; i<[customHeaderDetailsArray count]; i++) {
                    [customHeaderItemFieldsString appendFormat:@"<item><Zdoctype>Q</Zdoctype><ZdoctypeItem>QH</ZdoctypeItem><Tabname>%@</Tabname><Fieldname>%@</Fieldname><Value>%@</Value><Flabel>%@</Flabel><Datatype>%@</Datatype><Sequence>%@</Sequence><Length>%@</Length></item>",[[customHeaderDetailsArray objectAtIndex:i] objectAtIndex:2],[[customHeaderDetailsArray objectAtIndex:i] objectAtIndex:3],[[customHeaderDetailsArray objectAtIndex:i] objectAtIndex:4],[[customHeaderDetailsArray objectAtIndex:i] objectAtIndex:5],[[customHeaderDetailsArray objectAtIndex:i] objectAtIndex:6],[[customHeaderDetailsArray objectAtIndex:i] objectAtIndex:7],[[customHeaderDetailsArray objectAtIndex:i] objectAtIndex:8]];
                }
                
                customFieldsString = [NSString stringWithFormat:@"<Fields><!--Zero or more repetitions:-->%@</Fields>",customHeaderItemFieldsString];
            }
            
            if ([NullChecker isNull:[requestData objectForKey:@"WORKCENTERID"]]) {
                
                workCenterString = @"";
            }
            else{
                
                workCenterString = [self getcodeforkeys:[requestData objectForKey:@"WORKCENTERID"]];
            }
            
            if ([NullChecker isNull:[requestData objectForKey:@"PLANTID"]]) {
                str_Plant = @"";
            }
            else{
                str_Plant = [requestData objectForKey:@"PLANTID"];
            }
            
            
            if ([[requestData objectForKey:@"RSDATE"] length]) {
                reqStartDate=[[requestData objectForKey:@"RSDATE"] substringToIndex:10];
                reqStartTime=[[requestData objectForKey:@"RSDATE"] substringFromIndex:11];
            }
            else{
                reqStartDate=@"";
                reqStartTime=@"";
            }
            
            if ([[requestData objectForKey:@"REDATE"] length]) {
                reqEndDate=[[requestData objectForKey:@"REDATE"] substringToIndex:10];
                reqEndTime=[[requestData objectForKey:@"REDATE"] substringFromIndex:11];
            }
            else{
                reqEndDate=@"";
                reqEndTime=@"";
            }
            
            
            if ([[requestData objectForKey:@"SDATE"] length]) {
                reqMStartDate=[[requestData objectForKey:@"SDATE"] substringToIndex:10];
                reqMStartTime=[[requestData objectForKey:@"SDATE"] substringFromIndex:11];
            }
            else{
                reqMStartDate=@"";
                reqMStartTime=@"";
            }
            
            if ([[requestData objectForKey:@"EDATE"] length]) {
                reqMEndDate=[[requestData objectForKey:@"EDATE"] substringToIndex:10];
                reqMEndTime=[[requestData objectForKey:@"EDATE"] substringFromIndex:11];
            }
            else{
                reqMEndDate=@"";
                reqMEndTime=@"";
            }
            
            //            [soapMessage appendFormat:@"<ItNotifHeader><!--Zero or more repetitions:--><item><NotifType>%@</NotifType><Qmnum>%@</Qmnum><NotifShorttxt>%@</NotifShorttxt><FunctionLoc>%@</FunctionLoc><Equipment>%@</Equipment><ReportedBy>%@</ReportedBy><MalfuncStdate>%@</MalfuncStdate><MalfuncEddate>%@</MalfuncEddate><MalfuncSttime>%@</MalfuncSttime><MalfuncEdtime>%@</MalfuncEdtime><BreakdownInd>%@</BreakdownInd><Priority>%@</Priority><Ingrp></Ingrp><Arbpl>%@</Arbpl><Werks>%@</Werks><Strmn>%@</Strmn><Ltrmn>%@</Ltrmn><Strur>%@</Strur><Ltrur>%@</Ltrur><Aufnr>%@</Aufnr><ParnrVw>%@</ParnrVw><NameVw>%@</NameVw><Docs>%@</Docs><Closed></Closed><Completed></Completed><Createdon></Createdon><Auswk>%@</Auswk><Shift>%@</Shift><Noofperson>%@</Noofperson>%@</item></ItNotifHeader>",[requestData objectForKey:@"NID"],[requestData objectForKey:@"OBJECTID"],[requestData objectForKey:@"SHORTTEXT"],[requestData objectForKey:@"FID"],[requestData objectForKey:@"EQID"],[requestData objectForKey:@"NREPORTEDBY"],reqMStartDate,reqMEndDate,reqMStartTime,reqMEndTime,[requestData objectForKey:@"BREAKDOWN"],[requestData objectForKey:@"NPID"],workCenterString,str_Plant,reqStartDate,reqEndDate,reqStartTime,reqEndTime,[requestData objectForKey:@"AUFNR"],[requestData objectForKey:@"PARNRID"],[requestData objectForKey:@"PARNRTEXT"],[requestData objectForKey:@"DOCS"],[requestData objectForKey:@"EFFECTID"],[requestData objectForKey:@"SHIFT"],[requestData objectForKey:@"NOOFPERSON"],customFieldsString];
            
            
            [soapMessage appendFormat:@"<ItNotifHeader><!--Zero or more repetitions:--><item><NotifType>%@</NotifType><Qmnum>%@</Qmnum><NotifShorttxt>%@</NotifShorttxt><FunctionLoc>%@</FunctionLoc><Equipment>%@</Equipment><ReportedBy>%@</ReportedBy><MalfuncStdate>%@</MalfuncStdate><MalfuncEddate>%@</MalfuncEddate><MalfuncSttime>%@</MalfuncSttime><MalfuncEdtime>%@</MalfuncEdtime><BreakdownInd>%@</BreakdownInd><Priority>%@</Priority><Ingrp>%@</Ingrp><Arbpl>%@</Arbpl><Werks>%@</Werks><Strmn>%@</Strmn><Ltrmn>%@</Ltrmn><Strur>%@</Strur><Ltrur>%@</Ltrur><Aufnr>%@</Aufnr><ParnrVw>%@</ParnrVw><NameVw>%@</NameVw><Docs>%@</Docs><Closed></Closed><Completed></Completed><Createdon></Createdon><Ingrpname>%@</Ingrpname><Auswk>%@</Auswk><Shift>%@</Shift><Noofperson>%@</Noofperson><Usr01>%@</Usr01><Usr02>%@</Usr02>%@</item></ItNotifHeader>",[requestData objectForKey:@"NID"],[requestData objectForKey:@"OBJECTID"],[requestData objectForKey:@"SHORTTEXT"],[requestData objectForKey:@"FID"],[requestData objectForKey:@"EQID"],[requestData objectForKey:@"NREPORTEDBY"],reqMStartDate,reqMEndDate,reqMStartTime,reqMEndTime,[requestData objectForKey:@"BREAKDOWN"],[requestData objectForKey:@"NPID"],[requestData objectForKey:@"PLANNERGROUP"],workCenterString,str_Plant,reqStartDate,reqEndDate,reqStartTime,reqEndTime,[requestData objectForKey:@"AUFNR"],[requestData objectForKey:@"PARNRID"],[requestData objectForKey:@"PARNRTEXT"],[requestData objectForKey:@"DOCS"],[requestData objectForKey:@"PLANNERGROUPNAME"],[requestData objectForKey:@"EFFECTID"],[requestData objectForKey:@"SHIFT"],[requestData objectForKey:@"NOOFPERSON"],[requestData objectForKey:@"USR01"],[requestData objectForKey:@"USR02"],customFieldsString];
            
            
            
            if ([[requestData objectForKey:@"ITEMS"] count]) {
                NSArray *causeCodeDetailsArray = [requestData objectForKey:@"ITEMS"];
                [soapMessage appendString:@"<!--Optional:--><ItNotifItems><!--Zero or more repetitions:-->"];
                for (int i = 0; i<[causeCodeDetailsArray count]; i++) {
                    
                    customFieldsString = @"";
                    [customHeaderItemFieldsString setString:@""];
                    
                    for (int x = 0; x<[[[causeCodeDetailsArray objectAtIndex:i] objectAtIndex:1] count]; x++) {
                        
                        [customHeaderItemFieldsString appendFormat:@"<item><Zdoctype>Q</Zdoctype><ZdoctypeItem>%@</ZdoctypeItem><Tabname>%@</Tabname><Fieldname>%@</Fieldname><Value>%@</Value><Flabel>%@</Flabel><Datatype>%@</Datatype><Sequence>%@</Sequence><Length>%@</Length></item>",[[[[causeCodeDetailsArray objectAtIndex:i] objectAtIndex:1] objectAtIndex:x] objectAtIndex:1],[[[[causeCodeDetailsArray objectAtIndex:i] objectAtIndex:1] objectAtIndex:x] objectAtIndex:2],[[[[causeCodeDetailsArray objectAtIndex:i] objectAtIndex:1] objectAtIndex:x] objectAtIndex:3],[[[[causeCodeDetailsArray objectAtIndex:i] objectAtIndex:1] objectAtIndex:x] objectAtIndex:4],[[[[causeCodeDetailsArray objectAtIndex:i] objectAtIndex:1] objectAtIndex:x] objectAtIndex:5],[[[[causeCodeDetailsArray objectAtIndex:i] objectAtIndex:1] objectAtIndex:x] objectAtIndex:6],[[[[causeCodeDetailsArray objectAtIndex:i] objectAtIndex:1] objectAtIndex:x] objectAtIndex:7],[[[[causeCodeDetailsArray objectAtIndex:i] objectAtIndex:1] objectAtIndex:x] objectAtIndex:8]];
                    }
                    
                    for (int x = 0; x<[[[causeCodeDetailsArray objectAtIndex:i] lastObject] count]; x++) {
                        
                        [customHeaderItemFieldsString appendFormat:@"<item><Zdoctype>Q</Zdoctype><ZdoctypeItem>%@</ZdoctypeItem><Tabname>%@</Tabname><Fieldname>%@</Fieldname><Value>%@</Value><Flabel>%@</Flabel><Datatype>%@</Datatype><Sequence>%@</Sequence><Length>%@</Length></item>",[[[[causeCodeDetailsArray objectAtIndex:i] lastObject] objectAtIndex:x] objectAtIndex:1],[[[[causeCodeDetailsArray objectAtIndex:i] lastObject] objectAtIndex:x] objectAtIndex:2],[[[[causeCodeDetailsArray objectAtIndex:i] lastObject] objectAtIndex:x] objectAtIndex:3],[[[[causeCodeDetailsArray objectAtIndex:i] lastObject] objectAtIndex:x] objectAtIndex:4],[[[[causeCodeDetailsArray objectAtIndex:i] lastObject] objectAtIndex:x] objectAtIndex:5],[[[[causeCodeDetailsArray objectAtIndex:i] lastObject] objectAtIndex:x] objectAtIndex:6],[[[[causeCodeDetailsArray objectAtIndex:i] lastObject] objectAtIndex:x] objectAtIndex:7],[[[[causeCodeDetailsArray objectAtIndex:i] lastObject] objectAtIndex:x] objectAtIndex:8]];
                    }
                    
                    customFieldsString = [NSString stringWithFormat:@"<Fields><!--Zero or more repetitions:-->%@</Fields>",customHeaderItemFieldsString];
                    
                    NSString *actionString = @"";
                    if ([[[[causeCodeDetailsArray objectAtIndex:i] firstObject] objectAtIndex:14] isEqualToString:@"A"]) {
                        actionString = @"I";
                    }
                    else if([[[[causeCodeDetailsArray objectAtIndex:i] firstObject] objectAtIndex:14] isEqualToString:@"D"])
                    {
                        actionString = @"D";
                    }
                    else if([[[[causeCodeDetailsArray objectAtIndex:i] firstObject] objectAtIndex:15] isEqualToString:@"U"])
                    {
                        actionString = @"U";
                    }
                    
                    [soapMessage appendFormat:@"<item><Qmnum>%@</Qmnum><ItempartGrp>%@</ItempartGrp><Partgrptext>%@</Partgrptext><ItempartCod>%@</ItempartCod><Partcodetext>%@</Partcodetext><ItemdefectGrp>%@</ItemdefectGrp><ItemKey>%@</ItemKey><ItemdefectCod>%@</ItemdefectCod><ItemdefectShtxt>%@</ItemdefectShtxt><CauseKey>%@</CauseKey><CauseGrp>%@</CauseGrp><CauseCod>%@</CauseCod><CauseShtxt>%@</CauseShtxt>%@<Action>%@</Action></item>",[requestData objectForKey:@"OBJECTID"],[[[causeCodeDetailsArray objectAtIndex:i] firstObject] objectAtIndex:16],[[[causeCodeDetailsArray objectAtIndex:i] firstObject] objectAtIndex:18],[[[causeCodeDetailsArray objectAtIndex:i] firstObject] objectAtIndex:17],[[[causeCodeDetailsArray objectAtIndex:i] firstObject] objectAtIndex:19],[[[causeCodeDetailsArray objectAtIndex:i] firstObject] objectAtIndex:2],[[[causeCodeDetailsArray objectAtIndex:i] firstObject] objectAtIndex:12],[[[causeCodeDetailsArray objectAtIndex:i] firstObject] objectAtIndex:4],[[[causeCodeDetailsArray objectAtIndex:i] firstObject] objectAtIndex:10],[[[causeCodeDetailsArray objectAtIndex:i] firstObject] objectAtIndex:13],[[[causeCodeDetailsArray objectAtIndex:i] firstObject] objectAtIndex:6],[[[causeCodeDetailsArray objectAtIndex:i] firstObject] objectAtIndex:8],[[[causeCodeDetailsArray objectAtIndex:i] firstObject] objectAtIndex:11],customFieldsString,actionString];
                }
                [soapMessage appendString:@"</ItNotifItems>"];
            }
            
            if ([[requestData objectForKey:@"LONGTEXT"] length]) {
                NSArray *longTextArray = [[requestData objectForKey:@"LONGTEXT"] componentsSeparatedByString:@"\n"];
                [soapMessage appendString:@"<!--Optional:--><ItNotifLongtext><!--Zero or more repetitions:-->"];
                for (int i=0; i<[longTextArray count]; i++) {
                    [soapMessage appendFormat:@"<item><Qmnum>%@</Qmnum><TextLine>%@</TextLine></item>",[requestData objectForKey:@"OBJECTID"],[longTextArray objectAtIndex:i]];
                }
                [soapMessage appendString:@"</ItNotifLongtext><!--Optional:-->"];
            }
            
            //notif tasks
            if ([[requestData objectForKey:@"TASKS"] count]) {
                
                NSArray *taskCodeDetailsArray = [requestData objectForKey:@"TASKS"];
                [soapMessage appendString:@"<!--Optional:--><ItNotifTasks><!--Zero or more repetitions:-->"];
                
                for (int i = 0; i<[taskCodeDetailsArray count]; i++) {
                    
                    customFieldsString = @"";
                    [customHeaderItemFieldsString setString:@""];
                    
                    id taskDetails=[[taskCodeDetailsArray objectAtIndex:i] lastObject];
                    
                    for (int x = 0; x<[taskDetails count]; x++) {
                        
                        if ([[taskDetails objectAtIndex:0] isKindOfClass:[NSArray class]]) {
                            
                            [customHeaderItemFieldsString appendFormat:@"<item><Zdoctype>Q</Zdoctype><ZdoctypeItem>%@</ZdoctypeItem><Tabname>%@</Tabname><Fieldname>%@</Fieldname><Value>%@</Value><Flabel>%@</Flabel><Datatype>%@</Datatype><Sequence>%@</Sequence><Length>%@</Length></item>",[[taskDetails objectAtIndex:x] objectAtIndex:1],[[taskDetails objectAtIndex:x] objectAtIndex:2],[[taskDetails objectAtIndex:x] objectAtIndex:3],[[taskDetails objectAtIndex:x] objectAtIndex:4],[[taskDetails objectAtIndex:x] objectAtIndex:5],[[taskDetails objectAtIndex:x] objectAtIndex:6],[[taskDetails objectAtIndex:x] objectAtIndex:7],[[taskDetails objectAtIndex:x] objectAtIndex:8]];
                        }
                        else{
                            
                            [customHeaderItemFieldsString appendFormat:@"<item><Zdoctype>Q</Zdoctype><ZdoctypeItem>%@</ZdoctypeItem><Tabname>%@</Tabname><Fieldname>%@</Fieldname><Value>%@</Value><Flabel>%@</Flabel><Datatype>%@</Datatype><Sequence>%@</Sequence><Length>%@</Length></item>",[taskDetails  objectAtIndex:1],[taskDetails  objectAtIndex:2],[taskDetails  objectAtIndex:3],[taskDetails  objectAtIndex:4],[taskDetails  objectAtIndex:5],[taskDetails  objectAtIndex:6],[taskDetails  objectAtIndex:7],[taskDetails  objectAtIndex:8]];
                        }
                    }
                    
                    customFieldsString = [NSString stringWithFormat:@"<Fields><!--Zero or more repetitions:-->%@</Fields>",customHeaderItemFieldsString];
                    
                    
                    
                    NSString *erlnamString,*erldatString,*erlzeitString;
                    
                    if ([[[[taskCodeDetailsArray objectAtIndex:i] firstObject] objectAtIndex:40] isEqual:@"00:00:00"]) {
                        
                        erlnamString=@"";
                    }
                    else{
                        
                        erlnamString=[[[taskCodeDetailsArray objectAtIndex:i] firstObject] objectAtIndex:40];
                        
                    }
                    
                    
                    if (![NullChecker isNull:[[[taskCodeDetailsArray objectAtIndex:i] firstObject] objectAtIndex:38]]) {
                        
                        
                        if ([[[[taskCodeDetailsArray objectAtIndex:i] firstObject] objectAtIndex:38] isEqual:@"0000-00-00"]) {
                            
                            erldatString=@"";
                        }
                        else{
                            
                            erldatString=[[[taskCodeDetailsArray objectAtIndex:i] firstObject] objectAtIndex:38];
                            
                        }
                    }
                    else{
                        
                        erldatString=@"";
                        
                    }
                    
                    
                    if ([[[[taskCodeDetailsArray objectAtIndex:i] firstObject] objectAtIndex:39] isEqual:@"00:00:00"]) {
                        
                        erlzeitString=@"";
                    }
                    else{
                        
                        erlzeitString=[[[taskCodeDetailsArray objectAtIndex:i] firstObject] objectAtIndex:39];
                        
                    }
                    
                    [soapMessage appendFormat:@"<item><Qmnum>%@</Qmnum><ItemKey>%@</ItemKey><ItempartGrp></ItempartGrp><Partgrptext></Partgrptext><ItempartCod></ItempartCod><Partcodetext></Partcodetext><ItemdefectGrp></ItemdefectGrp><Defectgrptext></Defectgrptext><ItemdefectCod></ItemdefectCod><Defectcodetext></Defectcodetext><ItemdefectShtxt></ItemdefectShtxt><TaskKey>%@</TaskKey><TaskGrp>%@</TaskGrp><Taskgrptext>%@</Taskgrptext><TaskCod>%@</TaskCod><Taskcodetext>%@</Taskcodetext><TaskShtxt>%@</TaskShtxt><Pster>%@</Pster><Peter>%@</Peter><Pstur>%@</Pstur><Petur>%@</Petur><Parvw>%@</Parvw><Parnr>%@</Parnr><Erlnam>%@</Erlnam><Erldat>%@</Erldat><Erlzeit>%@</Erlzeit><Release>%@</Release><Complete>%@</Complete><Success>%@</Success><UserStatus></UserStatus><SysStatus></SysStatus><Smsttxt></Smsttxt><Smastxt></Smastxt><Usr01></Usr01><Usr02></Usr02><Usr03></Usr03><Usr04></Usr04><Usr05></Usr05>",[requestData objectForKey:@"OBJECTID"],[[[taskCodeDetailsArray objectAtIndex:i] firstObject] objectAtIndex:16],[[[taskCodeDetailsArray objectAtIndex:i] firstObject] objectAtIndex:2],[[[taskCodeDetailsArray objectAtIndex:i] firstObject] objectAtIndex:3],[self getcodeforkeys:[[[taskCodeDetailsArray objectAtIndex:i] firstObject] objectAtIndex:4]],[[[taskCodeDetailsArray objectAtIndex:i] firstObject] objectAtIndex:5],[[[taskCodeDetailsArray objectAtIndex:i] firstObject] objectAtIndex:6],[[[taskCodeDetailsArray objectAtIndex:i] firstObject] objectAtIndex:7],[[[taskCodeDetailsArray objectAtIndex:i] firstObject] objectAtIndex:11],[[[taskCodeDetailsArray objectAtIndex:i] firstObject] objectAtIndex:12],[[[taskCodeDetailsArray objectAtIndex:i] firstObject] objectAtIndex:36],[[[taskCodeDetailsArray objectAtIndex:i] firstObject] objectAtIndex:37],[[[taskCodeDetailsArray objectAtIndex:i] firstObject] objectAtIndex:8],[[[taskCodeDetailsArray objectAtIndex:i] firstObject] objectAtIndex:10],erlnamString,erldatString,erlnamString,[[[taskCodeDetailsArray objectAtIndex:i] firstObject] objectAtIndex:13],[[[taskCodeDetailsArray objectAtIndex:i] firstObject] objectAtIndex:14],[[[taskCodeDetailsArray objectAtIndex:i] firstObject] objectAtIndex:15]];
                    
                    
                    //                    [soapMessage appendFormat:@"<Fields><!--Zero or more repetitions:--><item><Zdoctype></Zdoctype><ZdoctypeItem></ZdoctypeItem><Tabname></Tabname><Fieldname></Fieldname><Datatype></Datatype><Value></Value><Flabel></Flabel><Sequence></Sequence><Length></Length></item></Fields>"];
                    
                    
                    if ([[[[taskCodeDetailsArray objectAtIndex:i] firstObject] objectAtIndex:17] isEqualToString:@"A"]) {
                        [soapMessage appendFormat:@"%@<Action>I</Action>",customFieldsString];
                    }
                    else{
                        
                        [soapMessage appendFormat:@"<Action>%@</Action>",[[[taskCodeDetailsArray objectAtIndex:i] firstObject] objectAtIndex:17]];
                    }
                    
                    [soapMessage appendFormat:@"</item>"];
                }
                
                [soapMessage appendString:@"</ItNotifTasks>"];
            }
            
            [soapMessage appendFormat:@"<!--Optional:--><IvTransmitType>%@</IvTransmitType>",[requestData objectForKey:@"TRANSMITTYPE"]];
            
            [soapMessage appendString:@"<IvCommit>X</IvCommit>"];
            
            break;
            
        case NOTIFICATION_CANCEL:
            
            [soapMessage appendFormat:@"<!--Optional:--><IsDevice><Muser>%@</Muser><Deviceid>%@</Deviceid><Devicesno></Devicesno><Udid></Udid></IsDevice>",[[requestData objectForKey:@"REPORTEDBY"] uppercaseString],[[[UIDevice currentDevice] identifierForVendor] UUIDString]];
            
            [soapMessage appendString:@"<ItNotifCancel><!--Zero or more repetitions:-->"];
            if ([requestData objectForKey:@"ITEMS"]) {
                NSMutableArray *objectIds = [requestData objectForKey:@"ITEMS"];
                for (int i=0; i<[objectIds count]; i++) {
                    [soapMessage appendFormat:@"<item><Qmnum>%@</Qmnum></item>",[objectIds objectAtIndex:i]];
                }
            }
            [soapMessage appendString:@"</ItNotifCancel>"];
            
            [soapMessage appendFormat:@"<!--Optional:--><IvTransmitType>%@</IvTransmitType>",[requestData objectForKey:@"TRANSMITTYPE"]];
            
            [soapMessage appendString:@"<!--Optional:--><IvCommit>X</IvCommit>"];
            
            break;
            
        case NOTIFICATION_COMPLETE:
            
            [soapMessage appendFormat:@"<!--Optional:--><IsDevice><Muser>%@</Muser><Deviceid>%@</Deviceid><Devicesno></Devicesno><Udid></Udid></IsDevice>",[[requestData objectForKey:@"REPORTEDBY"] uppercaseString],[[[UIDevice currentDevice] identifierForVendor] UUIDString]];
            
            [soapMessage appendString:@"<ItNotifComplete><!--Zero or more repetitions:-->"];
            if ([requestData objectForKey:@"ITEMS"]) {
                NSMutableArray *objectIds = [requestData objectForKey:@"ITEMS"];
                for (int i=0; i<[objectIds count]; i++) {
                    [soapMessage appendFormat:@"<item><Qmnum>%@</Qmnum></item>",[objectIds objectAtIndex:i]];
                }
            }
            [soapMessage appendString:@"</ItNotifComplete>"];
            
            [soapMessage appendFormat:@"<!--Optional:--><IvTransmitType>%@</IvTransmitType>",[requestData objectForKey:@"TRANSMITTYPE"]];
            
            [soapMessage appendString:@"<!--Optional:--><IvCommit>X</IvCommit>"];
            
            break;
            
        case GET_LIST_OF_DUE_NOTIFICATIONS:
            
            [soapMessage appendFormat:@"<!--Optional:--><IsDevice><Muser>%@</Muser><Deviceid>%@</Deviceid><Devicesno></Devicesno><Udid></Udid></IsDevice>",[[requestData objectForKey:@"REPORTEDBY"] uppercaseString],[[[UIDevice currentDevice] identifierForVendor] UUIDString]];
            
            [soapMessage appendFormat:@"<!--Optional:--><IvTransmitType>%@</IvTransmitType><!--Optional:--><IvUser>%@</IvUser>",[requestData objectForKey:@"TRANSMITTYPE"],[[requestData objectForKey:@"REPORTEDBY"] uppercaseString]];
            
            break;
            
            //        case ORDER_CREATE:
            //
            //            [soapMessage appendFormat:@"<!--Optional:--><IsDevice><Muser>%@</Muser><Deviceid>%@</Deviceid><Devicesno></Devicesno><Udid></Udid></IsDevice>",[[requestData objectForKey:@"REPORTEDBY"] uppercaseString],[[[UIDevice currentDevice] identifierForVendor] UUIDString]];
            //
            ////            if ([[requestData objectForKey:@"LATITUDE"] length] && [[requestData objectForKey:@"LONGITUDE"] length] && [[requestData objectForKey:@"ALTITUDE"] length]) {
            ////                [soapMessage appendFormat:@"<!--Optional:--><IsGeo><Latitude>%@</Latitude><Longitude>%@</Longitude><Altitude>%@</Altitude></IsGeo>",[requestData objectForKey:@"LATITUDE"],[requestData objectForKey:@"LONGITUDE"],[requestData objectForKey:@"ALTITUDE"]];
            ////            }
            //
            //            if ([[requestData objectForKey:@"ATTACHMENTS"] count]) {
            //                attachDocs = [NSMutableString new];
            //                NSArray *attachmentsArray = [requestData objectForKey:@"ATTACHMENTS"];
            //                for (int i =0; i<[attachmentsArray count]; i++) {
            //
            //                [attachDocs appendFormat:@"<item><Zobjid></Zobjid><Zdoctype>W</Zdoctype><ZdoctypeItem>WH</ZdoctypeItem><Filename>%@</Filename><Filetype>%@</Filetype><Fsize>%@</Fsize><Content>%@</Content></item>",[[attachmentsArray objectAtIndex:i] objectAtIndex:3],[[attachmentsArray objectAtIndex:i] objectAtIndex:4],[[attachmentsArray objectAtIndex:i] objectAtIndex:5],[[attachmentsArray objectAtIndex:i] objectAtIndex:7]];
            //            }
            //
            //            if ([attachDocs length]) {
            //                    [soapMessage appendFormat:@"<!--Optional:--><ItDocs><!--Zero or more repetitions:-->%@</ItDocs>",attachDocs];
            //                }
            //            }
            //
            //            /*
            //             [soapMessage appendFormat:@"<!--Optional:--><ItDocs><!--Zero or more repetitions:--><item><Zobjid></Zobjid><Zdoctype>W</Zdoctype><ZdoctypeItem>WH</ZdoctypeItem><Filename>%@</Filename><Filetype>%@</Filetype><Fsize>%@</Fsize><Content>%@</Content></item></ItDocs>"];
            //            */
            //
            //            if ([[requestData objectForKey:@"ITEMS"] count]) {
            //                NSArray *operationDetailsArray = [requestData objectForKey:@"ITEMS"];
            //                orderComponents = [[NSMutableString alloc] initWithString:@""];
            //                feildComponents = [[NSMutableString alloc] initWithString:@""];
            //
            //            for (int i = 0; i<[operationDetailsArray count]; i++) {
            //                if (![[[[operationDetailsArray objectAtIndex:i] firstObject] objectAtIndex:12] isEqual:@""]) {
            //                    //Need to write for loop for this FeildComponents
            //
            //                    for (int x = 0; x<[[[operationDetailsArray objectAtIndex:i] lastObject] count]; x++) {
            //
            //                        [feildComponents appendFormat:@"<item><Zdoctype>W</Zdoctype><ZdoctypeItem>%@</ZdoctypeItem><Tabname>%@</Tabname><Fieldname>%@</Fieldname><Value>%@</Value><Flabel>%@</Flabel><Datatype>%@</Datatype><Sequence>%@</Sequence><Length>%@</Length></item>",[[[[operationDetailsArray objectAtIndex:i] lastObject] objectAtIndex:x] objectAtIndex:1],[[[[operationDetailsArray objectAtIndex:i] lastObject] objectAtIndex:x] objectAtIndex:2],[[[[operationDetailsArray objectAtIndex:i] lastObject] objectAtIndex:x] objectAtIndex:3],[[[[operationDetailsArray objectAtIndex:i] lastObject] objectAtIndex:x] objectAtIndex:4],[[[[operationDetailsArray objectAtIndex:i] lastObject] objectAtIndex:x] objectAtIndex:5],[[[[operationDetailsArray objectAtIndex:i] lastObject] objectAtIndex:x] objectAtIndex:6],[[[[operationDetailsArray objectAtIndex:i] lastObject] objectAtIndex:x] objectAtIndex:7],[[[[operationDetailsArray objectAtIndex:i] lastObject] objectAtIndex:x] objectAtIndex:8]];
            //                    }
            //
            //                    customFieldsString = [NSString stringWithFormat:@"<Fields><!--Zero or more repetitions:-->%@</Fields>",feildComponents];
            //
            //                    [orderComponents appendFormat:@"<item><Aufnr></Aufnr><Vornr>%@</Vornr><Rsnum></Rsnum><Rspos></Rspos><Matnr>%@</Matnr><Werks>%@</Werks><Lgort>%@</Lgort><Posnr>%@</Posnr><Bdmng>%@</Bdmng><Meins></Meins>%@<Action>I</Action></item>",[[[operationDetailsArray objectAtIndex:i] firstObject] objectAtIndex:1],[[[operationDetailsArray objectAtIndex:i] firstObject] objectAtIndex:11],[[[operationDetailsArray objectAtIndex:i] firstObject] objectAtIndex:13],[[[operationDetailsArray objectAtIndex:i] firstObject] objectAtIndex:14],[[[operationDetailsArray objectAtIndex:i] firstObject] objectAtIndex:15],[[[operationDetailsArray objectAtIndex:i] firstObject] objectAtIndex:16],customFieldsString];
            //                    }
            //                }
            //                if (![orderComponents isEqualToString:@""]) {
            //
            //                    [soapMessage appendFormat:@"<!--Optional:--><ItOrderComponents><!--Zero or more repetitions:-->%@</ItOrderComponents>",orderComponents];
            //                }
            //            }
            //
            //            customFieldsString = @"";
            //            customHeaderItemFieldsString = [[NSMutableString alloc]initWithString:@""];
            //
            //            if ([[requestData objectForKey:@"CFH"] count]) {
            //                NSArray *customHeaderDetailsArray = [requestData objectForKey:@"CFH"];
            //                for (int i =0; i<[customHeaderDetailsArray count]; i++) {
            //                    [customHeaderItemFieldsString appendFormat:@"<item><Zdoctype>W</Zdoctype><ZdoctypeItem>WH</ZdoctypeItem><Tabname>%@</Tabname><Fieldname>%@</Fieldname><Value>%@</Value><Flabel>%@</Flabel><Datatype>%@</Datatype><Sequence>%@</Sequence><Length>%@</Length></item>",[[customHeaderDetailsArray objectAtIndex:i] objectAtIndex:2],[[customHeaderDetailsArray objectAtIndex:i] objectAtIndex:3],[[customHeaderDetailsArray objectAtIndex:i] objectAtIndex:4],[[customHeaderDetailsArray objectAtIndex:i] objectAtIndex:5],[[customHeaderDetailsArray objectAtIndex:i] objectAtIndex:6],[[customHeaderDetailsArray objectAtIndex:i] objectAtIndex:7],[[customHeaderDetailsArray objectAtIndex:i] objectAtIndex:8]];
            //                }
            //
            //                customFieldsString = [NSString stringWithFormat:@"<Fields><!--Zero or more repetitions:-->%@</Fields>",customHeaderItemFieldsString];
            //            }
            //
            //            [soapMessage appendFormat:@"<ItOrderHeader><!--Zero or more repetitions:--><item><Aufnr></Aufnr><Auart>%@</Auart><Ktext>%@</Ktext><Ernam>%@</Ernam><Erdat>%@</Erdat><Priok>%@</Priok><Equnr>%@</Equnr><Strno>%@</Strno><TplnrInt>%@</TplnrInt><Gltrp>%@</Gltrp><Gstrp>%@</Gstrp><Closed></Closed><Completed></Completed><Arbpl>%@</Arbpl><Werks>%@</Werks><Bemot>%@</Bemot><Kokrs>%@</Kokrs><Kostl>%@</Kostl>%@</item></ItOrderHeader>",[requestData objectForKey:@"OID"],[requestData objectForKey:@"SHORTTEXT"],[requestData objectForKey:@"REPORTEDBY"],[requestData objectForKey:@"SDATE"],[requestData objectForKey:@"OPID"],[requestData objectForKey:@"EQID"],[requestData objectForKey:@"FID"],[requestData objectForKey:@"FID"],[requestData objectForKey:@"EDATE"],[requestData objectForKey:@"SDATE"],[requestData objectForKey:@"WORKCENTERID"],[requestData objectForKey:@"PLANTID"],[requestData objectForKey:@"ACCINCID"],[requestData objectForKey:@"workarea"],[requestData objectForKey:@"costcenter"],customFieldsString];
            //
            //            [soapMessage appendString:@"<!--Optional:--><ItOrderLongtext><!--Zero or more repetitions:-->"];
            //
            //            if ([[requestData objectForKey:@"LONGTEXT"] length]) {
            //
            //                NSArray *longTextArray = [[requestData objectForKey:@"LONGTEXT"] componentsSeparatedByString:@"\n"];
            //
            //                for (int i=0; i<[longTextArray count]; i++) {
            //                    [soapMessage appendFormat:@"<item><Aufnr></Aufnr><Activity></Activity><TextLine>%@</TextLine></item>",[longTextArray objectAtIndex:i]];
            //                }
            //            }
            //
            //            if ([[requestData objectForKey:@"ITEMS"] count]) {
            //                NSArray *operationLongTextArray = [requestData objectForKey:@"ITEMS"];
            //
            ////                int Vornr = 0;
            ////                NSString *vornrID;
            //                for (int i =0; i< [operationLongTextArray count]; i++) {
            ////                    Vornr = Vornr+10;
            ////                    vornrID =[NSString stringWithFormat:@"%04i",Vornr];
            //                    //[[operationLongTextArray objectAtIndex:i] objectAtIndex:1]
            //                    NSArray *operationLongTextComponentArray = [[[[operationLongTextArray objectAtIndex:i] firstObject] objectAtIndex:31] componentsSeparatedByString:@"\n"];
            //                    for (int j =0; j<[operationLongTextComponentArray count]; j++) {
            //                    [soapMessage appendFormat:@"<item><Aufnr></Aufnr><Activity>%@</Activity><TextLine>%@</TextLine></item>",[[[operationLongTextArray objectAtIndex:i] firstObject] objectAtIndex:1],[operationLongTextComponentArray objectAtIndex:j]];
            //                    }
            //                }
            //            }
            //
            //            [soapMessage appendString:@"</ItOrderLongtext>"];
            //
            //            if ([[requestData objectForKey:@"ITEMS"] count]) {
            //                NSArray *operationDetailsArray = [requestData objectForKey:@"ITEMS"];
            //                [soapMessage appendString:@"<ItOrderOperations><!--Zero or more repetitions:-->"];
            //                feildOperations = [[NSMutableString alloc]initWithString:@""];
            //
            //                for (int i = 0; i<[operationDetailsArray count]; i++) {
            //
            //                    for (int x = 0; x<[[[operationDetailsArray objectAtIndex:i] objectAtIndex:1] count]; x++) {
            //
            //                        [feildOperations appendFormat:@"<item><Zdoctype>W</Zdoctype><ZdoctypeItem>%@</ZdoctypeItem><Tabname>%@</Tabname><Fieldname>%@</Fieldname><Value>%@</Value><Flabel>%@</Flabel><Datatype>%@</Datatype><Sequence>%@</Sequence><Length>%@</Length></item>",[[[[operationDetailsArray objectAtIndex:i] objectAtIndex:1] objectAtIndex:x] objectAtIndex:1],[[[[operationDetailsArray objectAtIndex:i] objectAtIndex:1] objectAtIndex:x] objectAtIndex:2],[[[[operationDetailsArray objectAtIndex:i] objectAtIndex:1] objectAtIndex:x] objectAtIndex:3],[[[[operationDetailsArray objectAtIndex:i] objectAtIndex:1] objectAtIndex:x] objectAtIndex:4],[[[[operationDetailsArray objectAtIndex:i] objectAtIndex:1] objectAtIndex:x] objectAtIndex:5],[[[[operationDetailsArray objectAtIndex:i] objectAtIndex:1] objectAtIndex:x] objectAtIndex:6],[[[[operationDetailsArray objectAtIndex:i] objectAtIndex:1] objectAtIndex:x] objectAtIndex:7],[[[[operationDetailsArray objectAtIndex:i] objectAtIndex:1] objectAtIndex:x] objectAtIndex:8]];
            //                    }
            //
            //                    customFieldsString = [NSString stringWithFormat:@"<Fields><!--Zero or more repetitions:-->%@</Fields>",feildOperations];
            //
            //                    [soapMessage appendFormat:@"<item><Aufnr></Aufnr><Vornr>%@</Vornr><Ltxa1>%@</Ltxa1><Arbpl>%@</Arbpl><Werks>%@</Werks><Steus>%@</Steus><Dauno>%@</Dauno><Daune>%@</Daune><Fsavd></Fsavd><Ssedd></Ssedd><Rueck></Rueck><Aueru></Aueru><ArbplText>%@</ArbplText><WerksText>%@</WerksText><SteusText>%@</SteusText>%@<Action>I</Action></item>",[[[operationDetailsArray objectAtIndex:i] firstObject] objectAtIndex:1],[[[operationDetailsArray objectAtIndex:i] firstObject] objectAtIndex:2],[[[operationDetailsArray objectAtIndex:i] firstObject] objectAtIndex:39],[[[operationDetailsArray objectAtIndex:i] firstObject] objectAtIndex:37],[[[operationDetailsArray objectAtIndex:i] firstObject] objectAtIndex:30],[[[operationDetailsArray objectAtIndex:i] firstObject] objectAtIndex:3],[[[operationDetailsArray objectAtIndex:i] firstObject] objectAtIndex:4],[[[operationDetailsArray objectAtIndex:i] firstObject] objectAtIndex:40],[[[operationDetailsArray objectAtIndex:i] firstObject] objectAtIndex:38],[[[operationDetailsArray objectAtIndex:i] firstObject] objectAtIndex:41],customFieldsString];
            //                }
            //
            //                [soapMessage appendString:@"</ItOrderOperations>"];
            //            }
            //
            //            if ([[requestData objectForKey:@"PERMITS"] count]) {
            //                NSArray *permitDetailsArray = [requestData objectForKey:@"PERMITS"];
            //                feildPermits = [[NSMutableString alloc] initWithString:@""];
            //                orderPermits = [[NSMutableString alloc] initWithString:@""];
            //                int Vornr = 0;
            //                NSString *vornrID;
            //                for (int i = 0; i<[permitDetailsArray count]; i++) {
            //                                            //Need to write for loop for this FeildPermits
            //                        //   for (int i =0; i<[]; <#increment#>) {
            //                        //               <#statements#>
            //                        //    }
            //                        //  [feildPermits appendFormat:@"<item><Zdoctype>?</Zdoctype><ZdoctypeItem>?</ZdoctypeItem><Tabname>?</Tabname><Fieldname>?</Fieldname><Value>?</Value><Flabel>?</Flabel></item>"];
            //
            //                        Vornr = Vornr+10;
            //
            //                        vornrID =[NSString stringWithFormat:@"%04i",Vornr];
            //
            //                    [orderPermits appendFormat:@"<item><Vornr>%@</Vornr><Permit>%@</Permit><Release>%@</Release><Complete>%@</Complete><NotRelevant>%@</NotRelevant><IssuedBy>%@</IssuedBy><Fields><!--Zero or more repetitions:-->%@</Fields><Action>I</Action></item>",vornrID,[[permitDetailsArray objectAtIndex:i] objectAtIndex:1],[[permitDetailsArray objectAtIndex:i] objectAtIndex:3],[[permitDetailsArray objectAtIndex:i] objectAtIndex:4],[[permitDetailsArray objectAtIndex:i] objectAtIndex:5],[[permitDetailsArray objectAtIndex:i] objectAtIndex:7],feildPermits];
            //                }
            //                if (![orderPermits isEqualToString:@""]) {
            //                     [soapMessage appendFormat:@"<!--Optional:--><ItOrderPermits><!--Zero or more repetitions:-->%@</ItOrderPermits>",orderPermits];
            //                }
            //            }
            //
            //            [soapMessage appendFormat:@"<!--Optional:--><IvTransmitType>%@</IvTransmitType>",[requestData objectForKey:@"TRANSMITTYPE"]];
            //
            //            [soapMessage appendString:@"<!--Optional:--><IvCommit>X</IvCommit>"];
            //
            //            break;
            
        case ORDER_CREATE:
            
            [soapMessage appendFormat:@"<!--Optional:--><IsDevice><Muser>%@</Muser><Deviceid>%@</Deviceid><Devicesno></Devicesno><Udid></Udid></IsDevice>",[[requestData objectForKey:@"REPORTEDBY"] uppercaseString],[[[UIDevice currentDevice] identifierForVendor] UUIDString]];
            
            if ([[requestData objectForKey:@"PARTS"] count]) {
                
                NSArray *partDetailsArray = [requestData objectForKey:@"PARTS"];
                orderComponents = [[NSMutableString alloc] initWithString:@""];
                feildComponents = [[NSMutableString alloc] initWithString:@""];
                
                for (int i = 0; i<[partDetailsArray count]; i++) {
                    //Need to write for loop for this FeildComponents
                    
                    for (int x = 0; x<[[[partDetailsArray objectAtIndex:i] lastObject] count]; x++) {
                        
                        [feildComponents appendFormat:@"<item><Zdoctype>W</Zdoctype><ZdoctypeItem>%@</ZdoctypeItem><Tabname>%@</Tabname><Fieldname>%@</Fieldname><Value>%@</Value><Flabel>%@</Flabel><Datatype>%@</Datatype><Sequence>%@</Sequence><Length>%@</Length></item>",[[[[partDetailsArray objectAtIndex:i] lastObject] objectAtIndex:x] objectAtIndex:1],[[[[partDetailsArray objectAtIndex:i] lastObject] objectAtIndex:x] objectAtIndex:2],[[[[partDetailsArray objectAtIndex:i] lastObject] objectAtIndex:x] objectAtIndex:3],[[[[partDetailsArray objectAtIndex:i] lastObject] objectAtIndex:x] objectAtIndex:4],[[[[partDetailsArray objectAtIndex:i] lastObject] objectAtIndex:x] objectAtIndex:5],[[[[partDetailsArray objectAtIndex:i] lastObject] objectAtIndex:x] objectAtIndex:6],[[[[partDetailsArray objectAtIndex:i] lastObject] objectAtIndex:x] objectAtIndex:7],[[[[partDetailsArray objectAtIndex:i] lastObject] objectAtIndex:x] objectAtIndex:8]];
                    }
                    
                    customFieldsString = [NSString stringWithFormat:@"<Fields><!--Zero or more repetitions:-->%@</Fields>",feildComponents];
                    
                    [orderComponents appendFormat:@"<item><Aufnr></Aufnr><Vornr>%@</Vornr><Rsnum></Rsnum><Rspos></Rspos><Matnr>%@</Matnr><Werks>%@</Werks><Lgort>%@</Lgort><Posnr>%@</Posnr><Bdmng>%@</Bdmng><Meins></Meins><Wempf>%@</Wempf><Ablad>%@</Ablad>%@<Action>I</Action></item>",[[[partDetailsArray objectAtIndex:i] firstObject] objectAtIndex:1],[[[partDetailsArray objectAtIndex:i] firstObject] objectAtIndex:5],[[[partDetailsArray objectAtIndex:i] firstObject] objectAtIndex:13],[[[partDetailsArray objectAtIndex:i] firstObject] objectAtIndex:3],[[[partDetailsArray objectAtIndex:i] firstObject] objectAtIndex:8],[[[partDetailsArray objectAtIndex:i] firstObject] objectAtIndex:2],[[[partDetailsArray objectAtIndex:i] firstObject] objectAtIndex:16],[[[partDetailsArray objectAtIndex:i] firstObject] objectAtIndex:17],customFieldsString];
                }
                
                if (![orderComponents isEqualToString:@""]) {
                    
                    [soapMessage appendFormat:@"<!--Optional:--><ItOrderComponents><!--Zero or more repetitions:-->%@</ItOrderComponents>",orderComponents];
                }
            }
            
            customFieldsString = @"";
            customHeaderItemFieldsString = [[NSMutableString alloc]initWithString:@""];
            
            if ([[requestData objectForKey:@"CFH"] count]) {
                
                NSArray *customHeaderDetailsArray = [requestData objectForKey:@"CFH"];
                
                for (int i =0; i<[customHeaderDetailsArray count]; i++) {
                    [customHeaderItemFieldsString appendFormat:@"<item><Zdoctype>W</Zdoctype><ZdoctypeItem>WH</ZdoctypeItem><Tabname>%@</Tabname><Fieldname>%@</Fieldname><Value>%@</Value><Flabel>%@</Flabel><Datatype>%@</Datatype><Sequence>%@</Sequence><Length>%@</Length></item>",[[customHeaderDetailsArray objectAtIndex:i] objectAtIndex:2],[[customHeaderDetailsArray objectAtIndex:i] objectAtIndex:3],[[customHeaderDetailsArray objectAtIndex:i] objectAtIndex:4],[[customHeaderDetailsArray objectAtIndex:i] objectAtIndex:5],[[customHeaderDetailsArray objectAtIndex:i] objectAtIndex:6],[[customHeaderDetailsArray objectAtIndex:i] objectAtIndex:7],[[customHeaderDetailsArray objectAtIndex:i] objectAtIndex:8]];
                }
                
                customFieldsString = [NSString stringWithFormat:@"<Fields><!--Zero or more repetitions:-->%@</Fields>",customHeaderItemFieldsString];
            }
            
            
            [soapMessage appendFormat:@"<ItOrderHeader><!--Zero or more repetitions:--><item><Aufnr></Aufnr><Auart>%@</Auart><Ktext>%@</Ktext><Ilart></Ilart><Ernam>%@</Ernam><Erdat>%@</Erdat><Priok>%@</Priok><Equnr>%@</Equnr><Strno>%@</Strno><TplnrInt>%@</TplnrInt><Bautl></Bautl><Gltrp>%@</Gltrp><Gstrp>%@</Gstrp><Msaus>%@</Msaus><Usage></Usage><Anlzu>%@</Anlzu><Ausvn>%@</Ausvn><Ausbs>%@</Ausbs><Qmnam>%@</Qmnam><Auswk>%@</Auswk><Docs></Docs><Permits></Permits><Altitude></Altitude><Latitude></Latitude><Longitude></Longitude><Qmnum>%@</Qmnum><ParnrVw>%@</ParnrVw><NameVw>%@</NameVw><Qcreate></Qcreate><Closed></Closed><Completed></Completed><Ingrp>%@</Ingrp><Arbpl>%@</Arbpl><Werks>%@</Werks><Bemot></Bemot><Aueru></Aueru><Auarttext></Auarttext><Qmartx></Qmartx><Qmtxt></Qmtxt><Pltxt></Pltxt><Eqktx></Eqktx><Priokx></Priokx><Ilatx></Ilatx><Plantname></Plantname><Wkctrname></Wkctrname><Ingrpname>%@</Ingrpname><Maktx></Maktx><Anlzux></Anlzux><Xstatus></Xstatus><Kokrs>%@</Kokrs><Kostl>%@</Kostl>%@</item></ItOrderHeader>",[requestData objectForKey:@"OID"],[requestData objectForKey:@"SHORTTEXT"],[requestData objectForKey:@"REPORTEDBY"],[requestData objectForKey:@"SDATE"],[requestData objectForKey:@"OPID"],[requestData objectForKey:@"EQID"],[requestData objectForKey:@"FID"],[requestData objectForKey:@"FID"],[requestData objectForKey:@"EDATE"],[requestData objectForKey:@"SDATE"],[requestData objectForKey:@"BREAKDOWN"],[requestData objectForKey:@"SYSTEMCONDITIONID"],[requestData objectForKey:@"MALFUNCTIONSTARTDATE"],[requestData objectForKey:@"MALFUNCTIONENDDATE"],[requestData objectForKey:@"NREPORTEDBY"],[requestData objectForKey:@"EFFECTID"],[requestData objectForKey:@"QMNUM"],[requestData objectForKey:@"PARNRID"],[requestData objectForKey:@"NAMEVW"],[requestData objectForKey:@"PLANNERGROUP"],[self getcodeforkeys:[requestData objectForKey:@"WORKCENTERID"]],[requestData objectForKey:@"PLANTID"],[requestData objectForKey:@"PLANNERGROUPNAME"],[requestData objectForKey:@"workarea"],[requestData objectForKey:@"costcenter"],customFieldsString];
            
            
            [soapMessage appendString:@"<!--Optional:--><ItOrderLongtext><!--Zero or more repetitions:-->"];
            
            if ([[requestData objectForKey:@"LONGTEXT"] length]) {
                
                NSArray *longTextArray = [[requestData objectForKey:@"LONGTEXT"] componentsSeparatedByString:@"\n"];
                
                for (int i=0; i<[longTextArray count]; i++) {
                    [soapMessage appendFormat:@"<item><Aufnr></Aufnr><Activity></Activity><TextLine>%@</TextLine></item>",[longTextArray objectAtIndex:i]];
                }
            }
            
            if ([[requestData objectForKey:@"ITEMS"] count]) {
                
                NSArray *operationLongTextArray = [requestData objectForKey:@"ITEMS"];
                
                //                int Vornr = 0;
                //                NSString *vornrID;
                for (int i =0; i< [operationLongTextArray count]; i++) {
                    //                    Vornr = Vornr+10;
                    //                    vornrID =[NSString stringWithFormat:@"%04i",Vornr];
                    //[[operationLongTextArray objectAtIndex:i] objectAtIndex:1]
                    NSArray *operationLongTextOperationArray = [[[[operationLongTextArray objectAtIndex:i] firstObject] objectAtIndex:20] componentsSeparatedByString:@"\n"];
                    for (int j =0; j<[operationLongTextOperationArray count]; j++) {
                        [soapMessage appendFormat:@"<item><Aufnr></Aufnr><Activity>%@</Activity><TextLine>%@</TextLine></item>",[[[operationLongTextArray objectAtIndex:i] firstObject] objectAtIndex:1],[operationLongTextOperationArray objectAtIndex:j]];
                    }
                }
            }
            
            [soapMessage appendString:@"</ItOrderLongtext>"];
            
            if ([[requestData objectForKey:@"ITEMS"] count]) {
                
                NSArray *operationDetailsArray = [requestData objectForKey:@"ITEMS"];
                [soapMessage appendString:@"<ItOrderOperations><!--Zero or more repetitions:-->"];
                feildOperations = [[NSMutableString alloc]initWithString:@""];
                
                for (int i = 0; i<[operationDetailsArray count]; i++) {
                    
                    for (int x = 0; x<[[[operationDetailsArray objectAtIndex:i] lastObject] count]; x++) {
                        
                        [feildOperations appendFormat:@"<item><Zdoctype>W</Zdoctype><ZdoctypeItem>%@</ZdoctypeItem><Tabname>%@</Tabname><Fieldname>%@</Fieldname><Value>%@</Value><Flabel>%@</Flabel><Datatype>%@</Datatype><Sequence>%@</Sequence><Length>%@</Length></item>",[[[[operationDetailsArray objectAtIndex:i] objectAtIndex:1] objectAtIndex:x] objectAtIndex:1],[[[[operationDetailsArray objectAtIndex:i] objectAtIndex:1] objectAtIndex:x] objectAtIndex:2],[[[[operationDetailsArray objectAtIndex:i] objectAtIndex:1] objectAtIndex:x] objectAtIndex:3],[[[[operationDetailsArray objectAtIndex:i] objectAtIndex:1] objectAtIndex:x] objectAtIndex:4],[[[[operationDetailsArray objectAtIndex:i] objectAtIndex:1] objectAtIndex:x] objectAtIndex:5],[[[[operationDetailsArray objectAtIndex:i] objectAtIndex:1] objectAtIndex:x] objectAtIndex:6],[[[[operationDetailsArray objectAtIndex:i] objectAtIndex:1] objectAtIndex:x] objectAtIndex:7],[[[[operationDetailsArray objectAtIndex:i] objectAtIndex:1] objectAtIndex:x] objectAtIndex:8]];
                    }
                    
                    customFieldsString = [NSString stringWithFormat:@"<Fields><!--Zero or more repetitions:-->%@</Fields>",feildOperations];
                    
                    
                    [soapMessage appendFormat:@"<item><Aufnr></Aufnr><Vornr>%@</Vornr><Ltxa1>%@</Ltxa1><Arbpl>%@</Arbpl><Werks>%@</Werks><Steus>%@</Steus><Dauno>%@</Dauno><Daune>%@</Daune><Fsavd></Fsavd><Ssedd></Ssedd><Rueck></Rueck><Aueru></Aueru><ArbplText>%@</ArbplText><WerksText>%@</WerksText><SteusText>%@</SteusText>%@<Action>I</Action></item>",[[[operationDetailsArray objectAtIndex:i] firstObject] objectAtIndex:1],[[[operationDetailsArray objectAtIndex:i] firstObject] objectAtIndex:2],[self getcodeforkeys:[[[operationDetailsArray objectAtIndex:i] firstObject] objectAtIndex:28]],[[[operationDetailsArray objectAtIndex:i] firstObject] objectAtIndex:26],[[[operationDetailsArray objectAtIndex:i] firstObject] objectAtIndex:19],[[[operationDetailsArray objectAtIndex:i] firstObject] objectAtIndex:3],[[[operationDetailsArray objectAtIndex:i] firstObject] objectAtIndex:4],[self getcodeforkeys:[[[operationDetailsArray objectAtIndex:i] firstObject] objectAtIndex:29]],[[[operationDetailsArray objectAtIndex:i] firstObject] objectAtIndex:27],[[[operationDetailsArray objectAtIndex:i] firstObject] objectAtIndex:30],customFieldsString];
                }
                
                [soapMessage appendString:@"</ItOrderOperations>"];
            }
            
            
            
            
            if ([[requestData objectForKey:@"WCMWORKAPPlICATIONS"] count]) {
                
                NSMutableString *workApplicationString = [[NSMutableString alloc]initWithString:@""];
                
                NSArray *wcmWorkApplication = [requestData objectForKey:@"WCMWORKAPPlICATIONS"];
                
                [soapMessage appendString:@"<!--Optional:--><ItWcmWaChkReq><!--Zero or more repetitions:-->"];
                
                for (int i =0; i<[wcmWorkApplication count]; i++) {
                    
                    [workApplicationString appendFormat:@"<item><Aufnr>%@</Aufnr><Objart>%@</Objart><Wapinr>%@</Wapinr><Iwerk>%@</Iwerk><Objtyp>%@</Objtyp><Usage>%@</Usage><Usagex>%@</Usagex><Train>%@</Train><Trainx>%@</Trainx><Anlzu>%@</Anlzu><Anlzux>%@</Anlzux><Etape>%@</Etape><Etapex>%@</Etapex><Begru>%@</Begru><Begtx>%@</Begtx><Stxt>%@</Stxt><Datefr>%@</Datefr><Timefr>%@</Timefr><Dateto>%@</Dateto><Timeto>%@</Timeto><Priok>%@</Priok><Priokx>%@</Priokx><Rctime>%@</Rctime><Rcunit>%@</Rcunit><Objnr>%@</Objnr><Refobj>%@</Refobj><Crea>%@</Crea><Prep>%@</Prep><Comp>%@</Comp><Appr>%@</Appr><Action>%@</Action></item>",[requestData objectForKey:@"OBJECTID"],[[[wcmWorkApplication objectAtIndex:i] firstObject] objectAtIndex:1],[[[wcmWorkApplication objectAtIndex:i] firstObject] objectAtIndex:2],[[[wcmWorkApplication objectAtIndex:i] firstObject] objectAtIndex:3],[[[wcmWorkApplication objectAtIndex:i] firstObject] objectAtIndex:4],[[[wcmWorkApplication objectAtIndex:i] firstObject] objectAtIndex:5],[[[wcmWorkApplication objectAtIndex:i] firstObject] objectAtIndex:6],[[[wcmWorkApplication objectAtIndex:i] firstObject] objectAtIndex:7],[[[wcmWorkApplication objectAtIndex:i] firstObject] objectAtIndex:8],[[[wcmWorkApplication objectAtIndex:i] firstObject] objectAtIndex:9],[[[wcmWorkApplication objectAtIndex:i] firstObject] objectAtIndex:10],[[[wcmWorkApplication objectAtIndex:i] firstObject] objectAtIndex:11],[[[wcmWorkApplication objectAtIndex:i] firstObject] objectAtIndex:12],[[[wcmWorkApplication objectAtIndex:i] firstObject] objectAtIndex:29],[[[wcmWorkApplication objectAtIndex:i] firstObject] objectAtIndex:30],[[[wcmWorkApplication objectAtIndex:i] firstObject] objectAtIndex:13],[[[wcmWorkApplication objectAtIndex:i] firstObject] objectAtIndex:14],[[[wcmWorkApplication objectAtIndex:i] firstObject] objectAtIndex:15],[[[wcmWorkApplication objectAtIndex:i] firstObject] objectAtIndex:16],[[[wcmWorkApplication objectAtIndex:i] firstObject] objectAtIndex:17],[[[wcmWorkApplication objectAtIndex:i] firstObject] objectAtIndex:18],[[[wcmWorkApplication objectAtIndex:i] firstObject] objectAtIndex:19],[[[wcmWorkApplication objectAtIndex:i] firstObject] objectAtIndex:20],[[[wcmWorkApplication objectAtIndex:i] firstObject] objectAtIndex:21],[[[wcmWorkApplication objectAtIndex:i] firstObject] objectAtIndex:22],[[[wcmWorkApplication objectAtIndex:i] firstObject] objectAtIndex:23],[[[wcmWorkApplication objectAtIndex:i] firstObject] objectAtIndex:24],[[[wcmWorkApplication objectAtIndex:i] firstObject] objectAtIndex:25],[[[wcmWorkApplication objectAtIndex:i] firstObject] objectAtIndex:26],[[[wcmWorkApplication objectAtIndex:i] firstObject] objectAtIndex:27],[[[wcmWorkApplication objectAtIndex:i] firstObject] objectAtIndex:28]];
                    
                    if (![[[[wcmWorkApplication objectAtIndex:i] firstObject] objectAtIndex:4] isEqualToString:@"1"] || ![[[[wcmWorkApplication objectAtIndex:i] firstObject] objectAtIndex:4] isEqualToString:@"7"]) {
                        
                        NSArray *wcmHStandardCheckPoints = [[wcmWorkApplication objectAtIndex:i] objectAtIndex:1];
                        
                        for (int j =0; j<[wcmHStandardCheckPoints count]; j++) {
                            
                            checkPointDescriptionString = [self getcodeforkeys:[[wcmHStandardCheckPoints objectAtIndex:j] objectAtIndex:6]];
                            
                            [soapMessage appendFormat:@"<item><Wapinr>%@</Wapinr><Wapityp>%@</Wapityp><ChkPointType>W</ChkPointType><Wkid>%@</Wkid><Needid></Needid><Value>%@</Value><Desctext>%@</Desctext><Tplnr></Tplnr><Equnr></Equnr></item>",[[wcmHStandardCheckPoints objectAtIndex:j] objectAtIndex:0],[[wcmHStandardCheckPoints objectAtIndex:j] objectAtIndex:1],[[wcmHStandardCheckPoints objectAtIndex:j] objectAtIndex:3],[[wcmHStandardCheckPoints objectAtIndex:j] objectAtIndex:5],checkPointDescriptionString];
                        }
                        
                        NSArray *wcmCStandardCheckPoints = [[wcmWorkApplication objectAtIndex:i] objectAtIndex:2];
                        
                        for (int j =0; j<[wcmCStandardCheckPoints count]; j++) {
                            
                            checkPointDescriptionString = [self getcodeforkeys:[[wcmCStandardCheckPoints objectAtIndex:j] objectAtIndex:6]];
                            
                            [soapMessage appendFormat:@"<item><Wapinr>%@</Wapinr><Wapityp>%@</Wapityp><ChkPointType>R</ChkPointType><Wkid></Wkid><Needid>%@</Needid><Value>%@</Value><Desctext>%@</Desctext><Tplnr></Tplnr><Equnr></Equnr></item>",[[wcmCStandardCheckPoints objectAtIndex:j] objectAtIndex:0],[[wcmCStandardCheckPoints objectAtIndex:j] objectAtIndex:1],[[wcmCStandardCheckPoints objectAtIndex:j] objectAtIndex:4],[[wcmCStandardCheckPoints objectAtIndex:j] objectAtIndex:5],checkPointDescriptionString];
                        }
                        
                    }
                }
                
                [soapMessage appendFormat:@"</ItWcmWaChkReq>"];
                
                [soapMessage appendString:@"<!--Optional:--><ItWcmWaData><!--Zero or more repetitions:-->"];
                
                if ([workApplicationString length]) {
                    
                    [soapMessage appendString:workApplicationString];
                }
                
                [soapMessage appendString:@"</ItWcmWaData>"];
                
            }
            
            if ([[requestData objectForKey:@"WCMISSUEPERMITS"] count]) {
                
                NSArray *wcmIssuePermits = [requestData objectForKey:@"WCMISSUEPERMITS"];
                
                [soapMessage appendString:@"<!--Optional:--><ItWcmWcagns><!--Zero or more repetitions:-->"];
                
                for (int i =0; i<[wcmIssuePermits count]; i++) {
                    
                    [soapMessage appendFormat:@"<item><Aufnr>%@</Aufnr><Objnr>%@</Objnr><Counter>%@</Counter><Werks>%@</Werks><Crname>%@</Crname><Objart>%@</Objart><Objtyp>%@</Objtyp><Pmsog>%@</Pmsog><Gntxt>%@</Gntxt><Geniakt>%@</Geniakt><Genvname>%@</Genvname><Hilvl>%@</Hilvl><Procflg>%@</Procflg><Direction>%@</Direction><Copyflg>%@</Copyflg><Mandflg>%@</Mandflg><Deacflg>%@</Deacflg><Status>%@</Status><Asgnflg>%@</Asgnflg><Autoflg>%@</Autoflg><Agent>%@</Agent><Valflg>%@</Valflg><Wcmuse>%@</Wcmuse><Action>%@</Action></item>",[requestData objectForKey:@"OBJECTID"],[[wcmIssuePermits objectAtIndex:i] objectAtIndex:1],[[wcmIssuePermits objectAtIndex:i] objectAtIndex:2],[[wcmIssuePermits objectAtIndex:i] objectAtIndex:3],[[wcmIssuePermits objectAtIndex:i] objectAtIndex:4],[[wcmIssuePermits objectAtIndex:i] objectAtIndex:5],[[wcmIssuePermits objectAtIndex:i] objectAtIndex:6],[[wcmIssuePermits objectAtIndex:i] objectAtIndex:7],[[wcmIssuePermits objectAtIndex:i] objectAtIndex:8],[[wcmIssuePermits objectAtIndex:i] objectAtIndex:9],[[wcmIssuePermits objectAtIndex:i] objectAtIndex:10],[[wcmIssuePermits objectAtIndex:i] objectAtIndex:11],[[wcmIssuePermits objectAtIndex:i] objectAtIndex:12],[[wcmIssuePermits objectAtIndex:i] objectAtIndex:13],[[wcmIssuePermits objectAtIndex:i] objectAtIndex:14],[[wcmIssuePermits objectAtIndex:i] objectAtIndex:15],[[wcmIssuePermits objectAtIndex:i] objectAtIndex:16],[[wcmIssuePermits objectAtIndex:i] objectAtIndex:17],[[wcmIssuePermits objectAtIndex:i] objectAtIndex:18],[[wcmIssuePermits objectAtIndex:i] objectAtIndex:19],[[wcmIssuePermits objectAtIndex:i] objectAtIndex:20],[[wcmIssuePermits objectAtIndex:i] objectAtIndex:21],[[wcmIssuePermits objectAtIndex:i] objectAtIndex:22],[[wcmIssuePermits objectAtIndex:i] objectAtIndex:23]];
                }
                
                [soapMessage appendString:@"</ItWcmWcagns>"];
            }
            
            if ([[requestData objectForKey:@"WCMOPERATIONWCD"] count]) {
                
                NSArray *wcmOperationWCD = [requestData objectForKey:@"WCMOPERATIONWCD"];
                
                NSMutableString *operationWCDTaggingConditionsString = [[NSMutableString alloc]initWithString:@""];
                
                [soapMessage appendString:@"<!--Optional:--><ItWcmWdData><!--Zero or more repetitions:-->"];
                
                for (int i =0; i<[wcmOperationWCD count]; i++) {
                    
                    NSMutableString *taggingString=[[NSMutableString alloc] initWithString:@""];
                    
                    [taggingString appendString:@"<Tagtext><!--Zero or more repetitions:-->"];
                    
                    if ([[[[wcmOperationWCD objectAtIndex:i] firstObject] objectAtIndex:31] length]) {
                        
                        NSArray *taggingTextArray = [[[[wcmOperationWCD objectAtIndex:i] firstObject] objectAtIndex:31] componentsSeparatedByString:@"\n"];
                        
                        for (int k=0; k<[taggingTextArray count]; k++) {
                            
                            [taggingString appendFormat:@"<item><Aufnr></Aufnr><Wcnr>%@</Wcnr><Objtype></Objtype><FormatCol></FormatCol><TextLine>%@</TextLine><Action>I</Action></item>",[[[wcmOperationWCD objectAtIndex:i] firstObject] objectAtIndex:2],[taggingTextArray objectAtIndex:k]];
                            
                        }
                    }
                    
                    [taggingString appendString:@"</Tagtext>"];
                    
                    
                    NSMutableString *unTaggingString=[[NSMutableString alloc] initWithString:@""];
                    
                    [unTaggingString appendString:@"<Untagtext><!--Zero or more repetitions:-->"];
                    
                    if ([[[[wcmOperationWCD objectAtIndex:i] firstObject] objectAtIndex:32] length]) {
                        
                        NSArray *taggingTextArray = [[[[wcmOperationWCD objectAtIndex:i] firstObject] objectAtIndex:32] componentsSeparatedByString:@"\n"];
                        
                        for (int j=0; j<[taggingTextArray count]; j++) {
                            
                            [unTaggingString appendFormat:@"<item><Aufnr></Aufnr><Wcnr>%@</Wcnr><Objtype></Objtype><FormatCol></FormatCol><TextLine>%@</TextLine><Action>I</Action></item>",[[[wcmOperationWCD objectAtIndex:i] firstObject] objectAtIndex:2],[taggingTextArray objectAtIndex:j]];
                            
                        }
                    }
                    
                    [unTaggingString appendString:@"</Untagtext>"];
                    
                    
                    [soapMessage appendFormat:@"<item><Aufnr>%@</Aufnr><Objart>%@</Objart><Wcnr>%@</Wcnr><Iwerk>%@</Iwerk><Objtyp>%@</Objtyp><Usage>%@</Usage><Usagex>%@</Usagex><Train>%@</Train><Trainx>%@</Trainx><Anlzu>%@</Anlzu><Anlzux>%@</Anlzux><Etape>%@</Etape><Etapex>%@</Etapex><Begru>%@</Begru><Begtx>%@</Begtx><Stxt>%@</Stxt><Datefr>%@</Datefr><Timefr>%@</Timefr><Dateto>%@</Dateto><Timeto>%@</Timeto><Priok>%@</Priok><Priokx>%@</Priokx><Rctime>%@</Rctime><Rcunit>%@</Rcunit><Objnr>%@</Objnr><Refobj>%@</Refobj><Crea>%@</Crea><Prep>%@</Prep><Comp>%@</Comp><Appr>%@</Appr>%@%@<Action>%@</Action></item>",[requestData objectForKey:@"OBJECTID"],[[[wcmOperationWCD objectAtIndex:i] firstObject] objectAtIndex:1],[[[wcmOperationWCD objectAtIndex:i] firstObject] objectAtIndex:2],[[[wcmOperationWCD objectAtIndex:i] firstObject] objectAtIndex:3],[[[wcmOperationWCD objectAtIndex:i] firstObject] objectAtIndex:4],[[[wcmOperationWCD objectAtIndex:i] firstObject] objectAtIndex:5],[[[wcmOperationWCD objectAtIndex:i] firstObject] objectAtIndex:6],[[[wcmOperationWCD objectAtIndex:i] firstObject] objectAtIndex:7],[[[wcmOperationWCD objectAtIndex:i] firstObject] objectAtIndex:8],[[[wcmOperationWCD objectAtIndex:i] firstObject] objectAtIndex:9],[[[wcmOperationWCD objectAtIndex:i] firstObject] objectAtIndex:10],[[[wcmOperationWCD objectAtIndex:i] firstObject] objectAtIndex:11],[[[wcmOperationWCD objectAtIndex:i] firstObject] objectAtIndex:12],[[[wcmOperationWCD objectAtIndex:i] firstObject] objectAtIndex:29],[[[wcmOperationWCD objectAtIndex:i] firstObject] objectAtIndex:30],[[[wcmOperationWCD objectAtIndex:i] firstObject] objectAtIndex:13],[[[wcmOperationWCD objectAtIndex:i] firstObject] objectAtIndex:14],[[[wcmOperationWCD objectAtIndex:i] firstObject] objectAtIndex:15],[[[wcmOperationWCD objectAtIndex:i] firstObject] objectAtIndex:16],[[[wcmOperationWCD objectAtIndex:i] firstObject] objectAtIndex:17],[[[wcmOperationWCD objectAtIndex:i] firstObject] objectAtIndex:18],[[[wcmOperationWCD objectAtIndex:i] firstObject] objectAtIndex:19],[[[wcmOperationWCD objectAtIndex:i] firstObject] objectAtIndex:20],[[[wcmOperationWCD objectAtIndex:i] firstObject] objectAtIndex:21],[[[wcmOperationWCD objectAtIndex:i] firstObject] objectAtIndex:22],[[[wcmOperationWCD objectAtIndex:i] firstObject] objectAtIndex:23],[[[wcmOperationWCD objectAtIndex:i] firstObject] objectAtIndex:24],[[[wcmOperationWCD objectAtIndex:i] firstObject] objectAtIndex:25],[[[wcmOperationWCD objectAtIndex:i] firstObject] objectAtIndex:26],[[[wcmOperationWCD objectAtIndex:i] firstObject] objectAtIndex:27],taggingString,unTaggingString,[[[wcmOperationWCD objectAtIndex:i] firstObject] objectAtIndex:28]];
                    
                    NSArray *wcmOperationWCDTaggingConditions = [[wcmOperationWCD objectAtIndex:i] objectAtIndex:1];
                    
                    for (int j =0; j<[wcmOperationWCDTaggingConditions count]; j++) {
                        
                        [operationWCDTaggingConditionsString appendFormat:@"<item><Wcnr>%@</Wcnr><Wcitm>%@</Wcitm><Objnr>%@</Objnr><Itmtyp>%@</Itmtyp><Seq>%@</Seq><Pred>%@</Pred><Succ>%@</Succ><Ccobj>%@</Ccobj><Cctyp>%@</Cctyp><Stxt>%@</Stxt><Tggrp>%@</Tggrp><Tgstep>%@</Tgstep><Tgproc>%@</Tgproc><Tgtyp>%@</Tgtyp><Tgseq>%@</Tgseq><Tgtxt>%@</Tgtxt><Unstep>%@</Unstep><Unproc>%@</Unproc><Untyp>%@</Untyp><Unseq>%@</Unseq><Untxt>%@</Untxt><Phblflg>%@</Phblflg><Phbltyp>%@</Phbltyp><Phblnr>%@</Phblnr><Tgflg>%@</Tgflg><Tgform>%@</Tgform><Tgnr>%@</Tgnr><Unform>%@</Unform><Unnr>%@</Unnr><Control>%@</Control><Location>%@</Location><Btg>%@</Btg><Etg>%@</Etg><Bug>%@</Bug><Eug>%@</Eug><Refobj>%@</Refobj><Action>%@</Action></item>",[[wcmOperationWCDTaggingConditions objectAtIndex:j] objectAtIndex:0],[[wcmOperationWCDTaggingConditions objectAtIndex:j] objectAtIndex:1],[[wcmOperationWCDTaggingConditions objectAtIndex:j] objectAtIndex:2],[[wcmOperationWCDTaggingConditions objectAtIndex:j] objectAtIndex:3],[[wcmOperationWCDTaggingConditions objectAtIndex:j] objectAtIndex:4],[[wcmOperationWCDTaggingConditions objectAtIndex:j] objectAtIndex:5],[[wcmOperationWCDTaggingConditions objectAtIndex:j] objectAtIndex:6],[self getcodeforkeys:[[wcmOperationWCDTaggingConditions objectAtIndex:j] objectAtIndex:7]],[[wcmOperationWCDTaggingConditions objectAtIndex:j] objectAtIndex:8],[[wcmOperationWCDTaggingConditions objectAtIndex:j] objectAtIndex:9],[[wcmOperationWCDTaggingConditions objectAtIndex:j] objectAtIndex:10],[[wcmOperationWCDTaggingConditions objectAtIndex:j] objectAtIndex:11],[[wcmOperationWCDTaggingConditions objectAtIndex:j] objectAtIndex:12],[[wcmOperationWCDTaggingConditions objectAtIndex:j] objectAtIndex:13],[[wcmOperationWCDTaggingConditions objectAtIndex:j] objectAtIndex:14],[[wcmOperationWCDTaggingConditions objectAtIndex:j] objectAtIndex:15],[[wcmOperationWCDTaggingConditions objectAtIndex:j] objectAtIndex:16],[[wcmOperationWCDTaggingConditions objectAtIndex:j] objectAtIndex:17],[[wcmOperationWCDTaggingConditions objectAtIndex:j] objectAtIndex:18],[[wcmOperationWCDTaggingConditions objectAtIndex:j] objectAtIndex:19],[[wcmOperationWCDTaggingConditions objectAtIndex:j] objectAtIndex:20],[[wcmOperationWCDTaggingConditions objectAtIndex:j] objectAtIndex:21],[[wcmOperationWCDTaggingConditions objectAtIndex:j] objectAtIndex:22],[[wcmOperationWCDTaggingConditions objectAtIndex:j] objectAtIndex:23],[[wcmOperationWCDTaggingConditions objectAtIndex:j] objectAtIndex:24],[[wcmOperationWCDTaggingConditions objectAtIndex:j] objectAtIndex:25],[[wcmOperationWCDTaggingConditions objectAtIndex:j] objectAtIndex:26],[[wcmOperationWCDTaggingConditions objectAtIndex:j] objectAtIndex:27],[[wcmOperationWCDTaggingConditions objectAtIndex:j] objectAtIndex:28],[[wcmOperationWCDTaggingConditions objectAtIndex:j] objectAtIndex:29],[[wcmOperationWCDTaggingConditions objectAtIndex:j] objectAtIndex:30],[[wcmOperationWCDTaggingConditions objectAtIndex:j] objectAtIndex:31],[[wcmOperationWCDTaggingConditions objectAtIndex:j] objectAtIndex:32],[[wcmOperationWCDTaggingConditions objectAtIndex:j] objectAtIndex:33],[[wcmOperationWCDTaggingConditions objectAtIndex:j] objectAtIndex:34],
                         [[[wcmOperationWCD objectAtIndex:i] firstObject] objectAtIndex:22]
                         ,[[wcmOperationWCDTaggingConditions objectAtIndex:j] objectAtIndex:36]];
                    }
                }
                
                [soapMessage appendString:@"</ItWcmWdData>"];
                
                [soapMessage appendString:@"<!--Optional:--><ItWcmWdItemData><!--Zero or more repetitions:-->"];
                
                if ([operationWCDTaggingConditionsString length]) {
                    
                    [soapMessage appendString:operationWCDTaggingConditionsString];
                }
                
                [soapMessage appendString:@"</ItWcmWdItemData>"];
            }
            
            if ([[requestData objectForKey:@"WCMWORKAPPROVALS"] count]) {
                
                NSArray *wcmWorkApproval = [requestData objectForKey:@"WCMWORKAPPROVALS"];
                
                [soapMessage appendString:@"<!--Optional:--><ItWcmWwData><!--Zero or more repetitions:-->"];
                
                for (int i =0; i<[wcmWorkApproval count]; i++) {
                    
                    [soapMessage appendFormat:@"<item><Aufnr>%@</Aufnr><Objart>%@</Objart><Wapnr>%@</Wapnr><Iwerk>%@</Iwerk><Usage>%@</Usage><Usagex>%@</Usagex><Train>%@</Train><Trainx>%@</Trainx><Anlzu>%@</Anlzu><Anlzux>%@</Anlzux><Etape>%@</Etape><Etapex>%@</Etapex><Begru>%@</Begru><Begtx>%@</Begtx><Stxt>%@</Stxt><Datefr>%@</Datefr><Timefr>%@</Timefr><Dateto>%@</Dateto><Timeto>%@</Timeto><Priok>%@</Priok><Priokx>%@</Priokx><Rctime>%@</Rctime><Rcunit>%@</Rcunit><Objnr>%@</Objnr><Refobj>%@</Refobj><Crea>%@</Crea><Prep>%@</Prep><Comp>%@</Comp><Appr>%@</Appr><Pappr>%@</Pappr><Action>%@</Action></item>",[requestData objectForKey:@"OBJECTID"],[[wcmWorkApproval objectAtIndex:i] objectAtIndex:1],[[wcmWorkApproval objectAtIndex:i] objectAtIndex:2],[[wcmWorkApproval objectAtIndex:i] objectAtIndex:3],[[wcmWorkApproval objectAtIndex:i] objectAtIndex:4],[[wcmWorkApproval objectAtIndex:i] objectAtIndex:5],[[wcmWorkApproval objectAtIndex:i] objectAtIndex:6],[[wcmWorkApproval objectAtIndex:i] objectAtIndex:7],[[wcmWorkApproval objectAtIndex:i] objectAtIndex:8],[[wcmWorkApproval objectAtIndex:i] objectAtIndex:9],[[wcmWorkApproval objectAtIndex:i] objectAtIndex:10],[[wcmWorkApproval objectAtIndex:i] objectAtIndex:11],[[wcmWorkApproval objectAtIndex:i] objectAtIndex:29],[[wcmWorkApproval objectAtIndex:i] objectAtIndex:30],[[wcmWorkApproval objectAtIndex:i] objectAtIndex:12],[[wcmWorkApproval objectAtIndex:i] objectAtIndex:13],[[wcmWorkApproval objectAtIndex:i] objectAtIndex:14],[[wcmWorkApproval objectAtIndex:i] objectAtIndex:15],[[wcmWorkApproval objectAtIndex:i] objectAtIndex:16],[[wcmWorkApproval objectAtIndex:i] objectAtIndex:17],[[wcmWorkApproval objectAtIndex:i] objectAtIndex:18],[[wcmWorkApproval objectAtIndex:i] objectAtIndex:19],[[wcmWorkApproval objectAtIndex:i] objectAtIndex:20],[[wcmWorkApproval objectAtIndex:i] objectAtIndex:21],[[wcmWorkApproval objectAtIndex:i] objectAtIndex:22],[[wcmWorkApproval objectAtIndex:i] objectAtIndex:23],[[wcmWorkApproval objectAtIndex:i] objectAtIndex:24],[[wcmWorkApproval objectAtIndex:i] objectAtIndex:25],[[wcmWorkApproval objectAtIndex:i] objectAtIndex:26],[[wcmWorkApproval objectAtIndex:i] objectAtIndex:27],[[wcmWorkApproval objectAtIndex:i] objectAtIndex:28]];
                    
                }
                
                [soapMessage appendString:@"</ItWcmWwData>"];
            }
            
            
            if ([[requestData objectForKey:@"SYSTEMSTATUS"] count]) {
                
                NSArray *systemStatusDetailsArray = [requestData objectForKey:@"ITEMS"];
                
                [soapMessage appendString:@"<ItOrderStatus><!--Zero or more repetitions:-->"];
                
                for (int i =0; i<[systemStatusDetailsArray count]; i++) {
                    
                    [soapMessage appendFormat:@"<item><Aufnr></Aufnr><Vornr></Vornr><Objnr></Objnr><Stsma></Stsma><Inist></Inist><Stonr></Stonr><Hsonr></Hsonr><Nsonr></Nsonr><Stat></Stat><Act></Act><Txt04></Txt04><Txt30></Txt30><Action>U</Action></item>"];
                }
                
                [soapMessage appendString:@"</ItOrderStatus>"];
            }
            
            
            [soapMessage appendFormat:@"<!--Optional:--><IvTransmitType>%@</IvTransmitType>",[requestData objectForKey:@"TRANSMITTYPE"]];
            
            [soapMessage appendString:@"<!--Optional:--><IvCommit>X</IvCommit>"];
            
            break;
            
        case ORDER_CHANGE:
            
            [soapMessage appendFormat:@"<!--Optional:--><IsDevice><Muser>%@</Muser><Deviceid>%@</Deviceid><Devicesno></Devicesno><Udid></Udid></IsDevice>",[[requestData objectForKey:@"REPORTEDBY"] uppercaseString],[[[UIDevice currentDevice] identifierForVendor] UUIDString]];
            
            //            if ([[requestData objectForKey:@"LATITUDE"] length] && [[requestData objectForKey:@"LONGITUDE"] length]) {
            //                [soapMessage appendFormat:@"<!--Optional:--><IsGeo><Latitude>%@</Latitude><Longitude>%@</Longitude><Altitude>%@</Altitude></IsGeo>",[requestData objectForKey:@"LATITUDE"],[requestData objectForKey:@"LONGITUDE"],[requestData objectForKey:@"ALTITUDE"]];
            //            }
            
            if ([[requestData objectForKey:@"ATTACHMENTS"] count]) {
                attachDocs = [NSMutableString new];
                NSArray *attachmentsArray = [requestData objectForKey:@"ATTACHMENTS"];
                for (int i =0; i<[attachmentsArray count]; i++) {
                    
                    [attachDocs appendFormat:@"<item><Zobjid>%@</Zobjid><Zdoctype>W</Zdoctype><ZdoctypeItem>WH</ZdoctypeItem><Filename>%@</Filename><Filetype>%@</Filetype><Fsize>%@</Fsize><Content>%@</Content></item>",[requestData objectForKey:@"OBJECTID"],[[attachmentsArray objectAtIndex:i] objectAtIndex:3],[[attachmentsArray objectAtIndex:i] objectAtIndex:4],[[attachmentsArray objectAtIndex:i] objectAtIndex:5],[[attachmentsArray objectAtIndex:i] objectAtIndex:7]];
                }
                
                if ([attachDocs length]) {
                    [soapMessage appendFormat:@"<!--Optional:--><ItDocs><!--Zero or more repetitions:-->%@</ItDocs>",attachDocs];
                }
            }
            
            if ([[requestData objectForKey:@"PARTS"] count]) {
                NSArray *partDetailsArray = [requestData objectForKey:@"PARTS"];
                NSString *actionID;
                orderComponents = [[NSMutableString alloc] initWithString:@""];
                feildComponents = [[NSMutableString alloc] initWithString:@""];
                
                for (int i = 0; i<[partDetailsArray count]; i++) {
                    
                    for (int x = 0; x<[[[partDetailsArray objectAtIndex:i] lastObject] count]; x++) {
                        
                        [feildComponents appendFormat:@"<item><Zdoctype>W</Zdoctype><ZdoctypeItem>%@</ZdoctypeItem><Tabname>%@</Tabname><Fieldname>%@</Fieldname><Value>%@</Value><Flabel>%@</Flabel><Datatype>%@</Datatype><Sequence>%@</Sequence><Length>%@</Length></item>",[[[[partDetailsArray objectAtIndex:i] lastObject] objectAtIndex:x] objectAtIndex:1],[[[[partDetailsArray objectAtIndex:i] lastObject] objectAtIndex:x] objectAtIndex:2],[[[[partDetailsArray objectAtIndex:i] lastObject] objectAtIndex:x] objectAtIndex:3],[[[[partDetailsArray objectAtIndex:i] lastObject] objectAtIndex:x] objectAtIndex:4],[[[[partDetailsArray objectAtIndex:i] lastObject] objectAtIndex:x] objectAtIndex:5],[[[[partDetailsArray objectAtIndex:i] lastObject] objectAtIndex:x] objectAtIndex:6],[[[[partDetailsArray objectAtIndex:i] lastObject] objectAtIndex:x] objectAtIndex:7],[[[[partDetailsArray objectAtIndex:i] lastObject] objectAtIndex:x] objectAtIndex:8]];
                    }
                    
                    customFieldsString = [NSString stringWithFormat:@"<Fields><!--Zero or more repetitions:-->%@</Fields>",feildComponents];
                    
                    if ([[[[partDetailsArray objectAtIndex:i] firstObject] objectAtIndex:15] isEqualToString:@"A"] || [[[[partDetailsArray objectAtIndex:i] firstObject] objectAtIndex:15] isEqualToString:@"I"]) {
                        actionID = @"I";
                    }
                    else if ([[[[partDetailsArray objectAtIndex:i] firstObject] objectAtIndex:15] isEqualToString:@"D"]) {
                        actionID = @"D";
                    }
                    else if ([[[[partDetailsArray objectAtIndex:i] firstObject] objectAtIndex:15] isEqualToString:@"U"]) {
                        actionID = @"U";
                    }
                    else{
                        actionID = @"";
                    }
                    
                    [orderComponents appendFormat:@"<item><Aufnr>%@</Aufnr><Vornr>%@</Vornr><Uvorn></Uvorn><Rsnum>%@</Rsnum><Rspos>%@</Rspos><Matnr>%@</Matnr><Werks>%@</Werks><Lgort>%@</Lgort><Posnr>%@</Posnr><Bdmng>%@</Bdmng><Meins></Meins><Postp>%@</Postp><Wempf></Wempf><Ablad></Ablad><MatnrText></MatnrText><WerksText></WerksText><LgortText></LgortText><PostpText></PostpText><Usr01></Usr01><Usr02></Usr02><Usr03></Usr03><Usr04></Usr04><Usr05></Usr05>%@<Action>%@</Action></item>",[requestData objectForKey:@"OBJECTID"],[[[partDetailsArray objectAtIndex:i] firstObject] objectAtIndex:1],[[[partDetailsArray objectAtIndex:i] firstObject] objectAtIndex:11],[[[partDetailsArray objectAtIndex:i] firstObject] objectAtIndex:12],[[[partDetailsArray objectAtIndex:i] firstObject] objectAtIndex:5],[[[partDetailsArray objectAtIndex:i] firstObject] objectAtIndex:13],[[[partDetailsArray objectAtIndex:i] firstObject] objectAtIndex:3],[[[partDetailsArray objectAtIndex:i] firstObject] objectAtIndex:8],[[[partDetailsArray objectAtIndex:i] firstObject] objectAtIndex:2],[[[partDetailsArray objectAtIndex:i] firstObject] objectAtIndex:9],customFieldsString,actionID];
                }
                
                if ([orderComponents length]) {
                    [soapMessage appendFormat:@"<!--Optional:--><ItOrderComponents><!--Zero or more repetitions:-->%@</ItOrderComponents>",orderComponents];
                }
            }
            
            customFieldsString = @"";
            customHeaderItemFieldsString = [[NSMutableString alloc]initWithString:@""];
            
            if ([[requestData objectForKey:@"CFH"] count]) {
                NSArray *customHeaderDetailsArray = [requestData objectForKey:@"CFH"];
                for (int i =0; i<[customHeaderDetailsArray count]; i++) {
                    [customHeaderItemFieldsString appendFormat:@"<item><Zdoctype>W</Zdoctype><ZdoctypeItem>WH</ZdoctypeItem><Tabname>%@</Tabname><Fieldname>%@</Fieldname><Value>%@</Value><Flabel>%@</Flabel><Datatype>%@</Datatype><Sequence>%@</Sequence><Length>%@</Length></item>",[[customHeaderDetailsArray objectAtIndex:i] objectAtIndex:2],[[customHeaderDetailsArray objectAtIndex:i] objectAtIndex:3],[[customHeaderDetailsArray objectAtIndex:i] objectAtIndex:4],[[customHeaderDetailsArray objectAtIndex:i] objectAtIndex:5],[[customHeaderDetailsArray objectAtIndex:i] objectAtIndex:6],[[customHeaderDetailsArray objectAtIndex:i] objectAtIndex:7],[[customHeaderDetailsArray objectAtIndex:i] objectAtIndex:8]];
                }
                
                customFieldsString = [NSString stringWithFormat:@"<Fields><!--Zero or more repetitions:-->%@</Fields>",customHeaderItemFieldsString];
            }
            
            
            
            [soapMessage appendFormat:@"<!--Optional:--><ItOrderHeader><!--Zero or more repetitions:--><item><Aufnr>%@</Aufnr><Auart>%@</Auart><Ktext>%@</Ktext><Ilart></Ilart><Ernam>%@</Ernam><Erdat>%@</Erdat><Priok>%@</Priok><Equnr>%@</Equnr><Strno>%@</Strno><TplnrInt>%@</TplnrInt><Bautl></Bautl><Gltrp>%@</Gltrp><Gstrp>%@</Gstrp><Msaus>%@</Msaus><Anlzu>%@</Anlzu><Ausvn>%@</Ausvn><Ausbs>%@</Ausbs><Qmnam>%@</Qmnam><Auswk>%@</Auswk><Docs></Docs><Permits></Permits><Altitude></Altitude><Latitude></Latitude><Longitude></Longitude><Qmnum>%@</Qmnum><ParnrVw>%@</ParnrVw><NameVw>%@</NameVw><Qcreate></Qcreate><Closed></Closed><Completed></Completed><Wcm></Wcm><Wsm></Wsm><Ingrp>%@</Ingrp><Arbpl>%@</Arbpl><Werks>%@</Werks><Bemot></Bemot><Aueru></Aueru><Auarttext></Auarttext><Qmartx></Qmartx><Qmtxt></Qmtxt><Pltxt></Pltxt><Eqktx></Eqktx><Priokx></Priokx><Ilatx></Ilatx><Plantname></Plantname><Wkctrname></Wkctrname><Ingrpname>%@</Ingrpname><Maktx></Maktx><Anlzux></Anlzux><Xstatus></Xstatus><Kokrs>%@</Kokrs><Kostl>%@</Kostl>%@</item></ItOrderHeader>",[requestData objectForKey:@"OBJECTID"],[requestData objectForKey:@"OID"],[requestData objectForKey:@"SHORTTEXT"],[requestData objectForKey:@"REPORTEDBY"],[requestData objectForKey:@"SDATE"],[requestData objectForKey:@"OPID"],[requestData objectForKey:@"EQID"],[requestData objectForKey:@"FID"],[requestData objectForKey:@"FID"],[requestData objectForKey:@"EDATE"],[requestData objectForKey:@"SDATE"],[requestData objectForKey:@"BREAKDOWN"],[requestData objectForKey:@"SYSTEMCONDITIONID"],[requestData objectForKey:@"MALFUNCTIONSTARTDATE"],[requestData objectForKey:@"MALFUNCTIONENDDATE"],[requestData objectForKey:@"NREPORTEDBY"],[requestData objectForKey:@"EFFECTID"],[requestData objectForKey:@"QMNUM"],[requestData objectForKey:@"PARNRID"],[requestData objectForKey:@"NAMEVW"],[requestData objectForKey:@"PLANNERGROUP"],[self getcodeforkeys:[requestData objectForKey:@"WORKCENTERID"]],[requestData objectForKey:@"PLANTID"],[requestData objectForKey:@"PLANNERGROUPNAME"],[requestData objectForKey:@"costcenter"],[requestData objectForKey:@"workarea"],customFieldsString];
            
            
            [soapMessage appendString:@"<!--Optional:--><ItOrderLongtext><!--Zero or more repetitions:-->"];
            
            if ([[requestData objectForKey:@"LONGTEXT"] length]) {
                
                NSArray *longTextArray = [[requestData objectForKey:@"LONGTEXT"] componentsSeparatedByString:@"\n"];
                
                for (int i=0; i<[longTextArray count]; i++) {
                    [soapMessage appendFormat:@"<item><Aufnr>%@</Aufnr><Activity></Activity><TextLine>%@</TextLine></item>",[requestData objectForKey:@"OBJECTID"],[longTextArray objectAtIndex:i]];
                }
            }
            
            if ([[requestData objectForKey:@"ITEMS"] count]) {
                NSArray *operationLongTextArray = [requestData objectForKey:@"ITEMS"];
                
                //                int Vornr = 0;
                //                NSString *vornrID;
                for (int i =0; i< [operationLongTextArray count]; i++) {
                    //                    Vornr = Vornr+10;
                    //                    vornrID =[NSString stringWithFormat:@"%04i",Vornr];
                    NSArray *operationLongTextOperationArray = [[[[operationLongTextArray objectAtIndex:i] firstObject] objectAtIndex:20] componentsSeparatedByString:@"\n"];
                    for (int j =0; j< [operationLongTextOperationArray count]; j++) {
                        [soapMessage appendFormat:@"<item><Aufnr>%@</Aufnr><Activity>%@</Activity><TextLine>%@</TextLine></item>",[requestData objectForKey:@"OBJECTID"],[[[operationLongTextArray objectAtIndex:i] firstObject] objectAtIndex:1],[operationLongTextOperationArray objectAtIndex:j]];
                    }
                }
            }
            
            [soapMessage appendString:@"</ItOrderLongtext>"];
            
            if ([[requestData objectForKey:@"ITEMS"] count]) {
                NSArray *operationDetailsArray = [requestData objectForKey:@"ITEMS"];
                [soapMessage appendString:@"<ItOrderOperations><!--Zero or more repetitions:-->"];
                
                NSString *actionID;
                feildOperations = [[NSMutableString alloc]initWithString:@""];
                
                for (int i = 0; i<[operationDetailsArray count]; i++) {
                    
                    for (int x = 0; x<[[[operationDetailsArray objectAtIndex:i] lastObject] count]; x++) {
                        
                        [feildOperations appendFormat:@"<item><Zdoctype>W</Zdoctype><ZdoctypeItem>%@</ZdoctypeItem><Tabname>%@</Tabname><Fieldname>%@</Fieldname><Value>%@</Value><Flabel>%@</Flabel><Datatype>%@</Datatype><Sequence>%@</Sequence><Length>%@</Length></item>",[[[[operationDetailsArray objectAtIndex:i] objectAtIndex:1] objectAtIndex:x] objectAtIndex:1],[[[[operationDetailsArray objectAtIndex:i] objectAtIndex:1] objectAtIndex:x] objectAtIndex:2],[[[[operationDetailsArray objectAtIndex:i] objectAtIndex:1] objectAtIndex:x] objectAtIndex:3],[[[[operationDetailsArray objectAtIndex:i] objectAtIndex:1] objectAtIndex:x] objectAtIndex:4],[[[[operationDetailsArray objectAtIndex:i] objectAtIndex:1] objectAtIndex:x] objectAtIndex:5],[[[[operationDetailsArray objectAtIndex:i] objectAtIndex:1] objectAtIndex:x] objectAtIndex:6],[[[[operationDetailsArray objectAtIndex:i] objectAtIndex:1] objectAtIndex:x] objectAtIndex:7],[[[[operationDetailsArray objectAtIndex:i] objectAtIndex:1] objectAtIndex:x] objectAtIndex:8]];
                    }
                    
                    customFieldsString = [NSString stringWithFormat:@"<Fields><!--Zero or more repetitions:-->%@</Fields>",feildOperations];
                    
                    if ([[[[operationDetailsArray objectAtIndex:i] firstObject] objectAtIndex:9] isEqualToString:@"A"]) {
                        actionID = @"I";
                    }
                    else if ([[[[operationDetailsArray objectAtIndex:i] firstObject] objectAtIndex:9] isEqualToString:@"D"]){
                        actionID = @"D";
                    }
                    else if ([[[[operationDetailsArray objectAtIndex:i] firstObject] objectAtIndex:9] isEqualToString:@"U"] || [[[[operationDetailsArray objectAtIndex:i] firstObject] objectAtIndex:9] isEqualToString:@"I"]){
                        
                        actionID = @"U";
                    }
                    else{
                        actionID = @"";
                    }
                    
                    [soapMessage appendFormat:@"<item><Aufnr>%@</Aufnr><Vornr>%@</Vornr><Ltxa1>%@</Ltxa1><Arbpl>%@</Arbpl><Werks>%@</Werks><Steus>%@</Steus><Larnt>%@</Larnt><Dauno>%@</Dauno><Daune>%@</Daune><Fsavd></Fsavd><Ssedd></Ssedd><Pernr>%@</Pernr><Asnum></Asnum><Plnty>%@</Plnty><Plnal>%@</Plnal><Plnnr>%@</Plnnr><Rueck></Rueck><Aueru></Aueru><ArbplText>%@</ArbplText><WerksText>%@</WerksText><SteusText>%@</SteusText>%@<Action>%@</Action></item>",[requestData objectForKey:@"OBJECTID"],[[[operationDetailsArray objectAtIndex:i] firstObject] objectAtIndex:1],[[[operationDetailsArray objectAtIndex:i] firstObject] objectAtIndex:2],[self getcodeforkeys:[[[operationDetailsArray objectAtIndex:i] firstObject] objectAtIndex:28]],[[[operationDetailsArray objectAtIndex:i] firstObject] objectAtIndex:26],[[[operationDetailsArray objectAtIndex:i] firstObject] objectAtIndex:19],[[[operationDetailsArray objectAtIndex:i] firstObject] objectAtIndex:14],[[[operationDetailsArray objectAtIndex:i] firstObject] objectAtIndex:3],[[[operationDetailsArray objectAtIndex:i] firstObject] objectAtIndex:4],[[[operationDetailsArray objectAtIndex:i] firstObject] objectAtIndex:15],[[[operationDetailsArray objectAtIndex:i] firstObject] objectAtIndex:18],[[[operationDetailsArray objectAtIndex:i] firstObject] objectAtIndex:16],[[[operationDetailsArray objectAtIndex:i] firstObject] objectAtIndex:17],[self getcodeforkeys:[[[operationDetailsArray objectAtIndex:i] firstObject] objectAtIndex:29]],[[[operationDetailsArray objectAtIndex:i] firstObject] objectAtIndex:27],[[[operationDetailsArray objectAtIndex:i] firstObject] objectAtIndex:30],customFieldsString,actionID];
                }
                
                [soapMessage appendString:@"</ItOrderOperations>"];
            }
            
            if ([[requestData objectForKey:@"WCMWORKAPPlICATIONS"] count]) {
                
                NSMutableString *workApplicationString = [[NSMutableString alloc]initWithString:@""];
                
                NSArray *wcmWorkApplication = [requestData objectForKey:@"WCMWORKAPPlICATIONS"];
                
                [soapMessage appendString:@"<!--Optional:--><ItWcmWaChkReq><!--Zero or more repetitions:-->"];
                
                for (int i =0; i<[wcmWorkApplication count]; i++) {
                    
                    [workApplicationString appendFormat:@"<item><Aufnr>%@</Aufnr><Objart>%@</Objart><Wapinr>%@</Wapinr><Iwerk>%@</Iwerk><Objtyp>%@</Objtyp><Usage>%@</Usage><Usagex>%@</Usagex><Train>%@</Train><Trainx>%@</Trainx><Anlzu>%@</Anlzu><Anlzux>%@</Anlzux><Etape>%@</Etape><Etapex>%@</Etapex><Begru>%@</Begru><Begtx>%@</Begtx><Stxt>%@</Stxt><Datefr>%@</Datefr><Timefr>%@</Timefr><Dateto>%@</Dateto><Timeto>%@</Timeto><Priok>%@</Priok><Priokx>%@</Priokx><Rctime>%@</Rctime><Rcunit>%@</Rcunit><Objnr>%@</Objnr><Refobj>%@</Refobj><Crea>%@</Crea><Prep>%@</Prep><Comp>%@</Comp><Appr>%@</Appr><Action>%@</Action></item>",[requestData objectForKey:@"OBJECTID"],[[[wcmWorkApplication objectAtIndex:i] firstObject] objectAtIndex:1],[[[wcmWorkApplication objectAtIndex:i] firstObject] objectAtIndex:2],[[[wcmWorkApplication objectAtIndex:i] firstObject] objectAtIndex:3],[[[wcmWorkApplication objectAtIndex:i] firstObject] objectAtIndex:4],[[[wcmWorkApplication objectAtIndex:i] firstObject] objectAtIndex:5],[[[wcmWorkApplication objectAtIndex:i] firstObject] objectAtIndex:6],[[[wcmWorkApplication objectAtIndex:i] firstObject] objectAtIndex:7],[[[wcmWorkApplication objectAtIndex:i] firstObject] objectAtIndex:8],[[[wcmWorkApplication objectAtIndex:i] firstObject] objectAtIndex:9],[[[wcmWorkApplication objectAtIndex:i] firstObject] objectAtIndex:10],[[[wcmWorkApplication objectAtIndex:i] firstObject] objectAtIndex:11],[[[wcmWorkApplication objectAtIndex:i] firstObject] objectAtIndex:12],[[[wcmWorkApplication objectAtIndex:i] firstObject] objectAtIndex:29],[[[wcmWorkApplication objectAtIndex:i] firstObject] objectAtIndex:30],[[[wcmWorkApplication objectAtIndex:i] firstObject] objectAtIndex:13],[[[wcmWorkApplication objectAtIndex:i] firstObject] objectAtIndex:14],[[[wcmWorkApplication objectAtIndex:i] firstObject] objectAtIndex:15],[[[wcmWorkApplication objectAtIndex:i] firstObject] objectAtIndex:16],[[[wcmWorkApplication objectAtIndex:i] firstObject] objectAtIndex:17],[[[wcmWorkApplication objectAtIndex:i] firstObject] objectAtIndex:18],[[[wcmWorkApplication objectAtIndex:i] firstObject] objectAtIndex:19],[[[wcmWorkApplication objectAtIndex:i] firstObject] objectAtIndex:20],[[[wcmWorkApplication objectAtIndex:i] firstObject] objectAtIndex:21],[[[wcmWorkApplication objectAtIndex:i] firstObject] objectAtIndex:22],[[[wcmWorkApplication objectAtIndex:i] firstObject] objectAtIndex:23],[[[wcmWorkApplication objectAtIndex:i] firstObject] objectAtIndex:24],[[[wcmWorkApplication objectAtIndex:i] firstObject] objectAtIndex:25],[[[wcmWorkApplication objectAtIndex:i] firstObject] objectAtIndex:26],[[[wcmWorkApplication objectAtIndex:i] firstObject] objectAtIndex:27],[[[wcmWorkApplication objectAtIndex:i] firstObject] objectAtIndex:28]];
                    
                    if (![[[[wcmWorkApplication objectAtIndex:i] firstObject] objectAtIndex:4] isEqualToString:@"1"] || ![[[[wcmWorkApplication objectAtIndex:i] firstObject] objectAtIndex:4] isEqualToString:@"7"]) {
                        
                        NSArray *wcmHStandardCheckPoints = [[wcmWorkApplication objectAtIndex:i] objectAtIndex:1];
                        
                        for (int j =0; j<[wcmHStandardCheckPoints count]; j++) {
                            
                            //                            [soapMessage appendFormat:@"<item><Wapinr>%@</Wapinr><Wapityp>%@</Wapityp><Needid>%@</Needid><Value>%@</Value><ChkPointType>%@</ChkPointType><Desctext>%@</Desctext><Tplnr>%@</Tplnr><Equnr>%@</Equnr></item>",[[wcmHStandardCheckPoints objectAtIndex:j] objectAtIndex:0],[[wcmHStandardCheckPoints objectAtIndex:j] objectAtIndex:1],[[wcmHStandardCheckPoints objectAtIndex:j] objectAtIndex:2],[[wcmHStandardCheckPoints objectAtIndex:j] objectAtIndex:3],[[wcmHStandardCheckPoints objectAtIndex:j] objectAtIndex:4],[[wcmHStandardCheckPoints objectAtIndex:j] objectAtIndex:5],[[wcmHStandardCheckPoints objectAtIndex:j] objectAtIndex:6],[[wcmHStandardCheckPoints objectAtIndex:j] objectAtIndex:7]];
                            checkPointDescriptionString = [self getcodeforkeys:[[wcmHStandardCheckPoints objectAtIndex:j] objectAtIndex:6]];
                            
                            [soapMessage appendFormat:@"<item><Wapinr>%@</Wapinr><Wapityp>%@</Wapityp><ChkPointType>W</ChkPointType><Wkid>%@</Wkid><Needid></Needid><Value>%@</Value><Desctext>%@</Desctext><Tplnr></Tplnr><Equnr></Equnr></item>",[[wcmHStandardCheckPoints objectAtIndex:j] objectAtIndex:0],[[wcmHStandardCheckPoints objectAtIndex:j] objectAtIndex:1],[[wcmHStandardCheckPoints objectAtIndex:j] objectAtIndex:3],[[wcmHStandardCheckPoints objectAtIndex:j] objectAtIndex:5],checkPointDescriptionString];
                        }
                        
                        NSArray *wcmCStandardCheckPoints = [[wcmWorkApplication objectAtIndex:i] objectAtIndex:2];
                        
                        for (int j =0; j<[wcmCStandardCheckPoints count]; j++) {
                            
                            checkPointDescriptionString = [self getcodeforkeys:[[wcmCStandardCheckPoints objectAtIndex:j] objectAtIndex:6]];
                            //                            [soapMessage appendFormat:@"<item><Wapinr>%@</Wapinr><Wapityp>%@</Wapityp><Needid>%@</Needid><Value>%@</Value><ChkPointType>%@</ChkPointType><Desctext>%@</Desctext><Tplnr>%@</Tplnr><Equnr>%@</Equnr></item>",[[wcmCStandardCheckPoints objectAtIndex:j] objectAtIndex:0],[[wcmCStandardCheckPoints objectAtIndex:j] objectAtIndex:1],[[wcmCStandardCheckPoints objectAtIndex:j] objectAtIndex:2],[[wcmCStandardCheckPoints objectAtIndex:j] objectAtIndex:3],[[wcmCStandardCheckPoints objectAtIndex:j] objectAtIndex:4],[[wcmCStandardCheckPoints objectAtIndex:j] objectAtIndex:5],[[wcmCStandardCheckPoints objectAtIndex:j] objectAtIndex:6],[[wcmCStandardCheckPoints objectAtIndex:j] objectAtIndex:7]];
                            [soapMessage appendFormat:@"<item><Wapinr>%@</Wapinr><Wapityp>%@</Wapityp><ChkPointType>R</ChkPointType><Wkid></Wkid><Needid>%@</Needid><Value>%@</Value><Desctext>%@</Desctext><Tplnr></Tplnr><Equnr></Equnr></item>",[[wcmCStandardCheckPoints objectAtIndex:j] objectAtIndex:0],[[wcmCStandardCheckPoints objectAtIndex:j] objectAtIndex:1],[[wcmCStandardCheckPoints objectAtIndex:j] objectAtIndex:4],[[wcmCStandardCheckPoints objectAtIndex:j] objectAtIndex:5],checkPointDescriptionString];
                            
                        }
                        
                    }
                }
                
                [soapMessage appendFormat:@"</ItWcmWaChkReq>"];
                
                [soapMessage appendString:@"<!--Optional:--><ItWcmWaData><!--Zero or more repetitions:-->"];
                
                if ([workApplicationString length]) {
                    
                    [soapMessage appendString:workApplicationString];
                }
                
                [soapMessage appendString:@"</ItWcmWaData>"];
                
            }
            
            if ([[requestData objectForKey:@"WCMISSUEPERMITS"] count]) {
                
                NSArray *wcmIssuePermits = [requestData objectForKey:@"WCMISSUEPERMITS"];
                
                [soapMessage appendString:@"<!--Optional:--><ItWcmWcagns><!--Zero or more repetitions:-->"];
                
                for (int i =0; i<[wcmIssuePermits count]; i++) {
                    
                    [soapMessage appendFormat:@"<item><Aufnr>%@</Aufnr><Objnr>%@</Objnr><Counter>%@</Counter><Werks>%@</Werks><Crname>%@</Crname><Objart>%@</Objart><Objtyp>%@</Objtyp><Pmsog>%@</Pmsog><Gntxt>%@</Gntxt><Geniakt>%@</Geniakt><Genvname>%@</Genvname><Hilvl>%@</Hilvl><Procflg>%@</Procflg><Direction>%@</Direction><Copyflg>%@</Copyflg><Mandflg>%@</Mandflg><Deacflg>%@</Deacflg><Status>%@</Status><Asgnflg>%@</Asgnflg><Autoflg>%@</Autoflg><Agent>%@</Agent><Valflg>%@</Valflg><Wcmuse>%@</Wcmuse><Action>I</Action></item>",[requestData objectForKey:@"OBJECTID"],[[wcmIssuePermits objectAtIndex:i] objectAtIndex:1],[[wcmIssuePermits objectAtIndex:i] objectAtIndex:2],[[wcmIssuePermits objectAtIndex:i] objectAtIndex:3],[[wcmIssuePermits objectAtIndex:i] objectAtIndex:4],[[wcmIssuePermits objectAtIndex:i] objectAtIndex:5],[[wcmIssuePermits objectAtIndex:i] objectAtIndex:6],[[wcmIssuePermits objectAtIndex:i] objectAtIndex:7],[[wcmIssuePermits objectAtIndex:i] objectAtIndex:8],[[wcmIssuePermits objectAtIndex:i] objectAtIndex:9],[[wcmIssuePermits objectAtIndex:i] objectAtIndex:10],[[wcmIssuePermits objectAtIndex:i] objectAtIndex:11],[[wcmIssuePermits objectAtIndex:i] objectAtIndex:12],[[wcmIssuePermits objectAtIndex:i] objectAtIndex:13],[[wcmIssuePermits objectAtIndex:i] objectAtIndex:14],[[wcmIssuePermits objectAtIndex:i] objectAtIndex:15],[[wcmIssuePermits objectAtIndex:i] objectAtIndex:16],[[wcmIssuePermits objectAtIndex:i] objectAtIndex:17],[[wcmIssuePermits objectAtIndex:i] objectAtIndex:18],[[wcmIssuePermits objectAtIndex:i] objectAtIndex:19],[[wcmIssuePermits objectAtIndex:i] objectAtIndex:20],[[wcmIssuePermits objectAtIndex:i] objectAtIndex:21],[[wcmIssuePermits objectAtIndex:i] objectAtIndex:22]];
                }
                
                [soapMessage appendString:@"</ItWcmWcagns>"];
            }
            
            if ([[requestData objectForKey:@"WCMOPERATIONWCD"] count]) {
                
                NSArray *wcmOperationWCD = [requestData objectForKey:@"WCMOPERATIONWCD"];
                
                NSMutableString *operationWCDTaggingConditionsString = [[NSMutableString alloc]initWithString:@""];
                
                [soapMessage appendString:@"<!--Optional:--><ItWcmWdData><!--Zero or more repetitions:-->"];
                
                for (int i =0; i<[wcmOperationWCD count]; i++) {
                    
                    
                    NSMutableString *taggingString=[[NSMutableString alloc] initWithString:@""];
                    
                    [taggingString appendString:@"<Tagtext><!--Zero or more repetitions:-->"];
                    
                    if ([[[[wcmOperationWCD objectAtIndex:i] firstObject] objectAtIndex:31] length]) {
                        
                        NSArray *taggingTextArray = [[[[wcmOperationWCD objectAtIndex:i] firstObject] objectAtIndex:31] componentsSeparatedByString:@"\n"];
                        
                        for (int k=0; k<[taggingTextArray count]; k++) {
                            
                            [taggingString appendFormat:@"<item><Aufnr></Aufnr><Wcnr>%@</Wcnr><Objtype></Objtype><FormatCol></FormatCol><TextLine>%@</TextLine><Action>U</Action></item>",[[[wcmOperationWCD objectAtIndex:i] firstObject] objectAtIndex:2],[taggingTextArray objectAtIndex:k]];
                            
                        }
                    }
                    
                    [taggingString appendString:@"</Tagtext>"];
                    
                    
                    NSMutableString *unTaggingString=[[NSMutableString alloc] initWithString:@""];
                    
                    [unTaggingString appendString:@"<Untagtext><!--Zero or more repetitions:-->"];
                    
                    if ([[[[wcmOperationWCD objectAtIndex:i] firstObject] objectAtIndex:32] length]) {
                        
                        NSArray *taggingTextArray = [[[[wcmOperationWCD objectAtIndex:i] firstObject] objectAtIndex:32] componentsSeparatedByString:@"\n"];
                        
                        for (int j=0; j<[taggingTextArray count]; j++) {
                            
                            [unTaggingString appendFormat:@"<item><Aufnr></Aufnr><Wcnr>%@</Wcnr><Objtype></Objtype><FormatCol></FormatCol><TextLine>%@</TextLine><Action>U</Action></item>",[[[wcmOperationWCD objectAtIndex:i] firstObject] objectAtIndex:2],[taggingTextArray objectAtIndex:j]];
                            
                        }
                    }
                    
                    [unTaggingString appendString:@"</Untagtext>"];
                    
                    [soapMessage appendFormat:@"<item><Aufnr>%@</Aufnr><Objart>%@</Objart><Wcnr>%@</Wcnr><Iwerk>%@</Iwerk><Objtyp>%@</Objtyp><Usage>%@</Usage><Usagex>%@</Usagex><Train>%@</Train><Trainx>%@</Trainx><Anlzu>%@</Anlzu><Anlzux>%@</Anlzux><Etape>%@</Etape><Etapex>%@</Etapex><Begru>%@</Begru><Begtx>%@</Begtx><Stxt>%@</Stxt><Datefr>%@</Datefr><Timefr>%@</Timefr><Dateto>%@</Dateto><Timeto>%@</Timeto><Priok>%@</Priok><Priokx>%@</Priokx><Rctime>%@</Rctime><Rcunit>%@</Rcunit><Objnr>%@</Objnr><Refobj>%@</Refobj><Crea>%@</Crea><Prep>%@</Prep><Comp>%@</Comp><Appr>%@</Appr>%@%@<Action>%@</Action></item>",[requestData objectForKey:@"OBJECTID"],[[[wcmOperationWCD objectAtIndex:i] firstObject] objectAtIndex:1],[[[wcmOperationWCD objectAtIndex:i] firstObject] objectAtIndex:2],[[[wcmOperationWCD objectAtIndex:i] firstObject] objectAtIndex:3],[[[wcmOperationWCD objectAtIndex:i] firstObject] objectAtIndex:4],[[[wcmOperationWCD objectAtIndex:i] firstObject] objectAtIndex:5],[[[wcmOperationWCD objectAtIndex:i] firstObject] objectAtIndex:6],[[[wcmOperationWCD objectAtIndex:i] firstObject] objectAtIndex:7],[[[wcmOperationWCD objectAtIndex:i] firstObject] objectAtIndex:8],[[[wcmOperationWCD objectAtIndex:i] firstObject] objectAtIndex:9],[[[wcmOperationWCD objectAtIndex:i] firstObject] objectAtIndex:10],[[[wcmOperationWCD objectAtIndex:i] firstObject] objectAtIndex:11],[[[wcmOperationWCD objectAtIndex:i] firstObject] objectAtIndex:12],[[[wcmOperationWCD objectAtIndex:i] firstObject] objectAtIndex:29],[[[wcmOperationWCD objectAtIndex:i] firstObject] objectAtIndex:30],[[[wcmOperationWCD objectAtIndex:i] firstObject] objectAtIndex:13],[[[wcmOperationWCD objectAtIndex:i] firstObject] objectAtIndex:14],[[[wcmOperationWCD objectAtIndex:i] firstObject] objectAtIndex:15],[[[wcmOperationWCD objectAtIndex:i] firstObject] objectAtIndex:16],[[[wcmOperationWCD objectAtIndex:i] firstObject] objectAtIndex:17],[[[wcmOperationWCD objectAtIndex:i] firstObject] objectAtIndex:18],[[[wcmOperationWCD objectAtIndex:i] firstObject] objectAtIndex:19],[[[wcmOperationWCD objectAtIndex:i] firstObject] objectAtIndex:20],[[[wcmOperationWCD objectAtIndex:i] firstObject] objectAtIndex:21],[[[wcmOperationWCD objectAtIndex:i] firstObject] objectAtIndex:22],[[[wcmOperationWCD objectAtIndex:i] firstObject] objectAtIndex:23],[[[wcmOperationWCD objectAtIndex:i] firstObject] objectAtIndex:24],[[[wcmOperationWCD objectAtIndex:i] firstObject] objectAtIndex:25],[[[wcmOperationWCD objectAtIndex:i] firstObject] objectAtIndex:26],[[[wcmOperationWCD objectAtIndex:i] firstObject] objectAtIndex:27],taggingString,unTaggingString,[[[wcmOperationWCD objectAtIndex:i] firstObject] objectAtIndex:28]];
                    
                    NSArray *wcmOperationWCDTaggingConditions = [[wcmOperationWCD objectAtIndex:i] objectAtIndex:1];
                    
                    for (int j =0; j<[wcmOperationWCDTaggingConditions count]; j++) {
                        
                        [operationWCDTaggingConditionsString appendFormat:@"<item><Wcnr>%@</Wcnr><Wcitm>%@</Wcitm><Objnr>%@</Objnr><Itmtyp>%@</Itmtyp><Seq>%@</Seq><Pred>%@</Pred><Succ>%@</Succ><Ccobj>%@</Ccobj><Cctyp>%@</Cctyp><Stxt>%@</Stxt><Tggrp>%@</Tggrp><Tgstep>%@</Tgstep><Tgproc>%@</Tgproc><Tgtyp>%@</Tgtyp><Tgseq>%@</Tgseq><Tgtxt>%@</Tgtxt><Unstep>%@</Unstep><Unproc>%@</Unproc><Untyp>%@</Untyp><Unseq>%@</Unseq><Untxt>%@</Untxt><Phblflg>%@</Phblflg><Phbltyp>%@</Phbltyp><Phblnr>%@</Phblnr><Tgflg>%@</Tgflg><Tgform>%@</Tgform><Tgnr>%@</Tgnr><Unform>%@</Unform><Unnr>%@</Unnr><Control>%@</Control><Location>%@</Location><Btg>%@</Btg><Etg>%@</Etg><Bug>%@</Bug><Eug>%@</Eug><Refobj>%@</Refobj><Action>%@</Action></item>",[[wcmOperationWCDTaggingConditions objectAtIndex:j] objectAtIndex:0],[[wcmOperationWCDTaggingConditions objectAtIndex:j] objectAtIndex:1],[[wcmOperationWCDTaggingConditions objectAtIndex:j] objectAtIndex:2],[[wcmOperationWCDTaggingConditions objectAtIndex:j] objectAtIndex:3],[[wcmOperationWCDTaggingConditions objectAtIndex:j] objectAtIndex:4],[[wcmOperationWCDTaggingConditions objectAtIndex:j] objectAtIndex:5],[[wcmOperationWCDTaggingConditions objectAtIndex:j] objectAtIndex:6],[self getcodeforkeys:[[wcmOperationWCDTaggingConditions objectAtIndex:j] objectAtIndex:7]],[[wcmOperationWCDTaggingConditions objectAtIndex:j] objectAtIndex:8],[self getcodeforkeys:[[wcmOperationWCDTaggingConditions objectAtIndex:j] objectAtIndex:9]],[[wcmOperationWCDTaggingConditions objectAtIndex:j] objectAtIndex:10],[[wcmOperationWCDTaggingConditions objectAtIndex:j] objectAtIndex:11],[[wcmOperationWCDTaggingConditions objectAtIndex:j] objectAtIndex:12],[[wcmOperationWCDTaggingConditions objectAtIndex:j] objectAtIndex:13],[[wcmOperationWCDTaggingConditions objectAtIndex:j] objectAtIndex:14],[[wcmOperationWCDTaggingConditions objectAtIndex:j] objectAtIndex:15],[[wcmOperationWCDTaggingConditions objectAtIndex:j] objectAtIndex:16],[[wcmOperationWCDTaggingConditions objectAtIndex:j] objectAtIndex:17],[[wcmOperationWCDTaggingConditions objectAtIndex:j] objectAtIndex:18],[[wcmOperationWCDTaggingConditions objectAtIndex:j] objectAtIndex:19],[[wcmOperationWCDTaggingConditions objectAtIndex:j] objectAtIndex:20],[[wcmOperationWCDTaggingConditions objectAtIndex:j] objectAtIndex:21],[[wcmOperationWCDTaggingConditions objectAtIndex:j] objectAtIndex:22],[[wcmOperationWCDTaggingConditions objectAtIndex:j] objectAtIndex:23],[[wcmOperationWCDTaggingConditions objectAtIndex:j] objectAtIndex:24],[[wcmOperationWCDTaggingConditions objectAtIndex:j] objectAtIndex:25],[[wcmOperationWCDTaggingConditions objectAtIndex:j] objectAtIndex:26],[[wcmOperationWCDTaggingConditions objectAtIndex:j] objectAtIndex:27],[[wcmOperationWCDTaggingConditions objectAtIndex:j] objectAtIndex:28],[[wcmOperationWCDTaggingConditions objectAtIndex:j] objectAtIndex:29],[[wcmOperationWCDTaggingConditions objectAtIndex:j] objectAtIndex:30],[[wcmOperationWCDTaggingConditions objectAtIndex:j] objectAtIndex:31],[[wcmOperationWCDTaggingConditions objectAtIndex:j] objectAtIndex:32],[[wcmOperationWCDTaggingConditions objectAtIndex:j] objectAtIndex:33],[[wcmOperationWCDTaggingConditions objectAtIndex:j] objectAtIndex:34],[[wcmOperationWCDTaggingConditions objectAtIndex:j] objectAtIndex:35],[[wcmOperationWCDTaggingConditions objectAtIndex:j] objectAtIndex:36]];
                    }
                }
                
                [soapMessage appendString:@"</ItWcmWdData>"];
                
                [soapMessage appendString:@"<!--Optional:--><ItWcmWdItemData><!--Zero or more repetitions:-->"];
                
                if ([operationWCDTaggingConditionsString length]) {
                    
                    [soapMessage appendString:operationWCDTaggingConditionsString];
                }
                
                [soapMessage appendString:@"</ItWcmWdItemData>"];
            }
            
            if ([[requestData objectForKey:@"WCMWORKAPPROVALS"] count]) {
                
                NSArray *wcmWorkApproval = [requestData objectForKey:@"WCMWORKAPPROVALS"];
                
                [soapMessage appendString:@"<!--Optional:--><ItWcmWwData><!--Zero or more repetitions:-->"];
                
                for (int i =0; i<[wcmWorkApproval count]; i++) {
                    
                    [soapMessage appendFormat:@"<item><Aufnr>%@</Aufnr><Objart>%@</Objart><Wapnr>%@</Wapnr><Iwerk>%@</Iwerk><Usage>%@</Usage><Usagex>%@</Usagex><Train>%@</Train><Trainx>%@</Trainx><Anlzu>%@</Anlzu><Anlzux>%@</Anlzux><Etape>%@</Etape><Etapex>%@</Etapex><Begru>%@</Begru><Begtx>%@</Begtx><Stxt>%@</Stxt><Datefr>%@</Datefr><Timefr>%@</Timefr><Dateto>%@</Dateto><Timeto>%@</Timeto><Priok>%@</Priok><Priokx>%@</Priokx><Rctime>%@</Rctime><Rcunit>%@</Rcunit><Objnr>%@</Objnr><Refobj>%@</Refobj><Crea>%@</Crea><Prep>%@</Prep><Comp>%@</Comp><Appr>%@</Appr><Pappr>%@</Pappr><Action>%@</Action></item>",[requestData objectForKey:@"OBJECTID"],[[wcmWorkApproval objectAtIndex:i] objectAtIndex:1],[[wcmWorkApproval objectAtIndex:i] objectAtIndex:2],[[wcmWorkApproval objectAtIndex:i] objectAtIndex:3],[[wcmWorkApproval objectAtIndex:i] objectAtIndex:4],[[wcmWorkApproval objectAtIndex:i] objectAtIndex:5],[[wcmWorkApproval objectAtIndex:i] objectAtIndex:6],[[wcmWorkApproval objectAtIndex:i] objectAtIndex:7],[[wcmWorkApproval objectAtIndex:i] objectAtIndex:8],[[wcmWorkApproval objectAtIndex:i] objectAtIndex:9],[[wcmWorkApproval objectAtIndex:i] objectAtIndex:10],[[wcmWorkApproval objectAtIndex:i] objectAtIndex:11],[[wcmWorkApproval objectAtIndex:i] objectAtIndex:29],[[wcmWorkApproval objectAtIndex:i] objectAtIndex:30],[[wcmWorkApproval objectAtIndex:i] objectAtIndex:12],[[wcmWorkApproval objectAtIndex:i] objectAtIndex:13],[[wcmWorkApproval objectAtIndex:i] objectAtIndex:14],[[wcmWorkApproval objectAtIndex:i] objectAtIndex:15],[[wcmWorkApproval objectAtIndex:i] objectAtIndex:16],[[wcmWorkApproval objectAtIndex:i] objectAtIndex:17],[[wcmWorkApproval objectAtIndex:i] objectAtIndex:18],[[wcmWorkApproval objectAtIndex:i] objectAtIndex:19],[[wcmWorkApproval objectAtIndex:i] objectAtIndex:20],[[wcmWorkApproval objectAtIndex:i] objectAtIndex:21],[[wcmWorkApproval objectAtIndex:i] objectAtIndex:22],[[wcmWorkApproval objectAtIndex:i] objectAtIndex:23],[[wcmWorkApproval objectAtIndex:i] objectAtIndex:24],[[wcmWorkApproval objectAtIndex:i] objectAtIndex:25],[[wcmWorkApproval objectAtIndex:i] objectAtIndex:26],[[wcmWorkApproval objectAtIndex:i] objectAtIndex:27],[[wcmWorkApproval objectAtIndex:i] objectAtIndex:28]];
                }
                
                [soapMessage appendString:@"</ItWcmWwData>"];
            }
            
            if ([[requestData objectForKey:@"WSMTRANSACTIONS"] count]) {
                
                NSArray *wsmDetailsArray = [requestData objectForKey:@"WSMTRANSACTIONS"];
                
                [soapMessage appendString:@"<!--Optional:--><ItWsmOrdSafemeas><!--Zero or more repetitions:-->"];
                
                for (int j=0; j<[wsmDetailsArray count]; j++) {
                    
                    NSString *ObjType = @"";
                    
                    ObjType = [[[[wsmDetailsArray objectAtIndex:j] firstObject] lastObject] objectAtIndex:0];
                    
                    if ([ObjType isEqualToString:@"Document"]) {
                        
                        ObjType = @"DO";
                    }
                    
                    [soapMessage appendFormat:@"<item><EamsAufnr>%@</EamsAufnr><EamsVornr></EamsVornr><Riskid></Riskid><Respid></Respid><ObjType>%@</ObjType><ObjId>%@</ObjId><Description></Description><SafetyChar>%@</SafetyChar><PrtInd></PrtInd><ExtObjId></ExtObjId><ObjTypeTxt></ObjTypeTxt><SafetyCharTxt></SafetyCharTxt><AsgmtLevel>HD</AsgmtLevel><ImageDesc></ImageDesc><RiskSht></RiskSht><RespSht></RespSht><EamsObjectNumber></EamsObjectNumber><EamsSafetyTextNo></EamsSafetyTextNo><SecondaryKey></SecondaryKey><TextTitle></TextTitle>",[requestData objectForKey:@"OBJECTID"],ObjType,[[[[wsmDetailsArray objectAtIndex:j] firstObject] objectAtIndex:1] objectForKey:@"Doknr"],[[[[wsmDetailsArray objectAtIndex:j] firstObject] objectAtIndex:1] objectForKey:@"SafetyChar"]];
                    
                    [soapMessage appendFormat:@"<TextLines><!--Zero or more repetitions:-->"];
                    
                    [soapMessage appendFormat:@"<item><Tdformat></Tdformat><Tdline></Tdline></item>"];
                    
                    [soapMessage appendFormat:@"</TextLines>"];
                    
                    NSString *actionString = @"I";
                    
                    if ([[[[wsmDetailsArray objectAtIndex:j] firstObject] objectAtIndex:2] isEqualToString:@""] || [[[[wsmDetailsArray objectAtIndex:j] firstObject] objectAtIndex:2] isEqualToString:@"U"]) {
                        
                        actionString = @"";
                    }
                    else if ([[[[wsmDetailsArray objectAtIndex:j] firstObject] objectAtIndex:2] isEqualToString:@"D"]){
                        
                        actionString = @"D";
                    }
                    
                    [soapMessage appendFormat:@"<Action>%@</Action></item>",actionString];
                }
                
                [soapMessage appendFormat:@"</ItWsmOrdSafemeas>"];
            }
            
            if ([[requestData objectForKey:@"SYSTEMSTATUS"] count]) {
                
                NSArray *systemStatusDetailsArray = [requestData objectForKey:@"SYSTEMSTATUS"];
                
                [soapMessage appendString:@"<ItOrderStatus><!--Zero or more repetitions:-->"];
                
                for (int i =0; i<[systemStatusDetailsArray count]; i++) {
                    
                    [soapMessage appendFormat:@"<item><Aufnr>%@</Aufnr><Vornr>%@</Vornr><Objnr>%@</Objnr><Stsma>%@</Stsma><Inist>%@</Inist><Stonr>%@</Stonr><Hsonr>%@</Hsonr><Nsonr>%@</Nsonr><Stat>%@</Stat><Act>%@</Act><Txt04>%@</Txt04><Txt30>%@</Txt30><Action>U</Action></item>",[requestData objectForKey:@"OBJECTID"],[[systemStatusDetailsArray objectAtIndex:i] objectForKey:@"orders_vornr_operation"],[[systemStatusDetailsArray objectAtIndex:i] objectForKey:@"orders_objnr"],[[systemStatusDetailsArray objectAtIndex:i] objectForKey:@"orders_stsma"],[[systemStatusDetailsArray objectAtIndex:i] objectForKey:@"orders_inist"],[[systemStatusDetailsArray objectAtIndex:i] objectForKey:@"orders_stonr"],[[systemStatusDetailsArray objectAtIndex:i] objectForKey:@"orders_hsonr"],[[systemStatusDetailsArray objectAtIndex:i] objectForKey:@"orders_nsonr"],[[systemStatusDetailsArray objectAtIndex:i] objectForKey:@"orders_stat"],[[systemStatusDetailsArray objectAtIndex:i] objectForKey:@"orders_act"],[[systemStatusDetailsArray objectAtIndex:i] objectForKey:@"orders_txt04"],[[systemStatusDetailsArray objectAtIndex:i] objectForKey:@"orders_txt30"]];
                }
                
                [soapMessage appendString:@"</ItOrderStatus>"];
            }
            
            [soapMessage appendFormat:@"<!--Optional:--><IvTransmitType>%@</IvTransmitType>",[requestData objectForKey:@"TRANSMITTYPE"]];
            
            [soapMessage appendFormat:@"<!--Optional:--><IvCommit>X</IvCommit>"];
            
            break;
            
        case ORDER_WOCO:
            
            [soapMessage appendFormat:@"<!--Optional:--><IsDevice><Muser>%@</Muser><Deviceid>%@</Deviceid><Devicesno></Devicesno><Udid></Udid></IsDevice>",[[requestData objectForKey:@"REPORTEDBY"] uppercaseString],[[[UIDevice currentDevice] identifierForVendor] UUIDString]];
            
            [soapMessage appendFormat:@"<ItOrderHeader><!--Zero or more repetitions:--><item><Aufnr>%@</Aufnr><Auart></Auart><Ktext></Ktext><Ilart></Ilart><Ernam></Ernam><Erdat></Erdat><Priok></Priok><Equnr></Equnr><Strno></Strno><TplnrInt></TplnrInt><Bautl></Bautl><Gltrp></Gltrp><Gstrp></Gstrp><Msaus></Msaus><Anlzu></Anlzu><Ausvn></Ausvn><Ausbs></Ausbs><Qmnam></Qmnam><Auswk></Auswk><Docs></Docs><Permits></Permits><Altitude></Altitude><Latitude></Latitude><Longitude></Longitude><Qmnum></Qmnum><Qcreate></Qcreate><Closed></Closed><Completed></Completed><Wcm></Wcm><Wsm></Wsm><Ingrp></Ingrp><Arbpl></Arbpl><Werks></Werks><Bemot></Bemot><Aueru></Aueru><Auarttext></Auarttext><Qmartx></Qmartx><Qmtxt></Qmtxt><Pltxt></Pltxt><Eqktx></Eqktx><Priokx></Priokx><Ilatx></Ilatx><Plantname></Plantname><Wkctrname></Wkctrname><Ingrpname></Ingrpname><Maktx></Maktx><Anlzux></Anlzux><Xstatus>WOCO</Xstatus><Kokrs></Kokrs><Kostl></Kostl><Usr01></Usr01><Usr02></Usr02><Usr03></Usr03><Usr04></Usr04><Usr05></Usr05></item></ItOrderHeader>",[requestData objectForKey:@"OBJECTID"]];
            
            [soapMessage appendFormat:@"<!--Optional:--><IvCommit>X</IvCommit>"];
            
            break;
            
        case ORDER_CANCEL:
            
            [soapMessage appendFormat:@"<!--Optional:--><IsDevice><Muser>%@</Muser><Deviceid>%@</Deviceid><Devicesno></Devicesno><Udid></Udid></IsDevice>",[[requestData objectForKey:@"REPORTEDBY"] uppercaseString],[[[UIDevice currentDevice] identifierForVendor] UUIDString]];
            
            [soapMessage appendString:@"<ItCancelOrder><!--Zero or more repetitions:-->"];
            
            if ([requestData objectForKey:@"ITEMS"]) {
                NSMutableArray *objectIds = [requestData objectForKey:@"ITEMS"];
                for (int i=0; i<[objectIds count]; i++) {
                    [soapMessage appendFormat:@"<item><Aufnr>%@</Aufnr></item>",[objectIds objectAtIndex:i]];
                }
            }
            
            [soapMessage appendFormat:@"</ItCancelOrder>"];
            
            [soapMessage appendString:@"<!--Optional:--><IvCommit>X</IvCommit>"];
            
            [soapMessage appendFormat:@"<!--Optional:--><IvTransmitType>%@</IvTransmitType>",[requestData objectForKey:@"TRANSMITTYPE"]];
            
            break;
            
        case ORDER_CONFIRM:
            
            [soapMessage appendFormat:@"<!--Optional:--><IsDevice><Muser>%@</Muser><Deviceid>%@</Deviceid><Devicesno></Devicesno><Udid></Udid></IsDevice>",[[requestData objectForKey:@"REPORTEDBY"] uppercaseString],[[[UIDevice currentDevice] identifierForVendor] UUIDString]];
            
            [soapMessage appendString:@"<!--Optional:--><ItConfirmOrder><!--Zero or more repetitions:-->"];
            
            if ([requestData objectForKey:@"ITEMS"]) {
                NSMutableArray *objectIds = [requestData objectForKey:@"ITEMS"];
                for (int i=0; i<[objectIds count]; i++) {
                    if ([[[[objectIds objectAtIndex:i] firstObject] objectAtIndex:10] isEqualToString:@"New"]) {
                        
                        [soapMessage appendFormat:@"<item><Orderid>%@</Orderid><Operation>%@</Operation><ConfNo>%@</ConfNo><ConfText>%@</ConfText><ActWork>%@</ActWork><UnWork>%@</UnWork><PlanWork></PlanWork><Learr>%@</Learr><Bemot>%@</Bemot><Grund>%@</Grund><Leknw>%@</Leknw><Aueru>%@</Aueru><Ausor></Ausor><Pernr></Pernr><Loart></Loart><Status></Status><Rsnum></Rsnum><Rspos></Rspos><Posnr></Posnr><Matnr></Matnr><Bwart></Bwart><Werks></Werks><Lgort></Lgort><Erfmg></Erfmg><Erfme></Erfme></item>",[requestData objectForKey:@"OBJECTID"],[[[objectIds objectAtIndex:i] firstObject] objectAtIndex:1],[[[objectIds objectAtIndex:i] firstObject] objectAtIndex:7],[[[objectIds objectAtIndex:i] firstObject] objectAtIndex:11],[[[objectIds objectAtIndex:i] firstObject] objectAtIndex:12],[[[objectIds objectAtIndex:i] firstObject] objectAtIndex:13],[[[objectIds objectAtIndex:i] firstObject] objectAtIndex:24],[[[objectIds objectAtIndex:i] firstObject] objectAtIndex:22],[[[objectIds objectAtIndex:i] firstObject] objectAtIndex:23],[[[objectIds objectAtIndex:i] firstObject] objectAtIndex:25],[[[objectIds objectAtIndex:i] firstObject] objectAtIndex:8]];
                    }
                }
            }
            
            [soapMessage appendString:@"</ItConfirmOrder>"];
            
            if ([requestData objectForKey:@"CUSTOMFIELDS"]) {
                NSMutableArray *customFields = [requestData objectForKey:@"CUSTOMFIELDS"];
                
                for (int i =0; i<[customFields count]; i++) {
                    [feildComponents appendFormat:@"<item><Zdoctype></Zdoctype><ZdoctypeItem></ZdoctypeItem><Tabname></Tabname><Fieldname></Fieldname><Value></Value><Flabel></Flabel></item>"];
                }
                
                [soapMessage appendFormat:@"<!--Optional:--><ItOrderFields><!--Zero or more repetitions:--></ItOrderFields>"];
            }
            
            [soapMessage appendFormat:@"<!--Optional:--><IvTransmitType>%@</IvTransmitType>",[requestData objectForKey:@"TRANSMITTYPE"]];
            
            [soapMessage appendString:@"<!--Optional:--><IvCommit>X</IvCommit>"];
            
            break;
            
        case ORDER_COLLECTIVE_CONFIRMATION:
            
            [soapMessage appendFormat:@"<!--Optional:--><IsDevice><Muser>%@</Muser><Deviceid>%@</Deviceid><Devicesno></Devicesno><Udid></Udid></IsDevice>",[[requestData objectForKey:@"REPORTEDBY"] uppercaseString],[[[UIDevice currentDevice] identifierForVendor] UUIDString]];
            
            [soapMessage appendString:@"<!--Optional:--><ItConfirmOrder><!--Zero or more repetitions:-->"];
            
            if ([[requestData objectForKey:@"OSTATUS"] isEqualToString:@""])
            {
                if ([requestData objectForKey:@"ITEMS"]) {
                    NSMutableArray *objectIds = [requestData objectForKey:@"ITEMS"];
                    for (int i=0; i<[objectIds count]; i++) {
                        if ([[[objectIds objectAtIndex:i] objectAtIndex:10] isEqualToString:@"New"]) {
                            
                            [soapMessage appendFormat:@"<item><Aufnr>%@</Aufnr><Vornr>%@</Vornr><ConfNo></ConfNo><ConfText>%@</ConfText><ActWork></ActWork><UnWork></UnWork><PlanWork></PlanWork><Learr></Learr><Bemot></Bemot><Grund>%@</Grund><Leknw>%@</Leknw><Aueru>%@</Aueru><Ausor></Ausor><Pernr>%@</Pernr><Loart></Loart><Status></Status><Rsnum></Rsnum><PostgDate></PostgDate><Plant></Plant><WorkCntr></WorkCntr><ExecStartDate>%@</ExecStartDate><ExecStartTime></ExecStartTime><ExecFinDate>%@</ExecFinDate><ExecFinTime></ExecFinTime></item>",[requestData objectForKey:@"OBJECTID"],[[objectIds objectAtIndex:i] objectAtIndex:1],[[objectIds objectAtIndex:i] objectAtIndex:11],[[objectIds objectAtIndex:i] objectAtIndex:23],[[objectIds objectAtIndex:i] objectAtIndex:25],[[objectIds objectAtIndex:i] objectAtIndex:8],[requestData objectForKey:@"EMPLOYEE"],[requestData objectForKey:@"SDATE"],[requestData objectForKey:@"EDATE"]];
                        }
                    }
                }
            }
            else{
                
                [soapMessage appendFormat:@"<item><Aufnr>%@</Aufnr><Vornr></Vornr><ConfNo></ConfNo><ConfText></ConfText><ActWork></ActWork><UnWork></UnWork><PlanWork></PlanWork><Learr></Learr><Bemot></Bemot><Grund></Grund><Leknw></Leknw><Aueru></Aueru><Ausor></Ausor><Pernr></Pernr><Loart></Loart><Status>TECO</Status><Rsnum></Rsnum><PostgDate></PostgDate><Plant></Plant><WorkCntr></WorkCntr><ExecStartDate></ExecStartDate><ExecStartTime></ExecStartTime><ExecFinDate></ExecFinDate><ExecFinTime></ExecFinTime></item>",[requestData objectForKey:@"OBJECTID"]];
                
            }
            
            [soapMessage appendString:@"</ItConfirmOrder>"];
            
            
            if ([[requestData objectForKey:@"ATTACHMENTS"] count]) {
                
                attachDocs = [NSMutableString new];
                
                NSArray *attachmentsArray = [requestData objectForKey:@"ATTACHMENTS"];
                
                for (int i =0; i<[attachmentsArray count]; i++) {
                    
                    [attachDocs appendFormat:@"<item><Zobjid></Zobjid><Zdoctype>Q</Zdoctype><ZdoctypeItem>QH</ZdoctypeItem><Filename>%@</Filename><Filetype>%@</Filetype><Fsize>%@</Fsize><Content>%@</Content><DocId></DocId><DocType></DocType><Objtype>%@</Objtype></item>",[[attachmentsArray objectAtIndex:i] objectAtIndex:3],[[attachmentsArray objectAtIndex:i] objectAtIndex:4],[[attachmentsArray objectAtIndex:i] objectAtIndex:5],[[attachmentsArray objectAtIndex:i] objectAtIndex:7],[[attachmentsArray objectAtIndex:i] objectAtIndex:2]];
                }
                
                if ([attachDocs length]) {
                    [soapMessage appendFormat:@"<!--Optional:--><ItDocs><!--Zero or more repetitions:-->%@</ItDocs>",attachDocs];
                }
            }
            
            [soapMessage appendString:@"<!--Optional:--><ItImrg><!--Zero or more repetitions:-->"];
            
            if ([[requestData objectForKey:@"MDOCS"] count]) {
                
                NSMutableArray *objectIds = [requestData objectForKey:@"MDOCS"];
                
                for (int i=0; i<[objectIds count]; i++) {
                    
                    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                    [dateFormatter setDateFormat:@"MMM dd, yyyy"];
                    
                    NSDate *tempDate = [dateFormatter dateFromString:[[objectIds objectAtIndex:i]  objectAtIndex:11]];
                    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
                    NSString *convertedDateString = [dateFormatter stringFromDate:tempDate];
                    
                    if ([NullChecker isNull:convertedDateString]) {
                        convertedDateString = @"";
                    }
                    
                    [dateFormatter setDateFormat:@"hh:mm a"];
                    
                    NSDate *tempTime = [dateFormatter dateFromString:[[objectIds objectAtIndex:i]  objectAtIndex:12]];
                    [dateFormatter setDateFormat:@"hh:mm:ss"];
                    
                    NSString *convertedTimeString = [dateFormatter stringFromDate:tempTime];
                    
                    if ([NullChecker isNull:convertedTimeString]) {
                        convertedTimeString = @"";
                    }
                    
                    [soapMessage appendFormat:@"<item><Qmnum></Qmnum><Aufnr>%@</Aufnr><Vornr></Vornr><Mdocm></Mdocm><Point>%@</Point><Mpobj></Mpobj><Mpobt></Mpobt><Psort></Psort><Pttxt></Pttxt><Atinn></Atinn><Idate>%@</Idate><Itime>%@</Itime><Mdtxt></Mdtxt><Readr></Readr><Atbez></Atbez><Msehi></Msehi><Msehl></Msehl><Readc>%@</Readc><Desic></Desic><Prest></Prest><Docaf>%@</Docaf><Action>I</Action></item></ItImrg>",[requestData objectForKey:@"OBJECTID"],[[objectIds objectAtIndex:i]  objectAtIndex:5],convertedDateString,convertedTimeString,[[objectIds objectAtIndex:i]  objectAtIndex:14],[[objectIds objectAtIndex:i]  objectAtIndex:21]];
                }
            }
            else{
                
                [soapMessage appendString:@"</ItImrg>"];
            }
            
            [soapMessage appendString:@"<!--Optional:--><ItOrderFields><!--Zero or more repetitions:-->"];
            
            [soapMessage appendString:@"<item><Zdoctype></Zdoctype><ZdoctypeItem></ZdoctypeItem><Tabname></Tabname><Fieldname></Fieldname><Datatype></Datatype><Value></Value><Flabel></Flabel><Sequence></Sequence><Length></Length></item>"];
            
            
            [soapMessage appendString:@"</ItOrderFields>"];
            
            [soapMessage appendString:@"<!--Optional:--><IvCommit>X</IvCommit>"];
            
            [soapMessage appendFormat:@"<!--Optional:--><IvTransmitType></IvTransmitType>"];
            
            break;
            
            
        case GET_LIST_OF_DUE_ORDERS:
            
            [soapMessage appendFormat:@"<!--Optional:--><IsDevice><Muser>%@</Muser><Deviceid>%@</Deviceid><Devicesno></Devicesno><Udid></Udid></IsDevice>",[[requestData objectForKey:@"REPORTEDBY"] uppercaseString],[[[UIDevice currentDevice] identifierForVendor] UUIDString]];
            
            [soapMessage appendFormat:@"<!--Optional:--><IvTransmitType>%@</IvTransmitType><!--Optional:--><IvUser>%@</IvUser>",[requestData objectForKey:@"TRANSMITTYPE"],[[requestData objectForKey:@"REPORTEDBY"] uppercaseString]];
            
            break;
            
        case GET_PERMITS_DATA:
            
            //For all F4 Helps No body required
            
            break;
            
        case GET_LIST_OF_PM_BOMS:
            
            [soapMessage appendFormat:@"<!--Optional:--><IsDevice><Muser>%@</Muser><Deviceid>%@</Deviceid><Devicesno></Devicesno><Udid></Udid></IsDevice>",[[requestData objectForKey:@"REPORTEDBY"] uppercaseString],[[[UIDevice currentDevice] identifierForVendor] UUIDString]];
            
            [soapMessage appendFormat:@"<!--Optional:--><IVEqDesc>%@</IVEqDesc><!--Optional:--><IvEqNo>%@</IvEqNo><!--Optional:--><IvTransmitType>%@</IvTransmitType><!--Optional:--><IvUser>%@</IvUser>",[requestData objectForKey:@"EQUIPDESCRIP"],[requestData objectForKey:@"EQUIPNO"],[requestData objectForKey:@"TRANSMITTYPE"],[[requestData objectForKey:@"REPORTEDBY"] uppercaseString]];
            
            break;
            
        case UTILITY_RESERVE:
            
            [soapMessage appendFormat:@"<!--Optional:--><IsDevice><Muser>%@</Muser><Deviceid>%@</Deviceid><Devicesno></Devicesno><Udid></Udid></IsDevice>",[[requestData objectForKey:@"REPORTEDBY"] uppercaseString],[[[UIDevice currentDevice] identifierForVendor] UUIDString]];
            
            feildActvs = [NSMutableString new];
            feildComponents = [NSMutableString new];
            [feildActvs setString:@""];
            [feildComponents setString:@""];
            
            //Need to write for loop for this FeildComponents
            //[feildComponents setString:@""];
            //            for (int i =0; i<[]; <#increment#>) {
            //                <#statements#>
            //            }
            //                [feildComponents appendString:[NSString stringWithFormat:@"<item><Zdoctype></Zdoctype><ZdoctypeItem></ZdoctypeItem><Tabname></Tabname><Fieldname></Fieldname><Value></Value><Flabel></Flabel></item>"]];
            //            if (feildComponents.length) {
            //                [feildActvs appendFormat:@"<Fields><!--Zero or more repetitions:-->%@</Fields>",feildComponents];
            //            }
            
            [soapMessage appendFormat:@"<IsReservHeader><MovementType>%@</MovementType><Plant>%@</Plant><CostCenter>%@</CostCenter><OrderNo>%@</OrderNo>%@</IsReservHeader>",[requestData objectForKey:@"MOVEMENT"],[requestData objectForKey:@"PLANT"],[requestData objectForKey:@"CCENTER"],[requestData objectForKey:@"ORDERNO"],feildActvs];
            
            [soapMessage appendString:@"<ItReservComp><!--Zero or more repetitions:-->"];
            
            if ([requestData objectForKey:@"ITEMS"]) {
                NSMutableArray *transactionDetails = [requestData objectForKey:@"ITEMS"];
                
                for (int i=0; i<[transactionDetails count]; i++) {
                    [feildActvs setString:@""];
                    [feildComponents setString:@""];
                    
                    //Need to write for loop for this FeildComponents
                    //[feildComponents setString:@""];
                    //            for (int i =0; i<[]; <#increment#>) {
                    //                <#statements#>
                    //            }
                    //                [feildComponents appendString:[NSString stringWithFormat:@"<item><Zdoctype></Zdoctype><ZdoctypeItem></ZdoctypeItem><Tabname></Tabname><Fieldname></Fieldname><Value></Value><Flabel></Flabel></item>"]];
                    //            if (feildComponents.length) {
                    //                [feildActvs appendFormat:@"<Fields><!--Zero or more repetitions:-->%@</Fields>",feildComponents];
                    //            }
                    
                    [soapMessage appendFormat:@"<item><BomComponent>%@</BomComponent><Quantity>%@</Quantity><Unit>%@</Unit><ReqmtDate>%@</ReqmtDate><StoreLoc>%@</StoreLoc>%@</item>",[[transactionDetails objectAtIndex:i] objectAtIndex:0],[[transactionDetails objectAtIndex:i] objectAtIndex:1],[[transactionDetails objectAtIndex:i] objectAtIndex:2],[[[transactionDetails objectAtIndex:i] objectAtIndex:3] substringToIndex:10],[[transactionDetails objectAtIndex:i]  lastObject],feildActvs];
                }
            }
            
            [soapMessage appendString:@"</ItReservComp>"];
            
            [soapMessage appendFormat:@"<!--Optional:--><IvTransmitType>%@</IvTransmitType>",[requestData objectForKey:@"TRANSMITTYPE"]];
            
            [soapMessage appendString:@"<!--Optional:--><IvCommit>X</IvCommit>"];
            
            break;
            
        case GET_STOCK_DATA:
            
            [soapMessage appendFormat:@"<!--Optional:--><IsDevice><Muser>%@</Muser><Deviceid>%@</Deviceid><Devicesno></Devicesno><Udid></Udid></IsDevice>",[[requestData objectForKey:@"REPORTEDBY"] uppercaseString],[[[UIDevice currentDevice] identifierForVendor] UUIDString]];
            
            [soapMessage appendFormat:@"<!--Optional:--><IvMaterial></IvMaterial>"];
            [soapMessage appendFormat:@"<!--Optional:--><IvMaterialDesc></IvMaterialDesc>"];
            [soapMessage appendFormat:@" <!--Optional:--><IvPlant></IvPlant>"];
            [soapMessage appendFormat:@"<!--Optional:--><IvStoreloc></IvStoreloc>"];
            [soapMessage appendFormat:@"<!--Optional:--><IvTransmitType>%@</IvTransmitType>",[requestData objectForKey:@"TRANSMITTYPE"]];
            [soapMessage appendFormat:@"<!--Optional:--><IvUser>%@</IvUser>",[requestData objectForKey:@"USERNAME"]];
            
            break;
            
        case GET_LOG_DATA:
            
            [soapMessage appendFormat:@"<!--Optional:--><IsDevice><Muser>%@</Muser><Deviceid>%@</Deviceid><Devicesno></Devicesno><Udid></Udid></IsDevice>",[[requestData objectForKey:@"REPORTEDBY"] uppercaseString],[[[UIDevice currentDevice] identifierForVendor] UUIDString]];
            
            [soapMessage appendFormat:@"<IvUser>%@</IvUser>",[[requestData objectForKey:@"REPORTEDBY"] uppercaseString]];
            
            break;
            
        case GET_MATERIAL_AVAILABILITY_CHECK:
            
            [soapMessage appendFormat:@"<!--Optional:--><IsDevice><Muser>%@</Muser><Deviceid>%@</Deviceid><Devicesno></Devicesno><Udid></Udid></IsDevice>",[[requestData objectForKey:@"USERNAME"] uppercaseString],[[[UIDevice currentDevice] identifierForVendor] UUIDString]];
            
            [soapMessage appendFormat:@"<!--Optional:--><ItMatnrPost><!--Zero or more repetitions:--><item><Matnr>%@</Matnr><Maktx></Maktx><Werks>%@</Werks><Arbpl></Arbpl><Lgort>%@</Lgort><Lgpla></Lgpla><Bwart></Bwart><Rdate>%@</Rdate><Erfmg>%@</Erfmg><Erfme></Erfme><Bemot></Bemot><Kostl></Kostl><CheckRule></CheckRule><Aufnr></Aufnr><Vornr></Vornr><Rsnum></Rsnum><Rspos></Rspos></item></ItMatnrPost>",[requestData objectForKey:@"MATERIAL"],[requestData objectForKey:@"PLANT"],[requestData objectForKey:@"STORAGELOCATION"],[requestData objectForKey:@"RDATE"],[requestData objectForKey:@"QUANTITY"]];
            
            break;
            
        case GET_DOCUMENTS:
            
            [soapMessage appendFormat:@"<!--Optional:--><IsDevice><Muser>%@</Muser><Deviceid>%@</Deviceid><Devicesno></Devicesno><Udid></Udid></IsDevice>",[[requestData objectForKey:@"USERNAME"] uppercaseString],[[[UIDevice currentDevice] identifierForVendor] UUIDString]];
            
            [soapMessage appendFormat:@"<!--Optional:--><IsDocument><Zobjid>%@</Zobjid><Zdoctype>%@</Zdoctype><ZdoctypeItem></ZdoctypeItem><Filename></Filename><Filetype></Filetype><Fsize></Fsize><Content></Content><DocId>%@</DocId><DocType></DocType><Objtype>%@</Objtype></IsDocument>",[requestData objectForKey:@"OBJECTID"],[requestData objectForKey:@"ZDOCTYPE"],[requestData objectForKey:@"DOCID"],[requestData objectForKey:@"OBJECTTYPE"]];
            
            break;
            
        case GET_NOTIFICATIONNO_DETAILS:
            
            [soapMessage appendFormat:@"<!--Optional:--><IsDevice><Muser>%@</Muser><Deviceid>%@</Deviceid><Devicesno></Devicesno><Udid></Udid></IsDevice>",[[requestData objectForKey:@"USERNAME"] uppercaseString],[[[UIDevice currentDevice] identifierForVendor] UUIDString]];
            
            [soapMessage appendFormat:@"<ItQmnum><!--Zero or more repetitions:--><item>%@</item></ItQmnum><!--Optional:-->",[requestData objectForKey:@"NOTIFICATION_NO"]];
            
            [soapMessage appendFormat:@"<IvTransmitType>%@</IvTransmitType>",[requestData objectForKey:@"TRANSMITTYPE"]];
            
            break;
            
        case GET_ORDERNO_DETAILS:
            
            [soapMessage appendFormat:@"<!--Optional:--><IsDevice><Muser>%@</Muser><Deviceid>%@</Deviceid><Devicesno></Devicesno><Udid></Udid></IsDevice>",[[requestData objectForKey:@"USERNAME"] uppercaseString],[[[UIDevice currentDevice] identifierForVendor] UUIDString]];
            
            [soapMessage appendFormat:@"<ItAufnr><!--Zero or more repetitions:--><item><Aufnr>%@</Aufnr></item></ItAufnr><!--Optional:-->",[requestData objectForKey:@"ORDER_NO"]];
            
            [soapMessage appendFormat:@"<IvTransmitType>%@</IvTransmitType>",[requestData objectForKey:@"TRANSMITTYPE"]];
            
            break;
            
        case CREATE_NOTIF_ORDER:
            
            [soapMessage appendFormat:@"<!--Optional:--><IsDevice><Muser>%@</Muser><Deviceid>%@</Deviceid><Devicesno></Devicesno><Udid></Udid></IsDevice>",[[requestData objectForKey:@"REPORTEDBY"] uppercaseString],[[[UIDevice currentDevice] identifierForVendor] UUIDString]];
            
            [soapMessage appendFormat:@"<!--Optional:--><IsGeo><Latitude></Latitude><Longitude></Longitude><Altitude></Altitude></IsGeo>"];
            
            if ([[requestData objectForKey:@"ATTACHMENTS"] count] || [[requestData objectForKey:@"OATTACHMENTS"] count]) {
                attachDocs = [NSMutableString new];
                NSArray *attachmentsArray = [requestData objectForKey:@"ATTACHMENTS"];
                NSArray *orderAttachmentsArray  = [requestData objectForKey:@"OATTACHMENTS"];
                for (int i =0; i<[attachmentsArray count]; i++) {
                    
                    [attachDocs appendFormat:@"<item><Zobjid></Zobjid><Zdoctype>Q</Zdoctype><ZdoctypeItem>QH</ZdoctypeItem><Filename>%@</Filename><Filetype>%@</Filetype><Fsize>%@</Fsize><Content>%@</Content><DocId></DocId><DocType></DocType><Objtype></Objtype></item>",[[attachmentsArray objectAtIndex:i] objectAtIndex:3],[[attachmentsArray objectAtIndex:i] objectAtIndex:4],[[attachmentsArray objectAtIndex:i] objectAtIndex:5],[[attachmentsArray objectAtIndex:i] objectAtIndex:7]];
                }
                
                for (int i =0; i<[orderAttachmentsArray count]; i++) {
                    
                    [attachDocs appendFormat:@"<item><Zobjid></Zobjid><Zdoctype>W</Zdoctype><ZdoctypeItem>WH</ZdoctypeItem><Filename>%@</Filename><Filetype>%@</Filetype><Fsize>%@</Fsize><Content>%@</Content><DocId></DocId><DocType></DocType><Objtype></Objtype></item>",[[orderAttachmentsArray objectAtIndex:i] objectAtIndex:3],[[orderAttachmentsArray objectAtIndex:i] objectAtIndex:4],[[orderAttachmentsArray objectAtIndex:i] objectAtIndex:5],[[orderAttachmentsArray objectAtIndex:i] objectAtIndex:7]];
                }
                
                if ([attachDocs length]) {
                    [soapMessage appendFormat:@"<!--Optional:--><ItDocs><!--Zero or more repetitions:-->%@</ItDocs>",attachDocs];
                }
            }
            
            customFieldsString = @"";
            customHeaderItemFieldsString = [[NSMutableString alloc]initWithString:@""];
            
            if ([[requestData objectForKey:@"CFH"] count]) {
                NSArray *customHeaderDetailsArray = [requestData objectForKey:@"CFH"];
                for (int i =0; i<[customHeaderDetailsArray count]; i++) {
                    [customHeaderItemFieldsString appendFormat:@"<item><Zdoctype>Q</Zdoctype><ZdoctypeItem>QH</ZdoctypeItem><Tabname>%@</Tabname><Fieldname>%@</Fieldname><Value>%@</Value><Flabel>%@</Flabel><Datatype>%@</Datatype><Sequence>%@</Sequence><Length>%@</Length></item>",[[customHeaderDetailsArray objectAtIndex:i] objectAtIndex:2],[[customHeaderDetailsArray objectAtIndex:i] objectAtIndex:3],[[customHeaderDetailsArray objectAtIndex:i] objectAtIndex:4],[[customHeaderDetailsArray objectAtIndex:i] objectAtIndex:5],[[customHeaderDetailsArray objectAtIndex:i] objectAtIndex:6],[[customHeaderDetailsArray objectAtIndex:i] objectAtIndex:7],[[customHeaderDetailsArray objectAtIndex:i] objectAtIndex:8]];
                }
                
                customFieldsString = [NSString stringWithFormat:@"<Fields><!--Zero or more repetitions:-->%@</Fields>",customHeaderItemFieldsString];
            }
            
            [soapMessage appendFormat:@"<!--Optional:--><ItNotifHeader><!--Zero or more repetitions:--><item><NotifType>%@</NotifType><Qmnum></Qmnum><NotifShorttxt>%@</NotifShorttxt><FunctionLoc>%@</FunctionLoc><Equipment>%@</Equipment><ReportedBy>%@</ReportedBy><MalfuncStdate>%@</MalfuncStdate><MalfuncEddate>%@</MalfuncEddate><MalfuncSttime></MalfuncSttime><MalfuncEdtime></MalfuncEdtime><BreakdownInd>%@</BreakdownInd><Priority>%@</Priority><Ingrp></Ingrp><Arbpl></Arbpl><Werks></Werks><Strmn></Strmn><Ltrmn></Ltrmn><Aufnr></Aufnr><Docs>%@</Docs><Closed></Closed><Completed></Completed><Createdon></Createdon>%@</item></ItNotifHeader>",[requestData objectForKey:@"NID"],[requestData objectForKey:@"SHORTTEXT"],[requestData objectForKey:@"FID"],[requestData objectForKey:@"EQID"],[requestData objectForKey:@"REPORTEDBY"],[requestData objectForKey:@"SDATE"],[requestData objectForKey:@"EDATE"],[requestData objectForKey:@"BREAKDOWN"],[requestData objectForKey:@"NPID"],[requestData objectForKey:@"DOCS"],customFieldsString];
            
            if ([[requestData objectForKey:@"ITEMS"] count]) {
                NSArray *causeCodeDetailsArray = [requestData objectForKey:@"ITEMS"];
                [soapMessage appendString:@"<!--Optional:--><ItNotifItems><!--Zero or more repetitions:-->"];
                for (int i = 0; i<[causeCodeDetailsArray count]; i++) {
                    
                    customFieldsString = @"";
                    [customHeaderItemFieldsString setString:@""];
                    
                    for (int x = 0; x<[[[causeCodeDetailsArray objectAtIndex:i] objectAtIndex:1] count]; x++) {
                        
                        [customHeaderItemFieldsString appendFormat:@"<item><Zdoctype>Q</Zdoctype><ZdoctypeItem>%@</ZdoctypeItem><Tabname>%@</Tabname><Fieldname>%@</Fieldname><Value>%@</Value><Flabel>%@</Flabel><Datatype>%@</Datatype><Sequence>%@</Sequence><Length>%@</Length></item>",[[[[causeCodeDetailsArray objectAtIndex:i] objectAtIndex:1] objectAtIndex:x] objectAtIndex:1],[[[[causeCodeDetailsArray objectAtIndex:i] objectAtIndex:1] objectAtIndex:x] objectAtIndex:2],[[[[causeCodeDetailsArray objectAtIndex:i] objectAtIndex:1] objectAtIndex:x] objectAtIndex:3],[[[[causeCodeDetailsArray objectAtIndex:i] objectAtIndex:1] objectAtIndex:x] objectAtIndex:4],[[[[causeCodeDetailsArray objectAtIndex:i] objectAtIndex:1] objectAtIndex:x] objectAtIndex:5],[[[[causeCodeDetailsArray objectAtIndex:i] objectAtIndex:1] objectAtIndex:x] objectAtIndex:6],[[[[causeCodeDetailsArray objectAtIndex:i] objectAtIndex:1] objectAtIndex:x] objectAtIndex:7],[[[[causeCodeDetailsArray objectAtIndex:i] objectAtIndex:1] objectAtIndex:x] objectAtIndex:8]];
                    }
                    
                    for (int x = 0; x<[[[causeCodeDetailsArray objectAtIndex:i] lastObject] count]; x++) {
                        
                        [customHeaderItemFieldsString appendFormat:@"<item><Zdoctype>Q</Zdoctype><ZdoctypeItem>%@</ZdoctypeItem><Tabname>%@</Tabname><Fieldname>%@</Fieldname><Value>%@</Value><Flabel>%@</Flabel><Datatype>%@</Datatype><Sequence>%@</Sequence><Length>%@</Length></item>",[[[[causeCodeDetailsArray objectAtIndex:i] lastObject] objectAtIndex:x] objectAtIndex:1],[[[[causeCodeDetailsArray objectAtIndex:i] lastObject] objectAtIndex:x] objectAtIndex:2],[[[[causeCodeDetailsArray objectAtIndex:i] lastObject] objectAtIndex:x] objectAtIndex:3],[[[[causeCodeDetailsArray objectAtIndex:i] lastObject] objectAtIndex:x] objectAtIndex:4],[[[[causeCodeDetailsArray objectAtIndex:i] lastObject] objectAtIndex:x] objectAtIndex:5],[[[[causeCodeDetailsArray objectAtIndex:i] lastObject] objectAtIndex:x] objectAtIndex:6],[[[[causeCodeDetailsArray objectAtIndex:i] lastObject] objectAtIndex:x] objectAtIndex:7],[[[[causeCodeDetailsArray objectAtIndex:i] lastObject] objectAtIndex:x] objectAtIndex:8]];
                    }
                    
                    customFieldsString = [NSString stringWithFormat:@"<Fields><!--Zero or more repetitions:-->%@</Fields>",customHeaderItemFieldsString];
                    
                    [soapMessage appendFormat:@"<item><Qmnum></Qmnum><ItemdefectGrp>%@</ItemdefectGrp><ItemKey>%@</ItemKey><ItemdefectCod>%@</ItemdefectCod><ItemdefectShtxt>%@</ItemdefectShtxt><CauseKey>%@</CauseKey><CauseGrp>%@</CauseGrp><CauseCod>%@</CauseCod><CauseShtxt>%@</CauseShtxt><ItempartGrp>%@</ItempartGrp><Partgrptext></Partgrptext><ItempartCod>%@</ItempartCod><Partcodetext></Partcodetext>%@<Action>I</Action></item>",[[[causeCodeDetailsArray objectAtIndex:i] firstObject] objectAtIndex:2],[[[causeCodeDetailsArray objectAtIndex:i] firstObject] objectAtIndex:12],[[[causeCodeDetailsArray objectAtIndex:i] firstObject] objectAtIndex:4],[[[causeCodeDetailsArray objectAtIndex:i] firstObject] objectAtIndex:10],[[[causeCodeDetailsArray objectAtIndex:i] firstObject] objectAtIndex:13],[[[causeCodeDetailsArray objectAtIndex:i] firstObject] objectAtIndex:6],[[[causeCodeDetailsArray objectAtIndex:i] firstObject] objectAtIndex:8],[[[causeCodeDetailsArray objectAtIndex:i] firstObject] objectAtIndex:11],[[[causeCodeDetailsArray objectAtIndex:i] firstObject] objectAtIndex:16],[[[causeCodeDetailsArray objectAtIndex:i] firstObject] objectAtIndex:17],customFieldsString];
                }
                [soapMessage appendString:@"</ItNotifItems>"];
            }
            if ([[requestData objectForKey:@"LONGTEXT"] length]) {
                NSArray *longTextArray = [[requestData objectForKey:@"LONGTEXT"] componentsSeparatedByString:@"\n"];
                [soapMessage appendString:@"<!--Optional:--><ItNotifLongtext><!--Zero or more repetitions:-->"];
                for (int i=0; i<[longTextArray count]; i++) {
                    [soapMessage appendFormat:@"<item><Qmnum></Qmnum><TextLine>%@</TextLine></item>",[longTextArray objectAtIndex:i]];
                }
                [soapMessage appendString:@"</ItNotifLongtext>"];
            }
            
            if ([[requestData objectForKey:@"OITEMS"] count]) {
                NSArray *operationDetailsArray = [requestData objectForKey:@"OITEMS"];
                orderComponents = [[NSMutableString alloc] initWithString:@""];
                feildComponents = [[NSMutableString alloc] initWithString:@""];
                
                for (int i = 0; i<[operationDetailsArray count]; i++) {
                    if (![[[[operationDetailsArray objectAtIndex:i] firstObject] objectAtIndex:12] isEqual:@""]) {
                        //Need to write for loop for this FeildComponents
                        
                        for (int x = 0; x<[[[operationDetailsArray objectAtIndex:i] lastObject] count]; x++) {
                            
                            [feildComponents appendFormat:@"<item><Zdoctype>W</Zdoctype><ZdoctypeItem>%@</ZdoctypeItem><Tabname>%@</Tabname><Fieldname>%@</Fieldname><Value>%@</Value><Flabel>%@</Flabel><Datatype>%@</Datatype><Sequence>%@</Sequence><Length>%@</Length></item>",[[[[operationDetailsArray objectAtIndex:i] lastObject] objectAtIndex:x] objectAtIndex:1],[[[[operationDetailsArray objectAtIndex:i] lastObject] objectAtIndex:x] objectAtIndex:2],[[[[operationDetailsArray objectAtIndex:i] lastObject] objectAtIndex:x] objectAtIndex:3],[[[[operationDetailsArray objectAtIndex:i] lastObject] objectAtIndex:x] objectAtIndex:4],[[[[operationDetailsArray objectAtIndex:i] lastObject] objectAtIndex:x] objectAtIndex:5],[[[[operationDetailsArray objectAtIndex:i] lastObject] objectAtIndex:x] objectAtIndex:6],[[[[operationDetailsArray objectAtIndex:i] lastObject] objectAtIndex:x] objectAtIndex:7],[[[[operationDetailsArray objectAtIndex:i] lastObject] objectAtIndex:x] objectAtIndex:8]];
                        }
                        
                        customFieldsString = [NSString stringWithFormat:@"<Fields><!--Zero or more repetitions:-->%@</Fields>",feildComponents];
                        
                        [orderComponents appendFormat:@"<item><Aufnr></Aufnr><Vornr>%@</Vornr><Rsnum></Rsnum><Rspos></Rspos><Matnr>%@</Matnr><Werks>%@</Werks><Lgort>%@</Lgort><Posnr>%@</Posnr><Bdmng>%@</Bdmng><Meins></Meins>%@<Action>I</Action></item>",[[[operationDetailsArray objectAtIndex:i] firstObject] objectAtIndex:1],[[[operationDetailsArray objectAtIndex:i] firstObject] objectAtIndex:11],[[[operationDetailsArray objectAtIndex:i] firstObject] objectAtIndex:13],[[[operationDetailsArray objectAtIndex:i] firstObject] objectAtIndex:14],[[[operationDetailsArray objectAtIndex:i] firstObject] objectAtIndex:15],[[[operationDetailsArray objectAtIndex:i] firstObject] objectAtIndex:16],customFieldsString];
                    }
                }
                
                if (![orderComponents isEqualToString:@""]) {
                    
                    [soapMessage appendFormat:@"<!--Optional:--><ItOrderComponents><!--Zero or more repetitions:-->%@</ItOrderComponents>",orderComponents];
                }
            }
            
            customFieldsString = @"";
            customHeaderItemFieldsString = [[NSMutableString alloc]initWithString:@""];
            
            if ([[requestData objectForKey:@"OCFH"] count]) {
                NSArray *customHeaderDetailsArray = [requestData objectForKey:@"OCFH"];
                for (int i =0; i<[customHeaderDetailsArray count]; i++) {
                    [customHeaderItemFieldsString appendFormat:@"<item><Zdoctype>W</Zdoctype><ZdoctypeItem>WH</ZdoctypeItem><Tabname>%@</Tabname><Fieldname>%@</Fieldname><Value>%@</Value><Flabel>%@</Flabel><Datatype>%@</Datatype><Sequence>%@</Sequence><Length>%@</Length></item>",[[customHeaderDetailsArray objectAtIndex:i] objectAtIndex:2],[[customHeaderDetailsArray objectAtIndex:i] objectAtIndex:3],[[customHeaderDetailsArray objectAtIndex:i] objectAtIndex:4],[[customHeaderDetailsArray objectAtIndex:i] objectAtIndex:5],[[customHeaderDetailsArray objectAtIndex:i] objectAtIndex:6],[[customHeaderDetailsArray objectAtIndex:i] objectAtIndex:7],[[customHeaderDetailsArray objectAtIndex:i] objectAtIndex:8]];
                }
                
                customFieldsString = [NSString stringWithFormat:@"<Fields><!--Zero or more repetitions:-->%@</Fields>",customHeaderItemFieldsString];
            }
            
            [soapMessage appendFormat:@"<ItOrderHeader><!--Zero or more repetitions:--><item><Aufnr></Aufnr><Auart>%@</Auart><Ktext>%@</Ktext><Ernam>%@</Ernam><Erdat>%@</Erdat><Priok>%@</Priok><Equnr>%@</Equnr><Strno>%@</Strno><TplnrInt>%@</TplnrInt><Gltrp>%@</Gltrp><Gstrp>%@</Gstrp><Closed></Closed><Completed></Completed><Arbpl>%@</Arbpl><Werks>%@</Werks><Bemot>%@</Bemot>%@</item></ItOrderHeader>",[requestData objectForKey:@"OID"],[requestData objectForKey:@"OSHORTTEXT"],[requestData objectForKey:@"REPORTEDBY"],[requestData objectForKey:@"OSDATE"],[requestData objectForKey:@"OPID"],[requestData objectForKey:@"OEQID"],[requestData objectForKey:@"OFID"],[requestData objectForKey:@"OFID"],[requestData objectForKey:@"OEDATE"],[requestData objectForKey:@"OSDATE"],[requestData objectForKey:@"OWORKCENTERID"],[requestData objectForKey:@"OPLANTID"],[requestData objectForKey:@"ACCINCID"],customFieldsString];
            
            [soapMessage appendString:@"<!--Optional:--><ItOrderLongtext><!--Zero or more repetitions:-->"];
            
            if ([[requestData objectForKey:@"OLONGTEXT"] length]) {
                
                NSArray *longTextArray = [[requestData objectForKey:@"OLONGTEXT"] componentsSeparatedByString:@"\n"];
                
                for (int i=0; i<[longTextArray count]; i++) {
                    [soapMessage appendFormat:@"<item><Aufnr></Aufnr><Activity></Activity><TextLine>%@</TextLine></item>",[longTextArray objectAtIndex:i]];
                }
            }
            
            if ([[requestData objectForKey:@"OITEMS"] count]) {
                NSArray *operationLongTextArray = [requestData objectForKey:@"OITEMS"];
                
                int Vornr = 0;
                NSString *vornrID;
                for (int i =0; i< [operationLongTextArray count]; i++) {
                    Vornr = Vornr+10;
                    vornrID =[NSString stringWithFormat:@"%04i",Vornr];
                    //[[operationLongTextArray objectAtIndex:i] objectAtIndex:1]
                    NSArray *operationLongTextComponentArray = [[[[operationLongTextArray objectAtIndex:i] firstObject] objectAtIndex:31] componentsSeparatedByString:@"\n"];
                    for (int j =0; j<[operationLongTextComponentArray count]; j++) {
                        [soapMessage appendFormat:@"<item><Aufnr></Aufnr><Activity>%@</Activity><TextLine>%@</TextLine></item>",vornrID,[operationLongTextComponentArray objectAtIndex:j]];
                    }
                }
            }
            
            [soapMessage appendString:@"</ItOrderLongtext>"];
            
            if ([[requestData objectForKey:@"OITEMS"] count]) {
                NSArray *operationDetailsArray = [requestData objectForKey:@"OITEMS"];
                [soapMessage appendString:@"<ItOrderOperations><!--Zero or more repetitions:-->"];
                feildOperations = [[NSMutableString alloc]initWithString:@""];
                
                for (int i = 0; i<[operationDetailsArray count]; i++) {
                    
                    for (int x = 0; x<[[[operationDetailsArray objectAtIndex:i] objectAtIndex:1] count]; x++) {
                        
                        [feildOperations appendFormat:@"<item><Zdoctype>W</Zdoctype><ZdoctypeItem>%@</ZdoctypeItem><Tabname>%@</Tabname><Fieldname>%@</Fieldname><Value>%@</Value><Flabel>%@</Flabel><Datatype>%@</Datatype><Sequence>%@</Sequence><Length>%@</Length></item>",[[[[operationDetailsArray objectAtIndex:i] objectAtIndex:1] objectAtIndex:x] objectAtIndex:1],[[[[operationDetailsArray objectAtIndex:i] objectAtIndex:1] objectAtIndex:x] objectAtIndex:2],[[[[operationDetailsArray objectAtIndex:i] objectAtIndex:1] objectAtIndex:x] objectAtIndex:3],[[[[operationDetailsArray objectAtIndex:i] objectAtIndex:1] objectAtIndex:x] objectAtIndex:4],[[[[operationDetailsArray objectAtIndex:i] objectAtIndex:1] objectAtIndex:x] objectAtIndex:5],[[[[operationDetailsArray objectAtIndex:i] objectAtIndex:1] objectAtIndex:x] objectAtIndex:6],[[[[operationDetailsArray objectAtIndex:i] objectAtIndex:1] objectAtIndex:x] objectAtIndex:7],[[[[operationDetailsArray objectAtIndex:i] objectAtIndex:1] objectAtIndex:x] objectAtIndex:8]];
                    }
                    
                    customFieldsString = [NSString stringWithFormat:@"<Fields><!--Zero or more repetitions:-->%@</Fields>",feildOperations];
                    
                    [soapMessage appendFormat:@"<item><Aufnr></Aufnr><Vornr>%@</Vornr><Ltxa1>%@</Ltxa1><Arbpl>%@</Arbpl><Werks>%@</Werks><Steus>%@</Steus><Dauno>%@</Dauno><Daune>%@</Daune><Fsavd></Fsavd><Ssedd></Ssedd><Rueck></Rueck><Aueru></Aueru><ArbplText>%@</ArbplText><WerksText>%@</WerksText><SteusText>%@</SteusText>%@<Action>I</Action></item>",[[[operationDetailsArray objectAtIndex:i] firstObject] objectAtIndex:1],[[[operationDetailsArray objectAtIndex:i] firstObject] objectAtIndex:2],[[[operationDetailsArray objectAtIndex:i] firstObject] objectAtIndex:39],[[[operationDetailsArray objectAtIndex:i] firstObject] objectAtIndex:37],[[[operationDetailsArray objectAtIndex:i] firstObject] objectAtIndex:30],[[[operationDetailsArray objectAtIndex:i] firstObject] objectAtIndex:3],[[[operationDetailsArray objectAtIndex:i] firstObject] objectAtIndex:4],[[[operationDetailsArray objectAtIndex:i] firstObject] objectAtIndex:40],[[[operationDetailsArray objectAtIndex:i] firstObject] objectAtIndex:38],[[[operationDetailsArray objectAtIndex:i] firstObject] objectAtIndex:41],customFieldsString];
                }
                
                [soapMessage appendString:@"</ItOrderOperations>"];
            }
            
            if ([[requestData objectForKey:@"PERMITS"] count]) {
                NSArray *permitDetailsArray = [requestData objectForKey:@"PERMITS"];
                feildPermits = [[NSMutableString alloc] initWithString:@""];
                orderPermits = [[NSMutableString alloc] initWithString:@""];
                int Vornr = 0;
                NSString *vornrID;
                for (int i = 0; i<[permitDetailsArray count]; i++) {
                    //Need to write for loop for this FeildPermits
                    //   for (int i =0; i<[]; <#increment#>) {
                    //               <#statements#>
                    //    }
                    //  [feildPermits appendFormat:@"<item><Zdoctype>?</Zdoctype><ZdoctypeItem>?</ZdoctypeItem><Tabname>?</Tabname><Fieldname>?</Fieldname><Value>?</Value><Flabel>?</Flabel></item>"];
                    
                    Vornr = Vornr+10;
                    
                    vornrID =[NSString stringWithFormat:@"%04i",Vornr];
                    
                    [orderPermits appendFormat:@"<item><Vornr>%@</Vornr><Permit>%@</Permit><Release>%@</Release><Complete>%@</Complete><NotRelevant>%@</NotRelevant><IssuedBy>%@</IssuedBy><Fields><!--Zero or more repetitions:-->%@</Fields><Action>I</Action></item>",vornrID,[[permitDetailsArray objectAtIndex:i] objectAtIndex:1],[[permitDetailsArray objectAtIndex:i] objectAtIndex:3],[[permitDetailsArray objectAtIndex:i] objectAtIndex:4],[[permitDetailsArray objectAtIndex:i] objectAtIndex:5],[[permitDetailsArray objectAtIndex:i] objectAtIndex:7],feildPermits];
                }
                if (![orderPermits isEqualToString:@""]) {
                    [soapMessage appendFormat:@"<!--Optional:--><ItOrderPermits><!--Zero or more repetitions:-->%@</ItOrderPermits>",orderPermits];
                }
            }
            
            [soapMessage appendString:@"<!--Optional:--><IvCommit>X</IvCommit>"];
            
            [soapMessage appendFormat:@"<!--Optional:--><IvTransmitType>%@</IvTransmitType>",[requestData objectForKey:@"TRANSMITTYPE"]];
            
            break;
            
        case GET_SETTINGS_DATA:
            
            [soapMessage appendFormat:@"<!--Optional:--><IsDevice><Muser>%@</Muser><Deviceid>%@</Deviceid><Devicesno></Devicesno><Udid></Udid></IsDevice><!--Optional:--><IvTransmitType>%@</IvTransmitType>",[[requestData objectForKey:@"REPORTEDBY"] uppercaseString],[[[UIDevice currentDevice] identifierForVendor] UUIDString],[requestData objectForKey:@"TRANSMITTYPE"]];
            
            break;
            
        case GET_AUTH_DATA:
            
            [soapMessage appendFormat:@"<!--Optional:--><IsDevice><Muser>%@</Muser><Deviceid>%@</Deviceid><Devicesno></Devicesno><Udid></Udid></IsDevice><!--Optional:--><IvTransmitType>%@</IvTransmitType>",[[requestData objectForKey:@"REPORTEDBY"] uppercaseString],[[[UIDevice currentDevice] identifierForVendor] UUIDString],[requestData objectForKey:@"TRANSMITTYPE"]];
            
            break;
            
        case SEARCH_PLANTMAINT:
            
            [soapMessage appendFormat:@"<!--Optional:--><IsDevice><Muser>%@</Muser><Deviceid>%@</Deviceid><Devicesno></Devicesno><Udid></Udid></IsDevice>",[[requestData objectForKey:@"REPORTEDBY"] uppercaseString],[[[UIDevice currentDevice] identifierForVendor] UUIDString]];
            
            [soapMessage appendFormat:@"<!--Optional:--><IsInput><Warpl></Warpl><Iwerk></Iwerk><Arbpl></Arbpl><Gewrk></Gewrk></IsInput><!--Optional:--><IvTransmitType>%@</IvTransmitType><!--Optional:--><IvUser>%@</IvUser>",[requestData objectForKey:@"TRANSMITTYPE"],[[requestData objectForKey:@"REPORTEDBY"] uppercaseString]];
            
            
            break;
            
        case GET_WSM_MASTERDATA:
            
            [soapMessage appendFormat:@"<!--Optional:--><IvDeviceId>%@</IvDeviceId><!--Optional:--><IvTransmitType>%@</IvTransmitType><!--Optional:--><IvUser>%@</IvUser>",[[[UIDevice currentDevice] identifierForVendor] UUIDString],[requestData objectForKey:@"TRANSMITTYPE"],[[requestData objectForKey:@"REPORTEDBY"] uppercaseString]];
            
            break;
            
        case BREAKDOWN_STATISTICS:
            
            [soapMessage appendFormat:@"<!--Optional:--><IsAusvn><Sign>%@</Sign><Option>%@</Option><Low>%@</Low><High>%@</High></IsAusvn>",[requestData objectForKey:@"SIGN"],[requestData objectForKey:@"OPTION"],[requestData objectForKey:@"STARTDATE"],[requestData objectForKey:@"ENDDATE"]];
            
            [soapMessage appendFormat:@"<!--Optional:--><IsDevice><Muser>%@</Muser><Deviceid>%@</Deviceid><Devicesno></Devicesno><Udid></Udid></IsDevice>",[[requestData objectForKey:@"USERNAME"] uppercaseString],[[[UIDevice currentDevice] identifierForVendor] UUIDString]];
            
            [soapMessage appendFormat:@"<!--Optional:--><IvLyear>%@</IvLyear>",[requestData objectForKey:@"YEAR"]];
            
            [soapMessage appendFormat:@"<!--Optional:--><IvTransmitType>%@</IvTransmitType>",[requestData objectForKey:@"TRANSMITTYPE"]];
            
            break;
            
        case NOTIFICATION_ANALYSIS:
            
            [soapMessage appendFormat:@"<!--Optional:--><IsDevice><Muser>%@</Muser><Deviceid>%@</Deviceid><Devicesno></Devicesno><Udid></Udid></IsDevice>",[[requestData objectForKey:@"USERNAME"]uppercaseString],[[[UIDevice currentDevice] identifierForVendor] UUIDString]];
            
            [soapMessage appendFormat:@"<!--Optional:--><IvDays></IvDays>"];
            
            [soapMessage appendFormat:@"<!--Optional:--><IvIwerk>%@</IvIwerk>",[requestData objectForKey:@"PLANT"]];
            
            [soapMessage appendFormat:@"<!--Optional:--><IvMonth>%@</IvMonth>",[requestData objectForKey:@"MONTH"]];
            
            [soapMessage appendFormat:@"<!--Optional:--><IvTransmitType>%@</IvTransmitType>",[requestData objectForKey:@"TRANSMITTYPE"]];
            
            [soapMessage appendFormat:@"<!--Optional:--><IvYear>%@</IvYear>",[requestData objectForKey:@"YEAR"]];
            
            break;
            
        case ORDER_ANALYSIS:
            
            [soapMessage appendFormat:@"<!--Optional:--><IsDevice><Muser>%@</Muser><Deviceid>%@</Deviceid><Devicesno></Devicesno><Udid></Udid></IsDevice>",[[requestData objectForKey:@"USERNAME"]uppercaseString],[[[UIDevice currentDevice] identifierForVendor] UUIDString]];
            
            [soapMessage appendFormat:@"<!--Optional:--><IvDays></IvDays>"];
            
            [soapMessage appendFormat:@"<!--Optional:--><IvIwerk>%@</IvIwerk>",[requestData objectForKey:@"PLANT"]];
            
            [soapMessage appendFormat:@"<!--Optional:--><IvMonth>%@</IvMonth>",[requestData objectForKey:@"MONTH"]];
            
            [soapMessage appendFormat:@"<!--Optional:--><IvTransmitType>%@</IvTransmitType>",[requestData objectForKey:@"TRANSMITTYPE"]];
            
            [soapMessage appendFormat:@"<!--Optional:--><IvYear>%@</IvYear>",[requestData objectForKey:@"YEAR"]];
            
            break;
            
            
        case MAINTAINANCE_SET_CHECK_LIST:
            
            [soapMessage appendFormat:@"<!--Optional:--><IsDevice><Muser>%@</Muser><Deviceid>%@</Deviceid><Devicesno></Devicesno><Udid></Udid></IsDevice>",[[requestData objectForKey:@"USERNAME"] uppercaseString],[[[UIDevice currentDevice] identifierForVendor] UUIDString]];
            
            
            [soapMessage appendFormat:@"<!--Optional:--><IsMchklHdr>"];
            
            [soapMessage appendFormat:@"<Aufnr>%@</Aufnr><Auart></Auart><Ktext></Ktext><Equnr></Equnr><Strno></Strno><TplnrInt></TplnrInt><Bautl></Bautl><Gltrp></Gltrp><Gstrp></Gstrp><StartTime>%@</StartTime><EndTime>%@</EndTime><Noofperson></Noofperson><Qmnum></Qmnum><Closed></Closed><Completed></Completed><Ingrp></Ingrp><Arbpl></Arbpl><Werks></Werks><Auarttext></Auarttext><Qmtxt></Qmtxt><Pltxt></Pltxt><Eqktx></Eqktx><Plantname></Plantname><Wkctrname></Wkctrname><Ingrpname></Ingrpname><Xstatus></Xstatus><AgnEngName>%@</AgnEngName><VedEngName>%@</VedEngName><Usr01></Usr01><Usr02></Usr02><Usr03></Usr03>",[requestData objectForKey:@"ONO"],[requestData objectForKey:@"StartTime"],[requestData objectForKey:@"EndTime"],[requestData objectForKey:@"AgencyEName"],[requestData objectForKey:@"VEName"]];
            
            [soapMessage appendFormat:@"</IsMchklHdr>"];
            
            
            if ([[requestData objectForKey:@"CHKLIST"] count]) {
                
                NSArray *chkListDetailsArray = [requestData objectForKey:@"CHKLIST"];
                
                [soapMessage appendFormat:@"<!--Optional:--><ItMchkl><!--Zero or more repetitions:-->"];
                
                
                
                for (int i = 0; i<[chkListDetailsArray count]; i++) {
                    
                    [soapMessage appendFormat:@"<item><Mandt></Mandt><Aufnr>%@</Aufnr><Vornr>%@</Vornr><Werks>%@</Werks><Ltxa1>%@</Ltxa1><Compl>%@</Compl><Finding>%@</Finding><Actiont>%@</Actiont><Remarks>%@</Remarks><Updkz>U</Updkz><Ernam></Ernam><Erdat></Erdat><Erzeit></Erzeit><Aenam></Aenam><Aedat></Aedat><Aezeit></Aezeit></item>",[requestData objectForKey:@"ONO"],[[chkListDetailsArray objectAtIndex:i] objectAtIndex:0],[[chkListDetailsArray objectAtIndex:i] objectAtIndex:7],[[chkListDetailsArray objectAtIndex:i] objectAtIndex:1],[[chkListDetailsArray objectAtIndex:i] objectAtIndex:2],[[chkListDetailsArray objectAtIndex:i] objectAtIndex:3],[[chkListDetailsArray objectAtIndex:i] objectAtIndex:4],[[chkListDetailsArray objectAtIndex:i] objectAtIndex:5]];
                }
            }
            
            [soapMessage appendFormat:@"</ItMchkl>"];
            
            [soapMessage appendFormat:@"<!--Optional:--><IvAufnr>%@</IvAufnr>",[requestData objectForKey:@"ONO"]];
            
            [soapMessage appendFormat:@"<!--Optional:--><IvCommit>X</IvCommit>"];
            
            [soapMessage appendFormat:@"<!--Optional:--><IvTransmitType></IvTransmitType>"];
            
            break;
            
        case MAINTAINANCE_GET_CHECK_LIST:
            
            [soapMessage appendFormat:@"<!--Optional:--><IsDevice><Muser>%@</Muser><Deviceid>%@</Deviceid><Devicesno></Devicesno><Udid></Udid></IsDevice>",[[requestData objectForKey:@"USERNAME"] uppercaseString],[[[UIDevice currentDevice] identifierForVendor] UUIDString]];
            
            [soapMessage appendFormat:@"<!--Optional:--><IvAufnr>%@</IvAufnr>",[requestData objectForKey:@"ONO"]];
            
            [soapMessage appendFormat:@"<!--Optional:--><IvTransmitType></IvTransmitType>"];
            
            break;
            
        case PERMIT_REPORT:
            
            [soapMessage appendFormat:@"<!--Optional:--><IsDevice><Muser>%@</Muser><Deviceid>%@</Deviceid><Devicesno></Devicesno><Udid></Udid></IsDevice>",[[requestData objectForKey:@"USERNAME"] uppercaseString],[[[UIDevice currentDevice] identifierForVendor] UUIDString]];
            
            [soapMessage appendFormat:@"<!--Optional:--><IvArbpl>%@</IvArbpl>",[requestData objectForKey:@"WORKCENTER"]];
            
            [soapMessage appendFormat:@"<!--Optional:--><IvIwerk>%@</IvIwerk>",[requestData objectForKey:@"PLANT"]];
            
            [soapMessage appendFormat:@"<!--Optional:--><IvMonth>%@</IvMonth>",[requestData objectForKey:@"MONTH"]];
            
            [soapMessage appendFormat:@"<!--Optional:--><IvTransmitType>%@</IvTransmitType>",[requestData objectForKey:@"TRANSMITTYPE"]];
            
            [soapMessage appendFormat:@"<!--Optional:--><IvYear>%@</IvYear>",[requestData objectForKey:@"YEAR"]];
            
            break;
            
        case GET_INITIAL_ZIP:
            
            [soapMessage appendFormat:@"<!--Optional:--><IsDevice><Muser>%@</Muser><Deviceid>%@</Deviceid><Devicesno></Devicesno><Udid></Udid></IsDevice>",[[requestData objectForKey:@"USERNAME"] uppercaseString],[[[UIDevice currentDevice] identifierForVendor] UUIDString]];
            
            [soapMessage appendFormat:@"<!--Optional:--><IvPlant>%@</IvPlant>",[requestData objectForKey:@"PLANT"]];
            
            [soapMessage appendFormat:@"<!--Optional:--><IvTransmitType>%@</IvTransmitType>",[requestData objectForKey:@"TRANSMITTYPE"]];
            
            break;
            
        case AVAILABILITY_REPORT:
            
            [soapMessage appendFormat:@"<!--Optional:--><IsArbpl><Sign>%@</Sign><Option>%@</Option><Low>%@</Low><High>%@</High></IsArbpl>",[requestData objectForKey:@"WORKCENTERSIGN"],[requestData objectForKey:@"WORKCENTEROPTION"],[requestData objectForKey:@"WORKCENTERSTART"],[requestData objectForKey:@"WORKCENTEREND"]];
            
            [soapMessage appendFormat:@"<!--Optional:--><IsAusvn><Sign>%@</Sign><Option>%@</Option><Low>%@</Low><High>%@</High></IsAusvn>",[requestData objectForKey:@"SIGN"],[requestData objectForKey:@"OPTION"],[requestData objectForKey:@"MALFUNCTIONSTART"],[requestData objectForKey:@"MALFUNCTIONEND"]];
            
            [soapMessage appendFormat:@"<!--Optional:--><IsDevice><Muser>%@</Muser><Deviceid>%@</Deviceid><Devicesno></Devicesno><Udid></Udid></IsDevice>",[[requestData objectForKey:@"USERNAME"] uppercaseString],[[[UIDevice currentDevice] identifierForVendor] UUIDString]];
            
            [soapMessage appendFormat:@"<!--Optional:--><IsEqunr><Sign>%@</Sign><Option>%@</Option><Low>%@</Low><High>%@</High></IsEqunr>",[requestData objectForKey:@"EQUIPSIGN"],[requestData objectForKey:@"EQUIPOPTION"],[requestData objectForKey:@"EQUIPMENTSTART"],[requestData objectForKey:@"EQUIPMENTEND"]];
            
            [soapMessage appendFormat:@"<!--Optional:--><IsIwerk><Sign>%@</Sign><Option>%@</Option><Low>%@</Low><High>%@</High></IsIwerk>",[requestData objectForKey:@"PLANTSIGN"],[requestData objectForKey:@"PLANTOPTION"],[requestData objectForKey:@"PLANTSTART"],[requestData objectForKey:@"PLANTEND"]];
            
            [soapMessage appendFormat:@"<!--Optional:--><IsTplnr><Sign>%@</Sign><Option>%@</Option><Low>%@</Low><High>%@</High></IsTplnr>",[requestData objectForKey:@"FUNCSIGN"],[requestData objectForKey:@"FLOPTION"],[requestData objectForKey:@"FUNCTIONLOCATIONSTART"],[requestData objectForKey:@"FUNCTIONLOCATIONEND"]];
            
            
            [soapMessage appendFormat:@"<!--Optional:--><IvTransmitType>%@</IvTransmitType>",[requestData objectForKey:@"TRANSMITTYPE"]];
            
            break;
            
        case MONITOR_EQUIP_HISTORY:
            
            [soapMessage appendFormat:@"<!--Optional:--><IsDevice><Muser>%@</Muser><Deviceid>%@</Deviceid><Devicesno></Devicesno><Udid></Udid></IsDevice>",[[requestData objectForKey:@"REPORTEDBY"] uppercaseString],[[[UIDevice currentDevice] identifierForVendor] UUIDString]];
            
            [soapMessage appendFormat:@"<!--Optional:--><IsPmEhist><Mandt></Mandt><Zdoctype></Zdoctype><Alldue></Alldue><Dbcnt></Dbcnt><Duedays></Duedays><Active></Active></IsPmEhist>"];
            
            [soapMessage appendFormat:@"<!--Optional:--><IvEqunr>%@</IvEqunr>",[requestData objectForKey:@"EQUINR"]];
            
            [soapMessage appendFormat:@"<!--Optional:--><IvTransmitType>%@</IvTransmitType>",[requestData objectForKey:@"TRANSMITTYPE"]];
            
            break;
            
            
        case MONITOR_GET_EQUIP_MDOCS:
            
            [soapMessage appendFormat:@"<!--Optional:--><IsDevice><Muser>%@</Muser><Deviceid>%@</Deviceid><Devicesno></Devicesno><Udid></Udid></IsDevice>",[requestData objectForKey:@"REPORTEDBY"],[[[UIDevice currentDevice] identifierForVendor] UUIDString]];
            
            [soapMessage appendFormat:@"<!--Optional:--><IvEqunr>%@</IvEqunr>",[requestData objectForKey:@"EQUINR"]];
            
            [soapMessage appendFormat:@"<!--Optional:--><IvTransmitType>%@</IvTransmitType>",[requestData objectForKey:@"TRANSMITTYPE"]];
            
            break;
            
        case MONITOR_SET_EQUIP_MDOCS:
            
            [soapMessage appendFormat:@"<!--Optional:--><IsDevice><Muser>%@</Muser><Deviceid>%@</Deviceid><Devicesno></Devicesno><Udid></Udid></IsDevice>",[[requestData objectForKey:@"USERNAME"] uppercaseString],[[[UIDevice currentDevice] identifierForVendor] UUIDString]];
            
            [soapMessage appendString:@"<!--Optional:--><ItImrg><!--Zero or more repetitions:-->"];
            
            if ([[requestData objectForKey:@"MDOCS"] count]) {
                
                NSMutableArray *objectIds = [requestData objectForKey:@"MDOCS"];
                
                for (int i=0; i<[objectIds count]; i++) {
                    
                    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                    [dateFormatter setDateFormat:@"MMM dd, yyyy"];
                    
                    NSDate *tempDate = [dateFormatter dateFromString:[[objectIds objectAtIndex:i] objectAtIndex:4]];
                    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
                    NSString *convertedDateString = [dateFormatter stringFromDate:tempDate];
                    
                    if ([NullChecker isNull:convertedDateString]) {
                        convertedDateString = @"";
                    }
                    
                    NSArray *vlcodArray = [[[objectIds objectAtIndex:i] objectAtIndex:8] componentsSeparatedByString:@"-"];
                    
                    NSString *vlocdString;
                    
                    if ([vlcodArray count]) {
                        
                        vlocdString=[vlcodArray objectAtIndex:0];
                    }
                    
                    else{
                        vlocdString=@"";
                    }
                    
                    [soapMessage appendFormat:@"<item><Qmnum></Qmnum><Aufnr></Aufnr><Vornr></Vornr><Equnr>%@</Equnr><Mdocm></Mdocm><Point>%@</Point><Mpobj></Mpobj><Mpobt></Mpobt><Psort></Psort><Pttxt></Pttxt><Atinn></Atinn><Idate>%@</Idate><Itime>%@</Itime><Mdtxt>%@</Mdtxt><Readr></Readr><Atbez></Atbez><Msehi></Msehi><Msehl></Msehl><Readc>%@</Readc><Desic></Desic><Prest></Prest><Docaf>%@</Docaf><Codct></Codct><Codgr></Codgr><Vlcod>%@</Vlcod><Action>I</Action></item>",[[objectIds objectAtIndex:i] objectAtIndex:2],[[objectIds objectAtIndex:i] objectAtIndex:3],convertedDateString,[[objectIds objectAtIndex:i] objectAtIndex:5],[[objectIds objectAtIndex:i] objectAtIndex:6],[[objectIds objectAtIndex:i] objectAtIndex:7],vlocdString,[[objectIds objectAtIndex:i] objectAtIndex:9]];
                }
                
                [soapMessage appendString:@"</ItImrg>"];
                
            }
            else{
                
                [soapMessage appendString:@"</ItImrg>"];
                
            }
            
            [soapMessage appendString:@"<!--Optional:--><IvCommit>X</IvCommit>"];
            
            
            [soapMessage appendFormat:@"<!--Optional:--><IvTransmitType>%@</IvTransmitType>",[requestData objectForKey:@"TRANSMITTYPE"]];
            
            break;
            
        case NOTIFICATION_RELEASE:
            
            [soapMessage appendFormat:@"<!--Optional:--><IsDevice><Muser>%@</Muser><Deviceid>%@</Deviceid><Devicesno></Devicesno><Udid></Udid></IsDevice>",[[requestData objectForKey:@"REPORTEDBY"] uppercaseString],[[[UIDevice currentDevice] identifierForVendor] UUIDString]];
            
            [soapMessage appendString:@"<!--Optional:--><IvCommit>X</IvCommit>"];
            
            if ([requestData objectForKey:@"ITEMS"]) {
                NSMutableArray *objectIds = [requestData objectForKey:@"ITEMS"];
                for (int i=0; i<[objectIds count]; i++) {
                    [soapMessage appendFormat:@"<!--Optional:--><IvQmnum>%@</IvQmnum>",[objectIds objectAtIndex:i]];
                }
            }
            
            [soapMessage appendFormat:@"<!--Optional:--><IvTransmitType>%@</IvTransmitType>",[requestData objectForKey:@"TRANSMITTYPE"]];
            
            break;
            
        case ORDER_RELEASE:
            
            [soapMessage appendFormat:@"<!--Optional:--><IsDevice><Muser>%@</Muser><Deviceid>%@</Deviceid><Devicesno></Devicesno><Udid></Udid></IsDevice>",[[requestData objectForKey:@"REPORTEDBY"] uppercaseString],[[[UIDevice currentDevice] identifierForVendor] UUIDString]];
            
            
            if ([requestData objectForKey:@"ITEMS"]) {
                NSMutableArray *objectIds = [requestData objectForKey:@"ITEMS"];
                for (int i=0; i<[objectIds count]; i++) {
                    [soapMessage appendFormat:@"<!--Optional:--><IvAufnr>%@</IvAufnr>",[objectIds objectAtIndex:i]];
                }
            }
            
            [soapMessage appendString:@"<!--Optional:--><IvCommit>X</IvCommit>"];
            
            
            [soapMessage appendFormat:@"<!--Optional:--><IvTransmitType>%@</IvTransmitType>",[requestData objectForKey:@"TRANSMITTYPE"]];
            
            break;
            
        case ORDER_MDOCS:
            
            [soapMessage appendFormat:@"<!--Optional:--><IsDevice><Muser>%@</Muser><Deviceid>%@</Deviceid><Devicesno></Devicesno><Udid></Udid></IsDevice>",[[requestData objectForKey:@"REPORTEDBY"] uppercaseString],[[[UIDevice currentDevice] identifierForVendor] UUIDString]];
            
            [soapMessage appendFormat:@"<!--Optional:--><IvArbpl></IvArbpl>"];
            
            [soapMessage appendFormat:@"<!--Optional:--><IvTplnr></IvTplnr>"];
            
            [soapMessage appendFormat:@"<!--Optional:--><IvTransmitType>%@</IvTransmitType>",[requestData objectForKey:@"TRANSMITTYPE"]];
            
            [soapMessage appendFormat:@"<!--Optional:--><IvUser>%@</IvUser>",[requestData objectForKey:@"REPORTEDBY"]];
            
            [soapMessage appendFormat:@"<!--Optional:--><IvWerks></IvWerks>"];
            
            break;
            
        case EQUIPMENT_BREAKDOWN:
            
            [soapMessage appendFormat:@"<!--Optional:--><IsAusvn><Sign></Sign><Option></Option><Low></Low><High></High></IsAusvn>"];
            
            [soapMessage appendFormat:@"<!--Optional:--><IsDevice><Muser>%@</Muser><Deviceid>%@</Deviceid><Devicesno></Devicesno><Udid></Udid></IsDevice>",[[requestData objectForKey:@"USERNAME"]uppercaseString],[[[UIDevice currentDevice] identifierForVendor] UUIDString]];
            
            [soapMessage appendFormat:@"<!--Optional:--><IvEqunr>%@</IvEqunr>",[requestData objectForKey:@"EQUIP_NUMBER"]];
            
            [soapMessage appendFormat:@"<!--Optional:--><IvLyear>%@</IvLyear>",[requestData objectForKey:@"YEAR"]];
            
            [soapMessage appendFormat:@"<!--Optional:--><IvTransmitType>%@</IvTransmitType>",[requestData objectForKey:@"TRANSMITTYPE"]];
            
            
            break;
            
        case INSPECTION_MPLAN:
            
            [soapMessage appendFormat:@"<!--Optional:--><IsDevice><Muser>%@</Muser><Deviceid>%@</Deviceid><Devicesno></Devicesno><Udid></Udid></IsDevice>",[[requestData objectForKey:@"REPORTEDBY"] uppercaseString],[[[UIDevice currentDevice] identifierForVendor] UUIDString]];
            
            [soapMessage appendFormat:@"<!--Optional:--><IvEqunr>%@</IvEqunr><!--Optional:--><IvTransmitType>%@</IvTransmitType>",[requestData objectForKey:@"EQUIP_NUMBER"],[requestData objectForKey:@"TRANSMITTYPE"]];
            
            break;
            
        case DEVICE_TOKEN:
            
            [soapMessage appendFormat:@"<!--Optional:--><IsDevice><Muser>%@</Muser><Deviceid>%@</Deviceid><Devicesno></Devicesno><Udid></Udid></IsDevice><!--Optional:--><IvTransmitType></IvTransmitType>",[requestData objectForKey:@"Muser"],[[[UIDevice currentDevice] identifierForVendor] UUIDString]];
            
            [soapMessage appendFormat:@"<!--Optional:--><IvAppid>FTEKP</IvAppid>"];
            
            break;
            
        case SET_DEVICETOKENID:
            
            [soapMessage appendFormat:@"<!--Optional:--><IsDevice><Muser>%@</Muser><Deviceid>%@</Deviceid><Devicesno></Devicesno><Udid></Udid></IsDevice>",[[requestData objectForKey:@"REPORTEDBY"] uppercaseString],[[[UIDevice currentDevice] identifierForVendor] UUIDString]];
            
            [soapMessage appendFormat:@"<!--Optional:--><IvAppid>FTEKP</IvAppid>"];
            
            [soapMessage appendFormat:@"<!--Optional:--><IvDevicetype>IOS</IvDevicetype>"];
            
            [soapMessage appendFormat:@"<!--Optional:--><IvTokenid>%@</IvTokenid>",[requestData objectForKey:@"DEVICETOKEN"]];
            
            break;
            
        case GEOTAG_SYNCALL:
            
            [soapMessage appendFormat:@"<!--Optional:--><IsDevice><Muser>%@</Muser><Deviceid>%@</Deviceid><Devicesno></Devicesno><Udid></Udid></IsDevice>",[[requestData objectForKey:@"USERNAME"]uppercaseString],[[[UIDevice currentDevice] identifierForVendor] UUIDString]];
            
            [soapMessage appendString:@"<!--Optional:--><ItGeo><!--Zero or more repetitions:-->"];
            
            if ([requestData objectForKey:@"GETGEOTAGITEMS"]) {
                NSMutableArray *objectIds = [requestData objectForKey:@"GETGEOTAGITEMS"];
                for (int i=0; i<[objectIds count]; i++) {
                    [soapMessage appendFormat:@"<Tplnr>%@</Tplnr><Equnr>%@</Equnr><Latitude>%@</Latitude><Longitude>%@</Longitude><Altitude>%@</Altitude>",[[objectIds objectAtIndex:i]objectAtIndex:0],[[objectIds objectAtIndex:i]objectAtIndex:1],[[objectIds objectAtIndex:i]objectAtIndex:2],[[objectIds objectAtIndex:i]objectAtIndex:3],[[objectIds objectAtIndex:i]objectAtIndex:4]];
                    
                }
            }
            [soapMessage appendString:@"</ItGeo>"];
            [soapMessage appendFormat:@"<!--Optional:--><IvTransmitType>%@</IvTransmitType>",[requestData objectForKey:@"TRANSMITTYPE"]];
            
            break;
            
            
        default:
            break;
    }
    
    [soapMessage appendFormat:@"</%@>",action];
    
    return soapMessage;
}

@end

