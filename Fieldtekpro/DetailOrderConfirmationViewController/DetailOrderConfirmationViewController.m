//
//  DetailOrderConfirmationViewController.m
//  Fieldtekpro
//
//  Created by Sathya Rakesh Kumar on 10/05/18.
//  Copyright © 2018 Enstrapp Bangalore. All rights reserved.
//

#import "DetailOrderConfirmationViewController.h"
#import "CreateOrderViewController.h"

@interface DetailOrderConfirmationViewController ()<UITextFieldDelegate,UITextViewDelegate>

@end

@implementation DetailOrderConfirmationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    headerDataArray=[NSMutableArray new];
    finalHeaderDataArray=[NSMutableArray new];

    self.dropDownArray=[NSMutableArray new];

    [self uiPickerTableViewForDropDownSelection];
    
   // NSLog(@"header details are %@",self.headerDetailsArray);
    
    NSString *str_UserNameDep = [[NSUserDefaults standardUserDefaults] objectForKey:@"userName"];
    decryptedUserName = [str_UserNameDep AES128DecryptWithKey:@""];
    
    
    [commonListTableview registerNib:[UINib nibWithNibName:@"ConfirmationTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"InputDropDownCell"];
    
    [finalConfirmTableview registerNib:[UINib nibWithNibName:@"InputDropDownTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"finalnputDropDownCell"];
    
    [finalConfirmTableview registerNib:[UINib nibWithNibName:@"BreakDownTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"breakdownCell"];
    
    [finalConfirmTableview registerNib:[UINib nibWithNibName:@"DurationTableviewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"durationCell"];

    [finalConfirmTableview registerNib:[UINib nibWithNibName:@"FinalConfirmationTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"confirmTextcell"];
 
     [self loadTechnicalConfirmationdata];

     // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
                                        if ([methodNameString isEqualToString:@"Confirm"]) {
                                            
                                            [self confirmOrderAlert];
                                         }
                                        
                                    }];
        
        UIAlertAction* noButton = [UIAlertAction actionWithTitle:cancelBtnTitle
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * action)
                                   {
                                       
                                      
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

- (void)textViewDidBeginEditing:(UITextView *)textView
{
   
    
}
- (void)textViewDidEndEditing:(UITextView *)textView
{
    headerFinalConfirmIndex = (int)textView.superview.tag;
    [[finalHeaderDataArray objectAtIndex:10] replaceObjectAtIndex:2 withObject:textView.text];
}


-(void)confirmOrderAlert
{
 
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDAnimationFade;
    hud.label.text = @"Confirmation in progress...";

    [self actualWorkCalculation];

    [[[self.detailOperationsArray objectAtIndex:0] firstObject] replaceObjectAtIndex:0 withObject:self.udidString];

    [[[self.detailOperationsArray objectAtIndex:0] firstObject] replaceObjectAtIndex:1 withObject:[[[self.detailOperationsArray objectAtIndex:0] firstObject] objectAtIndex:1]];

    [[[self.detailOperationsArray objectAtIndex:0] firstObject] replaceObjectAtIndex:7 withObject:[NSString stringWithString:[[[self.detailOperationsArray objectAtIndex:0] firstObject] objectAtIndex:7]]];//rueck

    [[[self.detailOperationsArray objectAtIndex:0] firstObject] replaceObjectAtIndex:11 withObject:[[finalHeaderDataArray objectAtIndex:10] objectAtIndex:2]];

    [[[self.detailOperationsArray objectAtIndex:0] firstObject] replaceObjectAtIndex:12 withObject:[[finalHeaderDataArray objectAtIndex:4] objectAtIndex:2]];
 
    [[[self.detailOperationsArray objectAtIndex:0] firstObject] replaceObjectAtIndex:13 withObject:[[finalHeaderDataArray objectAtIndex:4] objectAtIndex:2]];

    [[[self.detailOperationsArray objectAtIndex:0] firstObject] replaceObjectAtIndex:10 withObject:@"New"];

    [[[self.detailOperationsArray objectAtIndex:0] firstObject] replaceObjectAtIndex:8 withObject:aueruid];
    
    [[[self.detailOperationsArray objectAtIndex:0] firstObject] replaceObjectAtIndex:24 withObject:@""];//Activity Learr


//    if (activityId.length)
//    {
//        [[[self.operationDetailsArray objectAtIndex:currentOperationItemIndex] firstObject] replaceObjectAtIndex:24 withObject:activityId];//Activity Learr
//    }

//    [[[self.operationDetailsArray objectAtIndex:currentOperationItemIndex] firstObject] replaceObjectAtIndex:23 withObject:reasonId];//ReasonId grund

//    if(accIndicatorID.length){
//        [[[self.operationDetailsArray objectAtIndex:currentOperationItemIndex] firstObject] replaceObjectAtIndex:22 withObject:accIndicatorID]; //bemot
//    }

    
    [[[self.detailOperationsArray objectAtIndex:0] firstObject] replaceObjectAtIndex:23 withObject:@""];//ReasonId grund
    
    [[[self.detailOperationsArray objectAtIndex:0] firstObject] replaceObjectAtIndex:22 withObject:@""]; //bemot
    
    [[[self.detailOperationsArray objectAtIndex:0] firstObject] replaceObjectAtIndex:25 withObject:noremainingWork];//noremainingwork Leknw

    orderHeaderDetails = [[NSMutableDictionary alloc] init];
    [orderHeaderDetails setObject:[self.udidString copy] forKey:@"ID"];
    
    [orderHeaderDetails setObject:[[headerDataArray objectAtIndex:0] objectAtIndex:3] forKey:@"OID"];
    [orderHeaderDetails setObject:[[headerDataArray objectAtIndex:0] objectAtIndex:2] forKey:@"ONAME"];
    [orderHeaderDetails setObject:[[[headerDataArray objectAtIndex:3] objectAtIndex:3] copy] forKey:@"FID"];
    [orderHeaderDetails setObject:[[[headerDataArray objectAtIndex:3] objectAtIndex:2] copy] forKey:@"FNAME"];
    [orderHeaderDetails setObject:[[[headerDataArray objectAtIndex:4] objectAtIndex:3] copy] forKey:@"EQID"];
    [orderHeaderDetails setObject:[[[headerDataArray objectAtIndex:4] objectAtIndex:2] copy] forKey:@"EQNAME"];
    [orderHeaderDetails setObject:[[[headerDataArray objectAtIndex:5] objectAtIndex:3] copy] forKey:@"OPID"];
    [orderHeaderDetails setObject:[[[headerDataArray objectAtIndex:5] objectAtIndex:2] copy] forKey:@"OPNAME"];

    if ([self.statusString isEqualToString:@"Partially Confirmed"]) {
        [orderHeaderDetails setObject:@"PCNF" forKey:@"OSTATUS"];
    }
    else
    {
        [orderHeaderDetails setObject:self.statusString forKey:@"OSTATUS"];
    }

    [orderHeaderDetails setObject:@"Confirm" forKey:@"OSYNCSTATUS"];

//    if ([self.attachmentArray count]) {
//        [self.orderHeaderDetails setObject:@"X" forKey:@"DOCS"];
//    }
//    else{
//        [self.orderHeaderDetails setObject:@"" forKey:@"DOCS"];
//    }
//
    [orderHeaderDetails setObject:@"" forKey:@"DOCS"];
    
 
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMM dd, yyyy"];
    NSDate *startDate = [dateFormatter dateFromString:[[headerDataArray objectAtIndex:0] objectAtIndex:2]];
    NSDate *endDate = [dateFormatter dateFromString:[[headerDataArray objectAtIndex:0] objectAtIndex:2]];
    // Convert date object into desired format
    [dateFormatter setDateFormat:@"yyyyMMdd"];
    NSString *convertedStartDateString = [dateFormatter stringFromDate:startDate];
    if ([NullChecker isNull:convertedStartDateString]) {
        convertedStartDateString = @"";
    }
    NSString *convertedEndDateString = [dateFormatter stringFromDate:endDate];
    if ([NullChecker isNull:convertedEndDateString]) {
        convertedEndDateString = @"";
    }
    
    [orderHeaderDetails setObject:[NSString stringWithFormat:@"%@",convertedStartDateString] forKey:@"SDATE"];
    
    [orderHeaderDetails setObject:[NSString stringWithFormat:@"%@",convertedEndDateString] forKey:@"EDATE"];

    [orderHeaderDetails setObject:[decryptedUserName copy] forKey:@"REPORTEDBY"];
    [orderHeaderDetails setObject:[[headerDataArray objectAtIndex:1] objectAtIndex:2] forKey:@"SHORTTEXT"];
    [orderHeaderDetails setObject:[[[headerDataArray objectAtIndex:0] objectAtIndex:2] copy] forKey:@"LONGTEXT"];

    [orderHeaderDetails setObject:@"" forKey:@"PLANTID"];
    [orderHeaderDetails setObject:@"" forKey:@"PLANTNAME"];
 
//    [orderHeaderDetails setObject:plantWorkCenterID forKey:@"PLANTID"];
//    [orderHeaderDetails setObject:plantIdHeaderTextField.text forKey:@"PLANTNAME"];

    [orderHeaderDetails setObject:[[self.headerDetailsArray objectAtIndex:10] objectAtIndex:2]  forKey:@"WORKCENTERID"];
    [orderHeaderDetails setObject:[[self.headerDetailsArray objectAtIndex:10] objectAtIndex:3] forKey:@"WORKCENTERNAME"];
    [orderHeaderDetails setObject:self.orderNuber forKey:@"OBJECTID"];
    [orderHeaderDetails setObject:@"" forKey:@"ACCINCNAME"];
 
//    if (accIndicatorIDHeader.length) {
//        [self.orderHeaderDetails setObject:accIndicatorIDHeader forKey:@"ACCINCID"];
//    }

    [orderHeaderDetails setObject:@"" forKey:@"workarea"];
    [orderHeaderDetails setObject:@"" forKey:@"costcenter"];
    
 
//    if (headerWorkArea.length) {
//
//        [self.orderHeaderDetails setObject:headerWorkArea forKey:@"workarea"];
//    }
//
//    if (headerCostCenter.length) {
//
//        [self.orderHeaderDetails setObject:headerCostCenter forKey:@"costcenter"];
//    }

    NSDateFormatter *getDate = [[NSDateFormatter alloc] init];
    [getDate setDateFormat:@"yyyyMMdd HH:mm:ss"];
    NSArray *dateTimeArray = [NSArray arrayWithArray:[[getDate stringFromDate:[NSDate date]] componentsSeparatedByString:@" "]];

    [orderHeaderDetails setObject:[dateTimeArray firstObject]  forKey:@"DATE"];

    [orderHeaderDetails setObject:[dateTimeArray lastObject]  forKey:@"TIME"];

    //    [[DataBase sharedInstance] confirmOrderForUUID:orderUDID ObjectcID:orderNoString ReportedBY:decryptedUserName];
    
    NSMutableArray *mutableOperationsArray=[NSMutableArray new];
    
    [mutableOperationsArray addObjectsFromArray:self.detailOperationsArray];

 //   [[DataBase sharedInstance] insertDataIntoOrderHeader:orderHeaderDetails withAttachments:[NSMutableArray array] withPermitWorkApprovalsDetails:[NSMutableArray array] withOperation:mutableOperationsArray withParts:[NSMutableArray array] withWSM:[NSMutableArray array] withObjects:[NSMutableArray array] withSystemStatus:[NSMutableArray array] withPermitsWorkApplications:[NSMutableArray array] withIssuePermits:[NSMutableArray array] withPermitsOperationWCD:[NSMutableArray array] withPermitsOperationWCDTagiingConditions:[NSMutableArray array] withPermitsStandardCheckPoints:[NSMutableArray array] withMeasurementDocs:[NSMutableArray new]];

    if ([[ConnectionManager defaultManager] isConnectionQueueIsActive]) {
        [[ConnectionManager defaultManager] stopCurrentConnetion];
    }

    [orderHeaderDetails setObject:self.detailOperationsArray forKey:@"ITEMS"];

    if([[ConnectionManager defaultManager] isReachable] && [[orderHeaderDetails objectForKey:@"OBJECTID"] length])
    {
        NSMutableDictionary *endPointDictionary = [NSMutableDictionary new];
        [endPointDictionary setObject:@"Z" forKey:@"ACTIVITY"];
        [endPointDictionary setObject:@"W" forKey:@"DOCTYPE"];
        [endPointDictionary setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"ENDPOINT"] forKey:@"ENDPOINT"];
        NSArray *endPointArray = [[DataBase sharedInstance] getEndPointURL:endPointDictionary];
        NSLog(@"endPoint :%@",[[endPointArray objectAtIndex:0] objectAtIndex:0]);
        [orderHeaderDetails setObject:[[endPointArray objectAtIndex:0] objectAtIndex:0] forKey:@"URL_ENDPOINT"];

        [orderHeaderDetails setObject:@"" forKey:@"TRANSMITTYPE"];
        
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"CSRF"];
        [[NSUserDefaults standardUserDefaults] synchronize];

        [Request makeWebServiceRequest:ORDER_CONFIRM parameters:orderHeaderDetails delegate:self];
    }
    else{

        [[DataBase sharedInstance] updateOrderStatus:self.udidString :@"PCNF"];

     }
 }

-(void)actualWorkCalculation
{
    if ([[[finalHeaderDataArray objectAtIndex:4] objectAtIndex:3] length])
    {
        NSArray *components = [[[finalHeaderDataArray objectAtIndex:4] objectAtIndex:3] componentsSeparatedByString:@"/"];
        
        if ([[[finalHeaderDataArray objectAtIndex:4] objectAtIndex:3] isEqualToString:@"MIN"])
        {
            float result = (([[components objectAtIndex:0] intValue]) + [[[finalHeaderDataArray objectAtIndex:4] objectAtIndex:3] floatValue]/60);
            
            finalworkunitString=[NSString stringWithFormat:@"%02f",result];
            
         }
        else  if ([[[finalHeaderDataArray objectAtIndex:4] objectAtIndex:3] isEqualToString:@"HR"])
        {
            float result = (([[components objectAtIndex:0]  intValue]) + [[[finalHeaderDataArray objectAtIndex:4] objectAtIndex:3] floatValue]);
            finalworkunitString=[NSString stringWithFormat:@"%02f",result];
        }
        else  if ([[[finalHeaderDataArray objectAtIndex:4] objectAtIndex:3] isEqualToString:@"DAY"])
        {
            float result = (([[components objectAtIndex:0]  intValue]) + [[[finalHeaderDataArray objectAtIndex:4] objectAtIndex:3] floatValue]*8);
            finalworkunitString=[NSString stringWithFormat:@"%02f",result];
        }
        
        NSArray *arrayTrimming = [finalworkunitString componentsSeparatedByString:@"."];
        
        NSString *trimmedString=[NSString stringWithFormat:@"%@.%@",[arrayTrimming objectAtIndex:0],[[arrayTrimming objectAtIndex:1] substringToIndex:2]];
        
        [[[self.detailOperationsArray objectAtIndex:0] firstObject] replaceObjectAtIndex:21 withObject:[NSString stringWithFormat:@"%@/ HR",trimmedString]];
     }
}

#pragma mark-
#pragma mark- UITextField delegate

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    
      headerCommonIndex = (int)textField.superview.tag;
      headerFinalConfirmIndex = (int)textField.superview.tag;
    
        [self.dropDownArray removeAllObjects];
    
       tag=(int)textField.tag;

          if (headerFinalConfirmIndex==5) {
                
            textField.inputView = self.dropDownTableView;
            self.dropDownTableView.tag = ORDER_REASONS;
            textField.inputAccessoryView = self.mypickerToolbar;
            [self.dropDownArray addObjectsFromArray:[[DataBase sharedInstance] getListOfReasons: @""]];
            [self.dropDownTableView reloadData];
                
           }
           else if (headerFinalConfirmIndex==6){
            
               [self datePickerForMalFuncStartDate];
               textField.inputView=self.startMalFunctionDatePicker;
               textField.inputAccessoryView = self.mypickerToolbar;
            }
        
           else if (headerFinalConfirmIndex==7){
               
               [self datePickerForMalFuncStartDate];
               textField.inputView=self.startMalFunctionDatePicker;
               textField.inputAccessoryView = self.mypickerToolbar;
           }
    
           else if (tag==20){
 
               [[textField valueForKey:@"textInputTraits"] setValue:[UIColor clearColor] forKey:@"insertionPointColor"];

               textField.inputView = self.dropDownTableView;
               textField.inputAccessoryView = self.mypickerToolbar;
               self.dropDownTableView.tag = ORDER_DURATION;

             //  flagUnits = YES;
               [self.dropDownArray addObjectsFromArray:[[DataBase sharedInstance] getUnits:@"D"]];
               [self.dropDownTableView reloadData];
           }
    
      return YES;
 }
 
- (IBAction)backButtonClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)finalBackButtonClicked:(id)sender
{
    [finalConfirmView removeFromSuperview];
}


-(IBAction)startOrderBtn:(id)sender
{
    // startBtn.hidden = NO;
    
    [self startNStopWorkOrderTimerMethod];
    
    [self confirmOperationTimerMethod];
 
}

-(IBAction)finishOrderBtn:(id)sender
{
  //  resetAllInputsBtn.hidden=YES;
    
  //  [[[self.operationDetailsArray objectAtIndex:currentOperationItemIndex] firstObject] replaceObjectAtIndex:8 withObject:@"S"];
    
    confirmOperationStatusLabel.text = @"";
    //    if (startBtn.hidden == NO) {
    [self confirmOperationTimerMethod];
    //    }
    
    NSMutableDictionary *totalDurationForSelectedWorkOrderOperationDictionary = [NSMutableDictionary new];
  //  [totalDurationForSelectedWorkOrderOperationDictionary setObject:[orderUDID copy] forKey:@"ID"];
    
    NSArray *fetchTotalDurationForSelectedWorkOrderOperation;
    
    fetchTotalDurationForSelectedWorkOrderOperation = [[DataBase sharedInstance] fetchTotalDurationWorkOrderTimer:totalDurationForSelectedWorkOrderOperationDictionary];
    
    [finalHeaderDataArray addObject:[NSMutableArray arrayWithObjects:@"Order # :",@"",self.orderNuber,@"", nil]];
    
    [finalHeaderDataArray addObject:[NSMutableArray arrayWithObjects:@"Operation# :",@"",[[[self.detailOperationsArray objectAtIndex:0] firstObject] objectAtIndex:1],@"", nil]];
    
    [finalHeaderDataArray addObject:[NSMutableArray arrayWithObjects:@"Operation Short text :",@"",[[[self.detailOperationsArray objectAtIndex:0] firstObject] objectAtIndex:2],@"", nil]];
    
    [finalHeaderDataArray addObject:[NSMutableArray arrayWithObjects:@"Planned Work/Unit :",@"",[[[self.detailOperationsArray objectAtIndex:0] firstObject] objectAtIndex:21],@"", nil]];
    
 
    int totalPlannedWorkDuration = 0;
    
    for (int i =0; i<[fetchTotalDurationForSelectedWorkOrderOperation count]; i++) {
        NSString *totalDurationString = [[fetchTotalDurationForSelectedWorkOrderOperation objectAtIndex:i] objectAtIndex:0];
        totalPlannedWorkDuration = totalPlannedWorkDuration + [totalDurationString intValue];
    }
    
    if (totalPlannedWorkDuration >0) {
        
        NSArray *plannedWorkUnitType = [[[[self.detailOperationsArray objectAtIndex:0] firstObject] objectAtIndex:21] componentsSeparatedByString:@"/"];
        
        float x = totalPlannedWorkDuration;
        
        if ([[plannedWorkUnitType objectAtIndex:1] isEqualToString:@"MIN"]) {
            
            NSString *actualWorkUnitString=[NSString stringWithFormat:@"%.2f",x/60];
            
          //  actualWorkUnitTextField.text =[actualWorkUnitString substringToIndex:[actualWorkUnitString length]-1];

           // actualWorkUnitIDTextField.text = @"MIN";
            
            [finalHeaderDataArray addObject:[NSMutableArray arrayWithObjects:@"Duration :",@"",[actualWorkUnitString substringToIndex:[actualWorkUnitString length]-1],@"MIN", nil]];

        }
        else if ([[plannedWorkUnitType objectAtIndex:1] isEqualToString:@"HR"]){
            
            NSString *actualWorkUnitString=[NSString stringWithFormat:@"%.2f",x/(60 * 60)];
//            actualWorkUnitTextField.text =[actualWorkUnitString substringToIndex:[actualWorkUnitString length]-1];
          //  actualWorkUnitIDTextField.text = @"HR";
            
            [finalHeaderDataArray addObject:[NSMutableArray arrayWithObjects:@"Duration :",@"",[actualWorkUnitString substringToIndex:[actualWorkUnitString length]-1],@"HR", nil]];

        }
        else if ([[plannedWorkUnitType objectAtIndex:1] isEqualToString:@"DAY"]){
            
            NSString *actualWorkUnitString=[NSString stringWithFormat:@"%.2f",x/(60 * 60 * 24)];
            
//            actualWorkUnitTextField.text =[actualWorkUnitString substringToIndex:[actualWorkUnitString length]-1];
           // actualWorkUnitIDTextField.text = @"DAY";
            
            [finalHeaderDataArray addObject:[NSMutableArray arrayWithObjects:@"Duration :",@"",[actualWorkUnitString substringToIndex:[actualWorkUnitString length]-1],@"DAY", nil]];
         }
    }
    
    [finalHeaderDataArray addObject:[NSMutableArray arrayWithObjects:@"Reason :",@"",@"",@"", nil]];
    
    NSDateFormatter *dateformatter=[[NSDateFormatter alloc]init];
    [dateformatter setDateFormat:@"MMM dd, yyyy "];
 
    [finalHeaderDataArray addObject:[NSMutableArray arrayWithObjects:@"Start Date & Time :",@"",[dateformatter stringFromDate:[NSDate date]],@"", nil]];

    [finalHeaderDataArray addObject:[NSMutableArray arrayWithObjects:@"End Date & Time :",@"",[dateformatter stringFromDate:[NSDate date]],@"", nil]];
 
    [finalHeaderDataArray addObject:[NSMutableArray arrayWithObjects:@"No Remaining Work :",@"",@"",@"", nil]];
    
    [finalHeaderDataArray addObject:[NSMutableArray arrayWithObjects:@"Final Confirmation :",@"",@"",@"", nil]];
    
    [finalHeaderDataArray addObject:[NSMutableArray arrayWithObjects:@"Confirmation Text :",@"",@"",@"", nil]];

    [finalConfirmView setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    
    [self.view addSubview:finalConfirmView];
 
    [finalConfirmTableview reloadData];

    
//    confirmOrderTextField.userInteractionEnabled=NO;
//    confirmOperationTextField.userInteractionEnabled=NO;
//    confirmOperationShortTextField.userInteractionEnabled=NO;
//    confirmPlannedWorkTextField.userInteractionEnabled=NO;
//
//    confirmPlannedWorkTextField.text=plannedWorkTextField.text;
//    confirmOrderTextField.text=operationStatusTextField.text;
//    confirmOperationTextField.text=operationNumberTextField.text;
//    confirmOperationShortTextField.text=operationShortTextFieldString;
    
    aueruid=@"X";
    noremainingWork=@"X";
    
//    confirmationTextview.layer.cornerRadius = 8.0f;
//    confirmationTextview.layer.masksToBounds = YES;
//    confirmationTextview.layer.borderColor = [[UIColor darkGrayColor] CGColor];
//    confirmationTextview.layer.borderWidth = 1.0f;
//
//    confirmOrderStatusLabelinFinish.hidden=NO;
//    confirmOrderStatusCodeinFinish.hidden=NO;
//    confirmOperationStatusCodeinFinish.hidden=NO;
//    operationStatusLabelinFinish.hidden=NO;
    
  //  resetAllInputsBtn.userInteractionEnabled=NO;
}

-(IBAction)confirmSubmitBtn:(id)sender
{
    if(![JEValidator validateTextValue:[[finalHeaderDataArray objectAtIndex:10] objectAtIndex:2]])
    {
 
        [self showAlertMessageWithTitle:@"Warning" message:@"Please enter Confirmation Text!" cancelButtonTitle:@"Ok" withactionType:@"Single" forMethod:nil];
    }
    else
    {
        if (finalFlag ==YES)
        {
          
            [self showAlertMessageWithTitle:@"Decision" message:@"Do you want to submit for Final Confirmation?" cancelButtonTitle:@"NO" withactionType:@"Multiple" forMethod:@"Confirm"];
            
         }
        else
        {
 
             [self showAlertMessageWithTitle:@"Decision" message:@"Do you want to submit for Partial Confirmation?" cancelButtonTitle:@"NO" withactionType:@"Multiple" forMethod:@"Confirm"];

        }
    }
}

-(void)loadTechnicalConfirmationdata
{
 
    finishBtn.hidden=NO;
    startBtn.hidden=NO;
    
    self.activityIndicatorView.hidden=YES;
    
    [headerDataArray addObject:[NSMutableArray arrayWithObjects:@"Order # :",@"",self.orderNuber,@"", nil]];
    
    [headerDataArray addObject:[NSMutableArray arrayWithObjects:@"Operation# :",@"",[[[self.detailOperationsArray objectAtIndex:0] firstObject] objectAtIndex:1],@"", nil]];
    
    [headerDataArray addObject:[NSMutableArray arrayWithObjects:@"Operation text :",@"",[[[self.detailOperationsArray objectAtIndex:0] firstObject] objectAtIndex:2],@"", nil]];
    
    [headerDataArray addObject:[NSMutableArray arrayWithObjects:@"Operation LongText :",@"",[[[self.detailOperationsArray objectAtIndex:0] firstObject] objectAtIndex:20],@"", nil]];
 
    [headerDataArray addObject:[NSMutableArray arrayWithObjects:@"Control Key :",@"",[[[self.detailOperationsArray objectAtIndex:0] firstObject] objectAtIndex:30],@"", nil]];
 
    [headerDataArray addObject:[NSMutableArray arrayWithObjects:@"Plant/WorkCenter :",@"",[NSString stringWithFormat:@"%@/%@",[[[self.detailOperationsArray objectAtIndex:0] firstObject] objectAtIndex:27],[[[self.detailOperationsArray objectAtIndex:0] firstObject] objectAtIndex:29]],@"", nil]];
    
    [headerDataArray addObject:[NSMutableArray arrayWithObjects:@"Activity Type :",@"",[[[self.detailOperationsArray objectAtIndex:0] firstObject] objectAtIndex:14],@"", nil]];
    
    [headerDataArray addObject:[NSMutableArray arrayWithObjects:@"Planned Work/Unit :",@"",[[[self.detailOperationsArray objectAtIndex:0] firstObject] objectAtIndex:21],@"", nil]];
    
    [headerDataArray addObject:[NSMutableArray arrayWithObjects:@"Confirmed Work/Unit :",@"",[[[self.detailOperationsArray objectAtIndex:0] firstObject] objectAtIndex:3],@"", nil]];
 
}



-(void)confirmOperationTimerMethod{
    
    NSMutableDictionary *workOrderConfirmationTimeIntervals = [NSMutableDictionary new];
    
    [workOrderConfirmationTimeIntervals setObject:@"" forKey:@"ACTION"];
    
    if ([confirmOperationStatusLabel.text isEqual:@"Paused"])
    {
        [workOrderConfirmationTimeIntervals setObject:@"P" forKey:@"TYPE"];
    }
    else if ([confirmOperationStatusLabel.text isEqual:@"Started"]){
        [workOrderConfirmationTimeIntervals setObject:@"S" forKey:@"TYPE"];
    }
    else{
        [workOrderConfirmationTimeIntervals setObject:@"S" forKey:@"TYPE"];
        [workOrderConfirmationTimeIntervals setObject:@"New" forKey:@"ACTION"];
    }
    
    
    NSDateFormatter *dateformatter=[[NSDateFormatter alloc]init];
    
    [dateformatter setDateFormat:@"yyyyMMdd HH:mm:ss"];
         NSLog(@"%@",[dateformatter stringFromDate:[NSDate date]]);
    
   // [workOrderConfirmationTimeIntervals setObject:[orderUDID copy] forKey:@"ID"];
    [workOrderConfirmationTimeIntervals setObject:[dateformatter stringFromDate:[NSDate date]] forKey:@"TIME"];
   // [workOrderConfirmationTimeIntervals setObject:[[[self.operationDetailsArray objectAtIndex:currentOperationItemIndex] firstObject] objectAtIndex:1] forKey:@"OPERATIONKEY"];
  //  [workOrderConfirmationTimeIntervals setObject:[[[self.operationDetailsArray objectAtIndex:currentOperationItemIndex] firstObject] objectAtIndex:15] forKey:@"COMPONENTKEY"];
    
    [workOrderConfirmationTimeIntervals setObject:@"" forKey:@"DURATION"];
    
    NSArray *tempLastRecordTimeArray = [[DataBase sharedInstance] fetchLastRecordConfirmWorkOrderTimer:workOrderConfirmationTimeIntervals];
    
    if ([tempLastRecordTimeArray count]) {
        
        [dateformatter setDateFormat:@"yyyyMMdd HH:mm:ss"];
        
        NSDate *previousTime;
        
        previousTime = [dateformatter dateFromString:[[tempLastRecordTimeArray objectAtIndex:0] objectAtIndex:0]];
        
        NSDate *currentTime;
        
        currentTime = [dateformatter dateFromString:[workOrderConfirmationTimeIntervals objectForKey:@"TIME"]];
        
        NSInteger comparisionResult = [AppDelegate secondsBetweenDate:previousTime andDate:currentTime];
        
        NSString *differenceString = [NSString stringWithFormat:@"%i",(int)comparisionResult];
        
        [workOrderConfirmationTimeIntervals setObject:differenceString forKey:@"DURATION"];
    }
    
    [[DataBase sharedInstance] insertConfirmOrderWorkTimer:workOrderConfirmationTimeIntervals];
    
     [pcnfResetTimerArray addObject:[workOrderConfirmationTimeIntervals objectForKey:@"DURATION"]];
    
    
}

-(void)startNStopWorkOrderTimerMethod{
    
    if (startFlag == NO)
    {
        startFlag = YES;
        self.activityIndicatorView.hidden=NO;
        
       // confirmOperationStatusLabel.text=@"Started";
        [[[self.detailOperationsArray objectAtIndex:0] firstObject] replaceObjectAtIndex:8 withObject:@"S"];
       // confirmOperationStatusCode.backgroundColor=[UIColor yellowColor];
         [self.activityIndicatorView startAnimating];
         [startBtn setImage:[UIImage imageNamed:@"Pause-icon"] forState:UIControlStateNormal];
          finishBtn.hidden=NO;
         [startBtn setTitle:@"Pause" forState:UIControlStateNormal];
    }
    else
    {
        [startBtn setTitle:@"Start" forState:UIControlStateNormal];
       // confirmOperationStatusLabel.text=@"Paused";
        [[[self.detailOperationsArray objectAtIndex:0] firstObject] replaceObjectAtIndex:8 withObject:@"P"];
     //   confirmOperationStatusCode.backgroundColor=[UIColor purpleColor];
       // [startBtn setImage:[UIImage imageNamed:@"Start-icon"] forState:UIControlStateNormal];
          [startBtn setTitle:@"Paused" forState:UIControlStateNormal];
 //         finishBtn.hidden=YES;
         [self.activityIndicatorView stopAnimating];
 
        startFlag = NO;
    }
     [commonListTableview reloadData];
    
    
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
    
    [finalConfirmTableview endEditing:YES];
    
}


#pragma mark-
#pragma mark-Date Picker for Text Field

//for Datepicker.
-(void)datePickerForMalFuncStartDate{
    
    
    self.startMalFunctionDatePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, 250, 0, 0)];
    
    self.startMalFunctionDatePicker.datePickerMode = UIDatePickerModeDateAndTime;
    
 
    self.mypickerToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 100, 320, 56)];
    
    self.mypickerToolbar.barStyle = UIBarStyleBlackOpaque;
    
    [self.mypickerToolbar sizeToFit];
    
    NSMutableArray *barItems = [[NSMutableArray alloc] init];
    
    UIBarButtonItem *cnclBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(pickerCancelClicked)];
    
    [barItems addObject:cnclBtn];
    
    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    [barItems addObject:flexSpace];
    
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(pickerDoneStartDateClicked)];
    
    [barItems addObject:doneBtn];
    
    [self.mypickerToolbar setItems:barItems animated:YES];
 
}

