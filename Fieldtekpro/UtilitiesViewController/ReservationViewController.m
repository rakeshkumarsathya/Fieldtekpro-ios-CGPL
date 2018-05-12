//
//  ReservationViewController.m
//  Fieldtekpro
//
//  Created by Sathya Rakesh Kumar on 07/12/17.
//  Copyright © 2017 Enstrapp Bangalore. All rights reserved.
//

#import "ReservationViewController.h"

@interface ReservationViewController ()<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>
@end

@implementation ReservationViewController

@synthesize defaults;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    movementTypeID = [NSMutableString new];
    costCenterID= [NSMutableString new];
 
    [self setRightView:requirementDateTextfield withImage:@"calendar"];
    [self setRightView:movementTypeTextfield withImage:@"dropdown"];
    [self setRightView:costCenterTextfield withImage:@"dropdown"];
    
    defaults=[NSUserDefaults standardUserDefaults];
    
    self.dropDownArray=[NSMutableArray new];
    
    if (self.detailBomDetailsArray.count) {
        
        if (self.plantValueString.length) {
            
            plantTextfield.text=self.plantValueString;
 
        }
     }
    
    NSString *str_UserNameDep = [defaults objectForKey:@"userName"];
    
    decryptedUserName = [str_UserNameDep AES128DecryptWithKey:@""];
    
     NSDateFormatter *dateformatter=[[NSDateFormatter alloc]init];
     [dateformatter setDateFormat:@"MMM dd, yyyy"];
     requirementDateTextfield.text=[dateformatter stringFromDate:[NSDate date]];
     quantityTextField.text=@"1";
    
 
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void)setRightView:(UITextField *)textField withImage:(NSString *)imageview
{
    arrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",imageview]]];
    arrow.frame = CGRectMake(0.0, 0.0, arrow.image.size.width+10.0, arrow.image.size.height);
    arrow.contentMode = UIViewContentModeCenter;
    
    textField.rightView = arrow;
    textField.rightViewMode = UITextFieldViewModeAlways;
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

-(void)pickerTableViewCancelClicked
{
    
    [movementTypeTextfield resignFirstResponder];
    [costCenterTextfield resignFirstResponder];
}

#pragma mark
#pragma mark - TableView Delegate Methods

//table view methods strats here

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;              // Default is 1 if not implemented
{
    
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (tableView==self.dropDownTableView) {
        return self.dropDownArray.count;
    }
    
    return 1;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.accessoryType=UITableViewCellAccessoryNone;
    
    if (tableView==self.dropDownTableView) {
        
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
        
        else{
            
             cell.textLabel.text = [NSString stringWithFormat:@"%@-%@",[[self.dropDownArray objectAtIndex:indexPath.row] objectAtIndex:ID_INDEX],[[self.dropDownArray objectAtIndex:indexPath.row] objectAtIndex:NAME_INDEX]];
            
        }
        
        return cell;
    }
    
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
     if (tableView == self.dropDownTableView) {
        
        switch ([self.dropDownTableView tag]) {
                
            case BOMMOVEMENTTYPE:
                
                movementTypeTextfield.text = [NSString stringWithFormat:@"%@",[[self.dropDownArray objectAtIndex:indexPath.row] objectAtIndex:ID_INDEX]];
                
                [movementTypeID setString:[[self.dropDownArray objectAtIndex:indexPath.row] objectAtIndex:NAME_INDEX]];
                
//                if ([movementTypeID isEqualToString:@"201"]) {
//
//                    orderNumberView.hidden=YES;
//                   }
//
//                else{
//                     orderNumberView.hidden=NO;
//                 }
 
                [movementTypeTextfield resignFirstResponder];
                
                break;
                
            case BOMCOSTCENTER:
                
                [costCenterID setString:[[self.dropDownArray objectAtIndex:indexPath.row] objectAtIndex:ID_INDEX]];
                
                costCenterTextfield.text = [NSString stringWithFormat:@"%@",[[self.dropDownArray objectAtIndex:indexPath.row] objectAtIndex:NAME_INDEX]];
                
                [costCenterTextfield resignFirstResponder];
                
                break;
                
            default:break;
        }
    }
    
}

#pragma mark-
#pragma mark-Date Picker for Text Field

//for Datepicker.
-(void)datePickerForRequirementDate{
    
    self.requirementDatePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, 250, 0, 0)];
    
    self.requirementDatePicker.datePickerMode = UIDatePickerModeDateAndTime;
    
    requirementDateTextfield.inputView =self.requirementDatePicker;
    
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
    
    requirementDateTextfield.inputAccessoryView = myDatePickerToolBar;
}


