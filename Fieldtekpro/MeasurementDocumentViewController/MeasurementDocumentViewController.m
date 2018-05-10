//
//  MeasurementDocumentViewController.m
//  Fieldtekpro
//
//  Created by Enstrapp Bangalore on 16/01/18.
//  Copyright © 2018 Enstrapp Bangalore. All rights reserved.
//

#import "MeasurementDocumentViewController.h"

@interface MeasurementDocumentViewController ()<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>

@end

@implementation MeasurementDocumentViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
     [self.measurementDocTableView registerNib:[UINib nibWithNibName:@"MeasureMentDocumentTableViewCell_Iphone5" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"Cell"];
    
       [inspectionCheckListTableView registerNib:[UINib nibWithNibName:@"StartInspectionTableViewCell_iPhone5" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"Cell"];
    
    NSString *key = @"";
    NSLog(@"total key is %@",key);
    
    NSString *str_UserNameDep = [[NSUserDefaults standardUserDefaults] objectForKey:@"userName"];
    decryptedUserName = [str_UserNameDep AES128DecryptWithKey:key];
 
    [self fetchequipDocs];
    
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)backInspectionClicked:(id)sender
{
    [startInspectionView removeFromSuperview];
}

-(IBAction)backButtonClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
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
                                        if ([methodNameString isEqualToString:@"SetMeasDoc"]) {
                                            
                                            [self setMeasurementDocMethod];
                                            
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

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    textfieldTag=(int)textField.tag;
    
    selectedInspectionIndex = (int)textField.superview.tag;
    
    if (textfieldTag==10)
    {
        
        NSMutableDictionary *tempInspectionDictionary = [NSMutableDictionary new];
        
        [tempInspectionDictionary addEntriesFromDictionary:[self.inspectionCheckListDataArray objectAtIndex:selectedInspectionIndex]];
        NSMutableDictionary *tempDictionary=[NSMutableDictionary new];
        [tempDictionary setObject:textField.text forKey:@"readc"];
        
        [tempInspectionDictionary addEntriesFromDictionary:tempDictionary];
        [self.inspectionCheckListDataArray replaceObjectAtIndex:selectedInspectionIndex withObject:tempInspectionDictionary];
        
    }
    else if (textfieldTag==20)
    {
        NSMutableDictionary *tempInspectionDictionary = [NSMutableDictionary new];
        
        [tempInspectionDictionary addEntriesFromDictionary:[self.inspectionCheckListDataArray objectAtIndex:selectedInspectionIndex]];
        NSMutableDictionary *tempDictionary=[NSMutableDictionary new];
        [tempDictionary setObject:textField.text forKey:@"notes"];
        
        [tempInspectionDictionary addEntriesFromDictionary:tempDictionary];
        
        [self.inspectionCheckListDataArray replaceObjectAtIndex:selectedInspectionIndex withObject:tempInspectionDictionary];
        
    }
    
    else if (textfieldTag==30){
        
        if (dropDowndismissFlag)
        {
            NSMutableDictionary *tempInspectionDictionary = [NSMutableDictionary new];
            
            [tempInspectionDictionary addEntriesFromDictionary:[self.inspectionCheckListDataArray objectAtIndex:selectedInspectionIndex]];
            
            NSMutableDictionary *tempDictionary=[NSMutableDictionary new];
            
            [tempDictionary setObject:[NSString stringWithFormat:@"%@ ",[[self.dropDownArray objectAtIndex:selectedDropwnTag] objectForKey:@"code"]] forKey:@"vlcod"];
            
             [tempInspectionDictionary addEntriesFromDictionary:tempDictionary];
            
            [self.inspectionCheckListDataArray replaceObjectAtIndex:selectedInspectionIndex withObject:tempInspectionDictionary];
        }
     }
    
    [inspectionCheckListTableView reloadData];
    
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    [inspectionCheckListTableView endEditing:YES];
    
    return YES;
}


-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    [textField reloadInputViews];
    
    tag=(int)textField.tag;
    
    selectedInspectionIndex = (int)textField.superview.tag;

    
    if (textField == measurementDateTextField) {
        [self datePickerForMeasurementDocument];
    }
    else if (textField == measurementTimeTextField) {
        [self datePickerForMeasurementTime];
    }
    else if (textField == dateTexField) {
        
        tag=40;
        [self datePickerForMeasurementDocument];
    }
    
    else if (textField == timeTextField) {
        tag=50;
        [self datePickerForMeasurementTime];
    }
    else if (textField == raedingTextField) {
        
        [self numberpad];
    }
    
    else{
        
        if (tag==30) {
            
            if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
            {
                self.dropDownTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 50, 250, 200)];
                self.mypickerToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 40)];
                
            }
            else
            {
                self.dropDownTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 50, 250, 300)];
                
                self.mypickerToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 40)];
                
                
            }
            
            textField.inputView=self.dropDownTableView;
            
            self.dropDownTableView.delegate=self;
            self.dropDownTableView.dataSource=self;
            
            NSMutableArray *barItems = [[NSMutableArray alloc] init];
            
            UIBarButtonItem *cnclBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(dropdownCancelClicked)];
            
            [barItems addObject:cnclBtn];
            
            UIBarButtonItem *fixedSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:self action:nil];
            
            [barItems addObject:fixedSpace];
            
            UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
            [barItems addObject:flexSpace];
            UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(dropdownDoneClicked)];
            [barItems addObject:doneBtn];
            [_mypickerToolbar setItems:barItems animated:YES];
            
            textField.inputAccessoryView = _mypickerToolbar;
            _mypickerToolbar.barStyle = UIBarStyleBlackOpaque;
            
            
            if (self.dropDownArray==nil) {
                
                self.dropDownArray=[NSMutableArray new];
            }
            else{
                
                [self.dropDownArray removeAllObjects];
             }
            
            [self.dropDownArray addObjectsFromArray:[[DataBase sharedInstance] getMeasCodes:[[self.inspectionCheckListDataArray objectAtIndex:selectedInspectionIndex] objectForKey:@"codgr"]]];
            
            [self.dropDownTableView reloadData];
            
        }
    }
    
    return YES;
}

-(void)dropdownCancelClicked
{
    dropDowndismissFlag=NO;
    [self.view endEditing:YES];
}

-(void)dropdownDoneClicked
{
    dropDowndismissFlag=NO;
    [self.view endEditing:YES];
    
}


-(void)numberpad
{
    UIToolbar *numberToolbar;
    
    UIBarButtonItem *cancelNumberPadButton;
    UIBarButtonItem *spaceNumberPadButton;
    UIBarButtonItem *applyNumberPadButton;
    NSArray *itemarr;
    
    [raedingTextField setKeyboardType:UIKeyboardTypeDecimalPad];
    
    numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 40)];
    
    numberToolbar.barStyle = UIBarStyleBlackTranslucent;
    cancelNumberPadButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelNumberPad)];
    spaceNumberPadButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    applyNumberPadButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(doneWithNumberPad)];
    
    itemarr = [NSArray arrayWithObjects:cancelNumberPadButton, spaceNumberPadButton, applyNumberPadButton, nil];
    // numberToolbar.items = itemarr;
    
    [numberToolbar setItems:itemarr];
    [numberToolbar sizeToFit];
    
    raedingTextField.inputAccessoryView = numberToolbar;
    
    numberToolbar.barStyle = UIBarStyleBlackOpaque;
    [cancelNumberPadButton setTintColor:[UIColor whiteColor]];
    [applyNumberPadButton setTintColor:[UIColor whiteColor]];
    
    
}

