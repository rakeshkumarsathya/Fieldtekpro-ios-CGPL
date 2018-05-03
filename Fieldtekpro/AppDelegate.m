//
//  AppDelegate.m
//  Fieldtekpro
//
//  Created by Enstrapp Bangalore on 09/10/17.
//  Copyright © 2017 Enstrapp Bangalore. All rights reserved.
//

#import "AppDelegate.h"

#if defined(__IPHONE_10_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
@import UserNotifications;
#endif

// Implement UNUserNotificationCenterDelegate to receive display notification via APNS for devices
// running iOS 10 and above.
#if defined(__IPHONE_10_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0

#define isiPhone5  ([[UIScreen mainScreen] bounds].size.height == 568)?TRUE:FALSE
#define isiPhone6 ( [[UIScreen mainScreen] bounds].size.height == 667)?TRUE:FALSE
#define IS_IPHONE_6_PLUS ([[UIScreen mainScreen] bounds].size.height == 736.0)?TRUE:FALSE

@interface AppDelegate ()<UNUserNotificationCenterDelegate,FIRMessagingDelegate>
// Stores reference on PubNub client to make sure what it won't be released.

#endif

// Copied from Apple's header in case it is missing in some cases (e.g. pre-Xcode 8 builds).
#ifndef NSFoundationVersionNumber_iOS_9_x_Max
#define NSFoundationVersionNumber_iOS_9_x_Max 1299
#endif

@end

@interface AppDelegate ()

@end

@implementation AppDelegate
@synthesize defaults;

NSString *const kGCMMessageIDKey = @"gcm.message_id";


- (CoreDataHelper *)coreDateInitialize
{
    if (!_coreDataControlObject) {

        _coreDataControlObject = [CoreDataHelper new];
        [_coreDataControlObject setupCoreData];
    }
    
    return _coreDataControlObject;
}

+(NSDictionary *)fetchingPathForPlist{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString* plistPath = [documentsDirectory stringByAppendingPathComponent:@"LabelsContent.plist"];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:plistPath]) {
        plistPath = [[NSBundle mainBundle] pathForResource:@"LabelsContent" ofType:@"plist"];
    }
    
    NSDictionary *dictPlistForLabelsContent = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
    
    return dictPlistForLabelsContent;
}

#pragma mark-
#pragma mark- UIDate Comparision

+ (NSInteger)daysBetweenDate:(NSDate*)fromDateTime andDate:(NSDate*)toDateTime
{
    NSDate *fromDate;
    NSDate *toDate;
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    [calendar rangeOfUnit:NSCalendarUnitDay startDate:&fromDate
                 interval:NULL forDate:fromDateTime];
    [calendar rangeOfUnit:NSCalendarUnitDay startDate:&toDate
                 interval:NULL forDate:toDateTime];
    
    NSDateComponents *difference = [calendar components:NSCalendarUnitDay
                                               fromDate:fromDate toDate:toDate options:0];
    
    return [difference day];
}

