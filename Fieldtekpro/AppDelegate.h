//
//  AppDelegate.h
//  Fieldtekpro
//
//  Created by Enstrapp Bangalore on 09/10/17.
//  Copyright © 2017 Enstrapp Bangalore. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IQKeyboardManager.h"
#import "CoreDataHelper.h"
#import "DataBase.h"

@import Firebase;

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    NSString *databasePath;
    UILocalNotification *localNotification ;
     NSTimer* dataTimer;
}
@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, strong) CoreDataHelper *coreDataControlObject;

@property (nonatomic, strong) NSString *deviceTokenString;
@property (nonatomic, strong) NSUserDefaults *defaults;

@property (strong, nonatomic) UIViewController *viewController;

 


+(NSDictionary *)fetchingPathForPlist;
+ (NSInteger)daysBetweenDate:(NSDate*)fromDateTime andDate:(NSDate*)toDateTime;
+ (NSInteger)secondsBetweenDate:(NSDate*)fromDateTime andDate:(NSDate*)toDateTime;

@end

