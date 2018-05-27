//
//  RequestODATA.m
//  PMCockpit
//
//  Created by Shyam Chandar on 29/03/15.
//  Copyright (c) 2015 Enstrapp IT Solutions. All rights reserved.
//?$filter=Werks%20eq%20%271000%27%20and%20Lgort%20eq%20%270001%27&$format=json

#import "RequestODATA.h"

@implementation RequestODATA

#pragma mark - Instance methos

- (void)makeWebServiceRequest:(WebServiceRequest)requestId parameters:(NSDictionary *)parameters delegate:(id)delegate
{
    defaults = [NSUserDefaults standardUserDefaults];
    NSString *key = @"";
    
    NSLog(@"total key is %@",key);
    NSString *str_UserNameDep = [defaults objectForKey:@"userName"];
    decryptedUserName = [str_UserNameDep AES128DecryptWithKey:key];
    
    switch (requestId) {
    
        case LOGIN:
            self.dataType = NORMAL_DATA;
            self.requestType = requestId;
            if ([parameters objectForKey:@"PASSWORD"]) {
                
                NSData *passwordData = [[parameters objectForKey:@"PASSWORD"] dataUsingEncoding:NSASCIIStringEncoding];
                
                  NSString *passwordString = [Request encodeToPercentEscapeString:[passwordData base64Encoding]];
                 NSMutableString *requestString=[NSMutableString new];
                 [requestString appendFormat:@"%@:%@%@/%@?$filter=&$format=json",URL_HOST,URL_PORT,URL_PATH_ODATA,URL_LOGIN_ODATA];
                 self.connectionRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:requestString]];
                 NSData *decodedData = [[NSData alloc] initWithBase64EncodedString:[parameters objectForKey:@"PASSWORD"] options:0];
                
                NSString *decodedString = [[NSString alloc] initWithData:decodedData encoding:NSUTF8StringEncoding];
                NSLog(@"Decode String Value: %@", decodedString);
                
                [self.connectionRequest setValue:[NSString stringWithFormat:@"%@",[parameters objectForKey:@"USERNAME"]] forHTTPHeaderField:@"IvUsername"];
                [self.connectionRequest setValue:[NSString stringWithFormat:@"%@",[parameters objectForKey:@"USERNAME"]] forHTTPHeaderField:@"Muser"];
                [self.connectionRequest setValue:[NSString stringWithFormat:@"%@",decodedString] forHTTPHeaderField:@"IvPassword"];
                [self.connectionRequest setValue:@"EN" forHTTPHeaderField:@"IvLanguage"];
                [self.connectionRequest setValue:@"" forHTTPHeaderField:@"Devicesno"];
                [self.connectionRequest setValue:@"18523416-177F-4B9B-9250-4F7A90A89537" forHTTPHeaderField:@"Deviceid"];
                [self.connectionRequest setValue:@"" forHTTPHeaderField:@"Udid"];
 
                NSString *authStr = [NSString stringWithFormat:@"%@:%@",[parameters objectForKey:@"USERNAME"],decodedString];
                
                NSData *authData = [authStr dataUsingEncoding:NSUTF8StringEncoding];
                
                NSString *authValue = [authData base64EncodedStringWithOptions:0];
                
                [self.connectionRequest addValue:[NSString stringWithFormat:@"Basic %@",authValue] forHTTPHeaderField:@"Authorization"];
               }
             self.resultDelegate = delegate;
            
             break;
 
        case GET_SYNC_MAP_DATA:
            
             self.dataType = NORMAL_DATA;
            self.requestType = requestId;
            
            if ([parameters objectForKey:@"REPORTEDBY"])
            {

                NSMutableString *requestString=[NSMutableString new];
                
                [requestString appendFormat:@"%@:%@%@/%@?$filter=&$format=json",URL_HOST,URL_PORT,URL_PATH_ODATA,URL_GET_SYNC_MAP_ODATA];
                
                self.connectionRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:requestString] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:180.0];

                [self decryptforBasicAuth];
                
                [self.connectionRequest setValue:[NSString stringWithFormat:@"%@",[parameters objectForKey:@"TRANSMITTYPE"]] forHTTPHeaderField:@"IvTransmitType"];
                
                [self.connectionRequest setValue:[NSString stringWithFormat:@"%@",decryptedUserName] forHTTPHeaderField:@"Muser"];
                
                 [self.connectionRequest setValue:@"" forHTTPHeaderField:@"Devicesno"];
                
                [self.connectionRequest setValue:@"18523416-177F-4B9B-9250-4F7A90A89537" forHTTPHeaderField:@"Deviceid"];
                [self.connectionRequest setValue:@"" forHTTPHeaderField:@"Udid"];
                
                 NSString *authStr = [NSString stringWithFormat:@"%@:%@",[parameters objectForKey:@"USERNAME"],decryptedPassword];
                
                NSData *authData = [authStr dataUsingEncoding:NSUTF8StringEncoding];
                
                NSString *authValue = [authData base64EncodedStringWithOptions:0];
                
                [self.connectionRequest addValue:[NSString stringWithFormat:@"Basic %@",authValue] forHTTPHeaderField:@"Authorization"];
                
                NSLog(@"Request is %@",self.connectionRequest);

             }
 
            self.resultDelegate = delegate;
            
            break;
            
        case GET_LOAD_SETTINGS:
            
            self.dataType = NORMAL_DATA;
            self.requestType = requestId;
            
            if ([parameters objectForKey:@"REPORTEDBY"])
            {
                 NSMutableString *requestString=[NSMutableString new];
                
                [requestString appendFormat:@"%@:%@%@/%@",URL_HOST,URL_PORT,URL_PATH_ODATA,[parameters objectForKey:@"URL_ENDPOINT"]];
                
                self.connectionRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:requestString] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:180.0];
 
                [self decryptforBasicAuth];
                
                [self.connectionRequest setValue:[NSString stringWithFormat:@"%@",[parameters objectForKey:@"TRANSMITTYPE"]] forHTTPHeaderField:@"IvTransmitType"];
                
                [self.connectionRequest setValue:[[parameters objectForKey:@"REPORTEDBY"] uppercaseString] forHTTPHeaderField:@"Muser"];
                
                [self.connectionRequest setValue:@"" forHTTPHeaderField:@"Devicesno"];
                 [self.connectionRequest setValue:[NSString stringWithFormat:@"%@",decryptedUserName] forHTTPHeaderField:@"ivuser"];
                 [self.connectionRequest setValue:@"18523416-177F-4B9B-9250-4F7A90A89537" forHTTPHeaderField:@"Deviceid"];
                [self.connectionRequest setValue:@"" forHTTPHeaderField:@"Udid"];
                
                NSString *authStr = [NSString stringWithFormat:@"%@:%@",decryptedUserName,decryptedPassword];
                
                NSData *authData = [authStr dataUsingEncoding:NSUTF8StringEncoding];
                
                NSString *authValue = [authData base64EncodedStringWithOptions:0];
                
                [self.connectionRequest addValue:[NSString stringWithFormat:@"Basic %@",authValue] forHTTPHeaderField:@"Authorization"];
 
            }
 
            self.resultDelegate = delegate;
            
            break;
            
            case SEARCH_FUNCLOC_EQUIPMENTS:
            
            self.dataType = NORMAL_DATA;
            self.requestType = requestId;
            
            if ([parameters objectForKey:@"REPORTEDBY"])
            {
                NSMutableString *requestString=[NSMutableString new];
                
                [requestString appendFormat:@"%@:%@%@/%@",URL_HOST,URL_PORT,URL_PATH_ODATA,[parameters objectForKey:@"URL_ENDPOINT"]];
 
                  self.connectionRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:requestString] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:180.0];
                
                 [self decryptforBasicAuth];
 
                [self.connectionRequest setValue:[NSString stringWithFormat:@"%@",[parameters objectForKey:@"TRANSMITTYPE"]] forHTTPHeaderField:@"IvTransmitType"];
                [self.connectionRequest setValue:[NSString stringWithFormat:@"%@",decryptedUserName] forHTTPHeaderField:@"Muser"];
                [self.connectionRequest setValue:@"" forHTTPHeaderField:@"Devicesno"];
                [self.connectionRequest setValue:@"18523416-177F-4B9B-9250-4F7A90A89537" forHTTPHeaderField:@"Deviceid"];
                [self.connectionRequest setValue:@"" forHTTPHeaderField:@"Udid"];
                [self.connectionRequest setValue:@"" forHTTPHeaderField:@"iVTplnr"];
                [self.connectionRequest setValue:@"" forHTTPHeaderField:@"iVCcenter"];
                [self.connectionRequest setValue:@"" forHTTPHeaderField:@"iVText"];
                [self.connectionRequest setValue:@"" forHTTPHeaderField:@"iVArbpl"];
                [self.connectionRequest setValue:@"" forHTTPHeaderField:@"iVMaxRecords"];
                
                [self.connectionRequest setValue:[NSString stringWithFormat:@"%@",decryptedUserName] forHTTPHeaderField:@"ivuser"];
 
                NSString *authStr = [NSString stringWithFormat:@"%@:%@",[parameters objectForKey:@"USERNAME"],decryptedPassword];
                
                NSData *authData = [authStr dataUsingEncoding:NSUTF8StringEncoding];
                
                NSString *authValue = [authData base64EncodedStringWithOptions:0];
                 [self.connectionRequest addValue:[NSString stringWithFormat:@"Basic %@",authValue] forHTTPHeaderField:@"Authorization"];
                
 
            }
            
            self.resultDelegate = delegate;
 
            break;
            
            case GET_VALUE_HELPS:
            
            self.dataType = NORMAL_DATA;
            self.requestType = requestId;
            
            if ([parameters objectForKey:@"REPORTEDBY"])
            {
                NSMutableString *requestString=[NSMutableString new];
                
                [requestString appendFormat:@"%@:%@%@/%@?$filter=&$format=json",URL_HOST,URL_PORT,URL_PATH_ODATA,[parameters objectForKey:@"URL_ENDPOINT"]];
                
                 self.connectionRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:requestString] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:300.0];
                
             //   self.connectionRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:requestString]];
                
                [self decryptforBasicAuth];
                
                [self.connectionRequest setValue:[NSString stringWithFormat:@"%@",[parameters objectForKey:@"TRANSMITTYPE"]] forHTTPHeaderField:@"IvTransmitType"];
                
                [self.connectionRequest setValue:[NSString stringWithFormat:@"%@",decryptedUserName] forHTTPHeaderField:@"Muser"];
                
                [self.connectionRequest setValue:@"" forHTTPHeaderField:@"Devicesno"];
                
                [self.connectionRequest setValue:@"18523416-177F-4B9B-9250-4F7A90A89537" forHTTPHeaderField:@"Deviceid"];
                [self.connectionRequest setValue:@"" forHTTPHeaderField:@"Udid"];
                
                 [self.connectionRequest setValue:[NSString stringWithFormat:@"%@",decryptedUserName] forHTTPHeaderField:@"ivuser"];
                
                NSString *authStr = [NSString stringWithFormat:@"%@:%@",[parameters objectForKey:@"USERNAME"],decryptedPassword];
                
                NSData *authData = [authStr dataUsingEncoding:NSUTF8StringEncoding];
                
                NSString *authValue = [authData base64EncodedStringWithOptions:0];
                
                [self.connectionRequest addValue:[NSString stringWithFormat:@"Basic %@",authValue] forHTTPHeaderField:@"Authorization"];
                
 
            }
            
            self.resultDelegate = delegate;
            
            break;
            
            case ORDER_MDOCS:
             self.dataType = NORMAL_DATA;
            self.requestType = requestId;
            
            if ([parameters objectForKey:@"REPORTEDBY"])
            {
                NSMutableString *requestString=[NSMutableString new];
                
                [requestString appendFormat:@"%@:%@%@/%@?$filter=&$format=json",URL_HOST,URL_PORT,URL_PATH_ODATA,[parameters objectForKey:@"URL_ENDPOINT"]];
                
                self.connectionRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:requestString] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:180.0];

                [self decryptforBasicAuth];
                
                [self.connectionRequest setValue:[NSString stringWithFormat:@"%@",[parameters objectForKey:@"TRANSMITTYPE"]] forHTTPHeaderField:@"IvTransmitType"];
                
                [self.connectionRequest setValue:[NSString stringWithFormat:@"%@",decryptedUserName] forHTTPHeaderField:@"Muser"];
                
                [self.connectionRequest setValue:@"" forHTTPHeaderField:@"Devicesno"];
                
                [self.connectionRequest setValue:@"18523416-177F-4B9B-9250-4F7A90A89537" forHTTPHeaderField:@"Deviceid"];
                [self.connectionRequest setValue:@"" forHTTPHeaderField:@"Udid"];
                
                NSString *authStr = [NSString stringWithFormat:@"%@:%@",[parameters objectForKey:@"USERNAME"],decryptedPassword];
                
                 [self.connectionRequest setValue:[NSString stringWithFormat:@"%@",decryptedUserName] forHTTPHeaderField:@"ivuser"];
                
                NSData *authData = [authStr dataUsingEncoding:NSUTF8StringEncoding];
                
                NSString *authValue = [authData base64EncodedStringWithOptions:0];
                
                [self.connectionRequest addValue:[NSString stringWithFormat:@"Basic %@",authValue] forHTTPHeaderField:@"Authorization"];
             }
            
            self.resultDelegate = delegate;
            break;
            
           case WCM_VALUE_HELPS:
            
            self.dataType = NORMAL_DATA;
            self.requestType = requestId;
            
            if ([parameters objectForKey:@"REPORTEDBY"])
            {
                NSMutableString *requestString=[NSMutableString new];
                
                [requestString appendFormat:@"%@:%@%@/%@?$filter=&$format=json",URL_HOST,URL_PORT,URL_PATH_ODATA,[parameters objectForKey:@"URL_ENDPOINT"]];
                
                self.connectionRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:requestString] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:260.0];

                [self decryptforBasicAuth];
                
                [self.connectionRequest setValue:[NSString stringWithFormat:@"%@",[parameters objectForKey:@"TRANSMITTYPE"]] forHTTPHeaderField:@"IvTransmitType"];
                
                [self.connectionRequest setValue:[NSString stringWithFormat:@"%@",decryptedUserName] forHTTPHeaderField:@"Muser"];
                
                [self.connectionRequest setValue:@"" forHTTPHeaderField:@"Devicesno"];
                
                [self.connectionRequest setValue:@"18523416-177F-4B9B-9250-4F7A90A89537" forHTTPHeaderField:@"Deviceid"];
                [self.connectionRequest setValue:@"" forHTTPHeaderField:@"Udid"];
                
                 [self.connectionRequest setValue:[NSString stringWithFormat:@"%@",decryptedUserName] forHTTPHeaderField:@"ivuser"];
                
                NSString *authStr = [NSString stringWithFormat:@"%@:%@",[parameters objectForKey:@"USERNAME"],decryptedPassword];
                
                NSData *authData = [authStr dataUsingEncoding:NSUTF8StringEncoding];
                
                NSString *authValue = [authData base64EncodedStringWithOptions:0];
                
                [self.connectionRequest addValue:[NSString stringWithFormat:@"Basic %@",authValue] forHTTPHeaderField:@"Authorization"];
            }
            
            self.resultDelegate = delegate;
            break;
            
        case GET_LIST_OF_DUE_NOTIFICATIONS:
            
            self.dataType = NORMAL_DATA;
            self.requestType = requestId;
            
            if ([parameters objectForKey:@"REPORTEDBY"])
            {
                NSMutableString *requestString=[NSMutableString new];
                
                [requestString appendFormat:@"%@:%@%@/%@?$filter=&$format=json",URL_HOST,URL_PORT,URL_PATH_ODATA,[parameters objectForKey:@"URL_ENDPOINT"]];
                
                self.connectionRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:requestString] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:180.0];

                [self decryptforBasicAuth];
                
                [self.connectionRequest setValue:[NSString stringWithFormat:@"%@",[parameters objectForKey:@"TRANSMITTYPE"]] forHTTPHeaderField:@"IvTransmitType"];
                
                [self.connectionRequest setValue:[NSString stringWithFormat:@"%@",decryptedUserName] forHTTPHeaderField:@"Muser"];
                
                [self.connectionRequest setValue:@"" forHTTPHeaderField:@"Devicesno"];
                
                [self.connectionRequest setValue:@"18523416-177F-4B9B-9250-4F7A90A89537" forHTTPHeaderField:@"Deviceid"];
                [self.connectionRequest setValue:@"" forHTTPHeaderField:@"Udid"];
                
                [self.connectionRequest setValue:[NSString stringWithFormat:@"%@",decryptedUserName] forHTTPHeaderField:@"ivuser"];
                
                [self.connectionRequest setValue:@"DUNOT" forHTTPHeaderField:@"Operation"];
                
 
                NSString *authStr = [NSString stringWithFormat:@"%@:%@",[parameters objectForKey:@"USERNAME"],decryptedPassword];
                
                NSData *authData = [authStr dataUsingEncoding:NSUTF8StringEncoding];
                
                NSString *authValue = [authData base64EncodedStringWithOptions:0];
                
                [self.connectionRequest addValue:[NSString stringWithFormat:@"Basic %@",authValue] forHTTPHeaderField:@"Authorization"];
                
                NSLog(@"Request is %@",self.connectionRequest);

            }
            
            self.resultDelegate = delegate;
            break;
            
        case MONITOR_EQUIP_HISTORY:
            
            self.dataType = NORMAL_DATA;
            self.requestType = requestId;
            
            if ([parameters objectForKey:@"REPORTEDBY"])
            {
                NSMutableString *requestString=[NSMutableString new];
                
                [requestString appendFormat:@"%@:%@%@/%@",URL_HOST,URL_PORT,URL_PATH_ODATA,[parameters objectForKey:@"URL_ENDPOINT"]];
                
                self.connectionRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:requestString] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:180.0];

                [self decryptforBasicAuth];
                
                [self.connectionRequest setValue:[NSString stringWithFormat:@"%@",[parameters objectForKey:@"TRANSMITTYPE"]] forHTTPHeaderField:@"IvTransmitType"];
                
                [self.connectionRequest setValue:[[parameters objectForKey:@"REPORTEDBY"] uppercaseString] forHTTPHeaderField:@"Muser"];
                
                [self.connectionRequest setValue:@"" forHTTPHeaderField:@"Devicesno"];
                [self.connectionRequest setValue:[NSString stringWithFormat:@"%@",decryptedUserName] forHTTPHeaderField:@"ivuser"];
                [self.connectionRequest setValue:@"18523416-177F-4B9B-9250-4F7A90A89537" forHTTPHeaderField:@"Deviceid"];
                [self.connectionRequest setValue:@"" forHTTPHeaderField:@"Udid"];
                
                [self.connectionRequest setValue:[parameters objectForKey:@"EQUINR"] forHTTPHeaderField:@"Equnr"];
                
                NSString *authStr = [NSString stringWithFormat:@"%@:%@",decryptedUserName,decryptedPassword];
                NSData *authData = [authStr dataUsingEncoding:NSUTF8StringEncoding];
                NSString *authValue = [authData base64EncodedStringWithOptions:0];
                [self.connectionRequest addValue:[NSString stringWithFormat:@"Basic %@",authValue] forHTTPHeaderField:@"Authorization"];
                NSLog(@"Request is %@",self.connectionRequest);
                
            }
            
            self.resultDelegate = delegate;
            
            break;
 
            case GET_AUTH_DATA:
            
            self.dataType = NORMAL_DATA;
            self.requestType = requestId;
            
            if ([parameters objectForKey:@"REPORTEDBY"])
            {
                NSMutableString *requestString=[NSMutableString new];
                
                [requestString appendFormat:@"%@:%@%@/%@",URL_HOST,URL_PORT,URL_PATH_ODATA,[parameters objectForKey:@"URL_ENDPOINT"]];
                
                self.connectionRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:requestString] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:180.0];

                [self decryptforBasicAuth];
                
                [self.connectionRequest setValue:[NSString stringWithFormat:@"%@",[parameters objectForKey:@"TRANSMITTYPE"]] forHTTPHeaderField:@"IvTransmitType"];
                [self.connectionRequest setValue:[[parameters objectForKey:@"REPORTEDBY"] uppercaseString] forHTTPHeaderField:@"Muser"];
                [self.connectionRequest setValue:@"" forHTTPHeaderField:@"Devicesno"];
                [self.connectionRequest setValue:[NSString stringWithFormat:@"%@",decryptedUserName] forHTTPHeaderField:@"ivuser"];
                [self.connectionRequest setValue:@"18523416-177F-4B9B-9250-4F7A90A89537" forHTTPHeaderField:@"Deviceid"];
                [self.connectionRequest setValue:@"" forHTTPHeaderField:@"Udid"];
 
                NSString *authStr = [NSString stringWithFormat:@"%@:%@",decryptedUserName,decryptedPassword];
                NSData *authData = [authStr dataUsingEncoding:NSUTF8StringEncoding];
                NSString *authValue = [authData base64EncodedStringWithOptions:0];
                [self.connectionRequest addValue:[NSString stringWithFormat:@"Basic %@",authValue] forHTTPHeaderField:@"Authorization"];
            }
            
            self.resultDelegate = delegate;
            
            break;
            
        case GET_LIST_OF_DUE_ORDERS:
            
            self.dataType = NORMAL_DATA;
            self.requestType = requestId;
            
            if ([parameters objectForKey:@"REPORTEDBY"])
            {
                NSMutableString *requestString=[NSMutableString new];
                
                [requestString appendFormat:@"%@:%@%@/%@?$filter=&$format=json",URL_HOST,URL_PORT,URL_PATH_ODATA,[parameters objectForKey:@"URL_ENDPOINT"]];
                
                self.connectionRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:requestString] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:180.0];

                [self decryptforBasicAuth];
                
                [self.connectionRequest setValue:[NSString stringWithFormat:@"%@",[parameters objectForKey:@"TRANSMITTYPE"]] forHTTPHeaderField:@"IvTransmitType"];
                
                [self.connectionRequest setValue:[NSString stringWithFormat:@"%@",decryptedUserName] forHTTPHeaderField:@"Muser"];
                 [self.connectionRequest setValue:@"" forHTTPHeaderField:@"Devicesno"];
                 [self.connectionRequest setValue:@"18523416-177F-4B9B-9250-4F7A90A89537" forHTTPHeaderField:@"Deviceid"];
                [self.connectionRequest setValue:@"" forHTTPHeaderField:@"Udid"];
                 [self.connectionRequest setValue:[NSString stringWithFormat:@"%@",decryptedUserName] forHTTPHeaderField:@"ivuser"];
                
                 [self.connectionRequest setValue:@"DUORD" forHTTPHeaderField:@"Operation"];
 
                NSString *authStr = [NSString stringWithFormat:@"%@:%@",[parameters objectForKey:@"USERNAME"],decryptedPassword];
                
                NSData *authData = [authStr dataUsingEncoding:NSUTF8StringEncoding];
                
                NSString *authValue = [authData base64EncodedStringWithOptions:0];
                
                [self.connectionRequest addValue:[NSString stringWithFormat:@"Basic %@",authValue] forHTTPHeaderField:@"Authorization"];
                
                NSLog(@"Request is %@",self.connectionRequest);

            }
            
            self.resultDelegate = delegate;
            break;
            
           case GET_ORDERS:
            
            self.dataType = NORMAL_DATA;
            self.requestType = requestId;
            
            if ([parameters objectForKey:@"REPORTEDBY"])
            {
                NSMutableString *requestString=[NSMutableString new];
                
                [requestString appendFormat:@"%@:%@%@/%@?$filter=&$format=json",URL_HOST,URL_PORT,URL_PATH_ODATA,[parameters objectForKey:@"URL_ENDPOINT"]];
                
                self.connectionRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:requestString] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:180.0];

                [self decryptforBasicAuth];
                
                [self.connectionRequest setValue:[NSString stringWithFormat:@"%@",@"Single_Ord"] forHTTPHeaderField:@"IvTransmitType"];
                
                [self.connectionRequest setValue:[NSString stringWithFormat:@"%@",decryptedUserName] forHTTPHeaderField:@"Muser"];
                [self.connectionRequest setValue:@"" forHTTPHeaderField:@"Devicesno"];
                [self.connectionRequest setValue:@"18523416-177F-4B9B-9250-4F7A90A89537" forHTTPHeaderField:@"Deviceid"];
                [self.connectionRequest setValue:@"" forHTTPHeaderField:@"Udid"];
                [self.connectionRequest setValue:[NSString stringWithFormat:@"%@",decryptedUserName] forHTTPHeaderField:@"ivuser"];
                
                [self.connectionRequest setValue:[parameters objectForKey:@"Aufnr"] forHTTPHeaderField:@"IvAufnr"];
                
                [self.connectionRequest setValue:@"DUORD" forHTTPHeaderField:@"Operation"];
                
                NSString *authStr = [NSString stringWithFormat:@"%@:%@",[parameters objectForKey:@"USERNAME"],decryptedPassword];
                
                NSData *authData = [authStr dataUsingEncoding:NSUTF8StringEncoding];
                
                NSString *authValue = [authData base64EncodedStringWithOptions:0];
                
                [self.connectionRequest addValue:[NSString stringWithFormat:@"Basic %@",authValue] forHTTPHeaderField:@"Authorization"];
                
                NSLog(@"Request is %@",self.connectionRequest);
                
            }
            
            self.resultDelegate = delegate;
            break;
 
        case MONITOR_GET_EQUIP_MDOCS:
            
            self.dataType = NORMAL_DATA;
            self.requestType = requestId;
            
            if ([parameters objectForKey:@"REPORTEDBY"])
            {
                NSMutableString *requestString=[NSMutableString new];
                
                [requestString appendFormat:@"%@:%@%@/%@",URL_HOST,URL_PORT,URL_PATH_ODATA,[parameters objectForKey:@"URL_ENDPOINT"]];
                
                self.connectionRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:requestString] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:180.0];

                [self decryptforBasicAuth];
                
                [self.connectionRequest setValue:[NSString stringWithFormat:@"%@",[parameters objectForKey:@"TRANSMITTYPE"]] forHTTPHeaderField:@"IvTransmitType"];
                
                [self.connectionRequest setValue:[[parameters objectForKey:@"REPORTEDBY"] uppercaseString] forHTTPHeaderField:@"Muser"];
                
                [self.connectionRequest setValue:@"" forHTTPHeaderField:@"Devicesno"];
                [self.connectionRequest setValue:[NSString stringWithFormat:@"%@",decryptedUserName] forHTTPHeaderField:@"ivuser"];
                [self.connectionRequest setValue:@"18523416-177F-4B9B-9250-4F7A90A89537" forHTTPHeaderField:@"Deviceid"];
                [self.connectionRequest setValue:@"" forHTTPHeaderField:@"Udid"];
                
                [self.connectionRequest setValue:[parameters objectForKey:@"EQUINR"] forHTTPHeaderField:@"Equnr"];
                
                NSString *authStr = [NSString stringWithFormat:@"%@:%@",decryptedUserName,decryptedPassword];
                NSData *authData = [authStr dataUsingEncoding:NSUTF8StringEncoding];
                NSString *authValue = [authData base64EncodedStringWithOptions:0];
                [self.connectionRequest addValue:[NSString stringWithFormat:@"Basic %@",authValue] forHTTPHeaderField:@"Authorization"];
                NSLog(@"Request is %@",self.connectionRequest);
                
            }
            self.resultDelegate = delegate;
             break;
            
        case MONITOR_SET_EQUIP_MDOCS:
            
            self.dataType = NORMAL_DATA;
            self.requestType = requestId;
            self.resultDelegate = delegate;
            
            if (![[NSUserDefaults standardUserDefaults] objectForKey:@"CSRF"]) {
                
                [self performSelectorInBackground:@selector(createSession:) withObject:[NSMutableArray arrayWithObjects:[NSNumber numberWithInt:requestId],parameters, nil]];
                
                return;
            }
            
            //  self.connectionRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@:%@%@/%@",URL_HOST,URL_PORT,URL_PATH_ODATA,[parameters objectForKey:@"URL_ENDPOINT"]]]];
            
            self.connectionRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@:%@%@/%@",URL_HOST,URL_PORT,URL_PATH_ODATA,[parameters objectForKey:@"URL_ENDPOINT"]]] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:180.0];
            
            self.resultDelegate = delegate;
            
            if (1) {
                NSMutableString *soapString = [[NSMutableString alloc] init];
                //[soapString appendString:[self mxmlPrefix:requestId]];
                [soapString appendString:[self mxmlBodyWithKeys:parameters Values:nil Action:[self actionWithWebServiceRequest:requestId]]];
                //[soapString appendString:[self mxmlSuffix]];
                NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapString length]];
                [self.connectionRequest setValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"CSRF"] forHTTPHeaderField:@"x-csrf-token"];
                [self.connectionRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
                [self.connectionRequest setValue:@"application/json" forHTTPHeaderField:@"Accept"];
                [self.connectionRequest addValue:msgLength forHTTPHeaderField:@"Content-Length"];
                
                [self decryptforBasicAuth];
                
                NSString *authStr = [NSString stringWithFormat:@"%@:%@",decryptedUserName,decryptedPassword];
                
                NSData *authData = [authStr dataUsingEncoding:NSUTF8StringEncoding];
                
                NSString *authValue = [authData base64EncodedStringWithOptions:0];
                
                [self.connectionRequest addValue:[NSString stringWithFormat:@"Basic %@",authValue] forHTTPHeaderField:@"Authorization"];
                
                [self.connectionRequest setHTTPMethod: @"POST"];
                [self.connectionRequest setHTTPBody:[soapString dataUsingEncoding:NSUTF8StringEncoding]];
                
                NSLog(@"%@",soapString);
            }
            
            break;
            
            
        case NOTIFICATION_CREATE:
            
            self.dataType = NORMAL_DATA;
            self.requestType = requestId;
            self.resultDelegate = delegate;
            
            if (![[NSUserDefaults standardUserDefaults] objectForKey:@"CSRF"]) {
                
                [self performSelectorInBackground:@selector(createSession:) withObject:[NSMutableArray arrayWithObjects:[NSNumber numberWithInt:requestId],parameters, nil]];
                
                return;
            }
            
          //  self.connectionRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@:%@%@/%@",URL_HOST,URL_PORT,URL_PATH_ODATA,[parameters objectForKey:@"URL_ENDPOINT"]]]];
            
             self.connectionRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@:%@%@/%@",URL_HOST,URL_PORT,URL_PATH_ODATA,[parameters objectForKey:@"URL_ENDPOINT"]]] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:180.0];
            
            self.resultDelegate = delegate;
 
            if (1) {
                NSMutableString *soapString = [[NSMutableString alloc] init];
                //[soapString appendString:[self mxmlPrefix:requestId]];
                [soapString appendString:[self mxmlBodyWithKeys:parameters Values:nil Action:[self actionWithWebServiceRequest:requestId]]];
                //[soapString appendString:[self mxmlSuffix]];
                NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapString length]];
                [self.connectionRequest setValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"CSRF"] forHTTPHeaderField:@"x-csrf-token"];
                [self.connectionRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
                [self.connectionRequest setValue:@"application/json" forHTTPHeaderField:@"Accept"];
                [self.connectionRequest addValue:msgLength forHTTPHeaderField:@"Content-Length"];
                
                [self decryptforBasicAuth];
                
                NSString *authStr = [NSString stringWithFormat:@"%@:%@",decryptedUserName,decryptedPassword];
                
                NSData *authData = [authStr dataUsingEncoding:NSUTF8StringEncoding];
                
                NSString *authValue = [authData base64EncodedStringWithOptions:0];
                
                [self.connectionRequest addValue:[NSString stringWithFormat:@"Basic %@",authValue] forHTTPHeaderField:@"Authorization"];
                
                [self.connectionRequest setHTTPMethod: @"POST"];
                [self.connectionRequest setHTTPBody:[soapString dataUsingEncoding:NSUTF8StringEncoding]];
                
             }
 
            break;
            
        case NOTIFICATION_CHANGE:
        
        self.dataType = NORMAL_DATA;
        self.requestType = requestId;
        self.resultDelegate = delegate;
        
          if (![[NSUserDefaults standardUserDefaults] objectForKey:@"CSRF"]) {
 
              [self performSelectorInBackground:@selector(createSession:) withObject:[NSMutableArray arrayWithObjects:[NSNumber numberWithInt:requestId],parameters, nil]];
                
                return;
            }
 
