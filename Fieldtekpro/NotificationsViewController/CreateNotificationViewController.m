//
//  CreateNotificationViewController.m
//  Fieldtekpro
//
//  Created by Enstrapp Bangalore on 09/10/17.
//  Copyright © 2017 Enstrapp Bangalore. All rights reserved.
//

#import "CreateNotificationViewController.h"

#define UIColorFromRGB(r, g, b)  [UIColor colorWithRed:((r) / 255.0) green:((g) / 255.0) blue:((b) / 255.0) alpha:1.0]

#define ID_INDEX 0
#define NAME_INDEX 1

@interface CreateNotificationViewController ()<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>

@end

@implementation CreateNotificationViewController
@synthesize defaults;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    defaults=[NSUserDefaults standardUserDefaults];
 
    self.dropDownArray=[NSMutableArray new];
    
    createOrderBtn.hidden=YES;
    
    count=0;
    
    NSString *key = @"";
    NSLog(@"total key is %@",key);
    
    NSString *str_UserNameDep = [defaults objectForKey:@"userName"];
    decryptedUserName = [str_UserNameDep AES128DecryptWithKey:key];
    
    // Get the instance of the UITextField of the search bar
    UITextField *searchField = [dropDownSearchBar valueForKey:@"_searchField"];
    // Change search bar text color
    searchField.textColor = [UIColor blueColor];
    
    // Change the search bar placeholder text color
    [searchField setValue:[UIColor blueColor] forKeyPath:@"_placeholderLabel.textColor"];
    
    
    self.causeCodeDetailsArray = [NSMutableArray new];
    self.selectedCheckBoxArray = [NSMutableArray new];
    self.selectedTaskCheckBoxArray=[NSMutableArray new];
    self.notifActivityDetailsArray = [NSMutableArray new];
    self.causeCodeDetailDeleteArray = [NSMutableArray new];
    
    [[DataBase sharedInstance] deleteNotificationTransactions];
    [[DataBase sharedInstance] deleteNotificationTasks];
    [[DataBase sharedInstance] deleteNotificationActivities];

     self.getDocumentsHeaderDetails=[[NSMutableDictionary alloc]init];
     [self uiPickerTableViewForDropDownSelection];
    
     [self customChangeSegmentController];
    
     self.itemKeyDetailsArray=[NSMutableArray new];
    

     updateActivityFlag=NO;
 
    if ([self.detailNotificationArray count])
    {
        editBtn.hidden=NO;
        [self loadChangeHeaderData];
    }
    
    else
    {
         editBtn.hidden=YES;
         [self loadHeaderData];
     }

    notificationUDID =[NSMutableString new];
    notificationTypeID = [NSMutableString new];
    priorityID = [NSMutableString new];
    
    //intializing values for damages and causes
    VornrItem = 1;
    VornrCauseCode = 1;
    VornrTaskCode =1;
   
    personResponisbleID=[NSMutableString new];
    effectID=[NSMutableString new];

     self.customHeaderDetailsArray = [NSMutableArray new];
    self.customDamageDetailsArray=[NSMutableArray new];
    self.customCauseDetailsArray=[NSMutableArray new];
    self.customTasksDetailsArray=[NSMutableArray new];
 
    
     [commomlistListTableview registerNib:[UINib nibWithNibName:@"ListofCauseCodesTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"causecodeCell"];
    
     [commomlistListTableview registerNib:[UINib nibWithNibName:@"TaskCodeTableViewCell~iPhone5" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"TaskCodeTableviewcell"];
    
     [commomlistListTableview registerNib:[UINib nibWithNibName:@"ActivityTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"ActivityCell"];
    
     [commomlistListTableview registerNib:[UINib nibWithNibName:@"ListOfAttachmentsCustomTableViewCell_iPhone6" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"AttachmentsCell"];
    
     [commomlistListTableview registerNib:[UINib nibWithNibName:@"InspectionResultTableViewCell_Iphone6" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"InspectionCell"];
 
     [commonAddTableView registerNib:[UINib nibWithNibName:@"CustomInputDorpdownTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"CustomDropdownTableViewCell"];
    
   //  [commonAddTableView registerNib:[UINib nibWithNibName:@"TaskCodeStatusTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"custumStatuscell"];
    
       [commonAddTableView registerNib:[UINib nibWithNibName:@"NotifOrderTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"NotifOrderCell"];
    
     [duplicateNotificationTableView registerNib:[UINib nibWithNibName:@"DuplicateNotificationTableViewCell_iPhone5" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"Cell"];
    
 
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(IBAction)editBtnClicked:(id)sender{
    
    editBtnSelected =YES;
    
    editBtn.hidden=YES;
    
    [commomlistListTableview reloadData];
}


-(void)viewWillAppear:(BOOL)animated{
    
    res_obj=[Response sharedInstance];
 
    if ([self.inspectionEquipmentArray count]) {
        
        [[headerDataArray objectAtIndex:3] replaceObjectAtIndex:2 withObject:[self.inspectionEquipmentArray objectAtIndex:0]];
        [[headerDataArray objectAtIndex:3] replaceObjectAtIndex:3 withObject:[self.inspectionEquipmentArray objectAtIndex:1]];
        
        equipmentID=[self.inspectionEquipmentArray objectAtIndex:0];
 
        [[headerDataArray objectAtIndex:4] replaceObjectAtIndex:2 withObject:[self.inspectionEquipmentArray objectAtIndex:2]];
 
        NSArray *plannerGroupDetails=[[DataBase sharedInstance] fetchPlannerGrpForequipIngrp:[self.inspectionEquipmentArray objectAtIndex:2]];
        
        plannerGrouplID=[NSMutableString new];
        
        if ([plannerGroupDetails count]) {
            
            [plannerGrouplID setString:[[plannerGroupDetails objectAtIndex:0] objectAtIndex:1]];
            plannerGroupNameString=[[plannerGroupDetails objectAtIndex:0] objectAtIndex:2];
            
            [[headerDataArray objectAtIndex:6] replaceObjectAtIndex:2 withObject:[NSString stringWithFormat:@"%@-%@",[[plannerGroupDetails objectAtIndex:0] objectAtIndex:1],[[plannerGroupDetails objectAtIndex:0] objectAtIndex:2]]];
        }
        
        if (res_obj.catalogProfileIdstring.length) {
            
            catalogProfileID=[NSMutableString new];
            
            [catalogProfileID setString:[self.inspectionEquipmentArray objectAtIndex:6]];
            
        }
        
        [[headerDataArray objectAtIndex:2] replaceObjectAtIndex:2 withObject:self.checkListFuncLocidString];
        [[headerDataArray objectAtIndex:2] replaceObjectAtIndex:3 withObject:self.checkListFuncLocidString];

        
    }
 
}

-(IBAction)searchBackButtonClicked:(id)sender
{
    if (seachDropdownTableView.tag==2) {
        
        [searchDropDownView removeFromSuperview];

    }
    else{
        
        if (count==0)
        {
            [searchDropDownView removeFromSuperview];
        }
        else
        {
            if (seachDropdownTableView.tag==1)
            {
                if (!islevelEnabled) {
                    
                    NSMutableDictionary *inputParameters = [NSMutableDictionary new];
                    
                    if (count==1)
                    {
                        [locationIdArray removeAllObjects];
                        
                        [inputParameters setObject:@"" forKey:@"functionLocationHID"];
                     }
                     else
                    {
                        [locationIdArray removeObjectAtIndex:[locationIdArray count]-1];
                        [inputParameters setObject:[locationIdArray objectAtIndex:count-2] forKey:@"functionLocationHID"];
                    }
                    
                    if (self.functionLocationHierarchyArray == nil) {
                        self.functionLocationHierarchyArray = [NSMutableArray new];
                    }
                    else{
                        
                        [self.functionLocationHierarchyArray removeAllObjects];
                    }
                    
                    [self.functionLocationHierarchyArray addObjectsFromArray:[[DataBase sharedInstance] getFunctionLocations:inputParameters]];
                    
                    funcLocnHeaderLabel.text = [NSString stringWithFormat:@"Function Location (%lu)",(unsigned long)[self.functionLocationHierarchyArray count]];
                 }
                else
                {
                     NSMutableDictionary *inputParameters = [NSMutableDictionary new];
                    
                    [inputParameters setObject:[locationIdArray objectAtIndex:count-1] forKey:@"functionLocationHID"];
                    
                    [locationIdArray removeObjectAtIndex:[locationIdArray count]-1];
                    
                    [self.functionLocationHierarchyArray addObjectsFromArray:[[DataBase sharedInstance] getFunctionLocations:inputParameters]];
                    
                    funcLocnHeaderLabel.text = [NSString stringWithFormat:@"Function Location (%lu)",(unsigned long)[self.functionLocationHierarchyArray count]];
                    
                }
            }
            
            count=count-1;
            
            if (count==0)
            {
                seachDropdownTableView.tag=0;
                
                NSMutableDictionary *inputParameters = [NSMutableDictionary new];
                
                [inputParameters setObject:@"" forKey:@"functionLocationHID"];
                
                [self.functionLocationHierarchyArray addObjectsFromArray:[[DataBase sharedInstance] getFunctionLocations:inputParameters]];
                
                funcLocnHeaderLabel.text = [NSString stringWithFormat:@"Function Location (%lu)",(unsigned long)[self.functionLocationArray count]];
            }
            
            [seachDropdownTableView reloadData];
        }
    }
 }


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
                                        if ([methodNameString isEqualToString:@"Attachments"]) {
                                            
                                            if (![[[self.attachmentArray objectAtIndex:attachmentCurrentIndex] objectAtIndex:7] isEqualToString:@""]) {
                                                
                                                [self downloadAttachments];
                                                
                                            }
                                            else{
                                                
                                                if([[ConnectionManager defaultManager] isReachable])
                                                {
                                                    
                                                    NSMutableDictionary *endPointDictionary = [NSMutableDictionary new];
                                                    [endPointDictionary setObject:@"AT" forKey:@"ACTIVITY"];
                                                    [endPointDictionary setObject:@"AT" forKey:@"DOCTYPE"];
                                                    [endPointDictionary setObject:@"REST" forKey:@"ENDPOINT"];
 
                                                    NSArray *endPointArray = [[DataBase sharedInstance] getEndPointURL:endPointDictionary];
                                                    NSLog(@"endPoint :%@",[[endPointArray objectAtIndex:0] objectAtIndex:0]);
                                                    [self.getDocumentsHeaderDetails setObject:[[endPointArray objectAtIndex:0] objectAtIndex:0] forKey:@"URL_ENDPOINT"];
                                                    
                                                    hud = [MBProgressHUD showHUDAddedTo:commomlistListTableview animated:YES];
                                                    hud.mode = MBProgressHUDAnimationFade;
                                                    hud.label.text = @"Downloading in progress...";
                                                    
                                                  [Request makeWebServiceRequest:GET_DOCUMENTS parameters:self.getDocumentsHeaderDetails delegate:self];
                                                  
                                                    //[self downloadAttachments];
                                                }
                                                else
                                                {
                                                    
                                                }
                                            }
                                         }
                                        
                                        else if ([methodNameString isEqualToString:@"back"]){
 
                                            [self.navigationController popViewControllerAnimated:YES];
 
                                        }
                                        
                                       else if ([methodNameString isEqualToString:@"addMoreCauseCode"]) {

                                           [self addMoreCauseCodeDetailsMethod];
                                           
                                       }
                                        
                                       else if ([methodNameString isEqualToString:@"AlertFail"])
                                       {
                                           
                                           [self descriptionAlert];
                                           
                                       }
                                        
                                       else if ([methodNameString isEqualToString:@"Create Notification"]){
 
                                           hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                                           hud.mode = MBProgressHUDModeAnnularDeterminate;
                                           hud.label.text = @"Creation in progress...";
 
                                           [self insertCreateNotification];
                                           
                                       }
                                       else if ([methodNameString isEqualToString:@"Change Notification"]){
                                           
                                           hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                                           hud.mode = MBProgressHUDModeAnnularDeterminate;
                                           hud.label.text = @"Change in progress...";
                                           
                                           [self insertChangeNotifications];
                                           
                                       }
                                        
                                       else if ([methodNameString isEqualToString:@"Delete CauseCodes"]){
                                           
                                           [self listofCauseCodesCancel];
                                           
                                       }
 
                                     }];
        
        UIAlertAction* noButton = [UIAlertAction actionWithTitle:cancelBtnTitle
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * action)
                                   {
 
                                       if ([methodNameString isEqualToString:@"addMoreCauseCode"]) {
                                           
                                            [self addCauseCodeDetailsMethod];
 
                                       }
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
                                       
                                       if ([methodNameString isEqualToString:@"Notif Success"]) {
                                           
                                           [self.navigationController popViewControllerAnimated:YES];

                                       }
                                       
 
                                   }];
        
        [alert addAction:okButton];
        
        [self presentViewController:alert animated:YES completion:nil];
        
    }
}


-(void)insertCreateNotification{
    
    self.notificationHeaderDetails = [[NSMutableDictionary alloc] init];
    [self.notificationHeaderDetails setObject:[notificationUDID copy] forKey:@"ID"];
    
    [self.notificationHeaderDetails setObject:[[[headerDataArray objectAtIndex:0] objectAtIndex:3]  copy] forKey:@"NID"];
     
    [self.notificationHeaderDetails setObject:[[[headerDataArray objectAtIndex:0] objectAtIndex:2]  copy] forKey:@"NNAME"];
    
    [self.notificationHeaderDetails setObject:[[headerDataArray objectAtIndex:1] objectAtIndex:2] forKey:@"SHORTTEXT"];
    
    
    if (res_obj.longTextString) {
         [self.notificationHeaderDetails setObject:res_obj.longTextString forKey:@"LONGTEXT"];

    }
    
    if ([NullChecker isNull:functionalLocationID]) {
        
        functionalLocationID = [[[headerDataArray objectAtIndex:2] objectAtIndex:3]  copy];
    }
    
    [self.notificationHeaderDetails setObject:[functionalLocationID copy] forKey:@"FID"];
    [self.notificationHeaderDetails setObject:[[[headerDataArray objectAtIndex:2] objectAtIndex:2]  copy] forKey:@"FNAME"];
    
    if ([NullChecker isNull:equipmentID]) {
        equipmentID = [[[headerDataArray objectAtIndex:3] objectAtIndex:3]  copy];
    }
    
    [self.notificationHeaderDetails setObject:[equipmentID copy] forKey:@"EQID"];
    
    [self.notificationHeaderDetails setObject:[[[headerDataArray objectAtIndex:3] objectAtIndex:2]  copy] forKey:@"EQNAME"];
    
    [self.notificationHeaderDetails setObject:[[[headerDataArray objectAtIndex:5] objectAtIndex:3] copy] forKey:@"NPID"];
    
    [self.notificationHeaderDetails setObject:[[headerDataArray objectAtIndex:5] objectAtIndex:2] forKey:@"NPNAME"];
    
    [self.notificationHeaderDetails setObject:@"" forKey:@"PLANNERGROUP"];
 
    if (plannerGrouplID.length) {
        
        [self.notificationHeaderDetails setObject:plannerGrouplID forKey:@"PLANNERGROUP"];
        
    }
    
    [self.notificationHeaderDetails setObject:@"" forKey:@"PLANNERGROUPNAME"];

     if (plannerGroupNameString.length) {
        [self.notificationHeaderDetails setObject:plannerGroupNameString forKey:@"PLANNERGROUPNAME"];

    }
    
 
    [self.notificationHeaderDetails setObject:[[headerDataArray objectAtIndex:7] objectAtIndex:2] forKey:@"NREPORTEDBY"];
    
     [self.notificationHeaderDetails setObject:[decryptedUserName copy] forKey:@"REPORTEDBY"];
    
    [self.notificationHeaderDetails setObject:@"" forKey:@"USR01"];

    
    if (primaryPersonResonsibleID.length) {
        
          [self.notificationHeaderDetails setObject:primaryPersonResonsibleID forKey:@"USR01"];
        
    }
 
    [self.notificationHeaderDetails setObject:@"" forKey:@"USR02"];

    
    if (primaryPersonResonsibleNameString.length) {
        
          [self.notificationHeaderDetails setObject:primaryPersonResonsibleNameString forKey:@"USR02"];
    }
 
    
    [self.notificationHeaderDetails setObject:@"" forKey:@"PARNRID"];
 
    if (personResponisbleID.length) {
        
        [self.notificationHeaderDetails setObject:personResponisbleID forKey:@"PARNRID"];
        
    }
    
    [self.notificationHeaderDetails setObject:@"" forKey:@"PARNRTEXT"];

 
    if (personresponsibleNameString.length) {
        
        [self.notificationHeaderDetails setObject:personresponsibleNameString forKey:@"PARNRTEXT"];

     }
 
    [self.notificationHeaderDetails setObject:@"OSNO" forKey:@"NSTATUS"];
    [self.notificationHeaderDetails setObject:@"" forKey:@"DOCS"];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMM dd, yyyy hh:mm a"];
 
    NSDate *requiredstartDate = [dateFormatter dateFromString:[[headerDataArray objectAtIndex:10] objectAtIndex:2]];
    NSDate *requiredendDate = [dateFormatter dateFromString:[[headerDataArray objectAtIndex:11] objectAtIndex:2]];
    NSDate *startDate = [dateFormatter dateFromString:[[headerDataArray objectAtIndex:12] objectAtIndex:2]];
    NSDate *endDate = [dateFormatter dateFromString:[[headerDataArray objectAtIndex:13] objectAtIndex:2]];
    // Convert date object into desired format
    [dateFormatter setDateFormat:@"yyyyMMdd HHmmss"];
    
    NSString *convertedrequiredStartDateString = [dateFormatter stringFromDate:requiredstartDate];
    
    if ([NullChecker isNull:convertedrequiredStartDateString]) {
        convertedrequiredStartDateString = @"";
    }
    
    NSString *convertedrequiredEndDateString = [dateFormatter stringFromDate:requiredendDate];
    if ([NullChecker isNull:convertedrequiredEndDateString]) {
        convertedrequiredEndDateString = @"";
    }
    
    NSString *convertedStartDateString = [dateFormatter stringFromDate:startDate];
    if ([NullChecker isNull:convertedStartDateString]) {
        convertedStartDateString = @"";
    }
    
    NSString *convertedEndDateString = [dateFormatter stringFromDate:endDate];
    if ([NullChecker isNull:convertedEndDateString]) {
        convertedEndDateString = @"";
    }
    
    [self.notificationHeaderDetails setObject:[NSString stringWithFormat:@"%@",convertedrequiredStartDateString] forKey:@"RSDATE"];
    [self.notificationHeaderDetails setObject:[NSString stringWithFormat:@"%@",convertedrequiredEndDateString] forKey:@"REDATE"];
    
    [self.notificationHeaderDetails setObject:[NSString stringWithFormat:@"%@",convertedStartDateString] forKey:@"SDATE"];
    [self.notificationHeaderDetails setObject:[NSString stringWithFormat:@"%@",convertedEndDateString] forKey:@"EDATE"];
    
    [self.notificationHeaderDetails setObject:@"" forKey:@"BREAKDOWN"];
    
    
    
    [self.notificationHeaderDetails setObject:@"" forKey:@"LATITUDE"];
    [self.notificationHeaderDetails setObject:@"" forKey:@"LONGITUDE"];
    [self.notificationHeaderDetails setObject:@"" forKey:@"ALTITUDE"];
    
    if (latitudesString.length) {
        [self.notificationHeaderDetails setObject:[latitudesString copy] forKey:@"LATITUDE"];
    }
    if (longitudesString.length) {
        [self.notificationHeaderDetails setObject:[longitudesString copy] forKey:@"LONGITUDE"];
    }
    if (altitudesString.length) {
        [self.notificationHeaderDetails setObject:[altitudesString copy] forKey:@"ALTITUDE"];
    }
    
    [self.notificationHeaderDetails setObject:@"" forKey:@"EFFECTID"];
    
    effectID=[[headerDataArray objectAtIndex:14] objectAtIndex:3];
    
    if (effectID.length) {
        [self.notificationHeaderDetails setObject:effectID forKey:@"EFFECTID"];
    }
    
    [self.notificationHeaderDetails setObject:@"" forKey:@"SHIFT"];
    
    [self.notificationHeaderDetails setObject:@"" forKey:@"NOOFPERSON"];
    
   // [self getAttachedDocuments];
    
    if(self.attachmentArray==nil)
    {
        self.attachmentArray=[NSMutableArray new];
    }
    
    if(notificationNoString.length)
    {
        [self.notificationHeaderDetails setObject:[notificationNoString copy] forKey:@"OBJECTID"];
    }
    
    [self.notificationHeaderDetails setObject:transmitTypeString forKey:@"TRANSMITTYPE"];
    
    [self.notificationHeaderDetails setObject:@"" forKey:@"AUFNR"];
    
    
    [self.notificationHeaderDetails setObject:res_obj.plantIdString forKey:@"PLANTID"];
    
    [self.notificationHeaderDetails setObject:@"" forKey:@"PLANTNAME"];
    
    [self.notificationHeaderDetails setObject:res_obj.workcenterString forKey:@"WORKCENTERID"];
    
    [self.notificationHeaderDetails setObject:@"" forKey:@"WORKCENTERNAME"];
    
   
    NSMutableArray * activitiesArray=[NSMutableArray new];
    
    if ([self.notifActivityDetailsArray count]) {
        
        [activitiesArray addObject:self.notifActivityDetailsArray];
        
    }
    
    //    for (int i =0; i<[customHeaderDetailsArray count]; i++) {
    //        [[customHeaderDetailsArray objectAtIndex:i] replaceObjectAtIndex:3 withObject:[NSString stringWithString:[customTextFieldHeaderArray objectAtIndex:i]]];
    //    }
    //[self.customDamageDetailsArray addObjectsFromArray:self.customCauseDetailsArray];
    
    [self.notificationHeaderDetails setObject:self.customHeaderDetailsArray forKey:@"CFH"];
    
 
    [[DataBase sharedInstance] insertDataIntoNotificationHeader:self.notificationHeaderDetails withAttachments:self.attachmentArray withTransaction:self.causeCodeDetailsArray withActivityCodes:activitiesArray withTaskcodes:self.notifTaskCodesDetailsArray withInspectionResult:[NSMutableArray array] withNotifStatusCode:[NSMutableArray array]];


    [notificationUDID setString:[self.notificationHeaderDetails objectForKey:@"ID"]];
    
    [[DataBase sharedInstance] writToLogFile:[NSString stringWithFormat:@"Notification Created locally with ID : %@",[self.notificationHeaderDetails objectForKey:@"ID"]]];
    
    if ([[ConnectionManager defaultManager] isConnectionQueueIsActive]) {
        [[ConnectionManager defaultManager] stopCurrentConnetion];
    }
    
    [self.notificationHeaderDetails setObject:self.attachmentArray forKey:@"ATTACHMENTS"];
    
    [self.notificationHeaderDetails setObject:self.causeCodeDetailsArray forKey:@"ITEMS"];
    
    if (self.notifTaskCodesDetailsArray == nil) {
        self.notifTaskCodesDetailsArray = [NSMutableArray new];
    }
    
    [self.notificationHeaderDetails setObject:self.notifTaskCodesDetailsArray forKey:@"TASKS"];
    
    [self.notificationHeaderDetails setObject:self.notifActivityDetailsArray forKey:@"ACTIVITIES"];


    //[self.notificationHeaderDetails setObject:self.customDamageDetailsArray forKey:@"CUSTOMTRANSACTIONFIELDS"];
    //[self.notificationHeaderDetails setObject:self.customCauseDetailsArray forKey:@"CUSTOMCAUSEFIELDS"];
    
    if([[ConnectionManager defaultManager] isReachable])
    {
        NSMutableDictionary *endPointDictionary = [NSMutableDictionary new];
        [endPointDictionary setObject:@"I" forKey:@"ACTIVITY"];
        [endPointDictionary setObject:@"Q" forKey:@"DOCTYPE"];
        [endPointDictionary setObject:[defaults objectForKey:@"ENDPOINT"] forKey:@"ENDPOINT"];
        
        NSArray *endPointArray = [[DataBase sharedInstance] getEndPointURL:endPointDictionary];
        
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"CSRF"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        if ([endPointArray count]) {
            NSLog(@"endPoint :%@",[[endPointArray objectAtIndex:0] objectAtIndex:0]);
            [self.notificationHeaderDetails setObject:[[endPointArray objectAtIndex:0] objectAtIndex:0] forKey:@"URL_ENDPOINT"];
        }
        else{
            
            [self showAlertMessageWithTitle:@"Failed" message:@"Failed to reach server" cancelButtonTitle:@"Ok" withactionType:@"Single" forMethod:nil];
        }
       
        
        [Request makeWebServiceRequest:NOTIFICATION_CREATE parameters:self.notificationHeaderDetails delegate:self];
    }
    else
    {
       // [ActivityView dismiss];
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
 
        if ([[defaults objectForKey:@"ACTIVATELOGS"] isEqualToString:@"X"])
        {
            [[DataBase sharedInstance] writToLogFile:[NSString stringWithFormat:@"#INFO#.com.enstrapp.fieldtekpro#Notif #Activity:Create Notification #Mode:Offline #Class:Very Important #MUser:%@ #DeviceId:%@",decryptedUserName,[defaults objectForKey:@"edeviceid"]]];
        }
        
 
        [self.navigationController popToRootViewControllerAnimated:YES];
        
       // [self resetAllValues];
        
    }
    
    return;
}

-(void)insertChangeNotifications{
    
    self.notificationHeaderDetails = [[NSMutableDictionary alloc] init];
    
    [self.notificationHeaderDetails setObject:[[[self.detailNotificationArray objectAtIndex:0] objectForKey:@"notificationh_id"] copy] forKey:@"ID"];
    
    [self.notificationHeaderDetails setObject:[[[headerDataArray objectAtIndex:0] objectAtIndex:3]  copy] forKey:@"NID"];
    
    [self.notificationHeaderDetails setObject:[[[headerDataArray objectAtIndex:0] objectAtIndex:2]  copy] forKey:@"NNAME"];
    
    [self.notificationHeaderDetails setObject:[[headerDataArray objectAtIndex:1] objectAtIndex:2] forKey:@"SHORTTEXT"];
    
    
     if (res_obj.longTextString.length) {
        
        [self.notificationHeaderDetails setObject:res_obj.longTextString forKey:@"LONGTEXT"];
     }
    
     else{
         [self.notificationHeaderDetails setObject:[[self .detailNotificationArray objectAtIndex:0] objectForKey:@"notificationh_longtext"] forKey:@"LONGTEXT"];
      }
    
    
    if (notificationNoString.length) {
        [self.notificationHeaderDetails setObject:[notificationNoString copy] forKey:@"OBJECTID"];
    }
    
    if ([NullChecker isNull:functionalLocationID]) {
        
        functionalLocationID = [[[headerDataArray objectAtIndex:4] objectAtIndex:3]  copy];
    }
    
    [self.notificationHeaderDetails setObject:[functionalLocationID copy] forKey:@"FID"];
    [self.notificationHeaderDetails setObject:[[[headerDataArray objectAtIndex:4] objectAtIndex:2]  copy] forKey:@"FNAME"];
    
 
    if (equipmentFlag==NO)
    {
         if([NullChecker isNull:equipmentID])
        {
            equipmentID = [[[headerDataArray objectAtIndex:5] objectAtIndex:3]  copy];
        }
    }
    
    [self.notificationHeaderDetails setObject:[equipmentID copy] forKey:@"EQID"];
    
    [self.notificationHeaderDetails setObject:[[[headerDataArray objectAtIndex:5] objectAtIndex:2]  copy] forKey:@"EQNAME"];
    
    [self.notificationHeaderDetails setObject:[[[headerDataArray objectAtIndex:7] objectAtIndex:3] copy] forKey:@"NPID"];
    
    [self.notificationHeaderDetails setObject:[[headerDataArray objectAtIndex:7] objectAtIndex:2] forKey:@"NPNAME"];
    
    [self.notificationHeaderDetails setObject:@"" forKey:@"PLANNERGROUP"];
    
    
    if (plannerGrouplID.length) {
        
        [self.notificationHeaderDetails setObject:plannerGrouplID forKey:@"PLANNERGROUP"];
        
    }
    
    [self.notificationHeaderDetails setObject:@"" forKey:@"PLANNERGROUPNAME"];
    
    if (plannerGroupNameString.length) {
        [self.notificationHeaderDetails setObject:plannerGroupNameString forKey:@"PLANNERGROUPNAME"];
        
    }
    
     [self.notificationHeaderDetails setObject:[[headerDataArray objectAtIndex:9] objectAtIndex:2] forKey:@"NREPORTEDBY"];
    
    [self.notificationHeaderDetails setObject:[decryptedUserName copy] forKey:@"REPORTEDBY"];
    
    [self.notificationHeaderDetails setObject:@"" forKey:@"USR01"];
    
    
    if (primaryPersonResonsibleID.length) {
        
        [self.notificationHeaderDetails setObject:primaryPersonResonsibleID forKey:@"USR01"];
        
    }
    
    [self.notificationHeaderDetails setObject:@"" forKey:@"USR02"];
    
    
    if (primaryPersonResonsibleNameString.length) {
        
        [self.notificationHeaderDetails setObject:primaryPersonResonsibleNameString forKey:@"USR02"];
    }
    
    
    [self.notificationHeaderDetails setObject:@"" forKey:@"PARNRID"];
    
    if (personResponisbleID.length) {
        
        [self.notificationHeaderDetails setObject:personResponisbleID forKey:@"PARNRID"];
        
    }
    
    [self.notificationHeaderDetails setObject:@"" forKey:@"PARNRTEXT"];
    
    
    if (personresponsibleNameString.length) {
        
        [self.notificationHeaderDetails setObject:personresponsibleNameString forKey:@"PARNRTEXT"];
        
    }
    
    [self.notificationHeaderDetails setObject:@"OSNO" forKey:@"NSTATUS"];
    
    
    if ([self.attachmentArray count]) {
        [self.notificationHeaderDetails setObject:@"X" forKey:@"DOCS"];
    }
    else{
        [self.notificationHeaderDetails setObject:@"" forKey:@"DOCS"];
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMM dd, yyyy hh:mm a"];
    
    
    NSDate *requiredstartDate = [dateFormatter dateFromString:[[headerDataArray objectAtIndex:12] objectAtIndex:2]];
    NSDate *requiredendDate = [dateFormatter dateFromString:[[headerDataArray objectAtIndex:13] objectAtIndex:2]];
    NSDate *startDate = [dateFormatter dateFromString:[[headerDataArray objectAtIndex:14] objectAtIndex:2]];
    NSDate *endDate = [dateFormatter dateFromString:[[headerDataArray objectAtIndex:15] objectAtIndex:2]];
    // Convert date object into desired format
    [dateFormatter setDateFormat:@"yyyyMMdd HHmmss"];

    NSString *convertedrequiredStartDateString = [dateFormatter stringFromDate:requiredstartDate];
    
    if ([NullChecker isNull:convertedrequiredStartDateString]) {
        convertedrequiredStartDateString = @"";
    }
    
    NSString *convertedrequiredEndDateString = [dateFormatter stringFromDate:requiredendDate];
    if ([NullChecker isNull:convertedrequiredEndDateString]) {
        convertedrequiredEndDateString = @"";
    }
    
    NSString *convertedStartDateString = [dateFormatter stringFromDate:startDate];
    if ([NullChecker isNull:convertedStartDateString]) {
        convertedStartDateString = @"";
    }
    
    NSString *convertedEndDateString = [dateFormatter stringFromDate:endDate];
    if ([NullChecker isNull:convertedEndDateString]) {
        convertedEndDateString = @"";
    }
    
    [self.notificationHeaderDetails setObject:[NSString stringWithFormat:@"%@",convertedrequiredStartDateString] forKey:@"RSDATE"];
    [self.notificationHeaderDetails setObject:[NSString stringWithFormat:@"%@",convertedrequiredEndDateString] forKey:@"REDATE"];
    
    [self.notificationHeaderDetails setObject:[NSString stringWithFormat:@"%@",convertedStartDateString] forKey:@"SDATE"];
    [self.notificationHeaderDetails setObject:[NSString stringWithFormat:@"%@",convertedEndDateString] forKey:@"EDATE"];
    
    [self.notificationHeaderDetails setObject:@"" forKey:@"BREAKDOWN"];
    
    
    [self.notificationHeaderDetails setObject:@"" forKey:@"LATITUDE"];
    [self.notificationHeaderDetails setObject:@"" forKey:@"LONGITUDE"];
    [self.notificationHeaderDetails setObject:@"" forKey:@"ALTITUDE"];
    
    if (latitudesString.length) {
        [self.notificationHeaderDetails setObject:[latitudesString copy] forKey:@"LATITUDE"];
    }
    if (longitudesString.length) {
        [self.notificationHeaderDetails setObject:[longitudesString copy] forKey:@"LONGITUDE"];
    }
    if (altitudesString.length) {
        [self.notificationHeaderDetails setObject:[altitudesString copy] forKey:@"ALTITUDE"];
    }
    
    [self.notificationHeaderDetails setObject:@"" forKey:@"EFFECTID"];
    
    effectID=[[headerDataArray objectAtIndex:16] objectAtIndex:3];
    
    if (effectID.length) {
        [self.notificationHeaderDetails setObject:effectID forKey:@"EFFECTID"];
    }
    
    [self.notificationHeaderDetails setObject:@"" forKey:@"SHIFT"];
    
    [self.notificationHeaderDetails setObject:@"" forKey:@"NOOFPERSON"];
    
   // [self getAttachedDocuments];
    
    if(self.attachmentArray==nil)
    {
        self.attachmentArray=[NSMutableArray new];
    }
    
    if(notificationNoString.length)
    {
        [self.notificationHeaderDetails setObject:[notificationNoString copy] forKey:@"OBJECTID"];
    }
    
    [self.notificationHeaderDetails setObject:transmitTypeString forKey:@"TRANSMITTYPE"];
    
    [self.notificationHeaderDetails setObject:@"" forKey:@"AUFNR"];

    if (aufnrID.length) {
        
        [self.notificationHeaderDetails setObject:aufnrID forKey:@"AUFNR"];

    }
 
    [self.notificationHeaderDetails setObject:plantID forKey:@"PLANTID"];
    
    [self.notificationHeaderDetails setObject:@"" forKey:@"PLANTNAME"];
    
    [self.notificationHeaderDetails setObject:[[self.detailNotificationArray objectAtIndex:0] objectForKey:@"notificationh_workcenterid"] forKey:@"WORKCENTERID"];
    
    [self.notificationHeaderDetails setObject:[[self.detailNotificationArray objectAtIndex:0] objectForKey:@"notificationh_workcentername"] forKey:@"WORKCENTERNAME"];
    
 
    [self.causeCodeDetailsArray addObjectsFromArray:self.causeCodeDetailDeleteArray];
    [self.notifTaskCodesDetailsArray addObjectsFromArray:self.taskCodesDeleteDetailsArray];
    
    if (!notificationNoString.length) {
        [[DataBase sharedInstance] deleteRecordinNotificationForUUID:notificationUDID ObjectcID:@"" ReportedBY:decryptedUserName];
    }
    
    [self.notificationHeaderDetails setObject:self.customHeaderDetailsArray forKey:@"CFH"];
    
    [self.notificationHeaderDetails setObject:@"" forKey:@"TRANSMITTYPE"];
    
    //    [self.notificationHeaderDetails setObject:equipHistoryArray forKey:@"EQUIPMENTHISTORY"];
    //    if([[ConnectionManager defaultManager] isReachable] && [[self.notificationHeaderDetails objectForKey:@"OBJECTID"] length]){
    //    }
    //    else if([[ConnectionManager defaultManager] isReachable]  && ![[self.notificationHeaderDetails objectForKey:@"OBJECTID"] length])
    //    {
    //
    //    }
    //    else{
    //        [self.notificationHeaderDetails setObject:@"Changed" forKey:@"NSTATUS"];
    //    }
    
    [self.notificationHeaderDetails setObject:@"" forKey:@"NSTATUS"];
    
    NSMutableArray * activitiesArray=[NSMutableArray new];
    
    if ([self.notifActivityDetailsArray count]) {
        
        [activitiesArray addObject:self.notifActivityDetailsArray];
        
    }
    
    [[DataBase sharedInstance] insertDataIntoNotificationHeader:self.notificationHeaderDetails withAttachments:self.attachmentArray withTransaction:self.causeCodeDetailsArray withActivityCodes:activitiesArray withTaskcodes:self.notifTaskCodesDetailsArray withInspectionResult:[NSMutableArray array] withNotifStatusCode:[NSMutableArray array]];
    
    if ([[ConnectionManager defaultManager] isConnectionQueueIsActive]) {
        [[ConnectionManager defaultManager] stopCurrentConnetion];
    }
    if (self.notifTaskCodesDetailsArray == nil) {
        self.notifTaskCodesDetailsArray = [NSMutableArray new];
    }
    [self.notificationHeaderDetails setObject:self.causeCodeDetailsArray forKey:@"ITEMS"];
    [self.notificationHeaderDetails setObject:self.attachmentArray forKey:@"ATTACHMENTS"];
    [self.notificationHeaderDetails setObject:self.notifTaskCodesDetailsArray forKey:@"TASKS"];
    
    [self.notificationHeaderDetails setObject:self.notifActivityDetailsArray forKey:@"ACTIVITIES"];
    
    if([[ConnectionManager defaultManager] isReachable] && [[self.notificationHeaderDetails objectForKey:@"OBJECTID"] length])
    {
        NSMutableDictionary *endPointDictionary = [NSMutableDictionary new];
        [endPointDictionary setObject:@"U" forKey:@"ACTIVITY"];
        [endPointDictionary setObject:@"Q" forKey:@"DOCTYPE"];
        [endPointDictionary setObject:[defaults objectForKey:@"ENDPOINT"] forKey:@"ENDPOINT"];
        NSArray *endPointArray = [[DataBase sharedInstance] getEndPointURL:endPointDictionary];
        
        [self.notificationHeaderDetails setObject:[[endPointArray objectAtIndex:0] objectAtIndex:0] forKey:@"URL_ENDPOINT"];
        
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"CSRF"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [Request makeWebServiceRequest:NOTIFICATION_CHANGE parameters:self.notificationHeaderDetails delegate:self];
    }
    else if([[ConnectionManager defaultManager] isReachable]  && ![[self.notificationHeaderDetails objectForKey:@"OBJECTID"] length])
    {
        NSMutableDictionary *endPointDictionary = [NSMutableDictionary new];
        [endPointDictionary setObject:@"I" forKey:@"ACTIVITY"];
        [endPointDictionary setObject:@"Q" forKey:@"DOCTYPE"];
        [endPointDictionary setObject:[defaults objectForKey:@"ENDPOINT"] forKey:@"ENDPOINT"];
        NSArray *endPointArray = [[DataBase sharedInstance] getEndPointURL:endPointDictionary];
        NSLog(@"endPoint :%@",[[endPointArray objectAtIndex:0] objectAtIndex:0]);
        [self.notificationHeaderDetails setObject:[[endPointArray objectAtIndex:0] objectAtIndex:0] forKey:@"URL_ENDPOINT"];
        
        [Request makeWebServiceRequest:NOTIFICATION_CREATE parameters:self.notificationHeaderDetails delegate:self];
    }
    else
    {
        [[DataBase sharedInstance] updateNotificationStatus:notificationUDID :@"Changed"];
        
        if ([[defaults objectForKey:@"ACTIVATELOGS"] isEqualToString:@"X"])
        {
            [[DataBase sharedInstance] writToLogFile:[NSString stringWithFormat:@"#INFO#.com.enstrapp.fieldtekpro#Notif #Notifno:%@ #Activity:Change Notification #Mode:Offline #Class: Very Important #MUser:%@ #DeviceId:%@",notificationNoString,decryptedUserName,[defaults objectForKey:@"edeviceid"]]];
        }
        
        [self.navigationController popViewControllerAnimated:YES];
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
     }
  }

-(void)activityDetailsMethod{
 
    NSMutableDictionary *activityDetailsDictionary = [NSMutableDictionary new];
    
    [activityDetailsDictionary setObject:[notificationUDID copy] forKey:@"ID"];
    [activityDetailsDictionary setObject:[vornrItemID copy] forKey:@"ITEMKEY"];
 
    [activityDetailsDictionary setObject:[[[addActivityArray objectAtIndex:1] objectAtIndex:3] copy] forKey:@"OBJECTPART"];
    
    [activityDetailsDictionary setObject:[[[addActivityArray objectAtIndex:2] objectAtIndex:3] copy] forKey:@"DAMAGE CODE"];
    
    if (activityCodegroupString.length) {
         [activityDetailsDictionary setObject:activityCodegroupString forKey:@"CODEGROUP"];
     }
    else{
        [activityDetailsDictionary setObject:[[addActivityArray objectAtIndex:3] objectAtIndex:3] forKey:@"CODEGROUP"];
     }
    
    if (activityCodeString.length) {
        [activityDetailsDictionary setObject:activityCodeString forKey:@"CODE"];
    }
    else{
        [activityDetailsDictionary setObject:[[addActivityArray objectAtIndex:4] objectAtIndex:3] forKey:@"CODE"];
    }
    
    [activityDetailsDictionary setObject:[[addActivityArray objectAtIndex:5] objectAtIndex:3] forKey:@"TEXT"];
    [activityDetailsDictionary setObject:[[addActivityArray objectAtIndex:6] objectAtIndex:3] forKey:@"STARTDATE"];
    [activityDetailsDictionary setObject:[[addActivityArray objectAtIndex:7] objectAtIndex:3] forKey:@"ENDDATE"];
    [activityDetailsDictionary setObject:[[addActivityArray objectAtIndex:8] objectAtIndex:3] forKey:@"STARTTIME"];
    [activityDetailsDictionary setObject:[[addActivityArray objectAtIndex:9] objectAtIndex:3] forKey:@"ENDTIME"];

    [activityDetailsDictionary setObject:[vornrItemID copy] forKey:@"ACTIVITYITEMKEY"];

 }

-(void)addCauseCodeDetailsMethod{
    
    submitResetView.hidden=NO;
 
    NSMutableDictionary *causeCodeDetailsDictionary = [NSMutableDictionary new];
 
    if ([self.detailNotificationArray count]) {
 
        [causeCodeDetailsDictionary setObject:[[[self.detailNotificationArray objectAtIndex:0] objectForKey:@"notificationh_id"] copy] forKey:@"ID"];
     }
     else{
        
        [causeCodeDetailsDictionary setObject:[notificationUDID copy] forKey:@"ID"];
     }
    
    
    [causeCodeDetailsDictionary setObject:[vornrItemID copy] forKey:@"ITEMKEY"];
    [causeCodeDetailsDictionary setObject:[vornrCauseCodeID copy] forKey:@"CAUSEKEY"];
 
    [self.itemKeyDetailsArray addObject:[NSMutableArray arrayWithObjects:vornrItemID,@"", nil]];
 
    [causeCodeDetailsDictionary setObject:[[[addCauseCodeDataArray objectAtIndex:2] objectAtIndex:3] copy] forKey:@"DAMAGEID"];
    
    [causeCodeDetailsDictionary setObject:[[[addCauseCodeDataArray objectAtIndex:2] objectAtIndex:2] copy] forKey:@"DAMAGETEXT"];
    
    [causeCodeDetailsDictionary setObject:[[[addCauseCodeDataArray objectAtIndex:3]  objectAtIndex:3] copy] forKey:@"DAMAGECODEID"];
 
     [causeCodeDetailsDictionary setObject:[[[addCauseCodeDataArray objectAtIndex:2] objectAtIndex:2] copy] forKey:@"DAMAGECODETEXT"];
    
    damageCodeIdString=[[[addCauseCodeDataArray objectAtIndex:3]  objectAtIndex:3] copy];
 
    damageNameString=[[[addCauseCodeDataArray objectAtIndex:2] objectAtIndex:2] copy];
    
    
    [causeCodeDetailsDictionary setObject:[[[addCauseCodeDataArray objectAtIndex:4] objectAtIndex:2] copy] forKey:@"DAMAGEDESCRIPTION"];
    
    [causeCodeDetailsDictionary setObject:[[[addCauseCodeDataArray objectAtIndex:0] objectAtIndex:3] copy] forKey:@"OBJECTPARTGROUPID"];
    
    [causeCodeDetailsDictionary setObject:[[[addCauseCodeDataArray objectAtIndex:1] objectAtIndex:3] copy] forKey:@"OBJECTPARTID"];
    
    objectPartIDString=[[[addCauseCodeDataArray objectAtIndex:1]  objectAtIndex:3] copy];
    
    objectPartNameString=[[[addCauseCodeDataArray objectAtIndex:1] objectAtIndex:2] copy];
    
    
    [causeCodeDetailsDictionary setObject:[[[addCauseCodeDataArray objectAtIndex:0] objectAtIndex:2] copy] forKey:@"OBJECTPARTGROUPTEXT"];
    
    [causeCodeDetailsDictionary setObject:[[[addCauseCodeDataArray objectAtIndex:1] objectAtIndex:2] copy] forKey:@"OBJECTPARTTEXT"];
    
    [causeCodeDetailsDictionary setObject:@"A" forKey:@"ITEMSTATUS"];
    
   // [causeCodeDetailsDictionary setObject:@"" forKey:@"CAUSEKEY"];
    
    [causeCodeDetailsDictionary setObject:[[[addCauseCodeDataArray objectAtIndex:5] objectAtIndex:3] copy] forKey:@"CAUSEID"];
    
    [causeCodeDetailsDictionary setObject:[[[addCauseCodeDataArray objectAtIndex:5] objectAtIndex:2] copy] forKey:@"CAUSETEXT"];
    
    [causeCodeDetailsDictionary setObject:[[[addCauseCodeDataArray objectAtIndex:6] objectAtIndex:3] copy] forKey:@"CAUSECODEID"];
    
    [causeCodeDetailsDictionary setObject:[[[addCauseCodeDataArray objectAtIndex:6] objectAtIndex:2] copy] forKey:@"CAUSECODETEXT"];
    
    [causeCodeDetailsDictionary setObject:[[[addCauseCodeDataArray objectAtIndex:7] objectAtIndex:2] copy] forKey:@"CAUSEDESCRIPTION"];
    
    [causeCodeDetailsDictionary setObject:@"A" forKey:@"CAUSESTATUS"];
    
    [causeCodeDetailsDictionary setObject:[NSArray arrayWithObjects:[defaults objectForKey:@"tempCustomDamage"],[defaults objectForKey:@"tempCustomCause"], nil]  forKey:@"CUSTOM"];
    
    [[DataBase sharedInstance] insertNotificationTransactions:causeCodeDetailsDictionary];
    [self.causeCodeDetailsArray removeAllObjects];
    
     if ([self.detailNotificationArray count]) {
        
        [self.causeCodeDetailsArray addObjectsFromArray:[[DataBase sharedInstance] fetchNotificationTransactionDetailsForUUID:[[self.detailNotificationArray objectAtIndex:0] objectForKey:@"notificationh_id"]]];

    }
    else{
 
        [self.causeCodeDetailsArray addObjectsFromArray:[[DataBase sharedInstance] fetchNotificationTransactionDetailsForUUID:[notificationUDID copy]]];

    }
    
    
    /*  NSMutableArray *tempCauseCodeDetailsArray= [NSMutableArray new];
     
     [tempCauseCodeDetailsArray addObjectsFromArray:[NSArray arrayWithObjects:@"",[notificationUDID copy],[damageID copy],[damageTextField.text copy],[damageCodeID copy],[damageCodeTextField.text copy],[causeID copy],[causeTextField.text copy],[causeCodeID copy],[causeCodeTextField.text copy],[damageDescriptionTextField.text copy],[causeDescriptionTextField.text copy],[vornrItemID copy],@"",@"A",@"A", nil]];
     
     [self.causeCodeDetailsArray addObject:[NSMutableArray arrayWithObjects:tempCauseCodeDetailsArray,[defaults objectForKey:@"tempCustomDamage"],[defaults objectForKey:@"tempCustomCause"], nil]];*/
    
    clearCuaseFields=YES;
    
    [[addCauseCodeDataArray objectAtIndex:2] replaceObjectAtIndex:2 withObject:@""];
    [[addCauseCodeDataArray objectAtIndex:2] replaceObjectAtIndex:3 withObject:@""];
    
    [[addCauseCodeDataArray objectAtIndex:3] replaceObjectAtIndex:2 withObject:@""];
    [[addCauseCodeDataArray objectAtIndex:3] replaceObjectAtIndex:3 withObject:@""];
    
    [[addCauseCodeDataArray objectAtIndex:4] replaceObjectAtIndex:2 withObject:@""];
 
    
    commonAddTableView.tag=0;
    [commonAddTableView reloadData];
    
    
    VornrItem = 0;
    VornrCauseCode = 1;
    
    for (int i=0; i<[self.causeCodeDetailsArray count]; i++) {
        
        vornrItemID = [[[self.causeCodeDetailsArray  objectAtIndex:i] firstObject]  objectAtIndex:12];
    }
    
    VornrItem = [vornrItemID intValue];
    
    VornrItem = VornrItem +1;
    
    VornrCauseCode = 1;
    
    vornrCauseCodeID = @"";
    
  //  [self causecodesDisabling];
    
    for (int  i =0; i<[self.customDamageDetailsArray count]; i++) {
        
        [[self.customDamageDetailsArray objectAtIndex:i] replaceObjectAtIndex:4 withObject:@""];
    }
    
    for (int  i =0; i<[self.customCauseDetailsArray count]; i++) {
        [[self.customCauseDetailsArray  objectAtIndex:i] replaceObjectAtIndex:4 withObject:@""];
    }
    
    [defaults setObject:self.customDamageDetailsArray forKey:@"tempCustomDamage"];
    [defaults setObject:self.customCauseDetailsArray forKey:@"tempCustomCause"];
    [defaults synchronize];
    
//    [self.addCauseCodeView removeFromSuperview];
//
//
//    causeTextField.text=@"";
//    causeCodeTextField.text=@"";
//    causeDescriptionTextField.text=@"";
//
    for (int i=0; i<[self.causeCodeDetailsArray count]; i++) {
        
        if ([[[[self.causeCodeDetailsArray objectAtIndex:i] firstObject] objectAtIndex:14] isEqualToString:@"D"]){
            [self.causeCodeDetailDeleteArray addObject:[NSMutableArray arrayWithArray:[self.causeCodeDetailsArray objectAtIndex:i]]];
            [self.causeCodeDetailsArray removeObjectAtIndex:i];
            --i;
        }
    }
    
    [addCauseTaskView removeFromSuperview];
    
    commomlistListTableview.tag=1;
    [commomlistListTableview reloadData];
 
  }

-(void)addMoreCauseCodeDetailsMethod{
    
    submitResetView.hidden=YES;
    
    NSMutableDictionary *causeCodeDetailsDictionary = [NSMutableDictionary new];
    
    [causeCodeDetailsDictionary setObject:[notificationUDID copy] forKey:@"ID"];
    
    [causeCodeDetailsDictionary setObject:[vornrItemID copy] forKey:@"ITEMKEY"];
    [causeCodeDetailsDictionary setObject:[vornrCauseCodeID copy] forKey:@"CAUSEKEY"];
 
    [causeCodeDetailsDictionary setObject:[[[addCauseCodeDataArray objectAtIndex:2] objectAtIndex:3] copy] forKey:@"DAMAGEID"];
    [causeCodeDetailsDictionary setObject:[[[addCauseCodeDataArray objectAtIndex:2] objectAtIndex:2] copy] forKey:@"DAMAGETEXT"];
    
    [causeCodeDetailsDictionary setObject:[[[addCauseCodeDataArray objectAtIndex:3]  objectAtIndex:3] copy] forKey:@"DAMAGECODEID"];
    
    [causeCodeDetailsDictionary setObject:[[[addCauseCodeDataArray objectAtIndex:2] objectAtIndex:2] copy] forKey:@"DAMAGECODETEXT"];
    
    [causeCodeDetailsDictionary setObject:[[[addCauseCodeDataArray objectAtIndex:4] objectAtIndex:2] copy] forKey:@"DAMAGEDESCRIPTION"];
    
    [causeCodeDetailsDictionary setObject:[[[addCauseCodeDataArray objectAtIndex:0] objectAtIndex:3] copy] forKey:@"OBJECTPARTGROUPID"];
    
    [causeCodeDetailsDictionary setObject:[[[addCauseCodeDataArray objectAtIndex:1] objectAtIndex:3] copy] forKey:@"OBJECTPARTID"];
    
    [causeCodeDetailsDictionary setObject:[[[addCauseCodeDataArray objectAtIndex:0] objectAtIndex:2] copy] forKey:@"OBJECTPARTGROUPTEXT"];
    
    [causeCodeDetailsDictionary setObject:[[[addCauseCodeDataArray objectAtIndex:1] objectAtIndex:2] copy] forKey:@"OBJECTPARTTEXT"];
    
    [causeCodeDetailsDictionary setObject:@"A" forKey:@"ITEMSTATUS"];
    
 
    [causeCodeDetailsDictionary setObject:[[[addCauseCodeDataArray objectAtIndex:5] objectAtIndex:3] copy] forKey:@"CAUSEID"];
    
    [causeCodeDetailsDictionary setObject:[[[addCauseCodeDataArray objectAtIndex:5] objectAtIndex:2] copy] forKey:@"CAUSETEXT"];
    
    [causeCodeDetailsDictionary setObject:[[[addCauseCodeDataArray objectAtIndex:6] objectAtIndex:3] copy] forKey:@"CAUSECODEID"];
    
    [causeCodeDetailsDictionary setObject:[[[addCauseCodeDataArray objectAtIndex:6] objectAtIndex:2] copy] forKey:@"CAUSECODETEXT"];
    
    [causeCodeDetailsDictionary setObject:[[[addCauseCodeDataArray objectAtIndex:7] objectAtIndex:2] copy] forKey:@"CAUSEDESCRIPTION"];
    
    [causeCodeDetailsDictionary setObject:@"A" forKey:@"CAUSESTATUS"];
    
    [causeCodeDetailsDictionary setObject:[NSArray arrayWithObjects:[defaults objectForKey:@"tempCustomDamage"],[defaults objectForKey:@"tempCustomCause"], nil]  forKey:@"CUSTOM"];
    
    [[DataBase sharedInstance] insertNotificationTransactions:causeCodeDetailsDictionary];
    
    [self.causeCodeDetailsArray removeAllObjects];
    
    [self.causeCodeDetailsArray addObjectsFromArray:[[DataBase sharedInstance] fetchNotificationTransactionDetailsForUUID:notificationUDID]];
    
    [[addCauseCodeDataArray objectAtIndex:2] replaceObjectAtIndex:2 withObject:@""];
    [[addCauseCodeDataArray objectAtIndex:2] replaceObjectAtIndex:3 withObject:@""];
    
    [[addCauseCodeDataArray objectAtIndex:3] replaceObjectAtIndex:2 withObject:@""];
    [[addCauseCodeDataArray objectAtIndex:4] replaceObjectAtIndex:3 withObject:@""];
    
    [[addCauseCodeDataArray objectAtIndex:5] replaceObjectAtIndex:2 withObject:@""];

  
    
//    damageTextField.userInteractionEnabled = NO;
//    damageCodeTextField.userInteractionEnabled = NO;
//    damageDescriptionTextField.userInteractionEnabled = NO;
    
    VornrCauseCode = VornrCauseCode+1;
    
    for (int  i =0; i<[self.customCauseDetailsArray count]; i++) {
        [[self.customCauseDetailsArray objectAtIndex:i] replaceObjectAtIndex:4 withObject:@""];
    }
    
    [defaults setObject:self.customCauseDetailsArray forKey:@"tempCustomCause"];
    [defaults synchronize];
    
    
    for (int i=0; i<[self.causeCodeDetailsArray count]; i++) {
        
        if ([[[[self.causeCodeDetailsArray objectAtIndex:i] firstObject] objectAtIndex:14] isEqualToString:@"D"]){
            [self.causeCodeDetailDeleteArray addObject:[NSMutableArray arrayWithArray:[self.causeCodeDetailsArray objectAtIndex:i]]];
            [self.causeCodeDetailsArray removeObjectAtIndex:i];
            --i;
        }
    }
    
 
    commomlistListTableview.tag=1;
    [commomlistListTableview reloadData];
    
    
}

#pragma mark-
#pragma mark- UIPicker Table View Method

-(void)uiPickerTableViewForDropDownSelection{
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        self.dropDownTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 50, 250, 200)];
    }
    else
    {
        self.dropDownTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 50, 250, 300)];
    }
    
    self.dropDownTableView.delegate=self;
    self.dropDownTableView.dataSource=self;
    
    // Create done button in UIPickerView
    
    self.mypickerToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 100, 320, 56)];
    
    self.mypickerToolbar.barStyle = UIBarStyleBlackOpaque;
    
    [self.mypickerToolbar sizeToFit];
    
    NSMutableArray *barItems = [[NSMutableArray alloc] init];
    
    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    [barItems addObject:flexSpace];
    
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(pickerTableViewCancelClicked)];
    
    [barItems addObject:doneBtn];
    
    [self.mypickerToolbar setItems:barItems animated:YES];
}

-(void)pickerTableViewCancelClicked{
    
    [commomlistListTableview endEditing:YES];
    
}


 -(void)datePickerForMalFuncStartDate{
    
    self.startMalFunctionDatePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, 250, 0, 0)];
 
    self.startMalFunctionDatePicker.datePickerMode = UIDatePickerModeDate;
 
    myDatePickerToolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 100, 320, 56)];
    
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
 
}

-(void)datePickerForMalFuncEndDate{
    
    self.EndMalFunctionDatePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, 250, 0, 0)];
    
    self.EndMalFunctionDatePicker.datePickerMode = UIDatePickerModeDateAndTime;
    
//    malFunctionEndDateTextField.inputView =self.EndMalFunctionDatePicker;
//
//    requiredEndDateTextField.inputView =self.EndMalFunctionDatePicker;
//
//    plannedFinishDateTextfield.inputView =self.EndMalFunctionDatePicker;
    
    myDatePickerToolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 100, 320, 56)];
    
    myDatePickerToolBar.barStyle = UIBarStyleBlackOpaque;
    
    [myDatePickerToolBar sizeToFit];
    
    NSMutableArray *barItems = [[NSMutableArray alloc] init];
    
    UIBarButtonItem *cnclBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(pickerCancelClicked)];
    
    [barItems addObject:cnclBtn];
    
    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    [barItems addObject:flexSpace];
    
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(pickerDoneEndDateClicked)];
    
    [barItems addObject:doneBtn];
    
    [myDatePickerToolBar setItems:barItems animated:YES];
 
    
}

-(void)pickerDoneStartDateClicked
{
 
    self.minStartDate =[self.startMalFunctionDatePicker date];

    if (commomlistListTableview.tag==0) {
        
        if (!createNotificationFlag) {
            
            if (headerCommonIndex == 12) {
                
                NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
                [dateFormat setDateFormat:@"MMM dd, yyyy hh:mm a"];
                
                [[headerDataArray objectAtIndex:12] replaceObjectAtIndex:2 withObject:[dateFormat stringFromDate:self.minStartDate]];
                
                if (![[[headerDataArray objectAtIndex:13] objectAtIndex:2] isEqual:@""]) {
                    requireddateFlag = YES;
                    
                    self.minEndDate = [dateFormat dateFromString:[[headerDataArray objectAtIndex:13] objectAtIndex:2]];
                    
                    NSInteger comparisionResult = [AppDelegate daysBetweenDate:self.minStartDate andDate:self.minEndDate];
                    
                    NSLog(@"%i",(int)comparisionResult);
                    NSString *comparisionString = [NSString stringWithFormat:@"%i",(int)comparisionResult];
                    if ([[comparisionString substringToIndex:1] isEqualToString:@"-"])
                    {
                        
                        [[headerDataArray objectAtIndex:12] replaceObjectAtIndex:2 withObject:[dateFormat stringFromDate:self.minStartDate]];
                        
                        [self showAlertMessageWithTitle:@"Alert" message:@"Required Start Date has to be earlier than Required End Date" cancelButtonTitle:@"ok" withactionType:@"Single" forMethod:nil];
                        
                    }
                }
            }
            
            else if (headerCommonIndex==13){
                
                self.minEndDate =[self.startMalFunctionDatePicker date];
                
                NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
                [dateFormat setDateFormat:@"MMM dd, yyyy hh:mm a"];
                
                [[headerDataArray objectAtIndex:13] replaceObjectAtIndex:2 withObject:[dateFormat stringFromDate:self.minEndDate]];
                
                if (![[[headerDataArray objectAtIndex:12] objectAtIndex:2] isEqual:@""]) {
                    
                    requireddateFlag = NO;
                    self.minStartDate = [dateFormat dateFromString:[[headerDataArray objectAtIndex:12] objectAtIndex:2]];
                    
                    NSInteger comparisionResult = [AppDelegate daysBetweenDate:self.minStartDate andDate:self.minEndDate];
                    NSLog(@"%i",(int)comparisionResult);
                    NSString *comparisionString = [NSString stringWithFormat:@"%i",(int)comparisionResult];
                    if ([[comparisionString substringToIndex:1] isEqualToString:@"-"])
                    {
                        [[headerDataArray objectAtIndex:13] replaceObjectAtIndex:2 withObject:@""];
                        
                        [self showAlertMessageWithTitle:@"Alert" message:@"Required End Date has to be later than Required Start Date" cancelButtonTitle:@"Ok" withactionType:@"Single" forMethod:nil];
                        
                    }
                }
            }
            
            
            else if (headerCommonIndex==14){
                
                self.minStartDate =[self.startMalFunctionDatePicker date];
                
                NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
                [dateFormat setDateFormat:@"MMM dd, yyyy hh:mm a"];
                
                [[headerDataArray objectAtIndex:14] replaceObjectAtIndex:2 withObject:[dateFormat stringFromDate:self.minStartDate]];
                
                if (![[[headerDataArray objectAtIndex:15] objectAtIndex:2] isEqual:@""]) {
                    
                    requireddateFlag = NO;
                    self.minStartDate = [dateFormat dateFromString:[[headerDataArray objectAtIndex:15] objectAtIndex:2]];
                    
                    NSInteger comparisionResult = [AppDelegate daysBetweenDate:self.minStartDate andDate:self.minEndDate];
                    NSLog(@"%i",(int)comparisionResult);
                    NSString *comparisionString = [NSString stringWithFormat:@"%i",(int)comparisionResult];
                    
                    if ([[comparisionString substringToIndex:1] isEqualToString:@"-"])
                    {
                        [[headerDataArray objectAtIndex:14] replaceObjectAtIndex:2 withObject:@""];
                        
                        [self showAlertMessageWithTitle:@"Alert" message:@"Required End Date has to be later than Required Start Date" cancelButtonTitle:@"Ok" withactionType:@"Single" forMethod:nil];
                    }
                }
            }
            
            else if (headerCommonIndex==15){
                
                self.minEndDate =[self.startMalFunctionDatePicker date];
                
                NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
                [dateFormat setDateFormat:@"MMM dd, yyyy hh:mm a"];
                
                [[headerDataArray objectAtIndex:15] replaceObjectAtIndex:2 withObject:[dateFormat stringFromDate:self.minEndDate]];
                
                if (![[[headerDataArray objectAtIndex:14] objectAtIndex:2] isEqual:@""]) {
                    
                    requireddateFlag = NO;
                    self.minStartDate = [dateFormat dateFromString:[[headerDataArray objectAtIndex:14] objectAtIndex:2]];
                    
                    NSInteger comparisionResult = [AppDelegate daysBetweenDate:self.minStartDate andDate:self.minEndDate];
                    NSLog(@"%i",(int)comparisionResult);
                    NSString *comparisionString = [NSString stringWithFormat:@"%i",(int)comparisionResult];
                    if ([[comparisionString substringToIndex:1] isEqualToString:@"-"])
                    {
                        [[headerDataArray objectAtIndex:15] replaceObjectAtIndex:2 withObject:@""];
                        
                        [self showAlertMessageWithTitle:@"Alert" message:@"Required End Date has to be later than Required Start Date" cancelButtonTitle:@"Ok" withactionType:@"Single" forMethod:nil];
                        
                    }
                }
           }
 
        }
        
        else{
            
            if (headerCommonIndex == 10) {
                
                NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
                [dateFormat setDateFormat:@"MMM dd, yyyy hh:mm a"];
                
                [[headerDataArray objectAtIndex:10] replaceObjectAtIndex:2 withObject:[dateFormat stringFromDate:self.minStartDate]];
                
                if (![[[headerDataArray objectAtIndex:11] objectAtIndex:2] isEqual:@""]) {
                    requireddateFlag = YES;
                    
                    self.minEndDate = [dateFormat dateFromString:[[headerDataArray objectAtIndex:11] objectAtIndex:2]];
                    
                    NSInteger comparisionResult = [AppDelegate daysBetweenDate:self.minStartDate andDate:self.minEndDate];
                    
                    NSLog(@"%i",(int)comparisionResult);
                    NSString *comparisionString = [NSString stringWithFormat:@"%i",(int)comparisionResult];
                    if ([[comparisionString substringToIndex:1] isEqualToString:@"-"])
                    {
                        
                        [[headerDataArray objectAtIndex:10] replaceObjectAtIndex:2 withObject:[dateFormat stringFromDate:self.minStartDate]];
                        
                        [self showAlertMessageWithTitle:@"Alert" message:@"Required Start Date has to be earlier than Required End Date" cancelButtonTitle:@"ok" withactionType:@"Single" forMethod:nil];
                        
                    }
                }
            }
            
            else if (headerCommonIndex==11){
                
                self.minEndDate =[self.startMalFunctionDatePicker date];
                
                NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
                [dateFormat setDateFormat:@"MMM dd, yyyy hh:mm a"];
                
                [[headerDataArray objectAtIndex:11] replaceObjectAtIndex:2 withObject:[dateFormat stringFromDate:self.minEndDate]];
                
                if (![[[headerDataArray objectAtIndex:10] objectAtIndex:2] isEqual:@""]) {
                    
                    requireddateFlag = NO;
                    
                    self.minStartDate = [dateFormat dateFromString:[[headerDataArray objectAtIndex:10] objectAtIndex:2]];
                    
                    NSInteger comparisionResult = [AppDelegate daysBetweenDate:self.minStartDate andDate:self.minEndDate];
                    NSLog(@"%i",(int)comparisionResult);
                    NSString *comparisionString = [NSString stringWithFormat:@"%i",(int)comparisionResult];
                    if ([[comparisionString substringToIndex:1] isEqualToString:@"-"])
                    {
                        [[headerDataArray objectAtIndex:11] replaceObjectAtIndex:2 withObject:@""];
                        
                        [self showAlertMessageWithTitle:@"Alert" message:@"Required End Date has to be later than Required Start Date" cancelButtonTitle:@"Ok" withactionType:@"Single" forMethod:nil];
                        
                    }
                }
            }
            
            
            else if (headerCommonIndex==12){
                
                self.minStartDate =[self.startMalFunctionDatePicker date];
                
                NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
                [dateFormat setDateFormat:@"MMM dd, yyyy hh:mm a"];
                
                [[headerDataArray objectAtIndex:12] replaceObjectAtIndex:2 withObject:[dateFormat stringFromDate:self.minStartDate]];
                
                if (![[[headerDataArray objectAtIndex:13] objectAtIndex:2] isEqual:@""]) {
                    
                    requireddateFlag = NO;
                    
                    self.minStartDate = [dateFormat dateFromString:[[headerDataArray objectAtIndex:13] objectAtIndex:2]];
                    
                    NSInteger comparisionResult = [AppDelegate daysBetweenDate:self.minStartDate andDate:self.minEndDate];
                    NSLog(@"%i",(int)comparisionResult);
                    NSString *comparisionString = [NSString stringWithFormat:@"%i",(int)comparisionResult];
                    
                    if ([[comparisionString substringToIndex:1] isEqualToString:@"-"])
                    {
                        [[headerDataArray objectAtIndex:12] replaceObjectAtIndex:2 withObject:@""];
                        
                        [self showAlertMessageWithTitle:@"Alert" message:@"Required End Date has to be later than Required Start Date" cancelButtonTitle:@"Ok" withactionType:@"Single" forMethod:nil];
                    }
                }
            }
            
            else if (headerCommonIndex==13){
                
                self.minEndDate =[self.startMalFunctionDatePicker date];
                
                NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
                [dateFormat setDateFormat:@"MMM dd, yyyy hh:mm a"];
                
                [[headerDataArray objectAtIndex:13] replaceObjectAtIndex:2 withObject:[dateFormat stringFromDate:self.minEndDate]];
                
                if (![[[headerDataArray objectAtIndex:12] objectAtIndex:2] isEqual:@""]) {
                    
                    requireddateFlag = NO;
                    self.minStartDate = [dateFormat dateFromString:[[headerDataArray objectAtIndex:12] objectAtIndex:2]];
                    
                    NSInteger comparisionResult = [AppDelegate daysBetweenDate:self.minStartDate andDate:self.minEndDate];
                    NSLog(@"%i",(int)comparisionResult);
                    NSString *comparisionString = [NSString stringWithFormat:@"%i",(int)comparisionResult];
                    if ([[comparisionString substringToIndex:1] isEqualToString:@"-"])
                    {
                        [[headerDataArray objectAtIndex:13] replaceObjectAtIndex:2 withObject:@""];
                        
                        [self showAlertMessageWithTitle:@"Alert" message:@"Required End Date has to be later than Required Start Date" cancelButtonTitle:@"Ok" withactionType:@"Single" forMethod:nil];
                        
                     }
                }
             }
         }
 
        [commomlistListTableview reloadData];
        [commomlistListTableview endEditing:YES];
    }
    
    else if (commonAddTableView.tag==1){
        
        if (headerCommonIndex==5)
        {
            NSDateFormatter *taskDateFormat = [[NSDateFormatter alloc] init];
            [taskDateFormat setDateFormat:@"MMM dd, yyyy"];

           // plannedStartDateTextfield.text = [taskDateFormat stringFromDate:self.minStartDate];
 
             [[addTaskCodeDataArray objectAtIndex:5] replaceObjectAtIndex:2 withObject:[taskDateFormat stringFromDate:self.minStartDate]];

            if (![[[addTaskCodeDataArray objectAtIndex:6] objectAtIndex:2] isEqual:@""]) {
                
                requireddateFlag = YES;
                
                self.minEndDate = [taskDateFormat dateFromString:[[addTaskCodeDataArray objectAtIndex:6] objectAtIndex:2]];
                
                 NSInteger comparisionResult = [AppDelegate daysBetweenDate:self.minStartDate andDate:self.minEndDate];

                NSLog(@"%i",(int)comparisionResult);
                NSString *comparisionString = [NSString stringWithFormat:@"%i",(int)comparisionResult];
                if ([[comparisionString substringToIndex:1] isEqualToString:@"-"]) {
                   // plannedStartDateTextfield.text = @"";
                    
               [[addTaskCodeDataArray objectAtIndex:5] replaceObjectAtIndex:2 withObject:@""];
                    
              [self showAlertMessageWithTitle:@"Alert" message:@"Planned Start Date has to be earlier than Planned Finish Date" cancelButtonTitle:@"Ok" withactionType:@"Single" forMethod:nil];
 
                }
            }
        }
        else if (headerCommonIndex==6){

            NSDateFormatter *taskDateFormat = [[NSDateFormatter alloc] init];
            
            [taskDateFormat setDateFormat:@"MMM dd, yyyy"];
            
            [[addTaskCodeDataArray objectAtIndex:6] replaceObjectAtIndex:2 withObject:[taskDateFormat stringFromDate:self.minStartDate]];
            
           }
        
          [commonAddTableView reloadData];
          [commonAddTableView endEditing:YES];
       }
    else if (commonAddTableView.tag==2){
        
        if (headerCommonIndex==6) {
            
            NSDateFormatter *taskDateFormat = [[NSDateFormatter alloc] init];
             [taskDateFormat setDateFormat:@"MMM dd, yyyy"];
            
             [[addActivityArray objectAtIndex:6] replaceObjectAtIndex:2 withObject:[taskDateFormat stringFromDate:self.minStartDate]];
            
             [commonAddTableView reloadData];
             [commonAddTableView endEditing:YES];
            
         }
        else if (headerCommonIndex==7){
            
            NSDateFormatter *taskDateFormat = [[NSDateFormatter alloc] init];
            [taskDateFormat setDateFormat:@"MMM dd, yyyy"];
            
            [[addActivityArray objectAtIndex:7] replaceObjectAtIndex:2 withObject:[taskDateFormat stringFromDate:self.minStartDate]];
            
            [commonAddTableView reloadData];
            [commonAddTableView endEditing:YES];
        }
        else if (headerCommonIndex==8){
            
            NSDateFormatter *taskDateFormat = [[NSDateFormatter alloc] init];
            [taskDateFormat setDateFormat:@"HH:mm:ss"];
            
            [[addActivityArray objectAtIndex:8] replaceObjectAtIndex:2 withObject:[taskDateFormat stringFromDate:self.minStartDate]];
            
            [commonAddTableView reloadData];
            [commonAddTableView endEditing:YES];
        }
        else if (headerCommonIndex==9){
            
            NSDateFormatter *taskDateFormat = [[NSDateFormatter alloc] init];
            [taskDateFormat setDateFormat:@"HH:mm:ss"];
            
            [[addActivityArray objectAtIndex:9] replaceObjectAtIndex:2 withObject:[taskDateFormat stringFromDate:self.minStartDate]];
            
            [commonAddTableView reloadData];
            [commonAddTableView endEditing:YES];
        }
      
      }
        
  }

-(void)pickerDoneEndDateClicked
{
 
//    else if (headerCommonIndex==6)
//    {
//        NSDateFormatter *taskDateFormat = [[NSDateFormatter alloc] init];
//        [taskDateFormat setDateFormat:@"MMM dd, yyyy"];
//
//        plannedFinishDateTextfield.text = [taskDateFormat stringFromDate:self.minEndDate];
//
//        if (![plannedStartDateTextfield.text isEqual:@""]) {
//            requireddateFlag = YES;
//            self.minStartDate = [taskDateFormat dateFromString:plannedStartDateTextfield.text];
//
//            NSInteger comparisionResult = [AppDelegate daysBetweenDate:self.minStartDate andDate:self.minEndDate];
//
//            NSLog(@"%i",(int)comparisionResult);
//            NSString *comparisionString = [NSString stringWithFormat:@"%i",(int)comparisionResult];
//            if ([[comparisionString substringToIndex:1] isEqualToString:@"-"]) {
//                plannedFinishDateTextfield.text = @"";
//                UIAlertView *alertAscending = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Planned End Date has to be later than Planned Start  Date" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
//                [alertAscending show];
//            }
//        }
//
//    }
//    else{
//
//        malFunctionEndDateTextField.text = [dateFormat stringFromDate:self.minEndDate];
//
//        if (![malFunctionStartDateTextField.text isEqual:@""]) {
//            dateFlag = NO;
//            self.minStartDate = [dateFormat dateFromString:malFunctionStartDateTextField.text];
//
//            NSInteger comparisionResult = [AppDelegate daysBetweenDate:self.minStartDate andDate:self.minEndDate];
//            NSLog(@"%i",(int)comparisionResult);
//            NSString *comparisionString = [NSString stringWithFormat:@"%i",(int)comparisionResult];
//            if ([[comparisionString substringToIndex:1] isEqualToString:@"-"]) {
//                malFunctionEndDateTextField.text = @"";
//                UIAlertView *alertAscending = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"MalFunction End Date has to be later than MalFunction Start Date" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
//                [alertAscending show];
//            }
//        }
//    }
//
//    [commomlistListTableview reloadData];
    
}

-(void)pickerCancelClicked
{
    
//    if (tag == 1) {
//
//        if (requireddateFlag == YES)
//        {
//            requiredStartDateTextField.text = @"";
//        }
//        else if (requireddateFlag == NO)
//        {
//            requiredEndDateTextField.text = @"";
//        }
//    }
//    else if (tag==TASK_COMPLETION_DATE){
//
//        completionStartDateTextField.text=@"";
//    }
//    else{
//        if (dateFlag == YES) {
//            malFunctionStartDateTextField.text = @"";
//        }
//        else if (dateFlag == NO){
//            malFunctionEndDateTextField.text = @"";
//        }
//    }

     [commomlistListTableview reloadData];
    
}


-(void)loadChangeHeaderData
{
    
    headerDataArray=[NSMutableArray new];
    
    notificationUDID =[NSMutableString new];

    commomlistListTableview.tag=0;
    
    createNotificationFlag=NO;

 //   editBtnSelected=NO;
    
    transmitTypeString=@"";
    
    [notificationUDID setString:[[self.detailNotificationArray objectAtIndex:0] objectForKey:@"notificationh_id"]];
 
    notificationNoString=[[self.detailNotificationArray objectAtIndex:0] objectForKey:@"nh_objectID"];
    
    [headerDataArray addObject:[NSMutableArray arrayWithObjects:@"Notification Type",@"Select Notification Type",[[self.detailNotificationArray objectAtIndex:0]   objectForKey:@"notificationh_type_name"],[[self.detailNotificationArray objectAtIndex:0] objectForKey:@"notificationh_type_id"], nil]];
    
    [headerDataArray addObject:[NSMutableArray arrayWithObjects:@"Notification Text",@"Enter Notification text",[[self.detailNotificationArray objectAtIndex:0] objectForKey:@"notificationh_shorttext"],@"", nil]];
    
    [headerDataArray addObject:[NSMutableArray arrayWithObjects:@"Order No :",@"",[[self.detailNotificationArray objectAtIndex:0] objectForKey:@"notificationh_order_no"],@"", nil]];
    
    createOrderBtn.hidden=NO;

    if (![NullChecker isNull:[[self.detailNotificationArray objectAtIndex:0] objectForKey:@"notificationh_order_no"]]) {
        
        createOrderBtn.hidden=YES;
        
    }
    
    ////////
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSDate *tempNotifDate = [dateFormatter dateFromString:[[self.detailNotificationArray objectAtIndex:0] objectForKey:@"notificationh_qmdat"]];
    
    // Convert date object into desired format
    [dateFormatter setDateFormat:@"MMM dd, yyyy"];
    NSString *convertedNotifDateString = [dateFormatter stringFromDate:tempNotifDate];
    
    if ([NullChecker isNull:convertedNotifDateString]) {
        convertedNotifDateString = @"";
    }
 
    [headerDataArray addObject:[NSMutableArray arrayWithObjects:@"Notification Date :",@"",[NSString stringWithFormat:@"%@",convertedNotifDateString],@"", nil]];
 
    
     [headerDataArray addObject:[NSMutableArray arrayWithObjects:@"Function Location",@"Search or Enter Function Location ",[[self.detailNotificationArray objectAtIndex:0] objectForKey:@"notificationh_funcloc_name"],[[self.detailNotificationArray objectAtIndex:0] objectForKey:@"notificationh_funcloc_id"], nil]];
    
    [headerDataArray addObject:[NSMutableArray arrayWithObjects:@"Equipment Number",@"Search or Scan Equipment Number ",[[self.detailNotificationArray objectAtIndex:0] objectForKey:@"notificationh_equip_name"],[[self.detailNotificationArray objectAtIndex:0] objectForKey:@"notificationh_equip_id"], nil]];
    
    equipmentID=[[self.detailNotificationArray objectAtIndex:0] objectForKey:@"notificationh_equip_id"];
 
    NSArray *tempArray;
    
    if (equipmentID.length) {
        
        tempArray=[[DataBase sharedInstance] getiWerksForequipment:equipmentID];
        
     }
    
    catalogProfileID=[NSMutableString new];
    iwerkString=[NSMutableString new];
 
    if ([tempArray count]) {
        
        if (![NullChecker isNull:[[tempArray objectAtIndex:0] objectForKey:@"catalogProfileID"]]) {
            
              [catalogProfileID setString:[[tempArray objectAtIndex:0] objectForKey:@"catalogProfileID"]];
 
         }
        else{
            
 
            [catalogProfileID setString:@""];
         }
        
        if (![NullChecker isNull:[[tempArray objectAtIndex:0] objectForKey:@"iwerks"]]) {
            
             [iwerkString setString:[[tempArray objectAtIndex:0] objectForKey:@"iwerks"]];
 
        }
        else{
            
            [iwerkString setString:@""];
         }
      }
    
 
    [headerDataArray addObject:[NSMutableArray arrayWithObjects:@"Work Center",@"Search Work Center",[[self.detailNotificationArray objectAtIndex:0] objectForKey:@"notificationh_workcentername"],[[self.detailNotificationArray objectAtIndex:0] objectForKey:@"notificationh_workcenterid"], nil]];
    
    [headerDataArray addObject:[NSMutableArray arrayWithObjects:@"Priority",@"Select priority",[[self.detailNotificationArray objectAtIndex:0] objectForKey:@"notificationh_priority_name"],[[self.detailNotificationArray objectAtIndex:0] objectForKey:@"notificationh_priorityid"], nil]];

    
    [headerDataArray addObject:[NSMutableArray arrayWithObjects:@"Planner group",@"Select Planner Group",[[self.detailNotificationArray objectAtIndex:0] objectForKey:@"notificationh_ingrp_name"],[[self.detailNotificationArray objectAtIndex:0] objectForKey:@"notificationh_ingrp"], nil]];
    
    
     plannerGrouplID=[[self.detailNotificationArray objectAtIndex:0] objectForKey:@"notificationh_ingrp"];
     plannerGroupNameString=[[self.detailNotificationArray objectAtIndex:0] objectForKey:@"notificationh_ingrp_name"];

 
    [headerDataArray addObject:[NSMutableArray arrayWithObjects:@"Reported By",@"Enter Reported By",[[self.detailNotificationArray objectAtIndex:0] objectForKey:@"notificationh_reported_by_Input"],@"", nil]];
    
    [primaryPersonResonsibleID setString:@""];
    
    primaryPersonResonsibleNameString=@"";
    
 
    plantID=[[self.detailNotificationArray objectAtIndex:0] objectForKey:@"notificationh_plantid"];

    
    if ([[[self.detailNotificationArray objectAtIndex:0] objectForKey:@"notificationh_usr02"] isEqualToString:@""]) {
        
         primaryPersonResonsibleNameString=[[self.detailNotificationArray objectAtIndex:0]
                                           objectForKey:@"notificationh_usr02"];
 
    }
    
    if ([[[self.detailNotificationArray objectAtIndex:0] objectForKey:@"notificationh_usr01"] isEqualToString:@""]) {
 
        [primaryPersonResonsibleID setString:[[self.detailNotificationArray objectAtIndex:0] objectForKey:@"notificationh_usr01"]];
 
    }
    
 
    [headerDataArray addObject:[NSMutableArray arrayWithObjects:@"Primary User Responsible",@"Select Primary User Responsible",primaryPersonResonsibleNameString,primaryPersonResonsibleID, nil]];
 
    [headerDataArray addObject:[NSMutableArray arrayWithObjects:@"Person Responsible",@"Select Person Responsible",[[self.detailNotificationArray objectAtIndex:0] objectForKey:@"notificationh_personresponsible_text"],[[self.detailNotificationArray objectAtIndex:0] objectForKey:@"notificationh_personresponsible_id"], nil]];
 
    ////////
   // NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMdd HHmmss"];
    NSDate *tempstartDate = [dateFormatter dateFromString:[[self.detailNotificationArray objectAtIndex:0] objectForKey:@"notificationh_reqstartdate"]];
    NSDate *tempendDate = [dateFormatter dateFromString:[[self.detailNotificationArray objectAtIndex:0] objectForKey:@"notificationh_reqenddate"]];
    
    NSDate *tempreqstartDate = [dateFormatter dateFromString:[[self.detailNotificationArray objectAtIndex:0] objectForKey:@"notificationh_startdate"]];
 
    
    NSDate *tempreqendDate = [dateFormatter dateFromString:[[self.detailNotificationArray objectAtIndex:0] objectForKey:@"notificationh_enddate"]];
    
    // Convert date object into desired format
    [dateFormatter setDateFormat:@"MMM dd, yyyy hh:mm a"];
    NSString *convertedStartDateString = [dateFormatter stringFromDate:tempstartDate];
    if ([NullChecker isNull:convertedStartDateString]) {
        convertedStartDateString = @"";
    }
 
    [headerDataArray addObject:[NSMutableArray arrayWithObjects:@"Required Start Date & Time",@"",[NSString stringWithFormat:@"%@",convertedStartDateString],@"", nil]];

    
    NSString *convertedEndDateStirng = [dateFormatter stringFromDate:tempendDate];
    if ([NullChecker isNull:convertedEndDateStirng]) {
        convertedEndDateStirng = @"";
    }
 
    [headerDataArray addObject:[NSMutableArray arrayWithObjects:@"Required End Date & Time",@"",[NSString stringWithFormat:@"%@",convertedEndDateStirng],@"", nil]];

    
    NSString *convertedReqStartDateString = [dateFormatter stringFromDate:tempreqstartDate];
    if ([NullChecker isNull:convertedReqStartDateString]) {
        convertedReqStartDateString = @"";
    }
 
    [headerDataArray addObject:[NSMutableArray arrayWithObjects:@"Malfunction Start date & Time",@"",[NSString stringWithFormat:@"%@",convertedReqStartDateString],@"", nil]];

    NSString *convertedReqEndDateStirng = [dateFormatter stringFromDate:tempreqendDate];
    if ([NullChecker isNull:convertedReqEndDateStirng]) {
        convertedReqEndDateStirng = @"";
    }
    
 
  //  [headerDataArray addObject:[NSMutableArray arrayWithObjects:@"BreakDown",@"",@"", nil]];

    [headerDataArray addObject:[NSMutableArray arrayWithObjects:@"Malfunction End date & Time",@"",[NSString stringWithFormat:@"%@",convertedReqEndDateStirng],@"", nil]];
 
     [headerDataArray addObject:[NSMutableArray arrayWithObjects:@"Effect",@"Select Effect",[[self.detailNotificationArray objectAtIndex:0] objectForKey:@"notificationh_effect_name"],[[self.detailNotificationArray objectAtIndex:0] objectForKey:@"notificationh_effect_id"], nil]];
    
    
    if ([[[self.detailNotificationArray objectAtIndex:0] objectForKey:@"notificationh_status"] length]) {
        CALayer *layer = [statusButton layer];
        
        [layer setMasksToBounds:YES];
        [layer setCornerRadius:statusButton.frame.size.width / 2];
        
        CALayer *statusLayer = [_statusHeaderButton layer];
        
        [statusLayer setMasksToBounds:YES];
        [statusLayer setCornerRadius:_statusHeaderButton.frame.size.width / 2];
 
        NstatusLabel = [[self.detailNotificationArray objectAtIndex:0] objectForKey:@"notificationh_effect_name"];
        
        notifNoLabel.text=[[self.detailNotificationArray objectAtIndex:0] objectForKey:@"nh_objectID"];
        self.statusHeaderNumber.text=[[self.detailNotificationArray objectAtIndex:0] objectForKey:@"nh_objectID"];

 
        if ([[[self.detailNotificationArray objectAtIndex:0] objectForKey:@"notificationh_status"] isEqualToString:@"NOPR"])
        {
            [statusButton setTitle:@"NOPR" forState:UIControlStateNormal];
            statusButton.backgroundColor=UIColorFromRGB(39, 171, 226);
            [_statusHeaderButton setTitle:@"NOPR" forState:UIControlStateNormal];
            _statusHeaderButton.backgroundColor=UIColorFromRGB(39, 171, 226);
        }
        else if ([[[self.detailNotificationArray objectAtIndex:0] objectForKey:@"notificationh_status"] isEqualToString:@"OSNO"])
        {
            [statusButton setTitle:@"OSNO" forState:UIControlStateNormal];
            statusButton.backgroundColor=[UIColor yellowColor];
            [_statusHeaderButton setTitle:@"OSNO" forState:UIControlStateNormal];
            _statusHeaderButton.backgroundColor=[UIColor yellowColor];
        }
        else if ([[[self.detailNotificationArray objectAtIndex:0] objectForKey:@"notificationh_status"] isEqualToString:@"Cancelled"])
        {
            [statusButton setTitle:@"DLFL" forState:UIControlStateNormal];
            statusButton.backgroundColor=[UIColor redColor];
            
            [_statusHeaderButton setTitle:@"DLFL" forState:UIControlStateNormal];
            _statusHeaderButton.backgroundColor=[UIColor redColor];
            statusCodeImage.backgroundColor = [UIColor redColor];
            
            submitResetView.hidden = YES;
            cancelBtn.hidden = YES;
            completeBtn.hidden = YES;
            editBtn.hidden = YES;
            takeAPictureBtn.userInteractionEnabled=NO;
            chooseFromGalleryBtn.userInteractionEnabled=NO;
            chooseFromGalleryTextBtn.userInteractionEnabled=NO;
            takeAPictureTextBtn.userInteractionEnabled=NO;
            deleteImagesBtn.hidden=YES;
            submitResetView.hidden=YES;
//            leftCustomInfoBtn.userInteractionEnabled=NO;
//            rightCustomInfoBtn.userInteractionEnabled=NO;
            
         }
        else if ([[[self.detailNotificationArray objectAtIndex:0] objectForKey:@"notificationh_status"] isEqualToString:@"Completed"]) {
            
            [statusButton setTitle:@"NOCO" forState:UIControlStateNormal];
            statusButton.backgroundColor=[UIColor greenColor];
            [_statusHeaderButton setTitle:@"NOCO" forState:UIControlStateNormal];
            _statusHeaderButton.backgroundColor=[UIColor greenColor];
            
            statusCodeImage.backgroundColor = [UIColor greenColor];
            submitResetView.hidden = YES;
            cancelBtn.hidden = YES;
            completeBtn.hidden = YES;
            //seperatorLabel.hidden = YES;
            editBtn.hidden = YES;
           // self.listofCauseCodesTableVIew.userInteractionEnabled=NO;
            takeAPictureBtn.userInteractionEnabled=NO;
            chooseFromGalleryBtn.userInteractionEnabled=NO;
            chooseFromGalleryTextBtn.userInteractionEnabled=NO;
            takeAPictureTextBtn.userInteractionEnabled=NO;
            deleteImagesBtn.hidden=YES;
            submitResetView.hidden=YES;
//            leftCustomInfoBtn.userInteractionEnabled=NO;
//            rightCustomInfoBtn.userInteractionEnabled=NO;
            
            createOrderBtn.hidden=YES;
            
        }
        else{
            [statusButton setTitle:@"NOPR" forState:UIControlStateNormal];
            [statusButton setBackgroundColor:UIColorFromRGB(39, 171, 226)];
            
            [_statusHeaderButton setTitle:@"NOPR" forState:UIControlStateNormal];
            [_statusHeaderButton setBackgroundColor:UIColorFromRGB(39, 171, 226)];
            
        }
        
    }
    
    
    if (self.causeCodeDetailsArray == nil)
    {
        self.causeCodeDetailsArray = [NSMutableArray new];
        
    }
    [self.causeCodeDetailsArray removeAllObjects];
    
    if (self.attachmentArray == nil) {
        self.attachmentArray = [NSMutableArray new];
    }
    
    [self.attachmentArray removeAllObjects];
    
    if (self.causeCodeDetailDeleteArray) {
        [self.causeCodeDetailDeleteArray removeAllObjects];
    }
    else
    {
        self.causeCodeDetailDeleteArray = [NSMutableArray new];
    }
    
    if (self.customDamageDetailsArray == nil) {
        self.customDamageDetailsArray = [NSMutableArray new];
    }
    else{
        [self.customDamageDetailsArray removeAllObjects];
    }
    
    if (self.notifTaskCodesDetailsArray == nil) {
        self.notifTaskCodesDetailsArray = [NSMutableArray new];
    }
    
    if (self.taskCodesDeleteDetailsArray == nil){
        self.taskCodesDeleteDetailsArray = [NSMutableArray new];
    }
    
    if (self.customHeaderDetailsArray == nil) {
        self.customHeaderDetailsArray = [NSMutableArray new];
    }
    else{
        [self.customHeaderDetailsArray removeAllObjects];
    }
    
    if (notifInspectionArray == nil)
    {
        notifInspectionArray = [NSMutableArray new];
    }
    else
    {
        [notifInspectionArray removeAllObjects];
    }
    
    if (self.itemKeyDetailsArray == nil)
    {
        self.itemKeyDetailsArray = [NSMutableArray new];
    }
    else
    {
        [self.itemKeyDetailsArray removeAllObjects];
    }
    
    notifInspectionArray = [[DataBase sharedInstance] getInspectionResultforEquipment:[[self.detailNotificationArray objectAtIndex:0] objectForKey:@"notificationh_equip_id"]];
    
 
//    self.notificationHeaderDetails = [NSMutableDictionary new];
//
//    [self.notificationHeaderDetails removeAllObjects];
 
    
    [[DataBase sharedInstance] getinsertDetailNotificationDetailstoDictionary:nil withAttachments:self.attachmentArray withTransaction:self.causeCodeDetailsArray withTasks:self.notifTaskCodesDetailsArray withNotifStatus:[NSMutableArray array] forAction:@"" ForUUID:[[self.detailNotificationArray objectAtIndex:0] objectForKey:@"notificationh_id"]];
 
    [self.notifActivityDetailsArray addObjectsFromArray:[[DataBase sharedInstance] fetchNotificationActivityItemKey:[[self.detailNotificationArray objectAtIndex:0] objectForKey:@"notificationh_id"]]];
    
    
    //    [[DataBase sharedInstance] insertNotificationTransactionsDetails:notificationUDID :self.causeCodeDetailsArray];
    
 //   [[DataBase sharedInstance] insertNotificationTransactionsDetails:notificationUDID withTransactionDetailsCopy:self.causeCodeDetailsArray withTaskCodeDetailsCopy:self.notifTaskCodesDetailsArray];
    
  //  [[DataBase sharedInstance] insertNotificationTransactionsDetails:notificationUDID withTransactionDetailsCopy:self.causeCodeDetailsArray withActivityDetailsArray:self.notifActivityDetailsArray withTaskCodeDetailsCopy:self.notifTaskCodesDetailsArray];
    
    //-(NSMutableArray *)insertNotificationTransactionsDetails :(NSString *)uuid withTransactionDetailsCopy:(NSArray *)transactionDetails withActivityDetailsArray:(NSArray *)activityDetails withTaskCodeDetailsCopy:(NSArray *)taskCodeDetails{

    
    [[DataBase sharedInstance] insertNotificationTransactionsDetails:[[self.detailNotificationArray objectAtIndex:0] objectForKey:@"notificationh_id"] withTransactionDetailsCopy:self.causeCodeDetailsArray withActivityDetailsArray:self.notifActivityDetailsArray withTaskCodeDetailsCopy:self.notifTaskCodesDetailsArray];
    
    
    [notifSystemStatusTableView registerNib:[UINib nibWithNibName:@"OrderSystemStatusTableViewCell~iPhone5" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"Cell"];
    
    
    if (self.notifSystemStatusArray == nil) {
        self.notifSystemStatusArray = [NSMutableArray new];
    }
    else{
        
        [self.notifSystemStatusArray removeAllObjects];
    }
    
    [self.notifSystemStatusArray addObjectsFromArray:[[DataBase sharedInstance] fetchNotifSystemStatus:[[self.detailNotificationArray objectAtIndex:0] objectForKey:@"notificationh_id"]]];
 
 
    [self loadsystemStatusheaderView];
    
 
    VornrItem = 0;
    VornrCauseCode = 1;
    
    for (int i=0; i<[self.causeCodeDetailsArray count]; i++) {
        if ([[[[self.causeCodeDetailsArray objectAtIndex:i] firstObject] objectAtIndex:14] isEqualToString:@"D"]){
            [self.causeCodeDetailDeleteArray addObject:[NSMutableArray arrayWithArray:[self.causeCodeDetailsArray objectAtIndex:i]]];
            [self.causeCodeDetailsArray removeObjectAtIndex:i];
            --i;
        }
        
        vornrItemID = [[[self.causeCodeDetailsArray  objectAtIndex:i] firstObject]  objectAtIndex:12];
 
    }
    
    VornrItem = [vornrItemID intValue];
 
    VornrItem = VornrItem +1;
    
    //    VornrTaskCode = 0;
    
    [self.itemKeyDetailsArray addObject:[NSMutableArray arrayWithObjects:vornrItemID,@"", nil]];

 
    for (int i=0; i<[self.notifTaskCodesDetailsArray count]; i++) {
        if ([[[[self.notifTaskCodesDetailsArray objectAtIndex:i] firstObject] objectAtIndex:17] isEqualToString:@"D"]){
            [self.taskCodesDeleteDetailsArray addObject:[NSMutableArray arrayWithArray:[self.notifTaskCodesDetailsArray objectAtIndex:i]]];
            [self.notifTaskCodesDetailsArray removeObjectAtIndex:i];
            --i;
        }
        
        vornrTaskID = [[[self.notifTaskCodesDetailsArray  objectAtIndex:i] firstObject] objectAtIndex:17];
    }
    
    VornrTaskCode = [vornrTaskID intValue];
    
    VornrTaskCode = VornrTaskCode +1;
    
    [commomlistListTableview registerNib:[UINib nibWithNibName:@"InputDropDownTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"InputDropDownCell"];
    
    [commomlistListTableview registerNib:[UINib nibWithNibName:@"SearchInputDropdownTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"SearchInputDropDownCell"];
    
    [commomlistListTableview registerNib:[UINib nibWithNibName:@"DateandTimeTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"DateDropDownCell"];
    
    [commomlistListTableview registerNib:[UINib nibWithNibName:@"BreakDownTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"BreakDownCell"];
    
    [commomlistListTableview registerNib:[UINib nibWithNibName:@"NotifOrderTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"NotifOrderCell"];
 
}

-(void)loadHeaderData
{
    
    headerDataArray=[NSMutableArray new];
    addCauseCodeDataArray=[NSMutableArray new];
    
    createNotificationFlag=YES;
    
    submitResetView.hidden=NO;
    
    xStatusBtn.hidden=YES;
    
    //For Duplicate Notification.
    transmitTypeString = @"";
 
    commomlistListTableview.tag=0;
    
    [headerDataArray addObject:[NSMutableArray arrayWithObjects:@"Notification Type",@"Select Notification Type",@"",@"", nil]];
    
    [headerDataArray addObject:[NSMutableArray arrayWithObjects:@"Notification Text",@"Enter Notification text",@"",@"", nil]];
    
    [headerDataArray addObject:[NSMutableArray arrayWithObjects:@"Function Location",@"Search or Enter Function Location ",@"",@"", nil]];
    
    [headerDataArray addObject:[NSMutableArray arrayWithObjects:@"Equipment Number",@"Search or Scan Equipment Number ",@"",@"", nil]];
    
    [headerDataArray addObject:[NSMutableArray arrayWithObjects:@"Work Center",@"Search  Work Center ",@"",@"", nil]];
 
    [headerDataArray addObject:[NSMutableArray arrayWithObjects:@"Priority",@"Select priority",@"",@"", nil]];
    
    [headerDataArray addObject:[NSMutableArray arrayWithObjects:@"Planner group",@"Select Planner Group",@"",@"", nil]];
    
    [headerDataArray addObject:[NSMutableArray arrayWithObjects:@"Reported By",@"Enter Reported By",@"",@"", nil]];
    
      [headerDataArray addObject:[NSMutableArray arrayWithObjects:@"Primary User Responsible",@"Select Primary User Responsible",@"",@"", nil]];
    
    [headerDataArray addObject:[NSMutableArray arrayWithObjects:@"Person Responsible",@"Select Person Responsible",@"",@"", nil]];
    
    NSDateFormatter *dateformatter=[[NSDateFormatter alloc]init];
    [dateformatter setDateFormat:@"MMM dd, yyyy hh:mm a"];
 
    [headerDataArray addObject:[NSMutableArray arrayWithObjects:@"Required Start Date & Time",@"",[dateformatter stringFromDate:[NSDate date]],@"", nil]];
    
    [headerDataArray addObject:[NSMutableArray arrayWithObjects:@"Required End Date & Time",@"",@"",@"", nil]];
    
    [headerDataArray addObject:[NSMutableArray arrayWithObjects:@"Malfunction Start date & Time",@"",[dateformatter stringFromDate:[NSDate date]],@"", nil]];
    
   // [headerDataArray addObject:[NSMutableArray arrayWithObjects:@"BreakDown",@"",@"",@"", nil]];
    
    [headerDataArray addObject:[NSMutableArray arrayWithObjects:@"Malfunction End date & Time",@"",@"",@"", nil]];
    
    [headerDataArray addObject:[NSMutableArray arrayWithObjects:@"Effect",@"Select Effect",@"",@"", nil]];
    
    [commomlistListTableview registerNib:[UINib nibWithNibName:@"InputDropDownTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"InputDropDownCell"];
    
    [commomlistListTableview registerNib:[UINib nibWithNibName:@"SearchInputDropdownTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"SearchInputDropDownCell"];
    
    [commomlistListTableview registerNib:[UINib nibWithNibName:@"DateandTimeTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"DateDropDownCell"];
    
    [commomlistListTableview registerNib:[UINib nibWithNibName:@"BreakDownTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"BreakDownCell"];
    
 
}


-(void)loadCauseCodeDetails
{
    
    addCauseCodeDataArray=[NSMutableArray new];
    commonAddTableView.tag=0;
    
    xStatusBtn.hidden=NO;

     [addCauseCodeDataArray addObject:[NSMutableArray arrayWithObjects:@"Object Part",@"Select Object Part",@"",@"", nil]];
    
    [addCauseCodeDataArray addObject:[NSMutableArray arrayWithObjects:@"Object Part Code",@"Select Object Part Code",@"",@"", nil]];
    
    [addCauseCodeDataArray addObject:[NSMutableArray arrayWithObjects:@"Damage",@"Select Damage",@"",@"", nil]];
    
    [addCauseCodeDataArray addObject:[NSMutableArray arrayWithObjects:@"Damage Code",@"Select Damage Code",@"",@"", nil]];
    
    [addCauseCodeDataArray addObject:[NSMutableArray arrayWithObjects:@"Damage Description",@"Enter Damage description",@"",@"", nil]];
    
    [addCauseCodeDataArray addObject:[NSMutableArray arrayWithObjects:@"Cause",@"Select Cause",@"",@"", nil]];
    
    [addCauseCodeDataArray addObject:[NSMutableArray arrayWithObjects:@"Cause Code",@"Select Cause Code",@"",@"", nil]];
    
    [addCauseCodeDataArray addObject:[NSMutableArray arrayWithObjects:@"Cause Description",@"Enter Cause Description",@"",@"", nil]];
    
    [addCauseTaskView setFrame:CGRectMake(0, 0, commomlistListTableview.frame.size.width, commomlistListTableview.frame.size.height)];
 
    submitResetView.hidden=YES;
    
    [commomlistListTableview addSubview:addCauseTaskView];
    
 
 }

-(void)loadActivityData
{
    addActivityArray=[NSMutableArray new];
    
    commonAddTableView.tag=2;
    
 
    [addActivityArray addObject:[NSMutableArray arrayWithObjects:@"Item key",@"Select Item Key",@"",@"", nil]];
    
    if (objectPartIDString.length) {
        
        [addActivityArray addObject:[NSMutableArray arrayWithObjects:@"Object Part",@"",objectPartNameString,objectPartIDString, nil]];

    }
    else{
         [addActivityArray addObject:[NSMutableArray arrayWithObjects:@"Object Part",@"",@"",@"", nil]];
    }
    
    if (damageCodeIdString.length) {
        
        [addActivityArray addObject:[NSMutableArray arrayWithObjects:@"Damage Code",@"",damageNameString,damageCodeIdString, nil]];
        
     }
    else
    {
        [addActivityArray addObject:[NSMutableArray arrayWithObjects:@"Damage Code",@"",@"",@"", nil]];
    }
    
    
    [addActivityArray addObject:[NSMutableArray arrayWithObjects:@"Code Group",@"",@"",@"", nil]];
    
    [addActivityArray addObject:[NSMutableArray arrayWithObjects:@"Code",@"",@"",@"", nil]];
    
    [addActivityArray addObject:[NSMutableArray arrayWithObjects:@"Text",@"",@"",@"", nil]];
    
    [addActivityArray addObject:[NSMutableArray arrayWithObjects:@"Start Date",@"Start Date",@"",@"", nil]];
    
    [addActivityArray addObject:[NSMutableArray arrayWithObjects:@"End Date",@"End date",@"",@"", nil]];
    
    [addActivityArray addObject:[NSMutableArray arrayWithObjects:@"Start Time",@"Start Time",@"",@"", nil]];
    
    [addActivityArray addObject:[NSMutableArray arrayWithObjects:@"End Time",@"End Time",@"",@"", nil]];
    
    [addCauseTaskView setFrame:CGRectMake(0, 0, commomlistListTableview.frame.size.width, commomlistListTableview.frame.size.height)];
 
    submitResetView.hidden=YES;
    
    [commomlistListTableview addSubview:addCauseTaskView];
 
}

-(void)loadTaskCodeData
{
   
    addTaskCodeDataArray=[NSMutableArray new];
    
    commonAddTableView.tag=1;
    
    [addTaskCodeDataArray addObject:[NSMutableArray arrayWithObjects:@"Task group",@"Select Task Group",@"", nil]];
    
    [addTaskCodeDataArray addObject:[NSMutableArray arrayWithObjects:@"Task Code",@"Select Task Code",@"", nil]];
    
    [addTaskCodeDataArray addObject:[NSMutableArray arrayWithObjects:@"Task Text",@"Enter Task Text",@"", nil]];
    
    [addTaskCodeDataArray addObject:[NSMutableArray arrayWithObjects:@"Task Processor",@"Select Task Processor",@"", nil]];
    
    [addTaskCodeDataArray addObject:[NSMutableArray arrayWithObjects:@"Responsible",@"Enter Responsible",@"", nil]];
    
    [addTaskCodeDataArray addObject:[NSMutableArray arrayWithObjects:@"Planned Start Date",@"Select Planned Start Date",@"", nil]];
    
    [addTaskCodeDataArray addObject:[NSMutableArray arrayWithObjects:@"Planned Finish Date",@"Select Planned Finished Date",@"", nil]];
    
    [addTaskCodeDataArray addObject:[NSMutableArray arrayWithObjects:@"Planned Start Time",@"Select Planned Start Time",@"", nil]];
    
    [addTaskCodeDataArray addObject:[NSMutableArray arrayWithObjects:@"Planned Finshed Time",@"Select Planned Finish Time",@"", nil]];
    
    [addTaskCodeDataArray addObject:[NSMutableArray arrayWithObjects:@"Status",@"",@"",@"", nil]];
    
    [addTaskCodeDataArray addObject:[NSMutableArray arrayWithObjects:@"Completion Date",@"Select Completion  Date",@"", nil]];
    
    [addTaskCodeDataArray addObject:[NSMutableArray arrayWithObjects:@"Completion Time",@"Select Completion  Time",@"", nil]];
    
     [addTaskCodeDataArray addObject:[NSMutableArray arrayWithObjects:@"Reported By",@"Enter Reported By",@"", nil]];
    
     [addCauseTaskView setFrame:CGRectMake(0, 0, commomlistListTableview.frame.size.width, commomlistListTableview.frame.size.height)];
    
 
    submitResetView.hidden=YES;
    
    [commomlistListTableview addSubview:addCauseTaskView];
    
}

-(void)downloadAttachments
{
    
    NSString *trimmedString;
    if (![[[self.attachmentArray objectAtIndex:attachmentCurrentIndex] objectAtIndex:7] isEqualToString:@""]) {
        
        trimmedString=[[self.attachmentArray objectAtIndex:attachmentCurrentIndex] objectAtIndex:7];
        
    }
    else{
        
        trimmedString=[dataaArray substringFromIndex:33];
        
        
    }
    
    NSString *urlString=[NSString stringWithFormat:@"%@:%@%@",[defaults objectForKey:@"HOST"],[defaults objectForKey:@"PORT"],trimmedString];
    
    NSString *key = @"";
    NSString *str_Pasword = [defaults objectForKey:@"password"];
    NSString *decryptedPassword = [str_Pasword AES128DecryptWithKey:key];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
    
    NSString *authStr = [NSString stringWithFormat:@"%@:%@",decryptedUserName,decryptedPassword];
    NSData *authData = [authStr dataUsingEncoding:NSUTF8StringEncoding];
    
    NSString *authValue = [authData base64EncodedStringWithOptions:0];
    
    //  [request setValue:authValue forHTTPHeaderField:@"Authorization"];
    
    [request addValue:[NSString stringWithFormat:@"Basic %@",authValue] forHTTPHeaderField:@"Authorization"];
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse * response,
                                               NSData * data,
                                               NSError * error) {
                               if (!error){
                                   
    UIWebView *webView;
                                   
                                   
     [downloadsView setFrame:CGRectMake(0, 0, commomlistListTableview.frame.size.width, commomlistListTableview.frame.size.height)];
                                  
      webView = [[UIWebView alloc] initWithFrame:CGRectMake(10, 60, downloadsView.frame.size.width, downloadsView.frame.size.height-10)];
                                   
 
                                   [webView loadRequest:request];
                                   [webView sizeToFit];
                                   
                                   [commomlistListTableview addSubview:downloadsView];
                                   
                                   [downloadsView addSubview:webView];
                                   
                                   [defaults removeObjectForKey:@"DA"];
                                   [defaults synchronize];
                                   
                                   
                                   
                               } else {
                                   NSLog(@"ERRORE: %@", error);
                               }
                               
                           }];
    
   // [ActivityView dismiss];
    
}

-(IBAction)dismissSystemStatusBtn:(id)sender{
    
    [self.notifStatusView removeFromSuperview];
    
}

-(IBAction)notifSystemStatusValueChanged:(id)sender{
    
    self.sysytemStatusSegmentControl = (UISegmentedControl *)sender;
    
    int clickedSegment=(int)[self.sysytemStatusSegmentControl selectedSegmentIndex];
    
    switch (clickedSegment)
    {
        case 0:
            
            notifSystemStatusTableView.tag=0;
            
            break;
            
        case 1:
            
            notifSystemStatusTableView.tag=1;
            
            break;
            
        case 2:
            
            notifSystemStatusTableView.tag=2;
            
            break;
            
        default:break;
    }
    
    [notifSystemStatusTableView reloadData];
    
}


-(IBAction)systemStatusButton:(id)sender{
    
 
     notifSystemStatusTableView.tag = 0;
    
     [notifSystemStatusTableView reloadData];
    
    [self.notifStatusView setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    
     [self.view addSubview:self.notifStatusView];
 
}


#pragma mark-
#pragma mark- UITextField delegate




-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    headerCommonIndex = (int)textField.superview.tag;

    [self.dropDownArray removeAllObjects];
 
    if (commomlistListTableview.tag==0)
    {
        if (!createNotificationFlag) {
            
            if (headerCommonIndex==0) {
                
                [[textField valueForKey:@"textInputTraits"] setValue:[UIColor clearColor] forKey:@"insertionPointColor"];
                textField.inputView = self.dropDownTableView;
                
                textField.inputAccessoryView = self.mypickerToolbar;
                
                self.dropDownTableView.tag = NOTIFICATIONTYPE;
                
                [self.dropDownArray addObjectsFromArray:[[DataBase sharedInstance] getNotificationTypes]];
                
                [self.dropDownTableView reloadData];
                
            }
            else if (headerCommonIndex==7){
                
                [[textField valueForKey:@"textInputTraits"] setValue:[UIColor clearColor] forKey:@"insertionPointColor"];
                textField.inputView = self.dropDownTableView;
                textField.inputAccessoryView = self.mypickerToolbar;
                 self.dropDownTableView.tag = PRIORITY;
                 [self.dropDownArray addObjectsFromArray:[[DataBase sharedInstance] getNotifPriorityTypes]];
                 [self.dropDownTableView reloadData];
                
            }
            else if (headerCommonIndex==8){
                
                [[textField valueForKey:@"textInputTraits"] setValue:[UIColor clearColor] forKey:@"insertionPointColor"];
                
                textField.inputView = self.dropDownTableView;
                textField.inputAccessoryView = self.mypickerToolbar;
                
                self.dropDownTableView.tag = PLANNER_GROUP;
 
                if (iwerkString.length) {

                     [self.dropDownArray addObjectsFromArray:[[DataBase sharedInstance] getPlannerGroupMasterforPlant:iwerkString]];
                }
 
                [self.dropDownTableView reloadData];
                
             }
            
//            else if (headerCommonIndex==10){
//
//                [[textField valueForKey:@"textInputTraits"] setValue:[UIColor clearColor] forKey:@"insertionPointColor"];
//                textField.inputView = self.dropDownTableView;
//                textField.inputAccessoryView = self.mypickerToolbar;
//
//                if (plantID.length) {
//
//                     [self.dropDownArray addObjectsFromArray:[[DataBase sharedInstance] getPersonResonsibleMasterforPlant:plantID]];
//                }
//                else{
//
//                     [self.dropDownArray addObjectsFromArray:[[DataBase sharedInstance] getPersonResonsibleMaster]];
//                }
//
//                 self.dropDownTableView.tag = PRIMARY_USER_RESPONSIBLE;
//                 [self.dropDownTableView reloadData];
//
//            }
//
            else if (headerCommonIndex==11){
                
                [[textField valueForKey:@"textInputTraits"] setValue:[UIColor clearColor] forKey:@"insertionPointColor"];
                textField.inputView = self.dropDownTableView;
                textField.inputAccessoryView = self.mypickerToolbar;
 
                if (plantID.length) {
                    
                      [self.dropDownArray addObjectsFromArray:[[DataBase sharedInstance] getPersonResonsibleMasterforPlant:plantID forWorkcenter:@""]];
                }
                else{
                    
                    if (!createNotificationFlag) {
                        
                         [self.dropDownArray addObjectsFromArray:[[DataBase sharedInstance] getPersonResonsibleMasterforPlant:[[self.detailNotificationArray objectAtIndex:0] objectForKey:@"notificationh_plantid"] forWorkcenter:@""]];
                    }
 
                }
                
                self.dropDownTableView.tag = PERSON_RESONSIBLE;
                [self.dropDownTableView reloadData];
                
            }
            else if (headerCommonIndex==12){
                
                [self datePickerForMalFuncStartDate];
                textField.inputView=self.startMalFunctionDatePicker;
                textField.inputAccessoryView = myDatePickerToolBar;
                
                
            }
            else if (headerCommonIndex==13){
                
                [self datePickerForMalFuncStartDate];
                textField.inputView=self.startMalFunctionDatePicker;
                textField.inputAccessoryView = myDatePickerToolBar;
            }
            
            else if (headerCommonIndex==14){
                
                [self datePickerForMalFuncStartDate];
                textField.inputView=self.startMalFunctionDatePicker;
                textField.inputAccessoryView = myDatePickerToolBar;
            }
            
            else if (headerCommonIndex==15){
                
                [self datePickerForMalFuncStartDate];
                textField.inputView=self.startMalFunctionDatePicker;
                textField.inputAccessoryView = myDatePickerToolBar;
            }
            else if (headerCommonIndex==16)
            {
                
                [[textField valueForKey:@"textInputTraits"] setValue:[UIColor clearColor] forKey:@"insertionPointColor"];
                textField.inputView = self.dropDownTableView;
                textField.inputAccessoryView = self.mypickerToolbar;
                 [self.dropDownArray addObjectsFromArray:[[DataBase sharedInstance] getNotificationEffect]];
                 self.dropDownTableView.tag = EFFECT;
                 [self.dropDownTableView reloadData];
                
             }
         }
        else{
            
            if (headerCommonIndex==0) {
                
                [[textField valueForKey:@"textInputTraits"] setValue:[UIColor clearColor] forKey:@"insertionPointColor"];
                textField.inputView = self.dropDownTableView;
                
                textField.inputAccessoryView = self.mypickerToolbar;
                
                self.dropDownTableView.tag = NOTIFICATIONTYPE;
                
                [self.dropDownArray addObjectsFromArray:[[DataBase sharedInstance] getNotificationTypes]];
                
                [self.dropDownTableView reloadData];
                
            }
            else if (headerCommonIndex==5){
                
                [[textField valueForKey:@"textInputTraits"] setValue:[UIColor clearColor] forKey:@"insertionPointColor"];
                textField.inputView = self.dropDownTableView;
                textField.inputAccessoryView = self.mypickerToolbar;
                
                self.dropDownTableView.tag = PRIORITY;
                
                [self.dropDownArray addObjectsFromArray:[[DataBase sharedInstance] getNotifPriorityTypes]];
                
                [self.dropDownTableView reloadData];
            }
            else if (headerCommonIndex==6){
                
                [[textField valueForKey:@"textInputTraits"] setValue:[UIColor clearColor] forKey:@"insertionPointColor"];
                textField.inputView = self.dropDownTableView;
                textField.inputAccessoryView = self.mypickerToolbar;
                
                self.dropDownTableView.tag = PLANNER_GROUP;
                
                //  [self.dropDownArray addObjectsFromArray:[[DataBase sharedInstance] getPlannerGroupMasterforPlant:headerPlantID]];
                
                [self.dropDownTableView reloadData];
                
            }
//            else if (headerCommonIndex==8){
//
//                [[textField valueForKey:@"textInputTraits"] setValue:[UIColor clearColor] forKey:@"insertionPointColor"];
//                textField.inputView = self.dropDownTableView;
//                textField.inputAccessoryView = self.mypickerToolbar;
//
//                if (res_obj.plantIdString.length) {
//
//                    [self.dropDownArray addObjectsFromArray:[[DataBase sharedInstance] getPersonResonsibleMasterforPlant:res_obj.plantIdString]];
//                }
//                else{
//
//                    [self.dropDownArray addObjectsFromArray:[[DataBase sharedInstance] getPersonResonsibleMaster]];
//                }
//
//
//                self.dropDownTableView.tag = PRIMARY_USER_RESPONSIBLE;
//
//                [self.dropDownTableView reloadData];
//
//            }
            
             else if (headerCommonIndex==9){
                
                [[textField valueForKey:@"textInputTraits"] setValue:[UIColor clearColor] forKey:@"insertionPointColor"];
                textField.inputView = self.dropDownTableView;
                textField.inputAccessoryView = self.mypickerToolbar;
                
                 if (res_obj.plantIdString.length) {
 
                     [self.dropDownArray addObjectsFromArray:[[DataBase sharedInstance] getPersonResonsibleMasterforPlant:res_obj.plantIdString forWorkcenter:res_obj.workcenterString]];

                 }
                 else{
                     
                     [self.dropDownArray addObjectsFromArray:[[DataBase sharedInstance] getPersonResonsibleMasterforPlant:@"" forWorkcenter:@""]];

                 }
                
                self.dropDownTableView.tag = PERSON_RESONSIBLE;
                 [self.dropDownTableView reloadData];
              }
            else if (headerCommonIndex==10){
                
                [self datePickerForMalFuncStartDate];
                textField.inputView=self.startMalFunctionDatePicker;
                textField.inputAccessoryView = myDatePickerToolBar;
             }
            else if (headerCommonIndex==11){
                
                [self datePickerForMalFuncStartDate];
                textField.inputView=self.startMalFunctionDatePicker;
                textField.inputAccessoryView = myDatePickerToolBar;
            }
            
            else if (headerCommonIndex==12){
                
                [self datePickerForMalFuncStartDate];
                textField.inputView=self.startMalFunctionDatePicker;
                textField.inputAccessoryView = myDatePickerToolBar;
            }
            
            else if (headerCommonIndex==13){
                
                [self datePickerForMalFuncStartDate];
                textField.inputView=self.startMalFunctionDatePicker;
                textField.inputAccessoryView = myDatePickerToolBar;
            }
            else if (headerCommonIndex==14){
                
                [[textField valueForKey:@"textInputTraits"] setValue:[UIColor clearColor] forKey:@"insertionPointColor"];
                textField.inputView = self.dropDownTableView;
                textField.inputAccessoryView = self.mypickerToolbar;
                
                [self.dropDownArray addObjectsFromArray:[[DataBase sharedInstance] getNotificationEffect]];
                
                self.dropDownTableView.tag = EFFECT;
                
                [self.dropDownTableView reloadData];
                
            }
            
        }
 
       }
    else if (commonAddTableView.tag==0){
 
          if (headerCommonIndex==2) {
 
            [[textField valueForKey:@"textInputTraits"] setValue:[UIColor clearColor] forKey:@"insertionPointColor"];
            
            if ([equipmentID isEqual:@""]) {
 
                [self showAlertMessageWithTitle:@"Information" message:@"Please Select Equipment" cancelButtonTitle:@"OK" withactionType:@"Single" forMethod:nil];
                
                return NO;
            }
            else{
                
                textField.inputView = self.dropDownTableView;
                textField.inputAccessoryView = self.mypickerToolbar;
                
                self.dropDownTableView.tag = DAMAGE;
                [self.dropDownArray addObjectsFromArray:[[DataBase sharedInstance] getComponentsForCatalogID:catalogProfileID]];
                if (![self.dropDownArray count]) {
                    [self.dropDownArray addObjectsFromArray:[[DataBase sharedInstance] getComponentsForNotificationID:@""]];
                    if (![self.dropDownArray count])
                    {
                        //[damageTextField resignFirstResponder];
                     
                [self showAlertMessageWithTitle:@"Information" message:@"No suitable data found for the selected criteria!" cancelButtonTitle:@"OK" withactionType:@"Single" forMethod:nil];
                        
                        return NO;
                    }
                    else{
                        [self.dropDownTableView reloadData];
                    }
                }
                else{
                    [self.dropDownTableView reloadData];
                }
            }
        }
        
        // [[damageCodeTextField valueForKey:@"textInputTraits"] setValue:[UIColor clearColor] forKey:@"insertionPointColor"];
        
        //            [addCauseCodeDataArray addObject:[NSArray arrayWithObjects:@"Object Part",@"Select Object Part",[NSString stringWithFormat:@"%@",[[[self.causeCodeDetailsArray objectAtIndex:indexPath.row] firstObject] objectAtIndex:18]],[[[self.causeCodeDetailsArray objectAtIndex:indexPath.row] firstObject] objectAtIndex:17], nil]];
        //
        //            [addCauseCodeDataArray addObject:[NSArray arrayWithObjects:@"Object Part Code",@"Select Object Part Code",[NSString stringWithFormat:@"%@",[[[self.causeCodeDetailsArray objectAtIndex:indexPath.row] firstObject] objectAtIndex:19]],[[[self.causeCodeDetailsArray objectAtIndex:indexPath.row] firstObject] objectAtIndex:16], nil]];
        //
        //            [addCauseCodeDataArray addObject:[NSArray arrayWithObjects:@"Event",@"Select Event",[NSString stringWithFormat:@"%@",[[[self.causeCodeDetailsArray objectAtIndex:indexPath.row] firstObject] objectAtIndex:3]], nil]];
        //
        //            [addCauseCodeDataArray addObject:[NSArray arrayWithObjects:@"Event Code",@"Select Event Code",[NSString stringWithFormat:@"%@",[[[self.causeCodeDetailsArray objectAtIndex:indexPath.row] firstObject] objectAtIndex:5]], nil]];
        //
        //            [addCauseCodeDataArray addObject:[NSArray arrayWithObjects:@"Event Description",@"Enter Event description",[NSString stringWithFormat:@"%@",[[[self.causeCodeDetailsArray objectAtIndex:indexPath.row] firstObject] objectAtIndex:10]], nil]];
        //
        //            [addCauseCodeDataArray addObject:[NSArray arrayWithObjects:@"Cause",@"Select Cause",[NSString stringWithFormat:@"%@",[[[self.causeCodeDetailsArray objectAtIndex:indexPath.row] firstObject] objectAtIndex:7]], nil]];
        //
        //            [addCauseCodeDataArray addObject:[NSArray arrayWithObjects:@"Cause Code",@"Select Cause Code",[NSString stringWithFormat:@"%@",[[[self.causeCodeDetailsArray objectAtIndex:indexPath.row] firstObject] objectAtIndex:9]], nil]];
        //
        //            [addCauseCodeDataArray addObject:[NSArray arrayWithObjects:@"Cause Description",@"Enter Cause Description",[NSString stringWithFormat:@"%@",[[[self.causeCodeDetailsArray objectAtIndex:indexPath.row] firstObject] objectAtIndex:11]], nil]];
 
        else if (headerCommonIndex == 3){
 
            if ([equipmentID isEqual:@""])
            {
//                UIAlertView *alertNotifType = [[UIAlertView alloc]initWithTitle:@"Information" message:@"Please Select Equipment" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
//
//                [alertNotifType show];
                
                [self showAlertMessageWithTitle:@"Information" message:@"Please Select Equipment" cancelButtonTitle:@"Ok" withactionType:@"Single" forMethod:nil];
                
                return NO;
            }
            else if(![[[addCauseCodeDataArray objectAtIndex:2]  objectAtIndex:3] length]) {
            
                 [self showAlertMessageWithTitle:@"Information" message:@"Please select Damage Group" cancelButtonTitle:@"OK" withactionType:@"Single" forMethod:nil];
 
                return NO;
            }
            else{
                
                
                textField.inputView = self.dropDownTableView;
                textField.inputAccessoryView = self.mypickerToolbar;
                
                self.dropDownTableView.tag = DAMAGECODE;
                
                [self.dropDownArray addObjectsFromArray:[[DataBase sharedInstance] getProblemDetailsForComponentID:[[addCauseCodeDataArray objectAtIndex:2]  objectAtIndex:3] :@"" :@""]];
                if (![self.dropDownArray count]) {
                   // [damageCodeTextField resignFirstResponder];
 
                    [self showAlertMessageWithTitle:@"Information" message:@"No suitable data found for the selected criteria!" cancelButtonTitle:@"OK" withactionType:@"Single" forMethod:nil];
                    
                    return NO;
                }
                else{
                    
                    [self.dropDownTableView reloadData];
                }
            }
        }
        
        else if (headerCommonIndex==5){
            
           
            if ([[[addCauseCodeDataArray objectAtIndex:2] objectAtIndex:3]   isEqualToString:@""]||[[[addCauseCodeDataArray objectAtIndex:3] objectAtIndex:3] isEqualToString:@""])
            {
                [self showAlertMessageWithTitle:@"Information" message:@"Please Select Damage and Damage Code" cancelButtonTitle:@"OK" withactionType:@"Single" forMethod:nil];
                 return NO;
             }
            else
            {
 
                [[textField valueForKey:@"textInputTraits"] setValue:[UIColor clearColor] forKey:@"insertionPointColor"];
                
                if ([equipmentID isEqual:@""]) {
 
                    [self showAlertMessageWithTitle:@"Information" message:@"Please Select Equipment" cancelButtonTitle:@"OK" withactionType:@"Single" forMethod:nil];
                    
                    return NO;
                }
                else{
                    
                    textField.inputView = self.dropDownTableView;
                    textField.inputAccessoryView = self.mypickerToolbar;
                    self.dropDownTableView.tag = CAUSE;
                    [self.dropDownArray addObjectsFromArray:[[DataBase sharedInstance] getCaseGroupForCatalogID:catalogProfileID]];
                    if (![self.dropDownArray count]) {
                        [self.dropDownArray addObjectsFromArray:[[DataBase sharedInstance] getCaseGroupForNotificationID:@""]];
                        if (![self.dropDownArray count])
                        {
                            textField.delegate  = self;
                            
                    [self showAlertMessageWithTitle:@"Information" message:@"No suitable data found for the selected criteria!" cancelButtonTitle:@"OK" withactionType:@"Single" forMethod:nil];
                            
                            return NO;
                        }
                        else{
                            [self.dropDownTableView reloadData];
                        }
                    }
                    else{
                        [self.dropDownTableView reloadData];
                    }
                }
            }
        }
        else if (headerCommonIndex==6){
            
 
              if ([[[addCauseCodeDataArray objectAtIndex:2] objectAtIndex:3]   isEqualToString:@""]||[[[addCauseCodeDataArray objectAtIndex:3]  objectAtIndex:3] isEqualToString:@""])
            {
                //[self causecodesDisabling];
                
            }
            else
            {
               // [self causecodesEnabling];
                
                [[textField valueForKey:@"textInputTraits"] setValue:[UIColor clearColor] forKey:@"insertionPointColor"];
                
                if ([equipmentID isEqual:@""]) {
                    
                    [textField resignFirstResponder];
 
                    [self showAlertMessageWithTitle:@"Information" message:@"Please Select Equipment" cancelButtonTitle:@"OK" withactionType:@"Single" forMethod:nil];
                    
                    return NO;
                }
                else if(![[[addCauseCodeDataArray objectAtIndex:5]  objectAtIndex:3] length]) {
                    
                    [textField resignFirstResponder];
 
                      [self showAlertMessageWithTitle:@"Information" message:@"Please select Cause Group" cancelButtonTitle:@"OK" withactionType:@"Single" forMethod:nil];
                    
                    
                    return NO;
                }
                else{
                    
                    textField.inputView = self.dropDownTableView;
                    textField.inputAccessoryView = self.mypickerToolbar;
                    
                    [self.dropDownArray addObjectsFromArray:[[DataBase sharedInstance] getCauseCodeForCaseGroupID:[[addCauseCodeDataArray objectAtIndex:5]  objectAtIndex:3] :@"" :@""]];
                    
                    if (![self.dropDownArray count]) {
                        
                        [textField resignFirstResponder];
 
                [self showAlertMessageWithTitle:@"Information" message:@"No suitable data found for the selected criteria!" cancelButtonTitle:@"OK" withactionType:@"Single" forMethod:nil];
                        
                        return NO;
                    }
                    else{
                        self.dropDownTableView.tag = CAUSECODE;
                        [self.dropDownTableView reloadData];
                    }
                }
            }
        }
        
        else if (headerCommonIndex==0)
        {
            [[textField valueForKey:@"textInputTraits"] setValue:[UIColor clearColor] forKey:@"insertionPointColor"];

            if ([equipmentID isEqual:@""]) {
              
                 [self showAlertMessageWithTitle:@"Information" message:@"Please Select Equipment" cancelButtonTitle:@"Ok" withactionType:@"Single" forMethod:nil];
                
                return NO;
            }
            else
            {
                textField.inputView = self.dropDownTableView;
                textField.inputAccessoryView = self.mypickerToolbar;

                self.dropDownTableView.tag = OBJECTPARTGROUP;
                [self.dropDownArray addObjectsFromArray:[[DataBase sharedInstance] getObjectGroupForCatalogID:catalogProfileID]];

                if (![self.dropDownArray count]) {
                    [self.dropDownArray addObjectsFromArray:[[DataBase sharedInstance] getObjectGroupForNotificationID:@""]];

                    if (![self.dropDownArray count]) {

                        [textField resignFirstResponder];
 
                  [self showAlertMessageWithTitle:@"Information" message:@"No suitable data found for the selected criteria!" cancelButtonTitle:@"Ok" withactionType:@"Single" forMethod:nil];
                        
                        return NO;
                    }
                    else{

                        [self.dropDownTableView reloadData];
                    }
                }
                else{

                    [self.dropDownTableView reloadData];
                }
            }
        }
        else if (headerCommonIndex==1)
        {
            [[textField valueForKey:@"textInputTraits"] setValue:[UIColor clearColor] forKey:@"insertionPointColor"];

            if ([equipmentID isEqual:@""]) {

                [textField resignFirstResponder];
                
                  [self showAlertMessageWithTitle:@"Information" message:@"Please Select Equipment" cancelButtonTitle:@"Ok" withactionType:@"Single" forMethod:nil];
                
                return NO;
            }
            
            
            else if(![[[addCauseCodeDataArray objectAtIndex:0]  objectAtIndex:3] length]) {
                [textField resignFirstResponder];
              
                 [self showAlertMessageWithTitle:@"Information" message:@"Please select Object Part Group" cancelButtonTitle:@"Ok" withactionType:@"Single" forMethod:nil];
 
                return NO;
            }
            else
            {
                textField.inputView = self.dropDownTableView;
                textField.inputAccessoryView = self.mypickerToolbar;

                self.dropDownTableView.tag = OBJECTPART;

                [self.dropDownArray addObjectsFromArray:[[DataBase sharedInstance] getObjectGroupDetailsForObjectGroupID:[[addCauseCodeDataArray objectAtIndex:0]  objectAtIndex:3] :@"" :@""]];

                if (![self.dropDownArray count]) {
                    [textField resignFirstResponder];
                    
            [self showAlertMessageWithTitle:@"Information" message:@"No suitable data found for the selected criteria!" cancelButtonTitle:@"Ok" withactionType:@"Single" forMethod:nil];
                   
                    return NO;
                }
                else{

                    [self.dropDownTableView reloadData];
                }
            }
        }
        
        else{
            
            textField.inputView=nil;
            textField.inputAccessoryView=nil;
            
        }
     }
//
//    else if (commonAddTableView.tag==1){
//
//        if (headerCommonIndex==0) {
//
//            [[textField valueForKey:@"textInputTraits"] setValue:[UIColor clearColor] forKey:@"insertionPointColor"];
//
//                textField.inputView = self.dropDownTableView;
//                textField.inputAccessoryView = self.mypickerToolbar;
//
//                self.dropDownTableView.tag = TASKCODEGROUP;
//                [self.dropDownArray addObjectsFromArray:[[DataBase sharedInstance] getTaskGroupForCatalogID:@""]];
//                if (![self.dropDownArray count]) {
//                    [textField resignFirstResponder];
//
//                    [self showAlertMessageWithTitle:@"Information" message:@"No suitable data found for the selected criteria!" cancelButtonTitle:@"Ok" withactionType:@"Single" forMethod:nil];
//
//                    return NO;
//                }
//                else{
//
//                    if ([notificationTypeID isEqualToString:@"M2"]) {
//
//                        for (int i =0; i<[self.dropDownArray count]; i++) {
//
//                            if ([[[self.dropDownArray objectAtIndex:i] objectAtIndex:ID_INDEX] isEqualToString:@"PM1"]) {
//                                [self.dropDownArray removeObjectAtIndex:i];
//                                [self.dropDownTableView reloadData];
//                                return TRUE;
//                            }
//                        }
//                    }
//                    else{
//                        [self.dropDownTableView reloadData];
//                    }
//                }
//          }
//
//        else if (headerCommonIndex==1){
//
//            [[textField valueForKey:@"textInputTraits"] setValue:[UIColor clearColor] forKey:@"insertionPointColor"];
//
//            if(!textField.text.length) {
//                [textField resignFirstResponder];
//
//                 [self showAlertMessageWithTitle:@"Information" message:@"Please select Task Group" cancelButtonTitle:@"Ok" withactionType:@"Single" forMethod:nil];
//
//                return NO;
//            }
//            else
//            {
//                textField.inputView = self.dropDownTableView;
//                textField.inputAccessoryView = self.mypickerToolbar;
//
//                self.dropDownTableView.tag = TASKGROUP;
//
//                [self.dropDownArray addObjectsFromArray:[[DataBase sharedInstance] getTaskGroupDetailsForTaskCodeID:taskGroupID :@"" :catalogProfileID]];
//
//                if (![self.dropDownArray count]) {
//
//                    [textField resignFirstResponder];
//
//                [self showAlertMessageWithTitle:@"Information" message:@"No suitable data found for the selected criteria!" cancelButtonTitle:@"Ok" withactionType:@"Single" forMethod:nil];
//
//                    return NO;
//                }
//                else{
//
//                    [self.dropDownTableView reloadData];
//                }
//            }
//        }
//
//        else if (headerCommonIndex==5)
//        {
//            [self datePickerForMalFuncStartDate];
//            textField.inputView=self.startMalFunctionDatePicker;
//            textField.inputAccessoryView = myDatePickerToolBar;
//
//         }
//         else if (headerCommonIndex==6)
//         {
//             [self datePickerForMalFuncStartDate];
//             textField.inputView=self.startMalFunctionDatePicker;
//             textField.inputAccessoryView = myDatePickerToolBar;
//
//         }
//        else if (headerCommonIndex==7)
//        {
//            [self datePickerForPlannedTime];
//            textField.inputView =self.plannedDatePicker;
//             textField.inputAccessoryView = myDatePickerToolBar;
//         }
//         else if (headerCommonIndex==8)
//         {
//            [self datePickerForPlannedTime];
//             textField.inputView =self.plannedDatePicker;
//             textField.inputAccessoryView = myDatePickerToolBar;
//
//         }
//      }
    else if (commonAddTableView.tag==2){
        
        if (headerCommonIndex==0) {
            
            [[textField valueForKey:@"textInputTraits"] setValue:[UIColor clearColor] forKey:@"insertionPointColor"];
            textField.inputView = self.dropDownTableView;
            textField.inputAccessoryView = self.mypickerToolbar;
            
            [self.dropDownArray addObjectsFromArray:self.itemKeyDetailsArray];
            self.dropDownTableView.tag = ACTIVITY_ITEM_KEY;
            
            [self.dropDownTableView reloadData];
        }
        else if (headerCommonIndex==3){
            
             [[textField valueForKey:@"textInputTraits"] setValue:[UIColor clearColor] forKey:@"insertionPointColor"];
 
                textField.inputView = self.dropDownTableView;
                textField.inputAccessoryView = self.mypickerToolbar;
                 self.dropDownTableView.tag = ACTIVITY_CODEGROUP;
               [self.dropDownArray addObjectsFromArray:[[DataBase sharedInstance] getActivityCodeGroups:@""]];
                if (![self.dropDownArray count]) {
 
                    [self showAlertMessageWithTitle:@"Information" message:@"No suitable data found for the selected criteria!" cancelButtonTitle:@"OK" withactionType:@"Single" forMethod:nil];
 
                        return NO;
                    }
                    else{
                        [self.dropDownTableView reloadData];
                    }
            }
        
        else if (headerCommonIndex==4){
            
            [[textField valueForKey:@"textInputTraits"] setValue:[UIColor clearColor] forKey:@"insertionPointColor"];
            
            textField.inputView = self.dropDownTableView;
            textField.inputAccessoryView = self.mypickerToolbar;
            self.dropDownTableView.tag = ACTIVITY_CODE;
            if ([[[addActivityArray objectAtIndex:3] objectAtIndex:3] isEqualToString:@""]) {
                
                [self showAlertMessageWithTitle:@"Information" message:@"Please select Object Part Group" cancelButtonTitle:@"Ok" withactionType:@"Single" forMethod:nil];

            }
            [self.dropDownArray addObjectsFromArray:[[DataBase sharedInstance] getActivityCodes:[[addActivityArray objectAtIndex:3] objectAtIndex:3]]];
            if (![self.dropDownArray count]) {
                
                [self showAlertMessageWithTitle:@"Information" message:@"No suitable data found for the selected criteria!" cancelButtonTitle:@"Ok" withactionType:@"Single" forMethod:nil];
                
                 return NO;
            }
            else{
                [self.dropDownTableView reloadData];
            }
            
        }
          else if (headerCommonIndex==6){
 
            [self datePickerForMalFuncStartDate];
            textField.inputView=self.startMalFunctionDatePicker;
            textField.inputAccessoryView = myDatePickerToolBar;
        }
         else if (headerCommonIndex==7){
            [self datePickerForMalFuncStartDate];
             textField.inputView=self.startMalFunctionDatePicker;
             textField.inputAccessoryView = myDatePickerToolBar;
        }
        
         else if (headerCommonIndex==8){
             
             [self datePickerForPlannedTime];
             textField.inputView =self.plannedDatePicker;
             textField.inputAccessoryView = myDatePickerToolBar;
         }
         else if (headerCommonIndex==9){
             [self datePickerForPlannedTime];
             textField.inputView =self.plannedDatePicker;
             textField.inputAccessoryView = myDatePickerToolBar;
         }
        
         else{
             
             textField.inputView =nil;
             textField.inputAccessoryView = nil;
         }
     }
 
    return YES;
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    
    headerCommonIndex = (int)textField.superview.tag;

    if (commomlistListTableview.tag==0) {
 
        if (!createNotificationFlag) {
            
            if (headerCommonIndex==10) {
                
                [[headerDataArray objectAtIndex:10] replaceObjectAtIndex:2 withObject:textField.text];
             }
            
            commomlistListTableview.tag=0;
         }
        else{
            
            if (headerCommonIndex==1) {
                
                [[headerDataArray objectAtIndex:1] replaceObjectAtIndex:2 withObject:textField.text];
            }
            
            else if (headerCommonIndex==7){
                
                [[headerDataArray objectAtIndex:7] replaceObjectAtIndex:2 withObject:textField.text];
             }
            
            else if (headerCommonIndex==8){
                
                [[headerDataArray objectAtIndex:8] replaceObjectAtIndex:2 withObject:textField.text];
             }
 
            else  if (headerCommonIndex==2) {
                
                locationId=@"";
                
                [[headerDataArray objectAtIndex:2] replaceObjectAtIndex:2 withObject:@""];
                [[headerDataArray objectAtIndex:2] replaceObjectAtIndex:3 withObject:@""];
                
                commomlistListTableview.tag=0;
             }
          }
       }
    
     else if (commomlistListTableview.tag==1){
        
        if (headerCommonIndex==4) {
             [[addCauseCodeDataArray objectAtIndex:4] replaceObjectAtIndex:2 withObject:textField.text];
         }
         else if (headerCommonIndex==7){
             [[addCauseCodeDataArray objectAtIndex:7] replaceObjectAtIndex:2 withObject:textField.text];
         }
         
     }
    else if (commomlistListTableview.tag==2){
 
        if (headerCommonIndex==5) {
             [[addActivityArray objectAtIndex:5] replaceObjectAtIndex:2 withObject:textField.text];
         }
      }
    
     [commomlistListTableview reloadData];
 
    return YES;
}

#pragma mark-
#pragma mark-Date Picker for Text Field

//for MeasurementDatepicker.
-(void)datePickerForPlannedTime{
    
    self.plannedDatePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, 250, 0, 0)];
    
    self.plannedDatePicker.datePickerMode = UIDatePickerModeTime;
 
     myDatePickerToolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 100, 320, 56)];
    
    myDatePickerToolBar.barStyle = UIBarStyleBlackOpaque;
    
    [myDatePickerToolBar sizeToFit];
    
    NSMutableArray *barItems = [[NSMutableArray alloc] init];
    
    UIBarButtonItem *cnclBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(plannedTimeCancelClicked)];
    
    [barItems addObject:cnclBtn];
    
    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    [barItems addObject:flexSpace];
    
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(plannedTimeDoneClicked)];
    
    [barItems addObject:doneBtn];
    
    [myDatePickerToolBar setItems:barItems animated:YES];
    
    
}


-(void)plannedTimeCancelClicked
{
    [commonAddTableView endEditing:YES];
}

-(void)plannedTimeDoneClicked
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
//    if (headerCommonIndex==7) {
//
//        [dateFormatter setDateFormat:@"HH:mm:ss"];
//         [[addTaskCodeDataArray objectAtIndex:7] replaceObjectAtIndex:2 withObject:[dateFormatter stringFromDate:self.plannedDatePicker.date]];
//
//      }
//
//    else if (headerCommonIndex==8){
//
//        [dateFormatter setDateFormat:@"HH:mm:ss"];
//        [[addTaskCodeDataArray objectAtIndex:8] replaceObjectAtIndex:2 withObject:[dateFormatter stringFromDate:self.plannedDatePicker.date]];
//
//    }
    
    if (headerCommonIndex==8) {
        
        [dateFormatter setDateFormat:@"HH:mm:ss"];
        [[addActivityArray objectAtIndex:8] replaceObjectAtIndex:2 withObject:[dateFormatter stringFromDate:self.plannedDatePicker.date]];
        
    }
   else if (headerCommonIndex==9) {
        
        [dateFormatter setDateFormat:@"HH:mm:ss"];
        [[addActivityArray objectAtIndex:9] replaceObjectAtIndex:2 withObject:[dateFormatter stringFromDate:self.plannedDatePicker.date]];
        
    }
    
    [commonAddTableView reloadData];
    [commonAddTableView endEditing:YES];
    
 }


 
-(IBAction)backButtonClicked:(id)sender
{
    
    [self showAlertMessageWithTitle:@"Decision" message:@"Do you want to navigate to My Notifications?" cancelButtonTitle:@"No" withactionType:@"Multiple" forMethod:@"back"];
    
 }

-(IBAction)duplicateNotificationButton:(id)sender{
    
    [duplicateNotificationView removeFromSuperview];
    
    submitResetView.hidden=NO;
    
    [self showAlertMessageWithTitle:@"Decision" message:@"Do you want to submit for Notification creation?" cancelButtonTitle:@"No" withactionType:@"Multiple" forMethod:@"Create Notification"];
 
 }

-(IBAction)addButtonSelected:(id)sender
{
     [addCauseTaskBtn setTitle:@"Add" forState:UIControlStateNormal];
 
    [commonAddTableView scrollRectToVisible:CGRectMake(0, 0, 0, 0) animated:YES];

 
        if (isCausecodeSelected) {
             [self loadCauseCodeDetails];
         }
        else{
            
            if ([self.causeCodeDetailsArray count]) {
                 [self loadActivityData];
             }
             else{
                
                 [self showAlertMessageWithTitle:@"Decision" message:@"Please Add Atleast one Notification Item." cancelButtonTitle:@"OK" withactionType:@"Single" forMethod:@"Create Notification"];
             }
        }
    
     submitResetView.hidden=YES;
     [commonAddTableView reloadData];
    
 }
-(IBAction)submitCauseTaskClicked:(id)sender{
    
    
    
}

-(IBAction)cancelCauseTaskClicked:(id)sender{
    
    [addCauseTaskView removeFromSuperview];
    
}

-(IBAction)addCauseTaskDetailsClicked:(id)sender
{
    if (commonAddTableView.tag==0)
    {
        if (updateFlag) {
            
            itemSelectedFlag = NO;
            
            if(![JEValidator validateTextValue:[[addCauseCodeDataArray objectAtIndex:2] objectAtIndex:3]])
            {
 
                [self showAlertMessageWithTitle:@"Failure" message:@"Please enter damage group" cancelButtonTitle:@"Ok" withactionType:@"Single" forMethod:nil];
            }
            else if(![JEValidator validateTextValue:[[addCauseCodeDataArray objectAtIndex:3] objectAtIndex:3]])
            {
 
                [self showAlertMessageWithTitle:@"Failure" message:@"Please enter damage code" cancelButtonTitle:@"Ok" withactionType:@"Single" forMethod:nil];
            }
            else
            {
 
                NSMutableDictionary *causeCodeDetailsDictionary = [NSMutableDictionary new];
                
                [causeCodeDetailsDictionary setObject:[[[self.detailNotificationArray objectAtIndex:0] objectForKey:@"notificationh_id"] copy] forKey:@"ID"];
                
                [causeCodeDetailsDictionary setObject:[vornrItemID copy] forKey:@"ITEMKEY"];
                [causeCodeDetailsDictionary setObject:[vornrCauseCodeID copy] forKey:@"CAUSEKEY"];
                
                [causeCodeDetailsDictionary setObject:[[[addCauseCodeDataArray objectAtIndex:2] objectAtIndex:3] copy] forKey:@"DAMAGEID"];
                
                [causeCodeDetailsDictionary setObject:[[[addCauseCodeDataArray objectAtIndex:2] objectAtIndex:2] copy] forKey:@"DAMAGETEXT"];
                
                [causeCodeDetailsDictionary setObject:[[[addCauseCodeDataArray objectAtIndex:3]  objectAtIndex:3] copy] forKey:@"DAMAGECODEID"];
                
                [causeCodeDetailsDictionary setObject:[[[addCauseCodeDataArray objectAtIndex:3] objectAtIndex:2] copy] forKey:@"DAMAGECODETEXT"];
                
                [causeCodeDetailsDictionary setObject:[[[addCauseCodeDataArray objectAtIndex:4] objectAtIndex:2] copy] forKey:@"DAMAGEDESCRIPTION"];
                
                [causeCodeDetailsDictionary setObject:[[[addCauseCodeDataArray objectAtIndex:0] objectAtIndex:3] copy] forKey:@"OBJECTPARTGROUPID"];
                
                [causeCodeDetailsDictionary setObject:[[[addCauseCodeDataArray objectAtIndex:1] objectAtIndex:3] copy] forKey:@"OBJECTPARTID"];
                
                [causeCodeDetailsDictionary setObject:[[[addCauseCodeDataArray objectAtIndex:0] objectAtIndex:2] copy] forKey:@"OBJECTPARTGROUPTEXT"];
                
                [causeCodeDetailsDictionary setObject:[[[addCauseCodeDataArray objectAtIndex:1] objectAtIndex:2] copy] forKey:@"OBJECTPARTTEXT"];
                
                [causeCodeDetailsDictionary setObject:@"U" forKey:@"ITEMSTATUS"];
                
                [causeCodeDetailsDictionary setObject:@"" forKey:@"CAUSEKEY"];
                
                [causeCodeDetailsDictionary setObject:[[[addCauseCodeDataArray objectAtIndex:5] objectAtIndex:3] copy] forKey:@"CAUSEID"];
                
                [causeCodeDetailsDictionary setObject:[[[addCauseCodeDataArray objectAtIndex:5] objectAtIndex:2] copy] forKey:@"CAUSETEXT"];
                
                [causeCodeDetailsDictionary setObject:[[[addCauseCodeDataArray objectAtIndex:6] objectAtIndex:3] copy] forKey:@"CAUSECODEID"];
                
                [causeCodeDetailsDictionary setObject:[[[addCauseCodeDataArray objectAtIndex:6] objectAtIndex:2] copy] forKey:@"CAUSECODETEXT"];
                
                [causeCodeDetailsDictionary setObject:[[[addCauseCodeDataArray objectAtIndex:7] objectAtIndex:2] copy] forKey:@"CAUSEDESCRIPTION"];
                
                [causeCodeDetailsDictionary setObject:[NSArray arrayWithObjects:[defaults objectForKey:@"tempCustomDamage"],[defaults objectForKey:@"tempCustomCause"], nil] forKey:@"CUSTOM"];
                
                [[DataBase sharedInstance] updateNotificationTransactions:causeCodeDetailsDictionary];
                
                [self.causeCodeDetailsArray removeAllObjects];
                
                [self.causeCodeDetailsArray addObjectsFromArray:[[DataBase sharedInstance] fetchNotificationTransactionDetailsForUUID:[[self.detailNotificationArray objectAtIndex:0] objectForKey:@"notificationh_id"]]];
                
                VornrItem = 0;
                VornrCauseCode = 1;
                
                for (int i=0; i<[self.causeCodeDetailsArray count]; i++) {
                    if ([[[[self.causeCodeDetailsArray objectAtIndex:i] firstObject] objectAtIndex:14] isEqualToString:@"D"]){
                        [self.causeCodeDetailDeleteArray addObject:[NSMutableArray arrayWithArray:[self.causeCodeDetailsArray objectAtIndex:i]]];
                        [self.causeCodeDetailsArray removeObjectAtIndex:i];
                        --i;
                    }
                    
                    vornrItemID = [[[self.causeCodeDetailsArray  objectAtIndex:i] firstObject]  objectAtIndex:12];
                }
                
                VornrItem = [vornrItemID intValue];
                
                VornrItem = VornrItem +1;
 
 
                for (int  i  =0; i<[self.customDamageDetailsArray count]; i++) {
                    [[self.customDamageDetailsArray objectAtIndex:i] replaceObjectAtIndex:4 withObject:@""];
                }
                
                for (int  i  =0; i<[self.customCauseDetailsArray count]; i++) {
                    [[self.customCauseDetailsArray objectAtIndex:i] replaceObjectAtIndex:4 withObject:@""];
                }
                
                [defaults setObject:self.customDamageDetailsArray forKey:@"tempCustomDamage"];
                [defaults setObject:self.customCauseDetailsArray forKey:@"tempCustomCause"];
                [defaults synchronize];
                
                commomlistListTableview.tag=1;
                [commomlistListTableview reloadData];
                
                customDamageFieldFlag = YES;
                customCauseFieldFlag = YES;
                
                submitResetView.hidden=NO;
                
                [addCauseTaskView removeFromSuperview];
                
             }
        }
        
        else{
            
            if(![JEValidator validateTextValue:[[addCauseCodeDataArray objectAtIndex:2] objectAtIndex:2]])
            {
                
                [self showAlertMessageWithTitle:@"Information" message:@"Please Select Damage" cancelButtonTitle:@"Ok" withactionType:@"Single" forMethod:nil];
                
            }
            else if(![JEValidator validateTextValue:[[addCauseCodeDataArray objectAtIndex:3] objectAtIndex:2]])
            {
                
                [self showAlertMessageWithTitle:@"Information" message:@"Please Select Damage Code" cancelButtonTitle:@"Ok" withactionType:@"Single" forMethod:nil];
                
            }
            else if(![JEValidator validateTextValue:[[addCauseCodeDataArray objectAtIndex:5] objectAtIndex:2]])
            {
                
                [self showAlertMessageWithTitle:@"Information" message:@"Please Select Cause" cancelButtonTitle:@"Ok" withactionType:@"Single" forMethod:nil];
                
                
            }
            else if(![JEValidator validateTextValue:[[addCauseCodeDataArray objectAtIndex:6]  objectAtIndex:2]])
            {
                
                [self showAlertMessageWithTitle:@"Information" message:@"Please Select Cause Code" cancelButtonTitle:@"Ok" withactionType:@"Single" forMethod:nil];
                
            }
            else{
                
                //self.updateCauseCodesBtn.hidden = YES;
                
                vornrItemID = [NSString stringWithFormat:@"%04i",VornrItem];
                
                vornrCauseCodeID =[NSString stringWithFormat:@"%04i",VornrCauseCode];
                
                //            if (![damageDescriptionTextField.text length]) {
                //                damageDescriptionTextField.text = @"";
                //            }
                //
                //            if (![causeDescriptionTextField.text length]) {
                //                causeDescriptionTextField.text = @"";
                //            }
                
                if(![JEValidator validateTextValue:[[addCauseCodeDataArray objectAtIndex:5]  objectAtIndex:2]] && ![JEValidator validateTextValue:[[addCauseCodeDataArray  objectAtIndex:6] objectAtIndex:2]])
                {
                    NSMutableDictionary *causeCodeDetailsDictionary = [NSMutableDictionary new];
                    
                    [causeCodeDetailsDictionary setObject:[notificationUDID copy] forKey:@"ID"];
                    [causeCodeDetailsDictionary setObject:[vornrItemID copy] forKey:@"ITEMKEY"];
                    [causeCodeDetailsDictionary setObject:[[[addCauseCodeDataArray objectAtIndex:2] objectAtIndex:3] copy] forKey:@"DAMAGEID"];
                    [causeCodeDetailsDictionary setObject:[[[addCauseCodeDataArray objectAtIndex:2] objectAtIndex:2] copy] forKey:@"DAMAGETEXT"];
                    
                    [causeCodeDetailsDictionary setObject:[[[addCauseCodeDataArray objectAtIndex:3]  objectAtIndex:3] copy] forKey:@"DAMAGECODEID"];
                    
                    [causeCodeDetailsDictionary setObject:[[[addCauseCodeDataArray objectAtIndex:3] objectAtIndex:2] copy] forKey:@"DAMAGECODETEXT"];
                    
                    [causeCodeDetailsDictionary setObject:[[[addCauseCodeDataArray objectAtIndex:4] objectAtIndex:2] copy] forKey:@"DAMAGEDESCRIPTION"];
                    
                    [causeCodeDetailsDictionary setObject:[[[addCauseCodeDataArray objectAtIndex:0] objectAtIndex:3] copy] forKey:@"OBJECTPARTGROUPID"];
                    
                    [causeCodeDetailsDictionary setObject:[[[addCauseCodeDataArray objectAtIndex:1] objectAtIndex:3] copy] forKey:@"OBJECTPARTID"];
                    
                    [causeCodeDetailsDictionary setObject:[[[addCauseCodeDataArray objectAtIndex:0] objectAtIndex:2] copy] forKey:@"OBJECTPARTGROUPTEXT"];
                    
                    [causeCodeDetailsDictionary setObject:[[[addCauseCodeDataArray objectAtIndex:1] objectAtIndex:2] copy] forKey:@"OBJECTPARTTEXT"];
                    
                    [causeCodeDetailsDictionary setObject:@"A" forKey:@"ITEMSTATUS"];
                    
                    [causeCodeDetailsDictionary setObject:@"" forKey:@"CAUSEKEY"];
                    
                    [causeCodeDetailsDictionary setObject:[[[addCauseCodeDataArray objectAtIndex:5] objectAtIndex:3] copy] forKey:@"CAUSEID"];
                    
                    [causeCodeDetailsDictionary setObject:[[[addCauseCodeDataArray objectAtIndex:5] objectAtIndex:2] copy] forKey:@"CAUSETEXT"];
                    
                    [causeCodeDetailsDictionary setObject:[[[addCauseCodeDataArray objectAtIndex:6] objectAtIndex:3] copy] forKey:@"CAUSECODEID"];
                    
                    [causeCodeDetailsDictionary setObject:[[[addCauseCodeDataArray objectAtIndex:6] objectAtIndex:2] copy] forKey:@"CAUSECODETEXT"];
                    
                    [causeCodeDetailsDictionary setObject:[[[addCauseCodeDataArray objectAtIndex:7] objectAtIndex:2] copy] forKey:@"CAUSEDESCRIPTION"];
                    
                    [causeCodeDetailsDictionary setObject:@"A" forKey:@"CAUSESTATUS"];
                    
                    [causeCodeDetailsDictionary setObject:[NSArray arrayWithObjects:[defaults objectForKey:@"tempCustomDamage"],[defaults objectForKey:@"tempCustomCause"], nil]  forKey:@"CUSTOM"];
                    
                    [[DataBase sharedInstance] insertNotificationTransactions:causeCodeDetailsDictionary];
                    
                    [self.causeCodeDetailsArray removeAllObjects];
                    
                    [self.causeCodeDetailsArray addObjectsFromArray:[[DataBase sharedInstance] fetchNotificationTransactionDetailsForUUID:notificationUDID]];
                    
                    /*  NSMutableArray *tempCauseCodeDetailsArray= [NSMutableArray new];
                     
                     [tempCauseCodeDetailsArray addObjectsFromArray:[NSArray arrayWithObjects:@"",[notificationUDID copy],[damageID copy],[damageTextField.text copy],[damageCodeID copy],[damageCodeTextField.text copy],[causeID copy],[causeTextField.text copy],[causeCodeID copy],[causeCodeTextField.text copy],[damageDescriptionTextField.text copy],[causeDescriptionTextField.text copy],[vornrItemID copy],@"",@"A",@"A", nil]];
                     
                     [self.causeCodeDetailsArray addObject:[NSMutableArray arrayWithObjects:tempCauseCodeDetailsArray,[defaults objectForKey:@"tempCustomDamage"],[defaults objectForKey:@"tempCustomCause"], nil]];*/
                    
                    clearCuaseFields=YES;
                    
                    
                    [[addCauseCodeDataArray objectAtIndex:2] replaceObjectAtIndex:2 withObject:@""];
                    [[addCauseCodeDataArray objectAtIndex:2] replaceObjectAtIndex:3 withObject:@""];
                    
                    [[addCauseCodeDataArray objectAtIndex:3] replaceObjectAtIndex:2 withObject:@""];
                    [[addCauseCodeDataArray objectAtIndex:3] replaceObjectAtIndex:3 withObject:@""];
                    
                    [[addCauseCodeDataArray objectAtIndex:4] replaceObjectAtIndex:2 withObject:@""];
                    
                    [[addCauseCodeDataArray objectAtIndex:5] replaceObjectAtIndex:2 withObject:@""];
                    [[addCauseCodeDataArray objectAtIndex:5] replaceObjectAtIndex:3 withObject:@""];
                    
                    [[addCauseCodeDataArray objectAtIndex:6] replaceObjectAtIndex:2 withObject:@""];
                    [[addCauseCodeDataArray objectAtIndex:6] replaceObjectAtIndex:3 withObject:@""];
                    
                    [[addCauseCodeDataArray objectAtIndex:7] replaceObjectAtIndex:2 withObject:@""];
                    
                    commonAddTableView.tag=0;
                    [commonAddTableView reloadData];
 
 
                    VornrItem = 0;
                    VornrCauseCode = 1;
                    
                    NSMutableArray *temparray = [NSMutableArray new];
                    
                    for (int i=0; i<[self.causeCodeDetailsArray count]; i++) {
                        
                        if ([[[[self.causeCodeDetailsArray objectAtIndex:i] firstObject] objectAtIndex:14] isEqualToString:@"D"]){
                            [self.causeCodeDetailDeleteArray addObject:[NSMutableArray arrayWithArray:[self.causeCodeDetailsArray objectAtIndex:i]]];
                            [self.causeCodeDetailsArray removeObjectAtIndex:i];
                            
                            [temparray addObject:[self.causeCodeDetailsArray objectAtIndex:i]];
                            --i;
                        }
 
                        if (i==-1) {
                            i=0;
                        }
 
                        vornrItemID = [[[self.causeCodeDetailsArray  objectAtIndex:i] firstObject]  objectAtIndex:12];
                    }
                    
                    if ([temparray count]) {
                        for (int k=0; k<[self.causeCodeDetailsArray count]; k++) {
                            if ([[[[self.causeCodeDetailsArray  objectAtIndex:k] firstObject]  objectAtIndex:12] isEqualToString:[[[temparray objectAtIndex:k] firstObject]  objectAtIndex:12]]) {
                                
                                [self.causeCodeDetailsArray removeObjectAtIndex:k];
                            }
                            
                        }
                    }
                    
                    VornrItem = [vornrItemID intValue];
                    
                    VornrItem = VornrItem +1;
                    
                    commomlistListTableview.tag=1;
                    
                    [commomlistListTableview reloadData];
                    
                    if (commonAddTableView.tag==0) {
                        
                        [commonAddTableView setUserInteractionEnabled:NO];
                        
                    }
                    
                    //  [self causecodesDisabling];
                    
                    //                damageTextField.userInteractionEnabled = YES;
                    //                damageCodeTextField.userInteractionEnabled = YES;
                    //                damageDescriptionTextField.userInteractionEnabled = YES;
                    
                    for (int  i  =0; i<[self.customDamageDetailsArray count]; i++) {
                        [[[self.customDamageDetailsArray mutableCopy] objectAtIndex:i] replaceObjectAtIndex:4 withObject:@""];
                    }
                    
                    for (int  i  =0; i<[self.customCauseDetailsArray count]; i++) {
                        [[[self.customCauseDetailsArray mutableCopy] objectAtIndex:i] replaceObjectAtIndex:4 withObject:@""];
                    }
                    
                    [defaults setObject:self.customDamageDetailsArray forKey:@"tempCustomDamage"];
                    [defaults setObject:self.customCauseDetailsArray forKey:@"tempCustomCause"];
                    [defaults synchronize];
                    
                    [addCauseTaskView removeFromSuperview];
                }
                else
                {
                  //  [self showAlertMessageWithTitle:@"Information" message:@"Would you like to add another cause for this item?" cancelButtonTitle:@"NO" withactionType:@"Multiple" forMethod:@"addMoreCauseCode"];
                    
                    [self addCauseCodeDetailsMethod];

                    
                }
            }
         }
     }
    
     else if (commonAddTableView.tag==2){
 
         if (!updateActivityFlag) {
             
             NSMutableDictionary *addActivityDetailsDictionary = [NSMutableDictionary new];
             
             [addActivityDetailsDictionary setObject:[notificationUDID copy] forKey:@"ID"];
             
             [addActivityDetailsDictionary setObject:[[[addActivityArray objectAtIndex:0] objectAtIndex:2] copy] forKey:@"ITEMKEY"];
             
             
             if (![NullChecker isNull:[[addCauseCodeDataArray objectAtIndex:0] objectAtIndex:3]]) {
                 
                 [addActivityDetailsDictionary setObject:[[[addCauseCodeDataArray objectAtIndex:0] objectAtIndex:3] copy] forKey:@"OBJECTPART"];
             }
             else{
                 [addActivityDetailsDictionary setObject:@"" forKey:@"OBJECTPART"];
             }
             
             if (![NullChecker isNull:[[addCauseCodeDataArray objectAtIndex:1] objectAtIndex:3]]) {
                 
                 [addActivityDetailsDictionary setObject:[[[addCauseCodeDataArray objectAtIndex:0] objectAtIndex:3] copy] forKey:@"OBJECTPART"];
             }
             else{
                 [addActivityDetailsDictionary setObject:@"" forKey:@"OBJECTPART"];
             }
             
             if (![NullChecker isNull:[[addCauseCodeDataArray objectAtIndex:1] objectAtIndex:3]]) {
                 
                 [addActivityDetailsDictionary setObject:[[[addCauseCodeDataArray objectAtIndex:1] objectAtIndex:3] copy] forKey:@"OBJECTPARTCODE"];
             }
             else{
                 [addActivityDetailsDictionary setObject:@"" forKey:@"OBJECTPARTCODE"];
             }
             
             [addActivityDetailsDictionary setObject:@"" forKey:@"OBJECTPARTDESCRIPTION"];
             
             
             if (![NullChecker isNull:[[addCauseCodeDataArray objectAtIndex:3] objectAtIndex:3]]) {
                 
                 [addActivityDetailsDictionary setObject:[[addCauseCodeDataArray objectAtIndex:3] objectAtIndex:3] forKey:@"DAMAGE"];
             }
             else{
                 [addActivityDetailsDictionary setObject:@"" forKey:@"DAMAGE"];
             }
             
             
             if (![NullChecker isNull:[[addCauseCodeDataArray objectAtIndex:2] objectAtIndex:3]]) {
                 
                 [addActivityDetailsDictionary setObject:[[addCauseCodeDataArray objectAtIndex:2] objectAtIndex:3] forKey:@"DAMAGECODE"];
             }
             else{
                 [addActivityDetailsDictionary setObject:@"" forKey:@"DAMAGECODE"];
             }
             
            [addActivityDetailsDictionary setObject:@"" forKey:@"DAMAGEDESCRIPTION"];
 
             if (![NullChecker isNull:[[addCauseCodeDataArray objectAtIndex:5] objectAtIndex:3]]) {
                 
                 [addActivityDetailsDictionary setObject:[[addCauseCodeDataArray objectAtIndex:5] objectAtIndex:3] forKey:@"CAUSECODECODEGROUP"];
                 
             }
             else{
                 [addActivityDetailsDictionary setObject:@"" forKey:@"CAUSECODECODEGROUP"];
             }
             
             if (![NullChecker isNull:[[addCauseCodeDataArray objectAtIndex:6] objectAtIndex:3]]) {
                 
                 [addActivityDetailsDictionary setObject:[[addCauseCodeDataArray objectAtIndex:6] objectAtIndex:3] forKey:@"CAUSECODECODEGROUP"];
             }
             else{
                 [addActivityDetailsDictionary setObject:@"" forKey:@"CAUSECODECODEGROUP"];
             }
             
             if (![NullChecker isNull:[[addCauseCodeDataArray objectAtIndex:7] objectAtIndex:3]]) {
                 
                 [addActivityDetailsDictionary setObject:[[addCauseCodeDataArray objectAtIndex:7] objectAtIndex:3] forKey:@"CAUSECODE"];
             }
             else{
                 [addActivityDetailsDictionary setObject:@"" forKey:@"CAUSECODE"];
             }
             
             [addActivityDetailsDictionary setObject:@"" forKey:@"CODEDESCRIPTION"];
             
             
             [addActivityDetailsDictionary setObject:[[[addActivityArray objectAtIndex:0] objectAtIndex:2] copy] forKey:@"ACTIVITYITEMKEY"];
             
             [addActivityDetailsDictionary setObject:[[[addActivityArray objectAtIndex:3] objectAtIndex:3] copy] forKey:@"ACTIVITYGROUP"];
             
             [addActivityDetailsDictionary setObject:[[[addActivityArray objectAtIndex:3] objectAtIndex:2] copy] forKey:@"ACTIVITYGROUPTEXT"];
             
             [addActivityDetailsDictionary setObject:[[[addActivityArray objectAtIndex:4] objectAtIndex:3] copy] forKey:@"ACTIVITYCODE"];
             
             [addActivityDetailsDictionary setObject:[[[addActivityArray objectAtIndex:4] objectAtIndex:2] copy] forKey:@"ACTIVITYCODETEXT"];
             
             [addActivityDetailsDictionary setObject:[[[addActivityArray objectAtIndex:5] objectAtIndex:2] copy] forKey:@"ACTIVITYSHORTTEXT"];
             
             [addActivityDetailsDictionary setObject:@"" forKey:@"QMNUM"];
             
             NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
             [dateFormatter setDateFormat:@"MMM dd, yyyy"];
             
             NSDate *requiredstartDate = [dateFormatter dateFromString:[[[addActivityArray objectAtIndex:6] objectAtIndex:2] copy]];
             
             NSDate *requiredendDate = [dateFormatter dateFromString:[[[addActivityArray objectAtIndex:7] objectAtIndex:2] copy]];
             
             
             // Convert date object into desired format
             [dateFormatter setDateFormat:@"yyyyMMdd"];
             
             NSString *convertedrequiredStartDateString = [dateFormatter stringFromDate:requiredstartDate];
             
             if ([NullChecker isNull:convertedrequiredStartDateString]) {
                 convertedrequiredStartDateString = @"00000000";
             }
             
             NSString *convertedrequiredEndDateString = [dateFormatter stringFromDate:requiredendDate];
             if ([NullChecker isNull:convertedrequiredEndDateString]) {
                 convertedrequiredEndDateString = @"00000000";
             }
             
             [dateFormatter setDateFormat:@"HH:mm:ss"];
             
             NSDate *startTime = [dateFormatter dateFromString:[[[addActivityArray objectAtIndex:8] objectAtIndex:2] copy]];
             
             NSDate *endTime = [dateFormatter dateFromString:[[[addActivityArray objectAtIndex:9] objectAtIndex:2] copy]];
 
             [dateFormatter setDateFormat:@"hhmmss"];
             
             NSString *convertedStartTime = [dateFormatter stringFromDate:startTime];
             
             NSString *convertedEndTime = [dateFormatter stringFromDate:endTime];
             
             
             if ([NullChecker isNull:convertedStartTime]) {
                 convertedStartTime = @"000000";
             }
             
             if ([NullChecker isNull:convertedEndTime]) {
                 convertedEndTime = @"000000";
             }
             
             [addActivityDetailsDictionary setObject:convertedrequiredStartDateString forKey:@"USR01"];
             
             [addActivityDetailsDictionary setObject:convertedrequiredEndDateString forKey:@"USR02"];
             
             [addActivityDetailsDictionary setObject:convertedStartTime forKey:@"USR03"];
             
             [addActivityDetailsDictionary setObject:convertedEndTime forKey:@"USR04"];
             
             [addActivityDetailsDictionary setObject:@"000" forKey:@"USR05"];
             
             [[DataBase sharedInstance] insertNotificationActivities:addActivityDetailsDictionary];
             
             [self.notifActivityDetailsArray removeAllObjects];
             
             [self.notifActivityDetailsArray addObjectsFromArray:[[DataBase sharedInstance] fetchNotificationActivitiesForUUID:[notificationUDID copy]]];
             
             [[addActivityArray objectAtIndex:0] replaceObjectAtIndex:2 withObject:@""];
             [[addActivityArray objectAtIndex:1] replaceObjectAtIndex:2 withObject:@""];
             [[addActivityArray objectAtIndex:2] replaceObjectAtIndex:2 withObject:@""];
             
             [[addActivityArray objectAtIndex:3] replaceObjectAtIndex:2 withObject:@""];
             [[addActivityArray objectAtIndex:3] replaceObjectAtIndex:3 withObject:@""];
             
             [[addActivityArray objectAtIndex:4] replaceObjectAtIndex:2 withObject:@""];
             [[addActivityArray objectAtIndex:4] replaceObjectAtIndex:3 withObject:@""];
             
             [[addActivityArray objectAtIndex:5] replaceObjectAtIndex:2 withObject:@""];
             
             [[addActivityArray objectAtIndex:6] replaceObjectAtIndex:2 withObject:@""];
             [[addActivityArray objectAtIndex:7] replaceObjectAtIndex:2 withObject:@""];
             
             [[addActivityArray objectAtIndex:8] replaceObjectAtIndex:2 withObject:@""];
             [[addActivityArray objectAtIndex:9] replaceObjectAtIndex:2 withObject:@""];
 
         }
         else{
             
             NSMutableDictionary *addActivityDetailsDictionary = [NSMutableDictionary new];
             
             [addActivityDetailsDictionary setObject:[[[self.detailNotificationArray objectAtIndex:0] objectForKey:@"notificationh_id"] copy] forKey:@"ID"];
             
             [addActivityDetailsDictionary setObject:[[[addActivityArray objectAtIndex:0] objectAtIndex:2] copy] forKey:@"ITEMKEY"];
             
             
             if (![NullChecker isNull:[[addCauseCodeDataArray objectAtIndex:0] objectAtIndex:3]]) {
                 
                 [addActivityDetailsDictionary setObject:[[[addCauseCodeDataArray objectAtIndex:0] objectAtIndex:3] copy] forKey:@"OBJECTPART"];
             }
             else{
                 [addActivityDetailsDictionary setObject:@"" forKey:@"OBJECTPART"];
             }
             
             if (![NullChecker isNull:[[addCauseCodeDataArray objectAtIndex:1] objectAtIndex:3]]) {
                 
                 [addActivityDetailsDictionary setObject:[[[addCauseCodeDataArray objectAtIndex:0] objectAtIndex:3] copy] forKey:@"OBJECTPART"];
             }
             else{
                 [addActivityDetailsDictionary setObject:@"" forKey:@"OBJECTPART"];
             }
             
             if (![NullChecker isNull:[[addCauseCodeDataArray objectAtIndex:1] objectAtIndex:3]]) {
                 
                 [addActivityDetailsDictionary setObject:[[[addCauseCodeDataArray objectAtIndex:1] objectAtIndex:3] copy] forKey:@"OBJECTPARTCODE"];
             }
             else{
                 [addActivityDetailsDictionary setObject:@"" forKey:@"OBJECTPARTCODE"];
             }
             
             [addActivityDetailsDictionary setObject:@"" forKey:@"OBJECTPARTDESCRIPTION"];
             
             
             if (![NullChecker isNull:[[addCauseCodeDataArray objectAtIndex:3] objectAtIndex:3]]) {
                 
                 [addActivityDetailsDictionary setObject:[[addCauseCodeDataArray objectAtIndex:3] objectAtIndex:3] forKey:@"DAMAGE"];
             }
             else{
                 [addActivityDetailsDictionary setObject:@"" forKey:@"DAMAGE"];
             }
             
             
             if (![NullChecker isNull:[[addCauseCodeDataArray objectAtIndex:2] objectAtIndex:3]]) {
                 
                 [addActivityDetailsDictionary setObject:[[addCauseCodeDataArray objectAtIndex:2] objectAtIndex:3] forKey:@"DAMAGECODE"];
             }
             else{
                 [addActivityDetailsDictionary setObject:@"" forKey:@"DAMAGECODE"];
             }
             
             
             [addActivityDetailsDictionary setObject:@"" forKey:@"DAMAGEDESCRIPTION"];
             
             
             if (![NullChecker isNull:[[addCauseCodeDataArray objectAtIndex:5] objectAtIndex:3]]) {
                 
                 [addActivityDetailsDictionary setObject:[[addCauseCodeDataArray objectAtIndex:5] objectAtIndex:3] forKey:@"CAUSECODECODEGROUP"];
                 
             }
             else{
                 [addActivityDetailsDictionary setObject:@"" forKey:@"CAUSECODECODEGROUP"];
             }
             
             if (![NullChecker isNull:[[addCauseCodeDataArray objectAtIndex:6] objectAtIndex:3]]) {
                 
                 [addActivityDetailsDictionary setObject:[[addCauseCodeDataArray objectAtIndex:6] objectAtIndex:3] forKey:@"CAUSECODECODEGROUP"];
             }
             else{
                 [addActivityDetailsDictionary setObject:@"" forKey:@"CAUSECODECODEGROUP"];
             }
             
             if (![NullChecker isNull:[[addCauseCodeDataArray objectAtIndex:7] objectAtIndex:3]]) {
                 
                 [addActivityDetailsDictionary setObject:[[addCauseCodeDataArray objectAtIndex:7] objectAtIndex:3] forKey:@"CAUSECODE"];
             }
             else{
                 [addActivityDetailsDictionary setObject:@"" forKey:@"CAUSECODE"];
             }
             
             [addActivityDetailsDictionary setObject:@"" forKey:@"CODEDESCRIPTION"];
             
             
             [addActivityDetailsDictionary setObject:[[[addActivityArray objectAtIndex:0] objectAtIndex:2] copy] forKey:@"ACTIVITYITEMKEY"];
             
             [addActivityDetailsDictionary setObject:[[[addActivityArray objectAtIndex:3] objectAtIndex:3] copy] forKey:@"ACTIVITYGROUP"];
             
             [addActivityDetailsDictionary setObject:[[[addActivityArray objectAtIndex:3] objectAtIndex:2] copy] forKey:@"ACTIVITYGROUPTEXT"];
             
             [addActivityDetailsDictionary setObject:[[[addActivityArray objectAtIndex:4] objectAtIndex:3] copy] forKey:@"ACTIVITYCODE"];
             
             [addActivityDetailsDictionary setObject:[[[addActivityArray objectAtIndex:4] objectAtIndex:2] copy] forKey:@"ACTIVITYCODETEXT"];
             
             [addActivityDetailsDictionary setObject:[[[addActivityArray objectAtIndex:5] objectAtIndex:2] copy] forKey:@"ACTIVITYSHORTTEXT"];
             
             [addActivityDetailsDictionary setObject:@"" forKey:@"QMNUM"];
             
             
             [addActivityDetailsDictionary setObject:@"" forKey:@"ACTIVITYKEY"];

              if (activityKeyString.length) {
                 
                  [addActivityDetailsDictionary setObject:activityKeyString forKey:@"ACTIVITYKEY"];
             }
            

 
             NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
             [dateFormatter setDateFormat:@"MMM dd, yyyy"];
             
             NSDate *requiredstartDate = [dateFormatter dateFromString:[[[addActivityArray objectAtIndex:6] objectAtIndex:2] copy]];
             
             NSDate *requiredendDate = [dateFormatter dateFromString:[[[addActivityArray objectAtIndex:7] objectAtIndex:2] copy]];
             
              // Convert date object into desired format
             [dateFormatter setDateFormat:@"yyyyMMdd"];
             
             NSString *convertedrequiredStartDateString = [dateFormatter stringFromDate:requiredstartDate];
             
             if ([NullChecker isNull:convertedrequiredStartDateString]) {
                 convertedrequiredStartDateString = @"00000000";
             }
             
             NSString *convertedrequiredEndDateString = [dateFormatter stringFromDate:requiredendDate];
             if ([NullChecker isNull:convertedrequiredEndDateString]) {
                 convertedrequiredEndDateString = @"00000000";
             }
             
             [dateFormatter setDateFormat:@"HH:mm:ss"];
             
             NSDate *startTime = [dateFormatter dateFromString:[[[addActivityArray objectAtIndex:8] objectAtIndex:2] copy]];
             
             NSDate *endTime = [dateFormatter dateFromString:[[[addActivityArray objectAtIndex:9] objectAtIndex:2] copy]];
             
            [dateFormatter setDateFormat:@"hhmmss"];
             
             NSString *convertedStartTime = [dateFormatter stringFromDate:startTime];
             
             NSString *convertedEndTime = [dateFormatter stringFromDate:endTime];
             
             
             if ([NullChecker isNull:convertedStartTime]) {
                 convertedStartTime = @"000000";
             }
             
             if ([NullChecker isNull:convertedEndTime]) {
                 convertedEndTime = @"000000";
             }
             
             [addActivityDetailsDictionary setObject:convertedrequiredStartDateString forKey:@"USR01"];
             
             [addActivityDetailsDictionary setObject:convertedrequiredEndDateString forKey:@"USR02"];
             
             [addActivityDetailsDictionary setObject:convertedStartTime forKey:@"USR03"];
             
             [addActivityDetailsDictionary setObject:convertedEndTime forKey:@"USR04"];
             
             [addActivityDetailsDictionary setObject:@"" forKey:@"USR05"];
             
             [[DataBase sharedInstance] updateNotificationActivities:addActivityDetailsDictionary];
             
             [self.notifActivityDetailsArray removeAllObjects];
             
             [self.notifActivityDetailsArray addObjectsFromArray:[[DataBase sharedInstance] fetchNotificationActivitiesForUUID:[[[self.detailNotificationArray objectAtIndex:0] objectForKey:@"notificationh_id"] copy]]];
             
             [[addActivityArray objectAtIndex:0] replaceObjectAtIndex:2 withObject:@""];
             [[addActivityArray objectAtIndex:1] replaceObjectAtIndex:2 withObject:@""];
             [[addActivityArray objectAtIndex:2] replaceObjectAtIndex:2 withObject:@""];
             
             [[addActivityArray objectAtIndex:3] replaceObjectAtIndex:2 withObject:@""];
             [[addActivityArray objectAtIndex:3] replaceObjectAtIndex:3 withObject:@""];
             
             [[addActivityArray objectAtIndex:4] replaceObjectAtIndex:2 withObject:@""];
             [[addActivityArray objectAtIndex:4] replaceObjectAtIndex:3 withObject:@""];
             
             [[addActivityArray objectAtIndex:5] replaceObjectAtIndex:2 withObject:@""];
             
             [[addActivityArray objectAtIndex:6] replaceObjectAtIndex:2 withObject:@""];
             [[addActivityArray objectAtIndex:7] replaceObjectAtIndex:2 withObject:@""];
             
             [[addActivityArray objectAtIndex:8] replaceObjectAtIndex:2 withObject:@""];
             [[addActivityArray objectAtIndex:9] replaceObjectAtIndex:2 withObject:@""];
             
         }
         
          [addCauseTaskView removeFromSuperview];
          commomlistListTableview.tag=2;
          [commomlistListTableview reloadData];
          submitResetView.hidden=NO;
        
       }
}


-(IBAction)deleteListofCauseCodes:(id)sender
{
    if (![self.selectedCheckBoxArray count]) {
       
         [self showAlertMessageWithTitle:@"Information" message:@"No Items or causes selected" cancelButtonTitle:@"Ok" withactionType:@"Single" forMethod:nil];
        
    }
    else{
 
        [self showAlertMessageWithTitle:@"Alert" message:@"The selected item and all cause codes will be deleted. \n Do you want to continue?" cancelButtonTitle:@"No" withactionType:@"Multiple" forMethod:@"Delete CauseCodes"];
    }
}


-(void)listofCauseCodesCancel{
    
    NSMutableIndexSet *indexesToDelete = [NSMutableIndexSet indexSet];
    
    for (id obj in self.selectedCheckBoxArray) {
        //do stuff with obj
        
        if (obj) {
            [indexesToDelete addIndex:[obj intValue]];
        }
        
        NSMutableDictionary *tempDeleteSlectedRow = [NSMutableDictionary new];
        
        if (updateFlag) {
            
            [tempDeleteSlectedRow setObject:[[[self.detailNotificationArray objectAtIndex:0] objectForKey:@"notificationh_id"] copy] forKey:@"ID"];
         }
        
        else{
            
            [tempDeleteSlectedRow setObject:[notificationUDID copy] forKey:@"ID"];
         }
        
        [tempDeleteSlectedRow setObject:[[[self.causeCodeDetailsArray objectAtIndex:[obj intValue]] firstObject] objectAtIndex:12] forKey:@"ITEMKEY"];
        [tempDeleteSlectedRow setObject:[[[self.causeCodeDetailsArray objectAtIndex:[obj intValue]] firstObject] objectAtIndex:13] forKey:@"CAUSEKEY"];
        
        if ([[[[self.causeCodeDetailsArray objectAtIndex:[obj intValue]] firstObject] objectAtIndex:14] isEqualToString:@"A"]){
            
            [[DataBase sharedInstance] deleteNotificationTransactions:tempDeleteSlectedRow];
            
        }
        else if ([[[[self.causeCodeDetailsArray objectAtIndex:[obj intValue]] firstObject] objectAtIndex:14] isEqualToString:@""]){
            
            [[DataBase sharedInstance] updateDeletedNotificationTransactionsDetails:tempDeleteSlectedRow];
        }
    }
    
    if (indexesToDelete) {
        
        [self.causeCodeDetailsArray removeAllObjects];
        
        [self.causeCodeDetailsArray addObjectsFromArray:[[DataBase sharedInstance] fetchNotificationTransactionDetailsForUUID:notificationUDID]];
 
      }
    
    VornrItem = 0;
    vornrItemID = @"";
    VornrCauseCode = 1;
    
    for (int i=0; i<[self.causeCodeDetailsArray count]; i++) {
        
        vornrItemID = [[[self.causeCodeDetailsArray  objectAtIndex:i] firstObject]  objectAtIndex:12];
        
        if ([[[[self.causeCodeDetailsArray objectAtIndex:i] firstObject] objectAtIndex:14] isEqualToString:@"D"]){
            [self.causeCodeDetailDeleteArray addObject:[NSMutableArray arrayWithArray:[self.causeCodeDetailsArray objectAtIndex:i]]];
            [self.causeCodeDetailsArray removeObjectAtIndex:i];
            --i;
        }
    }
    
    VornrItem = [vornrItemID intValue];
    
    VornrItem = VornrItem +1;
    
    [self.selectedCheckBoxArray removeAllObjects];
    
    itemSelectedFlag = NO;
    
//    self.updateCauseCodesBtn.hidden = YES;
//
//    [self.listofCauseCodesTableVIew reloadData];
    
    commomlistListTableview.tag=1;
    [commomlistListTableview reloadData];
    
}


-(void)customChangeSegmentController
{
    
    [segmentControl removeFromSuperview];
     segmentControl = [[YAScrollSegmentControl alloc] initWithFrame:CGRectMake(0, 0, commomlistListTableview.frame.size.width, 30)];
    segmentControl.buttons = @[@"Header", @"Cause Codes",@"Activity", @"Attachments"];
    segmentControl.delegate = self;
    [segmentControl setFont:[UIFont fontWithName:@"Helvetica" size:16.0]];
 
    [segmentControl setTitleColor:[UIColor whiteColor]  forState:UIControlStateSelected];
    segmentControl.gradientColor =  [UIColor whiteColor]; // Purposely set strange gradient color to demonstrate the effect
    segmentControl.tintColor=[UIColor whiteColor];
     [self.segmentView addSubview:segmentControl];
 
}


-(void)loadsystemStatusheaderView
{
    
    UIView *systemstatusHeaderView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, commomlistListTableview.frame.size.width, 60)];
    
    UITextField *systemLabel=[[UITextField alloc] initWithFrame:CGRectMake(15, 15, systemstatusHeaderView.frame.size.width-40, 30)];
    
    systemLabel.textColor=[UIColor blueColor];
    
    systemLabel.userInteractionEnabled=NO;
    
    systemLabel.borderStyle=UITextBorderStyleNone;
    
    [systemLabel setBackgroundColor:[UIColor whiteColor]];
    
 
     NSString *txt30StatusNumString,*txt30WOStatusNumberString;
    
    if (!notifheaderStatusString.length) {
        
        for (int i=0; i<[[[self.notifSystemStatusArray objectAtIndex:1] firstObject] count]; i++) {
            
            if ([[[[[self.notifSystemStatusArray objectAtIndex:1] firstObject] objectAtIndex:i] objectForKey:@"notifications_act"] isEqualToString:@"X"]) {
                
                txt30StatusNumString=[[[[self.notifSystemStatusArray objectAtIndex:1] firstObject] objectAtIndex:i] objectForKey:@"notifications_txt04"];
            }
            
        }
        
        for (int j=0; j<[[[self.notifSystemStatusArray objectAtIndex:2] firstObject] count]; j++) {
            
            if ([[[[[self.notifSystemStatusArray objectAtIndex:2] firstObject] objectAtIndex:j] objectForKey:@"notifications_act"] isEqualToString:@"X"]) {
                
                txt30WOStatusNumberString=[[[[self.notifSystemStatusArray objectAtIndex:2] firstObject] objectAtIndex:j] objectForKey:@"notifications_txt04"];
            }
        }
        
        
        if ([NullChecker isNull:txt30StatusNumString]) {
            
            txt30StatusNumString=@"";
            
        }
        
        if ([NullChecker isNull:txt30WOStatusNumberString]) {
            
            txt30StatusNumString=@"";
            
        }
        
        notifheaderStatusString=[NSString stringWithFormat:@"%@ %@",txt30StatusNumString,txt30WOStatusNumberString];
        
    }
 
     systemLabel.text=notifheaderStatusString;
    
     [systemstatusHeaderView setBackgroundColor:UIColorFromRGB(246, 241, 247)];

     [systemstatusHeaderView addSubview:systemLabel];
    
     [commomlistListTableview setTableHeaderView:systemstatusHeaderView];
 
 }

- (void)didSelectItemAtIndex:(NSInteger)index
{
     switch (index)
    {
        case 0:
 
            [commomlistListTableview setTableHeaderView:nil];
            
             if (!createNotificationFlag) {
                 [self loadsystemStatusheaderView];
             }
            
            commomlistListTableview.hidden=NO;

             [addCauseTaskView removeFromSuperview];
             [self.attachmentsView removeFromSuperview];
             [downloadsView removeFromSuperview];
 
             commomlistListTableview.tag=0;
             [commomlistListTableview reloadData];
             submitResetView.hidden=NO;
 
        break;
            
        case 1:
          
            commomlistListTableview.userInteractionEnabled=YES;

            [customHeaderView setFrame:CGRectMake(0, 0, commomlistListTableview.frame.size.width, 50)];
            [commomlistListTableview setTableHeaderView:customHeaderView];
             isCausecodeSelected=YES;
            
            commomlistListTableview.hidden=NO;

             [self.attachmentsView removeFromSuperview];
            [downloadsView removeFromSuperview];
            [addCauseTaskView removeFromSuperview];
            commomlistListTableview.tag=1;
            [commomlistListTableview reloadData];
 
        break;
            
        case 2:
            
            commomlistListTableview.userInteractionEnabled=YES;
             [customHeaderView setFrame:CGRectMake(0, 0, commomlistListTableview.frame.size.width, 50)];
            [commomlistListTableview setTableHeaderView:customHeaderView];
            isCausecodeSelected=NO;
             commomlistListTableview.hidden=NO;
             [self.attachmentsView removeFromSuperview];
            [downloadsView removeFromSuperview];
            [addCauseTaskView removeFromSuperview];
             commomlistListTableview.tag=2;
             [commomlistListTableview reloadData];
            
            break;
            
        case 3:
 
            isCausecodeSelected=NO;
            [commomlistListTableview setTableHeaderView:nil];
            [addCauseTaskView removeFromSuperview];
            
             if (!createNotificationFlag) {
                
                 [self.attachmentsView setFrame:CGRectMake(0, 0, commomlistListTableview.frame.size.width, commomlistListTableview.frame.size.height)];
                 [commomlistListTableview addSubview:self.attachmentsView];
                
            }
            
            else{
                
                [self.attachmentsView setFrame:CGRectMake(0, 0, commomlistListTableview.frame.size.width, commomlistListTableview.frame.size.height)];
                [commomlistListTableview addSubview:self.attachmentsView];
            }
            
            submitResetView.hidden=NO;
 
         break;
 
      default:break;
    }
    
}


-(IBAction)addImageClicked:(id)sender{
    
    [self uploadPicture];
    
}


-(void)uploadPicture{
    
   
    //    UIActionSheet *action = [[UIActionSheet alloc]initWithTitle:@"" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Take Photo",@"Choose Photo", nil];
    //    [action showInView:self.view];
    
    
    UIAlertController * pickerAlert=   [UIAlertController
                                        alertControllerWithTitle:@"Select"
                                        message:@""
                                        preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction* cameraButton = [UIAlertAction
                                   actionWithTitle:@"Camera"
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction * action)
                                   {
                                       
                                       if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
                                       {
                                           [self performSelector:@selector(showCamera) withObject:nil afterDelay:0.1];
 
                                       }
                                       else
                                       {
                                           
                                           [self showAlertMessageWithTitle:@"Oops" message:@"Your Device doesn't support Camera" cancelButtonTitle:@"Ok" withactionType:@"Single" forMethod:nil];
                                       }
                                       
                                   }];
    UIAlertAction *galleryButton = [UIAlertAction
                                    actionWithTitle:@"Gallery"
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * action)
                                    {
                                        
                                        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
                                        {
                                            [self.selectedCheckBoxImageArray removeAllObjects];
                                            
                                            ELCImagePickerController *elcPicker = [[ELCImagePickerController alloc] initImagePicker];
                                            
                                            elcPicker.maximumImagesCount = 100; //Set the maximum number of images to select to 100
                                            elcPicker.returnsOriginalImage = YES; //Only return the fullScreenImage, not the fullResolutionImage
                                            elcPicker.returnsImage = YES; //Return UIimage if YES. If NO, only return asset location information
                                            elcPicker.onOrder = YES; //For multiple image selection, display and return order of selected images
                                            elcPicker.mediaTypes = @[(NSString *)kUTTypeImage, (NSString *)kUTTypeMovie]; //Supports image and movie types
                                            
                                            elcPicker.imagePickerDelegate = self;
                                            
                                            [self presentViewController:elcPicker animated:YES completion:nil];
                                            
                                        }
                                        
                                    }];
    
    
    UIAlertAction *cancelButton = [UIAlertAction
                                   actionWithTitle:@"Cancel"
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction * action)
                                   {
                                       //Do some thing here
                                       [pickerAlert dismissViewControllerAnimated:YES completion:nil];
                                       
                                   }];
    
    
    
    
    [pickerAlert addAction:cameraButton];
    
    [pickerAlert addAction:galleryButton];
    
    [pickerAlert addAction:cancelButton];
    
    [self presentViewController:pickerAlert animated:YES completion:nil];
    
}



-(IBAction)takeaPictureBtn:(id)sender{

    [self performSelector:@selector(showCamera) withObject:nil afterDelay:0.1];

}

-(void)showCamera{
    
    UIImagePickerController * imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.modalPresentationStyle = UIModalPresentationCurrentContext;
    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    imagePicker.allowsEditing =YES;
    [self.view.window.rootViewController presentViewController:imagePicker animated:YES completion:nil];
}


-(IBAction)choosefromGalleryBtn:(id)sender{

    [self.selectedCheckBoxImageArray removeAllObjects];

    ELCImagePickerController *elcPicker = [[ELCImagePickerController alloc] initImagePicker];
 
    elcPicker.maximumImagesCount = 100; //Set the maximum number of images to select to 100
    elcPicker.returnsOriginalImage = YES; //Only return the fullScreenImage, not the fullResolutionImage
    elcPicker.returnsImage = YES; //Return UIimage if YES. If NO, only return asset location information
    elcPicker.onOrder = YES; //For multiple image selection, display and return order of selected images
    elcPicker.mediaTypes = @[(NSString *)kUTTypeImage, (NSString *)kUTTypeMovie]; //Supports image and movie types
 
    elcPicker.imagePickerDelegate = self;
    
     [self presentViewController:elcPicker animated:YES completion:nil];
}

#pragma mark-
#pragma mark- ImagePickerControllerDelegate from Camera.

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
//    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//    if ([app.viewController respondsToSelector:@selector(dismissViewControllerAnimated:completion:)]){
//        [app.viewController dismissViewControllerAnimated:YES completion:nil];
//    } else {
//        [app.viewController dismissViewControllerAnimated:YES completion:nil];
//    }
    
      [self dismissViewControllerAnimated:YES completion:nil];

 
 
    arr_images=[[NSMutableArray alloc]initWithCapacity:5];
    arr_imagesDocType=[[NSMutableArray alloc]initWithCapacity:5];
    
    UIImage *image = (UIImage *)[info objectForKey:UIImagePickerControllerOriginalImage];
    NSData *imageData = UIImageJPEGRepresentation(image, .8);
    [[DataBase sharedInstance] setImagecaputreTag:1];
    NSString *filePath = [[[DataBase sharedInstance] getImageDirectory] stringByAppendingPathComponent:[[DataBase sharedInstance] createUniqueIdfortable:@""]];
    [imageData writeToFile:filePath atomically:YES];
    [arr_images addObject:filePath];
    
    cameraFlag = YES;
    
    UIAlertController * alert=[UIAlertController alertControllerWithTitle:@""
                                                                  message:@"Would you like to add this attachment to"
                                                           preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* notifButton = [UIAlertAction actionWithTitle:@"Yes, please"
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action)
                                    {
 
                                        attachmentAlertTypeString = @"BUS2038";
 
                                        for (int i =0; i<[arr_images count]; i++) {
                                            
                                            [arr_imagesDocType addObject:attachmentAlertTypeString];
                                        }
                                         [self limitationCheckForImages];
 
                                     }];
    
    UIAlertAction* equipmentButton = [UIAlertAction actionWithTitle:@"Yes, please"
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction * action)
                                {
                                    
                                     attachmentAlertTypeString = @"EQUI";

                                    for (int i =0; i<[arr_images count]; i++) {
                                        
                                        [arr_imagesDocType addObject:attachmentAlertTypeString];
                                    }
                                    
                                    [self limitationCheckForImages];
                                    
                                 }];
    
    UIAlertAction* okButton = [UIAlertAction actionWithTitle:@"Cancel"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * action)
                               {
                                   
                                   [alert dismissViewControllerAnimated:YES completion:nil];
                                   
                               }];
    
     [alert addAction:notifButton];
     [alert addAction:equipmentButton];
     [alert addAction:okButton];
    
    [self presentViewController:alert animated:YES completion:nil];
 
}



-(void)limitationCheckForImages{
    
    if (arr_images == nil) {
        arr_images = [NSMutableArray new];
        arr_imagesDocType = [NSMutableArray new];
    }
    
    if (arr_onScreenImages == nil) {
        arr_onScreenImages = [NSMutableArray new];
        arr_onScreenImagesDocType = [NSMutableArray new];
    }
    
    if (arr_images.count>0) {
        
        [arr_onScreenImages addObjectsFromArray:arr_images];
        
        [arr_onScreenImagesDocType addObjectsFromArray:arr_imagesDocType];
        
        if (arr_onScreenImages.count >5) {
            
            [arr_onScreenImages removeObjectsInArray:arr_images];
            [arr_onScreenImagesDocType removeObjectsInArray:arr_imagesDocType];
 
            [self showAlertMessageWithTitle:@"Info" message:@"You cannot upload more than 5 documents at a time" cancelButtonTitle:@"Ok" withactionType:@"Single" forMethod:nil];
            
        }
        else{
            if (cameraFlag) {
                
                [self descriptionAlert];
                
            }
            
            attachmentsFlag=YES;
            // [self setGridView];
            
            [self addAttachmentDocuments];
            
            [attachmentsTableview reloadData];
            
        }
    }
}

-(void)descriptionAlert{
    
    
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle: @"Alert"
                                                                              message: @"Enter a description for this image"
                                                                       preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"Enter Description";
        textField.textColor = [UIColor blueColor];
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        textField.borderStyle = UITextBorderStyleRoundedRect;
    }];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSArray * textfields = alertController.textFields;
        UITextField * namefield = textfields[0];
        
        if ([NullChecker isNull:namefield.text]) {
 
            [self showAlertMessageWithTitle:@"" message:@"Please Enter Description" cancelButtonTitle:@"Ok" withactionType:@"Multiple" forMethod:@"AlertFail"];
        }
        else{
            if (!imageNameFlag) {
                self.fileNameArray = [NSMutableArray new];
                imageNameFlag = YES;
            }
            
            [self.fileNameArray addObject:[namefield.text copy]];
            
            NSArray *tempArray = self.fileNameArray;
            
            for (int i=0; i<[tempArray count]; i++) {
                
                if ([[tempArray objectAtIndex:i] isKindOfClass:[NSArray class]]) {
                    [self.fileNameArray removeObject:[tempArray objectAtIndex:i]];
                }
                else if ([[tempArray objectAtIndex:i] isEqualToString:@""]) {
                    [self.fileNameArray removeObject:[tempArray objectAtIndex:i]];
                }
                else if ([NullChecker isNull:[tempArray objectAtIndex:i]]){
                    [self.fileNameArray removeObject:[tempArray objectAtIndex:i]];
                }
            }
        }
 
        
    }]];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
}


#pragma mark-
#pragma mark- ELCImagePickerControllerDelegate Methods

- (void)elcImagePickerController:(ELCImagePickerController *)picker didFinishPickingMediaWithInfo:(NSArray *)info{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    arr_images=[[NSMutableArray alloc]initWithCapacity:5];
    arr_imagesDocType = [[NSMutableArray alloc]initWithCapacity:5];
    
    for(NSDictionary *dict in info) {
        UIImage *image = [dict objectForKey:UIImagePickerControllerOriginalImage];
        NSData *imageData = UIImageJPEGRepresentation(image, .8);
        [[DataBase sharedInstance] setImagecaputreTag:1];
        NSString *filePath = [[[DataBase sharedInstance] getImageDirectory] stringByAppendingPathComponent:[[DataBase sharedInstance] createUniqueIdfortable:@""]];
        [imageData writeToFile:filePath atomically:YES];
        [arr_images addObject:filePath];
    }
    
    cameraFlag = NO;
    
    
    UIAlertController * alert=[UIAlertController alertControllerWithTitle:@""
                                                                  message:@"Would you like to add this attachment to"
                                                           preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction*notifButton = [UIAlertAction actionWithTitle:@"Notification"
                                                         style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction * action)
                                 {
                                     attachmentAlertTypeString = @"BUS2038";
                                     
                                     for (int i =0; i<[arr_images count]; i++) {
                                         
                                         [arr_imagesDocType addObject:attachmentAlertTypeString];
                                     }
                                     
                                     [self limitationCheckForImages];
                                     
                                 }];
    
    UIAlertAction* equipButton = [UIAlertAction actionWithTitle:@"Equipment"
                                                          style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction * action)
                                  {
                                      
                                      attachmentAlertTypeString = @"EQUI";
                                      
                                      for (int i =0; i<[arr_images count]; i++) {
                                          
                                          [arr_imagesDocType addObject:attachmentAlertTypeString];
                                      }
                                      
                                      [self limitationCheckForImages];
                                      
                                  }];
    
    UIAlertAction* okButton = [UIAlertAction actionWithTitle:@"Cancel"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * action)
                               {
                                   /** What we write here???????? **/
                                   NSLog(@"you pressed No, thanks button");
                                   // call method whatever u need
                                   [alert dismissViewControllerAnimated:YES completion:nil];
                                   
                               }];
    
    [alert addAction:notifButton];
    [alert addAction:equipButton];
    [alert addAction:okButton];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}


-(IBAction)dismissViewAttachments:(id)sender{

    //[self.attachmentsSubView removeFromSuperview];
}

-(IBAction)viewAttachments:(id)sender
{
//    [attachmentsView addSubview:self.attachmentsSubView];
//    [self.attachmentsTableView reloadData];
}

-(IBAction)deleteMultipleImages:(id)sender{
    
    if ([arr_onScreenImages count]) {

        [self aCancel:sender];
    }
    else{

        UIAlertView *failureAlert = [[UIAlertView alloc]initWithTitle:@"Inforamtion" message:@"No Images Selected" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [failureAlert show];
    }
}


-(void)aCancel:(id)sender{
    
    NSMutableIndexSet *indexesToDelete = [NSMutableIndexSet indexSet];
    
    for (id obj in self.selectedCheckBoxImageArray) {
        //do stuff with obj
        if (obj) {
            [indexesToDelete addIndex:[obj intValue]];
        }
    }
    
    [arr_onScreenImages removeObjectsAtIndexes:indexesToDelete];
    [arr_onScreenImagesDocType removeObjectsAtIndexes:indexesToDelete];
    
    [self.fileNameArray removeObjectsAtIndexes:indexesToDelete];
    
    [self setGridView];
    
    [self.selectedCheckBoxImageArray removeAllObjects];
}

- (void)elcImagePickerControllerDidCancel:(ELCImagePickerController *)picker
{
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if ([app.viewController respondsToSelector:@selector(dismissViewControllerAnimated:completion:)]){
        [app.viewController dismissViewControllerAnimated:YES completion:nil];
    } else {
        [app.viewController dismissViewControllerAnimated:YES completion:nil];
    }
}

-(NSString *)contentTypeForImageData:(NSData *)data {
    uint8_t c;
    [data getBytes:&c length:1];
    
    switch (c) {
        case 0xFF:
            return @"image/jpeg";
            break;
        case 0x89:
            return @"image/png";
            break;
        case 0x47:
            return @"image/gif";
            break;
        case 0x49:
        case 0x4D:
            return @"image/tiff";
            break;
        case 0x25:
            return @"application/pdf";
            break;
        case 0xD0:
            return @"application/vnd";
            break;
        case 0x46:
            return @"text/plain";
            break;
        default:
            return @"application/octet-stream";
    }
    return nil;
}


-(void)setGridView{
    
    xSpace = -46;
    
    iSpace = -46;
    
    viewImage.frame = CGRectZero;
    [viewImage removeFromSuperview];
    
    imageView.image=nil;
    
    int Width = 0;
    int Height = 0;
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        
        viewImage = [[UIView alloc]initWithFrame: CGRectMake(0, 10, 284, 264)];
        
        Width = 50;
        Height = 50;
    }
    else if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad){
        
        viewImage = [[UIView alloc]initWithFrame: CGRectMake(0, 10, 920, 200)];
        
        Width = 150;
        Height = 150;
    }
    
    [self.imageContainer addSubview:viewImage];
    
    
    for (int x=0; x<[arr_onScreenImages count]; x++) {
        
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
            imageView=[[UIImageView alloc]initWithFrame:CGRectMake(xSpace+51, ySpace, Width, Height)];
            
            xSpace=xSpace+85;
            iSpace =iSpace+85;
        }
        else if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
        {
            imageView=[[UIImageView alloc]initWithFrame:CGRectMake(xSpace+51, ySpace, Width, Height)];
            
            xSpace=xSpace+185;
            iSpace =iSpace+185;
            
            ySpace =ySpace+0;
        }
        
        imageView.layer.cornerRadius = 9.0;
        [imageView.layer setMasksToBounds:YES];
        
        if ([[arr_onScreenImages objectAtIndex:x] isKindOfClass:[UIImage class]]) {
            imageView.image=[arr_onScreenImages objectAtIndex:x];
        }
        else{
            imageView.image= [UIImage imageWithContentsOfFile:[arr_onScreenImages objectAtIndex:x]];
        }
        
        cancelImage = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelImage.tag = x;
        cancelImage.frame = CGRectMake(iSpace, -12.0, 25, 25);
        
        [cancelImage setImage:[UIImage imageNamed:@"checkbox_unselected.png"] forState:UIControlStateNormal];
        [cancelImage addTarget:self action:@selector(cancelCheckBox:) forControlEvents:UIControlEventTouchUpInside];
        
        [viewImage addSubview:imageView];
        [viewImage addSubview:cancelImage];
        
        if (!cameraFlag) {
            
            if (!imageNameFlag) {
                if (self.fileNameArray == nil) {
                    self.fileNameArray = [NSMutableArray new];
                }
                imageNameFlag = YES;
            }
            
            [self.fileNameArray addObject:@"*"];
            
            NSArray *tempArray = self.fileNameArray;
            
            for (int i=0; i<[tempArray count]; i++) {
                NSLog(@"%@",[tempArray objectAtIndex:i]);
                if ([[tempArray objectAtIndex:i] isKindOfClass:[NSArray class]]) {
                    [self.fileNameArray removeObject:[tempArray objectAtIndex:i]];
                }
                else if ([[tempArray objectAtIndex:i] isEqualToString:@""]) {
                    [self.fileNameArray removeObject:[tempArray objectAtIndex:i]];
                }
                else if ([NullChecker isNull:[tempArray objectAtIndex:i]]){
                    [self.fileNameArray removeObject:[tempArray objectAtIndex:i]];
                }
            }
        }
    }
    
    viewImage.backgroundColor=[UIColor clearColor];
}

-(void)addAttachmentDocuments{
    
    if (self.attachmentArray == nil) {
        self.attachmentArray = [NSMutableArray new];
    }
    else{
        [self.attachmentArray removeAllObjects];
    }
    
    UIImage *customImage ;
    
    for (int x=0; x<[arr_onScreenImages count]; x++) {
        
        if ([[arr_onScreenImages objectAtIndex:x] isKindOfClass:[UIImage class]]) {
            customImage=[arr_onScreenImages objectAtIndex:x];
        }
        else{
            customImage= [UIImage imageWithContentsOfFile:[arr_onScreenImages objectAtIndex:x]];
        }
        
        // Determine output size
        CGFloat maxSize = 1024.0f;
        CGFloat width = customImage.size.width;
        CGFloat height = customImage.size.height;
        CGFloat newWidth = width;
        CGFloat newHeight = height;
        
        // If any side exceeds the maximun size, reduce the greater side to 1200px and proportionately the other one
        if (width > maxSize || height > maxSize) {
            if (width > height) {
                newWidth = maxSize;
                newHeight = (height*maxSize)/width;
            } else {
                newHeight = maxSize;
                newWidth = (width*maxSize)/height;
            }
        }
        
        // Resize the image
        CGSize newSize = CGSizeMake(newWidth, newHeight);
        UIGraphicsBeginImageContext(newSize);
        [customImage drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
        customImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        // Set maximun compression in order to decrease file size and enable faster uploads & downloads
        //   pictureData = UIImageJPEGRepresentation(imageView.image, 0.0f); (compressed)
        pictureData = UIImageJPEGRepresentation(customImage, 1);//(original)
        
        imageSize =(int)pictureData.length;
        NSLog(@"SIZE OF IMAGE: %i ", imageSize);
        
        contentData = [pictureData base64Encoding];
        
        str_ImageType = [self contentTypeForImageData:pictureData];
        NSLog(@"str_ImageType :%@",str_ImageType);
        
        //        if ([[self.fileNameArray objectAtIndex:x] isEqualToString:@"*"]) {
        //
        //            if ([defaults objectForKey:@"Count"] ==nil) {
        //                NSString *str_Count = @"0";
        //                [defaults setObject:str_Count forKey:@"Count"];
        //            }
        //
        //            [defaults synchronize];
        //
        //            NSString *str_CountValue = [defaults objectForKey:@"Count"];
        //            int value = [str_CountValue intValue];
        //            value = value+1;
        //            str_CountValue = [NSString stringWithFormat:@"%i", value];
        //            [defaults setObject:str_CountValue forKey:@"Count"];
        //            NSString *str_imgName = [NSString stringWithFormat:@"img%03i",value];
        //            [self.fileNameArray replaceObjectAtIndex:x withObject:str_imgName];
        //        }
        
        if ([[defaults objectForKey:@"Count"] isEqualToString:@"1000"]) {
            [defaults removeObjectForKey:@"Count"];
        }
        
        [defaults synchronize];
        
        // [self.attachmentArray addObject:[NSMutableArray arrayWithObjects:@"",@"",[arr_onScreenImagesDocType objectAtIndex:x],[self.fileNameArray objectAtIndex:x],str_ImageType,[NSString stringWithFormat:@"%i",imageSize],@"",contentData,@"I", nil]];
        
        if (!cameraFlag) {
            
            if (!imageNameFlag) {
                if (self.fileNameArray == nil) {
                    self.fileNameArray = [NSMutableArray new];
                }
                imageNameFlag = YES;
            }
            
            [self.fileNameArray addObject:@"*"];
            
            NSArray *tempArray = self.fileNameArray;
            
            for (int i=0; i<[tempArray count]; i++) {
                NSLog(@"%@",[tempArray objectAtIndex:i]);
                if ([[tempArray objectAtIndex:i] isKindOfClass:[NSArray class]]) {
                    [self.fileNameArray removeObject:[tempArray objectAtIndex:i]];
                }
                else if ([[tempArray objectAtIndex:i] isEqualToString:@""]) {
                    [self.fileNameArray removeObject:[tempArray objectAtIndex:i]];
                }
                else if ([NullChecker isNull:[tempArray objectAtIndex:i]]){
                    [self.fileNameArray removeObject:[tempArray objectAtIndex:i]];
                }
            }
        }
        
        [self.attachmentArray addObject:[NSMutableArray arrayWithObjects:@"",@"",[arr_onScreenImagesDocType objectAtIndex:x],[self.fileNameArray objectAtIndex:x],str_ImageType,[NSString stringWithFormat:@"%i",imageSize],@"",contentData,@"I", nil]];
        
    }
}


-(void)getAttachedDocuments{
    
    if (self.attachmentArray == nil) {
        self.attachmentArray = [NSMutableArray new];
    }
    else{
        [self.attachmentArray removeAllObjects];
    }
    
    for (int x=0; x<[arr_onScreenImages count]; x++) {
        
        if ([[arr_onScreenImages objectAtIndex:x] isKindOfClass:[UIImage class]]) {
            imageView.image=[arr_onScreenImages objectAtIndex:x];
        }
        else{
            imageView.image= [UIImage imageWithContentsOfFile:[arr_onScreenImages objectAtIndex:x]];
        }
        
        // Determine output size
        CGFloat maxSize = 1024.0f;
        CGFloat width = imageView.image.size.width;
        CGFloat height = imageView.image.size.height;
        CGFloat newWidth = width;
        CGFloat newHeight = height;
        
        // If any side exceeds the maximun size, reduce the greater side to 1200px and proportionately the other one
        if (width > maxSize || height > maxSize) {
            if (width > height) {
                newWidth = maxSize;
                newHeight = (height*maxSize)/width;
            } else {
                newHeight = maxSize;
                newWidth = (width*maxSize)/height;
            }
        }
        
        // Resize the image
        CGSize newSize = CGSizeMake(newWidth, newHeight);
        UIGraphicsBeginImageContext(newSize);
        [imageView.image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
        imageView.image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        // Set maximun compression in order to decrease file size and enable faster uploads & downloads
        //   pictureData = UIImageJPEGRepresentation(imageView.image, 0.0f); (compressed)
        pictureData = UIImageJPEGRepresentation(imageView.image, 1);//(original)
        // pictureData = UIImagePNGRepresentation(imageView.image);//(original)
        //        NSLog(@"pictureData :%lu",(unsigned long)pictureData.length);
        imageSize =(int)pictureData.length;
        NSLog(@"SIZE OF IMAGE: %i ", imageSize);
        //We have to pass Content Data to Database with Encoding
        
        contentData = [pictureData base64Encoding];
        // NSLog(@"contentData :%@",contentData);
        
        str_ImageType = [self contentTypeForImageData:pictureData];
        NSLog(@"str_ImageType :%@",str_ImageType);
        
        if ([[self.fileNameArray objectAtIndex:x] isEqualToString:@"*"]) {
            
            if ([defaults objectForKey:@"Count"] ==nil) {
                NSString *str_Count = @"0";
                [defaults setObject:str_Count forKey:@"Count"];
            }
            
            [defaults synchronize];
            
            NSString *str_CountValue = [defaults objectForKey:@"Count"];
            int value = [str_CountValue intValue];
            value = value+1;
            str_CountValue = [NSString stringWithFormat:@"%i", value];
            [defaults setObject:str_CountValue forKey:@"Count"];
            NSString *str_imgName = [NSString stringWithFormat:@"img%03i",value];
            [self.fileNameArray replaceObjectAtIndex:x withObject:str_imgName];
        }
        
        if ([[defaults objectForKey:@"Count"] isEqualToString:@"1000"]) {
            [defaults removeObjectForKey:@"Count"];
        }
        
        [defaults synchronize];
        
        [self.attachmentArray addObject:[NSMutableArray arrayWithObjects:@"",@"",[arr_onScreenImagesDocType objectAtIndex:x],[self.fileNameArray objectAtIndex:x],str_ImageType,[NSString stringWithFormat:@"%i",imageSize],@"",contentData,@"I", nil]];
        
        [self.notificationHeaderDetails setObject:@"X" forKey:@"DOCS"];
        
    }
}

-(IBAction)createOrderBtn:(id)sender{
    
    CreateOrderViewController *createVc = [self.storyboard instantiateViewControllerWithIdentifier:@"CreateOrderVC"];
    
    createVc.loadNotificationDetailsArray=[self.detailNotificationArray copy];
    
    [self showViewController:createVc sender:self];
    
}

-(IBAction)createNotification:(id)sender
{
    
     NSString *notifTypeString,*notifShorttextString,*requiredStartdateString,*requiredEnddateString,*malfunctionStartdateString;
    
    if (createNotificationFlag) {
        
        notifTypeString=[[headerDataArray objectAtIndex:0] objectAtIndex:3];
        notifShorttextString=[[headerDataArray objectAtIndex:1] objectAtIndex:2];
        requiredStartdateString=[[headerDataArray objectAtIndex:10] objectAtIndex:2];
        requiredEnddateString=[[headerDataArray objectAtIndex:11] objectAtIndex:2];
        malfunctionStartdateString=[[headerDataArray objectAtIndex:12] objectAtIndex:2];
    }
    
    else{
        
        notifTypeString=[[headerDataArray objectAtIndex:0] objectAtIndex:3];
        notifShorttextString=[[headerDataArray objectAtIndex:1] objectAtIndex:2];
        requiredStartdateString=[[headerDataArray objectAtIndex:12] objectAtIndex:2];
        requiredEnddateString=[[headerDataArray objectAtIndex:13] objectAtIndex:2];
        malfunctionStartdateString=[[headerDataArray objectAtIndex:14] objectAtIndex:2];
        
    }
    
    if(![JEValidator validateTextValue:notifTypeString])
    {
 
        [self showAlertMessageWithTitle:@"Information" message:@"Please Enter Notifcation Type" cancelButtonTitle:@"Ok" withactionType:@"Single" forMethod:nil];
        
    }
    else if(![JEValidator validateTextValue:notifShorttextString])
    {
 
          [self showAlertMessageWithTitle:@"Information" message:@"Please Enter Notification Text" cancelButtonTitle:@"Ok" withactionType:@"Single" forMethod:nil];
    }
    else if(![JEValidator validateTextValue:equipmentID])
    {
 
        [self showAlertMessageWithTitle:@"Information" message:@"Please Enter Function Location or Equipment Number" cancelButtonTitle:@"Ok" withactionType:@"Single" forMethod:nil];
        
    }
    else if(![JEValidator validateTextValue:requiredStartdateString])
    {
 
        [self showAlertMessageWithTitle:@"Information" message:@"Please Enter Required Start Date" cancelButtonTitle:@"Ok" withactionType:@"Single" forMethod:nil];
        
    }
    
    else if(![JEValidator validateTextValue:[[headerDataArray objectAtIndex:5] objectAtIndex:3]])
    {
        
        [self showAlertMessageWithTitle:@"Information" message:@"Please Select Priority" cancelButtonTitle:@"Ok" withactionType:@"Single" forMethod:nil];
        
    }
    
//    else if(![JEValidator validateTextValue:requiredEnddateString])
//    {
//
//         [self showAlertMessageWithTitle:@"Information" message:@"Please Enter Required End Date" cancelButtonTitle:@"Ok" withactionType:@"Single" forMethod:nil];
//
//    }
//    else if(![JEValidator validateTextValue:malfunctionStartdateString])
//    {
//
//          [self showAlertMessageWithTitle:@"Information" message:@"Please Enter Start Malfunction Date" cancelButtonTitle:@"Ok" withactionType:@"Single" forMethod:nil];
//
//    }
//    else if(![JEValidator validateTextValue:effectTextField.text])
//    {
//        [self showAlertMessageWithTitle:@"Information" message:@"Please Select Effect"];
//    }
    
    else{
        // NSString *message;
        if (createNotificationFlag)
        {
 
            [self showAlertMessageWithTitle:@"Decision" message:@"Do you want to submit for Notification creation?" cancelButtonTitle:@"No" withactionType:@"Multiple" forMethod:@"Create Notification"];
 
        }
        else{
 
            [self showAlertMessageWithTitle:@"Decision" message:@"Do you want to change the selected Notification?" cancelButtonTitle:@"No" withactionType:@"Multiple" forMethod:@"Change Notification"];
            
         }
    }
}



#pragma mark
#pragma mark - TableView Delegate Methods
//table view methods strats here

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;              // Default is 1 if not implemented
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (tableView==commomlistListTableview) {
        
        if (commomlistListTableview.tag==0) {
            
            return [headerDataArray count];
         }
        
     else  if (commomlistListTableview.tag==1)
     {
             return [self.causeCodeDetailsArray count];
     }
     else   if (commomlistListTableview.tag==2)
     {
         return [self.notifActivityDetailsArray count];
     }
        
     else   if (commomlistListTableview.tag==3)
     {
         return [self.attachmentArray count];
     }
        
     else   if (commomlistListTableview.tag==4)
     {
         return [notifInspectionArray count];
     }
        
    }
    else if (tableView==commonAddTableView){
        
        if (commonAddTableView.tag==0) {
            
            return [addCauseCodeDataArray count];
        }
        
        else if (commonAddTableView.tag==1){
             return [addTaskCodeDataArray count];
         }
        
        else if (commonAddTableView.tag==2){
            
            return [addActivityArray count];
        }
        
     }
    
    else  if (tableView ==duplicateNotificationTableView)
    {
        return [notificatinDuplicateArray count];
    }
    
    else if (tableView == self.dropDownTableView) {
        
        return [self.dropDownArray count];
    }
    
   else if (tableView == seachDropdownTableView)
    {
        if (seachDropdownTableView.tag==1)
        {
            if (!islevelEnabled) {
                return [self.functionLocationHierarchyArray count];
                
            }
            
            else{
                 return [self.filteredArray count];
             }
        }
        else if (seachDropdownTableView.tag==2){
            
            return [self.dropDownArray count];
 
        }
        else
        {
            if (!islevelEnabled)
            {
                return [self.functionLocationArray count];
            }
            else{
                
                return [self.filteredArray count];
 
            }
        }
    }
   else if (tableView==notifSystemStatusTableView){
       
       if (notifSystemStatusTableView.tag == 0) {
           
           return [[[self.notifSystemStatusArray objectAtIndex:0] firstObject] count];
       }
       else if (notifSystemStatusTableView.tag == 1){
           
           return [[[self.notifSystemStatusArray objectAtIndex:1] firstObject] count];
       }
       else{
           
           return [[[self.notifSystemStatusArray objectAtIndex:2] firstObject] count];
       }
   }
    
   else if (tableView==attachmentsTableview){
       
     return   [self.attachmentArray count];
       
   }
     return 0;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == commomlistListTableview)
    {
        if (commomlistListTableview.tag==0) {
            
            if (!createNotificationFlag) {
 
                    if (indexPath.row==2||indexPath.row==3) {
                        
                        static NSString *CellIdentifier = @"NotifOrderCell";
                        
                        NotifOrderTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                        
                        if (cell==nil) {
                            cell=[[NotifOrderTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                        }
                        
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
 
                        cell.titleLabel.text=[[headerDataArray objectAtIndex:indexPath.row] objectAtIndex:0];
                        
                        NSMutableAttributedString *titleString = [[NSMutableAttributedString alloc] initWithString:[[headerDataArray objectAtIndex:indexPath.row] objectAtIndex:2]];
 
                        // using text on button
                        [cell.notifOrderBtn setAttributedTitle: titleString forState:UIControlStateNormal];
                        
                        if (indexPath.row==2) {
                            
                            NSMutableAttributedString *titleString = [[NSMutableAttributedString alloc] initWithString:[[headerDataArray objectAtIndex:indexPath.row] objectAtIndex:2]];
                            // making text property to underline text-
                            [titleString addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, [titleString length])];
                            
                            // using text on button
                            [cell.notifOrderBtn setAttributedTitle: titleString forState:UIControlStateNormal];
                        }
 
                    [cell.notifOrderBtn addTarget:self action:@selector(orderNoButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
 
                        return cell;
                 }
                else if (indexPath.row==4||indexPath.row==5||indexPath.row==6) {
                    
                    static NSString *CellIdentifier = @"SearchInputDropDownCell";
                    
                    SearchInputDropdownTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
 
                    if (cell==nil) {
                        cell=[[SearchInputDropdownTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    }
                    
                    cell.InputTextField.superview.tag = indexPath.row;
                    cell.InputTextField.delegate = self;
                    
                    cell.notifView.layer.cornerRadius = 2.0f;
                    cell.notifView.layer.masksToBounds = YES;
                    cell.notifView.layer.borderColor = [[UIColor darkGrayColor] CGColor];
                    cell.notifView.layer.borderWidth = 1.0f;
 
                    cell.madatoryLabel.hidden=YES;
                    
                    if (indexPath.row==6) {
                        
                        cell.madatoryLabel.hidden=NO;

                    }
                    
 
                    cell.scanBtn.hidden=NO;
                    cell.historyBtn.hidden=NO;
                    cell.scanLabel.hidden=NO;
                    
                    if (indexPath.row==4||indexPath.row==6) {
                        cell.scanBtn.hidden=YES;
                        cell.historyBtn.hidden=YES;
                        cell.scanLabel.hidden=YES;
                    }
                    
                    
                    cell.titleLabel.text=[[headerDataArray objectAtIndex:indexPath.row] objectAtIndex:0];
                    
                    cell.InputTextField.placeholder=[[headerDataArray objectAtIndex:indexPath.row] objectAtIndex:1];
                    
                    if (indexPath.row==6) {
                        
                        cell.InputTextField.text=[[headerDataArray objectAtIndex:indexPath.row] objectAtIndex:2];
                        
                    }
                    
                    else{
                        
                        cell.InputTextField.text=[[headerDataArray objectAtIndex:indexPath.row] objectAtIndex:3];
                        cell.namelabel.text=[[headerDataArray objectAtIndex:indexPath.row] objectAtIndex:2];
                        
                    }
                    
                    [cell.searchBtn addTarget:self action:@selector(functionLocationSearchAction:) forControlEvents:UIControlEventTouchUpInside];
                    
                    [cell.scanBtn addTarget:self action:@selector(scanSearchAction:) forControlEvents:UIControlEventTouchUpInside];
 
                    return cell;
                 }
                else{
                    
                        static NSString *CellIdentifier = @"InputDropDownCell";
                        
                        InputDropDownTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                        
                        if (cell==nil) {
                            cell=[[InputDropDownTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                        }
                        
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        
                        cell.dropDownImageView.hidden=NO;
                        
                        [cell.dropDownImageView setImage:[UIImage imageNamed:@"dropdown"]];
                    
                    cell.notifView.layer.cornerRadius = 2.0f;
                    cell.notifView.layer.masksToBounds = YES;
                    cell.notifView.layer.borderColor = [[UIColor darkGrayColor] CGColor];
                    cell.notifView.layer.borderWidth = 1.0f;
                    
                    [cell.longTextBtn addTarget:self action:@selector(longTxtAction:)   forControlEvents:UIControlEventTouchDown];

 
                    cell.longTextBtn.hidden=YES;
                    cell.madatoryLabel.hidden=NO;
                    
                    
                    if (indexPath.row==9||indexPath.row==10||indexPath.row==11||indexPath.row==15||indexPath.row==16) {
                        
                        cell.madatoryLabel.hidden=YES;
                        
                    }
                    
                    [cell.InputTextField setUserInteractionEnabled:YES];
 
                    if (indexPath.row==0) {
                        
                        [cell.InputTextField setUserInteractionEnabled:NO];

                    }
                        
                        if (indexPath.row==1||indexPath.row==9||indexPath.row==10)
                        {
                            if (indexPath.row==1) {
                                
                                cell.longTextBtn.hidden=NO;

                            }
                             cell.dropDownImageView.hidden=YES;
                         }
                        
                        else if (indexPath.row==12||indexPath.row==13||indexPath.row==14||indexPath.row==15){
                            
                            cell.dropDownImageView.hidden=NO;
                            
                            [cell.dropDownImageView setImage:[UIImage imageNamed:@"calendar"]];
                            
                        }
                        
                        cell.InputTextField.superview.tag = indexPath.row;
                        cell.InputTextField.delegate = self;
                        
                        cell.titleLabel.text=[[headerDataArray objectAtIndex:indexPath.row] objectAtIndex:0];
                        cell.InputTextField.placeholder=[[headerDataArray objectAtIndex:indexPath.row] objectAtIndex:1];
                        
                        cell.InputTextField.text=[[headerDataArray objectAtIndex:indexPath.row] objectAtIndex:2];
                        
                        return cell;
                    }
              }
            
            else{
               
                if (indexPath.row==2||indexPath.row==3||indexPath.row==4) {
                    
                    static NSString *CellIdentifier = @"SearchInputDropDownCell";
                    
                    SearchInputDropdownTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    
                    cell.notifView.layer.cornerRadius = 2.0f;
                    cell.notifView.layer.masksToBounds = YES;
                    cell.notifView.layer.borderColor = [[UIColor darkGrayColor] CGColor];
                    cell.notifView.layer.borderWidth = 1.0f;
                    
 
                    if (cell==nil) {
                        cell=[[SearchInputDropdownTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    }
                    
                    cell.InputTextField.superview.tag = indexPath.row;
                    cell.InputTextField.delegate = self;
                    
                    
                    cell.madatoryLabel.hidden=YES;
                    
                    if (indexPath.row==4) {
                        
                        cell.madatoryLabel.hidden=NO;
                        
                    }
                    
                    cell.scanBtn.hidden=NO;
                    cell.historyBtn.hidden=NO;
                    cell.scanLabel.hidden=NO;
                    
                    cell.historyBtn.hidden=YES;
                    
                    if (indexPath.row==2||indexPath.row==4) {
                        cell.scanBtn.hidden=YES;
                        cell.historyBtn.hidden=YES;
                        cell.scanLabel.hidden=YES;
                    }
 
                    cell.titleLabel.text=[[headerDataArray objectAtIndex:indexPath.row] objectAtIndex:0];
                    
                    cell.InputTextField.placeholder=[[headerDataArray objectAtIndex:indexPath.row] objectAtIndex:1];
                    
                    if (indexPath.row==4) {
                        
                        cell.InputTextField.text=[[headerDataArray objectAtIndex:indexPath.row] objectAtIndex:2];
                     }
                    
                    else{
                        
                        cell.InputTextField.text=[[headerDataArray objectAtIndex:indexPath.row] objectAtIndex:3];
                        cell.namelabel.text=[[headerDataArray objectAtIndex:indexPath.row] objectAtIndex:2];
                     }
                    
                    [cell.searchBtn addTarget:self action:@selector(functionLocationSearchAction:) forControlEvents:UIControlEventTouchUpInside];
                    
                    [cell.scanBtn addTarget:self action:@selector(scanSearchAction:) forControlEvents:UIControlEventTouchUpInside];
                    
                    return cell;
                    
                }
                else{
                    
                    static NSString *CellIdentifier = @"InputDropDownCell";
                    
                    InputDropDownTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    
                    if (cell==nil) {
                        cell=[[InputDropDownTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    }
                    
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    
                    cell.notifView.layer.cornerRadius = 2.0f;
                    cell.notifView.layer.masksToBounds = YES;
                    cell.notifView.layer.borderColor = [[UIColor darkGrayColor] CGColor];
                    cell.notifView.layer.borderWidth = 1.0f;
                    
                    cell.dropDownImageView.hidden=NO;
                    
                    [cell.dropDownImageView setImage:[UIImage imageNamed:@"dropdown"]];
                    
                     cell.longTextBtn.hidden=YES;
                    cell.madatoryLabel.hidden=NO;
                    
                    [cell.longTextBtn addTarget:self action:@selector(longTxtAction:)   forControlEvents:UIControlEventTouchDown];

                    if (indexPath.row==7||indexPath.row==8||indexPath.row==9||indexPath.row==13||indexPath.row==14||indexPath.row==11||indexPath.row==12) {
                         cell.madatoryLabel.hidden=YES;
                     }

                    if (indexPath.row==1||indexPath.row==7||indexPath.row==8)
                    {
                        
                        if (indexPath.row==1) {
                            
                            cell.longTextBtn.hidden=NO;
                        }
                        
                        cell.dropDownImageView.hidden=YES;
                        
                    }
                    
                    else if (indexPath.row==12||indexPath.row==11||indexPath.row==13||indexPath.row==10){
                        
                        cell.dropDownImageView.hidden=NO;
                        
                        [cell.dropDownImageView setImage:[UIImage imageNamed:@"calendar"]];
                        
                    }
                    
                    cell.InputTextField.superview.tag = indexPath.row;
                    cell.InputTextField.delegate = self;
                    
                    cell.titleLabel.text=[[headerDataArray objectAtIndex:indexPath.row] objectAtIndex:0];
                    cell.InputTextField.placeholder=[[headerDataArray objectAtIndex:indexPath.row] objectAtIndex:1];
                    
                    cell.InputTextField.text=[[headerDataArray objectAtIndex:indexPath.row] objectAtIndex:2];
                    
                    return cell;
                }
             }
           }
        else if (commomlistListTableview.tag==1)
        {
 
            static NSString *CellIdentifier = @"causecodeCell";
            
            ListofCauseCodesTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if (cell==nil) {
                cell=[[ListofCauseCodesTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            
            static NSInteger checkboxTag = 123;
            NSInteger x,y;x = 8.0; y = 9.0;
            
            UIButton *checkboxSelect = (UIButton *) [cell.contentView viewWithTag:checkboxTag];
            
            if (!checkboxSelect)
            {
                checkboxSelect = [[UIButton alloc] initWithFrame:(CGRectMake(x,y,25.0,25.0))];
                checkboxSelect.tag = checkboxTag;
                [cell.contentView addSubview:checkboxSelect];
            }
            
            [checkboxSelect setImage:[UIImage imageNamed:@"radiounselection.png"]   forState:UIControlStateNormal];
            
            checkboxSelect.adjustsImageWhenHighlighted = YES;
            [checkboxSelect addTarget:self action:@selector(checkBoxClicked:)   forControlEvents:UIControlEventTouchDown];
            
            cell.damageLabel.text = [NSString stringWithFormat:@"%@",[[[self.causeCodeDetailsArray objectAtIndex:indexPath.row] firstObject] objectAtIndex:3]];
            cell.damageCodeLabel.text = [NSString stringWithFormat:@"%@",[[[self.causeCodeDetailsArray objectAtIndex:indexPath.row] firstObject] objectAtIndex:5]];
            cell.damageDescriptionLabel.text = [NSString stringWithFormat:@"%@",[[[self.causeCodeDetailsArray objectAtIndex:indexPath.row] firstObject] objectAtIndex:10]];
            cell.causeLabel.text = [NSString stringWithFormat:@"%@",[[[self.causeCodeDetailsArray objectAtIndex:indexPath.row] firstObject] objectAtIndex:7]];
            cell.causeCodeLabel.text = [NSString stringWithFormat:@"%@",[[[self.causeCodeDetailsArray objectAtIndex:indexPath.row] firstObject] objectAtIndex:9]];
            cell.causeDescriptionLabel.text = [NSString stringWithFormat:@"%@",[[[self.causeCodeDetailsArray objectAtIndex:indexPath.row] firstObject] objectAtIndex:10]];
            
            //cell.itemCountLabel.text=[NSString stringWithFormat:@"%@",[[[self.causeCodeDetailsArray objectAtIndex:indexPath.row] firstObject] objectAtIndex:12]];
            
            if ([[[[self.causeCodeDetailsArray objectAtIndex:indexPath.row] firstObject] objectAtIndex:14] isEqualToString:@""]) {
                cell.itemCountLabel.textColor=UIColorFromRGB(59, 187, 196);
            }
            else{
                
                cell.itemCountLabel.textColor=[UIColor blackColor];
            }
            
            cell.damageLabel.adjustsFontSizeToFitWidth = YES;
            cell.damageCodeLabel.adjustsFontSizeToFitWidth = YES;
            cell.damageDescriptionLabel.adjustsFontSizeToFitWidth = YES;
            cell.causeLabel.adjustsFontSizeToFitWidth = YES;
            cell.causeCodeLabel.adjustsFontSizeToFitWidth = YES;
            cell.causeDescriptionLabel.adjustsFontSizeToFitWidth = YES;
 
 
            return cell;
        }
        
        else if (commomlistListTableview.tag==2) {
            
             static NSString *CellIdentifier = @"ActivityCell";
            
            ActivityTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if (cell==nil) {
                cell=[[ActivityTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            
            static NSInteger checkboxTag = 123;
            NSInteger x,y;x = 8.0; y = 8.0;
            
            UIButton *checkboxSelect = (UIButton *) [cell.contentView viewWithTag:checkboxTag];
            
            if (!checkboxSelect)
            {
                checkboxSelect = [[UIButton alloc] initWithFrame:(CGRectMake(x,y,25.0,25.0))];
                checkboxSelect.tag = checkboxTag;
            }
            
            [checkboxSelect setImage:[UIImage imageNamed:@"checkbox_unselected.png"]   forState:UIControlStateNormal];

           cell.activityKeyLabel.text=[[self.notifActivityDetailsArray objectAtIndex:indexPath.row] objectForKey:@"notificationa_ItemKey"] ;
             cell.activityTextLabel.text=[[self.notifActivityDetailsArray objectAtIndex:indexPath.row] objectForKey:@"notificationa_ActvShtxt"] ;
             cell.codeGroupLabel.text=[[self.notifActivityDetailsArray objectAtIndex:indexPath.row] objectForKey:@"notificationa_ActvGrp"] ;
             cell.codeLabel.text=[[self.notifActivityDetailsArray objectAtIndex:indexPath.row] objectForKey:@"notificationa_ActvCod"] ;
            
            return cell;
         }
        
         else if (commomlistListTableview.tag==3)
         {
            
            static NSString *CellIdentifier = @"AttachmentsCell";

             ListOfAttachmentsCustomTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if (cell==nil) {
                cell=[[ListOfAttachmentsCustomTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            
            cell.accessoryType = UITableViewCellAccessoryNone;
            
            if (indexPath.row % 2 == 0){
                cell.contentView.backgroundColor =UIColorFromRGB(249, 249, 249);
            }
            else {
                cell.contentView.backgroundColor =[UIColor whiteColor];
            }
            
               //for attachment Download8 8 34 21
               static NSInteger detailCheckBoxTag = 124;
              NSInteger i,j;
            
             UIButton *detailCheckBoxSelect = (UIButton *) [cell.contentView viewWithTag:detailCheckBoxTag];
 
                i =250.0; j = 8.0;
            
                if (!detailCheckBoxSelect)
                {
                    detailCheckBoxSelect = [[UIButton alloc] initWithFrame:(CGRectMake(i,j,34,21))];
                    detailCheckBoxSelect.tag = detailCheckBoxTag;
                    [cell.contentView addSubview:detailCheckBoxSelect];
                }
 
            [detailCheckBoxSelect setImage:[UIImage imageNamed:@"download"] forState:UIControlStateNormal];
            detailCheckBoxSelect.adjustsImageWhenHighlighted = YES;
            [detailCheckBoxSelect addTarget:self action:@selector(attachmentsDownloadButtonClickedinNotifications:) forControlEvents:UIControlEventTouchDown];
            
            cell.countLabel.text = [NSString stringWithFormat:@"%li)",(long)indexPath.row+1];
            cell.fileNameLabel.text = [NSString stringWithFormat:@"%@",[[self.attachmentArray objectAtIndex:indexPath.row] objectAtIndex:3]];
            cell.fileTypeLabel.text = [NSString stringWithFormat:@"%@",[[self.attachmentArray objectAtIndex:indexPath.row] objectAtIndex:4]];
            if ([[[[self.attachmentArray objectAtIndex:indexPath.row] objectAtIndex:6] uppercaseString] isEqualToString:@"BUS2038"]) {
                cell.objectTypeLabel.text = @"Notification";
            }
            else  if ([[[[self.attachmentArray objectAtIndex:indexPath.row] objectAtIndex:6] uppercaseString] isEqualToString:@"EQUI"]) {
                cell.objectTypeLabel.text = @"Equipment";
            }
            else  if ([[[[self.attachmentArray objectAtIndex:indexPath.row] objectAtIndex:6] uppercaseString]isEqualToString:@"BUS2007"]) {
                cell.objectTypeLabel.text = @"Order";
            }
            else  if ([[[[self.attachmentArray objectAtIndex:indexPath.row] objectAtIndex:6] uppercaseString]isEqualToString:@"BUS0010"]) {
                cell.objectTypeLabel.text = @"Functional Location";
            }
            
            return cell;
            
        }
        else if (commomlistListTableview.tag==4){
            
            static NSString *CellIdentifier = @"InspectionCell";
 
            InspectionResultTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
 
            if (cell==nil) {
                cell=[[InspectionResultTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            
            if (indexPath.row % 2 == 0){
                cell.backgroundColor =UIColorFromRGB(249, 249, 249);
            }
            else {
                cell.backgroundColor =[UIColor whiteColor];
            }
            
            cell.accessoryType = UITableViewCellAccessoryNone;
            
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            
            cell.measurementDocumentLabel.text =[NSString stringWithFormat:@"%@",[[notifInspectionArray objectAtIndex:indexPath.row] objectAtIndex:4]];
            cell.pointLabel.text = [[notifInspectionArray objectAtIndex:indexPath.row] objectAtIndex:5];
            cell.descLabel.text = [[notifInspectionArray objectAtIndex:indexPath.row] objectAtIndex:9];
            cell.dateLabel.text = [NSString stringWithFormat:@"%@ %@",[[notifInspectionArray objectAtIndex:indexPath.row] objectAtIndex:11],[[notifInspectionArray objectAtIndex:indexPath.row] objectAtIndex:12]];
            cell.readingLabel.text = [[notifInspectionArray objectAtIndex:indexPath.row] objectAtIndex:18];
            cell.targetLabel.text = [[notifInspectionArray objectAtIndex:indexPath.row] objectAtIndex:19];
            cell.unitLabel.text = [[notifInspectionArray objectAtIndex:indexPath.row] objectAtIndex:17];
            cell.personLabel.text = [[notifInspectionArray objectAtIndex:indexPath.row] objectAtIndex:14];
            cell.resultLabel.text = [[notifInspectionArray objectAtIndex:indexPath.row] objectAtIndex:24];
            cell.notesLabel.text = [[notifInspectionArray objectAtIndex:indexPath.row] objectAtIndex:13];
            
            return cell;
        }
    }
    else if (tableView==commonAddTableView)
    {
        if (commonAddTableView.tag==0) {
            
            static NSString *CellIdentifier = @"CustomDropdownTableViewCell";
            
            CustomInputDorpdownTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if (cell==nil) {
                cell=[[CustomInputDorpdownTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;

            cell.mandatoryLabel.hidden=NO;
            
            cell.notifView.layer.cornerRadius = 2.0f;
            cell.notifView.layer.masksToBounds = YES;
            cell.notifView.layer.borderColor = [[UIColor darkGrayColor] CGColor];
            cell.notifView.layer.borderWidth = 1.0f;
            
            if (indexPath.row==0||indexPath.row==1||indexPath.row==4||indexPath.row==7)
            {
                cell.mandatoryLabel.hidden=YES;

            }
 
            cell.additionalDatabtn.hidden=YES;
            cell.dropDownImageView.hidden=NO;
            
            cell.InputTextField.superview.tag = indexPath.row;
            cell.InputTextField.delegate = self;
            
            if (indexPath.row==2||indexPath.row==5) {
                
                cell.additionalDatabtn.hidden=NO;
                
            }
            
            if (indexPath.row==4||indexPath.row==7) {
                cell.dropDownImageView.hidden=YES;
            }
            
            cell.titleLabel.text=[[addCauseCodeDataArray objectAtIndex:indexPath.row] objectAtIndex:0];
            cell.InputTextField.placeholder=[[addCauseCodeDataArray objectAtIndex:indexPath.row] objectAtIndex:1];
            
              cell.InputTextField.text=[[addCauseCodeDataArray objectAtIndex:indexPath.row] objectAtIndex:2];
            
            return cell;
        }
        else if (commonAddTableView.tag==2)
        {
            if (indexPath.row==1||indexPath.row==2) {
                
                static NSString *CellIdentifier = @"NotifOrderCell";
                
                NotifOrderTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                
                if (cell==nil) {
                    cell=[[NotifOrderTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                }
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
 
                cell.titleLabel.text=[[addActivityArray objectAtIndex:indexPath.row] objectAtIndex:0];
                
                [cell.notifOrderBtn setTitle:[[addActivityArray objectAtIndex:indexPath.row] objectAtIndex:2] forState:UIControlStateNormal];
                
                
                return cell;
            }
             else{
                
                static NSString *CellIdentifier = @"CustomDropdownTableViewCell";
                
                CustomInputDorpdownTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                
                if (cell==nil) {
                    cell=[[CustomInputDorpdownTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                }
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                cell.mandatoryLabel.hidden=YES;
                 
                 cell.notifView.layer.cornerRadius = 2.0f;
                 cell.notifView.layer.masksToBounds = YES;
                 cell.notifView.layer.borderColor = [[UIColor darkGrayColor] CGColor];
                 cell.notifView.layer.borderWidth = 1.0f;
                
                [cell.dropDownImageView setImage:[UIImage imageNamed:@"calendar"]];


                cell.additionalDatabtn.hidden=YES;
                cell.dropDownImageView.hidden=NO;
                
                cell.InputTextField.superview.tag = indexPath.row;
                cell.InputTextField.delegate = self;
 
                  if (indexPath.row==0||indexPath.row==3||indexPath.row==4){
                    
                    [cell.dropDownImageView setImage:[UIImage imageNamed:@"dropdown"]];
 
                }
                
                if (indexPath.row==5) {
                    cell.dropDownImageView.hidden=YES;
                }
                
                cell.titleLabel.text=[[addActivityArray objectAtIndex:indexPath.row] objectAtIndex:0];
                cell.InputTextField.placeholder=[[addActivityArray objectAtIndex:indexPath.row] objectAtIndex:1];
                cell.InputTextField.text=[[addActivityArray objectAtIndex:indexPath.row] objectAtIndex:2];
                
                return cell;
                
            }
         }
      }
 
    else if (tableView ==duplicateNotificationTableView) {
        
        if (duplicateNotificationTableView.contentSize.height < duplicateNotificationTableView.frame.size.height) {
            duplicateNotificationTableView.scrollEnabled = NO;
        }
        else {
            duplicateNotificationTableView.scrollEnabled = YES;
        }
        static NSString *CellIdentifier = @"Cell";
        
        DuplicateNotificationTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        
        if (cell==nil) {
            cell=[[DuplicateNotificationTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        
        cell.accessoryType = UITableViewCellAccessoryNone;
        
        if (indexPath.row % 2 == 0){
            cell.backgroundColor =UIColorFromRGB(249, 249, 249);
        }
        else {
            cell.backgroundColor =[UIColor whiteColor];
        }
        
        cell.notificaitonNumberLabel.text = [[notificatinDuplicateArray objectAtIndex:indexPath.row] objectForKey:@"Qmnum"];
        cell.priorityLabel.text = [[notificatinDuplicateArray objectAtIndex:indexPath.row] objectForKey:@"Priok"];
        cell.shortTextLabel.text = [[notificatinDuplicateArray objectAtIndex:indexPath.row] objectForKey:@"Qmtxt"];
        
        return cell;
    }
  
    
  else  if (tableView == self.dropDownTableView) {
        
        static NSString *CellIdentifier = @"Cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell==nil) {
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        cell.accessoryType=UITableViewCellAccessoryNone;
        
        if ([[self.dropDownArray objectAtIndex:indexPath.row] count] == 2) {
            cell.textLabel.text = [NSString stringWithFormat:@"%@-%@",[[self.dropDownArray objectAtIndex:indexPath.row] objectAtIndex:ID_INDEX],[[self.dropDownArray objectAtIndex:indexPath.row] objectAtIndex:NAME_INDEX]];
        }
        else if ([[self.dropDownArray objectAtIndex:indexPath.row] count] == 1) {
            cell.textLabel.text = [NSString stringWithFormat:@"%@",[[self.dropDownArray objectAtIndex:indexPath.row] objectAtIndex:ID_INDEX]];
        }
        
        else if ([[self.dropDownArray objectAtIndex:indexPath.row] count] == 5) {
            cell.textLabel.text = [NSString stringWithFormat:@"%@-%@%@",[[self.dropDownArray objectAtIndex:indexPath.row] objectAtIndex:2],[[self.dropDownArray objectAtIndex:indexPath.row] objectAtIndex:4],[[self.dropDownArray objectAtIndex:indexPath.row] objectAtIndex:3]];
        }
        
        else if ([[self.dropDownArray objectAtIndex:indexPath.row] count] == 3) {
            cell.textLabel.text = [NSString stringWithFormat:@"%@-%@",[[self.dropDownArray objectAtIndex:indexPath.row] objectAtIndex:1],[[self.dropDownArray objectAtIndex:indexPath.row] objectAtIndex:2]];
            
        }
 
        return cell;
    }
    
   else if (tableView == seachDropdownTableView)
    {
        
        static NSString *CellIdentifier = @"Cell";
        
        FunctionalLocationTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell==nil) {
            cell=[[FunctionalLocationTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        cell.accessoryType = UITableViewCellAccessoryNone;
        
        if (seachDropdownTableView.tag==1) {
            
            
            if ([[[self.functionLocationHierarchyArray objectAtIndex:indexPath.row] objectForKey:@"stplnr"] isEqualToString:@"X"]) {
                
                [cell.funcLocBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
                
                cell.funcLocContentView.layer.cornerRadius = 2.0f;
                cell.funcLocContentView.layer.masksToBounds = YES;
                cell.funcLocContentView.layer.borderColor = [[UIColor redColor] CGColor];
                cell.funcLocContentView.layer.borderWidth = 1.0f;

                
                [cell.funcLocBtn setUserInteractionEnabled:YES];
                
                [cell.funcLocBtn addTarget:self action:@selector(fLocationHDetailButtonClicked:) forControlEvents:UIControlEventTouchDown];
            }
            
            else
            {
                [cell.funcLocBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                
                cell.funcLocContentView.layer.cornerRadius = 2.0f;
                cell.funcLocContentView.layer.masksToBounds = YES;
                cell.funcLocContentView.layer.borderColor = [[UIColor redColor] CGColor];
                cell.funcLocContentView.layer.borderWidth = 1.0f;

                [cell.funcLocBtn setUserInteractionEnabled:NO];
            }
            
            
            if (!islevelEnabled)
            {
                
                [cell.funcLocBtn setTitle:[[self.functionLocationHierarchyArray objectAtIndex:indexPath.row] objectForKey:@"locationid"] forState:UIControlStateNormal];
                cell.funcLocationDescriptionLabel.text =[[self.functionLocationHierarchyArray objectAtIndex:indexPath.row] objectForKey:@"locationName"];
            }
            else{
                
                [cell.funcLocBtn setTitle:[[self.filteredArray objectAtIndex:indexPath.row] objectForKey:@"locationid"] forState:UIControlStateNormal];
                
                cell.funcLocationDescriptionLabel.text =[[self.filteredArray objectAtIndex:indexPath.row] objectForKey:@"locationName"];
            }
            
            return cell;
        }
        
        else if (seachDropdownTableView.tag==2){
            
            static NSString *CellIdentifier = @"WorkcenterCell";
            
            WorkcenterTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if (cell==nil) {
                cell=[[WorkcenterTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            cell.accessoryType = UITableViewCellAccessoryNone;
            
            cell.idLabel.text=[[self.dropDownArray objectAtIndex:indexPath.row] objectAtIndex:2];
            
            cell.textLabel.text=[[self.dropDownArray objectAtIndex:indexPath.row] objectAtIndex:3];
 
            return cell;
            
        }
        else{
            
            
            [cell.funcLocBtn addTarget:self action:@selector(fLocationHDetailButtonClicked:) forControlEvents:UIControlEventTouchDown];
            
            cell.funcLocationIdLabel.textColor = [UIColor redColor];
            
            cell.funcLocContentView.layer.cornerRadius = 2.0f;
            cell.funcLocContentView.layer.masksToBounds = YES;
            cell.funcLocContentView.layer.borderColor = [[UIColor redColor] CGColor];
            cell.funcLocContentView.layer.borderWidth = 1.0f;

            
            [cell.funcLocBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            
            if (!islevelEnabled)
            {
                 [cell.funcLocBtn setTitle:[[self.functionLocationArray objectAtIndex:indexPath.row] objectForKey:@"locationid"] forState:UIControlStateNormal];
                 cell.funcLocationDescriptionLabel.text =[[self.functionLocationArray objectAtIndex:indexPath.row] objectForKey:@"locationName"];
                
            }
            else{
                
                [cell.funcLocBtn setTitle:[[self.filteredArray objectAtIndex:indexPath.row] objectForKey:@"locationid"] forState:UIControlStateNormal];
                
                cell.funcLocationDescriptionLabel.text =[[self.filteredArray objectAtIndex:indexPath.row] objectForKey:@"locationName"];
            }
            
            return cell;
        }
    }
    
    
   else if (tableView==notifSystemStatusTableView){
       
       if (notifSystemStatusTableView.contentSize.height < notifSystemStatusTableView.frame.size.height) {
           notifSystemStatusTableView.scrollEnabled = NO;
       }
       else
           notifSystemStatusTableView.scrollEnabled = YES;
       
       static NSString *CellIdentifier = @"Cell";
       
       OrderSystemStatusTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
       
       
       if (cell==nil) {
           cell=[[OrderSystemStatusTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
       }
       
       if (indexPath.row % 2 == 0){
           cell.backgroundColor =UIColorFromRGB(249, 249, 249);
       }
       else {
           cell.backgroundColor =[UIColor whiteColor];
       }
       
       cell.accessoryType = UITableViewCellAccessoryNone;
       
       cell.selectionStyle=UITableViewCellSelectionStyleNone;
       
//       static NSInteger checkboxTag = 123;
//       NSInteger x,y;x = 8.0; y = 14.0;
       
//      cell.checkBoxNRadioButtonSelectionForSystemStatusButton = (UIButton *) [cell.contentView viewWithTag:checkboxTag];
//
//       if (!cell.checkBoxNRadioButtonSelectionForSystemStatusButton)
//       {
//            cell.checkBoxNRadioButtonSelectionForSystemStatusButton.tag = checkboxTag;
//        }
       
       cell.checkBoxNRadioButtonSelectionForSystemStatusButton.adjustsImageWhenHighlighted = YES;
       cell.accessoryType = UITableViewCellAccessoryNone;
       
       [cell.checkBoxNRadioButtonSelectionForSystemStatusButton addTarget:self action:@selector(checkBoxNRadioButtonSelectionForSystemStatus:)   forControlEvents:UIControlEventTouchDown];
       
       if (notifSystemStatusTableView.tag == 0) {
           
           cell.txt04.text=[[[[self.notifSystemStatusArray objectAtIndex:0] firstObject] objectAtIndex:indexPath.row] objectForKey:@"notifications_txt04"];
           cell.Txt30.text=[[[[self.notifSystemStatusArray objectAtIndex:0] firstObject] objectAtIndex:indexPath.row] objectForKey:@"notifications_txt30"];
           
           if ([[[[[self.notifSystemStatusArray objectAtIndex:0] firstObject] objectAtIndex:indexPath.row] objectForKey:@"notifications_act"] isEqualToString:@"X"]) {
               
               [cell.checkBoxNRadioButtonSelectionForSystemStatusButton  setImage:[UIImage imageNamed:@"radioselection.png"]   forState:UIControlStateNormal];
           }
           else{
               
               [cell.checkBoxNRadioButtonSelectionForSystemStatusButton  setImage:[UIImage imageNamed:@"radiounselection.png"]   forState:UIControlStateNormal];
           }
       }
       else if (notifSystemStatusTableView.tag == 1){
           
           cell.txt04.text=[[[[self.notifSystemStatusArray objectAtIndex:1] firstObject] objectAtIndex:indexPath.row] objectForKey:@"notifications_txt04"];
           cell.Txt30.text=[[[[self.notifSystemStatusArray objectAtIndex:1] firstObject] objectAtIndex:indexPath.row] objectForKey:@"notifications_txt30"];
           
           if ([[[[[self.notifSystemStatusArray objectAtIndex:1] firstObject] objectAtIndex:indexPath.row] objectForKey:@"notifications_act"] isEqualToString:@"X"]) {
               
               [cell.checkBoxNRadioButtonSelectionForSystemStatusButton  setImage:[UIImage imageNamed:@"radioselection.png"]   forState:UIControlStateNormal];
           }
           else{
               
               [cell.checkBoxNRadioButtonSelectionForSystemStatusButton  setImage:[UIImage imageNamed:@"radiounselection.png"]   forState:UIControlStateNormal];
           }
       }
       else if (notifSystemStatusTableView.tag == 2){
           
           cell.txt04.text=[[[[self.notifSystemStatusArray objectAtIndex:2] firstObject] objectAtIndex:indexPath.row] objectForKey:@"notifications_txt04"];
           cell.Txt30.text=[[[[self.notifSystemStatusArray objectAtIndex:2] firstObject] objectAtIndex:indexPath.row] objectForKey:@"notifications_txt30"];
           
           if ([[[[[self.notifSystemStatusArray objectAtIndex:2] firstObject] objectAtIndex:indexPath.row] objectForKey:@"notifications_act"] isEqualToString:@"X"]) {
               
               [cell.checkBoxNRadioButtonSelectionForSystemStatusButton  setImage:[UIImage imageNamed:@"radioselection.png"]   forState:UIControlStateNormal];
           }
           else{
               
               [cell.checkBoxNRadioButtonSelectionForSystemStatusButton  setImage:[UIImage imageNamed:@"radiounselection.png"]   forState:UIControlStateNormal];
           }
       }
       
       return cell;
   }
    
    
   else if (tableView==attachmentsTableview){
       
       static NSString *CellIdentifier = @"attachmentCell";
       
       AttachmentsTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
 
       if (cell==nil) {
           cell=[[AttachmentsTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
       }
       
       cell.selectionStyle = UITableViewCellSelectionStyleNone;
       
       cell.uploadedLabel.text=[[self.attachmentArray objectAtIndex:indexPath.row] objectAtIndex:2];
       
       // cell.idLabel.text=[[self.attachmentsArray objectAtIndex:indexPath.row] objectForKey:@"id"];
 
        UIImage *ret = [UIImage imageWithContentsOfFile:[arr_images objectAtIndex:indexPath.row]];
           
        cell.attachmentImage.image=ret;

 
       return cell;
   }
    
      return nil;
 }

- (UIImage *)decodeBase64ToImage:(NSString *)strEncodeData {
    NSData *data = [[NSData alloc]initWithBase64EncodedString:strEncodeData options:NSDataBase64DecodingIgnoreUnknownCharacters];
    return [UIImage imageWithData:data];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
      if (tableView ==commomlistListTableview)
      {
           if (commomlistListTableview.tag==1) {
 
             itemSelectedFlag = YES;
             customDamageFieldFlag = NO;
             customCauseFieldFlag = NO;
              
              updateFlag=YES;
              
              if (createNotificationFlag)
              {
//            self.updateCauseCodesBtn.hidden = NO;
//
//            self.addCauseCodesBtn.hidden=NO;
              }
            
        else{
            if (editBtnSelected)
            {
//                self.updateCauseCodesBtn.hidden = NO;
//                self.addCauseCodesBtn.hidden=NO;
            }
            else{
//                self.updateCauseCodesBtn.hidden = YES;
//                self.addCauseCodesBtn.hidden=YES;
            }
        }
        
       // newChangeCauseCodeLabel.text = @"Update Cause Code";
 
 
        [addCauseTaskBtn setTitle:@"Update" forState:UIControlStateNormal];

          
          addCauseCodeDataArray=[NSMutableArray new];
          commonAddTableView.tag=0;
          
          vornrItemID = [NSString stringWithFormat:@"%lld",[[[[self.causeCodeDetailsArray objectAtIndex:indexPath.row] firstObject] objectAtIndex:12] longLongValue]];
          
          VornrItem = [vornrItemID intValue];
          
          
          vornrCauseCodeID = [NSString stringWithFormat:@"%lld",[[[[self.causeCodeDetailsArray objectAtIndex:indexPath.row] firstObject] objectAtIndex:13] longLongValue]];
          
          VornrCauseCode = [vornrCauseCodeID intValue];
            
          VornrCauseCode = VornrCauseCode+1;
 
          [addCauseCodeDataArray addObject:[NSMutableArray arrayWithObjects:@"Object Part",@"Select Object Part",[NSString stringWithFormat:@"%@",[[[self.causeCodeDetailsArray objectAtIndex:indexPath.row] firstObject] objectAtIndex:18]],[[[self.causeCodeDetailsArray objectAtIndex:indexPath.row] firstObject] objectAtIndex:17], nil]];
 
          [addCauseCodeDataArray addObject:[NSMutableArray arrayWithObjects:@"Object Part Code",@"Select Object Part Code",[NSString stringWithFormat:@"%@",[[[self.causeCodeDetailsArray objectAtIndex:indexPath.row] firstObject] objectAtIndex:19]],[[[self.causeCodeDetailsArray objectAtIndex:indexPath.row] firstObject] objectAtIndex:16], nil]];
          
          [addCauseCodeDataArray addObject:[NSMutableArray arrayWithObjects:@"Danage",@"Select Damage",[NSString stringWithFormat:@"%@",[[[self.causeCodeDetailsArray objectAtIndex:indexPath.row] firstObject] objectAtIndex:3]],[[[self.causeCodeDetailsArray objectAtIndex:indexPath.row] firstObject] objectAtIndex:2], nil]];
          
          [addCauseCodeDataArray addObject:[NSMutableArray arrayWithObjects:@"Damage Code",@"Select Damage Code",[NSString stringWithFormat:@"%@",[[[self.causeCodeDetailsArray objectAtIndex:indexPath.row] firstObject] objectAtIndex:5]],[[[self.causeCodeDetailsArray objectAtIndex:indexPath.row] firstObject] objectAtIndex:4], nil]];
          
          [addCauseCodeDataArray addObject:[NSMutableArray arrayWithObjects:@"Damage Description",@"Enter Event description",[NSString stringWithFormat:@"%@",[[[self.causeCodeDetailsArray objectAtIndex:indexPath.row] firstObject] objectAtIndex:10]],@"", nil]];
          
          [addCauseCodeDataArray addObject:[NSMutableArray arrayWithObjects:@"Cause",@"Select Cause",[NSString stringWithFormat:@"%@",[[[self.causeCodeDetailsArray objectAtIndex:indexPath.row] firstObject] objectAtIndex:7]],[[[self.causeCodeDetailsArray objectAtIndex:indexPath.row] firstObject] objectAtIndex:6], nil]];
          
          [addCauseCodeDataArray addObject:[NSMutableArray arrayWithObjects:@"Cause Code",@"Select Cause Code",[NSString stringWithFormat:@"%@",[[[self.causeCodeDetailsArray objectAtIndex:indexPath.row] firstObject] objectAtIndex:9]],[[[self.causeCodeDetailsArray objectAtIndex:indexPath.row] firstObject] objectAtIndex:8], nil]];
          
          [addCauseCodeDataArray addObject:[NSMutableArray arrayWithObjects:@"Cause Description",@"Enter Cause Description",[NSString stringWithFormat:@"%@",[[[self.causeCodeDetailsArray objectAtIndex:indexPath.row] firstObject] objectAtIndex:11]],@"", nil]];
          
 
            if ([[[self.causeCodeDetailsArray objectAtIndex:indexPath.row] lastObject] count]) {
                
                for (int i =0; i <[[[self.causeCodeDetailsArray objectAtIndex:indexPath.row] lastObject] count]; i++) {
                    
                    [[self.customCauseDetailsArray objectAtIndex:i] replaceObjectAtIndex:4 withObject:[[[[self.causeCodeDetailsArray objectAtIndex:indexPath.row] lastObject] objectAtIndex:i] objectAtIndex:4]];
                }
                
                [defaults setObject:[[self.causeCodeDetailsArray objectAtIndex:indexPath.row] lastObject] forKey:@"tempCustomCause"];
            }
            else{
                [defaults setObject:self.customCauseDetailsArray forKey:@"tempCustomCause"];
            }
            
            [defaults setObject:[[self.causeCodeDetailsArray objectAtIndex:indexPath.row] objectAtIndex:1] forKey:@"tempCustomDamage"];
            
            [defaults synchronize];
          
           submitResetView.hidden=YES;
          
          [commomlistListTableview addSubview:addCauseTaskView];
          
          [addCauseTaskView setFrame:CGRectMake(0, 0, commomlistListTableview.frame.size.width, commomlistListTableview.frame.size.height)];
          
          commonAddTableView.tag=0;
          [commonAddTableView reloadData];
              
          }
//
//           else if (commomlistListTableview.tag==2){
//
//                  currentTaskIndex = (int)indexPath.row;
//
//                  //   taskHeaderLabel.text = @"Update Task Code";
//
//                  if (taskGroupID == nil) {
//                      taskGroupID = [NSMutableString stringWithString:@""];
//                  }
//
//                  if (taskCodeID == nil) {
//                      taskCodeID = [NSMutableString stringWithString:@""];
//                  }
//
//                  if (taskProcessorID == nil) {
//                      taskProcessorID = [NSMutableString stringWithString:@""];
//                  }
//
//                  [taskGroupID setString:[[[self.notifTaskCodesDetailsArray objectAtIndex:indexPath.row] firstObject] objectAtIndex:3]];
//
//                  addTaskCodeDataArray=[NSMutableArray new];
//
//                  commonAddTableView.tag=1;
//
//
//                  [addTaskCodeDataArray addObject:[NSMutableArray arrayWithObjects:@"Task group",@"Select Task Group",[[[self.notifTaskCodesDetailsArray objectAtIndex:indexPath.row] firstObject] objectAtIndex:4], nil]];
//
//                  [addTaskCodeDataArray addObject:[NSMutableArray arrayWithObjects:@"Task Code",@"Select Task Code",[[[self.notifTaskCodesDetailsArray objectAtIndex:indexPath.row] firstObject] objectAtIndex:5], nil]];
//
//                  [addTaskCodeDataArray addObject:[NSMutableArray arrayWithObjects:@"Task Text",@"Enter Task Text",[[[self.notifTaskCodesDetailsArray objectAtIndex:indexPath.row] firstObject]objectAtIndex:7], nil]];
//
//                  [addTaskCodeDataArray addObject:[NSMutableArray arrayWithObjects:@"Task Processor",@"Select Task Processor",[[[self.notifTaskCodesDetailsArray objectAtIndex:indexPath.row] firstObject] objectAtIndex:9],[[[self.notifTaskCodesDetailsArray objectAtIndex:indexPath.row] firstObject] objectAtIndex:8], nil]];
//
//                  [addTaskCodeDataArray addObject:[NSMutableArray arrayWithObjects:@"Responsible",@"Enter Responsible",[[[self.notifTaskCodesDetailsArray objectAtIndex:indexPath.row] firstObject] objectAtIndex:10], nil]];
//
//                  NSDateFormatter *taskCodesDateFormatter=[[NSDateFormatter alloc]init];
//
//                  [taskCodesDateFormatter setDateFormat:@"yyyy-MM-dd"];
//
//                  NSDate *tempStartDate = [taskCodesDateFormatter dateFromString:[[[self.notifTaskCodesDetailsArray objectAtIndex:indexPath.row] firstObject] objectAtIndex:11]];
//                  NSDate *tempFinishDate = [taskCodesDateFormatter dateFromString:[[[self.notifTaskCodesDetailsArray objectAtIndex:indexPath.row] firstObject] objectAtIndex:12]];
//                  // Convert date object into desired format
//                  [taskCodesDateFormatter setDateFormat:@"MMM dd, yyyy"];
//
//                  NSString *convertedStartDateString = [taskCodesDateFormatter stringFromDate:tempStartDate];
//                  NSString *convertedFinishDateString = [taskCodesDateFormatter stringFromDate:tempFinishDate];
//
//                  if ([NullChecker isNull:convertedStartDateString]) {
//                      convertedStartDateString = @"";
//                  }
//
//                  if ([NullChecker isNull:convertedFinishDateString]) {
//                      convertedFinishDateString = @"";
//                  }
//
//
//                  [addTaskCodeDataArray addObject:[NSMutableArray arrayWithObjects:@"Planned Start Date",@"Select Planned Start Date",convertedStartDateString, nil]];
//
//                  [addTaskCodeDataArray addObject:[NSMutableArray arrayWithObjects:@"Planned Finish Date",@"Select Planned Finished Date",convertedFinishDateString, nil]];
//
//                  if ([[[[self.notifTaskCodesDetailsArray objectAtIndex:indexPath.row] firstObject] objectAtIndex:38] isEqualToString:@"0000-00-00"]) {
//
//                      [addTaskCodeDataArray addObject:[NSMutableArray arrayWithObjects:@"Planned Start Time",@"Select Planned Start Time",@"", nil]];
//                   }
//                  else{
//
//                      [addTaskCodeDataArray addObject:[NSMutableArray arrayWithObjects:@"Planned Start Time",@"Select Planned Start Time",[[[self.notifTaskCodesDetailsArray objectAtIndex:indexPath.row] firstObject] objectAtIndex:38], nil]];
//                   }
//
//
//                  if ([[[[self.notifTaskCodesDetailsArray objectAtIndex:indexPath.row] firstObject] objectAtIndex:39] isEqualToString:@"00:00:00"]) {
//
//                      [addTaskCodeDataArray addObject:[NSMutableArray arrayWithObjects:@"Planned Finshed Time",@"Select Planned Finish Time",@"", nil]];
//                   }
//                  else{
//
//                      [addTaskCodeDataArray addObject:[NSMutableArray arrayWithObjects:@"Planned Finshed Time",@"Select Planned Finish Time",[[[self.notifTaskCodesDetailsArray objectAtIndex:indexPath.row] firstObject] objectAtIndex:39], nil]];
//                  }
//
//                  [taskCodeID setString:[[[self.notifTaskCodesDetailsArray objectAtIndex:indexPath.row] firstObject] objectAtIndex:5]];
//
//
//                  if ([[[[self.notifTaskCodesDetailsArray objectAtIndex:indexPath.row] firstObject] objectAtIndex:13] isEqualToString:@"X"]) {
//
//                      releaseCheckBoxString = @"X";
//                       releaseCheckBoxFlag = NO;
//
//                  }
//                  else{
//                      releaseCheckBoxString=@"";
//
//                      releaseCheckBoxFlag=NO;
//                  }
//
//                  if ([[[[self.notifTaskCodesDetailsArray objectAtIndex:indexPath.row] firstObject] objectAtIndex:14] isEqualToString:@"X"])
//                  {
//                      completeCheckBoxString = @"X";
//
//                      if (![[[[self.notifTaskCodesDetailsArray objectAtIndex:currentTaskIndex] firstObject] objectAtIndex:17] isEqualToString:@"A"]) {
//
//                          [self taskInputsDisableMethod];
//                      }
//                      completeCheckBoxFlag = YES;
//                  }
//                  else{
//
//                      completeCheckBoxString=@"";
//
//                      completeCheckBoxFlag=NO;
//                  }
//
//
//                  if ([[[[self.notifTaskCodesDetailsArray objectAtIndex:indexPath.row] firstObject] objectAtIndex:15] isEqualToString:@"X"]) {
//                      suceessCheckBoxString = @"X";
//
//                      if (![[[[self.notifTaskCodesDetailsArray objectAtIndex:currentTaskIndex] firstObject] objectAtIndex:17] isEqualToString:@"A"])
//                      {
//                          [self taskInputsDisableMethod];
//                      }
//
//                      succesCheckBoxFlag = YES;
//                  }
//                  else{
//
//                      suceessCheckBoxString=@"";
//
//                      succesCheckBoxFlag=NO;
//                  }
//
//
//                  [addTaskCodeDataArray addObject:[NSMutableArray arrayWithObjects:@"Status",releaseCheckBoxString,completeCheckBoxString,suceessCheckBoxString, nil]];
//
//                  if ([[[self.notifTaskCodesDetailsArray objectAtIndex:indexPath.row] lastObject] count]) {
//
//                      //  [[self.customTasksDetailsArray firstObject] replaceObjectAtIndex:4 withObject:[[self.notifTaskCodesDetailsArray objectAtIndex:indexPath.row] lastObject]];
//
//                      [defaults setObject:[[self.notifTaskCodesDetailsArray objectAtIndex:indexPath.row] lastObject] forKey:@"tempCustomTask"];
//                  }
//                  else{
//                      [defaults setObject:self.customTasksDetailsArray forKey:@"tempCustomTask"];
//                  }
//
//                  [addTaskCodeDataArray addObject:[NSMutableArray arrayWithObjects:@"Completion Date",@"Select Completion  Date",@"", nil]];
//                   [addTaskCodeDataArray addObject:[NSMutableArray arrayWithObjects:@"Completion Time",@"Select Completion  Time",@"", nil]];
//                   [addTaskCodeDataArray addObject:[NSMutableArray arrayWithObjects:@"Reported By",@"Enter Reported By",[[[self.notifTaskCodesDetailsArray objectAtIndex:indexPath.row] firstObject] objectAtIndex:40], nil]];
//
//
//                  [addCauseTaskView setFrame:CGRectMake(0, 0, commomlistListTableview.frame.size.width, commomlistListTableview.frame.size.height)];
//
//                  submitResetView.hidden=YES;
//
//                  [commomlistListTableview addSubview:addCauseTaskView];
//
//                  [commonAddTableView reloadData];
//             }
          
            else if (commomlistListTableview.tag==2){
               
               addActivityArray=[NSMutableArray new];
               
               commonAddTableView.tag=2;
 
               [addActivityArray addObject:[NSMutableArray arrayWithObjects:@"Item key",@"Select Item Key",[[self.notifActivityDetailsArray objectAtIndex:indexPath.row] objectForKey:@"notificationa_ItemKey"],@"", nil]];
               
               if (objectPartIDString.length) {
                   
                   [addActivityArray addObject:[NSMutableArray arrayWithObjects:@"Object Part",@"",objectPartNameString,objectPartIDString, nil]];
                   
               }
               else{
                   [addActivityArray addObject:[NSMutableArray arrayWithObjects:@"Object Part",@"",@"",@"", nil]];
               }
               
               if (damageCodeIdString.length) {
                   
                   [addActivityArray addObject:[NSMutableArray arrayWithObjects:@"Damage Code",@"",damageNameString,damageCodeIdString, nil]];

               }
               else
               {
                   [addActivityArray addObject:[NSMutableArray arrayWithObjects:@"Damage Code",@"",@"",@"", nil]];
               }
               
               [addActivityArray addObject:[NSMutableArray arrayWithObjects:@"Code Group",@"",[[self.notifActivityDetailsArray objectAtIndex:indexPath.row] objectForKey:@"notificationa_Actgrptext"],[[self.notifActivityDetailsArray objectAtIndex:indexPath.row] objectForKey:@"notificationa_ActvGrp"], nil]];
               
               [addActivityArray addObject:[NSMutableArray arrayWithObjects:@"Code",@"",[[self.notifActivityDetailsArray objectAtIndex:indexPath.row] objectForKey:@"notificationa_Actcodetext"],[[self.notifActivityDetailsArray objectAtIndex:indexPath.row] objectForKey:@"notificationa_ActvCod"], nil]];
               
               [addActivityArray addObject:[NSMutableArray arrayWithObjects:@"Text",@"",[[self.notifActivityDetailsArray objectAtIndex:indexPath.row] objectForKey:@"notificationa_ActvShtxt"],@"", nil]];
                
                // CREATE TABLE "NOTIFICATIONS_ACTIVITY_COPY" ( `notificationa_id` TEXT, `notificationa_header_id` TEXT, `notificationa_Actcodetext` TEXT, `notificationa_Actgrptext` TEXT, `notificationa_Action` TEXT, `notificationa_ActvCod` TEXT, `notificationa_ActvGrp` TEXT, `notificationa_ActvKey` TEXT, `notificationa_ActvShtxt` TEXT, `notificationa_CauseKey` TEXT, `notificationa_Defectcodetext` TEXT, `notificationa_Defectgrptext` TEXT, `notificationa_ItemKey` TEXT, `notificationa_ItemdefectCod` TEXT, `notificationa_ItemdefectGrp` TEXT, `notificationa_ItemdefectShtxt` TEXT, `notificationa_ItempartCod` TEXT, `notificationa_ItempartGrp` TEXT, `notificationa_Partcodetext` TEXT, `notificationa_Partgrptext` TEXT, `Qmnum` TEXT, `Usr01` TEXT, `Usr02` TEXT, `Usr03` TEXT, `Usr04` TEXT, `Usr05` TEXT )
                
               //
                
                activityKeyString=[[self.notifActivityDetailsArray objectAtIndex:indexPath.row] objectForKey:@"notificationa_ActvKey"];
                
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"yyyyMMdd"];
 
                NSDate *requiredstartDate = [dateFormatter dateFromString:[[self.notifActivityDetailsArray objectAtIndex:indexPath.row] objectForKey:@"Usr01"]];
                
                NSDate *requiredendDate = [dateFormatter dateFromString:[[self.notifActivityDetailsArray objectAtIndex:indexPath.row] objectForKey:@"Usr02"]];
 
                // Convert date object into desired format
                [dateFormatter setDateFormat:@"MMM dd, yyyy"];
 
                NSString *convertedrequiredStartDateString = [dateFormatter stringFromDate:requiredstartDate];
                
                if ([NullChecker isNull:convertedrequiredStartDateString]) {
                    convertedrequiredStartDateString = @"";
                }
                
                NSString *convertedrequiredEndDateString = [dateFormatter stringFromDate:requiredendDate];
                if ([NullChecker isNull:convertedrequiredEndDateString]) {
                    convertedrequiredEndDateString = @"";
                }
                
                [dateFormatter setDateFormat:@"hhmmss"];

                NSDate *startTime = [dateFormatter dateFromString:[[[self.notifActivityDetailsArray objectAtIndex:indexPath.row] objectForKey:@"Usr03"] copy]];
                
                NSDate *endTime = [dateFormatter dateFromString:[[[self.notifActivityDetailsArray objectAtIndex:indexPath.row] objectForKey:@"Usr04"] copy]];
 
                [dateFormatter setDateFormat:@"HH:mm:ss"];
 
                NSString *convertedStartTime = [dateFormatter stringFromDate:startTime];
                
                NSString *convertedEndTime = [dateFormatter stringFromDate:endTime];
                
                
                if ([NullChecker isNull:convertedStartTime]) {
                    convertedStartTime = @"";
                }
                
                if ([NullChecker isNull:convertedEndTime]) {
                    convertedEndTime = @"";
                }
                
                
                updateActivityFlag=YES;
 
               [addActivityArray addObject:[NSMutableArray arrayWithObjects:@"Start Date",@"Start Date",convertedrequiredStartDateString,@"", nil]];
               
               [addActivityArray addObject:[NSMutableArray arrayWithObjects:@"End Date",@"End date",convertedrequiredEndDateString,@"", nil]];
               
               [addActivityArray addObject:[NSMutableArray arrayWithObjects:@"Start Time",@"Start Time",convertedStartTime,@"", nil]];
               
               [addActivityArray addObject:[NSMutableArray arrayWithObjects:@"End Time",@"End Time",convertedEndTime,@"", nil]];
               
               [addCauseTaskView setFrame:CGRectMake(0, 0, commomlistListTableview.frame.size.width, commomlistListTableview.frame.size.height)];
               
               [commonAddTableView reloadData];
 
               submitResetView.hidden=YES;
               
               [commomlistListTableview addSubview:addCauseTaskView];
           }
      }
 
     else if (tableView == self.dropDownTableView) {
        
        switch ([self.dropDownTableView tag]) {
                
            case NOTIFICATIONTYPE:
             
                [[headerDataArray objectAtIndex:0] replaceObjectAtIndex:2 withObject:[[self.dropDownArray objectAtIndex:indexPath.row] objectAtIndex:NAME_INDEX]];
 
                 [[headerDataArray objectAtIndex:0] replaceObjectAtIndex:3 withObject:[[self.dropDownArray objectAtIndex:indexPath.row] objectAtIndex:ID_INDEX]];
  
                [commomlistListTableview endEditing:YES];
                
                [commomlistListTableview reloadData];
 
                 break;
                
            case PRIORITY:

                if (!createNotificationFlag) {
                    
                    [[headerDataArray objectAtIndex:7] replaceObjectAtIndex:2 withObject:[[self.dropDownArray objectAtIndex:indexPath.row] objectAtIndex:NAME_INDEX]];
                    
                    [[headerDataArray objectAtIndex:7] replaceObjectAtIndex:3 withObject:[[self.dropDownArray objectAtIndex:indexPath.row] objectAtIndex:ID_INDEX]];
                }
                else{
                    
                    [[headerDataArray objectAtIndex:5] replaceObjectAtIndex:2 withObject:[[self.dropDownArray objectAtIndex:indexPath.row] objectAtIndex:NAME_INDEX]];
                    
                    [[headerDataArray objectAtIndex:5] replaceObjectAtIndex:3 withObject:[[self.dropDownArray objectAtIndex:indexPath.row] objectAtIndex:ID_INDEX]];
                }
 
                 [commomlistListTableview endEditing:YES];
                
                [commomlistListTableview reloadData];
                

                break;

            case DAMAGE:

                
                [[addCauseCodeDataArray objectAtIndex:2] replaceObjectAtIndex:2 withObject:[[self.dropDownArray objectAtIndex:indexPath.row] objectAtIndex:NAME_INDEX]];
                
                [[addCauseCodeDataArray objectAtIndex:2] replaceObjectAtIndex:3 withObject:[[self.dropDownArray objectAtIndex:indexPath.row] objectAtIndex:ID_INDEX]];
                
                [commonAddTableView endEditing:YES];
                [commonAddTableView reloadData];
                
 
                break;
                
                
            case DAMAGECODE:

//                [damageCodeID setString:[[self.dropDownArray objectAtIndex:indexPath.row] objectAtIndex:ID_INDEX]];
//
//                damageCodeTextField.text = [NSString stringWithFormat:@"%@",[[self.dropDownArray objectAtIndex:indexPath.row] objectAtIndex:NAME_INDEX]];
//
//                if ([damageCodeTextField.text isEqualToString:@""])
//                {
//                    [self causecodesDisabling];
//                }
//                else
//                {
//                    [self causecodesEnabling];
//                }
//
//                [damageCodeTextField resignFirstResponder];
                
                [[addCauseCodeDataArray objectAtIndex:3] replaceObjectAtIndex:2 withObject:[[self.dropDownArray objectAtIndex:indexPath.row] objectAtIndex:NAME_INDEX]];
                
                [[addCauseCodeDataArray objectAtIndex:3] replaceObjectAtIndex:3 withObject:[[self.dropDownArray objectAtIndex:indexPath.row] objectAtIndex:ID_INDEX]];
                
                [commonAddTableView endEditing:YES];
                [commonAddTableView reloadData];
                

                break;

            case CAUSE:

//                [causeID setString:[[self.dropDownArray objectAtIndex:indexPath.row] objectAtIndex:ID_INDEX]];
//
//                causeTextField.text = [NSString stringWithFormat:@"%@",[[self.dropDownArray objectAtIndex:indexPath.row] objectAtIndex:NAME_INDEX]];
//
//                [causeCodeID setString:@""];
//                causeCodeTextField.text = @"";
//
//                [causeTextField resignFirstResponder];
                
                [[addCauseCodeDataArray objectAtIndex:5] replaceObjectAtIndex:2 withObject:[[self.dropDownArray objectAtIndex:indexPath.row] objectAtIndex:NAME_INDEX]];
                
                [[addCauseCodeDataArray objectAtIndex:5] replaceObjectAtIndex:3 withObject:[[self.dropDownArray objectAtIndex:indexPath.row] objectAtIndex:ID_INDEX]];
                
                [commonAddTableView endEditing:YES];
                [commonAddTableView reloadData];

                break;

            case CAUSECODE:

//                [causeCodeID setString:[[self.dropDownArray objectAtIndex:indexPath.row] objectAtIndex:ID_INDEX]];
//
//                causeCodeTextField.text = [NSString stringWithFormat:@"%@",[[self.dropDownArray objectAtIndex:indexPath.row] objectAtIndex:NAME_INDEX]];
//
//                [causeCodeTextField resignFirstResponder];
                
                [[addCauseCodeDataArray objectAtIndex:6] replaceObjectAtIndex:2 withObject:[[self.dropDownArray objectAtIndex:indexPath.row] objectAtIndex:NAME_INDEX]];
                
                [[addCauseCodeDataArray objectAtIndex:6] replaceObjectAtIndex:3 withObject:[[self.dropDownArray objectAtIndex:indexPath.row] objectAtIndex:ID_INDEX]];
                
                [commonAddTableView endEditing:YES];
                [commonAddTableView reloadData];

                break;

            case OBJECTPARTGROUP:

 
                [[addCauseCodeDataArray objectAtIndex:0] replaceObjectAtIndex:2 withObject:[[self.dropDownArray objectAtIndex:indexPath.row] objectAtIndex:NAME_INDEX]];
                
                [[addCauseCodeDataArray objectAtIndex:0] replaceObjectAtIndex:3 withObject:[[self.dropDownArray objectAtIndex:indexPath.row] objectAtIndex:ID_INDEX]];
                
                [commonAddTableView endEditing:YES];
                [commonAddTableView reloadData];

                break;

            case OBJECTPART:

                 [[addCauseCodeDataArray objectAtIndex:1] replaceObjectAtIndex:2 withObject:[[self.dropDownArray objectAtIndex:indexPath.row] objectAtIndex:NAME_INDEX]];
                
                [[addCauseCodeDataArray objectAtIndex:1] replaceObjectAtIndex:3 withObject:[[self.dropDownArray objectAtIndex:indexPath.row] objectAtIndex:ID_INDEX]];
                
                [commonAddTableView endEditing:YES];
                [commonAddTableView reloadData];

                break;


            case EFFECT:
                
                if (!createNotificationFlag) {
                    
                    [[headerDataArray objectAtIndex:16] replaceObjectAtIndex:2 withObject:[[self.dropDownArray objectAtIndex:indexPath.row] objectAtIndex:NAME_INDEX]];
                    
                    [[headerDataArray objectAtIndex:16] replaceObjectAtIndex:3 withObject:[[self.dropDownArray objectAtIndex:indexPath.row] objectAtIndex:ID_INDEX]];
                 }
                else{
                    
                    [[headerDataArray objectAtIndex:14] replaceObjectAtIndex:2 withObject:[[self.dropDownArray objectAtIndex:indexPath.row] objectAtIndex:NAME_INDEX]];
                    
                    [[headerDataArray objectAtIndex:14] replaceObjectAtIndex:3 withObject:[[self.dropDownArray objectAtIndex:indexPath.row] objectAtIndex:ID_INDEX]];
                }
 
                [commomlistListTableview endEditing:YES];
                
                [commomlistListTableview reloadData];
                

                break;

//            case SHIFT:
//
//                shiftTextField.text = [NSString stringWithFormat:@"%@",[[self.dropDownArray objectAtIndex:indexPath.row] objectAtIndex:NAME_INDEX]];
//
//                if (shiftID == nil) {
//
//                    shiftID = [[NSMutableString alloc]initWithString:@""];
//                }
//
//                [shiftID setString:[[self.dropDownArray objectAtIndex:indexPath.row] objectAtIndex:ID_INDEX]];
//
//                [shiftTextField resignFirstResponder];
//
//                break;
                
            case PRIMARY_USER_RESPONSIBLE:
                
                primaryPersonResonsibleNameString=[[self.dropDownArray objectAtIndex:indexPath.row] objectAtIndex:2];
                
                [primaryPersonResonsibleID setString:[[self.dropDownArray objectAtIndex:indexPath.row] objectAtIndex:4]];
                
                if (!createNotificationFlag) {
                    
                      [[headerDataArray objectAtIndex:10] replaceObjectAtIndex:2 withObject:[NSString stringWithFormat:@"%@-%@-%@",[[self.dropDownArray objectAtIndex:indexPath.row] objectAtIndex:2],[[self.dropDownArray objectAtIndex:indexPath.row] objectAtIndex:4],[[self.dropDownArray objectAtIndex:indexPath.row] objectAtIndex:3]]];
                 }
                
                else{
              
                [[headerDataArray objectAtIndex:8] replaceObjectAtIndex:2 withObject:[NSString stringWithFormat:@"%@-%@-%@",[[self.dropDownArray objectAtIndex:indexPath.row] objectAtIndex:2],[[self.dropDownArray objectAtIndex:indexPath.row] objectAtIndex:4],[[self.dropDownArray objectAtIndex:indexPath.row] objectAtIndex:3]]];
                    
                }
                
                [commomlistListTableview endEditing:YES];
                [commomlistListTableview reloadData];
                
                
                break;
//
            case PERSON_RESONSIBLE:
                
                [personResponisbleID setString:[[self.dropDownArray objectAtIndex:indexPath.row] objectAtIndex:2]];
                
                personresponsibleNameString=[[self.dropDownArray objectAtIndex:indexPath.row] objectAtIndex:4];

                if (!createNotificationFlag) {
                    
                [[headerDataArray objectAtIndex:11] replaceObjectAtIndex:2 withObject:[NSString stringWithFormat:@"%@-%@-%@",[[self.dropDownArray objectAtIndex:indexPath.row] objectAtIndex:2],[[self.dropDownArray objectAtIndex:indexPath.row] objectAtIndex:4],[[self.dropDownArray objectAtIndex:indexPath.row] objectAtIndex:3]]];
                    
                }
                
                else{
                    
                   
                       [[headerDataArray objectAtIndex:9] replaceObjectAtIndex:2 withObject:[NSString stringWithFormat:@"%@-%@-%@",[[self.dropDownArray objectAtIndex:indexPath.row] objectAtIndex:2],[[self.dropDownArray objectAtIndex:indexPath.row] objectAtIndex:4],[[self.dropDownArray objectAtIndex:indexPath.row] objectAtIndex:3]]];
                    
                }
 
                [commomlistListTableview endEditing:YES];
                [commomlistListTableview reloadData];
                

                break;

            case PLANNER_GROUP:
 
                if (!createNotificationFlag) {
                    
                    [[headerDataArray objectAtIndex:8] replaceObjectAtIndex:3 withObject:[[self.dropDownArray objectAtIndex:indexPath.row] objectAtIndex:NAME_INDEX]];
                    
                    [[headerDataArray objectAtIndex:8] replaceObjectAtIndex:2 withObject:[[self.dropDownArray objectAtIndex:indexPath.row] objectAtIndex:ID_INDEX]];
                }
                
                else{
                    
                    [[headerDataArray objectAtIndex:6] replaceObjectAtIndex:2 withObject:[[self.dropDownArray objectAtIndex:indexPath.row] objectAtIndex:NAME_INDEX]];
                    
                    [[headerDataArray objectAtIndex:6] replaceObjectAtIndex:3 withObject:[[self.dropDownArray objectAtIndex:indexPath.row] objectAtIndex:ID_INDEX]];
                 }
 
                [commomlistListTableview endEditing:YES];
                 [commomlistListTableview reloadData];
                
                 break;
 
            case ACTIVITY_ITEM_KEY:
                
                [[addActivityArray objectAtIndex:0] replaceObjectAtIndex:2 withObject:[[self.dropDownArray objectAtIndex:indexPath.row] objectAtIndex:ID_INDEX]];
                
               // [[addActivityArray objectAtIndex:0] replaceObjectAtIndex:3 withObject:[[self.dropDownArray objectAtIndex:indexPath.row] objectAtIndex:ID_INDEX]];
                
                [commonAddTableView endEditing:YES];
                
                [commonAddTableView reloadData];
                
                break;
                
            case ACTIVITY_CODEGROUP:
                
                [[addActivityArray objectAtIndex:3] replaceObjectAtIndex:2 withObject:[[self.dropDownArray objectAtIndex:indexPath.row] objectAtIndex:NAME_INDEX]];
                
                 [[addActivityArray objectAtIndex:3] replaceObjectAtIndex:3 withObject:[[self.dropDownArray objectAtIndex:indexPath.row] objectAtIndex:ID_INDEX]];
                
                [commonAddTableView endEditing:YES];
                
                [commonAddTableView reloadData];
                
                break;
                
            case ACTIVITY_CODE:
                
                [[addActivityArray objectAtIndex:4] replaceObjectAtIndex:2 withObject:[[self.dropDownArray objectAtIndex:indexPath.row] objectAtIndex:NAME_INDEX]];
                
                [[addActivityArray objectAtIndex:4] replaceObjectAtIndex:3 withObject:[[self.dropDownArray objectAtIndex:indexPath.row] objectAtIndex:ID_INDEX]];
                
                [commonAddTableView endEditing:YES];
                
                [commonAddTableView reloadData];
                
                break;
                
                
            default:
                break;
        }
    }
    
     else if (tableView==seachDropdownTableView)
     {
         NSString *locationName;
         
         if (seachDropdownTableView.tag==1) {
             
             if (!islevelEnabled) {
                 
                 locationId=[[self.functionLocationHierarchyArray objectAtIndex:indexPath.row] objectForKey:@"locationid"];
                 
                 locationName=[[self.functionLocationHierarchyArray objectAtIndex:indexPath.row] objectForKey:@"locationName"];
             }
             
             else{
                 
                 locationId=[[self.filteredArray objectAtIndex:indexPath.row] objectForKey:@"locationid"];
                 
                 locationName=[[self.filteredArray objectAtIndex:indexPath.row] objectForKey:@"locationName"];
                 
             }
 
           }
         
         else{
             
             if (!islevelEnabled) {
                 
                 locationId=[[self.functionLocationArray objectAtIndex:indexPath.row] objectForKey:@"locationid"];
                 
                 locationName=[[self.functionLocationArray objectAtIndex:indexPath.row] objectForKey:@"locationName"];
              }
             
             else{
                 
                 locationId=[[self.filteredArray objectAtIndex:indexPath.row] objectForKey:@"locationid"];
                 
                 locationName=[[self.filteredArray objectAtIndex:indexPath.row] objectForKey:@"locationName"];

             }
 
         }
 
         if (locationId.length) {
             
             if (!createNotificationFlag) {
 
                 [[headerDataArray objectAtIndex:4] replaceObjectAtIndex:2 withObject:locationName];
                 [[headerDataArray objectAtIndex:4] replaceObjectAtIndex:3 withObject:locationId];
               }
              else{
                 
                 [[headerDataArray objectAtIndex:2] replaceObjectAtIndex:2 withObject:locationName];
                 [[headerDataArray objectAtIndex:2] replaceObjectAtIndex:3 withObject:locationId];
 
             }
              commomlistListTableview.tag=0;
             [commomlistListTableview reloadData];
         }
         
         [searchDropDownView removeFromSuperview];
  
     }
}

-(NSIndexPath *) GetCellFromTableView: (UITableView *)tableView Sender:(id)sender
{
    CGPoint position = [sender convertPoint:CGPointZero toView:tableView];
    NSIndexPath *indexPath = [tableView indexPathForRowAtPoint:position];
    return indexPath;//[tableView cellForRowAtIndexPath:indexPath];
}


-(void)orderNoButtonClicked:(id)sender{
    
    NSMutableArray *orderHeaderDetailsArray=[NSMutableArray new];
    
    [orderHeaderDetailsArray addObjectsFromArray:[[DataBase sharedInstance] fetchOrderDetailsForOrderNo:orderNoBtn.titleLabel.text]];
    
    if (![orderHeaderDetailsArray count]) {
        
        UIAlertView  *failureOrderDetailsAlertView = [[UIAlertView alloc]initWithTitle:@"Information" message:@"No Data Found" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        
        [failureOrderDetailsAlertView show];
        
        [self showAlertMessageWithTitle:@"Information" message:@"No Data Found" cancelButtonTitle:@"Ok" withactionType:@"Single" forMethod:nil];
        
    }
    else
    {
        
        CreateOrderViewController *createVc = [self.storyboard instantiateViewControllerWithIdentifier:@"CreateOrderVC"];
 
        if ([orderHeaderDetailsArray count])
        {
            createVc.detailOrdersArray=[orderHeaderDetailsArray copy];
        }
        
        if (notificationNoString.length)
        {
            [defaults setObject:notificationNoString forKey:@"NotifNo"];
            [defaults synchronize];
        }

        [self showViewController:createVc sender:self];
        
 
//        orderNotifFlag=YES;
//
//        [createOrder setAutomaticallyAdjustsScrollViewInsets:NO];
//        createOrder.view.frame = self.view.frame;
//
//        [createOrder fetchChangeOrderDetailsForOrderNo:orderNoBtn.titleLabel.text];
        
        // [self.view addSubview:createOrder.view];
        
    }
    
}

-(void)checkBoxNRadioButtonSelectionForSystemStatus:(id)sender{
    
    NSIndexPath *ip = [self GetCellFromTableView:notifSystemStatusTableView Sender:sender];
    
    UIButton *tappedButton = (UIButton*)sender;
    
    if (notifSystemStatusTableView.tag == 1) {
        
        if ([[[[[self.notifSystemStatusArray objectAtIndex:1] firstObject] objectAtIndex:ip.row] objectForKey:@"notifications_act"] isEqualToString:@"X"]) {
            
            if (![[[[[self.notifSystemStatusArray objectAtIndex:1] firstObject] objectAtIndex:ip.row] objectForKey:@"notifications_action"] isEqualToString:@"X"]) {
                
                NSMutableDictionary *newDict = [[NSMutableDictionary alloc] init];
                NSDictionary *oldDict = (NSDictionary *)[[[self.notifSystemStatusArray objectAtIndex:1] firstObject] objectAtIndex:ip.row];
                [newDict addEntriesFromDictionary:oldDict];
                
                [newDict setObject:@"" forKey:@"notifications_act"];
                
                [[[self.notifSystemStatusArray objectAtIndex:1] firstObject] replaceObjectAtIndex:ip.row withObject:newDict];
            }
        }
        else
        {
            if (![[[[[self.notifSystemStatusArray objectAtIndex:1] firstObject] objectAtIndex:ip.row] objectForKey:@"notifications_action"] isEqualToString:@"Y"]) {
                
                for (int i =0; i<[[[self.notifSystemStatusArray objectAtIndex:1] firstObject] count]; i++) {
                    NSMutableDictionary *newDict = [[NSMutableDictionary alloc] init];
                    
                    NSDictionary *oldDict = (NSDictionary *)[[[self.notifSystemStatusArray objectAtIndex:1] firstObject] objectAtIndex:i];
                    
                    [newDict addEntriesFromDictionary:oldDict];
                    
                    [newDict setObject:@"" forKey:@"notifications_act"];
                    
                    [[[self.notifSystemStatusArray objectAtIndex:1] firstObject] replaceObjectAtIndex:i withObject:newDict];
                }
                
                NSMutableDictionary *newDict = [[NSMutableDictionary alloc] init];
                
                NSDictionary *oldDict = (NSDictionary *)[[[self.notifSystemStatusArray objectAtIndex:1] firstObject] objectAtIndex:ip.row];
                [newDict addEntriesFromDictionary:oldDict];
                
                [newDict setObject:@"X" forKey:@"notifications_act"];
                
                [[[self.notifSystemStatusArray objectAtIndex:1] firstObject] replaceObjectAtIndex:ip.row withObject:newDict];
            }
        }
        
        [notifSystemStatusTableView reloadData];
    }
    else if (notifSystemStatusTableView.tag == 2) {
        
   
         NSMutableDictionary *newDict = [[NSMutableDictionary alloc] init];
        NSDictionary *oldDict = (NSDictionary *)[[[self.notifSystemStatusArray objectAtIndex:2] firstObject] objectAtIndex:ip.row];
        [newDict addEntriesFromDictionary:oldDict];
        
        if([tappedButton.currentImage isEqual:[UIImage imageNamed:@"radiounselection.png"]]) {
            [sender  setImage:[UIImage imageNamed: @"radioselection.png"] forState:UIControlStateNormal];
            
            [newDict setObject:@"X" forKey:@"notifications_act"];
        }
        else{
            [sender setImage:[UIImage imageNamed:@"radiounselection.png"]forState:UIControlStateNormal];
            
            [newDict setObject:@"" forKey:@"notifications_act"];
        }
        
        [[[self.notifSystemStatusArray objectAtIndex:2] firstObject] replaceObjectAtIndex:ip.row withObject:newDict];
    }
}

-(void)breakDownBtnClicked:(id)sender {
 
    UIButton *tappedButton = (UIButton*)sender;
 
    if ([tappedButton.currentImage isEqual:[UIImage imageNamed:@"checkBoxUnSelection"]])
    {
         [tappedButton setImage:nil forState:UIControlStateNormal];
         [tappedButton setImage:[UIImage imageNamed:@"CheckBoxSelection"] forState:UIControlStateNormal];
        
         [[headerDataArray objectAtIndex:12] replaceObjectAtIndex:2 withObject:@"X"];
 
    }
    else
    {
         [tappedButton setImage:nil forState:UIControlStateSelected];
        [tappedButton setImage:[UIImage imageNamed:@"checkBoxUnSelection"] forState:UIControlStateNormal];
 
        [[headerDataArray objectAtIndex:12] replaceObjectAtIndex:2 withObject:@""];
     }
 
}


-(void)fLocationHDetailButtonClicked:(id)sender
{
    NSIndexPath *ip = [self GetCellFromTableView:seachDropdownTableView Sender:sender];
    NSMutableDictionary *inputParameters = [NSMutableDictionary new];
    selectedDismissFlocIndex=(int)ip.row;
    
     count=count+1;
    
    if (seachDropdownTableView.tag == 1)
    {
        if (!islevelEnabled)
        {
            [inputParameters setObject:[[self.functionLocationHierarchyArray objectAtIndex:ip.row] objectForKey:@"locationid"] forKey:@"functionLocationHID"];
            
            [locationIdArray addObject:[[self.functionLocationHierarchyArray objectAtIndex:ip.row] objectForKey:@"locationid"]];
            
            
            if (self.functionLocationHierarchyArray == nil) {
                self.functionLocationHierarchyArray = [NSMutableArray new];
            }
            else{
                
                [self.functionLocationHierarchyArray removeAllObjects];
            }
            
            [self.functionLocationHierarchyArray addObjectsFromArray:[[DataBase sharedInstance] getFunctionLocations:inputParameters]];
            
            
            funcLocnHeaderLabel.text = [NSString stringWithFormat:@"Function Location (%lu)",(unsigned long)[self.functionLocationHierarchyArray count]];
            
        }
        else{
            
            dropDownSearchBar.text=@"";
            
            [inputParameters setObject:[[self.filteredArray objectAtIndex:ip.row] objectForKey:@"locationid"] forKey:@"functionLocationHID"];
            
            [locationIdArray addObject:[[self.filteredArray objectAtIndex:ip.row] objectForKey:@"locationid"]];
            
            if (self.functionLocationHierarchyArray == nil) {
                self.functionLocationHierarchyArray = [NSMutableArray new];
            }
            else{
                
                [self.functionLocationHierarchyArray removeAllObjects];
            }
            
            islevelEnabled=NO;
            
            [self.functionLocationHierarchyArray addObjectsFromArray:[[DataBase sharedInstance] getFunctionLocations:inputParameters]];
            
            funcLocnHeaderLabel.text = [NSString stringWithFormat:@"Function Location (%lu)",(unsigned long)[self.functionLocationHierarchyArray count]];
        }
        
        [seachDropdownTableView reloadData];
    }
    
    else{
        
        if (!islevelEnabled) {
            
            if (self.functionLocationHierarchyArray == nil) {
                self.functionLocationHierarchyArray = [NSMutableArray new];
            }
            else{
                
                [self.functionLocationHierarchyArray removeAllObjects];
            }
            
            [inputParameters setObject:[[self.functionLocationArray objectAtIndex:ip.row] objectForKey:@"locationid"] forKey:@"functionLocationHID"];
            
            [locationIdArray addObject:[[self.functionLocationArray objectAtIndex:ip.row] objectForKey:@"locationid"]];
            
            [self.functionLocationHierarchyArray addObjectsFromArray:[[DataBase sharedInstance] getFunctionLocations:inputParameters]];
            
            
            funcLocnHeaderLabel.text = [NSString stringWithFormat:@"Function Location (%lu)",(unsigned long)[self.functionLocationHierarchyArray count]];
            
        }
        
        else{
            
            dropDownSearchBar.text=@"";
 
            [inputParameters setObject:[[self.filteredArray objectAtIndex:ip.row] objectForKey:@"locationid"] forKey:@"functionLocationHID"];
            
            [locationIdArray addObject:[[self.filteredArray objectAtIndex:ip.row] objectForKey:@"locationid"]];
            
            if (self.functionLocationHierarchyArray == nil) {
                self.functionLocationHierarchyArray = [NSMutableArray new];
            }
            else{
                
                [self.functionLocationHierarchyArray removeAllObjects];
            }
            
            [self.functionLocationHierarchyArray addObjectsFromArray:[[DataBase sharedInstance] getFunctionLocations:inputParameters]];
            
            islevelEnabled=NO;
            
            funcLocnHeaderLabel.text = [NSString stringWithFormat:@"Function Location (%lu)",(unsigned long)[self.functionLocationHierarchyArray count]];
            
        }
        
        seachDropdownTableView.tag=1;
        
        [seachDropdownTableView reloadData];
        
    }
    
}

-(void)checkBoxClicked:(id)sender{
    
    NSIndexPath *ip = [self GetCellFromTableView:commomlistListTableview Sender:sender];
    NSInteger i = ip.row;
    
    UIButton *tappedButton = (UIButton*)sender;
    
    if([tappedButton.currentImage isEqual:[UIImage imageNamed:@"radiounselection.png"]]) {
        
        [sender  setImage:[UIImage imageNamed: @"radioselection.png"] forState:UIControlStateNormal];
         [self.selectedCheckBoxArray addObject:[NSNumber numberWithInteger:i]];
        
    }
    else{
        
        [self.selectedCheckBoxArray removeObject:[NSNumber numberWithInteger:i]];
        [sender setImage:[UIImage imageNamed:@"radiounselection.png"]forState:UIControlStateNormal];
    }
}

-(void)taskBoxClicked:(id)sender
{
    NSIndexPath *ip = [self GetCellFromTableView:commomlistListTableview Sender:sender];
    NSInteger i = ip.row;
    
    UIButton *tappedButton = (UIButton*)sender;
    
    if([tappedButton.currentImage isEqual:[UIImage imageNamed:@"radiounselection.png"]]) {
        
        [sender  setImage:[UIImage imageNamed: @"radioselection.png"] forState:UIControlStateNormal];
         [self.selectedTaskCheckBoxArray addObject:[NSNumber numberWithInteger:i]];
        
    }
    else{
        
        [self.selectedTaskCheckBoxArray removeObject:[NSNumber numberWithInteger:i]];
         [sender setImage:[UIImage imageNamed:@"radiounselection.png"]forState:UIControlStateNormal];
    }
    
}

-(void)taskInputsDisableMethod{
    
//    taskCodeGroupTextField.userInteractionEnabled = NO;
//    taskCodeTextField.userInteractionEnabled = NO;
//    taskDescTextField.userInteractionEnabled = NO;
//    taskProcessorTextField.userInteractionEnabled = NO;
//    responsibleTextField.userInteractionEnabled = NO;
//    plannedStartDateTextfield.userInteractionEnabled = NO;
//    plannedFinishDateTextfield.userInteractionEnabled = NO;
//
//    releaseStatusBtn.userInteractionEnabled = NO;
//    successStatusBtn.userInteractionEnabled = NO;
//    completeStatusBtn.userInteractionEnabled = NO;
//
//    _addTaskCodeButton.hidden = YES;
//    _updateTaskCodeBtn.hidden = YES;
    
    commonAddTableView.userInteractionEnabled=NO;

}


-(void)taskInputsEnableMethod{
    
//    taskCodeGroupTextField.userInteractionEnabled = YES;
//    taskCodeTextField.userInteractionEnabled = YES;
//    taskDescTextField.userInteractionEnabled = YES;
//    taskProcessorTextField.userInteractionEnabled = YES;
//    responsibleTextField.userInteractionEnabled = YES;
//    plannedStartDateTextfield.userInteractionEnabled = YES;
//    plannedFinishDateTextfield.userInteractionEnabled = YES;
//
//    releaseStatusBtn.userInteractionEnabled = YES;
//    successStatusBtn.userInteractionEnabled = YES;
//    completeStatusBtn.userInteractionEnabled = YES;
//
//    _addTaskCodeButton.hidden = YES;
//    _updateTaskCodeBtn.hidden = NO;
    
    commonAddTableView.userInteractionEnabled=YES;
    
}


-(void)releaseCheckBoxBtn:(id)sender{
    
 
    UIButton *tappedButton = (UIButton*)sender;
 
    if (releaseCheckBoxFlag == NO)
    {
        releaseCheckBoxFlag = YES;
        releaseCheckBoxString = @"X";
        [[addTaskCodeDataArray objectAtIndex:9]  replaceObjectAtIndex:1 withObject:@"X"];
         [tappedButton setImage:nil forState:UIControlStateNormal];
        [tappedButton setImage:[UIImage imageNamed:@"radioselection.png"] forState:UIControlStateNormal];
    }
    else
    {
        releaseCheckBoxString = @" ";
        [tappedButton setImage:nil forState:UIControlStateSelected];
        [[addTaskCodeDataArray objectAtIndex:9]  replaceObjectAtIndex:1 withObject:@""];
         [tappedButton setImage:[UIImage imageNamed:@"radiounselection.png"] forState:UIControlStateNormal];
        releaseCheckBoxFlag = NO;
    }
}

-(void)completeCheckBoxBtn:(id)sender
{
    
     UIButton *tappedButton = (UIButton*)sender;
    
    if (completeCheckBoxFlag == NO)
    {
        completeCheckBoxFlag = YES;
        completeCheckBoxString = @"X";
        [[addTaskCodeDataArray objectAtIndex:9]  replaceObjectAtIndex:2 withObject:@"X"];
         [tappedButton setImage:nil forState:UIControlStateNormal];
        [tappedButton setImage:[UIImage imageNamed:@"radioselection.png"] forState:UIControlStateNormal];
    }
    else
    {
        completeCheckBoxString = @" ";
        [tappedButton setImage:nil forState:UIControlStateSelected];
        [[addTaskCodeDataArray objectAtIndex:9]  replaceObjectAtIndex:2 withObject:@""];
         [tappedButton setImage:[UIImage imageNamed:@"radiounselection.png"] forState:UIControlStateNormal];
        completeCheckBoxFlag = NO;
    }
    
    
}

-(void)successCheckBoxBtn:(id)sender
{
     UIButton *tappedButton = (UIButton*)sender;
     if (succesCheckBoxFlag == NO)
    {
        succesCheckBoxFlag = YES;
        suceessCheckBoxString = @"X";
         [[addTaskCodeDataArray objectAtIndex:9]  replaceObjectAtIndex:3 withObject:@"X"];
         [tappedButton setImage:nil forState:UIControlStateNormal];
        [tappedButton setImage:[UIImage imageNamed:@"radioselection.png"] forState:UIControlStateNormal];
    }
    else
    {
        suceessCheckBoxString = @" ";
        [[addTaskCodeDataArray objectAtIndex:9] replaceObjectAtIndex:3 withObject:@""];
         [tappedButton setImage:nil forState:UIControlStateSelected];
        [tappedButton setImage:[UIImage imageNamed:@"radiounselection.png"] forState:UIControlStateNormal];
        succesCheckBoxFlag = NO;
    }
 }


-(void)attachmentsDownloadButtonClickedinNotifications:(id)sender
{
 
    [self.getDocumentsHeaderDetails removeAllObjects];
     NSIndexPath *ip = [self GetCellFromTableView:commomlistListTableview Sender:sender];
     NSInteger i = ip.row;
     [self.getDocumentsHeaderDetails setObject:decryptedUserName forKey:@"REPORTEDBY"];
    [self.getDocumentsHeaderDetails setObject:notificationNoString forKey:@"OBJECTID"];
    [self.getDocumentsHeaderDetails setObject:[[self.attachmentArray objectAtIndex:i]objectAtIndex:1] forKey:@"DOCID"];
    [self.getDocumentsHeaderDetails setObject:@"Q" forKey:@"ZDOCTYPE"];
    [self.getDocumentsHeaderDetails setObject:[[self.attachmentArray objectAtIndex:i]objectAtIndex:6] forKey:@"OBJECTTYPE"];
    
    if ([[ConnectionManager defaultManager] isReachable])
    {
         [self showAlertMessageWithTitle:@"Decision" message:@"Do you want to download this attachment?" cancelButtonTitle:@"No" withactionType:@"Multiple" forMethod:@"Attachments"];
     }
    else
    {
         [self showAlertMessageWithTitle:@"No Network Available" message:@"Attachment cannot be downloaded!" cancelButtonTitle:@"Ok" withactionType:@"single" forMethod:nil];
    }
}

-(void)duplicateNotificationMethod{
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
     [duplicateNotificationView setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
     [self.view addSubview:duplicateNotificationView];
     transmitTypeString = @"func";
     submitResetView.hidden=YES;
     [duplicateNotificationTableView reloadData];
 }


-(void)dismissequipmentNumberView {
    
     if (res_obj.idString) {
        
        if (!createNotificationFlag) {
            
            [[headerDataArray objectAtIndex:5] replaceObjectAtIndex:2 withObject:res_obj.nameString];
            [[headerDataArray objectAtIndex:5] replaceObjectAtIndex:3 withObject:res_obj.idString];
            
            if (res_obj.workcenterString) {
                
                [[headerDataArray objectAtIndex:6] replaceObjectAtIndex:2 withObject:res_obj.workcenterString];
                
            }
            
            NSArray *plannerGroupDetails=[[DataBase sharedInstance] fetchPlannerGrpForequipIngrp:res_obj.ingrpString];
            
            if ([plannerGroupDetails count]) {
                
                [[headerDataArray objectAtIndex:7] replaceObjectAtIndex:2 withObject:[NSString stringWithFormat:@"%@-%@",[[plannerGroupDetails objectAtIndex:0] objectAtIndex:1],[[plannerGroupDetails objectAtIndex:0] objectAtIndex:2]]];
             }
        }
        
        else{
            
            [[headerDataArray objectAtIndex:3] replaceObjectAtIndex:2 withObject:res_obj.nameString];
            [[headerDataArray objectAtIndex:3] replaceObjectAtIndex:3 withObject:res_obj.idString];
            
            equipmentID=res_obj.idString;
            
            if (res_obj.workcenterString) {
                
                [[headerDataArray objectAtIndex:4] replaceObjectAtIndex:2 withObject:res_obj.workcenterString];
                
            }
            
            NSArray *plannerGroupDetails=[[DataBase sharedInstance] fetchPlannerGrpForequipIngrp:res_obj.ingrpString];
            
            plannerGrouplID=[NSMutableString new];
            
            if ([plannerGroupDetails count]) {
                
                [plannerGrouplID setString:[[plannerGroupDetails objectAtIndex:0] objectAtIndex:1]];
                plannerGroupNameString=[[plannerGroupDetails objectAtIndex:0] objectAtIndex:2];
                
                [[headerDataArray objectAtIndex:6] replaceObjectAtIndex:2 withObject:[NSString stringWithFormat:@"%@-%@",[[plannerGroupDetails objectAtIndex:0] objectAtIndex:1],[[plannerGroupDetails objectAtIndex:0] objectAtIndex:2]]];
            }
            
            if (res_obj.catalogProfileIdstring.length) {
                
                catalogProfileID=[NSMutableString new];
                
                [catalogProfileID setString:[res_obj.catalogProfileIdstring copy]];
                
             }
            
            
            if (res_obj.equipFunLocString.length) {
                

                NSArray *tempArray=[[DataBase sharedInstance] fetchNotificationLocationName:res_obj.equipFunLocString];
                
                [[headerDataArray objectAtIndex:2] replaceObjectAtIndex:3 withObject:res_obj.equipFunLocString];
                
                functionalLocationID=res_obj.equipFunLocString;
                
                if ([tempArray count]) {
                    
                    [[headerDataArray objectAtIndex:2] replaceObjectAtIndex:2 withObject:[[tempArray objectAtIndex:0] objectForKey:@"locationName"]];
                    
                }

            }
            
         }
        
         commomlistListTableview.tag=0;
        [commomlistListTableview reloadData];
    }
 
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)dismissScanView {
    
    [[headerDataArray objectAtIndex:3] replaceObjectAtIndex:3 withObject:[defaults objectForKey:@"scanned"]];
      NSLog(@"scanned");
    [[headerDataArray objectAtIndex:3] replaceObjectAtIndex:2 withObject:[defaults objectForKey:@"scanned"]];
 
    commomlistListTableview.tag=0;
    [commomlistListTableview reloadData];
 
   // [self.navigationController popViewControllerAnimated:YES];
 }

-(void)scanSearchAction:(id)sender{

    ScanBarcodeViewController *scanVc = [self.storyboard instantiateViewControllerWithIdentifier:@"scanVC"];
 
    scanVc.delegate=self;
    
    [self showViewController:scanVc sender:self];
 }

-(void)longTxtAction:(id)sender{
    
    LongtextViewController *longVc = [self.storyboard instantiateViewControllerWithIdentifier:@"longtextVC"];
      longVc.delegate=self;
 
    if (!createNotificationFlag) {
        
        longVc.nonEditableString=[[self .detailNotificationArray objectAtIndex:0] objectForKey:@"notificationh_longtext"];
     }
    else{
        
        if (res_obj.longTextString.length) {
            
            longVc.editableString=res_obj.longTextString;
        }
    }
    
     [self showViewController:longVc sender:self];
    
 }


-(void)functionLocationSearchAction:(id)sender
{
    
    NSIndexPath *ip = [self GetCellFromTableView:commomlistListTableview Sender:sender];
    NSInteger i = ip.row;
    
    if (!createNotificationFlag) {
        
        if (i==4) {
            
            [seachDropdownTableView registerNib:[UINib nibWithNibName:@"FunctionalLocationTableViewCell_iPhone" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"Cell"];
            
            [self fetchFunctionLocations];
            
            [searchDropDownView setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
            [self.view addSubview:searchDropDownView];
        }
        
        else if (i==5){
            
            EquipmentNumberViewController *equipVc = [self.storyboard instantiateViewControllerWithIdentifier:@"EquipIdentifier"];
            
            equipVc.functionLocationString =locationId;
            
            equipVc.searchCondition=@"X";
            
            equipVc.delegate=self;
            
            [self showViewController:equipVc sender:self];
        }
        
        else if (i==6){
            
            
            [self.dropDownArray removeAllObjects];
            
            [self.dropDownArray addObjectsFromArray:[[DataBase sharedInstance] getListOfWorkCenter]];
            
            funcLocnHeaderLabel.text = [NSString stringWithFormat:@"Work Center (%lu)",(unsigned long)[self.dropDownArray count]];
            
            [seachDropdownTableView registerNib:[UINib nibWithNibName:@"WorkcenterTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"WorkcenterCell"];
            
            [searchDropDownView setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
            
            seachDropdownTableView.tag=2;
            
            [seachDropdownTableView reloadData];
            
            [self.view addSubview:searchDropDownView];
            
        }
    }
    
    else{
        
        if (i==2) {
            
            [seachDropdownTableView registerNib:[UINib nibWithNibName:@"FunctionalLocationTableViewCell_iPhone" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"Cell"];
            
            [self fetchFunctionLocations];
            
            [searchDropDownView setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
            [self.view addSubview:searchDropDownView];
        }
        
        else if (i==3){
            
            EquipmentNumberViewController *equipVc = [self.storyboard instantiateViewControllerWithIdentifier:@"EquipIdentifier"];
            
            equipVc.functionLocationString =locationId;
            
            equipVc.searchCondition=@"X";
            
            equipVc.delegate=self;

            
            [self showViewController:equipVc sender:self];
        }
        
        else if (i==4){
            
             [self.dropDownArray removeAllObjects];
            
             [self.dropDownArray addObjectsFromArray:[[DataBase sharedInstance] getListOfWorkCenter]];
 
             [seachDropdownTableView registerNib:[UINib nibWithNibName:@"WorkcenterTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"WorkcenterCell"];
            
             [searchDropDownView setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
            
             funcLocnHeaderLabel.text = [NSString stringWithFormat:@"Work Center (%lu)",(unsigned long)[self.dropDownArray count]];
            
            seachDropdownTableView.tag=2;
            
            [seachDropdownTableView reloadData];
 
            [self.view addSubview:searchDropDownView];
 
        }
    }
}

-(void)fetchFunctionLocations{
    
    if (self.functionLocationArray == nil) {
        self.functionLocationArray = [NSMutableArray new];
        
    }
    else{
        [self.functionLocationArray removeAllObjects];
    }
    
    
    [self.functionLocationArray addObjectsFromArray:[[DataBase sharedInstance] getFuncLoc:@"*"]];
    
    funcLocnHeaderLabel.text = [NSString stringWithFormat:@"Function Location (%lu)",(unsigned long)[self.functionLocationArray count]];
    
    if (![self.functionLocationArray count])
    {
        
      //  [self showAlertMessageWithTitle:@"Inforamtion" message:@"No Functional Location Available" cancelButtonTitle:@"Ok"];
        
    }
    else{
        
        dropDownSearchBar.tag = 1;
        [seachDropdownTableView reloadData];
        islevelEnabled=NO;
        
    }
 }


#pragma mark-
#pragma mark- Search Predicate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (searchBar==dropDownSearchBar) {
        
        if ([searchText isEqualToString:@""]) {
            
            islevelEnabled=NO;
            
            if (dropDownSearchBar.tag==1) {
                
                funcLocnHeaderLabel.text = [NSString stringWithFormat:@"Function Location (%lu)",(unsigned long)[self.functionLocationHierarchyArray count]];
            }
            else{
                
                funcLocnHeaderLabel.text = [NSString stringWithFormat:@"Function Location (%lu)",(unsigned long)[self.functionLocationArray count]];
            }
            
        }
        else{
            
            NSPredicate *bPredicate = [NSPredicate predicateWithFormat:@"locationid contains[c] %@ OR locationName contains[c] %@ OR plantName contains[c] %@ OR workStation contains[c] %@ OR costCenter contains[c] %@ OR plannerGroup contains[c] %@",searchText,searchText,searchText,searchText,searchText,searchText];
            
            if (self.filteredArray == nil) {
                self.filteredArray = [[NSArray alloc]init];
            }
            
            if (seachDropdownTableView.tag==1) {
                
                self.filteredArray = [self.functionLocationHierarchyArray filteredArrayUsingPredicate:bPredicate];
                
            }
            else{
                
                self.filteredArray = [self.functionLocationArray filteredArrayUsingPredicate:bPredicate];
                
            }
            
            funcLocnHeaderLabel.text = [NSString stringWithFormat:@"Function Location (%lu)",(unsigned long)[self.filteredArray count]];
            
            islevelEnabled=YES;
        }
        
        [seachDropdownTableView reloadData];
        
    }
    
    
    //[self.dropDownArray addObjectsFromArray:[[DataBase sharedInstance] getEquipments:searchText]];
}

#pragma mark-
#pragma mark- request Delegate

- (void)resultData:(NSDictionary *)resultData withErrorDescription:(NSString *)errorDescription requestID:(WebServiceRequest)requestID :(int)statusCode
{
    switch (requestID) {
            
            searchListArray = nil;
            searchListArray = [[NSMutableArray alloc]init];
            
            
        case FUNCTIONLOC_COSTCENTER:
            
            if (!errorDescription.length) {
                
                if (statusCode == 401) {
                    
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
 
                    [self showAlertMessageWithTitle:@"Authentication Failed!!" message:@"kindly check your password" cancelButtonTitle:@"ok" withactionType:@"Single" forMethod:nil];
                    
                }
                else{
                    
                    NSMutableDictionary *parsedDictionary = [[Response sharedInstance] parseForFuncLocCostCenter:resultData];
                    if ([parsedDictionary objectForKey:@"result"]) {
                        
                        NSArray *arr_EquipCostCenter = [parsedDictionary objectForKey:@"result"];
                        
                        [searchListArray removeAllObjects];
                        
                        for (int i =0; i< [arr_EquipCostCenter count]; i++) {
                            NSString *str_Arbpl = [[arr_EquipCostCenter objectAtIndex:i] objectForKey:@"Arbpl"];
                            NSString *str_Eqktx = [[arr_EquipCostCenter objectAtIndex:i] objectForKey:@"Eqktx"];
                            NSString *strEqunr = [[arr_EquipCostCenter objectAtIndex:i] objectForKey:@"Equnr"];
                            NSString *str_Iwerk = [[arr_EquipCostCenter objectAtIndex:i] objectForKey:@"Iwerk"];
                            NSString *str_Spras = [[arr_EquipCostCenter objectAtIndex:i] objectForKey:@"Spras"];
                            
                            if ([NullChecker isNull:str_Arbpl]) {
                                str_Arbpl = @"";
                            }
                            
                            if ([NullChecker isNull:str_Eqktx]) {
                                str_Eqktx = @"";
                            }
                            
                            if ([NullChecker isNull:strEqunr]) {
                                strEqunr = @"";
                            }
                            
                            if ([NullChecker isNull:str_Iwerk]) {
                                str_Iwerk = @"";
                            }
                            
                            
                            if ([NullChecker isNull:str_Spras]) {
                                str_Spras = @"";
                            }
                            
                            [searchListArray addObject:[NSMutableArray arrayWithObjects:[str_Arbpl copy],[str_Eqktx copy],[strEqunr copy],[str_Iwerk copy],[str_Spras copy], nil]];
                        }
                    }
                }
            }
            
            break;
            
 
        case GET_DOCUMENTS:
            
            if (!errorDescription.length) {
                NSMutableDictionary *parsedDictionary = [[Response sharedInstance] parseForGetDocuments:resultData];
                if ([parsedDictionary objectForKey:@"URL"])
                {
                    dataaArray=[parsedDictionary objectForKey:@"URL"];
                    [self downloadAttachments];
                }
                else
                {
 
                [self showAlertMessageWithTitle:@"Failure" message:@"Attachment cannot be downloaded" cancelButtonTitle:@"Ok" withactionType:@"Single" forMethod:nil];
                    
                }
            }
            
            break;
            
            
        case NOTIFICATION_CREATE:
            
            if (!errorDescription.length) {
                
                if (statusCode == 401)
                {
                    
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
 
                      [self showAlertMessageWithTitle:@"Authentication Failed!!" message:@"kindly check your password" cancelButtonTitle:@"Ok" withactionType:@"Single" forMethod:nil];
                    
                }
                else{
 
                    NSMutableDictionary *parsedDictionary = [[Response sharedInstance] parseForCreateNotification:resultData];
                    
                    if ([parsedDictionary objectForKey:@"resultDuplicates"]) {
                        
                        id responseObject = [parsedDictionary objectForKey:@"resultDuplicates"];
                        
                        if (notificatinDuplicateArray == nil) {
                            notificatinDuplicateArray = [[NSMutableArray alloc] init];
                        }
                        else{
                            [notificatinDuplicateArray removeAllObjects];
                        }
                        
                        [notificatinDuplicateArray addObjectsFromArray:responseObject];
                        
                      //  [[DataBase sharedInstance] deleteNotificationHeader:[self.notificationHeaderDetails objectForKey:@"ID"]];
                        
                        [self duplicateNotificationMethod];
                        
                        return;
                        
                    }
                    
                    if ([parsedDictionary objectForKey:@"OBJECTID"]) {
                        
                        [[DataBase sharedInstance] deleteNotificationTransactions];
                        [[DataBase sharedInstance] deleteNotificationTasks];
                        
                        if([[DataBase sharedInstance] updateNotificationWithObjectid:[parsedDictionary objectForKey:@"OBJECTID"] forHeaderID:notificationUDID])
                        {
                            [[DataBase sharedInstance] updateSyncLogForCategory:@"Notification" action:@"Create" objectid:[parsedDictionary objectForKey:@"OBJECTID"] UUID:[self.notificationHeaderDetails objectForKey:@"ID"]];
                            
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
                                        }
                                        
                                        [currentHeaderDictionary setObject:@"" forKey:@"LONGTEXT"];
                                        
                                       // [currentHeaderDictionary setObject:[[DataBase sharedInstance] fetchNameForIDKey:@"OBJECTID" forValue:[currentHeaderDictionary objectForKey:@"OBJECTID"]] forKey:@"ID"];
                                        
                                        if (notificationUDID.length) {
 
                                            [currentHeaderDictionary setObject:notificationUDID forKey:@"ID"];
                                         }
                                        
                                        else{
                                            
                                            [currentHeaderDictionary setObject:@"" forKey:@"ID"];

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
                            
                            
                            if ([[[parsedDictionary objectForKey:@"MESSAGE"] substringToIndex:1] isEqualToString:@"S"]) {
                                
                                  [self showAlertMessageWithTitle:@"Success" message:[[parsedDictionary objectForKey:@"MESSAGE"] substringFromIndex:1] cancelButtonTitle:@"Ok" withactionType:@"Single" forMethod:@"Notif Success"];
                                
                            }
                             else{
                                
                                  [self showAlertMessageWithTitle:@"Error" message:[[parsedDictionary objectForKey:@"MESSAGE"] substringFromIndex:1] cancelButtonTitle:@"Ok" withactionType:@"Single" forMethod:@"Notif Success"];
                            }
                          
                            
                         }
                    }
                    else if([[[parsedDictionary objectForKey:@"MESSAGE"] substringToIndex:1] isEqualToString:@"E"])
                    {
                        [[DataBase sharedInstance] updateSyncLogErrorForCategory:@"Notification" action:@"Create" objectid:@"" UUID:[self.notificationHeaderDetails objectForKey:@"ID"] message:[[parsedDictionary objectForKey:@"MESSAGE"] substringFromIndex:1]];
                        
 
                           [self showAlertMessageWithTitle:@"ERROR" message:[[parsedDictionary objectForKey:@"MESSAGE"] substringFromIndex:1] cancelButtonTitle:@"Ok" withactionType:@"Single" forMethod:nil];
                        
                        
                    }
                    else if ([parsedDictionary objectForKey:@"ERROR"])
                    {
                        
                        [[DataBase sharedInstance] updateSyncLogErrorForCategory:@"Notification" action:@"Create" objectid:@"" UUID:[self.notificationHeaderDetails objectForKey:@"ID"] message:[parsedDictionary objectForKey:@"ERROR"]];
                        
                           [self showAlertMessageWithTitle:@"ERROR" message:[NSString stringWithFormat:@"Notification Not Created. Server error"] cancelButtonTitle:@"Ok" withactionType:@"Single" forMethod:nil];
                        
                     }
                    else
                    {
                        //                    [[DataBase sharedInstance] updateSyncLogErrorForCategory:@"Notification" action:@"Create" objectid:@"" UUID:[self.notificationHeaderDetails objectForKey:@"ID"] message:NSLocalizedString(@"ErrorMessage", nil)];
                        
                        [[DataBase sharedInstance] updateSyncLogErrorForCategory:@"Notification" action:@"Create" objectid:@""  UUID:[self.notificationHeaderDetails objectForKey:@"ID"] message:NSLocalizedString(@"ErrorMessage",nil)];
                        
 
                    [self showAlertMessageWithTitle:@"Information" message:NSLocalizedString(@"ErrorMessage", nil) cancelButtonTitle:@"Ok" withactionType:@"Single" forMethod:nil];
                        
                    }
                }
            }
            else
            {
                [[DataBase sharedInstance] updateSyncLogErrorForCategory:@"Notification" action:@"Create" objectid:@"" UUID:[self.notificationHeaderDetails objectForKey:@"ID"] message:NSLocalizedString(@"ErrorMessage", nil)];
                
                  [self showAlertMessageWithTitle:@"Failure" message:errorDescription cancelButtonTitle:@"Ok" withactionType:@"Single" forMethod:nil];
                
 
            }
            
            break;
            
            
        case NOTIFICATION_CHANGE:
            
            if (!errorDescription.length) {
                
                if (statusCode == 401) {
 
                    authenticationFailedAlert = [[UIAlertView alloc] initWithTitle:@"Authentication Failed!!" message:@"kindly check your password" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                    
                    [authenticationFailedAlert show];
                }
                else{
                    
                    NSDictionary *parsedDictionary = [[Response sharedInstance] parseForChangeNotification:resultData];
                    
                    if ([parsedDictionary objectForKey:@"MESSAGE"]) {
                        
                        [[DataBase sharedInstance] deleteNotificationTransactions];
                        [[DataBase sharedInstance] deleteNotificationTasks];
                        
                        NSString *messageCompare;
                        if ([[[parsedDictionary objectForKey:@"MESSAGE"] substringToIndex:1] isEqualToString:@"S"]) {
                            //[[DataBase sharedInstance] updateForChangeNotification:[self.notificationHeaderDetails objectForKey:@"ID"]];
                            
                            [[DataBase sharedInstance] updateSyncLogForCategory:@"Notification" action:@"Change" objectid:[self.notificationHeaderDetails objectForKey:@"OBJECTID"] UUID:[self.notificationHeaderDetails objectForKey:@"ID"]];
                            
                            if ([[defaults objectForKey:@"ACTIVATELOGS"] isEqualToString:@"X"])
                            {
                                [[DataBase sharedInstance] writToLogFile:[NSString stringWithFormat:@"#INFO#.com.enstrapp.fieldtekpro#Notif #Activity:Change Notification #Notifno:%@ #Mode:Online #Class: Very Important #MUser:%@ #DeviceId:%@",[self.notificationHeaderDetails objectForKey:@"OBJECTID"],decryptedUserName,[defaults objectForKey:@"edeviceid"]]];
                                
                            }
                            
                            messageCompare = [[parsedDictionary objectForKey:@"MESSAGE"] substringFromIndex:1];
                            
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
                                                    [resulActivityDictionary setObject:[[activitiesDictionary objectForKey:@"Usr01"] copy] forKey:@"Usr01"];
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
                        }
                        else if ([[[parsedDictionary objectForKey:@"Message"] substringToIndex:1] isEqualToString:@"E"])
                        {
                            //[[DataBase sharedInstance] updateForChangeNotification:[self.notificationHeaderDetails objectForKey:@"ID"]];
                            [[DataBase sharedInstance] updateSyncLogErrorForCategory:@"Notification" action:@"Change" objectid:[self.notificationHeaderDetails objectForKey:@"OBJECTID"] UUID:[self.notificationHeaderDetails objectForKey:@"ID"] message:[parsedDictionary objectForKey:@"MESSAGE"]];
                            
                            messageCompare = [[parsedDictionary objectForKey:@"MESSAGE"] substringFromIndex:1];
                        }
                        else
                        {
                            //[[DataBase sharedInstance] updateForChangeNotification:[self.notificationHeaderDetails objectForKey:@"ID"]];
                            [[DataBase sharedInstance] updateSyncLogErrorForCategory:@"Notification" action:@"Change" objectid:[self.notificationHeaderDetails objectForKey:@"OBJECTID"] UUID:[self.notificationHeaderDetails objectForKey:@"ID"] message:[parsedDictionary objectForKey:@"MESSAGE"]];
                            
                            messageCompare = [parsedDictionary objectForKey:@"MESSAGE"];
                        }
                        
                        if ([[[parsedDictionary objectForKey:@"MESSAGE"] substringToIndex:1] isEqualToString:@"S"]) {
 
                             [self showAlertMessageWithTitle:@"Success" message:messageCompare cancelButtonTitle:@"Ok" withactionType:@"Single" forMethod:@"Notif Success"];
 
                        }
                        else{
 
                            [self showAlertMessageWithTitle:@"FieldTekPro" message:messageCompare cancelButtonTitle:@"Ok" withactionType:@"Single" forMethod:@"Notif Success"];
                          }
                    }
                    else
                    {
                         [[DataBase sharedInstance] updateSyncLogErrorForCategory:@"Notification" action:@"Change" objectid:@"" UUID:[self.notificationHeaderDetails objectForKey:@"ID"] message:@"System Error. Please try again"];
                        
                        [self showAlertMessageWithTitle:@"Failure" message:@"System Error. Please try again." cancelButtonTitle:@"Ok" withactionType:@"Single" forMethod:nil];
                      }
                }
            }
            
            else
            {
                [[DataBase sharedInstance] updateSyncLogErrorForCategory:@"Notification" action:@"Change" objectid:@"" UUID:[self.notificationHeaderDetails objectForKey:@"ID"] message:NSLocalizedString(@"ErrorMessage", nil)];
                
                [self showAlertMessageWithTitle:@"Information" message:NSLocalizedString(@"ErrorMessage", nil) cancelButtonTitle:@"Ok" withactionType:@"Single" forMethod:nil];
              }
            
            break;
 
         default:
         break;
    }
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
}

 

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
   
 
 }


@end