-(void)pickerCancelClicked
{
    
}

-(void)pickerDoneStartDateClicked
{
     self.minStartDate =[self.startMalFunctionDatePicker date];
 
            if (headerFinalConfirmIndex == 6) {
                
                NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
                [dateFormat setDateFormat:@"MMM dd, yyyy hh:mm a"];
                
                [[finalHeaderDataArray objectAtIndex:6] replaceObjectAtIndex:2 withObject:[dateFormat stringFromDate:self.minStartDate]];
    
                if (![[[finalHeaderDataArray objectAtIndex:7] objectAtIndex:2] isEqual:@""]) {
                   // requireddateFlag = YES;
                    
                    self.minEndDate = [dateFormat dateFromString:[[finalHeaderDataArray objectAtIndex:7] objectAtIndex:2]];
                    
                    NSInteger comparisionResult = [AppDelegate daysBetweenDate:self.minStartDate andDate:self.minEndDate];
                    
                    NSLog(@"%i",(int)comparisionResult);
                    NSString *comparisionString = [NSString stringWithFormat:@"%i",(int)comparisionResult];
                    if ([[comparisionString substringToIndex:1] isEqualToString:@"-"])
                    {
                        
                        [[finalHeaderDataArray objectAtIndex:6] replaceObjectAtIndex:2 withObject:[dateFormat stringFromDate:self.minStartDate]];
                        
                        [self showAlertMessageWithTitle:@"Alert" message:@"Required Start Date has to be earlier than Required End Date" cancelButtonTitle:@"ok" withactionType:@"Single" forMethod:nil];
                        
                    }
                }
            }
            
            else if (headerFinalConfirmIndex==7){
                
                self.minEndDate =[self.startMalFunctionDatePicker date];
                
                NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
                [dateFormat setDateFormat:@"MMM dd, yyyy hh:mm a"];
                
                [[finalHeaderDataArray objectAtIndex:7] replaceObjectAtIndex:2 withObject:[dateFormat stringFromDate:self.minEndDate]];
                
                if (![[[finalHeaderDataArray objectAtIndex:6] objectAtIndex:2] isEqual:@""]) {
                    
                   // requireddateFlag = NO;
                    self.minStartDate = [dateFormat dateFromString:[[finalHeaderDataArray objectAtIndex:6] objectAtIndex:2]];
                    
                    NSInteger comparisionResult = [AppDelegate daysBetweenDate:self.minStartDate andDate:self.minEndDate];
                    NSLog(@"%i",(int)comparisionResult);
                    NSString *comparisionString = [NSString stringWithFormat:@"%i",(int)comparisionResult];
                    if ([[comparisionString substringToIndex:1] isEqualToString:@"-"])
                    {
                        [[finalHeaderDataArray objectAtIndex:7] replaceObjectAtIndex:2 withObject:@""];
                        
                        [self showAlertMessageWithTitle:@"Alert" message:@"Required End Date has to be later than Required Start Date" cancelButtonTitle:@"Ok" withactionType:@"Single" forMethod:nil];
                        
                    }
                }
            }
            
 
        [finalConfirmTableview reloadData];
        [finalConfirmTableview endEditing:YES];
    
}
    