//         self.connectionRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@:%@%@/%@",URL_HOST,URL_PORT,URL_PATH_ODATA,[parameters objectForKey:@"URL_ENDPOINT"]]]];
            
            self.connectionRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@:%@%@/%@",URL_HOST,URL_PORT,URL_PATH_ODATA,[parameters objectForKey:@"URL_ENDPOINT"]]] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:180.0];
        
        self.resultDelegate = delegate;
        
        if (1) {
            NSMutableString *soapString = [[NSMutableString alloc] init];
            //[soapString appendString:[self mxmlPrefix:requestId]];
            [soapString appendString:[self mxmlBodyWithKeys:parameters Values:nil Action:[self actionWithWebServiceRequest:requestId]]];
            //[soapString appendString:[self mxmlSuffix]];
            NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapString length]];
            [self.connectionRequest setValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"CSRF"] forHTTPHeaderField:@"x-csrf-token"];
            [self.connectionRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
            [self.connectionRequest setValue:@"application/json" forHTTPHeaderField:@"Accept"];
            [self.connectionRequest addValue:msgLength forHTTPHeaderField:@"Content-Length"];
            
            [self decryptforBasicAuth];
            
            NSString *authStr = [NSString stringWithFormat:@"%@:%@",decryptedUserName,decryptedPassword];
            
            NSData *authData = [authStr dataUsingEncoding:NSUTF8StringEncoding];
            
            NSString *authValue = [authData base64EncodedStringWithOptions:0];
            
            [self.connectionRequest addValue:[NSString stringWithFormat:@"Basic %@",authValue] forHTTPHeaderField:@"Authorization"];
            
            [self.connectionRequest setHTTPMethod: @"POST"];
            [self.connectionRequest setHTTPBody:[soapString dataUsingEncoding:NSUTF8StringEncoding]];
            
            NSLog(@"%@",soapString);
        }

            break;
            
        case NOTIFICATION_CANCEL:
            
            self.dataType = NORMAL_DATA;
            self.requestType = requestId;
            if ([parameters objectForKey:@"ITEMS"]) {
                NSString *objectIds = [[parameters objectForKey:@"ITEMS"] componentsJoinedByString:@","];
                NSMutableString *qumnumList = [[NSMutableString alloc] initWithString:@"'"];
                [qumnumList appendString:objectIds];
                [qumnumList appendString:@"'"];
                
                NSString *parameterString = [NSString stringWithFormat:@"Qmnum=%@&Cancel=true&Muser='%@'&UDID='18523416-177F-4B9B-9250-4F7A90A89537'",qumnumList,[decryptedUserName uppercaseString]];
                self.connectionRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@:%@%@%@?%@&$format=json",[defaults objectForKey:@"HOST"],[defaults objectForKey:@"PORT"],URL_PATH_ODATA,URL_CANCEL_NOTIFICATION_ODATA,parameterString]]];
            }
            
            self.resultDelegate = delegate;
            break;
    
            
        case NOTIFICATION_COMPLETE:
            
        self.dataType = NORMAL_DATA;
        self.requestType = requestId;
        self.resultDelegate = delegate;
        
        if (![[NSUserDefaults standardUserDefaults] objectForKey:@"CSRF"]) {
            
            [self performSelectorInBackground:@selector(createSession:) withObject:[NSMutableArray arrayWithObjects:[NSNumber numberWithInt:requestId],parameters, nil]];
            
            return;
        }
        
        self.connectionRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@:%@%@/%@",URL_HOST,URL_PORT,URL_PATH_ODATA,[parameters objectForKey:@"URL_ENDPOINT"]]]];
        
        self.resultDelegate = delegate;
        
        if (1) {
            NSMutableString *soapString = [[NSMutableString alloc] init];
            
            NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapString length]];
            [self.connectionRequest setValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"CSRF"] forHTTPHeaderField:@"x-csrf-token"];
            [self.connectionRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
            [self.connectionRequest setValue:@"application/json" forHTTPHeaderField:@"Accept"];
            [self.connectionRequest addValue:msgLength forHTTPHeaderField:@"Content-Length"];
            
            [self decryptforBasicAuth];
            
            NSString *authStr = [NSString stringWithFormat:@"%@:%@",decryptedUserName,decryptedPassword];
            
            NSData *authData = [authStr dataUsingEncoding:NSUTF8StringEncoding];
            
            NSString *authValue = [authData base64EncodedStringWithOptions:0];
            
            [self.connectionRequest addValue:[NSString stringWithFormat:@"Basic %@",authValue] forHTTPHeaderField:@"Authorization"];
            
            [self.connectionRequest setValue:[parameters objectForKey:@"REPORTEDBY"] forHTTPHeaderField:@"Muser"];

 
            [self.connectionRequest setValue:@"X" forHTTPHeaderField:@"IVCOMMIT"];
            
            [self.connectionRequest setValue:@"12345" forHTTPHeaderField:@"Devicesno"];
            
            [self.connectionRequest setValue:@"18523416-177F-4B9B-9250-4F7A90A89537" forHTTPHeaderField:@"Deviceid"];
            [self.connectionRequest setValue:@"" forHTTPHeaderField:@"Udid"];

            [self.connectionRequest setValue:[NSString stringWithFormat:@"%@",[parameters objectForKey:@"TRANSMITTYPE"]] forHTTPHeaderField:@"IvTransmitType"];
            
            if ([parameters objectForKey:@"ITEMS"]) {
                NSMutableArray *objectIds = [parameters objectForKey:@"ITEMS"];
                for (int i=0; i<[objectIds count]; i++) {
                    [self.connectionRequest setValue:[objectIds objectAtIndex:i] forHTTPHeaderField:@"Qmnum"];
                }
            }
            
            [self.connectionRequest setHTTPMethod: @"POST"];
            [self.connectionRequest setHTTPBody:[soapString dataUsingEncoding:NSUTF8StringEncoding]];
            
            NSLog(@"%@",soapString);
        }
        
        break;
            
        case ORDER_CREATE:
            
            self.dataType = NORMAL_DATA;
            self.requestType = requestId;
            self.resultDelegate = delegate;
            
            if (![[NSUserDefaults standardUserDefaults] objectForKey:@"CSRF"]) {
                
                [self performSelectorInBackground:@selector(createSession:) withObject:[NSMutableArray arrayWithObjects:[NSNumber numberWithInt:requestId],parameters, nil]];
                
                return;
            }
            
            //  self.connectionRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@:%@%@/%@",URL_HOST,URL_PORT,URL_PATH_ODATA,[parameters objectForKey:@"URL_ENDPOINT"]]]];
            
            self.connectionRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@:%@%@/%@",URL_HOST,URL_PORT,URL_PATH_ODATA,[parameters objectForKey:@"URL_ENDPOINT"]]] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:120.0];
            
            self.resultDelegate = delegate;
            
            if (1) {
                NSMutableString *soapString = [[NSMutableString alloc] init];
                //[soapString appendString:[self mxmlPrefix:requestId]];
                [soapString appendString:[self mxmlBodyWithKeys:parameters Values:nil Action:[self actionWithWebServiceRequest:requestId]]];
                //[soapString appendString:[self mxmlSuffix]];
                NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapString length]];
                [self.connectionRequest setValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"CSRF"] forHTTPHeaderField:@"x-csrf-token"];
                [self.connectionRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
                [self.connectionRequest setValue:@"application/json" forHTTPHeaderField:@"Accept"];
                [self.connectionRequest addValue:msgLength forHTTPHeaderField:@"Content-Length"];
                
                [self decryptforBasicAuth];
                
                NSString *authStr = [NSString stringWithFormat:@"%@:%@",decryptedUserName,decryptedPassword];
                
                NSData *authData = [authStr dataUsingEncoding:NSUTF8StringEncoding];
                
                NSString *authValue = [authData base64EncodedStringWithOptions:0];
                
                [self.connectionRequest addValue:[NSString stringWithFormat:@"Basic %@",authValue] forHTTPHeaderField:@"Authorization"];
                
                [self.connectionRequest setHTTPMethod: @"POST"];
                [self.connectionRequest setHTTPBody:[soapString dataUsingEncoding:NSUTF8StringEncoding]];
             }
             break;
            
        case PERMIT_CREATE:
            
            self.dataType = NORMAL_DATA;
            self.requestType = requestId;
            self.resultDelegate = delegate;
            
            if (![[NSUserDefaults standardUserDefaults] objectForKey:@"CSRF"]) {
                
                [self performSelectorInBackground:@selector(createSession:) withObject:[NSMutableArray arrayWithObjects:[NSNumber numberWithInt:requestId],parameters, nil]];
                
                return;
            }
            
            //  self.connectionRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@:%@%@/%@",URL_HOST,URL_PORT,URL_PATH_ODATA,[parameters objectForKey:@"URL_ENDPOINT"]]]];
            
            self.connectionRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@:%@%@/%@",URL_HOST,URL_PORT,URL_PATH_ODATA,[parameters objectForKey:@"URL_ENDPOINT"]]] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:120.0];
            
            self.resultDelegate = delegate;
            
            if (1) {
                NSMutableString *soapString = [[NSMutableString alloc] init];
                //[soapString appendString:[self mxmlPrefix:requestId]];
                [soapString appendString:[self mxmlBodyWithKeys:parameters Values:nil Action:[self actionWithWebServiceRequest:requestId]]];
                //[soapString appendString:[self mxmlSuffix]];
                NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapString length]];
                [self.connectionRequest setValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"CSRF"] forHTTPHeaderField:@"x-csrf-token"];
                [self.connectionRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
                [self.connectionRequest setValue:@"application/json" forHTTPHeaderField:@"Accept"];
                [self.connectionRequest addValue:msgLength forHTTPHeaderField:@"Content-Length"];
                
                [self decryptforBasicAuth];
                
                NSString *authStr = [NSString stringWithFormat:@"%@:%@",decryptedUserName,decryptedPassword];
                
                NSData *authData = [authStr dataUsingEncoding:NSUTF8StringEncoding];
                
                NSString *authValue = [authData base64EncodedStringWithOptions:0];
                
                [self.connectionRequest addValue:[NSString stringWithFormat:@"Basic %@",authValue] forHTTPHeaderField:@"Authorization"];
                
                [self.connectionRequest setHTTPMethod: @"POST"];
                [self.connectionRequest setHTTPBody:[soapString dataUsingEncoding:NSUTF8StringEncoding]];
            }
            break;
            
        case ORDER_COLLECTIVE_CONFIRMATION:
            
            self.dataType = NORMAL_DATA;
            self.requestType = requestId;
            self.resultDelegate = delegate;
            
            if (![[NSUserDefaults standardUserDefaults] objectForKey:@"CSRF"]) {
                
                [self performSelectorInBackground:@selector(createSession:) withObject:[NSMutableArray arrayWithObjects:[NSNumber numberWithInt:requestId],parameters, nil]];
                
                return;
            }
            
            //  self.connectionRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@:%@%@/%@",URL_HOST,URL_PORT,URL_PATH_ODATA,[parameters objectForKey:@"URL_ENDPOINT"]]]];
            
            self.connectionRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@:%@%@/%@",URL_HOST,URL_PORT,URL_PATH_ODATA,[parameters objectForKey:@"URL_ENDPOINT"]]] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:120.0];
            
            self.resultDelegate = delegate;
            
            if (1) {
                NSMutableString *soapString = [[NSMutableString alloc] init];
                //[soapString appendString:[self mxmlPrefix:requestId]];
                [soapString appendString:[self mxmlBodyWithKeys:parameters Values:nil Action:[self actionWithWebServiceRequest:requestId]]];
                //[soapString appendString:[self mxmlSuffix]];
                NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapString length]];
                [self.connectionRequest setValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"CSRF"] forHTTPHeaderField:@"x-csrf-token"];
                [self.connectionRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
                [self.connectionRequest setValue:@"application/json" forHTTPHeaderField:@"Accept"];
                [self.connectionRequest addValue:msgLength forHTTPHeaderField:@"Content-Length"];
                
                [self decryptforBasicAuth];
                
                NSString *authStr = [NSString stringWithFormat:@"%@:%@",decryptedUserName,decryptedPassword];
                
                NSData *authData = [authStr dataUsingEncoding:NSUTF8StringEncoding];
                
                NSString *authValue = [authData base64EncodedStringWithOptions:0];
                
                [self.connectionRequest addValue:[NSString stringWithFormat:@"Basic %@",authValue] forHTTPHeaderField:@"Authorization"];
                
                [self.connectionRequest setHTTPMethod: @"POST"];
                [self.connectionRequest setHTTPBody:[soapString dataUsingEncoding:NSUTF8StringEncoding]];
            }
            break;
            
            
        case GET_LIST_OF_ORDERS:
          
            self.dataType = NORMAL_DATA;
            self.requestType = requestId;
            if ([parameters objectForKey:@"ORDERTYPE"]) {
                NSMutableString *searchParameters = [[NSMutableString alloc] initWithString:@""];
                if ([[parameters objectForKey:@"ORDERTYPE"] length]) {
                    [searchParameters appendFormat:@"Auart eq '%@'",[parameters objectForKey:@"ORDERTYPE"]];
                }
                
                if ([[parameters objectForKey:@"PRIORITYFROM"] length]) {
                    if (searchParameters.length) {
                        [searchParameters appendString:@" and "];
                    }
                    if ([[parameters objectForKey:@"PRIORITYTO"] length]) {
                        [searchParameters appendFormat:@"(Priok ge '%@' and Priok le '%@' )",[parameters objectForKey:@"PRIORITYFROM"],[parameters objectForKey:@"PRIORITYTO"]];
                    }
                    else
                    {
                        [searchParameters appendFormat:@"Priok eq '%@'",[parameters objectForKey:@"PRIORITYFROM"]];
                    }
                }

                if ([[parameters objectForKey:@"EQUIPFROM"] length]) {
                    if (searchParameters.length) {
                        [searchParameters appendString:@" and "];
                    }
                    if ([[parameters objectForKey:@"EQUIPTO"] length]) {
                        [searchParameters appendFormat:@"(Equnr ge '%@' and Equnr le '%@' )",[parameters objectForKey:@"EQUIPFROM"],[parameters objectForKey:@"EQUIPTO"]];
                    }
                    else
                    {
                        [searchParameters appendFormat:@"Equnr eq '%@'",[parameters objectForKey:@"EQUIPFROM"]];
                    }
                }
                
                if ([[parameters objectForKey:@"FUNCLOCFROM"] length]) {
                    if (searchParameters.length) {
                        [searchParameters appendString:@" and "];
                    }
                    if ([[parameters objectForKey:@"FUNCLOCTO"] length]) {
                        [searchParameters appendFormat:@"(Strno ge '%@' and Strno le '%@' )",[parameters objectForKey:@"FUNCLOCFROM"],[parameters objectForKey:@"FUNCLOCTO"]];
                    }
                    else
                    {
                        [searchParameters appendFormat:@"Strno eq '%@'",[parameters objectForKey:@"FUNCLOCFROM"]];
                    }
                }
            
                // 192.168.0.6:8080/sap/opu/odata/ENS/PMAPP_SRV/NotificationHeaderCollection?$filter=CreatedOn+ge+datetime’2014-01-01T00%3A00'+and+CreatedOn+le+datetime'2014-01-10T00%3A00'+and+NotifType+eq+'ZB'+and+ReportedBy+eq+'KAMAL'+and+Completed+ne+'X'+and+Closed+ne+'X'&$expand=NotifLongText,NotificationItems&$format=json
                if ([[parameters objectForKey:@"DATEFROM"] length]) {
                    
                    if (searchParameters.length) {
                        [searchParameters appendString:@" and "];
                    }
                    if ([[parameters objectForKey:@"DATETO"] length]) {
                        [searchParameters appendFormat:@"(Erdat ge datetime'%@T00:00' and Erdat le datetime'%@T00:00' )",[parameters objectForKey:@"DATEFROM"],[parameters objectForKey:@"DATETO"]];
                    }
                    else
                    {
                        [searchParameters appendFormat:@"Erdat eq datetime'%@T00:00'",[parameters objectForKey:@"DATEFROM"]];
                    }
                }
                else if ([[parameters objectForKey:@"DATETO"] length]){
                
                    [searchParameters appendFormat:@"Erdat eq datetime'%@T00:00'",[parameters objectForKey:@"DATETO"]];
                }

                if ([[parameters objectForKey:@"REPORTEDBY"] length]) {
                    if (searchParameters.length) {
                        [searchParameters appendString:@" and "];
                    }
                    [searchParameters appendFormat:@"Ernam eq '%@'",[[parameters objectForKey:@"REPORTEDBY"] uppercaseString]];
                }
                
           //     http://192.168.0.6:8080/sap/opu/odata/ENS/PMAPP_SRV/OrderHeaderCollection?$filter=Aufnr%20eq%20%27000000820609%27&$expand=OrderOperations/OrderOperationLongTexts,OrderLongTexts,OrderOperations/OrderComponents&$format=json
                
                self.connectionRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@:%@%@%@?$filter=%@&$expand=OrderOperations/OrderOperationLongTexts,OrderLongTexts,OrderOperations/OrderComponents&$format=json&$top=100",[defaults objectForKey:@"HOST"],[defaults objectForKey:@"PORT"],URL_PATH_ODATA,URL_GET_LIST_OF_ORDERS_ODATA,[Request encodeToPercentEscapeString:searchParameters]]]];
            }
        
            self.resultDelegate = delegate;

            break;
            
        case GET_LIST_OF_OPEN_ORDERS:
            
            self.dataType = NORMAL_DATA;
            self.requestType = requestId;
            if ([parameters objectForKey:@"ORDERTYPE"]) {
                NSMutableString *searchParameters = [[NSMutableString alloc] initWithString:@""];
              
                if ([[parameters objectForKey:@"ORDERTYPE"] length]) {
                    [searchParameters appendFormat:@"Auart eq '%@'",[parameters objectForKey:@"ORDERTYPE"]];
                }
                
                if ([[parameters objectForKey:@"PRIORITYFROM"] length]) {
                    if (searchParameters.length) {
                        [searchParameters appendString:@" and "];
                    }
                    if ([[parameters objectForKey:@"PRIORITYTO"] length]) {
                        [searchParameters appendFormat:@"(Priok ge '%@' and Priok le '%@' )",[parameters objectForKey:@"PRIORITYFROM"],[parameters objectForKey:@"PRIORITYTO"]];
                    }
                    else
                    {
                        [searchParameters appendFormat:@"Priok eq '%@'",[parameters objectForKey:@"PRIORITYFROM"]];
                    }
                }
                
                if ([[parameters objectForKey:@"EQUIPFROM"] length]) {
                    if (searchParameters.length) {
                        [searchParameters appendString:@" and "];
                    }
                    if ([[parameters objectForKey:@"EQUIPTO"] length]) {
                        [searchParameters appendFormat:@"(Equnr ge '%@' and Equnr le '%@' )",[parameters objectForKey:@"EQUIPFROM"],[parameters objectForKey:@"EQUIPTO"]];
                    }
                    else
                    {
                        [searchParameters appendFormat:@"Equnr eq '%@'",[parameters objectForKey:@"EQUIPFROM"]];
                    }
                }
                
                if ([[parameters objectForKey:@"FUNCLOCFROM"] length]) {
                    if (searchParameters.length) {
                        [searchParameters appendString:@" and "];
                    }
                    if ([[parameters objectForKey:@"FUNCLOCTO"] length]) {
                        [searchParameters appendFormat:@"(Strno ge '%@' and Strno le '%@' )",[parameters objectForKey:@"FUNCLOCFROM"],[parameters objectForKey:@"FUNCLOCTO"]];
                    }
                    else
                    {
                        [searchParameters appendFormat:@"Strno eq '%@'",[parameters objectForKey:@"FUNCLOCFROM"]];
                    }
                }
                
                // 192.168.0.6:8080/sap/opu/odata/ENS/PMAPP_SRV/NotificationHeaderCollection?$filter=CreatedOn+ge+datetime’2014-01-01T00%3A00'+and+CreatedOn+le+datetime'2014-01-10T00%3A00'+and+NotifType+eq+'ZB'+and+ReportedBy+eq+'KAMAL'+and+Completed+ne+'X'+and+Closed+ne+'X'&$expand=NotifLongText,NotificationItems&$format=json
                if ([[parameters objectForKey:@"DATEFROM"] length]) {
                    
                    if (searchParameters.length) {
                        [searchParameters appendString:@" and "];
                    }
                    if ([[parameters objectForKey:@"DATETO"] length]) {
                        [searchParameters appendFormat:@"(Erdat ge datetime'%@T00:00' and Erdat le datetime'%@T00:00' )",[parameters objectForKey:@"DATEFROM"],[parameters objectForKey:@"DATETO"]];
                    }
                    else
                    {
                        [searchParameters appendFormat:@"Erdat eq datetime'%@T00:00'",[parameters objectForKey:@"DATEFROM"]];
                    }
                }
                else if ([[parameters objectForKey:@"DATETO"] length]){
                    
                    [searchParameters appendFormat:@"Erdat eq datetime'%@T00:00'",[parameters objectForKey:@"DATETO"]];
                }
                
                if ([[parameters objectForKey:@"REPORTEDBY"] length]) {
                    if (searchParameters.length) {
                        [searchParameters appendString:@" and "];
                    }
                    [searchParameters appendFormat:@"Ernam eq '%@'",[[parameters objectForKey:@"REPORTEDBY"] uppercaseString]];
                }
                
                [searchParameters appendFormat:@" and Aueru eq '%@'",[parameters objectForKey:@"AUERU"]];
                
                if (searchParameters.length) {
                    [searchParameters appendString:@" and "];
                }

                [searchParameters appendString:@"Completed ne 'X' and Closed ne 'X'"];
                
          //  http://192.168.0.6:8080/sap/opu/odata/ENS/PMAPP_SRV/OrderHeaderCollection?$filter=Aufnr%20eq%20%27820609%27%20and%20Completed%20ne%20%27X%27%20and%20Closed%20ne%20%27X%27&$expand=OrderOperations/OrderOperationLongTexts,OrderLongTexts,OrderOperations/OrderComponents&$format=json
                
            self.connectionRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@:%@%@%@?$filter=%@&$expand=OrderOperations/OrderOperationLongTexts,OrderLongTexts,OrderOperations/OrderComponents&$format=json&$top=100",[defaults objectForKey:@"HOST"],[defaults objectForKey:@"PORT"],URL_PATH_ODATA,URL_GET_LIST_OF_OPEN_ORDERS_ODATA,[Request encodeToPercentEscapeString:searchParameters]]]];
            }
            
            self.resultDelegate = delegate;

            break;
            
        case ORDER_CHANGE:
           
            self.dataType = NORMAL_DATA;
            self.requestType = requestId;
            self.resultDelegate = delegate;
            
            if (![[NSUserDefaults standardUserDefaults] objectForKey:@"CSRF"]) {
                
                [self performSelectorInBackground:@selector(createSession:) withObject:[NSMutableArray arrayWithObjects:[NSNumber numberWithInt:requestId],parameters, nil]];
                
                return;
            }
 
            self.connectionRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@:%@%@/%@",URL_HOST,URL_PORT,URL_PATH_ODATA,[parameters objectForKey:@"URL_ENDPOINT"]]] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:180.0];
            
            self.resultDelegate = delegate;
            
            if (1) {
                NSMutableString *soapString = [[NSMutableString alloc] init];
                //[soapString appendString:[self mxmlPrefix:requestId]];
                [soapString appendString:[self mxmlBodyWithKeys:parameters Values:nil Action:[self actionWithWebServiceRequest:requestId]]];
                //[soapString appendString:[self mxmlSuffix]];
                NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapString length]];
                [self.connectionRequest setValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"CSRF"] forHTTPHeaderField:@"x-csrf-token"];
                [self.connectionRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
                [self.connectionRequest setValue:@"application/json" forHTTPHeaderField:@"Accept"];
                [self.connectionRequest addValue:msgLength forHTTPHeaderField:@"Content-Length"];
                
                [self decryptforBasicAuth];
                
                NSString *authStr = [NSString stringWithFormat:@"%@:%@",decryptedUserName,decryptedPassword];
                
                NSData *authData = [authStr dataUsingEncoding:NSUTF8StringEncoding];
                
                NSString *authValue = [authData base64EncodedStringWithOptions:0];
                
                [self.connectionRequest addValue:[NSString stringWithFormat:@"Basic %@",authValue] forHTTPHeaderField:@"Authorization"];
                
                [self.connectionRequest setHTTPMethod: @"POST"];
                [self.connectionRequest setHTTPBody:[soapString dataUsingEncoding:NSUTF8StringEncoding]];
             }
            break;
            
        case ORDER_CANCEL:
            self.dataType = NORMAL_DATA;
            self.requestType = requestId;
            if ([parameters objectForKey:@"ITEMS"]) {
                NSString *objectIds = [[parameters objectForKey:@"ITEMS"] componentsJoinedByString:@","];
                NSMutableString *qumnumList = [[NSMutableString alloc] initWithString:@"'"];
                [qumnumList appendString:objectIds];
                [qumnumList appendString:@"'"];
               // http://enstol4:8080/sap/opu/odata/ENS/PMAPP_SRV/OrderComplete?AUFNR='820604'&CANCEL=true&MUSER='KAMAL'&DEVICEID='79803294809283409'&DEVICESNO='9878zxsdas9979898'&UDID='89729872384987987'
                NSString *parameterString = [NSString stringWithFormat:@"AUFNR=%@&CANCEL=true&MUSER='%@'&UDID='18523416-177F-4B9B-9250-4F7A90A89537'",qumnumList,[decryptedUserName uppercaseString]];
                self.connectionRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@:%@%@%@?%@&$format=json",[defaults objectForKey:@"HOST"],[defaults objectForKey:@"PORT"],URL_PATH_ODATA,URL_CANCEL_ORDER_ODATA,parameterString]]];
            }
            
            self.resultDelegate = delegate;
            
            break;
            
        case ORDER_CONFIRM:
 
            self.dataType = NORMAL_DATA;
            self.requestType = requestId;
            self.resultDelegate = delegate;
            
            if (![[NSUserDefaults standardUserDefaults] objectForKey:@"CSRF"]) {
                
                [self performSelectorInBackground:@selector(createSession:) withObject:[NSMutableArray arrayWithObjects:[NSNumber numberWithInt:requestId],parameters, nil]];
                
                return;
            }
            
            self.connectionRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@:%@%@/%@",URL_HOST,URL_PORT,URL_PATH_ODATA,[parameters objectForKey:@"URL_ENDPOINT"]]] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:180.0];
            
            self.resultDelegate = delegate;
            
            if (1) {
                NSMutableString *soapString = [[NSMutableString alloc] init];
                //[soapString appendString:[self mxmlPrefix:requestId]];
                [soapString appendString:[self mxmlBodyWithKeys:parameters Values:nil Action:[self actionWithWebServiceRequest:requestId]]];
                //[soapString appendString:[self mxmlSuffix]];
                NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapString length]];
                [self.connectionRequest setValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"CSRF"] forHTTPHeaderField:@"x-csrf-token"];
                [self.connectionRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
                [self.connectionRequest setValue:@"application/json" forHTTPHeaderField:@"Accept"];
                [self.connectionRequest addValue:msgLength forHTTPHeaderField:@"Content-Length"];
                
                [self decryptforBasicAuth];
                
                NSString *authStr = [NSString stringWithFormat:@"%@:%@",decryptedUserName,decryptedPassword];
                
                NSData *authData = [authStr dataUsingEncoding:NSUTF8StringEncoding];
                
                NSString *authValue = [authData base64EncodedStringWithOptions:0];
                
                [self.connectionRequest addValue:[NSString stringWithFormat:@"Basic %@",authValue] forHTTPHeaderField:@"Authorization"];
                
                [self.connectionRequest setHTTPMethod: @"POST"];
                [self.connectionRequest setHTTPBody:[soapString dataUsingEncoding:NSUTF8StringEncoding]];
            }
            break;
            
            break;
            
        case GET_LIST_OF_PM_BOMS:
            
            self.dataType = NORMAL_DATA;
            self.requestType = requestId;
            
            if ([parameters objectForKey:@"REPORTEDBY"])
            {
                
                NSMutableString *requestString=[NSMutableString new];
                 [requestString appendFormat:@"%@:%@%@/%@",URL_HOST,URL_PORT,URL_PATH_ODATA,[parameters objectForKey:@"URL_ENDPOINT"]];
                
                self.connectionRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:requestString] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:180.0];
 
                [self decryptforBasicAuth];
                
                [self.connectionRequest setValue:[NSString stringWithFormat:@"%@",[parameters objectForKey:@"TRANSMITTYPE"]] forHTTPHeaderField:@"IvTransmitType"];
                
                [self.connectionRequest setValue:[NSString stringWithFormat:@"%@",decryptedUserName] forHTTPHeaderField:@"Muser"];
                
                [self.connectionRequest setValue:@"" forHTTPHeaderField:@"Devicesno"];
                
                [self.connectionRequest setValue:@"18523416-177F-4B9B-9250-4F7A90A89537" forHTTPHeaderField:@"Deviceid"];
                [self.connectionRequest setValue:@"" forHTTPHeaderField:@"Udid"];
 
                 [self.connectionRequest setValue:[NSString stringWithFormat:@"%@",[parameters objectForKey:@"EQUIPNO"]] forHTTPHeaderField:@"IvEqNo"];
                
                 [self.connectionRequest setValue:[NSString stringWithFormat:@"%@",[parameters objectForKey:@"EQUIPDESCRIP"]] forHTTPHeaderField:@"IvEqDesc"];
                
                [self.connectionRequest setValue:[NSString stringWithFormat:@"%@",decryptedUserName] forHTTPHeaderField:@"ivuser"];
 
                NSString *authStr = [NSString stringWithFormat:@"%@:%@",[parameters objectForKey:@"REPORTEDBY"],decryptedPassword];
                
                NSData *authData = [authStr dataUsingEncoding:NSUTF8StringEncoding];
                
                NSString *authValue = [authData base64EncodedStringWithOptions:0];
                
                [self.connectionRequest addValue:[NSString stringWithFormat:@"Basic %@",authValue] forHTTPHeaderField:@"Authorization"];
 
            }
            
             self.resultDelegate = delegate;
 
            break;
            
         case JSA_VALUE_HELPS:
            
            self.dataType = NORMAL_DATA;
            self.requestType = requestId;
            
            if ([parameters objectForKey:@"REPORTEDBY"])
            {
                
                NSMutableString *requestString=[NSMutableString new];
                [requestString appendFormat:@"%@:%@%@/%@",URL_HOST,URL_PORT,URL_PATH_ODATA,[parameters objectForKey:@"URL_ENDPOINT"]];
                
                self.connectionRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:requestString]];
                
                [self decryptforBasicAuth];
                
                [self.connectionRequest setValue:[NSString stringWithFormat:@"%@",[parameters objectForKey:@"TRANSMITTYPE"]] forHTTPHeaderField:@"IvTransmitType"];
                
                [self.connectionRequest setValue:[NSString stringWithFormat:@"%@",decryptedUserName] forHTTPHeaderField:@"Muser"];
                
                [self.connectionRequest setValue:@"12345" forHTTPHeaderField:@"Devicesno"];
                
                [self.connectionRequest setValue:@"18523416-177F-4B9B-9250-4F7A90A89537" forHTTPHeaderField:@"Deviceid"];
                [self.connectionRequest setValue:@"" forHTTPHeaderField:@"Udid"];
                
                
                [self.connectionRequest setValue:[NSString stringWithFormat:@"%@",decryptedUserName] forHTTPHeaderField:@"ivuser"];
                
                NSString *authStr = [NSString stringWithFormat:@"%@:%@",[parameters objectForKey:@"REPORTEDBY"],decryptedPassword];
                
                NSData *authData = [authStr dataUsingEncoding:NSUTF8StringEncoding];
                
                NSString *authValue = [authData base64EncodedStringWithOptions:0];
                
                [self.connectionRequest addValue:[NSString stringWithFormat:@"Basic %@",authValue] forHTTPHeaderField:@"Authorization"];
                
                NSLog(@"Request is %@",self.connectionRequest);
                
            }
            
            self.resultDelegate = delegate;
            
            break;
            
        case UTILITY_RESERVE:
            
            self.dataType = NORMAL_DATA;
            self.requestType = requestId;
            self.resultDelegate = delegate;
 
            if (![[NSUserDefaults standardUserDefaults] objectForKey:@"CSRF"]) {
                
                [self performSelectorInBackground:@selector(createSession:) withObject:[NSMutableArray arrayWithObjects:[NSNumber numberWithInt:requestId],parameters, nil]];
                
                return;
            }
            
             self.connectionRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@:%@%@/%@",URL_HOST,URL_PORT,URL_PATH_ODATA,[parameters objectForKey:@"URL_ENDPOINT"]]]];
            
              self.resultDelegate = delegate;
 
            if (1) {
                NSMutableString *soapString = [[NSMutableString alloc] init];
                //[soapString appendString:[self mxmlPrefix:requestId]];
                [soapString appendString:[self mxmlBodyWithKeys:parameters Values:nil Action:[self actionWithWebServiceRequest:requestId]]];
                //[soapString appendString:[self mxmlSuffix]];
                NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapString length]];
                [self.connectionRequest setValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"CSRF"] forHTTPHeaderField:@"x-csrf-token"];
                [self.connectionRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
                [self.connectionRequest setValue:@"application/json" forHTTPHeaderField:@"Accept"];
                [self.connectionRequest addValue:msgLength forHTTPHeaderField:@"Content-Length"];
                
                [self decryptforBasicAuth];
                
                NSString *authStr = [NSString stringWithFormat:@"%@:%@",decryptedUserName,decryptedPassword];
                
                NSData *authData = [authStr dataUsingEncoding:NSUTF8StringEncoding];
                
                NSString *authValue = [authData base64EncodedStringWithOptions:0];
                
                [self.connectionRequest addValue:[NSString stringWithFormat:@"Basic %@",authValue] forHTTPHeaderField:@"Authorization"];
                
                [self.connectionRequest setHTTPMethod: @"POST"];
                [self.connectionRequest setHTTPBody:[soapString dataUsingEncoding:NSUTF8StringEncoding]];
                
             }
 
            break;
            
        case GET_STOCK_DATA:
            self.dataType = NORMAL_DATA;
            self.requestType = requestId;
            if ([parameters objectForKey:@"PLANTFROM"]) {
                NSMutableString *parameterString = [[NSMutableString alloc] initWithString:@""];
                if ([[parameters objectForKey:@"PLANTFROM"] length] && [[parameters objectForKey:@"PLANTTO"] length]) {
                    [parameterString appendFormat:@"Werks ge '%@' and Werks le '%@'",[parameters objectForKey:@"PLANTFROM"],[parameters objectForKey:@"PLANTTO"]];
                }
                else if([[parameters objectForKey:@"PLANTFROM"] length])
                {
                    [parameterString appendFormat:@"Werks eq '%@'",[parameters objectForKey:@"PLANTFROM"]];
                }
                else if([[parameters objectForKey:@"PLANTTO"] length])
                {
                    [parameterString appendFormat:@"Werks le '%@'",[parameters objectForKey:@"PLANTTO"]];
                }
                
                if ([[parameters objectForKey:@"STORAGELOCFROM"] length] && [[parameters objectForKey:@"STORAGELOCTO"] length]) {
                    [parameterString appendString:@" and "];
                    
                    [parameterString appendFormat:@"Lgort ge '%@' and Lgort le '%@'",[parameters objectForKey:@"STORAGELOCFROM"],[parameters objectForKey:@"STORAGELOCTO"]];
                }
                else if([[parameters objectForKey:@"STORAGELOCFROM"] length])
                {
                    [parameterString appendString:@" and "];
                    
                    [parameterString appendFormat:@"Lgort eq '%@'",[parameters objectForKey:@"STORAGELOCFROM"]];
                }
                else if([[parameters objectForKey:@"STORAGELOCTO"] length])
                {
                    [parameterString appendString:@" and "];
                    
                    [parameterString appendFormat:@"Lgort le '%@'",[parameters objectForKey:@"STORAGELOCTO"]];
                }
                
                if ([[parameters objectForKey:@"MATERIALDESC"] length]) {
                    [parameterString appendString:@" and "];
                    
                    [parameterString appendFormat:@"Maktx eq '%@'",[parameters objectForKey:@"MATERIALDESC"]];
                }
                
                //StockDataCollection?$filter=Werks%20ge%20%271000%27%20and%20Werks%20le%20%272000%27
                self.connectionRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@:%@%@%@?$filter=%@&$format=json",[defaults objectForKey:@"HOST"],[defaults objectForKey:@"PORT"],URL_PATH_ODATA,URL_GET_STOCK_DATA_ODATA,[Request encodeToPercentEscapeString:parameterString]]]];
            }
            
            self.resultDelegate = delegate;
            
            break;
            
        case GET_LOG_DATA:
         
            self.dataType = NORMAL_DATA;
            self.requestType = requestId;
            
            if ([parameters objectForKey:@"REPORTEDBY"])
            {
                
                NSMutableString *requestString=[NSMutableString new];
                [requestString appendFormat:@"%@:%@%@/%@",URL_HOST,URL_PORT,URL_PATH_ODATA,[parameters objectForKey:@"URL_ENDPOINT"]];
                
                self.connectionRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:requestString]];
                
                [self decryptforBasicAuth];
 
                [self.connectionRequest setValue:[NSString stringWithFormat:@"%@",decryptedUserName] forHTTPHeaderField:@"Muser"];
                
                [self.connectionRequest setValue:@"" forHTTPHeaderField:@"Devicesno"];
                
                [self.connectionRequest setValue:@"18523416-177F-4B9B-9250-4F7A90A89537" forHTTPHeaderField:@"Deviceid"];
                [self.connectionRequest setValue:@"" forHTTPHeaderField:@"Udid"];
                
                [self.connectionRequest setValue:[NSString stringWithFormat:@"%@",decryptedUserName] forHTTPHeaderField:@"ivuser"];
                
                NSString *authStr = [NSString stringWithFormat:@"%@:%@",[parameters objectForKey:@"REPORTEDBY"],decryptedPassword];
                
                NSData *authData = [authStr dataUsingEncoding:NSUTF8StringEncoding];
                
                NSString *authValue = [authData base64EncodedStringWithOptions:0];
                
                [self.connectionRequest addValue:[NSString stringWithFormat:@"Basic %@",authValue] forHTTPHeaderField:@"Authorization"];
                 NSLog(@"Request is %@",self.connectionRequest);
                
            }
             self.resultDelegate = delegate;
            break;
            
           case SET_DEVICETOKENID:
            
            self.dataType = NORMAL_DATA;
            self.requestType = requestId;
            
            if ([parameters objectForKey:@"REPORTEDBY"])
            {
                
                 NSMutableString *requestString=[NSMutableString new];
                 [requestString appendFormat:@"%@:%@%@/%@",URL_HOST,URL_PORT,URL_PATH_ODATA,[parameters objectForKey:@"URL_ENDPOINT"]];
                 self.connectionRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:requestString]];
                
                 [self decryptforBasicAuth];
                 [self.connectionRequest setValue:[NSString stringWithFormat:@"%@",decryptedUserName] forHTTPHeaderField:@"Muser"];
                 [self.connectionRequest setValue:@"12345" forHTTPHeaderField:@"Devicesno"];
                
                [self.connectionRequest setValue:@"18523416-177F-4B9B-9250-4F7A90A89537" forHTTPHeaderField:@"Deviceid"];
                [self.connectionRequest setValue:@"" forHTTPHeaderField:@"Udid"];
                
                [self.connectionRequest setValue:[NSString stringWithFormat:@"%@",decryptedUserName] forHTTPHeaderField:@"ivuser"];
                 [self.connectionRequest setValue:[parameters objectForKey:@"DEVICETOKEN"] forHTTPHeaderField:@"IvTokenid"];
                
                 NSString *authStr = [NSString stringWithFormat:@"%@:%@",[parameters objectForKey:@"REPORTEDBY"],decryptedPassword];
                 NSData *authData = [authStr dataUsingEncoding:NSUTF8StringEncoding];
                
                 NSString *authValue = [authData base64EncodedStringWithOptions:0];
                
                 [self.connectionRequest addValue:[NSString stringWithFormat:@"Basic %@",authValue] forHTTPHeaderField:@"Authorization"];
                 NSLog(@"Request is %@",self.connectionRequest);
                
            }
            self.resultDelegate = delegate;
            break;
            
        case GET_MATERIAL_AVAILABILITY_CHECK:
 
            self.dataType = NORMAL_DATA;
            self.requestType = requestId;
            self.resultDelegate = delegate;
            
            if (![[NSUserDefaults standardUserDefaults] objectForKey:@"CSRF"]) {
                
                [self performSelectorInBackground:@selector(createSession:) withObject:[NSMutableArray arrayWithObjects:[NSNumber numberWithInt:requestId],parameters, nil]];
                
                return;
            }
            
            self.connectionRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@:%@%@/%@",URL_HOST,URL_PORT,URL_PATH_ODATA,[parameters objectForKey:@"URL_ENDPOINT"]]]];
 
            if (1) {
                NSMutableString *soapString = [[NSMutableString alloc] init];
                //[soapString appendString:[self mxmlPrefix:requestId]];
                [soapString appendString:[self mxmlBodyWithKeys:parameters Values:nil Action:[self actionWithWebServiceRequest:requestId]]];
                //[soapString appendString:[self mxmlSuffix]];
                NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapString length]];
                [self.connectionRequest setValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"CSRF"] forHTTPHeaderField:@"x-csrf-token"];
                [self.connectionRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
                [self.connectionRequest setValue:@"application/json" forHTTPHeaderField:@"Accept"];
                [self.connectionRequest addValue:msgLength forHTTPHeaderField:@"Content-Length"];
                
                 [self decryptforBasicAuth];
                
                NSString *authStr = [NSString stringWithFormat:@"%@:%@",decryptedUserName,decryptedPassword];
                
                NSData *authData = [authStr dataUsingEncoding:NSUTF8StringEncoding];
                
                NSString *authValue = [authData base64EncodedStringWithOptions:0];
                
                [self.connectionRequest addValue:[NSString stringWithFormat:@"Basic %@",authValue] forHTTPHeaderField:@"Authorization"];
                
                [self.connectionRequest setHTTPMethod: @"POST"];
 
                [self.connectionRequest setHTTPBody:[soapString dataUsingEncoding:NSUTF8StringEncoding]];
                NSLog(@"%@",soapString);
            }
            
            break;
            
        case NOTIFICATION_RELEASE:
            
            self.dataType = NORMAL_DATA;
            self.requestType = requestId;
            
            if ([parameters objectForKey:@"REPORTEDBY"])
            {
                
                NSMutableString *requestString=[NSMutableString new];
                [requestString appendFormat:@"%@:%@%@/%@",URL_HOST,URL_PORT,URL_PATH_ODATA,[parameters objectForKey:@"URL_ENDPOINT"]];
                
                self.connectionRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:requestString]];
                
                [self decryptforBasicAuth];
                
                 [self.connectionRequest setValue:[parameters objectForKey:@"REPORTEDBY"] forHTTPHeaderField:@"Muser"];
                 [self.connectionRequest setValue:[parameters objectForKey:@"REPORTEDBY"] forHTTPHeaderField:@"ivuser"];
                 [self.connectionRequest setValue:@"RLNOT" forHTTPHeaderField:@"Operation"];
 
                [self.connectionRequest setValue:@"X" forHTTPHeaderField:@"IVCOMMIT"];
                
                [self.connectionRequest setValue:@"" forHTTPHeaderField:@"Devicesno"];
                
                [self.connectionRequest setValue:@"18523416-177F-4B9B-9250-4F7A90A89537" forHTTPHeaderField:@"Deviceid"];
                [self.connectionRequest setValue:@"" forHTTPHeaderField:@"Udid"];
                
                [self.connectionRequest setValue:[NSString stringWithFormat:@"%@",[parameters objectForKey:@"TRANSMITTYPE"]] forHTTPHeaderField:@"IvTransmitType"];
 
                if ([parameters objectForKey:@"ITEMS"]) {
                    NSMutableArray *objectIds = [parameters objectForKey:@"ITEMS"];
                    for (int i=0; i<[objectIds count]; i++) {
                        [self.connectionRequest setValue:[objectIds objectAtIndex:i] forHTTPHeaderField:@"qmnum"];
                    }
                }
                
                  NSString *authStr = [NSString stringWithFormat:@"%@:%@",[parameters objectForKey:@"REPORTEDBY"],decryptedPassword];
                 NSData *authData = [authStr dataUsingEncoding:NSUTF8StringEncoding];
                 NSString *authValue = [authData base64EncodedStringWithOptions:0];
                 [self.connectionRequest addValue:[NSString stringWithFormat:@"Basic %@",authValue] forHTTPHeaderField:@"Authorization"];
             }
             self.resultDelegate = delegate;
             break;
            
            case ORDER_RELEASE:
            
            self.dataType = NORMAL_DATA;
            self.requestType = requestId;
            
            if ([parameters objectForKey:@"REPORTEDBY"])
            {
                
                NSMutableString *requestString=[NSMutableString new];
                [requestString appendFormat:@"%@:%@%@/%@",URL_HOST,URL_PORT,URL_PATH_ODATA,[parameters objectForKey:@"URL_ENDPOINT"]];
                
                self.connectionRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:requestString]];
                
                [self decryptforBasicAuth];
                
                [self.connectionRequest setValue:[parameters objectForKey:@"USERNAME"] forHTTPHeaderField:@"Muser"];
                [self.connectionRequest setValue:@"12345" forHTTPHeaderField:@"Devicesno"];
                [self.connectionRequest setValue:[parameters objectForKey:@"REPORTEDBY"] forHTTPHeaderField:@"Muser"];
                
                [self.connectionRequest setValue:@"18523416-177F-4B9B-9250-4F7A90A89537" forHTTPHeaderField:@"Deviceid"];
                [self.connectionRequest setValue:@"" forHTTPHeaderField:@"Udid"];
                
                [self.connectionRequest setValue:[parameters objectForKey:@"REPORTEDBY"] forHTTPHeaderField:@"ivuser"];
                
                [self.connectionRequest setValue:@"RLORD" forHTTPHeaderField:@"Operation"];
                
                [self.connectionRequest setValue:@"X" forHTTPHeaderField:@"IVCOMMIT"];

                [self.connectionRequest setValue:[NSString stringWithFormat:@"%@",[parameters objectForKey:@"TRANSMITTYPE"]] forHTTPHeaderField:@"IvTransmitType"];
 
                if ([parameters objectForKey:@"ITEMS"]) {
                    NSMutableArray *objectIds = [parameters objectForKey:@"ITEMS"];
                    for (int i=0; i<[objectIds count]; i++) {
                     [self.connectionRequest setValue:[objectIds objectAtIndex:i] forHTTPHeaderField:@"IvAufnr"];

                    }
                }
                
                NSString *authStr = [NSString stringWithFormat:@"%@:%@",[parameters objectForKey:@"REPORTEDBY"],decryptedPassword];
                
                NSData *authData = [authStr dataUsingEncoding:NSUTF8StringEncoding];
                
                NSString *authValue = [authData base64EncodedStringWithOptions:0];
                
                [self.connectionRequest addValue:[NSString stringWithFormat:@"Basic %@",authValue] forHTTPHeaderField:@"Authorization"];
                
                NSLog(@"Request is %@",self.connectionRequest);
                
            }
             self.resultDelegate = delegate;
             break;
            
        case NOTIFICATION_POSTPONE:
            
            self.dataType = NORMAL_DATA;
            self.requestType = requestId;
            
            if ([parameters objectForKey:@"REPORTEDBY"])
            {
                
                NSMutableString *requestString=[NSMutableString new];
                [requestString appendFormat:@"%@:%@%@/%@",URL_HOST,URL_PORT,URL_PATH_ODATA,[parameters objectForKey:@"URL_ENDPOINT"]];
                
                self.connectionRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:requestString]];
                
                [self decryptforBasicAuth];
                
                [self.connectionRequest setValue:[parameters objectForKey:@"USERNAME"] forHTTPHeaderField:@"Muser"];
                [self.connectionRequest setValue:@"" forHTTPHeaderField:@"Devicesno"];
                [self.connectionRequest setValue:[parameters objectForKey:@"REPORTEDBY"] forHTTPHeaderField:@"Muser"];
                
                [self.connectionRequest setValue:@"18523416-177F-4B9B-9250-4F7A90A89537" forHTTPHeaderField:@"Deviceid"];
                [self.connectionRequest setValue:@"" forHTTPHeaderField:@"Udid"];
                
                [self.connectionRequest setValue:[parameters objectForKey:@"REPORTEDBY"] forHTTPHeaderField:@"ivuser"];
                
                [self.connectionRequest setValue:@"NOPO" forHTTPHeaderField:@"Operation"];
                
                [self.connectionRequest setValue:@"X" forHTTPHeaderField:@"IVCOMMIT"];
                
                [self.connectionRequest setValue:[NSString stringWithFormat:@"%@",[parameters objectForKey:@"TRANSMITTYPE"]] forHTTPHeaderField:@"IvTransmitType"];
                
                if ([parameters objectForKey:@"ITEMS"]) {
                    NSMutableArray *objectIds = [parameters objectForKey:@"ITEMS"];
                    for (int i=0; i<[objectIds count]; i++) {
                        [self.connectionRequest setValue:[objectIds objectAtIndex:i] forHTTPHeaderField:@"Qmnum"];
                        
                    }
                }
                
                NSString *authStr = [NSString stringWithFormat:@"%@:%@",[parameters objectForKey:@"REPORTEDBY"],decryptedPassword];
                
                NSData *authData = [authStr dataUsingEncoding:NSUTF8StringEncoding];
                
                NSString *authValue = [authData base64EncodedStringWithOptions:0];
                
                [self.connectionRequest addValue:[NSString stringWithFormat:@"Basic %@",authValue] forHTTPHeaderField:@"Authorization"];
                
                NSLog(@"Request is %@",self.connectionRequest);
                
            }
            
            self.resultDelegate = delegate;
            
            break;
            
          case GET_PERMITS_DATA:
            
            //http://115.99.229.129:8080/sap/opu/odata/EMT/PMAPP_SRV/MasterPermitsCollection?$format=json
            
            self.dataType = NORMAL_DATA;
            self.requestType = requestId;
            self.connectionRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@:%@%@%@?&$format=json",[defaults objectForKey:@"HOST"],[defaults objectForKey:@"PORT"],URL_PATH_ODATA,URL_GET_PERMITS_DATA_ODATA]]];
            self.resultDelegate = delegate;
            
            break;
            
        default:
            break;
    }
    
    [self startConnection];
}