-(void)pickerDoneStartDateClicked
{
    self.minStartDate =[self.requirementDatePicker date];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"MMM dd, yyyy"];
    
    requirementDateTextfield.text = [dateFormat stringFromDate:self.minStartDate];
    
    [requirementDateTextfield resignFirstResponder];
    
    [requirementDateTextfield resignFirstResponder];
    if (![requirementDateTextfield.text isEqual:@""])
    {
        dateFlag = YES;
        
        //[self compare];
    }
}

-(void)pickerCancelClicked
{
    if (dateFlag == YES)
    {
        requirementDateTextfield.text = @"";
    }
    else if (dateFlag == NO)
    {
        requirementDateTextfield.text = @"";
    }
    
    [requirementDateTextfield resignFirstResponder];
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    [self.dropDownArray removeAllObjects];
 
    if (textField == movementTypeTextfield) {
        [[movementTypeTextfield valueForKey:@"textInputTraits"] setValue:[UIColor clearColor] forKey:@"insertionPointColor"];
        
        [self uiPickerTableViewForDropDownSelection];
        
        movementTypeTextfield.inputView = self.dropDownTableView;
        movementTypeTextfield.inputAccessoryView = self.mypickerToolbar;
        
        self.dropDownTableView.tag = BOMMOVEMENTTYPE;
        
        [self.dropDownArray addObjectsFromArray:[[DataBase sharedInstance] getListOfMovementTypes]];
        
        [self.dropDownTableView reloadData];
    }
    else if (textField == costCenterTextfield)
    {
        [[costCenterTextfield valueForKey:@"textInputTraits"] setValue:[UIColor clearColor] forKey:@"insertionPointColor"];
        [self uiPickerTableViewForDropDownSelection];
        
        costCenterTextfield.inputView = self.dropDownTableView;
        costCenterTextfield.inputAccessoryView = self.mypickerToolbar;
        
        self.dropDownTableView.tag = BOMCOSTCENTER;
         [self.dropDownArray addObjectsFromArray:[[DataBase sharedInstance] getCostCentersList:self.plantValueString]];
 
        [self.dropDownTableView reloadData];
    }
    else if (textField==requirementDateTextfield)
    {
        [self datePickerForRequirementDate];
    }
    
    return YES;
}



