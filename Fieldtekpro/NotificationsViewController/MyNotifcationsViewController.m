//
//  MyNotifcationsViewController.m
//  Fieldtekpro
//
//  Created by Deepak Gantala on 25/07/15.
//  Copyright (c) 2015 Enstrapp IT Solutions. All rights reserved.
//

#import "MyNotifcationsViewController.h"
#import "MyNotificationsListTableViewCell.h"
#import "DataBase.h"

//#import "ActivityView.h"
//#import "NotificationObjects.h"
#import "ConnectionManager.h"
#import "FilterSortTableViewCell.h"

//#import "OrderSystemStatusTableViewCell.h"


#define isiPhone5  ([[UIScreen mainScreen] bounds].size.height == 568)?TRUE:FALSE
#define isiPhone6 ( [[UIScreen mainScreen] bounds].size.height == 667)?TRUE:FALSE
#define IS_IPHONE_6_PLUS ([[UIScreen mainScreen] bounds].size.height == 736.0)?TRUE:FALSE
#define IS_IPAD ([[UIScreen mainScreen] bounds].size.height == 1024.0)?TRUE:FALSE

#define UIColorFromRGB(r, g, b)  [UIColor colorWithRed:((r) / 255.0) green:((g) / 255.0) blue:((b) / 255.0) alpha:1.0]

#define ID_INDEX 0
#define NAME_INDEX 1

@interface MyNotifcationsViewController ()
{
    NSMutableArray *titleArray;
    UIImageView *previousImageView;
    NSString *startDate,*endDate;
    int headerIndexPathRow,textfieldTag;
    
    NSMutableString *wrckcenterStringl,*wrkcenterQueryString;
    
}

@property (nonatomic,retain) NSMutableArray *structuredFilterSortedArray;

@end

@implementation MyNotifcationsViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
    
    defaults=[NSUserDefaults standardUserDefaults];
    
    NSString *key = @"";
    NSLog(@"total key is %@",key);
    
    NSString *str_UserNameDep = [defaults objectForKey:@"userName"];
    decryptedUserName = [str_UserNameDep AES128DecryptWithKey:key];
 
    filterSubView.hidden=YES;
    filterBackgroundClicked.hidden=YES;
    searchBarView.hidden=YES;
    
  //  WorkCenterTableviewcell.xib
    
    [filterSortTableView registerNib:[UINib nibWithNibName:@"FilterWorkcenterTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"WorkcenterCell"];
 
    self.notificationListArray = [NSMutableArray new];
    
    inputsDictionary = [NSMutableDictionary new];
    notifNoSortSelected = YES;
    statusSortSelected = NO;
    shortTextSortSelected = NO;
    prioritySortSelected = NO;
    malFuncStartDateSortSelected = NO;
    
 
    searchBtn.imageEdgeInsets = UIEdgeInsetsMake(-0,10, 10, 0);
    searchBtn.titleEdgeInsets = UIEdgeInsetsMake(30, -40, 0, 0);
    
    filterBtn.imageEdgeInsets = UIEdgeInsetsMake(-0,15, 10, 0);
    filterBtn.titleEdgeInsets = UIEdgeInsetsMake(30,-30, 0, 0);
    
    sortBtn.imageEdgeInsets = UIEdgeInsetsMake(-10,10,5, 15);
    sortBtn.titleEdgeInsets = UIEdgeInsetsMake(30,-15, 0, 0);
    
    refreshBtn.imageEdgeInsets = UIEdgeInsetsMake(-10,20, 10, 0);
    refreshBtn.titleEdgeInsets = UIEdgeInsetsMake(30, -20, 0, 0);
    
    self.structuredFilterSortedArray = [[NSMutableArray alloc]init];
    
    titleArray = [[NSMutableArray alloc] init];
    
    NSMutableArray *tempNotificationTypeArray=[NSMutableArray new];
    
    NSArray *tempNotifMaster = [[DataBase sharedInstance] getNotificationTypesinSingleArray];
    
    if ([tempNotifMaster count]) {
        
        [tempNotificationTypeArray addObject:[NSMutableArray arrayWithObjects:@"ALL",@"", nil]];
    }
    
    for (int i = 0; i<[tempNotifMaster count]; i++) {
        
        [tempNotificationTypeArray addObject:[NSMutableArray arrayWithObjects:[tempNotifMaster objectAtIndex:i],@"", nil]];
    }
    
     [systemStatusTableView registerNib:[UINib nibWithNibName:@"OrderSystemStatusTableViewCell~iPhone5" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"Cell"];
    
    NSMutableArray *tempPrioritiesArray=[NSMutableArray new];
    
    NSArray *tempNotifPriorityMaster = [[DataBase sharedInstance] getNotificationPriorityinSingleArray];
    
    if ([tempNotifPriorityMaster count]) {
        
        [tempPrioritiesArray addObject:[NSMutableArray arrayWithObjects:@"ALL",@"", nil]];
    }
    
    for (int i = 0; i<[tempNotifPriorityMaster count]; i++) {
        
        [tempPrioritiesArray addObject:[NSMutableArray arrayWithObjects:[tempNotifPriorityMaster objectAtIndex:i],@"", nil]];
    }
    
    NSMutableArray *dateArray=[NSMutableArray new];
    
    [dateArray addObject:[NSMutableArray arrayWithObjects:@"Created Date",@"X",nil]];
    [dateArray addObject:[NSMutableArray arrayWithObjects:@"Malfunction Date",@"",nil]];
    [dateArray addObject:[NSMutableArray arrayWithObjects:@"Required Date",@"",nil]];
    [dateArray addObject:[NSMutableArray arrayWithObjects:@"From Date",@"",nil]];//for inputs fields
    [dateArray addObject:[NSMutableArray arrayWithObjects:@"To Date",@"",nil]];//for input fields
    
    NSMutableArray *tempFilterArray=[NSMutableArray new];
    
    [tempFilterArray addObject:[NSMutableArray arrayWithObjects:@"ALL",@"",nil]];
    [tempFilterArray addObject:[NSMutableArray arrayWithObjects:@"OSNO",@"",nil]];
    [tempFilterArray addObject:[NSMutableArray arrayWithObjects:@"NOPR",@"",nil]];
    [tempFilterArray addObject:[NSMutableArray arrayWithObjects:@"NOPO",@"",nil]];
    [tempFilterArray addObject:[NSMutableArray arrayWithObjects:@"NOCO",@"",nil]];
    
     NSMutableArray *tempAttachmentArray=[NSMutableArray new];
     [tempAttachmentArray addObject:[NSMutableArray arrayWithObjects:@"Yes",@"",nil]];
    
     NSMutableArray *personResonsibleArray=[NSMutableArray new];
     [personResonsibleArray addObject:[NSMutableArray arrayWithObjects:@"Yes",@"X", nil]];
 
      NSMutableArray *WorkcenterArray=[NSMutableArray new];
     [WorkcenterArray addObject:[NSMutableArray arrayWithObjects:@"Select Workcenter",@"", nil]];
 
     [self.structuredFilterSortedArray addObject:[NSMutableArray arrayWithObjects:tempNotificationTypeArray,tempPrioritiesArray,dateArray,tempFilterArray,tempAttachmentArray,personResonsibleArray,WorkcenterArray, nil]];
    
    //////////////////////////////////////////
    NSMutableArray *tempSortDescriptionTexts=[NSMutableArray new];
    [tempSortDescriptionTexts addObject:[NSMutableArray arrayWithObjects:@"Sort A to Z",@"", nil]];
    [tempSortDescriptionTexts addObject:[NSMutableArray arrayWithObjects:@"SORT Z to A",@"", nil]];
    
    NSMutableArray *tempSortStatusTexts=[NSMutableArray new];
    [tempSortStatusTexts addObject:[NSMutableArray arrayWithObjects:@"Critical to Low",@"",nil]];
    [tempSortStatusTexts addObject:[NSMutableArray arrayWithObjects:@"Low to Critical",@"", nil]];
    
    NSMutableArray *tempSortMalFuncStartDate=[NSMutableArray new];
    [tempSortMalFuncStartDate addObject:[NSMutableArray arrayWithObjects:@"Ascending 1-9",@"", nil]];
    [tempSortMalFuncStartDate addObject:[NSMutableArray arrayWithObjects:@"Descending 9-1",@"", nil]];
    
    NSMutableArray *notificationNumber=[NSMutableArray new];
    [notificationNumber addObject:[NSMutableArray arrayWithObjects:@"Ascending 1-9",@"", nil]];
    [notificationNumber addObject:[NSMutableArray arrayWithObjects:@"Descending 9-1",@"", nil]];
    
 
 
    [self.structuredFilterSortedArray addObject:[NSMutableArray arrayWithObjects:tempSortDescriptionTexts,tempSortStatusTexts,tempSortMalFuncStartDate,notificationNumber, nil]];
    [notifNoSortBtn setImage:[UIImage imageNamed:@"SortDown.png"] forState:UIControlStateNormal];
    
    selectedFilterSortCheckBoxArray= [NSMutableArray new];
    selectedCheckBoxArray = [NSMutableArray new];
    CALayer *layer = [myNotificationsHeaderView layer];
    [layer setMasksToBounds:YES];
    [layer setCornerRadius:8.0];
    
    completeButton.hidden = YES;
    cancelButton.hidden = YES;
    releaseBtn.hidden = YES;
    
}

#pragma mark-
#pragma mark- ViewWillAppear

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
 
     NSArray *parnerDataArray=[[DataBase sharedInstance] getPernrFromMasterData];
    
    NSMutableDictionary *actions=[NSMutableDictionary new];
    
    if ([parnerDataArray count]) {
        
        [actions setObject:[[parnerDataArray objectAtIndex:0] objectAtIndex:0] forKey:@"PERNR"];
        
    }
    
     [self searchMyNotificationsFromSqlite:actions];
 
}

-(void)viewDidDisappear:(BOOL)animated{
    
    myNotificationsTableView.editing=false;
}

-(void)searchMyNotificationsFromSqlite :(NSMutableDictionary *)actions{
    
    [defaults removeObjectForKey:@"DETAILSCREEN"];
    [defaults synchronize];
    
    // filterCall
    [self.notificationListArray removeAllObjects];
 
    [self.notificationListArray addObjectsFromArray:[[DataBase sharedInstance] getLocalNotificationForCondition:actions]];
    
    [myNotificationsTableView scrollRectToVisible:CGRectMake(0, 0, 0, 0) animated:YES];
    
    myNotificationsCountLabel.text = [NSString stringWithFormat:@"Notifications (%i)",(int)[self.notificationListArray count]];
    
     myNotificationsTableView.tag=0;
    
    [myNotificationsTableView reloadData];
}

#pragma mark-
#pragma mark- Validator Methods


-(void)showAlertMessageWithTitle:(NSString*)title message:(NSString*)message cancelButtonTitle:(NSString *)cancelBtnTitle withactionType:(NSString *)actionString forMethod:(NSString *)methodNameString
{
    
    UIAlertController * alert=[UIAlertController alertControllerWithTitle:title
                                                                  message:message
                                                           preferredStyle:UIAlertControllerStyleAlert];
    
    if ([actionString isEqualToString:@"Multiple"]) {
        
        UIAlertAction* yesButton = [UIAlertAction actionWithTitle:@"Yes"
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action)
                                    {
                                        if ([methodNameString isEqualToString:@"Refresh"]) {
 
                                            hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                                            hud.mode = MBProgressHUDAnimationFade;
                                            hud.label.text = @"Data refresh in progress...";
                                            
                                            [self getLoadSettings];
 
                                        }
                                        
                                        else if ([methodNameString isEqualToString:@"Release"]){
                                            
                                            [self releaseNotifications];
 
                                        }
                                        
                                        else if ([methodNameString isEqualToString:@"Cancel"]){
                                            
                                            [self cancelNotification];
                                            
                                        }
                                        
                                        else if ([methodNameString isEqualToString:@"CompleteNotif"]){
                                            
                                            [self completeNotifications];
                                            
                                        }
                                        
                                        else if ([methodNameString isEqualToString:@"Postpone"]){
                                            
                                            [self postPoneNotificationsmethod];
                                            
                                        }

 
                                        // call method whatever u need
                                    }];
        
        UIAlertAction* noButton = [UIAlertAction actionWithTitle:cancelBtnTitle
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * action)
                                   {
                                       /** What we write here???????? **/
                                       NSLog(@"you pressed No, thanks button");
                                       // call method whatever u need
                                       [alert dismissViewControllerAnimated:YES completion:nil];
                                       
                                   }];
        
          [alert addAction:noButton];
          [alert addAction:yesButton];
        
        [self presentViewController:alert animated:YES completion:nil];
    }
    
    else{
        
        UIAlertAction* okButton = [UIAlertAction actionWithTitle:cancelBtnTitle
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * action)
                                   {
                                      
                                       [alert dismissViewControllerAnimated:YES completion:nil];
                                       
                                   }];
        
         [alert addAction:okButton];
        
        [self presentViewController:alert animated:YES completion:nil];
        
    }
  }

  -(void)cancelNotification{
    
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDAnimationFade;
    hud.label.text = @"Cancellation in progress...";
        
        if (self.notificationHeaderDetails) {
            [self.notificationHeaderDetails removeAllObjects];
        }
        else{
            self.notificationHeaderDetails = [NSMutableDictionary dictionary];
        }
        
        NSMutableArray *objectIds = [[NSMutableArray alloc] init];
        NSMutableArray *uuids = [NSMutableArray new];
        for (int i=0; i<[selectedCheckBoxArray count]; i++) {
            
            int rowIndex = [[selectedCheckBoxArray objectAtIndex:i] intValue];
            if ([NullChecker isNull:[NSString stringWithString:[[self.notificationListArray objectAtIndex:rowIndex] objectForKey:@"notificationh_status"]]]) {
                [[DataBase sharedInstance] deleteRecordinNotificationForUUID:[[self.notificationListArray objectAtIndex:i] objectForKey:@"notificationh_id"] ObjectcID:[[self.notificationListArray objectAtIndex:rowIndex] objectForKey:@"nh_objectID"] ReportedBY:decryptedUserName];
            }
            else{
                [objectIds addObject:[NSString stringWithString:[[self.notificationListArray objectAtIndex:rowIndex] objectForKey:@"nh_objectID"]]];
                [uuids addObject:[NSString stringWithString:[[self.notificationListArray objectAtIndex:i] objectForKey:@"notificationh_id"]]];
                
                [self.notificationHeaderDetails setObject:[NSString stringWithString:[[self.notificationListArray objectAtIndex:i] objectForKey:@"notificationh_id"]] forKey:[[self.notificationListArray objectAtIndex:rowIndex] objectForKey:@"nh_objectID"]];
                
                if ([[DataBase sharedInstance] cancelNotificationForUUID:[[self.notificationListArray objectAtIndex:i] objectForKey:@"notificationh_id"] ObjectcID:[[self.notificationListArray objectAtIndex:rowIndex] objectForKey:@"nh_objectID"] ReportedBY:decryptedUserName]) {
                    NSLog(@"Cancelled %@",[[self.notificationListArray objectAtIndex:i] objectForKey:@"notificationh_id"]);
                }
            }
        }
        
        if ([[ConnectionManager defaultManager] isConnectionQueueIsActive]) {
            [[ConnectionManager defaultManager] stopCurrentConnetion];
        }
        
        if([[ConnectionManager defaultManager] isReachable] && [objectIds count])
        {
            NSMutableDictionary *endPointCancelNotificationDictionary = [NSMutableDictionary new];
            [endPointCancelNotificationDictionary setObject:@"X" forKey:@"ACTIVITY"];
            [endPointCancelNotificationDictionary setObject:@"Q" forKey:@"DOCTYPE"];
            [endPointCancelNotificationDictionary setObject:[defaults objectForKey:@"ENDPOINT"] forKey:@"ENDPOINT"];
            NSArray *endPointArray = [[DataBase sharedInstance] getEndPointURL:endPointCancelNotificationDictionary];
            NSLog(@"endPoint :%@",[[endPointArray objectAtIndex:0] objectAtIndex:0]);
            [endPointCancelNotificationDictionary setObject:[[endPointArray objectAtIndex:0] objectAtIndex:0] forKey:@"URL_ENDPOINT"];
            [endPointCancelNotificationDictionary setObject:objectIds forKey:@"ITEMS"];
            [endPointCancelNotificationDictionary setObject:[[decryptedUserName copy] uppercaseString] forKey:@"REPORTEDBY"];
            
            [endPointCancelNotificationDictionary setObject:@"" forKey:@"TRANSMITTYPE"];
            
            [Request makeWebServiceRequest:NOTIFICATION_CANCEL parameters:endPointCancelNotificationDictionary delegate:self];
        }
        else
        {
            if ([objectIds count]) {
                for (int i = 0; i<[uuids count]; i++) {
                    [[DataBase sharedInstance] updateNotificationStatus:[uuids objectAtIndex:i] :@"Cancelled"];
                }
            }
            else
            {
                  [self showAlertMessageWithTitle:@"FieldTekPro" message:@"Notification Cancelled Sucessfully" cancelButtonTitle:@"Ok" withactionType:@"Single" forMethod:nil];
            }
            
            if ([[defaults objectForKey:@"ACTIVATELOGS"] isEqualToString:@"X"])
            {
                
                [[DataBase sharedInstance] writToLogFile:[NSString stringWithFormat:@"#INFO#.com.enstrapp.fieldtekpro#NotifNo #Activity:Cancel Notification #Mode:Offline #Class:Very Important #MUser:%@ #DeviceId:%@",decryptedUserName,[defaults objectForKey:@"edeviceid"]]];
            }
            
            [selectedCheckBoxArray removeAllObjects];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [inputsDictionary removeAllObjects];
            [inputsDictionary setObject:@"ORDER BY nh_upadated_Date DESC" forKey:@"RECENT"];
            [self searchMyNotificationsFromSqlite:inputsDictionary];
            
        }
}

-(void)releaseNotifications
 {
    
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDAnimationFade;
    hud.label.text = @"Release  in progress...";
 
        if (self.notificationHeaderDetails) {
            [self.notificationHeaderDetails removeAllObjects];
        }
        else{
            self.notificationHeaderDetails = [NSMutableDictionary dictionary];
        }
        
        NSMutableArray *objectIds = [[NSMutableArray alloc] init];
        NSMutableArray *uuids = [NSMutableArray new];
 
            int rowIndex = selectedRow;
     
            if ([NullChecker isNull:[NSString stringWithString:[[self.notificationListArray objectAtIndex:rowIndex] objectForKey:@"nh_objectID"]]]) {
                [[DataBase sharedInstance] deleteRecordinNotificationForUUID:[[self.notificationListArray objectAtIndex:selectedRow] objectForKey:@"notificationh_id"] ObjectcID:[[self.notificationListArray objectAtIndex:rowIndex] objectForKey:@"nh_objectID"] ReportedBY:decryptedUserName];
            }
            else{
                
                [objectIds addObject:[NSString stringWithString:[[self.notificationListArray objectAtIndex:rowIndex] objectForKey:@"nh_objectID"]]];
                
                [uuids addObject:[NSString stringWithString:[[self.notificationListArray objectAtIndex:selectedRow] objectForKey:@"notificationh_id"]]];
                
                [self.notificationHeaderDetails setObject:[NSString stringWithString:[[self.notificationListArray objectAtIndex:selectedRow] objectForKey:@"notificationh_id"]] forKey:[[self.notificationListArray objectAtIndex:rowIndex] objectForKey:@"nh_objectID"]];
                
                if ([[DataBase sharedInstance] releaseNotificationForUUID:[[self.notificationListArray objectAtIndex:rowIndex] objectForKey:@"notificationh_id"] ObjectcID:[[self.notificationListArray objectAtIndex:rowIndex] objectForKey:@"nh_objectID"] ReportedBY:decryptedUserName]) {
                    
                    NSLog(@"Released %@",[[self.notificationListArray objectAtIndex:rowIndex] objectForKey:@"notificationh_id"]);
                }
            }
 
        if ([[ConnectionManager defaultManager] isConnectionQueueIsActive]) {
            [[ConnectionManager defaultManager] stopCurrentConnetion];
        }
        
        if([[ConnectionManager defaultManager] isReachable] && [objectIds count])
        {
            NSMutableDictionary *endPointReleaseNotificationDictionary = [NSMutableDictionary new];
            
            [endPointReleaseNotificationDictionary setObject:@"RL" forKey:@"ACTIVITY"];
            [endPointReleaseNotificationDictionary setObject:@"Q" forKey:@"DOCTYPE"];
            [endPointReleaseNotificationDictionary setObject:[defaults objectForKey:@"ENDPOINT"] forKey:@"ENDPOINT"];
            
            NSArray *endPointArray = [[DataBase sharedInstance] getEndPointURL:endPointReleaseNotificationDictionary];
            NSLog(@"endPoint :%@",[[endPointArray objectAtIndex:0] objectAtIndex:0]);
            [endPointReleaseNotificationDictionary setObject:[[endPointArray objectAtIndex:0] objectAtIndex:0] forKey:@"URL_ENDPOINT"];
            
            [endPointReleaseNotificationDictionary setObject:objectIds forKey:@"ITEMS"];
            [endPointReleaseNotificationDictionary setObject:[[decryptedUserName copy] uppercaseString] forKey:@"REPORTEDBY"];
            [endPointReleaseNotificationDictionary setObject:@"" forKey:@"TRANSMITTYPE"];
            
            [Request makeWebServiceRequest:NOTIFICATION_RELEASE parameters:endPointReleaseNotificationDictionary delegate:self];
        }
        else
        {
            if ([objectIds count]) {
                for (int i = 0; i<[uuids count]; i++) {
                    [[DataBase sharedInstance] updateNotificationStatus:[uuids objectAtIndex:i] :@"Released"];
                }
            }
            else
            {
                  [self showAlertMessageWithTitle:@"FieldTekPro" message:@"Notification Released Sucessfully" cancelButtonTitle:@"No" withactionType:@"Single" forMethod:nil];
             }
            
            if ([[defaults objectForKey:@"ACTIVATELOGS"] isEqualToString:@"X"])
            {
                
                [[DataBase sharedInstance] writToLogFile:[NSString stringWithFormat:@"#INFO#.com.enstrapp.fieldtekpro#NotifNo #Activity:Release Notification #Mode:Offline #Class:Very Important #MUser:%@ #DeviceId:%@",decryptedUserName,[defaults objectForKey:@"edeviceid"]]];
            }
            
            [selectedCheckBoxArray removeAllObjects];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [inputsDictionary removeAllObjects];
            [inputsDictionary setObject:@"ORDER BY nh_upadated_Date DESC" forKey:@"RECENT"];
            [self searchMyNotificationsFromSqlite:inputsDictionary];
            
        }
 }

-(void)completeNotifications
{
    
     hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
     hud.mode = MBProgressHUDAnimationFade;
     hud.label.text = @"Completion in progress...";
        
        NSMutableArray *objectIds = [[NSMutableArray alloc] init];
        NSMutableArray *uuids = [NSMutableArray new];
        if (self.notificationHeaderDetails) {
            [self.notificationHeaderDetails removeAllObjects];
        }
        else{
            self.notificationHeaderDetails = [NSMutableDictionary dictionary];
        }
        
 
            int rowIndex = selectedRow;
            [objectIds addObject:[NSString stringWithString:[[self.notificationListArray objectAtIndex:rowIndex] objectForKey:@"nh_objectID"]]];
    
            [uuids addObject:[NSString stringWithString:[[self.notificationListArray objectAtIndex:rowIndex] objectForKey:@"notificationh_id"]]];
    
            [self.notificationHeaderDetails setObject:[NSString stringWithString:[[self.notificationListArray objectAtIndex:rowIndex] objectForKey:@"notificationh_id"]] forKey:[[self.notificationListArray objectAtIndex:rowIndex] objectForKey:@"nh_objectID"]];
    
            if ([[DataBase sharedInstance] completeNotificationForUUID:[[self.notificationListArray objectAtIndex:rowIndex] objectForKey:@"notificationh_id"] ObjectcID:[[self.notificationListArray objectAtIndex:rowIndex] objectForKey:@"nh_objectID"] ReportedBY:decryptedUserName]) {
                NSLog(@"Completed %@",[[self.notificationListArray objectAtIndex:rowIndex] objectForKey:@"notificationh_id"]);
            }

    if ([[ConnectionManager defaultManager] isConnectionQueueIsActive]) {
            [[ConnectionManager defaultManager] stopCurrentConnetion];
        }
        
        if([[ConnectionManager defaultManager] isReachable])
        {
            NSMutableDictionary *endPointCompleteNotificationDictionary = [NSMutableDictionary new];
            [endPointCompleteNotificationDictionary setObject:@"S" forKey:@"ACTIVITY"];
            [endPointCompleteNotificationDictionary setObject:@"Q" forKey:@"DOCTYPE"];
            [endPointCompleteNotificationDictionary setObject:[defaults objectForKey:@"ENDPOINT"] forKey:@"ENDPOINT"];
            NSArray *endPointArray = [[DataBase sharedInstance] getEndPointURL:endPointCompleteNotificationDictionary];
            NSLog(@"endPoint :%@",[[endPointArray objectAtIndex:0] objectAtIndex:0]);
            [endPointCompleteNotificationDictionary setObject:[[endPointArray objectAtIndex:0] objectAtIndex:0] forKey:@"URL_ENDPOINT"];
            [endPointCompleteNotificationDictionary setObject:objectIds forKey:@"ITEMS"];
            [endPointCompleteNotificationDictionary setObject:[[decryptedUserName copy] uppercaseString] forKey:@"REPORTEDBY"];
            
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"CSRF"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
             [endPointCompleteNotificationDictionary setObject:@"LOAD" forKey:@"TRANSMITTYPE"];
            
            [Request makeWebServiceRequest:NOTIFICATION_COMPLETE parameters:endPointCompleteNotificationDictionary delegate:self];
        }
        else
        {
            for (int i = 0; i<[uuids count]; i++) {
                [[DataBase sharedInstance] updateNotificationStatus:[uuids objectAtIndex:i] :@"Completed"];
            }
            
            if ([[defaults objectForKey:@"ACTIVATELOGS"] isEqualToString:@"X"])
            {
                [[DataBase sharedInstance] writToLogFile:[NSString stringWithFormat:@"#INFO#.com.enstrapp.fieldtekpro#Notif #Activity:Complete Notification #Mode:Offline #Class:Very Important #MUser:%@ #DeviceId:%@",decryptedUserName,[defaults objectForKey:@"edeviceid"]]];
                
            }
            
            [selectedCheckBoxArray removeAllObjects];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [inputsDictionary removeAllObjects];
            [inputsDictionary setObject:@"ORDER BY nh_upadated_Date DESC" forKey:@"RECENT"];
            [self searchMyNotificationsFromSqlite:inputsDictionary];
            
        }
 }


-(void)postPoneNotificationsmethod{
    
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDAnimationFade;
    hud.label.text = @"Postpone in progress...";
    
    NSMutableArray *objectIds = [[NSMutableArray alloc] init];
    NSMutableArray *uuids = [NSMutableArray new];
    if (self.notificationHeaderDetails) {
        [self.notificationHeaderDetails removeAllObjects];
    }
    else{
        self.notificationHeaderDetails = [NSMutableDictionary dictionary];
    }
    
     int rowIndex = selectedRow;
    
    [objectIds addObject:[NSString stringWithString:[[self.notificationListArray objectAtIndex:rowIndex] objectForKey:@"nh_objectID"]]];
    
    [uuids addObject:[NSString stringWithString:[[self.notificationListArray objectAtIndex:rowIndex] objectForKey:@"notificationh_id"]]];
    
    [self.notificationHeaderDetails setObject:[NSString stringWithString:[[self.notificationListArray objectAtIndex:rowIndex] objectForKey:@"notificationh_id"]] forKey:[[self.notificationListArray objectAtIndex:rowIndex] objectForKey:@"nh_objectID"]];
  
      if ([[DataBase sharedInstance] postPoneNotificationForUUID:[[self.notificationListArray objectAtIndex:rowIndex] objectForKey:@"notificationh_id"] ObjectcID:[[self.notificationListArray objectAtIndex:rowIndex] objectForKey:@"nh_objectID"] ReportedBY:decryptedUserName]) {
        NSLog(@"Postponed %@",[[self.notificationListArray objectAtIndex:rowIndex] objectForKey:@"notificationh_id"]);
    }
    
    if ([[ConnectionManager defaultManager] isConnectionQueueIsActive]) {
        [[ConnectionManager defaultManager] stopCurrentConnetion];
    }
    
    if([[ConnectionManager defaultManager] isReachable])
    {
        NSMutableDictionary *endPointCompleteNotificationDictionary = [NSMutableDictionary new];
        [endPointCompleteNotificationDictionary setObject:@"PP" forKey:@"ACTIVITY"];
        [endPointCompleteNotificationDictionary setObject:@"Q" forKey:@"DOCTYPE"];
        [endPointCompleteNotificationDictionary setObject:[defaults objectForKey:@"ENDPOINT"] forKey:@"ENDPOINT"];
        NSArray *endPointArray = [[DataBase sharedInstance] getEndPointURL:endPointCompleteNotificationDictionary];
        
        if ([endPointArray count]) {
            
            NSLog(@"endPoint :%@",[[endPointArray objectAtIndex:0] objectAtIndex:0]);
            [endPointCompleteNotificationDictionary setObject:[[endPointArray objectAtIndex:0] objectAtIndex:0] forKey:@"URL_ENDPOINT"];
            [endPointCompleteNotificationDictionary setObject:objectIds forKey:@"ITEMS"];
            [endPointCompleteNotificationDictionary setObject:[[decryptedUserName copy] uppercaseString] forKey:@"REPORTEDBY"];
            
            [endPointCompleteNotificationDictionary setObject:@"LOAD" forKey:@"TRANSMITTYPE"];
            
            [Request makeWebServiceRequest:NOTIFICATION_POSTPONE parameters:endPointCompleteNotificationDictionary delegate:self];
            
         }
        
    }
    else
    {
        for (int i = 0; i<[uuids count]; i++) {
            [[DataBase sharedInstance] updateNotificationStatus:[uuids objectAtIndex:i] :@"Completed"];
        }
        
        if ([[defaults objectForKey:@"ACTIVATELOGS"] isEqualToString:@"X"])
        {
            [[DataBase sharedInstance] writToLogFile:[NSString stringWithFormat:@"#INFO#.com.enstrapp.fieldtekpro#Notif #Activity:Postpone Notification #Mode:Offline #Class:Very Important #MUser:%@ #DeviceId:%@",decryptedUserName,[defaults objectForKey:@"edeviceid"]]];
            
        }
        
        [selectedCheckBoxArray removeAllObjects];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [inputsDictionary removeAllObjects];
        [inputsDictionary setObject:@"ORDER BY nh_upadated_Date DESC" forKey:@"RECENT"];
        [self searchMyNotificationsFromSqlite:inputsDictionary];
        
    }
}


#pragma mark-
#pragma mark- Iphone Button Actions



//-(void)dismissScanView{
//
//    self.notificationSearchBar.text = [defaults objectForKey:@"scanned"];
//
//    [self searchBar:self.notificationSearchBar textDidChange:self.notificationSearchBar.text];
//
//    [scanView.view removeFromSuperview];
//}
//
//-(IBAction)equipmentBarCodeScan:(id)sender{
//
//    [self.notificationSearchBar resignFirstResponder];
//
//    NSString *nibName =@"";
//    if (isiPhone5) {
//        nibName = @"ScanBarcodeViewController~iPhone5";
//    }
//    else if (isiPhone6){
//
//        nibName = @"ScanBarcodeViewController~iPhone6";
//    }
//    else if (IS_IPHONE_6_PLUS){
//
//        nibName = @"ScanBarcodeViewController~iPhone6Plus";
//    }
//    else if (IS_IPAD){
//
//        nibName = @"ScanBarcodeViewController~iPad";
//    }
//
//    scanView =[[ScanBarcodeViewController alloc]initWithNibName:nibName bundle:nil];
//    scanView.delegate = self;
//
//    [self.view addSubview:scanView.view];
//}


-(IBAction)releaseButtonClicked:(id)sender{
    
 
     //    NSString *filterString = [NSString stringWithFormat:@"nh_objectID like '%@%%' or notificationh_shorttext like '%@%%' or notificationh_priority_name like '%@%%' or notificationh_startdate like '%@%%' or notificationh_status like '%@%%' or notificationh_equip_id like '%@%%'",searchText,searchText,searchText,searchText,searchText,searchText];
    
    if ([selectedCheckBoxArray count] == 1) {
        NSMutableArray *objectIds = [NSMutableArray new];
        for (int i=0; i<[selectedCheckBoxArray count]; i++) {
            
            int rowIndex = [[selectedCheckBoxArray objectAtIndex:i] intValue];
            
            if ([NullChecker isNull:[[self.notificationListArray objectAtIndex:rowIndex] objectForKey:@"notificationh_personresponsible_id"]]) {
                
             [self showAlertMessageWithTitle:@"Information" message:@"Please Enter Person responsible for Selected Notification" cancelButtonTitle:@"Ok" withactionType:@"Single" forMethod:nil];
                
            }
            
         else   if ([NullChecker isNull:[[self.notificationListArray objectAtIndex:rowIndex] objectForKey:@"notificationh_effect_id"]]) {
                
                [self showAlertMessageWithTitle:@"Information" message:@"Please Enter Effect  for Selected Notification" cancelButtonTitle:@"Ok" withactionType:@"Single" forMethod:nil];
                
            }
            
           else if ([[[self.notificationListArray objectAtIndex:rowIndex] objectForKey:@"notificationh_status"] isEqualToString:@"Cancelled"]) {
                [objectIds addObject:[NSString stringWithString:[[self.notificationListArray objectAtIndex:rowIndex] objectForKey:@"notificationh_status"]]];
            }
            else if ([[[self.notificationListArray objectAtIndex:rowIndex] objectForKey:@"notificationh_status"] isEqualToString:@"Completed"]){
                [objectIds addObject:[NSString stringWithString:[[self.notificationListArray objectAtIndex:rowIndex] objectForKey:@"notificationh_status"]]];
            }
        }
        if ([objectIds count])
        {
             [self showAlertMessageWithTitle:@"Information" message:@"Selected notification cannot be Released" cancelButtonTitle:@"Ok" withactionType:@"Single" forMethod:nil];
            
          }
        else
        {
 
            [self showAlertMessageWithTitle:@"Decision" message:@"Do you want to Release  the selected Notification?" cancelButtonTitle:@"No" withactionType:@"Multiple" forMethod:@"Release"];
            
         }
    }
    else if ([selectedCheckBoxArray count] >1)
    {
 
         [self showAlertMessageWithTitle:@"Information" message:@"Please select only one notification to release" cancelButtonTitle:@"Ok" withactionType:@"Single" forMethod:nil];
        
    }
    else {
 
        [self showAlertMessageWithTitle:@"Information" message:@"Please select atleast one notification" cancelButtonTitle:@"Ok" withactionType:@"Single" forMethod:nil];
        
    }
 
}

-(void)ReleaseMethod{
    
         NSMutableArray *objectIds = [NSMutableArray new];
 
             int rowIndex = selectedRow;
            
            if ([NullChecker isNull:[[self.notificationListArray objectAtIndex:rowIndex] objectForKey:@"notificationh_personresponsible_id"]]) {
                
                [self showAlertMessageWithTitle:@"Information" message:@"Please Enter Person responsible for Selected Notification" cancelButtonTitle:@"Ok" withactionType:@"Single" forMethod:nil];
                
            }
            else   if ([NullChecker isNull:[[self.notificationListArray objectAtIndex:rowIndex] objectForKey:@"notificationh_effect_id"]]) {
                
                [self showAlertMessageWithTitle:@"Information" message:@"Please Enter Effect  for Selected Notification" cancelButtonTitle:@"Ok" withactionType:@"Single" forMethod:nil];
                
            }
            
            else if ([[[self.notificationListArray objectAtIndex:rowIndex] objectForKey:@"notificationh_status"] isEqualToString:@"Cancelled"]) {
                [objectIds addObject:[NSString stringWithString:[[self.notificationListArray objectAtIndex:rowIndex] objectForKey:@"notificationh_status"]]];
            }
            else if ([[[self.notificationListArray objectAtIndex:rowIndex] objectForKey:@"notificationh_status"] isEqualToString:@"Completed"]){
                [objectIds addObject:[NSString stringWithString:[[self.notificationListArray objectAtIndex:rowIndex] objectForKey:@"notificationh_status"]]];
            }
 
         if ([objectIds count])
        {
            [self showAlertMessageWithTitle:@"Information" message:@"Selected notification cannot be Released" cancelButtonTitle:@"Ok" withactionType:@"Single" forMethod:nil];
         }
        else
        {
             [self showAlertMessageWithTitle:@"Decision" message:@"Do you want to Release  the selected Notification?" cancelButtonTitle:@"No" withactionType:@"Multiple" forMethod:@"Release"];
         }
  }

-(void)postPoneNotifications{
 
    int rowIndex = selectedRow;
 
    [self showAlertMessageWithTitle:@"Decision" message:[NSString stringWithFormat:@"Do you want to Postpone  the selected Notification %@?",[[self.notificationListArray objectAtIndex:rowIndex] objectForKey:@"nh_objectID"]] cancelButtonTitle:@"No" withactionType:@"Multiple" forMethod:@"Postpone"];
    
 }

 
-(IBAction)searchButtonClicked:(id)sender
{
    [searchView setFrame:CGRectMake(0, 0, myNotificationsTableView.frame.size.width, 44)];
    [myNotificationsTableView setTableHeaderView:searchView];

}

-(IBAction)searchCancelClicked:(id)sender
{
    [myNotificationsTableView setTableHeaderView:nil];

}

-(IBAction)filterButtonClicked:(id)sender
{
    filterByLabel.text=@"Filter BY:";

    self.window = [UIApplication sharedApplication].keyWindow;
    blackView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.window.frame.size.height)];
    [blackView setBackgroundColor:[UIColor blackColor]];
    [blackView setAlpha:0.8];
    [self.window addSubview:blackView];
    [filterView setFrame:CGRectMake(blackView.frame.size.width-260, 57, 260, self.window.frame.size.height-57)];
    [self.window addSubview:filterView];
     filterSortTableView.tag = 0;
    [filterSortTableView reloadData];
    
}

-(IBAction)sortButtonClicked:(id)sender
{
    filterByLabel.text=@"Sort BY:";
    
    self.window = [UIApplication sharedApplication].keyWindow;
    blackView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.window.frame.size.height)];
    [blackView setBackgroundColor:[UIColor blackColor]];
    [blackView setAlpha:0.8];
    [self.window addSubview:blackView];
    [filterView setFrame:CGRectMake(blackView.frame.size.width-260, 57, 260, self.window.frame.size.height-57)];
    [self.window addSubview:filterView];
 
    filterSortTableView.tag = 1;
    [filterSortTableView reloadData];
 
 }


-(IBAction)filterBackgroundClicked:(id)sender
{
    [blackView removeFromSuperview];
    [filterView removeFromSuperview];
    filterBackgroundClicked.hidden=YES;
    
    if (filterSortTableView.tag==0)
    {
        [self filterBackGround];
    }
    else if (filterSortTableView.tag==1)
    {
        [self sortBackGround];
    }
}

-(void)filterBackGround
{
    NSMutableString *queryStringNotificationType = [NSMutableString new];
    NSMutableString *queryStringPriority = [NSMutableString new];
    NSMutableString *queryStringDate = [NSMutableString new];
    NSMutableString *queryStringStatus = [NSMutableString new];
    NSMutableString *queryStringAttachments = [NSMutableString new];
    
    NSMutableString *queryString = [NSMutableString new];
    NSPredicate *predicate;
    
    for (int j=0; j<[[self.structuredFilterSortedArray firstObject] count]; j++)
    {
        for (int k = 0; k<[[[self.structuredFilterSortedArray firstObject] objectAtIndex:0] count]; k++) {
            
            if ([[[[[self.structuredFilterSortedArray firstObject] objectAtIndex:0] objectAtIndex:k] objectAtIndex:1] isEqualToString:@"X"]) {
                
                if (![[[[[self.structuredFilterSortedArray firstObject] objectAtIndex:0] objectAtIndex:k] objectAtIndex:0] isEqualToString:@"All"]) {
                    
                    if ([queryStringNotificationType length]) {
                        [queryStringNotificationType appendString:@" or "];
                    }
                    
                    [queryStringNotificationType appendFormat:@"notificationh_type_name = '%@'",[[[[self.structuredFilterSortedArray firstObject] objectAtIndex:0] objectAtIndex:k] objectAtIndex:0]];
                    
//                    [queryStringNotificationType appendFormat:@"notificationh_type_name contains[c] '%@'",[[[[self.structuredFilterSortedArray firstObject] objectAtIndex:0] objectAtIndex:k] objectAtIndex:0]];
                    
                }
            }
        }
        
        for (int k = 0; k<[[[self.structuredFilterSortedArray firstObject] objectAtIndex:1] count]; k++) {
            
            if ([[[[[self.structuredFilterSortedArray firstObject] objectAtIndex:1] objectAtIndex:k] objectAtIndex:1] isEqualToString:@"X"]) {
                
                if (![[[[[self.structuredFilterSortedArray firstObject] objectAtIndex:1] objectAtIndex:k] objectAtIndex:0] isEqualToString:@"All"]) {
                    
                    if ([queryStringPriority length]) {
                        [queryStringPriority appendString:@" or "];
                    }
                    
                    [queryStringPriority appendFormat:@"notificationh_priority_name = '%@'",[[[[self.structuredFilterSortedArray firstObject] objectAtIndex:1] objectAtIndex:k] objectAtIndex:0]];
                    
//                    [queryStringNotificationType appendFormat:@"notificationh_priority_name contains[c] '%@'",[[[[self.structuredFilterSortedArray firstObject] objectAtIndex:1] objectAtIndex:k] objectAtIndex:0]];
                    
                }
            }
        }
        
        for (int k = 0; k<[[[self.structuredFilterSortedArray firstObject] objectAtIndex:2] count]; k++) {
            
            if ([[[[[self.structuredFilterSortedArray firstObject] objectAtIndex:2] objectAtIndex:k] objectAtIndex:1] isEqualToString:@"X"]) {
                
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"MMM dd, yyyy"];
                NSDate *requiredstartDate = [dateFormatter dateFromString:startDate];
                NSDate *requiredendDate = [dateFormatter dateFromString:endDate];
                // Convert date object into desired format
                [dateFormatter setDateFormat:@"yyyy-MM-dd"];
                
                NSString *convertedrequiredStartDateString = [dateFormatter stringFromDate:requiredstartDate];
                
                NSString *convertedrequiredEndDateString = [dateFormatter stringFromDate:requiredendDate] ;
                
                if ([queryStringDate length]) {
                    [queryStringDate setString:@""];
                }
                
                if ([[[[[self.structuredFilterSortedArray firstObject] objectAtIndex:2] objectAtIndex:k] objectAtIndex:0] isEqualToString:@"Created Date"]) {
                    
                    if (convertedrequiredStartDateString.length && convertedrequiredEndDateString.length) {
                        
                       // [NSPredicate predicateWithFormat:@"(date >= %@) AND (date <= %@)", startDate, endDate];
                        [queryStringDate appendFormat:@"notificationh_startdate BETWEEN '%@' and '%@'",convertedrequiredStartDateString,convertedrequiredEndDateString];
                        
//                         [queryStringDate appendFormat:@"(notificationh_startdate >= %@) AND (notificationh_startdate <= %@)",convertedrequiredStartDateString,convertedrequiredEndDateString];
                    }
                    else{
                        
                        NSDate *currentDate = [NSDate date];
                        // Convert date object into desired format
                        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
                        
                        NSString *convertedCurrentDateString = [dateFormatter stringFromDate:currentDate] ;
                        
                        if (convertedrequiredStartDateString.length) {
                            
                          //  [queryStringDate appendFormat:@"(notificationh_startdate >= %@) AND (notificationh_startdate <= %@)",convertedrequiredStartDateString,convertedCurrentDateString];
                            [queryStringDate appendFormat:@"notificationh_startdate BETWEEN '%@' and '%@'",convertedrequiredStartDateString,convertedCurrentDateString];
                        }
                        else if (convertedrequiredEndDateString.length) {
                            
                            [queryStringDate appendFormat:@"notificationh_startdate BETWEEN '%@' and '%@'",convertedrequiredEndDateString,convertedCurrentDateString];
                            
//                            [queryStringDate appendFormat:@"(notificationh_startdate >= %@) AND (notificationh_startdate <= %@)",convertedrequiredStartDateString,convertedCurrentDateString];
                        }
                    }
                }
                else if ([[[[[self.structuredFilterSortedArray firstObject] objectAtIndex:2] objectAtIndex:k] objectAtIndex:0] isEqualToString:@"Malfunction Date"]){
                    
                    if (convertedrequiredStartDateString.length && convertedrequiredEndDateString.length) {
                        
                        [queryStringDate appendFormat:@"notificationh_startdate BETWEEN '%@' and '%@'",convertedrequiredStartDateString,convertedrequiredEndDateString];
                        
//                         [queryStringDate appendFormat:@"(notificationh_startdate >= %@) AND (notificationh_startdate <= %@)",convertedrequiredStartDateString,convertedrequiredEndDateString];
                        
                    }
                    else{
                        
                        NSDate *currentDate = [NSDate date];
                        // Convert date object into desired format
                        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
                        
                        NSString *convertedCurrentDateString = [dateFormatter stringFromDate:currentDate];
                        
                        if (convertedrequiredStartDateString.length) {
                            
                            [queryStringDate appendFormat:@"notificationh_startdate BETWEEN '%@' and '%@'",convertedrequiredStartDateString,convertedCurrentDateString];
                        
//                            [queryStringDate appendFormat:@"(notificationh_startdate >= %@) AND (notificationh_startdate <= %@)",convertedrequiredStartDateString,convertedCurrentDateString];
                            
                        }
                        else if (convertedrequiredEndDateString.length) {
                            
                            [queryStringDate appendFormat:@"notificationh_startdate BETWEEN '%@' and '%@'",convertedrequiredEndDateString,convertedCurrentDateString];
                            
//                    [queryStringDate appendFormat:@"(notificationh_startdate >= %@) AND (notificationh_startdate <= %@)",convertedrequiredStartDateString,convertedCurrentDateString];
                            
                        }
                    }
                }
                else if ([[[[[self.structuredFilterSortedArray firstObject] objectAtIndex:2] objectAtIndex:k] objectAtIndex:0] isEqualToString:@"Required Date"]){
                    
                    if (convertedrequiredStartDateString.length && convertedrequiredEndDateString.length) {
                        [queryStringDate appendFormat:@"notificationh_reqstartdate BETWEEN '%@' and '%@'",convertedrequiredStartDateString,convertedrequiredEndDateString];
                        
//                         [queryStringDate appendFormat:@"(notificationh_reqstartdate >= %@) AND (notificationh_reqstartdate <= %@)",convertedrequiredStartDateString,convertedrequiredEndDateString];
                        
                    }
                    else{
                        
                        NSDate *currentDate = [NSDate date];
                        // Convert date object into desired format
                        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
                        
                        NSString *convertedCurrentDateString = [dateFormatter stringFromDate:currentDate];
                        
                        if (convertedrequiredStartDateString.length) {
                            
                            [queryStringDate appendFormat:@"notificationh_reqstartdate BETWEEN '%@' and '%@'",convertedrequiredStartDateString,convertedCurrentDateString];
                            
//                             [queryStringDate appendFormat:@"(notificationh_reqstartdate >= %@) AND (notificationh_reqstartdate <= %@)",convertedrequiredStartDateString,convertedCurrentDateString];
                            
                        }
                        else if (convertedrequiredEndDateString.length) {
                            
                            [queryStringDate appendFormat:@"notificationh_reqenddate BETWEEN '%@' and '%@'",convertedrequiredEndDateString,convertedCurrentDateString];
                            
//                              [queryStringDate appendFormat:@"(notificationh_reqenddate >= %@) AND (notificationh_reqenddate <= %@)",convertedrequiredEndDateString,convertedCurrentDateString];
                            
                        }
                    }
                }
            }
        }
        
        for (int k = 0; k<[[[self.structuredFilterSortedArray firstObject] objectAtIndex:3] count]; k++) {
            
            if ([[[[[self.structuredFilterSortedArray firstObject] objectAtIndex:3] objectAtIndex:k] objectAtIndex:1] isEqualToString:@"X"]) {
                
                if (![[[[[self.structuredFilterSortedArray firstObject] objectAtIndex:3] objectAtIndex:k] objectAtIndex:0] isEqualToString:@"All"]) {
                    
                    if ([queryStringStatus length]) {
                        [queryStringStatus appendString:@" or "];
                    }
                    
                    NSString *statusString;
                    
                    if ([[[[[self.structuredFilterSortedArray firstObject] objectAtIndex:3] objectAtIndex:k] objectAtIndex:0] isEqualToString:@"DLFL"]) {
                        
                        statusString=@"Cancelled";
                    }
                   else if ([[[[[self.structuredFilterSortedArray firstObject] objectAtIndex:3] objectAtIndex:k] objectAtIndex:0] isEqualToString:@"OSNO"]) {
                        
                        statusString=@"OSNO";
                    }
                    else if ([[[[[self.structuredFilterSortedArray firstObject] objectAtIndex:3] objectAtIndex:k] objectAtIndex:0] isEqualToString:@"NOCO"]){
                        statusString=@"Completed";
                        
                    }
                    else{
                        statusString=@"NOPR";
                    }
                    
                    [queryStringStatus appendFormat:@"notificationh_status contains[c] '%@'",statusString];
                }
            }
        }
    }
    
    if ([queryStringNotificationType length]) {
        
        [queryString appendFormat:@"(%@)",queryStringNotificationType];
    }
    
    if ([queryStringPriority length]) {
        
        if ([queryString length]) {
            
            [queryString appendFormat:@" and (%@)",queryStringPriority];
        }
        else
        {
            [queryString appendFormat:@" (%@)",queryStringPriority];
            
        }
    }
    
    if ([queryStringDate length]) {
        
        if ([queryString length]) {
            
            [queryString appendFormat:@" and (%@)",queryStringDate];
        }
        else
        {
            [queryString appendFormat:@" (%@)",queryStringDate];
        }
    }
    
    if ([queryStringStatus length]) {
        
        if ([queryString length]) {
            
            [queryString appendFormat:@" and (%@)",queryStringStatus];
        }
        else
        {
            [queryString appendFormat:@" (%@)",queryStringStatus];
        }
    }
    
    
    
    if ([[[[self.structuredFilterSortedArray firstObject] objectAtIndex:4] firstObject] containsObject:@"X"]) {
        
        if ([queryString length]) {
            
            [queryStringAttachments appendFormat:@" and (nh_docs = 'X')"];
            
        }
        else
        {
            [queryStringAttachments appendFormat:@" (nh_docs = '')"];
            
        }
        
        [queryString appendString:queryStringAttachments];
    }
    
    if ([[[[self.structuredFilterSortedArray firstObject] objectAtIndex:5] firstObject] containsObject:@"X"]) {
        
        if ([queryString length]) {
            
            NSArray *parnerDataArray=[[DataBase sharedInstance] getPernrFromMasterData];
            
             if ([parnerDataArray count]) {
 
                [queryStringAttachments appendFormat:@" and (notificationh_personresponsible_id = '%@')",[[parnerDataArray objectAtIndex:0] objectAtIndex:0]];
             }
            
          }
        else
        {
            [queryStringAttachments appendFormat:@" (notificationh_personresponsible_id = '')"];
            
        }
        
        [queryString appendString:queryStringAttachments];
    }
 
    if ([wrkcenterQueryString length]) {
        
        if ([queryString length]) {
            
            [queryString appendFormat:@" and (%@)",wrkcenterQueryString];
        }
        else
        {
            [queryString appendFormat:@" (%@)",wrkcenterQueryString];
        }
    }
 
 
    NSArray *filtersArray=[[DataBase sharedInstance] getPriorityList:queryString];
    
    [self.notificationListArray removeAllObjects];
    
    [self.notificationListArray addObjectsFromArray:filtersArray];
    myNotificationsCountLabel.text = [NSString stringWithFormat:@"Notifications (%i)",(int)[self.notificationListArray count]];
    myNotificationsTableView.tag=0;
    [myNotificationsTableView scrollRectToVisible:CGRectMake(0, 0, 0, 0) animated:YES];
    [myNotificationsTableView reloadData];
}

-(void)sortBackGround
{
    NSMutableString *queryStringDescription = [NSMutableString new];
    NSMutableString *queryStringStatus = [NSMutableString new];
    NSMutableString *queryStringMalFunctiondate = [NSMutableString new];
    NSMutableString *queryStringNotificationNumber = [NSMutableString new];

    NSMutableString *queryString = [NSMutableString new];
    
    if ([[[[[self.structuredFilterSortedArray objectAtIndex:1] objectAtIndex:0] objectAtIndex:0] objectAtIndex:1] isEqualToString:@"X"]) {
        
        [queryStringDescription appendFormat:@" notificationh_shorttext ASC "];
    }
    else if ([[[[[self.structuredFilterSortedArray objectAtIndex:1] objectAtIndex:0] objectAtIndex:1] objectAtIndex:1] isEqualToString:@"X"])
    {
        [queryStringDescription appendFormat:@" notificationh_shorttext DESC "];
    }
    
    if ([queryStringDescription length]) {
        
        [queryString appendFormat:@"%@",queryStringDescription];
    }
    
    
    if ([[[[[self.structuredFilterSortedArray objectAtIndex:1] objectAtIndex:2] objectAtIndex:0] objectAtIndex:1] isEqualToString:@"X"]) {
        
        [queryStringMalFunctiondate appendFormat:@" notificationh_startdate ASC "];
    }
    
    else if ([[[[[self.structuredFilterSortedArray objectAtIndex:1] objectAtIndex:2] objectAtIndex:1] objectAtIndex:1] isEqualToString:@"X"])
    {
        [queryStringMalFunctiondate appendFormat:@" notificationh_startdate DESC "];
        
    }
    
    
    if ([queryStringMalFunctiondate length]) {
        
        if ([queryString length]) {
            [queryString appendFormat:@",%@",queryStringMalFunctiondate];
        }
        else{
            
            [queryString appendFormat:@"%@",queryStringMalFunctiondate];
        }
    }
    
    if ([[[[[self.structuredFilterSortedArray objectAtIndex:1] objectAtIndex:1] objectAtIndex:0] objectAtIndex:1] isEqualToString:@"X"]) {
        
        [queryStringStatus appendFormat:@" notificationh_priorityid ASC "];
    }
    
    else  if ([[[[[self.structuredFilterSortedArray objectAtIndex:1] objectAtIndex:1] objectAtIndex:1] objectAtIndex:1] isEqualToString:@"X"])
    {
        [queryStringStatus appendFormat:@" notificationh_priorityid DESC "];
        
    }
    
    if ([queryStringStatus length]) {
        
        if ([queryString length]) {
            [queryString appendFormat:@",%@",queryStringStatus];
        }
        else{
            
            [queryString appendFormat:@"%@",queryStringStatus];
        }
    }
    
    if ([[[[[self.structuredFilterSortedArray objectAtIndex:1] objectAtIndex:3] objectAtIndex:0] objectAtIndex:1] isEqualToString:@"X"]) {
        
        [queryStringNotificationNumber appendFormat:@" nh_objectID ASC "];
    }
    
    else  if ([[[[[self.structuredFilterSortedArray objectAtIndex:1] objectAtIndex:3] objectAtIndex:1] objectAtIndex:1] isEqualToString:@"X"])
    {
        [queryStringNotificationNumber appendFormat:@" nh_objectID DESC "];
        
    }
    
    if ([queryStringNotificationNumber length]) {
        
        if ([queryString length]) {
            [queryString appendFormat:@",%@",queryStringNotificationNumber];
        }
        else{
            
            [queryString appendFormat:@"%@",queryStringNotificationNumber];
        }
    }
    
    
    NSArray *filtersArray=[[DataBase sharedInstance] getSortedList:queryString];
    
    [self.notificationListArray removeAllObjects];
    
    [self.notificationListArray addObjectsFromArray:filtersArray];
    
    myNotificationsCountLabel.text = [NSString stringWithFormat:@"Notifications (%i)",(int)[self.notificationListArray count]];
    
    [myNotificationsTableView scrollRectToVisible:CGRectMake(0, 0, 0, 0) animated:YES];
    
    myNotificationsTableView.tag=0;
    
    [myNotificationsTableView reloadData];
}

- (IBAction)backButtonClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)clearAllFilterSortButtonClicked:(id)sender
{
    if (filterSortTableView.tag==0)
    {
        for (int i=0; i<[[self.structuredFilterSortedArray firstObject] count]; i++) {

            for (int j=0; j<[[[self.structuredFilterSortedArray firstObject] objectAtIndex:i] count];j++)
            {
                [[[[self.structuredFilterSortedArray firstObject] objectAtIndex:i] objectAtIndex:j] replaceObjectAtIndex:1 withObject:@""];
            }
        }
    }
    else if (filterSortTableView.tag==1)
    {
        for (int i=0; i<[[self.structuredFilterSortedArray objectAtIndex:1] count]; i++) {

            for (int j=0; j<[[[self.structuredFilterSortedArray lastObject] objectAtIndex:i] count];j++)
            {
                [[[[self.structuredFilterSortedArray lastObject] objectAtIndex:i] objectAtIndex:j] replaceObjectAtIndex:1 withObject:@""];
            }
        }
    }
 
    
        [filterView removeFromSuperview];
        filterBackgroundClicked.hidden=YES;
        [filterSortTableView reloadData];
        [blackView removeFromSuperview];
 
       [self searchMyNotificationsFromSqlite:nil];

    
}

-(IBAction)refreshBtn:(id)sender{
    
    if ([[ConnectionManager defaultManager] isReachable]) {
        
        [defaults setObject:@"REFRESH" forKey:@"REFRESH"];
        [defaults synchronize];
 
        [self showAlertMessageWithTitle:@"Refresh" message:@"All Relavent Data will be loaded from server.\nDo you want to continue?" cancelButtonTitle:@"No" withactionType:@"Multiple" forMethod:@"Refresh"];
        
    }
    else{
        
        if ([[defaults objectForKey:@"ACTIVATELOGS"] isEqualToString:@"X"])
        {
            [[DataBase sharedInstance] writToLogFile:[NSString stringWithFormat:@"#INFO#.com.enstrapp.fieldtekpro #Activity:Refresh   #Class: Very Important #MUser:%@ #DeviceId:%@",decryptedUserName,[defaults objectForKey:@"edeviceid"]]];
        }
 
        [self showAlertMessageWithTitle:@"No Network Available" message:@"Refresh cannot be performed!" cancelButtonTitle:@"No" withactionType:@"Single" forMethod:nil];
     }
}




#pragma mark-
#pragma mark- UISearchBar delegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
     [_notificationSearchBar resignFirstResponder];
}

#pragma mark-
#pragma mark- Button Actions

-(IBAction)cancelSearchBarView:(id)sender{
   
    [myNotificationsTableView setTableHeaderView:nil];
   
   // [self filterBackGround];
}


-(IBAction)cancelFilterSort:(id)sender
{
      [blackView removeFromSuperview];
      [filterView removeFromSuperview];
}

-(IBAction)cancelNotifications:(id)sender{
    
     //    NSString *filterString = [NSString stringWithFormat:@"nh_objectID like '%@%%' or notificationh_shorttext like '%@%%' or notificationh_priority_name like '%@%%' or notificationh_startdate like '%@%%' or notificationh_status like '%@%%' or notificationh_equip_id like '%@%%'",searchText,searchText,searchText,searchText,searchText,searchText];
    
    if ([selectedCheckBoxArray count] == 1) {
        NSMutableArray *objectIds = [NSMutableArray new];
        for (int i=0; i<[selectedCheckBoxArray count]; i++) {
            
            int rowIndex = [[selectedCheckBoxArray objectAtIndex:i] intValue];
            
            if ([[[self.notificationListArray objectAtIndex:rowIndex] objectForKey:@"notificationh_status"] isEqualToString:@"Cancelled"]) {
                [objectIds addObject:[NSString stringWithString:[[self.notificationListArray objectAtIndex:rowIndex] objectForKey:@"notificationh_status"]]];
            }
            else if ([[[self.notificationListArray objectAtIndex:rowIndex] objectForKey:@"notificationh_status"] isEqualToString:@"Completed"]){
                [objectIds addObject:[NSString stringWithString:[[self.notificationListArray objectAtIndex:rowIndex] objectForKey:@"notificationh_status"]]];
            }
        }
        if ([objectIds count])
        {
 
               [self showAlertMessageWithTitle:@"Information" message:@"Selected notification cannot be Cancelled" cancelButtonTitle:@"Ok" withactionType:@"Single" forMethod:nil];
            
        }
        else
        {
 
             [self showAlertMessageWithTitle:@"Decision" message:@"Do you want to cancel the selected Notification?" cancelButtonTitle:@"No" withactionType:@"Multiple" forMethod:@"Cancel"];
            
 
        }
    }
    else if ([selectedCheckBoxArray count] >1)
    {
        
         [self showAlertMessageWithTitle:@"Information" message:@"Please select only one notification to cancel" cancelButtonTitle:@"No" withactionType:@"Single" forMethod:nil];
 
    }
    else{
        
        
        [self showAlertMessageWithTitle:@"Information" message:@"Please select atleast one notification" cancelButtonTitle:@"No" withactionType:@"Single" forMethod:nil];
        
    }
}
 
    -(void)completeNotifvalidation{
        
        NSMutableArray *objectIds = [NSMutableArray new];
 
            int rowIndex = selectedRow;
            
            if ([[[self.notificationListArray objectAtIndex:rowIndex] objectForKey:@"notificationh_status"] isEqualToString:@"Cancelled"] || [[[self.notificationListArray objectAtIndex:rowIndex] objectForKey:@"notificationh_status"] isEqualToString:@""]) {
                [objectIds addObject:[NSString stringWithString:[[self.notificationListArray objectAtIndex:rowIndex] objectForKey:@"notificationh_status"]]];
            }
            else if ([[[self.notificationListArray objectAtIndex:rowIndex] objectForKey:@"notificationh_status"] isEqualToString:@"Completed"] || [[[self.notificationListArray objectAtIndex:rowIndex] objectForKey:@"notificationh_status"] isEqualToString:@""]){
                [objectIds addObject:[NSString stringWithString:[[self.notificationListArray objectAtIndex:rowIndex] objectForKey:@"notificationh_status"]]];
            }
        
        
        if ([objectIds count])
        {
             [self showAlertMessageWithTitle:@"Information" message:[NSString stringWithFormat:@"Selected notification cannot be completed"] cancelButtonTitle:@"Ok" withactionType:@"Single" forMethod:nil];
        }
        else
        {
             [self showAlertMessageWithTitle:@"Decision" message:[NSString stringWithFormat:@"Do you want to complete the selected Notification?"] cancelButtonTitle:@"No" withactionType:@"Multiple" forMethod:@"CompleteNotif"];
         }

    
    }
 
#pragma mark-
#pragma mark- Void Methods

-(void)functionForSyncMapData{
    
    if (syncMapDataMutableArray == nil) {
        syncMapDataMutableArray = [NSMutableArray new];
    }
    else{
        [syncMapDataMutableArray removeAllObjects];
    }
    
    [syncMapDataMutableArray addObjectsFromArray:[[DataBase sharedInstance] getSyncMapData:@"SOAP"]];
    
    if ([syncMapDataMutableArray count]) {
        
        if ([[ConnectionManager defaultManager] isReachable]) {
            
            // [self performSelectorOnMainThread:@selector(getLoadSettings) withObject:nil waitUntilDone:YES];
            
            [self getLoadSettings];
            
        }
    }
}

-(void)getLoadSettings{
    
    NSMutableDictionary *endPointDictionary = [NSMutableDictionary new];
    [endPointDictionary setObject:@"F4" forKey:@"ACTIVITY"];
    [endPointDictionary setObject:@"D1" forKey:@"DOCTYPE"];
    [endPointDictionary setObject:[defaults objectForKey:@"ENDPOINT"] forKey:@"ENDPOINT"];
    
    NSArray *endPointArray = [[DataBase sharedInstance] getEndPointURL:endPointDictionary];
    NSLog(@"endPoint :%@",[[endPointArray objectAtIndex:0] objectAtIndex:0]);
    [endPointDictionary setObject:[[endPointArray objectAtIndex:0] objectAtIndex:0] forKey:@"URL_ENDPOINT"];
    [endPointDictionary setObject:@"REFR" forKey:@"TRANSMITTYPE"];
    [endPointDictionary setObject:decryptedUserName forKey:@"REPORTEDBY"];

    [Request makeWebServiceRequest:GET_LOAD_SETTINGS parameters:endPointDictionary delegate:self];
    
}

-(void)getDueNotifications{
    
    NSMutableDictionary *endPointDictionary = [NSMutableDictionary new];
    [endPointDictionary setObject:@"DN" forKey:@"ACTIVITY"];
    [endPointDictionary setObject:@"C1" forKey:@"DOCTYPE"];
    [endPointDictionary setObject:[defaults objectForKey:@"ENDPOINT"] forKey:@"ENDPOINT"];
     NSArray *endPointArray = [[DataBase sharedInstance] getEndPointURL:endPointDictionary];
    NSLog(@"endPoint :%@",[[endPointArray objectAtIndex:0] objectAtIndex:0]);
    [endPointDictionary setObject:[[endPointArray objectAtIndex:0] objectAtIndex:0] forKey:@"URL_ENDPOINT"];
    [endPointDictionary setObject:@"REFR" forKey:@"TRANSMITTYPE"];
     [endPointDictionary setObject:decryptedUserName forKey:@"REPORTEDBY"];
    
    [Request makeWebServiceRequest:GET_LIST_OF_DUE_NOTIFICATIONS parameters:endPointDictionary delegate:self];
    
}

#pragma mark-
#pragma mark- Sort Options

-(IBAction)notifNoSort:(id)sender{
    [inputsDictionary removeAllObjects];
    
    if (notifNoSortSelected) {
        [notifNoSortBtn setImage:[UIImage imageNamed:@"SortUp.png"] forState:UIControlStateNormal];
        [inputsDictionary setObject:@"ASC" forKey:@"SORT"];
        notifNoSortSelected = NO;
    }
    else{
        [notifNoSortBtn setImage:[UIImage imageNamed:@"SortDown.png"] forState:UIControlStateNormal];
        [inputsDictionary setObject:@"DESC" forKey:@"SORT"];
        notifNoSortSelected = YES;
    }
    [inputsDictionary setObject:@"nh_objectid" forKey:@"COLOUMN"];
    
    [self searchMyNotificationsFromSqlite:inputsDictionary];
}

-(IBAction)statusSelected:(id)sender{
    [inputsDictionary removeAllObjects];
    
    if (statusSortSelected) {
        [statusSortBtn setImage:[UIImage imageNamed:@"SortUp.png"] forState:UIControlStateNormal];
        [inputsDictionary setObject:@"ASC" forKey:@"SORT"];
        statusSortSelected = NO;
    }
    else{
        [statusSortBtn setImage:[UIImage imageNamed:@"SortDown.png"] forState:UIControlStateNormal];
        [inputsDictionary setObject:@"DESC" forKey:@"SORT"];
        statusSortSelected = YES;
    }
    [inputsDictionary setObject:@"notificationh_status" forKey:@"COLOUMN"];
    
    [self searchMyNotificationsFromSqlite:inputsDictionary];
}

-(IBAction)shortTextSelected:(id)sender{
    [inputsDictionary removeAllObjects];
    
    if (shortTextSortSelected) {
        [shortTextSortBtn setImage:[UIImage imageNamed:@"SortUp.png"] forState:UIControlStateNormal];
        [inputsDictionary setObject:@"ASC" forKey:@"SORT"];
        shortTextSortSelected = NO;
    }
    else{
        [shortTextSortBtn setImage:[UIImage imageNamed:@"SortDown.png"] forState:UIControlStateNormal];
        [inputsDictionary setObject:@"DESC" forKey:@"SORT"];
        shortTextSortSelected = YES;
    }
    [inputsDictionary setObject:@"notificationh_shorttext" forKey:@"COLOUMN"];
    
    [self searchMyNotificationsFromSqlite:inputsDictionary];
}

-(IBAction)prioritySelected:(id)sender{
    [inputsDictionary removeAllObjects];
    
    if (prioritySortSelected) {
        [prioritySortBtn setImage:[UIImage imageNamed:@"SortUp.png"] forState:UIControlStateNormal];
        [inputsDictionary setObject:@"ASC" forKey:@"SORT"];
        prioritySortSelected = NO;
    }
    else{
        [prioritySortBtn setImage:[UIImage imageNamed:@"SortDown.png"] forState:UIControlStateNormal];
        [inputsDictionary setObject:@"DESC" forKey:@"SORT"];
        prioritySortSelected = YES;
    }
    [inputsDictionary setObject:@"notificationh_priority_name" forKey:@"COLOUMN"];
    
    [self searchMyNotificationsFromSqlite:inputsDictionary];
}

-(IBAction)startDateSelected:(id)sender{
    [inputsDictionary removeAllObjects];
    
    if (malFuncStartDateSortSelected) {
        [malFuncStartDateSortBtn setImage:[UIImage imageNamed:@"SortUp.png"] forState:UIControlStateNormal];
        [inputsDictionary setObject:@"ASC" forKey:@"SORT"];
        malFuncStartDateSortSelected = NO;
    }
    else{
        [malFuncStartDateSortBtn setImage:[UIImage imageNamed:@"SortDown.png"] forState:UIControlStateNormal];
        [inputsDictionary setObject:@"DESC" forKey:@"SORT"];
        
        malFuncStartDateSortSelected = YES;
    }
    [inputsDictionary setObject:@"notificationh_startdate" forKey:@"COLOUMN"];
    
    [self searchMyNotificationsFromSqlite:inputsDictionary];
}

-(IBAction)createNoticationBtn:(id)sender{
    
    CreateNotificationViewController *createVc = [self.storyboard instantiateViewControllerWithIdentifier:@"CreateNotifIdentifier"];
    
     [self showViewController:createVc sender:self];
}

//- (void)dismissMyNotificationsViewController
//{
//    if (self.notificationSearchBar.text.length) {
//        [self searchBar:self.notificationSearchBar textDidChange:self.notificationSearchBar.text];
//    }
//    else{
//        [self searchMyNotificationsFromSqlite:nil];
//    }
//
//    [createNotification.view removeFromSuperview];
//    createNotification = nil;
//}

- (void)poptoMyNotificationsViewController
{
    [inputsDictionary removeAllObjects];
    [inputsDictionary setObject:@"ORDER BY nh_upadated_Date DESC" forKey:@"RECENT"];
    [self searchMyNotificationsFromSqlite:inputsDictionary];
   // [createNotification.view removeFromSuperview];
    //createNotification = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark-
#pragma mark-Date Picker for Text Field

//for Datepicker.
-(void)datePickerForStartDate{
    
    [filterSortTableView reloadData];
}

-(void)pickerCancelClicked{
    
    [filterSortTableView reloadData];
    
}

-(void)pickerDoneStartDateClicked
{
    [filterSortTableView reloadData];
    
}

//for Datepicker.
-(void)datePickerForEndDate{
    
    [filterSortTableView reloadData];
    
}


-(void)pickerEndCancelClicked{
    
    [filterSortTableView reloadData];
    
}

-(void)pickerDoneEndDateClicked
{
    [filterSortTableView reloadData];
    
}

-(IBAction)backToNotificationsFromSystemStatus:(id)sender{
    
    [systemStatusView removeFromSuperview];
}



#pragma mark-
#pragma mark- UITextFieldDelegate

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    int indexPathRow = (int)textField.superview.tag;
    headerIndexPathRow = indexPathRow;
    
    textfieldTag=(int)textField.tag;
    
    if (textfieldTag==10) {
        
        self.startDatePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, 250, 0, 0)];
        
        self.startDatePicker.datePickerMode = UIDatePickerModeDate;
        
        textField.inputView =self.startDatePicker;
        
        UIToolbar *myDatePickerToolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 100, 320, 56)];
        
        myDatePickerToolBar.barStyle = UIBarStyleBlackOpaque;
        
        [myDatePickerToolBar sizeToFit];
        
        NSMutableArray *barItems = [[NSMutableArray alloc] init];
        
        UIBarButtonItem *cnclBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(pickerCancelClicked)];
        
        [barItems addObject:cnclBtn];
        
        UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
        
        [barItems addObject:flexSpace];
        
        UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(pickerDoneStartDateClicked)];
        
        [barItems addObject:doneBtn];
        
        [myDatePickerToolBar setItems:barItems animated:YES];
        textField.inputAccessoryView = myDatePickerToolBar;
    }
    else if (textfieldTag==20)
    {
        self.EndDatePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, 250, 0, 0)];
        self.EndDatePicker.datePickerMode = UIDatePickerModeDate;
        textField.inputView =self.EndDatePicker;
        UIToolbar *myDatePickerToolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 100, 320, 56)];
        myDatePickerToolBar.barStyle = UIBarStyleBlackOpaque;
        [myDatePickerToolBar sizeToFit];
        NSMutableArray *barItems = [[NSMutableArray alloc] init];
        UIBarButtonItem *cnclBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(pickerEndCancelClicked)];
        [barItems addObject:cnclBtn];
        UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
        [barItems addObject:flexSpace];
        UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(pickerDoneEndDateClicked)];
        [barItems addObject:doneBtn];
        [myDatePickerToolBar setItems:barItems animated:YES];
        textField.inputAccessoryView = myDatePickerToolBar;
    }
    else if (textfieldTag==30){
 
        [blackView removeFromSuperview];
        [filterView removeFromSuperview];
        
        WorkcenterViewController *equipVc = [self.storyboard instantiateViewControllerWithIdentifier:@"wrkcenterVC"];
         equipVc.delegate=self;
        [self showViewController:equipVc sender:self];
        
          return NO;
        
    }
    
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    textfieldTag=(int)textField.tag;
    
    if (textfieldTag==10)
    {
        self.minStartDate =[self.startDatePicker date];
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"MMM dd, yyyy"];
        textField.text = [dateFormat stringFromDate:self.minStartDate];
        startDate = textField.text;
    }
    else if (textfieldTag==20)
    {
        self.minStartDate =[self.EndDatePicker date];
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"MMM dd, yyyy"];
        textField.text = [dateFormat stringFromDate:self.minStartDate];
        endDate = textField.text;
    }
    
 
    return YES;
}

-(void)dismissWorkcenterView {
    
    Response *res_obj=[Response sharedInstance];
    
    wrckcenterStringl=[NSMutableString new];
    
    wrkcenterQueryString=[NSMutableString new];

    
     for (int i=0; i<[res_obj.workcenterArray count]; i++) {
        
         if (wrckcenterStringl.length) {
             
             [wrckcenterStringl appendString:@", "];
         }
         if (wrkcenterQueryString.length) {
             
             [wrkcenterQueryString appendString:@" or "];
         }
        [wrckcenterStringl appendString:[res_obj.workcenterArray objectAtIndex:i]];
         
        [wrkcenterQueryString appendFormat:@" notificationh_workcenterid = '%@'",[res_obj.workcenterArray objectAtIndex:i]];
 
     }
 
    filterByLabel.text=@"Filter BY:";
    
    self.window = [UIApplication sharedApplication].keyWindow;
    blackView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.window.frame.size.height)];
    [blackView setBackgroundColor:[UIColor blackColor]];
    [blackView setAlpha:0.8];
    [self.window addSubview:blackView];
    [filterView setFrame:CGRectMake(blackView.frame.size.width-260, 57, 260, self.window.frame.size.height-57)];
    [self.window addSubview:filterView];
    filterSortTableView.tag = 0;
    [filterSortTableView reloadData];
    
 
     [self.navigationController popViewControllerAnimated:YES];

 }

#pragma mark
#pragma mark - TableView Delegate Methods
//table view methods strats here

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;              // Default is 1 if not implemented
{
    if (tableView==filterSortTableView)
    {
        if (filterSortTableView.tag==0) {
            return 7;
        }
        else{
             return 4;
        }
    }
     return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (tableView == myNotificationsTableView) {
        
        UILabel *noDataLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, tableView.bounds.size.height)];
        noDataLabel.textAlignment = NSTextAlignmentCenter;
        tableView.backgroundView = noDataLabel;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
          if (myNotificationsTableView.tag==0) {
            
            if ([self.notificationListArray count]) {
                noDataLabel.text = @"";
                noDataLabel.textColor = [UIColor grayColor];
                
                return [self.notificationListArray count];
            }
            else{
                noDataLabel.text = @"No data available";
                noDataLabel.textColor = [UIColor grayColor];
             }
         }
        else if (myNotificationsTableView.tag==1){
            
            if ([filteredArray count]) {
                noDataLabel.text = @"";
                noDataLabel.textColor = [UIColor grayColor];
                
                return [filteredArray count];
            }
            else{
                
                noDataLabel.text = @"No data available";
                noDataLabel.textColor = [UIColor grayColor];
                
            }
        }
     }
    else if (tableView== filterSortTableView)
    {
        if (filterSortTableView.tag==0) {
            
            return [[[self.structuredFilterSortedArray firstObject] objectAtIndex:section] count];
            
        }
        else if (filterSortTableView.tag==1)
        {
            return [[[self.structuredFilterSortedArray lastObject] objectAtIndex:section] count];
        }
    }
    
    else if (tableView==systemStatusTableView){
        
        return [notificationSystemStatusArray count];
    }
    return 0;
}


-(NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (tableView==myNotificationsTableView) {
        
         selectedRow=(int)indexPath.row;

         UITableViewRowAction *nocoAction,*relAction,*nopoAction;
 
            if ([[[self.notificationListArray objectAtIndex:indexPath.row] objectForKey:@"notificationh_status"] isEqualToString:@"OSNO"]) {
 
              relAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"REL" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
                  //insert your editAction here
                  
                  [self ReleaseMethod];
                  
              }];
              
              relAction.backgroundColor = [UIColor blueColor];

              nocoAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"NOCO"  handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
                  //insert your deleteAction here
                  [self completeNotifvalidation];
                  
              }];
              
              nocoAction.backgroundColor = [UIColor greenColor];
 
                    nopoAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"NOPO"  handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
                        //insert your deleteAction here
                        [self postPoneNotifications];
                        
                    }];
                    
                    nopoAction.backgroundColor = [UIColor redColor];
                
                  return @[nopoAction,relAction,nocoAction];

            }
        
            else if  ([[[self.notificationListArray objectAtIndex:indexPath.row] objectForKey:@"notificationh_status"] isEqualToString:@"NOPR"]){
                
                relAction.backgroundColor = [UIColor blueColor];
                
                nocoAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"NOCO"  handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
                    //insert your deleteAction here
                    [self completeNotifvalidation];
                    
                }];
                
                nocoAction.backgroundColor = [UIColor greenColor];
                
                return @[nocoAction];
            }
        
            else{
                
                return nil;
            }
      }

    return nil;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.

    if (tableView==myNotificationsTableView) {
        
        return YES;
    }

    return NO;
}

-(void)deleteIncidentAttachments{


}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (tableView== filterSortTableView)
    {
        if (filterSortTableView.tag==0)
        {
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 18)];
            /* Create custom view to display section header... */
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10,0, tableView.frame.size.width, 18)];
            [label setFont:[UIFont boldSystemFontOfSize:12]];
            /* Section header is in 0th index... */
            
            if (section==0)
            {
                [label setText:@"Notification Type"];
            }
            else if (section==1)
            {
                [label setText:@"Priority"];
            }
            else if (section==2)
            {
                [label setText:@"Date"];
            }
            else if (section == 3){
                
                [label setText:@"Status"];
            }
            else if (section == 4){
                
                 [label setText:@"Attachments"];

            }
            else if (section == 5){
                
                [label setText:@"Person Responsible"];
                
            }
            else
            {
                [label setText:@"Work center"];

            }
            
            [view addSubview:label];
            //[view setBackgroundColor:[UIColor colorWithRed:166/255.0 green:177/255.0 blue:186/255.0 alpha:1.0]]; //your background color...
            return view;
        }
        
        if (filterSortTableView.tag==1)
        {
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 18)];
            /* Create custom view to display section header... */
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10,0, tableView.frame.size.width, 18)];
            [label setFont:[UIFont boldSystemFontOfSize:12]];
            /* Section header is in 0th index... */
            
            if (section==0)
            {
                [label setText:@"Description"];
                
            }
            else if (section==1)
            {
                [label setText:@"Status"];
                
            }
            else if(section ==2)
            {
                [label setText:@"Start Date "];
                
            }
            else
            {
                [label setText:@"Notification Number"];
 
            }
            [view addSubview:label];
            
            return view;
            
        }
    }
    
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.accessoryType=UITableViewCellAccessoryNone;
    
    if (tableView == myNotificationsTableView) {
        
        if (myNotificationsTableView.contentSize.height < myNotificationsTableView.frame.size.height) {
            myNotificationsTableView.scrollEnabled = NO;
        }
        else {
            myNotificationsTableView.scrollEnabled = YES;
        }
        static NSString *CellIdentifier = @"CustomCell";
        
         MyNotificationsListTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell==nil) {
            cell=[[MyNotificationsListTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
 
         cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.notifView.layer.cornerRadius = 2.0f;
        cell.notifView.layer.masksToBounds = YES;
        cell.notifView.layer.borderColor = [[UIColor darkGrayColor] CGColor];
        cell.notifView.layer.borderWidth = 1.0f;
 
        if (myNotificationsTableView.tag==0) {
           
            NSString *statusCode=[NSString stringWithFormat:@"%@",[[self.notificationListArray objectAtIndex:indexPath.row] objectForKey:@"notificationh_status"]];
            
            CALayer *layer = [cell.statusButton layer];
            [layer setMasksToBounds:YES];
            [layer setCornerRadius:cell.statusButton.frame.size.width / 2];
 
          //  [cell.statusButton addTarget:self action:@selector(checkBoxClicked:)   forControlEvents:UIControlEventTouchDown];
            
            [cell.changeNotificationButton addTarget:self action:@selector(detailCheckBoxSelected:) forControlEvents:UIControlEventTouchDown];
            
            if ([[[self.notificationListArray objectAtIndex:indexPath.row] objectForKey:@"notificationh_priorityid"] isEqual:@"1"]) {
                cell.priorityLabel.backgroundColor = [UIColor redColor];
            }
            else if ([[[self.notificationListArray objectAtIndex:indexPath.row] objectForKey:@"notificationh_priorityid"] isEqual:@"2"]){
                cell.priorityLabel.backgroundColor = [UIColor redColor];
            }
            else if ([[[self.notificationListArray objectAtIndex:indexPath.row] objectForKey:@"notificationh_priorityid"] isEqual:@"3"]){//Medium
                cell.priorityLabel.backgroundColor = [UIColor orangeColor];
            }
            else if ([[[self.notificationListArray objectAtIndex:indexPath.row] objectForKey:@"notificationh_priorityid"] isEqual:@"4"]){//Low
                cell.priorityLabel.backgroundColor = [UIColor lightGrayColor];
            }
            else
            {
                cell.priorityLabel.backgroundColor = [UIColor whiteColor];
            }
 
            cell.attachmentImage.hidden = YES;
            
            cell.priorityLabel.text =[ NSString stringWithFormat:@"%@",[[self.notificationListArray objectAtIndex:indexPath.row] objectForKey:@"notificationh_priority_name"]];
            
            if ([[[self.notificationListArray objectAtIndex:indexPath.row] objectForKey:@"nh_docs"] isEqualToString:@"X"]) {
                cell.attachmentImage.hidden = NO;
            }
            cell.notificationNoLabel.text =[NSString stringWithFormat:@"%@",[[self.notificationListArray objectAtIndex:indexPath.row] objectForKey:@"nh_objectID"]];
            cell.notificationTextLabel.text = [NSString stringWithFormat: @"%@",[[self.notificationListArray objectAtIndex:indexPath.row] objectForKey:@"notificationh_shorttext"]];
            
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyyMMdd HHmmss"];
            NSDate *tempStartDate = [dateFormatter dateFromString:[[self.notificationListArray objectAtIndex:indexPath.row] objectForKey:@"notificationh_startdate"]];
            // Convert date object into desired format
            [dateFormatter setDateFormat:@"MMM dd, yyyy"];
            
            NSString *convertedStartDateString = [dateFormatter stringFromDate:tempStartDate];
            if ([NullChecker isNull:convertedStartDateString]) {
                convertedStartDateString = @"";
            }
            
            cell.startDateLabel.text = [NSString stringWithFormat:@"%@",convertedStartDateString];
            cell.statusCodeLabel.text = [NSString stringWithFormat:@"%@",[[self.notificationListArray objectAtIndex:indexPath.row] objectForKey:@"notificationh_status"]];
            
            if ([selectedCheckBoxArray containsObject:[NSNumber numberWithInteger:indexPath.row]])
            {
                [cell.statusButton setImage:[UIImage imageNamed:@"Checked-Icon.png"]   forState:UIControlStateNormal];
            }
            else
            {
                [cell.statusButton setImage:nil  forState:UIControlStateNormal];
            }
            
            [cell.statusButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            
            if ([statusCode isEqualToString:@"NOPR"]) {
                
                [cell.statusButton setBackgroundColor:UIColorFromRGB(39, 171, 226)];
                [cell.statusButton setTitle:statusCode forState:UIControlStateNormal];
                
            }
            else if ([statusCode isEqualToString:@"Cancelled"]){
                
                cell.statusButton.backgroundColor=[UIColor redColor];
                [cell.statusButton setTitle:@"DLFL" forState:UIControlStateNormal];
                
            }
            else if ([statusCode isEqualToString:@"Completed"]){
                
                [cell.statusButton setTitle:@"NOCO" forState:UIControlStateNormal];
                cell.statusButton.backgroundColor=[UIColor greenColor];
            }
            else if ([statusCode isEqualToString:@"OSNO"]){
                
                [cell.statusButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
                cell.statusButton.backgroundColor=[UIColor yellowColor];
                [cell.statusButton setTitle:@"OSNO" forState:UIControlStateNormal];
                
            }
            else{
                [cell.statusButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
                [cell.statusButton setBackgroundColor:[UIColor yellowColor]];
                
            }
            
            [cell.systemStatusButton addTarget:self action:@selector(selectedSystemStatus:) forControlEvents:UIControlEventTouchDown];
            
            return cell;
        }
        else if (myNotificationsTableView.tag==1){
            
            NSString *statusCode=[NSString stringWithFormat:@"%@",[[filteredArray objectAtIndex:indexPath.row] objectForKey:@"notificationh_status"]];
            
            CALayer *layer = [cell.statusButton layer];
            [layer setMasksToBounds:YES];
            [layer setCornerRadius:cell.statusButton.frame.size.width / 2];
            
            
          //  [cell.statusButton addTarget:self action:@selector(checkBoxClicked:)   forControlEvents:UIControlEventTouchDown];
            
            [cell.changeNotificationButton addTarget:self action:@selector(detailCheckBoxSelected:) forControlEvents:UIControlEventTouchDown];
            
            if ([[[filteredArray objectAtIndex:indexPath.row] objectForKey:@"notificationh_priorityid"] isEqual:@"1"]) {
                cell.priorityLabel.backgroundColor = [UIColor redColor];
            }
            else if ([[[filteredArray objectAtIndex:indexPath.row] objectForKey:@"notificationh_priorityid"] isEqual:@"2"]){
                cell.priorityLabel.backgroundColor = [UIColor redColor];
            }
            else if ([[[filteredArray objectAtIndex:indexPath.row] objectForKey:@"notificationh_priorityid"] isEqual:@"3"]){//Medium
                cell.priorityLabel.backgroundColor = [UIColor orangeColor];
            }
            else if ([[[filteredArray objectAtIndex:indexPath.row] objectForKey:@"notificationh_priorityid"] isEqual:@"4"]){//Low
                cell.priorityLabel.backgroundColor = [UIColor lightGrayColor];
            }
            else
            {
                cell.priorityLabel.backgroundColor = [UIColor whiteColor];
            }
            
            cell.attachmentImage.hidden = YES;
            
            cell.priorityLabel.text =[ NSString stringWithFormat:@"%@",[[filteredArray objectAtIndex:indexPath.row] objectForKey:@"notificationh_priority_name"]];
            
            if ([[[filteredArray objectAtIndex:indexPath.row] objectForKey:@"nh_docs"] isEqualToString:@"X"]) {
                cell.attachmentImage.hidden = NO;
            }
            cell.notificationNoLabel.text =[NSString stringWithFormat:@"%@",[[filteredArray objectAtIndex:indexPath.row] objectForKey:@"nh_objectID"]];
            cell.notificationTextLabel.text = [NSString stringWithFormat: @"%@",[[filteredArray objectAtIndex:indexPath.row] objectForKey:@"notificationh_shorttext"]];
            
            
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSDate *tempStartDate = [dateFormatter dateFromString:[[filteredArray objectAtIndex:indexPath.row] objectForKey:@"notificationh_startdate"]];
            // Convert date object into desired format
            [dateFormatter setDateFormat:@"MMM dd, yyyy"];
            
            NSString *convertedStartDateString = [dateFormatter stringFromDate:tempStartDate];
            if ([NullChecker isNull:convertedStartDateString]) {
                convertedStartDateString = @"";
            }
            
            cell.startDateLabel.text = [NSString stringWithFormat:@"%@",convertedStartDateString];
            cell.statusCodeLabel.text = [NSString stringWithFormat:@"%@",[[filteredArray objectAtIndex:indexPath.row] objectForKey:@"notificationh_status"]];
            
            if ([selectedCheckBoxArray containsObject:[NSNumber numberWithInteger:indexPath.row]])
            {
                [cell.statusButton setImage:[UIImage imageNamed:@"tick"]   forState:UIControlStateNormal];
            }
            else
            {
                [cell.statusButton setImage:nil  forState:UIControlStateNormal];
            }
            
            [cell.statusButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            
            if ([statusCode isEqualToString:@"NOPR"]) {
                
                [cell.statusButton setBackgroundColor:UIColorFromRGB(39, 171, 226)];
                [cell.statusButton setTitle:statusCode forState:UIControlStateNormal];
                
            }
            else if ([statusCode isEqualToString:@"Cancelled"]){
                
                cell.statusButton.backgroundColor=[UIColor redColor];
                [cell.statusButton setTitle:@"DLFL" forState:UIControlStateNormal];
                
            }
            else if ([statusCode isEqualToString:@"Completed"]){
                
                [cell.statusButton setTitle:@"NOCO" forState:UIControlStateNormal];
                cell.statusButton.backgroundColor=[UIColor greenColor];
            }
            else if ([statusCode isEqualToString:@"OSNO"]){
                
                [cell.statusButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
                cell.statusButton.backgroundColor=[UIColor yellowColor];
                [cell.statusButton setTitle:@"OSNO" forState:UIControlStateNormal];
                
            }
            else{
                [cell.statusButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
                [cell.statusButton setBackgroundColor:[UIColor yellowColor]];
                
            }
            
            [cell.systemStatusButton addTarget:self action:@selector(selectedSystemStatus:) forControlEvents:UIControlEventTouchDown];
            
            return cell;
        }
        
    }
    else if(tableView==filterSortTableView)
    {
        if (filterSortTableView.contentSize.height < filterSortTableView.frame.size.height) {
            filterSortTableView.scrollEnabled = NO;
        }
        else {
            filterSortTableView.scrollEnabled = YES;
        }
        
        static NSString *CellIdentifier = @"CustomCell";
        
        FilterSortTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell==nil) {
            cell=[[FilterSortTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        
        cell.headerlabelValue.hidden = NO;
        cell.dateTextfield.hidden = YES;
        cell.dateImageView.hidden = YES;
        cell.filterSortCheckBoxButton.hidden = NO;
        
        if ((filterSortTableView.tag==0 && indexPath.section==2 && (indexPath.row == 3 || indexPath.row == 4))|| (filterSortTableView.tag==0 && indexPath.section==6 && indexPath.row==0))
        {
            cell.headerlabelValue.hidden = YES;
            cell.dateTextfield.hidden = NO;
            cell.dateImageView.hidden = NO;
            cell.filterSortCheckBoxButton.hidden = YES;
            
            cell.dateTextfield.superview.tag = indexPath.row;
            cell.dateTextfield.delegate = self;
            
            cell.dateTextfield.placeholder = [[[[self.structuredFilterSortedArray firstObject]objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectAtIndex:0];
          
            cell.dateTextfield.text = @"";
            [cell.dateImageView setImage:[UIImage imageNamed:@"calendar"]];

            
            if (indexPath.row == 3) {
                
                [cell.dateTextfield setTag:10];
                
                if (startDate.length) {
                    cell.dateTextfield.text=startDate;
                }
            }
            else if (indexPath.row == 4){
                
                [cell.dateTextfield setTag:20];
                
                if (endDate.length) {
                    cell.dateTextfield.text=endDate;
                }
            }
            else if (indexPath.section == 6){
                
                [cell.dateTextfield setTag:30];
 
                [cell.dateImageView setImage:[UIImage imageNamed:@"dropdown"]];
                
                if (wrckcenterStringl.length) {
                    cell.dateTextfield.text=wrckcenterStringl;
                }
            }
         }
         else
        {
            if (filterSortTableView.tag==0) {
 
                    cell.filterSortCheckBoxButton.adjustsImageWhenHighlighted = YES;
                    
                    cell.headerlabelValue.text=[[[[self.structuredFilterSortedArray firstObject]objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectAtIndex:0];
                    
                    if ([[[[[self.structuredFilterSortedArray firstObject] objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectAtIndex:1] isEqualToString:@"X"])
                    {
                        [cell.filterSortCheckBoxButton setImage:[UIImage imageNamed:@"CheckBoxSelection"]   forState:UIControlStateNormal];
                        
                        cell.headerlabelValue.textColor= [UIColor colorWithRed:38.0/255.0 green:85.0/255.0 blue:157.0/255.0 alpha:5.0];
                    }
                    else
                    {
                        [cell.filterSortCheckBoxButton setImage:[UIImage imageNamed:@"checkBoxUnSelection"]   forState:UIControlStateNormal];
                        cell.headerlabelValue.textColor=[UIColor lightGrayColor];
                    }
              }
            else if (filterSortTableView.tag==1)
            {
                cell.filterSortCheckBoxButton.adjustsImageWhenHighlighted = YES;
                
                cell.headerlabelValue.text=[[[[self.structuredFilterSortedArray lastObject]objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectAtIndex:0];
                
                if ([[[[[self.structuredFilterSortedArray lastObject]objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectAtIndex:1] isEqualToString:@"X"])
                {
                    [cell.filterSortCheckBoxButton setImage:[UIImage imageNamed:@"CheckBoxSelection"]   forState:UIControlStateNormal];
                    
                    cell.headerlabelValue.textColor= [UIColor colorWithRed:38.0/255.0 green:85.0/255.0 blue:157.0/255.0 alpha:5.0];
                }
                else
                {
                    [cell.filterSortCheckBoxButton setImage:[UIImage imageNamed:@"checkBoxUnSelection"]   forState:UIControlStateNormal];
                    cell.headerlabelValue.textColor=[UIColor lightGrayColor];
                }
            }
        }
        
        return  cell;
    }

    else if (tableView==systemStatusTableView){

        if (systemStatusTableView.contentSize.height < systemStatusTableView.frame.size.height) {
            systemStatusTableView.scrollEnabled = NO;
        }
        else
            systemStatusTableView.scrollEnabled = YES;

        static NSString *CellIdentifier = @"Cell";

        OrderSystemStatusTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:CellIdentifier];

        if (cell==nil) {
            cell=[[OrderSystemStatusTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }

        if (indexPath.row % 2 == 0){
            cell.backgroundColor =UIColorFromRGB(249, 249, 249);
        }
        else{

            cell.backgroundColor =[UIColor whiteColor];
        }

        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        
        cell.systemStatusView.layer.cornerRadius = 2.0f;
        cell.systemStatusView.layer.masksToBounds = YES;
        cell.systemStatusView.layer.borderColor = [[UIColor darkGrayColor] CGColor];
        cell.systemStatusView.layer.borderWidth = 1.0f;

        static NSInteger checkboxTag = 123;
        NSInteger x,y;x = 8.0; y = 14.0;

        UIButton *checkBoxNRadioButtonSelectionForSystemStatusButton = (UIButton *) [cell.contentView viewWithTag:checkboxTag];

        if (!checkBoxNRadioButtonSelectionForSystemStatusButton)
        {
            checkBoxNRadioButtonSelectionForSystemStatusButton = [[UIButton alloc] initWithFrame:(CGRectMake(x,y,20,20))];
            checkBoxNRadioButtonSelectionForSystemStatusButton.tag = checkboxTag;
            [cell.contentView addSubview:checkBoxNRadioButtonSelectionForSystemStatusButton];
        }

        checkBoxNRadioButtonSelectionForSystemStatusButton.adjustsImageWhenHighlighted = YES;

        cell.txt04.text=[[notificationSystemStatusArray objectAtIndex:indexPath.row] objectForKey:@"notifications_txt04"];
        cell.Txt30.text=[[notificationSystemStatusArray objectAtIndex:indexPath.row] objectForKey:@"notifications_txt30"];

        if ([[[notificationSystemStatusArray objectAtIndex:indexPath.row] objectForKey:@"notifications_act"] isEqualToString:@"X"]) {

            [checkBoxNRadioButtonSelectionForSystemStatusButton  setImage:[UIImage imageNamed:@"checkBoxSelection.png"]   forState:UIControlStateNormal];
        }
        else{

            [checkBoxNRadioButtonSelectionForSystemStatusButton  setImage:[UIImage imageNamed:@"checkBoxUnselection.png"]   forState:UIControlStateNormal];
        }

        return cell;
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView==filterSortTableView)
    {
        if (filterSortTableView.tag==0)
        {
            if (indexPath.section == 2) {
                
                if ([[[[[self.structuredFilterSortedArray firstObject] objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectAtIndex:1] isEqualToString:@"X"])
                {
                    [[[[[self.structuredFilterSortedArray firstObject]objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectAtIndex:1] isEqualToString:@""];
                }
                else{
                    
                    if(indexPath.row == 0){
                        
                        [[[[self.structuredFilterSortedArray firstObject] objectAtIndex:indexPath.section] objectAtIndex:1] replaceObjectAtIndex:1 withObject:@""];
                        
                        [[[[self.structuredFilterSortedArray firstObject] objectAtIndex:indexPath.section] objectAtIndex:2] replaceObjectAtIndex:1 withObject:@""];
                        
                    }
                    else if (indexPath.row ==1){
                        
                        [[[[self.structuredFilterSortedArray firstObject] objectAtIndex:indexPath.section] objectAtIndex:0] replaceObjectAtIndex:1 withObject:@""];
                        
                        [[[[self.structuredFilterSortedArray firstObject] objectAtIndex:indexPath.section] objectAtIndex:2] replaceObjectAtIndex:1 withObject:@""];
                        
                    }
                    else if (indexPath.row ==2){
                        
                        [[[[self.structuredFilterSortedArray firstObject] objectAtIndex:indexPath.section] objectAtIndex:0] replaceObjectAtIndex:1 withObject:@""];
                        
                        [[[[self.structuredFilterSortedArray firstObject] objectAtIndex:indexPath.section] objectAtIndex:1] replaceObjectAtIndex:1 withObject:@""];
                        
                    }
                    
                    [[[[self.structuredFilterSortedArray firstObject] objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] replaceObjectAtIndex:1 withObject:@"X"];
                    
                }
            }
            else {
                
                if ([[[[[self.structuredFilterSortedArray firstObject] objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectAtIndex:1] isEqualToString:@"X"])
                {
                    
                    if (indexPath.row>0) {
                        
                        if ([[[[[self.structuredFilterSortedArray firstObject]objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectAtIndex:1] isEqualToString:@"X"])
                        {
                            [[[[self.structuredFilterSortedArray firstObject] objectAtIndex:indexPath.section] objectAtIndex:0] replaceObjectAtIndex:1 withObject:@""];
                            
                            [[[[self.structuredFilterSortedArray firstObject]objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] replaceObjectAtIndex:1 withObject:@""];
                        }
                        else
                        {
                            [[[[self.structuredFilterSortedArray firstObject]objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] replaceObjectAtIndex:1 withObject:@"X"];
                        }
                    }
                    else
                    {
                        
                        for (int i=0; i<[[[self.structuredFilterSortedArray firstObject] objectAtIndex:indexPath.section] count]; i++) {
                            
                            [[[[self.structuredFilterSortedArray firstObject]objectAtIndex:indexPath.section] objectAtIndex:i] replaceObjectAtIndex:1 withObject:@""];
                        }
                    }
                }
                else if ([[[[[self.structuredFilterSortedArray firstObject] objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectAtIndex:1] isEqualToString:@""])
                {
                    if (indexPath.row>0) {
                        
                        if ([[[[[self.structuredFilterSortedArray firstObject] objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectAtIndex:1] isEqualToString:@"X"])
                        {
                            [[[[[self.structuredFilterSortedArray firstObject] objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectAtIndex:1] replaceObjectAtIndex:indexPath.row withObject:@""];
                        }
                        else
                        {
                            [[[[self.structuredFilterSortedArray firstObject]objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] replaceObjectAtIndex:1 withObject:@"X"];
                        }
                    }
                    else
                    {
                        for (int i=0; i<[[[self.structuredFilterSortedArray firstObject] objectAtIndex:indexPath.section] count]; i++) {
                            
                            [[[[self.structuredFilterSortedArray firstObject]objectAtIndex:indexPath.section] objectAtIndex:i] replaceObjectAtIndex:1 withObject:@"X"];
                        }
                    }
                }
            }
        }
        else if (filterSortTableView.tag==1)
        {
            
            if ([[[[[self.structuredFilterSortedArray lastObject] objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectAtIndex:1] isEqualToString:@"X"]) {
                
                [[[[self.structuredFilterSortedArray lastObject] objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] replaceObjectAtIndex:1 withObject:@""];
            }
            else
            {
                if (indexPath.row == 1) {
                    [[[[self.structuredFilterSortedArray lastObject] objectAtIndex:indexPath.section] objectAtIndex:0] replaceObjectAtIndex:1 withObject:@""];
                    [[[[self.structuredFilterSortedArray lastObject] objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] replaceObjectAtIndex:1 withObject:@"X"];
                }
                else
                {
                    [[[[self.structuredFilterSortedArray lastObject] objectAtIndex:indexPath.section] objectAtIndex:1] replaceObjectAtIndex:1 withObject:@""];
                    
                    [[[[self.structuredFilterSortedArray lastObject] objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] replaceObjectAtIndex:1 withObject:@"X"];
                }
            }
        }
        
        [filterSortTableView reloadData];
    }
    
}


-(void)selectedSystemStatus:(id)sender{
    
    NSIndexPath *ip = [self GetCellFromTableView:myNotificationsTableView Sender:sender];
    
    [self systemStatus:[[self.notificationListArray objectAtIndex:ip.row] objectForKey:@"notificationh_id"]];
    
    
}

-(void)systemStatus:(NSString *)uuid{
    
    if (notificationSystemStatusArray == nil) {
        notificationSystemStatusArray = [NSMutableArray new];
    }
    else{
        
        [notificationSystemStatusArray removeAllObjects];
    }
    
    [notificationSystemStatusArray addObjectsFromArray:[[DataBase sharedInstance] fetchNotificationSystemStatusOnly:uuid]];
    
    [systemStatusView setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    
    [self.view addSubview:systemStatusView];
    [systemStatusTableView reloadData];
}

-(NSIndexPath *) GetCellFromTableView: (UITableView *)tableView Sender:(id)sender
{
    CGPoint position = [sender convertPoint:CGPointZero toView:tableView];
    NSIndexPath *indexPath = [tableView indexPathForRowAtPoint:position];
    return indexPath;//[tableView cellForRowAtIndexPath:indexPath];
}

-(void)startButtonSelected:(id)sender{
    
    if (![[self.structuredFilterSortedArray objectAtIndex:2] isEqualToString:@"X"]) {
        [self.structuredFilterSortedArray replaceObjectAtIndex:0 withObject:@""];
        [self.structuredFilterSortedArray replaceObjectAtIndex:1 withObject:@""];
        [self.structuredFilterSortedArray replaceObjectAtIndex:2 withObject:@"X"];
    }
    
    [filterSortTableView reloadData];
    
}

-(void)createdButtonSelected:(id)sender{
    
    if (![[self.structuredFilterSortedArray objectAtIndex:0] isEqualToString:@"X"]) {
        [self.structuredFilterSortedArray replaceObjectAtIndex:0 withObject:@"X"];
        [self.structuredFilterSortedArray replaceObjectAtIndex:1 withObject:@""];
        [self.structuredFilterSortedArray replaceObjectAtIndex:2 withObject:@""];
    }
    [filterSortTableView reloadData];
}

-(void)malfunctionButtonSelected:(id)sender{
    
    if (![[self.structuredFilterSortedArray objectAtIndex:1] isEqualToString:@"X"]) {
        [self.structuredFilterSortedArray replaceObjectAtIndex:0 withObject:@""];
        [self.structuredFilterSortedArray replaceObjectAtIndex:1 withObject:@"X"];
        [self.structuredFilterSortedArray replaceObjectAtIndex:2 withObject:@""];
    }
    
    [filterSortTableView reloadData];
    
}

-(void)filterSortCheckBoxSelected:(id)sender{
    
    NSIndexPath *ip = [self GetCellFromTableView:filterSortTableView Sender:sender];
    NSInteger i = ip.row;
    
    UIButton *tappedButton = (UIButton*)sender;
    
    if([tappedButton.currentImage isEqual:[UIImage imageNamed:@"radiounselection.png"]]) {
        [sender  setImage:[UIImage imageNamed: @"radioselection.png"] forState:UIControlStateNormal];
        [selectedFilterSortCheckBoxArray addObject:[NSNumber numberWithInteger:i]];
    }
    else{
        [selectedFilterSortCheckBoxArray removeObject:[NSNumber numberWithInteger:i]];
        
        [sender setImage:[UIImage imageNamed:@"radiounselection.png"]forState:UIControlStateNormal];
    }
}

-(void)detailCheckBoxSelected:(id)sender
{
    NSIndexPath *ip = [self GetCellFromTableView:myNotificationsTableView Sender:sender];
    NSInteger i = ip.row;
    
    CreateNotificationViewController *createVc = [self.storyboard instantiateViewControllerWithIdentifier:@"CreateNotifIdentifier"];
    
    NSMutableArray *tempArray=[NSMutableArray new];
    
    [tempArray addObject:[self.notificationListArray objectAtIndex:i]];
    
    if ([tempArray count])
    {
         createVc.detailNotificationArray=[tempArray copy];
 
    }
    
    [self showViewController:createVc sender:self];
    
//    NotificationObjects *selectedNotificationObject = [[NotificationObjects alloc]init];
//
//    if (myNotificationsTableView.tag==0) {
//
//        selectedNotificationObject.notificationUUID = [[self.notificationListArray objectAtIndex:i] objectForKey:@"notificationh_id"];
//
//        selectedNotificationObject.notificationTypeID = [[self.notificationListArray objectAtIndex:i] objectForKey:@"notificationh_type_id"];
//        selectedNotificationObject.notificationTypeText = [[self.notificationListArray objectAtIndex:i] objectForKey:@"notificationh_type_name"];
//        selectedNotificationObject.notificationShortText = [[self.notificationListArray objectAtIndex:i] objectForKey:@"notificationh_shorttext"];
//        selectedNotificationObject.notificationLongText = [[self.notificationListArray objectAtIndex:i] objectForKey:@"notificationh_shorttext"];
//        selectedNotificationObject.funcLocID = [[self.notificationListArray objectAtIndex:i] objectForKey:@"notificationh_funcloc_id"];
//        selectedNotificationObject.funcLocText= [[self.notificationListArray objectAtIndex:i] objectForKey:@"notificationh_funcloc_name"];
//        selectedNotificationObject.equipNoID = [[self.notificationListArray objectAtIndex:i] objectForKey:@"notificationh_equip_id"];
//        selectedNotificationObject.equipNoText = [[self.notificationListArray objectAtIndex:i] objectForKey:@"notificationh_equip_name"];
//        selectedNotificationObject.priorityID = [[self.notificationListArray objectAtIndex:i] objectForKey:@"notificationh_priorityid"];
//        selectedNotificationObject.priorityText = [[self.notificationListArray objectAtIndex:i] objectForKey:@"notificationh_priority_name"];
//
//        ////////
//        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//        NSDate *tempstartDate = [dateFormatter dateFromString:[[self.notificationListArray objectAtIndex:i] objectForKey:@"notificationh_startdate"]];
//        NSDate *tempendDate = [dateFormatter dateFromString:[[self.notificationListArray objectAtIndex:i] objectForKey:@"notificationh_enddate"]];
//
//        NSDate *tempreqstartDate = [dateFormatter dateFromString:[[self.notificationListArray objectAtIndex:i] objectForKey:@"notificationh_reqstartdate"]];
//        NSDate *tempreqendDate = [dateFormatter dateFromString:[[self.notificationListArray objectAtIndex:i] objectForKey:@"notificationh_reqenddate"]];
//
//        // Convert date object into desired format
//        [dateFormatter setDateFormat:@"MMM dd, yyyy hh:mm a"];
//        NSString *convertedStartDateString = [dateFormatter stringFromDate:tempstartDate];
//        if ([NullChecker isNull:convertedStartDateString]) {
//            convertedStartDateString = @"";
//        }
//        selectedNotificationObject.startMalFuncDate = [NSString stringWithFormat:@"%@",convertedStartDateString];
//        NSString *convertedEndDateStirng = [dateFormatter stringFromDate:tempendDate];
//        if ([NullChecker isNull:convertedEndDateStirng]) {
//            convertedEndDateStirng = @"";
//        }
//        selectedNotificationObject.endMalfuncDate = [NSString stringWithFormat:@"%@",convertedEndDateStirng];
//
//        NSString *convertedReqStartDateString = [dateFormatter stringFromDate:tempreqstartDate];
//        if ([NullChecker isNull:convertedReqStartDateString]) {
//            convertedReqStartDateString = @"";
//        }
//        selectedNotificationObject.reqStartDate = [NSString stringWithFormat:@"%@",convertedReqStartDateString];
//        NSString *convertedReqEndDateStirng = [dateFormatter stringFromDate:tempreqendDate];
//        if ([NullChecker isNull:convertedReqEndDateStirng]) {
//            convertedReqEndDateStirng = @"";
//        }
//        selectedNotificationObject.reqEndDate = [NSString stringWithFormat:@"%@",convertedReqEndDateStirng];
//
//        ///
//        selectedNotificationObject.breakDownCheck = [[self.notificationListArray objectAtIndex:i] objectForKey:@"notificationh_breakdown"];
//        selectedNotificationObject.notificationStatus = [[self.notificationListArray objectAtIndex:i] objectForKey:@"notificationh_status"];
//        selectedNotificationObject.notificationNumber = [[self.notificationListArray objectAtIndex:i] objectForKey:@"nh_objectID"];
//        selectedNotificationObject.notificationHeaderPlantID = [[self.notificationListArray objectAtIndex:i] objectForKey:@"notificationh_plantid"];
//        selectedNotificationObject.notificationHeaderWorkCenterID = [[self.notificationListArray objectAtIndex:i] objectForKey:@"notificationh_workcenterid"];
//
//        selectedNotificationObject.shiftType = [[self.notificationListArray objectAtIndex:i] objectForKey:@"notificationh_shift"];
//        selectedNotificationObject.noofperson = [[self.notificationListArray objectAtIndex:i] objectForKey:@"notificationh_noofperson"];
//        selectedNotificationObject.effectID = [[self.notificationListArray objectAtIndex:i] objectForKey:@"notificationh_effect_id"];
//        selectedNotificationObject.effectText = [[self.notificationListArray objectAtIndex:i] objectForKey:@"notificationh_effect_name"];
//        selectedNotificationObject.parnrID = [[self.notificationListArray objectAtIndex:i] objectForKey:@"notificationh_personresponsible_id"];
//        selectedNotificationObject.parnrText = [[self.notificationListArray objectAtIndex:i] objectForKey:@"notificationh_personresponsible_text"];
//        selectedNotificationObject.aufnr = [[self.notificationListArray objectAtIndex:i] objectForKey:@"notificationh_order_no"];
//        selectedNotificationObject.reportedBy = [[self.notificationListArray objectAtIndex:i] objectForKey:@"notificationh_reported_by_Input"];
//        selectedNotificationObject.plannerGroupID = [[self.notificationListArray objectAtIndex:i] objectForKey:@"notificationh_ingrp"];
//        selectedNotificationObject.plannerGroupName = [[self.notificationListArray objectAtIndex:i] objectForKey:@"notificationh_ingrp_name"];
//
//    }
//    else if (myNotificationsTableView.tag==1){
//
//        selectedNotificationObject.notificationUUID = [[filteredArray objectAtIndex:i] objectForKey:@"notificationh_id"];
//        selectedNotificationObject.notificationTypeID = [[filteredArray objectAtIndex:i] objectForKey:@"notificationh_type_id"];
//        selectedNotificationObject.notificationTypeText = [[filteredArray objectAtIndex:i] objectForKey:@"notificationh_type_name"];
//        selectedNotificationObject.notificationShortText = [[filteredArray objectAtIndex:i] objectForKey:@"notificationh_shorttext"];
//        selectedNotificationObject.notificationLongText = [[filteredArray objectAtIndex:i] objectForKey:@"notificationh_shorttext"];
//        selectedNotificationObject.funcLocID = [[filteredArray objectAtIndex:i] objectForKey:@"notificationh_funcloc_id"];
//        selectedNotificationObject.funcLocText= [[filteredArray objectAtIndex:i] objectForKey:@"notificationh_funcloc_name"];
//        selectedNotificationObject.equipNoID = [[filteredArray objectAtIndex:i] objectForKey:@"notificationh_equip_id"];
//        selectedNotificationObject.equipNoText = [[filteredArray objectAtIndex:i] objectForKey:@"notificationh_equip_name"];
//        selectedNotificationObject.priorityID = [[filteredArray objectAtIndex:i] objectForKey:@"notificationh_priorityid"];
//        selectedNotificationObject.priorityText = [[filteredArray objectAtIndex:i] objectForKey:@"notificationh_priority_name"];
//
//        ////////
//        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//        NSDate *tempstartDate = [dateFormatter dateFromString:[[filteredArray objectAtIndex:i] objectForKey:@"notificationh_startdate"]];
//        NSDate *tempendDate = [dateFormatter dateFromString:[[filteredArray objectAtIndex:i] objectForKey:@"notificationh_enddate"]];
//
//        NSDate *tempreqstartDate = [dateFormatter dateFromString:[[filteredArray objectAtIndex:i] objectForKey:@"notificationh_reqstartdate"]];
//        NSDate *tempreqendDate = [dateFormatter dateFromString:[[filteredArray objectAtIndex:i] objectForKey:@"notificationh_reqenddate"]];
//
//        // Convert date object into desired format
//        [dateFormatter setDateFormat:@"MMM dd, yyyy hh:mm a"];
//        NSString *convertedStartDateString = [dateFormatter stringFromDate:tempstartDate];
//        if ([NullChecker isNull:convertedStartDateString]) {
//            convertedStartDateString = @"";
//        }
//        selectedNotificationObject.startMalFuncDate = [NSString stringWithFormat:@"%@",convertedStartDateString];
//        NSString *convertedEndDateStirng = [dateFormatter stringFromDate:tempendDate];
//        if ([NullChecker isNull:convertedEndDateStirng]) {
//            convertedEndDateStirng = @"";
//        }
//        selectedNotificationObject.endMalfuncDate = [NSString stringWithFormat:@"%@",convertedEndDateStirng];
//
//        NSString *convertedReqStartDateString = [dateFormatter stringFromDate:tempreqstartDate];
//        if ([NullChecker isNull:convertedReqStartDateString]) {
//            convertedReqStartDateString = @"";
//        }
//        selectedNotificationObject.reqStartDate = [NSString stringWithFormat:@"%@",convertedReqStartDateString];
//        NSString *convertedReqEndDateStirng = [dateFormatter stringFromDate:tempreqendDate];
//        if ([NullChecker isNull:convertedReqEndDateStirng]) {
//            convertedReqEndDateStirng = @"";
//        }
//        selectedNotificationObject.reqEndDate = [NSString stringWithFormat:@"%@",convertedReqEndDateStirng];
//
//        ///
//        selectedNotificationObject.breakDownCheck = [[filteredArray objectAtIndex:i] objectForKey:@"notificationh_breakdown"];
//        selectedNotificationObject.notificationStatus = [[filteredArray objectAtIndex:i] objectForKey:@"notificationh_status"];
//        selectedNotificationObject.notificationNumber = [[filteredArray objectAtIndex:i] objectForKey:@"nh_objectID"];
//        selectedNotificationObject.notificationHeaderPlantID = [[filteredArray objectAtIndex:i] objectForKey:@"notificationh_plantid"];
//        selectedNotificationObject.notificationHeaderWorkCenterID = [[filteredArray objectAtIndex:i] objectForKey:@"notificationh_workcenterid"];
//
//        selectedNotificationObject.shiftType = [[filteredArray objectAtIndex:i] objectForKey:@"notificationh_shift"];
//        selectedNotificationObject.noofperson = [[filteredArray objectAtIndex:i] objectForKey:@"notificationh_noofperson"];
//        selectedNotificationObject.effectID = [[filteredArray objectAtIndex:i] objectForKey:@"notificationh_effect_id"];
//        selectedNotificationObject.effectText = [[filteredArray objectAtIndex:i] objectForKey:@"notificationh_effect_name"];
//        selectedNotificationObject.parnrID = [[filteredArray objectAtIndex:i] objectForKey:@"notificationh_personresponsible_id"];
//        selectedNotificationObject.parnrText = [[filteredArray objectAtIndex:i] objectForKey:@"notificationh_personresponsible_text"];
//        selectedNotificationObject.aufnr = [[filteredArray objectAtIndex:i] objectForKey:@"notificationh_order_no"];
//        selectedNotificationObject.reportedBy = [[filteredArray objectAtIndex:i] objectForKey:@"notificationh_reported_by_Input"];
//        selectedNotificationObject.plannerGroupID = [[filteredArray objectAtIndex:i] objectForKey:@"notificationh_ingrp"];
//        selectedNotificationObject.plannerGroupName = [[filteredArray objectAtIndex:i] objectForKey:@"notificationh_ingrp_name"];
//    }
//
//
//
////    createNotification.delegate = self;
////    [createNotification setAutomaticallyAdjustsScrollViewInsets:NO];
////    createNotification.view.frame = self.view.frame;
////    [createNotification addDetailsWithSelectedNotificationObject:selectedNotificationObject];
////
////    [self.view addSubview:createNotification.view];
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==myNotificationsTableView) {
        
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
        {
            return 110;
        }
        else if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
            
            return  110;
        }
    }
    else if (tableView == systemStatusTableView){
        
        return 70;
    }
    else
    {
        return 40;
        
    }
    
    return  0;
}

-(void)checkBoxClicked:(id)sender{
    
    NSIndexPath *ip = [self GetCellFromTableView:myNotificationsTableView Sender:sender];
    NSInteger i = ip.row;
    
    releaseIndex=ip.row;
    
     UIButton *tappedButton = (UIButton*)sender;
    
    if([tappedButton.currentImage isEqual:[UIImage imageNamed:@"Checked-Icon.png"]]) {
        
//        if ([[[self.notificationListArray objectAtIndex:i] objectForKey:@"notificationh_status"] isEqualToString:@"OSNO"]) {
//
//            releaseBtn.hidden=YES;
//            completeButton.hidden = NO;
//            cancelButton.hidden = NO;
//
//        }
//        else{
//            completeButton.hidden = YES;
//            cancelButton.hidden = YES;
//            releaseBtn.hidden=YES;
//
//        }
        
        completeButton.hidden = YES;
        releaseBtn.hidden=YES;
        
        [selectedCheckBoxArray removeObject:[NSNumber numberWithInteger:i]];
        
    }
    else
    {
        [selectedCheckBoxArray removeAllObjects];
        [selectedCheckBoxArray addObject:[NSNumber numberWithInteger:i]];
 
        if ([[[self.notificationListArray objectAtIndex:i] objectForKey:@"notificationh_status"] isEqualToString:@"OSNO"]) {
            
            releaseBtn.hidden=NO;
            completeButton.hidden = YES;
            cancelButton.hidden = NO;
        }
        else{
            completeButton.hidden = NO;
            cancelButton.hidden = NO;
            releaseBtn.hidden=YES;
         }
     }
    
    [myNotificationsTableView reloadData];
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    
    if (searchText.length) {
        
        myNotificationsTableView.tag = 1;
        
        NSPredicate *bPredicate = [NSPredicate predicateWithFormat:@"nh_objectID contains[c] %@ || notificationh_shorttext contains[c] %@ ||  notificationh_priority_name contains[c] %@  || notificationh_startdate contains[c] %@",searchText,searchText,searchText,searchText];
        
        filteredArray = [self.notificationListArray filteredArrayUsingPredicate:bPredicate];
        
        myNotificationsCountLabel.text = [NSString stringWithFormat:@"Notifications (%i)",(int)filteredArray.count];
    }
    else{
        
        myNotificationsTableView.tag = 0;
        
        myNotificationsCountLabel.text = [NSString stringWithFormat:@"Notifications (%i)",(int)self.notificationListArray.count];
    }

    
//    NSString *filterString = [NSString stringWithFormat:@"nh_objectID like '%@%%' or notificationh_shorttext like '%@%%' or notificationh_priority_name like '%@%%' or notificationh_startdate like '%@%%' or notificationh_status like '%@%%' or notificationh_equip_id like '%@%%'",searchText,searchText,searchText,searchText,searchText,searchText];
//    
//    [inputsDictionary removeObjectForKey:@"COLOUMN"];
//    [inputsDictionary setObject:filterString forKey:@"FILTER"];
//    
//    [self searchMyNotificationsFromSqlite:inputsDictionary];
    [myNotificationsTableView reloadData];
    
}

-(void)dismissScanView
{
    self.notificationSearchBar.text = [defaults objectForKey:@"scanned"];
    [self searchBar:self.notificationSearchBar textDidChange:self.notificationSearchBar.text];
  //  [self.navigationController popViewControllerAnimated:YES];
    
}

-(IBAction)scanBtnClicked:(id)sender{
 
    ScanBarcodeViewController *scanVc = [self.storyboard instantiateViewControllerWithIdentifier:@"scanVC"];
     scanVc.delegate=self;
     [self showViewController:scanVc sender:self];
    
}

-(IBAction)selectAllCheckBox:(id)sender{
    
    if (!checkBoxHeaderBtn.selected) {
        checkBoxHeaderBtn.selected = YES;
        [checkBoxHeaderBtn setImage:[UIImage imageNamed:@"checkbox_selected.png"] forState:UIControlStateNormal];
    }
    else{
        checkBoxHeaderBtn.selected = NO;
        [checkBoxHeaderBtn setImage:[UIImage imageNamed:@"checkbox_unselected.png"] forState:UIControlStateNormal];
    }
    
    [myNotificationsTableView reloadData];
}

#pragma mark-
#pragma mark- Response Delegate Method
 
- (void)resultData:(NSDictionary *)resultData withErrorDescription:(NSString *)errorDescription requestID:(WebServiceRequest)requestID :(int)statusCode
{
 
    switch (requestID) {
            
        case NOTIFICATION_CANCEL:
            
            if (!errorDescription.length) {
                
                if (statusCode == 401) {
                    
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
 
                    [self showAlertMessageWithTitle:@"Authentication Failed!!" message:@"kindly check your password" cancelButtonTitle:@"Ok" withactionType:@"Single" forMethod:nil];
                 }
                else{
                    
                    NSMutableDictionary *parseDictionary = [[Response sharedInstance] parseForCancelNotification:resultData];
                    
                    if ([parseDictionary objectForKey:@"Message"]){
                        
                        NSArray *arrayMessage = [parseDictionary objectForKey:@"Message"];
                        NSMutableString *messageContent = [[NSMutableString alloc]init];
 
                        [messageContent setString:@""];
                        
                        for (int i =0; i<[arrayMessage count]; i++) {
                            
                            if ([[[arrayMessage objectAtIndex:i] substringToIndex:1] isEqualToString:@"S"]) {
 
                                [[DataBase sharedInstance] updateSyncLogForCategory:@"Notification" action:@"Cancel" objectid:[parseDictionary objectForKey:@"OBJECTID"] UUID:[self.notificationHeaderDetails objectForKey:[parseDictionary objectForKey:@"OBJECTID"]]];
                                
                                 if ([[defaults objectForKey:@"ACTIVATELOGS"] isEqualToString:@"X"])
                                {
                                    
                                    [[DataBase sharedInstance] writToLogFile:[NSString stringWithFormat:@"#INFO#.com.enstrapp.fieldtekpro#Notif #Activity:Cancel Notification #Notifno:%@ #Mode:Online #Class:Very Important #MUser:%@ #DeviceId:%@",[parseDictionary objectForKey:@"OBJECTID"],decryptedUserName,[defaults objectForKey:@"edeviceid"]]];
                                    
                                }
                                
                                 [[DataBase sharedInstance] updateNotificationStatus:[self.notificationHeaderDetails objectForKey:[parseDictionary objectForKey:@"OBJECTID"]] :@"Cancelled"];
                                [messageContent appendString:[NSString stringWithFormat:@"%@\n",[[[parseDictionary objectForKey:@"Message"] objectAtIndex:i] substringFromIndex:1]]];
                            }
                            else  if ([[[arrayMessage objectAtIndex:i] substringToIndex:1] isEqualToString:@"E"]) {
 
                                [[DataBase sharedInstance] updateSyncLogErrorForCategory:@"Notification" action:@"Cancel" objectid:[parseDictionary objectForKey:@"OBJECTID"] UUID:[self.notificationHeaderDetails objectForKey:[parseDictionary objectForKey:@"OBJECTID"]] message:[[arrayMessage objectAtIndex:i] substringFromIndex:1]];
                                
                                [messageContent appendString:[NSString stringWithFormat:@"%@\n",[[[parseDictionary objectForKey:@"Message"] objectAtIndex:i] substringFromIndex:1]]];
                            }
                            else{
 
                                [[DataBase sharedInstance] updateSyncLogErrorForCategory:@"Notification" action:@"Cancel" objectid:[parseDictionary objectForKey:@"OBJECTID"] UUID:[self.notificationHeaderDetails objectForKey:[parseDictionary objectForKey:@"OBJECTID"]] message:[arrayMessage objectAtIndex:i]];
                                
                                [messageContent appendString:[NSString stringWithFormat:@"%@\n",[[parseDictionary objectForKey:@"Message"] objectAtIndex:i]]];
                            }
                            
                            [self.notificationHeaderDetails removeObjectForKey:[parseDictionary objectForKey:@"OBJECTID"]];
                        }
                        
                        [MBProgressHUD hideHUDForView:self.view animated:YES];

                         [self showAlertMessageWithTitle:@"FieldTekPro" message:messageContent cancelButtonTitle:@"Ok" withactionType:@"Single" forMethod:nil];
                        
                     }
                }
            }
            else{
                if (self.notificationHeaderDetails.count) {
                    NSArray *objectIds = [self.notificationHeaderDetails allKeys];
                    for (int i=0; i<[objectIds count]; i++) {
                        [[DataBase sharedInstance] updateSyncLogErrorForCategory:@"Notification" action:@"Cancel" objectid:[objectIds objectAtIndex:i] UUID:[self.notificationHeaderDetails objectForKey:[objectIds objectAtIndex:i]] message:errorDescription];
                    }
                    
                    [MBProgressHUD hideHUDForView:self.view animated:YES];

 
                    [self showAlertMessageWithTitle:@"FieldTekPro" message:errorDescription cancelButtonTitle:@"Ok" withactionType:@"Single" forMethod:nil];

                }
            }
            
            break;
            
        case NOTIFICATION_COMPLETE:
            
            if (!errorDescription.length) {
                
                if (statusCode == 401) {
                    
                    [MBProgressHUD hideHUDForView:self.view animated:YES];

                //    authenticationFailedAlert = [[UIAlertView alloc] initWithTitle:@"Authentication Failed!!" message:@"kindly check your password" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                    
                    [self showAlertMessageWithTitle:@"Authentication Failed!!" message:@"kindly check your password" cancelButtonTitle:@"Ok" withactionType:@"Single" forMethod:nil];

                    
                    [authenticationFailedAlert show];
                }
                else{
                    
                    NSMutableDictionary *parseDictionary = [[Response sharedInstance] parseForCompleteNotification:resultData];
 
                    NSMutableString *messageContent = [[NSMutableString alloc]init];
                    [messageContent setString:@""];
                    
                    NSArray *objectIDResult = [[parseDictionary objectForKey:@"MESSAGE"] componentsSeparatedByString:@" "];
                    
                        if ([[objectIDResult firstObject] isEqualToString:@"S"]) {
                            [[DataBase sharedInstance] updateSyncLogForCategory:@"Notification" action:@"Complete" objectid:[parseDictionary objectForKey:@"OBJECTID"] UUID:[self.notificationHeaderDetails objectForKey:[parseDictionary objectForKey:@"OBJECTID"]]];
                            
                            if ([[defaults objectForKey:@"ACTIVATELOGS"] isEqualToString:@"X"])
                            {
                                [[DataBase sharedInstance] writToLogFile:[NSString stringWithFormat:@"#INFO#.com.enstrapp.fieldtekpro#Notif #Activity:Complete Notification #Notifno:%@ #Mode:Online #Class:Very Important #MUser:%@ #DeviceId:%@",[parseDictionary objectForKey:@"OBJECTID"],decryptedUserName,[defaults objectForKey:@"edeviceid"]]];
                                
                            }
                            
                            [[DataBase sharedInstance] updateNotificationStatus:[self.notificationHeaderDetails objectForKey:[parseDictionary objectForKey:@"OBJECTID"]] :@"Completed"];
                            
                         }
                        else if ([[objectIDResult firstObject] isEqualToString:@"E"]) {
                            
                            [[DataBase sharedInstance] updateSyncLogErrorForCategory:@"Notification" action:@"Complete" objectid:[parseDictionary objectForKey:@"OBJECTID"] UUID:[self.notificationHeaderDetails objectForKey:[parseDictionary objectForKey:@"OBJECTID"]] message:[[parseDictionary objectForKey:@"MESSAGE"] substringFromIndex:1]];
                        }
                        else
                        {
                            [[DataBase sharedInstance] updateSyncLogErrorForCategory:@"Notification" action:@"Complete" objectid:[parseDictionary objectForKey:@"OBJECTID"] UUID:[self.notificationHeaderDetails objectForKey:[parseDictionary objectForKey:@"OBJECTID"]] message:[parseDictionary objectForKey:@"MESSAGE"]];
                        }
                        
                        [self.notificationHeaderDetails removeObjectForKey:[parseDictionary objectForKey:@"OBJECTID"]];
                        
                        [messageContent appendString:[NSString stringWithFormat:@"%@\n",[[parseDictionary objectForKey:@"MESSAGE"] substringFromIndex:1]]];
                    
                    
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
 
                    [self showAlertMessageWithTitle:@"FieldTekPro" message:messageContent cancelButtonTitle:@"Ok" withactionType:@"Single" forMethod:@"Complete"];
 
                }
            }
            else{
                if (self.notificationHeaderDetails.count) {
                    NSArray *objectIds = [self.notificationHeaderDetails allKeys];
                    for (int i=0; i<[objectIds count]; i++) {
                        [[DataBase sharedInstance] updateSyncLogErrorForCategory:@"Notification" action:@"Complete" objectid:[objectIds objectAtIndex:i] UUID:[self.notificationHeaderDetails objectForKey:[objectIds objectAtIndex:i]] message:errorDescription];
                    }
                    
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
 
                      [self showAlertMessageWithTitle:@"FieldTekPro" message:errorDescription cancelButtonTitle:@"Ok" withactionType:@"Single" forMethod:nil];
                    
                }
            }
            
            break;
            
        case GET_SYNC_MAP_DATA:
            
            if (!errorDescription.length) {
                
                [[Response sharedInstance] parseForSyncMapData:resultData];
                [self functionForSyncMapData];

                    
            }
            else{
                
                [MBProgressHUD hideHUDForView:self.view animated:YES];
 
                [self showAlertMessageWithTitle:@"FieldTekPro" message:errorDescription cancelButtonTitle:@"Ok" withactionType:@"Single" forMethod:nil];
                
            }
            
            break;
            
        case GET_LOAD_SETTINGS:
            
            if (!errorDescription.length) {
                
                    NSMutableDictionary *parsedDictionary = [[Response sharedInstance] parseForLoadSettings:resultData];
                    
                    if ([parsedDictionary objectForKey:@"resultRefresh"]) {
                        if ([[parsedDictionary objectForKey:@"resultRefresh"] isKindOfClass:[NSArray class]]) {
                            if ([[parsedDictionary objectForKey:@"resultRefresh"] objectAtIndex:0]) {
                                
                                if ([[[parsedDictionary objectForKey:@"resultRefresh"] objectAtIndex:0] objectForKey:@"Dnot"]) {
                                    if ([[[[parsedDictionary objectForKey:@"resultRefresh"] objectAtIndex:0] objectForKey:@"Dnot"] isEqualToString:@"X"]) {
                                        [self getDueNotifications];
                                    }
                                    else{
                                        [MBProgressHUD hideHUDForView:self.view animated:YES];
                                     
                                           [self showAlertMessageWithTitle:@"Info" message:@"No changes for you." cancelButtonTitle:@"Ok" withactionType:@"Single" forMethod:nil];
                                        
                                    }
                                }
                            }
                        }
                        else if ([[parsedDictionary objectForKey:@"resultRefresh"] isKindOfClass:[NSDictionary class]]){
                            
                            if ([[parsedDictionary objectForKey:@"resultRefresh"] objectForKey:@"Dnot"]) {
                                if ([[[parsedDictionary objectForKey:@"resultRefresh"] objectForKey:@"Dnot"] isEqualToString:@"X"]) {
                                    
                                     [self getDueNotifications];
                                    [MBProgressHUD hideHUDForView:self.view animated:YES];

                                }
                                else{
                                    [MBProgressHUD hideHUDForView:self.view animated:YES];

 
                                       [self showAlertMessageWithTitle:@"Info" message:@"No changes for you." cancelButtonTitle:@"Ok" withactionType:@"Single" forMethod:nil];
                                    
                                }
                            }
                        }
                    }
            }
            
            else{
                
                [MBProgressHUD hideHUDForView:self.view animated:YES];
 
                [self showAlertMessageWithTitle:@"FieldTekPro" message:errorDescription cancelButtonTitle:@"Ok" withactionType:@"Single" forMethod:nil];
                
            }
            
            break;
            
        case GET_LIST_OF_DUE_NOTIFICATIONS:
            
            if (!errorDescription.length) {
                
                if (statusCode == 401) {
                    
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
 
                    [self showAlertMessageWithTitle:@"Authentication Failed!!" message:@"kindly check your password" cancelButtonTitle:@"Ok" withactionType:@"Single" forMethod:nil];
                    
                }
                else{
                    
                    NSMutableDictionary *parsedDictionary = [[Response sharedInstance] parseForListOfDueNotification:resultData];
                    // if ([parsedDictionary count] == 0) {
                    [[DataBase sharedInstance] deleteinsertDataIntoHeader:@"N"];
                    //}
                    if ([parsedDictionary objectForKey:@"resultHeader"]) {
                        NSMutableDictionary *notificationDetailDictionary = [[NSMutableDictionary alloc] init];
                        
                        id responseObject = [parsedDictionary objectForKey:@"resultHeader"];
                        
                        NSMutableArray *notificatinHeaderArray = [[NSMutableArray alloc] init];
                        
                        NSMutableArray *inspectionResultDataArray = [NSMutableArray new];
                        
                        
                        [notificatinHeaderArray addObjectsFromArray:responseObject];
                        
                        NSDictionary *headerDictionary;
                        NSDateFormatter *dateFormate = [[NSDateFormatter alloc] init];
                        [dateFormate setDateFormat:@"yyyy-MM-dd"];
                        
                        for (int i=0; i<[notificatinHeaderArray count]; i++) {
                            if ([[notificatinHeaderArray objectAtIndex:i] isKindOfClass:[NSDictionary class]]) {
                                headerDictionary = [notificatinHeaderArray objectAtIndex:i];
                                NSMutableDictionary *currentHeaderDictionary = [[NSMutableDictionary alloc] init];
                                if ([headerDictionary objectForKey:@"BreakdownInd"]) {
                                    [currentHeaderDictionary setObject:[[headerDictionary objectForKey:@"BreakdownInd"] copy] forKey:@"BREAKDOWN"];
                                }
                                else
                                {
                                    [currentHeaderDictionary setObject:@" " forKey:@"BREAKDOWN"];
                                }
                                
                                if ([headerDictionary objectForKey:@"FunctionLoc"]) {
                                    
                                    [currentHeaderDictionary setObject:[[headerDictionary objectForKey:@"FunctionLoc"] copy] forKey:@"FID"];
                                }
                                else{
                                    [currentHeaderDictionary setObject:@"" forKey:@"FID"];
                                }
                                if ([headerDictionary objectForKey:@"Pltxt"]) {
                                    
                                    [currentHeaderDictionary setObject:[[headerDictionary objectForKey:@"Pltxt"] copy] forKey:@"FNAME"];
                                }
                                else{
                                    [currentHeaderDictionary setObject:@"" forKey:@"FNAME"];
                                }
                                
                                if ([headerDictionary objectForKey:@"NotifShorttxt"]) {
                                    [currentHeaderDictionary setObject:[[headerDictionary objectForKey:@"NotifShorttxt"] copy] forKey:@"SHORTTEXT"];
                                }
                                else{
                                    [currentHeaderDictionary setObject:@"" forKey:@"SHORTTEXT"];
                                }
                                if ([headerDictionary objectForKey:@"NotifType"]) {
                                    [currentHeaderDictionary setObject:[[headerDictionary objectForKey:@"NotifType"] copy] forKey:@"NID"];
                                }
                                else{
                                    [currentHeaderDictionary setObject:@"" forKey:@"NID"];
                                }
                                
                                if ([headerDictionary objectForKey:@"Qmartx"]) {
                                    [currentHeaderDictionary setObject:[[headerDictionary objectForKey:@"Qmartx"] copy] forKey:@"NNAME"];
                                }
                                else{
                                    [currentHeaderDictionary setObject:@"" forKey:@"NNAME"];
                                }
                                
                                if ([headerDictionary objectForKey:@"Qmnum"]) {
                                    [currentHeaderDictionary setObject:[[headerDictionary objectForKey:@"Qmnum"] copy] forKey:@"OBJECTID"];
                                }
                                else{
                                    [currentHeaderDictionary setObject:@"" forKey:@"OBJECTID"];
                                }
                                
                                if ([headerDictionary objectForKey:@"Qmdat"]) {
                                    [currentHeaderDictionary setObject:[[headerDictionary objectForKey:@"Qmdat"] copy] forKey:@"QMDAT"];
                                }
                                else{
                                    [currentHeaderDictionary setObject:@"" forKey:@"QMDAT"];
                                }
                                
                                [currentHeaderDictionary setObject:@"" forKey:@"REPORTEDBY"];
                                
                                if ([headerDictionary objectForKey:@"ReportedBy"]) {
                                    [currentHeaderDictionary setObject:[[headerDictionary objectForKey:@"ReportedBy"] copy] forKey:@"NREPORTEDBY"];
                                }
                                else{
                                    
                                    [currentHeaderDictionary setObject:@"" forKey:@"NREPORTEDBY"];
                                    
                                }
                                
                                if ([headerDictionary objectForKey:@"Equipment"]) {
                                    [currentHeaderDictionary setObject:[[headerDictionary objectForKey:@"Equipment"] copy] forKey:@"EQID"];
                                }
                                else{
                                    [currentHeaderDictionary setObject:@"" forKey:@"EQID"];
                                }
                                
                                if ([headerDictionary objectForKey:@"Eqktx"]) {
                                    [currentHeaderDictionary setObject:[[headerDictionary objectForKey:@"Eqktx"] copy] forKey:@"EQNAME"];
                                }
                                else{
                                    [currentHeaderDictionary setObject:@"" forKey:@"EQNAME"];
                                }
                                
                                if ([headerDictionary objectForKey:@"Priority"]) {
                                    [currentHeaderDictionary setObject:[[headerDictionary objectForKey:@"Priority"] copy] forKey:@"NPID"];
                                }
                                else{
                                    [currentHeaderDictionary setObject:@"" forKey:@"NPID"];
                                }
                                
                                if ([headerDictionary objectForKey:@"Priokx"]) {
                                    [currentHeaderDictionary setObject:[[headerDictionary objectForKey:@"Priokx"] copy] forKey:@"NPNAME"];
                                }
                                else{
                                    [currentHeaderDictionary setObject:@"" forKey:@"NPNAME"];
                                }
                                
                                if ([headerDictionary objectForKey:@"MalfuncEddate"]) {
                                    
                                    NSString *malfunctionEndDateString;
                                    
                                    if (![NullChecker isNull:[headerDictionary objectForKey:@"MalfuncEddate"]]) {
                                        
                                        if ([[headerDictionary objectForKey:@"MalfuncEddate"] rangeOfString:@"Date"].length) {
                                            
                                            malfunctionEndDateString=[NSString stringWithFormat:@"%@",[dateFormate stringFromDate:[NSDate dateWithTimeIntervalSince1970:[[[[headerDictionary objectForKey:@"MalfuncEddate"] stringByReplacingOccurrencesOfString:@"/Date(" withString:@""] stringByReplacingOccurrencesOfString:@")/" withString:@""] doubleValue]/1000.0]]];
                                            
                                        }
                                        else
                                        {
                                            malfunctionEndDateString=[NSString stringWithFormat:@"%@",[headerDictionary objectForKey:@"MalfuncEddate"]];
                                        }
                                    }
                                    
                                    
                                    
                                    if (malfunctionEndDateString.length) {
                                        
                                        if ([headerDictionary objectForKey:@"MalfuncEdtime"]) {
                                            
                                            [currentHeaderDictionary setObject:[NSString stringWithFormat:@"%@ %@",malfunctionEndDateString,[headerDictionary objectForKey:@"MalfuncEdtime"]] forKey:@"EDATE"];
                                        }
                                        else{
                                            
                                            [currentHeaderDictionary setObject:malfunctionEndDateString forKey:@"EDATE"];
                                        }
                                    }
                                    
                                }
                                else{
                                    [currentHeaderDictionary setObject:@"" forKey:@"EDATE"];
                                }
                                
                                if (![NullChecker isNull:[headerDictionary objectForKey:@"MalfuncStdate"]]) {
                                    
                                    NSString *malfunctionStartDateString;
                                    
                                    if ([[headerDictionary objectForKey:@"MalfuncStdate"] rangeOfString:@"Date"].length) {
                                        
                                        malfunctionStartDateString=[NSString stringWithFormat:@"%@",[dateFormate stringFromDate:[NSDate dateWithTimeIntervalSince1970:[[[[headerDictionary objectForKey:@"MalfuncStdate"] stringByReplacingOccurrencesOfString:@"/Date(" withString:@""] stringByReplacingOccurrencesOfString:@")/" withString:@""] doubleValue]/1000.0]]];
                                    }
                                    else{
                                        
                                        malfunctionStartDateString=[NSString stringWithFormat:@"%@",[headerDictionary objectForKey:@"MalfuncStdate"]];
                                        [currentHeaderDictionary setObject:[NSString stringWithFormat:@"%@",[headerDictionary objectForKey:@"MalfuncStdate"]] forKey:@"SDATE"];
                                    }
                                    
                                    if (malfunctionStartDateString.length) {
                                        
                                        if ([headerDictionary objectForKey:@"MalfuncSttime"]) {
                                            
                                            [currentHeaderDictionary setObject:[NSString stringWithFormat:@"%@ %@",malfunctionStartDateString,[headerDictionary objectForKey:@"MalfuncSttime"]] forKey:@"SDATE"];
                                        }
                                        else{
                                            
                                            [currentHeaderDictionary setObject:malfunctionStartDateString forKey:@"SDATE"];
                                        }
                                    }
                                    
                                }
                                else{
                                    [currentHeaderDictionary setObject:@"" forKey:@"SDATE"];
                                }
                                
                                if ([headerDictionary objectForKey:@"Werks"]) {
                                    [currentHeaderDictionary setObject:[headerDictionary objectForKey:@"Werks"] forKey:@"PLANTID"];
                                    [currentHeaderDictionary setObject:[headerDictionary objectForKey:@"Plantname"] forKey:@"PLANTNAME"];
                                }
                                else{
                                    [currentHeaderDictionary setObject:@"" forKey:@"PLANTID"];
                                    [currentHeaderDictionary setObject:@"" forKey:@"PLANTNAME"];
                                }
                                
                                if ([headerDictionary objectForKey:@"Arbpl"]) {
                                    [currentHeaderDictionary setObject:[headerDictionary objectForKey:@"Arbpl"] forKey:@"WORKCENTERID"];
                                    [currentHeaderDictionary setObject:[headerDictionary objectForKey:@"Wkctrname"] forKey:@"WORKCENTERNAME"];
                                }
                                else{
                                    [currentHeaderDictionary setObject:@"" forKey:@"WORKCENTERID"];
                                    [currentHeaderDictionary setObject:@"" forKey:@"WORKCENTERNAME"];
                                }
                                
                                if ([headerDictionary objectForKey:@"Xstatus"]) {
                                    [currentHeaderDictionary setObject:[headerDictionary objectForKey:@"Xstatus"] forKey:@"NSTATUS"];
                                }
                                else{
                                    
                                    [currentHeaderDictionary setObject:@"OSNO" forKey:@"NSTATUS"];
                                }
                                
                                [currentHeaderDictionary setObject:@"" forKey:@"DOCS"];
                                
                                if ([headerDictionary objectForKey:@"Docs"]) {
                                    [currentHeaderDictionary setObject:[headerDictionary objectForKey:@"Docs"] forKey:@"DOCS"];
                                }
                                
                                [currentHeaderDictionary setObject:@"" forKey:@"RSDATE"];
                                
                                if ([headerDictionary objectForKey:@"Strmn"]) {
                                    
                                    if ([headerDictionary objectForKey:@"Strur"]) {
                                        
                                        [currentHeaderDictionary setObject:[NSString stringWithFormat:@"%@ %@",[headerDictionary objectForKey:@"Strmn"],[headerDictionary objectForKey:@"Strur"]] forKey:@"RSDATE"];
                                    }
                                    else{
                                        
                                        [currentHeaderDictionary setObject:[headerDictionary objectForKey:@"Strmn"] forKey:@"RSDATE"];
                                    }
                                    
                                    
                                    //                                [currentHeaderDictionary setObject:[NSString stringWithFormat:@"%@ %@",[headerDictionary objectForKey:@"Strmn"],[headerDictionary objectForKey:@"Strur"]] forKey:@"RSDATE"];
                                }
                                
                                [currentHeaderDictionary setObject:@"" forKey:@"REDATE"];
                                
                                if ([headerDictionary objectForKey:@"Ltrmn"]) {
                                    
                                    if ([headerDictionary objectForKey:@"Ltrur"]) {
                                        
                                        [currentHeaderDictionary setObject:[NSString stringWithFormat:@"%@ %@",[headerDictionary objectForKey:@"Ltrmn"],[headerDictionary objectForKey:@"Ltrur"]] forKey:@"REDATE"];
                                    }
                                    else{
                                        
                                        [currentHeaderDictionary setObject:[headerDictionary objectForKey:@"Ltrmn"] forKey:@"REDATE"];
                                        
                                    }
                                    //                                [currentHeaderDictionary setObject:[NSString stringWithFormat:@"%@ %@",[headerDictionary objectForKey:@"Ltrmn"],[headerDictionary objectForKey:@"Ltrur"]] forKey:@"REDATE"];
                                }
                                
                                
                                if ([headerDictionary objectForKey:@"ParnrVw"]) {
                                    [currentHeaderDictionary setObject:[headerDictionary objectForKey:@"ParnrVw"] forKey:@"PARNRID"];
                                }
                                else{
                                    
                                    [currentHeaderDictionary setObject:@"" forKey:@"PARNRID"];
                                }
                                
                                if ([headerDictionary objectForKey:@"NameVw"]) {
                                    [currentHeaderDictionary setObject:[headerDictionary objectForKey:@"NameVw"] forKey:@"PARNRTEXT"];
                                }
                                else{
                                    
                                    [currentHeaderDictionary setObject:@"" forKey:@"PARNRTEXT"];
                                    
                                }
                                
                                if ([headerDictionary objectForKey:@"Ingrp"]) {
                                    [currentHeaderDictionary setObject:[headerDictionary objectForKey:@"Ingrp"] forKey:@"PLANNERGROUP"];
                                }
                                else{
                                    
                                    [currentHeaderDictionary setObject:@"" forKey:@"PLANNERGROUP"];
                                    
                                }
                                
                                if ([headerDictionary objectForKey:@"Ingrpname"]) {
                                    [currentHeaderDictionary setObject:[headerDictionary objectForKey:@"Ingrpname"] forKey:@"PLANNERGROUPNAME"];
                                }
                                else{
                                    
                                    [currentHeaderDictionary setObject:@"" forKey:@"PLANNERGROUPNAME"];
                                    
                                }
                                
                                [currentHeaderDictionary setObject:@"" forKey:@"SHIFT"];
                                if ([headerDictionary objectForKey:@"Shift"]) {
                                    [currentHeaderDictionary setObject:[headerDictionary objectForKey:@"Shift"] forKey:@"SHIFT"];
                                }
                                
                                [currentHeaderDictionary setObject:@"" forKey:@"NOOFPERSON"];
                                if ([headerDictionary objectForKey:@"Noofperson"]) {
                                    [currentHeaderDictionary setObject:[headerDictionary objectForKey:@"Noofperson"] forKey:@"NOOFPERSON"];
                                }
                                
                                [currentHeaderDictionary setObject:@"" forKey:@"EFFECTID"];
                                if ([headerDictionary objectForKey:@"Auswk"]) {
                                    [currentHeaderDictionary setObject:[headerDictionary objectForKey:@"Auswk"] forKey:@"EFFECTID"];
                                }
                                
                                [currentHeaderDictionary setObject:@"" forKey:@"EFFECTNAME"];
                                if ([headerDictionary objectForKey:@"Auswkt"]) {
                                    [currentHeaderDictionary setObject:[headerDictionary objectForKey:@"Auswkt"] forKey:@"EFFECTNAME"];
                                }
                                
                                [currentHeaderDictionary setObject:@"" forKey:@"AUFNR"];
                                if ([headerDictionary objectForKey:@"Aufnr"]) {
                                    [currentHeaderDictionary setObject:[headerDictionary objectForKey:@"Aufnr"] forKey:@"AUFNR"];
                                }
                                
                                [currentHeaderDictionary setObject:@"" forKey:@"LONGTEXT"];
                                [currentHeaderDictionary setObject:[[DataBase sharedInstance] fetchNameForIDKey:@"OBJECTID" forValue:[currentHeaderDictionary objectForKey:@"OBJECTID"]] forKey:@"ID"];
                                if (![[currentHeaderDictionary objectForKey:@"ID"] length]) {
                                    
                                }
                                
                                [currentHeaderDictionary setObject:@"" forKey:@"USR01"];
                                if ([headerDictionary objectForKey:@"Usr01"]) {
                                    [currentHeaderDictionary setObject:[headerDictionary objectForKey:@"Usr01"] forKey:@"USR01"];
                                }
                                
                                [currentHeaderDictionary setObject:@"" forKey:@"USR02"];
                                if ([headerDictionary objectForKey:@"Usr02"]) {
                                    [currentHeaderDictionary setObject:[headerDictionary objectForKey:@"Usr02"] forKey:@"USR02"];
                                }
                                
                                
                                [currentHeaderDictionary setObject:@"" forKey:@"NOSYNCLOG"];
                                [currentHeaderDictionary setObject:@"" forKey:@"LATITUDES"];
                                [currentHeaderDictionary setObject:@"" forKey:@"LONGITUDES"];
                                [currentHeaderDictionary setObject:@"" forKey:@"ALTITUDES"];
                                
                                if ([headerDictionary objectForKey:@"EquiHistory"]) {
                                    id equipmentHisory = [headerDictionary objectForKey:@"EquiHistory"];
                                    if ([equipmentHisory objectForKey:@"item"]) {
                                        equipmentHisory = [equipmentHisory objectForKey:@"item"];
                                        if ([equipmentHisory isKindOfClass:[NSDictionary class]]) {
                                            [currentHeaderDictionary setObject:[NSMutableArray arrayWithObject:equipmentHisory] forKey:@"EQUIPMENTHISTORY"];
                                        }
                                        else if ([equipmentHisory isKindOfClass:[NSArray class]]){
                                            [currentHeaderDictionary setObject:equipmentHisory forKey:@"EQUIPMENTHISTORY"];
                                        }
                                    }
                                }
                                
                                if ([headerDictionary objectForKey:@"Fields"]) {
                                    NSMutableArray *fieldsMutArray = [NSMutableArray new];
                                    NSMutableArray *tempfieldsMutArray = [NSMutableArray new];
                                    
                                    if ([[[headerDictionary objectForKey:@"Fields"] objectForKey:@"item"] isKindOfClass:[NSDictionary class]]) {
                                        [tempfieldsMutArray addObjectsFromArray:[NSMutableArray arrayWithObject:[[headerDictionary objectForKey:@"Fields"] objectForKey:@"item"]]];
                                    }
                                    else if ([[[headerDictionary objectForKey:@"Fields"] objectForKey:@"item"] isKindOfClass:[NSArray class]]) {
                                        [tempfieldsMutArray addObjectsFromArray:[[headerDictionary objectForKey:@"Fields"] objectForKey:@"item"]];
                                    }
                                    
                                    //                                NSArray *fieldsArray = [[headerDictionary objectForKey:@"Fields"] objectForKey:@"item"];
                                    for (int i =0; i<[tempfieldsMutArray count]; i++) {
                                        NSString *fieldValue,*fieldName,*fLabel,*tabName,*dataType,*sequence,*length;
                                        if ([NullChecker isNull:[[tempfieldsMutArray objectAtIndex:i] objectForKey:@"Fieldname"]]) {
                                            fieldName = @"";
                                        }
                                        else{
                                            fieldName = [[tempfieldsMutArray objectAtIndex:i] objectForKey:@"Fieldname"];
                                        }
                                        
                                        if ([NullChecker isNull:[[tempfieldsMutArray objectAtIndex:i] objectForKey:@"Flabel"]]) {
                                            fLabel = @"";
                                        }
                                        else{
                                            fLabel = [[tempfieldsMutArray objectAtIndex:i] objectForKey:@"Flabel"];
                                        }
                                        
                                        if ([NullChecker isNull:[[tempfieldsMutArray objectAtIndex:i] objectForKey:@"Tabname"]]) {
                                            tabName = @"";
                                        }
                                        else{
                                            tabName = [[tempfieldsMutArray objectAtIndex:i] objectForKey:@"Tabname"];
                                        }
                                        
                                        if ([NullChecker isNull:[[tempfieldsMutArray objectAtIndex:i] objectForKey:@"Value"]]) {
                                            fieldValue = @"";
                                        }
                                        else{
                                            fieldValue = [[tempfieldsMutArray objectAtIndex:i] objectForKey:@"Value"];
                                        }
                                        
                                        if ([NullChecker isNull:[[tempfieldsMutArray objectAtIndex:i] objectForKey:@"Datatype"]]) {
                                            dataType = @"";
                                        }
                                        else{
                                            dataType = [[tempfieldsMutArray objectAtIndex:i] objectForKey:@"Datatype"];
                                        }
                                        
                                        if ([NullChecker isNull:[[tempfieldsMutArray objectAtIndex:i] objectForKey:@"Sequence"]]) {
                                            sequence = @"";
                                        }
                                        else{
                                            sequence = [[tempfieldsMutArray objectAtIndex:i] objectForKey:@"Sequence"];
                                        }
                                        
                                        if ([NullChecker isNull:[[tempfieldsMutArray objectAtIndex:i] objectForKey:@"Length"]]) {
                                            length = @"";
                                        }
                                        else{
                                            length = [[tempfieldsMutArray objectAtIndex:i] objectForKey:@"Length"];
                                        }
                                        
                                        
                                        [fieldsMutArray addObject:[NSMutableArray arrayWithObjects:@"W",@"WH",tabName,fieldName,fieldValue,fLabel,dataType,sequence,length, nil]];
                                    }
                                    
                                    [currentHeaderDictionary setObject:fieldsMutArray forKey:@"CFH"];
                                }
                                
                                [notificationDetailDictionary setObject:[NSMutableArray arrayWithObjects:currentHeaderDictionary,[NSMutableArray array],[NSMutableArray array],[NSMutableArray array],[NSMutableArray array],[NSMutableArray array], nil] forKey:[currentHeaderDictionary objectForKey:@"OBJECTID"]];
                            }
                        }
                        
                        [notificatinHeaderArray removeAllObjects];
                        
                        //    resultInspection
                        // resultActivities
                        
                        responseObject = nil;
                        
                        responseObject = [parsedDictionary objectForKey:@"resultInspection"];
                        
                        
                        for (int i = 0; i<[responseObject  count]; i++) {
                            NSDictionary *inspectionresultDictionary;
                            
                            NSMutableArray *resultInpectionsDataArray = [NSMutableArray new];
                            
                            inspectionresultDictionary = [responseObject  objectAtIndex:i];
                            if ([NullChecker isNull:[inspectionresultDictionary objectForKey:@"Qmnum"]]) {
                                [resultInpectionsDataArray addObject:@""];
                            }
                            else{
                                [resultInpectionsDataArray addObject:[inspectionresultDictionary objectForKey:@"Qmnum"]];
                            }
                            
                            if ([NullChecker isNull:[inspectionresultDictionary objectForKey:@"Aufnr"]]) {
                                [resultInpectionsDataArray addObject:@""];
                            }
                            else{
                                
                                [resultInpectionsDataArray addObject:[inspectionresultDictionary objectForKey:@"Aufnr"]];
                            }
                            
                            if ([NullChecker isNull:[inspectionresultDictionary objectForKey:@"Vornr"]]) {
                                [resultInpectionsDataArray addObject:@""];
                            }
                            else{
                                [resultInpectionsDataArray addObject:[inspectionresultDictionary objectForKey:@"Vornr"]];
                            }
                            
                            if ([NullChecker isNull:[inspectionresultDictionary objectForKey:@"Equnr"]]) {
                                [resultInpectionsDataArray addObject:@""];
                            }
                            else{
                                [resultInpectionsDataArray addObject:[inspectionresultDictionary objectForKey:@"Equnr"]];
                            }
                            
                            if ([NullChecker isNull:[inspectionresultDictionary objectForKey:@"Mdocm"]]) {
                                [resultInpectionsDataArray addObject:@""];
                            }
                            else{
                                [resultInpectionsDataArray addObject:[inspectionresultDictionary objectForKey:@"Mdocm"]];
                            }
                            
                            if ([NullChecker isNull:[inspectionresultDictionary objectForKey:@"Point"]]) {
                                [resultInpectionsDataArray addObject:@""];
                            }
                            else{
                                [resultInpectionsDataArray addObject:[inspectionresultDictionary objectForKey:@"Point"]];
                            }
                            
                            if ([NullChecker isNull:[inspectionresultDictionary objectForKey:@"Mpobj"]]) {
                                [resultInpectionsDataArray addObject:@""];
                            }
                            else{
                                [resultInpectionsDataArray addObject:[inspectionresultDictionary objectForKey:@"Mpobj"]];
                            }
                            
                            if ([NullChecker isNull:[inspectionresultDictionary objectForKey:@"Mpobt"]]) {
                                [resultInpectionsDataArray addObject:@""];
                            }
                            else{
                                [resultInpectionsDataArray addObject:[inspectionresultDictionary objectForKey:@"Mpobt"]];
                            }
                            
                            if ([NullChecker isNull:[inspectionresultDictionary objectForKey:@"Psort"]]) {
                                [resultInpectionsDataArray addObject:@""];
                            }
                            else{
                                [resultInpectionsDataArray addObject:[inspectionresultDictionary objectForKey:@"Psort"]];
                            }
                            
                            if ([NullChecker isNull:[inspectionresultDictionary objectForKey:@"Pttxt"]]) {
                                [resultInpectionsDataArray addObject:@""];
                            }
                            else{
                                [resultInpectionsDataArray addObject:[inspectionresultDictionary objectForKey:@"Pttxt"]];
                            }
                            
                            if ([NullChecker isNull:[inspectionresultDictionary objectForKey:@"Atinn"]]) {
                                [resultInpectionsDataArray addObject:@""];
                            }
                            else{
                                [resultInpectionsDataArray addObject:[inspectionresultDictionary objectForKey:@"Atinn"]];
                            }
                            
                            if ([NullChecker isNull:[inspectionresultDictionary objectForKey:@"Idate"]]) {
                                [resultInpectionsDataArray addObject:@""];
                            }
                            else{
                                [resultInpectionsDataArray addObject:[inspectionresultDictionary objectForKey:@"Idate"]];
                            }
                            
                            if ([NullChecker isNull:[inspectionresultDictionary objectForKey:@"Itime"]]) {
                                [resultInpectionsDataArray addObject:@""];
                            }
                            else{
                                [resultInpectionsDataArray addObject:[inspectionresultDictionary objectForKey:@"Itime"]];
                            }
                            
                            if ([NullChecker isNull:[inspectionresultDictionary objectForKey:@"Mdtxt"]]) {
                                [resultInpectionsDataArray addObject:@""];
                            }
                            else{
                                [resultInpectionsDataArray addObject:[inspectionresultDictionary objectForKey:@"Mdtxt"]];
                            }
                            
                            if ([NullChecker isNull:[inspectionresultDictionary objectForKey:@"Readr"]]) {
                                [resultInpectionsDataArray addObject:@""];
                            }
                            else{
                                [resultInpectionsDataArray addObject:[inspectionresultDictionary objectForKey:@"Readr"]];
                            }
                            
                            
                            if ([NullChecker isNull:[inspectionresultDictionary objectForKey:@"Atbez"]]) {
                                [resultInpectionsDataArray addObject:@""];
                            }
                            else{
                                [resultInpectionsDataArray addObject:[inspectionresultDictionary objectForKey:@"Atbez"]];
                            }
                            
                            if ([NullChecker isNull:[inspectionresultDictionary objectForKey:@"Msehi"]]) {
                                [resultInpectionsDataArray addObject:@""];
                            }
                            else{
                                [resultInpectionsDataArray addObject:[inspectionresultDictionary objectForKey:@"Msehi"]];
                            }
                            
                            
                            if ([NullChecker isNull:[inspectionresultDictionary objectForKey:@"Msehl"]]) {
                                [resultInpectionsDataArray addObject:@""];
                            }
                            else{
                                [resultInpectionsDataArray addObject:[inspectionresultDictionary objectForKey:@"Msehl"]];
                            }
                            
                            
                            if ([NullChecker isNull:[inspectionresultDictionary objectForKey:@"Readc"]]) {
                                [resultInpectionsDataArray addObject:@""];
                            }
                            else{
                                [resultInpectionsDataArray addObject:[inspectionresultDictionary objectForKey:@"Readc"]];
                            }
                            
                            if ([NullChecker isNull:[inspectionresultDictionary objectForKey:@"Desic"]]) {
                                [resultInpectionsDataArray addObject:@""];
                            }
                            else{
                                [resultInpectionsDataArray addObject:[inspectionresultDictionary objectForKey:@"Desic"]];
                            }
                            
                            if ([NullChecker isNull:[inspectionresultDictionary objectForKey:@"Prest"]]) {
                                [resultInpectionsDataArray addObject:@""];
                            }
                            else{
                                [resultInpectionsDataArray addObject:[inspectionresultDictionary objectForKey:@"Prest"]];
                            }
                            
                            
                            if ([NullChecker isNull:[inspectionresultDictionary objectForKey:@"Docaf"]]) {
                                [resultInpectionsDataArray addObject:@""];
                            }
                            else{
                                [resultInpectionsDataArray addObject:[inspectionresultDictionary objectForKey:@"Docaf"]];
                            }
                            
                            if ([NullChecker isNull:[inspectionresultDictionary objectForKey:@"Codct"]]) {
                                [resultInpectionsDataArray addObject:@""];
                            }
                            else{
                                [resultInpectionsDataArray addObject:[inspectionresultDictionary objectForKey:@"Codct"]];
                            }
                            
                            if ([NullChecker isNull:[inspectionresultDictionary objectForKey:@"Codgr"]]) {
                                [resultInpectionsDataArray addObject:@""];
                            }
                            else{
                                [resultInpectionsDataArray addObject:[inspectionresultDictionary objectForKey:@"Codgr"]];
                            }
                            
                            if ([NullChecker isNull:[inspectionresultDictionary objectForKey:@"Vlcod"]]) {
                                [resultInpectionsDataArray addObject:@""];
                            }
                            else{
                                [resultInpectionsDataArray addObject:[inspectionresultDictionary objectForKey:@"Vlcod"]];
                            }
                            
                            if ([NullChecker isNull:[inspectionresultDictionary objectForKey:@"Action"]]) {
                                [resultInpectionsDataArray addObject:@""];
                            }
                            else{
                                [resultInpectionsDataArray addObject:[inspectionresultDictionary objectForKey:@"Action"]];
                            }
                            
                            [inspectionResultDataArray addObject:resultInpectionsDataArray];
                        }
                        
                        
                        responseObject = nil;
                        NSMutableArray *notificationDocs = [[NSMutableArray alloc] init];
                        
                        if ([parsedDictionary objectForKey:@"resultDocs"]) {
                            responseObject = [parsedDictionary objectForKey:@"resultDocs"];
                            [notificationDocs addObjectsFromArray:responseObject];
                            
                            NSDictionary *DocsDictionary;
                            for (int i =0; i<[notificationDocs count]; i++) {
                                if ([[notificationDocs objectAtIndex:i] isKindOfClass:[NSDictionary class]]) {
                                    DocsDictionary = [notificationDocs objectAtIndex:i];
                                    if ([notificationDetailDictionary objectForKey:[NSString stringWithFormat:@"%lld",[[DocsDictionary objectForKey:@"Zobjid"] longLongValue]]]) {
                                        NSMutableArray *Docs = [NSMutableArray array];
                                        [Docs addObject:@""];
                                        if ([DocsDictionary objectForKey:@"DocId"]) {
                                            [Docs addObject:[[DocsDictionary objectForKey:@"DocId"] copy]];
                                        }
                                        else{
                                            [Docs addObject:@""];
                                        }
                                        
                                        if ([DocsDictionary objectForKey:@"DocType"]) {
                                            [Docs addObject:[[DocsDictionary objectForKey:@"DocType"] copy]];
                                        }
                                        else{
                                            [Docs addObject:@""];
                                        }
                                        
                                        if ([DocsDictionary objectForKey:@"Filename"]) {
                                            [Docs addObject:[[DocsDictionary objectForKey:@"Filename"] copy]];
                                        }
                                        else{
                                            [Docs addObject:@""];
                                        }
                                        
                                        if ([DocsDictionary objectForKey:@"Filetype"]) {
                                            [Docs addObject:[[DocsDictionary objectForKey:@"Filetype"] copy]];
                                        }
                                        else{
                                            [Docs addObject:@""];
                                        }
                                        
                                        if ([DocsDictionary objectForKey:@"Fsize"]) {
                                            [Docs addObject:[[DocsDictionary objectForKey:@"Fsize"] copy]];
                                        }
                                        else{
                                            [Docs addObject:@""];
                                        }
                                        
                                        if ([DocsDictionary objectForKey:@"Objtype"]) {
                                            [Docs addObject:[[DocsDictionary objectForKey:@"Objtype"] copy]];
                                        }
                                        else{
                                            
                                            [Docs addObject:@""];
                                        }
                                        
                                        [Docs addObject:@""];//Content
                                        [Docs addObject:@""];//Action
                                        
                                        [[[notificationDetailDictionary objectForKey:[DocsDictionary objectForKey:@"Zobjid"]] objectAtIndex:1] addObject:Docs];
                                    }
                                }
                            }
                        }
                        
                        responseObject = nil;
                        NSMutableArray *notificationTransactionArray = [[NSMutableArray alloc] init];
                        
                        if ([parsedDictionary objectForKey:@"resultTransactions"]) {
                            responseObject = [parsedDictionary objectForKey:@"resultTransactions"];
                            
                            [notificationTransactionArray addObjectsFromArray:responseObject];
                            
                            NSDictionary *transactionDictionary;
                            
                            for (int i=0; i<[notificationTransactionArray count]; i++) {
                                if ([[notificationTransactionArray objectAtIndex:i] isKindOfClass:[NSDictionary class]]) {
                                    transactionDictionary = [notificationTransactionArray objectAtIndex:i];
                                    if ([notificationDetailDictionary objectForKey:[transactionDictionary objectForKey:@"Qmnum"]]) {
                                        NSMutableArray *transactions = [NSMutableArray array];
                                        
                                        [transactions addObject:@""];
                                        [transactions addObject:@""];
                                        if ([transactionDictionary objectForKey:@"ItemdefectGrp"]) {
                                            [transactions addObject:[[transactionDictionary objectForKey:@"ItemdefectGrp"] copy]];
                                        }
                                        else{
                                            [transactions addObject:@""];
                                        }
                                        
                                        if ([transactionDictionary objectForKey:@"Defectgrptext"]) {
                                            [transactions addObject:[[transactionDictionary objectForKey:@"Defectgrptext"] copy]];
                                        }
                                        else{
                                            [transactions addObject:@""];
                                        }
                                        
                                        if ([transactionDictionary objectForKey:@"ItemdefectCod"]) {
                                            [transactions addObject:[[transactionDictionary objectForKey:@"ItemdefectCod"] copy]];
                                        }
                                        else{
                                            [transactions addObject:@""];
                                        }
                                        
                                        if ([transactionDictionary objectForKey:@"Defectcodetext"]) {
                                            [transactions addObject:[[transactionDictionary objectForKey:@"Defectcodetext"] copy]];
                                        }
                                        else{
                                            [transactions addObject:@""];
                                            
                                        }
                                        
                                        if ([transactionDictionary objectForKey:@"CauseGrp"]) {
                                            [transactions addObject:[[transactionDictionary objectForKey:@"CauseGrp"] copy]];
                                        }
                                        else{
                                            [transactions addObject:@""];
                                        }
                                        
                                        if ([transactionDictionary objectForKey:@"Causegrptext"]) {
                                            [transactions addObject:[[transactionDictionary objectForKey:@"Causegrptext"] copy]];
                                        }
                                        else{
                                            [transactions addObject:@""];
                                        }
                                        
                                        if ([transactionDictionary objectForKey:@"CauseCod"]) {
                                            [transactions addObject:[[transactionDictionary objectForKey:@"CauseCod"] copy]];
                                        }
                                        else{
                                            [transactions addObject:@""];
                                        }
                                        
                                        if ([transactionDictionary objectForKey:@"Causecodetext"]) {
                                            [transactions addObject:[[transactionDictionary objectForKey:@"Causecodetext"] copy]];
                                        }
                                        else{
                                            [transactions addObject:@""];
                                        }
                                        
                                        if ([transactionDictionary objectForKey:@"ItemdefectShtxt"]) {
                                            [transactions addObject:[[transactionDictionary objectForKey:@"ItemdefectShtxt"] copy]];
                                        }
                                        else{
                                            [transactions addObject:@""];
                                        }
                                        if ([transactionDictionary objectForKey:@"CauseShtxt"]) {
                                            [transactions addObject:[[transactionDictionary objectForKey:@"CauseShtxt"] copy]];
                                        }
                                        else{
                                            [transactions addObject:@""];
                                        }
                                        
                                        if ([transactionDictionary objectForKey:@"ItemKey"]) {
                                            [transactions addObject:[[transactionDictionary objectForKey:@"ItemKey"] copy]];
                                        }
                                        else{
                                            [transactions addObject:@""];
                                        }
                                        
                                        if ([transactionDictionary objectForKey:@"CauseKey"]) {
                                            [transactions addObject:[[transactionDictionary objectForKey:@"CauseKey"] copy]];
                                        }
                                        else{
                                            [transactions addObject:@""];
                                        }
                                        
                                        [transactions addObject:@""];//Component Status
                                        [transactions addObject:@""];//Item Status
                                        
                                        if ([transactionDictionary objectForKey:@"ItempartGrp"]) {
                                            [transactions addObject:[transactionDictionary objectForKey:@"ItempartGrp"]];
                                        }
                                        else{
                                            
                                            [transactions addObject:@""];//objectPartGroupid
                                        }
                                        
                                        if ([transactionDictionary objectForKey:@"ItempartCod"]) {
                                            [transactions addObject:[transactionDictionary objectForKey:@"ItempartCod"]];
                                        }
                                        else{
                                            
                                            [transactions addObject:@""];//ObjectPartid
                                        }
                                        
                                        if ([transactionDictionary objectForKey:@"Partgrptext"]) {
                                            [transactions addObject:[transactionDictionary objectForKey:@"Partgrptext"]];
                                        }
                                        else{
                                            
                                            [transactions addObject:@""];//objectPartGrouptext
                                        }
                                        
                                        if ([transactionDictionary objectForKey:@"Partcodetext"])
                                        {
                                            [transactions addObject:[transactionDictionary objectForKey:@"Partcodetext"]];
                                        }
                                        else{
                                            
                                            [transactions addObject:@""];//ObjectParttext
                                        }
                                        
                                        id customFieldsDamageTransactionsID,customFieldsCauseTransactionsID;
                                        if ([transactionDictionary objectForKey:@"Fields"]) {
                                            NSArray *fieldsArray = [[transactionDictionary objectForKey:@"Fields"] objectForKey:@"item"];
                                            NSMutableArray *transactionsDamageCustomFields = [NSMutableArray array];
                                            NSMutableArray *transactionsCauseCustomFields = [NSMutableArray array];
                                            for (int i =0; i<[fieldsArray count]; i++) {
                                                NSString *fieldValue,*fieldName,*fLabel,*tabName,*docType,*docTypeItem,*dataType,*sequence,*length;
                                                if ([NullChecker isNull:[[fieldsArray objectAtIndex:i] objectForKey:@"Fieldname"]]) {
                                                    fieldName = @"";
                                                }
                                                else{
                                                    fieldName = [[fieldsArray objectAtIndex:i] objectForKey:@"Fieldname"];
                                                }
                                                
                                                if ([NullChecker isNull:[[fieldsArray objectAtIndex:i] objectForKey:@"Flabel"]]) {
                                                    fLabel = @"";
                                                }
                                                else{
                                                    fLabel = [[fieldsArray objectAtIndex:i] objectForKey:@"Flabel"];
                                                }
                                                
                                                if ([NullChecker isNull:[[fieldsArray objectAtIndex:i] objectForKey:@"Tabname"]]) {
                                                    tabName = @"";
                                                }
                                                else{
                                                    tabName = [[fieldsArray objectAtIndex:i] objectForKey:@"Tabname"];
                                                }
                                                
                                                if ([NullChecker isNull:[[fieldsArray objectAtIndex:i] objectForKey:@"Value"]]) {
                                                    fieldValue = @"";
                                                }
                                                else{
                                                    fieldValue = [[fieldsArray objectAtIndex:i] objectForKey:@"Value"];
                                                }
                                                
                                                if ([NullChecker isNull:[[fieldsArray objectAtIndex:i] objectForKey:@"Zdoctype"]]) {
                                                    docType = @"";
                                                }
                                                else{
                                                    docType = [[fieldsArray objectAtIndex:i] objectForKey:@"Zdoctype"];
                                                }
                                                
                                                if ([NullChecker isNull:[[fieldsArray objectAtIndex:i] objectForKey:@"ZdoctypeItem"]]) {
                                                    docTypeItem = @"";
                                                }
                                                else{
                                                    docTypeItem = [[fieldsArray objectAtIndex:i] objectForKey:@"ZdoctypeItem"];
                                                }
                                                
                                                
                                                if ([NullChecker isNull:[[fieldsArray objectAtIndex:i] objectForKey:@"Datatype"]]) {
                                                    dataType = @"";
                                                }
                                                else{
                                                    dataType = [[fieldsArray objectAtIndex:i] objectForKey:@"Datatype"];
                                                }
                                                
                                                if ([NullChecker isNull:[[fieldsArray objectAtIndex:i] objectForKey:@"Sequence"]]) {
                                                    sequence = @"";
                                                }
                                                else{
                                                    sequence = [[fieldsArray objectAtIndex:i] objectForKey:@"Sequence"];
                                                }
                                                
                                                if ([NullChecker isNull:[[fieldsArray objectAtIndex:i] objectForKey:@"Length"]]) {
                                                    length = @"";
                                                }
                                                else{
                                                    length = [[fieldsArray objectAtIndex:i] objectForKey:@"Length"];
                                                }
                                                
                                                if ([docTypeItem isEqualToString:@"QI"]) {
                                                    [transactionsDamageCustomFields addObject:[NSMutableArray arrayWithObjects:docType,docTypeItem,tabName,fieldName,fieldValue,fLabel,dataType,sequence,length, nil]];
                                                }
                                                else if ([docTypeItem isEqualToString:@"QC"]){
                                                    [transactionsCauseCustomFields addObject:[NSMutableArray arrayWithObjects:docType,docTypeItem,tabName,fieldName,fieldValue,fLabel,dataType,sequence,length, nil]];
                                                }
                                            }
                                            
                                            customFieldsDamageTransactionsID = transactionsDamageCustomFields;
                                            customFieldsCauseTransactionsID = transactionsCauseCustomFields;
                                        }
                                        
                                        [[[notificationDetailDictionary objectForKey:[transactionDictionary objectForKey:@"Qmnum"]] objectAtIndex:2] addObject:[NSArray arrayWithObjects:transactions,customFieldsDamageTransactionsID,customFieldsCauseTransactionsID, nil]];
                                    }
                                }
                            }
                            
                            [notificationTransactionArray removeAllObjects];
                        }
                        
                        
                        responseObject = nil;
                        NSMutableArray *notificationActivitiesArray = [[NSMutableArray alloc] init];
                        
                        if ([parsedDictionary objectForKey:@"resultActivities"]) {
                            responseObject = [parsedDictionary objectForKey:@"resultActivities"];
                            
                            [notificationActivitiesArray addObjectsFromArray:responseObject];
                            
                            NSDictionary *activitiesDictionary;
                            
                            for (int i=0; i<[notificationActivitiesArray count]; i++) {
                                
                                if ([[notificationActivitiesArray objectAtIndex:i] isKindOfClass:[NSDictionary class]]) {
                                    
                                    activitiesDictionary = [notificationActivitiesArray objectAtIndex:i];
                                    
                                    if ([notificationDetailDictionary objectForKey:[NSString stringWithFormat:@"%lli",[[activitiesDictionary objectForKey:@"Qmnum"] longLongValue]]]) {
                                        
                                         NSMutableDictionary *resulActivityDictionary=[NSMutableDictionary new];
                                        
                                        [resulActivityDictionary setObject:@"" forKey:@"notificationa_id"];
                                        
                                        [resulActivityDictionary setObject:@"" forKey:@"notificationa_header_id"];
                                        
                                        
                                        if ([activitiesDictionary objectForKey:@"Actcodetext"]) {
                                            
                                            [resulActivityDictionary setObject:[[activitiesDictionary objectForKey:@"Actcodetext"] copy] forKey:@"notificationa_Actcodetext"];
                                            
                                        }
                                        else{
                                            
                                            [resulActivityDictionary setObject:@"" forKey:@"notificationa_Actgrptext"];
                                            
                                        }
                                        
                                        if ([activitiesDictionary objectForKey:@"Actgrptext"]) {
                                            
                                            [resulActivityDictionary setObject:[[activitiesDictionary objectForKey:@"Actgrptext"] copy] forKey:@"notificationa_Actgrptext"];
                                            
                                        }
                                        else{
                                            
                                            [resulActivityDictionary setObject:@"" forKey:@"notificationa_Actgrptext"];
                                            
                                        }
                                        
                                        if ([activitiesDictionary objectForKey:@"Action"]) {
                                            
                                            [resulActivityDictionary setObject:[activitiesDictionary objectForKey:@"Action"] forKey:@"notificationa_Action"];
                                            
                                        }
                                        else{
                                            
                                            [resulActivityDictionary setObject:@"" forKey:@"notificationa_Action"];
                                            
                                        }
                                        
                                        if ([activitiesDictionary objectForKey:@"ActvCod"]) {
                                            
                                            [resulActivityDictionary setObject:[activitiesDictionary objectForKey:@"ActvCod"] forKey:@"notificationa_ActvCod"];
                                            
                                            
                                        }
                                        else{
                                            
                                            [resulActivityDictionary setObject:@"" forKey:@"notificationa_ActvCod"];
                                            
                                        }
                                        
                                        if ([activitiesDictionary objectForKey:@"ActvGrp"]) {
                                            
                                            [resulActivityDictionary setObject:[[activitiesDictionary objectForKey:@"ActvGrp"] copy] forKey:@"notificationa_ActvGrp"];
                                            
                                        }
                                        else{
                                            
                                            [resulActivityDictionary setObject:@"" forKey:@"notificationa_ActvGrp"];
                                        }
                                        
                                        if ([activitiesDictionary objectForKey:@"ActvKey"]) {
                                            
                                            [resulActivityDictionary setObject:[[activitiesDictionary objectForKey:@"ActvKey"] copy] forKey:@"notificationa_ActvKey"];
                                            
                                        }
                                        else{
                                            
                                            [resulActivityDictionary setObject:@"" forKey:@"notificationa_ActvKey"];
                                            
                                        }
                                        
                                        if ([activitiesDictionary objectForKey:@"ActvShtxt"]) {
                                            
                                            [resulActivityDictionary setObject:[[activitiesDictionary objectForKey:@"ActvShtxt"] copy] forKey:@"notificationa_ActvShtxt"];
                                            
                                        }
                                        else{
                                            
                                            [resulActivityDictionary setObject:@"" forKey:@"notificationa_ActvShtxt"];
                                        }
                                        
                                        if ([activitiesDictionary objectForKey:@"CauseKey"]) {
                                            [resulActivityDictionary setObject:[[activitiesDictionary objectForKey:@"CauseKey"] copy] forKey:@"notificationa_CauseKey"];
                                        }
                                        else{
                                            [resulActivityDictionary setObject:@"" forKey:@"notificationa_CauseKey"];
                                        }
                                        
                                        if ([activitiesDictionary objectForKey:@"Defectcodetext"]) {
                                            
                                            [resulActivityDictionary setObject:[[activitiesDictionary objectForKey:@"Defectcodetext"] copy] forKey:@"notificationa_Defectcodetext"];
                                            
                                        }
                                        else{
                                            [resulActivityDictionary setObject:@"" forKey:@"notificationa_Defectcodetext"];
                                        }
                                        
                                        if ([activitiesDictionary objectForKey:@"Defectgrptext"]) {
                                            
                                            [resulActivityDictionary setObject:[[activitiesDictionary objectForKey:@"Defectgrptext"] copy] forKey:@"notificationa_Defectgrptext"];
                                        }
                                        else{
                                            
                                            [resulActivityDictionary setObject:@"" forKey:@"notificationa_Defectgrptext"];
                                            
                                        }
                                        
                                        if ([activitiesDictionary objectForKey:@"ItemKey"]) {
                                            
                                            [resulActivityDictionary setObject:[[activitiesDictionary objectForKey:@"ItemKey"] copy] forKey:@"notificationa_ItemKey"];
                                            
                                        }
                                        else{
                                            
                                            [resulActivityDictionary setObject:[[activitiesDictionary objectForKey:@"ItemKey"] copy] forKey:@"notificationa_ItemdefectCod"];
                                            
                                        }
                                        
                                        if ([activitiesDictionary objectForKey:@"ItemdefectCod"]) {
                                            
                                            [resulActivityDictionary setObject:[[activitiesDictionary objectForKey:@"ItemdefectCod"] copy] forKey:@"notificationa_ItemdefectCod"];
                                        }
                                        else{
                                            [resulActivityDictionary setObject:@"" forKey:@"notificationa_ItemdefectCod"];
                                        }
                                        
                                        
                                        if ([activitiesDictionary objectForKey:@"ItemdefectGrp"]) {
                                            [resulActivityDictionary setObject:[[activitiesDictionary objectForKey:@"ItemdefectGrp"] copy] forKey:@"notificationa_ItemdefectGrp"];
                                        }
                                        else{
                                            
                                            [resulActivityDictionary setObject:@"" forKey:@"notificationa_ItemdefectGrp"];
                                            
                                        }
                                        
                                        if ([activitiesDictionary objectForKey:@"ItemdefectShtxt"]) {
                                            
                                            [resulActivityDictionary setObject:[[activitiesDictionary objectForKey:@"ItemdefectShtxt"] copy] forKey:@"notificationa_ItemdefectShtxt"];
                                            
                                        }
                                        else{
                                            
                                            [resulActivityDictionary setObject:@"" forKey:@"notificationa_ItemdefectShtxt"];
                                            
                                        }
                                        
                                        if ([activitiesDictionary objectForKey:@"ItempartCod"]) {
                                            
                                            [resulActivityDictionary setObject:[[activitiesDictionary objectForKey:@"ItempartCod"] copy] forKey:@"notificationa_ItempartCod"];
                                            
                                        }
                                        else{
                                            
                                            [resulActivityDictionary setObject:@"" forKey:@"notificationa_ItempartCod"];
                                            
                                        }
                                        
                                        if ([activitiesDictionary objectForKey:@"ItempartGrp"])
                                        {
                                            
                                            [resulActivityDictionary setObject:[[activitiesDictionary objectForKey:@"ItempartGrp"] copy] forKey:@"notificationa_ItempartGrp"];
                                            
                                        }
                                        else{
                                            
                                            [resulActivityDictionary setObject:@"" forKey:@"notificationa_ItempartGrp"];
                                            
                                        }
                                        
                                        if ([activitiesDictionary objectForKey:@"Partcodetext"])
                                        {
                                            [resulActivityDictionary setObject:[[activitiesDictionary objectForKey:@"Partcodetext"] copy] forKey:@"notificationa_Partcodetext"];
                                            
                                        }
                                        else{
                                            
                                            [resulActivityDictionary setObject:@"" forKey:@"notificationa_Partcodetext"];
                                            
                                        }
                                        
                                        if ([activitiesDictionary objectForKey:@"Partgrptext"])
                                        {
                                            
                                            [resulActivityDictionary setObject:[[activitiesDictionary objectForKey:@"Partgrptext"] copy] forKey:@"notificationa_Partgrptext"];
                                            
                                        }
                                        else{
                                            
                                            [resulActivityDictionary setObject:@"" forKey:@"notificationa_Partgrptext"];
                                            
                                        }
                                        
                                        if ([activitiesDictionary objectForKey:@"Qmnum"])
                                        {
                                            [resulActivityDictionary setObject:[[activitiesDictionary objectForKey:@"Qmnum"] copy] forKey:@"Qmnum"];
                                            
                                        }
                                        else{
                                            
                                            [resulActivityDictionary setObject:@"" forKey:@"Qmnum"];
                                            
                                        }
                                        
                                        if ([activitiesDictionary objectForKey:@"Usr01"])
                                        {
                                            [resulActivityDictionary setObject:[[activitiesDictionary objectForKey:@"Usr01"] copy] forKey:@"Qmnum"];
                                        }
                                        else{
                                            
                                            [resulActivityDictionary setObject:@"" forKey:@"Usr01"];
                                            
                                        }
                                        
                                        if ([activitiesDictionary objectForKey:@"Usr02"])
                                        {
                                            
                                            [resulActivityDictionary setObject:[[activitiesDictionary objectForKey:@"Usr02"] copy] forKey:@"Usr02"];
                                            
                                        }
                                        else{
                                            
                                            [resulActivityDictionary setObject:@"" forKey:@"Usr02"];
                                            
                                        }
                                        
                                        if ([activitiesDictionary objectForKey:@"Usr03"])
                                        {
                                            
                                            [resulActivityDictionary setObject:[[activitiesDictionary objectForKey:@"Usr03"] copy] forKey:@"Usr03"];
                                            
                                        }
                                        else{
                                            
                                            [resulActivityDictionary setObject:@"" forKey:@"Usr03"];
                                            
                                        }
                                        
                                        if ([activitiesDictionary objectForKey:@"Usr04"])
                                        {
                                            
                                            [resulActivityDictionary setObject:[[activitiesDictionary objectForKey:@"Usr04"] copy] forKey:@"Usr04"];
                                            
                                        }
                                        else{
                                            
                                            [resulActivityDictionary setObject:@"" forKey:@"Usr04"];
                                            
                                        }
                                        
                                        if ([activitiesDictionary objectForKey:@"Usr05"])
                                        {
                                            [resulActivityDictionary setObject:[[activitiesDictionary objectForKey:@"Usr05"] copy] forKey:@"Usr05"];
                                        }
                                        else{
                                            
                                            [resulActivityDictionary setObject:@"" forKey:@"Usr05"];
                                            
                                        }
                                        
                                        id customFieldsDamageTransactionsID,customFieldsCauseTransactionsID;
                                        
                                        if ([activitiesDictionary objectForKey:@"Fields"]) {
                                            NSArray *fieldsArray = [[activitiesDictionary objectForKey:@"Fields"] objectForKey:@"item"];
                                            NSMutableArray *transactionsDamageCustomFields = [NSMutableArray array];
                                            NSMutableArray *transactionsCauseCustomFields = [NSMutableArray array];
                                            for (int i =0; i<[fieldsArray count]; i++) {
                                                NSString *fieldValue,*fieldName,*fLabel,*tabName,*docType,*docTypeItem,*dataType,*sequence,*length;
                                                if ([NullChecker isNull:[[fieldsArray objectAtIndex:i] objectForKey:@"Fieldname"]]) {
                                                    fieldName = @"";
                                                }
                                                else{
                                                    fieldName = [[fieldsArray objectAtIndex:i] objectForKey:@"Fieldname"];
                                                }
                                                
                                                if ([NullChecker isNull:[[fieldsArray objectAtIndex:i] objectForKey:@"Flabel"]]) {
                                                    fLabel = @"";
                                                }
                                                else{
                                                    fLabel = [[fieldsArray objectAtIndex:i] objectForKey:@"Flabel"];
                                                }
                                                
                                                if ([NullChecker isNull:[[fieldsArray objectAtIndex:i] objectForKey:@"Tabname"]]) {
                                                    tabName = @"";
                                                }
                                                else{
                                                    tabName = [[fieldsArray objectAtIndex:i] objectForKey:@"Tabname"];
                                                }
                                                
                                                if ([NullChecker isNull:[[fieldsArray objectAtIndex:i] objectForKey:@"Value"]]) {
                                                    fieldValue = @"";
                                                }
                                                else{
                                                    fieldValue = [[fieldsArray objectAtIndex:i] objectForKey:@"Value"];
                                                }
                                                
                                                if ([NullChecker isNull:[[fieldsArray objectAtIndex:i] objectForKey:@"Zdoctype"]]) {
                                                    docType = @"";
                                                }
                                                else{
                                                    docType = [[fieldsArray objectAtIndex:i] objectForKey:@"Zdoctype"];
                                                }
                                                
                                                if ([NullChecker isNull:[[fieldsArray objectAtIndex:i] objectForKey:@"ZdoctypeItem"]]) {
                                                    docTypeItem = @"";
                                                }
                                                else{
                                                    docTypeItem = [[fieldsArray objectAtIndex:i] objectForKey:@"ZdoctypeItem"];
                                                }
                                                
                                                
                                                if ([NullChecker isNull:[[fieldsArray objectAtIndex:i] objectForKey:@"Datatype"]]) {
                                                    dataType = @"";
                                                }
                                                else{
                                                    dataType = [[fieldsArray objectAtIndex:i] objectForKey:@"Datatype"];
                                                }
                                                
                                                if ([NullChecker isNull:[[fieldsArray objectAtIndex:i] objectForKey:@"Sequence"]]) {
                                                    sequence = @"";
                                                }
                                                else{
                                                    sequence = [[fieldsArray objectAtIndex:i] objectForKey:@"Sequence"];
                                                }
                                                
                                                if ([NullChecker isNull:[[fieldsArray objectAtIndex:i] objectForKey:@"Length"]]) {
                                                    length = @"";
                                                }
                                                else{
                                                    length = [[fieldsArray objectAtIndex:i] objectForKey:@"Length"];
                                                }
                                                
                                                if ([docTypeItem isEqualToString:@"QI"]) {
                                                    [transactionsDamageCustomFields addObject:[NSMutableArray arrayWithObjects:docType,docTypeItem,tabName,fieldName,fieldValue,fLabel,dataType,sequence,length, nil]];
                                                }
                                                else if ([docTypeItem isEqualToString:@"QC"]){
                                                    [transactionsCauseCustomFields addObject:[NSMutableArray arrayWithObjects:docType,docTypeItem,tabName,fieldName,fieldValue,fLabel,dataType,sequence,length, nil]];
                                                }
                                            }
                                            
                                            customFieldsDamageTransactionsID = transactionsDamageCustomFields;
                                            customFieldsCauseTransactionsID = transactionsCauseCustomFields;
                                        }
                                        
                                        [[[notificationDetailDictionary objectForKey:[NSString stringWithFormat:@"%lli",[[activitiesDictionary objectForKey:@"Qmnum"] longLongValue]]] objectAtIndex:3] addObject:[NSArray arrayWithObjects:resulActivityDictionary,[NSMutableArray array],[NSMutableArray array], nil]];
                                    }
                                }
                            }
                            
                            [notificationActivitiesArray removeAllObjects];
                        }
                        
                        responseObject = nil;
                        NSMutableArray *notificationTasksArray = [[NSMutableArray alloc] init];
                        
                        if ([parsedDictionary objectForKey:@"resultTasks"]) {
                            
                            responseObject = [parsedDictionary objectForKey:@"resultTasks"];
                            
                            [notificationTasksArray addObjectsFromArray:responseObject];
                            
                            NSDictionary *tasksDictionary;
                            
                            for (int i=0; i<[notificationTasksArray count]; i++) {
                                
                                if ([[notificationTasksArray objectAtIndex:i] isKindOfClass:[NSDictionary class]]) {
                                    tasksDictionary = [notificationTasksArray objectAtIndex:i];
                                    if ([notificationDetailDictionary objectForKey:[NSString stringWithFormat:@"%lli",[[tasksDictionary objectForKey:@"Qmnum"] longLongValue]]]) {
                                        
                                        NSMutableArray *tasks = [NSMutableArray array];
                                        
                                        [tasks addObject:@""];
                                        [tasks addObject:@""];
                                        
                                        if ([tasksDictionary objectForKey:@"TaskKey"]) {
                                            [tasks addObject:[[tasksDictionary objectForKey:@"TaskKey"] copy]];
                                        }
                                        else{
                                            [tasks addObject:@""];
                                        }
                                        
                                        if ([tasksDictionary objectForKey:@"TaskGrp"]) {
                                            [tasks addObject:[[tasksDictionary objectForKey:@"TaskGrp"] copy]];
                                        }
                                        else{
                                            [tasks addObject:@""];
                                        }
                                        
                                        if ([tasksDictionary objectForKey:@"Taskgrptext"]) {
                                            [tasks addObject:[[tasksDictionary objectForKey:@"Taskgrptext"] copy]];
                                        }
                                        else{
                                            [tasks addObject:@""];
                                        }
                                        
                                        if ([tasksDictionary objectForKey:@"TaskCod"]) {
                                            [tasks addObject:[tasksDictionary objectForKey:@"TaskCod"]];
                                        }
                                        else{
                                            
                                            [tasks addObject:@""];
                                        }
                                        
                                        if ([tasksDictionary objectForKey:@"Taskcodetext"]) {
                                            [tasks addObject:[tasksDictionary objectForKey:@"Taskcodetext"]];
                                        }
                                        else{
                                            
                                            [tasks addObject:@""];
                                        }
                                        
                                        if ([tasksDictionary objectForKey:@"TaskShtxt"]) {
                                            [tasks addObject:[tasksDictionary objectForKey:@"TaskShtxt"]];
                                        }
                                        else{
                                            
                                            [tasks addObject:@""];
                                        }
                                        
                                        if ([tasksDictionary objectForKey:@"Parvw"])
                                        {
                                            [tasks addObject:[tasksDictionary objectForKey:@"Parvw"]];
                                        }
                                        else{
                                            
                                            [tasks addObject:@""];
                                        }
                                        
                                        [tasks addObject:@""];//processername
                                        
                                        if ([tasksDictionary objectForKey:@"Parnr"])
                                        {
                                            [tasks addObject:[tasksDictionary objectForKey:@"Parnr"]];
                                        }
                                        else{
                                            
                                            [tasks addObject:@""];
                                        }
                                        
                                        if ([tasksDictionary objectForKey:@"Pster"])
                                        {
                                            [tasks addObject:[tasksDictionary objectForKey:@"Pster"]];
                                        }
                                        else{
                                            
                                            [tasks addObject:@""];
                                        }
                                        
                                        if ([tasksDictionary objectForKey:@"Peter"])
                                        {
                                            [tasks addObject:[tasksDictionary objectForKey:@"Peter"]];
                                        }
                                        else{
                                            
                                            [tasks addObject:@""];
                                        }
                                        
                                        if ([tasksDictionary objectForKey:@"Release"]) {
                                            [tasks addObject:[tasksDictionary objectForKey:@"Release"]];
                                        }
                                        else{
                                            
                                            [tasks addObject:@""];
                                        }
                                        
                                        if ([tasksDictionary objectForKey:@"Complete"]) {
                                            [tasks addObject:[tasksDictionary objectForKey:@"Complete"]];
                                        }
                                        else{
                                            
                                            [tasks addObject:@""];
                                        }
                                        
                                        if ([tasksDictionary objectForKey:@"Success"]) {
                                            [tasks addObject:[tasksDictionary objectForKey:@"Success"]];
                                        }
                                        else{
                                            
                                            [tasks addObject:@""];
                                        }
                                        
                                        if ([tasksDictionary objectForKey:@"ItemKey"]) {
                                            [tasks addObject:[tasksDictionary objectForKey:@"ItemKey"]];
                                        }
                                        else{
                                            
                                            [tasks addObject:@""];
                                        }
                                        
                                        
                                        [tasks addObject:@""];//item status
                                        
                                        ////////////////
                                        
                                        if ([tasksDictionary objectForKey:@"ItempartGrp"]) {
                                            [tasks addObject:[[tasksDictionary objectForKey:@"ItempartGrp"] copy]];
                                        }
                                        else{
                                            [tasks addObject:@""];
                                        }
                                        
                                        if ([tasksDictionary objectForKey:@"Partgrptext"]) {
                                            [tasks addObject:[[tasksDictionary objectForKey:@"Partgrptext"] copy]];
                                        }
                                        else{
                                            [tasks addObject:@""];
                                        }
                                        
                                        if ([tasksDictionary objectForKey:@"ItempartCod"]) {
                                            [tasks addObject:[[tasksDictionary objectForKey:@"ItempartCod"] copy]];
                                        }
                                        else{
                                            [tasks addObject:@""];
                                        }
                                        
                                        if ([tasksDictionary objectForKey:@"Partcodetext"]) {
                                            [tasks addObject:[[tasksDictionary objectForKey:@"Partcodetext"] copy]];
                                        }
                                        else{
                                            [tasks addObject:@""];
                                            
                                        }
                                        
                                        if ([tasksDictionary objectForKey:@"ItemdefectGrp"]) {
                                            [tasks addObject:[[tasksDictionary objectForKey:@"ItemdefectGrp"] copy]];
                                        }
                                        else{
                                            [tasks addObject:@""];
                                        }
                                        
                                        if ([tasksDictionary objectForKey:@"Defectgrptext"]) {
                                            [tasks addObject:[[tasksDictionary objectForKey:@"Defectgrptext"] copy]];
                                        }
                                        else{
                                            [tasks addObject:@""];
                                        }
                                        
                                        if ([tasksDictionary objectForKey:@"ItemdefectCod"]) {
                                            [tasks addObject:[[tasksDictionary objectForKey:@"ItemdefectCod"] copy]];
                                        }
                                        else{
                                            [tasks addObject:@""];
                                        }
                                        
                                        if ([tasksDictionary objectForKey:@"Defectcodetext"]) {
                                            [tasks addObject:[[tasksDictionary objectForKey:@"Defectcodetext"] copy]];
                                        }
                                        else{
                                            [tasks addObject:@""];
                                        }
                                        
                                        if ([tasksDictionary objectForKey:@"ItemdefectShtxt"]) {
                                            [tasks addObject:[[tasksDictionary objectForKey:@"ItemdefectShtxt"] copy]];
                                        }
                                        else{
                                            [tasks addObject:@""];
                                        }
                                        
                                        if ([tasksDictionary objectForKey:@"UserStatus"]) {
                                            [tasks addObject:[tasksDictionary objectForKey:@"UserStatus"]];
                                        }
                                        else{
                                            
                                            [tasks addObject:@""];
                                        }
                                        
                                        if ([tasksDictionary objectForKey:@"SysStatus"]) {
                                            [tasks addObject:[tasksDictionary objectForKey:@"SysStatus"]];
                                        }
                                        else{
                                            
                                            [tasks addObject:@""];
                                        }
                                        
                                        if ([tasksDictionary objectForKey:@"Smsttxt"]) {
                                            [tasks addObject:[tasksDictionary objectForKey:@"Smsttxt"]];
                                        }
                                        else{
                                            
                                            [tasks addObject:@""];
                                        }
                                        
                                        if ([tasksDictionary objectForKey:@"Smastxt"]) {
                                            [tasks addObject:[tasksDictionary objectForKey:@"Smastxt"]];
                                        }
                                        else{
                                            
                                            [tasks addObject:@""];
                                        }
                                        
                                        if ([tasksDictionary objectForKey:@"Usr01"]) {
                                            [tasks addObject:[tasksDictionary objectForKey:@"Usr01"]];
                                        }
                                        else{
                                            
                                            [tasks addObject:@""];
                                        }
                                        
                                        if ([tasksDictionary objectForKey:@"Usr02"]) {
                                            [tasks addObject:[tasksDictionary objectForKey:@"Usr02"]];
                                        }
                                        else{
                                            
                                            [tasks addObject:@""];
                                        }
                                        
                                        if ([tasksDictionary objectForKey:@"Usr03"]) {
                                            [tasks addObject:[tasksDictionary objectForKey:@"Usr03"]];
                                        }
                                        else{
                                            
                                            [tasks addObject:@""];
                                        }
                                        
                                        if ([tasksDictionary objectForKey:@"Usr04"]) {
                                            [tasks addObject:[tasksDictionary objectForKey:@"Usr04"]];
                                        }
                                        else{
                                            
                                            [tasks addObject:@""];
                                        }
                                        
                                        if ([tasksDictionary objectForKey:@"Usr05"]) {
                                            [tasks addObject:[tasksDictionary objectForKey:@"Usr05"]];
                                        }
                                        else{
                                            
                                            [tasks addObject:@""];
                                        }
                                        
                                        if ([tasksDictionary objectForKey:@"Pstur"]) {
                                            [tasks addObject:[[tasksDictionary objectForKey:@"Pstur"] copy]];
                                        }
                                        else{
                                            [tasks addObject:@""];
                                        }
                                        
                                        if ([tasksDictionary objectForKey:@"Petur"]) {
                                            [tasks addObject:[[tasksDictionary objectForKey:@"Petur"] copy]];
                                        }
                                        else{
                                            [tasks addObject:@""];
                                        }
                                        
                                        if ([tasksDictionary objectForKey:@"Erldat"]) {
                                            [tasks addObject:[[tasksDictionary objectForKey:@"Erldat"] copy]];
                                        }
                                        else{
                                            [tasks addObject:@""];
                                        }
                                        
                                        if ([tasksDictionary objectForKey:@"Erlzeit"]) {
                                            [tasks addObject:[[tasksDictionary objectForKey:@"Erlzeit"] copy]];
                                        }
                                        else{
                                            [tasks addObject:@""];
                                        }
                                        
                                        if ([tasksDictionary objectForKey:@"Erlnam"]) {
                                            [tasks addObject:[[tasksDictionary objectForKey:@"Erlnam"] copy]];
                                        }
                                        else{
                                            [tasks addObject:@""];
                                        }
                                        
                                        
                                        id customFieldsTaskTransactionsID;
                                        if ([tasksDictionary objectForKey:@"Fields"]) {
                                            
                                            NSMutableArray *fieldsArray=[NSMutableArray new];
                                            if ([[[tasksDictionary objectForKey:@"Fields"] objectForKey:@"item"] isKindOfClass:[NSDictionary class]]) {
                                                
                                                [fieldsArray addObjectsFromArray:[NSMutableArray arrayWithObject:[[tasksDictionary objectForKey:@"Fields"] objectForKey:@"item"]]];
                                            }
                                            else if ([[[tasksDictionary objectForKey:@"Fields"] objectForKey:@"item"] isKindOfClass:[NSArray class]]){
                                                
                                                [fieldsArray addObjectsFromArray:[[tasksDictionary objectForKey:@"Fields"] objectForKey:@"item"]];
                                            }
                                            
                                            NSMutableArray *taskCodeCustomFields = [NSMutableArray array];
                                            
                                            for (int i =0; i<[fieldsArray count]; i++) {
                                                NSString *fieldValue,*fieldName,*fLabel,*tabName,*docType,*docTypeItem,*dataType,*sequence,*length;
                                                if ([NullChecker isNull:[[fieldsArray objectAtIndex:i] objectForKey:@"Fieldname"]]) {
                                                    fieldName = @"";
                                                }
                                                else{
                                                    fieldName = [[fieldsArray objectAtIndex:i] objectForKey:@"Fieldname"];
                                                }
                                                
                                                if ([NullChecker isNull:[[fieldsArray objectAtIndex:i] objectForKey:@"Flabel"]]) {
                                                    fLabel = @"";
                                                }
                                                else{
                                                    fLabel = [[fieldsArray objectAtIndex:i] objectForKey:@"Flabel"];
                                                }
                                                
                                                if ([NullChecker isNull:[[fieldsArray objectAtIndex:i] objectForKey:@"Tabname"]]) {
                                                    tabName = @"";
                                                }
                                                else{
                                                    tabName = [[fieldsArray objectAtIndex:i] objectForKey:@"Tabname"];
                                                }
                                                
                                                if ([NullChecker isNull:[[fieldsArray objectAtIndex:i] objectForKey:@"Value"]]) {
                                                    fieldValue = @"";
                                                }
                                                else{
                                                    fieldValue = [[fieldsArray objectAtIndex:i] objectForKey:@"Value"];
                                                }
                                                
                                                if ([NullChecker isNull:[[fieldsArray objectAtIndex:i] objectForKey:@"Zdoctype"]]) {
                                                    docType = @"";
                                                }
                                                else{
                                                    docType = [[fieldsArray objectAtIndex:i] objectForKey:@"Zdoctype"];
                                                }
                                                
                                                if ([NullChecker isNull:[[fieldsArray objectAtIndex:i] objectForKey:@"ZdoctypeItem"]]) {
                                                    docTypeItem = @"";
                                                }
                                                else{
                                                    docTypeItem = [[fieldsArray objectAtIndex:i] objectForKey:@"ZdoctypeItem"];
                                                }
                                                
                                                
                                                if ([NullChecker isNull:[[fieldsArray objectAtIndex:i] objectForKey:@"Datatype"]]) {
                                                    dataType = @"";
                                                }
                                                else{
                                                    dataType = [[fieldsArray objectAtIndex:i] objectForKey:@"Datatype"];
                                                }
                                                
                                                if ([NullChecker isNull:[[fieldsArray objectAtIndex:i] objectForKey:@"Sequence"]]) {
                                                    sequence = @"";
                                                }
                                                else{
                                                    sequence = [[fieldsArray objectAtIndex:i] objectForKey:@"Sequence"];
                                                }
                                                
                                                if ([NullChecker isNull:[[fieldsArray objectAtIndex:i] objectForKey:@"Length"]]) {
                                                    length = @"";
                                                }
                                                else{
                                                    length = [[fieldsArray objectAtIndex:i] objectForKey:@"Length"];
                                                }
                                                
                                                if ([docTypeItem isEqualToString:@"QT"]) {
                                                    [taskCodeCustomFields addObject:[NSMutableArray arrayWithObjects:docType,docTypeItem,tabName,fieldName,fieldValue,fLabel,dataType,sequence,length, nil]];
                                                }
                                                
                                            }
                                            
                                            customFieldsTaskTransactionsID = taskCodeCustomFields;
                                            
                                        }
                                        
                                        [[[notificationDetailDictionary objectForKey:[NSString stringWithFormat:@"%lli",[[tasksDictionary objectForKey:@"Qmnum"] longLongValue]]] objectAtIndex:4] addObject:[NSArray arrayWithObjects:tasks,customFieldsTaskTransactionsID, nil]];
                                     }
                                }
                            }
                            
                            [notificationTasksArray removeAllObjects];
                        }
                        
                        responseObject = nil;
                        NSMutableArray *notificationStatusArray = [[NSMutableArray alloc] init];
                        
                        if ([parsedDictionary objectForKey:@"resultNotifStatus"]) {
                            
                            responseObject = [parsedDictionary objectForKey:@"resultNotifStatus"];
                            
                            [notificationStatusArray addObjectsFromArray:responseObject];
                            
                            NSDictionary *notifStatusDictionary;
                            
                            for (int i=0; i<[notificationStatusArray count]; i++) {
                                if ([[notificationStatusArray objectAtIndex:i] isKindOfClass:[NSDictionary class]]) {
                                    notifStatusDictionary = [notificationStatusArray objectAtIndex:i];
                                    if ([notificationDetailDictionary objectForKey:[NSString stringWithFormat:@"%lli",[[notifStatusDictionary objectForKey:@"Qmnum"] longLongValue]]]) {
                                        
                                        NSMutableArray *notifStatus = [NSMutableArray array];
                                        
                                        if ([notifStatusDictionary objectForKey:@"Qmnum"]) {
                                            [notifStatus addObject:[notifStatusDictionary objectForKey:@"Qmnum"]];
                                        }
                                        else{
                                            
                                            [notifStatus addObject:@""];
                                        }
                                        
                                        if ([notifStatusDictionary objectForKey:@"Aufnr"]) {
                                            [notifStatus addObject:[notifStatusDictionary objectForKey:@"Aufnr"]];
                                        }
                                        else{
                                            
                                            [notifStatus addObject:@""];
                                        }
                                        
                                        if ([notifStatusDictionary objectForKey:@"Objnr"]) {
                                            [notifStatus addObject:[notifStatusDictionary objectForKey:@"Objnr"]];
                                        }
                                        else{
                                            [notifStatus addObject:@""];
                                        }
                                        
                                        if ([notifStatusDictionary objectForKey:@"Manum"]) {
                                            [notifStatus addObject:[notifStatusDictionary objectForKey:@"Manum"]];
                                        }
                                        else{
                                            [notifStatus addObject:@""];
                                        }
                                        
                                        if ([notifStatusDictionary objectForKey:@"Stsma"]) {
                                            [notifStatus addObject:[notifStatusDictionary objectForKey:@"Stsma"]];
                                        }
                                        else{
                                            [notifStatus addObject:@""];
                                        }
                                        
                                        if ([notifStatusDictionary objectForKey:@"Inist"]) {
                                            [notifStatus addObject:[notifStatusDictionary objectForKey:@"Inist"]];
                                        }
                                        else{
                                            [notifStatus addObject:@""];
                                        }
                                        
                                        if ([notifStatusDictionary objectForKey:@"Stonr"]) {
                                            [notifStatus addObject:[notifStatusDictionary objectForKey:@"Stonr"]];
                                        }
                                        else{
                                            [notifStatus addObject:@""];
                                        }
                                        
                                        if ([notifStatusDictionary objectForKey:@"Hsonr"]) {
                                            [notifStatus addObject:[notifStatusDictionary objectForKey:@"Hsonr"]];
                                        }
                                        else{
                                            [notifStatus addObject:@""];
                                        }
                                        
                                        if ([notifStatusDictionary objectForKey:@"Nsonr"]) {
                                            [notifStatus addObject:[notifStatusDictionary objectForKey:@"Nsonr"]];
                                        }
                                        else{
                                            [notifStatus addObject:@""];
                                        }
                                        
                                        if ([notifStatusDictionary objectForKey:@"Stat"]) {
                                            [notifStatus addObject:[[notifStatusDictionary objectForKey:@"Stat"] substringToIndex:1]];
                                        }
                                        else{
                                            [notifStatus addObject:@""];
                                        }
                                        
                                        if ([notifStatusDictionary objectForKey:@"Act"]) {
                                            [notifStatus addObject:[notifStatusDictionary objectForKey:@"Act"]];
                                        }
                                        else{
                                            [notifStatus addObject:@""];
                                        }
                                        
                                        if ([notifStatusDictionary objectForKey:@"Txt04"]) {
                                            [notifStatus addObject:[notifStatusDictionary objectForKey:@"Txt04"]];
                                        }
                                        else{
                                            [notifStatus addObject:@""];
                                        }
                                        
                                        if ([notifStatusDictionary objectForKey:@"Txt30"]) {
                                            [notifStatus addObject:[notifStatusDictionary objectForKey:@"Txt30"]];
                                        }
                                        else{
                                            [notifStatus addObject:@""];
                                        }
                                        
                                        if ([notifStatusDictionary objectForKey:@"Action"]) {
                                            [notifStatus addObject:[notifStatusDictionary objectForKey:@"Action"]];
                                        }
                                        else{
                                            [notifStatus addObject:@""];
                                        }
                                        
                                        [[[notificationDetailDictionary objectForKey:[NSString stringWithFormat:@"%lli",[[notifStatusDictionary objectForKey:@"Qmnum"] longLongValue]]] lastObject] addObject:notifStatus];
                                    }
                                }
                            }
                            
                            [notificationStatusArray removeAllObjects];
                        }
                        
                        responseObject = nil;
                        
                        if ([parsedDictionary objectForKey:@"resultLongText"]) {
                            responseObject = [parsedDictionary objectForKey:@"resultLongText"];
                            NSMutableArray *notificatioTextnArray = [[NSMutableArray alloc] init];
                            
                            [notificatioTextnArray addObjectsFromArray:responseObject];
                            
                            NSDictionary *textDictionary;
                            for (int i=0; i<[notificatioTextnArray count]; i++) {
                                if ([[notificatioTextnArray objectAtIndex:i] isKindOfClass:[NSDictionary class]]) {
                                    textDictionary = [notificatioTextnArray objectAtIndex:i];
                                    if ([notificationDetailDictionary objectForKey:[textDictionary objectForKey:@"Qmnum"]]) {
                                        NSMutableDictionary *headerDictionary = [[notificationDetailDictionary objectForKey:[textDictionary objectForKey:@"Qmnum"]] firstObject];
                                        if ([[headerDictionary objectForKey:@"LONGTEXT"] length]) {
                                            [headerDictionary setObject:[NSString stringWithFormat:@"%@\n%@",[headerDictionary objectForKey:@"LONGTEXT"],[textDictionary objectForKey:@"TextLine"]] forKey:@"LONGTEXT"];
                                        }
                                        else
                                        {
                                            [headerDictionary setObject:[NSString stringWithFormat:@"%@",[textDictionary objectForKey:@"TextLine"]] forKey:@"LONGTEXT"];
                                        }
                                    }
                                }
                            }
                            
                            [notificationTransactionArray removeAllObjects];
                            responseObject = nil;
                        }
                        
                        NSLog(@"%@",notificationDetailDictionary);
                        
                        NSArray *objectIds = [notificationDetailDictionary allKeys];
                        [[DataBase sharedInstance] deleteinsertDataIntoHeader:@"N"];
                        
                        if ([[defaults objectForKey:@"ACTIVATELOGS"] isEqualToString:@"X"])
                        {
                            [[DataBase sharedInstance] writToLogFile:[NSString stringWithFormat:@"#INFO#.com.enstrapp.fieldtekpro#No of Due Notifications received:%lu",(unsigned long)[objectIds count]]];
                        }
                        
                        for (int i=0; i<[objectIds count]; i++) {
                            
                            [[DataBase sharedInstance] insertDataIntoNotificationHeader:[[notificationDetailDictionary objectForKey:[objectIds objectAtIndex:i]] firstObject] withAttachments:[[notificationDetailDictionary objectForKey:[objectIds objectAtIndex:i]] objectAtIndex:1] withTransaction:[[notificationDetailDictionary objectForKey:[objectIds objectAtIndex:i]] objectAtIndex:2] withActivityCodes:[[notificationDetailDictionary objectForKey:[objectIds objectAtIndex:i]] objectAtIndex:3] withTaskcodes:[[notificationDetailDictionary objectForKey:[objectIds objectAtIndex:i]] objectAtIndex:4] withInspectionResult:[inspectionResultDataArray copy] withNotifStatusCode:[[notificationDetailDictionary objectForKey:[objectIds objectAtIndex:i]] objectAtIndex:5]];
                         }
                        
                        [self searchMyNotificationsFromSqlite:nil];
                        [MBProgressHUD hideHUDForView:self.view animated:YES];
                        
                    }
                    
                    else{
                        
                        [self searchMyNotificationsFromSqlite:nil];

                        [MBProgressHUD hideHUDForView:self.view animated:YES];

                    }
                 }
            }
            else{
                
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                
                [self showAlertMessageWithTitle:@"FieldTekPro" message:errorDescription cancelButtonTitle:@"Ok" withactionType:@"Single" forMethod:nil];
                
            }
            
            break;
            
            
        case NOTIFICATION_RELEASE:
            
            if (!errorDescription.length) {
                
                if (statusCode == 401) {
                    
                    [MBProgressHUD hideHUDForView:self.view animated:YES];

                    
                     [self showAlertMessageWithTitle:@"Authentication Failed!!" message:@"kindly check your password" cancelButtonTitle:@"Ok" withactionType:@"Single" forMethod:nil];
                    
                }
                else{
                    
                    NSMutableDictionary *parsedDictionary = [[Response sharedInstance] parseForReleaseNotification:resultData];
                    
                    if ([parsedDictionary objectForKey:@"MESSAGE"]) {
                        
                        NSMutableString *messageString = [NSMutableString stringWithString:@""];
                        
                        NSString *qmnumString;
                        
                        [[DataBase sharedInstance] deleteNotificationTransactions];
                        [[DataBase sharedInstance] deleteNotificationTasks];
                        
                        if ([[[[parsedDictionary objectForKey:@"MESSAGE"] substringToIndex:1] uppercaseString] isEqualToString:@"S"]) {
                            [messageString appendString:[NSString stringWithFormat:@"%@\n", [[parsedDictionary objectForKey:@"MESSAGE"] substringFromIndex:1]]];
                            
                            [[DataBase sharedInstance] updateSyncLogForCategory:@"Notification" action:@"Release" objectid:[parsedDictionary objectForKey:@"OBJECTID"] UUID:[self.notificationHeaderDetails objectForKey:@"ID"]];
                            
                            if ([[defaults objectForKey:@"ACTIVATELOGS"] isEqualToString:@"X"])
                            {
                                [[DataBase sharedInstance] writToLogFile:[NSString stringWithFormat:@"#INFO#.com.enstrapp.fieldtekpro#Notif #Activity:Create Notification #Notifno:%@ #Mode:Online #Class: Very Important #MUser:%@ #DeviceId:%@",[parsedDictionary objectForKey:@"OBJECTID"],decryptedUserName,[defaults objectForKey:@"edeviceid"]]];
                             }
                            
                            
                            if ([parsedDictionary objectForKey:@"resultHeader"]) {
                                NSMutableDictionary *notificationDetailDictionary = [[NSMutableDictionary alloc] init];
                                
                                id responseObject = [parsedDictionary objectForKey:@"resultHeader"];
                                
                                NSMutableArray *notificatinHeaderArray = [[NSMutableArray alloc] init];
                                
                                NSMutableArray *inspectionResultDataArray = [NSMutableArray new];
                                
                                
                                [notificatinHeaderArray addObjectsFromArray:responseObject];
                                
                                NSDictionary *headerDictionary;
                                NSDateFormatter *dateFormate = [[NSDateFormatter alloc] init];
                                [dateFormate setDateFormat:@"yyyy-MM-dd"];
                                
                                for (int i=0; i<[notificatinHeaderArray count]; i++) {
                                    if ([[notificatinHeaderArray objectAtIndex:i] isKindOfClass:[NSDictionary class]]) {
                                        headerDictionary = [notificatinHeaderArray objectAtIndex:i];
                                        NSMutableDictionary *currentHeaderDictionary = [[NSMutableDictionary alloc] init];
                                        if ([headerDictionary objectForKey:@"BreakdownInd"]) {
                                            [currentHeaderDictionary setObject:[[headerDictionary objectForKey:@"BreakdownInd"] copy] forKey:@"BREAKDOWN"];
                                        }
                                        else
                                        {
                                            [currentHeaderDictionary setObject:@" " forKey:@"BREAKDOWN"];
                                        }
                                        
                                        if ([headerDictionary objectForKey:@"FunctionLoc"]) {
                                            
                                            [currentHeaderDictionary setObject:[[headerDictionary objectForKey:@"FunctionLoc"] copy] forKey:@"FID"];
                                        }
                                        else{
                                            [currentHeaderDictionary setObject:@"" forKey:@"FID"];
                                        }
                                        if ([headerDictionary objectForKey:@"Pltxt"]) {
                                            
                                            [currentHeaderDictionary setObject:[[headerDictionary objectForKey:@"Pltxt"] copy] forKey:@"FNAME"];
                                        }
                                        else{
                                            [currentHeaderDictionary setObject:@"" forKey:@"FNAME"];
                                        }
                                        
                                        if ([headerDictionary objectForKey:@"NotifShorttxt"]) {
                                            [currentHeaderDictionary setObject:[[headerDictionary objectForKey:@"NotifShorttxt"] copy] forKey:@"SHORTTEXT"];
                                        }
                                        else{
                                            [currentHeaderDictionary setObject:@"" forKey:@"SHORTTEXT"];
                                        }
                                        if ([headerDictionary objectForKey:@"NotifType"]) {
                                            [currentHeaderDictionary setObject:[[headerDictionary objectForKey:@"NotifType"] copy] forKey:@"NID"];
                                        }
                                        else{
                                            [currentHeaderDictionary setObject:@"" forKey:@"NID"];
                                        }
                                        
                                        if ([headerDictionary objectForKey:@"Qmartx"]) {
                                            [currentHeaderDictionary setObject:[[headerDictionary objectForKey:@"Qmartx"] copy] forKey:@"NNAME"];
                                        }
                                        else{
                                            [currentHeaderDictionary setObject:@"" forKey:@"NNAME"];
                                        }
                                        
                                        if ([headerDictionary objectForKey:@"Qmnum"]) {
                                            [currentHeaderDictionary setObject:[[headerDictionary objectForKey:@"Qmnum"] copy] forKey:@"OBJECTID"];
                                        }
                                        else{
                                            [currentHeaderDictionary setObject:@"" forKey:@"OBJECTID"];
                                        }
                                        
                                        if ([headerDictionary objectForKey:@"Qmdat"]) {
                                            [currentHeaderDictionary setObject:[[headerDictionary objectForKey:@"Qmdat"] copy] forKey:@"QMDAT"];
                                        }
                                        else{
                                            [currentHeaderDictionary setObject:@"" forKey:@"QMDAT"];
                                        }
                                        
                                        [currentHeaderDictionary setObject:@"" forKey:@"REPORTEDBY"];
                                        
                                        if ([headerDictionary objectForKey:@"ReportedBy"]) {
                                            [currentHeaderDictionary setObject:[[headerDictionary objectForKey:@"ReportedBy"] copy] forKey:@"NREPORTEDBY"];
                                        }
                                        else{
                                            
                                            [currentHeaderDictionary setObject:@"" forKey:@"NREPORTEDBY"];
                                            
                                        }
                                        
                                        if ([headerDictionary objectForKey:@"Equipment"]) {
                                            [currentHeaderDictionary setObject:[[headerDictionary objectForKey:@"Equipment"] copy] forKey:@"EQID"];
                                        }
                                        else{
                                            [currentHeaderDictionary setObject:@"" forKey:@"EQID"];
                                        }
                                        
                                        if ([headerDictionary objectForKey:@"Eqktx"]) {
                                            [currentHeaderDictionary setObject:[[headerDictionary objectForKey:@"Eqktx"] copy] forKey:@"EQNAME"];
                                        }
                                        else{
                                            [currentHeaderDictionary setObject:@"" forKey:@"EQNAME"];
                                        }
                                        
                                        if ([headerDictionary objectForKey:@"Priority"]) {
                                            [currentHeaderDictionary setObject:[[headerDictionary objectForKey:@"Priority"] copy] forKey:@"NPID"];
                                        }
                                        else{
                                            [currentHeaderDictionary setObject:@"" forKey:@"NPID"];
                                        }
                                        
                                        if ([headerDictionary objectForKey:@"Priokx"]) {
                                            [currentHeaderDictionary setObject:[[headerDictionary objectForKey:@"Priokx"] copy] forKey:@"NPNAME"];
                                        }
                                        else{
                                            [currentHeaderDictionary setObject:@"" forKey:@"NPNAME"];
                                        }
                                        
                                        if ([headerDictionary objectForKey:@"MalfuncEddate"]) {
                                            
                                            NSString *malfunctionEndDateString;
                                            
                                            if (![NullChecker isNull:[headerDictionary objectForKey:@"MalfuncEddate"]]) {
                                                
                                                if ([[headerDictionary objectForKey:@"MalfuncEddate"] rangeOfString:@"Date"].length) {
                                                    
                                                    malfunctionEndDateString=[NSString stringWithFormat:@"%@",[dateFormate stringFromDate:[NSDate dateWithTimeIntervalSince1970:[[[[headerDictionary objectForKey:@"MalfuncEddate"] stringByReplacingOccurrencesOfString:@"/Date(" withString:@""] stringByReplacingOccurrencesOfString:@")/" withString:@""] doubleValue]/1000.0]]];
                                                    
                                                }
                                                else
                                                {
                                                    malfunctionEndDateString=[NSString stringWithFormat:@"%@",[headerDictionary objectForKey:@"MalfuncEddate"]];
                                                }
                                            }
                                            
                                            
                                            
                                            if (malfunctionEndDateString.length) {
                                                
                                                if ([headerDictionary objectForKey:@"MalfuncEdtime"]) {
                                                    
                                                    [currentHeaderDictionary setObject:[NSString stringWithFormat:@"%@ %@",malfunctionEndDateString,[headerDictionary objectForKey:@"MalfuncEdtime"]] forKey:@"EDATE"];
                                                }
                                                else{
                                                    
                                                    [currentHeaderDictionary setObject:malfunctionEndDateString forKey:@"EDATE"];
                                                }
                                            }
                                            
                                        }
                                        else{
                                            [currentHeaderDictionary setObject:@"" forKey:@"EDATE"];
                                        }
                                        
                                        if (![NullChecker isNull:[headerDictionary objectForKey:@"MalfuncStdate"]]) {
                                            
                                            NSString *malfunctionStartDateString;
                                            
                                            if ([[headerDictionary objectForKey:@"MalfuncStdate"] rangeOfString:@"Date"].length) {
                                                
                                                malfunctionStartDateString=[NSString stringWithFormat:@"%@",[dateFormate stringFromDate:[NSDate dateWithTimeIntervalSince1970:[[[[headerDictionary objectForKey:@"MalfuncStdate"] stringByReplacingOccurrencesOfString:@"/Date(" withString:@""] stringByReplacingOccurrencesOfString:@")/" withString:@""] doubleValue]/1000.0]]];
                                            }
                                            else{
                                                
                                                malfunctionStartDateString=[NSString stringWithFormat:@"%@",[headerDictionary objectForKey:@"MalfuncStdate"]];
                                                [currentHeaderDictionary setObject:[NSString stringWithFormat:@"%@",[headerDictionary objectForKey:@"MalfuncStdate"]] forKey:@"SDATE"];
                                            }
                                            
                                            if (malfunctionStartDateString.length) {
                                                
                                                if ([headerDictionary objectForKey:@"MalfuncSttime"]) {
                                                    
                                                    [currentHeaderDictionary setObject:[NSString stringWithFormat:@"%@ %@",malfunctionStartDateString,[headerDictionary objectForKey:@"MalfuncSttime"]] forKey:@"SDATE"];
                                                }
                                                else{
                                                    
                                                    [currentHeaderDictionary setObject:malfunctionStartDateString forKey:@"SDATE"];
                                                }
                                            }
                                            
                                        }
                                        else{
                                            [currentHeaderDictionary setObject:@"" forKey:@"SDATE"];
                                        }
                                        
                                        if ([headerDictionary objectForKey:@"Werks"]) {
                                            [currentHeaderDictionary setObject:[headerDictionary objectForKey:@"Werks"] forKey:@"PLANTID"];
                                            [currentHeaderDictionary setObject:[headerDictionary objectForKey:@"Plantname"] forKey:@"PLANTNAME"];
                                        }
                                        else{
                                            [currentHeaderDictionary setObject:@"" forKey:@"PLANTID"];
                                            [currentHeaderDictionary setObject:@"" forKey:@"PLANTNAME"];
                                        }
                                        
                                        if ([headerDictionary objectForKey:@"Arbpl"]) {
                                            [currentHeaderDictionary setObject:[headerDictionary objectForKey:@"Arbpl"] forKey:@"WORKCENTERID"];
                                            [currentHeaderDictionary setObject:[headerDictionary objectForKey:@"Wkctrname"] forKey:@"WORKCENTERNAME"];
                                        }
                                        else{
                                            [currentHeaderDictionary setObject:@"" forKey:@"WORKCENTERID"];
                                            [currentHeaderDictionary setObject:@"" forKey:@"WORKCENTERNAME"];
                                        }
                                        
                                        if ([headerDictionary objectForKey:@"Xstatus"]) {
                                            [currentHeaderDictionary setObject:[headerDictionary objectForKey:@"Xstatus"] forKey:@"NSTATUS"];
                                        }
                                        else{
                                            
                                            [currentHeaderDictionary setObject:@"OSNO" forKey:@"NSTATUS"];
                                        }
                                        
                                        [currentHeaderDictionary setObject:@"" forKey:@"DOCS"];
                                        
                                        if ([headerDictionary objectForKey:@"Docs"]) {
                                            [currentHeaderDictionary setObject:[headerDictionary objectForKey:@"Docs"] forKey:@"DOCS"];
                                        }
                                        
                                        [currentHeaderDictionary setObject:@"" forKey:@"RSDATE"];
                                        
                                        if ([headerDictionary objectForKey:@"Strmn"]) {
                                            
                                            if ([headerDictionary objectForKey:@"Strur"]) {
                                                
                                                [currentHeaderDictionary setObject:[NSString stringWithFormat:@"%@ %@",[headerDictionary objectForKey:@"Strmn"],[headerDictionary objectForKey:@"Strur"]] forKey:@"RSDATE"];
                                            }
                                            else{
                                                
                                                [currentHeaderDictionary setObject:[headerDictionary objectForKey:@"Strmn"] forKey:@"RSDATE"];
                                            }
                                            
                                            
                                            //                                [currentHeaderDictionary setObject:[NSString stringWithFormat:@"%@ %@",[headerDictionary objectForKey:@"Strmn"],[headerDictionary objectForKey:@"Strur"]] forKey:@"RSDATE"];
                                        }
                                        
                                        [currentHeaderDictionary setObject:@"" forKey:@"REDATE"];
                                        
                                        if ([headerDictionary objectForKey:@"Ltrmn"]) {
                                            
                                            if ([headerDictionary objectForKey:@"Ltrur"]) {
                                                
                                                [currentHeaderDictionary setObject:[NSString stringWithFormat:@"%@ %@",[headerDictionary objectForKey:@"Ltrmn"],[headerDictionary objectForKey:@"Ltrur"]] forKey:@"REDATE"];
                                            }
                                            else{
                                                
                                                [currentHeaderDictionary setObject:[headerDictionary objectForKey:@"Ltrmn"] forKey:@"REDATE"];
                                                
                                            }
                                            //                                [currentHeaderDictionary setObject:[NSString stringWithFormat:@"%@ %@",[headerDictionary objectForKey:@"Ltrmn"],[headerDictionary objectForKey:@"Ltrur"]] forKey:@"REDATE"];
                                        }
                                        
                                        
                                        if ([headerDictionary objectForKey:@"ParnrVw"]) {
                                            [currentHeaderDictionary setObject:[headerDictionary objectForKey:@"ParnrVw"] forKey:@"PARNRID"];
                                        }
                                        else{
                                            
                                            [currentHeaderDictionary setObject:@"" forKey:@"PARNRID"];
                                        }
                                        
                                        if ([headerDictionary objectForKey:@"NameVw"]) {
                                            [currentHeaderDictionary setObject:[headerDictionary objectForKey:@"NameVw"] forKey:@"PARNRTEXT"];
                                        }
                                        else{
                                            
                                            [currentHeaderDictionary setObject:@"" forKey:@"PARNRTEXT"];
                                            
                                        }
                                        
                                        if ([headerDictionary objectForKey:@"Ingrp"]) {
                                            [currentHeaderDictionary setObject:[headerDictionary objectForKey:@"Ingrp"] forKey:@"PLANNERGROUP"];
                                        }
                                        else{
                                            
                                            [currentHeaderDictionary setObject:@"" forKey:@"PLANNERGROUP"];
                                            
                                        }
                                        
                                        if ([headerDictionary objectForKey:@"Ingrpname"]) {
                                            [currentHeaderDictionary setObject:[headerDictionary objectForKey:@"Ingrpname"] forKey:@"PLANNERGROUPNAME"];
                                        }
                                        else{
                                            
                                            [currentHeaderDictionary setObject:@"" forKey:@"PLANNERGROUPNAME"];
                                            
                                        }
                                        
                                        [currentHeaderDictionary setObject:@"" forKey:@"SHIFT"];
                                        if ([headerDictionary objectForKey:@"Shift"]) {
                                            [currentHeaderDictionary setObject:[headerDictionary objectForKey:@"Shift"] forKey:@"SHIFT"];
                                        }
                                        
                                        [currentHeaderDictionary setObject:@"" forKey:@"NOOFPERSON"];
                                        if ([headerDictionary objectForKey:@"Noofperson"]) {
                                            [currentHeaderDictionary setObject:[headerDictionary objectForKey:@"Noofperson"] forKey:@"NOOFPERSON"];
                                        }
                                        
                                        [currentHeaderDictionary setObject:@"" forKey:@"EFFECTID"];
                                        if ([headerDictionary objectForKey:@"Auswk"]) {
                                            [currentHeaderDictionary setObject:[headerDictionary objectForKey:@"Auswk"] forKey:@"EFFECTID"];
                                        }
                                        
                                        [currentHeaderDictionary setObject:@"" forKey:@"EFFECTNAME"];
                                        if ([headerDictionary objectForKey:@"Auswkt"]) {
                                            [currentHeaderDictionary setObject:[headerDictionary objectForKey:@"Auswkt"] forKey:@"EFFECTNAME"];
                                        }
                                        
                                        [currentHeaderDictionary setObject:@"" forKey:@"AUFNR"];
                                        
                                        
                                        if ([headerDictionary objectForKey:@"Aufnr"]) {
                                            [currentHeaderDictionary setObject:[headerDictionary objectForKey:@"Aufnr"] forKey:@"AUFNR"];
                                            
                                            aufnrString=[headerDictionary objectForKey:@"Aufnr"];
                                            
                                        }
                                        
                                        [currentHeaderDictionary setObject:@"" forKey:@"LONGTEXT"];
                                        [currentHeaderDictionary setObject:[[DataBase sharedInstance] fetchNameForIDKey:@"OBJECTID" forValue:[currentHeaderDictionary objectForKey:@"OBJECTID"]] forKey:@"ID"];
                                        if (![[currentHeaderDictionary objectForKey:@"ID"] length]) {
                                            
                                        }
                                        
                                        [currentHeaderDictionary setObject:@"" forKey:@"USR01"];
                                        if ([headerDictionary objectForKey:@"Usr01"]) {
                                            [currentHeaderDictionary setObject:[headerDictionary objectForKey:@"Usr01"] forKey:@"USR01"];
                                        }
                                        
                                        [currentHeaderDictionary setObject:@"" forKey:@"USR02"];
                                        if ([headerDictionary objectForKey:@"Usr02"]) {
                                            [currentHeaderDictionary setObject:[headerDictionary objectForKey:@"Usr02"] forKey:@"USR02"];
                                        }
                                        
                                        
                                        [currentHeaderDictionary setObject:@"" forKey:@"NOSYNCLOG"];
                                        [currentHeaderDictionary setObject:@"" forKey:@"LATITUDES"];
                                        [currentHeaderDictionary setObject:@"" forKey:@"LONGITUDES"];
                                        [currentHeaderDictionary setObject:@"" forKey:@"ALTITUDES"];
                                        
                                        if ([headerDictionary objectForKey:@"EquiHistory"]) {
                                            id equipmentHisory = [headerDictionary objectForKey:@"EquiHistory"];
                                            if ([equipmentHisory objectForKey:@"item"]) {
                                                equipmentHisory = [equipmentHisory objectForKey:@"item"];
                                                if ([equipmentHisory isKindOfClass:[NSDictionary class]]) {
                                                    [currentHeaderDictionary setObject:[NSMutableArray arrayWithObject:equipmentHisory] forKey:@"EQUIPMENTHISTORY"];
                                                }
                                                else if ([equipmentHisory isKindOfClass:[NSArray class]]){
                                                    [currentHeaderDictionary setObject:equipmentHisory forKey:@"EQUIPMENTHISTORY"];
                                                }
                                            }
                                        }
                                        
                                        if ([headerDictionary objectForKey:@"Fields"]) {
                                            NSMutableArray *fieldsMutArray = [NSMutableArray new];
                                            NSMutableArray *tempfieldsMutArray = [NSMutableArray new];
                                            
                                            if ([[[headerDictionary objectForKey:@"Fields"] objectForKey:@"item"] isKindOfClass:[NSDictionary class]]) {
                                                [tempfieldsMutArray addObjectsFromArray:[NSMutableArray arrayWithObject:[[headerDictionary objectForKey:@"Fields"] objectForKey:@"item"]]];
                                            }
                                            else if ([[[headerDictionary objectForKey:@"Fields"] objectForKey:@"item"] isKindOfClass:[NSArray class]]) {
                                                [tempfieldsMutArray addObjectsFromArray:[[headerDictionary objectForKey:@"Fields"] objectForKey:@"item"]];
                                            }
                                            
                                            //                                NSArray *fieldsArray = [[headerDictionary objectForKey:@"Fields"] objectForKey:@"item"];
                                            for (int i =0; i<[tempfieldsMutArray count]; i++) {
                                                NSString *fieldValue,*fieldName,*fLabel,*tabName,*dataType,*sequence,*length;
                                                if ([NullChecker isNull:[[tempfieldsMutArray objectAtIndex:i] objectForKey:@"Fieldname"]]) {
                                                    fieldName = @"";
                                                }
                                                else{
                                                    fieldName = [[tempfieldsMutArray objectAtIndex:i] objectForKey:@"Fieldname"];
                                                }
                                                
                                                if ([NullChecker isNull:[[tempfieldsMutArray objectAtIndex:i] objectForKey:@"Flabel"]]) {
                                                    fLabel = @"";
                                                }
                                                else{
                                                    fLabel = [[tempfieldsMutArray objectAtIndex:i] objectForKey:@"Flabel"];
                                                }
                                                
                                                if ([NullChecker isNull:[[tempfieldsMutArray objectAtIndex:i] objectForKey:@"Tabname"]]) {
                                                    tabName = @"";
                                                }
                                                else{
                                                    tabName = [[tempfieldsMutArray objectAtIndex:i] objectForKey:@"Tabname"];
                                                }
                                                
                                                if ([NullChecker isNull:[[tempfieldsMutArray objectAtIndex:i] objectForKey:@"Value"]]) {
                                                    fieldValue = @"";
                                                }
                                                else{
                                                    fieldValue = [[tempfieldsMutArray objectAtIndex:i] objectForKey:@"Value"];
                                                }
                                                
                                                if ([NullChecker isNull:[[tempfieldsMutArray objectAtIndex:i] objectForKey:@"Datatype"]]) {
                                                    dataType = @"";
                                                }
                                                else{
                                                    dataType = [[tempfieldsMutArray objectAtIndex:i] objectForKey:@"Datatype"];
                                                }
                                                
                                                if ([NullChecker isNull:[[tempfieldsMutArray objectAtIndex:i] objectForKey:@"Sequence"]]) {
                                                    sequence = @"";
                                                }
                                                else{
                                                    sequence = [[tempfieldsMutArray objectAtIndex:i] objectForKey:@"Sequence"];
                                                }
                                                
                                                if ([NullChecker isNull:[[tempfieldsMutArray objectAtIndex:i] objectForKey:@"Length"]]) {
                                                    length = @"";
                                                }
                                                else{
                                                    length = [[tempfieldsMutArray objectAtIndex:i] objectForKey:@"Length"];
                                                }
                                                
                                                
                                                [fieldsMutArray addObject:[NSMutableArray arrayWithObjects:@"W",@"WH",tabName,fieldName,fieldValue,fLabel,dataType,sequence,length, nil]];
                                            }
                                            
                                            [currentHeaderDictionary setObject:fieldsMutArray forKey:@"CFH"];
                                        }
                                        
                                        [notificationDetailDictionary setObject:[NSMutableArray arrayWithObjects:currentHeaderDictionary,[NSMutableArray array],[NSMutableArray array],[NSMutableArray array],[NSMutableArray array],[NSMutableArray array], nil] forKey:[currentHeaderDictionary objectForKey:@"OBJECTID"]];
                                    }
                                }
                                
                                [notificatinHeaderArray removeAllObjects];
                                
                                //    resultInspection
                                // resultActivities
                                
                                responseObject = nil;
                                
                                responseObject = [parsedDictionary objectForKey:@"resultInspection"];
                                
                                
                                for (int i = 0; i<[responseObject  count]; i++) {
                                    NSDictionary *inspectionresultDictionary;
                                    
                                    NSMutableArray *resultInpectionsDataArray = [NSMutableArray new];
                                    
                                    inspectionresultDictionary = [responseObject  objectAtIndex:i];
                                    if ([NullChecker isNull:[inspectionresultDictionary objectForKey:@"Qmnum"]]) {
                                        [resultInpectionsDataArray addObject:@""];
                                    }
                                    else{
                                        [resultInpectionsDataArray addObject:[inspectionresultDictionary objectForKey:@"Qmnum"]];
                                    }
                                    
                                    if ([NullChecker isNull:[inspectionresultDictionary objectForKey:@"Aufnr"]]) {
                                        [resultInpectionsDataArray addObject:@""];
                                    }
                                    else{
                                        
                                        [resultInpectionsDataArray addObject:[inspectionresultDictionary objectForKey:@"Aufnr"]];
                                    }
                                    
                                    if ([NullChecker isNull:[inspectionresultDictionary objectForKey:@"Vornr"]]) {
                                        [resultInpectionsDataArray addObject:@""];
                                    }
                                    else{
                                        [resultInpectionsDataArray addObject:[inspectionresultDictionary objectForKey:@"Vornr"]];
                                    }
                                    
                                    if ([NullChecker isNull:[inspectionresultDictionary objectForKey:@"Equnr"]]) {
                                        [resultInpectionsDataArray addObject:@""];
                                    }
                                    else{
                                        [resultInpectionsDataArray addObject:[inspectionresultDictionary objectForKey:@"Equnr"]];
                                    }
                                    
                                    if ([NullChecker isNull:[inspectionresultDictionary objectForKey:@"Mdocm"]]) {
                                        [resultInpectionsDataArray addObject:@""];
                                    }
                                    else{
                                        [resultInpectionsDataArray addObject:[inspectionresultDictionary objectForKey:@"Mdocm"]];
                                    }
                                    
                                    if ([NullChecker isNull:[inspectionresultDictionary objectForKey:@"Point"]]) {
                                        [resultInpectionsDataArray addObject:@""];
                                    }
                                    else{
                                        [resultInpectionsDataArray addObject:[inspectionresultDictionary objectForKey:@"Point"]];
                                    }
                                    
                                    if ([NullChecker isNull:[inspectionresultDictionary objectForKey:@"Mpobj"]]) {
                                        [resultInpectionsDataArray addObject:@""];
                                    }
                                    else{
                                        [resultInpectionsDataArray addObject:[inspectionresultDictionary objectForKey:@"Mpobj"]];
                                    }
                                    
                                    if ([NullChecker isNull:[inspectionresultDictionary objectForKey:@"Mpobt"]]) {
                                        [resultInpectionsDataArray addObject:@""];
                                    }
                                    else{
                                        [resultInpectionsDataArray addObject:[inspectionresultDictionary objectForKey:@"Mpobt"]];
                                    }
                                    
                                    if ([NullChecker isNull:[inspectionresultDictionary objectForKey:@"Psort"]]) {
                                        [resultInpectionsDataArray addObject:@""];
                                    }
                                    else{
                                        [resultInpectionsDataArray addObject:[inspectionresultDictionary objectForKey:@"Psort"]];
                                    }
                                    
                                    if ([NullChecker isNull:[inspectionresultDictionary objectForKey:@"Pttxt"]]) {
                                        [resultInpectionsDataArray addObject:@""];
                                    }
                                    else{
                                        [resultInpectionsDataArray addObject:[inspectionresultDictionary objectForKey:@"Pttxt"]];
                                    }
                                    
                                    if ([NullChecker isNull:[inspectionresultDictionary objectForKey:@"Atinn"]]) {
                                        [resultInpectionsDataArray addObject:@""];
                                    }
                                    else{
                                        [resultInpectionsDataArray addObject:[inspectionresultDictionary objectForKey:@"Atinn"]];
                                    }
                                    
                                    if ([NullChecker isNull:[inspectionresultDictionary objectForKey:@"Idate"]]) {
                                        [resultInpectionsDataArray addObject:@""];
                                    }
                                    else{
                                        [resultInpectionsDataArray addObject:[inspectionresultDictionary objectForKey:@"Idate"]];
                                    }
                                    
                                    if ([NullChecker isNull:[inspectionresultDictionary objectForKey:@"Itime"]]) {
                                        [resultInpectionsDataArray addObject:@""];
                                    }
                                    else{
                                        [resultInpectionsDataArray addObject:[inspectionresultDictionary objectForKey:@"Itime"]];
                                    }
                                    
                                    if ([NullChecker isNull:[inspectionresultDictionary objectForKey:@"Mdtxt"]]) {
                                        [resultInpectionsDataArray addObject:@""];
                                    }
                                    else{
                                        [resultInpectionsDataArray addObject:[inspectionresultDictionary objectForKey:@"Mdtxt"]];
                                    }
                                    
                                    if ([NullChecker isNull:[inspectionresultDictionary objectForKey:@"Readr"]]) {
                                        [resultInpectionsDataArray addObject:@""];
                                    }
                                    else{
                                        [resultInpectionsDataArray addObject:[inspectionresultDictionary objectForKey:@"Readr"]];
                                    }
                                    
                                    
                                    if ([NullChecker isNull:[inspectionresultDictionary objectForKey:@"Atbez"]]) {
                                        [resultInpectionsDataArray addObject:@""];
                                    }
                                    else{
                                        [resultInpectionsDataArray addObject:[inspectionresultDictionary objectForKey:@"Atbez"]];
                                    }
                                    
                                    if ([NullChecker isNull:[inspectionresultDictionary objectForKey:@"Msehi"]]) {
                                        [resultInpectionsDataArray addObject:@""];
                                    }
                                    else{
                                        [resultInpectionsDataArray addObject:[inspectionresultDictionary objectForKey:@"Msehi"]];
                                    }
                                    
                                    
                                    if ([NullChecker isNull:[inspectionresultDictionary objectForKey:@"Msehl"]]) {
                                        [resultInpectionsDataArray addObject:@""];
                                    }
                                    else{
                                        [resultInpectionsDataArray addObject:[inspectionresultDictionary objectForKey:@"Msehl"]];
                                    }
                                    
                                    
                                    if ([NullChecker isNull:[inspectionresultDictionary objectForKey:@"Readc"]]) {
                                        [resultInpectionsDataArray addObject:@""];
                                    }
                                    else{
                                        [resultInpectionsDataArray addObject:[inspectionresultDictionary objectForKey:@"Readc"]];
                                    }
                                    
                                    if ([NullChecker isNull:[inspectionresultDictionary objectForKey:@"Desic"]]) {
                                        [resultInpectionsDataArray addObject:@""];
                                    }
                                    else{
                                        [resultInpectionsDataArray addObject:[inspectionresultDictionary objectForKey:@"Desic"]];
                                    }
                                    
                                    if ([NullChecker isNull:[inspectionresultDictionary objectForKey:@"Prest"]]) {
                                        [resultInpectionsDataArray addObject:@""];
                                    }
                                    else{
                                        [resultInpectionsDataArray addObject:[inspectionresultDictionary objectForKey:@"Prest"]];
                                    }
                                    
                                    
                                    if ([NullChecker isNull:[inspectionresultDictionary objectForKey:@"Docaf"]]) {
                                        [resultInpectionsDataArray addObject:@""];
                                    }
                                    else{
                                        [resultInpectionsDataArray addObject:[inspectionresultDictionary objectForKey:@"Docaf"]];
                                    }
                                    
                                    if ([NullChecker isNull:[inspectionresultDictionary objectForKey:@"Codct"]]) {
                                        [resultInpectionsDataArray addObject:@""];
                                    }
                                    else{
                                        [resultInpectionsDataArray addObject:[inspectionresultDictionary objectForKey:@"Codct"]];
                                    }
                                    
                                    if ([NullChecker isNull:[inspectionresultDictionary objectForKey:@"Codgr"]]) {
                                        [resultInpectionsDataArray addObject:@""];
                                    }
                                    else{
                                        [resultInpectionsDataArray addObject:[inspectionresultDictionary objectForKey:@"Codgr"]];
                                    }
                                    
                                    if ([NullChecker isNull:[inspectionresultDictionary objectForKey:@"Vlcod"]]) {
                                        [resultInpectionsDataArray addObject:@""];
                                    }
                                    else{
                                        [resultInpectionsDataArray addObject:[inspectionresultDictionary objectForKey:@"Vlcod"]];
                                    }
                                    
                                    if ([NullChecker isNull:[inspectionresultDictionary objectForKey:@"Action"]]) {
                                        [resultInpectionsDataArray addObject:@""];
                                    }
                                    else{
                                        [resultInpectionsDataArray addObject:[inspectionresultDictionary objectForKey:@"Action"]];
                                    }
                                    
                                    [inspectionResultDataArray addObject:resultInpectionsDataArray];
                                }
                                
                                
                                responseObject = nil;
                                NSMutableArray *notificationDocs = [[NSMutableArray alloc] init];
                                
                                if ([parsedDictionary objectForKey:@"resultDocs"]) {
                                    responseObject = [parsedDictionary objectForKey:@"resultDocs"];
                                    [notificationDocs addObjectsFromArray:responseObject];
                                    
                                    NSDictionary *DocsDictionary;
                                    for (int i =0; i<[notificationDocs count]; i++) {
                                        if ([[notificationDocs objectAtIndex:i] isKindOfClass:[NSDictionary class]]) {
                                            DocsDictionary = [notificationDocs objectAtIndex:i];
                                            if ([notificationDetailDictionary objectForKey:[NSString stringWithFormat:@"%lld",[[DocsDictionary objectForKey:@"Zobjid"] longLongValue]]]) {
                                                NSMutableArray *Docs = [NSMutableArray array];
                                                [Docs addObject:@""];
                                                if ([DocsDictionary objectForKey:@"DocId"]) {
                                                    [Docs addObject:[[DocsDictionary objectForKey:@"DocId"] copy]];
                                                }
                                                else{
                                                    [Docs addObject:@""];
                                                }
                                                
                                                if ([DocsDictionary objectForKey:@"DocType"]) {
                                                    [Docs addObject:[[DocsDictionary objectForKey:@"DocType"] copy]];
                                                }
                                                else{
                                                    [Docs addObject:@""];
                                                }
                                                
                                                if ([DocsDictionary objectForKey:@"Filename"]) {
                                                    [Docs addObject:[[DocsDictionary objectForKey:@"Filename"] copy]];
                                                }
                                                else{
                                                    [Docs addObject:@""];
                                                }
                                                
                                                if ([DocsDictionary objectForKey:@"Filetype"]) {
                                                    [Docs addObject:[[DocsDictionary objectForKey:@"Filetype"] copy]];
                                                }
                                                else{
                                                    [Docs addObject:@""];
                                                }
                                                
                                                if ([DocsDictionary objectForKey:@"Fsize"]) {
                                                    [Docs addObject:[[DocsDictionary objectForKey:@"Fsize"] copy]];
                                                }
                                                else{
                                                    [Docs addObject:@""];
                                                }
                                                
                                                if ([DocsDictionary objectForKey:@"Objtype"]) {
                                                    [Docs addObject:[[DocsDictionary objectForKey:@"Objtype"] copy]];
                                                }
                                                else{
                                                    
                                                    [Docs addObject:@""];
                                                }
                                                
                                                [Docs addObject:@""];//Content
                                                [Docs addObject:@""];//Action
                                                
                                                [[[notificationDetailDictionary objectForKey:[DocsDictionary objectForKey:@"Zobjid"]] objectAtIndex:1] addObject:Docs];
                                            }
                                        }
                                    }
                                }
                                
                                responseObject = nil;
                                NSMutableArray *notificationTransactionArray = [[NSMutableArray alloc] init];
                                
                                if ([parsedDictionary objectForKey:@"resultTransactions"]) {
                                    responseObject = [parsedDictionary objectForKey:@"resultTransactions"];
                                    
                                    [notificationTransactionArray addObjectsFromArray:responseObject];
                                    
                                    NSDictionary *transactionDictionary;
                                    
                                    for (int i=0; i<[notificationTransactionArray count]; i++) {
                                        if ([[notificationTransactionArray objectAtIndex:i] isKindOfClass:[NSDictionary class]]) {
                                            transactionDictionary = [notificationTransactionArray objectAtIndex:i];
                                            if ([notificationDetailDictionary objectForKey:[transactionDictionary objectForKey:@"Qmnum"]]) {
                                                NSMutableArray *transactions = [NSMutableArray array];
                                                
                                                [transactions addObject:@""];
                                                [transactions addObject:@""];
                                                if ([transactionDictionary objectForKey:@"ItemdefectGrp"]) {
                                                    [transactions addObject:[[transactionDictionary objectForKey:@"ItemdefectGrp"] copy]];
                                                }
                                                else{
                                                    [transactions addObject:@""];
                                                }
                                                
                                                if ([transactionDictionary objectForKey:@"Defectgrptext"]) {
                                                    [transactions addObject:[[transactionDictionary objectForKey:@"Defectgrptext"] copy]];
                                                }
                                                else{
                                                    [transactions addObject:@""];
                                                }
                                                
                                                if ([transactionDictionary objectForKey:@"ItemdefectCod"]) {
                                                    [transactions addObject:[[transactionDictionary objectForKey:@"ItemdefectCod"] copy]];
                                                }
                                                else{
                                                    [transactions addObject:@""];
                                                }
                                                
                                                if ([transactionDictionary objectForKey:@"Defectcodetext"]) {
                                                    [transactions addObject:[[transactionDictionary objectForKey:@"Defectcodetext"] copy]];
                                                }
                                                else{
                                                    [transactions addObject:@""];
                                                    
                                                }
                                                
                                                if ([transactionDictionary objectForKey:@"CauseGrp"]) {
                                                    [transactions addObject:[[transactionDictionary objectForKey:@"CauseGrp"] copy]];
                                                }
                                                else{
                                                    [transactions addObject:@""];
                                                }
                                                
                                                if ([transactionDictionary objectForKey:@"Causegrptext"]) {
                                                    [transactions addObject:[[transactionDictionary objectForKey:@"Causegrptext"] copy]];
                                                }
                                                else{
                                                    [transactions addObject:@""];
                                                }
                                                
                                                if ([transactionDictionary objectForKey:@"CauseCod"]) {
                                                    [transactions addObject:[[transactionDictionary objectForKey:@"CauseCod"] copy]];
                                                }
                                                else{
                                                    [transactions addObject:@""];
                                                }
                                                
                                                if ([transactionDictionary objectForKey:@"Causecodetext"]) {
                                                    [transactions addObject:[[transactionDictionary objectForKey:@"Causecodetext"] copy]];
                                                }
                                                else{
                                                    [transactions addObject:@""];
                                                }
                                                
                                                if ([transactionDictionary objectForKey:@"ItemdefectShtxt"]) {
                                                    [transactions addObject:[[transactionDictionary objectForKey:@"ItemdefectShtxt"] copy]];
                                                }
                                                else{
                                                    [transactions addObject:@""];
                                                }
                                                if ([transactionDictionary objectForKey:@"CauseShtxt"]) {
                                                    [transactions addObject:[[transactionDictionary objectForKey:@"CauseShtxt"] copy]];
                                                }
                                                else{
                                                    [transactions addObject:@""];
                                                }
                                                
                                                if ([transactionDictionary objectForKey:@"ItemKey"]) {
                                                    [transactions addObject:[[transactionDictionary objectForKey:@"ItemKey"] copy]];
                                                }
                                                else{
                                                    [transactions addObject:@""];
                                                }
                                                
                                                if ([transactionDictionary objectForKey:@"CauseKey"]) {
                                                    [transactions addObject:[[transactionDictionary objectForKey:@"CauseKey"] copy]];
                                                }
                                                else{
                                                    [transactions addObject:@""];
                                                }
                                                
                                                [transactions addObject:@""];//Component Status
                                                [transactions addObject:@""];//Item Status
                                                
                                                if ([transactionDictionary objectForKey:@"ItempartGrp"]) {
                                                    [transactions addObject:[transactionDictionary objectForKey:@"ItempartGrp"]];
                                                }
                                                else{
                                                    
                                                    [transactions addObject:@""];//objectPartGroupid
                                                }
                                                
                                                if ([transactionDictionary objectForKey:@"ItempartCod"]) {
                                                    [transactions addObject:[transactionDictionary objectForKey:@"ItempartCod"]];
                                                }
                                                else{
                                                    
                                                    [transactions addObject:@""];//ObjectPartid
                                                }
                                                
                                                if ([transactionDictionary objectForKey:@"Partgrptext"]) {
                                                    [transactions addObject:[transactionDictionary objectForKey:@"Partgrptext"]];
                                                }
                                                else{
                                                    
                                                    [transactions addObject:@""];//objectPartGrouptext
                                                }
                                                
                                                if ([transactionDictionary objectForKey:@"Partcodetext"])
                                                {
                                                    [transactions addObject:[transactionDictionary objectForKey:@"Partcodetext"]];
                                                }
                                                else{
                                                    
                                                    [transactions addObject:@""];//ObjectParttext
                                                }
                                                
                                                id customFieldsDamageTransactionsID,customFieldsCauseTransactionsID;
                                                if ([transactionDictionary objectForKey:@"Fields"]) {
                                                    NSArray *fieldsArray = [[transactionDictionary objectForKey:@"Fields"] objectForKey:@"item"];
                                                    NSMutableArray *transactionsDamageCustomFields = [NSMutableArray array];
                                                    NSMutableArray *transactionsCauseCustomFields = [NSMutableArray array];
                                                    for (int i =0; i<[fieldsArray count]; i++) {
                                                        NSString *fieldValue,*fieldName,*fLabel,*tabName,*docType,*docTypeItem,*dataType,*sequence,*length;
                                                        if ([NullChecker isNull:[[fieldsArray objectAtIndex:i] objectForKey:@"Fieldname"]]) {
                                                            fieldName = @"";
                                                        }
                                                        else{
                                                            fieldName = [[fieldsArray objectAtIndex:i] objectForKey:@"Fieldname"];
                                                        }
                                                        
                                                        if ([NullChecker isNull:[[fieldsArray objectAtIndex:i] objectForKey:@"Flabel"]]) {
                                                            fLabel = @"";
                                                        }
                                                        else{
                                                            fLabel = [[fieldsArray objectAtIndex:i] objectForKey:@"Flabel"];
                                                        }
                                                        
                                                        if ([NullChecker isNull:[[fieldsArray objectAtIndex:i] objectForKey:@"Tabname"]]) {
                                                            tabName = @"";
                                                        }
                                                        else{
                                                            tabName = [[fieldsArray objectAtIndex:i] objectForKey:@"Tabname"];
                                                        }
                                                        
                                                        if ([NullChecker isNull:[[fieldsArray objectAtIndex:i] objectForKey:@"Value"]]) {
                                                            fieldValue = @"";
                                                        }
                                                        else{
                                                            fieldValue = [[fieldsArray objectAtIndex:i] objectForKey:@"Value"];
                                                        }
                                                        
                                                        if ([NullChecker isNull:[[fieldsArray objectAtIndex:i] objectForKey:@"Zdoctype"]]) {
                                                            docType = @"";
                                                        }
                                                        else{
                                                            docType = [[fieldsArray objectAtIndex:i] objectForKey:@"Zdoctype"];
                                                        }
                                                        
                                                        if ([NullChecker isNull:[[fieldsArray objectAtIndex:i] objectForKey:@"ZdoctypeItem"]]) {
                                                            docTypeItem = @"";
                                                        }
                                                        else{
                                                            docTypeItem = [[fieldsArray objectAtIndex:i] objectForKey:@"ZdoctypeItem"];
                                                        }
                                                        
                                                        
                                                        if ([NullChecker isNull:[[fieldsArray objectAtIndex:i] objectForKey:@"Datatype"]]) {
                                                            dataType = @"";
                                                        }
                                                        else{
                                                            dataType = [[fieldsArray objectAtIndex:i] objectForKey:@"Datatype"];
                                                        }
                                                        
                                                        if ([NullChecker isNull:[[fieldsArray objectAtIndex:i] objectForKey:@"Sequence"]]) {
                                                            sequence = @"";
                                                        }
                                                        else{
                                                            sequence = [[fieldsArray objectAtIndex:i] objectForKey:@"Sequence"];
                                                        }
                                                        
                                                        if ([NullChecker isNull:[[fieldsArray objectAtIndex:i] objectForKey:@"Length"]]) {
                                                            length = @"";
                                                        }
                                                        else{
                                                            length = [[fieldsArray objectAtIndex:i] objectForKey:@"Length"];
                                                        }
                                                        
                                                        if ([docTypeItem isEqualToString:@"QI"]) {
                                                            [transactionsDamageCustomFields addObject:[NSMutableArray arrayWithObjects:docType,docTypeItem,tabName,fieldName,fieldValue,fLabel,dataType,sequence,length, nil]];
                                                        }
                                                        else if ([docTypeItem isEqualToString:@"QC"]){
                                                            [transactionsCauseCustomFields addObject:[NSMutableArray arrayWithObjects:docType,docTypeItem,tabName,fieldName,fieldValue,fLabel,dataType,sequence,length, nil]];
                                                        }
                                                    }
                                                    
                                                    customFieldsDamageTransactionsID = transactionsDamageCustomFields;
                                                    customFieldsCauseTransactionsID = transactionsCauseCustomFields;
                                                }
                                                
                                                [[[notificationDetailDictionary objectForKey:[transactionDictionary objectForKey:@"Qmnum"]] objectAtIndex:2] addObject:[NSArray arrayWithObjects:transactions,customFieldsDamageTransactionsID,customFieldsCauseTransactionsID, nil]];
                                            }
                                        }
                                    }
                                    
                                    [notificationTransactionArray removeAllObjects];
                                }
                                
                                
                                responseObject = nil;
                                NSMutableArray *notificationActivitiesArray = [[NSMutableArray alloc] init];
                                
                                if ([parsedDictionary objectForKey:@"resultActivities"]) {
                                    responseObject = [parsedDictionary objectForKey:@"resultActivities"];
                                    
                                    [notificationActivitiesArray addObjectsFromArray:responseObject];
                                    
                                    NSDictionary *activitiesDictionary;
                                    
                                    for (int i=0; i<[notificationActivitiesArray count]; i++) {
                                        if ([[notificationActivitiesArray objectAtIndex:i] isKindOfClass:[NSDictionary class]]) {
                                            activitiesDictionary = [notificationTransactionArray objectAtIndex:i];
                                            if ([notificationDetailDictionary objectForKey:[NSString stringWithFormat:@"%lli",[[activitiesDictionary objectForKey:@"Qmnum"] longLongValue]]]) {
                                                
                                                
                                                NSMutableDictionary *resulActivityDictionary=[NSMutableDictionary new];
                                                
                                                [resulActivityDictionary setObject:@"" forKey:@"notificationa_id"];
                                                
                                                [resulActivityDictionary setObject:@"" forKey:@"notificationa_header_id"];
                                                
 
                                            if ([activitiesDictionary objectForKey:@"Actcodetext"]) {
 
                                                 [resulActivityDictionary setObject:[[activitiesDictionary objectForKey:@"Actcodetext"] copy] forKey:@"notificationa_Actcodetext"];
                                                    
                                                }
                                                else{
 
                                                    [resulActivityDictionary setObject:@"" forKey:@"notificationa_Actgrptext"];
                                                    
                                                 }
                                                
                                                if ([activitiesDictionary objectForKey:@"Actgrptext"]) {
 
                                                     [resulActivityDictionary setObject:[[activitiesDictionary objectForKey:@"Actgrptext"] copy] forKey:@"notificationa_Actgrptext"];
 
                                                }
                                                else{
 
                                                    [resulActivityDictionary setObject:@"" forKey:@"notificationa_Actgrptext"];

                                                }
                                                
                                                if ([activitiesDictionary objectForKey:@"Action"]) {
 
                                                    [resulActivityDictionary setObject:[activitiesDictionary objectForKey:@"Action"] forKey:@"notificationa_Action"];

                                                }
                                                else{
 
                                                    [resulActivityDictionary setObject:@"" forKey:@"notificationa_Action"];

                                                }
                                                
                                                if ([activitiesDictionary objectForKey:@"ActvCod"]) {
                                                    
                                                    [resulActivityDictionary setObject:[activitiesDictionary objectForKey:@"ActvCod"] forKey:@"notificationa_ActvCod"];

                                                    
                                                }
                                                else{
                                                   
                                                    [resulActivityDictionary setObject:@"" forKey:@"notificationa_ActvCod"];
                                                    
                                                }
                                                
                                                if ([activitiesDictionary objectForKey:@"ActvGrp"]) {
 
                                                [resulActivityDictionary setObject:[[activitiesDictionary objectForKey:@"notificationa_ActvGrp"] copy] forKey:@"notificationa_ActvCod"];
                                                    
                                                }
                                                else{
                                                    
                                                    [resulActivityDictionary setObject:@"" forKey:@"notificationa_ActvCod"];
                                                }
                                                
                                                if ([activitiesDictionary objectForKey:@"ActvKey"]) {
 
                                                    [resulActivityDictionary setObject:[[activitiesDictionary objectForKey:@"ActvKey"] copy] forKey:@"notificationa_ActvKey"];
                                                    
                                                }
                                                else{
 
                                                    [resulActivityDictionary setObject:@"" forKey:@"notificationa_ActvKey"];

                                                }
                                                
                                                if ([activitiesDictionary objectForKey:@"ActvShtxt"]) {

                                                    [resulActivityDictionary setObject:[[activitiesDictionary objectForKey:@"ActvShtxt"] copy] forKey:@"notificationa_ActvShtxt"];

                                                }
                                                else{
                                                    
                                                    [resulActivityDictionary setObject:@"" forKey:@"notificationa_ActvShtxt"];
                                                }
                                                
                                                if ([activitiesDictionary objectForKey:@"CauseKey"]) {
                                                    [resulActivityDictionary setObject:[[activitiesDictionary objectForKey:@"CauseKey"] copy] forKey:@"notificationa_CauseKey"];
                                                }
                                                else{
                                                    [resulActivityDictionary setObject:@"" forKey:@"notificationa_CauseKey"];
                                                }
                                                
                                                if ([activitiesDictionary objectForKey:@"Defectcodetext"]) {
 
                                                    [resulActivityDictionary setObject:[[activitiesDictionary objectForKey:@"Defectcodetext"] copy] forKey:@"notificationa_Defectcodetext"];

                                                }
                                                else{
                                                    [resulActivityDictionary setObject:@"" forKey:@"notificationa_Defectcodetext"];
                                                }
                                                
                                                if ([activitiesDictionary objectForKey:@"Defectgrptext"]) {
                                                    
                                                    [resulActivityDictionary setObject:[[activitiesDictionary objectForKey:@"Defectgrptext"] copy] forKey:@"notificationa_Defectgrptext"];
                                                }
                                                else{
                                                    
                                                    [resulActivityDictionary setObject:@"" forKey:@"notificationa_Defectgrptext"];

                                                }
                                                
                                                if ([activitiesDictionary objectForKey:@"ItemKey"]) {
 
                                                    [resulActivityDictionary setObject:[[activitiesDictionary objectForKey:@"ItemKey"] copy] forKey:@"notificationa_ItemKey"];

                                                }
                                                else{
                                                    
                                                    [resulActivityDictionary setObject:[[activitiesDictionary objectForKey:@"ItemKey"] copy] forKey:@"notificationa_ItemdefectCod"];
                                                    
                                                }
                                                
                                                if ([activitiesDictionary objectForKey:@"ItemdefectCod"]) {
                                                    
                                                    [resulActivityDictionary setObject:[[activitiesDictionary objectForKey:@"ItemdefectCod"] copy] forKey:@"notificationa_ItemdefectCod"];
                                                }
                                                else{
                                                    [resulActivityDictionary setObject:@"" forKey:@"notificationa_ItemdefectCod"];
                                                }
                                                
                                                
                                                if ([activitiesDictionary objectForKey:@"ItemdefectGrp"]) {
                                                    [resulActivityDictionary setObject:[[activitiesDictionary objectForKey:@"ItemdefectGrp"] copy] forKey:@"notificationa_ItemdefectGrp"];
                                                }
                                                else{
                                                    
                                                    [resulActivityDictionary setObject:@"" forKey:@"notificationa_ItemdefectGrp"];

                                                }
                                                
                                                if ([activitiesDictionary objectForKey:@"ItemdefectShtxt"]) {
 
                                                    [resulActivityDictionary setObject:[[activitiesDictionary objectForKey:@"ItemdefectShtxt"] copy] forKey:@"notificationa_ItemdefectShtxt"];

                                                }
                                                else{
                                                    
                                                    [resulActivityDictionary setObject:@"" forKey:@"notificationa_ItemdefectShtxt"];
                                                    
                                                }
                                                
                                                if ([activitiesDictionary objectForKey:@"ItempartCod"]) {
 
                                                    [resulActivityDictionary setObject:[[activitiesDictionary objectForKey:@"ItempartCod"] copy] forKey:@"notificationa_ItempartCod"];

                                                 }
                                                else{
                                                    
                                                    [resulActivityDictionary setObject:@"" forKey:@"notificationa_ItempartCod"];
                                                    
                                                }
                                                
                                                if ([activitiesDictionary objectForKey:@"ItempartGrp"])
                                                {
 
                                                    [resulActivityDictionary setObject:[[activitiesDictionary objectForKey:@"ItempartGrp"] copy] forKey:@"notificationa_ItempartGrp"];

                                                }
                                                else{
                                                    
                                                    [resulActivityDictionary setObject:@"" forKey:@"notificationa_ItempartGrp"];
                                                    
                                                }
                                                
                                                if ([activitiesDictionary objectForKey:@"Partcodetext"])
                                                {
                                                    [resulActivityDictionary setObject:[[activitiesDictionary objectForKey:@"Partcodetext"] copy] forKey:@"notificationa_Partcodetext"];
                                                    
                                                }
                                                else{
                                                    
                                                    [resulActivityDictionary setObject:@"" forKey:@"notificationa_Partcodetext"];
                                                    
                                                }
                                                
                                                if ([activitiesDictionary objectForKey:@"Partgrptext"])
                                                {
 
                                                    [resulActivityDictionary setObject:[[activitiesDictionary objectForKey:@"Partgrptext"] copy] forKey:@"notificationa_Partgrptext"];

                                                }
                                                else{
                                                    
                                                    [resulActivityDictionary setObject:@"" forKey:@"notificationa_Partgrptext"];
                                                    
                                                }
                                                
                                                if ([activitiesDictionary objectForKey:@"Qmnum"])
                                                {
                                                    [resulActivityDictionary setObject:[[activitiesDictionary objectForKey:@"Qmnum"] copy] forKey:@"Qmnum"];
                                                    
                                                }
                                                else{
                                                    
                                                    [resulActivityDictionary setObject:@"" forKey:@"Qmnum"];
                                                    
                                                }
                                                
                                                if ([activitiesDictionary objectForKey:@"Usr01"])
                                                {
                                                    [resulActivityDictionary setObject:[[activitiesDictionary objectForKey:@"Usr01"] copy] forKey:@"Qmnum"];
                                                }
                                                else{
                                                    
                                                    [resulActivityDictionary setObject:@"" forKey:@"Usr01"];
                                                    
                                                }
                                                
                                                if ([activitiesDictionary objectForKey:@"Usr02"])
                                                {
 
                                                    [resulActivityDictionary setObject:[[activitiesDictionary objectForKey:@"Usr02"] copy] forKey:@"Usr02"];

                                                }
                                                else{
                                                    
                                                    [resulActivityDictionary setObject:@"" forKey:@"Usr02"];
                                                    
                                                }
                                                
                                                if ([activitiesDictionary objectForKey:@"Usr03"])
                                                {
 
                                                    [resulActivityDictionary setObject:[[activitiesDictionary objectForKey:@"Usr03"] copy] forKey:@"Usr03"];

                                                }
                                                else{
                                                    
                                                    [resulActivityDictionary setObject:@"" forKey:@"Usr03"];
                                                    
                                                }
                                                
                                                if ([activitiesDictionary objectForKey:@"Usr04"])
                                                {
 
                                                    [resulActivityDictionary setObject:[[activitiesDictionary objectForKey:@"Usr04"] copy] forKey:@"Usr04"];

                                                }
                                                else{
                                                    
                                                    [resulActivityDictionary setObject:@"" forKey:@"Usr04"];
                                                    
                                                }
                                                
                                                if ([activitiesDictionary objectForKey:@"Usr05"])
                                                {
                                                    [resulActivityDictionary setObject:[[activitiesDictionary objectForKey:@"Usr05"] copy] forKey:@"Usr05"];
                                                }
                                                else{
                                                    
                                                    [resulActivityDictionary setObject:@"" forKey:@"Usr05"];
                                                    
                                                }
 
                                                id customFieldsDamageTransactionsID,customFieldsCauseTransactionsID;
                                                
                                                if ([activitiesDictionary objectForKey:@"Fields"]) {
                                                    NSArray *fieldsArray = [[activitiesDictionary objectForKey:@"Fields"] objectForKey:@"item"];
                                                    NSMutableArray *transactionsDamageCustomFields = [NSMutableArray array];
                                                    NSMutableArray *transactionsCauseCustomFields = [NSMutableArray array];
                                                    for (int i =0; i<[fieldsArray count]; i++) {
                                                        NSString *fieldValue,*fieldName,*fLabel,*tabName,*docType,*docTypeItem,*dataType,*sequence,*length;
                                                        if ([NullChecker isNull:[[fieldsArray objectAtIndex:i] objectForKey:@"Fieldname"]]) {
                                                            fieldName = @"";
                                                        }
                                                        else{
                                                            fieldName = [[fieldsArray objectAtIndex:i] objectForKey:@"Fieldname"];
                                                        }
                                                        
                                                        if ([NullChecker isNull:[[fieldsArray objectAtIndex:i] objectForKey:@"Flabel"]]) {
                                                            fLabel = @"";
                                                        }
                                                        else{
                                                            fLabel = [[fieldsArray objectAtIndex:i] objectForKey:@"Flabel"];
                                                        }
                                                        
                                                        if ([NullChecker isNull:[[fieldsArray objectAtIndex:i] objectForKey:@"Tabname"]]) {
                                                            tabName = @"";
                                                        }
                                                        else{
                                                            tabName = [[fieldsArray objectAtIndex:i] objectForKey:@"Tabname"];
                                                        }
                                                        
                                                        if ([NullChecker isNull:[[fieldsArray objectAtIndex:i] objectForKey:@"Value"]]) {
                                                            fieldValue = @"";
                                                        }
                                                        else{
                                                            fieldValue = [[fieldsArray objectAtIndex:i] objectForKey:@"Value"];
                                                        }
                                                        
                                                        if ([NullChecker isNull:[[fieldsArray objectAtIndex:i] objectForKey:@"Zdoctype"]]) {
                                                            docType = @"";
                                                        }
                                                        else{
                                                            docType = [[fieldsArray objectAtIndex:i] objectForKey:@"Zdoctype"];
                                                        }
                                                        
                                                        if ([NullChecker isNull:[[fieldsArray objectAtIndex:i] objectForKey:@"ZdoctypeItem"]]) {
                                                            docTypeItem = @"";
                                                        }
                                                        else{
                                                            docTypeItem = [[fieldsArray objectAtIndex:i] objectForKey:@"ZdoctypeItem"];
                                                        }
                                                        
                                                        
                                                        if ([NullChecker isNull:[[fieldsArray objectAtIndex:i] objectForKey:@"Datatype"]]) {
                                                            dataType = @"";
                                                        }
                                                        else{
                                                            dataType = [[fieldsArray objectAtIndex:i] objectForKey:@"Datatype"];
                                                        }
                                                        
                                                        if ([NullChecker isNull:[[fieldsArray objectAtIndex:i] objectForKey:@"Sequence"]]) {
                                                            sequence = @"";
                                                        }
                                                        else{
                                                            sequence = [[fieldsArray objectAtIndex:i] objectForKey:@"Sequence"];
                                                        }
                                                        
                                                        if ([NullChecker isNull:[[fieldsArray objectAtIndex:i] objectForKey:@"Length"]]) {
                                                            length = @"";
                                                        }
                                                        else{
                                                            length = [[fieldsArray objectAtIndex:i] objectForKey:@"Length"];
                                                        }
                                                        
                                                        if ([docTypeItem isEqualToString:@"QI"]) {
                                                            [transactionsDamageCustomFields addObject:[NSMutableArray arrayWithObjects:docType,docTypeItem,tabName,fieldName,fieldValue,fLabel,dataType,sequence,length, nil]];
                                                        }
                                                        else if ([docTypeItem isEqualToString:@"QC"]){
                                                            [transactionsCauseCustomFields addObject:[NSMutableArray arrayWithObjects:docType,docTypeItem,tabName,fieldName,fieldValue,fLabel,dataType,sequence,length, nil]];
                                                        }
                                                    }
                                                    
                                                    customFieldsDamageTransactionsID = transactionsDamageCustomFields;
                                                    customFieldsCauseTransactionsID = transactionsCauseCustomFields;
                                                }
                                                
                                                [[[notificationDetailDictionary objectForKey:[NSString stringWithFormat:@"%lli",[[activitiesDictionary objectForKey:@"Qmnum"] longLongValue]]] objectAtIndex:3] addObject:[NSArray arrayWithObjects:resulActivityDictionary,[NSMutableArray array],[NSMutableArray array], nil]];
                                            }
                                        }
                                    }
                                    
                                    [notificationActivitiesArray removeAllObjects];
                                }
                                
                                responseObject = nil;
                                NSMutableArray *notificationTasksArray = [[NSMutableArray alloc] init];
                                
                                if ([parsedDictionary objectForKey:@"resultTasks"]) {
                                    
                                    responseObject = [parsedDictionary objectForKey:@"resultTasks"];
                                    
                                    [notificationTasksArray addObjectsFromArray:responseObject];
                                    
                                    NSDictionary *tasksDictionary;
                                    
                                    for (int i=0; i<[notificationTasksArray count]; i++) {
                                        
                                        if ([[notificationTasksArray objectAtIndex:i] isKindOfClass:[NSDictionary class]]) {
                                            tasksDictionary = [notificationTasksArray objectAtIndex:i];
                                            if ([notificationDetailDictionary objectForKey:[NSString stringWithFormat:@"%lli",[[tasksDictionary objectForKey:@"Qmnum"] longLongValue]]]) {
                                                
                                                NSMutableArray *tasks = [NSMutableArray array];
                                                
                                                [tasks addObject:@""];
                                                [tasks addObject:@""];
                                                
                                                if ([tasksDictionary objectForKey:@"TaskKey"]) {
                                                    [tasks addObject:[[tasksDictionary objectForKey:@"TaskKey"] copy]];
                                                }
                                                else{
                                                    [tasks addObject:@""];
                                                }
                                                
                                                if ([tasksDictionary objectForKey:@"TaskGrp"]) {
                                                    [tasks addObject:[[tasksDictionary objectForKey:@"TaskGrp"] copy]];
                                                }
                                                else{
                                                    [tasks addObject:@""];
                                                }
                                                
                                                if ([tasksDictionary objectForKey:@"Taskgrptext"]) {
                                                    [tasks addObject:[[tasksDictionary objectForKey:@"Taskgrptext"] copy]];
                                                }
                                                else{
                                                    [tasks addObject:@""];
                                                }
                                                
                                                if ([tasksDictionary objectForKey:@"TaskCod"]) {
                                                    [tasks addObject:[tasksDictionary objectForKey:@"TaskCod"]];
                                                }
                                                else{
                                                    
                                                    [tasks addObject:@""];
                                                }
                                                
                                                if ([tasksDictionary objectForKey:@"Taskcodetext"]) {
                                                    [tasks addObject:[tasksDictionary objectForKey:@"Taskcodetext"]];
                                                }
                                                else{
                                                    
                                                    [tasks addObject:@""];
                                                }
                                                
                                                if ([tasksDictionary objectForKey:@"TaskShtxt"]) {
                                                    [tasks addObject:[tasksDictionary objectForKey:@"TaskShtxt"]];
                                                }
                                                else{
                                                    
                                                    [tasks addObject:@""];
                                                }
                                                
                                                if ([tasksDictionary objectForKey:@"Parvw"])
                                                {
                                                    [tasks addObject:[tasksDictionary objectForKey:@"Parvw"]];
                                                }
                                                else{
                                                    
                                                    [tasks addObject:@""];
                                                }
                                                
                                                [tasks addObject:@""];//processername
                                                
                                                if ([tasksDictionary objectForKey:@"Parnr"])
                                                {
                                                    [tasks addObject:[tasksDictionary objectForKey:@"Parnr"]];
                                                }
                                                else{
                                                    
                                                    [tasks addObject:@""];
                                                }
                                                
                                                if ([tasksDictionary objectForKey:@"Pster"])
                                                {
                                                    [tasks addObject:[tasksDictionary objectForKey:@"Pster"]];
                                                }
                                                else{
                                                    
                                                    [tasks addObject:@""];
                                                }
                                                
                                                if ([tasksDictionary objectForKey:@"Peter"])
                                                {
                                                    [tasks addObject:[tasksDictionary objectForKey:@"Peter"]];
                                                }
                                                else{
                                                    
                                                    [tasks addObject:@""];
                                                }
                                                
                                                if ([tasksDictionary objectForKey:@"Release"]) {
                                                    [tasks addObject:[tasksDictionary objectForKey:@"Release"]];
                                                }
                                                else{
                                                    
                                                    [tasks addObject:@""];
                                                }
                                                
                                                if ([tasksDictionary objectForKey:@"Complete"]) {
                                                    [tasks addObject:[tasksDictionary objectForKey:@"Complete"]];
                                                }
                                                else{
                                                    
                                                    [tasks addObject:@""];
                                                }
                                                
                                                if ([tasksDictionary objectForKey:@"Success"]) {
                                                    [tasks addObject:[tasksDictionary objectForKey:@"Success"]];
                                                }
                                                else{
                                                    
                                                    [tasks addObject:@""];
                                                }
                                                
                                                if ([tasksDictionary objectForKey:@"ItemKey"]) {
                                                    [tasks addObject:[tasksDictionary objectForKey:@"ItemKey"]];
                                                }
                                                else{
                                                    
                                                    [tasks addObject:@""];
                                                }
                                                
                                                
                                                [tasks addObject:@""];//item status
                                                
                                                ////////////////
                                                
                                                if ([tasksDictionary objectForKey:@"ItempartGrp"]) {
                                                    [tasks addObject:[[tasksDictionary objectForKey:@"ItempartGrp"] copy]];
                                                }
                                                else{
                                                    [tasks addObject:@""];
                                                }
                                                
                                                if ([tasksDictionary objectForKey:@"Partgrptext"]) {
                                                    [tasks addObject:[[tasksDictionary objectForKey:@"Partgrptext"] copy]];
                                                }
                                                else{
                                                    [tasks addObject:@""];
                                                }
                                                
                                                if ([tasksDictionary objectForKey:@"ItempartCod"]) {
                                                    [tasks addObject:[[tasksDictionary objectForKey:@"ItempartCod"] copy]];
                                                }
                                                else{
                                                    [tasks addObject:@""];
                                                }
                                                
                                                if ([tasksDictionary objectForKey:@"Partcodetext"]) {
                                                    [tasks addObject:[[tasksDictionary objectForKey:@"Partcodetext"] copy]];
                                                }
                                                else{
                                                    [tasks addObject:@""];
                                                    
                                                }
                                                
                                                if ([tasksDictionary objectForKey:@"ItemdefectGrp"]) {
                                                    [tasks addObject:[[tasksDictionary objectForKey:@"ItemdefectGrp"] copy]];
                                                }
                                                else{
                                                    [tasks addObject:@""];
                                                }
                                                
                                                if ([tasksDictionary objectForKey:@"Defectgrptext"]) {
                                                    [tasks addObject:[[tasksDictionary objectForKey:@"Defectgrptext"] copy]];
                                                }
                                                else{
                                                    [tasks addObject:@""];
                                                }
                                                
                                                if ([tasksDictionary objectForKey:@"ItemdefectCod"]) {
                                                    [tasks addObject:[[tasksDictionary objectForKey:@"ItemdefectCod"] copy]];
                                                }
                                                else{
                                                    [tasks addObject:@""];
                                                }
                                                
                                                if ([tasksDictionary objectForKey:@"Defectcodetext"]) {
                                                    [tasks addObject:[[tasksDictionary objectForKey:@"Defectcodetext"] copy]];
                                                }
                                                else{
                                                    [tasks addObject:@""];
                                                }
                                                
                                                if ([tasksDictionary objectForKey:@"ItemdefectShtxt"]) {
                                                    [tasks addObject:[[tasksDictionary objectForKey:@"ItemdefectShtxt"] copy]];
                                                }
                                                else{
                                                    [tasks addObject:@""];
                                                }
                                                
                                                if ([tasksDictionary objectForKey:@"UserStatus"]) {
                                                    [tasks addObject:[tasksDictionary objectForKey:@"UserStatus"]];
                                                }
                                                else{
                                                    
                                                    [tasks addObject:@""];
                                                }
                                                
                                                if ([tasksDictionary objectForKey:@"SysStatus"]) {
                                                    [tasks addObject:[tasksDictionary objectForKey:@"SysStatus"]];
                                                }
                                                else{
                                                    
                                                    [tasks addObject:@""];
                                                }
                                                
                                                if ([tasksDictionary objectForKey:@"Smsttxt"]) {
                                                    [tasks addObject:[tasksDictionary objectForKey:@"Smsttxt"]];
                                                }
                                                else{
                                                    
                                                    [tasks addObject:@""];
                                                }
                                                
                                                if ([tasksDictionary objectForKey:@"Smastxt"]) {
                                                    [tasks addObject:[tasksDictionary objectForKey:@"Smastxt"]];
                                                }
                                                else{
                                                    
                                                    [tasks addObject:@""];
                                                }
                                                
                                                if ([tasksDictionary objectForKey:@"Usr01"]) {
                                                    [tasks addObject:[tasksDictionary objectForKey:@"Usr01"]];
                                                }
                                                else{
                                                    
                                                    [tasks addObject:@""];
                                                }
                                                
                                                if ([tasksDictionary objectForKey:@"Usr02"]) {
                                                    [tasks addObject:[tasksDictionary objectForKey:@"Usr02"]];
                                                }
                                                else{
                                                    
                                                    [tasks addObject:@""];
                                                }
                                                
                                                if ([tasksDictionary objectForKey:@"Usr03"]) {
                                                    [tasks addObject:[tasksDictionary objectForKey:@"Usr03"]];
                                                }
                                                else{
                                                    
                                                    [tasks addObject:@""];
                                                }
                                                
                                                if ([tasksDictionary objectForKey:@"Usr04"]) {
                                                    [tasks addObject:[tasksDictionary objectForKey:@"Usr04"]];
                                                }
                                                else{
                                                    
                                                    [tasks addObject:@""];
                                                }
                                                
                                                if ([tasksDictionary objectForKey:@"Usr05"]) {
                                                    [tasks addObject:[tasksDictionary objectForKey:@"Usr05"]];
                                                }
                                                else{
                                                    
                                                    [tasks addObject:@""];
                                                }
                                                
                                                if ([tasksDictionary objectForKey:@"Pstur"]) {
                                                    [tasks addObject:[[tasksDictionary objectForKey:@"Pstur"] copy]];
                                                }
                                                else{
                                                    [tasks addObject:@""];
                                                }
                                                
                                                if ([tasksDictionary objectForKey:@"Petur"]) {
                                                    [tasks addObject:[[tasksDictionary objectForKey:@"Petur"] copy]];
                                                }
                                                else{
                                                    [tasks addObject:@""];
                                                }
                                                
                                                if ([tasksDictionary objectForKey:@"Erldat"]) {
                                                    [tasks addObject:[[tasksDictionary objectForKey:@"Erldat"] copy]];
                                                }
                                                else{
                                                    [tasks addObject:@""];
                                                }
                                                
                                                if ([tasksDictionary objectForKey:@"Erlzeit"]) {
                                                    [tasks addObject:[[tasksDictionary objectForKey:@"Erlzeit"] copy]];
                                                }
                                                else{
                                                    [tasks addObject:@""];
                                                }
                                                
                                                if ([tasksDictionary objectForKey:@"Erlnam"]) {
                                                    [tasks addObject:[[tasksDictionary objectForKey:@"Erlnam"] copy]];
                                                }
                                                else{
                                                    [tasks addObject:@""];
                                                }
                                                
                                                
                                                id customFieldsTaskTransactionsID;
                                                if ([tasksDictionary objectForKey:@"Fields"]) {
                                                    
                                                    NSMutableArray *fieldsArray=[NSMutableArray new];
                                                    if ([[[tasksDictionary objectForKey:@"Fields"] objectForKey:@"item"] isKindOfClass:[NSDictionary class]]) {
                                                        
                                                        [fieldsArray addObjectsFromArray:[NSMutableArray arrayWithObject:[[tasksDictionary objectForKey:@"Fields"] objectForKey:@"item"]]];
                                                    }
                                                    else if ([[[tasksDictionary objectForKey:@"Fields"] objectForKey:@"item"] isKindOfClass:[NSArray class]]){
                                                        
                                                        [fieldsArray addObjectsFromArray:[[tasksDictionary objectForKey:@"Fields"] objectForKey:@"item"]];
                                                    }
                                                    
                                                    NSMutableArray *taskCodeCustomFields = [NSMutableArray array];
                                                    
                                                    for (int i =0; i<[fieldsArray count]; i++) {
                                                        NSString *fieldValue,*fieldName,*fLabel,*tabName,*docType,*docTypeItem,*dataType,*sequence,*length;
                                                        if ([NullChecker isNull:[[fieldsArray objectAtIndex:i] objectForKey:@"Fieldname"]]) {
                                                            fieldName = @"";
                                                        }
                                                        else{
                                                            fieldName = [[fieldsArray objectAtIndex:i] objectForKey:@"Fieldname"];
                                                        }
                                                        
                                                        if ([NullChecker isNull:[[fieldsArray objectAtIndex:i] objectForKey:@"Flabel"]]) {
                                                            fLabel = @"";
                                                        }
                                                        else{
                                                            fLabel = [[fieldsArray objectAtIndex:i] objectForKey:@"Flabel"];
                                                        }
                                                        
                                                        if ([NullChecker isNull:[[fieldsArray objectAtIndex:i] objectForKey:@"Tabname"]]) {
                                                            tabName = @"";
                                                        }
                                                        else{
                                                            tabName = [[fieldsArray objectAtIndex:i] objectForKey:@"Tabname"];
                                                        }
                                                        
                                                        if ([NullChecker isNull:[[fieldsArray objectAtIndex:i] objectForKey:@"Value"]]) {
                                                            fieldValue = @"";
                                                        }
                                                        else{
                                                            fieldValue = [[fieldsArray objectAtIndex:i] objectForKey:@"Value"];
                                                        }
                                                        
                                                        if ([NullChecker isNull:[[fieldsArray objectAtIndex:i] objectForKey:@"Zdoctype"]]) {
                                                            docType = @"";
                                                        }
                                                        else{
                                                            docType = [[fieldsArray objectAtIndex:i] objectForKey:@"Zdoctype"];
                                                        }
                                                        
                                                        if ([NullChecker isNull:[[fieldsArray objectAtIndex:i] objectForKey:@"ZdoctypeItem"]]) {
                                                            docTypeItem = @"";
                                                        }
                                                        else{
                                                            docTypeItem = [[fieldsArray objectAtIndex:i] objectForKey:@"ZdoctypeItem"];
                                                        }
                                                        
                                                        
                                                        if ([NullChecker isNull:[[fieldsArray objectAtIndex:i] objectForKey:@"Datatype"]]) {
                                                            dataType = @"";
                                                        }
                                                        else{
                                                            dataType = [[fieldsArray objectAtIndex:i] objectForKey:@"Datatype"];
                                                        }
                                                        
                                                        if ([NullChecker isNull:[[fieldsArray objectAtIndex:i] objectForKey:@"Sequence"]]) {
                                                            sequence = @"";
                                                        }
                                                        else{
                                                            sequence = [[fieldsArray objectAtIndex:i] objectForKey:@"Sequence"];
                                                        }
                                                        
                                                        if ([NullChecker isNull:[[fieldsArray objectAtIndex:i] objectForKey:@"Length"]]) {
                                                            length = @"";
                                                        }
                                                        else{
                                                            length = [[fieldsArray objectAtIndex:i] objectForKey:@"Length"];
                                                        }
                                                        
                                                        if ([docTypeItem isEqualToString:@"QT"]) {
                                                            [taskCodeCustomFields addObject:[NSMutableArray arrayWithObjects:docType,docTypeItem,tabName,fieldName,fieldValue,fLabel,dataType,sequence,length, nil]];
                                                        }
                                                        
                                                    }
                                                    
                                                    customFieldsTaskTransactionsID = taskCodeCustomFields;
                                                    
                                                }
                                                
                                                [[[notificationDetailDictionary objectForKey:[NSString stringWithFormat:@"%lli",[[tasksDictionary objectForKey:@"Qmnum"] longLongValue]]] objectAtIndex:4] addObject:[NSArray arrayWithObjects:tasks,customFieldsTaskTransactionsID, nil]];
                                            }
                                        }
                                    }
                                    
                                    [notificationTasksArray removeAllObjects];
                                }
                                
                                responseObject = nil;
                                NSMutableArray *notificationStatusArray = [[NSMutableArray alloc] init];
                                
                                if ([parsedDictionary objectForKey:@"resultNotifStatus"]) {
                                    
                                    responseObject = [parsedDictionary objectForKey:@"resultNotifStatus"];
                                    
                                    [notificationStatusArray addObjectsFromArray:responseObject];
                                    
                                    NSDictionary *notifStatusDictionary;
                                    
                                    for (int i=0; i<[notificationStatusArray count]; i++) {
                                        if ([[notificationStatusArray objectAtIndex:i] isKindOfClass:[NSDictionary class]]) {
                                            notifStatusDictionary = [notificationStatusArray objectAtIndex:i];
                                            if ([notificationDetailDictionary objectForKey:[NSString stringWithFormat:@"%lli",[[notifStatusDictionary objectForKey:@"Qmnum"] longLongValue]]]) {
                                                
                                                NSMutableArray *notifStatus = [NSMutableArray array];
                                                
                                                if ([notifStatusDictionary objectForKey:@"Qmnum"]) {
                                                    [notifStatus addObject:[notifStatusDictionary objectForKey:@"Qmnum"]];
                                                }
                                                else{
                                                    
                                                    [notifStatus addObject:@""];
                                                }
                                                
                                                if ([notifStatusDictionary objectForKey:@"Aufnr"]) {
                                                    [notifStatus addObject:[notifStatusDictionary objectForKey:@"Aufnr"]];
                                                }
                                                else{
                                                    
                                                    [notifStatus addObject:@""];
                                                }
                                                
                                                if ([notifStatusDictionary objectForKey:@"Objnr"]) {
                                                    [notifStatus addObject:[notifStatusDictionary objectForKey:@"Objnr"]];
                                                }
                                                else{
                                                    [notifStatus addObject:@""];
                                                }
                                                
                                                if ([notifStatusDictionary objectForKey:@"Manum"]) {
                                                    [notifStatus addObject:[notifStatusDictionary objectForKey:@"Manum"]];
                                                }
                                                else{
                                                    [notifStatus addObject:@""];
                                                }
                                                
                                                if ([notifStatusDictionary objectForKey:@"Stsma"]) {
                                                    [notifStatus addObject:[notifStatusDictionary objectForKey:@"Stsma"]];
                                                }
                                                else{
                                                    [notifStatus addObject:@""];
                                                }
                                                
                                                if ([notifStatusDictionary objectForKey:@"Inist"]) {
                                                    [notifStatus addObject:[notifStatusDictionary objectForKey:@"Inist"]];
                                                }
                                                else{
                                                    [notifStatus addObject:@""];
                                                }
                                                
                                                if ([notifStatusDictionary objectForKey:@"Stonr"]) {
                                                    [notifStatus addObject:[notifStatusDictionary objectForKey:@"Stonr"]];
                                                }
                                                else{
                                                    [notifStatus addObject:@""];
                                                }
                                                
                                                if ([notifStatusDictionary objectForKey:@"Hsonr"]) {
                                                    [notifStatus addObject:[notifStatusDictionary objectForKey:@"Hsonr"]];
                                                }
                                                else{
                                                    [notifStatus addObject:@""];
                                                }
                                                
                                                if ([notifStatusDictionary objectForKey:@"Nsonr"]) {
                                                    [notifStatus addObject:[notifStatusDictionary objectForKey:@"Nsonr"]];
                                                }
                                                else{
                                                    [notifStatus addObject:@""];
                                                }
                                                
                                                if ([notifStatusDictionary objectForKey:@"Stat"]) {
                                                    [notifStatus addObject:[[notifStatusDictionary objectForKey:@"Stat"] substringToIndex:1]];
                                                }
                                                else{
                                                    [notifStatus addObject:@""];
                                                }
                                                
                                                if ([notifStatusDictionary objectForKey:@"Act"]) {
                                                    [notifStatus addObject:[notifStatusDictionary objectForKey:@"Act"]];
                                                }
                                                else{
                                                    [notifStatus addObject:@""];
                                                }
                                                
                                                if ([notifStatusDictionary objectForKey:@"Txt04"]) {
                                                    [notifStatus addObject:[notifStatusDictionary objectForKey:@"Txt04"]];
                                                }
                                                else{
                                                    [notifStatus addObject:@""];
                                                }
                                                
                                                if ([notifStatusDictionary objectForKey:@"Txt30"]) {
                                                    [notifStatus addObject:[notifStatusDictionary objectForKey:@"Txt30"]];
                                                }
                                                else{
                                                    [notifStatus addObject:@""];
                                                }
                                                
                                                if ([notifStatusDictionary objectForKey:@"Action"]) {
                                                    [notifStatus addObject:[notifStatusDictionary objectForKey:@"Action"]];
                                                }
                                                else{
                                                    [notifStatus addObject:@""];
                                                }
                                                
                                                [[[notificationDetailDictionary objectForKey:[NSString stringWithFormat:@"%lli",[[notifStatusDictionary objectForKey:@"Qmnum"] longLongValue]]] lastObject] addObject:notifStatus];
                                            }
                                        }
                                    }
                                    
                                    [notificationStatusArray removeAllObjects];
                                }
                                
                                responseObject = nil;
                                
                                if ([parsedDictionary objectForKey:@"resultLongText"]) {
                                    responseObject = [parsedDictionary objectForKey:@"resultLongText"];
                                    NSMutableArray *notificatioTextnArray = [[NSMutableArray alloc] init];
                                    
                                    [notificatioTextnArray addObjectsFromArray:responseObject];
                                    
                                    NSDictionary *textDictionary;
                                    for (int i=0; i<[notificatioTextnArray count]; i++) {
                                        if ([[notificatioTextnArray objectAtIndex:i] isKindOfClass:[NSDictionary class]]) {
                                            textDictionary = [notificatioTextnArray objectAtIndex:i];
                                            if ([notificationDetailDictionary objectForKey:[textDictionary objectForKey:@"Qmnum"]]) {
                                                NSMutableDictionary *headerDictionary = [[notificationDetailDictionary objectForKey:[textDictionary objectForKey:@"Qmnum"]] firstObject];
                                                if ([[headerDictionary objectForKey:@"LONGTEXT"] length]) {
                                                    [headerDictionary setObject:[NSString stringWithFormat:@"%@\n%@",[headerDictionary objectForKey:@"LONGTEXT"],[textDictionary objectForKey:@"TextLine"]] forKey:@"LONGTEXT"];
                                                }
                                                else
                                                {
                                                    [headerDictionary setObject:[NSString stringWithFormat:@"%@",[textDictionary objectForKey:@"TextLine"]] forKey:@"LONGTEXT"];
                                                }
                                            }
                                        }
                                    }
                                    
                                    [notificationTransactionArray removeAllObjects];
                                    responseObject = nil;
                                }
                                
 
                                NSArray *objectIds = [notificationDetailDictionary allKeys];
 
                                if ([[defaults objectForKey:@"ACTIVATELOGS"] isEqualToString:@"X"])
                                {
                                    [[DataBase sharedInstance] writToLogFile:[NSString stringWithFormat:@"#INFO#.com.enstrapp.fieldtekpro#No of Due Notifications received:%lu",(unsigned long)[objectIds count]]];
                                }
                                
                                for (int i=0; i<[objectIds count]; i++) {
                                    
                                    [[DataBase sharedInstance] insertDataIntoNotificationHeader:[[notificationDetailDictionary objectForKey:[objectIds objectAtIndex:i]] firstObject] withAttachments:[[notificationDetailDictionary objectForKey:[objectIds objectAtIndex:i]] objectAtIndex:1] withTransaction:[[notificationDetailDictionary objectForKey:[objectIds objectAtIndex:i]] objectAtIndex:2] withActivityCodes:[[notificationDetailDictionary objectForKey:[objectIds objectAtIndex:i]] objectAtIndex:3] withTaskcodes:[[notificationDetailDictionary objectForKey:[objectIds objectAtIndex:i]] objectAtIndex:4] withInspectionResult:[inspectionResultDataArray copy] withNotifStatusCode:[[notificationDetailDictionary objectForKey:[objectIds objectAtIndex:i]] objectAtIndex:5]];
                                }
                                
                            }
                            
                            [[DataBase sharedInstance] updateNotificationWithObjectid:qmnumString forHeaderID:[self.notificationHeaderDetails objectForKey:@"ID"]];
                            
                            releaseBtn.hidden=YES;
                            
                            if (qmnumString.length) {
                                
                                [messageString appendString:[NSString stringWithFormat:@"%@ \n Order %@ has been Created Successfully",messageString,qmnumString]];
                                
                             }
                            
                            [self showAlertMessageWithTitle:@"Success" message:messageString cancelButtonTitle:@"OK" withactionType:@"Single" forMethod:nil];
                            
                            if (aufnrString.length) {
                                
                                NSMutableDictionary *dataDictionary = [[NSMutableDictionary alloc]init];
                                [dataDictionary setObject:decryptedUserName forKey:@"REPORTEDBY"];
                                [dataDictionary setObject:aufnrString forKey:@"Aufnr"];
                                NSMutableDictionary *endPointDictionary = [NSMutableDictionary new];
                                [endPointDictionary setObject:@"DO" forKey:@"ACTIVITY"];
                                [endPointDictionary setObject:@"C2" forKey:@"DOCTYPE"];
                                [endPointDictionary setObject:[defaults objectForKey:@"ENDPOINT"] forKey:@"ENDPOINT"];
                                 NSArray *endPointArray = [[DataBase sharedInstance] getEndPointURL:endPointDictionary];
                                NSLog(@"endPoint :%@",[[endPointArray objectAtIndex:0] objectAtIndex:0]);
                                [dataDictionary setObject:[[endPointArray objectAtIndex:0] objectAtIndex:0] forKey:@"URL_ENDPOINT"];    [dataDictionary setObject:@"REFR" forKey:@"TRANSMITTYPE"];
                                [Request makeWebServiceRequest:GET_ORDERS parameters:dataDictionary delegate:self];
                             }
                            else{
                                
                                [MBProgressHUD hideHUDForView:self.view animated:YES];
                             }
                         }
                        else if([[[parsedDictionary objectForKey:@"MESSAGE"] substringToIndex:1] isEqualToString:@"E"])
                        {
                            [[DataBase sharedInstance] updateSyncLogErrorForCategory:@"Notification" action:@"Release" objectid:@"" UUID:[self.notificationHeaderDetails objectForKey:@"ID"] message:[[parsedDictionary objectForKey:@"MESSAGE"] substringFromIndex:1]];
 
                            [self showAlertMessageWithTitle:@"ERROR" message:[[parsedDictionary objectForKey:@"MESSAGE"] substringFromIndex:1] cancelButtonTitle:@"OK" withactionType:@"Single" forMethod:nil];
                            
                            [MBProgressHUD hideHUDForView:self.view animated:YES];
 
                        }
                        else if ([parsedDictionary objectForKey:@"ERROR"]) {
                            [[DataBase sharedInstance] updateSyncLogErrorForCategory:@"Notification" action:@"Release" objectid:@"" UUID:[self.notificationHeaderDetails objectForKey:@"ID"] message:[parsedDictionary objectForKey:@"ERROR"]];
                            
                               [self showAlertMessageWithTitle:@"Failure" message:[NSString stringWithFormat:@"Notification Not Created. Server error"] cancelButtonTitle:@"OK" withactionType:@"Single" forMethod:nil];
                            
                            [MBProgressHUD hideHUDForView:self.view animated:YES];

                        }
                        else
                        {
                            //                    [[DataBase sharedInstance] updateSyncLogErrorForCategory:@"Notification" action:@"Create" objectid:@"" UUID:[self.notificationHeaderDetails objectForKey:@"ID"] message:NSLocalizedString(@"ErrorMessage", nil)];
                            
                            [[DataBase sharedInstance] updateSyncLogErrorForCategory:@"Notification" action:@"Release" objectid:@""  UUID:[self.notificationHeaderDetails objectForKey:@"ID"] message:NSLocalizedString(@"ErrorMessage",nil)];
                            
                              [self showAlertMessageWithTitle:@"Information" message:[NSString stringWithFormat:NSLocalizedString(@"ErrorMessage", nil)] cancelButtonTitle:@"OK" withactionType:@"Single" forMethod:nil];
                            
                            [MBProgressHUD hideHUDForView:self.view animated:YES];

                        }
                     }
                    
                    else{
                        
                        [MBProgressHUD hideHUDForView:self.view animated:YES];

                    }
                    
                 }
            }
            else
            {
                [[DataBase sharedInstance] updateSyncLogErrorForCategory:@"Notification" action:@"Release" objectid:@"" UUID:[self.notificationHeaderDetails objectForKey:@"ID"] message:NSLocalizedString(@"ErrorMessage", nil)];
              
                   [self showAlertMessageWithTitle:@"Failure" message:errorDescription cancelButtonTitle:@"OK" withactionType:@"Single" forMethod:nil];
            }
            
            break;
            
        case GET_ORDERS:
            
          if (!errorDescription.length) {
              
            NSMutableDictionary *parsedDictionary = [[Response sharedInstance] parseForListOfDueOrders:resultData];
            
 
            if ([parsedDictionary objectForKey:@"resultHeader"]) {
                
                NSMutableDictionary *orderDetailDictionary = [[NSMutableDictionary alloc] init];
                id responseObject;
                NSMutableArray *orderOperationArray = [[NSMutableArray alloc] init];
                NSMutableArray *orderDocsArray = [[NSMutableArray alloc] init];
                NSMutableArray *orderHeaderArray = [[NSMutableArray alloc] init];
                NSMutableArray *orderWsmSafetyMeasuresArray = [[NSMutableArray alloc]init];
                NSMutableArray *orderWcmWorkApprovalListArray = [[NSMutableArray alloc]init];
                NSMutableArray *orderWcmWorkApplicationListArray = [[NSMutableArray alloc]init];
                NSMutableArray *orderWcmIssuePermitsArray = [[NSMutableArray alloc]init];
                NSMutableArray *orderWcmOperationWCDArray = [[NSMutableArray alloc]init];
                NSMutableArray *orderWcmOperationWCDTaggingConditionsArray = [[NSMutableArray alloc] init];
                NSMutableArray *orderWcmPermitsStandardCheckPoints = [NSMutableArray new];
                
                NSMutableArray *orderStatusArray = [[NSMutableArray alloc] init];
                NSMutableArray *orderOlistArray = [[NSMutableArray alloc] init];
                
                NSMutableArray *orderMeasurementDocumentsArray = [NSMutableArray new];
                
                NSDictionary *headerDictionary;
                
                responseObject = nil;
                responseObject = [parsedDictionary objectForKey:@"resultHeader"];
                
                [orderHeaderArray addObjectsFromArray:responseObject];
                
                NSDateFormatter *dateFormate = [[NSDateFormatter alloc] init];
                [dateFormate setDateFormat:@"yyyy-MM-dd"];
                NSMutableDictionary *currentHeaderDictionary;
                
                for (int i=0; i<[orderHeaderArray count]; i++) {
                    
                    if ([[orderHeaderArray objectAtIndex:i] isKindOfClass:[NSDictionary class]]) {
                        headerDictionary = [orderHeaderArray objectAtIndex:i];
                        currentHeaderDictionary = [[NSMutableDictionary alloc] init];
                        if ([headerDictionary objectForKey:@"Aufnr"]) {
                            [currentHeaderDictionary setObject:[[headerDictionary objectForKey:@"Aufnr"] copy] forKey:@"OBJECTID"];
                            
                        }
                        else
                        {
                            [currentHeaderDictionary setObject:@" " forKey:@"OBJECTID"];
                        }
                        
                        
                        
                        [currentHeaderDictionary setObject:[[headerDictionary objectForKey:@"Auart"] copy] forKey:@"OID"];
                        
                        if ([NullChecker isNull:[headerDictionary objectForKey:@"Ktext"]]) {
                            [currentHeaderDictionary setObject:@"" forKey:@"SHORTTEXT"];
                        }
                        else{
                            [currentHeaderDictionary setObject:[[headerDictionary objectForKey:@"Ktext"] copy] forKey:@"SHORTTEXT"];
                        }
                        
                        if ([headerDictionary objectForKey:@"Gltrp"]) {
                            
                            [currentHeaderDictionary setObject:[headerDictionary objectForKey:@"Gltrp"] forKey:@"EDATE"];
                            
                        }
                        else{
                            [currentHeaderDictionary setObject:@"" forKey:@"EDATE"];
                        }
                        
                        if ([headerDictionary objectForKey:@"Gstrp"]) {
                            
                            [currentHeaderDictionary setObject:[headerDictionary objectForKey:@"Gstrp"] forKey:@"SDATE"];
                        }
                        else{
                            
                            [currentHeaderDictionary setObject:@"" forKey:@"SDATE"];
                        }
                        
                        [currentHeaderDictionary setObject:[[headerDictionary objectForKey:@"Ernam"] copy] forKey:@"REPORTEDBY"];
                        if ([headerDictionary objectForKey:@"Priok"]) {
                            [currentHeaderDictionary setObject:[[headerDictionary objectForKey:@"Priok"] copy] forKey:@"OPID"];
                        }
                        else{
                            [currentHeaderDictionary setObject:@"" forKey:@"OPID"];
                        }
                        
                        if ([headerDictionary objectForKey:@"Equnr"]) {
                            [currentHeaderDictionary setObject:[[headerDictionary objectForKey:@"Equnr"] copy] forKey:@"EQID"];
                        }
                        else{
                            [currentHeaderDictionary setObject:@"" forKey:@"EQID"];
                        }
                        
                        if ([headerDictionary objectForKey:@"Strno"]) {
                            [currentHeaderDictionary setObject:[[headerDictionary objectForKey:@"Strno"] copy] forKey:@"FID"];
                        }
                        else{
                            [currentHeaderDictionary setObject:@"" forKey:@"FID"];
                        }
                        
                        if ([headerDictionary objectForKey:@"Xstatus"]) {
                            [currentHeaderDictionary setObject:[headerDictionary objectForKey:@"Xstatus"] forKey:@"OSTATUS"];
                        }
                        else{
                            [currentHeaderDictionary setObject:@"Assigned" forKey:@"OSTATUS"];
                        }
                        
                        if ([headerDictionary objectForKey:@"Docs"]) {
                            [currentHeaderDictionary setObject:[headerDictionary objectForKey:@"Docs"] forKey:@"DOCS"];
                        }
                        else{
                            [currentHeaderDictionary setObject:@"" forKey:@"DOCS"];
                        }
                        
                        if ([headerDictionary objectForKey:@"Werks"]) {
                            [currentHeaderDictionary setObject:[headerDictionary objectForKey:@"Werks"] forKey:@"PLANTID"];
                        }
                        else{
                            [currentHeaderDictionary setObject:@"" forKey:@"PLANTID"];
                        }
                        
                        if ([headerDictionary objectForKey:@"Plantname"]) {
                            
                            [currentHeaderDictionary setObject:[headerDictionary objectForKey:@"Plantname"] forKey:@"PLANTNAME"];
                        }
                        else{
                            [currentHeaderDictionary setObject:@"" forKey:@"PLANTNAME"];
                        }
                        
                        if ([headerDictionary objectForKey:@"Arbpl"]) {
                            [currentHeaderDictionary setObject:[headerDictionary objectForKey:@"Arbpl"] forKey:@"WORKCENTERID"];
                        }
                        else{
                            [currentHeaderDictionary setObject:@"" forKey:@"WORKCENTERID"];
                        }
                        
                        if ([headerDictionary objectForKey:@"Wkctrname"]) {
                            
                            [currentHeaderDictionary setObject:[headerDictionary objectForKey:@"Wkctrname"] forKey:@"WORKCENTERNAME"];
                        }
                        else{
                            [currentHeaderDictionary setObject:@"" forKey:@"WORKCENTERNAME"];
                        }
                        
                        if ([headerDictionary objectForKey:@"Ausvn"]) {
                            [currentHeaderDictionary setObject:[headerDictionary objectForKey:@"Ausvn"] forKey:@"MALFUNCTIONSTARTDATE"];
                        }
                        else{
                            
                            [currentHeaderDictionary setObject:@"" forKey:@"MALFUNCTIONSTARTDATE"];
                        }
                        
                        if ([headerDictionary objectForKey:@"Ausbs"]) {
                            [currentHeaderDictionary setObject:[headerDictionary objectForKey:@"Ausbs"] forKey:@"MALFUNCTIONENDDATE"];
                        }
                        else{
                            
                            [currentHeaderDictionary setObject:@"" forKey:@"MALFUNCTIONENDDATE"];
                        }
                        
                        if ([headerDictionary objectForKey:@"Qmnam"]) {
                            [currentHeaderDictionary setObject:[headerDictionary objectForKey:@"Qmnam"] forKey:@"NREPORTEDBY"];
                        }
                        else{
                            [currentHeaderDictionary setObject:@"" forKey:@"NREPORTEDBY"];
                        }
                        
                        if ([headerDictionary objectForKey:@"Msaus"]) {
                            [currentHeaderDictionary setObject:[headerDictionary objectForKey:@"Msaus"] forKey:@"BREAKDOWN"];
                        }
                        else{
                            [currentHeaderDictionary setObject:@"" forKey:@"BREAKDOWN"];
                        }
                        
                        if ([headerDictionary objectForKey:@"Auswk"]) {
                            [currentHeaderDictionary setObject:[headerDictionary objectForKey:@"Auswk"] forKey:@"EFFECTID"];
                        }
                        else{
                            
                            [currentHeaderDictionary setObject:@"" forKey:@"EFFECTID"];
                        }
                        
                        if ([headerDictionary objectForKey:@"Auswkt"]) {
                            [currentHeaderDictionary setObject:[headerDictionary objectForKey:@"Auswkt"] forKey:@"EFFECTNAME"];
                        }
                        else{
                            
                            [currentHeaderDictionary setObject:@"" forKey:@"EFFECTNAME"];
                        }
                        
                        
                        if ([headerDictionary objectForKey:@"Anlzu"]) {
                            [currentHeaderDictionary setObject:[headerDictionary objectForKey:@"Anlzu"] forKey:@"SYSTEMCONDITIONID"];
                        }
                        else{
                            [currentHeaderDictionary setObject:@"" forKey:@"SYSTEMCONDITIONID"];
                        }
                        
                        if ([headerDictionary objectForKey:@"Anlzux"]) {
                            [currentHeaderDictionary setObject:[headerDictionary objectForKey:@"Anlzux"] forKey:@"SYSTEMCONDITIONTEXT"];
                        }
                        else{
                            [currentHeaderDictionary setObject:@"" forKey:@"SYSTEMCONDITIONTEXT"];
                        }
                        
                        
                        
                        if ([headerDictionary objectForKey:@"ParnrVw"]) {
                            [currentHeaderDictionary setObject:[headerDictionary objectForKey:@"ParnrVw"] forKey:@"PARNRID"];
                        }
                        else{
                            
                            [currentHeaderDictionary setObject:@"" forKey:@"PARNRID"];
                        }
                        
                        if ([headerDictionary objectForKey:@"NameVw"]) {
                            [currentHeaderDictionary setObject:[headerDictionary objectForKey:@"NameVw"] forKey:@"NAMEVW"];
                        }
                        else{
                            
                            [currentHeaderDictionary setObject:@"" forKey:@"NAMEVW"];
                            
                        }
                        
                        if ([headerDictionary objectForKey:@"Ingrp"]) {
                            [currentHeaderDictionary setObject:[headerDictionary objectForKey:@"Ingrp"] forKey:@"PLANNERGROUP"];
                        }
                        else{
                            
                            [currentHeaderDictionary setObject:@"" forKey:@"PLANNERGROUP"];
                            
                        }
                        
                        if ([headerDictionary objectForKey:@"Ingrpname"]) {
                            [currentHeaderDictionary setObject:[headerDictionary objectForKey:@"Ingrpname"] forKey:@"PLANNERGROUPNAME"];
                        }
                        else{
                            
                            [currentHeaderDictionary setObject:@"" forKey:@"PLANNERGROUPNAME"];
                            
                        }
                        
                        
                        [currentHeaderDictionary setObject:@"" forKey:@"LATITUDE"];
                        [currentHeaderDictionary setObject:@"" forKey:@"LONGITUDE"];
                        [currentHeaderDictionary setObject:@"" forKey:@"ALTITUDE"];
                        
                        [currentHeaderDictionary setObject:@"" forKey:@"workarea"];
                        [currentHeaderDictionary setObject:@"" forKey:@"costcenter"];
                        
                        if ([headerDictionary objectForKey:@"Kokrs"]) {
                            
                            [currentHeaderDictionary setObject:[headerDictionary objectForKey:@"Kokrs"] forKey:@"workarea"];
                        }
                        
                        if ([headerDictionary objectForKey:@"Kostl"]) {
                            
                            [currentHeaderDictionary setObject:[headerDictionary objectForKey:@"Kostl"] forKey:@"costcenter"];
                        }
                        
                        
                        if ([headerDictionary objectForKey:@"EquiHistory"]) {
                            id equipmentHisory = [headerDictionary objectForKey:@"EquiHistory"];
                            if ([equipmentHisory objectForKey:@"item"]) {
                                equipmentHisory = [equipmentHisory objectForKey:@"item"];
                                if ([equipmentHisory isKindOfClass:[NSDictionary class]]) {
                                    [currentHeaderDictionary setObject:[NSMutableArray arrayWithObject:equipmentHisory] forKey:@"EQUIPMENTHISTORY"];
                                }
                                else if ([equipmentHisory isKindOfClass:[NSArray class]]){
                                    [currentHeaderDictionary setObject:equipmentHisory forKey:@"EQUIPMENTHISTORY"];
                                }
                            }
                        }
                        
                        if ([headerDictionary objectForKey:@"Fields"]) {
                            NSMutableArray *fieldsMutArray = [NSMutableArray new];
                            NSMutableArray *tempfieldsMutArray = [NSMutableArray new];
                            
                            if ([[[headerDictionary objectForKey:@"Fields"] objectForKey:@"item"] isKindOfClass:[NSDictionary class]]) {
                                [tempfieldsMutArray addObjectsFromArray:[NSMutableArray arrayWithObject:[[headerDictionary objectForKey:@"Fields"] objectForKey:@"item"]]];
                            }
                            else if ([[[headerDictionary objectForKey:@"Fields"] objectForKey:@"item"] isKindOfClass:[NSArray class]]) {
                                [tempfieldsMutArray addObjectsFromArray:[[headerDictionary objectForKey:@"Fields"] objectForKey:@"item"]];
                            }
                            
                            //                                NSArray *fieldsArray = [[headerDictionary objectForKey:@"Fields"] objectForKey:@"item"];
                            for (int i =0; i<[tempfieldsMutArray count]; i++) {
                                NSString *fieldValue,*fieldName,*fLabel,*tabName,*dataType,*sequence,*length;
                                if ([NullChecker isNull:[[tempfieldsMutArray objectAtIndex:i] objectForKey:@"Fieldname"]]) {
                                    fieldName = @"";
                                }
                                else{
                                    fieldName = [[tempfieldsMutArray objectAtIndex:i] objectForKey:@"Fieldname"];
                                }
                                
                                if ([NullChecker isNull:[[tempfieldsMutArray objectAtIndex:i] objectForKey:@"Flabel"]]) {
                                    fLabel = @"";
                                }
                                else{
                                    fLabel = [[tempfieldsMutArray objectAtIndex:i] objectForKey:@"Flabel"];
                                }
                                
                                if ([NullChecker isNull:[[tempfieldsMutArray objectAtIndex:i] objectForKey:@"Tabname"]]) {
                                    tabName = @"";
                                }
                                else{
                                    tabName = [[tempfieldsMutArray objectAtIndex:i] objectForKey:@"Tabname"];
                                }
                                
                                if ([NullChecker isNull:[[tempfieldsMutArray objectAtIndex:i] objectForKey:@"Value"]]) {
                                    fieldValue = @"";
                                }
                                else{
                                    fieldValue = [[tempfieldsMutArray objectAtIndex:i] objectForKey:@"Value"];
                                }
                                
                                if ([NullChecker isNull:[[tempfieldsMutArray objectAtIndex:i] objectForKey:@"Datatype"]]) {
                                    dataType = @"";
                                }
                                else{
                                    dataType = [[tempfieldsMutArray objectAtIndex:i] objectForKey:@"Datatype"];
                                }
                                
                                if ([NullChecker isNull:[[tempfieldsMutArray objectAtIndex:i] objectForKey:@"Sequence"]]) {
                                    sequence = @"";
                                }
                                else{
                                    sequence = [[tempfieldsMutArray objectAtIndex:i] objectForKey:@"Sequence"];
                                }
                                
                                if ([NullChecker isNull:[[tempfieldsMutArray objectAtIndex:i] objectForKey:@"Length"]]) {
                                    length = @"";
                                }
                                else{
                                    length = [[tempfieldsMutArray objectAtIndex:i] objectForKey:@"Length"];
                                }
                                
                                
                                [fieldsMutArray addObject:[NSMutableArray arrayWithObjects:@"W",@"WH",tabName,fieldName,fieldValue,fLabel,dataType,sequence,length, nil]];
                            }
                            
                            [currentHeaderDictionary setObject:fieldsMutArray forKey:@"CFH"];
                        }
                        
                        [currentHeaderDictionary setObject:@"" forKey:@"LONGTEXT"];
                        [currentHeaderDictionary setObject:[[DataBase sharedInstance] fetchNameForIDKey:@"ORDEROBJECTID" forValue:[currentHeaderDictionary objectForKey:@"OBJECTID"]] forKey:@"ID"];
                        if (![[currentHeaderDictionary objectForKey:@"ID"] length]) {
                            
                        }
                        
                        if ([headerDictionary objectForKey:@"Auarttext"]) {
                            [currentHeaderDictionary setObject:[headerDictionary objectForKey:@"Auarttext"] forKey:@"ONAME"];
                        }
                        
                        if ([headerDictionary objectForKey:@"Priokx"]) {
                            [currentHeaderDictionary setObject:[headerDictionary objectForKey:@"Priokx"] forKey:@"OPNAME"];
                        }
                        else{
                            [currentHeaderDictionary setObject:@"" forKey:@"OPNAME"];
                        }
                        
                        if ([headerDictionary objectForKey:@"Pltxt"]) {
                            [currentHeaderDictionary setObject:[headerDictionary objectForKey:@"Pltxt"] forKey:@"FNAME"];
                        }
                        else{
                            [currentHeaderDictionary setObject:@"" forKey:@"FNAME"];
                        }
                        
                        if ([headerDictionary objectForKey:@"Eqktx"]) {
                            [currentHeaderDictionary setObject:[headerDictionary objectForKey:@"Eqktx"] forKey:@"EQNAME"];
                        }
                        else{
                            
                            [currentHeaderDictionary setObject:@"" forKey:@"EQNAME"];
                        }
                        
                        if ([headerDictionary  objectForKey:@"Bemot"]) {
                            [currentHeaderDictionary setObject:[headerDictionary objectForKey:@"Bemot"] forKey:@"ACCINCID"];
                            [currentHeaderDictionary setObject:[headerDictionary objectForKey:@"Bemot"] forKey:@"ACCINCNAME"];
                        }
                        else{
                            [currentHeaderDictionary setObject:@"" forKey:@"ACCINCID"];
                            [currentHeaderDictionary setObject:@"" forKey:@"ACCINCNAME"];
                        }
                        
                        if ([headerDictionary objectForKey:@"Kokrs"]) {
                            [currentHeaderDictionary setObject:[headerDictionary objectForKey:@"Kokrs"] forKey:@"workarea"];
                        }
                        else{
                            
                            [currentHeaderDictionary setObject:@"" forKey:@"workarea"];
                        }
                        
                        if ([headerDictionary objectForKey:@"Kostl"]) {
                            [currentHeaderDictionary setObject:[headerDictionary objectForKey:@"Kostl"] forKey:@"costcenter"];
                        }
                        else{
                            
                            [currentHeaderDictionary setObject:@"" forKey:@"costcenter"];
                        }
                        
                        [currentHeaderDictionary setObject:@"" forKey:@"NOSYNCLOG"];
                        
                        [currentHeaderDictionary setObject:@"" forKey:@"QMNUM"];
                        
                        if ([headerDictionary objectForKey:@"Qmnum"]) {
                            
                            [currentHeaderDictionary setObject:[headerDictionary objectForKey:@"Qmnum"] forKey:@"QMNUM"];
                        }
                        
                        [currentHeaderDictionary setObject:@"" forKey:@"usr01"];
                        if ([headerDictionary objectForKey:@"Usr01"]) {
                            
                            [currentHeaderDictionary setObject:[headerDictionary objectForKey:@"Usr01"] forKey:@"usr01"];
                        }
                        
                        [currentHeaderDictionary setObject:@"" forKey:@"usr02"];
                        if ([headerDictionary objectForKey:@"Usr02"]) {
                            
                            [currentHeaderDictionary setObject:[headerDictionary objectForKey:@"Usr02"] forKey:@"usr02"];
                        }
                        
                        [currentHeaderDictionary setObject:@"" forKey:@"usr03"];
                        if ([headerDictionary objectForKey:@"Usr03"]) {
                            
                            [currentHeaderDictionary setObject:[headerDictionary objectForKey:@"Usr03"] forKey:@"usr03"];
                        }
                        
                        [currentHeaderDictionary setObject:@"" forKey:@"usr04"];
                        if ([headerDictionary objectForKey:@"Usr04"]) {
                            
                            [currentHeaderDictionary setObject:[headerDictionary objectForKey:@"Usr04"] forKey:@"usr04"];
                        }
                        
                        [currentHeaderDictionary setObject:@"" forKey:@"usr05"];
                        if ([headerDictionary objectForKey:@"Usr05"]) {
                            
                            [currentHeaderDictionary setObject:[headerDictionary objectForKey:@"Usr04"] forKey:@"usr05"];
                        }
                        
                        [orderDetailDictionary setObject:[NSMutableArray arrayWithObjects:currentHeaderDictionary,[NSMutableArray array],[NSMutableArray array],[NSMutableArray array],[NSMutableArray array],[NSMutableArray array],[NSMutableArray array],[NSMutableArray array],[NSMutableArray array],[NSMutableArray array],[NSMutableArray array],[NSMutableArray array], nil] forKey:[currentHeaderDictionary objectForKey:@"OBJECTID"]];
                    }
                }
                
                [orderHeaderArray removeAllObjects];
                
                NSMutableDictionary *orderOlistDictionary = [[NSMutableDictionary alloc] init];
                responseObject = nil;
                NSMutableDictionary *tempOlistDictionary;
                
                if ([parsedDictionary objectForKey:@"resultOrderOlist"]) {
                    
                    responseObject = [parsedDictionary objectForKey:@"resultOrderOlist"];
                    
                    [orderOlistArray addObjectsFromArray:responseObject];
                    
                    for (int i=0; i<[orderOlistArray count]; i++) {
                        if ([[orderOlistArray objectAtIndex:i] isKindOfClass:[NSDictionary class]]) {
                            headerDictionary = [orderOlistArray objectAtIndex:i];
                            if ([orderDetailDictionary objectForKey:[NSString stringWithFormat:@"%lld",[[headerDictionary objectForKey:@"Aufnr"] longLongValue]]]) {
                                if ([orderOlistDictionary objectForKey:[NSString stringWithFormat:@"%lld",[[headerDictionary objectForKey:@"Aufnr"] longLongValue]]]) {
                                    tempOlistDictionary = [orderOlistDictionary objectForKey:[NSString stringWithFormat:@"%lld",[[headerDictionary objectForKey:@"Aufnr"] longLongValue]]];
                                    if ([tempOlistDictionary objectForKey:[headerDictionary objectForKey:@"Obknr"]]) {
                                        tempOlistDictionary = [tempOlistDictionary objectForKey:[headerDictionary objectForKey:@"Obknr"]];
                                        [tempOlistDictionary addEntriesFromDictionary:headerDictionary];
                                    }
                                    else{
                                        [tempOlistDictionary setObject:[NSMutableDictionary dictionaryWithDictionary:headerDictionary] forKey:[headerDictionary objectForKey:@"Obknr"]];
                                    }
                                }
                                else
                                {
                                    [orderOlistDictionary setObject:[NSMutableDictionary dictionaryWithObject:[NSMutableDictionary dictionaryWithDictionary:headerDictionary] forKey:[headerDictionary objectForKey:@"Obknr"]] forKey:[NSString stringWithFormat:@"%lld",[[headerDictionary objectForKey:@"Aufnr"] longLongValue]]];
                                }
                            }
                        }
                    }
                }
                
                [orderOlistArray removeAllObjects];
                
                NSMutableDictionary *orderDocsDictionary = [[NSMutableDictionary alloc] init];
                responseObject = nil;
                NSMutableDictionary *tempDocsDictionary;
                
                if ([parsedDictionary objectForKey:@"resultDocs"]) {
                    
                    responseObject = [parsedDictionary objectForKey:@"resultDocs"];
                    
                    [orderDocsArray addObjectsFromArray:responseObject];
                    
                    for (int i=0; i<[orderDocsArray count]; i++) {
                        if ([[orderDocsArray objectAtIndex:i] isKindOfClass:[NSDictionary class]]) {
                            headerDictionary = [orderDocsArray objectAtIndex:i];
                            if ([orderDetailDictionary objectForKey:[NSString stringWithFormat:@"%lld",[[headerDictionary objectForKey:@"Zobjid"] longLongValue]]]) {
                                if ([orderDocsDictionary objectForKey:[NSString stringWithFormat:@"%lld",[[headerDictionary objectForKey:@"Zobjid"] longLongValue]]]) {
                                    tempDocsDictionary = [orderDocsDictionary objectForKey:[NSString stringWithFormat:@"%lld",[[headerDictionary objectForKey:@"Zobjid"] longLongValue]]];
                                    if ([tempDocsDictionary objectForKey:[headerDictionary objectForKey:@"Filename"]]) {
                                        tempDocsDictionary = [tempDocsDictionary objectForKey:[headerDictionary objectForKey:@"Filename"]];
                                        [tempDocsDictionary addEntriesFromDictionary:headerDictionary];
                                    }
                                    else{
                                        [tempDocsDictionary setObject:[NSMutableDictionary dictionaryWithDictionary:headerDictionary] forKey:[headerDictionary objectForKey:@"Filename"]];
                                    }
                                }
                                else
                                {
                                    [orderDocsDictionary setObject:[NSMutableDictionary dictionaryWithObject:[NSMutableDictionary dictionaryWithDictionary:headerDictionary] forKey:[headerDictionary objectForKey:@"Filename"]] forKey:[NSString stringWithFormat:@"%lld",[[headerDictionary objectForKey:@"Zobjid"] longLongValue]]];
                                }
                            }
                        }
                    }
                }
                
                [orderDocsArray removeAllObjects];
                
                NSMutableDictionary *orderTransactionDictionary = [[NSMutableDictionary alloc] init];
                responseObject = nil;
                
                NSMutableDictionary *tempDictionary;
                
                if ([parsedDictionary objectForKey:@"resultOperationsTransactions"]) {
                    
                    responseObject = [parsedDictionary objectForKey:@"resultOperationsTransactions"];
                    
                    [orderOperationArray addObjectsFromArray:responseObject];
                    
                    for (int i=0; i<[orderOperationArray count]; i++) {
                        if ([[orderOperationArray objectAtIndex:i] isKindOfClass:[NSDictionary class]]) {
                            headerDictionary = [orderOperationArray objectAtIndex:i];
                            
                            if ([orderDetailDictionary objectForKey:[headerDictionary objectForKey:@"Aufnr"]]) {
                                if ([orderTransactionDictionary objectForKey:[headerDictionary objectForKey:@"Aufnr"]]) {
                                    tempDictionary = [orderTransactionDictionary objectForKey:[headerDictionary objectForKey:@"Aufnr"]];
                                    if ([tempDictionary objectForKey:[headerDictionary objectForKey:@"Vornr"]]) {
                                        tempDictionary = [tempDictionary objectForKey:[headerDictionary objectForKey:@"Vornr"]];
                                        [tempDictionary addEntriesFromDictionary:headerDictionary];
                                    }
                                    else
                                    {
                                        [tempDictionary setObject:[NSMutableDictionary dictionaryWithDictionary:headerDictionary] forKey:[headerDictionary objectForKey:@"Vornr"]];
                                    }
                                }
                                else
                                {
                                    [orderTransactionDictionary setObject:[NSMutableDictionary dictionaryWithObject:[NSMutableDictionary dictionaryWithDictionary:headerDictionary] forKey:[headerDictionary objectForKey:@"Vornr"]] forKey:[headerDictionary objectForKey:@"Aufnr"]];
                                }
                            }
                        }
                    }
                }
                
                [orderOperationArray removeAllObjects];
                
                responseObject = nil;
                NSMutableArray *orderTransactionArray = [[NSMutableArray alloc] init];
                
                if ([parsedDictionary objectForKey:@"resultComponentsTransactions"]) {
                    
                    responseObject = [parsedDictionary objectForKey:@"resultComponentsTransactions"];
                    
                    if ([responseObject isKindOfClass:[NSDictionary class]]) {
                        [orderTransactionArray addObject:responseObject];
                    }
                    else if ([responseObject isKindOfClass:[NSArray class]])
                    {
                        [orderTransactionArray addObjectsFromArray:responseObject];
                    }
                    
                    NSDictionary *transactionDictionary;
                    
                    for (int i=0; i<[orderTransactionArray count]; i++) {
                        
                        if ([[orderTransactionArray objectAtIndex:i] isKindOfClass:[NSDictionary class]]) {
                            
                            transactionDictionary = [orderTransactionArray objectAtIndex:i];
                            
                            if ([orderDetailDictionary objectForKey:[transactionDictionary objectForKey:@"Aufnr"]]) {
                                
                                if ([orderTransactionDictionary objectForKey:[transactionDictionary objectForKey:@"Aufnr"]]) {
                                    
                                    tempDictionary = [orderTransactionDictionary objectForKey:[transactionDictionary objectForKey:@"Aufnr"]];
                                    
                                    if ([tempDictionary objectForKey:[transactionDictionary objectForKey:@"Vornr"]]) {
                                        
                                        tempDictionary = [tempDictionary objectForKey:[transactionDictionary objectForKey:@"Vornr"]];
                                        
                                        if ([tempDictionary objectForKey:@"Components"]) {
                                            
                                            NSMutableArray *componentArray = [tempDictionary objectForKey:@"Components"];
                                            
                                            [componentArray addObject:[NSMutableDictionary dictionaryWithDictionary:transactionDictionary]];
                                        }
                                        else
                                        {
                                            [tempDictionary setObject:[NSMutableArray arrayWithObject:[NSMutableDictionary dictionaryWithDictionary:transactionDictionary]] forKey:@"Components"];
                                        }
                                    }
                                    else
                                    {
                                        [tempDictionary setObject:[NSMutableDictionary dictionaryWithDictionary:transactionDictionary] forKey:[transactionDictionary objectForKey:@"Vornr"]];
                                    }
                                }
                                else
                                {
                                    [orderTransactionDictionary setObject:[NSMutableDictionary dictionaryWithObject:[NSMutableDictionary dictionaryWithDictionary:transactionDictionary] forKey:[transactionDictionary objectForKey:@"Vornr"]] forKey:[transactionDictionary objectForKey:@"Aufnr"]];
                                }
                            }
                        }
                    }
                    
                    [orderTransactionArray removeAllObjects];
                }
                
                NSMutableDictionary *orderMeasurementDocumentsDictionary = [[NSMutableDictionary alloc] init];
                responseObject = nil;
                
                NSMutableDictionary *measureMentDocsDictionary;
                
                if ([parsedDictionary objectForKey:@"resultMeasurementDocuments"]) {
                    
                    responseObject = [parsedDictionary objectForKey:@"resultMeasurementDocuments"];
                    
                    [orderMeasurementDocumentsArray addObjectsFromArray:responseObject];
                    
                    for (int i=0; i<[orderMeasurementDocumentsArray count]; i++) {
                        if ([[orderMeasurementDocumentsArray objectAtIndex:i] isKindOfClass:[NSDictionary class]]) {
                            headerDictionary = [orderMeasurementDocumentsArray objectAtIndex:i];
                            
                            if ([orderDetailDictionary objectForKey:[headerDictionary objectForKey:@"Aufnr"]]) {
                                if ([orderMeasurementDocumentsDictionary objectForKey:[headerDictionary objectForKey:@"Aufnr"]]) {
                                    tempDictionary = [orderMeasurementDocumentsDictionary objectForKey:[headerDictionary objectForKey:@"Aufnr"]];
                                    if ([tempDictionary objectForKey:[headerDictionary objectForKey:@"Mdocm"]]) {
                                        measureMentDocsDictionary = [tempDictionary objectForKey:[headerDictionary objectForKey:@"Mdocm"]];
                                        [measureMentDocsDictionary addEntriesFromDictionary:headerDictionary];
                                    }
                                    else
                                    {
                                        [measureMentDocsDictionary setObject:[NSMutableDictionary dictionaryWithDictionary:headerDictionary] forKey:[headerDictionary objectForKey:@"Mdocm"]];
                                    }
                                }
                                else
                                {
                                    [orderMeasurementDocumentsDictionary setObject:[NSMutableDictionary dictionaryWithObject:[NSMutableDictionary dictionaryWithDictionary:headerDictionary] forKey:[headerDictionary objectForKey:@"Mdocm"]] forKey:[headerDictionary objectForKey:@"Aufnr"]];
                                }
                            }
                        }
                    }
                }
                
                [orderMeasurementDocumentsArray removeAllObjects];
                
                NSMutableDictionary *orderWSMSafetyMeasuresDictionary = [[NSMutableDictionary alloc] init];
                responseObject = nil;
                NSMutableDictionary *tempWSMSafetyMeasuresDictionary;
                
                if ([parsedDictionary objectForKey:@"resultWSMSafetyMeasures"]) {
                    
                    responseObject = [parsedDictionary objectForKey:@"resultWSMSafetyMeasures"];
                    
                    [orderWsmSafetyMeasuresArray addObjectsFromArray:responseObject];
                    
                    for (int i=0; i<[orderWsmSafetyMeasuresArray count]; i++) {
                        
                        if ([[orderWsmSafetyMeasuresArray objectAtIndex:i] isKindOfClass:[NSDictionary class]]) {
                            headerDictionary = [orderWsmSafetyMeasuresArray objectAtIndex:i];
                            if ([orderDetailDictionary objectForKey:[NSString stringWithFormat:@"%lld",[[headerDictionary objectForKey:@"EamsAufnr"] longLongValue]]]) {
                                if ([orderWSMSafetyMeasuresDictionary objectForKey:[NSString stringWithFormat:@"%lld",[[headerDictionary objectForKey:@"EamsAufnr"] longLongValue]]]) {
                                    tempWSMSafetyMeasuresDictionary = [orderWSMSafetyMeasuresDictionary objectForKey:[NSString stringWithFormat:@"%lld",[[headerDictionary objectForKey:@"EamsAufnr"] longLongValue]]];
                                    if ([tempWSMSafetyMeasuresDictionary objectForKey:[headerDictionary objectForKey:@"ObjId"]]) {
                                        tempWSMSafetyMeasuresDictionary = [tempWSMSafetyMeasuresDictionary objectForKey:[headerDictionary objectForKey:@"ObjId"]];
                                        [tempWSMSafetyMeasuresDictionary addEntriesFromDictionary:headerDictionary];
                                    }
                                    else{
                                        [tempWSMSafetyMeasuresDictionary setObject:[NSMutableDictionary dictionaryWithDictionary:headerDictionary] forKey:[headerDictionary objectForKey:@"ObjId"]];
                                    }
                                }
                                else
                                {
                                    [orderWSMSafetyMeasuresDictionary setObject:[NSMutableDictionary dictionaryWithObject:[NSMutableDictionary dictionaryWithDictionary:headerDictionary] forKey:[headerDictionary objectForKey:@"ObjId"]] forKey:[NSString stringWithFormat:@"%lld",[[headerDictionary objectForKey:@"EamsAufnr"] longLongValue]]];
                                }
                            }
                        }
                    }
                }
                
                [orderWsmSafetyMeasuresArray removeAllObjects];
                
                NSMutableDictionary *orderWCMWorkApprovalListDictionary = [[NSMutableDictionary alloc] init];
                responseObject = nil;
                NSMutableDictionary *tempWCMWorkApprovalListDictionary;
                
                if ([parsedDictionary objectForKey:@"resultWorkApprovalsData"]) {
                    
                    responseObject = [parsedDictionary objectForKey:@"resultWorkApprovalsData"];
                    
                    [orderWcmWorkApprovalListArray addObjectsFromArray:responseObject];
                    
                    for (int i=0; i<[orderWcmWorkApprovalListArray count]; i++) {
                        
                        if ([[orderWcmWorkApprovalListArray objectAtIndex:i] isKindOfClass:[NSDictionary class]]) {
                            headerDictionary = [orderWcmWorkApprovalListArray objectAtIndex:i];
                            if ([orderDetailDictionary objectForKey:[NSString stringWithFormat:@"%lld",[[headerDictionary objectForKey:@"Aufnr"] longLongValue]]]) {
                                if ([orderWCMWorkApprovalListDictionary objectForKey:[NSString stringWithFormat:@"%lld",[[headerDictionary objectForKey:@"Aufnr"] longLongValue]]]) {
                                    tempWCMWorkApprovalListDictionary = [orderWCMWorkApprovalListDictionary objectForKey:[NSString stringWithFormat:@"%lld",[[headerDictionary objectForKey:@"Aufnr"] longLongValue]]];
                                    if ([tempWCMWorkApprovalListDictionary objectForKey:[headerDictionary objectForKey:@"Wapnr"]]) {
                                        tempWCMWorkApprovalListDictionary = [tempWCMWorkApprovalListDictionary objectForKey:[headerDictionary objectForKey:@"Wapnr"]];
                                        [tempWCMWorkApprovalListDictionary addEntriesFromDictionary:headerDictionary];
                                    }
                                    else{
                                        [tempWCMWorkApprovalListDictionary setObject:[NSMutableDictionary dictionaryWithDictionary:headerDictionary] forKey:[headerDictionary objectForKey:@"Wapnr"]];
                                    }
                                }
                                else
                                {
                                    [orderWCMWorkApprovalListDictionary setObject:[NSMutableDictionary dictionaryWithObject:[NSMutableDictionary dictionaryWithDictionary:headerDictionary] forKey:[headerDictionary objectForKey:@"Wapnr"]] forKey:[NSString stringWithFormat:@"%lld",[[headerDictionary objectForKey:@"Aufnr"] longLongValue]]];
                                }
                            }
                        }
                    }
                }
                
                [orderWcmWorkApprovalListArray removeAllObjects];
                
                
                NSMutableDictionary *orderWCMWorkApplicationListDictionary = [[NSMutableDictionary alloc] init];
                responseObject = nil;
                NSMutableDictionary *tempWCMWorkApplicationListDictionary;
                
                if ([parsedDictionary objectForKey:@"resultWorkApplicationData"]) {
                    
                    responseObject = [parsedDictionary objectForKey:@"resultWorkApplicationData"];
                    
                    [orderWcmWorkApplicationListArray addObjectsFromArray:responseObject];
                    
                    for (int i=0; i<[orderWcmWorkApplicationListArray count]; i++) {
                        
                        if ([[orderWcmWorkApplicationListArray objectAtIndex:i] isKindOfClass:[NSDictionary class]]) {
                            headerDictionary = [orderWcmWorkApplicationListArray objectAtIndex:i];
                            if ([orderDetailDictionary objectForKey:[NSString stringWithFormat:@"%lld",[[headerDictionary objectForKey:@"Aufnr"] longLongValue]]]) {
                                if ([orderWCMWorkApplicationListDictionary objectForKey:[NSString stringWithFormat:@"%lld",[[headerDictionary objectForKey:@"Aufnr"] longLongValue]]]) {
                                    tempWCMWorkApplicationListDictionary = [orderWCMWorkApplicationListDictionary objectForKey:[NSString stringWithFormat:@"%lld",[[headerDictionary objectForKey:@"Aufnr"] longLongValue]]];
                                    if ([tempWCMWorkApplicationListDictionary objectForKey:[headerDictionary objectForKey:@"Wapinr"]]) {
                                        tempWCMWorkApplicationListDictionary = [tempWCMWorkApprovalListDictionary objectForKey:[headerDictionary objectForKey:@"Wapinr"]];
                                        [tempWCMWorkApplicationListDictionary addEntriesFromDictionary:headerDictionary];
                                    }
                                    else{
                                        [tempWCMWorkApplicationListDictionary setObject:[NSMutableDictionary dictionaryWithDictionary:headerDictionary] forKey:[headerDictionary objectForKey:@"Wapinr"]];
                                    }
                                }
                                else
                                {
                                    [orderWCMWorkApplicationListDictionary setObject:[NSMutableDictionary dictionaryWithObject:[NSMutableDictionary dictionaryWithDictionary:headerDictionary] forKey:[headerDictionary objectForKey:@"Wapinr"]] forKey:[NSString stringWithFormat:@"%lld",[[headerDictionary objectForKey:@"Aufnr"] longLongValue]]];
                                }
                            }
                        }
                    }
                }
                
                [orderWcmWorkApplicationListArray removeAllObjects];
                
                ///
                NSMutableDictionary *orderWCMIssuePermitsDictionary = [[NSMutableDictionary alloc] init];
                responseObject = nil;
                NSMutableDictionary *tempWCMIssuePermitsDictionary;
                
                if ([parsedDictionary objectForKey:@"resultIssuePermits"]) {
                    
                    
                    responseObject = [parsedDictionary objectForKey:@"resultIssuePermits"];
                    
                    
                    [orderWcmIssuePermitsArray addObjectsFromArray:responseObject];
                    
                    
                    for (int i=0; i<[orderWcmIssuePermitsArray count]; i++) {
                        
                        
                        if ([[orderWcmIssuePermitsArray objectAtIndex:i] isKindOfClass:[NSDictionary class]]) {
                            headerDictionary = [orderWcmIssuePermitsArray objectAtIndex:i];
                            if ([orderDetailDictionary objectForKey:[NSString stringWithFormat:@"%lld",[[headerDictionary objectForKey:@"Aufnr"] longLongValue]]]) {
                                
                                
                                if ([orderWCMIssuePermitsDictionary objectForKey:[NSString stringWithFormat:@"%lld",[[headerDictionary objectForKey:@"Aufnr"] longLongValue]]]) {
                                    tempWCMIssuePermitsDictionary = [orderWCMIssuePermitsDictionary objectForKey:[NSString stringWithFormat:@"%lld",[[headerDictionary objectForKey:@"Aufnr"] longLongValue]]];
                                    if ([tempWCMIssuePermitsDictionary objectForKey:[headerDictionary objectForKey:@"Werks"]]) {
                                        
                                        tempWCMIssuePermitsDictionary = [tempWCMIssuePermitsDictionary objectForKey:[headerDictionary objectForKey:@"Werks"]];
                                        
                                        
                                        if ([tempWCMIssuePermitsDictionary objectForKey:@"Objects"]) {
                                            NSMutableArray *objectsArray = [tempWCMIssuePermitsDictionary objectForKey:@"Objects"];
                                            [objectsArray addObject:[NSMutableDictionary dictionaryWithDictionary:headerDictionary]];
                                        }
                                        else{
                                            
                                            
                                            [tempWCMIssuePermitsDictionary setObject:[NSMutableArray arrayWithObject:[NSMutableDictionary dictionaryWithDictionary:headerDictionary]] forKey:@"Objects"];
                                        }
                                    }
                                    else{
                                        
                                        
                                        [tempWCMIssuePermitsDictionary setObject:[NSMutableDictionary dictionaryWithDictionary:headerDictionary] forKey:[headerDictionary objectForKey:@"Werks"]];
                                    }
                                }
                                else
                                {
                                    [orderWCMIssuePermitsDictionary setObject:[NSMutableDictionary dictionaryWithObject:[NSMutableDictionary dictionaryWithDictionary:headerDictionary] forKey:[headerDictionary objectForKey:@"Werks"]] forKey:[NSString stringWithFormat:@"%lld",[[headerDictionary objectForKey:@"Aufnr"] longLongValue]]];
                                }
                            }
                        }
                    }
                }
                [orderWcmIssuePermitsArray removeAllObjects];
                
                //
                
                responseObject = [parsedDictionary objectForKey:@"resultOperationWCDItemData"];
                
                for (int i = 0; i<[responseObject count]; i++) {
                    NSMutableArray *orderDetailWCMOperationWCDTaggingConditionsArray = [NSMutableArray new];
                    
                    tempDictionary = [responseObject objectAtIndex:i];
                    
                    if ([NullChecker isNull:[tempDictionary objectForKey:@"Wcnr"]]) {
                        [orderDetailWCMOperationWCDTaggingConditionsArray addObject:@""];
                    }
                    else{
                        [orderDetailWCMOperationWCDTaggingConditionsArray addObject:[tempDictionary objectForKey:@"Wcnr"]];
                    }
                    
                    if ([NullChecker isNull:[tempDictionary objectForKey:@"Wcitm"]]) {
                        [orderDetailWCMOperationWCDTaggingConditionsArray addObject:@""];
                    }
                    else{
                        
                        [orderDetailWCMOperationWCDTaggingConditionsArray addObject:[tempDictionary objectForKey:@"Wcitm"]];
                    }
                    
                    if ([NullChecker isNull:[tempDictionary objectForKey:@"Objnr"]]) {
                        [orderDetailWCMOperationWCDTaggingConditionsArray addObject:@""];
                    }
                    else{
                        [orderDetailWCMOperationWCDTaggingConditionsArray addObject:[tempDictionary objectForKey:@"Objnr"]];
                    }
                    
                    if ([NullChecker isNull:[tempDictionary objectForKey:@"Itmtyp"]]) {
                        [orderDetailWCMOperationWCDTaggingConditionsArray addObject:@""];
                    }
                    else{
                        [orderDetailWCMOperationWCDTaggingConditionsArray addObject:[tempDictionary objectForKey:@"Itmtyp"]];
                    }
                    
                    if ([NullChecker isNull:[tempDictionary objectForKey:@"Seq"]]) {
                        [orderDetailWCMOperationWCDTaggingConditionsArray addObject:@""];
                    }
                    else{
                        [orderDetailWCMOperationWCDTaggingConditionsArray addObject:[tempDictionary objectForKey:@"Seq"]];
                    }
                    
                    if ([NullChecker isNull:[tempDictionary objectForKey:@"Pred"]]) {
                        [orderDetailWCMOperationWCDTaggingConditionsArray addObject:@""];
                    }
                    else{
                        [orderDetailWCMOperationWCDTaggingConditionsArray addObject:[tempDictionary objectForKey:@"Pred"]];
                    }
                    
                    if ([NullChecker isNull:[tempDictionary objectForKey:@"Succ"]]) {
                        [orderDetailWCMOperationWCDTaggingConditionsArray addObject:@""];
                    }
                    else{
                        [orderDetailWCMOperationWCDTaggingConditionsArray addObject:[tempDictionary objectForKey:@"Succ"]];
                    }
                    
                    if ([NullChecker isNull:[tempDictionary objectForKey:@"Ccobj"]]) {
                        [orderDetailWCMOperationWCDTaggingConditionsArray addObject:@""];
                    }
                    else{
                        [orderDetailWCMOperationWCDTaggingConditionsArray addObject:[tempDictionary objectForKey:@"Ccobj"]];
                    }
                    
                    if ([NullChecker isNull:[tempDictionary objectForKey:@"Cctyp"]]) {
                        [orderDetailWCMOperationWCDTaggingConditionsArray addObject:@""];
                    }
                    else{
                        [orderDetailWCMOperationWCDTaggingConditionsArray addObject:[tempDictionary objectForKey:@"Cctyp"]];
                    }
                    
                    if ([NullChecker isNull:[tempDictionary objectForKey:@"Stxt"]]) {
                        [orderDetailWCMOperationWCDTaggingConditionsArray addObject:@""];
                    }
                    else{
                        [orderDetailWCMOperationWCDTaggingConditionsArray addObject:[tempDictionary objectForKey:@"Stxt"]];
                    }
                    
                    if ([NullChecker isNull:[tempDictionary objectForKey:@"Tggrp"]]) {
                        [orderDetailWCMOperationWCDTaggingConditionsArray addObject:@""];
                    }
                    else{
                        [orderDetailWCMOperationWCDTaggingConditionsArray addObject:[tempDictionary objectForKey:@"Tggrp"]];
                    }
                    
                    if ([NullChecker isNull:[tempDictionary objectForKey:@"Tgstep"]]) {
                        [orderDetailWCMOperationWCDTaggingConditionsArray addObject:@""];
                    }
                    else{
                        [orderDetailWCMOperationWCDTaggingConditionsArray addObject:[tempDictionary objectForKey:@"Tgstep"]];
                    }
                    
                    if ([NullChecker isNull:[tempDictionary objectForKey:@"Tgproc"]]) {
                        [orderDetailWCMOperationWCDTaggingConditionsArray addObject:@""];
                    }
                    else{
                        [orderDetailWCMOperationWCDTaggingConditionsArray addObject:[tempDictionary objectForKey:@"Tgproc"]];
                    }
                    
                    if ([NullChecker isNull:[tempDictionary objectForKey:@"Tgtyp"]]) {
                        [orderDetailWCMOperationWCDTaggingConditionsArray addObject:@""];
                    }
                    else{
                        [orderDetailWCMOperationWCDTaggingConditionsArray addObject:[tempDictionary objectForKey:@"Tgtyp"]];
                    }
                    
                    if ([NullChecker isNull:[tempDictionary objectForKey:@"Tgseq"]]) {
                        [orderDetailWCMOperationWCDTaggingConditionsArray addObject:@""];
                    }
                    else{
                        [orderDetailWCMOperationWCDTaggingConditionsArray addObject:[tempDictionary objectForKey:@"Tgseq"]];
                    }
                    
                    if ([NullChecker isNull:[tempDictionary objectForKey:@"Tgtxt"]]) {
                        [orderDetailWCMOperationWCDTaggingConditionsArray addObject:@""];
                    }
                    else{
                        [orderDetailWCMOperationWCDTaggingConditionsArray addObject:[tempDictionary objectForKey:@"Tgtxt"]];
                    }
                    
                    if ([NullChecker isNull:[tempDictionary objectForKey:@"Unstep"]]) {
                        [orderDetailWCMOperationWCDTaggingConditionsArray addObject:@""];
                    }
                    else{
                        [orderDetailWCMOperationWCDTaggingConditionsArray addObject:[tempDictionary objectForKey:@"Unstep"]];
                    }
                    
                    if ([NullChecker isNull:[tempDictionary objectForKey:@"Unproc"]]) {
                        [orderDetailWCMOperationWCDTaggingConditionsArray addObject:@""];
                    }
                    else{
                        [orderDetailWCMOperationWCDTaggingConditionsArray addObject:[tempDictionary objectForKey:@"Unproc"]];
                    }
                    
                    if ([NullChecker isNull:[tempDictionary objectForKey:@"Untyp"]]) {
                        [orderDetailWCMOperationWCDTaggingConditionsArray addObject:@""];
                    }
                    else{
                        [orderDetailWCMOperationWCDTaggingConditionsArray addObject:[tempDictionary objectForKey:@"Untyp"]];
                    }
                    
                    if ([NullChecker isNull:[tempDictionary objectForKey:@"Unseq"]]) {
                        [orderDetailWCMOperationWCDTaggingConditionsArray addObject:@""];
                    }
                    else{
                        [orderDetailWCMOperationWCDTaggingConditionsArray addObject:[tempDictionary objectForKey:@"Unseq"]];
                    }
                    
                    if ([NullChecker isNull:[tempDictionary objectForKey:@"Untxt"]]) {
                        [orderDetailWCMOperationWCDTaggingConditionsArray addObject:@""];
                    }
                    else{
                        [orderDetailWCMOperationWCDTaggingConditionsArray addObject:[tempDictionary objectForKey:@"Untxt"]];
                    }
                    
                    if ([NullChecker isNull:[tempDictionary objectForKey:@"Phblflg"]]) {
                        [orderDetailWCMOperationWCDTaggingConditionsArray addObject:@""];
                    }
                    else{
                        [orderDetailWCMOperationWCDTaggingConditionsArray addObject:[tempDictionary objectForKey:@"Phblflg"]];
                    }
                    
                    if ([NullChecker isNull:[tempDictionary objectForKey:@"Phbltyp"]]) {
                        [orderDetailWCMOperationWCDTaggingConditionsArray addObject:@""];
                    }
                    else{
                        [orderDetailWCMOperationWCDTaggingConditionsArray addObject:[tempDictionary objectForKey:@"Phbltyp"]];
                    }
                    
                    if ([NullChecker isNull:[tempDictionary objectForKey:@"Phblnr"]]) {
                        [orderDetailWCMOperationWCDTaggingConditionsArray addObject:@""];
                    }
                    else{
                        [orderDetailWCMOperationWCDTaggingConditionsArray addObject:[tempDictionary objectForKey:@"Phblnr"]];
                    }
                    
                    if ([NullChecker isNull:[tempDictionary objectForKey:@"Tgflg"]]) {
                        [orderDetailWCMOperationWCDTaggingConditionsArray addObject:@""];
                    }
                    else{
                        [orderDetailWCMOperationWCDTaggingConditionsArray addObject:[tempDictionary objectForKey:@"Tgflg"]];
                    }
                    
                    if ([NullChecker isNull:[tempDictionary objectForKey:@"Tgform"]]) {
                        [orderDetailWCMOperationWCDTaggingConditionsArray addObject:@""];
                    }
                    else{
                        [orderDetailWCMOperationWCDTaggingConditionsArray addObject:[tempDictionary objectForKey:@"Tgform"]];
                    }
                    
                    if ([NullChecker isNull:[tempDictionary objectForKey:@"Tgnr"]]) {
                        [orderDetailWCMOperationWCDTaggingConditionsArray addObject:@""];
                    }
                    else{
                        [orderDetailWCMOperationWCDTaggingConditionsArray addObject:[tempDictionary objectForKey:@"Tgnr"]];
                    }
                    
                    if ([NullChecker isNull:[tempDictionary objectForKey:@"Unform"]]) {
                        [orderDetailWCMOperationWCDTaggingConditionsArray addObject:@""];
                    }
                    else{
                        [orderDetailWCMOperationWCDTaggingConditionsArray addObject:[tempDictionary objectForKey:@"Unform"]];
                    }
                    
                    if ([NullChecker isNull:[tempDictionary objectForKey:@"Unnr"]]) {
                        [orderDetailWCMOperationWCDTaggingConditionsArray addObject:@""];
                    }
                    else{
                        [orderDetailWCMOperationWCDTaggingConditionsArray addObject:[tempDictionary objectForKey:@"Unnr"]];
                    }
                    
                    if ([NullChecker isNull:[tempDictionary objectForKey:@"Control"]]) {
                        [orderDetailWCMOperationWCDTaggingConditionsArray addObject:@""];
                    }
                    else{
                        [orderDetailWCMOperationWCDTaggingConditionsArray addObject:[tempDictionary objectForKey:@"Control"]];
                    }
                    
                    if ([NullChecker isNull:[tempDictionary objectForKey:@"Location"]]) {
                        [orderDetailWCMOperationWCDTaggingConditionsArray addObject:@""];
                    }
                    else{
                        [orderDetailWCMOperationWCDTaggingConditionsArray addObject:[tempDictionary objectForKey:@"Location"]];
                    }
                    
                    if ([NullChecker isNull:[tempDictionary objectForKey:@"Btg"]]) {
                        [orderDetailWCMOperationWCDTaggingConditionsArray addObject:@""];
                    }
                    else{
                        [orderDetailWCMOperationWCDTaggingConditionsArray addObject:[tempDictionary objectForKey:@"Btg"]];
                    }
                    
                    if ([NullChecker isNull:[tempDictionary objectForKey:@"Etg"]]) {
                        [orderDetailWCMOperationWCDTaggingConditionsArray addObject:@""];
                    }
                    else{
                        [orderDetailWCMOperationWCDTaggingConditionsArray addObject:[tempDictionary objectForKey:@"Etg"]];
                    }
                    
                    if ([NullChecker isNull:[tempDictionary objectForKey:@"Bug"]]) {
                        [orderDetailWCMOperationWCDTaggingConditionsArray addObject:@""];
                    }
                    else{
                        [orderDetailWCMOperationWCDTaggingConditionsArray addObject:[tempDictionary objectForKey:@"Bug"]];
                    }
                    
                    if ([NullChecker isNull:[tempDictionary objectForKey:@"Eug"]]) {
                        [orderDetailWCMOperationWCDTaggingConditionsArray addObject:@""];
                    }
                    else{
                        [orderDetailWCMOperationWCDTaggingConditionsArray addObject:[tempDictionary objectForKey:@"Eug"]];
                    }
                    
                    if ([NullChecker isNull:[tempDictionary objectForKey:@"Refobj"]]) {
                        [orderDetailWCMOperationWCDTaggingConditionsArray addObject:@""];
                    }
                    else{
                        [orderDetailWCMOperationWCDTaggingConditionsArray addObject:[tempDictionary objectForKey:@"Refobj"]];
                    }
                    
                    if ([NullChecker isNull:[tempDictionary objectForKey:@"Action"]]) {
                        [orderDetailWCMOperationWCDTaggingConditionsArray addObject:@""];
                    }
                    else{
                        [orderDetailWCMOperationWCDTaggingConditionsArray addObject:[tempDictionary objectForKey:@"Action"]];
                    }
                    
                    [orderWcmOperationWCDTaggingConditionsArray addObject:orderDetailWCMOperationWCDTaggingConditionsArray];
                }
                
                ///
                responseObject = nil;
                
                if ([parsedDictionary objectForKey:@"resultStandardCheckPoints"])
                {
                    
                    responseObject = [parsedDictionary objectForKey:@"resultStandardCheckPoints"];
                    
                    for (int i = 0; i<[responseObject  count]; i++) {
                        
                        NSMutableArray *orderDetailWCMStandardCheckPointsArray = [NSMutableArray new];
                        
                        tempDictionary = [responseObject objectAtIndex:i];
                        if ([NullChecker isNull:[tempDictionary objectForKey:@"Wapinr"]]) {
                            [orderDetailWCMStandardCheckPointsArray addObject:@""];
                        }
                        else{
                            [orderDetailWCMStandardCheckPointsArray addObject:[tempDictionary objectForKey:@"Wapinr"]];
                        }
                        
                        if ([NullChecker isNull:[tempDictionary objectForKey:@"Wapityp"]]) {
                            [orderDetailWCMStandardCheckPointsArray addObject:@""];
                        }
                        else{
                            
                            [orderDetailWCMStandardCheckPointsArray addObject:[tempDictionary objectForKey:@"Wapityp"]];
                        }
                        
                        
                        if ([NullChecker isNull:[tempDictionary objectForKey:@"ChkPointType"]]) {
                            [orderDetailWCMStandardCheckPointsArray addObject:@""];
                        }
                        else{
                            
                            [orderDetailWCMStandardCheckPointsArray addObject:[tempDictionary objectForKey:@"ChkPointType"]];
                        }
                        
                        if ([NullChecker isNull:[tempDictionary objectForKey:@"Wkid"]]) {
                            [orderDetailWCMStandardCheckPointsArray addObject:@""];
                        }
                        else{
                            
                            [orderDetailWCMStandardCheckPointsArray addObject:[tempDictionary objectForKey:@"Wkid"]];
                        }
                        
                        if ([NullChecker isNull:[tempDictionary objectForKey:@"Needid"]]) {
                            [orderDetailWCMStandardCheckPointsArray addObject:@""];
                        }
                        else{
                            [orderDetailWCMStandardCheckPointsArray addObject:[tempDictionary objectForKey:@"Needid"]];
                        }
                        
                        if ([NullChecker isNull:[tempDictionary objectForKey:@"Value"]]) {
                            [orderDetailWCMStandardCheckPointsArray addObject:@""];
                        }
                        else{
                            [orderDetailWCMStandardCheckPointsArray addObject:[tempDictionary objectForKey:@"Value"]];
                        }
                        
                        
                        if ([NullChecker isNull:[tempDictionary objectForKey:@"Desctext"]]) {
                            [orderDetailWCMStandardCheckPointsArray addObject:@""];
                        }
                        else{
                            [orderDetailWCMStandardCheckPointsArray addObject:[tempDictionary objectForKey:@"Desctext"]];
                        }
                        
                        
                        if ([NullChecker isNull:[tempDictionary objectForKey:@"Wkgrp"]]) {
                            [orderDetailWCMStandardCheckPointsArray addObject:@""];
                        }
                        else{
                            [orderDetailWCMStandardCheckPointsArray addObject:[tempDictionary objectForKey:@"Wkgrp"]];
                        }
                        
                        if ([NullChecker isNull:[tempDictionary objectForKey:@"Needgrp"]]) {
                            [orderDetailWCMStandardCheckPointsArray addObject:@""];
                        }
                        else{
                            [orderDetailWCMStandardCheckPointsArray addObject:[tempDictionary objectForKey:@"Needgrp"]];
                        }
                        
                        if ([NullChecker isNull:[tempDictionary objectForKey:@"Tplnr"]]) {
                            [orderDetailWCMStandardCheckPointsArray addObject:@""];
                        }
                        else{
                            [orderDetailWCMStandardCheckPointsArray addObject:[tempDictionary objectForKey:@"Tplnr"]];
                        }
                        
                        if ([NullChecker isNull:[tempDictionary objectForKey:@"Equnr"]]) {
                            [orderDetailWCMStandardCheckPointsArray addObject:@""];
                        }
                        else{
                            [orderDetailWCMStandardCheckPointsArray addObject:[tempDictionary objectForKey:@"Equnr"]];
                        }
                        
                        [orderDetailWCMStandardCheckPointsArray addObject:@""];
                        
                        [orderDetailWCMStandardCheckPointsArray addObject:@""];
                        
                        
                        [orderWcmPermitsStandardCheckPoints addObject:orderDetailWCMStandardCheckPointsArray];
                    }
                }
                
                
                NSMutableDictionary *orderWCMOperationWCDDictionary = [[NSMutableDictionary alloc] init];
                responseObject = nil;
                
                NSMutableDictionary *tempWCMOperationWCDDictionary;
                
                if ([parsedDictionary objectForKey:@"resultOperationWCDData"]) {
                    
                    responseObject = [parsedDictionary objectForKey:@"resultOperationWCDData"];
                    
                    [orderWcmOperationWCDArray addObjectsFromArray:responseObject];
                    
                    for (int i=0; i<[orderWcmOperationWCDArray count]; i++) {
                        
                        if ([[orderWcmOperationWCDArray objectAtIndex:i] isKindOfClass:[NSDictionary class]]) {
                            headerDictionary = [orderWcmOperationWCDArray objectAtIndex:i];
                            if ([orderDetailDictionary objectForKey:[NSString stringWithFormat:@"%lld",[[headerDictionary objectForKey:@"Aufnr"] longLongValue]]]) {
                                if ([orderWCMOperationWCDDictionary objectForKey:[NSString stringWithFormat:@"%lld",[[headerDictionary objectForKey:@"Aufnr"] longLongValue]]]) {
                                    tempWCMOperationWCDDictionary = [orderWCMOperationWCDDictionary objectForKey:[NSString stringWithFormat:@"%lld",[[headerDictionary objectForKey:@"Aufnr"] longLongValue]]];
                                    if ([tempWCMOperationWCDDictionary objectForKey:[headerDictionary objectForKey:@"Wcnr"]]) {
                                        tempWCMOperationWCDDictionary = [tempWCMOperationWCDDictionary objectForKey:[headerDictionary objectForKey:@"Wcnr"]];
                                        [tempWCMOperationWCDDictionary addEntriesFromDictionary:headerDictionary];
                                    }
                                    else{
                                        [tempWCMOperationWCDDictionary setObject:[NSMutableDictionary dictionaryWithDictionary:headerDictionary] forKey:[headerDictionary objectForKey:@"Wcnr"]];
                                    }
                                }
                                else
                                {
                                    [orderWCMOperationWCDDictionary setObject:[NSMutableDictionary dictionaryWithObject:[NSMutableDictionary dictionaryWithDictionary:headerDictionary] forKey:[headerDictionary objectForKey:@"Wcnr"]] forKey:[NSString stringWithFormat:@"%lld",[[headerDictionary objectForKey:@"Aufnr"] longLongValue]]];
                                }
                            }
                        }
                    }
                }
                
                [orderWcmOperationWCDArray removeAllObjects];
                
                ///
                responseObject = nil;
                
                NSMutableDictionary *orderStatusDictionary = [[NSMutableDictionary alloc] init];
                
                NSMutableDictionary *tempOrderStatusDictionary;
                
                if ([parsedDictionary objectForKey:@"resultOrderStatus"]) {
                    
                    responseObject = [parsedDictionary objectForKey:@"resultOrderStatus"];
                    
                    [orderStatusArray addObjectsFromArray:responseObject];
                    
                    for (int i=0; i<[orderStatusArray count]; i++) {
                        
                        if ([[orderStatusArray objectAtIndex:i] isKindOfClass:[NSDictionary class]]) {
                            
                            headerDictionary = [orderStatusArray objectAtIndex:i];
                            
                            if ([orderDetailDictionary objectForKey:[headerDictionary objectForKey:@"Aufnr"]]) {
                                
                                if ([orderStatusDictionary objectForKey:[headerDictionary objectForKey:@"Aufnr"]]) {
                                    
                                    tempOrderStatusDictionary = [orderStatusDictionary objectForKey:[headerDictionary objectForKey:@"Aufnr"]];
                                    
                                    if ([tempOrderStatusDictionary objectForKey:[headerDictionary objectForKey:@"Objnr"]]) {
                                        
                                        tempOrderStatusDictionary = [tempOrderStatusDictionary objectForKey:[headerDictionary objectForKey:@"Objnr"]];
                                        
                                        if ([tempOrderStatusDictionary objectForKey:@"SystemStatus"]) {
                                            
                                            NSMutableArray *systemStatusArray = [tempOrderStatusDictionary objectForKey:@"SystemStatus"];
                                            
                                            [systemStatusArray addObject:[NSMutableDictionary dictionaryWithDictionary:headerDictionary]];
                                        }
                                        else
                                        {
                                            [tempOrderStatusDictionary setObject:[NSMutableArray arrayWithObject:[NSMutableDictionary dictionaryWithDictionary:headerDictionary]] forKey:@"SystemStatus"];
                                        }
                                    }
                                    else
                                    {
                                        [tempOrderStatusDictionary setObject:[NSMutableDictionary dictionaryWithDictionary:headerDictionary] forKey:[headerDictionary objectForKey:@"Objnr"]];
                                    }
                                }
                                else
                                {
                                    [orderStatusDictionary setObject:[NSMutableDictionary dictionaryWithObject:[NSMutableDictionary dictionaryWithDictionary:headerDictionary] forKey:[headerDictionary objectForKey:@"Objnr"]] forKey:[headerDictionary objectForKey:@"Aufnr"]];
                                }
                            }
                        }
                    }
                }
                
                [orderStatusArray removeAllObjects];
                
                if ([parsedDictionary objectForKey:@"resultLongText"]) {
                    
                    responseObject = [parsedDictionary objectForKey:@"resultLongText"];
                    
                    NSMutableArray *orderTextnArray = [[NSMutableArray alloc] init];
                    if ([responseObject isKindOfClass:[NSDictionary class]]) {
                        [orderTextnArray addObject:responseObject];
                    }
                    else if ([responseObject isKindOfClass:[NSArray class]])
                    {
                        [orderTextnArray addObjectsFromArray:responseObject];
                    }
                    
                    NSDictionary *textDictionary;
                    for (int i=0; i<[orderTextnArray count]; i++) {
                        if ([[orderTextnArray objectAtIndex:i] isKindOfClass:[NSDictionary class]]) {
                            textDictionary = [orderTextnArray objectAtIndex:i];
                            if ([orderDetailDictionary objectForKey:[textDictionary objectForKey:@"Aufnr"]]) {
                                if ([textDictionary objectForKey:@"Activity"]) {
                                    tempDictionary = [orderTransactionDictionary objectForKey:[textDictionary objectForKey:@"Aufnr"]];
                                    if (tempDictionary) {
                                        tempDictionary = [tempDictionary objectForKey:[textDictionary objectForKey:@"Activity"]];
                                        if (tempDictionary) {
                                            id longText = [tempDictionary objectForKey:@"OPTLONGTEXT"];
                                            NSString *textLine = [textDictionary objectForKey:@"TextLine"];
                                            if (!textLine.length) {
                                                textLine = @"";
                                            }
                                            if ([longText length]) {
                                                [tempDictionary setObject:[NSString stringWithFormat:@"%@\n%@",longText,textLine] forKey:@"OPTLONGTEXT"];
                                            }
                                            else
                                            {
                                                [tempDictionary setObject:[NSString stringWithString:textLine] forKey:@"OPTLONGTEXT"];
                                            }
                                        }
                                    }
                                }
                                else
                                {
                                    NSMutableDictionary *headerDictionary = [[orderDetailDictionary objectForKey:[textDictionary objectForKey:@"Aufnr"]] firstObject];
                                    NSString *textLine = [textDictionary objectForKey:@"TextLine"];
                                    
                                    if (!textLine.length) {
                                        textLine = @"";
                                    }
                                    
                                    if ([[headerDictionary objectForKey:@"LONGTEXT"] length]) {
                                        [headerDictionary setObject:[NSString stringWithFormat:@"%@\n%@",[headerDictionary objectForKey:@"LONGTEXT"],textLine] forKey:@"LONGTEXT"];
                                    }
                                    else
                                    {
                                        [headerDictionary setObject:[NSString stringWithFormat:@"%@",textLine] forKey:@"LONGTEXT"];
                                    }
                                }
                            }
                        }
                    }
                    
                    [orderTransactionArray removeAllObjects];
                }
                
                /////
                responseObject = nil;
                
                [orderWcmWorkApplicationListArray addObjectsFromArray:[orderWCMWorkApplicationListDictionary allKeys]];
                
                NSArray *recordIDWCMWorkApplicationListArray;
                NSDictionary *WCMWorkApplicationListDictionary;
                
                for (int i =0; i<[orderWcmWorkApplicationListArray  count]; i++) {
                    
                    NSMutableArray *wcmWorkApplicationListArray = [NSMutableArray new];
                    
                    WCMWorkApplicationListDictionary = [orderWCMWorkApplicationListDictionary objectForKey:[orderWcmWorkApplicationListArray objectAtIndex:i]];
                    recordIDWCMWorkApplicationListArray = [WCMWorkApplicationListDictionary allKeys];
                    
                    for (int j=0; j<[recordIDWCMWorkApplicationListArray count]; j++) {
                        
                        NSMutableArray *orderDetailWCMWorkApplicationListArray = [NSMutableArray new];
                        
                        tempDictionary = [WCMWorkApplicationListDictionary objectForKey:[recordIDWCMWorkApplicationListArray objectAtIndex:j]];
                        if ([NullChecker isNull:[tempDictionary objectForKey:@"Aufnr"]]) {
                            [orderDetailWCMWorkApplicationListArray addObject:@""];
                        }
                        else{
                            [orderDetailWCMWorkApplicationListArray addObject:[NSString stringWithFormat:@"%lld",[[tempDictionary objectForKey:@"Aufnr"] longLongValue]]];
                        }
                        
                        if ([NullChecker isNull:[tempDictionary objectForKey:@"Objart"]]) {
                            [orderDetailWCMWorkApplicationListArray addObject:@""];
                        }
                        else{
                            
                            [orderDetailWCMWorkApplicationListArray addObject:[tempDictionary objectForKey:@"Objart"]];
                        }
                        
                        if ([NullChecker isNull:[tempDictionary objectForKey:@"Wapinr"]]) {
                            [orderDetailWCMWorkApplicationListArray addObject:@""];
                        }
                        else{
                            [orderDetailWCMWorkApplicationListArray addObject:[tempDictionary objectForKey:@"Wapinr"]];
                        }
                        
                        if ([NullChecker isNull:[tempDictionary objectForKey:@"Iwerk"]]) {
                            [orderDetailWCMWorkApplicationListArray addObject:@""];
                        }
                        else{
                            [orderDetailWCMWorkApplicationListArray addObject:[tempDictionary objectForKey:@"Iwerk"]];
                        }
                        
                        if ([NullChecker isNull:[tempDictionary objectForKey:@"Objtyp"]]) {
                            [orderDetailWCMWorkApplicationListArray addObject:@""];
                        }
                        else{
                            [orderDetailWCMWorkApplicationListArray addObject:[tempDictionary objectForKey:@"Objtyp"]];
                        }
                        
                        if ([NullChecker isNull:[tempDictionary objectForKey:@"Usage"]]) {
                            [orderDetailWCMWorkApplicationListArray addObject:@""];
                        }
                        else{
                            [orderDetailWCMWorkApplicationListArray addObject:[tempDictionary objectForKey:@"Usage"]];
                        }
                        
                        if ([NullChecker isNull:[tempDictionary objectForKey:@"Usagex"]]) {
                            [orderDetailWCMWorkApplicationListArray addObject:@""];
                        }
                        else{
                            [orderDetailWCMWorkApplicationListArray addObject:[tempDictionary objectForKey:@"Usagex"]];
                        }
                        
                        if ([NullChecker isNull:[tempDictionary objectForKey:@"Train"]]) {
                            [orderDetailWCMWorkApplicationListArray addObject:@""];
                        }
                        else{
                            [orderDetailWCMWorkApplicationListArray addObject:[tempDictionary objectForKey:@"Train"]];
                        }
                        
                        if ([NullChecker isNull:[tempDictionary objectForKey:@"Trainx"]]) {
                            [orderDetailWCMWorkApplicationListArray addObject:@""];
                        }
                        else{
                            [orderDetailWCMWorkApplicationListArray addObject:[tempDictionary objectForKey:@"Trainx"]];
                        }
                        
                        if ([NullChecker isNull:[tempDictionary objectForKey:@"Anlzu"]]) {
                            [orderDetailWCMWorkApplicationListArray addObject:@""];
                        }
                        else{
                            [orderDetailWCMWorkApplicationListArray addObject:[tempDictionary objectForKey:@"Anlzu"]];
                        }
                        
                        if ([NullChecker isNull:[tempDictionary objectForKey:@"Anlzux"]]) {
                            [orderDetailWCMWorkApplicationListArray addObject:@""];
                        }
                        else{
                            [orderDetailWCMWorkApplicationListArray addObject:[tempDictionary objectForKey:@"Anlzux"]];
                        }
                        
                        if ([NullChecker isNull:[tempDictionary objectForKey:@"Etape"]]) {
                            [orderDetailWCMWorkApplicationListArray addObject:@""];
                        }
                        else{
                            [orderDetailWCMWorkApplicationListArray addObject:[tempDictionary objectForKey:@"Etape"]];
                        }
                        
                        if ([NullChecker isNull:[tempDictionary objectForKey:@"Etapex"]]) {
                            [orderDetailWCMWorkApplicationListArray addObject:@""];
                        }
                        else{
                            [orderDetailWCMWorkApplicationListArray addObject:[tempDictionary objectForKey:@"Etapex"]];
                        }
                        
                        if ([NullChecker isNull:[tempDictionary objectForKey:@"Stxt"]]) {
                            [orderDetailWCMWorkApplicationListArray addObject:@""];
                        }
                        else{
                            [orderDetailWCMWorkApplicationListArray addObject:[tempDictionary objectForKey:@"Stxt"]];
                        }
                        
                        if ([NullChecker isNull:[tempDictionary objectForKey:@"Datefr"]]) {
                            [orderDetailWCMWorkApplicationListArray addObject:@""];
                        }
                        else{
                            [orderDetailWCMWorkApplicationListArray addObject:[tempDictionary objectForKey:@"Datefr"]];
                        }
                        
                        if ([NullChecker isNull:[tempDictionary objectForKey:@"Timefr"]]) {
                            [orderDetailWCMWorkApplicationListArray addObject:@""];
                        }
                        else{
                            [orderDetailWCMWorkApplicationListArray addObject:[tempDictionary objectForKey:@"Timefr"]];
                        }
                        
                        if ([NullChecker isNull:[tempDictionary objectForKey:@"Dateto"]]) {
                            [orderDetailWCMWorkApplicationListArray addObject:@""];
                        }
                        else{
                            [orderDetailWCMWorkApplicationListArray addObject:[tempDictionary objectForKey:@"Dateto"]];
                        }
                        
                        if ([NullChecker isNull:[tempDictionary objectForKey:@"Timeto"]]) {
                            [orderDetailWCMWorkApplicationListArray addObject:@""];
                        }
                        else{
                            [orderDetailWCMWorkApplicationListArray addObject:[tempDictionary objectForKey:@"Timeto"]];
                        }
                        
                        if ([NullChecker isNull:[tempDictionary objectForKey:@"Priok"]]) {
                            [orderDetailWCMWorkApplicationListArray addObject:@""];
                        }
                        else{
                            [orderDetailWCMWorkApplicationListArray addObject:[tempDictionary objectForKey:@"Priok"]];
                        }
                        
                        if ([NullChecker isNull:[tempDictionary objectForKey:@"Priokx"]]) {
                            [orderDetailWCMWorkApplicationListArray addObject:@""];
                        }
                        else{
                            [orderDetailWCMWorkApplicationListArray addObject:[tempDictionary objectForKey:@"Priokx"]];
                        }
                        
                        if ([NullChecker isNull:[tempDictionary objectForKey:@"Rctime"]]) {
                            [orderDetailWCMWorkApplicationListArray addObject:@""];
                        }
                        else{
                            [orderDetailWCMWorkApplicationListArray addObject:[tempDictionary objectForKey:@"Rctime"]];
                        }
                        
                        if ([NullChecker isNull:[tempDictionary objectForKey:@"Rcunit"]]) {
                            [orderDetailWCMWorkApplicationListArray addObject:@""];
                        }
                        else{
                            [orderDetailWCMWorkApplicationListArray addObject:[tempDictionary objectForKey:@"Rcunit"]];
                        }
                        
                        if ([NullChecker isNull:[tempDictionary objectForKey:@"Objnr"]]) {
                            [orderDetailWCMWorkApplicationListArray addObject:@""];
                        }
                        else{
                            [orderDetailWCMWorkApplicationListArray addObject:[tempDictionary objectForKey:@"Objnr"]];
                        }
                        
                        if ([NullChecker isNull:[tempDictionary objectForKey:@"Refobj"]]) {
                            [orderDetailWCMWorkApplicationListArray addObject:@""];
                        }
                        else{
                            [orderDetailWCMWorkApplicationListArray addObject:[tempDictionary objectForKey:@"Refobj"]];
                        }
                        
                        if ([NullChecker isNull:[tempDictionary objectForKey:@"Crea"]]) {
                            [orderDetailWCMWorkApplicationListArray addObject:@""];
                        }
                        else{
                            [orderDetailWCMWorkApplicationListArray addObject:[tempDictionary objectForKey:@"Crea"]];
                        }
                        
                        if ([NullChecker isNull:[tempDictionary objectForKey:@"Prep"]]) {
                            [orderDetailWCMWorkApplicationListArray addObject:@""];
                        }
                        else{
                            [orderDetailWCMWorkApplicationListArray addObject:[tempDictionary objectForKey:@"Prep"]];
                        }
                        
                        if ([NullChecker isNull:[tempDictionary objectForKey:@"Comp"]]) {
                            [orderDetailWCMWorkApplicationListArray addObject:@""];
                        }
                        else{
                            [orderDetailWCMWorkApplicationListArray addObject:[tempDictionary objectForKey:@"Comp"]];
                        }
                        
                        if ([NullChecker isNull:[tempDictionary objectForKey:@"Appr"]]) {
                            [orderDetailWCMWorkApplicationListArray addObject:@""];
                        }
                        else{
                            [orderDetailWCMWorkApplicationListArray addObject:[tempDictionary objectForKey:@"Appr"]];
                        }
                        
                        if ([NullChecker isNull:[tempDictionary objectForKey:@"Action"]]) {
                            [orderDetailWCMWorkApplicationListArray addObject:@""];//Action
                        }
                        else{
                            [orderDetailWCMWorkApplicationListArray addObject:[tempDictionary objectForKey:@"Action"]];
                        }
                        
                        if ([NullChecker isNull:[tempDictionary objectForKey:@"Begru"]]) {
                            [orderDetailWCMWorkApplicationListArray addObject:@""];
                        }
                        else{
                            [orderDetailWCMWorkApplicationListArray addObject:[tempDictionary objectForKey:@"Begru"]];
                        }
                        
                        if ([NullChecker isNull:[tempDictionary objectForKey:@"Begtx"]]) {
                            [orderDetailWCMWorkApplicationListArray addObject:@""];
                        }
                        else{
                            [orderDetailWCMWorkApplicationListArray addObject:[tempDictionary objectForKey:@"Begtx"]];
                        }
                        
                        [wcmWorkApplicationListArray addObject:orderDetailWCMWorkApplicationListArray];
                    }
                    
                    [[orderDetailDictionary objectForKey:[orderWcmWorkApplicationListArray objectAtIndex:i]] replaceObjectAtIndex:8 withObject:wcmWorkApplicationListArray];
                }
                
                [orderWcmWorkApplicationListArray removeAllObjects];
                
                /////
                responseObject = nil;
                
                [orderWcmOperationWCDArray addObjectsFromArray:[orderWCMOperationWCDDictionary allKeys]];
                
                NSArray *recordIDWCMOperationWCDListArray;
                NSDictionary *WCMOperationWCDListDictionary;
                
                for (int i =0; i<[orderWcmOperationWCDArray  count]; i++) {
                    
                    NSMutableArray *wcmOperationWCDListArray = [NSMutableArray new];
                    
                    WCMOperationWCDListDictionary = [orderWCMOperationWCDDictionary objectForKey:[orderWcmOperationWCDArray objectAtIndex:i]];
                    recordIDWCMOperationWCDListArray = [WCMOperationWCDListDictionary allKeys];
                    
                    for (int j=0; j<[recordIDWCMOperationWCDListArray count]; j++) {
                        
                        NSMutableArray *orderDetailWCMOperationWCDListArray = [NSMutableArray new];
                        
                        tempDictionary = [WCMOperationWCDListDictionary objectForKey:[recordIDWCMOperationWCDListArray objectAtIndex:j]];
                        if ([NullChecker isNull:[tempDictionary objectForKey:@"Aufnr"]]) {
                            [orderDetailWCMOperationWCDListArray addObject:@""];
                        }
                        else{
                            [orderDetailWCMOperationWCDListArray addObject:[NSString stringWithFormat:@"%lld",[[tempDictionary objectForKey:@"Aufnr"] longLongValue]]];
                        }
                        
                        if ([NullChecker isNull:[tempDictionary objectForKey:@"Objart"]]) {
                            [orderDetailWCMOperationWCDListArray addObject:@""];
                        }
                        else{
                            
                            [orderDetailWCMOperationWCDListArray addObject:[tempDictionary objectForKey:@"Objart"]];
                        }
                        
                        if ([NullChecker isNull:[tempDictionary objectForKey:@"Wcnr"]]) {
                            [orderDetailWCMOperationWCDListArray addObject:@""];
                        }
                        else{
                            [orderDetailWCMOperationWCDListArray addObject:[tempDictionary objectForKey:@"Wcnr"]];
                        }
                        
                        if ([NullChecker isNull:[tempDictionary objectForKey:@"Iwerk"]]) {
                            [orderDetailWCMOperationWCDListArray addObject:@""];
                        }
                        else{
                            [orderDetailWCMOperationWCDListArray addObject:[tempDictionary objectForKey:@"Iwerk"]];
                        }
                        
                        if ([NullChecker isNull:[tempDictionary objectForKey:@"Objtyp"]]) {
                            [orderDetailWCMOperationWCDListArray addObject:@""];
                        }
                        else{
                            [orderDetailWCMOperationWCDListArray addObject:[tempDictionary objectForKey:@"Objtyp"]];
                        }
                        
                        if ([NullChecker isNull:[tempDictionary objectForKey:@"Usage"]]) {
                            [orderDetailWCMOperationWCDListArray addObject:@""];
                        }
                        else{
                            [orderDetailWCMOperationWCDListArray addObject:[tempDictionary objectForKey:@"Usage"]];
                        }
                        
                        if ([NullChecker isNull:[tempDictionary objectForKey:@"Usagex"]]) {
                            [orderDetailWCMOperationWCDListArray addObject:@""];
                        }
                        else{
                            [orderDetailWCMOperationWCDListArray addObject:[tempDictionary objectForKey:@"Usagex"]];
                        }
                        
                        if ([NullChecker isNull:[tempDictionary objectForKey:@"Train"]]) {
                            [orderDetailWCMOperationWCDListArray addObject:@""];
                        }
                        else{
                            [orderDetailWCMOperationWCDListArray addObject:[tempDictionary objectForKey:@"Train"]];
                        }
                        
                        if ([NullChecker isNull:[tempDictionary objectForKey:@"Trainx"]]) {
                            [orderDetailWCMOperationWCDListArray addObject:@""];
                        }
                        else{
                            [orderDetailWCMOperationWCDListArray addObject:[tempDictionary objectForKey:@"Trainx"]];
                        }
                        
                        if ([NullChecker isNull:[tempDictionary objectForKey:@"Anlzu"]]) {
                            [orderDetailWCMOperationWCDListArray addObject:@""];
                        }
                        else{
                            [orderDetailWCMOperationWCDListArray addObject:[tempDictionary objectForKey:@"Anlzu"]];
                        }
                        
                        if ([NullChecker isNull:[tempDictionary objectForKey:@"Anlzux"]]) {
                            [orderDetailWCMOperationWCDListArray addObject:@""];
                        }
                        else{
                            [orderDetailWCMOperationWCDListArray addObject:[tempDictionary objectForKey:@"Anlzux"]];
                        }
                        
                        if ([NullChecker isNull:[tempDictionary objectForKey:@"Etape"]]) {
                            [orderDetailWCMOperationWCDListArray addObject:@""];
                        }
                        else{
                            [orderDetailWCMOperationWCDListArray addObject:[tempDictionary objectForKey:@"Etape"]];
                        }
                        
                        if ([NullChecker isNull:[tempDictionary objectForKey:@"Etapex"]]) {
                            [orderDetailWCMOperationWCDListArray addObject:@""];
                        }
                        else{
                            [orderDetailWCMOperationWCDListArray addObject:[tempDictionary objectForKey:@"Etapex"]];
                        }
                        
                        if ([NullChecker isNull:[tempDictionary objectForKey:@"Stxt"]]) {
                            [orderDetailWCMOperationWCDListArray addObject:@""];
                        }
                        else{
                            [orderDetailWCMOperationWCDListArray addObject:[tempDictionary objectForKey:@"Stxt"]];
                        }
                        
                        if ([NullChecker isNull:[tempDictionary objectForKey:@"Datefr"]]) {
                            [orderDetailWCMOperationWCDListArray addObject:@""];
                        }
                        else{
                            [orderDetailWCMOperationWCDListArray addObject:[tempDictionary objectForKey:@"Datefr"]];
                        }
                        
                        if ([NullChecker isNull:[tempDictionary objectForKey:@"Timefr"]]) {
                            [orderDetailWCMOperationWCDListArray addObject:@""];
                        }
                        else{
                            [orderDetailWCMOperationWCDListArray addObject:[tempDictionary objectForKey:@"Timefr"]];
                        }
                        
                        if ([NullChecker isNull:[tempDictionary objectForKey:@"Dateto"]]) {
                            [orderDetailWCMOperationWCDListArray addObject:@""];
                        }
                        else{
                            [orderDetailWCMOperationWCDListArray addObject:[tempDictionary objectForKey:@"Dateto"]];
                        }
                        
                        if ([NullChecker isNull:[tempDictionary objectForKey:@"Timeto"]]) {
                            [orderDetailWCMOperationWCDListArray addObject:@""];
                        }
                        else{
                            [orderDetailWCMOperationWCDListArray addObject:[tempDictionary objectForKey:@"Timeto"]];
                        }
                        
                        if ([NullChecker isNull:[tempDictionary objectForKey:@"Priok"]]) {
                            [orderDetailWCMOperationWCDListArray addObject:@""];
                        }
                        else{
                            [orderDetailWCMOperationWCDListArray addObject:[tempDictionary objectForKey:@"Priok"]];
                        }
                        
                        if ([NullChecker isNull:[tempDictionary objectForKey:@"Priokx"]]) {
                            [orderDetailWCMOperationWCDListArray addObject:@""];
                        }
                        else{
                            [orderDetailWCMOperationWCDListArray addObject:[tempDictionary objectForKey:@"Priokx"]];
                        }
                        
                        if ([NullChecker isNull:[tempDictionary objectForKey:@"Rctime"]]) {
                            [orderDetailWCMOperationWCDListArray addObject:@""];
                        }
                        else{
                            [orderDetailWCMOperationWCDListArray addObject:[tempDictionary objectForKey:@"Rctime"]];
                        }
                        
                        if ([NullChecker isNull:[tempDictionary objectForKey:@"Rcunit"]]) {
                            [orderDetailWCMOperationWCDListArray addObject:@""];
                        }
                        else{
                            [orderDetailWCMOperationWCDListArray addObject:[tempDictionary objectForKey:@"Rcunit"]];
                        }
                        
                        if ([NullChecker isNull:[tempDictionary objectForKey:@"Objnr"]]) {
                            [orderDetailWCMOperationWCDListArray addObject:@""];
                        }
                        else{
                            [orderDetailWCMOperationWCDListArray addObject:[tempDictionary objectForKey:@"Objnr"]];
                        }
                        
                        if ([NullChecker isNull:[tempDictionary objectForKey:@"Refobj"]]) {
                            [orderDetailWCMOperationWCDListArray addObject:@""];
                        }
                        else{
                            [orderDetailWCMOperationWCDListArray addObject:[tempDictionary objectForKey:@"Refobj"]];
                        }
                        
                        if ([NullChecker isNull:[tempDictionary objectForKey:@"Crea"]]) {
                            [orderDetailWCMOperationWCDListArray addObject:@""];
                        }
                        else{
                            [orderDetailWCMOperationWCDListArray addObject:[tempDictionary objectForKey:@"Crea"]];
                        }
                        
                        if ([NullChecker isNull:[tempDictionary objectForKey:@"Prep"]]) {
                            [orderDetailWCMOperationWCDListArray addObject:@""];
                        }
                        else{
                            [orderDetailWCMOperationWCDListArray addObject:[tempDictionary objectForKey:@"Prep"]];
                        }
                        
                        if ([NullChecker isNull:[tempDictionary objectForKey:@"Comp"]]) {
                            [orderDetailWCMOperationWCDListArray addObject:@""];
                        }
                        else{
                            [orderDetailWCMOperationWCDListArray addObject:[tempDictionary objectForKey:@"Comp"]];
                        }
                        
                        if ([NullChecker isNull:[tempDictionary objectForKey:@"Appr"]]) {
                            [orderDetailWCMOperationWCDListArray addObject:@""];
                        }
                        else{
                            [orderDetailWCMOperationWCDListArray addObject:[tempDictionary objectForKey:@"Appr"]];
                        }
                        
                        if ([NullChecker isNull:[tempDictionary objectForKey:@"Action"]]) {
                            [orderDetailWCMOperationWCDListArray addObject:@""];//Action
                        }
                        else{
                            [orderDetailWCMOperationWCDListArray addObject:[tempDictionary objectForKey:@"Action"]];
                        }
                        
                        if ([NullChecker isNull:[tempDictionary objectForKey:@"Begru"]]) {
                            [orderDetailWCMOperationWCDListArray addObject:@""];
                        }
                        else{
                            [orderDetailWCMOperationWCDListArray addObject:[tempDictionary objectForKey:@"Begru"]];
                        }
                        
                        if ([NullChecker isNull:[tempDictionary objectForKey:@"Begtx"]]) {
                            [orderDetailWCMOperationWCDListArray addObject:@""];
                        }
                        else{
                            [orderDetailWCMOperationWCDListArray addObject:[tempDictionary objectForKey:@"Begtx"]];
                        }
                        
                        
                        if ([NullChecker isNull:[tempDictionary objectForKey:@"Tagtext"]]) {
                            [orderDetailWCMOperationWCDListArray addObject:@""];
                        }
                        else{
                            
                            id   responseTagObject = [tempDictionary objectForKey:@"Tagtext"];
                            
                            NSMutableArray *orderTagTextArray = [[NSMutableArray alloc] init];
                            if ([[responseTagObject objectForKey:@"item"] isKindOfClass:[NSDictionary class]]) {
                                [orderTagTextArray addObject:[responseTagObject objectForKey:@"item"]];
                            }
                            else if ([[responseTagObject objectForKey:@"item"] isKindOfClass:[NSArray class]])
                            {
                                [orderTagTextArray addObjectsFromArray:[responseTagObject objectForKey:@"item"]];
                            }
                            
                            NSMutableString *taggingText=[[NSMutableString alloc] initWithString:@""];
                            
                            for (int t=0; t<[orderTagTextArray count]; t++) {
                                
                                NSString *textLine = [[orderTagTextArray objectAtIndex:t] objectForKey:@"TextLine"];
                                if (!textLine.length) {
                                    textLine = @"";
                                }
                                
                                [taggingText appendString:[NSString stringWithFormat:@"%@\n",textLine]];
                                
                            }
                            
                            [orderDetailWCMOperationWCDListArray addObject:taggingText];
                            
                        }
                        
                        
                        if ([NullChecker isNull:[tempDictionary objectForKey:@"Untagtext"]]) {
                            [orderDetailWCMOperationWCDListArray addObject:@""];
                        }
                        else{
                            
                            id   responseUnTagObject = [tempDictionary objectForKey:@"Untagtext"];
                            
                            NSMutableArray *orderUnTagTextArray = [[NSMutableArray alloc] init];
                            if ([[responseUnTagObject objectForKey:@"item"] isKindOfClass:[NSDictionary class]]) {
                                [orderUnTagTextArray addObject:[responseUnTagObject objectForKey:@"item"]];
                            }
                            else if ([[responseUnTagObject objectForKey:@"item"] isKindOfClass:[NSArray class]])
                            {
                                [orderUnTagTextArray addObjectsFromArray:[responseUnTagObject objectForKey:@"item"]];
                            }
                            
                            NSMutableString *unTaggingText=[[NSMutableString alloc] initWithString:@""];
                            
                            for (int t=0; t<[orderUnTagTextArray count]; t++) {
                                
                                NSString *textLine = [[orderUnTagTextArray objectAtIndex:t] objectForKey:@"TextLine"];
                                if (!textLine.length) {
                                    textLine = @"";
                                }
                                
                                [unTaggingText appendString:[NSString stringWithFormat:@"%@\n",textLine]];
                            }
                            
                            [orderDetailWCMOperationWCDListArray addObject:unTaggingText];
                            
                        }
                        
                        
                        //                            CREATE TABLE "ORDER_WCM_OPERATIONWCD" ("orderwcm_header_id" VARCHAR,"orderwcm_objart" VARCHAR,"orderwcm_wcnr" VARCHAR,"orderwcm_iwerk" VARCHAR,"orderwcm_objtyp" VARCHAR,"orderwcm_usage" VARCHAR,"orderwcm_usagex" VARCHAR,"orderwcm_train" VARCHAR,"orderwcm_trainx" VARCHAR,"orderwcm_anlzu" VARCHAR,"orderwcm_anlzux" VARCHAR,"orderwcm_etape" VARCHAR,"orderwcm_etapex" VARCHAR,"orderwcm_stxt" VARCHAR,"orderwcm_datefr" VARCHAR,"orderwcm_timefr" VARCHAR,"orderwcm_dateto" VARCHAR,"orderwcm_timeto" VARCHAR,"orderwcm_priok" VARCHAR,"orderwcm_priokx" VARCHAR,"orderwcm_rctime" VARCHAR,"orderwcm_rcunit" VARCHAR,"orderwcm_objnr" VARCHAR,"orderwcm_refobj" VARCHAR,"orderwcm_crea" VARCHAR,"orderwcm_prep" VARCHAR,"orderwcm_comp" VARCHAR,"orderwcm_appr" VARCHAR,"orderwcm_action" VARCHAR, "orderwcm_Begru" VARCHAR, "orderwcm_Begtx" VARCHAR, "orderwcm_tagging_text" VARCHAR, "orderwcm_untagging_text" VARCHAR)
                        
                        [wcmOperationWCDListArray addObject:orderDetailWCMOperationWCDListArray];
                    }
                    
                    [[orderDetailDictionary objectForKey:[orderWcmOperationWCDArray objectAtIndex:i]] replaceObjectAtIndex:10 withObject:wcmOperationWCDListArray];
                }
                
                [orderWcmWorkApplicationListArray removeAllObjects];
                
                /////
                responseObject = nil;
                
                [orderWcmWorkApprovalListArray addObjectsFromArray:[orderWCMWorkApprovalListDictionary allKeys]];
                
                NSArray *recordIDWCMWorkApprovalListArray;
                NSDictionary *WCMWorkApprovalListDictionary;
                
                for (int i =0; i<[orderWcmWorkApprovalListArray  count]; i++) {
                    
                    WCMWorkApprovalListDictionary = [orderWCMWorkApprovalListDictionary objectForKey:[orderWcmWorkApprovalListArray objectAtIndex:i]];
                    recordIDWCMWorkApprovalListArray = [WCMWorkApprovalListDictionary allKeys];
                    NSMutableArray *wcmWorkApprovalListArray = [NSMutableArray new];
                    
                    for (int j=0; j<[recordIDWCMWorkApprovalListArray count]; j++) {
                        
                        NSMutableArray *orderDetailWCMWorkApprovalListArray = [NSMutableArray new];
                        
                        tempDictionary = [WCMWorkApprovalListDictionary objectForKey:[recordIDWCMWorkApprovalListArray objectAtIndex:j]];
                        if ([NullChecker isNull:[tempDictionary objectForKey:@"Aufnr"]]) {
                            [orderDetailWCMWorkApprovalListArray addObject:@""];
                        }
                        else{
                            [orderDetailWCMWorkApprovalListArray addObject:[NSString stringWithFormat:@"%lld",[[tempDictionary objectForKey:@"Aufnr"] longLongValue]]];
                        }
                        
                        if ([NullChecker isNull:[tempDictionary objectForKey:@"Objart"]]) {
                            [orderDetailWCMWorkApprovalListArray addObject:@""];
                        }
                        else{
                            
                            [orderDetailWCMWorkApprovalListArray addObject:[tempDictionary objectForKey:@"Objart"]];
                        }
                        
                        if ([NullChecker isNull:[tempDictionary objectForKey:@"Wapnr"]]) {
                            [orderDetailWCMWorkApprovalListArray addObject:@""];
                        }
                        else{
                            [orderDetailWCMWorkApprovalListArray addObject:[tempDictionary objectForKey:@"Wapnr"]];
                        }
                        
                        if ([NullChecker isNull:[tempDictionary objectForKey:@"Iwerk"]]) {
                            [orderDetailWCMWorkApprovalListArray addObject:@""];
                        }
                        else{
                            [orderDetailWCMWorkApprovalListArray addObject:[tempDictionary objectForKey:@"Iwerk"]];
                        }
                        
                        if ([NullChecker isNull:[tempDictionary objectForKey:@"Usage"]]) {
                            [orderDetailWCMWorkApprovalListArray addObject:@""];
                        }
                        else{
                            [orderDetailWCMWorkApprovalListArray addObject:[tempDictionary objectForKey:@"Usage"]];
                        }
                        
                        if ([NullChecker isNull:[tempDictionary objectForKey:@"Usagex"]]) {
                            [orderDetailWCMWorkApprovalListArray addObject:@""];
                        }
                        else{
                            [orderDetailWCMWorkApprovalListArray addObject:[tempDictionary objectForKey:@"Usagex"]];
                        }
                        
                        if ([NullChecker isNull:[tempDictionary objectForKey:@"Train"]]) {
                            [orderDetailWCMWorkApprovalListArray addObject:@""];
                        }
                        else{
                            [orderDetailWCMWorkApprovalListArray addObject:[tempDictionary objectForKey:@"Train"]];
                        }
                        
                        if ([NullChecker isNull:[tempDictionary objectForKey:@"Trainx"]]) {
                            [orderDetailWCMWorkApprovalListArray addObject:@""];
                        }
                        else{
                            [orderDetailWCMWorkApprovalListArray addObject:[tempDictionary objectForKey:@"Trainx"]];
                        }
                        
                        if ([NullChecker isNull:[tempDictionary objectForKey:@"Anlzu"]]) {
                            [orderDetailWCMWorkApprovalListArray addObject:@""];
                        }
                        else{
                            [orderDetailWCMWorkApprovalListArray addObject:[tempDictionary objectForKey:@"Anlzu"]];
                        }
                        
                        if ([NullChecker isNull:[tempDictionary objectForKey:@"Anlzux"]]) {
                            [orderDetailWCMWorkApprovalListArray addObject:@""];
                        }
                        else{
                            [orderDetailWCMWorkApprovalListArray addObject:[tempDictionary objectForKey:@"Anlzux"]];
                        }
                        
                        if ([NullChecker isNull:[tempDictionary objectForKey:@"Etape"]]) {
                            [orderDetailWCMWorkApprovalListArray addObject:@""];
                        }
                        else{
                            [orderDetailWCMWorkApprovalListArray addObject:[tempDictionary objectForKey:@"Etape"]];
                        }
                        
                        if ([NullChecker isNull:[tempDictionary objectForKey:@"Etapex"]]) {
                            [orderDetailWCMWorkApprovalListArray addObject:@""];
                        }
                        else{
                            [orderDetailWCMWorkApprovalListArray addObject:[tempDictionary objectForKey:@"Etapex"]];
                        }
                        
                        if ([NullChecker isNull:[tempDictionary objectForKey:@"Stxt"]]) {
                            [orderDetailWCMWorkApprovalListArray addObject:@""];
                        }
                        else{
                            [orderDetailWCMWorkApprovalListArray addObject:[tempDictionary objectForKey:@"Stxt"]];
                        }
                        
                        if ([NullChecker isNull:[tempDictionary objectForKey:@"Datefr"]]) {
                            [orderDetailWCMWorkApprovalListArray addObject:@""];
                        }
                        else{
                            [orderDetailWCMWorkApprovalListArray addObject:[tempDictionary objectForKey:@"Datefr"]];
                        }
                        
                        if ([NullChecker isNull:[tempDictionary objectForKey:@"Timefr"]]) {
                            [orderDetailWCMWorkApprovalListArray addObject:@""];
                        }
                        else{
                            [orderDetailWCMWorkApprovalListArray addObject:[tempDictionary objectForKey:@"Timefr"]];
                        }
                        
                        if ([NullChecker isNull:[tempDictionary objectForKey:@"Dateto"]]) {
                            [orderDetailWCMWorkApprovalListArray addObject:@""];
                        }
                        else{
                            [orderDetailWCMWorkApprovalListArray addObject:[tempDictionary objectForKey:@"Dateto"]];
                        }
                        
                        if ([NullChecker isNull:[tempDictionary objectForKey:@"Timeto"]]) {
                            [orderDetailWCMWorkApprovalListArray addObject:@""];
                        }
                        else{
                            [orderDetailWCMWorkApprovalListArray addObject:[tempDictionary objectForKey:@"Timeto"]];
                        }
                        
                        if ([NullChecker isNull:[tempDictionary objectForKey:@"Priok"]]) {
                            [orderDetailWCMWorkApprovalListArray addObject:@""];
                        }
                        else{
                            [orderDetailWCMWorkApprovalListArray addObject:[tempDictionary objectForKey:@"Priok"]];
                        }
                        
                        if ([NullChecker isNull:[tempDictionary objectForKey:@"Priokx"]]) {
                            [orderDetailWCMWorkApprovalListArray addObject:@""];
                        }
                        else{
                            [orderDetailWCMWorkApprovalListArray addObject:[tempDictionary objectForKey:@"Priokx"]];
                        }
                        
                        if ([NullChecker isNull:[tempDictionary objectForKey:@"Rctime"]]) {
                            [orderDetailWCMWorkApprovalListArray addObject:@""];
                        }
                        else{
                            [orderDetailWCMWorkApprovalListArray addObject:[tempDictionary objectForKey:@"Rctime"]];
                        }
                        
                        if ([NullChecker isNull:[tempDictionary objectForKey:@"Rcunit"]]) {
                            [orderDetailWCMWorkApprovalListArray addObject:@""];
                        }
                        else{
                            [orderDetailWCMWorkApprovalListArray addObject:[tempDictionary objectForKey:@"Rcunit"]];
                        }
                        
                        if ([NullChecker isNull:[tempDictionary objectForKey:@"Objnr"]]) {
                            [orderDetailWCMWorkApprovalListArray addObject:@""];
                        }
                        else{
                            [orderDetailWCMWorkApprovalListArray addObject:[tempDictionary objectForKey:@"Objnr"]];
                        }
                        
                        if ([NullChecker isNull:[tempDictionary objectForKey:@"Refobj"]]) {
                            [orderDetailWCMWorkApprovalListArray addObject:@""];
                        }
                        else{
                            [orderDetailWCMWorkApprovalListArray addObject:[tempDictionary objectForKey:@"Refobj"]];
                        }
                        
                        if ([NullChecker isNull:[tempDictionary objectForKey:@"Crea"]]) {
                            [orderDetailWCMWorkApprovalListArray addObject:@""];
                        }
                        else{
                            [orderDetailWCMWorkApprovalListArray addObject:[tempDictionary objectForKey:@"Crea"]];
                        }
                        
                        if ([NullChecker isNull:[tempDictionary objectForKey:@"Prep"]]) {
                            [orderDetailWCMWorkApprovalListArray addObject:@""];
                        }
                        else{
                            [orderDetailWCMWorkApprovalListArray addObject:[tempDictionary objectForKey:@"Prep"]];
                        }
                        
                        if ([NullChecker isNull:[tempDictionary objectForKey:@"Comp"]]) {
                            [orderDetailWCMWorkApprovalListArray addObject:@""];
                        }
                        else{
                            [orderDetailWCMWorkApprovalListArray addObject:[tempDictionary objectForKey:@"Comp"]];
                        }
                        
                        if ([NullChecker isNull:[tempDictionary objectForKey:@"Appr"]]) {
                            [orderDetailWCMWorkApprovalListArray addObject:@""];
                        }
                        else{
                            [orderDetailWCMWorkApprovalListArray addObject:[tempDictionary objectForKey:@"Appr"]];
                        }
                        
                        if ([NullChecker isNull:[tempDictionary objectForKey:@"Pappr"]]) {
                            [orderDetailWCMWorkApprovalListArray addObject:@""];
                        }
                        else{
                            [orderDetailWCMWorkApprovalListArray addObject:[tempDictionary objectForKey:@"Pappr"]];
                        }
                        
                        if ([NullChecker isNull:[tempDictionary objectForKey:@"Action"]]) {
                            [orderDetailWCMWorkApprovalListArray addObject:@""];//Action
                        }
                        else{
                            [orderDetailWCMWorkApprovalListArray addObject:[tempDictionary objectForKey:@"Action"]];
                        }
                        
                        
                        if ([NullChecker isNull:[tempDictionary objectForKey:@"Begru"]]) {
                            [orderDetailWCMWorkApprovalListArray addObject:@""];
                        }
                        else{
                            [orderDetailWCMWorkApprovalListArray addObject:[tempDictionary objectForKey:@"Begru"]];
                        }
                        
                        if ([NullChecker isNull:[tempDictionary objectForKey:@"Begtx"]]) {
                            [orderDetailWCMWorkApprovalListArray addObject:@""];
                        }
                        else{
                            [orderDetailWCMWorkApprovalListArray addObject:[tempDictionary objectForKey:@"Begtx"]];
                        }
                        
                        
                        [wcmWorkApprovalListArray addObject:orderDetailWCMWorkApprovalListArray];
                    }
                    
                    [[orderDetailDictionary objectForKey:[orderWcmWorkApprovalListArray objectAtIndex:i]] replaceObjectAtIndex:1 withObject:wcmWorkApprovalListArray];
                }
                
                [orderWcmWorkApprovalListArray removeAllObjects];
                
                /////
                responseObject = nil;
                
                [orderWcmIssuePermitsArray addObjectsFromArray:[orderWCMIssuePermitsDictionary allKeys]];
                
                NSArray *recordIDWCMIssuePermitsArray;
                NSDictionary *WCMIssuePermitsDictionary;
                
                for (int i =0; i<[orderWcmIssuePermitsArray  count]; i++) {
                    
                    WCMIssuePermitsDictionary = [orderWCMIssuePermitsDictionary objectForKey:[orderWcmIssuePermitsArray objectAtIndex:i]];
                    recordIDWCMIssuePermitsArray = [WCMIssuePermitsDictionary allKeys];
                    
                    NSMutableArray *wcmIssuePermitsArray = [NSMutableArray new];
                    
                    
                    for (int j=0; j<[recordIDWCMIssuePermitsArray count]; j++) {
                        
                        
                        tempDictionary = [WCMIssuePermitsDictionary objectForKey:[recordIDWCMIssuePermitsArray objectAtIndex:j]];
                        
                        
                        NSMutableArray *temPArray=[NSMutableArray new];
                        
                        
                        if ([tempDictionary isKindOfClass:[NSDictionary class]]){
                            
                            
                            if ([tempDictionary objectForKey:@"Objects"]) {
                                
                                
                                [temPArray addObjectsFromArray:[tempDictionary objectForKey:@"Objects"]];
                                
                                
                                for (int k=0; k<[temPArray count]; k++) {
                                    
                                    
                                    NSMutableArray *orderDetailWCMIssuePermitsArray = [NSMutableArray new];
                                    
                                    
                                    NSDictionary *tempObjectsDictionary = [temPArray objectAtIndex:k];
                                    
                                    
                                    if ([NullChecker isNull:[tempObjectsDictionary objectForKey:@"Aufnr"]]) {
                                        [orderDetailWCMIssuePermitsArray addObject:@""];
                                    }
                                    else{
                                        [orderDetailWCMIssuePermitsArray addObject:[NSString stringWithFormat:@"%lld",[[tempObjectsDictionary objectForKey:@"Aufnr"] longLongValue]]];
                                    }
                                    
                                    
                                    if ([NullChecker isNull:[tempObjectsDictionary objectForKey:@"Objnr"]]) {
                                        [orderDetailWCMIssuePermitsArray addObject:@""];
                                    }
                                    else{
                                        
                                        
                                        [orderDetailWCMIssuePermitsArray addObject:[tempObjectsDictionary objectForKey:@"Objnr"]];
                                    }
                                    
                                    
                                    if ([NullChecker isNull:[tempObjectsDictionary objectForKey:@"Counter"]]) {
                                        [orderDetailWCMIssuePermitsArray addObject:@""];
                                    }
                                    else{
                                        [orderDetailWCMIssuePermitsArray addObject:[tempObjectsDictionary objectForKey:@"Counter"]];
                                    }
                                    
                                    
                                    if ([NullChecker isNull:[tempObjectsDictionary objectForKey:@"Werks"]]) {
                                        [orderDetailWCMIssuePermitsArray addObject:@""];
                                    }
                                    else{
                                        [orderDetailWCMIssuePermitsArray addObject:[tempObjectsDictionary objectForKey:@"Werks"]];
                                    }
                                    
                                    
                                    if ([NullChecker isNull:[tempObjectsDictionary objectForKey:@"Crname"]]) {
                                        [orderDetailWCMIssuePermitsArray addObject:@""];
                                    }
                                    else{
                                        [orderDetailWCMIssuePermitsArray addObject:[tempObjectsDictionary objectForKey:@"Crname"]];
                                    }
                                    
                                    
                                    if ([NullChecker isNull:[tempObjectsDictionary objectForKey:@"Objart"]]) {
                                        [orderDetailWCMIssuePermitsArray addObject:@""];
                                    }
                                    else{
                                        [orderDetailWCMIssuePermitsArray addObject:[tempObjectsDictionary objectForKey:@"Objart"]];
                                    }
                                    
                                    
                                    if ([NullChecker isNull:[tempObjectsDictionary objectForKey:@"Objtyp"]]) {
                                        [orderDetailWCMIssuePermitsArray addObject:@""];
                                    }
                                    else{
                                        [orderDetailWCMIssuePermitsArray addObject:[tempObjectsDictionary objectForKey:@"Objtyp"]];
                                    }
                                    
                                    
                                    if ([NullChecker isNull:[tempObjectsDictionary objectForKey:@"Pmsog"]]) {
                                        [orderDetailWCMIssuePermitsArray addObject:@""];
                                    }
                                    else{
                                        [orderDetailWCMIssuePermitsArray addObject:[tempObjectsDictionary objectForKey:@"Pmsog"]];
                                    }
                                    
                                    
                                    if ([NullChecker isNull:[tempObjectsDictionary objectForKey:@"Gntxt"]]) {
                                        [orderDetailWCMIssuePermitsArray addObject:@""];
                                    }
                                    else{
                                        [orderDetailWCMIssuePermitsArray addObject:[tempObjectsDictionary objectForKey:@"Gntxt"]];
                                    }
                                    
                                    
                                    if ([NullChecker isNull:[tempObjectsDictionary objectForKey:@"Geniakt"]]) {
                                        [orderDetailWCMIssuePermitsArray addObject:@""];
                                    }
                                    else{
                                        [orderDetailWCMIssuePermitsArray addObject:[tempObjectsDictionary objectForKey:@"Geniakt"]];
                                    }
                                    
                                    
                                    if ([NullChecker isNull:[tempObjectsDictionary objectForKey:@"Genvname"]]) {
                                        [orderDetailWCMIssuePermitsArray addObject:@""];
                                    }
                                    else{
                                        [orderDetailWCMIssuePermitsArray addObject:[tempObjectsDictionary objectForKey:@"Genvname"]];
                                    }
                                    
                                    
                                    if ([NullChecker isNull:[tempObjectsDictionary objectForKey:@"Hilvl"]]) {
                                        [orderDetailWCMIssuePermitsArray addObject:@""];
                                    }
                                    else{
                                        [orderDetailWCMIssuePermitsArray addObject:[tempObjectsDictionary objectForKey:@"Hilvl"]];
                                    }
                                    
                                    
                                    if ([NullChecker isNull:[tempObjectsDictionary objectForKey:@"Procflg"]]) {
                                        [orderDetailWCMIssuePermitsArray addObject:@""];
                                    }
                                    else{
                                        [orderDetailWCMIssuePermitsArray addObject:[tempObjectsDictionary objectForKey:@"Procflg"]];
                                    }
                                    
                                    
                                    if ([NullChecker isNull:[tempObjectsDictionary objectForKey:@"Direction"]]) {
                                        [orderDetailWCMIssuePermitsArray addObject:@""];
                                    }
                                    else{
                                        [orderDetailWCMIssuePermitsArray addObject:[tempObjectsDictionary objectForKey:@"Direction"]];
                                    }
                                    
                                    
                                    if ([NullChecker isNull:[tempObjectsDictionary objectForKey:@"Copyflg"]]) {
                                        [orderDetailWCMIssuePermitsArray addObject:@""];
                                    }
                                    else{
                                        [orderDetailWCMIssuePermitsArray addObject:[tempObjectsDictionary objectForKey:@"Copyflg"]];
                                    }
                                    
                                    
                                    if ([NullChecker isNull:[tempObjectsDictionary objectForKey:@"Mandflg"]]) {
                                        [orderDetailWCMIssuePermitsArray addObject:@""];
                                    }
                                    else{
                                        [orderDetailWCMIssuePermitsArray addObject:[tempObjectsDictionary objectForKey:@"Mandflg"]];
                                    }
                                    
                                    
                                    if ([NullChecker isNull:[tempObjectsDictionary objectForKey:@"Deacflg"]]) {
                                        [orderDetailWCMIssuePermitsArray addObject:@""];
                                    }
                                    else{
                                        [orderDetailWCMIssuePermitsArray addObject:[tempObjectsDictionary objectForKey:@"Deacflg"]];
                                    }
                                    
                                    
                                    if ([NullChecker isNull:[tempObjectsDictionary objectForKey:@"Status"]]) {
                                        [orderDetailWCMIssuePermitsArray addObject:@""];
                                    }
                                    else{
                                        [orderDetailWCMIssuePermitsArray addObject:[tempObjectsDictionary objectForKey:@"Status"]];
                                    }
                                    
                                    
                                    if ([NullChecker isNull:[tempObjectsDictionary objectForKey:@"Asgnflg"]]) {
                                        [orderDetailWCMIssuePermitsArray addObject:@""];
                                    }
                                    else{
                                        [orderDetailWCMIssuePermitsArray addObject:[tempObjectsDictionary objectForKey:@"Asgnflg"]];
                                    }
                                    
                                    
                                    if ([NullChecker isNull:[tempObjectsDictionary objectForKey:@"Autoflg"]]) {
                                        [orderDetailWCMIssuePermitsArray addObject:@""];
                                    }
                                    else{
                                        [orderDetailWCMIssuePermitsArray addObject:[tempObjectsDictionary objectForKey:@"Autoflg"]];
                                    }
                                    
                                    
                                    if ([NullChecker isNull:[tempObjectsDictionary objectForKey:@"Agent"]]) {
                                        [orderDetailWCMIssuePermitsArray addObject:@""];
                                    }
                                    else{
                                        [orderDetailWCMIssuePermitsArray addObject:[tempObjectsDictionary objectForKey:@"Agent"]];
                                    }
                                    
                                    
                                    if ([NullChecker isNull:[tempObjectsDictionary objectForKey:@"Valflg"]]) {
                                        [orderDetailWCMIssuePermitsArray addObject:@""];
                                    }
                                    else{
                                        [orderDetailWCMIssuePermitsArray addObject:[tempObjectsDictionary objectForKey:@"Valflg"]];
                                    }
                                    
                                    
                                    if ([NullChecker isNull:[tempObjectsDictionary objectForKey:@"Wcmuse"]]) {
                                        [orderDetailWCMIssuePermitsArray addObject:@""];
                                    }
                                    else{
                                        [orderDetailWCMIssuePermitsArray addObject:[tempObjectsDictionary objectForKey:@"Wcmuse"]];
                                    }
                                    
                                    
                                    if ([NullChecker isNull:[tempObjectsDictionary objectForKey:@"Action"]]) {
                                        [orderDetailWCMIssuePermitsArray addObject:@""];
                                    }
                                    else{
                                        [orderDetailWCMIssuePermitsArray addObject:[tempObjectsDictionary objectForKey:@"Action"]];
                                    }
                                    
                                    
                                    [wcmIssuePermitsArray addObject:orderDetailWCMIssuePermitsArray];
                                }
                            }
                            
                            
                            NSMutableArray *orderDetailWCMIssuePermitsArray = [NSMutableArray new];
                            
                            if ([NullChecker isNull:[tempDictionary objectForKey:@"Aufnr"]]) {
                                [orderDetailWCMIssuePermitsArray addObject:@""];
                            }
                            else{
                                [orderDetailWCMIssuePermitsArray addObject:[NSString stringWithFormat:@"%lld",[[tempDictionary objectForKey:@"Aufnr"] longLongValue]]];
                            }
                            
                            
                            if ([NullChecker isNull:[tempDictionary objectForKey:@"Objnr"]]) {
                                [orderDetailWCMIssuePermitsArray addObject:@""];
                            }
                            else{
                                
                                
                                [orderDetailWCMIssuePermitsArray addObject:[tempDictionary objectForKey:@"Objnr"]];
                            }
                            
                            
                            if ([NullChecker isNull:[tempDictionary objectForKey:@"Counter"]]) {
                                [orderDetailWCMIssuePermitsArray addObject:@""];
                            }
                            else{
                                [orderDetailWCMIssuePermitsArray addObject:[tempDictionary objectForKey:@"Counter"]];
                            }
                            
                            
                            if ([NullChecker isNull:[tempDictionary objectForKey:@"Werks"]]) {
                                [orderDetailWCMIssuePermitsArray addObject:@""];
                            }
                            else{
                                [orderDetailWCMIssuePermitsArray addObject:[tempDictionary objectForKey:@"Werks"]];
                            }
                            
                            
                            if ([NullChecker isNull:[tempDictionary objectForKey:@"Crname"]]) {
                                [orderDetailWCMIssuePermitsArray addObject:@""];
                            }
                            else{
                                [orderDetailWCMIssuePermitsArray addObject:[tempDictionary objectForKey:@"Crname"]];
                            }
                            
                            
                            if ([NullChecker isNull:[tempDictionary objectForKey:@"Objart"]]) {
                                [orderDetailWCMIssuePermitsArray addObject:@""];
                            }
                            else{
                                [orderDetailWCMIssuePermitsArray addObject:[tempDictionary objectForKey:@"Objart"]];
                            }
                            
                            
                            if ([NullChecker isNull:[tempDictionary objectForKey:@"Objtyp"]]) {
                                [orderDetailWCMIssuePermitsArray addObject:@""];
                            }
                            else{
                                [orderDetailWCMIssuePermitsArray addObject:[tempDictionary objectForKey:@"Objtyp"]];
                            }
                            
                            
                            if ([NullChecker isNull:[tempDictionary objectForKey:@"Pmsog"]]) {
                                [orderDetailWCMIssuePermitsArray addObject:@""];
                            }
                            else{
                                [orderDetailWCMIssuePermitsArray addObject:[tempDictionary objectForKey:@"Pmsog"]];
                            }
                            
                            
                            if ([NullChecker isNull:[tempDictionary objectForKey:@"Gntxt"]]) {
                                [orderDetailWCMIssuePermitsArray addObject:@""];
                            }
                            else{
                                [orderDetailWCMIssuePermitsArray addObject:[tempDictionary objectForKey:@"Gntxt"]];
                            }
                            
                            
                            if ([NullChecker isNull:[tempDictionary objectForKey:@"Geniakt"]]) {
                                [orderDetailWCMIssuePermitsArray addObject:@""];
                            }
                            else{
                                [orderDetailWCMIssuePermitsArray addObject:[tempDictionary objectForKey:@"Geniakt"]];
                            }
                            
                            
                            if ([NullChecker isNull:[tempDictionary objectForKey:@"Genvname"]]) {
                                [orderDetailWCMIssuePermitsArray addObject:@""];
                            }
                            else{
                                [orderDetailWCMIssuePermitsArray addObject:[tempDictionary objectForKey:@"Genvname"]];
                            }
                            
                            
                            if ([NullChecker isNull:[tempDictionary objectForKey:@"Hilvl"]]) {
                                [orderDetailWCMIssuePermitsArray addObject:@""];
                            }
                            else{
                                [orderDetailWCMIssuePermitsArray addObject:[tempDictionary objectForKey:@"Hilvl"]];
                            }
                            
                            
                            if ([NullChecker isNull:[tempDictionary objectForKey:@"Procflg"]]) {
                                [orderDetailWCMIssuePermitsArray addObject:@""];
                            }
                            else{
                                [orderDetailWCMIssuePermitsArray addObject:[tempDictionary objectForKey:@"Procflg"]];
                            }
                            
                            
                            if ([NullChecker isNull:[tempDictionary objectForKey:@"Direction"]]) {
                                [orderDetailWCMIssuePermitsArray addObject:@""];
                            }
                            else{
                                [orderDetailWCMIssuePermitsArray addObject:[tempDictionary objectForKey:@"Direction"]];
                            }
                            
                            
                            if ([NullChecker isNull:[tempDictionary objectForKey:@"Copyflg"]]) {
                                [orderDetailWCMIssuePermitsArray addObject:@""];
                            }
                            else{
                                [orderDetailWCMIssuePermitsArray addObject:[tempDictionary objectForKey:@"Copyflg"]];
                            }
                            
                            
                            if ([NullChecker isNull:[tempDictionary objectForKey:@"Mandflg"]]) {
                                [orderDetailWCMIssuePermitsArray addObject:@""];
                            }
                            else{
                                [orderDetailWCMIssuePermitsArray addObject:[tempDictionary objectForKey:@"Mandflg"]];
                            }
                            
                            
                            if ([NullChecker isNull:[tempDictionary objectForKey:@"Deacflg"]]) {
                                [orderDetailWCMIssuePermitsArray addObject:@""];
                            }
                            else{
                                [orderDetailWCMIssuePermitsArray addObject:[tempDictionary objectForKey:@"Deacflg"]];
                            }
                            
                            
                            if ([NullChecker isNull:[tempDictionary objectForKey:@"Status"]]) {
                                [orderDetailWCMIssuePermitsArray addObject:@""];
                            }
                            else{
                                [orderDetailWCMIssuePermitsArray addObject:[tempDictionary objectForKey:@"Status"]];
                            }
                            
                            
                            if ([NullChecker isNull:[tempDictionary objectForKey:@"Asgnflg"]]) {
                                [orderDetailWCMIssuePermitsArray addObject:@""];
                            }
                            else{
                                [orderDetailWCMIssuePermitsArray addObject:[tempDictionary objectForKey:@"Asgnflg"]];
                            }
                            
                            
                            if ([NullChecker isNull:[tempDictionary objectForKey:@"Autoflg"]]) {
                                [orderDetailWCMIssuePermitsArray addObject:@""];
                            }
                            else{
                                [orderDetailWCMIssuePermitsArray addObject:[tempDictionary objectForKey:@"Autoflg"]];
                            }
                            
                            
                            if ([NullChecker isNull:[tempDictionary objectForKey:@"Agent"]]) {
                                [orderDetailWCMIssuePermitsArray addObject:@""];
                            }
                            else{
                                [orderDetailWCMIssuePermitsArray addObject:[tempDictionary objectForKey:@"Agent"]];
                            }
                            
                            
                            if ([NullChecker isNull:[tempDictionary objectForKey:@"Valflg"]]) {
                                [orderDetailWCMIssuePermitsArray addObject:@""];
                            }
                            else{
                                [orderDetailWCMIssuePermitsArray addObject:[tempDictionary objectForKey:@"Valflg"]];
                            }
                            
                            
                            if ([NullChecker isNull:[tempDictionary objectForKey:@"Wcmuse"]]) {
                                [orderDetailWCMIssuePermitsArray addObject:@""];
                            }
                            else{
                                [orderDetailWCMIssuePermitsArray addObject:[tempDictionary objectForKey:@"Wcmuse"]];
                            }
                            
                            
                            if ([NullChecker isNull:[tempDictionary objectForKey:@"Action"]]) {
                                [orderDetailWCMIssuePermitsArray addObject:@""];
                            }
                            else{
                                [orderDetailWCMIssuePermitsArray addObject:[tempDictionary objectForKey:@"Action"]];
                            }
                            
                            
                            [wcmIssuePermitsArray addObject:orderDetailWCMIssuePermitsArray];
                        }
                        
                        
                        [[orderDetailDictionary objectForKey:[orderWcmIssuePermitsArray objectAtIndex:i]] replaceObjectAtIndex:9 withObject:wcmIssuePermitsArray];
                        
                    }
                }
                [orderWcmIssuePermitsArray removeAllObjects];
                
                //////////
                [orderDocsArray addObjectsFromArray:[orderDocsDictionary allKeys]];
                NSArray *recordIDDocsArray;
                NSDictionary *docsDictionary;
                
                for (int i =0; i<[orderDocsArray  count]; i++) {
                    docsDictionary = [orderDocsDictionary objectForKey:[orderDocsArray objectAtIndex:i]];
                    recordIDDocsArray = [docsDictionary allKeys];
                    NSMutableArray *orderDocsListArray = [NSMutableArray new];
                    
                    for (int j=0; j<[recordIDDocsArray count]; j++) {
                        NSMutableArray *orderDetailDocsListArray = [NSMutableArray new];
                        
                        tempDictionary = [docsDictionary objectForKey:[recordIDDocsArray objectAtIndex:j]];
                        
                        if ([NullChecker isNull:[tempDictionary objectForKey:@"Zobjid"]]) {
                            [orderDetailDocsListArray addObject:@""];
                        }
                        else{
                            [orderDetailDocsListArray addObject:[tempDictionary objectForKey:@"Zobjid"]];
                        }
                        
                        if ([NullChecker isNull:[tempDictionary objectForKey:@"DocId"]]) {
                            [orderDetailDocsListArray addObject:@""];
                        }
                        else{
                            [orderDetailDocsListArray addObject:[tempDictionary objectForKey:@"DocId"]];
                        }
                        
                        if ([NullChecker isNull:[tempDictionary objectForKey:@"DocType"]]) {
                            [orderDetailDocsListArray addObject:@""];
                        }
                        else{
                            [orderDetailDocsListArray addObject:[tempDictionary objectForKey:@"DocType"]];
                        }
                        
                        if ([NullChecker isNull:[tempDictionary objectForKey:@"Filename"]]) {
                            [orderDetailDocsListArray addObject:@""];
                        }
                        else{
                            [orderDetailDocsListArray addObject:[tempDictionary objectForKey:@"Filename"]];
                        }
                        if ([NullChecker isNull:[tempDictionary objectForKey:@"Filetype"]]) {
                            [orderDetailDocsListArray addObject:@""];
                        }
                        else{
                            [orderDetailDocsListArray addObject:[tempDictionary objectForKey:@"Filetype"]];
                        }
                        
                        if ([NullChecker isNull:[tempDictionary objectForKey:@"Fsize"]]) {
                            
                            [orderDetailDocsListArray addObject:@""];//Size
                        }
                        else{
                            [orderDetailDocsListArray addObject:[tempDictionary objectForKey:@"Fsize"]];
                        }
                        
                        if ([NullChecker isNull:[tempDictionary objectForKey:@"Objtype"]]) {
                            
                            [orderDetailDocsListArray addObject:@""];//Objtype
                        }
                        else{
                            [orderDetailDocsListArray addObject:[tempDictionary objectForKey:@"Objtype"]];
                        }
                        
                        [orderDetailDocsListArray addObject:@""];//Content
                        [orderDetailDocsListArray addObject:@""];//Action
                        
                        [orderDocsListArray addObject:orderDetailDocsListArray];
                    }
                    
                    [[orderDetailDictionary objectForKey:[orderDocsArray objectAtIndex:i]] replaceObjectAtIndex:2 withObject:orderDocsListArray];
                }
                
                [orderDocsArray removeAllObjects];
                
                [orderTransactionArray addObjectsFromArray:[orderTransactionDictionary allKeys]];
                NSArray *recordIDArray;
                NSDictionary *componentDictionary;
                
                for (int i =0; i<[orderTransactionArray  count]; i++) {
                    componentDictionary = [orderTransactionDictionary objectForKey:[orderTransactionArray objectAtIndex:i]];
                    recordIDArray = [componentDictionary allKeys];
                    NSMutableArray *orderTransactionListArray = [NSMutableArray new];
                    NSMutableArray *orderPartsListArray = [NSMutableArray new];
                    
                    for (int j=0; j<[recordIDArray count]; j++) {
                        
                        NSMutableArray *orderDetailTransactionListArray = [NSMutableArray new];
                        
                        tempDictionary = [componentDictionary objectForKey:[recordIDArray objectAtIndex:j]];
                        
                        //CREATE TABLE "ORDER_TRANSACTION" ("ordert_header_id" VARCHAR,"ordert_vornr_operation" VARCHAR,"ordert_operation_name" VARCHAR,"ordert_duration_name" VARCHAR,"ordert_duration_id" VARCHAR,"ordert_fsavd" VARCHAR,"ordert_ssedd" VARCHAR,"ordert_rueck" VARCHAR,"ordert_aueru" VARCHAR,"ordert_operation_action" VARCHAR,"ordert_status" VARCHAR,"ordert_conftext" VARCHAR,"ordert_actwork" VARCHAR,"ordert_unwork" VARCHAR,"ordert_larnt" VARCHAR,"ordert_pernr" VARCHAR,"ordert_plnal" VARCHAR,"ordert_plnnr" VARCHAR,"ordert_plnty" VARCHAR,"ordert_steus" VARCHAR,"ordert_operationlongtext" VARCHAR,"usr01" VARCHAR,"bemot" VARCHAR,"grund" VARCHAR,"learr" VARCHAR,"leknw" VARCHAR,"operation_plantid" VARCHAR,"operation_plantname" VARCHAR,"operation_workcenterid" VARCHAR,"operation_workcentertext" VARCHAR,"ordert_steustext" VARCHAR)
                        
                        if ([NullChecker isNull:[tempDictionary objectForKey:@"Aufnr"]]) {
                            [orderDetailTransactionListArray addObject:@""];
                        }
                        else{
                            [orderDetailTransactionListArray addObject:[tempDictionary objectForKey:@"Aufnr"]];
                        }
                        
                        if ([NullChecker isNull:[tempDictionary objectForKey:@"Vornr"]]) {
                            [orderDetailTransactionListArray addObject:@""];
                        }
                        else{
                            [orderDetailTransactionListArray addObject:[tempDictionary objectForKey:@"Vornr"]];
                        }
                        
                        if ([NullChecker isNull:[tempDictionary objectForKey:@"Ltxa1"]]) {
                            [orderDetailTransactionListArray addObject:@""];
                        }
                        else{
                            [orderDetailTransactionListArray addObject:[tempDictionary objectForKey:@"Ltxa1"]];//Operation short text
                        }
                        
                        if ([NullChecker isNull:[tempDictionary objectForKey:@"Dauno"]]) {
                            [orderDetailTransactionListArray addObject:@""];
                        }
                        else{
                            [orderDetailTransactionListArray addObject:[tempDictionary objectForKey:@"Dauno"]];//duration
                        }
                        
                        if ([NullChecker isNull:[tempDictionary objectForKey:@"Daune"]]) {
                            [orderDetailTransactionListArray addObject:@""];
                        }
                        else{
                            [orderDetailTransactionListArray addObject:[tempDictionary objectForKey:@"Daune"]];//duration id
                        }
                        
                        if ([NullChecker isNull:[tempDictionary objectForKey:@"Fsavd"]]) {
                            [orderDetailTransactionListArray addObject:@""];
                        }
                        else{
                            [orderDetailTransactionListArray addObject:[tempDictionary objectForKey:@"Fsavd"]];//date
                        }
                        
                        if ([NullChecker isNull:[tempDictionary objectForKey:@"Ssedd"]]) {
                            [orderDetailTransactionListArray addObject:@""];
                        }
                        else{
                            [orderDetailTransactionListArray addObject:[tempDictionary objectForKey:@"Ssedd"]];//date
                        }
                        
                        if ([NullChecker isNull:[tempDictionary objectForKey:@"Rueck"]]) {
                            [orderDetailTransactionListArray addObject:@""];
                        }
                        else{
                            [orderDetailTransactionListArray addObject:[tempDictionary objectForKey:@"Rueck"]];
                        }
                        
                        if ([NullChecker isNull:[tempDictionary objectForKey:@"Aueru"]]) {
                            [orderDetailTransactionListArray addObject:@""];//for aueru
                        }
                        else{
                            [orderDetailTransactionListArray addObject:[tempDictionary objectForKey:@"Aueru"]];
                        }
                        
                        [orderDetailTransactionListArray addObject:@""];//For OperationAction
                        [orderDetailTransactionListArray addObject:@""];//For Status
                        [orderDetailTransactionListArray addObject:@""];//For Confirmation text in Confirm Order
                        [orderDetailTransactionListArray addObject:@""];//For Actual Work Text
                        [orderDetailTransactionListArray addObject:@""];//For Actual Work Units
                        
                        if ([NullChecker isNull:[tempDictionary objectForKey:@"Larnt"]]) {
                            [orderDetailTransactionListArray addObject:@""];
                        }
                        else{
                            [orderDetailTransactionListArray addObject:[tempDictionary objectForKey:@"Larnt"]];//Activity Type
                        }
                        if ([NullChecker isNull:[tempDictionary objectForKey:@"Pernr"]]) {
                            [orderDetailTransactionListArray addObject:@""];
                        }
                        else{
                            [orderDetailTransactionListArray addObject:[tempDictionary objectForKey:@"Pernr"]];//Personal No
                        }
                        
                        if ([NullChecker isNull:[tempDictionary objectForKey:@"Plnal"]]) {
                            [orderDetailTransactionListArray addObject:@""];
                        }
                        else{
                            [orderDetailTransactionListArray addObject:[tempDictionary objectForKey:@"Plnal"]];//Group Counter
                        }
                        
                        if ([NullChecker isNull:[tempDictionary objectForKey:@"Plnnr"]]) {
                            [orderDetailTransactionListArray addObject:@""];
                        }
                        else{
                            [orderDetailTransactionListArray addObject:[tempDictionary objectForKey:@"Plnnr"]];//key for task list group
                        }
                        
                        if ([NullChecker isNull:[tempDictionary objectForKey:@"Plnty"]]) {
                            [orderDetailTransactionListArray addObject:@""];
                        }
                        else{
                            [orderDetailTransactionListArray addObject:[tempDictionary objectForKey:@"Plnty"]];//Task list type
                        }
                        
                        if ([NullChecker isNull:[tempDictionary objectForKey:@"Steus"]]) {
                            [orderDetailTransactionListArray addObject:@""];
                        }
                        else{
                            [orderDetailTransactionListArray addObject:[tempDictionary objectForKey:@"Steus"]];//Control Key
                        }
                        
                        if ([NullChecker isNull:[tempDictionary objectForKey:@"OPTLONGTEXT"]]) {
                            [orderDetailTransactionListArray addObject:@""];
                        }
                        else{
                            [orderDetailTransactionListArray addObject:[tempDictionary objectForKey:@"OPTLONGTEXT"]];
                        }//For Long Text
                        
                        if ([NullChecker isNull:[tempDictionary objectForKey:@"Usr01"]]) {
                            [orderDetailTransactionListArray addObject:@""];
                        }
                        else{
                            [orderDetailTransactionListArray addObject:[tempDictionary objectForKey:@"Usr01"]];
                        }//For Actual Work
                        
                        [orderDetailTransactionListArray addObject:@""];//Bemot(Accounting Indicator)
                        [orderDetailTransactionListArray addObject:@""];//grund(ConfirmReason)
                        [orderDetailTransactionListArray addObject:@""];//Learr(noRemainingWork)
                        [orderDetailTransactionListArray addObject:@""];//Leknw(confirmreason)
                        
                        if ([NullChecker isNull:[tempDictionary objectForKey:@"Werks"]]) {
                            [orderDetailTransactionListArray addObject:@""];//Werks
                            
                        }
                        else{
                            [orderDetailTransactionListArray addObject:[tempDictionary objectForKey:@"Werks"]];//Werks
                        }
                        
                        if ([NullChecker isNull:[tempDictionary objectForKey:@"WerksText"]]) {
                            [orderDetailTransactionListArray addObject:@""];//WerksText
                            
                        }
                        else{
                            [orderDetailTransactionListArray addObject:[tempDictionary objectForKey:@"WerksText"]];//WersText
                        }
                        
                        if ([NullChecker isNull:[tempDictionary objectForKey:@"Arbpl"]]) {
                            [orderDetailTransactionListArray addObject:@""];//Arbpl
                        }
                        else{
                            [orderDetailTransactionListArray addObject:[tempDictionary objectForKey:@"Arbpl"]];//Arbpl
                            
                        }
                        
                        if ([NullChecker isNull:[tempDictionary objectForKey:@"ArbplText"]]) {
                            [orderDetailTransactionListArray addObject:@""];//ArbplText
                        }
                        else{
                            [orderDetailTransactionListArray addObject:[tempDictionary objectForKey:@"ArbplText"]];//ArbplText
                        }
                        
                        if ([NullChecker isNull:[tempDictionary objectForKey:@"SteusText"]]) {
                            [orderDetailTransactionListArray addObject:@""];//SteusText
                        }
                        else{
                            [orderDetailTransactionListArray addObject:[tempDictionary objectForKey:@"SteusText"]];//SteusText
                        }
                        //
                        //                            id customFieldsOperationsTransactionsID;
                        //                            if ([tempDictionary objectForKey:@"Fields"]) {
                        //                                NSArray *fieldsArray = [[tempDictionary objectForKey:@"Fields"] objectForKey:@"item"];
                        //                                NSMutableArray *transactionsOperationsCustomFields = [NSMutableArray new];
                        //                                for (int l =0; l<[fieldsArray count]; l++) {
                        //                                    NSString *fieldValue,*fieldName,*fLabel,*tabName,*docType,*docTypeItem,*dataType,*sequence,*length;
                        //                                    if ([NullChecker isNull:[[fieldsArray objectAtIndex:l] objectForKey:@"Fieldname"]]) {
                        //                                        fieldName = @"";
                        //                                    }
                        //                                    else{
                        //                                        fieldName = [[fieldsArray objectAtIndex:l] objectForKey:@"Fieldname"];
                        //                                    }
                        //
                        //                                    if ([NullChecker isNull:[[fieldsArray objectAtIndex:l] objectForKey:@"Flabel"]]) {
                        //                                        fLabel = @"";
                        //                                    }
                        //                                    else{
                        //                                        fLabel = [[fieldsArray objectAtIndex:l] objectForKey:@"Flabel"];
                        //                                    }
                        //
                        //                                    if ([NullChecker isNull:[[fieldsArray objectAtIndex:l] objectForKey:@"Tabname"]]) {
                        //                                        tabName = @"";
                        //                                    }
                        //                                    else{
                        //                                        tabName = [[fieldsArray objectAtIndex:l] objectForKey:@"Tabname"];
                        //                                    }
                        //
                        //                                    if ([NullChecker isNull:[[fieldsArray objectAtIndex:l] objectForKey:@"Value"]]) {
                        //                                        fieldValue = @"";
                        //                                    }
                        //                                    else{
                        //                                        fieldValue = [[fieldsArray objectAtIndex:l] objectForKey:@"Value"];
                        //                                    }
                        //
                        //                                    if ([NullChecker isNull:[[fieldsArray objectAtIndex:l] objectForKey:@"Zdoctype"]]) {
                        //                                        docType = @"";
                        //                                    }
                        //                                    else{
                        //                                        docType = [[fieldsArray objectAtIndex:l] objectForKey:@"Zdoctype"];
                        //                                    }
                        //
                        //                                    if ([NullChecker isNull:[[fieldsArray objectAtIndex:l] objectForKey:@"ZdoctypeItem"]]) {
                        //                                        docTypeItem = @"";
                        //                                    }
                        //                                    else{
                        //                                        docTypeItem = [[fieldsArray objectAtIndex:l] objectForKey:@"ZdoctypeItem"];
                        //                                    }
                        //
                        //                                    if ([NullChecker isNull:[[fieldsArray objectAtIndex:l] objectForKey:@"Datatype"]]) {
                        //                                        dataType = @"";
                        //                                    }
                        //                                    else{
                        //                                        dataType = [[fieldsArray objectAtIndex:l] objectForKey:@"Datatype"];
                        //                                    }
                        //
                        //                                    if ([NullChecker isNull:[[fieldsArray objectAtIndex:l] objectForKey:@"Sequence"]]) {
                        //                                        sequence = @"";
                        //                                    }
                        //                                    else{
                        //                                        sequence = [[fieldsArray objectAtIndex:l] objectForKey:@"Sequence"];
                        //                                    }
                        //
                        //                                    if ([NullChecker isNull:[[fieldsArray objectAtIndex:l] objectForKey:@"Length"]]) {
                        //                                        length = @"";
                        //                                    }
                        //                                    else{
                        //                                        length = [[fieldsArray objectAtIndex:l] objectForKey:@"Length"];
                        //                                    }
                        //
                        //                                    if ([docTypeItem isEqualToString:@"WO"]) {
                        //                                        [transactionsOperationsCustomFields addObject:[NSMutableArray arrayWithObjects:docType,docTypeItem,tabName,fieldName,fieldValue,fLabel,dataType,sequence,length, nil]];
                        //                                    }
                        //                                }
                        //
                        //                                customFieldsOperationsTransactionsID = transactionsOperationsCustomFields;
                        //                            }
                        
                        [orderTransactionListArray addObject:[NSArray arrayWithObjects:orderDetailTransactionListArray,[NSArray array], nil]];
                        
                        if ([tempDictionary objectForKey:@"Components"]) {
                            
                            //CREATE TABLE "ORDER_PARTS" ("ordert_header_id" VARCHAR, "ordert_vornr_operation" VARCHAR, "ordert_quantity" INTEGER, "ordert_lgort" VARCHAR, "ordert_lgorttext" VARCHAR, "ordert_matnr" VARCHAR, "ordert_matnrtext" VARCHAR, "ordert_meins" VARCHAR, "ordert_posnr" VARCHAR, "ordert_postp" VARCHAR, "ordert_postptext" VARCHAR, "ordert_rsnum" VARCHAR, "ordert_rspos" VARCHAR, "ordert_werks" VARCHAR, "ordert_werkstext" VARCHAR)
                            
                            for (int k =0; k<[[tempDictionary objectForKey:@"Components"] count]; k++) {
                                
                                NSMutableArray *orderDetailComponentTransactionListArray = [NSMutableArray new];
                                
                                NSDictionary *tempCompenetsDictionary = [[tempDictionary objectForKey:@"Components"] objectAtIndex:k];
                                if ([NullChecker isNull:[tempCompenetsDictionary objectForKey:@"Aufnr"]]) {
                                    [orderDetailComponentTransactionListArray addObject:@""];
                                }
                                else{
                                    [orderDetailComponentTransactionListArray addObject:[tempCompenetsDictionary objectForKey:@"Aufnr"]];
                                }
                                
                                if ([NullChecker isNull:[tempCompenetsDictionary objectForKey:@"Vornr"]]) {
                                    [orderDetailComponentTransactionListArray addObject:@""];
                                }
                                else{
                                    [orderDetailComponentTransactionListArray addObject:[tempCompenetsDictionary objectForKey:@"Vornr"]];
                                }
                                
                                if ([NullChecker isNull:[tempCompenetsDictionary objectForKey:@"Bdmng"]]) {
                                    
                                    [orderDetailComponentTransactionListArray addObject:@""];
                                }
                                else{
                                    [orderDetailComponentTransactionListArray addObject:[tempCompenetsDictionary objectForKey:@"Bdmng"]];//Quantity
                                }
                                
                                if ([NullChecker isNull:[tempCompenetsDictionary objectForKey:@"Lgort"]]) {
                                    [orderDetailComponentTransactionListArray addObject:@""];
                                }
                                else{
                                    [orderDetailComponentTransactionListArray addObject:[tempCompenetsDictionary objectForKey:@"Lgort"]];
                                }
                                
                                if ([NullChecker isNull:[tempCompenetsDictionary objectForKey:@"LgortText"]]) {
                                    [orderDetailComponentTransactionListArray addObject:@""];
                                }
                                else{
                                    [orderDetailComponentTransactionListArray addObject:[tempCompenetsDictionary objectForKey:@"LgortText"]];
                                }
                                
                                if ([NullChecker isNull:[tempCompenetsDictionary objectForKey:@"Matnr"]]) {
                                    [orderDetailComponentTransactionListArray addObject:@""];
                                    [orderDetailComponentTransactionListArray addObject:@""];
                                }
                                else{
                                    [orderDetailComponentTransactionListArray addObject:[tempCompenetsDictionary objectForKey:@"Matnr"]];//ComponentID
                                }
                                
                                if ([NullChecker isNull:[tempCompenetsDictionary objectForKey:@"MatnrText"]]) {
                                    [orderDetailComponentTransactionListArray addObject:@""];
                                }
                                else{
                                    
                                    [orderDetailComponentTransactionListArray addObject:[tempCompenetsDictionary objectForKey:@"MatnrText"]];//ComponentName
                                }
                                
                                if ([NullChecker isNull:[tempCompenetsDictionary objectForKey:@"Meins"]]) {
                                    [orderDetailComponentTransactionListArray addObject:@""];
                                }
                                else{
                                    [orderDetailComponentTransactionListArray addObject:[tempCompenetsDictionary objectForKey:@"Meins"]];//Meins
                                    
                                }
                                
                                if ([NullChecker isNull:[tempCompenetsDictionary objectForKey:@"Posnr"]]) {
                                    [orderDetailComponentTransactionListArray addObject:@""];
                                }
                                else{
                                    [orderDetailComponentTransactionListArray addObject:[tempCompenetsDictionary objectForKey:@"Posnr"]];
                                }
                                
                                if([NullChecker isNull:[tempCompenetsDictionary objectForKey:@"Postp"]]){
                                    [orderDetailComponentTransactionListArray addObject:@""];
                                }
                                else{
                                    [orderDetailComponentTransactionListArray addObject:[tempCompenetsDictionary objectForKey:@"Postp"]];//Item Category in Components
                                }
                                
                                if([NullChecker isNull:[tempCompenetsDictionary objectForKey:@"PostpText"]]){
                                    [orderDetailComponentTransactionListArray addObject:@""];
                                }
                                else{
                                    [orderDetailComponentTransactionListArray addObject:[tempCompenetsDictionary objectForKey:@"PostpText"]];//Item Category in Components
                                }
                                
                                if ([NullChecker isNull:[tempCompenetsDictionary objectForKey:@"Rsnum"]]) {
                                    [orderDetailComponentTransactionListArray addObject:@""];
                                }
                                else{
                                    [orderDetailComponentTransactionListArray addObject:[tempCompenetsDictionary objectForKey:@"Rsnum"]];
                                }
                                
                                if ([NullChecker isNull:[tempCompenetsDictionary objectForKey:@"Rspos"]]) {
                                    [orderDetailComponentTransactionListArray addObject:@""];
                                }
                                else{
                                    [orderDetailComponentTransactionListArray addObject:[tempCompenetsDictionary objectForKey:@"Rspos"]];
                                }
                                
                                if ([tempCompenetsDictionary objectForKey:@"Werks"]) {
                                    [orderDetailComponentTransactionListArray addObject:[tempCompenetsDictionary objectForKey:@"Werks"]];//Werks
                                }
                                else{
                                    [orderDetailComponentTransactionListArray addObject:@""];//Werks
                                }
                                
                                if ([tempCompenetsDictionary objectForKey:@"WerksText"]) {
                                    [orderDetailComponentTransactionListArray addObject:[tempCompenetsDictionary objectForKey:@"WerksText"]];//Werks
                                }
                                else{
                                    [orderDetailComponentTransactionListArray addObject:@""];//WerksText
                                }
                                
                                [orderDetailComponentTransactionListArray addObject:@""];//ComponentAction
                                
                                if([NullChecker isNull:[tempCompenetsDictionary objectForKey:@"Wempf"]]){
                                    [orderDetailComponentTransactionListArray addObject:@""];
                                }
                                else{
                                    [orderDetailComponentTransactionListArray addObject:[tempCompenetsDictionary objectForKey:@"Wempf"]];//receipt
                                }
                                
                                if([NullChecker isNull:[tempCompenetsDictionary objectForKey:@"Ablad"]]){
                                    [orderDetailComponentTransactionListArray addObject:@""];
                                }
                                else{
                                    [orderDetailComponentTransactionListArray addObject:[tempCompenetsDictionary objectForKey:@"Ablad"]];//unload
                                }
                                
                                
                                
                                id customFieldsComponentsTransactionsID;
                                NSMutableArray *transactionsComponentsCustomFields = [NSMutableArray new];
                                
                                if ([tempCompenetsDictionary objectForKey:@"Fields"]) {
                                    
                                    NSMutableArray *fieldsArray=[NSMutableArray new];
                                    
                                    if ([[[tempCompenetsDictionary objectForKey:@"Fields"] objectForKey:@"item"] isKindOfClass:[NSDictionary class]]) {
                                        
                                        [fieldsArray addObjectsFromArray:[NSMutableArray arrayWithObject:[[tempCompenetsDictionary objectForKey:@"Fields"] objectForKey:@"item"]]];
                                    }
                                    else if ([[[tempCompenetsDictionary objectForKey:@"Fields"] objectForKey:@"item"] isKindOfClass:[NSArray class]]){
                                        
                                        [fieldsArray addObjectsFromArray:[[tempCompenetsDictionary objectForKey:@"Fields"] objectForKey:@"item"]];
                                        
                                    }
                                    
                                    
                                    for (int l =0; l<[fieldsArray count]; l++) {
                                        NSString *fieldValue,*fieldName,*fLabel,*tabName,*docType,*docTypeItem,*dataType,*sequence,*length;
                                        if ([NullChecker isNull:[[fieldsArray objectAtIndex:l] objectForKey:@"Fieldname"]]) {
                                            fieldName = @"";
                                        }
                                        else{
                                            fieldName = [[fieldsArray objectAtIndex:l] objectForKey:@"Fieldname"];
                                        }
                                        
                                        if ([NullChecker isNull:[[fieldsArray objectAtIndex:l] objectForKey:@"Flabel"]]) {
                                            fLabel = @"";
                                        }
                                        else{
                                            fLabel = [[fieldsArray objectAtIndex:l] objectForKey:@"Flabel"];
                                        }
                                        
                                        if ([NullChecker isNull:[[fieldsArray objectAtIndex:l] objectForKey:@"Tabname"]]) {
                                            tabName = @"";
                                        }
                                        else{
                                            tabName = [[fieldsArray objectAtIndex:l] objectForKey:@"Tabname"];
                                        }
                                        
                                        if ([NullChecker isNull:[[fieldsArray objectAtIndex:l] objectForKey:@"Value"]]) {
                                            fieldValue = @"";
                                        }
                                        else{
                                            fieldValue = [[fieldsArray objectAtIndex:l] objectForKey:@"Value"];
                                        }
                                        
                                        if ([NullChecker isNull:[[fieldsArray objectAtIndex:l] objectForKey:@"Zdoctype"]]) {
                                            docType = @"";
                                        }
                                        else{
                                            docType = [[fieldsArray objectAtIndex:l] objectForKey:@"Zdoctype"];
                                        }
                                        
                                        if ([NullChecker isNull:[[fieldsArray objectAtIndex:l] objectForKey:@"ZdoctypeItem"]]) {
                                            docTypeItem = @"";
                                        }
                                        else{
                                            docTypeItem = [[fieldsArray objectAtIndex:l] objectForKey:@"ZdoctypeItem"];
                                        }
                                        
                                        if ([NullChecker isNull:[[fieldsArray objectAtIndex:l] objectForKey:@"Datatype"]]) {
                                            dataType = @"";
                                        }
                                        else{
                                            dataType = [[fieldsArray objectAtIndex:l] objectForKey:@"Datatype"];
                                        }
                                        
                                        if ([NullChecker isNull:[[fieldsArray objectAtIndex:l] objectForKey:@"Sequence"]]) {
                                            sequence = @"";
                                        }
                                        else{
                                            sequence = [[fieldsArray objectAtIndex:l] objectForKey:@"Sequence"];
                                        }
                                        
                                        if ([NullChecker isNull:[[fieldsArray objectAtIndex:l] objectForKey:@"Length"]]) {
                                            length = @"";
                                        }
                                        else{
                                            length = [[fieldsArray objectAtIndex:l] objectForKey:@"Length"];
                                        }
                                        
                                        if ([docTypeItem isEqualToString:@"WC"]){
                                            [transactionsComponentsCustomFields addObject:[NSMutableArray arrayWithObjects:docType,docTypeItem,tabName,fieldName,fieldValue,fLabel,dataType,sequence,length, nil]];
                                        }
                                    }
                                    
                                    customFieldsComponentsTransactionsID = transactionsComponentsCustomFields;
                                }
                                
                                [orderPartsListArray addObject:[NSArray arrayWithObjects:orderDetailComponentTransactionListArray,customFieldsComponentsTransactionsID, nil]];
                                
                                [orderPartsListArray addObject:[NSArray arrayWithObjects:orderDetailComponentTransactionListArray,[NSArray array], nil]];
                                
                            }
                        }
                    }
                    
                    [[orderDetailDictionary objectForKey:[orderTransactionArray objectAtIndex:i]] replaceObjectAtIndex:3 withObject:orderTransactionListArray];
                    
                    [[orderDetailDictionary objectForKey:[orderTransactionArray objectAtIndex:i]] replaceObjectAtIndex:4 withObject:orderPartsListArray];
                }
                
                [orderTransactionArray removeAllObjects];
                
                ////////////
                
                [orderWsmSafetyMeasuresArray addObjectsFromArray:[orderWSMSafetyMeasuresDictionary allKeys]];
                
                NSArray *recordIDWSMSafetyMeasuresArray;
                NSDictionary *WSMSafetyMeasuresDictionary;
                
                for (int i =0; i<[orderWsmSafetyMeasuresArray count]; i++) {
                    
                    WSMSafetyMeasuresDictionary = [orderWSMSafetyMeasuresDictionary objectForKey:[orderWsmSafetyMeasuresArray objectAtIndex:i]];
                    recordIDWSMSafetyMeasuresArray = [WSMSafetyMeasuresDictionary allKeys];
                    NSMutableArray *orderWSMSafetyMeasuresListArray = [NSMutableArray new];
                    
                    //CREATE TABLE "ORDER_WSM_SAFETYMEASURES" ("orderwsm_header_id" VARCHAR, "orderwsm_aufnr" VARCHAR, "orderwsm_vornr_operation" VARCHAR,"orderwsm_description" VARCHAR, "orderwsm_safety_text_no" VARCHAR, "orderwsm_objid" VARCHAR, "orderwsm_objtype" VARCHAR, "orderwsm_safetychar" VARCHAR, "orderwsm_safetychar_text" VARCHAR, "orderwsm_action" VARCHAR)
                    
                    for (int j=0; j<[recordIDWSMSafetyMeasuresArray count]; j++) {
                        
                        NSMutableArray *orderDetailWSMSafetyListArray = [NSMutableArray new];
                        
                        tempDictionary = [WSMSafetyMeasuresDictionary objectForKey:[recordIDWSMSafetyMeasuresArray objectAtIndex:j]];
                        
                        if ([NullChecker isNull:[tempDictionary objectForKey:@"EamsAufnr"]]) {
                            [orderDetailWSMSafetyListArray addObject:@""];
                        }
                        else{
                            [orderDetailWSMSafetyListArray addObject:[NSString stringWithFormat:@"%lld",[[tempDictionary objectForKey:@"EamsAufnr"] longLongValue]]];
                        }
                        
                        
                        [orderDetailWSMSafetyListArray addObject:@""];//operation
                        
                        if ([NullChecker isNull:[tempDictionary objectForKey:@"Description"]]) {
                            [orderDetailWSMSafetyListArray addObject:@""];
                        }
                        else{
                            [orderDetailWSMSafetyListArray addObject:[tempDictionary objectForKey:@"Description"]];
                        }
                        
                        if ([NullChecker isNull:[tempDictionary objectForKey:@"EamsSafetyTextNo"]]) {
                            [orderDetailWSMSafetyListArray addObject:@""];
                        }
                        else{
                            [orderDetailWSMSafetyListArray addObject:[tempDictionary objectForKey:@"EamsSafetyTextNo"]];
                        }
                        
                        if ([NullChecker isNull:[tempDictionary objectForKey:@"ObjId"]]) {
                            [orderDetailWSMSafetyListArray addObject:@""];
                        }
                        else{
                            [orderDetailWSMSafetyListArray addObject:[tempDictionary objectForKey:@"ObjId"]];
                        }
                        
                        if ([NullChecker isNull:[tempDictionary objectForKey:@"ObjType"]]) {
                            [orderDetailWSMSafetyListArray addObject:@""];
                        }
                        else{
                            
                            if ([[tempDictionary objectForKey:@"ObjType"] isEqualToString:@"DO"]) {
                                
                                [orderDetailWSMSafetyListArray addObject:@"Document"];
                            }
                            else{
                                
                                [orderDetailWSMSafetyListArray addObject:[tempDictionary objectForKey:@"ObjType"]];
                            }
                        }
                        
                        if ([NullChecker isNull:[tempDictionary objectForKey:@"SafetyChar"]]) {
                            [orderDetailWSMSafetyListArray addObject:@""];
                        }
                        else{
                            [orderDetailWSMSafetyListArray addObject:[tempDictionary objectForKey:@"SafetyChar"]];
                        }
                        
                        if ([NullChecker isNull:[tempDictionary objectForKey:@"SafetyCharTxt"]]) {
                            [orderDetailWSMSafetyListArray addObject:@""];
                        }
                        else{
                            [orderDetailWSMSafetyListArray addObject:[tempDictionary objectForKey:@"SafetyCharTxt"]];
                        }
                        
                        [orderDetailWSMSafetyListArray addObject:@""];//selection
                        
                        [orderWSMSafetyMeasuresListArray addObject:orderDetailWSMSafetyListArray];
                    }
                    
                    [[orderDetailDictionary objectForKey:[orderWsmSafetyMeasuresArray objectAtIndex:i]] replaceObjectAtIndex:5 withObject:orderWSMSafetyMeasuresListArray];
                }
                
                [orderWsmSafetyMeasuresArray removeAllObjects];
                
                ///////////
                
                [orderStatusArray addObjectsFromArray:[orderStatusDictionary allKeys]];
                
                NSArray *recordIDorderStatusArray;
                NSDictionary *EtorderStatusDictionary;
                
                for (int i =0; i<[orderStatusArray count]; i++) {
                    
                    EtorderStatusDictionary = [orderStatusDictionary objectForKey:[orderStatusArray objectAtIndex:i]];
                    recordIDorderStatusArray = [EtorderStatusDictionary allKeys];
                    
                    NSMutableArray *orderStatusDetailArray = [NSMutableArray new];
                    
                    BOOL act = NO;
                    
                    for (int j=0; j<[recordIDorderStatusArray count]; j++) {
                        
                        NSMutableDictionary *orderStatusListDictionary = [NSMutableDictionary new];
                        
                        tempDictionary = [EtorderStatusDictionary objectForKey:[recordIDorderStatusArray objectAtIndex:j]];
                        
                        if ([NullChecker isNull:[tempDictionary objectForKey:@"Aufnr"]]) {
                            [orderStatusListDictionary setObject:@"" forKey:@"orders_aufnr"];
                        }
                        else{
                            
                            [orderStatusListDictionary setObject:[NSString stringWithFormat:@"%lld",[[tempDictionary objectForKey:@"Aufnr"] longLongValue]] forKey:@"orders_aufnr"];
                        }
                        
                        if ([NullChecker isNull:[tempDictionary objectForKey:@"Vornr"]]) {
                            [orderStatusListDictionary setObject:@"" forKey:@"orders_vornr_operation"];
                        }
                        else{
                            
                            [orderStatusListDictionary setObject:[tempDictionary objectForKey:@"Vornr"] forKey:@"orders_vornr_operation"];
                        }
                        
                        if ([NullChecker isNull:[tempDictionary objectForKey:@"Objnr"]]) {
                            
                            [orderStatusListDictionary setObject:@"" forKey:@"orders_objnr"];
                        }
                        else{
                            
                            [orderStatusListDictionary setObject:[tempDictionary objectForKey:@"Objnr"] forKey:@"orders_objnr"];
                        }
                        
                        if ([NullChecker isNull:[tempDictionary objectForKey:@"Stsma"]]) {
                            
                            [orderStatusListDictionary setObject:@"" forKey:@"orders_stsma"];
                        }
                        else{
                            
                            [orderStatusListDictionary setObject:[tempDictionary objectForKey:@"Stsma"] forKey:@"orders_stsma"];
                        }
                        
                        if ([NullChecker isNull:[tempDictionary objectForKey:@"Inist"]]) {
                            
                            [orderStatusListDictionary setObject:@"" forKey:@"orders_inist"];
                        }
                        else{
                            
                            [orderStatusListDictionary setObject:[tempDictionary objectForKey:@"Inist"] forKey:@"orders_inist"];
                        }
                        
                        if ([NullChecker isNull:[tempDictionary objectForKey:@"Stonr"]]) {
                            [orderStatusListDictionary setObject:@"" forKey:@"orders_stonr"];
                        }
                        else{
                            
                            [orderStatusListDictionary setObject:[tempDictionary objectForKey:@"Stonr"] forKey:@"orders_stonr"];
                        }
                        
                        if ([NullChecker isNull:[tempDictionary objectForKey:@"Hsonr"]]) {
                            
                            [orderStatusListDictionary setObject:@"" forKey:@"orders_hsonr"];
                        }
                        else{
                            
                            [orderStatusListDictionary setObject:[tempDictionary objectForKey:@"Hsonr"] forKey:@"orders_hsonr"];
                        }
                        
                        if ([NullChecker isNull:[tempDictionary objectForKey:@"Nsonr"]]) {
                            
                            [orderStatusListDictionary setObject:@"" forKey:@"orders_nsonr"];
                        }
                        else{
                            
                            [orderStatusListDictionary setObject:[tempDictionary objectForKey:@"Nsonr"] forKey:@"orders_nsonr"];
                        }
                        
                        if ([NullChecker isNull:[tempDictionary objectForKey:@"Stat"]]) {
                            [orderStatusListDictionary setObject:@"" forKey:@"orders_stat"];
                        }
                        else{
                            
                            [orderStatusListDictionary setObject:[[tempDictionary objectForKey:@"Stat"] substringToIndex:1] forKey:@"orders_stat"];
                        }
                        
                        if ([NullChecker isNull:[tempDictionary objectForKey:@"Act"]]) {
                            [orderStatusListDictionary setObject:@"" forKey:@"orders_act"];
                            
                            if (act ==YES) {
                                [orderStatusListDictionary setObject:@"" forKey:@"orders_selected"];//Selection
                            }
                            else{
                                
                                [orderStatusListDictionary setObject:@"Y" forKey:@"orders_selected"];//Selection
                            }
                        }
                        else{
                            
                            [orderStatusListDictionary setObject:[tempDictionary objectForKey:@"Act"] forKey:@"orders_act"];
                            [orderStatusListDictionary setObject:@"X" forKey:@"orders_selected"];//Selection
                            if ([[[tempDictionary objectForKey:@"Stat"] substringToIndex:1] isEqualToString:@"E"]) {
                                act = YES;
                            }
                        }
                        
                        if ([NullChecker isNull:[tempDictionary objectForKey:@"Txt04"]]) {
                            [orderStatusListDictionary setObject:@"" forKey:@"orders_txt04"];
                        }
                        else{
                            [orderStatusListDictionary setObject:[tempDictionary objectForKey:@"Txt04"] forKey:@"orders_txt04"];
                        }
                        
                        if ([NullChecker isNull:[tempDictionary objectForKey:@"Txt30"]]) {
                            [orderStatusListDictionary setObject:@"" forKey:@"orders_txt30"];
                        }
                        else{
                            
                            [orderStatusListDictionary setObject:[tempDictionary objectForKey:@"Txt30"] forKey:@"orders_txt30"];
                        }
                        
                        [orderStatusDetailArray addObject:orderStatusListDictionary];
                        
                        if ([tempDictionary objectForKey:@"SystemStatus"]) {
                            
                            if ([[tempDictionary objectForKey:@"SystemStatus"] isKindOfClass:[NSArray class]]) {
                                
                                id systemStatus = [tempDictionary objectForKey:@"SystemStatus"];
                                
                                for (int k =0 ; k <[systemStatus count]; k++) {
                                    
                                    NSMutableDictionary *orderStatusListDictionary = [NSMutableDictionary new];
                                    
                                    tempDictionary = [systemStatus objectAtIndex:k];
                                    
                                    if ([NullChecker isNull:[tempDictionary objectForKey:@"Aufnr"]]) {
                                        [orderStatusListDictionary setObject:@"" forKey:@"orders_aufnr"];
                                    }
                                    else{
                                        
                                        [orderStatusListDictionary setObject:[NSString stringWithFormat:@"%lld",[[tempDictionary objectForKey:@"Aufnr"] longLongValue]] forKey:@"orders_aufnr"];
                                    }
                                    
                                    if ([NullChecker isNull:[tempDictionary objectForKey:@"Vornr"]]) {
                                        [orderStatusListDictionary setObject:@"" forKey:@"orders_vornr_operation"];
                                    }
                                    else{
                                        
                                        [orderStatusListDictionary setObject:[tempDictionary objectForKey:@"Vornr"] forKey:@"orders_vornr_operation"];
                                    }
                                    
                                    if ([NullChecker isNull:[tempDictionary objectForKey:@"Objnr"]]) {
                                        
                                        [orderStatusListDictionary setObject:@"" forKey:@"orders_objnr"];
                                    }
                                    else{
                                        
                                        [orderStatusListDictionary setObject:[tempDictionary objectForKey:@"Objnr"] forKey:@"orders_objnr"];
                                    }
                                    
                                    if ([NullChecker isNull:[tempDictionary objectForKey:@"Stsma"]]) {
                                        
                                        [orderStatusListDictionary setObject:@"" forKey:@"orders_stsma"];
                                    }
                                    else{
                                        
                                        [orderStatusListDictionary setObject:[tempDictionary objectForKey:@"Stsma"] forKey:@"orders_stsma"];
                                    }
                                    
                                    if ([NullChecker isNull:[tempDictionary objectForKey:@"Inist"]]) {
                                        
                                        [orderStatusListDictionary setObject:@"" forKey:@"orders_inist"];
                                    }
                                    else{
                                        
                                        [orderStatusListDictionary setObject:[tempDictionary objectForKey:@"Inist"] forKey:@"orders_inist"];
                                    }
                                    
                                    if ([NullChecker isNull:[tempDictionary objectForKey:@"Stonr"]]) {
                                        [orderStatusListDictionary setObject:@"" forKey:@"orders_stonr"];
                                    }
                                    else{
                                        
                                        [orderStatusListDictionary setObject:[tempDictionary objectForKey:@"Stonr"] forKey:@"orders_stonr"];
                                    }
                                    
                                    if ([NullChecker isNull:[tempDictionary objectForKey:@"Hsonr"]]) {
                                        
                                        [orderStatusListDictionary setObject:@"" forKey:@"orders_hsonr"];
                                    }
                                    else{
                                        
                                        [orderStatusListDictionary setObject:[tempDictionary objectForKey:@"Hsonr"] forKey:@"orders_hsonr"];
                                    }
                                    
                                    if ([NullChecker isNull:[tempDictionary objectForKey:@"Nsonr"]]) {
                                        
                                        [orderStatusListDictionary setObject:@"" forKey:@"orders_nsonr"];
                                    }
                                    else{
                                        
                                        [orderStatusListDictionary setObject:[tempDictionary objectForKey:@"Nsonr"] forKey:@"orders_nsonr"];
                                    }
                                    
                                    if ([NullChecker isNull:[tempDictionary objectForKey:@"Stat"]]) {
                                        
                                        [orderStatusListDictionary setObject:@"" forKey:@"orders_stat"];
                                    }
                                    else{
                                        
                                        if ([[[tempDictionary objectForKey:@"Stat"] substringToIndex:1] isEqualToString:@"I"]) {
                                            
                                            [orderStatusListDictionary setObject:[[tempDictionary objectForKey:@"Stat"] substringToIndex:1] forKey:@"orders_stat"];
                                        }
                                        else{
                                            
                                            [orderStatusListDictionary setObject:[[tempDictionary objectForKey:@"Stat"] substringToIndex:1] forKey:@"orders_stat"];
                                            
                                        }
                                    }
                                    
                                    if ([NullChecker isNull:[tempDictionary objectForKey:@"Act"]]) {
                                        [orderStatusListDictionary setObject:@"" forKey:@"orders_act"];
                                        if (act ==YES) {
                                            [orderStatusListDictionary setObject:@"" forKey:@"orders_selected"];//Selection
                                        }
                                        else{
                                            [orderStatusListDictionary setObject:@"Y" forKey:@"orders_selected"];//Selection
                                        }
                                    }
                                    else{
                                        
                                        [orderStatusListDictionary setObject:[tempDictionary objectForKey:@"Act"] forKey:@"orders_act"];
                                        
                                        [orderStatusListDictionary setObject:@"X" forKey:@"orders_selected"];//Selection
                                        
                                        if ([[[tempDictionary objectForKey:@"Stat"] substringToIndex:1] isEqualToString:@"E"]) {
                                            act = YES;
                                        }
                                        
                                    }
                                    
                                    if ([NullChecker isNull:[tempDictionary objectForKey:@"Txt04"]]) {
                                        [orderStatusListDictionary setObject:@"" forKey:@"orders_txt04"];
                                    }
                                    else{
                                        [orderStatusListDictionary setObject:[tempDictionary objectForKey:@"Txt04"] forKey:@"orders_txt04"];
                                    }
                                    
                                    if ([NullChecker isNull:[tempDictionary objectForKey:@"Txt30"]]) {
                                        [orderStatusListDictionary setObject:@"" forKey:@"orders_txt30"];
                                    }
                                    else{
                                        
                                        [orderStatusListDictionary setObject:[tempDictionary objectForKey:@"Txt30"] forKey:@"orders_txt30"];
                                    }
                                    
                                    [orderStatusDetailArray addObject:orderStatusListDictionary];
                                }
                            }
                        }
                    }
                    
                    [[orderDetailDictionary objectForKey:[orderStatusArray objectAtIndex:i]] replaceObjectAtIndex:6 withObject:orderStatusDetailArray];
                }
                
                [orderStatusArray removeAllObjects];
                
                ////////////
                
                [orderOlistArray addObjectsFromArray:[orderOlistDictionary allKeys]];
                
                NSArray *recordOlistArray;
                NSDictionary *orderObjectlistDictionary;
                
                for (int i =0; i<[orderOlistArray count]; i++) {
                    
                    orderObjectlistDictionary = [orderOlistDictionary objectForKey:[orderOlistArray objectAtIndex:i]];
                    recordOlistArray = [orderObjectlistDictionary allKeys];
                    NSMutableArray *orderObjectListArray = [NSMutableArray new];
                    
                    //CREATE TABLE "ORDER_OBJECTS" ("orderobject_header_id" VARCHAR, "orderobject_aufnr" VARCHAR, "orderobject_obknr" VARCHAR, "orderobject_obzae" VARCHAR, "orderobject_qmnum" VARCHAR, "orderobject_equnr" VARCHAR, "orderobject_strno" VARCHAR, "orderobject_tplnr" VARCHAR, "orderobject_bautl" VARCHAR, "orderobject_qmtxt" VARCHAR, "orderobject_pltxt" VARCHAR, "orderobject_eqktx" VARCHAR, "orderobject_maktx" VARCHAR, "orderobject_action" VARCHAR)
                    
                    for (int j=0; j<[recordOlistArray count]; j++) {
                        
                        NSMutableArray *orderDetailObjectListArray = [NSMutableArray new];
                        
                        tempDictionary = [orderObjectlistDictionary objectForKey:[recordOlistArray objectAtIndex:j]];
                        
                        if ([NullChecker isNull:[tempDictionary objectForKey:@"Aufnr"]]) {
                            [orderDetailObjectListArray addObject:@""];
                        }
                        else{
                            [orderDetailObjectListArray addObject:[NSString stringWithFormat:@"%lld",[[tempDictionary objectForKey:@"Aufnr"] longLongValue]]];
                        }
                        
                        
                        if ([NullChecker isNull:[tempDictionary objectForKey:@"Obknr"]]) {
                            [orderDetailObjectListArray addObject:@""];
                        }
                        else{
                            [orderDetailObjectListArray addObject:[tempDictionary objectForKey:@"Obknr"]];
                        }
                        
                        if ([NullChecker isNull:[tempDictionary objectForKey:@"Obzae"]]) {
                            [orderDetailObjectListArray addObject:@""];
                        }
                        else{
                            [orderDetailObjectListArray addObject:[tempDictionary objectForKey:@"Obzae"]];
                        }
                        
                        if ([NullChecker isNull:[tempDictionary objectForKey:@"Qmnum"]]) {
                            [orderDetailObjectListArray addObject:@""];
                        }
                        else{
                            [orderDetailObjectListArray addObject:[tempDictionary objectForKey:@"Qmnum"]];
                        }
                        
                        if ([NullChecker isNull:[tempDictionary objectForKey:@"Equnr"]]) {
                            [orderDetailObjectListArray addObject:@""];
                        }
                        else{
                            
                            [orderDetailObjectListArray addObject:[tempDictionary objectForKey:@"Equnr"]];
                            
                        }
                        
                        if ([NullChecker isNull:[tempDictionary objectForKey:@"Strno"]]) {
                            [orderDetailObjectListArray addObject:@""];
                        }
                        else{
                            [orderDetailObjectListArray addObject:[tempDictionary objectForKey:@"Strno"]];
                        }
                        
                        if ([NullChecker isNull:[tempDictionary objectForKey:@"Tplnr"]]) {
                            [orderDetailObjectListArray addObject:@""];
                        }
                        else{
                            [orderDetailObjectListArray addObject:[tempDictionary objectForKey:@"Tplnr"]];
                        }
                        
                        if([NullChecker isNull:[tempDictionary objectForKey:@"Bautl"]]){
                            
                            [orderDetailObjectListArray addObject:@""];
                        }
                        else{
                            [orderDetailObjectListArray addObject:[tempDictionary objectForKey:@"Bautl"]];
                        }
                        
                        if([NullChecker isNull:[tempDictionary objectForKey:@"Qmtxt"]]){
                            
                            [orderDetailObjectListArray addObject:@""];
                        }
                        else{
                            [orderDetailObjectListArray addObject:[tempDictionary objectForKey:@"Qmtxt"]];
                        }
                        
                        if([NullChecker isNull:[tempDictionary objectForKey:@"Pltxt"]]){
                            
                            [orderDetailObjectListArray addObject:@""];
                        }
                        else{
                            [orderDetailObjectListArray addObject:[tempDictionary objectForKey:@"Pltxt"]];
                        }
                        
                        if([NullChecker isNull:[tempDictionary objectForKey:@"Eqktx"]]){
                            
                            [orderDetailObjectListArray addObject:@""];
                        }
                        else{
                            [orderDetailObjectListArray addObject:[tempDictionary objectForKey:@"Eqktx"]];
                        }
                        
                        if([NullChecker isNull:[tempDictionary objectForKey:@"Maktx"]]){
                            
                            [orderDetailObjectListArray addObject:@""];
                        }
                        else{
                            [orderDetailObjectListArray addObject:[tempDictionary objectForKey:@"Maktx"]];
                        }
                        
                        if([NullChecker isNull:[tempDictionary objectForKey:@"Action"]]){
                            
                            [orderDetailObjectListArray addObject:@""];
                        }
                        else{
                            [orderDetailObjectListArray addObject:[tempDictionary objectForKey:@"Action"]];
                        }
                        
                        [orderObjectListArray addObject:orderDetailObjectListArray];
                    }
                    
                    [[orderDetailDictionary objectForKey:[orderOlistArray objectAtIndex:i]] replaceObjectAtIndex:7 withObject:orderObjectListArray];
                }
                
                [orderOlistArray removeAllObjects];
                
                ////////////
                
                responseObject = nil;
                
                [orderMeasurementDocumentsArray addObjectsFromArray:[orderMeasurementDocumentsDictionary allKeys]];
                
                NSArray *recordIDMDocsArray;
                NSDictionary *mDocsDictionary;
                
                for (int i =0; i<[orderMeasurementDocumentsArray  count]; i++) {
                    mDocsDictionary = [orderMeasurementDocumentsDictionary objectForKey:[orderMeasurementDocumentsArray objectAtIndex:i]];
                    recordIDMDocsArray = [mDocsDictionary allKeys];
                    NSMutableArray *orderMDocsListArray = [NSMutableArray new];
                    
                    for (int j=0; j<[recordIDMDocsArray count]; j++) {
                        NSMutableArray *orderDetailMDocsListArray = [NSMutableArray new];
                        
                        tempDictionary = [mDocsDictionary objectForKey:[recordIDMDocsArray objectAtIndex:j]];
                        
                        if ([NullChecker isNull:[tempDictionary objectForKey:@"Qmnum"]]) {
                            [orderDetailMDocsListArray addObject:@""];
                        }
                        else{
                            [orderDetailMDocsListArray addObject:[tempDictionary objectForKey:@"Qmnum"]];
                        }
                        
                        if ([NullChecker isNull:[tempDictionary objectForKey:@"Aufnr"]]) {
                            [orderDetailMDocsListArray addObject:@""];
                        }
                        else{
                            [orderDetailMDocsListArray addObject:[tempDictionary objectForKey:@"Aufnr"]];
                        }
                        
                        if ([NullChecker isNull:[tempDictionary objectForKey:@"Vornr"]]) {
                            [orderDetailMDocsListArray addObject:@""];
                        }
                        else{
                            [orderDetailMDocsListArray addObject:[tempDictionary objectForKey:@"Vornr"]];
                        }
                        
                        if ([NullChecker isNull:[tempDictionary objectForKey:@"Mdocm"]]) {
                            [orderDetailMDocsListArray addObject:@""];
                        }
                        else{
                            [orderDetailMDocsListArray addObject:[tempDictionary objectForKey:@"Mdocm"]];
                        }
                        if ([NullChecker isNull:[tempDictionary objectForKey:@"Point"]]) {
                            [orderDetailMDocsListArray addObject:@""];
                        }
                        else{
                            [orderDetailMDocsListArray addObject:[tempDictionary objectForKey:@"Point"]];
                        }
                        
                        if ([NullChecker isNull:[tempDictionary objectForKey:@"Mpobj"]]) {
                            
                            [orderDetailMDocsListArray addObject:@""];
                        }
                        else{
                            [orderDetailMDocsListArray addObject:[tempDictionary objectForKey:@"Mpobj"]];
                        }
                        
                        if ([NullChecker isNull:[tempDictionary objectForKey:@"Mpobt"]]) {
                            
                            [orderDetailMDocsListArray addObject:@""];
                        }
                        else{
                            [orderDetailMDocsListArray addObject:[tempDictionary objectForKey:@"Mpobt"]];
                        }
                        
                        if ([NullChecker isNull:[tempDictionary objectForKey:@"Psort"]]) {
                            
                            [orderDetailMDocsListArray addObject:@""];
                        }
                        else{
                            [orderDetailMDocsListArray addObject:[tempDictionary objectForKey:@"Psort"]];
                        }
                        
                        if ([NullChecker isNull:[tempDictionary objectForKey:@"Pttxt"]]) {
                            
                            [orderDetailMDocsListArray addObject:@""];
                        }
                        else{
                            [orderDetailMDocsListArray addObject:[tempDictionary objectForKey:@"Pttxt"]];
                        }
                        
                        if ([NullChecker isNull:[tempDictionary objectForKey:@"Atinn"]]) {
                            
                            [orderDetailMDocsListArray addObject:@""];
                        }
                        else{
                            [orderDetailMDocsListArray addObject:[tempDictionary objectForKey:@"Atinn"]];
                        }
                        
                        if ([NullChecker isNull:[tempDictionary objectForKey:@"Idate"]]) {
                            
                            [orderDetailMDocsListArray addObject:@""];
                        }
                        else{
                            [orderDetailMDocsListArray addObject:[tempDictionary objectForKey:@"Idate"]];
                        }
                        
                        if ([NullChecker isNull:[tempDictionary objectForKey:@"Itime"]]) {
                            
                            [orderDetailMDocsListArray addObject:@""];
                        }
                        else{
                            [orderDetailMDocsListArray addObject:[tempDictionary objectForKey:@"Itime"]];
                        }
                        
                        
                        if ([NullChecker isNull:[tempDictionary objectForKey:@"Mdtxt"]]) {
                            
                            [orderDetailMDocsListArray addObject:@""];
                        }
                        else{
                            [orderDetailMDocsListArray addObject:[tempDictionary objectForKey:@"Mdtxt"]];
                        }
                        
                        
                        if ([NullChecker isNull:[tempDictionary objectForKey:@"Readr"]]) {
                            
                            [orderDetailMDocsListArray addObject:@""];
                        }
                        else{
                            [orderDetailMDocsListArray addObject:[tempDictionary objectForKey:@"Readr"]];
                        }
                        
                        if ([NullChecker isNull:[tempDictionary objectForKey:@"Atbez"]]) {
                            
                            [orderDetailMDocsListArray addObject:@""];
                        }
                        else{
                            [orderDetailMDocsListArray addObject:[tempDictionary objectForKey:@"Atbez"]];
                        }
                        
                        
                        if ([NullChecker isNull:[tempDictionary objectForKey:@"Msehi"]]) {
                            
                            [orderDetailMDocsListArray addObject:@""];//
                        }
                        else{
                            [orderDetailMDocsListArray addObject:[tempDictionary objectForKey:@"Msehi"]];
                        }
                        
                        if ([NullChecker isNull:[tempDictionary objectForKey:@"Msehl"]]) {
                            
                            [orderDetailMDocsListArray addObject:@""];
                        }
                        else{
                            [orderDetailMDocsListArray addObject:[tempDictionary objectForKey:@"Msehl"]];
                        }
                        
                        if ([NullChecker isNull:[tempDictionary objectForKey:@"Readc"]]) {
                            
                            [orderDetailMDocsListArray addObject:@""];
                        }
                        else{
                            [orderDetailMDocsListArray addObject:[tempDictionary objectForKey:@"Readc"]];
                        }
                        
                        if ([NullChecker isNull:[tempDictionary objectForKey:@"Desic"]]) {
                            
                            [orderDetailMDocsListArray addObject:@""];
                        }
                        else{
                            [orderDetailMDocsListArray addObject:[tempDictionary objectForKey:@"Desic"]];
                        }
                        
                        if ([NullChecker isNull:[tempDictionary objectForKey:@"Prest"]]) {
                            
                            [orderDetailMDocsListArray addObject:@""];
                        }
                        else{
                            [orderDetailMDocsListArray addObject:[tempDictionary objectForKey:@"Prest"]];
                        }
                        
                        if ([NullChecker isNull:[tempDictionary objectForKey:@"Docaf"]]) {
                            
                            [orderDetailMDocsListArray addObject:@""];
                        }
                        else{
                            [orderDetailMDocsListArray addObject:[tempDictionary objectForKey:@"Docaf"]];
                        }
                        
                        
                        if ([NullChecker isNull:[tempDictionary objectForKey:@"Action"]]) {
                            
                            [orderDetailMDocsListArray addObject:@""];
                        }
                        else{
                            [orderDetailMDocsListArray addObject:[tempDictionary objectForKey:@"Action"]];
                        }
                        
                        [orderMDocsListArray addObject:orderDetailMDocsListArray];
                    }
                    
                    [[orderDetailDictionary objectForKey:[orderMeasurementDocumentsArray objectAtIndex:i]] replaceObjectAtIndex:11 withObject:orderMDocsListArray];
                }
                
                [orderMeasurementDocumentsArray removeAllObjects];
                
                ///
                
                NSArray *objectIds = [orderDetailDictionary allKeys];
                
                if ([[defaults objectForKey:@"ACTIVATELOGS"] isEqualToString:@"X"])
                {
                    [[DataBase sharedInstance] writToLogFile:[NSString stringWithFormat:@"#INFO#.com.enstrapp.fieldtekpro#No of Due Orders received:%lu",(unsigned long)[objectIds count]]];
                }
                
                for (int i=0; i<[objectIds count]; i++) {
                    
                    if (i ==1) {
                        
                        [orderWcmOperationWCDTaggingConditionsArray removeAllObjects];
                        [orderWcmPermitsStandardCheckPoints removeAllObjects];
                    }
                    
                    [[DataBase sharedInstance] insertDataIntoOrderHeader:[[orderDetailDictionary objectForKey:[objectIds objectAtIndex:i]] firstObject] withAttachments:[[orderDetailDictionary objectForKey:[objectIds objectAtIndex:i]] objectAtIndex:2] withPermitWorkApprovalsDetails:[[orderDetailDictionary objectForKey:[objectIds objectAtIndex:i]] objectAtIndex:1] withOperation:[[orderDetailDictionary objectForKey:[objectIds objectAtIndex:i]] objectAtIndex:3] withParts:[[orderDetailDictionary objectForKey:[objectIds objectAtIndex:i]] objectAtIndex:4] withWSM:[[orderDetailDictionary objectForKey:[objectIds objectAtIndex:i]] objectAtIndex:5] withObjects:[[orderDetailDictionary objectForKey:[objectIds objectAtIndex:i]] objectAtIndex:7] withSystemStatus:[[orderDetailDictionary objectForKey:[objectIds objectAtIndex:i]] objectAtIndex:6] withPermitsWorkApplications:[[orderDetailDictionary objectForKey:[objectIds objectAtIndex:i]] objectAtIndex:8] withIssuePermits:[[orderDetailDictionary objectForKey:[objectIds objectAtIndex:i]] objectAtIndex:9] withPermitsOperationWCD:[[orderDetailDictionary objectForKey:[objectIds objectAtIndex:i]] objectAtIndex:10] withPermitsOperationWCDTagiingConditions:orderWcmOperationWCDTaggingConditionsArray withPermitsStandardCheckPoints:orderWcmPermitsStandardCheckPoints withMeasurementDocs:[[orderDetailDictionary objectForKey:[objectIds objectAtIndex:i]] objectAtIndex:11]];
                }
            
            }
 
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
           }
            else{
                
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                
                [self showAlertMessageWithTitle:@"FieldTekPro" message:errorDescription cancelButtonTitle:@"Ok" withactionType:@"Single" forMethod:nil];
                
            }
            
            break;
 
        case NOTIFICATION_POSTPONE:
            
            if (!errorDescription.length) {
                
                if (statusCode == 401) {
                    
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    
                     [self showAlertMessageWithTitle:@"Authentication Failed!!" message:@"kindly check your password" cancelButtonTitle:@"OK" withactionType:@"Single" forMethod:nil];
                    
                }
                else{
                    
                    NSMutableDictionary *parsedDictionary = [[Response sharedInstance] parseForReleaseNotification:resultData];
                    
                    if ([parsedDictionary objectForKey:@"MESSAGE"]) {
                        
                        NSMutableString *messageString = [NSMutableString stringWithString:@""];
                        
                        NSString *qmnumString;
                        
                        [[DataBase sharedInstance] deleteNotificationTransactions];
                        [[DataBase sharedInstance] deleteNotificationTasks];
                        
                        if ([[[[parsedDictionary objectForKey:@"MESSAGE"] substringToIndex:1] uppercaseString] isEqualToString:@"S"]) {
                            [messageString appendString:[NSString stringWithFormat:@"%@\n", [[parsedDictionary objectForKey:@"MESSAGE"] substringFromIndex:1]]];
                            
                            [[DataBase sharedInstance] updateSyncLogForCategory:@"Notification" action:@"Postpone" objectid:[parsedDictionary objectForKey:@"OBJECTID"] UUID:[self.notificationHeaderDetails objectForKey:@"ID"]];
                            
                            if ([[defaults objectForKey:@"ACTIVATELOGS"] isEqualToString:@"X"])
                            {
                                [[DataBase sharedInstance] writToLogFile:[NSString stringWithFormat:@"#INFO#.com.enstrapp.fieldtekpro#Notif #Activity:Postpone Notification #Notifno:%@ #Mode:Online #Class: Very Important #MUser:%@ #DeviceId:%@",[parsedDictionary objectForKey:@"OBJECTID"],decryptedUserName,[defaults objectForKey:@"edeviceid"]]];
                                
                            }
                            
                            if ([parsedDictionary objectForKey:@"resultHeader"]) {
                                NSMutableDictionary *notificationDetailDictionary = [[NSMutableDictionary alloc] init];
                                
                                id responseObject = [parsedDictionary objectForKey:@"resultHeader"];
                                
                                NSMutableArray *notificatinHeaderArray = [[NSMutableArray alloc] init];
                                
                                NSMutableArray *inspectionResultDataArray = [NSMutableArray new];
                                
                                
                                [notificatinHeaderArray addObjectsFromArray:responseObject];
                                
                                NSDictionary *headerDictionary;
                                NSDateFormatter *dateFormate = [[NSDateFormatter alloc] init];
                                [dateFormate setDateFormat:@"yyyy-MM-dd"];
                                
                                for (int i=0; i<[notificatinHeaderArray count]; i++) {
                                    if ([[notificatinHeaderArray objectAtIndex:i] isKindOfClass:[NSDictionary class]]) {
                                        headerDictionary = [notificatinHeaderArray objectAtIndex:i];
                                        NSMutableDictionary *currentHeaderDictionary = [[NSMutableDictionary alloc] init];
                                        if ([headerDictionary objectForKey:@"BreakdownInd"]) {
                                            [currentHeaderDictionary setObject:[[headerDictionary objectForKey:@"BreakdownInd"] copy] forKey:@"BREAKDOWN"];
                                        }
                                        else
                                        {
                                            [currentHeaderDictionary setObject:@" " forKey:@"BREAKDOWN"];
                                        }
                                        
                                        if ([headerDictionary objectForKey:@"FunctionLoc"]) {
                                            
                                            [currentHeaderDictionary setObject:[[headerDictionary objectForKey:@"FunctionLoc"] copy] forKey:@"FID"];
                                        }
                                        else{
                                            [currentHeaderDictionary setObject:@"" forKey:@"FID"];
                                        }
                                        if ([headerDictionary objectForKey:@"Pltxt"]) {
                                            
                                            [currentHeaderDictionary setObject:[[headerDictionary objectForKey:@"Pltxt"] copy] forKey:@"FNAME"];
                                        }
                                        else{
                                            [currentHeaderDictionary setObject:@"" forKey:@"FNAME"];
                                        }
                                        
                                        if ([headerDictionary objectForKey:@"NotifShorttxt"]) {
                                            [currentHeaderDictionary setObject:[[headerDictionary objectForKey:@"NotifShorttxt"] copy] forKey:@"SHORTTEXT"];
                                        }
                                        else{
                                            [currentHeaderDictionary setObject:@"" forKey:@"SHORTTEXT"];
                                        }
                                        if ([headerDictionary objectForKey:@"NotifType"]) {
                                            [currentHeaderDictionary setObject:[[headerDictionary objectForKey:@"NotifType"] copy] forKey:@"NID"];
                                        }
                                        else{
                                            [currentHeaderDictionary setObject:@"" forKey:@"NID"];
                                        }
                                        
                                        if ([headerDictionary objectForKey:@"Qmartx"]) {
                                            [currentHeaderDictionary setObject:[[headerDictionary objectForKey:@"Qmartx"] copy] forKey:@"NNAME"];
                                        }
                                        else{
                                            [currentHeaderDictionary setObject:@"" forKey:@"NNAME"];
                                        }
                                        
                                        if ([headerDictionary objectForKey:@"Qmnum"]) {
                                            [currentHeaderDictionary setObject:[[headerDictionary objectForKey:@"Qmnum"] copy] forKey:@"OBJECTID"];
                                        }
                                        else{
                                            [currentHeaderDictionary setObject:@"" forKey:@"OBJECTID"];
                                        }
                                        
                                        if ([headerDictionary objectForKey:@"Qmdat"]) {
                                            [currentHeaderDictionary setObject:[[headerDictionary objectForKey:@"Qmdat"] copy] forKey:@"QMDAT"];
                                        }
                                        else{
                                            [currentHeaderDictionary setObject:@"" forKey:@"QMDAT"];
                                        }
                                        
                                        [currentHeaderDictionary setObject:@"" forKey:@"REPORTEDBY"];
                                        
                                        if ([headerDictionary objectForKey:@"ReportedBy"]) {
                                            [currentHeaderDictionary setObject:[[headerDictionary objectForKey:@"ReportedBy"] copy] forKey:@"NREPORTEDBY"];
                                        }
                                        else{
                                            
                                            [currentHeaderDictionary setObject:@"" forKey:@"NREPORTEDBY"];
                                            
                                        }
                                        
                                        if ([headerDictionary objectForKey:@"Equipment"]) {
                                            [currentHeaderDictionary setObject:[[headerDictionary objectForKey:@"Equipment"] copy] forKey:@"EQID"];
                                        }
                                        else{
                                            [currentHeaderDictionary setObject:@"" forKey:@"EQID"];
                                        }
                                        
                                        if ([headerDictionary objectForKey:@"Eqktx"]) {
                                            [currentHeaderDictionary setObject:[[headerDictionary objectForKey:@"Eqktx"] copy] forKey:@"EQNAME"];
                                        }
                                        else{
                                            [currentHeaderDictionary setObject:@"" forKey:@"EQNAME"];
                                        }
                                        
                                        if ([headerDictionary objectForKey:@"Priority"]) {
                                            [currentHeaderDictionary setObject:[[headerDictionary objectForKey:@"Priority"] copy] forKey:@"NPID"];
                                        }
                                        else{
                                            [currentHeaderDictionary setObject:@"" forKey:@"NPID"];
                                        }
                                        
                                        if ([headerDictionary objectForKey:@"Priokx"]) {
                                            [currentHeaderDictionary setObject:[[headerDictionary objectForKey:@"Priokx"] copy] forKey:@"NPNAME"];
                                        }
                                        else{
                                            [currentHeaderDictionary setObject:@"" forKey:@"NPNAME"];
                                        }
                                        
                                        if ([headerDictionary objectForKey:@"MalfuncEddate"]) {
                                            
                                            NSString *malfunctionEndDateString;
                                            
                                            if (![NullChecker isNull:[headerDictionary objectForKey:@"MalfuncEddate"]]) {
                                                
                                                if ([[headerDictionary objectForKey:@"MalfuncEddate"] rangeOfString:@"Date"].length) {
                                                    
                                                    malfunctionEndDateString=[NSString stringWithFormat:@"%@",[dateFormate stringFromDate:[NSDate dateWithTimeIntervalSince1970:[[[[headerDictionary objectForKey:@"MalfuncEddate"] stringByReplacingOccurrencesOfString:@"/Date(" withString:@""] stringByReplacingOccurrencesOfString:@")/" withString:@""] doubleValue]/1000.0]]];
                                                    
                                                }
                                                else
                                                {
                                                    malfunctionEndDateString=[NSString stringWithFormat:@"%@",[headerDictionary objectForKey:@"MalfuncEddate"]];
                                                }
                                            }
                                            
                                            
                                            
                                            if (malfunctionEndDateString.length) {
                                                
                                                if ([headerDictionary objectForKey:@"MalfuncEdtime"]) {
                                                    
                                                    [currentHeaderDictionary setObject:[NSString stringWithFormat:@"%@ %@",malfunctionEndDateString,[headerDictionary objectForKey:@"MalfuncEdtime"]] forKey:@"EDATE"];
                                                }
                                                else{
                                                    
                                                    [currentHeaderDictionary setObject:malfunctionEndDateString forKey:@"EDATE"];
                                                }
                                            }
                                            
                                        }
                                        else{
                                            [currentHeaderDictionary setObject:@"" forKey:@"EDATE"];
                                        }
                                        
                                        if (![NullChecker isNull:[headerDictionary objectForKey:@"MalfuncStdate"]]) {
                                            
                                            NSString *malfunctionStartDateString;
                                            
                                            if ([[headerDictionary objectForKey:@"MalfuncStdate"] rangeOfString:@"Date"].length) {
                                                
                                                malfunctionStartDateString=[NSString stringWithFormat:@"%@",[dateFormate stringFromDate:[NSDate dateWithTimeIntervalSince1970:[[[[headerDictionary objectForKey:@"MalfuncStdate"] stringByReplacingOccurrencesOfString:@"/Date(" withString:@""] stringByReplacingOccurrencesOfString:@")/" withString:@""] doubleValue]/1000.0]]];
                                            }
                                            else{
                                                
                                                malfunctionStartDateString=[NSString stringWithFormat:@"%@",[headerDictionary objectForKey:@"MalfuncStdate"]];
                                                [currentHeaderDictionary setObject:[NSString stringWithFormat:@"%@",[headerDictionary objectForKey:@"MalfuncStdate"]] forKey:@"SDATE"];
                                            }
                                            
                                            if (malfunctionStartDateString.length) {
                                                
                                                if ([headerDictionary objectForKey:@"MalfuncSttime"]) {
                                                    
                                                    [currentHeaderDictionary setObject:[NSString stringWithFormat:@"%@ %@",malfunctionStartDateString,[headerDictionary objectForKey:@"MalfuncSttime"]] forKey:@"SDATE"];
                                                }
                                                else{
                                                    
                                                    [currentHeaderDictionary setObject:malfunctionStartDateString forKey:@"SDATE"];
                                                }
                                            }
                                            
                                        }
                                        else{
                                            [currentHeaderDictionary setObject:@"" forKey:@"SDATE"];
                                        }
                                        
                                        if ([headerDictionary objectForKey:@"Werks"]) {
                                            [currentHeaderDictionary setObject:[headerDictionary objectForKey:@"Werks"] forKey:@"PLANTID"];
                                            [currentHeaderDictionary setObject:[headerDictionary objectForKey:@"Plantname"] forKey:@"PLANTNAME"];
                                        }
                                        else{
                                            [currentHeaderDictionary setObject:@"" forKey:@"PLANTID"];
                                            [currentHeaderDictionary setObject:@"" forKey:@"PLANTNAME"];
                                        }
                                        
                                        if ([headerDictionary objectForKey:@"Arbpl"]) {
                                            [currentHeaderDictionary setObject:[headerDictionary objectForKey:@"Arbpl"] forKey:@"WORKCENTERID"];
                                            [currentHeaderDictionary setObject:[headerDictionary objectForKey:@"Wkctrname"] forKey:@"WORKCENTERNAME"];
                                        }
                                        else{
                                            [currentHeaderDictionary setObject:@"" forKey:@"WORKCENTERID"];
                                            [currentHeaderDictionary setObject:@"" forKey:@"WORKCENTERNAME"];
                                        }
                                        
                                        if ([headerDictionary objectForKey:@"Xstatus"]) {
                                            [currentHeaderDictionary setObject:[headerDictionary objectForKey:@"Xstatus"] forKey:@"NSTATUS"];
                                        }
                                        else{
                                            
                                            [currentHeaderDictionary setObject:@"OSNO" forKey:@"NSTATUS"];
                                        }
                                        
                                        [currentHeaderDictionary setObject:@"" forKey:@"DOCS"];
                                        
                                        if ([headerDictionary objectForKey:@"Docs"]) {
                                            [currentHeaderDictionary setObject:[headerDictionary objectForKey:@"Docs"] forKey:@"DOCS"];
                                        }
                                        
                                        [currentHeaderDictionary setObject:@"" forKey:@"RSDATE"];
                                        
                                        if ([headerDictionary objectForKey:@"Strmn"]) {
                                            
                                            if ([headerDictionary objectForKey:@"Strur"]) {
                                                
                                                [currentHeaderDictionary setObject:[NSString stringWithFormat:@"%@ %@",[headerDictionary objectForKey:@"Strmn"],[headerDictionary objectForKey:@"Strur"]] forKey:@"RSDATE"];
                                            }
                                            else{
                                                
                                                [currentHeaderDictionary setObject:[headerDictionary objectForKey:@"Strmn"] forKey:@"RSDATE"];
                                            }
                                            
                                            
                                            //                                [currentHeaderDictionary setObject:[NSString stringWithFormat:@"%@ %@",[headerDictionary objectForKey:@"Strmn"],[headerDictionary objectForKey:@"Strur"]] forKey:@"RSDATE"];
                                        }
                                        
                                        [currentHeaderDictionary setObject:@"" forKey:@"REDATE"];
                                        
                                        if ([headerDictionary objectForKey:@"Ltrmn"]) {
                                            
                                            if ([headerDictionary objectForKey:@"Ltrur"]) {
                                                
                                                [currentHeaderDictionary setObject:[NSString stringWithFormat:@"%@ %@",[headerDictionary objectForKey:@"Ltrmn"],[headerDictionary objectForKey:@"Ltrur"]] forKey:@"REDATE"];
                                            }
                                            else{
                                                
                                                [currentHeaderDictionary setObject:[headerDictionary objectForKey:@"Ltrmn"] forKey:@"REDATE"];
                                                
                                            }
                                            //                                [currentHeaderDictionary setObject:[NSString stringWithFormat:@"%@ %@",[headerDictionary objectForKey:@"Ltrmn"],[headerDictionary objectForKey:@"Ltrur"]] forKey:@"REDATE"];
                                        }
                                        
                                        
                                        if ([headerDictionary objectForKey:@"ParnrVw"]) {
                                            [currentHeaderDictionary setObject:[headerDictionary objectForKey:@"ParnrVw"] forKey:@"PARNRID"];
                                        }
                                        else{
                                            
                                            [currentHeaderDictionary setObject:@"" forKey:@"PARNRID"];
                                        }
                                        
                                        if ([headerDictionary objectForKey:@"NameVw"]) {
                                            [currentHeaderDictionary setObject:[headerDictionary objectForKey:@"NameVw"] forKey:@"PARNRTEXT"];
                                        }
                                        else{
                                            
                                            [currentHeaderDictionary setObject:@"" forKey:@"PARNRTEXT"];
                                            
                                        }
                                        
                                        if ([headerDictionary objectForKey:@"Ingrp"]) {
                                            [currentHeaderDictionary setObject:[headerDictionary objectForKey:@"Ingrp"] forKey:@"PLANNERGROUP"];
                                        }
                                        else{
                                            
                                            [currentHeaderDictionary setObject:@"" forKey:@"PLANNERGROUP"];
                                            
                                        }
                                        
                                        if ([headerDictionary objectForKey:@"Ingrpname"]) {
                                            [currentHeaderDictionary setObject:[headerDictionary objectForKey:@"Ingrpname"] forKey:@"PLANNERGROUPNAME"];
                                        }
                                        else{
                                            
                                            [currentHeaderDictionary setObject:@"" forKey:@"PLANNERGROUPNAME"];
                                            
                                        }
                                        
                                        [currentHeaderDictionary setObject:@"" forKey:@"SHIFT"];
                                        if ([headerDictionary objectForKey:@"Shift"]) {
                                            [currentHeaderDictionary setObject:[headerDictionary objectForKey:@"Shift"] forKey:@"SHIFT"];
                                        }
                                        
                                        [currentHeaderDictionary setObject:@"" forKey:@"NOOFPERSON"];
                                        if ([headerDictionary objectForKey:@"Noofperson"]) {
                                            [currentHeaderDictionary setObject:[headerDictionary objectForKey:@"Noofperson"] forKey:@"NOOFPERSON"];
                                        }
                                        
                                        [currentHeaderDictionary setObject:@"" forKey:@"EFFECTID"];
                                        if ([headerDictionary objectForKey:@"Auswk"]) {
                                            [currentHeaderDictionary setObject:[headerDictionary objectForKey:@"Auswk"] forKey:@"EFFECTID"];
                                        }
                                        
                                        [currentHeaderDictionary setObject:@"" forKey:@"EFFECTNAME"];
                                        if ([headerDictionary objectForKey:@"Auswkt"]) {
                                            [currentHeaderDictionary setObject:[headerDictionary objectForKey:@"Auswkt"] forKey:@"EFFECTNAME"];
                                        }
                                        
                                        [currentHeaderDictionary setObject:@"" forKey:@"AUFNR"];
                                        if ([headerDictionary objectForKey:@"Aufnr"]) {
                                            [currentHeaderDictionary setObject:[headerDictionary objectForKey:@"Aufnr"] forKey:@"AUFNR"];
                                        }
                                        
                                        [currentHeaderDictionary setObject:@"" forKey:@"LONGTEXT"];
                                        [currentHeaderDictionary setObject:[[DataBase sharedInstance] fetchNameForIDKey:@"OBJECTID" forValue:[currentHeaderDictionary objectForKey:@"OBJECTID"]] forKey:@"ID"];
                                        if (![[currentHeaderDictionary objectForKey:@"ID"] length]) {
                                            
                                        }
                                        
                                        [currentHeaderDictionary setObject:@"" forKey:@"USR01"];
                                        if ([headerDictionary objectForKey:@"Usr01"]) {
                                            [currentHeaderDictionary setObject:[headerDictionary objectForKey:@"Usr01"] forKey:@"USR01"];
                                        }
                                        
                                        [currentHeaderDictionary setObject:@"" forKey:@"USR02"];
                                        if ([headerDictionary objectForKey:@"Usr02"]) {
                                            [currentHeaderDictionary setObject:[headerDictionary objectForKey:@"Usr02"] forKey:@"USR02"];
                                        }
                                        
                                        
                                        [currentHeaderDictionary setObject:@"" forKey:@"NOSYNCLOG"];
                                        [currentHeaderDictionary setObject:@"" forKey:@"LATITUDES"];
                                        [currentHeaderDictionary setObject:@"" forKey:@"LONGITUDES"];
                                        [currentHeaderDictionary setObject:@"" forKey:@"ALTITUDES"];
                                        
                                        if ([headerDictionary objectForKey:@"EquiHistory"]) {
                                            id equipmentHisory = [headerDictionary objectForKey:@"EquiHistory"];
                                            if ([equipmentHisory objectForKey:@"item"]) {
                                                equipmentHisory = [equipmentHisory objectForKey:@"item"];
                                                if ([equipmentHisory isKindOfClass:[NSDictionary class]]) {
                                                    [currentHeaderDictionary setObject:[NSMutableArray arrayWithObject:equipmentHisory] forKey:@"EQUIPMENTHISTORY"];
                                                }
                                                else if ([equipmentHisory isKindOfClass:[NSArray class]]){
                                                    [currentHeaderDictionary setObject:equipmentHisory forKey:@"EQUIPMENTHISTORY"];
                                                }
                                            }
                                        }
                                        
                                        if ([headerDictionary objectForKey:@"Fields"]) {
                                            NSMutableArray *fieldsMutArray = [NSMutableArray new];
                                            NSMutableArray *tempfieldsMutArray = [NSMutableArray new];
                                            
                                            if ([[[headerDictionary objectForKey:@"Fields"] objectForKey:@"item"] isKindOfClass:[NSDictionary class]]) {
                                                [tempfieldsMutArray addObjectsFromArray:[NSMutableArray arrayWithObject:[[headerDictionary objectForKey:@"Fields"] objectForKey:@"item"]]];
                                            }
                                            else if ([[[headerDictionary objectForKey:@"Fields"] objectForKey:@"item"] isKindOfClass:[NSArray class]]) {
                                                [tempfieldsMutArray addObjectsFromArray:[[headerDictionary objectForKey:@"Fields"] objectForKey:@"item"]];
                                            }
                                            
                                            //                                NSArray *fieldsArray = [[headerDictionary objectForKey:@"Fields"] objectForKey:@"item"];
                                            for (int i =0; i<[tempfieldsMutArray count]; i++) {
                                                NSString *fieldValue,*fieldName,*fLabel,*tabName,*dataType,*sequence,*length;
                                                if ([NullChecker isNull:[[tempfieldsMutArray objectAtIndex:i] objectForKey:@"Fieldname"]]) {
                                                    fieldName = @"";
                                                }
                                                else{
                                                    fieldName = [[tempfieldsMutArray objectAtIndex:i] objectForKey:@"Fieldname"];
                                                }
                                                
                                                if ([NullChecker isNull:[[tempfieldsMutArray objectAtIndex:i] objectForKey:@"Flabel"]]) {
                                                    fLabel = @"";
                                                }
                                                else{
                                                    fLabel = [[tempfieldsMutArray objectAtIndex:i] objectForKey:@"Flabel"];
                                                }
                                                
                                                if ([NullChecker isNull:[[tempfieldsMutArray objectAtIndex:i] objectForKey:@"Tabname"]]) {
                                                    tabName = @"";
                                                }
                                                else{
                                                    tabName = [[tempfieldsMutArray objectAtIndex:i] objectForKey:@"Tabname"];
                                                }
                                                
                                                if ([NullChecker isNull:[[tempfieldsMutArray objectAtIndex:i] objectForKey:@"Value"]]) {
                                                    fieldValue = @"";
                                                }
                                                else{
                                                    fieldValue = [[tempfieldsMutArray objectAtIndex:i] objectForKey:@"Value"];
                                                }
                                                
                                                if ([NullChecker isNull:[[tempfieldsMutArray objectAtIndex:i] objectForKey:@"Datatype"]]) {
                                                    dataType = @"";
                                                }
                                                else{
                                                    dataType = [[tempfieldsMutArray objectAtIndex:i] objectForKey:@"Datatype"];
                                                }
                                                
                                                if ([NullChecker isNull:[[tempfieldsMutArray objectAtIndex:i] objectForKey:@"Sequence"]]) {
                                                    sequence = @"";
                                                }
                                                else{
                                                    sequence = [[tempfieldsMutArray objectAtIndex:i] objectForKey:@"Sequence"];
                                                }
                                                
                                                if ([NullChecker isNull:[[tempfieldsMutArray objectAtIndex:i] objectForKey:@"Length"]]) {
                                                    length = @"";
                                                }
                                                else{
                                                    length = [[tempfieldsMutArray objectAtIndex:i] objectForKey:@"Length"];
                                                }
                                                
                                                
                                                [fieldsMutArray addObject:[NSMutableArray arrayWithObjects:@"W",@"WH",tabName,fieldName,fieldValue,fLabel,dataType,sequence,length, nil]];
                                            }
                                            
                                            [currentHeaderDictionary setObject:fieldsMutArray forKey:@"CFH"];
                                        }
                                        
                                        [notificationDetailDictionary setObject:[NSMutableArray arrayWithObjects:currentHeaderDictionary,[NSMutableArray array],[NSMutableArray array],[NSMutableArray array],[NSMutableArray array],[NSMutableArray array], nil] forKey:[currentHeaderDictionary objectForKey:@"OBJECTID"]];
                                    }
                                }
                                
                                [notificatinHeaderArray removeAllObjects];
                                
                                //    resultInspection
                                // resultActivities
                                
                                responseObject = nil;
                                
                                responseObject = [parsedDictionary objectForKey:@"resultInspection"];
                                
                                
                                for (int i = 0; i<[responseObject  count]; i++) {
                                    NSDictionary *inspectionresultDictionary;
                                    
                                    NSMutableArray *resultInpectionsDataArray = [NSMutableArray new];
                                    
                                    inspectionresultDictionary = [responseObject  objectAtIndex:i];
                                    if ([NullChecker isNull:[inspectionresultDictionary objectForKey:@"Qmnum"]]) {
                                        [resultInpectionsDataArray addObject:@""];
                                    }
                                    else{
                                        [resultInpectionsDataArray addObject:[inspectionresultDictionary objectForKey:@"Qmnum"]];
                                    }
                                    
                                    if ([NullChecker isNull:[inspectionresultDictionary objectForKey:@"Aufnr"]]) {
                                        [resultInpectionsDataArray addObject:@""];
                                    }
                                    else{
                                        
                                        [resultInpectionsDataArray addObject:[inspectionresultDictionary objectForKey:@"Aufnr"]];
                                    }
                                    
                                    if ([NullChecker isNull:[inspectionresultDictionary objectForKey:@"Vornr"]]) {
                                        [resultInpectionsDataArray addObject:@""];
                                    }
                                    else{
                                        [resultInpectionsDataArray addObject:[inspectionresultDictionary objectForKey:@"Vornr"]];
                                    }
                                    
                                    if ([NullChecker isNull:[inspectionresultDictionary objectForKey:@"Equnr"]]) {
                                        [resultInpectionsDataArray addObject:@""];
                                    }
                                    else{
                                        [resultInpectionsDataArray addObject:[inspectionresultDictionary objectForKey:@"Equnr"]];
                                    }
                                    
                                    if ([NullChecker isNull:[inspectionresultDictionary objectForKey:@"Mdocm"]]) {
                                        [resultInpectionsDataArray addObject:@""];
                                    }
                                    else{
                                        [resultInpectionsDataArray addObject:[inspectionresultDictionary objectForKey:@"Mdocm"]];
                                    }
                                    
                                    if ([NullChecker isNull:[inspectionresultDictionary objectForKey:@"Point"]]) {
                                        [resultInpectionsDataArray addObject:@""];
                                    }
                                    else{
                                        [resultInpectionsDataArray addObject:[inspectionresultDictionary objectForKey:@"Point"]];
                                    }
                                    
                                    if ([NullChecker isNull:[inspectionresultDictionary objectForKey:@"Mpobj"]]) {
                                        [resultInpectionsDataArray addObject:@""];
                                    }
                                    else{
                                        [resultInpectionsDataArray addObject:[inspectionresultDictionary objectForKey:@"Mpobj"]];
                                    }
                                    
                                    if ([NullChecker isNull:[inspectionresultDictionary objectForKey:@"Mpobt"]]) {
                                        [resultInpectionsDataArray addObject:@""];
                                    }
                                    else{
                                        [resultInpectionsDataArray addObject:[inspectionresultDictionary objectForKey:@"Mpobt"]];
                                    }
                                    
                                    if ([NullChecker isNull:[inspectionresultDictionary objectForKey:@"Psort"]]) {
                                        [resultInpectionsDataArray addObject:@""];
                                    }
                                    else{
                                        [resultInpectionsDataArray addObject:[inspectionresultDictionary objectForKey:@"Psort"]];
                                    }
                                    
                                    if ([NullChecker isNull:[inspectionresultDictionary objectForKey:@"Pttxt"]]) {
                                        [resultInpectionsDataArray addObject:@""];
                                    }
                                    else{
                                        [resultInpectionsDataArray addObject:[inspectionresultDictionary objectForKey:@"Pttxt"]];
                                    }
                                    
                                    if ([NullChecker isNull:[inspectionresultDictionary objectForKey:@"Atinn"]]) {
                                        [resultInpectionsDataArray addObject:@""];
                                    }
                                    else{
                                        [resultInpectionsDataArray addObject:[inspectionresultDictionary objectForKey:@"Atinn"]];
                                    }
                                    
                                    if ([NullChecker isNull:[inspectionresultDictionary objectForKey:@"Idate"]]) {
                                        [resultInpectionsDataArray addObject:@""];
                                    }
                                    else{
                                        [resultInpectionsDataArray addObject:[inspectionresultDictionary objectForKey:@"Idate"]];
                                    }
                                    
                                    if ([NullChecker isNull:[inspectionresultDictionary objectForKey:@"Itime"]]) {
                                        [resultInpectionsDataArray addObject:@""];
                                    }
                                    else{
                                        [resultInpectionsDataArray addObject:[inspectionresultDictionary objectForKey:@"Itime"]];
                                    }
                                    
                                    if ([NullChecker isNull:[inspectionresultDictionary objectForKey:@"Mdtxt"]]) {
                                        [resultInpectionsDataArray addObject:@""];
                                    }
                                    else{
                                        [resultInpectionsDataArray addObject:[inspectionresultDictionary objectForKey:@"Mdtxt"]];
                                    }
                                    
                                    if ([NullChecker isNull:[inspectionresultDictionary objectForKey:@"Readr"]]) {
                                        [resultInpectionsDataArray addObject:@""];
                                    }
                                    else{
                                        [resultInpectionsDataArray addObject:[inspectionresultDictionary objectForKey:@"Readr"]];
                                    }
                                    
                                    
                                    if ([NullChecker isNull:[inspectionresultDictionary objectForKey:@"Atbez"]]) {
                                        [resultInpectionsDataArray addObject:@""];
                                    }
                                    else{
                                        [resultInpectionsDataArray addObject:[inspectionresultDictionary objectForKey:@"Atbez"]];
                                    }
                                    
                                    if ([NullChecker isNull:[inspectionresultDictionary objectForKey:@"Msehi"]]) {
                                        [resultInpectionsDataArray addObject:@""];
                                    }
                                    else{
                                        [resultInpectionsDataArray addObject:[inspectionresultDictionary objectForKey:@"Msehi"]];
                                    }
                                    
                                    
                                    if ([NullChecker isNull:[inspectionresultDictionary objectForKey:@"Msehl"]]) {
                                        [resultInpectionsDataArray addObject:@""];
                                    }
                                    else{
                                        [resultInpectionsDataArray addObject:[inspectionresultDictionary objectForKey:@"Msehl"]];
                                    }
                                    
                                    
                                    if ([NullChecker isNull:[inspectionresultDictionary objectForKey:@"Readc"]]) {
                                        [resultInpectionsDataArray addObject:@""];
                                    }
                                    else{
                                        [resultInpectionsDataArray addObject:[inspectionresultDictionary objectForKey:@"Readc"]];
                                    }
                                    
                                    if ([NullChecker isNull:[inspectionresultDictionary objectForKey:@"Desic"]]) {
                                        [resultInpectionsDataArray addObject:@""];
                                    }
                                    else{
                                        [resultInpectionsDataArray addObject:[inspectionresultDictionary objectForKey:@"Desic"]];
                                    }
                                    
                                    if ([NullChecker isNull:[inspectionresultDictionary objectForKey:@"Prest"]]) {
                                        [resultInpectionsDataArray addObject:@""];
                                    }
                                    else{
                                        [resultInpectionsDataArray addObject:[inspectionresultDictionary objectForKey:@"Prest"]];
                                    }
                                    
                                    
                                    if ([NullChecker isNull:[inspectionresultDictionary objectForKey:@"Docaf"]]) {
                                        [resultInpectionsDataArray addObject:@""];
                                    }
                                    else{
                                        [resultInpectionsDataArray addObject:[inspectionresultDictionary objectForKey:@"Docaf"]];
                                    }
                                    
                                    if ([NullChecker isNull:[inspectionresultDictionary objectForKey:@"Codct"]]) {
                                        [resultInpectionsDataArray addObject:@""];
                                    }
                                    else{
                                        [resultInpectionsDataArray addObject:[inspectionresultDictionary objectForKey:@"Codct"]];
                                    }
                                    
                                    if ([NullChecker isNull:[inspectionresultDictionary objectForKey:@"Codgr"]]) {
                                        [resultInpectionsDataArray addObject:@""];
                                    }
                                    else{
                                        [resultInpectionsDataArray addObject:[inspectionresultDictionary objectForKey:@"Codgr"]];
                                    }
                                    
                                    if ([NullChecker isNull:[inspectionresultDictionary objectForKey:@"Vlcod"]]) {
                                        [resultInpectionsDataArray addObject:@""];
                                    }
                                    else{
                                        [resultInpectionsDataArray addObject:[inspectionresultDictionary objectForKey:@"Vlcod"]];
                                    }
                                    
                                    if ([NullChecker isNull:[inspectionresultDictionary objectForKey:@"Action"]]) {
                                        [resultInpectionsDataArray addObject:@""];
                                    }
                                    else{
                                        [resultInpectionsDataArray addObject:[inspectionresultDictionary objectForKey:@"Action"]];
                                    }
                                    
                                    [inspectionResultDataArray addObject:resultInpectionsDataArray];
                                }
                                
                                
                                responseObject = nil;
                                NSMutableArray *notificationDocs = [[NSMutableArray alloc] init];
                                
                                if ([parsedDictionary objectForKey:@"resultDocs"]) {
                                    responseObject = [parsedDictionary objectForKey:@"resultDocs"];
                                    [notificationDocs addObjectsFromArray:responseObject];
                                    
                                    NSDictionary *DocsDictionary;
                                    for (int i =0; i<[notificationDocs count]; i++) {
                                        if ([[notificationDocs objectAtIndex:i] isKindOfClass:[NSDictionary class]]) {
                                            DocsDictionary = [notificationDocs objectAtIndex:i];
                                            if ([notificationDetailDictionary objectForKey:[NSString stringWithFormat:@"%lld",[[DocsDictionary objectForKey:@"Zobjid"] longLongValue]]]) {
                                                NSMutableArray *Docs = [NSMutableArray array];
                                                [Docs addObject:@""];
                                                if ([DocsDictionary objectForKey:@"DocId"]) {
                                                    [Docs addObject:[[DocsDictionary objectForKey:@"DocId"] copy]];
                                                }
                                                else{
                                                    [Docs addObject:@""];
                                                }
                                                
                                                if ([DocsDictionary objectForKey:@"DocType"]) {
                                                    [Docs addObject:[[DocsDictionary objectForKey:@"DocType"] copy]];
                                                }
                                                else{
                                                    [Docs addObject:@""];
                                                }
                                                
                                                if ([DocsDictionary objectForKey:@"Filename"]) {
                                                    [Docs addObject:[[DocsDictionary objectForKey:@"Filename"] copy]];
                                                }
                                                else{
                                                    [Docs addObject:@""];
                                                }
                                                
                                                if ([DocsDictionary objectForKey:@"Filetype"]) {
                                                    [Docs addObject:[[DocsDictionary objectForKey:@"Filetype"] copy]];
                                                }
                                                else{
                                                    [Docs addObject:@""];
                                                }
                                                
                                                if ([DocsDictionary objectForKey:@"Fsize"]) {
                                                    [Docs addObject:[[DocsDictionary objectForKey:@"Fsize"] copy]];
                                                }
                                                else{
                                                    [Docs addObject:@""];
                                                }
                                                
                                                if ([DocsDictionary objectForKey:@"Objtype"]) {
                                                    [Docs addObject:[[DocsDictionary objectForKey:@"Objtype"] copy]];
                                                }
                                                else{
                                                    
                                                    [Docs addObject:@""];
                                                }
                                                
                                                [Docs addObject:@""];//Content
                                                [Docs addObject:@""];//Action
                                                
                                                [[[notificationDetailDictionary objectForKey:[DocsDictionary objectForKey:@"Zobjid"]] objectAtIndex:1] addObject:Docs];
                                            }
                                        }
                                    }
                                }
                                
                                responseObject = nil;
                                NSMutableArray *notificationTransactionArray = [[NSMutableArray alloc] init];
                                
                                if ([parsedDictionary objectForKey:@"resultTransactions"]) {
                                    responseObject = [parsedDictionary objectForKey:@"resultTransactions"];
                                    
                                    [notificationTransactionArray addObjectsFromArray:responseObject];
                                    
                                    NSDictionary *transactionDictionary;
                                    
                                    for (int i=0; i<[notificationTransactionArray count]; i++) {
                                        if ([[notificationTransactionArray objectAtIndex:i] isKindOfClass:[NSDictionary class]]) {
                                            transactionDictionary = [notificationTransactionArray objectAtIndex:i];
                                            if ([notificationDetailDictionary objectForKey:[transactionDictionary objectForKey:@"Qmnum"]]) {
                                                NSMutableArray *transactions = [NSMutableArray array];
                                                
                                                [transactions addObject:@""];
                                                [transactions addObject:@""];
                                                if ([transactionDictionary objectForKey:@"ItemdefectGrp"]) {
                                                    [transactions addObject:[[transactionDictionary objectForKey:@"ItemdefectGrp"] copy]];
                                                }
                                                else{
                                                    [transactions addObject:@""];
                                                }
                                                
                                                if ([transactionDictionary objectForKey:@"Defectgrptext"]) {
                                                    [transactions addObject:[[transactionDictionary objectForKey:@"Defectgrptext"] copy]];
                                                }
                                                else{
                                                    [transactions addObject:@""];
                                                }
                                                
                                                if ([transactionDictionary objectForKey:@"ItemdefectCod"]) {
                                                    [transactions addObject:[[transactionDictionary objectForKey:@"ItemdefectCod"] copy]];
                                                }
                                                else{
                                                    [transactions addObject:@""];
                                                }
                                                
                                                if ([transactionDictionary objectForKey:@"Defectcodetext"]) {
                                                    [transactions addObject:[[transactionDictionary objectForKey:@"Defectcodetext"] copy]];
                                                }
                                                else{
                                                    [transactions addObject:@""];
                                                    
                                                }
                                                
                                                if ([transactionDictionary objectForKey:@"CauseGrp"]) {
                                                    [transactions addObject:[[transactionDictionary objectForKey:@"CauseGrp"] copy]];
                                                }
                                                else{
                                                    [transactions addObject:@""];
                                                }
                                                
                                                if ([transactionDictionary objectForKey:@"Causegrptext"]) {
                                                    [transactions addObject:[[transactionDictionary objectForKey:@"Causegrptext"] copy]];
                                                }
                                                else{
                                                    [transactions addObject:@""];
                                                }
                                                
                                                if ([transactionDictionary objectForKey:@"CauseCod"]) {
                                                    [transactions addObject:[[transactionDictionary objectForKey:@"CauseCod"] copy]];
                                                }
                                                else{
                                                    [transactions addObject:@""];
                                                }
                                                
                                                if ([transactionDictionary objectForKey:@"Causecodetext"]) {
                                                    [transactions addObject:[[transactionDictionary objectForKey:@"Causecodetext"] copy]];
                                                }
                                                else{
                                                    [transactions addObject:@""];
                                                }
                                                
                                                if ([transactionDictionary objectForKey:@"ItemdefectShtxt"]) {
                                                    [transactions addObject:[[transactionDictionary objectForKey:@"ItemdefectShtxt"] copy]];
                                                }
                                                else{
                                                    [transactions addObject:@""];
                                                }
                                                if ([transactionDictionary objectForKey:@"CauseShtxt"]) {
                                                    [transactions addObject:[[transactionDictionary objectForKey:@"CauseShtxt"] copy]];
                                                }
                                                else{
                                                    [transactions addObject:@""];
                                                }
                                                
                                                if ([transactionDictionary objectForKey:@"ItemKey"]) {
                                                    [transactions addObject:[[transactionDictionary objectForKey:@"ItemKey"] copy]];
                                                }
                                                else{
                                                    [transactions addObject:@""];
                                                }
                                                
                                                if ([transactionDictionary objectForKey:@"CauseKey"]) {
                                                    [transactions addObject:[[transactionDictionary objectForKey:@"CauseKey"] copy]];
                                                }
                                                else{
                                                    [transactions addObject:@""];
                                                }
                                                
                                                [transactions addObject:@""];//Component Status
                                                [transactions addObject:@""];//Item Status
                                                
                                                if ([transactionDictionary objectForKey:@"ItempartGrp"]) {
                                                    [transactions addObject:[transactionDictionary objectForKey:@"ItempartGrp"]];
                                                }
                                                else{
                                                    
                                                    [transactions addObject:@""];//objectPartGroupid
                                                }
                                                
                                                if ([transactionDictionary objectForKey:@"ItempartCod"]) {
                                                    [transactions addObject:[transactionDictionary objectForKey:@"ItempartCod"]];
                                                }
                                                else{
                                                    
                                                    [transactions addObject:@""];//ObjectPartid
                                                }
                                                
                                                if ([transactionDictionary objectForKey:@"Partgrptext"]) {
                                                    [transactions addObject:[transactionDictionary objectForKey:@"Partgrptext"]];
                                                }
                                                else{
                                                    
                                                    [transactions addObject:@""];//objectPartGrouptext
                                                }
                                                
                                                if ([transactionDictionary objectForKey:@"Partcodetext"])
                                                {
                                                    [transactions addObject:[transactionDictionary objectForKey:@"Partcodetext"]];
                                                }
                                                else{
                                                    
                                                    [transactions addObject:@""];//ObjectParttext
                                                }
                                                
                                                id customFieldsDamageTransactionsID,customFieldsCauseTransactionsID;
                                                if ([transactionDictionary objectForKey:@"Fields"]) {
                                                    NSArray *fieldsArray = [[transactionDictionary objectForKey:@"Fields"] objectForKey:@"item"];
                                                    NSMutableArray *transactionsDamageCustomFields = [NSMutableArray array];
                                                    NSMutableArray *transactionsCauseCustomFields = [NSMutableArray array];
                                                    for (int i =0; i<[fieldsArray count]; i++) {
                                                        NSString *fieldValue,*fieldName,*fLabel,*tabName,*docType,*docTypeItem,*dataType,*sequence,*length;
                                                        if ([NullChecker isNull:[[fieldsArray objectAtIndex:i] objectForKey:@"Fieldname"]]) {
                                                            fieldName = @"";
                                                        }
                                                        else{
                                                            fieldName = [[fieldsArray objectAtIndex:i] objectForKey:@"Fieldname"];
                                                        }
                                                        
                                                        if ([NullChecker isNull:[[fieldsArray objectAtIndex:i] objectForKey:@"Flabel"]]) {
                                                            fLabel = @"";
                                                        }
                                                        else{
                                                            fLabel = [[fieldsArray objectAtIndex:i] objectForKey:@"Flabel"];
                                                        }
                                                        
                                                        if ([NullChecker isNull:[[fieldsArray objectAtIndex:i] objectForKey:@"Tabname"]]) {
                                                            tabName = @"";
                                                        }
                                                        else{
                                                            tabName = [[fieldsArray objectAtIndex:i] objectForKey:@"Tabname"];
                                                        }
                                                        
                                                        if ([NullChecker isNull:[[fieldsArray objectAtIndex:i] objectForKey:@"Value"]]) {
                                                            fieldValue = @"";
                                                        }
                                                        else{
                                                            fieldValue = [[fieldsArray objectAtIndex:i] objectForKey:@"Value"];
                                                        }
                                                        
                                                        if ([NullChecker isNull:[[fieldsArray objectAtIndex:i] objectForKey:@"Zdoctype"]]) {
                                                            docType = @"";
                                                        }
                                                        else{
                                                            docType = [[fieldsArray objectAtIndex:i] objectForKey:@"Zdoctype"];
                                                        }
                                                        
                                                        if ([NullChecker isNull:[[fieldsArray objectAtIndex:i] objectForKey:@"ZdoctypeItem"]]) {
                                                            docTypeItem = @"";
                                                        }
                                                        else{
                                                            docTypeItem = [[fieldsArray objectAtIndex:i] objectForKey:@"ZdoctypeItem"];
                                                        }
                                                        
                                                        
                                                        if ([NullChecker isNull:[[fieldsArray objectAtIndex:i] objectForKey:@"Datatype"]]) {
                                                            dataType = @"";
                                                        }
                                                        else{
                                                            dataType = [[fieldsArray objectAtIndex:i] objectForKey:@"Datatype"];
                                                        }
                                                        
                                                        if ([NullChecker isNull:[[fieldsArray objectAtIndex:i] objectForKey:@"Sequence"]]) {
                                                            sequence = @"";
                                                        }
                                                        else{
                                                            sequence = [[fieldsArray objectAtIndex:i] objectForKey:@"Sequence"];
                                                        }
                                                        
                                                        if ([NullChecker isNull:[[fieldsArray objectAtIndex:i] objectForKey:@"Length"]]) {
                                                            length = @"";
                                                        }
                                                        else{
                                                            length = [[fieldsArray objectAtIndex:i] objectForKey:@"Length"];
                                                        }
                                                        
                                                        if ([docTypeItem isEqualToString:@"QI"]) {
                                                            [transactionsDamageCustomFields addObject:[NSMutableArray arrayWithObjects:docType,docTypeItem,tabName,fieldName,fieldValue,fLabel,dataType,sequence,length, nil]];
                                                        }
                                                        else if ([docTypeItem isEqualToString:@"QC"]){
                                                            [transactionsCauseCustomFields addObject:[NSMutableArray arrayWithObjects:docType,docTypeItem,tabName,fieldName,fieldValue,fLabel,dataType,sequence,length, nil]];
                                                        }
                                                    }
                                                    
                                                    customFieldsDamageTransactionsID = transactionsDamageCustomFields;
                                                    customFieldsCauseTransactionsID = transactionsCauseCustomFields;
                                                }
                                                
                                                [[[notificationDetailDictionary objectForKey:[transactionDictionary objectForKey:@"Qmnum"]] objectAtIndex:2] addObject:[NSArray arrayWithObjects:transactions,customFieldsDamageTransactionsID,customFieldsCauseTransactionsID, nil]];
                                            }
                                        }
                                    }
                                    
                                    [notificationTransactionArray removeAllObjects];
                                }
                                
                                
                                responseObject = nil;
                                NSMutableArray *notificationActivitiesArray = [[NSMutableArray alloc] init];
                                
                                if ([parsedDictionary objectForKey:@"resultActivities"]) {
                                    responseObject = [parsedDictionary objectForKey:@"resultActivities"];
                                    
                                    [notificationActivitiesArray addObjectsFromArray:responseObject];
                                    
                                    NSDictionary *activitiesDictionary;
                                    
                                    for (int i=0; i<[notificationActivitiesArray count]; i++) {
                                        
                                        if ([[notificationActivitiesArray objectAtIndex:i] isKindOfClass:[NSDictionary class]]) {
                                            
                                            activitiesDictionary = [notificationActivitiesArray objectAtIndex:i];
                                            
                                            if ([notificationDetailDictionary objectForKey:[NSString stringWithFormat:@"%lli",[[activitiesDictionary objectForKey:@"Qmnum"] longLongValue]]]) {
                                                
                                                NSMutableDictionary *resulActivityDictionary=[NSMutableDictionary new];
                                                
                                                [resulActivityDictionary setObject:@"" forKey:@"notificationa_id"];
                                                
                                                [resulActivityDictionary setObject:@"" forKey:@"notificationa_header_id"];
                                                
                                                
                                                if ([activitiesDictionary objectForKey:@"Actcodetext"]) {
                                                    
                                                    [resulActivityDictionary setObject:[[activitiesDictionary objectForKey:@"Actcodetext"] copy] forKey:@"notificationa_Actcodetext"];
                                                    
                                                }
                                                else{
                                                    
                                                    [resulActivityDictionary setObject:@"" forKey:@"notificationa_Actgrptext"];
                                                    
                                                }
                                                
                                                if ([activitiesDictionary objectForKey:@"Actgrptext"]) {
                                                    
                                                    [resulActivityDictionary setObject:[[activitiesDictionary objectForKey:@"Actgrptext"] copy] forKey:@"notificationa_Actgrptext"];
                                                    
                                                }
                                                else{
                                                    
                                                    [resulActivityDictionary setObject:@"" forKey:@"notificationa_Actgrptext"];
                                                    
                                                }
                                                
                                                if ([activitiesDictionary objectForKey:@"Action"]) {
                                                    
                                                    [resulActivityDictionary setObject:[activitiesDictionary objectForKey:@"Action"] forKey:@"notificationa_Action"];
                                                    
                                                }
                                                else{
                                                    
                                                    [resulActivityDictionary setObject:@"" forKey:@"notificationa_Action"];
                                                    
                                                }
                                                
                                                if ([activitiesDictionary objectForKey:@"ActvCod"]) {
                                                    
                                                    [resulActivityDictionary setObject:[activitiesDictionary objectForKey:@"ActvCod"] forKey:@"notificationa_ActvCod"];
                                                    
                                                    
                                                }
                                                else{
                                                    
                                                    [resulActivityDictionary setObject:@"" forKey:@"notificationa_ActvCod"];
                                                    
                                                }
                                                
                                                if ([activitiesDictionary objectForKey:@"ActvGrp"]) {
                                                    
                                                    [resulActivityDictionary setObject:[[activitiesDictionary objectForKey:@"ActvGrp"] copy] forKey:@"notificationa_ActvGrp"];
                                                    
                                                }
                                                else{
                                                    
                                                    [resulActivityDictionary setObject:@"" forKey:@"notificationa_ActvGrp"];
                                                }
                                                
                                                if ([activitiesDictionary objectForKey:@"ActvKey"]) {
                                                    
                                                    [resulActivityDictionary setObject:[[activitiesDictionary objectForKey:@"ActvKey"] copy] forKey:@"notificationa_ActvKey"];
                                                    
                                                }
                                                else{
                                                    
                                                    [resulActivityDictionary setObject:@"" forKey:@"notificationa_ActvKey"];
                                                    
                                                }
                                                
                                                if ([activitiesDictionary objectForKey:@"ActvShtxt"]) {
                                                    
                                                    [resulActivityDictionary setObject:[[activitiesDictionary objectForKey:@"ActvShtxt"] copy] forKey:@"notificationa_ActvShtxt"];
                                                    
                                                }
                                                else{
                                                    
                                                    [resulActivityDictionary setObject:@"" forKey:@"notificationa_ActvShtxt"];
                                                }
                                                
                                                if ([activitiesDictionary objectForKey:@"CauseKey"]) {
                                                    [resulActivityDictionary setObject:[[activitiesDictionary objectForKey:@"CauseKey"] copy] forKey:@"notificationa_CauseKey"];
                                                }
                                                else{
                                                    [resulActivityDictionary setObject:@"" forKey:@"notificationa_CauseKey"];
                                                }
                                                
                                                if ([activitiesDictionary objectForKey:@"Defectcodetext"]) {
                                                    
                                                    [resulActivityDictionary setObject:[[activitiesDictionary objectForKey:@"Defectcodetext"] copy] forKey:@"notificationa_Defectcodetext"];
                                                    
                                                }
                                                else{
                                                    [resulActivityDictionary setObject:@"" forKey:@"notificationa_Defectcodetext"];
                                                }
                                                
                                                if ([activitiesDictionary objectForKey:@"Defectgrptext"]) {
                                                    
                                                    [resulActivityDictionary setObject:[[activitiesDictionary objectForKey:@"Defectgrptext"] copy] forKey:@"notificationa_Defectgrptext"];
                                                }
                                                else{
                                                    
                                                    [resulActivityDictionary setObject:@"" forKey:@"notificationa_Defectgrptext"];
                                                    
                                                }
                                                
                                                if ([activitiesDictionary objectForKey:@"ItemKey"]) {
                                                    
                                                    [resulActivityDictionary setObject:[[activitiesDictionary objectForKey:@"ItemKey"] copy] forKey:@"notificationa_ItemKey"];
                                                    
                                                }
                                                else{
                                                    
                                                    [resulActivityDictionary setObject:[[activitiesDictionary objectForKey:@"ItemKey"] copy] forKey:@"notificationa_ItemdefectCod"];
                                                    
                                                }
                                                
                                                if ([activitiesDictionary objectForKey:@"ItemdefectCod"]) {
                                                    
                                                    [resulActivityDictionary setObject:[[activitiesDictionary objectForKey:@"ItemdefectCod"] copy] forKey:@"notificationa_ItemdefectCod"];
                                                }
                                                else{
                                                    [resulActivityDictionary setObject:@"" forKey:@"notificationa_ItemdefectCod"];
                                                }
                                                
                                                
                                                if ([activitiesDictionary objectForKey:@"ItemdefectGrp"]) {
                                                    [resulActivityDictionary setObject:[[activitiesDictionary objectForKey:@"ItemdefectGrp"] copy] forKey:@"notificationa_ItemdefectGrp"];
                                                }
                                                else{
                                                    
                                                    [resulActivityDictionary setObject:@"" forKey:@"notificationa_ItemdefectGrp"];
                                                    
                                                }
                                                
                                                if ([activitiesDictionary objectForKey:@"ItemdefectShtxt"]) {
                                                    
                                                    [resulActivityDictionary setObject:[[activitiesDictionary objectForKey:@"ItemdefectShtxt"] copy] forKey:@"notificationa_ItemdefectShtxt"];
                                                    
                                                }
                                                else{
                                                    
                                                    [resulActivityDictionary setObject:@"" forKey:@"notificationa_ItemdefectShtxt"];
                                                    
                                                }
                                                
                                                if ([activitiesDictionary objectForKey:@"ItempartCod"]) {
                                                    
                                                    [resulActivityDictionary setObject:[[activitiesDictionary objectForKey:@"ItempartCod"] copy] forKey:@"notificationa_ItempartCod"];
                                                    
                                                }
                                                else{
                                                    
                                                    [resulActivityDictionary setObject:@"" forKey:@"notificationa_ItempartCod"];
                                                    
                                                }
                                                
                                                if ([activitiesDictionary objectForKey:@"ItempartGrp"])
                                                {
                                                    
                                                    [resulActivityDictionary setObject:[[activitiesDictionary objectForKey:@"ItempartGrp"] copy] forKey:@"notificationa_ItempartGrp"];
                                                    
                                                }
                                                else{
                                                    
                                                    [resulActivityDictionary setObject:@"" forKey:@"notificationa_ItempartGrp"];
                                                    
                                                }
                                                
                                                if ([activitiesDictionary objectForKey:@"Partcodetext"])
                                                {
                                                    [resulActivityDictionary setObject:[[activitiesDictionary objectForKey:@"Partcodetext"] copy] forKey:@"notificationa_Partcodetext"];
                                                    
                                                }
                                                else{
                                                    
                                                    [resulActivityDictionary setObject:@"" forKey:@"notificationa_Partcodetext"];
                                                    
                                                }
                                                
                                                if ([activitiesDictionary objectForKey:@"Partgrptext"])
                                                {
                                                    
                                                    [resulActivityDictionary setObject:[[activitiesDictionary objectForKey:@"Partgrptext"] copy] forKey:@"notificationa_Partgrptext"];
                                                    
                                                }
                                                else{
                                                    
                                                    [resulActivityDictionary setObject:@"" forKey:@"notificationa_Partgrptext"];
                                                    
                                                }
                                                
                                                if ([activitiesDictionary objectForKey:@"Qmnum"])
                                                {
                                                    [resulActivityDictionary setObject:[[activitiesDictionary objectForKey:@"Qmnum"] copy] forKey:@"Qmnum"];
                                                    
                                                }
                                                else{
                                                    
                                                    [resulActivityDictionary setObject:@"" forKey:@"Qmnum"];
                                                    
                                                }
                                                
                                                if ([activitiesDictionary objectForKey:@"Usr01"])
                                                {
                                                    [resulActivityDictionary setObject:[[activitiesDictionary objectForKey:@"Usr01"] copy] forKey:@"Qmnum"];
                                                }
                                                else{
                                                    
                                                    [resulActivityDictionary setObject:@"" forKey:@"Usr01"];
                                                    
                                                }
                                                
                                                if ([activitiesDictionary objectForKey:@"Usr02"])
                                                {
                                                    
                                                    [resulActivityDictionary setObject:[[activitiesDictionary objectForKey:@"Usr02"] copy] forKey:@"Usr02"];
                                                    
                                                }
                                                else{
                                                    
                                                    [resulActivityDictionary setObject:@"" forKey:@"Usr02"];
                                                    
                                                }
                                                
                                                if ([activitiesDictionary objectForKey:@"Usr03"])
                                                {
                                                    
                                                    [resulActivityDictionary setObject:[[activitiesDictionary objectForKey:@"Usr03"] copy] forKey:@"Usr03"];
                                                    
                                                }
                                                else{
                                                    
                                                    [resulActivityDictionary setObject:@"" forKey:@"Usr03"];
                                                    
                                                }
                                                
                                                if ([activitiesDictionary objectForKey:@"Usr04"])
                                                {
                                                    
                                                    [resulActivityDictionary setObject:[[activitiesDictionary objectForKey:@"Usr04"] copy] forKey:@"Usr04"];
                                                    
                                                }
                                                else{
                                                    
                                                    [resulActivityDictionary setObject:@"" forKey:@"Usr04"];
                                                    
                                                }
                                                
                                                if ([activitiesDictionary objectForKey:@"Usr05"])
                                                {
                                                    [resulActivityDictionary setObject:[[activitiesDictionary objectForKey:@"Usr05"] copy] forKey:@"Usr05"];
                                                }
                                                else{
                                                    
                                                    [resulActivityDictionary setObject:@"" forKey:@"Usr05"];
                                                    
                                                }
                                                
                                                id customFieldsDamageTransactionsID,customFieldsCauseTransactionsID;
                                                
                                                if ([activitiesDictionary objectForKey:@"Fields"]) {
                                                    NSArray *fieldsArray = [[activitiesDictionary objectForKey:@"Fields"] objectForKey:@"item"];
                                                    NSMutableArray *transactionsDamageCustomFields = [NSMutableArray array];
                                                    NSMutableArray *transactionsCauseCustomFields = [NSMutableArray array];
                                                    for (int i =0; i<[fieldsArray count]; i++) {
                                                        NSString *fieldValue,*fieldName,*fLabel,*tabName,*docType,*docTypeItem,*dataType,*sequence,*length;
                                                        if ([NullChecker isNull:[[fieldsArray objectAtIndex:i] objectForKey:@"Fieldname"]]) {
                                                            fieldName = @"";
                                                        }
                                                        else{
                                                            fieldName = [[fieldsArray objectAtIndex:i] objectForKey:@"Fieldname"];
                                                        }
                                                        
                                                        if ([NullChecker isNull:[[fieldsArray objectAtIndex:i] objectForKey:@"Flabel"]]) {
                                                            fLabel = @"";
                                                        }
                                                        else{
                                                            fLabel = [[fieldsArray objectAtIndex:i] objectForKey:@"Flabel"];
                                                        }
                                                        
                                                        if ([NullChecker isNull:[[fieldsArray objectAtIndex:i] objectForKey:@"Tabname"]]) {
                                                            tabName = @"";
                                                        }
                                                        else{
                                                            tabName = [[fieldsArray objectAtIndex:i] objectForKey:@"Tabname"];
                                                        }
                                                        
                                                        if ([NullChecker isNull:[[fieldsArray objectAtIndex:i] objectForKey:@"Value"]]) {
                                                            fieldValue = @"";
                                                        }
                                                        else{
                                                            fieldValue = [[fieldsArray objectAtIndex:i] objectForKey:@"Value"];
                                                        }
                                                        
                                                        if ([NullChecker isNull:[[fieldsArray objectAtIndex:i] objectForKey:@"Zdoctype"]]) {
                                                            docType = @"";
                                                        }
                                                        else{
                                                            docType = [[fieldsArray objectAtIndex:i] objectForKey:@"Zdoctype"];
                                                        }
                                                        
                                                        if ([NullChecker isNull:[[fieldsArray objectAtIndex:i] objectForKey:@"ZdoctypeItem"]]) {
                                                            docTypeItem = @"";
                                                        }
                                                        else{
                                                            docTypeItem = [[fieldsArray objectAtIndex:i] objectForKey:@"ZdoctypeItem"];
                                                        }
                                                        
                                                        
                                                        if ([NullChecker isNull:[[fieldsArray objectAtIndex:i] objectForKey:@"Datatype"]]) {
                                                            dataType = @"";
                                                        }
                                                        else{
                                                            dataType = [[fieldsArray objectAtIndex:i] objectForKey:@"Datatype"];
                                                        }
                                                        
                                                        if ([NullChecker isNull:[[fieldsArray objectAtIndex:i] objectForKey:@"Sequence"]]) {
                                                            sequence = @"";
                                                        }
                                                        else{
                                                            sequence = [[fieldsArray objectAtIndex:i] objectForKey:@"Sequence"];
                                                        }
                                                        
                                                        if ([NullChecker isNull:[[fieldsArray objectAtIndex:i] objectForKey:@"Length"]]) {
                                                            length = @"";
                                                        }
                                                        else{
                                                            length = [[fieldsArray objectAtIndex:i] objectForKey:@"Length"];
                                                        }
                                                        
                                                        if ([docTypeItem isEqualToString:@"QI"]) {
                                                            [transactionsDamageCustomFields addObject:[NSMutableArray arrayWithObjects:docType,docTypeItem,tabName,fieldName,fieldValue,fLabel,dataType,sequence,length, nil]];
                                                        }
                                                        else if ([docTypeItem isEqualToString:@"QC"]){
                                                            [transactionsCauseCustomFields addObject:[NSMutableArray arrayWithObjects:docType,docTypeItem,tabName,fieldName,fieldValue,fLabel,dataType,sequence,length, nil]];
                                                        }
                                                    }
                                                    
                                                    customFieldsDamageTransactionsID = transactionsDamageCustomFields;
                                                    customFieldsCauseTransactionsID = transactionsCauseCustomFields;
                                                }
                                                
                                                [[[notificationDetailDictionary objectForKey:[NSString stringWithFormat:@"%lli",[[activitiesDictionary objectForKey:@"Qmnum"] longLongValue]]] objectAtIndex:3] addObject:[NSArray arrayWithObjects:resulActivityDictionary,[NSMutableArray array],[NSMutableArray array], nil]];
                                            }
                                        }
                                    }
                                    
                                    [notificationActivitiesArray removeAllObjects];
                                }
                                
                                responseObject = nil;
                                NSMutableArray *notificationTasksArray = [[NSMutableArray alloc] init];
                                
                                if ([parsedDictionary objectForKey:@"resultTasks"]) {
                                    
                                    responseObject = [parsedDictionary objectForKey:@"resultTasks"];
                                    
                                    [notificationTasksArray addObjectsFromArray:responseObject];
                                    
                                    NSDictionary *tasksDictionary;
                                    
                                    for (int i=0; i<[notificationTasksArray count]; i++) {
                                        
                                        if ([[notificationTasksArray objectAtIndex:i] isKindOfClass:[NSDictionary class]]) {
                                            tasksDictionary = [notificationTasksArray objectAtIndex:i];
                                            if ([notificationDetailDictionary objectForKey:[NSString stringWithFormat:@"%lli",[[tasksDictionary objectForKey:@"Qmnum"] longLongValue]]]) {
                                                
                                                NSMutableArray *tasks = [NSMutableArray array];
                                                
                                                [tasks addObject:@""];
                                                [tasks addObject:@""];
                                                
                                                if ([tasksDictionary objectForKey:@"TaskKey"]) {
                                                    [tasks addObject:[[tasksDictionary objectForKey:@"TaskKey"] copy]];
                                                }
                                                else{
                                                    [tasks addObject:@""];
                                                }
                                                
                                                if ([tasksDictionary objectForKey:@"TaskGrp"]) {
                                                    [tasks addObject:[[tasksDictionary objectForKey:@"TaskGrp"] copy]];
                                                }
                                                else{
                                                    [tasks addObject:@""];
                                                }
                                                
                                                if ([tasksDictionary objectForKey:@"Taskgrptext"]) {
                                                    [tasks addObject:[[tasksDictionary objectForKey:@"Taskgrptext"] copy]];
                                                }
                                                else{
                                                    [tasks addObject:@""];
                                                }
                                                
                                                if ([tasksDictionary objectForKey:@"TaskCod"]) {
                                                    [tasks addObject:[tasksDictionary objectForKey:@"TaskCod"]];
                                                }
                                                else{
                                                    
                                                    [tasks addObject:@""];
                                                }
                                                
                                                if ([tasksDictionary objectForKey:@"Taskcodetext"]) {
                                                    [tasks addObject:[tasksDictionary objectForKey:@"Taskcodetext"]];
                                                }
                                                else{
                                                    
                                                    [tasks addObject:@""];
                                                }
                                                
                                                if ([tasksDictionary objectForKey:@"TaskShtxt"]) {
                                                    [tasks addObject:[tasksDictionary objectForKey:@"TaskShtxt"]];
                                                }
                                                else{
                                                    
                                                    [tasks addObject:@""];
                                                }
                                                
                                                if ([tasksDictionary objectForKey:@"Parvw"])
                                                {
                                                    [tasks addObject:[tasksDictionary objectForKey:@"Parvw"]];
                                                }
                                                else{
                                                    
                                                    [tasks addObject:@""];
                                                }
                                                
                                                [tasks addObject:@""];//processername
                                                
                                                if ([tasksDictionary objectForKey:@"Parnr"])
                                                {
                                                    [tasks addObject:[tasksDictionary objectForKey:@"Parnr"]];
                                                }
                                                else{
                                                    
                                                    [tasks addObject:@""];
                                                }
                                                
                                                if ([tasksDictionary objectForKey:@"Pster"])
                                                {
                                                    [tasks addObject:[tasksDictionary objectForKey:@"Pster"]];
                                                }
                                                else{
                                                    
                                                    [tasks addObject:@""];
                                                }
                                                
                                                if ([tasksDictionary objectForKey:@"Peter"])
                                                {
                                                    [tasks addObject:[tasksDictionary objectForKey:@"Peter"]];
                                                }
                                                else{
                                                    
                                                    [tasks addObject:@""];
                                                }
                                                
                                                if ([tasksDictionary objectForKey:@"Release"]) {
                                                    [tasks addObject:[tasksDictionary objectForKey:@"Release"]];
                                                }
                                                else{
                                                    
                                                    [tasks addObject:@""];
                                                }
                                                
                                                if ([tasksDictionary objectForKey:@"Complete"]) {
                                                    [tasks addObject:[tasksDictionary objectForKey:@"Complete"]];
                                                }
                                                else{
                                                    
                                                    [tasks addObject:@""];
                                                }
                                                
                                                if ([tasksDictionary objectForKey:@"Success"]) {
                                                    [tasks addObject:[tasksDictionary objectForKey:@"Success"]];
                                                }
                                                else{
                                                    
                                                    [tasks addObject:@""];
                                                }
                                                
                                                if ([tasksDictionary objectForKey:@"ItemKey"]) {
                                                    [tasks addObject:[tasksDictionary objectForKey:@"ItemKey"]];
                                                }
                                                else{
                                                    
                                                    [tasks addObject:@""];
                                                }
                                                
                                                
                                                [tasks addObject:@""];//item status
                                                
                                                ////////////////
                                                
                                                if ([tasksDictionary objectForKey:@"ItempartGrp"]) {
                                                    [tasks addObject:[[tasksDictionary objectForKey:@"ItempartGrp"] copy]];
                                                }
                                                else{
                                                    [tasks addObject:@""];
                                                }
                                                
                                                if ([tasksDictionary objectForKey:@"Partgrptext"]) {
                                                    [tasks addObject:[[tasksDictionary objectForKey:@"Partgrptext"] copy]];
                                                }
                                                else{
                                                    [tasks addObject:@""];
                                                }
                                                
                                                if ([tasksDictionary objectForKey:@"ItempartCod"]) {
                                                    [tasks addObject:[[tasksDictionary objectForKey:@"ItempartCod"] copy]];
                                                }
                                                else{
                                                    [tasks addObject:@""];
                                                }
                                                
                                                if ([tasksDictionary objectForKey:@"Partcodetext"]) {
                                                    [tasks addObject:[[tasksDictionary objectForKey:@"Partcodetext"] copy]];
                                                }
                                                else{
                                                    [tasks addObject:@""];
                                                    
                                                }
                                                
                                                if ([tasksDictionary objectForKey:@"ItemdefectGrp"]) {
                                                    [tasks addObject:[[tasksDictionary objectForKey:@"ItemdefectGrp"] copy]];
                                                }
                                                else{
                                                    [tasks addObject:@""];
                                                }
                                                
                                                if ([tasksDictionary objectForKey:@"Defectgrptext"]) {
                                                    [tasks addObject:[[tasksDictionary objectForKey:@"Defectgrptext"] copy]];
                                                }
                                                else{
                                                    [tasks addObject:@""];
                                                }
                                                
                                                if ([tasksDictionary objectForKey:@"ItemdefectCod"]) {
                                                    [tasks addObject:[[tasksDictionary objectForKey:@"ItemdefectCod"] copy]];
                                                }
                                                else{
                                                    [tasks addObject:@""];
                                                }
                                                
                                                if ([tasksDictionary objectForKey:@"Defectcodetext"]) {
                                                    [tasks addObject:[[tasksDictionary objectForKey:@"Defectcodetext"] copy]];
                                                }
                                                else{
                                                    [tasks addObject:@""];
                                                }
                                                
                                                if ([tasksDictionary objectForKey:@"ItemdefectShtxt"]) {
                                                    [tasks addObject:[[tasksDictionary objectForKey:@"ItemdefectShtxt"] copy]];
                                                }
                                                else{
                                                    [tasks addObject:@""];
                                                }
                                                
                                                if ([tasksDictionary objectForKey:@"UserStatus"]) {
                                                    [tasks addObject:[tasksDictionary objectForKey:@"UserStatus"]];
                                                }
                                                else{
                                                    
                                                    [tasks addObject:@""];
                                                }
                                                
                                                if ([tasksDictionary objectForKey:@"SysStatus"]) {
                                                    [tasks addObject:[tasksDictionary objectForKey:@"SysStatus"]];
                                                }
                                                else{
                                                    
                                                    [tasks addObject:@""];
                                                }
                                                
                                                if ([tasksDictionary objectForKey:@"Smsttxt"]) {
                                                    [tasks addObject:[tasksDictionary objectForKey:@"Smsttxt"]];
                                                }
                                                else{
                                                    
                                                    [tasks addObject:@""];
                                                }
                                                
                                                if ([tasksDictionary objectForKey:@"Smastxt"]) {
                                                    [tasks addObject:[tasksDictionary objectForKey:@"Smastxt"]];
                                                }
                                                else{
                                                    
                                                    [tasks addObject:@""];
                                                }
                                                
                                                if ([tasksDictionary objectForKey:@"Usr01"]) {
                                                    [tasks addObject:[tasksDictionary objectForKey:@"Usr01"]];
                                                }
                                                else{
                                                    
                                                    [tasks addObject:@""];
                                                }
                                                
                                                if ([tasksDictionary objectForKey:@"Usr02"]) {
                                                    [tasks addObject:[tasksDictionary objectForKey:@"Usr02"]];
                                                }
                                                else{
                                                    
                                                    [tasks addObject:@""];
                                                }
                                                
                                                if ([tasksDictionary objectForKey:@"Usr03"]) {
                                                    [tasks addObject:[tasksDictionary objectForKey:@"Usr03"]];
                                                }
                                                else{
                                                    
                                                    [tasks addObject:@""];
                                                }
                                                
                                                if ([tasksDictionary objectForKey:@"Usr04"]) {
                                                    [tasks addObject:[tasksDictionary objectForKey:@"Usr04"]];
                                                }
                                                else{
                                                    
                                                    [tasks addObject:@""];
                                                }
                                                
                                                if ([tasksDictionary objectForKey:@"Usr05"]) {
                                                    [tasks addObject:[tasksDictionary objectForKey:@"Usr05"]];
                                                }
                                                else{
                                                    
                                                    [tasks addObject:@""];
                                                }
                                                
                                                if ([tasksDictionary objectForKey:@"Pstur"]) {
                                                    [tasks addObject:[[tasksDictionary objectForKey:@"Pstur"] copy]];
                                                }
                                                else{
                                                    [tasks addObject:@""];
                                                }
                                                
                                                if ([tasksDictionary objectForKey:@"Petur"]) {
                                                    [tasks addObject:[[tasksDictionary objectForKey:@"Petur"] copy]];
                                                }
                                                else{
                                                    [tasks addObject:@""];
                                                }
                                                
                                                if ([tasksDictionary objectForKey:@"Erldat"]) {
                                                    [tasks addObject:[[tasksDictionary objectForKey:@"Erldat"] copy]];
                                                }
                                                else{
                                                    [tasks addObject:@""];
                                                }
                                                
                                                if ([tasksDictionary objectForKey:@"Erlzeit"]) {
                                                    [tasks addObject:[[tasksDictionary objectForKey:@"Erlzeit"] copy]];
                                                }
                                                else{
                                                    [tasks addObject:@""];
                                                }
                                                
                                                if ([tasksDictionary objectForKey:@"Erlnam"]) {
                                                    [tasks addObject:[[tasksDictionary objectForKey:@"Erlnam"] copy]];
                                                }
                                                else{
                                                    [tasks addObject:@""];
                                                }
                                                
                                                
                                                id customFieldsTaskTransactionsID;
                                                if ([tasksDictionary objectForKey:@"Fields"]) {
                                                    
                                                    NSMutableArray *fieldsArray=[NSMutableArray new];
                                                    if ([[[tasksDictionary objectForKey:@"Fields"] objectForKey:@"item"] isKindOfClass:[NSDictionary class]]) {
                                                        
                                                        [fieldsArray addObjectsFromArray:[NSMutableArray arrayWithObject:[[tasksDictionary objectForKey:@"Fields"] objectForKey:@"item"]]];
                                                    }
                                                    else if ([[[tasksDictionary objectForKey:@"Fields"] objectForKey:@"item"] isKindOfClass:[NSArray class]]){
                                                        
                                                        [fieldsArray addObjectsFromArray:[[tasksDictionary objectForKey:@"Fields"] objectForKey:@"item"]];
                                                    }
                                                    
                                                    NSMutableArray *taskCodeCustomFields = [NSMutableArray array];
                                                    
                                                    for (int i =0; i<[fieldsArray count]; i++) {
                                                        NSString *fieldValue,*fieldName,*fLabel,*tabName,*docType,*docTypeItem,*dataType,*sequence,*length;
                                                        if ([NullChecker isNull:[[fieldsArray objectAtIndex:i] objectForKey:@"Fieldname"]]) {
                                                            fieldName = @"";
                                                        }
                                                        else{
                                                            fieldName = [[fieldsArray objectAtIndex:i] objectForKey:@"Fieldname"];
                                                        }
                                                        
                                                        if ([NullChecker isNull:[[fieldsArray objectAtIndex:i] objectForKey:@"Flabel"]]) {
                                                            fLabel = @"";
                                                        }
                                                        else{
                                                            fLabel = [[fieldsArray objectAtIndex:i] objectForKey:@"Flabel"];
                                                        }
                                                        
                                                        if ([NullChecker isNull:[[fieldsArray objectAtIndex:i] objectForKey:@"Tabname"]]) {
                                                            tabName = @"";
                                                        }
                                                        else{
                                                            tabName = [[fieldsArray objectAtIndex:i] objectForKey:@"Tabname"];
                                                        }
                                                        
                                                        if ([NullChecker isNull:[[fieldsArray objectAtIndex:i] objectForKey:@"Value"]]) {
                                                            fieldValue = @"";
                                                        }
                                                        else{
                                                            fieldValue = [[fieldsArray objectAtIndex:i] objectForKey:@"Value"];
                                                        }
                                                        
                                                        if ([NullChecker isNull:[[fieldsArray objectAtIndex:i] objectForKey:@"Zdoctype"]]) {
                                                            docType = @"";
                                                        }
                                                        else{
                                                            docType = [[fieldsArray objectAtIndex:i] objectForKey:@"Zdoctype"];
                                                        }
                                                        
                                                        if ([NullChecker isNull:[[fieldsArray objectAtIndex:i] objectForKey:@"ZdoctypeItem"]]) {
                                                            docTypeItem = @"";
                                                        }
                                                        else{
                                                            docTypeItem = [[fieldsArray objectAtIndex:i] objectForKey:@"ZdoctypeItem"];
                                                        }
                                                        
                                                        
                                                        if ([NullChecker isNull:[[fieldsArray objectAtIndex:i] objectForKey:@"Datatype"]]) {
                                                            dataType = @"";
                                                        }
                                                        else{
                                                            dataType = [[fieldsArray objectAtIndex:i] objectForKey:@"Datatype"];
                                                        }
                                                        
                                                        if ([NullChecker isNull:[[fieldsArray objectAtIndex:i] objectForKey:@"Sequence"]]) {
                                                            sequence = @"";
                                                        }
                                                        else{
                                                            sequence = [[fieldsArray objectAtIndex:i] objectForKey:@"Sequence"];
                                                        }
                                                        
                                                        if ([NullChecker isNull:[[fieldsArray objectAtIndex:i] objectForKey:@"Length"]]) {
                                                            length = @"";
                                                        }
                                                        else{
                                                            length = [[fieldsArray objectAtIndex:i] objectForKey:@"Length"];
                                                        }
                                                        
                                                        if ([docTypeItem isEqualToString:@"QT"]) {
                                                            [taskCodeCustomFields addObject:[NSMutableArray arrayWithObjects:docType,docTypeItem,tabName,fieldName,fieldValue,fLabel,dataType,sequence,length, nil]];
                                                        }
                                                        
                                                    }
                                                    
                                                    customFieldsTaskTransactionsID = taskCodeCustomFields;
                                                    
                                                }
                                                
                                                [[[notificationDetailDictionary objectForKey:[NSString stringWithFormat:@"%lli",[[tasksDictionary objectForKey:@"Qmnum"] longLongValue]]] objectAtIndex:4] addObject:[NSArray arrayWithObjects:tasks,customFieldsTaskTransactionsID, nil]];
                                            }
                                        }
                                    }
                                    
                                    [notificationTasksArray removeAllObjects];
                                }
                                
                                responseObject = nil;
                                NSMutableArray *notificationStatusArray = [[NSMutableArray alloc] init];
                                
                                if ([parsedDictionary objectForKey:@"resultNotifStatus"]) {
                                    
                                    responseObject = [parsedDictionary objectForKey:@"resultNotifStatus"];
                                    
                                    [notificationStatusArray addObjectsFromArray:responseObject];
                                    
                                    NSDictionary *notifStatusDictionary;
                                    
                                    for (int i=0; i<[notificationStatusArray count]; i++) {
                                        if ([[notificationStatusArray objectAtIndex:i] isKindOfClass:[NSDictionary class]]) {
                                            notifStatusDictionary = [notificationStatusArray objectAtIndex:i];
                                            if ([notificationDetailDictionary objectForKey:[NSString stringWithFormat:@"%lli",[[notifStatusDictionary objectForKey:@"Qmnum"] longLongValue]]]) {
                                                
                                                NSMutableArray *notifStatus = [NSMutableArray array];
                                                
                                                if ([notifStatusDictionary objectForKey:@"Qmnum"]) {
                                                    [notifStatus addObject:[notifStatusDictionary objectForKey:@"Qmnum"]];
                                                }
                                                else{
                                                    
                                                    [notifStatus addObject:@""];
                                                }
                                                
                                                if ([notifStatusDictionary objectForKey:@"Aufnr"]) {
                                                    [notifStatus addObject:[notifStatusDictionary objectForKey:@"Aufnr"]];
                                                }
                                                else{
                                                    
                                                    [notifStatus addObject:@""];
                                                }
                                                
                                                if ([notifStatusDictionary objectForKey:@"Objnr"]) {
                                                    [notifStatus addObject:[notifStatusDictionary objectForKey:@"Objnr"]];
                                                }
                                                else{
                                                    [notifStatus addObject:@""];
                                                }
                                                
                                                if ([notifStatusDictionary objectForKey:@"Manum"]) {
                                                    [notifStatus addObject:[notifStatusDictionary objectForKey:@"Manum"]];
                                                }
                                                else{
                                                    [notifStatus addObject:@""];
                                                }
                                                
                                                if ([notifStatusDictionary objectForKey:@"Stsma"]) {
                                                    [notifStatus addObject:[notifStatusDictionary objectForKey:@"Stsma"]];
                                                }
                                                else{
                                                    [notifStatus addObject:@""];
                                                }
                                                
                                                if ([notifStatusDictionary objectForKey:@"Inist"]) {
                                                    [notifStatus addObject:[notifStatusDictionary objectForKey:@"Inist"]];
                                                }
                                                else{
                                                    [notifStatus addObject:@""];
                                                }
                                                
                                                if ([notifStatusDictionary objectForKey:@"Stonr"]) {
                                                    [notifStatus addObject:[notifStatusDictionary objectForKey:@"Stonr"]];
                                                }
                                                else{
                                                    [notifStatus addObject:@""];
                                                }
                                                
                                                if ([notifStatusDictionary objectForKey:@"Hsonr"]) {
                                                    [notifStatus addObject:[notifStatusDictionary objectForKey:@"Hsonr"]];
                                                }
                                                else{
                                                    [notifStatus addObject:@""];
                                                }
                                                
                                                if ([notifStatusDictionary objectForKey:@"Nsonr"]) {
                                                    [notifStatus addObject:[notifStatusDictionary objectForKey:@"Nsonr"]];
                                                }
                                                else{
                                                    [notifStatus addObject:@""];
                                                }
                                                
                                                if ([notifStatusDictionary objectForKey:@"Stat"]) {
                                                    [notifStatus addObject:[[notifStatusDictionary objectForKey:@"Stat"] substringToIndex:1]];
                                                }
                                                else{
                                                    [notifStatus addObject:@""];
                                                }
                                                
                                                if ([notifStatusDictionary objectForKey:@"Act"]) {
                                                    [notifStatus addObject:[notifStatusDictionary objectForKey:@"Act"]];
                                                }
                                                else{
                                                    [notifStatus addObject:@""];
                                                }
                                                
                                                if ([notifStatusDictionary objectForKey:@"Txt04"]) {
                                                    [notifStatus addObject:[notifStatusDictionary objectForKey:@"Txt04"]];
                                                }
                                                else{
                                                    [notifStatus addObject:@""];
                                                }
                                                
                                                if ([notifStatusDictionary objectForKey:@"Txt30"]) {
                                                    [notifStatus addObject:[notifStatusDictionary objectForKey:@"Txt30"]];
                                                }
                                                else{
                                                    [notifStatus addObject:@""];
                                                }
                                                
                                                if ([notifStatusDictionary objectForKey:@"Action"]) {
                                                    [notifStatus addObject:[notifStatusDictionary objectForKey:@"Action"]];
                                                }
                                                else{
                                                    [notifStatus addObject:@""];
                                                }
                                                
                                                [[[notificationDetailDictionary objectForKey:[NSString stringWithFormat:@"%lli",[[notifStatusDictionary objectForKey:@"Qmnum"] longLongValue]]] lastObject] addObject:notifStatus];
                                            }
                                        }
                                    }
                                    
                                    [notificationStatusArray removeAllObjects];
                                }
                                
                                responseObject = nil;
                                
                                if ([parsedDictionary objectForKey:@"resultLongText"]) {
                                    responseObject = [parsedDictionary objectForKey:@"resultLongText"];
                                    NSMutableArray *notificatioTextnArray = [[NSMutableArray alloc] init];
                                    
                                    [notificatioTextnArray addObjectsFromArray:responseObject];
                                    
                                    NSDictionary *textDictionary;
                                    for (int i=0; i<[notificatioTextnArray count]; i++) {
                                        if ([[notificatioTextnArray objectAtIndex:i] isKindOfClass:[NSDictionary class]]) {
                                            textDictionary = [notificatioTextnArray objectAtIndex:i];
                                            if ([notificationDetailDictionary objectForKey:[textDictionary objectForKey:@"Qmnum"]]) {
                                                NSMutableDictionary *headerDictionary = [[notificationDetailDictionary objectForKey:[textDictionary objectForKey:@"Qmnum"]] firstObject];
                                                if ([[headerDictionary objectForKey:@"LONGTEXT"] length]) {
                                                    [headerDictionary setObject:[NSString stringWithFormat:@"%@\n%@",[headerDictionary objectForKey:@"LONGTEXT"],[textDictionary objectForKey:@"TextLine"]] forKey:@"LONGTEXT"];
                                                }
                                                else
                                                {
                                                    [headerDictionary setObject:[NSString stringWithFormat:@"%@",[textDictionary objectForKey:@"TextLine"]] forKey:@"LONGTEXT"];
                                                }
                                            }
                                        }
                                    }
                                    
                                    [notificationTransactionArray removeAllObjects];
                                    responseObject = nil;
                                }
                                
                                NSLog(@"%@",notificationDetailDictionary);
                                
                                NSArray *objectIds = [notificationDetailDictionary allKeys];
 
                                if ([[defaults objectForKey:@"ACTIVATELOGS"] isEqualToString:@"X"])
                                {
                                    [[DataBase sharedInstance] writToLogFile:[NSString stringWithFormat:@"#INFO#.com.enstrapp.fieldtekpro#No of Due Notifications received:%lu",(unsigned long)[objectIds count]]];
                                }
                                
                                for (int i=0; i<[objectIds count]; i++) {
                                    
                                    [[DataBase sharedInstance] insertDataIntoNotificationHeader:[[notificationDetailDictionary objectForKey:[objectIds objectAtIndex:i]] firstObject] withAttachments:[[notificationDetailDictionary objectForKey:[objectIds objectAtIndex:i]] objectAtIndex:1] withTransaction:[[notificationDetailDictionary objectForKey:[objectIds objectAtIndex:i]] objectAtIndex:2] withActivityCodes:[[notificationDetailDictionary objectForKey:[objectIds objectAtIndex:i]] objectAtIndex:3] withTaskcodes:[[notificationDetailDictionary objectForKey:[objectIds objectAtIndex:i]] objectAtIndex:4] withInspectionResult:[inspectionResultDataArray copy] withNotifStatusCode:[[notificationDetailDictionary objectForKey:[objectIds objectAtIndex:i]] objectAtIndex:5]];
                                }
                             }
                            
                            [[DataBase sharedInstance] updateNotificationWithObjectid:qmnumString forHeaderID:[self.notificationHeaderDetails objectForKey:@"ID"]];
                            
                            releaseBtn.hidden=YES;
                            
                              [self showAlertMessageWithTitle:@"Success" message:messageString cancelButtonTitle:@"OK" withactionType:@"Single" forMethod:nil];
 
                        }
                        else if([[[parsedDictionary objectForKey:@"MESSAGE"] substringToIndex:1] isEqualToString:@"E"])
                        {
                            [[DataBase sharedInstance] updateSyncLogErrorForCategory:@"Notification" action:@"Postpone" objectid:@"" UUID:[self.notificationHeaderDetails objectForKey:@"ID"] message:[[parsedDictionary objectForKey:@"MESSAGE"] substringFromIndex:1]];
                            
                            [self showAlertMessageWithTitle:@"ERROR" message:[[parsedDictionary objectForKey:@"MESSAGE"] substringFromIndex:1] cancelButtonTitle:@"OK" withactionType:@"Single" forMethod:nil];
                            
                            
                        }
                        else if ([parsedDictionary objectForKey:@"ERROR"]) {
                            [[DataBase sharedInstance] updateSyncLogErrorForCategory:@"Notification" action:@"Postpone" objectid:@"" UUID:[self.notificationHeaderDetails objectForKey:@"ID"] message:[parsedDictionary objectForKey:@"ERROR"]];
 
                            [self showAlertMessageWithTitle:@"Failure" message:[NSString stringWithFormat:@"Notification Not Postponed. Server error"] cancelButtonTitle:@"OK" withactionType:@"Single" forMethod:nil];
                            
                        }
                        else
                        {
                            //                    [[DataBase sharedInstance] updateSyncLogErrorForCategory:@"Notification" action:@"Create" objectid:@"" UUID:[self.notificationHeaderDetails objectForKey:@"ID"] message:NSLocalizedString(@"ErrorMessage", nil)];
                            
                            [[DataBase sharedInstance] updateSyncLogErrorForCategory:@"Notification" action:@"Postpone" objectid:@""  UUID:[self.notificationHeaderDetails objectForKey:@"ID"] message:NSLocalizedString(@"ErrorMessage",nil)];
                            
                            [self showAlertMessageWithTitle:@"Information" message:NSLocalizedString(@"ErrorMessage", nil) cancelButtonTitle:@"OK" withactionType:@"Single" forMethod:nil];
                            
                        }
                        
                    }
                    
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    
                }
            }
            else
            {
                [[DataBase sharedInstance] updateSyncLogErrorForCategory:@"Notification" action:@"Postpone" objectid:@"" UUID:[self.notificationHeaderDetails objectForKey:@"ID"] message:NSLocalizedString(@"ErrorMessage", nil)];
               
                [self showAlertMessageWithTitle:@"Failure" message:errorDescription cancelButtonTitle:@"OK" withactionType:@"Single" forMethod:nil];
                
            }
            
            break;
            
         default:
            break;
    }
    
    [self.notificationHeaderDetails removeAllObjects];
    [selectedCheckBoxArray removeAllObjects];
    [inputsDictionary removeAllObjects];
    [inputsDictionary setObject:@"ORDER BY nh_upadated_Date DESC" forKey:@"RECENT"];
    [self searchMyNotificationsFromSqlite:inputsDictionary];
    
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