-(void)cancelNumberPad{
    
}

-(void)doneWithNumberPad{
    
    [raedingTextField resignFirstResponder];
}



//for MeasurementDatepicker.
-(void)datePickerForMeasurementDocument{
    
    self.measurementDocDatePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, 250, 0, 0)];
    
    self.measurementDocDatePicker.datePickerMode = UIDatePickerModeDate;
    
    measurementDateTextField.inputView =self.measurementDocDatePicker;
    
    dateTexField.inputView =self.measurementDocDatePicker;
    
    UIToolbar *myDatePickerToolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 100, 320, 56)];
    
    myDatePickerToolBar.barStyle = UIBarStyleBlackOpaque;
    
    [myDatePickerToolBar sizeToFit];
    
    NSMutableArray *barItems = [[NSMutableArray alloc] init];
    
    UIBarButtonItem *cnclBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(measurementDocCancelClicked)];
    
    [barItems addObject:cnclBtn];
    
    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    [barItems addObject:flexSpace];
    
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(measurementDocDoneClicked)];
    
    [barItems addObject:doneBtn];
    
    [myDatePickerToolBar setItems:barItems animated:YES];
    
    measurementDateTextField.inputAccessoryView = myDatePickerToolBar;
    dateTexField.inputAccessoryView = myDatePickerToolBar;
    
    
}

-(void)measurementDocCancelClicked
{
    
    [measurementDateTextField resignFirstResponder];
    [dateTexField resignFirstResponder];
    
}

-(void)measurementDocDoneClicked
{
    if (tag==40) {
        
        self.measureMentDocumentDate =[self.measurementDocDatePicker date];
        
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"MMM dd, yyyy"];
        dateTexField.text = [dateFormat stringFromDate:self.measureMentDocumentDate];
        [dateTexField resignFirstResponder];
    }
    else{
        
        self.measureMentDocumentDate =[self.measurementDocDatePicker date];
        
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"MMM dd, yyyy"];
        
        measurementDateTextField.text = [dateFormat stringFromDate:self.measureMentDocumentDate];
        
        [measurementDateTextField resignFirstResponder];
    }
    
}


//for MeasurementDatepicker.
-(void)datePickerForMeasurementTime{
    
    self.measurementDocTimePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, 250, 0, 0)];
    
    self.measurementDocTimePicker.datePickerMode = UIDatePickerModeTime;
    
    measurementTimeTextField.inputView =self.measurementDocTimePicker;
    timeTextField.inputView =self.measurementDocTimePicker;
    
    
    UIToolbar *myDatePickerToolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 100, 320, 56)];
    
    myDatePickerToolBar.barStyle = UIBarStyleBlackOpaque;
    
    [myDatePickerToolBar sizeToFit];
    
    NSMutableArray *barItems = [[NSMutableArray alloc] init];
    
    UIBarButtonItem *cnclBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(measurementTimeCancelClicked)];
    
    [barItems addObject:cnclBtn];
    
    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    [barItems addObject:flexSpace];
    
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(measurementTimeDoneClicked)];
    
    [barItems addObject:doneBtn];
    
    [myDatePickerToolBar setItems:barItems animated:YES];
    
    measurementTimeTextField.inputAccessoryView = myDatePickerToolBar;
    timeTextField.inputAccessoryView = myDatePickerToolBar;
    
}

-(void)measurementTimeCancelClicked
{
    [measurementTimeTextField resignFirstResponder];
}

-(void)measurementTimeDoneClicked
{
    if (tag==50) {
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"HH:mm:ss"];
        timeTextField.text = [dateFormatter stringFromDate:self.measurementDocTimePicker.date];
        [timeTextField resignFirstResponder];
    }
    else{
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"hh:mm a"];
        measurementTimeTextField.text = [dateFormatter stringFromDate:self.measurementDocTimePicker.date];
        [measurementTimeTextField resignFirstResponder];
    }
    
}



-(IBAction)startInspectionBtn:(id)sender
{
    if (self.inspectionCheckListDataArray==nil)
    {
        self.inspectionCheckListDataArray=[NSMutableArray new];
    }
    else{
        
        [self.inspectionCheckListDataArray removeAllObjects];
    }
    
    [self.inspectionCheckListDataArray addObjectsFromArray:[[DataBase sharedInstance] getMeasurementDocumentPoints:[NSString stringWithFormat:@"%@",self.equipmentId]]];
    
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:[NSDate date]];
    NSInteger currentHour = [components hour];
    NSInteger currentMinute = [components minute];
    NSInteger currentSecond = [components second];
    
    
    //    if (currentHour < 14  || (currentHour < 6 || (currentHour == 14 && (currentMinute > 0 || currentSecond > 0)))) {
    //
    //
    //
    //    }
    //    else if (currentHour < 22 || (currentHour > 14 || (currentHour == 22 && (currentMinute > 0 || currentSecond > 0)))){
    //
    //
    //    }
    
    if ((currentHour ==1 && currentMinute >= 0 && currentSecond >= 0) || (currentHour < 9 && currentMinute >=0 && currentSecond >= 0) || (currentHour >=18 && (currentMinute > 0 || currentSecond >0)))
    {
        if (currentHour <=24 && currentMinute >=0 && currentSecond >=0)
        {
            self.shiftTitleText.text = @"Night Shift";
            
         }
        else
        {
            self.shiftTitleText.text = @"Night Shift";
        }
    }
    else if ((currentHour >= 9 && currentMinute >=0 && currentSecond >= 0))
    {
        if ((currentHour == 18 && currentMinute ==0 && currentSecond == 0))
        {
            self.shiftTitleText.text = @"Morning Shift";
        }
        else if (currentHour <18 && currentMinute >=0 && currentSecond >= 0)
        {
            self.shiftTitleText.text = @"Morning Shift";
        }
    }
    
    NSDateFormatter *dateformatter=[[NSDateFormatter alloc]init];
    [dateformatter setDateFormat:@"MMM dd, yyyy"];
    
    dateTexField.text = [dateformatter stringFromDate:[NSDate date]];
    
    [dateformatter setDateFormat:@"HHmmss"];
    
    timeTextField.text = [dateformatter stringFromDate:[NSDate date]];
    
    [startInspectionView setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
 
    [self.view addSubview:startInspectionView];
    
    [inspectionCheckListTableView reloadData];
 
}

-(void)fetchequipDocs
{
 
    if (self.equipmentId.length) {
        
        if ([[ConnectionManager defaultManager] isReachable]) {
            
           // [ActivityView show:@"Loading....."];
            
            hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
             hud.mode = MBProgressHUDAnimationFade;
            hud.label.text = @"Loading.....";
 
            NSMutableDictionary *endPointmeasureMentGetDictionary = [[NSMutableDictionary alloc]init];
            [endPointmeasureMentGetDictionary setObject:@"RD" forKey:@"ACTIVITY"];
            [endPointmeasureMentGetDictionary setObject:@"EI" forKey:@"DOCTYPE"];
            [endPointmeasureMentGetDictionary setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"ENDPOINT"] forKey:@"ENDPOINT"];
            
            [endPointmeasureMentGetDictionary setObject:decryptedUserName forKey:@"REPORTEDBY"];

            NSArray *endPointArray = [[DataBase sharedInstance] getEndPointURL:endPointmeasureMentGetDictionary];
            NSLog(@"endPoint :%@",[[endPointArray objectAtIndex:0] objectAtIndex:0]);
            [endPointmeasureMentGetDictionary setObject:[[endPointArray objectAtIndex:0] objectAtIndex:0] forKey:@"URL_ENDPOINT"];
            
            [endPointmeasureMentGetDictionary setObject:[self.equipmentId copy] forKey:@"EQUINR"];
            [endPointmeasureMentGetDictionary setObject:@"LOAD" forKey:@"TRANSMITTYPE"];
            
            [Request makeWebServiceRequest:MONITOR_GET_EQUIP_MDOCS parameters:endPointmeasureMentGetDictionary delegate:self];
            
        }
        else
        {
           
            [self showAlertMessageWithTitle:@"No Network Available" message:@"Please check your internet connection" cancelButtonTitle:@"Ok" withactionType:@"Single" forMethod:nil];
        }
        
    }
 }