#pragma mark
#pragma mark - TableView Delegate Methods
//table view methods strats here

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;              // Default is 1 if not implemented
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (tableView==commonListTableview) {
         return [headerDataArray count];
     }
    else if (tableView==finalConfirmTableview){
        
        return [finalHeaderDataArray count];
     }
    
    else if (tableView==self.dropDownTableView){
        
        return [self.dropDownArray count];
        
    }
    
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
     if (tableView==commonListTableview) {
        
        static NSString *CellIdentifier = @"InputDropDownCell";
        
        ConfirmationTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell==nil) {
            cell=[[ConfirmationTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
 
        CALayer *orderStatusLayerinFinish = [cell.statusImageview layer];
        [orderStatusLayerinFinish setMasksToBounds:YES];
        [orderStatusLayerinFinish setCornerRadius:8.0];
        
        cell.InputTextField.superview.tag = indexPath.row;
        cell.InputTextField.delegate = self;
 
          NSString  *aueruid=[[[self.detailOperationsArray objectAtIndex:0] firstObject] objectAtIndex:8];
            
            if (indexPath.row==1) {
                
                if ([aueruid isEqualToString:@"X"])
                {
                   cell.statusImageview.backgroundColor=[UIColor greenColor];
                    
                    startBtn.hidden=YES;
                    finishBtn.hidden=YES;
                    
                }
                else if ([aueruid isEqualToString:@"Y"])
                {
                    cell.statusImageview.backgroundColor=[UIColor orangeColor];
                    
                    startBtn.hidden=NO;
                    finishBtn.hidden=NO;
                    //              [[DataBase sharedInstance] deleteConfirmWorkOrderTimerForPCNF:orderObject.orderUUID];
                    
                }
                else if ([aueruid isEqualToString:@"Z"])
                {
                    cell.statusImageview.backgroundColor=UIColorFromRGB(0, 100, 0);
                    
                    startBtn.hidden=YES;
                    finishBtn.hidden=YES;
                    
                }
                else if ([aueruid isEqualToString:@"S"])
                {
                    cell.statusImageview.backgroundColor=[UIColor yellowColor];
                    startBtn.hidden=NO;
                    finishBtn.hidden=NO;
                    self.activityIndicatorView.hidden=NO;
                    [self.activityIndicatorView startAnimating];
                  //  [startBtn setImage:[UIImage imageNamed:@"Pause-icon"] forState:UIControlStateNormal];
                    startFlag = YES;
                    
                }
                else if ([aueruid isEqualToString:@"P"])
                {
                    cell.statusImageview.backgroundColor=[UIColor purpleColor];
                    
                 //   [startBtn setImage:[UIImage imageNamed:@"Start-icon"] forState:UIControlStateNormal];
                    startBtn.hidden=NO;
                    finishBtn.hidden=YES;
                    
                    self.activityIndicatorView.hidden=NO;
                    [self.activityIndicatorView stopAnimating];
                    
                    startFlag = NO;
                 }
                else
                {
                    cell.statusImageview.backgroundColor=UIColorFromRGB(39, 171, 226);
                    startBtn.hidden=NO;
                }
                
                if (![self.statusString isEqualToString:@"REL"]) {
                    
                    finishBtn.hidden=YES;
                    startBtn.hidden=YES;
                }
             }
        
        if (indexPath.row==0) {
            
            if ([self.statusString isEqualToString:@"Changed"])
            {
                cell.statusImageview.backgroundColor = [UIColor darkGrayColor];
                
             }
            else if ([confirmOrderStatusLabel.text isEqualToString:@"New"])
            {
                cell.statusImageview.backgroundColor = [UIColor yellowColor];
             }
            else if ([confirmOrderStatusLabel.text isEqualToString:@"Assigned"])
            {
                cell.statusImageview.backgroundColor = UIColorFromRGB(39, 171, 226);
                // [[DataBase sharedInstance] deleteConfirmWorkOrderTimerForPCNF:orderObject.orderUUID];
            }
            else if ([confirmOrderStatusLabel.text isEqualToString:@"Cancelled"]) {
                cell.statusImageview.backgroundColor = [UIColor redColor];
                 startBtn.hidden=YES;
            }
            else if ([confirmOrderStatusLabel.text isEqualToString:@"PCNF"]) {
                
                cell.statusImageview.backgroundColor = [UIColor orangeColor];
                
             }
            else if ([confirmOrderStatusLabel.text isEqualToString:@"CNF"]) {
                 cell.statusImageview.backgroundColor = [UIColor greenColor];
             }
            else if ([confirmOrderStatusLabel.text isEqualToString:@"ITRS"]) {
                
                startBtn.hidden=YES;
                 cell.statusImageview.backgroundColor = UIColorFromRGB(0, 100, 0);
             }
         }
        
            cell.dropDownImageView.hidden=YES;
            cell.madatoryLabel.hidden=YES;
            
            cell.confirmContentView.layer.cornerRadius = 2.0f;
            cell.confirmContentView.layer.masksToBounds = YES;
            cell.confirmContentView.layer.borderColor = [[UIColor darkGrayColor] CGColor];
            cell.confirmContentView.layer.borderWidth = 1.0f;
            
            cell.titleLabel.text=[[headerDataArray objectAtIndex:indexPath.row] objectAtIndex:0];
            cell.InputTextField.placeholder=[[headerDataArray objectAtIndex:indexPath.row] objectAtIndex:1];
            cell.InputTextField.text=[[headerDataArray objectAtIndex:indexPath.row] objectAtIndex:2];
 
        return cell;

    }
   
    else if (tableView==finalConfirmTableview){
        
        if (indexPath.row==8||indexPath.row==9) {
            
            static NSString *CellIdentifier = @"breakdownCell";
            
            BreakDownTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if (cell==nil) {
                cell=[[BreakDownTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            
            [cell.breakDownBtn addTarget:self action:@selector(breakDownBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
 
            cell.breakdownContentView.layer.cornerRadius = 2.0f;
            cell.breakdownContentView.layer.masksToBounds = YES;
            cell.breakdownContentView.layer.borderColor = [[UIColor darkGrayColor] CGColor];
            cell.breakdownContentView.layer.borderWidth = 1.0f;
            
            cell.titleLabel.text=[[finalHeaderDataArray objectAtIndex:indexPath.row] objectAtIndex:0];

            if ([[[finalHeaderDataArray objectAtIndex:indexPath.row] objectAtIndex:2] isEqualToString:@"X"]) {

                [cell.breakDownBtn setImage:[UIImage imageNamed:@"CheckBoxSelection"] forState:UIControlStateNormal];
            }

            else{

                [cell.breakDownBtn setImage:[UIImage imageNamed:@"checkBoxUnSelection"] forState:UIControlStateNormal];
             }
            
            return cell;
        }
        
        else if (indexPath.row==10){
            
            static NSString *CellIdentifier = @"confirmTextcell";
            
            FinalConfirmationTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if (cell==nil) {
                cell=[[FinalConfirmationTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
 
            cell.confirmTextview.superview.tag = indexPath.row;
            cell.confirmTextview.delegate = self;
            
            cell.confirmTextview.layer.cornerRadius = 2.0f;
            cell.confirmTextview.layer.masksToBounds = YES;
            cell.confirmTextview.layer.borderColor = [[UIColor darkGrayColor] CGColor];
            cell.confirmTextview.layer.borderWidth = 1.0f;
            
            cell.titleLabel.text=[[finalHeaderDataArray objectAtIndex:indexPath.row] objectAtIndex:0];
            cell.confirmTextview.text=[[finalHeaderDataArray objectAtIndex:indexPath.row] objectAtIndex:3];

            return cell;
        }
        
        else if (indexPath.row==4){
            
            static NSString *CellIdentifier = @"durationCell";
            
            DurationTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if (cell==nil) {
                cell=[[DurationTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            
         //   cell.durationInputTextfield.superview.tag = indexPath.row;
            cell.durationInputTextfield.delegate = self;
            
            [cell.durationInputTextfield setTag:10];
            [cell.durationtextfield setTag:20];

            cell.durationContentView.layer.cornerRadius = 2.0f;
            cell.durationContentView.layer.masksToBounds = YES;
            cell.durationContentView.layer.borderColor = [[UIColor darkGrayColor] CGColor];
            cell.durationContentView.layer.borderWidth = 1.0f;
            
            
            cell.durationtextfield.superview.tag = indexPath.row;
            cell.durationtextfield.delegate = self;
 
            cell.titleLabel.text=[[finalHeaderDataArray objectAtIndex:indexPath.row] objectAtIndex:0];
            
             cell.durationInputTextfield.text=[[finalHeaderDataArray objectAtIndex:indexPath.row] objectAtIndex:2];
            
            cell.durationtextfield.text=[[finalHeaderDataArray objectAtIndex:indexPath.row] objectAtIndex:3];

            return cell;
        }
        
        else{
            
            static NSString *CellIdentifier = @"finalnputDropDownCell";
            
            InputDropDownTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if (cell==nil) {
                cell=[[InputDropDownTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            cell.InputTextField.superview.tag = indexPath.row;
            cell.InputTextField.delegate = self;
            
            cell.longTextBtn.hidden=YES;
            cell.dropDownImageView.hidden=YES;
            cell.madatoryLabel.hidden=YES;
            
            if (indexPath.row==5||indexPath.row==6||indexPath.row==7) {
                
                cell.dropDownImageView.hidden=NO;
                
                if (indexPath.row==6||indexPath.row==7) {
                    
                    [cell.dropDownImageView setImage:[UIImage imageNamed:@"calendar"]];
 
                }
                else if (indexPath.row==5){
 
                    [cell.dropDownImageView setImage:[UIImage imageNamed:@"dropdown"]];
 
                }
              }
            
            cell.notifView.layer.cornerRadius = 2.0f;
            cell.notifView.layer.masksToBounds = YES;
            cell.notifView.layer.borderColor = [[UIColor darkGrayColor] CGColor];
            cell.notifView.layer.borderWidth = 1.0f;
            
            cell.titleLabel.text=[[finalHeaderDataArray objectAtIndex:indexPath.row] objectAtIndex:0];
            cell.InputTextField.placeholder=[[finalHeaderDataArray objectAtIndex:indexPath.row] objectAtIndex:1];
            cell.InputTextField.text=[[finalHeaderDataArray objectAtIndex:indexPath.row] objectAtIndex:2];
            return cell;

         }
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
 
    return nil;
 }

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
     if (tableView == self.dropDownTableView) {
        
        switch ([self.dropDownTableView tag]) {
                
            case ORDER_DURATION:
                
                //[[finalHeaderDataArray objectAtIndex:4] replaceObjectAtIndex:2 withObject:[[self.dropDownArray objectAtIndex:indexPath.row] objectAtIndex:NAME_INDEX]];
                
                [[finalHeaderDataArray objectAtIndex:4] replaceObjectAtIndex:3 withObject:[[self.dropDownArray objectAtIndex:indexPath.row] objectAtIndex:ID_INDEX]];
                
                [finalConfirmTableview endEditing:YES];
                
                [finalConfirmTableview reloadData];
                
                break;
        }
    }
    
}

-(NSIndexPath *) GetCellFromTableView: (UITableView *)tableView Sender:(id)sender
{
    CGPoint position = [sender convertPoint:CGPointZero toView:tableView];
    NSIndexPath *indexPath = [tableView indexPathForRowAtPoint:position];
    return indexPath;//[tableView cellForRowAtIndexPath:indexPath];
}


-(void)breakDownBtnClicked:(id)sender
{
    NSIndexPath *ip = [self GetCellFromTableView:finalConfirmTableview Sender:sender];
    
    UIButton *tappedButton = (UIButton*)sender;
    
     if (ip.row==8) {
        
        if([tappedButton.currentImage isEqual:[UIImage imageNamed:@"checkBoxUnSelection"]])
        {
            
            [tappedButton setImage:[UIImage imageNamed:@"CheckBoxSelection"] forState:UIControlStateNormal];
            
            [[finalHeaderDataArray objectAtIndex:8] replaceObjectAtIndex:2 withObject:@"X"];
            
        }
        else{
            
            [tappedButton setImage:[UIImage imageNamed:@"checkBoxUnSelection"] forState:UIControlStateNormal];
            
            [[finalHeaderDataArray objectAtIndex:8] replaceObjectAtIndex:2 withObject:@""];
            
        }
    }
    
     else if (ip.row==9){
         
         if([tappedButton.currentImage isEqual:[UIImage imageNamed:@"checkBoxUnSelection"]])
         {
             
             [tappedButton setImage:[UIImage imageNamed:@"CheckBoxSelection"] forState:UIControlStateNormal];
             
             [[finalHeaderDataArray objectAtIndex:9] replaceObjectAtIndex:2 withObject:@"X"];
             
         }
         else{
             
             [tappedButton setImage:[UIImage imageNamed:@"checkBoxUnSelection"] forState:UIControlStateNormal];
             
             [[finalHeaderDataArray objectAtIndex:9] replaceObjectAtIndex:2 withObject:@""];
             
         }
     }
 
     [finalConfirmTableview reloadData];
}

#pragma mark- result data

-(void)resultData:(NSDictionary *)resultData withErrorDescription:(NSString *)errorDescription requestID:(WebServiceRequest)requestID :(int)statusCode
{
    switch (requestID) {
            
 
        case ORDER_CONFIRM:
            
            if (statusCode == 401) {
                
                [MBProgressHUD hideHUDForView:self.view animated:YES];

                 [self showAlertMessageWithTitle:@"Authentication Failed!!" message:@"kindly check your password" cancelButtonTitle:@"Ok" withactionType:@"Single" forMethod:nil];
                
                return;
            }
            
            if (!errorDescription.length) {
                
                NSMutableDictionary *parsedDictionary = [[Response sharedInstance] parseForConfirmOrder:resultData];
                
                if ([parsedDictionary objectForKey:@"Message"]) {
                    NSMutableString *messageString = [NSMutableString stringWithString:@""];
                    NSArray *messageArray = [parsedDictionary objectForKey:@"Message"];
                    for (int i =0; i<[messageArray count]; i++) {
                        
                        if ([[[[messageArray objectAtIndex:i] substringToIndex:1] uppercaseString] isEqualToString:@"S"]) {
                            [messageString appendString:[NSString stringWithFormat:@"%@\n", [[messageArray objectAtIndex:i]substringFromIndex:1]]];
                            
                            [[DataBase sharedInstance] deleteConfirmWorkOrderTimer:[orderHeaderDetails objectForKey:@"ID"]];
                            
                            [[DataBase sharedInstance] updateSyncLogForCategory:@"Order" action:@"Confirm" objectid:[parsedDictionary objectForKey:@"OBJECTID"] UUID:self.udidString];
                            
                            //                             [[DataBase sharedInstance] updateSyncLogErrorForCategory:@"Order" action:@"Confirm" objectid:[self.orderHeaderDetails objectForKey:@"OBJECTID"] UUID:[self.orderHeaderDetails objectForKey:@"ID"] message:[messageString substringFromIndex:1]  Date:[self.orderHeaderDetails objectForKey:@"DATE"] timestamp:[self.orderHeaderDetails objectForKey:@"TIME"]];
 
                            if ([parsedDictionary objectForKey:@"resultHeader"]) {
                                id parsedResult = [parsedDictionary objectForKey:@"resultHeader"];
                                if ([[[parsedResult objectAtIndex:0] objectForKey:@"Xstatus"] isEqualToString:@"CNF"]) {
                                    
                                    [[DataBase sharedInstance] deleteRecordinOrderForUUID:[orderHeaderDetails objectForKey:@"ID"] ObjectcID:self.orderNuber ReportedBY:decryptedUserName];
                                    
                                }
                                else{
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
                                                    NSArray *fieldsArray = [[headerDictionary objectForKey:@"Fields"] objectForKey:@"item"];
                                                    for (int i =0; i<[fieldsArray count]; i++) {
                                                        NSString *fieldValue,*fieldName,*fLabel,*tabName,*dataType,*sequence,*length;
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
                                        
                                        responseObject = [parsedDictionary objectForKey:@"resultStandardCheckPoints"];
                                        
                                        for (int i = 0; i<[responseObject count]; i++) {
                                            
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
                                                
                                                id customFieldsOperationsTransactionsID;
                                                if ([tempDictionary objectForKey:@"Fields"]) {
                                                    NSArray *fieldsArray = [[tempDictionary objectForKey:@"Fields"] objectForKey:@"item"];
                                                    NSMutableArray *transactionsOperationsCustomFields = [NSMutableArray new];
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
                                                        
                                                        if ([docTypeItem isEqualToString:@"WO"]) {
                                                            [transactionsOperationsCustomFields addObject:[NSMutableArray arrayWithObjects:docType,docTypeItem,tabName,fieldName,fieldValue,fLabel,dataType,sequence,length, nil]];
                                                        }
                                                    }
                                                    
                                                    customFieldsOperationsTransactionsID = transactionsOperationsCustomFields;
                                                }
                                                
                                                [orderTransactionListArray addObject:[NSArray arrayWithObjects:orderDetailTransactionListArray,customFieldsOperationsTransactionsID, nil]];
                                                
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
                                                        
                                                        id customFieldsComponentsTransactionsID;
                                                        NSMutableArray *transactionsComponentsCustomFields = [NSMutableArray new];
                                                        
                                                        if ([tempCompenetsDictionary objectForKey:@"Fields"]) {
                                                            NSArray *fieldsArray = [[tempCompenetsDictionary objectForKey:@"Fields"] objectForKey:@"item"];
                                                            
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
                                            NSMutableArray *orderDocsListArray = [NSMutableArray new];
                                            
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
                                                
                                                
                                                [orderDocsListArray addObject:orderDetailMDocsListArray];
                                            }
                                            
                                            [[orderDetailDictionary objectForKey:[orderMeasurementDocumentsArray objectAtIndex:i]] replaceObjectAtIndex:11 withObject:orderDocsListArray];
                                        }
                                        
                                        [orderMeasurementDocumentsArray removeAllObjects];
 
                                        NSArray *objectIds = [orderDetailDictionary allKeys];
                                        
                                       
                                        for (int i=0; i<[objectIds count]; i++) {
                                            
                                            if (i ==1) {
                                                
                                                [orderWcmOperationWCDTaggingConditionsArray removeAllObjects];
                                                [orderWcmPermitsStandardCheckPoints removeAllObjects];
                                            }
                                            
                                            [[DataBase sharedInstance] insertDataIntoOrderHeader:[[orderDetailDictionary objectForKey:[objectIds objectAtIndex:i]] firstObject] withAttachments:[[orderDetailDictionary objectForKey:[objectIds objectAtIndex:i]] objectAtIndex:2] withPermitWorkApprovalsDetails:[[orderDetailDictionary objectForKey:[objectIds objectAtIndex:i]] objectAtIndex:1] withOperation:[[orderDetailDictionary objectForKey:[objectIds objectAtIndex:i]] objectAtIndex:3] withParts:[[orderDetailDictionary objectForKey:[objectIds objectAtIndex:i]] objectAtIndex:4] withWSM:[[orderDetailDictionary objectForKey:[objectIds objectAtIndex:i]] objectAtIndex:5] withObjects:[[orderDetailDictionary objectForKey:[objectIds objectAtIndex:i]] objectAtIndex:7] withSystemStatus:[[orderDetailDictionary objectForKey:[objectIds objectAtIndex:i]] objectAtIndex:6] withPermitsWorkApplications:[[orderDetailDictionary objectForKey:[objectIds objectAtIndex:i]] objectAtIndex:8] withIssuePermits:[[orderDetailDictionary objectForKey:[objectIds objectAtIndex:i]] objectAtIndex:9] withPermitsOperationWCD:[[orderDetailDictionary objectForKey:[objectIds objectAtIndex:i]] objectAtIndex:10] withPermitsOperationWCDTagiingConditions:orderWcmOperationWCDTaggingConditionsArray withPermitsStandardCheckPoints:orderWcmPermitsStandardCheckPoints withMeasurementDocs:[[orderDetailDictionary objectForKey:[objectIds objectAtIndex:i]] objectAtIndex:11]];
                                        }
                                    }
                                }
                            }
                        }
                        else if([[[[messageArray objectAtIndex:i] substringToIndex:1] uppercaseString] isEqualToString:@"E"])
                        {
                            [messageString appendString:[NSString stringWithFormat:@"%@\n", [[messageArray objectAtIndex:i]substringFromIndex:1]]];
                            
                            //                            [[DataBase sharedInstance] updateSyncLogErrorForCategory:@"Order" action:@"Confirm" objectid:[parsedDictionary objectForKey:@"OBJECTID"] UUID:[self.orderHeaderDetails objectForKey:@"ID"] message:[messageString substringFromIndex:1]];
 
                            [[DataBase sharedInstance] updateSyncLogErrorForCategory:@"Order" action:@"Confirm" objectid:[parsedDictionary objectForKey:@"OBJECTID"] UUID:self.udidString message:[messageString substringFromIndex:1] Date:[orderHeaderDetails objectForKey:@"DATE"] timestamp:[orderHeaderDetails objectForKey:@"TIME"]];
                            
                            [[DataBase sharedInstance] updateOrderStatus:[orderHeaderDetails objectForKey:@"ID"]];
                            
                        }
                        else
                        {
                            [messageString appendString:[NSString stringWithFormat:@"%@\n", [messageArray objectAtIndex:i]]];
                            //                            [[DataBase sharedInstance] updateSyncLogErrorForCategory:@"Order" action:@"Confirm" objectid:[parsedDictionary objectForKey:@"OBJECTID"] UUID:[self.orderHeaderDetails objectForKey:@"ID"] message:messageString];
                            
                            [[DataBase sharedInstance] updateSyncLogErrorForCategory:@"Order" action:@"Confirm" objectid:[parsedDictionary objectForKey:@"OBJECTID"] UUID:self.udidString message:[messageString substringFromIndex:1] Date:[orderHeaderDetails objectForKey:@"DATE"] timestamp:[orderHeaderDetails objectForKey:@"TIME"]];
                            
                            [[DataBase sharedInstance] updateOrderStatus:[orderHeaderDetails objectForKey:@"ID"]];
                        }
                    }
                    
                    if ([messageString length]) {
                        
 
                        [self showAlertMessageWithTitle:@"Information" message:messageString cancelButtonTitle:@"Ok" withactionType:@"Single" forMethod:nil];
                        
                    }
                }
                else
                {
                    //                    [[DataBase sharedInstance] updateSyncLogErrorForCategory:@"Order" action:@"Confirm" objectid:[self.orderHeaderDetails objectForKey:@"OBJECTID"] UUID:[self.orderHeaderDetails objectForKey:@"ID"] message:NSLocalizedString(@"ErrorMessage",nil)];
                    
                    [[DataBase sharedInstance] updateSyncLogErrorForCategory:@"Order" action:@"Confirm" objectid:self.orderNuber UUID:self.udidString message:NSLocalizedString(@"ErrorMessage",nil) Date:[orderHeaderDetails objectForKey:@"DATE"] timestamp:[orderHeaderDetails objectForKey:@"TIME"]];
                    
                    
                    [[DataBase sharedInstance] updateOrderStatus:[orderHeaderDetails objectForKey:@"ID"]];
                    
                     [self showAlertMessageWithTitle:@"Information" message:NSLocalizedString(@"ErrorMessage", nil) cancelButtonTitle:@"Ok" withactionType:@"Single" forMethod:nil];
                }
            }
            
            else{
                [[DataBase sharedInstance] updateSyncLogErrorForCategory:@"Order" action:@"Confirm" objectid:self.orderNuber UUID:self.udidString message:errorDescription];
                
                [[DataBase sharedInstance] updateOrderStatus:self.udidString];
                
 
                [self showAlertMessageWithTitle:@"Order not Confirmed" message:errorDescription cancelButtonTitle:@"Ok" withactionType:@"Single" forMethod:nil];
 
             }
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];

            break;
 
        default:break;
    }
    
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
