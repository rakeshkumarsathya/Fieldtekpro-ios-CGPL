//
//  JEValidator.m
//  ParentCare
//
//  Created by Deepak Gantala on 01/02/13.
//  Copyright (c) 2013 Enstrapp IT Solutions . All rights reserved.
//


#import "JEValidator.h"

#define DATE_COMPONENTS (NSYearCalendarUnit| NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekCalendarUnit |  NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit | NSWeekdayCalendarUnit | NSWeekdayOrdinalCalendarUnit)

#define CURRENT_CALENDAR [NSCalendar currentCalendar]

@implementation JEValidator

+(BOOL)validateTextValue:(NSString*)value	{
	if( !value || [value isKindOfClass:[NSNull class]] || [value isEqualToString:@""] )
		return NO;
	
	return YES;
}


+(BOOL)validateTextValue:(NSString*)value minLength:(NSInteger)minLength maxLength:(NSInteger)maxLength	{
	if( !value || [value isKindOfClass:[NSNull class]] || [value isEqualToString:@""] )
		return NO;
	
	NSInteger valueLength = [value length];
	if( !(valueLength >= minLength && valueLength <= maxLength) )
		return NO;
	
	return YES;
}


static NSString *emailRegExrp =	@"(?:[a-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[a-z0-9!#$%\\&'*+/=?\\^_`{|}"
@"~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\"
@"x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-"
@"z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5"
@"]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-"
@"9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21"
@"-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])";

static NSString *landlineReg =@"^[0-9]\\d{8}$";

+(BOOL)validateConfirmPassword:(NSString *)password :(NSString *)confirmPassword 
{
    if ([password isEqualToString:confirmPassword]) {
        return NO;
    }
    else {
        return YES;
    }
    
}

+(BOOL)validateEmailAddress:(NSString *)emailAddress {
	
	NSPredicate *emailPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegExrp];
	return [emailPredicate evaluateWithObject:emailAddress];
}
+(BOOL)validateLandLinePhone:(NSString *)LandLinePhoneNO {
	
	NSPredicate *emailPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", landlineReg];
	return [emailPredicate evaluateWithObject:LandLinePhoneNO];
}

+(BOOL)validateMobile:(NSString *)mobileNo {
	if (mobileNo.length == 10) {
        return NO;
    }
	
	return YES;
}

+(BOOL)validateUserName:(NSString *)value {
	if( !value || [value isKindOfClass:[NSNull class]] || [value isEqualToString:@""] )
		return NO;
	
	NSInteger valueLength = [value length];
	if(valueLength != 10)
		return NO;
	
	if(nil == [[[NSNumberFormatter alloc] init]  numberFromString:value])
		return NO;
	
	return YES;
}

+(BOOL)validatePhone:(NSString *)value {
	if( !value || [value isKindOfClass:[NSNull class]] || [value isEqualToString:@""])
		return NO;
	
	if(nil == [[[NSNumberFormatter alloc] init]  numberFromString:value])
		return NO;
	
	return YES;
}

+(BOOL)validateQuantity:(NSString *)value
{
	if( !value || [value isKindOfClass:[NSNull class]] || [value isEqualToString:@""] || [value isEqualToString:@"0"] || [value isEqualToString:@"00"] )
		return NO;
	
	if(nil == [[[NSNumberFormatter alloc] init]  numberFromString:value])
		return NO;
	
	return YES;	
}



//+(BOOL)validateDate:(NSDate*)date
//{
//	NSDateComponents *components1 = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:[NSDate date]];
//	NSDateComponents *components2 = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:date];
//	
//	NSLog(@"%d - %d - %d", (int)[components1 year], (int)[components1 month],(int) [components1 day]);
//	NSLog(@"%d - %d - %d", (int)[components2 year], (int)[components2 month], (int)[components2 day]);
//
//	return (([components1 year] <= [components2 year]) && ([components1 month] <= [components2 month]) && ([components1 day] <= [components2 day]));
//}

+(BOOL)validateTime:(NSString*)mainDate date:(NSString*)date
{
    
   
//    NSString *cc = @"asd asdasd ljkdfls ajdsakjs";
    NSString *BB = [mainDate stringByReplacingOccurrencesOfString:@" " withString:@""];
       
	if([self validateTextValue:BB])
	{
		NSArray *arr = [mainDate componentsSeparatedByString:@"and"];
      
		if([arr count] == 2)
		{
			NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
			[dateFormatter setDateFormat:@"hh:mma"];
			
			NSArray *ar1 = [[arr objectAtIndex:0] componentsSeparatedByString:@"to"];
			NSArray *ar2 = [[arr objectAtIndex:1] componentsSeparatedByString:@"to"];	
			
            
			NSDate *dt1 = [dateFormatter dateFromString:[ar1 objectAtIndex:0]];
			NSDate *dt2 = [dateFormatter dateFromString:[ar1 objectAtIndex:1]];
			NSDate *dt3 = [dateFormatter dateFromString:[ar2 objectAtIndex:0]];
			NSDate *dt4 = [dateFormatter dateFromString:[ar2 objectAtIndex:1]];
			
			NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
			[dateFormatter1 setDateFormat:@"HH.mm"];
			
			NSString *t1 = [dateFormatter1 stringFromDate:dt1];
			NSString *t2 = [dateFormatter1 stringFromDate:dt2];
			NSString *t3 = [dateFormatter1 stringFromDate:dt3];
			NSString *t4 = [dateFormatter1 stringFromDate:dt4];	
			
			double db1 = [t1 doubleValue];
			double db2 = [t2 doubleValue];
			double db3 = [t3 doubleValue];
			double db4 = [t4 doubleValue];
			
			NSString *curDate = [dateFormatter1 stringFromDate:[dateFormatter dateFromString:date]];
		
			double db = [curDate doubleValue];
			
			//NSLog(@"%f,,,, %f - %f %f %f ",db, db1, db2, db3, db4);
			//
			if(db >= db1 && db <= db2)
			{
				NSLog(@"in MORNING");
				return YES;
			}
			else if(db >= db3 && db <= db4)
			{
				NSLog(@"in EVENING");
				return YES;
			}	
			
			return NO;
		}
		
		NSArray *arr1 = [mainDate componentsSeparatedByString:@"to"];
		if([arr1 count] > 0)
		{
			NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
			[dateFormatter setDateFormat:@"hh:mma"];
			NSDate *dt1 = [dateFormatter dateFromString:[arr1 objectAtIndex:0]];
			NSDate *dt2 = [dateFormatter dateFromString:[arr1 objectAtIndex:1]];
			
			NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
			[dateFormatter1 setDateFormat:@"HH.mm"];
			NSString *t1 = [dateFormatter1 stringFromDate:dt1];
			NSString *t2 = [dateFormatter1 stringFromDate:dt2];
			
			double db1 = [t1 doubleValue];
			double db2 = [t2 doubleValue];

			NSString *curDate = [dateFormatter1 stringFromDate:[dateFormatter dateFromString:date]];
			
			double db = [curDate doubleValue];
			
			NSLog(@"%f - %f", db1, db2);
			//
			if(db >= db1 && db <= db2)
			{
				NSLog(@"in TIME");
				return YES;
			}
			return NO;
		}
	}

	return YES;
}

@end