- (void)startConnection
{
    if (self.connectionRequest){
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
        
        NSData *urlData = [NSData dataWithContentsOfURL:self.connectionRequest.URL];
        
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
   
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [dataToFileStream close];
    [[NSFileManager defaultManager] removeItemAtPath:filepathString error:nil];
    
    [Request stopRequest];
    
    [self.resultDelegate resultData:[NSDictionary dictionary] withErrorDescription:error.description  requestID:self.requestType :responseStatusCode];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSDictionary *dataDictionary;
     NSError *error;
    NSData *jsonData;
    switch (self.dataType)
    {
        case NORMAL_DATA:
            
         dataDictionary = [NSJSONSerialization JSONObjectWithData:receivedData options:NSJSONReadingAllowFragments error:&error];
            
            break;
         case LARGE_DATA:
            
            [dataToFileStream close];
            jsonData = [[NSData alloc] initWithContentsOfFile:filepathString];
            dataDictionary = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&error];
        default:
            break;
    }
 
      [self.resultDelegate resultData:dataDictionary withErrorDescription:@""  requestID:self.requestType :responseStatusCode];
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

//- (void)createSession:(NSMutableArray *)array
//{
//
//    [self decryptforBasicAuth];
//
//    NSString *urlString = @"http://172.16.213.16:8000/sap/opu/odata/sap/ZEMT_PMAPP_SRV/CrfTockenSet(' ')";
//
//    urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
//
//  //  NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
//
//      self.connectionRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
//
//     [self.connectionRequest setHTTPShouldHandleCookies:YES];
//
//     NSString *authStr = [NSString stringWithFormat:@"%@:%@",decryptedUserName,decryptedPassword];
//     NSData *authData = [authStr dataUsingEncoding:NSUTF8StringEncoding];
//     NSString *authValue = [authData base64EncodedStringWithOptions:0];
//     [self.connectionRequest addValue:[NSString stringWithFormat:@"Basic %@",authValue] forHTTPHeaderField:@"Authorization"];
//     [self.connectionRequest setValue:@"fetch" forHTTPHeaderField:@"x-csrf-token"];
//     [self.connectionRequest setHTTPMethod:@"GET"];
//
//    NSURLSession *session = [NSURLSession sharedSession];
//
//    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:self.connectionRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
//    {
//        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
//
//        if(httpResponse.statusCode == 200)
//        {
//            NSError *parseError = nil;
//            NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&parseError];
//
//             NSLog(@"The response is - %@",responseDictionary);
//
//            NSHTTPURLResponse *httpResp = (NSHTTPURLResponse*) response;
//
//            NSArray *cookies = [NSHTTPCookie cookiesWithResponseHeaderFields:[httpResp allHeaderFields] forURL:[response URL]];
//            [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookies:cookies forURL:[httpResp URL] mainDocumentURL:nil];
//            [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookieAcceptPolicy:NSHTTPCookieAcceptPolicyAlways];
//
//
//            for (NSHTTPCookie *cookie in cookies) {
//
//                NSMutableDictionary *cookieProperties = [NSMutableDictionary dictionary];
//                [cookieProperties setObject:cookie.name forKey:NSHTTPCookieName];
//                [cookieProperties setObject:cookie.value forKey:NSHTTPCookieValue];
//                [cookieProperties setObject:cookie.domain forKey:NSHTTPCookieDomain];
//                [cookieProperties setObject:cookie.path forKey:NSHTTPCookiePath];
//                [cookieProperties setObject:[NSNumber numberWithInt:(int)cookie.version] forKey:NSHTTPCookieVersion];
//
//                // set expiration to one month from now or any NSDate of your choosing
//                // this makes the cookie sessionless and it will persist across web sessions and app launches
//                /// if you want the cookie to be destroyed when your app exits, don't set this
//                [cookieProperties setObject:[NSDate dateWithTimeIntervalSinceNow:3600] forKey:NSHTTPCookieExpires];
//
//                NSHTTPCookie *cookie = [NSHTTPCookie cookieWithProperties:cookieProperties];
//                [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
//                NSLog(@"name:%@ value:%@", cookie.name, cookie.value);
//                NSData *cookieData = [NSKeyedArchiver archivedDataWithRootObject:cookie];
//                [[NSUserDefaults standardUserDefaults] setObject:cookieData forKey:@"MYSAVEDCOOKIE"];
//                [[NSUserDefaults standardUserDefaults] setObject:[[httpResp allHeaderFields] objectForKey:@"x-csrf-token"] forKey:@"CSRF"];
//                [[NSUserDefaults standardUserDefaults] synchronize];
//
//                [self performSelectorOnMainThread:@selector(callOperationsFromSessionCreation:) withObject:array waitUntilDone:NO];
//
//            }
//            if (![cookies count]) {
//                [self performSelectorOnMainThread:@selector(callErrorDelegatesFromSession:) withObject:array waitUntilDone:NO];
//            }
//         }
//        else
//        {
//            NSLog(@"Error");
//            // [self performSelectorOnMainThread:@selector(callErrorDelegatesFromSession:) withObject:array waitUntilDone:NO];
//        }
//     }];
//
//    [dataTask resume];
// }

- (void)createSession:(NSMutableArray *)array
{
    
    [self decryptforBasicAuth];
    
    NSString *urlString = @"http://172.16.213.16:8000/sap/opu/odata/sap/ZEMT_PMAPP_SRV/CrfTockenSet(' ')";
    
    urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    //  NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
    
    self.connectionRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
    
    [self.connectionRequest setHTTPShouldHandleCookies:YES];
    
    NSString *authStr = [NSString stringWithFormat:@"%@:%@",decryptedUserName,decryptedPassword];
    NSData *authData = [authStr dataUsingEncoding:NSUTF8StringEncoding];
    NSString *authValue = [authData base64EncodedStringWithOptions:0];
    [self.connectionRequest addValue:[NSString stringWithFormat:@"Basic %@",authValue] forHTTPHeaderField:@"Authorization"];
    [self.connectionRequest setValue:@"fetch" forHTTPHeaderField:@"x-csrf-token"];
    [self.connectionRequest setHTTPMethod:@"GET"];
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:self.connectionRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
                                      {
                                          NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
                                          
                                          if(httpResponse.statusCode == 200)
                                          {
                                              //NSError *parseError = nil;
                                
                                              //NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&parseError];
 
                                       NSArray *cookies = [NSHTTPCookie cookiesWithResponseHeaderFields:[httpResponse allHeaderFields] forURL:[response URL]];
                                              
                                        [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookies:cookies forURL:[httpResponse URL] mainDocumentURL:nil];
                                        
                                        [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookieAcceptPolicy:NSHTTPCookieAcceptPolicyAlways];
                                        
                                    NSMutableDictionary *cookieProperties = [NSMutableDictionary dictionary];
                                              
                                    [cookieProperties setObject:[NSDate dateWithTimeIntervalSinceNow:3600] forKey:NSHTTPCookieExpires];
 
                                    NSHTTPCookie *cookie = [NSHTTPCookie cookieWithProperties:cookieProperties];
                                              
                                    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
                                    
                                    NSData *cookieData = [NSKeyedArchiver archivedDataWithRootObject:cookie];
                                
                                    [[NSUserDefaults standardUserDefaults] setObject:cookieData forKey:@"MYSAVEDCOOKIE"];
                                    
                                    [[NSUserDefaults standardUserDefaults] setObject:[[httpResponse allHeaderFields] objectForKey:@"x-csrf-token"] forKey:@"CSRF"];
                                    
                                    [[NSUserDefaults standardUserDefaults] synchronize];
                                              
                                    [self performSelectorOnMainThread:@selector(callOperationsFromSessionCreation:) withObject:array waitUntilDone:NO];
                                              
                                    }
                                
                                    else
                                    {
                                        
                                [self performSelectorOnMainThread:@selector(callErrorDelegatesFromSession:) withObject:array waitUntilDone:NO];
                                              
                                              
                                          }
                                      }];
    
    [dataTask resume];
}


