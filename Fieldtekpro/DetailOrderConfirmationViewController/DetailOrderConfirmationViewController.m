//
//  DetailOrderConfirmationViewController.m
//  Fieldtekpro
//
//  Created by Sathya Rakesh Kumar on 10/05/18.
//  Copyright © 2018 Enstrapp Bangalore. All rights reserved.
//

#import "DetailOrderConfirmationViewController.h"
#import "CreateOrderViewController.h"

@interface DetailOrderConfirmationViewController ()<UITextFieldDelegate>

@end

@implementation DetailOrderConfirmationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    headerDataArray=[NSMutableArray new];
    finalHeaderDataArray=[NSMutableArray new];

    self.dropDownArray=[NSMutableArray new];

    [self uiPickerTableViewForDropDownSelection];
    
 //   NSLog(@"poertaion details are %@",self.detailOperationsArray);
    
    [commonListTableview registerNib:[UINib nibWithNibName:@"InputDropDownTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"InputDropDownCell"];
    
    [finalConfirmTableview registerNib:[UINib nibWithNibName:@"InputDropDownTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"finalnputDropDownCell"];
    
    [finalConfirmTableview registerNib:[UINib nibWithNibName:@"BreakDownTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"breakdownCell"];
    
    [finalConfirmTableview registerNib:[UINib nibWithNibName:@"DurationTableviewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"durationCell"];

 
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
                                        if ([methodNameString isEqualToString:@""]) {
                                            
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

#pragma mark-
#pragma mark- UITextField delegate

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
      headerCommonIndex = (int)textField.superview.tag;
      headerFinalConfirmIndex = (int)textField.superview.tag;

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
        
        NSArray *plannedWorkUnitType = [[[headerDataArray objectAtIndex:7]objectAtIndex:2] componentsSeparatedByString:@"/"];
        
        float x = totalPlannedWorkDuration;
        
        if ([[plannedWorkUnitType objectAtIndex:1] isEqualToString:@"MIN"]) {
            
            NSString *actualWorkUnitString=[NSString stringWithFormat:@"%.2f",x/60];
            
          //  actualWorkUnitTextField.text =[actualWorkUnitString substringToIndex:[actualWorkUnitString length]-1];

           // actualWorkUnitIDTextField.text = @"MIN";
            
            [finalHeaderDataArray addObject:[NSMutableArray arrayWithObjects:@"Duration :",@"",[actualWorkUnitString substringToIndex:[actualWorkUnitString length]-1],@"", nil]];

        }
        else if ([[plannedWorkUnitType objectAtIndex:1] isEqualToString:@"HR"]){
            
            NSString *actualWorkUnitString=[NSString stringWithFormat:@"%.2f",x/(60 * 60)];
//            actualWorkUnitTextField.text =[actualWorkUnitString substringToIndex:[actualWorkUnitString length]-1];
//            actualWorkUnitIDTextField.text = @"HR";
            
            [finalHeaderDataArray addObject:[NSMutableArray arrayWithObjects:@"Duration :",@"",[actualWorkUnitString substringToIndex:[actualWorkUnitString length]-1],@"", nil]];

        }
        else if ([[plannedWorkUnitType objectAtIndex:1] isEqualToString:@"DAY"]){
            
            NSString *actualWorkUnitString=[NSString stringWithFormat:@"%.2f",x/(60 * 60 * 24)];
            
//            actualWorkUnitTextField.text =[actualWorkUnitString substringToIndex:[actualWorkUnitString length]-1];
//            actualWorkUnitIDTextField.text = @"DAY";
            
            [finalHeaderDataArray addObject:[NSMutableArray arrayWithObjects:@"Duration :",@"",[actualWorkUnitString substringToIndex:[actualWorkUnitString length]-1],@"", nil]];

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

-(void)loadTechnicalConfirmationdata
{
 
    finishBtn.hidden=NO;
    startBtn.hidden=NO;
    
    self.activityIndicatorView.hidden=YES;
    
    if (![self.statusString isEqualToString:@"REL"]) {
        
         finishBtn.hidden=YES;
         startBtn.hidden=YES;
    }
    
    
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
      //  [[[self.detailOperationsArray objectAtIndex:currentOperationItemIndex] firstObject] replaceObjectAtIndex:8 withObject:@"S"];
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
      //  [[[self.operationDetailsArray objectAtIndex:currentOperationItemIndex] firstObject] replaceObjectAtIndex:8 withObject:@"P"];
     //   confirmOperationStatusCode.backgroundColor=[UIColor purpleColor];
       // [startBtn setImage:[UIImage imageNamed:@"Start-icon"] forState:UIControlStateNormal];
        
         [startBtn setTitle:@"Paused" forState:UIControlStateNormal];
 //         finishBtn.hidden=YES;
         [self.activityIndicatorView stopAnimating];
 
        startFlag = NO;
    }
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
        
        InputDropDownTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell==nil) {
            cell=[[InputDropDownTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIImageView *statusImageView=[[UIImageView alloc] init];
        
        CALayer *orderStatusLayerinFinish = [statusImageView layer];
        [orderStatusLayerinFinish setMasksToBounds:YES];
        [orderStatusLayerinFinish setCornerRadius:8.0];
        
        cell.InputTextField.superview.tag = indexPath.row;
        cell.InputTextField.delegate = self;
        
 
            NSString  *aueruid=[[[self.detailOperationsArray objectAtIndex:0] firstObject] objectAtIndex:8];
            
            if (indexPath.row==0) {
                
                if ([aueruid isEqualToString:@"X"])
                {
                    statusImageView.backgroundColor=[UIColor greenColor];
                    
                    startBtn.hidden=YES;
                    finishBtn.hidden=YES;
                    
                }
                else if ([aueruid isEqualToString:@"Y"])
                {
                    statusImageView.backgroundColor=[UIColor orangeColor];
                    
                    startBtn.hidden=NO;
                    finishBtn.hidden=NO;
                    //              [[DataBase sharedInstance] deleteConfirmWorkOrderTimerForPCNF:orderObject.orderUUID];
                    
                }
                else if ([aueruid isEqualToString:@"Z"])
                {
                    statusImageView.backgroundColor=UIColorFromRGB(0, 100, 0);
                    
                    startBtn.hidden=YES;
                    finishBtn.hidden=YES;
                    
                }
                else if ([aueruid isEqualToString:@"S"])
                {
                    statusImageView.backgroundColor=[UIColor yellowColor];
                    startBtn.hidden=NO;
                    finishBtn.hidden=NO;
                    self.activityIndicatorView.hidden=NO;
                    [self.activityIndicatorView startAnimating];
                    [startBtn setImage:[UIImage imageNamed:@"Pause-icon"] forState:UIControlStateNormal];
                    startFlag = YES;
                    
                }
                else if ([aueruid isEqualToString:@"P"])
                {
                    statusImageView.backgroundColor=[UIColor purpleColor];
                    
                    [startBtn setImage:[UIImage imageNamed:@"Start-icon"] forState:UIControlStateNormal];
                    startBtn.hidden=NO;
                    finishBtn.hidden=YES;
                    
                    self.activityIndicatorView.hidden=NO;
                    [self.activityIndicatorView stopAnimating];
                    
                    startFlag = NO;
                    
                }
                else
                {
                    statusImageView.backgroundColor=UIColorFromRGB(39, 171, 226);
                    startBtn.hidden=NO;
                }
            }
            
            cell.longTextBtn.hidden=YES;
            cell.dropDownImageView.hidden=YES;
            cell.madatoryLabel.hidden=YES;
            
            cell.notifView.layer.cornerRadius = 2.0f;
            cell.notifView.layer.masksToBounds = YES;
            cell.notifView.layer.borderColor = [[UIColor darkGrayColor] CGColor];
            cell.notifView.layer.borderWidth = 1.0f;
            
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
        
        else if (indexPath.row==4){
            
            static NSString *CellIdentifier = @"durationCell";
            
            DurationTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if (cell==nil) {
                cell=[[DurationTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            
            cell.durationInputTextfield.superview.tag = indexPath.row;
            cell.durationInputTextfield.delegate = self;
            
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
