//
//  JEValidator.h
//  ParentCare
//
//  Created by Deepak Gantala on 01/02/13.
//  Copyright (c) 2013 Enstrapp IT Solutions . All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JEValidator : NSObject {

}

+(BOOL)validateTextValue:(NSString*)value;
+(BOOL)validateTextValue:(NSString*)value minLength:(NSInteger)minLength maxLength:(NSInteger)maxLength;

+(BOOL)validateEmailAddress:(NSString*)emailAddress;

+(BOOL)validateUserName:(NSString*)userName;
+(BOOL)validatePhone:(NSString *)value;

+(BOOL)validateQuantity:(NSString *)value;

//+(BOOL)validateDate:(NSDate*)date;
+(BOOL)validateTime:(NSString*)mainDate date:(NSString*)date;
+(BOOL)validateConfirmPassword:(NSString *)password :(NSString *)confirmPassword;
+(BOOL)validateMobile:(NSString *)mobileNo;
@end