- (void)callErrorDelegatesFromSession:(NSMutableArray *)array
{
    
    [self.resultDelegate resultData:nil withErrorDescription:@"Can't Create Session" requestID:[[array objectAtIndex:0] intValue] :responseStatusCode];
    
}

- (void)callOperationsFromSessionCreation:(NSMutableArray *)array
{
    [self makeWebServiceRequest:[[array objectAtIndex:0] intValue] parameters:[array objectAtIndex:1] delegate:self.resultDelegate];
}

-(BOOL) isCookieExpired{
    
    BOOL status = YES;
    
    NSString *urlString = @"http://172.16.213.16:8000/sap/opu/odata/sap/ZEMT_PMAPP_SRV/CrfTockenSet(' ')";
    
    urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    NSArray *oldCookies = [[ NSHTTPCookieStorage sharedHTTPCookieStorage ]
                           cookiesForURL: [NSURL URLWithString:urlString]];
    
    NSHTTPCookie *cookie = [oldCookies lastObject];
    if (cookie) {
        NSDate *expiresDate =    [cookie expiresDate];
        NSDate *currentDate = [NSDate date];
        NSComparisonResult result = [currentDate compare:expiresDate];
        
        if(result==NSOrderedAscending){
            status = NO;
            NSLog(@"expiresDate is in the future");
        }
        else if(result==NSOrderedDescending){
            NSLog(@"expiresDate is in the past");
        }
        else{
            status = NO;
            NSLog(@"Both dates are the same");
        }
    }
    
    return status;
}