-(void)materialAailabilityCheckforStocks{
    
    NSMutableDictionary *dictionarySearch = [[NSMutableDictionary alloc]init];
    
    //    if (_plantTextField.text.length) {
    [dictionarySearch setObject:[plantTextfield.text copy] forKey:@"PLANT"];
    //    }
    //    else{
    //        [dictionarySearch setObject:@"" forKey:@"PLANT"];
    //    }
    
    //    for (int i=0; i<[selectedCheckBoxArray count]; i++) {
    
    [dictionarySearch setObject:[[[self.detailBomDetailsArray objectAtIndex:0] objectForKey:@"lgort"] copy] forKey:@"STORAGELOCATION"];
    [dictionarySearch setObject:[[[self.detailBomDetailsArray objectAtIndex:0] objectForKey:@"matnr"] copy] forKey:@"MATERIAL"];
    [dictionarySearch setObject:[quantityTextField.text copy] forKey:@"QUANTITY"];
    
    //    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMM dd, yyyy"];
    NSDate *startDate = [dateFormatter dateFromString:requirementDateTextfield.text];
    // Convert date object into desired format
    [dateFormatter setDateFormat:@"yyyyMMdd"];
    NSString *convertedStartDateString = [dateFormatter stringFromDate:startDate];
    if ([NullChecker isNull:convertedStartDateString]) {
        [dictionarySearch setObject:[dateFormatter stringFromDate:[NSDate date]] forKey:@"RDATE"];
    }
    else{
        [dictionarySearch setObject:convertedStartDateString forKey:@"RDATE"];
    }
    
    if([[ConnectionManager defaultManager] isReachable])
    {
        hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeDeterminate;
        hud.label.text = @"Availability check in progress…";
        
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"CSRF"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [dictionarySearch setObject:@"MC" forKey:@"ACTIVITY"];
        [dictionarySearch setObject:@"C6" forKey:@"DOCTYPE"];
        [dictionarySearch setObject:[defaults objectForKey:@"ENDPOINT"] forKey:@"ENDPOINT"];
        NSArray *endPointArray = [[DataBase sharedInstance] getEndPointURL:dictionarySearch];
        NSLog(@"endPoint :%@",[[endPointArray objectAtIndex:0] objectAtIndex:0]);
        [dictionarySearch setObject:[[endPointArray objectAtIndex:0] objectAtIndex:0] forKey:@"URL_ENDPOINT"];
        [dictionarySearch setObject:decryptedUserName forKey:@"REPORTEDBY"];
        [Request makeWebServiceRequest:GET_MATERIAL_AVAILABILITY_CHECK parameters:dictionarySearch delegate:self];
    }
    else
    {
        [MBProgressHUD hideHUDForView:self.view animated:YES];

        [self showAlertMessageWithTitle:@"No Network Available" message:@"Availability check cannot be performed!" cancelButtonTitle:@"Ok" withactionType:@"Single" forMethod:nil];
        
    }
    
}