-(IBAction)submitMeasureDocumentDetails:(id)sender{

    [self showAlertMessageWithTitle:@"Decision" message:@"Do you want to submit inspection checklist data ?" cancelButtonTitle:@"No" withactionType:@"Multiple" forMethod:@"SetMeasDoc"];
    
}

-(void)setMeasurementDocMethod{
    
   // [ActivityView show:@"Inspection Checklist in Progress....."];
    
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDAnimationFade;
    hud.label.text = @"Inspection Checklist in Progress.....";
    
    NSMutableDictionary *inspectionDetails = [[NSMutableDictionary alloc]init];
    
    [inspectionDetails setObject:@"I" forKey:@"ACTIVITY"];
    [inspectionDetails setObject:@"EI" forKey:@"DOCTYPE"];
    [inspectionDetails setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"ENDPOINT"] forKey:@"ENDPOINT"];
    
    NSArray *endPointArray = [[DataBase sharedInstance] getEndPointURL:inspectionDetails];
    NSLog(@"endPoint :%@",[[endPointArray objectAtIndex:0] objectAtIndex:0]);
    [inspectionDetails setObject:[[endPointArray objectAtIndex:0] objectAtIndex:0] forKey:@"URL_ENDPOINT"];
    
    //[inspectionDetails setObject:[self.inspectionCheckListDataArray copy] forKey:@"MDOCS"];
    
    //            [inspectionDetails setObject:dateTexField.text forKey:@"Date"];
    //            [inspectionDetails setObject:timeTextField.text forKey:@"Time"];
    
    [inspectionDetails setObject:@"" forKey:@"TRANSMITTYPE"];
    [inspectionDetails setObject:decryptedUserName forKey:@"REPORTEDBY"];
    
    NSMutableArray *inspectionChecklistArray=[NSMutableArray new];
    
    for (int i=0; i<[self.inspectionCheckListDataArray count]; i++) {
        
        NSMutableArray *tempArray=[NSMutableArray new];
        
        [tempArray addObject:@""];
        
        [tempArray addObject:@""];
        
        [tempArray addObject:[[self.inspectionCheckListDataArray objectAtIndex:i] objectForKey:@"equnr"]];
        
        [tempArray addObject:[[self.inspectionCheckListDataArray objectAtIndex:i] objectForKey:@"point"]];
        
        [tempArray addObject:dateTexField.text];
        
        [tempArray addObject:timeTextField.text];
        
        [tempArray addObject:[[self.inspectionCheckListDataArray objectAtIndex:i] objectForKey:@"notes"]];
        
        [tempArray addObject:[[self.inspectionCheckListDataArray objectAtIndex:i] objectForKey:@"readc"]];
        
 
        [tempArray addObject:[[self.inspectionCheckListDataArray objectAtIndex:i] objectForKey:@"task"]];
        
 
        NSString *vlcodString;
        
        if ([[[self.inspectionCheckListDataArray objectAtIndex:i] objectForKey:@"normal"] isEqualToString:@"X"]) {
            
            vlcodString=@"OK";
            
        }
        else if ([[[self.inspectionCheckListDataArray objectAtIndex:i] objectForKey:@"alarm"] isEqualToString:@"X"]){
            
            vlcodString=@"POK";
            
        }
        
        else if ([[[self.inspectionCheckListDataArray objectAtIndex:i] objectForKey:@"critical"] isEqualToString:@"X"]){
            
            vlcodString=@"NOK";
            
        }
        
        if ([NullChecker isNull:vlcodString]) {
            vlcodString = @"";
        }
        
        if ([vlcodString isEqualToString:@""]) {
 
             [tempArray addObject:@""];
         }
        else{
            
            [tempArray addObject:vlcodString];
            
        }
        

        if ([[self.inspectionCheckListDataArray objectAtIndex:i] objectForKey:@"vlcod"]) {
            
            [tempArray addObject:[[self.inspectionCheckListDataArray objectAtIndex:i] objectForKey:@"vlcod"]];
        }
        
        else{
            
            [tempArray addObject:@""];
        }
        
        [inspectionChecklistArray addObject:tempArray];
    }
    
    [inspectionDetails setObject:inspectionChecklistArray forKey:@"MDOCS"];
    
    // [[DataBase sharedInstance] insertInspectionCheckListDetailwithTransactions:inspectionDetails];
 
    if([[ConnectionManager defaultManager] isReachable])
    {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"CSRF"];
        [[NSUserDefaults standardUserDefaults] synchronize];

        [Request makeWebServiceRequest:MONITOR_SET_EQUIP_MDOCS parameters:inspectionDetails delegate:self];
        
    }
    else
    {
 
        [MBProgressHUD hideHUDForView:self.view animated:YES];

         [self showAlertMessageWithTitle:@"Inforamtion" message:@"Data Stored in offline" cancelButtonTitle:@"OK" withactionType:@"Single" forMethod:nil];
     }
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;              // Default is 1 if not implemented
{
    
    return 1;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (tableView == self.measurementDocTableView)
    {
         return [self.mesurementDocumentArray count];
    }
    else if (tableView ==inspectionCheckListTableView)
    {
         return [self.inspectionCheckListDataArray count];
    }
    else if (tableView == self.dropDownTableView) {
        
        return [self.dropDownArray count];
    }
    
    
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

  if (tableView == self.measurementDocTableView) {
    
    if (self.measurementDocTableView.contentSize.height < self.measurementDocTableView.frame.size.height) {
        self.measurementDocTableView.scrollEnabled = NO;
    }
    else {
        self.measurementDocTableView.scrollEnabled = YES;
    }
    
    static NSString *CellIdentifier = @"Cell";
    
    MeasureMentDocumentTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell==nil) {
        cell=[[MeasureMentDocumentTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
      cell.accessoryType=UITableViewCellAccessoryNone;

    
    static NSInteger checkboxTag = 123;
    NSInteger x,y;x = 8.0; y = 9.0;
    
    if (!cell.checkBoxButton) {
        
        cell.checkBoxButton.tag=checkboxTag;
        
    }
    [cell.checkBoxButton setImage:[UIImage imageNamed:@"checkBoxUnSelection"]   forState:UIControlStateNormal];
    
    cell.checkBoxButton.adjustsImageWhenHighlighted = YES;
    [cell.checkBoxButton addTarget:self action:@selector(checkBoxMeasureDocsClicked:)   forControlEvents:UIControlEventTouchDown];
      
      cell.mDocsContentView.layer.cornerRadius = 2.0f;
      cell.mDocsContentView.layer.masksToBounds = YES;
      cell.mDocsContentView.layer.borderColor = [[UIColor darkGrayColor] CGColor];
      cell.mDocsContentView.layer.borderWidth = 1.0f;
    
    cell.readValueLabel.textColor=[UIColor orangeColor];
    
    cell.mDocLabel.text=[[self.mesurementDocumentArray objectAtIndex:indexPath.row] objectAtIndex:4];
    
    cell.measurementPointValueLabel.text=[[self.mesurementDocumentArray objectAtIndex:indexPath.row] objectAtIndex:5];
    cell.measurementDescriptionLabel.text=[[self.mesurementDocumentArray objectAtIndex:indexPath.row] objectAtIndex:9];
    cell.readValueLabel.text=[[self.mesurementDocumentArray objectAtIndex:indexPath.row] objectAtIndex:18];
    
    cell.targetLabel.text=[[self.mesurementDocumentArray objectAtIndex:indexPath.row] objectAtIndex:19];
    
    cell.unitLabel.text=[[self.mesurementDocumentArray objectAtIndex:indexPath.row] objectAtIndex:17];
    
    cell.personLabel.text=[[self.mesurementDocumentArray objectAtIndex:indexPath.row] objectAtIndex:14];
    
    cell.notesLabel.text=[[self.mesurementDocumentArray objectAtIndex:indexPath.row] objectAtIndex:13];
    
    cell.resultLabel.text=@"";
    
    
    if ([[[self.mesurementDocumentArray objectAtIndex:indexPath.row] objectAtIndex:24] isEqualToString:@"POK"]) {
        
        cell.resultLabel.text=@"Alarm(POK)";
        
    }
    else if ([[[self.mesurementDocumentArray objectAtIndex:indexPath.row] objectAtIndex:24] isEqualToString:@"NOK"]){
        
        cell.resultLabel.text=@"Critical(NOK)";
    }
    else if ([[[self.mesurementDocumentArray objectAtIndex:indexPath.row] objectAtIndex:24] isEqualToString:@"OK"]){
        
        cell.resultLabel.text=@"Normal(OK)";
    }
    
    cell.resultLabel.textColor=[UIColor blueColor];
    
    NSDateFormatter *StartdateFormatter = [[NSDateFormatter alloc] init];
    [StartdateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    
    NSDate *startDateString = [StartdateFormatter dateFromString:[[self.mesurementDocumentArray objectAtIndex:indexPath.row] objectAtIndex:11]];
    
    
    // Convert date object into desired format
    
    [StartdateFormatter setDateFormat:@"MMM dd, yyyy"];
    NSString *convertedStartDateString = [StartdateFormatter stringFromDate:startDateString];
    
    if ([NullChecker isNull:convertedStartDateString])
    {
        convertedStartDateString = @"";
    }
    
 
    cell.timeDateLabel.text=[NSString stringWithFormat:@"%@ %@",convertedStartDateString,[[self.mesurementDocumentArray objectAtIndex:indexPath.row] objectAtIndex:12]];
    
    if ([self.selectedMeasureDocsCheckBoxArray containsObject:[NSNumber numberWithInteger:indexPath.row]])
    {
        
        [cell.checkBoxButton setImage:[UIImage imageNamed:@"checkBoxSelection"]   forState:UIControlStateNormal];
        
    }
    else{
        [cell.checkBoxButton setImage:[UIImage imageNamed:@"checkBoxUnSelection"]   forState:UIControlStateNormal];
    }
    
    if ([[[self.mesurementDocumentArray objectAtIndex:indexPath.row] objectAtIndex:22] isEqualToString:@"I"]) {
        cell.checkBoxButton.hidden=NO;
        
    }
    else
    {
        cell.checkBoxButton.hidden=YES;
    }
    
    return cell;
 }
 
  else if (tableView==inspectionCheckListTableView){
      
      static NSString *CellIdentifier = @"Cell";
      
      StartInspectionTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
 
      if (cell==nil) {
          cell=[[StartInspectionTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
      }
      
      static NSInteger checkboxTag = 123;
      NSInteger x,y;x = 8.0; y = 9.0;
      
      if (!cell.createdTaskBtn) {
          cell.createdTaskBtn.tag=checkboxTag;
      }
      
      cell.inspectionContentView.layer.cornerRadius = 2.0f;
      cell.inspectionContentView.layer.masksToBounds = YES;
      cell.inspectionContentView.layer.borderColor = [[UIColor darkGrayColor] CGColor];
      cell.inspectionContentView.layer.borderWidth = 1.0f;
      
      [cell.createdTaskBtn setImage:[UIImage imageNamed:@"checkBoxUnSelection"]   forState:UIControlStateNormal];
      
      cell.createdTaskBtn.adjustsImageWhenHighlighted = YES;
      
      [cell.createdTaskBtn addTarget:self action:@selector(createdTaskClicked:)   forControlEvents:UIControlEventTouchDown];
      
      if (!cell.normalBtn) {
          
          cell.normalBtn.tag=checkboxTag;
          
      }
      
      [cell.normalBtn addTarget:self action:@selector(normalBtnClicked:)   forControlEvents:UIControlEventTouchDown];
      
      if (!cell.alarmBtn) {
          
          cell.alarmBtn.tag=checkboxTag;
          
      }
      
      
      [cell.alarmBtn addTarget:self action:@selector(alarmBtnClicked:)   forControlEvents:UIControlEventTouchDown];
      
      if (!cell.criticalBtn) {
          
          cell.criticalBtn.tag=checkboxTag;
          
      }
      [cell.criticalBtn addTarget:self action:@selector(criticalBtnClicked:)   forControlEvents:UIControlEventTouchDown];
      
      
      [cell.alarmBtn setImage:[UIImage imageNamed:@"checkBoxUnSelection"]   forState:UIControlStateNormal];
      [cell.normalBtn setImage:[UIImage imageNamed:@"checkBoxUnSelection"]   forState:UIControlStateNormal];
      [cell.criticalBtn setImage:[UIImage imageNamed:@"checkBoxUnSelection"]   forState:UIControlStateNormal];
      
      
      cell.readingTextfield.superview.tag = indexPath.row;
      cell.notesTextfield.superview.tag = indexPath.row;
      
      cell.valuvationTextField.superview.tag = indexPath.row;
      
      [cell.readingTextfield setTag:10];
      [cell.notesTextfield setTag:20];
      
      [cell.valuvationTextField setTag:30];
      
      cell.readingTextfield.delegate=self;
      cell.notesTextfield.delegate=self;
      cell.valuvationTextField.delegate=self;
      
      
      cell.inspectionLabel.text=[[self.inspectionCheckListDataArray objectAtIndex:indexPath.row] objectForKey:@"point"];
      
      cell.descriptionlabel.text=[[self.inspectionCheckListDataArray objectAtIndex:indexPath.row] objectForKey:@"pttxt"];
      
      cell.readingTextfield.text=[[self.inspectionCheckListDataArray objectAtIndex:indexPath.row] objectForKey:@"readc"];
      
      cell.valuvationTextField.text=[[self.inspectionCheckListDataArray objectAtIndex:indexPath.row] objectForKey:@"vlcod"];
      
      cell.notesTextfield.text=[[self.inspectionCheckListDataArray objectAtIndex:indexPath.row] objectForKey:@"notes"];
      cell.unitsValueLabel.text=[[self.inspectionCheckListDataArray objectAtIndex:indexPath.row] objectForKey:@"msehl"];
      
      if ([[[self.inspectionCheckListDataArray objectAtIndex:indexPath.row] objectForKey:@"task"] isEqualToString:@"X"]) {
          
          [cell.createdTaskBtn setImage:[UIImage imageNamed:@"CheckBoxSelection"]   forState:UIControlStateNormal];
      }
      
      if ([[[self.inspectionCheckListDataArray objectAtIndex:indexPath.row] objectForKey:@"normal"] isEqualToString:@"X"]) {
          
          [cell.normalBtn setImage:[UIImage imageNamed:@"CheckBoxSelection"]   forState:UIControlStateNormal];
          
      }
      
      if ([[[self.inspectionCheckListDataArray objectAtIndex:indexPath.row] objectForKey:@"alarm"] isEqualToString:@"X"]) {
          
          [cell.alarmBtn setImage:[UIImage imageNamed:@"CheckBoxSelection"]   forState:UIControlStateNormal];
      }
      
      if ([[[self.inspectionCheckListDataArray objectAtIndex:indexPath.row] objectForKey:@"critical"] isEqualToString:@"X"]) {
          
          [cell.criticalBtn setImage:[UIImage imageNamed:@"CheckBoxSelection"]   forState:UIControlStateNormal];
      }
      
      return cell;
  }
  else if (tableView == self.dropDownTableView) {
      
      static NSString *CellIdentifier = @"Cell";
      UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
      
      if (cell==nil) {
          cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
      }
      
      cell.accessoryType=UITableViewCellAccessoryNone;
      
      cell.textLabel.text = [NSString stringWithFormat:@"%@-%@",[[self.dropDownArray objectAtIndex:indexPath.row] objectForKey:@"code"],[[self.dropDownArray objectAtIndex:indexPath.row] objectForKey:@"Kurztext1"]];
      
      return cell;
  }
 
    return nil;
 }

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
     if (tableView == self.dropDownTableView)
     {
        selectedDropwnTag=(int)indexPath.row;
        dropDowndismissFlag=YES;
        [self.view endEditing:YES];
        [inspectionCheckListTableView reloadData];
        
     }
}

-(NSIndexPath *) GetCellFromTableView: (UITableView *)tableView Sender:(id)sender
{
    CGPoint position = [sender convertPoint:CGPointZero toView:tableView];
    NSIndexPath *indexPath = [tableView indexPathForRowAtPoint:position];
    return indexPath;//[tableView cellForRowAtIndexPath:indexPath];
}

-(void)checkBoxMeasureDocsClicked:(id)sender{
    
    NSIndexPath *ip = [self GetCellFromTableView:self.measurementDocTableView Sender:sender];
    NSInteger i = ip.row;
    
    UIButton *tappedButton = (UIButton*)sender;
    
    if([tappedButton.currentImage isEqual:[UIImage imageNamed:@"checkBoxUnSelection"]]) {
        [sender  setImage:[UIImage imageNamed: @"CheckBoxSelection"] forState:UIControlStateNormal];
        // [[self.mesurementDocumentArray objectAtIndex:i] replaceObjectAtIndex:22 withObject:@"X"];
        [self.selectedMeasureDocsCheckBoxArray addObject:[NSNumber numberWithInteger:i]];
        
    }
    else
    {
        [sender setImage:[UIImage imageNamed:@"checkBoxUnSelection"]forState:UIControlStateNormal];
        // [[self.mesurementDocumentArray objectAtIndex:i] replaceObjectAtIndex:22 withObject:@""];
        [self.selectedMeasureDocsCheckBoxArray removeObject:[NSNumber numberWithInteger:i]];
        
    }
}


-(void)createdTaskClicked:(id)sender{
    
    NSIndexPath *ip = [self GetCellFromTableView:inspectionCheckListTableView Sender:sender];
    NSInteger i = ip.row;
    
    if(![[[self.inspectionCheckListDataArray objectAtIndex:i] objectForKey:@"task"] isEqualToString:@"X"])  {
        
        NSMutableDictionary *tempInspectionDictionary = [NSMutableDictionary new];
        
        [tempInspectionDictionary addEntriesFromDictionary:[self.inspectionCheckListDataArray objectAtIndex:i]];
        
        NSMutableDictionary *tempDictionary=[NSMutableDictionary new];
        
        [tempDictionary setObject:@"X" forKey:@"task"];
        
        [tempInspectionDictionary addEntriesFromDictionary:tempDictionary];
        
        [self.inspectionCheckListDataArray replaceObjectAtIndex:i withObject:tempInspectionDictionary];
        
    }
    else
    {
        NSMutableDictionary *tempInspectionDictionary = [NSMutableDictionary new];
        
        [tempInspectionDictionary addEntriesFromDictionary:[self.inspectionCheckListDataArray objectAtIndex:i]];
        
        NSMutableDictionary *tempDictionary=[NSMutableDictionary new];
        
        [tempDictionary setObject:@"" forKey:@"task"];
        
        [tempInspectionDictionary addEntriesFromDictionary:tempDictionary];
        
        [self.inspectionCheckListDataArray replaceObjectAtIndex:i withObject:tempInspectionDictionary];
        
    }
    
    [inspectionCheckListTableView reloadData];
}

-(void)normalBtnClicked:(id)sender{
    
    NSIndexPath *ip = [self GetCellFromTableView:inspectionCheckListTableView Sender:sender];
    
    NSInteger i = ip.row;
    
    if(![[[self.inspectionCheckListDataArray objectAtIndex:i] objectForKey:@"normal"] isEqualToString:@"X"]) {
        
        NSMutableDictionary *tempInspectionDictionary = [NSMutableDictionary new];
        
        [tempInspectionDictionary addEntriesFromDictionary:[self.inspectionCheckListDataArray objectAtIndex:i]];
        
        NSMutableDictionary *tempDictionary=[NSMutableDictionary new];
        
        [tempDictionary setObject:@"" forKey:@"critical"];
        [tempDictionary setObject:@"X" forKey:@"normal"];
        [tempDictionary setObject:@"" forKey:@"alarm"];
        
        [tempInspectionDictionary addEntriesFromDictionary:tempDictionary];
        
        [self.inspectionCheckListDataArray replaceObjectAtIndex:i withObject:tempInspectionDictionary];
    }
    
    [inspectionCheckListTableView reloadData];
    
}
-(void)alarmBtnClicked:(id)sender{
    
    NSIndexPath *ip = [self GetCellFromTableView:inspectionCheckListTableView Sender:sender];
    
    NSInteger i = ip.row;
    
    if(![[[self.inspectionCheckListDataArray objectAtIndex:i] objectForKey:@"alarm"] isEqualToString:@"X"]) {
        
        NSMutableDictionary *tempInspectionDictionary = [NSMutableDictionary new];
        
        [tempInspectionDictionary addEntriesFromDictionary:[self.inspectionCheckListDataArray objectAtIndex:i]];
        
        NSMutableDictionary *tempDictionary=[NSMutableDictionary new];
        
        [tempDictionary setObject:@"" forKey:@"critical"];
        [tempDictionary setObject:@"" forKey:@"normal"];
        [tempDictionary setObject:@"X" forKey:@"alarm"];
        
        [tempInspectionDictionary addEntriesFromDictionary:tempDictionary];
        
        [self.inspectionCheckListDataArray replaceObjectAtIndex:i withObject:tempInspectionDictionary];
        
    }
    
    [inspectionCheckListTableView reloadData];
}

-(void)criticalBtnClicked:(id)sender{
    
    NSIndexPath *ip = [self GetCellFromTableView:inspectionCheckListTableView Sender:sender];
    
    NSInteger i = ip.row;
    
    if(![[[self.inspectionCheckListDataArray objectAtIndex:i] objectForKey:@"critical"] isEqualToString:@"X"]) {
        
        NSMutableDictionary *tempInspectionDictionary = [NSMutableDictionary new];
        
        [tempInspectionDictionary addEntriesFromDictionary:[self.inspectionCheckListDataArray objectAtIndex:i]];
        
        NSMutableDictionary *tempDictionary=[NSMutableDictionary new];
        
        [tempDictionary setObject:@"X" forKey:@"critical"];
        [tempDictionary setObject:@"" forKey:@"normal"];
        [tempDictionary setObject:@"" forKey:@"alarm"];
        
        [tempInspectionDictionary addEntriesFromDictionary:tempDictionary];
        
        [self.inspectionCheckListDataArray replaceObjectAtIndex:i withObject:tempInspectionDictionary];
    }
    
    [inspectionCheckListTableView reloadData];
}

- (void)resultData:(NSDictionary *)resultData withErrorDescription:(NSString *)errorDescription requestID:(WebServiceRequest)requestID :(int)statusCode
{
    switch (requestID) {
 
  case MONITOR_GET_EQUIP_MDOCS:

     if (!errorDescription.length) {
    
     
     NSMutableDictionary *parsedDictionary =  [[Response sharedInstance] parseForMonitorMeasurementDocs:resultData];
    
     [MBProgressHUD hideHUDForView:self.view animated:YES];
 
    if ([parsedDictionary objectForKey:@"resultMonitorMdocs"]) {
        
        NSMutableArray *parsedArray=[NSMutableArray new];
        
        [parsedArray addObjectsFromArray:[parsedDictionary objectForKey:@"resultMonitorMdocs"]];
        
        if (self.mesurementDocumentArray==nil) {
            
            self.mesurementDocumentArray=[NSMutableArray new];
        }
        else{
            [self.mesurementDocumentArray removeAllObjects];
            
        }
        for (int i=0; i<[parsedArray count]; i++)
        {
            NSMutableArray *tempArray=[NSMutableArray new];
            
            [tempArray addObject:@""];
            
            if (![NullChecker isNull:[[parsedArray objectAtIndex:i] objectForKey:@"Qmnum"]])
            {
                [tempArray addObject:[NSString stringWithFormat:@"%@",[[parsedArray objectAtIndex:i] objectForKey:@"Qmnum"]]];//0vornr
                
            }
            else
            {
                [tempArray addObject:@""];//0vornr
                
            }
            
            
            if (![NullChecker isNull:[[parsedArray objectAtIndex:i] objectForKey:@"Aufnr"]])
            {
                
                [tempArray addObject:[NSString stringWithFormat:@"%@",[[parsedArray objectAtIndex:i] objectForKey:@"Aufnr"]]];
                
            }
            else
            {
                [tempArray addObject:@""];
                
            }
            
            
            
            if (![NullChecker isNull:[[parsedArray objectAtIndex:i] objectForKey:@"Vornr"]])
            {
                
                [tempArray addObject:[NSString stringWithFormat:@"%@",[[parsedArray objectAtIndex:i] objectForKey:@"Vornr"]]];
                
            }
            else
            {
                [tempArray addObject:@""];
                
            }
            
            
            
            if (![NullChecker isNull:[[parsedArray objectAtIndex:i] objectForKey:@"Mdocm"]])
            {
                
                [tempArray addObject:[NSString stringWithFormat:@"%@",[[parsedArray objectAtIndex:i] objectForKey:@"Mdocm"]]];
            }
            else
            {
                [tempArray addObject:@""];
                
            }
            
            if (![NullChecker isNull:[[parsedArray objectAtIndex:i] objectForKey:@"Point"]])
            {
                [tempArray addObject:[NSString stringWithFormat:@"%@",[[parsedArray objectAtIndex:i] objectForKey:@"Point"]]];
            }
            else
            {
                [tempArray addObject:@""];
            }
            
            if (![NullChecker isNull:[[parsedArray objectAtIndex:i] objectForKey:@"Mpobj"]])
            {
                [tempArray addObject:[NSString stringWithFormat:@"%@",[[parsedArray objectAtIndex:i] objectForKey:@"Mpobj"]]];
            }
            else
            {
                [tempArray addObject:@""];
            }
            
            if (![NullChecker isNull:[[parsedArray objectAtIndex:i] objectForKey:@"Mpobt"]])
            {
                [tempArray addObject:[NSString stringWithFormat:@"%@",[[parsedArray objectAtIndex:i] objectForKey:@"Mpobt"]]];
            }
            else
            {
                [tempArray addObject:@""];
            }
            
            if (![NullChecker isNull:[[parsedArray objectAtIndex:i] objectForKey:@"Psort"]])
            {
                [tempArray addObject:[NSString stringWithFormat:@"%@",[[parsedArray objectAtIndex:i] objectForKey:@"Psort"]]];
            }
            else
            {
                [tempArray addObject:@""];
                
            }
            
            if (![NullChecker isNull:[[parsedArray objectAtIndex:i] objectForKey:@"Pttxt"]])
            {
                [tempArray addObject:[NSString stringWithFormat:@"%@",[[parsedArray objectAtIndex:i] objectForKey:@"Pttxt"]]];
            }
            else
            {
                [tempArray addObject:@""];
                
            }
            
            if (![NullChecker isNull:[[parsedArray objectAtIndex:i] objectForKey:@"Atinn"]])
            {
                [tempArray addObject:[NSString stringWithFormat:@"%@",[[parsedArray objectAtIndex:i] objectForKey:@"Atinn"]]];
            }
            else
            {
                [tempArray addObject:@""];
                
            }
            
            if (![NullChecker isNull:[[parsedArray objectAtIndex:i] objectForKey:@"Idate"]])
            {
                [tempArray addObject:[NSString stringWithFormat:@"%@",[[parsedArray objectAtIndex:i] objectForKey:@"Idate"]]];
            }
            else
            {
                [tempArray addObject:@""];
                
            }
            
            if (![NullChecker isNull:[[parsedArray objectAtIndex:i] objectForKey:@"Itime"]])
            {
                [tempArray addObject:[NSString stringWithFormat:@"%@",[[parsedArray objectAtIndex:i] objectForKey:@"Itime"]]];
            }
            else
            {
                [tempArray addObject:@""];
                
            }
            
            if (![NullChecker isNull:[[parsedArray objectAtIndex:i] objectForKey:@"Mdtxt"]])
            {
                [tempArray addObject:[NSString stringWithFormat:@"%@",[[parsedArray objectAtIndex:i] objectForKey:@"Mdtxt"]]];
            }
            else
            {
                [tempArray addObject:@""];
                
            }
            
            if (![NullChecker isNull:[[parsedArray objectAtIndex:i] objectForKey:@"Readr"]])
            {
                [tempArray addObject:[NSString stringWithFormat:@"%@",[[parsedArray objectAtIndex:i] objectForKey:@"Readr"]]];
            }
            else
            {
                [tempArray addObject:@""];
                
            }
            
            if (![NullChecker isNull:[[parsedArray objectAtIndex:i] objectForKey:@"Atbez"]])
            {
                [tempArray addObject:[NSString stringWithFormat:@"%@",[[parsedArray objectAtIndex:i] objectForKey:@"Atbez"]]];
            }
            else
            {
                [tempArray addObject:@""];
                
            }
            
            if (![NullChecker isNull:[[parsedArray objectAtIndex:i] objectForKey:@"Msehi"]])
            {
                [tempArray addObject:[NSString stringWithFormat:@"%@",[[parsedArray objectAtIndex:i] objectForKey:@"Msehi"]]];
            }
            else
            {
                [tempArray addObject:@""];
                
            }
            
            
            if (![NullChecker isNull:[[parsedArray objectAtIndex:i] objectForKey:@"Msehl"]])
            {
                [tempArray addObject:[NSString stringWithFormat:@"%@",[[parsedArray objectAtIndex:i] objectForKey:@"Msehl"]]];
            }
            else
            {
                [tempArray addObject:@""];
                
            }
            
            if (![NullChecker isNull:[[parsedArray objectAtIndex:i] objectForKey:@"Readc"]])
            {
                [tempArray addObject:[NSString stringWithFormat:@"%@",[[parsedArray objectAtIndex:i] objectForKey:@"Readc"]]];
            }
            else
            {
                [tempArray addObject:@""];
                
            }
            
            if (![NullChecker isNull:[[parsedArray objectAtIndex:i] objectForKey:@"Desic"]])
            {
                [tempArray addObject:[NSString stringWithFormat:@"%@",[[parsedArray objectAtIndex:i] objectForKey:@"Desic"]]];
            }
            else
            {
                [tempArray addObject:@""];
                
            }
            
            if (![NullChecker isNull:[[parsedArray objectAtIndex:i] objectForKey:@"Prest"]])
            {
                [tempArray addObject:[NSString stringWithFormat:@"%@",[[parsedArray objectAtIndex:i] objectForKey:@"Prest"]]];
            }
            else
            {
                [tempArray addObject:@""];
                
            }
            
            if (![NullChecker isNull:[[parsedArray objectAtIndex:i] objectForKey:@"Docaf"]])
            {
                [tempArray addObject:[NSString stringWithFormat:@"%@",[[parsedArray objectAtIndex:i] objectForKey:@"Docaf"]]];
            }
            else
            {
                [tempArray addObject:@""];
                
            }
            
            if (![NullChecker isNull:[[parsedArray objectAtIndex:i] objectForKey:@"Codct"]])
            {
                [tempArray addObject:[NSString stringWithFormat:@"%@",[[parsedArray objectAtIndex:i] objectForKey:@"Codct"]]];
            }
            else
            {
                [tempArray addObject:@""];
                
            }
            
            if (![NullChecker isNull:[[parsedArray objectAtIndex:i] objectForKey:@"Codgr"]])
            {
                [tempArray addObject:[NSString stringWithFormat:@"%@",[[parsedArray objectAtIndex:i] objectForKey:@"Codgr"]]];
            }
            else
            {
                [tempArray addObject:@""];
                
            }
            
            if (![NullChecker isNull:[[parsedArray objectAtIndex:i] objectForKey:@"Vlcod"]])
            {
                [tempArray addObject:[NSString stringWithFormat:@"%@",[[parsedArray objectAtIndex:i] objectForKey:@"Vlcod"]]];
            }
            else
            {
                [tempArray addObject:@""];
                
            }
            
            if (![NullChecker isNull:[[parsedArray objectAtIndex:i] objectForKey:@"Action"]])
            {
                [tempArray addObject:[NSString stringWithFormat:@"%@",[[parsedArray objectAtIndex:i] objectForKey:@"Action"]]];
            }
            else
            {
                [tempArray addObject:@""];
                
            }
 
            [self.mesurementDocumentArray addObject:tempArray];
        }
    }
    
    else{
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"info" message:@"No Data Found" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        
        [alert show];
        
        if (self.mesurementDocumentArray==nil) {
            
            self.mesurementDocumentArray=[NSMutableArray new];
        }
        else{
            [self.mesurementDocumentArray removeAllObjects];
            
        }
        
          }
    
       [self.measurementDocTableView reloadData];
    
       }
            
        break;
            
        case MONITOR_SET_EQUIP_MDOCS:
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];

            if (!errorDescription.length) {
                
                 NSMutableDictionary *parsedDictionary =  [[Response sharedInstance] parseForSetMonitorMeasurementDocs:resultData];
                
                [MBProgressHUD hideHUDForView:self.view animated:YES];

                
                if ([parsedDictionary objectForKey:@"resultMonitorMdocs"]) {
                    
                    NSMutableArray *parsedArray=[NSMutableArray new];
                    
                    [parsedArray addObjectsFromArray:[parsedDictionary objectForKey:@"resultMonitorMdocs"]];
                    
                    if (self.mesurementDocumentArray==nil) {
                        
                        self.mesurementDocumentArray=[NSMutableArray new];
                    }
                    else{
                        [self.mesurementDocumentArray removeAllObjects];
                        
                    }
                    for (int i=0; i<[parsedArray count]; i++)
                    {
                        NSMutableArray *tempArray=[NSMutableArray new];
                        
                        [tempArray addObject:@""];
                        
                        if (![NullChecker isNull:[[parsedArray objectAtIndex:i] objectForKey:@"Qmnum"]])
                        {
                            [tempArray addObject:[NSString stringWithFormat:@"%@",[[parsedArray objectAtIndex:i] objectForKey:@"Qmnum"]]];//0vornr
                            
                        }
                        else
                        {
                            [tempArray addObject:@""];//0vornr
                            
                        }
                        
                        
                        if (![NullChecker isNull:[[parsedArray objectAtIndex:i] objectForKey:@"Aufnr"]])
                        {
                            
                            [tempArray addObject:[NSString stringWithFormat:@"%@",[[parsedArray objectAtIndex:i] objectForKey:@"Aufnr"]]];
                            
                        }
                        else
                        {
                            [tempArray addObject:@""];
                            
                        }
                        
                        
                        
                        if (![NullChecker isNull:[[parsedArray objectAtIndex:i] objectForKey:@"Vornr"]])
                        {
                            
                            [tempArray addObject:[NSString stringWithFormat:@"%@",[[parsedArray objectAtIndex:i] objectForKey:@"Vornr"]]];
                            
                        }
                        else
                        {
                            [tempArray addObject:@""];
                            
                        }
                        
                        
                        
                        if (![NullChecker isNull:[[parsedArray objectAtIndex:i] objectForKey:@"Mdocm"]])
                        {
                            
                            [tempArray addObject:[NSString stringWithFormat:@"%@",[[parsedArray objectAtIndex:i] objectForKey:@"Mdocm"]]];
                        }
                        else
                        {
                            [tempArray addObject:@""];
                            
                        }
                        
                        if (![NullChecker isNull:[[parsedArray objectAtIndex:i] objectForKey:@"Point"]])
                        {
                            [tempArray addObject:[NSString stringWithFormat:@"%@",[[parsedArray objectAtIndex:i] objectForKey:@"Point"]]];
                        }
                        else
                        {
                            [tempArray addObject:@""];
                        }
                        
                        if (![NullChecker isNull:[[parsedArray objectAtIndex:i] objectForKey:@"Mpobj"]])
                        {
                            [tempArray addObject:[NSString stringWithFormat:@"%@",[[parsedArray objectAtIndex:i] objectForKey:@"Mpobj"]]];
                        }
                        else
                        {
                            [tempArray addObject:@""];
                        }
                        
                        if (![NullChecker isNull:[[parsedArray objectAtIndex:i] objectForKey:@"Mpobt"]])
                        {
                            [tempArray addObject:[NSString stringWithFormat:@"%@",[[parsedArray objectAtIndex:i] objectForKey:@"Mpobt"]]];
                        }
                        else
                        {
                            [tempArray addObject:@""];
                        }
                        
                        if (![NullChecker isNull:[[parsedArray objectAtIndex:i] objectForKey:@"Psort"]])
                        {
                            [tempArray addObject:[NSString stringWithFormat:@"%@",[[parsedArray objectAtIndex:i] objectForKey:@"Psort"]]];
                        }
                        else
                        {
                            [tempArray addObject:@""];
                            
                        }
                        
                        if (![NullChecker isNull:[[parsedArray objectAtIndex:i] objectForKey:@"Pttxt"]])
                        {
                            [tempArray addObject:[NSString stringWithFormat:@"%@",[[parsedArray objectAtIndex:i] objectForKey:@"Pttxt"]]];
                        }
                        else
                        {
                            [tempArray addObject:@""];
                            
                        }
                        
                        if (![NullChecker isNull:[[parsedArray objectAtIndex:i] objectForKey:@"Atinn"]])
                        {
                            [tempArray addObject:[NSString stringWithFormat:@"%@",[[parsedArray objectAtIndex:i] objectForKey:@"Atinn"]]];
                        }
                        else
                        {
                            [tempArray addObject:@""];
                            
                        }
                        
                        if (![NullChecker isNull:[[parsedArray objectAtIndex:i] objectForKey:@"Idate"]])
                        {
                            [tempArray addObject:[NSString stringWithFormat:@"%@",[[parsedArray objectAtIndex:i] objectForKey:@"Idate"]]];
                        }
                        else
                        {
                            [tempArray addObject:@""];
                            
                        }
                        
                        if (![NullChecker isNull:[[parsedArray objectAtIndex:i] objectForKey:@"Itime"]])
                        {
                            [tempArray addObject:[NSString stringWithFormat:@"%@",[[parsedArray objectAtIndex:i] objectForKey:@"Itime"]]];
                        }
                        else
                        {
                            [tempArray addObject:@""];
                            
                        }
                        
                        if (![NullChecker isNull:[[parsedArray objectAtIndex:i] objectForKey:@"Mdtxt"]])
                        {
                            [tempArray addObject:[NSString stringWithFormat:@"%@",[[parsedArray objectAtIndex:i] objectForKey:@"Mdtxt"]]];
                        }
                        else
                        {
                            [tempArray addObject:@""];
                            
                        }
                        
                        if (![NullChecker isNull:[[parsedArray objectAtIndex:i] objectForKey:@"Readr"]])
                        {
                            [tempArray addObject:[NSString stringWithFormat:@"%@",[[parsedArray objectAtIndex:i] objectForKey:@"Readr"]]];
                        }
                        else
                        {
                            [tempArray addObject:@""];
                            
                        }
                        
                        if (![NullChecker isNull:[[parsedArray objectAtIndex:i] objectForKey:@"Atbez"]])
                        {
                            [tempArray addObject:[NSString stringWithFormat:@"%@",[[parsedArray objectAtIndex:i] objectForKey:@"Atbez"]]];
                        }
                        else
                        {
                            [tempArray addObject:@""];
                            
                        }
                        
                        if (![NullChecker isNull:[[parsedArray objectAtIndex:i] objectForKey:@"Msehi"]])
                        {
                            [tempArray addObject:[NSString stringWithFormat:@"%@",[[parsedArray objectAtIndex:i] objectForKey:@"Msehi"]]];
                        }
                        else
                        {
                            [tempArray addObject:@""];
                            
                        }
                        
                        
                        if (![NullChecker isNull:[[parsedArray objectAtIndex:i] objectForKey:@"Msehl"]])
                        {
                            [tempArray addObject:[NSString stringWithFormat:@"%@",[[parsedArray objectAtIndex:i] objectForKey:@"Msehl"]]];
                        }
                        else
                        {
                            [tempArray addObject:@""];
                            
                        }
                        
                        if (![NullChecker isNull:[[parsedArray objectAtIndex:i] objectForKey:@"Readc"]])
                        {
                            [tempArray addObject:[NSString stringWithFormat:@"%@",[[parsedArray objectAtIndex:i] objectForKey:@"Readc"]]];
                        }
                        else
                        {
                            [tempArray addObject:@""];
                            
                        }
                        
                        if (![NullChecker isNull:[[parsedArray objectAtIndex:i] objectForKey:@"Desic"]])
                        {
                            [tempArray addObject:[NSString stringWithFormat:@"%@",[[parsedArray objectAtIndex:i] objectForKey:@"Desic"]]];
                        }
                        else
                        {
                            [tempArray addObject:@""];
                            
                        }
                        
                        if (![NullChecker isNull:[[parsedArray objectAtIndex:i] objectForKey:@"Prest"]])
                        {
                            [tempArray addObject:[NSString stringWithFormat:@"%@",[[parsedArray objectAtIndex:i] objectForKey:@"Prest"]]];
                        }
                        else
                        {
                            [tempArray addObject:@""];
                            
                        }
                        
                        if (![NullChecker isNull:[[parsedArray objectAtIndex:i] objectForKey:@"Docaf"]])
                        {
                            [tempArray addObject:[NSString stringWithFormat:@"%@",[[parsedArray objectAtIndex:i] objectForKey:@"Docaf"]]];
                        }
                        else
                        {
                            [tempArray addObject:@""];
                            
                        }
                        
                        if (![NullChecker isNull:[[parsedArray objectAtIndex:i] objectForKey:@"Codct"]])
                        {
                            [tempArray addObject:[NSString stringWithFormat:@"%@",[[parsedArray objectAtIndex:i] objectForKey:@"Codct"]]];
                        }
                        else
                        {
                            [tempArray addObject:@""];
                            
                        }
                        
                        if (![NullChecker isNull:[[parsedArray objectAtIndex:i] objectForKey:@"Codgr"]])
                        {
                            [tempArray addObject:[NSString stringWithFormat:@"%@",[[parsedArray objectAtIndex:i] objectForKey:@"Codgr"]]];
                        }
                        else
                        {
                            [tempArray addObject:@""];
                            
                        }
                        
                        if (![NullChecker isNull:[[parsedArray objectAtIndex:i] objectForKey:@"Vlcod"]])
                        {
                            [tempArray addObject:[NSString stringWithFormat:@"%@",[[parsedArray objectAtIndex:i] objectForKey:@"Vlcod"]]];
                        }
                        else
                        {
                            [tempArray addObject:@""];
                            
                        }
                        
                        if (![NullChecker isNull:[[parsedArray objectAtIndex:i] objectForKey:@"Action"]])
                        {
                            [tempArray addObject:[NSString stringWithFormat:@"%@",[[parsedArray objectAtIndex:i] objectForKey:@"Action"]]];
                        }
                        else
                        {
                            [tempArray addObject:@""];
                            
                        }
                        
                        //[self.mesurementDocumentArray addObject:tempArray];
                    }
                    
                    NSString *messageCompare;
                    
                    NSArray *messageArray = [[parsedDictionary objectForKey:@"MESSAGE"] componentsSeparatedByString:@" "];
                    
                    if ([[[messageArray firstObject] uppercaseString] isEqualToString:@"S"]) {
                        
                        messageCompare = [[parsedDictionary objectForKey:@"MESSAGE"] substringFromIndex:1];
                        
                    }
 
                    [self showAlertMessageWithTitle:@"Success" message:[[parsedDictionary objectForKey:@"MESSAGE"] substringFromIndex:1] cancelButtonTitle:@"OK" withactionType:@"Single" forMethod:nil];
                    
                }
                
                else if ([parsedDictionary objectForKey:@"MESSAGE"])
                {
                    
                    [self showAlertMessageWithTitle:@"info" message:[[parsedDictionary objectForKey:@"MESSAGE"] substringFromIndex:1] cancelButtonTitle:@"OK" withactionType:@"Single" forMethod:nil];
                    
                 }
                
            }
            
            else{
                
                 [self showAlertMessageWithTitle:@"Information" message:errorDescription cancelButtonTitle:@"OK" withactionType:@"Single" forMethod:nil];

            }
            
            
            break;
            
        default: break;
            
            
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