-(void)setCookieswithRequestid:(WebServiceRequest)requestId forParamerters:(NSDictionary *)parameters
{
    
    NSData *cookieData = [[NSUserDefaults standardUserDefaults] objectForKey:@"MYSAVEDCOOKIE"];
    
    if ([cookieData length]) {
        NSHTTPCookie *cookie = [NSKeyedUnarchiver unarchiveObjectWithData:cookieData];
        if ([cookie.expiresDate compare:[NSDate date]] == NSOrderedDescending) {
            [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
        }
        else
        {
            [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
            
            [self performSelectorInBackground:@selector(createSession:) withObject:[NSMutableArray arrayWithObjects:[NSNumber numberWithInt:requestId],parameters, nil]];
            
            return;
        }
    }
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
            
        default:
            return @"";
    }
}

#pragma mark -
#pragma mark xml methods

- (NSString *)mxmlPrefix:(WebServiceRequest)requestID{
//    NSString *string = @"<?xml version=\"1.0\" encoding=\"utf-8\"?>";
//    string = [string stringByAppendingString:@"<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" "];
//    string = [string stringByAppendingString:@"xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" "];
//    string = [string stringByAppendingString:@"xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">"];
//    string = [string stringByAppendingString:@"<soap:Body>"];
    
    //    switch (requestID) {
    //        case UTILITY_RESERVE:
    //            return @"<soap:Envelope xmlns:soap=\"http://www.w3.org/2003/05/soap-envelope\" xmlns:urn=\"urn:sap-com:document:sap:soap:functions:mc-style\"><soap:Header/><soap:Body>";
    //            break;
    //
    //        default:
    return @"<soap:Envelope xmlns:soap=\"http://www.w3.org/2003/05/soap-envelope\" xmlns:urn=\"urn:sap-com:document:sap:soap:functions:mc-style\"><soap:Header/><soap:Body>";
    //  break;
    //    }
}

- (NSString *)mxmlSuffix{
//    NSString *string=@"</soap:Body>";
//    string = [string stringByAppendingString:@"</soap:Envelope>"];
    return @"</soap:Body></soap:Envelope>";
}

-(void)decryptforBasicAuth{
    
    NSString *key = @"";
    // NSLog(@"total key is %@",key);
    NSString *str_UserName = [defaults objectForKey:@"userName"];
    decryptedUserName = [str_UserName AES128DecryptWithKey:key];
    NSString *str_Pasword = [defaults objectForKey:@"password"];
    decryptedPassword = [str_Pasword AES128DecryptWithKey:key];
    
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

- (NSString *)mxmlBodyWithKeys:(NSDictionary *)requestData Values:(NSArray *)values Action:(NSString *)action{
    
    NSMutableString *soapMessage = [[NSMutableString alloc] initWithString:@""];
    //[soapMessage appendString:[NSString stringWithFormat:@"<%@>",action]];
    
    switch (self.requestType) {
            
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
        case USER_DATA:
            
            break;
        case FUNCTIONLOC_COSTCENTER:
            
            break;
            
        case FUNCTIONLOC_EQUIPMENT:
          
            break;
            
        case EQUIPMENT_COSTCENTER:
            
            break;
            
        case EQUIPMENT_FUNCLOC:
            
            break;
            
        case NOTIFICATION_CREATE:
            
            if (requestData.count) {
                
              NSMutableArray *headerFieldsItems = [[NSMutableArray alloc] init];
                
              NSMutableArray *headerCustomfieldsItems = [[NSMutableArray alloc] init];
                
              NSMutableArray *notificationItems = [[NSMutableArray alloc] init];
                
              NSMutableArray *notificationActivityItems = [[NSMutableArray alloc] init];
                
              NSMutableArray *attachmentsItems = [[NSMutableArray alloc] init];
                
                NSMutableArray *longTextItems = [[NSMutableArray alloc] init];


                 if ([[requestData objectForKey:@"ATTACHMENTS"] count]) {
 
                     NSArray *attachmentsArray = [requestData objectForKey:@"ATTACHMENTS"];
                     for (int i =0; i<[attachmentsArray count]; i++) {
 
                         NSString *objectidString=@"";
                         
                         if (![NullChecker isNull:[requestData objectForKey:@"OBJECTID"]]) {
                             
                              objectidString=[requestData objectForKey:@"OBJECTID"];
                         }
                         
                      [attachmentsItems addObject:[NSMutableDictionary dictionaryWithObjects:[NSArray arrayWithObjects:objectidString,@"Q",@"QH",[[attachmentsArray objectAtIndex:i] objectAtIndex:3],[[attachmentsArray objectAtIndex:i] objectAtIndex:4],[[attachmentsArray objectAtIndex:i] objectAtIndex:5],[[attachmentsArray objectAtIndex:i] objectAtIndex:7],@"",@"",[[attachmentsArray objectAtIndex:i] objectAtIndex:2], nil] forKeys:[NSArray arrayWithObjects:@"Zobjid",@"Zdoctype",@"ZdoctypeItem",@"Filename",@"Filetype",@"Fsize",@"Content",@"DocId",@"DocType",@"Objtype", nil]]];
                    }
                }
                
                
                if ([[requestData objectForKey:@"LONGTEXT"] length]) {
 
                    NSArray *longTextArray = [[requestData objectForKey:@"LONGTEXT"] componentsSeparatedByString:@"\n"];
                    
                    for (int i=0; i<[longTextArray count]; i++) {
                        
                         [longTextItems addObject:[NSMutableDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"",@"",@"",[longTextArray objectAtIndex:i], nil] forKeys:[NSArray arrayWithObjects:@"Qmnum",@"Objtype",@"Objkey",@"TextLine", nil]]];
                        
                       }
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
                    reqStartDate=[tempString substringToIndex:8];
                    reqStartTime=[tempString substringFromIndex:9];
                    
                }
                else{
                    reqStartDate=@"00000000";
                    reqStartTime=@"000000";
                }
                
                if ([[requestData objectForKey:@"REDATE"] length]) {
                    reqEndDate=[[requestData objectForKey:@"REDATE"] substringToIndex:8];
                    reqEndTime=[[requestData objectForKey:@"REDATE"] substringFromIndex:9];
                }
                else{
                    reqEndDate=@"00000000";
                    reqEndTime=@"000000";
                }
                
                 if ([[requestData objectForKey:@"SDATE"] length]) {
                    reqMStartDate=[[requestData objectForKey:@"SDATE"] substringToIndex:8];
                    reqMStartTime=[[requestData objectForKey:@"SDATE"] substringFromIndex:9];
                }
                else{
                    reqMStartDate=@"00000000";
                    reqMStartTime=@"000000";
                }
                
                if ([[requestData objectForKey:@"EDATE"] length]) {
                    reqMEndDate=[[requestData objectForKey:@"EDATE"] substringToIndex:8];
                    reqMEndTime=[[requestData objectForKey:@"EDATE"] substringFromIndex:9];
                }
                else{
                    reqMEndDate=@"00000000";
                    reqMEndTime=@"000000";
                }
                
              [headerCustomfieldsItems addObject:[NSMutableDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"",@"",@"",@"",@"",@"",@"",@"",@"", nil] forKeys:[NSArray arrayWithObjects:@"Zdoctype",@"ZdoctypeItem",@"Tabname",@"Fieldname",@"Datatype",@"Value",@"Flabel",@"Sequence",@"Length", nil]]];
                
             [headerFieldsItems addObject:[NSMutableDictionary dictionaryWithObjects:[NSArray arrayWithObjects:[requestData objectForKey:@"NID"],[requestData objectForKey:@"SHORTTEXT"],[requestData objectForKey:@"FID"],[requestData objectForKey:@"EQID"],[requestData objectForKey:@"REPORTEDBY"],reqMStartDate,reqMEndDate,reqMStartTime,reqMEndTime,[requestData objectForKey:@"BREAKDOWN"],[requestData objectForKey:@"NPID"],[requestData objectForKey:@"PLANNERGROUP"],workCenterString,str_Plant,reqStartDate,reqEndDate,reqStartTime,reqEndTime,[requestData objectForKey:@"AUFNR"],[requestData objectForKey:@"PARNRID"],[requestData objectForKey:@"PARNRTEXT"],[requestData objectForKey:@"DOCS"],@"00000000",[requestData objectForKey:@"PLANNERGROUPNAME"],[requestData objectForKey:@"EFFECTID"],[requestData objectForKey:@"SHIFT"],[NSNumber numberWithInt:[[requestData objectForKey:@"NOOFPERSON"] intValue]],@"00000000",[requestData objectForKey:@"USR01"],[requestData objectForKey:@"USR02"],headerCustomfieldsItems, nil] forKeys:[NSArray arrayWithObjects:@"NotifType",@"NotifShorttxt",@"FunctionLoc",@"Equipment",@"ReportedBy",@"MalfuncStdate",@"MalfuncEddate",@"MalfuncSttime",@"MalfuncEdtime",@"BreakdownInd",@"Priority",@"Ingrp",@"Arbpl",@"Werks", @"Strmn",@"Ltrmn",@"Strur",@"Ltrur",@"Aufnr",@"ParnrVw",@"NameVw",@"Docs",@"Createdon",@"Ingrpname",@"Auswk",@"Shift",@"Noofperson",@"Qmdat",@"Usr01",@"Usr02",@"ItNotifHeaderFields",nil]]];
 
                if ([[requestData objectForKey:@"ITEMS"] count]) {
                   
                    NSArray *causeCodeDetailsArray = [requestData objectForKey:@"ITEMS"];
                    for (int i = 0; i<[causeCodeDetailsArray count]; i++) {
                     NSMutableArray *firstCustomItems = [[NSMutableArray alloc] init];
                  // NSMutableArray *secondCustomItems = [[NSMutableArray alloc] init];
                  for (int x = 0; x<[[[causeCodeDetailsArray objectAtIndex:i] objectAtIndex:1] count]; x++) {
                     [firstCustomItems addObject:[NSMutableDictionary dictionaryWithObjects:[NSArray arrayWithObjects:[[[[causeCodeDetailsArray objectAtIndex:i] objectAtIndex:1] objectAtIndex:x] objectAtIndex:1],[[[[causeCodeDetailsArray objectAtIndex:i] objectAtIndex:1] objectAtIndex:x] objectAtIndex:2],[[[[causeCodeDetailsArray objectAtIndex:i] objectAtIndex:1] objectAtIndex:x] objectAtIndex:3],[[[[causeCodeDetailsArray objectAtIndex:i] objectAtIndex:1] objectAtIndex:x] objectAtIndex:4],[[[[causeCodeDetailsArray objectAtIndex:i] objectAtIndex:1] objectAtIndex:x] objectAtIndex:5],[[[[causeCodeDetailsArray objectAtIndex:i] objectAtIndex:1] objectAtIndex:x] objectAtIndex:6],[[[[causeCodeDetailsArray objectAtIndex:i] objectAtIndex:1] objectAtIndex:x] objectAtIndex:7],[[[[causeCodeDetailsArray objectAtIndex:i] objectAtIndex:1] objectAtIndex:x] objectAtIndex:8],nil] forKeys:[NSArray arrayWithObjects:@"Zdoctype",@"ZdoctypeItem",@"Tabname",@"Fieldname",@"Value",@"Flabel",@"Datatype",@"Sequence",@"Length", nil]]];
                      }
                        
//                    for (int x = 0; x<[[[causeCodeDetailsArray objectAtIndex:i] lastObject] count]; x++) {
//
//                     [secondCustomItems addObject:[NSMutableDictionary dictionaryWithObjects:[NSArray arrayWithObjects:[[[[causeCodeDetailsArray objectAtIndex:i] lastObject] objectAtIndex:x] objectAtIndex:1],[[[[causeCodeDetailsArray objectAtIndex:i] lastObject] objectAtIndex:x] objectAtIndex:2],[[[[causeCodeDetailsArray objectAtIndex:i] lastObject] objectAtIndex:x] objectAtIndex:3],[[[[causeCodeDetailsArray objectAtIndex:i] lastObject] objectAtIndex:x] objectAtIndex:4],[[[[causeCodeDetailsArray objectAtIndex:i] lastObject] objectAtIndex:x] objectAtIndex:5],[[[[causeCodeDetailsArray objectAtIndex:i] lastObject] objectAtIndex:x] objectAtIndex:6],[[[[causeCodeDetailsArray objectAtIndex:i] lastObject] objectAtIndex:x] objectAtIndex:7],[[[[causeCodeDetailsArray objectAtIndex:i] lastObject] objectAtIndex:x] objectAtIndex:8],nil] forKeys:[NSArray arrayWithObjects:@"Zdoctype",@"ZdoctypeItem",@"Tabname",@"Fieldname",@"Value",@"Flabel",@"Datatype",@"Sequence",@"Length", nil]]];
//                      }
                        
 
                    [notificationItems addObject:[NSMutableDictionary dictionaryWithObjects:[NSArray arrayWithObjects:[[[causeCodeDetailsArray objectAtIndex:i] firstObject] objectAtIndex:16],[[[causeCodeDetailsArray objectAtIndex:i] firstObject] objectAtIndex:18],[[[causeCodeDetailsArray objectAtIndex:i] firstObject] objectAtIndex:17],[[[causeCodeDetailsArray objectAtIndex:i] firstObject] objectAtIndex:19],[[[causeCodeDetailsArray objectAtIndex:i] firstObject] objectAtIndex:2],[[[causeCodeDetailsArray objectAtIndex:i] firstObject] objectAtIndex:12],[[[causeCodeDetailsArray objectAtIndex:i] firstObject] objectAtIndex:4],[[[causeCodeDetailsArray objectAtIndex:i] firstObject] objectAtIndex:10],[[[causeCodeDetailsArray objectAtIndex:i] firstObject] objectAtIndex:13],[[[causeCodeDetailsArray objectAtIndex:i] firstObject] objectAtIndex:6],[[[causeCodeDetailsArray objectAtIndex:i] firstObject] objectAtIndex:8],[[[causeCodeDetailsArray objectAtIndex:i] firstObject] objectAtIndex:11],@"I",firstCustomItems, nil] forKeys:[NSArray arrayWithObjects:@"ItempartGrp",@"Partgrptext",@"ItempartCod",@"Partcodetext",@"ItemdefectGrp",@"ItemKey",@"ItemdefectCod",@"ItemdefectShtxt",@"CauseKey",@"CauseGrp",@"CauseCod",@"CauseShtxt",@"Action",@"ItNotifItemsFields", nil]]];
                     }
                  }
 
                if ([[requestData objectForKey:@"ACTIVITIES"] count]) {
                    
                    NSArray *activityDetailsArray = [requestData objectForKey:@"ACTIVITIES"];
                    
                    for (int i = 0; i<[activityDetailsArray count]; i++) {
                        
                        [notificationActivityItems addObject:[NSMutableDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"",[[activityDetailsArray objectAtIndex:i] objectForKey:@"notificationa_ItemKey"],@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",[[activityDetailsArray objectAtIndex:i] objectForKey:@"notificationa_ActvGrp"],[[activityDetailsArray objectAtIndex:i] objectForKey:@"notificationa_ActvCod"],[[activityDetailsArray objectAtIndex:i] objectForKey:@"notificationa_Actcodetext"],[[activityDetailsArray objectAtIndex:i] objectForKey:@"notificationa_ActvShtxt"],@"I",[[activityDetailsArray objectAtIndex:i] objectForKey:@"Usr01"],[[activityDetailsArray objectAtIndex:i] objectForKey:@"Usr02"],[[activityDetailsArray objectAtIndex:i] objectForKey:@"Usr03"],[[activityDetailsArray objectAtIndex:i] objectForKey:@"Usr04"],@"", nil] forKeys:[NSArray arrayWithObjects:@"Qmnum",@"ItemKey",@"ItempartGrp",@"Partgrptext",@"ItempartCod",@"Partcodetext",@"ItemdefectGrp",@"Defectgrptext",@"ItemdefectCod",@"Defectcodetext",@"ItemdefectShtxt",@"CauseKey",@"ActvKey",@"ActvGrp",@"ActvCod",@"Actcodetext",@"ActvShtxt",@"Action",@"Usr01",@"Usr02",@"Usr03",@"Usr04",@"Usr05", nil]]];
                        
                    }
                 }
                
                
                NSMutableDictionary *notificationCreate = [[NSMutableDictionary alloc] init];
                 NSMutableArray *etNotifHeaderItems=[NSMutableArray new];
                 NSMutableArray *etNotifDupItems=[NSMutableArray new];
                 NSMutableArray *etNotifMessageItems=[NSMutableArray new];
                 NSMutableArray *etNotifCauseCodeItems=[NSMutableArray new];
                 NSMutableArray *etNotifStatusItems=[NSMutableArray new];
                 NSMutableArray *etNotifActivityItems=[NSMutableArray new];
                 NSMutableArray *etLongtextItems=[NSMutableArray new];
                 NSMutableArray *etDocsItems=[NSMutableArray new];

 
                 [etNotifHeaderItems addObject:[NSMutableDictionary dictionaryWithObjects:[NSArray array] forKeys:[NSArray array]]];
                 [etNotifDupItems addObject:[NSMutableDictionary dictionaryWithObjects:[NSArray array] forKeys:[NSArray array]]];
                 [etNotifMessageItems addObject:[NSMutableDictionary dictionaryWithObjects:[NSArray array] forKeys:[NSArray array]]];
                 [etNotifCauseCodeItems addObject:[NSMutableDictionary dictionaryWithObjects:[NSArray array] forKeys:[NSArray array]]];
                 [etNotifStatusItems addObject:[NSMutableDictionary dictionaryWithObjects:[NSArray array] forKeys:[NSArray array]]];
                 [etLongtextItems addObject:[NSMutableDictionary dictionaryWithObjects:[NSArray array] forKeys:[NSArray array]]];
                
                [etDocsItems addObject:[NSMutableDictionary dictionaryWithObjects:[NSArray array] forKeys:[NSArray array]]];

            

                BOOL isCommit=true;
 
                [notificationCreate setObject:headerFieldsItems forKey:@"ItNotifHeader"];
                [notificationCreate setObject:notificationItems forKey:@"ItNotifItems"];
                [notificationCreate setObject:notificationActivityItems forKey:@"ItNotifActvs"];
                [notificationCreate setObject:[[requestData objectForKey:@"REPORTEDBY"] uppercaseString] forKey:@"IvUser"];
                [notificationCreate setObject:attachmentsItems forKey:@"ItDocs"];
                [notificationCreate setObject:longTextItems forKey:@"ItNotifLongtext"];
                 [notificationCreate setObject:[[requestData objectForKey:@"REPORTEDBY"] uppercaseString] forKey:@"Muser"];
                [notificationCreate setObject:@"18523416-177F-4B9B-9250-4F7A90A89537" forKey:@"Deviceid"];
                [notificationCreate setObject:@"" forKey:@"Udid"];
                [notificationCreate setObject:[requestData objectForKey:@"TRANSMITTYPE"] forKey:@"IvTransmitType"];
                [notificationCreate setObject:[NSNumber numberWithBool:isCommit] forKey:@"IvCommit"];
                [notificationCreate setObject:@"CRNOT" forKey:@"Operation"];
 
                
                //For Response Data need to send  empty in ETformat
                [notificationCreate setObject:etNotifHeaderItems forKey:@"EtNotifHeader"];
                [notificationCreate setObject:etNotifStatusItems forKey:@"EtNotifStatus"];
                [notificationCreate setObject:etNotifDupItems forKey:@"EtNotifDup"];
                [notificationCreate setObject:etNotifCauseCodeItems forKey:@"EtNotifItems"];
                [notificationCreate setObject:etNotifActivityItems forKey:@"EtNotifActvs"];
                [notificationCreate setObject:etLongtextItems forKey:@"EtNotifLongtext"];
                [notificationCreate setObject:etNotifMessageItems forKey:@"EvMessage"];
                [notificationCreate setObject:etDocsItems forKey:@"EtDocs"];

 
                NSError *error;
                NSData *jsonData = [NSJSONSerialization dataWithJSONObject:notificationCreate options:NSJSONWritingPrettyPrinted error:&error];
                NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                [soapMessage appendString:jsonString];
                
            }
            
            break;
            
        case NOTIFICATION_CHANGE:
        
        if (requestData.count) {
            
            NSMutableArray *headerFieldsItems = [[NSMutableArray alloc] init];
            
            NSMutableArray *headerCustomfieldsItems = [[NSMutableArray alloc] init];
            
            NSMutableArray *notificationItems = [[NSMutableArray alloc] init];
            
            NSMutableArray *notificationActivityItems = [[NSMutableArray alloc] init];
            
            NSMutableArray *attachmentsItems = [[NSMutableArray alloc] init];
            
            NSMutableArray *longTextItems = [[NSMutableArray alloc] init];

            
            if ([[requestData objectForKey:@"ATTACHMENTS"] count]) {
                
                NSArray *attachmentsArray = [requestData objectForKey:@"ATTACHMENTS"];
                for (int i =0; i<[attachmentsArray count]; i++) {
                    
                    [attachmentsItems addObject:[NSMutableDictionary dictionaryWithObjects:[NSArray arrayWithObjects:[requestData objectForKey:@"OBJECTID"],@"Q",@"QH",[[attachmentsArray objectAtIndex:i] objectAtIndex:3],[[attachmentsArray objectAtIndex:i] objectAtIndex:4],[[attachmentsArray objectAtIndex:i] objectAtIndex:5],[[attachmentsArray objectAtIndex:i] objectAtIndex:7],@"",@"",[[attachmentsArray objectAtIndex:i] objectAtIndex:2], nil] forKeys:[NSArray arrayWithObjects:@"Zobjid",@"Zdoctype",@"ZdoctypeItem",@"Filename",@"Filetype",@"Fsize",@"Content",@"DocId",@"DocType",@"Objtype", nil]]];
                }
            }
            
            if ([[requestData objectForKey:@"LONGTEXT"] length]) {
                
                NSArray *longTextArray = [[requestData objectForKey:@"LONGTEXT"] componentsSeparatedByString:@"\n"];
                
                for (int i=0; i<[longTextArray count]; i++) {
                    
                    [longTextItems addObject:[NSMutableDictionary dictionaryWithObjects:[NSArray arrayWithObjects:[requestData objectForKey:@"OBJECTID"],@"",@"",[longTextArray objectAtIndex:i], nil] forKeys:[NSArray arrayWithObjects:@"Qmnum",@"Objtype",@"Objkey",@"TextLine", nil]]];
                    
                }
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
                reqStartDate=[tempString substringToIndex:8];
                reqStartTime=[tempString substringFromIndex:9];
                
            }
            else{
                reqStartDate=@"00000000";
                reqStartTime=@"000000";
            }
            
            if ([[requestData objectForKey:@"REDATE"] length]) {
                reqEndDate=[[requestData objectForKey:@"REDATE"] substringToIndex:8];
                reqEndTime=[[requestData objectForKey:@"REDATE"] substringFromIndex:9];
            }
            else{
                reqEndDate=@"00000000";
                reqEndTime=@"000000";
            }
            
            if ([[requestData objectForKey:@"SDATE"] length]) {
                reqMStartDate=[[requestData objectForKey:@"SDATE"] substringToIndex:8];
                reqMStartTime=[[requestData objectForKey:@"SDATE"] substringFromIndex:9];
            }
            else{
                reqMStartDate=@"00000000";
                reqMStartTime=@"000000";
            }
            
            if ([[requestData objectForKey:@"EDATE"] length]) {
                reqMEndDate=[[requestData objectForKey:@"EDATE"] substringToIndex:8];
                reqMEndTime=[[requestData objectForKey:@"EDATE"] substringFromIndex:9];
            }
            else{
                reqMEndDate=@"00000000";
                reqMEndTime=@"000000";
            }
            
            [headerCustomfieldsItems addObject:[NSMutableDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"",@"",@"",@"",@"",@"",@"",@"",@"", nil] forKeys:[NSArray arrayWithObjects:@"Zdoctype",@"ZdoctypeItem",@"Tabname",@"Fieldname",@"Datatype",@"Value",@"Flabel",@"Sequence",@"Length", nil]]];
            
            [headerFieldsItems addObject:[NSMutableDictionary dictionaryWithObjects:[NSArray arrayWithObjects:[requestData objectForKey:@"NID"],[requestData objectForKey:@"OBJECTID"],[requestData objectForKey:@"SHORTTEXT"],[requestData objectForKey:@"FID"],[requestData objectForKey:@"EQID"],[requestData objectForKey:@"REPORTEDBY"],reqMStartDate,reqMEndDate,reqMStartTime,reqMEndTime,[requestData objectForKey:@"BREAKDOWN"],[requestData objectForKey:@"NPID"],[requestData objectForKey:@"PLANNERGROUP"],workCenterString,str_Plant,reqStartDate,reqEndDate,reqStartTime,reqEndTime,[requestData objectForKey:@"AUFNR"],[requestData objectForKey:@"PARNRID"],[requestData objectForKey:@"PARNRTEXT"],[requestData objectForKey:@"DOCS"],@"00000000",[requestData objectForKey:@"PLANNERGROUPNAME"],[requestData objectForKey:@"EFFECTID"],[requestData objectForKey:@"SHIFT"],[NSNumber numberWithInt:[[requestData objectForKey:@"NOOFPERSON"] intValue]],@"00000000",[requestData objectForKey:@"USR01"],[requestData objectForKey:@"USR02"],headerCustomfieldsItems, nil] forKeys:[NSArray arrayWithObjects:@"NotifType",@"Qmnum",@"NotifShorttxt",@"FunctionLoc",@"Equipment",@"ReportedBy",@"MalfuncStdate",@"MalfuncEddate",@"MalfuncSttime",@"MalfuncEdtime",@"BreakdownInd",@"Priority",@"Ingrp",@"Arbpl",@"Werks", @"Strmn",@"Ltrmn",@"Strur",@"Ltrur",@"Aufnr",@"ParnrVw",@"NameVw",@"Docs",@"Createdon",@"Ingrpname",@"Auswk",@"Shift",@"Noofperson",@"Qmdat",@"Usr01",@"Usr02",@"ItNotifHeaderFields",nil]]];
            
            
            if ([[requestData objectForKey:@"ITEMS"] count]) {
                
                NSArray *causeCodeDetailsArray = [requestData objectForKey:@"ITEMS"];
                
                for (int i = 0; i<[causeCodeDetailsArray count]; i++) {
                    
                    NSMutableArray *firstCustomItems = [[NSMutableArray alloc] init];
                    
                    // NSMutableArray *secondCustomItems = [[NSMutableArray alloc] init];
                    
                    for (int x = 0; x<[[[causeCodeDetailsArray objectAtIndex:i] objectAtIndex:1] count]; x++) {
                        
                        [firstCustomItems addObject:[NSMutableDictionary dictionaryWithObjects:[NSArray arrayWithObjects:[[[[causeCodeDetailsArray objectAtIndex:i] objectAtIndex:1] objectAtIndex:x] objectAtIndex:1],[[[[causeCodeDetailsArray objectAtIndex:i] objectAtIndex:1] objectAtIndex:x] objectAtIndex:2],[[[[causeCodeDetailsArray objectAtIndex:i] objectAtIndex:1] objectAtIndex:x] objectAtIndex:3],[[[[causeCodeDetailsArray objectAtIndex:i] objectAtIndex:1] objectAtIndex:x] objectAtIndex:4],[[[[causeCodeDetailsArray objectAtIndex:i] objectAtIndex:1] objectAtIndex:x] objectAtIndex:5],[[[[causeCodeDetailsArray objectAtIndex:i] objectAtIndex:1] objectAtIndex:x] objectAtIndex:6],[[[[causeCodeDetailsArray objectAtIndex:i] objectAtIndex:1] objectAtIndex:x] objectAtIndex:7],[[[[causeCodeDetailsArray objectAtIndex:i] objectAtIndex:1] objectAtIndex:x] objectAtIndex:8],nil] forKeys:[NSArray arrayWithObjects:@"Zdoctype",@"ZdoctypeItem",@"Tabname",@"Fieldname",@"Value",@"Flabel",@"Datatype",@"Sequence",@"Length", nil]]];
                        
                    }
                    
                    //                    for (int x = 0; x<[[[causeCodeDetailsArray objectAtIndex:i] lastObject] count]; x++) {
                    //
                    //                     [secondCustomItems addObject:[NSMutableDictionary dictionaryWithObjects:[NSArray arrayWithObjects:[[[[causeCodeDetailsArray objectAtIndex:i] lastObject] objectAtIndex:x] objectAtIndex:1],[[[[causeCodeDetailsArray objectAtIndex:i] lastObject] objectAtIndex:x] objectAtIndex:2],[[[[causeCodeDetailsArray objectAtIndex:i] lastObject] objectAtIndex:x] objectAtIndex:3],[[[[causeCodeDetailsArray objectAtIndex:i] lastObject] objectAtIndex:x] objectAtIndex:4],[[[[causeCodeDetailsArray objectAtIndex:i] lastObject] objectAtIndex:x] objectAtIndex:5],[[[[causeCodeDetailsArray objectAtIndex:i] lastObject] objectAtIndex:x] objectAtIndex:6],[[[[causeCodeDetailsArray objectAtIndex:i] lastObject] objectAtIndex:x] objectAtIndex:7],[[[[causeCodeDetailsArray objectAtIndex:i] lastObject] objectAtIndex:x] objectAtIndex:8],nil] forKeys:[NSArray arrayWithObjects:@"Zdoctype",@"ZdoctypeItem",@"Tabname",@"Fieldname",@"Value",@"Flabel",@"Datatype",@"Sequence",@"Length", nil]]];
                    //                      }
                    
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
                    
                    [notificationItems addObject:[NSMutableDictionary dictionaryWithObjects:[NSArray arrayWithObjects:[requestData objectForKey:@"OBJECTID"],[[[causeCodeDetailsArray objectAtIndex:i] firstObject] objectAtIndex:16],[[[causeCodeDetailsArray objectAtIndex:i] firstObject] objectAtIndex:18],[[[causeCodeDetailsArray objectAtIndex:i] firstObject] objectAtIndex:17],[[[causeCodeDetailsArray objectAtIndex:i] firstObject] objectAtIndex:19],[[[causeCodeDetailsArray objectAtIndex:i] firstObject] objectAtIndex:2],[[[causeCodeDetailsArray objectAtIndex:i] firstObject] objectAtIndex:12],[[[causeCodeDetailsArray objectAtIndex:i] firstObject] objectAtIndex:4],[[[causeCodeDetailsArray objectAtIndex:i] firstObject] objectAtIndex:10],[[[causeCodeDetailsArray objectAtIndex:i] firstObject] objectAtIndex:13],[[[causeCodeDetailsArray objectAtIndex:i] firstObject] objectAtIndex:6],[[[causeCodeDetailsArray objectAtIndex:i] firstObject] objectAtIndex:8],[[[causeCodeDetailsArray objectAtIndex:i] firstObject] objectAtIndex:11],actionString,firstCustomItems, nil] forKeys:[NSArray arrayWithObjects:@"Qmnum",@"ItempartGrp",@"Partgrptext",@"ItempartCod",@"Partcodetext",@"ItemdefectGrp",@"ItemKey",@"ItemdefectCod",@"ItemdefectShtxt",@"CauseKey",@"CauseGrp",@"CauseCod",@"CauseShtxt",@"Action",@"ItNotifItemsFields", nil]]];
                    
                 }
            }
            
            if ([[requestData objectForKey:@"ACTIVITIES"] count]) {
                
                NSArray *activityDetailsArray = [requestData objectForKey:@"ACTIVITIES"];
                
                for (int i = 0; i<[activityDetailsArray count]; i++) {
                    
                    [notificationActivityItems addObject:[NSMutableDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"",[[activityDetailsArray objectAtIndex:i] objectForKey:@"notificationa_ItemKey"],@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",[[activityDetailsArray objectAtIndex:i] objectForKey:@"notificationa_ActvKey"],[[activityDetailsArray objectAtIndex:i] objectForKey:@"notificationa_ActvGrp"],[[activityDetailsArray objectAtIndex:i] objectForKey:@"notificationa_ActvCod"],[[activityDetailsArray objectAtIndex:i] objectForKey:@"notificationa_Actcodetext"],[[activityDetailsArray objectAtIndex:i] objectForKey:@"notificationa_ActvShtxt"],[[activityDetailsArray objectAtIndex:i] objectForKey:@"notificationa_Action"],[[activityDetailsArray objectAtIndex:i] objectForKey:@"Usr01"],[[activityDetailsArray objectAtIndex:i] objectForKey:@"Usr02"],[[activityDetailsArray objectAtIndex:i] objectForKey:@"Usr03"],[[activityDetailsArray objectAtIndex:i] objectForKey:@"Usr04"],@"", nil] forKeys:[NSArray arrayWithObjects:@"Qmnum",@"ItemKey",@"ItempartGrp",@"Partgrptext",@"ItempartCod",@"Partcodetext",@"ItemdefectGrp",@"Defectgrptext",@"ItemdefectCod",@"Defectcodetext",@"ItemdefectShtxt",@"CauseKey",@"ActvKey",@"ActvGrp",@"ActvCod",@"Actcodetext",@"ActvShtxt",@"Action",@"Usr01",@"Usr02",@"Usr03",@"Usr04",@"Usr05", nil]]];
                    
                }
            }
            
            
            NSMutableDictionary *notificationCreate = [[NSMutableDictionary alloc] init];
            NSMutableArray *etNotifHeaderItems=[NSMutableArray new];
            NSMutableArray *etNotifDupItems=[NSMutableArray new];
            NSMutableArray *etNotifMessageItems=[NSMutableArray new];
            NSMutableArray *etNotifCauseCodeItems=[NSMutableArray new];
            NSMutableArray *etNotifStatusItems=[NSMutableArray new];
            NSMutableArray *etNotifActivityItems=[NSMutableArray new];
            
            NSMutableArray *etLongtextItems=[NSMutableArray new];
            
            NSMutableArray *etDocsItems=[NSMutableArray new];
            
            [etDocsItems addObject:[NSMutableDictionary dictionaryWithObjects:[NSArray array] forKeys:[NSArray array]]];

            [etLongtextItems addObject:[NSMutableDictionary dictionaryWithObjects:[NSArray array] forKeys:[NSArray array]]];

            [etNotifHeaderItems addObject:[NSMutableDictionary dictionaryWithObjects:[NSArray array] forKeys:[NSArray array]]];
             [etNotifDupItems addObject:[NSMutableDictionary dictionaryWithObjects:[NSArray array] forKeys:[NSArray array]]];
             [etNotifMessageItems addObject:[NSMutableDictionary dictionaryWithObjects:[NSArray array] forKeys:[NSArray array]]];
             [etNotifCauseCodeItems addObject:[NSMutableDictionary dictionaryWithObjects:[NSArray array] forKeys:[NSArray array]]];
             [etNotifStatusItems addObject:[NSMutableDictionary dictionaryWithObjects:[NSArray array] forKeys:[NSArray array]]];
            
            [etNotifActivityItems addObject:[NSMutableDictionary dictionaryWithObjects:[NSArray array] forKeys:[NSArray array]]];
 
            BOOL isCommit=true;
            [notificationCreate setObject:headerFieldsItems forKey:@"ItNotifHeader"];
            [notificationCreate setObject:notificationItems forKey:@"ItNotifItems"];
            [notificationCreate setObject:notificationActivityItems forKey:@"ItNotifActvs"];
            [notificationCreate setObject:[[requestData objectForKey:@"REPORTEDBY"] uppercaseString] forKey:@"IvUser"];
            [notificationCreate setObject:attachmentsItems forKey:@"ItDocs"];
            [notificationCreate setObject:[[requestData objectForKey:@"REPORTEDBY"] uppercaseString] forKey:@"Muser"];
            [notificationCreate setObject:longTextItems forKey:@"ItNotifLongtext"];
             [notificationCreate setObject:@"18523416-177F-4B9B-9250-4F7A90A89537" forKey:@"Deviceid"];
            [notificationCreate setObject:@"" forKey:@"Udid"];
            [notificationCreate setObject:[requestData objectForKey:@"TRANSMITTYPE"] forKey:@"IvTransmitType"];
            [notificationCreate setObject:[NSNumber numberWithBool:isCommit] forKey:@"IvCommit"];
            [notificationCreate setObject:@"CHNOT" forKey:@"Operation"];
 
            //For Response Data need to send  empty in ETformat
            [notificationCreate setObject:etNotifHeaderItems forKey:@"EtNotifHeader"];
            [notificationCreate setObject:etNotifStatusItems forKey:@"EtNotifStatus"];
            [notificationCreate setObject:etNotifDupItems forKey:@"EtNotifDup"];
            [notificationCreate setObject:etNotifCauseCodeItems forKey:@"EtNotifItems"];
            [notificationCreate setObject:etLongtextItems forKey:@"EtNotifLongtext"];
             [notificationCreate setObject:etNotifActivityItems forKey:@"EtNotifActvs"];
            [notificationCreate setObject:etNotifMessageItems forKey:@"EvMessage"];
            [notificationCreate setObject:etDocsItems forKey:@"EtDocs"];

            
            NSError *error;
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:notificationCreate options:NSJSONWritingPrettyPrinted error:&error];
            NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            [soapMessage appendString:jsonString];
            
         }
 
            break;
            
        case NOTIFICATION_RELEASE:
            
            //No body required
            
            break;
            
        case NOTIFICATION_CANCEL:
            
            //No body required
            
            break;
            
        case NOTIFICATION_COMPLETE:
            
            // No body required
            
            break;
            
        case ORDER_CREATE:
            
            if ([requestData count]) {
                
                NSMutableArray *headerFieldsItems = [[NSMutableArray alloc] init];
                NSMutableArray *headerCustomfieldsItems = [[NSMutableArray alloc] init];
                
                NSMutableArray *orderOperations = [[NSMutableArray alloc] init];
                NSMutableArray *orderComponents = [[NSMutableArray alloc] init];
                NSMutableArray *longTextItems = [[NSMutableArray alloc] init];
                NSMutableArray *wcmApplicationItems = [[NSMutableArray alloc] init];
                NSMutableArray *wcmWorkRequirentsItems = [[NSMutableArray alloc] init];
                
                NSMutableArray *wcmWorkApprovalsItems = [[NSMutableArray alloc] init];



                
                if ([[requestData objectForKey:@"PARTS"] count]) {
                    
                    NSArray *partDetailsArray = [requestData objectForKey:@"PARTS"];
 
                    for (int i = 0; i<[partDetailsArray count]; i++) {
                        //Need to write for loop for this FeildComponents
                        
                        for (int x = 0; x<[[[partDetailsArray objectAtIndex:i] lastObject] count]; x++) {
 
                            }
 
                        [orderComponents addObject:[NSMutableDictionary dictionaryWithObjects:[NSArray arrayWithObjects:[[[partDetailsArray objectAtIndex:i] firstObject] objectAtIndex:1],[[[partDetailsArray objectAtIndex:i] firstObject] objectAtIndex:5],[[[partDetailsArray objectAtIndex:i] firstObject] objectAtIndex:13],[[[partDetailsArray objectAtIndex:i] firstObject] objectAtIndex:3],[[[partDetailsArray objectAtIndex:i] firstObject] objectAtIndex:8],[[[partDetailsArray objectAtIndex:i] firstObject] objectAtIndex:2],[[[partDetailsArray objectAtIndex:i] firstObject] objectAtIndex:16],[[[partDetailsArray objectAtIndex:i] firstObject] objectAtIndex:17],@"I", nil] forKeys:[NSArray arrayWithObjects:@"Vornr",@"Matnr",@"Werks",@"Lgort",@"Posnr",@"Bdmng",@"Wempf",@"Ablad",@"Action",nil]]];
                        
                     }
                 }

                if ([[requestData objectForKey:@"CFH"] count]) {
                    
                    NSArray *customHeaderDetailsArray = [requestData objectForKey:@"CFH"];
                    
                    for (int i =0; i<[customHeaderDetailsArray count]; i++) {
                        
                          [headerCustomfieldsItems addObject:[NSMutableDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"",@"",@"",@"",@"",@"",@"",@"",@"", nil] forKeys:[NSArray arrayWithObjects:@"Zdoctype",@"ZdoctypeItem",@"Tabname",@"Fieldname",@"Datatype",@"Value",@"Flabel",@"Sequence",@"Length", nil]]];
                    }
                  }
                
//                [self.orderHeaderDetails setObject:@"" forKey:@"POSID"];
//
//                [self.orderHeaderDetails setObject:@"" forKey:@"REVISION"];

                
                [headerFieldsItems addObject:[NSMutableDictionary dictionaryWithObjects:[NSArray arrayWithObjects:[requestData objectForKey:@"OID"],[requestData objectForKey:@"SHORTTEXT"],[requestData objectForKey:@"REPORTEDBY"],[requestData objectForKey:@"SDATE"],[requestData objectForKey:@"OPID"],[requestData objectForKey:@"EQID"],[requestData objectForKey:@"FID"],[requestData objectForKey:@"FID"],[requestData objectForKey:@"EDATE"],[requestData objectForKey:@"SDATE"],[requestData objectForKey:@"BREAKDOWN"],[requestData objectForKey:@"SYSTEMCONDITIONID"],[requestData objectForKey:@"MALFUNCTIONSTARTDATE"],[requestData objectForKey:@"MALFUNCTIONENDDATE"],[requestData objectForKey:@"NREPORTEDBY"],[requestData objectForKey:@"EFFECTID"],[requestData objectForKey:@"QMNUM"],[requestData objectForKey:@"PARNRID"],[requestData objectForKey:@"NAMEVW"],[requestData objectForKey:@"PLANNERGROUP"],[self getcodeforkeys:[requestData objectForKey:@"WORKCENTERID"]],[requestData objectForKey:@"PLANTID"],[requestData objectForKey:@"PLANNERGROUPNAME"],[requestData objectForKey:@"workarea"],[requestData objectForKey:@"costcenter"],[requestData objectForKey:@"POSID"],[requestData objectForKey:@"REVISION"],headerCustomfieldsItems, nil] forKeys:[NSArray arrayWithObjects:@"Auart",@"Ktext",@"Ernam",@"Erdat",@"Priok",@"Equnr",@"Strno",@"TplnrInt",@"Gltrp",@"Gstrp",@"Msaus",@"Anlzu",@"Ausvn",@"Ausbs",@"Qmnam", @"Auswk",@"Qmnum",@"ParnrVw",@"NameVw",@"Ingrp",@"Arbpl",@"Werks",@"Ingrpname",@"Kokrs",@"Kostl",@"Posid",@"Revnr",@"ItOrderHeadeFields",nil]]];
                
                
                if ([[requestData objectForKey:@"ITEMS"] count]) {
                    
                    NSArray *operationDetailsArray = [requestData objectForKey:@"ITEMS"];
 
                    for (int i = 0; i<[operationDetailsArray count]; i++) {
                        
                        for (int x = 0; x<[[[operationDetailsArray objectAtIndex:i] lastObject] count]; x++) {
                            
                        //    [feildOperations appendFormat:@"<item><Zdoctype>W</Zdoctype><ZdoctypeItem>%@</ZdoctypeItem><Tabname>%@</Tabname><Fieldname>%@</Fieldname><Value>%@</Value><Flabel>%@</Flabel><Datatype>%@</Datatype><Sequence>%@</Sequence><Length>%@</Length></item>",[[[[operationDetailsArray objectAtIndex:i] objectAtIndex:1] objectAtIndex:x] objectAtIndex:1],[[[[operationDetailsArray objectAtIndex:i] objectAtIndex:1] objectAtIndex:x] objectAtIndex:2],[[[[operationDetailsArray objectAtIndex:i] objectAtIndex:1] objectAtIndex:x] objectAtIndex:3],[[[[operationDetailsArray objectAtIndex:i] objectAtIndex:1] objectAtIndex:x] objectAtIndex:4],[[[[operationDetailsArray objectAtIndex:i] objectAtIndex:1] objectAtIndex:x] objectAtIndex:5],[[[[operationDetailsArray objectAtIndex:i] objectAtIndex:1] objectAtIndex:x] objectAtIndex:6],[[[[operationDetailsArray objectAtIndex:i] objectAtIndex:1] objectAtIndex:x] objectAtIndex:7],[[[[operationDetailsArray objectAtIndex:i] objectAtIndex:1] objectAtIndex:x] objectAtIndex:8]];
                        }
 
                        NSString *duanoString=[[[operationDetailsArray objectAtIndex:i] firstObject] objectAtIndex:3];
                        
                        if ([NullChecker isNull:duanoString]) {
                             duanoString=@"0";
                        }
 
                         [orderOperations addObject:[NSMutableDictionary dictionaryWithObjects:[NSArray arrayWithObjects:[[[operationDetailsArray objectAtIndex:i] firstObject] objectAtIndex:1],[[[operationDetailsArray objectAtIndex:i] firstObject] objectAtIndex:2],[self getcodeforkeys:[[[operationDetailsArray objectAtIndex:i] firstObject] objectAtIndex:28]],[[[operationDetailsArray objectAtIndex:i] firstObject] objectAtIndex:26],[[[operationDetailsArray objectAtIndex:i] firstObject] objectAtIndex:19],duanoString,[[[operationDetailsArray objectAtIndex:i] firstObject] objectAtIndex:4],[self getcodeforkeys:[[[operationDetailsArray objectAtIndex:i] firstObject] objectAtIndex:29]],[[[operationDetailsArray objectAtIndex:i] firstObject] objectAtIndex:27],[[[operationDetailsArray objectAtIndex:i] firstObject] objectAtIndex:30],@"I", nil] forKeys:[NSArray arrayWithObjects:@"Vornr",@"Ltxa1",@"Arbpl",@"Werks",@"Steus",@"Dauno",@"Daune",@"ArbplText",@"WerksText",@"SteusText",@"Action",nil]]];
                    }
                  }
                
                
                
//                if ([[requestData objectForKey:@"ITEMS"] count]) {
//                    
//                    NSArray *operationLongTextArray = [requestData objectForKey:@"ITEMS"];
//                    
//                    //                int Vornr = 0;
//                    //                NSString *vornrID;
//                    for (int i =0; i< [operationLongTextArray count]; i++) {
//                        //                    Vornr = Vornr+10;
//                        //                    vornrID =[NSString stringWithFormat:@"%04i",Vornr];
//                        //[[operationLongTextArray objectAtIndex:i] objectAtIndex:1]
//                        NSArray *operationLongTextOperationArray = [[[[operationLongTextArray objectAtIndex:i] firstObject] objectAtIndex:20] componentsSeparatedByString:@"\n"];
//                        for (int j =0; j<[operationLongTextOperationArray count]; j++) {
//                            [soapMessage appendFormat:@"<item><Aufnr></Aufnr><Activity>%@</Activity><TextLine>%@</TextLine></item>",[[[operationLongTextArray objectAtIndex:i] firstObject] objectAtIndex:1],[operationLongTextOperationArray objectAtIndex:j]];
//                        }
//                    }
//                }
//
 
                  if ([[requestData objectForKey:@"WCMWORKAPPlICATIONS"] count]) {
                    
                     NSArray *wcmWorkApplication = [requestData objectForKey:@"WCMWORKAPPlICATIONS"];
 
                      for (int i =0; i<[wcmWorkApplication count]; i++) {
                        
                         [wcmApplicationItems addObject:[NSMutableDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"",[[[wcmWorkApplication objectAtIndex:i] firstObject] objectAtIndex:1],[[[wcmWorkApplication objectAtIndex:i] firstObject] objectAtIndex:2],[[[wcmWorkApplication objectAtIndex:i] firstObject] objectAtIndex:3],[[[wcmWorkApplication objectAtIndex:i] firstObject] objectAtIndex:4],[[[wcmWorkApplication objectAtIndex:i] firstObject] objectAtIndex:5],[[[wcmWorkApplication objectAtIndex:i] firstObject] objectAtIndex:6],@"",@"",@"",@"",@"",@"",[[[wcmWorkApplication objectAtIndex:i] firstObject] objectAtIndex:29],[[[wcmWorkApplication objectAtIndex:i] firstObject] objectAtIndex:30],[[[wcmWorkApplication objectAtIndex:i] firstObject] objectAtIndex:13],[[[wcmWorkApplication objectAtIndex:i] firstObject] objectAtIndex:14],[[[wcmWorkApplication objectAtIndex:i] firstObject] objectAtIndex:15],[[[wcmWorkApplication objectAtIndex:i] firstObject] objectAtIndex:16],[[[wcmWorkApplication objectAtIndex:i] firstObject] objectAtIndex:17],@"",[[[wcmWorkApplication objectAtIndex:i] firstObject] objectAtIndex:19],@"",@"",@"",[[[wcmWorkApplication objectAtIndex:i] firstObject] objectAtIndex:23],@"",@"",@"",@"",[[[wcmWorkApplication objectAtIndex:i] firstObject] objectAtIndex:28], nil] forKeys:[NSArray arrayWithObjects:@"Aufnr",@"Objart",@"Wapinr",@"Iwerk",@"Objtyp",@"Usage",@"Usagex",@"Train",@"Trainx",@"Anlzu",@"Anlzux",@"Etape",@"Etapex",@"Begru",@"Begtx",@"Stxt",@"Datefr",@"Timefr",@"Dateto",@"Timeto",@"Priok",@"Priokx",@"Rctime",@"Rcunit",@"Objnr",@"Refobj",@"Crea",@"Prep",@"Comp",@"Appr",@"Action",nil]]];
                          
 
                        if (![[[[wcmWorkApplication objectAtIndex:i] firstObject] objectAtIndex:4] isEqualToString:@"1"] || ![[[[wcmWorkApplication objectAtIndex:i] firstObject] objectAtIndex:4] isEqualToString:@"7"]) {
                            
                            NSArray *wcmHStandardCheckPoints = [[wcmWorkApplication objectAtIndex:i] objectAtIndex:1];
                            
                            for (int j =0; j<[wcmHStandardCheckPoints count]; j++) {
                                
                                checkPointDescriptionString = [self getcodeforkeys:[[wcmHStandardCheckPoints objectAtIndex:j] objectAtIndex:6]];
                                
                                 [wcmWorkRequirentsItems addObject:[NSMutableDictionary dictionaryWithObjects:[NSArray arrayWithObjects:[[wcmHStandardCheckPoints objectAtIndex:j] objectAtIndex:0],[[wcmHStandardCheckPoints objectAtIndex:j] objectAtIndex:1],@"W",[[wcmHStandardCheckPoints objectAtIndex:j] objectAtIndex:3],[[wcmHStandardCheckPoints objectAtIndex:j] objectAtIndex:5],checkPointDescriptionString, nil] forKeys:[NSArray arrayWithObjects:@"Wapinr",@"Wapityp",@"ChkPointType",@"Wkid",@"Value",@"Desctext",nil]]];

                              }
                            
                            NSArray *wcmCStandardCheckPoints = [[wcmWorkApplication objectAtIndex:i] objectAtIndex:2];
                            
                            for (int j =0; j<[wcmCStandardCheckPoints count]; j++) {
                                
                                checkPointDescriptionString = [self getcodeforkeys:[[wcmCStandardCheckPoints objectAtIndex:j] objectAtIndex:6]];
 
                                [wcmWorkRequirentsItems addObject:[NSMutableDictionary dictionaryWithObjects:[NSArray arrayWithObjects:[[wcmCStandardCheckPoints objectAtIndex:j] objectAtIndex:0],[[wcmCStandardCheckPoints objectAtIndex:j] objectAtIndex:1],@"R",[[wcmCStandardCheckPoints objectAtIndex:j] objectAtIndex:4],[[wcmCStandardCheckPoints objectAtIndex:j] objectAtIndex:5],checkPointDescriptionString, nil] forKeys:[NSArray arrayWithObjects:@"Wapinr",@"Wapityp",@"ChkPointType",@"Needid",@"Value",@"Desctext",nil]]];

                            }
                         }
                    }
                }
 
            
                if ([[requestData objectForKey:@"WCMWORKAPPROVALS"] count]) {
                    
                    NSArray *wcmWorkApproval = [requestData objectForKey:@"WCMWORKAPPROVALS"];
 
                    for (int i =0; i<[wcmWorkApproval count]; i++) {
 
//                        [wcmWorkApprovalsItems addObject:[NSMutableDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"",[[wcmWorkApproval objectAtIndex:i] objectAtIndex:1],[[wcmWorkApproval objectAtIndex:i] objectAtIndex:2],@"",[[wcmWorkApproval objectAtIndex:i] objectAtIndex:4],[[wcmWorkApproval objectAtIndex:i] objectAtIndex:4],@"",@"",@"",@"",@"",@"",[[wcmWorkApproval objectAtIndex:i] objectAtIndex:29],[[wcmWorkApproval objectAtIndex:i] objectAtIndex:30],[[wcmWorkApproval objectAtIndex:i] objectAtIndex:12],[[wcmWorkApproval objectAtIndex:i] objectAtIndex:12],[[wcmWorkApproval objectAtIndex:i] objectAtIndex:13],[[wcmWorkApproval objectAtIndex:i] objectAtIndex:14],[[wcmWorkApproval objectAtIndex:i] objectAtIndex:15],[[wcmWorkApproval objectAtIndex:i] objectAtIndex:16],@"",[[wcmWorkApproval objectAtIndex:i] objectAtIndex:18],@"",@"",@"",@"",@"",@"",@"",@"",@"",[[wcmWorkApproval objectAtIndex:i] objectAtIndex:28], nil] forKeys:[NSArray arrayWithObjects:@"Aufnr",@"Objart",@"Wapnr",@"Iwerk",@"Usage",@"Usagex",@"Train",@"Trainx",@"Anlzu",@"Anlzux",@"Etape",@"Etapex",@"Begru",@"Begtx",@"Stxt",@"Datefr",@"Timefr",@"Dateto",@"Timeto",@"Priok",@"Priokx",@"Rctime",@"Rcunit",@"Objnr",@"Refobj",@"Crea",@"Prep",@"Comp",@"Appr",@"Pappr",@"Action",nil]]];
                        
                         [wcmWorkApprovalsItems addObject:[NSMutableDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"",[[wcmWorkApproval objectAtIndex:i] objectAtIndex:1],[[wcmWorkApproval objectAtIndex:i] objectAtIndex:2],[[wcmWorkApproval objectAtIndex:i] objectAtIndex:3],[[wcmWorkApproval objectAtIndex:i] objectAtIndex:4],[[wcmWorkApproval objectAtIndex:i] objectAtIndex:5],[[wcmWorkApproval objectAtIndex:i] objectAtIndex:6],[[wcmWorkApproval objectAtIndex:i] objectAtIndex:7],[[wcmWorkApproval objectAtIndex:i] objectAtIndex:8],[[wcmWorkApproval objectAtIndex:i] objectAtIndex:9],[[wcmWorkApproval objectAtIndex:i] objectAtIndex:10],[[wcmWorkApproval objectAtIndex:i] objectAtIndex:11],[[wcmWorkApproval objectAtIndex:i] objectAtIndex:29],[[wcmWorkApproval objectAtIndex:i] objectAtIndex:30],[[wcmWorkApproval objectAtIndex:i] objectAtIndex:12],[[wcmWorkApproval objectAtIndex:i] objectAtIndex:13],[[wcmWorkApproval objectAtIndex:i] objectAtIndex:14],[[wcmWorkApproval objectAtIndex:i] objectAtIndex:15],[[wcmWorkApproval objectAtIndex:i] objectAtIndex:16],[[wcmWorkApproval objectAtIndex:i] objectAtIndex:17],[[wcmWorkApproval objectAtIndex:i] objectAtIndex:18],[[wcmWorkApproval objectAtIndex:i] objectAtIndex:19],[[wcmWorkApproval objectAtIndex:i] objectAtIndex:20],[[wcmWorkApproval objectAtIndex:i] objectAtIndex:21],[[wcmWorkApproval objectAtIndex:i] objectAtIndex:22],[[wcmWorkApproval objectAtIndex:i] objectAtIndex:23],[[wcmWorkApproval objectAtIndex:i] objectAtIndex:24],[[wcmWorkApproval objectAtIndex:i] objectAtIndex:25],[[wcmWorkApproval objectAtIndex:i] objectAtIndex:26],[[wcmWorkApproval objectAtIndex:i] objectAtIndex:27],[[wcmWorkApproval objectAtIndex:i] objectAtIndex:28], nil] forKeys:[NSArray arrayWithObjects:@"Aufnr",@"Objart",@"Wapnr",@"Iwerk",@"Usage",@"Usagex",@"Train",@"Trainx",@"Anlzu",@"Anlzux",@"Etape",@"Etapex",@"Begru",@"Begtx",@"Stxt",@"Datefr",@"Timefr",@"Dateto",@"Timeto",@"Priok",@"Priokx",@"Rctime",@"Rcunit",@"Objnr",@"Refobj",@"Crea",@"Prep",@"Comp",@"Appr",@"Pappr",@"Action",nil]]];
                        
//                           [soapMessage appendFormat:@"<item><Aufnr>%@</Aufnr><Objart>%@</Objart><Wapnr>%@</Wapnr><Iwerk>%@</Iwerk><Usage>%@</Usage><Usagex>%@</Usagex><Train>%@</Train><Trainx>%@</Trainx><Anlzu>%@</Anlzu><Anlzux>%@</Anlzux><Etape>%@</Etape><Etapex>%@</Etapex><Begru>%@</Begru><Begtx>%@</Begtx><Stxt>%@</Stxt><Datefr>%@</Datefr><Timefr>%@</Timefr><Dateto>%@</Dateto><Timeto>%@</Timeto><Priok>%@</Priok><Priokx>%@</Priokx><Rctime>%@</Rctime><Rcunit>%@</Rcunit><Objnr>%@</Objnr><Refobj>%@</Refobj><Crea>%@</Crea><Prep>%@</Prep><Comp>%@</Comp><Appr>%@</Appr><Pappr>%@</Pappr><Action>%@</Action></item>",[requestData objectForKey:@"OBJECTID"],[[wcmWorkApproval objectAtIndex:i] objectAtIndex:1],[[wcmWorkApproval objectAtIndex:i] objectAtIndex:2],[[wcmWorkApproval objectAtIndex:i] objectAtIndex:3],[[wcmWorkApproval objectAtIndex:i] objectAtIndex:4],[[wcmWorkApproval objectAtIndex:i] objectAtIndex:5],[[wcmWorkApproval objectAtIndex:i] objectAtIndex:6],[[wcmWorkApproval objectAtIndex:i] objectAtIndex:7],[[wcmWorkApproval objectAtIndex:i] objectAtIndex:8],[[wcmWorkApproval objectAtIndex:i] objectAtIndex:9],[[wcmWorkApproval objectAtIndex:i] objectAtIndex:10],[[wcmWorkApproval objectAtIndex:i] objectAtIndex:11],[[wcmWorkApproval objectAtIndex:i] objectAtIndex:29],[[wcmWorkApproval objectAtIndex:i] objectAtIndex:30],[[wcmWorkApproval objectAtIndex:i] objectAtIndex:12],[[wcmWorkApproval objectAtIndex:i] objectAtIndex:13],[[wcmWorkApproval objectAtIndex:i] objectAtIndex:14],[[wcmWorkApproval objectAtIndex:i] objectAtIndex:15],[[wcmWorkApproval objectAtIndex:i] objectAtIndex:16],[[wcmWorkApproval objectAtIndex:i] objectAtIndex:17],[[wcmWorkApproval objectAtIndex:i] objectAtIndex:18],[[wcmWorkApproval objectAtIndex:i] objectAtIndex:19],[[wcmWorkApproval objectAtIndex:i] objectAtIndex:20],[[wcmWorkApproval objectAtIndex:i] objectAtIndex:21],[[wcmWorkApproval objectAtIndex:i] objectAtIndex:22],[[wcmWorkApproval objectAtIndex:i] objectAtIndex:23],[[wcmWorkApproval objectAtIndex:i] objectAtIndex:24],[[wcmWorkApproval objectAtIndex:i] objectAtIndex:25],[[wcmWorkApproval objectAtIndex:i] objectAtIndex:26],[[wcmWorkApproval objectAtIndex:i] objectAtIndex:27],[[wcmWorkApproval objectAtIndex:i] objectAtIndex:28]];
//
                        
                        }
                  }
 
                NSMutableDictionary *orderCreate = [[NSMutableDictionary alloc] init];
                NSMutableArray *etOrderHeaderItems=[NSMutableArray new];
                NSMutableArray *etOrderMessageItems=[NSMutableArray new];
                NSMutableArray *etOrderOperationItems=[NSMutableArray new];
                NSMutableArray *etOrderStatusItems=[NSMutableArray new];
                NSMutableArray *etOrderComponentItems=[NSMutableArray new];
                NSMutableArray *etLongtextItems=[NSMutableArray new];
                NSMutableArray *etwcmApplicationItems=[NSMutableArray new];
                NSMutableArray *etwcmWorkRequirentsItems=[NSMutableArray new];
                
                NSMutableArray *etwcmWorkApprovalsItems=[NSMutableArray new];

 
                [etLongtextItems addObject:[NSMutableDictionary dictionaryWithObjects:[NSArray array] forKeys:[NSArray array]]];
                 [etOrderHeaderItems addObject:[NSMutableDictionary dictionaryWithObjects:[NSArray array] forKeys:[NSArray array]]];
                 [etOrderMessageItems addObject:[NSMutableDictionary dictionaryWithObjects:[NSArray array] forKeys:[NSArray array]]];
                [etOrderOperationItems addObject:[NSMutableDictionary dictionaryWithObjects:[NSArray array] forKeys:[NSArray array]]];
                [etOrderComponentItems addObject:[NSMutableDictionary dictionaryWithObjects:[NSArray array] forKeys:[NSArray array]]];
                [etOrderStatusItems addObject:[NSMutableDictionary dictionaryWithObjects:[NSArray array] forKeys:[NSArray array]]];
                [etLongtextItems addObject:[NSMutableDictionary dictionaryWithObjects:[NSArray array] forKeys:[NSArray array]]];
                [etOrderMessageItems addObject:[NSMutableDictionary dictionaryWithObjects:[NSArray array] forKeys:[NSArray array]]];
                 [etwcmApplicationItems addObject:[NSMutableDictionary dictionaryWithObjects:[NSArray array] forKeys:[NSArray array]]];
                [etwcmWorkRequirentsItems addObject:[NSMutableDictionary dictionaryWithObjects:[NSArray array] forKeys:[NSArray array]]];
                
                [etwcmWorkApprovalsItems addObject:[NSMutableDictionary dictionaryWithObjects:[NSArray array] forKeys:[NSArray array]]];

 
                BOOL isCommit=true;
                [orderCreate setObject:headerFieldsItems forKey:@"ItOrderHeader"];
                [orderCreate setObject:orderOperations forKey:@"ItOrderOperations"];
                [orderCreate setObject:orderComponents forKey:@"ItOrderComponents"];
                
                [orderCreate setObject:wcmApplicationItems forKey:@"ItWcmWaData"];
                [orderCreate setObject:wcmWorkRequirentsItems forKey:@"ItWcmWaChkReq"];
                [orderCreate setObject:wcmWorkApprovalsItems forKey:@"ItWcmWwData"];
 

                [orderCreate setObject:[[requestData objectForKey:@"REPORTEDBY"] uppercaseString] forKey:@"IvUser"];
              //  [orderCreate setObject:attachmentsItems forKey:@"ItDocs"];
                [orderCreate setObject:[[requestData objectForKey:@"REPORTEDBY"] uppercaseString] forKey:@"Muser"];
                [orderCreate setObject:longTextItems forKey:@"ItOrderLongtext"];
                [orderCreate setObject:@"18523416-177F-4B9B-9250-4F7A90A89537" forKey:@"Deviceid"];
                [orderCreate setObject:@"" forKey:@"Udid"];
                [orderCreate setObject:[requestData objectForKey:@"TRANSMITTYPE"] forKey:@"IvTransmitType"];
                [orderCreate setObject:[NSNumber numberWithBool:isCommit] forKey:@"IvCommit"];
                [orderCreate setObject:@"CRORD" forKey:@"Operation"];
                
                //For Response Data need to send  empty in ETformat
                [orderCreate setObject:etOrderHeaderItems forKey:@"EtOrderHeader"];
                [orderCreate setObject:etOrderOperationItems forKey:@"EtOrderOperations"];
                [orderCreate setObject:etOrderComponentItems forKey:@"EtOrderComponents"];
                [orderCreate setObject:etOrderStatusItems forKey:@"EtOrderStatus"];
                [orderCreate setObject:etOrderStatusItems forKey:@"EtOrderLongtext"];
                [orderCreate setObject:etOrderStatusItems forKey:@"EsAufnr"];
                [orderCreate setObject:wcmApplicationItems forKey:@"EtWcmWaData"];
                [orderCreate setObject:wcmWorkRequirentsItems forKey:@"EtWcmWaChkReq"];
                [orderCreate setObject:etwcmWorkApprovalsItems forKey:@"EtWcmWwData"];

                
                 NSError *error;
                NSData *jsonData = [NSJSONSerialization dataWithJSONObject:orderCreate options:NSJSONWritingPrettyPrinted error:&error];
                NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                [soapMessage appendString:jsonString];
               }
   
            break;
            
        case ORDER_CHANGE:
    
            if ([requestData count]) {
                
                NSMutableArray *headerFieldsItems = [[NSMutableArray alloc] init];
                NSMutableArray *headerCustomfieldsItems = [[NSMutableArray alloc] init];
                
                NSMutableArray *orderOperations = [[NSMutableArray alloc] init];
                NSMutableArray *orderComponents = [[NSMutableArray alloc] init];
                NSMutableArray *longTextItems = [[NSMutableArray alloc] init];
                
                if ([[requestData objectForKey:@"PARTS"] count]) {
                    
                    NSArray *partDetailsArray = [requestData objectForKey:@"PARTS"];
                    
                    NSString *actionID;
 
                    for (int i = 0; i<[partDetailsArray count]; i++) {
                        //Need to write for loop for this FeildComponents
                        
                        for (int x = 0; x<[[[partDetailsArray objectAtIndex:i] lastObject] count]; x++) {
                            
                          }
                        
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
                        
                        
                        [orderComponents addObject:[NSMutableDictionary dictionaryWithObjects:[NSArray arrayWithObjects:[requestData objectForKey:@"OBJECTID"],[[[partDetailsArray objectAtIndex:i] firstObject] objectAtIndex:1],[[[partDetailsArray objectAtIndex:i] firstObject] objectAtIndex:5],[[[partDetailsArray objectAtIndex:i] firstObject] objectAtIndex:13],[[[partDetailsArray objectAtIndex:i] firstObject] objectAtIndex:3],[[[partDetailsArray objectAtIndex:i] firstObject] objectAtIndex:8],[[[partDetailsArray objectAtIndex:i] firstObject] objectAtIndex:2],[[[partDetailsArray objectAtIndex:i] firstObject] objectAtIndex:16],[[[partDetailsArray objectAtIndex:i] firstObject] objectAtIndex:17],actionID, nil] forKeys:[NSArray arrayWithObjects:@"Aufnr",@"Vornr",@"Matnr",@"Werks",@"Lgort",@"Posnr",@"Bdmng",@"Wempf",@"Ablad",@"Action",nil]]];
                        
                    }
                }
                
                if ([[requestData objectForKey:@"CFH"] count]) {
                    
                    NSArray *customHeaderDetailsArray = [requestData objectForKey:@"CFH"];
                    
                    for (int i =0; i<[customHeaderDetailsArray count]; i++) {
                        
                        [headerCustomfieldsItems addObject:[NSMutableDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"",@"",@"",@"",@"",@"",@"",@"",@"", nil] forKeys:[NSArray arrayWithObjects:@"Zdoctype",@"ZdoctypeItem",@"Tabname",@"Fieldname",@"Datatype",@"Value",@"Flabel",@"Sequence",@"Length", nil]]];
                    }
                 }
                
                 [headerFieldsItems addObject:[NSMutableDictionary dictionaryWithObjects:[NSArray arrayWithObjects:[requestData objectForKey:@"OBJECTID"],[requestData objectForKey:@"OID"],[requestData objectForKey:@"SHORTTEXT"],[requestData objectForKey:@"REPORTEDBY"],[requestData objectForKey:@"SDATE"],[requestData objectForKey:@"OPID"],[requestData objectForKey:@"EQID"],[requestData objectForKey:@"FID"],[requestData objectForKey:@"FID"],[requestData objectForKey:@"EDATE"],[requestData objectForKey:@"SDATE"],[requestData objectForKey:@"BREAKDOWN"],[requestData objectForKey:@"SYSTEMCONDITIONID"],[requestData objectForKey:@"MALFUNCTIONSTARTDATE"],[requestData objectForKey:@"MALFUNCTIONENDDATE"],[requestData objectForKey:@"NREPORTEDBY"],[requestData objectForKey:@"EFFECTID"],[requestData objectForKey:@"QMNUM"],[requestData objectForKey:@"PARNRID"],[requestData objectForKey:@"NAMEVW"],[requestData objectForKey:@"PLANNERGROUP"],[self getcodeforkeys:[requestData objectForKey:@"WORKCENTERID"]],[requestData objectForKey:@"PLANTID"],[requestData objectForKey:@"PLANNERGROUPNAME"],[requestData objectForKey:@"workarea"],[requestData objectForKey:@"costcenter"],[requestData objectForKey:@"POSID"],[requestData objectForKey:@"REVISION"],headerCustomfieldsItems, nil] forKeys:[NSArray arrayWithObjects:@"Aufnr",@"Auart",@"Ktext",@"Ernam",@"Erdat",@"Priok",@"Equnr",@"Strno",@"TplnrInt",@"Gltrp",@"Gstrp",@"Msaus",@"Anlzu",@"Ausvn",@"Ausbs",@"Qmnam", @"Auswk",@"Qmnum",@"ParnrVw",@"NameVw",@"Ingrp",@"Arbpl",@"Werks",@"Ingrpname",@"Kokrs",@"Kostl",@"Posid",@"Revnr",@"ItOrderHeadeFields",nil]]];
                
 
                if ([[requestData objectForKey:@"ITEMS"] count]) {
                    
                    NSArray *operationDetailsArray = [requestData objectForKey:@"ITEMS"];
                    
                    for (int i = 0; i<[operationDetailsArray count]; i++) {
                        
                        for (int x = 0; x<[[[operationDetailsArray objectAtIndex:i] lastObject] count]; x++) {
                            
                            //    [feildOperations appendFormat:@"<item><Zdoctype>W</Zdoctype><ZdoctypeItem>%@</ZdoctypeItem><Tabname>%@</Tabname><Fieldname>%@</Fieldname><Value>%@</Value><Flabel>%@</Flabel><Datatype>%@</Datatype><Sequence>%@</Sequence><Length>%@</Length></item>",[[[[operationDetailsArray objectAtIndex:i] objectAtIndex:1] objectAtIndex:x] objectAtIndex:1],[[[[operationDetailsArray objectAtIndex:i] objectAtIndex:1] objectAtIndex:x] objectAtIndex:2],[[[[operationDetailsArray objectAtIndex:i] objectAtIndex:1] objectAtIndex:x] objectAtIndex:3],[[[[operationDetailsArray objectAtIndex:i] objectAtIndex:1] objectAtIndex:x] objectAtIndex:4],[[[[operationDetailsArray objectAtIndex:i] objectAtIndex:1] objectAtIndex:x] objectAtIndex:5],[[[[operationDetailsArray objectAtIndex:i] objectAtIndex:1] objectAtIndex:x] objectAtIndex:6],[[[[operationDetailsArray objectAtIndex:i] objectAtIndex:1] objectAtIndex:x] objectAtIndex:7],[[[[operationDetailsArray objectAtIndex:i] objectAtIndex:1] objectAtIndex:x] objectAtIndex:8]];
                        }
                        
                        NSString *duanoString=[[[operationDetailsArray objectAtIndex:i] firstObject] objectAtIndex:3];
                        
                        NSString *actionID;
 
                        if ([NullChecker isNull:duanoString]) {
                            duanoString=@"0";
                        }
                        
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
                        
                        [orderOperations addObject:[NSMutableDictionary dictionaryWithObjects:[NSArray arrayWithObjects:[requestData objectForKey:@"OBJECTID"],[[[operationDetailsArray objectAtIndex:i] firstObject] objectAtIndex:1],[[[operationDetailsArray objectAtIndex:i] firstObject] objectAtIndex:2],[self getcodeforkeys:[[[operationDetailsArray objectAtIndex:i] firstObject] objectAtIndex:28]],[[[operationDetailsArray objectAtIndex:i] firstObject] objectAtIndex:26],[[[operationDetailsArray objectAtIndex:i] firstObject] objectAtIndex:19],duanoString,[[[operationDetailsArray objectAtIndex:i] firstObject] objectAtIndex:4],[self getcodeforkeys:[[[operationDetailsArray objectAtIndex:i] firstObject] objectAtIndex:29]],[[[operationDetailsArray objectAtIndex:i] firstObject] objectAtIndex:27],[[[operationDetailsArray objectAtIndex:i] firstObject] objectAtIndex:30],actionID, nil] forKeys:[NSArray arrayWithObjects:@"Aufnr",@"Vornr",@"Ltxa1",@"Arbpl",@"Werks",@"Steus",@"Dauno",@"Daune",@"ArbplText",@"WerksText",@"SteusText",@"Action",nil]]];
                    }
                }
                
            
                
                NSMutableDictionary *orderCreate = [[NSMutableDictionary alloc] init];
                NSMutableArray *etOrderHeaderItems=[NSMutableArray new];
                NSMutableArray *etOrderMessageItems=[NSMutableArray new];
                NSMutableArray *etOrderOperationItems=[NSMutableArray new];
                NSMutableArray *etOrderStatusItems=[NSMutableArray new];
                NSMutableArray *etOrderComponentItems=[NSMutableArray new];
                NSMutableArray *etLongtextItems=[NSMutableArray new];
                
                [etLongtextItems addObject:[NSMutableDictionary dictionaryWithObjects:[NSArray array] forKeys:[NSArray array]]];
                [etOrderHeaderItems addObject:[NSMutableDictionary dictionaryWithObjects:[NSArray array] forKeys:[NSArray array]]];
                [etOrderMessageItems addObject:[NSMutableDictionary dictionaryWithObjects:[NSArray array] forKeys:[NSArray array]]];
                [etOrderOperationItems addObject:[NSMutableDictionary dictionaryWithObjects:[NSArray array] forKeys:[NSArray array]]];
                [etOrderComponentItems addObject:[NSMutableDictionary dictionaryWithObjects:[NSArray array] forKeys:[NSArray array]]];
                [etOrderStatusItems addObject:[NSMutableDictionary dictionaryWithObjects:[NSArray array] forKeys:[NSArray array]]];
                [etLongtextItems addObject:[NSMutableDictionary dictionaryWithObjects:[NSArray array] forKeys:[NSArray array]]];
                
                BOOL isCommit=true;
                [orderCreate setObject:headerFieldsItems forKey:@"ItOrderHeader"];
                [orderCreate setObject:orderOperations forKey:@"ItOrderOperations"];
                [orderCreate setObject:orderComponents forKey:@"ItOrderComponents"];
                [orderCreate setObject:[[requestData objectForKey:@"REPORTEDBY"] uppercaseString] forKey:@"IvUser"];
                //  [orderCreate setObject:attachmentsItems forKey:@"ItDocs"];
                [orderCreate setObject:[[requestData objectForKey:@"REPORTEDBY"] uppercaseString] forKey:@"Muser"];
                [orderCreate setObject:longTextItems forKey:@"ItOrderLongtext"];
                [orderCreate setObject:@"18523416-177F-4B9B-9250-4F7A90A89537" forKey:@"Deviceid"];
                [orderCreate setObject:@"" forKey:@"Udid"];
                [orderCreate setObject:[requestData objectForKey:@"TRANSMITTYPE"] forKey:@"IvTransmitType"];
                [orderCreate setObject:[NSNumber numberWithBool:isCommit] forKey:@"IvCommit"];
                [orderCreate setObject:@"CHORD" forKey:@"Operation"];
                
                //For Response Data need to send  empty in ETformat
                [orderCreate setObject:etOrderHeaderItems forKey:@"EtOrderHeader"];
                [orderCreate setObject:etOrderOperationItems forKey:@"EtOrderOperations"];
                [orderCreate setObject:etOrderComponentItems forKey:@"EtOrderComponents"];
                [orderCreate setObject:etOrderStatusItems forKey:@"EtOrderStatus"];
                [orderCreate setObject:etLongtextItems forKey:@"EtOrderLongtext"];
                [orderCreate setObject:etOrderMessageItems forKey:@"EtMessages"];
 
                NSError *error;
                NSData *jsonData = [NSJSONSerialization dataWithJSONObject:orderCreate options:NSJSONWritingPrettyPrinted error:&error];
                NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                [soapMessage appendString:jsonString];
                
            }
            
            break;
            
      
            
 
         case ORDER_CANCEL:

            //Not required body
         
            break;
            
        case ORDER_CONFIRM:
 
            if ([requestData count]) {
                
                NSMutableDictionary *collectiveConfirmationDictionary = [[NSMutableDictionary alloc] init];
                
                NSMutableArray *operationsItemsArray=[NSMutableArray new];
 
                if ([requestData objectForKey:@"ITEMS"]) {
                    NSMutableArray *objectIds = [requestData objectForKey:@"ITEMS"];
                    for (int i=0; i<[objectIds count]; i++) {
                        if ([[[[objectIds objectAtIndex:i] firstObject] objectAtIndex:10] isEqualToString:@"New"]) {
                            
                             [operationsItemsArray addObject:[NSMutableDictionary dictionaryWithObjects:[NSArray arrayWithObjects:[requestData objectForKey:@"OBJECTID"],[[[objectIds objectAtIndex:i] firstObject] objectAtIndex:1],[[[objectIds objectAtIndex:i] firstObject] objectAtIndex:7],[[[objectIds objectAtIndex:i] firstObject] objectAtIndex:11],[[[objectIds objectAtIndex:i] firstObject] objectAtIndex:12],[[[objectIds objectAtIndex:i] firstObject] objectAtIndex:13],[[[objectIds objectAtIndex:i] firstObject] objectAtIndex:24],[[[objectIds objectAtIndex:i] firstObject] objectAtIndex:22],[[[objectIds objectAtIndex:i] firstObject] objectAtIndex:23],[[[objectIds objectAtIndex:i] firstObject] objectAtIndex:25],[[[objectIds objectAtIndex:i] firstObject] objectAtIndex:8], nil] forKeys:[NSArray arrayWithObjects:@"Aufnr",@"Vornr",@"ConfText",@"Grund",@"Leknw",@"Aueru",@"Pernr",@"ExecStartDate",@"ExecFinDate",@"ExecStartTime",@"ExecFinTime", nil]]];
                          }
                    }
                }
 
                
                [collectiveConfirmationDictionary setObject:[[requestData objectForKey:@"REPORTEDBY"] uppercaseString] forKey:@"Muser"];
                [collectiveConfirmationDictionary setObject:@"18523416-177F-4B9B-9250-4F7A90A89537" forKey:@"Deviceid"];
                [collectiveConfirmationDictionary setObject:@"" forKey:@"Devicesno"];
                [collectiveConfirmationDictionary setObject:@"" forKey:@"Udid"];
                [collectiveConfirmationDictionary setObject:operationsItemsArray forKey:@"ItConfirmOrder"];
 
                 NSMutableArray *etOrderHeaderItems=[NSMutableArray new];
                NSMutableArray *etOrderMessageItems=[NSMutableArray new];
                NSMutableArray *etOrderOperationItems=[NSMutableArray new];
                NSMutableArray *etOrderStatusItems=[NSMutableArray new];
                NSMutableArray *etOrderComponentItems=[NSMutableArray new];
                NSMutableArray *etLongtextItems=[NSMutableArray new];
                NSMutableArray *etDocItems=[NSMutableArray new];
                NSMutableArray *esAufnrItems=[NSMutableArray new];
 
                [etLongtextItems addObject:[NSMutableDictionary dictionaryWithObjects:[NSArray array] forKeys:[NSArray array]]];
                [etOrderHeaderItems addObject:[NSMutableDictionary dictionaryWithObjects:[NSArray array] forKeys:[NSArray array]]];
                [etOrderMessageItems addObject:[NSMutableDictionary dictionaryWithObjects:[NSArray array] forKeys:[NSArray array]]];
                [etOrderOperationItems addObject:[NSMutableDictionary dictionaryWithObjects:[NSArray array] forKeys:[NSArray array]]];
                [etOrderComponentItems addObject:[NSMutableDictionary dictionaryWithObjects:[NSArray array] forKeys:[NSArray array]]];
                [etOrderStatusItems addObject:[NSMutableDictionary dictionaryWithObjects:[NSArray array] forKeys:[NSArray array]]];
                [esAufnrItems addObject:[NSMutableDictionary dictionaryWithObjects:[NSArray array] forKeys:[NSArray array]]];
                [etDocItems addObject:[NSMutableDictionary dictionaryWithObjects:[NSArray array] forKeys:[NSArray array]]];
 
                [collectiveConfirmationDictionary setObject:@"CNORD" forKey:@"Operation"];
                
                BOOL isCommit=true;
                
                [collectiveConfirmationDictionary setObject:[NSNumber numberWithBool:isCommit] forKey:@"IvCommit"];
                [collectiveConfirmationDictionary setObject:etOrderHeaderItems forKey:@"EtOrderHeader"];
                [collectiveConfirmationDictionary setObject:etOrderOperationItems forKey:@"EtOrderOperations"];
                [collectiveConfirmationDictionary setObject:etLongtextItems forKey:@"EtOrderLongtext"];
                [collectiveConfirmationDictionary setObject:etOrderStatusItems forKey:@"EtOrderStatus"];
                [collectiveConfirmationDictionary setObject:etDocItems forKey:@"EtDocs"];
                [collectiveConfirmationDictionary setObject:etOrderMessageItems forKey:@"EtMessages"];
                [collectiveConfirmationDictionary setObject:esAufnrItems forKey:@"EsAufnr"];
                
                
                NSError *error;
                NSData *jsonData = [NSJSONSerialization dataWithJSONObject:collectiveConfirmationDictionary options:NSJSONWritingPrettyPrinted error:&error];
                NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                [soapMessage appendString:jsonString];
                
            }
            
            break;
            
        case MONITOR_SET_EQUIP_MDOCS:
            
            if ([requestData count]) {
                
                NSMutableDictionary *measureMentDocsDictionary = [[NSMutableDictionary alloc] init];
                
 
                NSMutableArray *mdocsItemsArray=[NSMutableArray new];
                
                if ([[requestData objectForKey:@"MDOCS"] count]) {
                    
                    NSMutableArray *objectIds = [requestData objectForKey:@"MDOCS"];
                    
                    for (int i=0; i<[objectIds count]; i++) {
                        
                        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                        [dateFormatter setDateFormat:@"MMM dd, yyyy"];
                        
                        NSDate *tempDate = [dateFormatter dateFromString:[[objectIds objectAtIndex:i] objectAtIndex:4]];
                        [dateFormatter setDateFormat:@"yyyyMMdd"];
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
                        
//                        [soapMessage appendFormat:@"<item><Qmnum></Qmnum><Aufnr></Aufnr><Vornr></Vornr><Equnr>%@</Equnr><Mdocm></Mdocm><Point>%@</Point><Mpobj></Mpobj><Mpobt></Mpobt><Psort></Psort><Pttxt></Pttxt><Atinn></Atinn><Idate>%@</Idate><Itime>%@</Itime><Mdtxt>%@</Mdtxt><Readr></Readr><Atbez></Atbez><Msehi></Msehi><Msehl></Msehl><Readc>%@</Readc><Desic></Desic><Prest></Prest><Docaf>%@</Docaf><Codct></Codct><Codgr></Codgr><Vlcod>%@</Vlcod><Action>I</Action></item>",[[objectIds objectAtIndex:i] objectAtIndex:2],[[objectIds objectAtIndex:i] objectAtIndex:3],convertedDateString,[[objectIds objectAtIndex:i] objectAtIndex:5],[[objectIds objectAtIndex:i] objectAtIndex:6],[[objectIds objectAtIndex:i] objectAtIndex:7],vlocdString,[[objectIds objectAtIndex:i] objectAtIndex:9]];
                        
                         [mdocsItemsArray addObject:[NSMutableDictionary dictionaryWithObjects:[NSArray arrayWithObjects:[[objectIds objectAtIndex:i] objectAtIndex:2],[[objectIds objectAtIndex:i] objectAtIndex:3],convertedDateString,[[objectIds objectAtIndex:i] objectAtIndex:5],[[objectIds objectAtIndex:i] objectAtIndex:6],[[objectIds objectAtIndex:i] objectAtIndex:7],vlocdString,[[objectIds objectAtIndex:i] objectAtIndex:10],@"I",[[objectIds objectAtIndex:i] objectAtIndex:9], nil] forKeys:[NSArray arrayWithObjects:@"Equnr",@"Point",@"Idate",@"Itime",@"Mdtxt",@"Readc",@"Docaf",@"Vlcod",@"Action",@"Atbez", nil]]];
                        
                    }
                    
                }
                
                [measureMentDocsDictionary setObject:mdocsItemsArray forKey:@"ItMeaImrg"];
                 [measureMentDocsDictionary setObject:[NSArray array] forKey:@"EtMeaImrg"];
                [measureMentDocsDictionary setObject:[NSArray array] forKey:@"EtBapiret"];
                [measureMentDocsDictionary setObject:[NSArray array] forKey:@"EtMsg"];
                [measureMentDocsDictionary setObject:[[requestData objectForKey:@"REPORTEDBY"] uppercaseString] forKey:@"Muser"];
                [measureMentDocsDictionary setObject:@"18523416-177F-4B9B-9250-4F7A90A89537" forKey:@"Udid"];
                [measureMentDocsDictionary setObject:[requestData objectForKey:@"TRANSMITTYPE"] forKey:@"TransmitType"];
                
                BOOL isCommit=true;
                
                [measureMentDocsDictionary setObject:[NSNumber numberWithBool:isCommit] forKey:@"VCommit"];
                
                NSError *error;
                NSData *jsonData = [NSJSONSerialization dataWithJSONObject:measureMentDocsDictionary options:NSJSONWritingPrettyPrinted error:&error];
                NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                [soapMessage appendString:jsonString];
                
            }
            
            break;
            
        case UTILITY_RESERVE:
         
            if ([requestData count]) {
 
                NSMutableDictionary *reserveDictionary = [[NSMutableDictionary alloc] init];
                
                NSMutableDictionary *reserveHeaderDictionary = [[NSMutableDictionary alloc] init];

                
                NSMutableArray *reservationHeaderArray = [[NSMutableArray alloc] init];
 
                [reserveHeaderDictionary setObject:[requestData objectForKey:@"MOVEMENT"] forKey:@"MovementType"];
                [reserveHeaderDictionary setObject:[requestData objectForKey:@"PLANT"] forKey:@"Plant"];
                [reserveHeaderDictionary setObject:[requestData objectForKey:@"CCENTER"] forKey:@"CostCenter"];
                [reserveHeaderDictionary setObject:[requestData objectForKey:@"ORDERNO"] forKey:@"OrderNo"];
                
                [reserveHeaderDictionary setObject:[NSArray array] forKey:@"BRHFields"];

                
                [reservationHeaderArray addObject:reserveHeaderDictionary];
                
                NSMutableArray *reservationItemsArray = [[NSMutableArray alloc] init];
                NSMutableArray *reserveItmes = [requestData objectForKey:@"ITEMS"];
                for (int i=0; i<[reserveItmes count]; i++) {
                    
                 NSString *convertedrequiredStartDateString = [[[reserveItmes objectAtIndex:i] objectAtIndex:3] copy];

                    if ([NullChecker isNull:convertedrequiredStartDateString]) {
                        
                        convertedrequiredStartDateString=@"00000000";
                    }
                    
                    NSMutableDictionary *reserveItmesDictionary = [[NSMutableDictionary alloc] init];
                     [reserveItmesDictionary setObject:[[reserveItmes objectAtIndex:i] objectAtIndex:0] forKey:@"BomComponent"];
                    [reserveItmesDictionary setObject:[[reserveItmes objectAtIndex:i] objectAtIndex:1] forKey:@"Quantity"];
                    [reserveItmesDictionary setObject:[[reserveItmes objectAtIndex:i] objectAtIndex:2] forKey:@"Unit"];
                    [reserveItmesDictionary setObject:convertedrequiredStartDateString forKey:@"ReqmtDate"];
                    
                    [reserveItmesDictionary setObject:[[reserveItmes objectAtIndex:i] lastObject] forKey:@"StoreLoc"];
                    
                    [reserveItmesDictionary setObject:[NSArray array] forKey:@"BRCFields"];
 
                    [reservationItemsArray addObject:reserveItmesDictionary];
                    
                }
                
                 [reserveDictionary setObject:reservationItemsArray forKey:@"ItReservComp"];
                 [reserveDictionary setObject:reservationHeaderArray forKey:@"IsReservHeader"];
                 [reserveDictionary setObject:[NSArray array] forKey:@"EtMessage"];
                 [reserveDictionary setObject:[[requestData objectForKey:@"REPORTEDBY"] uppercaseString] forKey:@"Muser"];
                [reserveDictionary setObject:@"18523416-177F-4B9B-9250-4F7A90A89537" forKey:@"Udid"];
                [reserveDictionary setObject:[requestData objectForKey:@"TRANSMITTYPE"] forKey:@"IvTransmitType"];
                
                  BOOL isCommit=true;
                
                [reserveDictionary setObject:[NSNumber numberWithBool:isCommit] forKey:@"IvCommit"];

                NSError *error;
                NSData *jsonData = [NSJSONSerialization dataWithJSONObject:reserveDictionary options:NSJSONWritingPrettyPrinted error:&error];
                NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                [soapMessage appendString:jsonString];
                
             }
            
            break;
      
        case GET_MATERIAL_AVAILABILITY_CHECK:

            if ([requestData count]) {

            NSMutableDictionary *materialAvailCheckDictionary = [[NSMutableDictionary alloc] init];
            
            [materialAvailCheckDictionary setObject:[[requestData objectForKey:@"REPORTEDBY"] uppercaseString] forKey:@"Muser"];
                
            [materialAvailCheckDictionary setObject:@"18523416-177F-4B9B-9250-4F7A90A89537" forKey:@"Deviceid"];
            [materialAvailCheckDictionary setObject:@"123" forKey:@"Devicesno"];
            [materialAvailCheckDictionary setObject:@"12456" forKey:@"Udid"];
            
            NSDateFormatter *availDateFormat = [[NSDateFormatter alloc] init];
            [availDateFormat setDateFormat:@"yyyyMMdd"];
            NSMutableArray *matnrItemsArray = [[NSMutableArray alloc] init];
            // NSMutableArray *matnrItems = [requestData objectForKey:@"ITEMS"];
            double unixStartTime;
            //for (int i=0; i<[matnrItems count]; i++) {
            NSDate *startDate = [availDateFormat dateFromString:[requestData objectForKey:@"RDATE"]];
            unixStartTime = [startDate timeIntervalSince1970] * 1000;
            NSMutableDictionary *matnrItmesDictionary = [[NSMutableDictionary alloc] init];
            [matnrItmesDictionary setObject:[requestData objectForKey:@"MATERIAL"] forKey:@"Matnr"];
            [matnrItmesDictionary setObject:@"" forKey:@"Maktx"];
            [matnrItmesDictionary setObject:[requestData objectForKey:@"PLANT"] forKey:@"Werks"];
            [matnrItmesDictionary setObject:@"" forKey:@"Arbpl"];
            [matnrItmesDictionary setObject:[requestData objectForKey:@"STORAGELOCATION"] forKey:@"Lgort"];
            [matnrItmesDictionary setObject:@"" forKey:@"Lgpla"];
            [matnrItmesDictionary setObject:@"" forKey:@"Bwart"];
            [matnrItmesDictionary setObject:[requestData objectForKey:@"RDATE"] forKey:@"Rdate"];
            [matnrItmesDictionary setObject:[requestData objectForKey:@"QUANTITY"] forKey:@"Erfmg"];
            [matnrItmesDictionary setObject:@"" forKey:@"Erfme"];
            [matnrItmesDictionary setObject:@"" forKey:@"Bemot"];
            [matnrItmesDictionary setObject:@"" forKey:@"Kostl"];
            [matnrItmesDictionary setObject:@"" forKey:@"Sobkz"];
            [matnrItmesDictionary setObject:@"" forKey:@"CheckRule"];
            [matnrItmesDictionary setObject:@"" forKey:@"Aufnr"];
            [matnrItmesDictionary setObject:@"" forKey:@"Vornr"];
            [matnrItmesDictionary setObject:@"" forKey:@"Rsnum"];
            [matnrItmesDictionary setObject:@"" forKey:@"Rspos"];
            [matnrItemsArray addObject:matnrItmesDictionary];
            // }
 
            [materialAvailCheckDictionary setObject:matnrItemsArray forKey:@"ItMatnrPost"];
            [materialAvailCheckDictionary setObject:[NSArray array] forKey:@"EvAvailable"];
            
            NSError *error;
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:materialAvailCheckDictionary options:NSJSONWritingPrettyPrinted error:&error];
            NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            [soapMessage appendString:jsonString];
            
            }
 
            break;
            
        case ORDER_COLLECTIVE_CONFIRMATION:
            
            if ([requestData count]) {
                
                NSMutableDictionary *collectiveConfirmationDictionary = [[NSMutableDictionary alloc] init];
 
                 NSMutableArray *operationsItemsArray=[NSMutableArray new];
                NSMutableArray *attachmentsItemsArray=[NSMutableArray new];
                NSMutableArray *mdocsItemsArray=[NSMutableArray new];
 
                if ([[requestData objectForKey:@"OSTATUS"] isEqualToString:@""])
                {
                    if ([requestData objectForKey:@"ITEMS"]) {
                        NSMutableArray *objectIds = [requestData objectForKey:@"ITEMS"];
                        for (int i=0; i<[objectIds count]; i++) {
                            if ([[[objectIds objectAtIndex:i] objectAtIndex:10] isEqualToString:@"New"]) {
 
                                [operationsItemsArray addObject:[NSMutableDictionary dictionaryWithObjects:[NSArray arrayWithObjects:[requestData objectForKey:@"OBJECTID"],[[objectIds objectAtIndex:i] objectAtIndex:1],[[objectIds objectAtIndex:i] objectAtIndex:11],[[objectIds objectAtIndex:i] objectAtIndex:23],[[objectIds objectAtIndex:i] objectAtIndex:25],[[objectIds objectAtIndex:i] objectAtIndex:8],[requestData objectForKey:@"EMPLOYEE"],[requestData objectForKey:@"SDATE"],[requestData objectForKey:@"EDATE"],[requestData objectForKey:@"STIME"],[requestData objectForKey:@"ETIME"], nil] forKeys:[NSArray arrayWithObjects:@"Aufnr",@"Vornr",@"ConfText",@"Grund",@"Leknw",@"Aueru",@"Pernr",@"ExecStartDate",@"ExecFinDate",@"ExecStartTime",@"ExecFinTime", nil]]];
                                
                            }
                        }
                    }
                }
                else{
 
                     [operationsItemsArray addObject:[NSMutableDictionary dictionaryWithObjects:[NSArray arrayWithObjects:[requestData objectForKey:@"OBJECTID"],@"TECO", nil] forKeys:[NSArray arrayWithObjects:@"Aufnr",@"Status", nil]]];
                }
                
                
                if ([[requestData objectForKey:@"ATTACHMENTS"] count]) {
                    
                    attachDocs = [NSMutableString new];
                    
                    NSArray *attachmentsArray = [requestData objectForKey:@"ATTACHMENTS"];
                    
                    for (int i =0; i<[attachmentsArray count]; i++) {
 
                        [attachmentsItemsArray addObject:[NSMutableDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"Q",@"QH",[[attachmentsArray objectAtIndex:i] objectAtIndex:3],[[attachmentsArray objectAtIndex:i] objectAtIndex:4],[[attachmentsArray objectAtIndex:i] objectAtIndex:5],[[attachmentsArray objectAtIndex:i] objectAtIndex:7],[[attachmentsArray objectAtIndex:i] objectAtIndex:2], nil] forKeys:[NSArray arrayWithObjects:@"Zdoctype",@"ZdoctypeItem",@"Filename",@"Filetype",@"Fsize",@"Content",@"Objtype", nil]]];
                      }
                  }
 
                if ([[requestData objectForKey:@"MDOCS"] count]) {
                    
                    NSMutableArray *objectIds = [requestData objectForKey:@"MDOCS"];
                    
                    for (int i=0; i<[objectIds count]; i++) {
                        
                        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                        [dateFormatter setDateFormat:@"MMM dd, yyyy"];
                        
                        NSDate *tempDate = [dateFormatter dateFromString:[[objectIds objectAtIndex:i]  objectAtIndex:11]];
                        [dateFormatter setDateFormat:@"yyyyMM-dd"];
                        NSString *convertedDateString = [dateFormatter stringFromDate:tempDate];
                        
                        if ([NullChecker isNull:convertedDateString]) {
                            convertedDateString = @"";
                        }
                        
                        [dateFormatter setDateFormat:@"hh:mm a"];
                        
                        NSDate *tempTime = [dateFormatter dateFromString:[[objectIds objectAtIndex:i]  objectAtIndex:12]];
                        [dateFormatter setDateFormat:@"hhmmss"];
                        
                        NSString *convertedTimeString = [dateFormatter stringFromDate:tempTime];
                        
                        if ([NullChecker isNull:convertedTimeString]) {
                            convertedTimeString = @"";
                        }
 
                    [mdocsItemsArray addObject:[NSMutableDictionary dictionaryWithObjects:[NSArray arrayWithObjects:[requestData objectForKey:@"OBJECTID"],[[objectIds objectAtIndex:i]  objectAtIndex:5],convertedDateString,convertedTimeString,[[objectIds objectAtIndex:i]  objectAtIndex:14],[[objectIds objectAtIndex:i]  objectAtIndex:21],@"I", nil] forKeys:[NSArray arrayWithObjects:@"Aufnr",@"Point",@"Idate",@"Itime",@"Readc",@"Docaf",@"Action", nil]]];
                        
                     }
                }
                
                [collectiveConfirmationDictionary setObject:[[requestData objectForKey:@"REPORTEDBY"] uppercaseString] forKey:@"Muser"];
                [collectiveConfirmationDictionary setObject:@"18523416-177F-4B9B-9250-4F7A90A89537" forKey:@"Deviceid"];
                [collectiveConfirmationDictionary setObject:@"123" forKey:@"Devicesno"];
                [collectiveConfirmationDictionary setObject:@"12456" forKey:@"Udid"];
                
                [collectiveConfirmationDictionary setObject:operationsItemsArray forKey:@"ItConfirmOrderColl"];
                [collectiveConfirmationDictionary setObject:attachmentsItemsArray forKey:@"ItDocs"];
                [collectiveConfirmationDictionary setObject:mdocsItemsArray forKey:@"ItImrg"];
 
 
                NSMutableArray *etOrderHeaderItems=[NSMutableArray new];
                NSMutableArray *etOrderMessageItems=[NSMutableArray new];
                NSMutableArray *etOrderOperationItems=[NSMutableArray new];
                NSMutableArray *etOrderStatusItems=[NSMutableArray new];
                NSMutableArray *etOrderComponentItems=[NSMutableArray new];
                NSMutableArray *etLongtextItems=[NSMutableArray new];
                NSMutableArray *etDocItems=[NSMutableArray new];
                NSMutableArray *esAufnrItems=[NSMutableArray new];


                [etLongtextItems addObject:[NSMutableDictionary dictionaryWithObjects:[NSArray array] forKeys:[NSArray array]]];
                [etOrderHeaderItems addObject:[NSMutableDictionary dictionaryWithObjects:[NSArray array] forKeys:[NSArray array]]];
                [etOrderMessageItems addObject:[NSMutableDictionary dictionaryWithObjects:[NSArray array] forKeys:[NSArray array]]];
                [etOrderOperationItems addObject:[NSMutableDictionary dictionaryWithObjects:[NSArray array] forKeys:[NSArray array]]];
                [etOrderComponentItems addObject:[NSMutableDictionary dictionaryWithObjects:[NSArray array] forKeys:[NSArray array]]];
                [etOrderStatusItems addObject:[NSMutableDictionary dictionaryWithObjects:[NSArray array] forKeys:[NSArray array]]];
                [esAufnrItems addObject:[NSMutableDictionary dictionaryWithObjects:[NSArray array] forKeys:[NSArray array]]];
                 [etDocItems addObject:[NSMutableDictionary dictionaryWithObjects:[NSArray array] forKeys:[NSArray array]]];

                
                [collectiveConfirmationDictionary setObject:@"CCORD" forKey:@"Operation"];

                BOOL isCommit=true;
                
                [collectiveConfirmationDictionary setObject:[NSNumber numberWithBool:isCommit] forKey:@"IvCommit"];
                 [collectiveConfirmationDictionary setObject:etOrderHeaderItems forKey:@"EtOrderHeader"];
                [collectiveConfirmationDictionary setObject:etOrderOperationItems forKey:@"EtOrderOperations"];
                [collectiveConfirmationDictionary setObject:etLongtextItems forKey:@"EtOrderLongtext"];
                [collectiveConfirmationDictionary setObject:etOrderStatusItems forKey:@"EtOrderStatus"];
                [collectiveConfirmationDictionary setObject:etDocItems forKey:@"EtDocs"];
                [collectiveConfirmationDictionary setObject:etOrderMessageItems forKey:@"EtMessages"];
                [collectiveConfirmationDictionary setObject:esAufnrItems forKey:@"EsAufnr"];

 
                NSError *error;
                NSData *jsonData = [NSJSONSerialization dataWithJSONObject:collectiveConfirmationDictionary options:NSJSONWritingPrettyPrinted error:&error];
                NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                [soapMessage appendString:jsonString];
                
            }
            
            break;
            
        case PERMIT_CREATE:
            
             if ([requestData count])
            {
                
                NSMutableArray *longTextItems = [[NSMutableArray alloc] init];
                NSMutableArray *wcmApplicationItems = [[NSMutableArray alloc] init];
                NSMutableArray *wcmWorkRequirentsItems = [[NSMutableArray alloc] init];
                NSMutableArray *wcmWorkApprovalsItems = [[NSMutableArray alloc] init];
                NSMutableArray *issuepermitItems = [[NSMutableArray alloc] init];

                NSMutableArray *operationWCDItems = [[NSMutableArray alloc] init];
                NSMutableArray *taggingConditionItems = [[NSMutableArray alloc] init];
                 NSMutableArray *tagItems = [[NSMutableArray alloc] init];
                NSMutableArray *unTaggItems = [[NSMutableArray alloc] init];

 
                if ([[requestData objectForKey:@"WCMWORKAPPlICATIONS"] count]) {
                    
                    NSArray *wcmWorkApplication = [requestData objectForKey:@"WCMWORKAPPlICATIONS"];
                    
                    for (int i =0; i<[wcmWorkApplication count]; i++) {
                        
                        [wcmApplicationItems addObject:[NSMutableDictionary dictionaryWithObjects:[NSArray arrayWithObjects:[requestData objectForKey:@"OBJECTID"],[[[wcmWorkApplication objectAtIndex:i] firstObject] objectAtIndex:1],[[[wcmWorkApplication objectAtIndex:i] firstObject] objectAtIndex:2],[[[wcmWorkApplication objectAtIndex:i] firstObject] objectAtIndex:3],[[[wcmWorkApplication objectAtIndex:i] firstObject] objectAtIndex:4],[[[wcmWorkApplication objectAtIndex:i] firstObject] objectAtIndex:5],[[[wcmWorkApplication objectAtIndex:i] firstObject] objectAtIndex:6],@"",@"",@"",@"",@"",@"",[[[wcmWorkApplication objectAtIndex:i] firstObject] objectAtIndex:29],[[[wcmWorkApplication objectAtIndex:i] firstObject] objectAtIndex:30],[[[wcmWorkApplication objectAtIndex:i] firstObject] objectAtIndex:13],[[[wcmWorkApplication objectAtIndex:i] firstObject] objectAtIndex:14],[[[wcmWorkApplication objectAtIndex:i] firstObject] objectAtIndex:15],[[[wcmWorkApplication objectAtIndex:i] firstObject] objectAtIndex:16],[[[wcmWorkApplication objectAtIndex:i] firstObject] objectAtIndex:17],@"",[[[wcmWorkApplication objectAtIndex:i] firstObject] objectAtIndex:19],@"0",@"",@"",[[[wcmWorkApplication objectAtIndex:i] firstObject] objectAtIndex:23],@"",@"",@"",@"",[[[wcmWorkApplication objectAtIndex:i] firstObject] objectAtIndex:28], nil] forKeys:[NSArray arrayWithObjects:@"Aufnr",@"Objart",@"Wapinr",@"Iwerk",@"Objtyp",@"Usage",@"Usagex",@"Train",@"Trainx",@"Anlzu",@"Anlzux",@"Etape",@"Etapex",@"Begru",@"Begtx",@"Stxt",@"Datefr",@"Timefr",@"Dateto",@"Timeto",@"Priok",@"Priokx",@"Rctime",@"Rcunit",@"Objnr",@"Refobj",@"Crea",@"Prep",@"Comp",@"Appr",@"Action",nil]]];
                        
                        
                        if (![[[[wcmWorkApplication objectAtIndex:i] firstObject] objectAtIndex:4] isEqualToString:@"1"] || ![[[[wcmWorkApplication objectAtIndex:i] firstObject] objectAtIndex:4] isEqualToString:@"7"]) {
                            
                            NSArray *wcmHStandardCheckPoints = [[wcmWorkApplication objectAtIndex:i] objectAtIndex:1];
                            
                            for (int j =0; j<[wcmHStandardCheckPoints count]; j++) {
                                
                                checkPointDescriptionString = [self getcodeforkeys:[[wcmHStandardCheckPoints objectAtIndex:j] objectAtIndex:6]];
                                
                                [wcmWorkRequirentsItems addObject:[NSMutableDictionary dictionaryWithObjects:[NSArray arrayWithObjects:[[wcmHStandardCheckPoints objectAtIndex:j] objectAtIndex:0],[[wcmHStandardCheckPoints objectAtIndex:j] objectAtIndex:1],@"W",[[wcmHStandardCheckPoints objectAtIndex:j] objectAtIndex:3],[[wcmHStandardCheckPoints objectAtIndex:j] objectAtIndex:5],checkPointDescriptionString, nil] forKeys:[NSArray arrayWithObjects:@"Wapinr",@"Wapityp",@"ChkPointType",@"Wkid",@"Value",@"Desctext",nil]]];
                                
                            }
                            
                            NSArray *wcmCStandardCheckPoints = [[wcmWorkApplication objectAtIndex:i] objectAtIndex:2];
                            
                            for (int j =0; j<[wcmCStandardCheckPoints count]; j++) {
                                
                                checkPointDescriptionString = [self getcodeforkeys:[[wcmCStandardCheckPoints objectAtIndex:j] objectAtIndex:6]];
                                
                                [wcmWorkRequirentsItems addObject:[NSMutableDictionary dictionaryWithObjects:[NSArray arrayWithObjects:[[wcmCStandardCheckPoints objectAtIndex:j] objectAtIndex:0],[[wcmCStandardCheckPoints objectAtIndex:j] objectAtIndex:1],@"R",[[wcmCStandardCheckPoints objectAtIndex:j] objectAtIndex:4],[[wcmCStandardCheckPoints objectAtIndex:j] objectAtIndex:5],checkPointDescriptionString, nil] forKeys:[NSArray arrayWithObjects:@"Wapinr",@"Wapityp",@"ChkPointType",@"Needid",@"Value",@"Desctext",nil]]];
                                
                            }
                        }
                    }
                }
                
                
                if ([[requestData objectForKey:@"WCMWORKAPPROVALS"] count]) {
                    
                    NSArray *wcmWorkApproval = [requestData objectForKey:@"WCMWORKAPPROVALS"];
                    
                    for (int i =0; i<[wcmWorkApproval count]; i++) {
                        
                         [wcmWorkApprovalsItems addObject:[NSMutableDictionary dictionaryWithObjects:[NSArray arrayWithObjects:[requestData objectForKey:@"OBJECTID"],[[wcmWorkApproval objectAtIndex:i] objectAtIndex:1],[[wcmWorkApproval objectAtIndex:i] objectAtIndex:2],[[wcmWorkApproval objectAtIndex:i] objectAtIndex:3],[[wcmWorkApproval objectAtIndex:i] objectAtIndex:4],[[wcmWorkApproval objectAtIndex:i] objectAtIndex:5],[[wcmWorkApproval objectAtIndex:i] objectAtIndex:6],[[wcmWorkApproval objectAtIndex:i] objectAtIndex:7],[[wcmWorkApproval objectAtIndex:i] objectAtIndex:8],[[wcmWorkApproval objectAtIndex:i] objectAtIndex:9],[[wcmWorkApproval objectAtIndex:i] objectAtIndex:10],[[wcmWorkApproval objectAtIndex:i] objectAtIndex:11],[[wcmWorkApproval objectAtIndex:i] objectAtIndex:29],[[wcmWorkApproval objectAtIndex:i] objectAtIndex:30],[[wcmWorkApproval objectAtIndex:i] objectAtIndex:12],[[wcmWorkApproval objectAtIndex:i] objectAtIndex:13],[[wcmWorkApproval objectAtIndex:i] objectAtIndex:14],[[wcmWorkApproval objectAtIndex:i] objectAtIndex:15],[[wcmWorkApproval objectAtIndex:i] objectAtIndex:16],[[wcmWorkApproval objectAtIndex:i] objectAtIndex:17],[[wcmWorkApproval objectAtIndex:i] objectAtIndex:18],@"0",@"",[[wcmWorkApproval objectAtIndex:i] objectAtIndex:21],[[wcmWorkApproval objectAtIndex:i] objectAtIndex:22],[[wcmWorkApproval objectAtIndex:i] objectAtIndex:23],[[wcmWorkApproval objectAtIndex:i] objectAtIndex:24],[[wcmWorkApproval objectAtIndex:i] objectAtIndex:25],[[wcmWorkApproval objectAtIndex:i] objectAtIndex:26],[[wcmWorkApproval objectAtIndex:i] objectAtIndex:27],[[wcmWorkApproval objectAtIndex:i] objectAtIndex:28], nil] forKeys:[NSArray arrayWithObjects:@"Aufnr",@"Objart",@"Wapnr",@"Iwerk",@"Usage",@"Usagex",@"Train",@"Trainx",@"Anlzu",@"Anlzux",@"Etape",@"Etapex",@"Begru",@"Begtx",@"Stxt",@"Datefr",@"Timefr",@"Dateto",@"Timeto",@"Priok",@"Priokx",@"Rctime",@"Rcunit",@"Objnr",@"Refobj",@"Crea",@"Prep",@"Comp",@"Appr",@"Pappr",@"Action",nil]]];
                        
                     }
                }
 
                
                if ([[requestData objectForKey:@"WCMISSUEPERMITS"] count]) {
                    
                    NSArray *wcmIssuePermits = [requestData objectForKey:@"WCMISSUEPERMITS"];
 
                    for (int i =0; i<[wcmIssuePermits count]; i++) {
                        
                        [issuepermitItems addObject:[NSMutableDictionary dictionaryWithObjects:[NSArray arrayWithObjects:[requestData objectForKey:@"OBJECTID"],[[wcmIssuePermits objectAtIndex:i] objectAtIndex:1],[[wcmIssuePermits objectAtIndex:i] objectAtIndex:2],[[wcmIssuePermits objectAtIndex:i] objectAtIndex:3],[[wcmIssuePermits objectAtIndex:i] objectAtIndex:4],[[wcmIssuePermits objectAtIndex:i] objectAtIndex:5],[[wcmIssuePermits objectAtIndex:i] objectAtIndex:6],[[wcmIssuePermits objectAtIndex:i] objectAtIndex:7],[[wcmIssuePermits objectAtIndex:i] objectAtIndex:8],[[wcmIssuePermits objectAtIndex:i] objectAtIndex:9],[[wcmIssuePermits objectAtIndex:i] objectAtIndex:10],[[wcmIssuePermits objectAtIndex:i] objectAtIndex:11],[[wcmIssuePermits objectAtIndex:i] objectAtIndex:12],[[wcmIssuePermits objectAtIndex:i] objectAtIndex:13],[[wcmIssuePermits objectAtIndex:i] objectAtIndex:14],[[wcmIssuePermits objectAtIndex:i] objectAtIndex:15],[[wcmIssuePermits objectAtIndex:i] objectAtIndex:16],[[wcmIssuePermits objectAtIndex:i] objectAtIndex:17],[[wcmIssuePermits objectAtIndex:i] objectAtIndex:18],[[wcmIssuePermits objectAtIndex:i] objectAtIndex:19],[[wcmIssuePermits objectAtIndex:i] objectAtIndex:20],[[wcmIssuePermits objectAtIndex:i] objectAtIndex:21],[[wcmIssuePermits objectAtIndex:i] objectAtIndex:22],[[wcmIssuePermits objectAtIndex:i] objectAtIndex:23], nil] forKeys:[NSArray arrayWithObjects:@"Aufnr",@"Objnr",@"Counter",@"Werks",@"Crname",@"Objart",@"Objtyp",@"Pmsog",@"Gntxt",@"Geniakt",@"Genvname",@"Hilvl",@"Procflg",@"Copyflg",@"Direction",@"Copyflg",@"Mandflg",@"Deacflg",@"Status",@"Asgnflg",@"Autoflg",@"Agent",@"Valflg",@"Wcmuse",@"Action",nil]]];
                      }
                  }
 
                
                if ([[requestData objectForKey:@"WCMOPERATIONWCD"] count]) {
                    
                    NSArray *wcmOperationWCD = [requestData objectForKey:@"WCMOPERATIONWCD"];
 
                    for (int i =0; i<[wcmOperationWCD count]; i++) {
 
                        if ([[[[wcmOperationWCD objectAtIndex:i] firstObject] objectAtIndex:31] length]) {
                            
                            NSArray *taggingTextArray = [[[[wcmOperationWCD objectAtIndex:i] firstObject] objectAtIndex:31] componentsSeparatedByString:@"\n"];
                            
                            for (int k=0; k<[taggingTextArray count]; k++) {
                                
                                 [unTaggItems addObject:[NSMutableDictionary dictionaryWithObjects:[NSArray arrayWithObjects:[requestData objectForKey:@"OBJECTID"],[[[wcmOperationWCD objectAtIndex:i] firstObject] objectAtIndex:2],[taggingTextArray objectAtIndex:k],@"I", nil] forKeys:[NSArray arrayWithObjects:@"Aufnr",@"Wcnr",@"Objtype",@"FormatCol",@"TextLine",@"Action",nil]]];
                              }
                        }
                        
                         if ([[[[wcmOperationWCD objectAtIndex:i] firstObject] objectAtIndex:32] length]) {
                            
                            NSArray *taggingTextArray = [[[[wcmOperationWCD objectAtIndex:i] firstObject] objectAtIndex:32] componentsSeparatedByString:@"\n"];
                            
                            for (int j=0; j<[taggingTextArray count]; j++) {
                                
                                 [unTaggItems addObject:[NSMutableDictionary dictionaryWithObjects:[NSArray arrayWithObjects:[requestData objectForKey:@"OBJECTID"],[[[wcmOperationWCD objectAtIndex:i] firstObject] objectAtIndex:2],[taggingTextArray objectAtIndex:j],@"I", nil] forKeys:[NSArray arrayWithObjects:@"Aufnr",@"Wcnr",@"Objtype",@"FormatCol",@"TextLine",@"Action",nil]]];
                              }
                         }
 


                        NSArray *wcmOperationWCDTaggingConditions = [[wcmOperationWCD objectAtIndex:i] objectAtIndex:1];
                        
                        for (int j =0; j<[wcmOperationWCDTaggingConditions count]; j++) {
                            
                           
                            [taggingConditionItems addObject:[NSMutableDictionary dictionaryWithObjects:[NSArray arrayWithObjects:[[wcmOperationWCDTaggingConditions objectAtIndex:j] objectAtIndex:0],[[wcmOperationWCDTaggingConditions objectAtIndex:j] objectAtIndex:1],[[wcmOperationWCDTaggingConditions objectAtIndex:j] objectAtIndex:2],[[wcmOperationWCDTaggingConditions objectAtIndex:j] objectAtIndex:3],[[wcmOperationWCDTaggingConditions objectAtIndex:j] objectAtIndex:4],[[wcmOperationWCDTaggingConditions objectAtIndex:j] objectAtIndex:5],[[wcmOperationWCDTaggingConditions objectAtIndex:j] objectAtIndex:6],[self getcodeforkeys:[[wcmOperationWCDTaggingConditions objectAtIndex:j] objectAtIndex:7]],[[wcmOperationWCDTaggingConditions objectAtIndex:j] objectAtIndex:8],[[wcmOperationWCDTaggingConditions objectAtIndex:j] objectAtIndex:9],[[wcmOperationWCDTaggingConditions objectAtIndex:j] objectAtIndex:10],[[wcmOperationWCDTaggingConditions objectAtIndex:j] objectAtIndex:11],[[wcmOperationWCDTaggingConditions objectAtIndex:j] objectAtIndex:12],[[wcmOperationWCDTaggingConditions objectAtIndex:j] objectAtIndex:13],[[wcmOperationWCDTaggingConditions objectAtIndex:j] objectAtIndex:14],[[wcmOperationWCDTaggingConditions objectAtIndex:j] objectAtIndex:15],[[wcmOperationWCDTaggingConditions objectAtIndex:j] objectAtIndex:16],[[wcmOperationWCDTaggingConditions objectAtIndex:j] objectAtIndex:17],[[wcmOperationWCDTaggingConditions objectAtIndex:j] objectAtIndex:18],[[wcmOperationWCDTaggingConditions objectAtIndex:j] objectAtIndex:19],[[wcmOperationWCDTaggingConditions objectAtIndex:j] objectAtIndex:20],[[wcmOperationWCDTaggingConditions objectAtIndex:j] objectAtIndex:21],[[wcmOperationWCDTaggingConditions objectAtIndex:j] objectAtIndex:22],[[wcmOperationWCDTaggingConditions objectAtIndex:j] objectAtIndex:23],[[wcmOperationWCDTaggingConditions objectAtIndex:j] objectAtIndex:24],[[wcmOperationWCDTaggingConditions objectAtIndex:j] objectAtIndex:25],[[wcmOperationWCDTaggingConditions objectAtIndex:j] objectAtIndex:26],[[wcmOperationWCDTaggingConditions objectAtIndex:j] objectAtIndex:27],[[wcmOperationWCDTaggingConditions objectAtIndex:j] objectAtIndex:28],[[wcmOperationWCDTaggingConditions objectAtIndex:j] objectAtIndex:29],[[wcmOperationWCDTaggingConditions objectAtIndex:j] objectAtIndex:30],[[wcmOperationWCDTaggingConditions objectAtIndex:j] objectAtIndex:31],[[wcmOperationWCDTaggingConditions objectAtIndex:j] objectAtIndex:32],[[wcmOperationWCDTaggingConditions objectAtIndex:j] objectAtIndex:33],[[wcmOperationWCDTaggingConditions objectAtIndex:j] objectAtIndex:34],
                                [[[wcmOperationWCD objectAtIndex:i] firstObject] objectAtIndex:22]
                            ,[[wcmOperationWCDTaggingConditions objectAtIndex:j] objectAtIndex:36], nil] forKeys:[NSArray arrayWithObjects:@"Wcnr",@"Wcitm",@"Objnr",@"Itmtyp",@"Seq",@"Pred",@"Succ",@"Ccobj",@"Cctyp",@"Stxt",@"Tggrp",@"Tgstep",@"Tgproc",@"Tgtyp",@"Tgseq",@"Tgtxt",@"Unstep",@"Untyp",@"Phblflg",@"Phbltyp",@"Phblnr",@"Tgflg",@"Tgform",@"Unform",@"Unnr",@"Control",@"Location",@"Btg",@"Etg",@"Bug",@"Eug",@"Refobj",@"Action",nil]]];
                           }
                        
                        [operationWCDItems addObject:[NSMutableDictionary dictionaryWithObjects:[NSArray arrayWithObjects:[requestData objectForKey:@"OBJECTID"],[[[wcmOperationWCD objectAtIndex:i] firstObject] objectAtIndex:1],[[[wcmOperationWCD objectAtIndex:i] firstObject] objectAtIndex:2],[[[wcmOperationWCD objectAtIndex:i] firstObject] objectAtIndex:3],[[[wcmOperationWCD objectAtIndex:i] firstObject] objectAtIndex:4],[[[wcmOperationWCD objectAtIndex:i] firstObject] objectAtIndex:5],[[[wcmOperationWCD objectAtIndex:i] firstObject] objectAtIndex:6],[[[wcmOperationWCD objectAtIndex:i] firstObject] objectAtIndex:7],[[[wcmOperationWCD objectAtIndex:i] firstObject] objectAtIndex:8],[[[wcmOperationWCD objectAtIndex:i] firstObject] objectAtIndex:9],[[[wcmOperationWCD objectAtIndex:i] firstObject] objectAtIndex:10],[[[wcmOperationWCD objectAtIndex:i] firstObject] objectAtIndex:11],[[[wcmOperationWCD objectAtIndex:i] firstObject] objectAtIndex:12],[[[wcmOperationWCD objectAtIndex:i] firstObject] objectAtIndex:29],[[[wcmOperationWCD objectAtIndex:i] firstObject] objectAtIndex:30],[[[wcmOperationWCD objectAtIndex:i] firstObject] objectAtIndex:13],[[[wcmOperationWCD objectAtIndex:i] firstObject] objectAtIndex:14],[[[wcmOperationWCD objectAtIndex:i] firstObject] objectAtIndex:15],[[[wcmOperationWCD objectAtIndex:i] firstObject] objectAtIndex:16],[[[wcmOperationWCD objectAtIndex:i] firstObject] objectAtIndex:17],[[[wcmOperationWCD objectAtIndex:i] firstObject] objectAtIndex:18],[[[wcmOperationWCD objectAtIndex:i] firstObject] objectAtIndex:19],[[[wcmOperationWCD objectAtIndex:i] firstObject] objectAtIndex:20],[[[wcmOperationWCD objectAtIndex:i] firstObject] objectAtIndex:21],[[[wcmOperationWCD objectAtIndex:i] firstObject] objectAtIndex:22],[[[wcmOperationWCD objectAtIndex:i] firstObject] objectAtIndex:23],[[[wcmOperationWCD objectAtIndex:i] firstObject] objectAtIndex:24],[[[wcmOperationWCD objectAtIndex:i] firstObject] objectAtIndex:25],[[[wcmOperationWCD objectAtIndex:i] firstObject] objectAtIndex:26],[[[wcmOperationWCD objectAtIndex:i] firstObject] objectAtIndex:27],[[[wcmOperationWCD objectAtIndex:i] firstObject] objectAtIndex:28],tagItems,unTaggItems,taggingConditionItems, nil] forKeys:[NSArray arrayWithObjects:@"Aufnr",@"Objart",@"Wcnr",@"Iwerk",@"Objtyp",@"Usage",@"Usagex",@"Train",@"Trainx",@"Anlzu",@"Anlzux",@"Etape",@"Etapex",@"Begru",@"Begtx",@"Stxt",@"Datefr",@"Timefr",@"Dateto",@"Priok",@"Priokx",@"Rctime",@"Rcunit",@"Objnr",@"Refobj",@"Crea",@"Prep",@"Comp",@"Appr",@"Action",@"ItWcmWdDataTagtext",@"ItWcmWdDataUntagtext",@"ItWcmWdItemData",nil]]];

                     }
                 }
                
                 NSMutableDictionary *orderCreate = [[NSMutableDictionary alloc] init];
                 NSMutableArray *etOrderMessageItems=[NSMutableArray new];
                 NSMutableArray *etOrderStatusItems=[NSMutableArray new];
                 NSMutableArray *etwcmApplicationItems=[NSMutableArray new];
                 NSMutableArray *etwcmWorkRequirentsItems=[NSMutableArray new];
                 NSMutableArray *etwcmWorkApprovalsItems=[NSMutableArray new];
                
                NSMutableArray *etOperationWCDItems=[NSMutableArray new];
                NSMutableArray *etWCMtagItems=[NSMutableArray new];
                NSMutableArray *etWCMUntagItems=[NSMutableArray new];
                NSMutableArray *etWCMWDItems=[NSMutableArray new];

 
                 [etOrderMessageItems addObject:[NSMutableDictionary dictionaryWithObjects:[NSArray array] forKeys:[NSArray array]]];
                 [etOrderStatusItems addObject:[NSMutableDictionary dictionaryWithObjects:[NSArray array] forKeys:[NSArray array]]];
                 [etwcmApplicationItems addObject:[NSMutableDictionary dictionaryWithObjects:[NSArray array] forKeys:[NSArray array]]];
                [etwcmWorkRequirentsItems addObject:[NSMutableDictionary dictionaryWithObjects:[NSArray array] forKeys:[NSArray array]]];
                 [etwcmWorkApprovalsItems addObject:[NSMutableDictionary dictionaryWithObjects:[NSArray array] forKeys:[NSArray array]]];
                
                [etWCMtagItems addObject:[NSMutableDictionary dictionaryWithObjects:[NSArray array] forKeys:[NSArray array]]];
                [etWCMUntagItems addObject:[NSMutableDictionary dictionaryWithObjects:[NSArray array] forKeys:[NSArray array]]];
                 [etWCMWDItems addObject:[NSMutableDictionary dictionaryWithObjects:[NSArray array] forKeys:[NSArray array]]];
                [etOperationWCDItems addObject:[NSMutableDictionary dictionaryWithObjects:[NSArray arrayWithObjects:etWCMtagItems,etWCMUntagItems,etWCMWDItems, nil] forKeys:[NSArray arrayWithObjects:@"EtWcmWdDataTagtext",@"EtWcmWdDataUntagtext",@"EtWcmWdItemData",nil]]];
 
                
                BOOL isCommit=true;
 
                [orderCreate setObject:wcmApplicationItems forKey:@"ItWcmWaData"];
                [orderCreate setObject:wcmWorkRequirentsItems forKey:@"ItWcmWaChkReq"];
                [orderCreate setObject:wcmWorkApprovalsItems forKey:@"ItWcmWwData"];
                [orderCreate setObject:wcmWorkApprovalsItems forKey:@"ItWcmWdData"];
                [orderCreate setObject:operationWCDItems forKey:@"ItWcmWdData"];
 
                
                [orderCreate setObject:[[requestData objectForKey:@"REPORTEDBY"] uppercaseString] forKey:@"IvUser"];
                //  [orderCreate setObject:attachmentsItems forKey:@"ItDocs"];
                [orderCreate setObject:[[requestData objectForKey:@"REPORTEDBY"] uppercaseString] forKey:@"Muser"];
                [orderCreate setObject:longTextItems forKey:@"ItOrderLongtext"];
                [orderCreate setObject:@"18523416-177F-4B9B-9250-4F7A90A89537" forKey:@"Deviceid"];
                [orderCreate setObject:@"" forKey:@"Udid"];
                [orderCreate setObject:[requestData objectForKey:@"TRANSMITTYPE"] forKey:@"IvTransmitType"];
                [orderCreate setObject:[NSNumber numberWithBool:isCommit] forKey:@"IvCommit"];
                [orderCreate setObject:@"WCMMP" forKey:@"Operation"];
                
                //For Response Data need to send  empty in ETformat
                [orderCreate setObject:etOrderStatusItems forKey:@"EtOrderStatus"];
                [orderCreate setObject:etOrderStatusItems forKey:@"EsAufnr"];
                [orderCreate setObject:etwcmApplicationItems forKey:@"EtWcmWaData"];
                [orderCreate setObject:etwcmWorkRequirentsItems forKey:@"EtWcmWaChkReq"];
                [orderCreate setObject:etwcmWorkApprovalsItems forKey:@"EtWcmWwData"];
                [orderCreate setObject:etOperationWCDItems forKey:@"EtWcmWdData"];

 
                NSError *error;
                NSData *jsonData = [NSJSONSerialization dataWithJSONObject:orderCreate options:NSJSONWritingPrettyPrinted error:&error];
                NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                [soapMessage appendString:jsonString];
            }
            
            break;
            
        default:
            break;
    }
   
    return soapMessage;
}


@end