-(void)submitStockReserve
{
    if (!reserveStockHeaderDictionary)
    {
        reserveStockHeaderDictionary = [NSMutableDictionary new];
    }
    else
    {
        [reserveStockHeaderDictionary removeAllObjects];
    }
    
    [reserveStockHeaderDictionary setObject:[movementTypeID copy] forKey:@"MOVEMENT"];
    
    if([NullChecker isNull:costCenterID]){
        [costCenterID setString:costCenterTextfield.text];
    }
    
    [reserveStockHeaderDictionary setObject:[plantTextfield.text copy] forKey:@"PLANT"];
    [reserveStockHeaderDictionary setObject:[costCenterID copy] forKey:@"CCENTER"];
    [reserveStockHeaderDictionary setObject:[orderNumberTextfield.text copy] forKey:@"ORDERNO"];
    
    
    NSString *str_UserNameDep = [defaults objectForKey:@"userName"];
    decryptedUserName = [str_UserNameDep AES128DecryptWithKey:@""];
    
    [reserveStockHeaderDictionary setObject:[decryptedUserName copy] forKey:@"REPORTEDBY"];
    NSMutableArray *reserveTransactionDetails = [NSMutableArray new];
    NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
    [timeFormatter setDateFormat:@"HH:mm:ss"];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMM dd, yyyy"];
    NSDate *requiredDate = [dateFormatter dateFromString:requirementDateTextfield.text];
    // Convert date object into desired format
    [dateFormatter setDateFormat:@"yyyyMMdd"];
    NSString *convertedRequiredDateString = [dateFormatter stringFromDate:requiredDate];
    if ([NullChecker isNull:convertedRequiredDateString]) {
        convertedRequiredDateString = @"";
    }
    
    if ([quantityTextField.text isEqualToString:@"0"] || [quantityTextField.text isEqualToString:@"00"] || [quantityTextField.text isEqualToString:@""]) {
        quantityTextField.text = @"1";
    }
    
    
    [reserveTransactionDetails addObject:[NSMutableArray arrayWithObjects:[[[self.detailBomDetailsArray objectAtIndex:0] objectForKey:@"matnr"] copy],quantityTextField.text,@"",[NSString stringWithFormat:@"%@",convertedRequiredDateString],[[[self.detailBomDetailsArray objectAtIndex:0] objectForKey:@"lgort"] copy], nil]];
    
    if ([[DataBase sharedInstance] insertUtilityReserveDetail:reserveStockHeaderDictionary withTransactions:reserveTransactionDetails]) {
        
        if ([[ConnectionManager defaultManager] isReachable]) {
            if ([[ConnectionManager defaultManager] isConnectionQueueIsActive]) {
                [[ConnectionManager defaultManager] stopCurrentConnetion];
            }
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
 
            hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDAnimationFade;
            hud.label.text = @"Reservation in progress...";
            
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"CSRF"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [reserveStockHeaderDictionary setObject:reserveTransactionDetails forKey:@"ITEMS"];
            [reserveStockHeaderDictionary setObject:@"R" forKey:@"ACTIVITY"];
            [reserveStockHeaderDictionary setObject:@"R" forKey:@"DOCTYPE"];
            [reserveStockHeaderDictionary setObject:[defaults objectForKey:@"ENDPOINT"] forKey:@"ENDPOINT"];
            NSArray *endPointArray = [[DataBase sharedInstance] getEndPointURL:reserveStockHeaderDictionary];
            
            [reserveStockHeaderDictionary setObject:[[endPointArray objectAtIndex:0] objectAtIndex:0] forKey:@"URL_ENDPOINT"];
             [reserveStockHeaderDictionary setObject:@"" forKey:@"TRANSMITTYPE"];
             [Request makeWebServiceRequest:UTILITY_RESERVE parameters:reserveStockHeaderDictionary delegate:self];
        }
        else
        {
            [self.navigationController popViewControllerAnimated:YES];
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
 
            if ([[defaults objectForKey:@"ACTIVATELOGS"] isEqualToString:@"X"])
            {
                
                [[DataBase sharedInstance] writToLogFile:[NSString stringWithFormat:@"#INFO#.com.enstrapp.fieldtekpro#Utilities #Activity:STOCK reservation #Mode:Offline #Class: Very Important #MUser:%@ #DeviceId:%@",decryptedUserName,[defaults objectForKey:@"edeviceid"]]];
            }
            
         }
    }
}