+ (NSInteger)secondsBetweenDate:(NSDate*)fromDateTime andDate:(NSDate*)toDateTime
{
    NSDate *fromDate;
    NSDate *toDate;
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    [calendar rangeOfUnit:NSCalendarUnitSecond startDate:&fromDate
                 interval:NULL forDate:fromDateTime];
    [calendar rangeOfUnit:NSCalendarUnitSecond startDate:&toDate
                 interval:NULL forDate:toDateTime];
    
    NSDateComponents *difference = [calendar components:NSCalendarUnitSecond
                                               fromDate:fromDate toDate:toDate options:0];
    
    NSLog(@"%ld",(long)[difference second]);
    
    return [difference second];
}



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [[IQKeyboardManager sharedManager] setEnable:YES];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:YES];
    
    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookieAcceptPolicy:NSHTTPCookieAcceptPolicyAlways];
    
    [defaults setObject:@"https://tpcecd.tpc.co.in" forKey:@"HOST"];//local Host
    [defaults setObject:@"1443" forKey:@"PORT"];
    
    [self coreDateInitialize];
    
    if ([defaults objectForKey:@"HOST"] ==nil || [defaults objectForKey:@"PORT"] == nil)
    {
        
        [defaults setObject:@"ODATA" forKey:@"ENDPOINT"];
        [defaults setObject:@"X" forKey:@"LOGIN_SAP_USER"];
        [defaults setObject:@"SAP" forKey:@"DATASOURCE"];
        [defaults setObject:@"X" forKey:@"ACTIVATELOGS"];
    }
    
    [[DataBase sharedInstance] connectDatabase];
 
    [[DataBase sharedInstance] openLogFile];
    
    //    [START configure_firebase]
    [FIRApp configure];
    
    // [END configure_firebase]
    
    // [START set_messaging_delegate]
    [FIRMessaging messaging].delegate = self;
    // [END set_messaging_delegate]
    
    [FIRMessaging messaging].shouldEstablishDirectChannel = YES;
    
    // Register for remote notifications. This shows a permission dialog on first run, to
    // show the dialog at a more appropriate time move this registration accordingly.
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_7_1) {
        // iOS 7.1 or earlier. Disable the deprecation warnings.
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        UIRemoteNotificationType allNotificationTypes =
        (UIRemoteNotificationTypeSound |
         UIRemoteNotificationTypeAlert |
         UIRemoteNotificationTypeBadge);
        [application registerForRemoteNotificationTypes:allNotificationTypes];
#pragma clang diagnostic pop
    } else {
        // iOS 8 or later
        // [START register_for_notifications]
        if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_9_x_Max) {
            UIUserNotificationType allNotificationTypes =
            (UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge);
            UIUserNotificationSettings *settings =
            [UIUserNotificationSettings settingsForTypes:allNotificationTypes categories:nil];
            [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        } else {
            // iOS 10 or later
#if defined(__IPHONE_10_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
            // For iOS 10 display notification (sent via APNS)
            if (@available(iOS 10.0, *)) {
                [UNUserNotificationCenter currentNotificationCenter].delegate = self;
            } else {
                // Fallback on earlier versions
            }
            if (@available(iOS 10.0, *)) {
                
                UNAuthorizationOptions authOptions =
                UNAuthorizationOptionAlert
                | UNAuthorizationOptionSound
                | UNAuthorizationOptionBadge;
                
                [[UNUserNotificationCenter currentNotificationCenter] requestAuthorizationWithOptions:authOptions completionHandler:^(BOOL granted, NSError * _Nullable error) {
                }];
            } else {
                // Fallback on earlier versions
            }
#endif
        }
        
        [[UIApplication sharedApplication] registerForRemoteNotifications];
        
     }
 
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookieAcceptPolicy:NSHTTPCookieAcceptPolicyAlways];
    
}

// [START receive_message]
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    // If you are receiving a notification message while your app is in the background,
    // this callback will not be fired till the user taps on the notification launching the application.
    // TODO: Handle data of notification
    
    // With swizzling disabled you must let Messaging know about the message, for Analytics
    // [[Messaging messaging] appDidReceiveMessage:userInfo];
    
    // Print message ID.
    if (userInfo[kGCMMessageIDKey]) {
        NSLog(@"Message ID: %@", userInfo[kGCMMessageIDKey]);
    }
    
    //    UIAlertView *alertPush = [[UIAlertView alloc]initWithTitle:@"ReceivedRemote" message:userInfo[kGCMMessageIDKey] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
    //    [alertPush show];
    //
    // Print full message.
    NSLog(@"%@", userInfo);
}


- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    // If you are receiving a notification message while your app is in the background,
    // this callback will not be fired till the user taps on the notification launching the application.
    // TODO: Handle data of notification
    
    // With swizzling disabled you must let Messaging know about the message, for Analytics
    // [[Messaging messaging] appDidReceiveMessage:userInfo];
    
    // Print message ID.
    if (userInfo[kGCMMessageIDKey]) {
        NSLog(@"Message ID: %@", userInfo[kGCMMessageIDKey]);
    }
    
    //    UIAlertView *alertPush = [[UIAlertView alloc]initWithTitle:@"ReceivedRemoteCompleteHandler" message:userInfo[kGCMMessageIDKey] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
    //    [alertPush show];
    
    // Print full message.
    NSLog(@"%@", userInfo);
    
    completionHandler(UIBackgroundFetchResultNewData);
}
// [END receive_message]

// [START ios_10_message_handling]
// Receive displayed notifications for iOS 10 devices.
#if defined(__IPHONE_10_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
// Handle incoming notification messages while app is in the foreground.
- (void)userNotificationCenter:(UNUserNotificationCenter *)center
       willPresentNotification:(UNNotification *)notification
         withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler  API_AVAILABLE(ios(10.0)){
    NSDictionary *userInfo = notification.request.content.userInfo;
    
    // With swizzling disabled you must let Messaging know about the message, for Analytics
    // [[Messaging messaging] appDidReceiveMessage:userInfo];
    
    // Print message ID.
    if (userInfo[kGCMMessageIDKey]) {
        NSLog(@"Message ID: %@", userInfo[kGCMMessageIDKey]);
    }
    
    // Print full message.
    NSLog(@"%@", userInfo);
    
    //    UIAlertView *alertPush = [[UIAlertView alloc]initWithTitle:@"ReceivedPNotification" message:userInfo[kGCMMessageIDKey] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
    //    [alertPush show];
    //
    // Change this to your preferred presentation option
    if (@available(iOS 10.0, *)) {
        completionHandler(UNNotificationPresentationOptionNone);
    } else {
        // Fallback on earlier versions
    }
}

// Handle notification messages after display notification is tapped by the user.
- (void)userNotificationCenter:(UNUserNotificationCenter *)center
didReceiveNotificationResponse:(UNNotificationResponse *)response
         withCompletionHandler:(void (^)(void))completionHandler  API_AVAILABLE(ios(10.0)){
    NSDictionary *userInfo = response.notification.request.content.userInfo;
    if (userInfo[kGCMMessageIDKey]) {
        NSLog(@"Message ID: %@", userInfo[kGCMMessageIDKey]);
    }
    
    // Print full message.
    NSLog(@"%@", userInfo);
    
    [[NSUserDefaults standardUserDefaults] setObject:@"X" forKey:@"PushEnabled"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    completionHandler();
}
#endif
// [END ios_10_message_handling]

// [START refresh_token]
- (void)messaging:(nonnull FIRMessaging *)messaging didRefreshRegistrationToken:(nonnull NSString *)fcmToken {
    // Note that this callback will be fired everytime a new token is generated, including the first
    // time. So if you need to retrieve the token as soon as it is available this is where that
    // should be done.
    NSLog(@"FCM registration token: %@", fcmToken);
    
    [[NSUserDefaults standardUserDefaults] setObject:fcmToken forKey:@"DEVICETOKEN"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    // TODO: If necessary send token to application server.
}
// [END refresh_token]

// [START ios_10_data_message]
// Receive data messages on iOS 10+ directly from FCM (bypassing APNs) when the app is in the foreground.
// To enable direct data messages, you can set [Messaging messaging].shouldEstablishDirectChannel to YES.
- (void)messaging:(FIRMessaging *)messaging didReceiveMessage:(FIRMessagingRemoteMessage *)remoteMessage {
    
    NSLog(@"Received data message: %@", remoteMessage.appData);
    
    //    UIAlertView *alertPush = [[UIAlertView alloc]initWithTitle:@"ReceivedUNotification" message:[NSString stringWithFormat:@"%@",[[remoteMessage.appData objectForKey:@"notification"] objectForKey:@"body"]] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
    //    [alertPush show];
    //
    
}
// [END ios_10_data_message]

//application:didReceiveRemoteNotification:fetchCompletionHandler:


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}



@end