-(void)materialAailabilityCheck{
    
    NSMutableDictionary *dictionarySearch = [[NSMutableDictionary alloc]init];
    
    [dictionarySearch setObject:[plantTextfield.text copy] forKey:@"PLANT"];
    
    [dictionarySearch setObject:[[[self.detailBomDetailsArray objectAtIndex:0] objectForKey:@"bomcomponent"] copy] forKey:@"MATERIAL"];
    
    NSArray *getLgort = [[DataBase sharedInstance] getStorageLocationFromMaterialNo:[[self.detailBomDetailsArray objectAtIndex:0] objectForKey:@"bomcomponent"]];
    
    if ([getLgort count]) {
        
        [dictionarySearch setObject:[[[getLgort objectAtIndex:0] objectForKey:@"lgort"] copy] forKey:@"STORAGELOCATION"];
    }
    else{
        
        [dictionarySearch setObject:@"" forKey:@"STORAGELOCATION"];
    }
    
    [dictionarySearch setObject:[quantityTextField.text copy] forKey:@"QUANTITY"];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMM dd, yyyy"];
    NSDate *startDate = [dateFormatter dateFromString:requirementDateTextfield.text];
    // Convert date object into desired format
    [dateFormatter setDateFormat:@"yyyyMMdd"];
    NSString *convertedStartDateString = [dateFormatter stringFromDate:startDate];
    if ([NullChecker isNull:convertedStartDateString]) {
        [dictionarySearch setObject:[dateFormatter stringFromDate:[NSDate date]] forKey:@"RDATE"];
    }
    else{
        [dictionarySearch setObject:convertedStartDateString forKey:@"RDATE"];
    }
    
    if([[ConnectionManager defaultManager] isReachable])
    {
         hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDAnimationFade;
        hud.label.text = @"Availability check in progress…";
        
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"CSRF"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [dictionarySearch setObject:@"MC" forKey:@"ACTIVITY"];
        [dictionarySearch setObject:@"C6" forKey:@"DOCTYPE"];
        [dictionarySearch setObject:[defaults objectForKey:@"ENDPOINT"] forKey:@"ENDPOINT"];
        NSArray *endPointArray = [[DataBase sharedInstance] getEndPointURL:dictionarySearch];
        NSLog(@"endPoint :%@",[[endPointArray objectAtIndex:0] objectAtIndex:0]);
        [dictionarySearch setObject:[[endPointArray objectAtIndex:0] objectAtIndex:0] forKey:@"URL_ENDPOINT"];
        
        [dictionarySearch setObject:decryptedUserName forKey:@"REPORTEDBY"];
        
        [Request makeWebServiceRequest:GET_MATERIAL_AVAILABILITY_CHECK parameters:dictionarySearch delegate:self];
    }
    else
    {
        [MBProgressHUD hideHUDForView:self.view animated:YES];

 
        [self showAlertMessageWithTitle:@"No Network Available" message:@"Availability check cannot be performed!" cancelButtonTitle:@"Ok" withactionType:@"Single" forMethod:nil];
        
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
                                        if ([methodNameString isEqualToString:@"Reservation"])
                                        {
                                            
                                            NSMutableArray *labstArray=[NSMutableArray new];
                                            
                                            if ([self.stockSelectedString isEqualToString:@"X"]) {
                                                
                                                [self materialAailabilityCheckforStocks];
                                               
                                            }
                                            else{
                                                
                            
                                                labstArray=[[DataBase sharedInstance] fetchStocksDataFromBomItem:[[self.detailBomDetailsArray objectAtIndex:0] objectForKey:@"bomcomponent"]];
                                                if ([labstArray count]) {
                                                    
                                                    storageLocationString=[[labstArray objectAtIndex:0] objectForKey:@"lgort"];
                                                 }
                                                
                                                if ([[ConnectionManager defaultManager] isReachable]) {
                                                    
                                                    if ([labstArray count]) {
                                                        
                                                        if ([[labstArray objectAtIndex:0] objectForKey:@"labst"]>0) {
                                                            
                                                            [self materialAailabilityCheck];
                                                            
                                                        }
                                                        else{
                                                            
                                                            
                                                            [self showAlertMessageWithTitle:@"Error" message:[NSString stringWithFormat:@"Material No %@ for Quantity %@ Not available on %@",[[self.detailBomDetailsArray objectAtIndex:0] objectForKey:@"bomcomponent"],quantityTextField.text,requirementDateTextfield.text] cancelButtonTitle:@"Ok" withactionType:@"Single" forMethod:@"Reserve Fail"];
                                                        }
                                                    }
                                                    
                                                    else{
                                                        
                                    [self showAlertMessageWithTitle:@"Information" message:@"Storage Location Not found" cancelButtonTitle:@"ok" withactionType:@"Single" forMethod:nil];
                                                     }
                                                 }
                                                else{
                                                    
                                                    [self submitReserve];
                                                }
                                              }
                                           }
 
                                        // call method whatever u need
                                    }];
        
        UIAlertAction* noButton = [UIAlertAction actionWithTitle:cancelBtnTitle
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * action)
                                     {
 
                                       if ([methodNameString isEqualToString:@"Reserve Sucess"])
                                       {
                                            [self submitReserve];
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
                                       
                                       else if ([methodNameString isEqualToString:@"Reserve Fail"]){
                                           
                                           [MBProgressHUD hideHUDForView:self.view animated:YES];
 
                                       }
                                       
                                       else if ([methodNameString isEqualToString:@"Reserve"]){
                                          
                                           [self.navigationController popViewControllerAnimated:YES];
 
                                       }
 
                                   }];
        
        [alert addAction:okButton];
        
        [self presentViewController:alert animated:YES completion:nil];
        
    }
}

-(IBAction)plantReservationBtn:(id)sender
{
    if(![JEValidator validateTextValue:movementTypeTextfield.text])
    {
       
        [self showAlertMessageWithTitle:@"Information" message:@"Please select Movement type" cancelButtonTitle:@"ok" withactionType:@"Single" forMethod:nil];
        
    }
    else if (![JEValidator validateTextValue:costCenterTextfield.text] && ![JEValidator validateTextValue:orderNumberTextfield.text]){
 
        [self showAlertMessageWithTitle:@"Information" message:@"Please enter either order or cost center" cancelButtonTitle:@"ok" withactionType:@"Single" forMethod:nil];
     }
    else
    {
     
        [self showAlertMessageWithTitle:@"Decision" message:@"Do you want to perform Reservation?" cancelButtonTitle:@"No" withactionType:@"Multiple" forMethod:@"Reservation"];
     }
}

-(void)submitReserve
{
    if (!reserveHeaderDictionary)
    {
        reserveHeaderDictionary = [[NSMutableDictionary alloc] init];
    }
    else{
        [reserveHeaderDictionary removeAllObjects];
    }
    
    [reserveHeaderDictionary setObject:[movementTypeID copy] forKey:@"MOVEMENT"];
    
    
    if([NullChecker isNull:costCenterID])
    {
        [costCenterID setString: costCenterTextfield.text];
    }
    [reserveHeaderDictionary setObject:[plantTextfield.text copy] forKey:@"PLANT"];
    [reserveHeaderDictionary setObject:[costCenterID copy] forKey:@"CCENTER"];
    [reserveHeaderDictionary setObject:[orderNumberTextfield.text copy] forKey:@"ORDERNO"];
    
 
    [reserveHeaderDictionary setObject:[decryptedUserName copy] forKey:@"REPORTEDBY"];
    
    NSMutableArray *reserveTransactionDetails = [NSMutableArray new];
    
    NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
    [timeFormatter setDateFormat:@"HH:mm:ss"];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMM dd, yyyy"];
    NSDate *requiredDate = [dateFormatter dateFromString:requirementDateTextfield.text];
    // Convert date object into desired format
    [dateFormatter setDateFormat:@"yyyyMMdd"];
    NSString *convertedRequiredDateString = [dateFormatter stringFromDate:requiredDate];
    if ([NullChecker isNull:convertedRequiredDateString]) {
        convertedRequiredDateString = @"";
    }
    
    //    for (int i=0; i<[selectedCheckBoxArray count]; i++) {
    //
    //        int rowIndex = [[selectedCheckBoxArray objectAtIndex:i] intValue];
    //        [reserveTransactionDetails addObject:[NSMutableArray arrayWithObjects:[[[self.bomDetailListArray objectAtIndex:rowIndex] objectForKey:@"bomcomponent"] copy],[quantityTextField.text copy],[[[self.bomDetailListArray objectAtIndex:rowIndex] objectForKey:@"unit"] copy],[NSString stringWithFormat:@"%@ %@",convertedRequiredDateString,[timeFormatter stringFromDate:[NSDate date]]], nil]];
    //    }
 
    
    [reserveTransactionDetails addObject:[NSMutableArray arrayWithObjects:[[[self.detailBomDetailsArray objectAtIndex:0] objectForKey:@"bomcomponent"] copy],[quantityTextField.text copy],[[[self.detailBomDetailsArray objectAtIndex:0] objectForKey:@"unit"] copy],[NSString stringWithFormat:@"%@",convertedRequiredDateString],storageLocationString, nil]];
    
 
    if ([[DataBase sharedInstance] insertUtilityReserveDetail:reserveHeaderDictionary withTransactions:reserveTransactionDetails])
    {
          if ([[ConnectionManager defaultManager] isReachable])
           {
            
            if ([[ConnectionManager defaultManager] isConnectionQueueIsActive]) {
                [[ConnectionManager defaultManager] stopCurrentConnetion];
            }
            
               hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
               hud.mode = MBProgressHUDAnimationFade;
               hud.label.text = @"Reservation in progress...";
               
               [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"CSRF"];
               [[NSUserDefaults standardUserDefaults] synchronize];
               
 
            [reserveHeaderDictionary setObject:reserveTransactionDetails forKey:@"ITEMS"];
            [reserveHeaderDictionary setObject:@"R" forKey:@"ACTIVITY"];
            [reserveHeaderDictionary setObject:@"R" forKey:@"DOCTYPE"];
            [reserveHeaderDictionary setObject:[defaults objectForKey:@"ENDPOINT"] forKey:@"ENDPOINT"];
            NSArray *endPointArray = [[DataBase sharedInstance] getEndPointURL:reserveHeaderDictionary];
            [reserveHeaderDictionary setObject:[[endPointArray objectAtIndex:0] objectAtIndex:0] forKey:@"URL_ENDPOINT"];
            
            [reserveHeaderDictionary setObject:@"" forKey:@"TRANSMITTYPE"];
            
            [Request makeWebServiceRequest:UTILITY_RESERVE parameters:reserveHeaderDictionary delegate:self];
        }
        else
        {
            
            if ([[defaults objectForKey:@"ACTIVATELOGS"] isEqualToString:@"X"])
            {
                 [[DataBase sharedInstance] writToLogFile:[NSString stringWithFormat:@"#INFO#.com.enstrapp.fieldtekpro#Utilities #Activity:BOM reservation #Mode:Offline #Class: Very Important #MUser:%@ #DeviceId:%@",decryptedUserName,[defaults objectForKey:@"edeviceid"]]];
            }
            
            [self.navigationController popViewControllerAnimated:YES];
 
         }
    }
}

-(IBAction)backButtonClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark-
#pragma mark- UITextField Delegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
 
    return TRUE;
}

-(void)resultData:(NSDictionary *)resultData withErrorDescription:(NSString *)errorDescription requestID:(WebServiceRequest)requestID :(int)statusCode
{
    switch (requestID) {
 
      case UTILITY_RESERVE:

      if (statusCode == 401)
      {
    
          [MBProgressHUD hideHUDForView:self.view animated:YES];
 
          [self showAlertMessageWithTitle:@"Authentication Failed!!" message:@"kindly check your password" cancelButtonTitle:@"Ok" withactionType:@"Single" forMethod:nil];
 
         return;
     }

    if (!errorDescription.length) {
    
    NSMutableDictionary *resultDictionary = [[Response sharedInstance] parseForUtilityReserve:(NSMutableDictionary *)resultData];
    
    if ([resultDictionary objectForKey:@"RESNUM"]) {
        
        [[DataBase sharedInstance] updateSyncLogForCategory:@"Reservation" action:@"Reserve" objectid:[resultDictionary objectForKey:@"RESNUM"] UUID:[reserveHeaderDictionary objectForKey:@"ID"]];
 
        [self showAlertMessageWithTitle:@"Information" message:[[resultDictionary objectForKey:@"Message"] substringFromIndex:1] cancelButtonTitle:@"Ok" withactionType:@"Single" forMethod:@"Reserve"];
        
        
        if ([[defaults objectForKey:@"ACTIVATELOGS"] isEqualToString:@"X"])
        {
            [[DataBase sharedInstance] writToLogFile:[NSString stringWithFormat:@"#INFO#.com.enstrapp.fieldtekpro#Utilities #Activity:BOM reservation #Resno:%@ #Mode:Online #Class: Very Important #MUser:%@ #DeviceId:%@",[[resultDictionary objectForKey:@"RESNUM"]objectAtIndex:0],decryptedUserName,[defaults objectForKey:@"edeviceid"]]];
        }
        
     }
    else if ([resultDictionary objectForKey:@"Message"]) {
        
       
        [[DataBase sharedInstance] updateSyncLogErrorForCategory:@"Reservation" action:@"Reserve" objectid:[resultDictionary objectForKey:@"RESNUM"] UUID:[reserveHeaderDictionary objectForKey:@"ID"] message:[[resultDictionary objectForKey:@"Message"] substringFromIndex:0]];
 
            [self showAlertMessageWithTitle:@"Information" message:[[resultDictionary objectForKey:@"Message"] substringFromIndex:0] cancelButtonTitle:@"Ok" withactionType:@"Single" forMethod:@"Reserve Sucess"];
     }
    else if ([resultDictionary objectForKey:@"ERROR"])
    {
 
        [self showAlertMessageWithTitle:@"Information" message:[resultDictionary objectForKey:@"ERROR"] cancelButtonTitle:@"Ok" withactionType:@"Single" forMethod:nil];
        
    }
    else{
        
        [[DataBase sharedInstance] updateSyncLogErrorForCategory:@"Reservation" action:@"Reserve" objectid:@"" UUID:[reserveHeaderDictionary objectForKey:@"ID"] message:NSLocalizedString(@"ErrorMessage", nil)];
    }
    
         [MBProgressHUD hideHUDForView:self.view animated:YES];
 
    }

   else
   {
       [MBProgressHUD hideHUDForView:self.view animated:YES];

   }

    break;
            
        case GET_MATERIAL_AVAILABILITY_CHECK:
            
            if (statusCode == 401) {
                
                [MBProgressHUD hideHUDForView:self.view animated:YES];
 
                [self showAlertMessageWithTitle:@"Authentication Failed!!" message:@"kindly check your password" cancelButtonTitle:@"Ok" withactionType:@"Single" forMethod:nil];
                
                return;
            }
            
            if (!errorDescription.length) {
                
                NSMutableDictionary *parsedDictionary = [[Response sharedInstance] parseForMaterialCheckAvailability:resultData];
                
                if ([parsedDictionary objectForKey:@"Message"]) {
 
                    if ([[[parsedDictionary objectForKey:@"Message"] substringToIndex:1] isEqualToString:@"S"]) {
                        
                        if ([self.stockSelectedString isEqualToString:@"X"]) {
                            
                            [self submitStockReserve];
                        }
                        else{
                            
                            [self submitReserve];
                         }
                        
                    }
                    else if ([[[parsedDictionary objectForKey:@"Message"] substringToIndex:1] isEqualToString:@"E"]) {
                          [self showAlertMessageWithTitle:@"Information" message:[[parsedDictionary objectForKey:@"Message"] substringFromIndex:1] cancelButtonTitle:@"OK" withactionType:@"Single" forMethod:nil];
                      }
                  }
                else if ([parsedDictionary objectForKey:@"ERROR"]){
 
                    [MBProgressHUD hideHUDForView:self.view animated:YES];

                  [self showAlertMessageWithTitle:@"Information" message:[parsedDictionary objectForKey:@"ERROR"] cancelButtonTitle:@"OK" withactionType:@"Single" forMethod:nil];
                    
                }
 
                else{
                    
                     [self showAlertMessageWithTitle:@"Information" message:@"Failed" cancelButtonTitle:@"OK" withactionType:@"Single" forMethod:nil];
                 }
                
                [MBProgressHUD hideHUDForView:self.view animated:YES];
 
                 [Request stopRequest];
             }
             else{
                
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                
                [Request stopRequest];

            }
            
            break;

    default:
    break;
            
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
