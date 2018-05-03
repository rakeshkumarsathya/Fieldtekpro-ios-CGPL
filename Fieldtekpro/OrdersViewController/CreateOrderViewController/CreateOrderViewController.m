//
//  CreateOrderViewController.m
//  Fieldtekpro
//
//  Created by Enstrapp Bangalore on 28/12/17.
//  Copyright © 2017 Enstrapp Bangalore. All rights reserved.
//

#import "CreateOrderViewController.h"

#define UIColorFromRGB(r, g, b)  [UIColor colorWithRed:((r) / 255.0) green:((g) / 255.0) blue:((b) / 255.0) alpha:1.0]

#define isiPhone5  ([[UIScreen mainScreen] bounds].size.height == 568)?TRUE:FALSE


@interface CreateOrderViewController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>
@end

@implementation CreateOrderViewController
@synthesize defaults;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self customCreateSegmentController];
    
    defaults=[NSUserDefaults standardUserDefaults];
 
    headerDataArray=[NSMutableArray new];
    notificationsArray=[NSMutableArray new];
    self.customHeaderDetailsArray=[NSMutableArray new];
    
    self.dropDownArray=[NSMutableArray new];
    self.selectedCheckBoxArray=[NSMutableArray new];
    [[DataBase sharedInstance] deleteOrderTransactions];
    [self uiPickerTableViewForDropDownSelection];
     orderUDID = [NSMutableString new];
     self.operationDetailsArray = [NSMutableArray new];
    self.partDetailsArray=[NSMutableArray new];
    self.equipmentsDetailsArray=[NSMutableArray new];
 
    createOrderFlag=YES;
 
    VornrOperation= 10;
    VornrComponent = 10;
    
   // self.getDocumentsHeaderDetails=[[NSMutableDictionary alloc]init];

    self.selectedCheckBoxImageArray = [NSMutableArray new];
    self.worksafetySelectedRadioBoxArray = [NSMutableArray new];
    self.workSafetyPlanOperationArray = [NSMutableArray new];
    self.objAvailRadioBoxArray = [NSMutableArray new];
    self.addRisksCheckBoxArray = [NSMutableArray new];
    self.applicationDetailsArray=[NSMutableArray new];
    self.workApprovalDetailsArray=[[NSMutableArray alloc] initWithCapacity:1];
    self.operationWCDSubmittedDetailsArray=[NSMutableArray new];
    self.selectedWorkApprovalArray=[NSMutableArray new];
    self.selectedApplicationCheckBoxesArray=[NSMutableArray new];
    self.applicationHeaderDetailsArray=[NSMutableArray new];
    self.selectedOperationWCDCheckBoxArray=[NSMutableArray new];
    self.selectedOpWCDDetailsArray=[NSMutableArray new];
    //self.tempIsolationHeaderDetailsArray=[NSMutableArray new];
    self.finalCheckPointsArray=[NSMutableArray new];
    self.permitsOperationWCD = [NSMutableArray new];
    self.workApplicationDetailsArray=[NSMutableArray new];
    self.opWCDListDetailsArray =[NSMutableArray new];
    self.addedOperationsWcdArray = [NSMutableArray new];
    self.attachmentArray = [NSMutableArray new];
 
    [self setBorderlayerContentViewforView:opTxtView];
    [self setBorderlayerContentViewforView:durationView];
    [self setBorderlayerContentViewforView:plantWkctrView];
    [self setBorderlayerContentViewforView:opPartsview];
    [self setBorderlayerContentViewforView:componentContentView];
    [self setBorderlayerContentViewforView:quantityContentView];
    [self setBorderlayerContentViewforView:plantStgLocnview];
    [self setBorderlayerContentViewforView:unloadView];
    [self setBorderlayerContentViewforView:receiptView];

    setPreparedFlag=NO;
    changeTaggingCondsFlag=NO;
    setPreparedIsolationFlag=NO;
 
    if ([self.detailOrdersArray count])
    {
         [self loadChangeOrderHeaderData];
         [self loadNotifChangeScreenData];
    }
    else if ([self.loadNotificationDetailsArray count]){
        
         [self loadNotificationHeaderDetailsData];
    }
    else
    {
          [self loadHeaderData];
    }
    
    [checkPointTableView registerNib:[UINib nibWithNibName:@"StandardCheckPointTableViewCell_Iphone5" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"Cell"];
 
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)viewWillAppear:(BOOL)animated{
    
    res_obj=[Response sharedInstance];
    
    NSString *str_UserNameDep = [defaults objectForKey:@"userName"];
    decryptedUserName = [str_UserNameDep AES128DecryptWithKey:@""];

}


-(void)setBorderlayerContentViewforView:(UIView *)contentView
{
    contentView.layer.cornerRadius = 2.0f;
    contentView.layer.masksToBounds = YES;
    contentView.layer.borderColor = [[UIColor darkGrayColor] CGColor];
    contentView.layer.borderWidth = 1.0f;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    headerCommonIndex = (int)textField.superview.tag;
    
    tag=(int)textField.text;
    
    [self.dropDownArray removeAllObjects];
    
    if (textField == wcmPriorityTextfield)
    {
 
        wcmPriorityFlag=YES;
        
        [[wcmPriorityTextfield valueForKey:@"textInputTraits"] setValue:[UIColor clearColor] forKey:@"insertionPointColor"];
        
        wcmPriorityTextfield.inputView = self.dropDownTableView;
        wcmPriorityTextfield.inputAccessoryView = self.mypickerToolbar;
        
        self.dropDownTableView.tag = ORDER_PRIORITY;
        [self.dropDownArray addObjectsFromArray:[[DataBase sharedInstance] getOrderPriorityTypes]];
        [self.dropDownTableView reloadData];
    }
    else if (textField == isolationPriorityTextfield){
        
        tag=200;
        wcmPriorityFlag=YES;
        
        [[isolationPriorityTextfield valueForKey:@"textInputTraits"] setValue:[UIColor clearColor] forKey:@"insertionPointColor"];
        
        isolationPriorityTextfield.inputView = self.dropDownTableView;
        isolationPriorityTextfield.inputAccessoryView = self.mypickerToolbar;
        
        self.dropDownTableView.tag = ORDER_PRIORITY;
        [self.dropDownArray addObjectsFromArray:[[DataBase sharedInstance] getOrderPriorityTypes]];
        [self.dropDownTableView reloadData];
    }
    else if (textField == opWcdTypeTexfield){
        
        [[opWcdTypeTexfield valueForKey:@"textInputTraits"] setValue:[UIColor clearColor] forKey:@"insertionPointColor"];
        
        if (self.dropDownArray==nil) {
            self.dropDownArray=[NSMutableArray new];
        }
        else{
            [self.dropDownArray removeAllObjects];
        }
        
        [self.dropDownArray addObject:[NSArray arrayWithObjects:@"E",@"Equipment", nil]];
        [self.dropDownArray addObject:[NSArray arrayWithObjects:@"F",@"Function Location", nil]];
        [self.dropDownArray addObject:[NSArray arrayWithObjects:@"N",@"Object", nil]];
        [self.dropDownArray addObject:[NSArray arrayWithObjects:@"",@"Comments", nil]];
        
        opWcdTypeTexfield.inputView = self.dropDownTableView;
        opWcdTypeTexfield.inputAccessoryView = self.mypickerToolbar;
        self.dropDownTableView.tag = ORDER_WCM_TYPE;
        [self.dropDownTableView reloadData];
    }
    else if (textField==opWcdObjectTextField){
        
        if ([opWcdTypeTexfield.text isEqualToString:@""]) {
            
            UIAlertView *failureAlertView = [[UIAlertView alloc]initWithTitle:@"Information" message:@"Please select 'Type' field" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            
            [failureAlertView show];
            
        }
        else{
            
            if ([opWCDObjectID isEqualToString:@"E"]) {
                
               // [self equipemntSearchActionMethod];
            }
            
            else if ([opWCDObjectID isEqualToString:@"F"]){
                
               // [self functionLocationSearchActionMethod];
                
            }
            
        }
        
    }
    else if (textField == wcmFromDateTextfield) {
        
        tag=60;
        [self datePickerForMeasurementDocument];
        
    }
    else if (textField == wcmToDateTextfield) {
        
        tag=61;
        [self datePickerForMeasurementDocument];
        
    }
    else if (textField == wcmFromTimeTextfield) {
        tag=62;
        [self datePickerForMeasurementTime];
    }
    else if (textField == wcmToTimeTextfield) {
        tag=63;
        [self datePickerForMeasurementTime];
    }
    else if (textField == isolationFromDateTextfield) {
        
        tag=64;
        [self datePickerForMeasurementDocument];
    }
    else if (textField == isolationToDateTextfield) {
        
        tag=65;
        [self datePickerForMeasurementDocument];
    }
    else if (textField == isolationFromTimeTextfield) {
        tag=66;
        [self datePickerForMeasurementTime];
    }
    else if (textField == isolationToTimeTextfield) {
        tag=67;
        [self datePickerForMeasurementTime];
    }
    
    else if (textField==durationTextField){
        
        tag=1;
        
        if ([operationLongTextView.text isEqualToString:@""])
        {
            [self showAlertMessageWithTitle:@"Information" message:@"Please enter operaion text or duration input" cancelButtonTitle:@"OK" withactionType:@"Single" forMethod:nil];
            
            return NO;
        }
        else if ([durationInputTextField.text isEqualToString:@""])
        {
            
            [self showAlertMessageWithTitle:@"Information" message:@"Please enter duration input" cancelButtonTitle:@"OK" withactionType:@"Single" forMethod:nil];
            
            return NO;
        }
        else
        {
            durationTextField.inputView = self.dropDownTableView;
            durationTextField.inputAccessoryView = self.mypickerToolbar;
            self.dropDownTableView.tag = ORDER_DURATION;
            
            flagUnits = YES;
            [self.dropDownArray addObjectsFromArray:[[DataBase sharedInstance] getUnits:@"D"]];
            [self.dropDownTableView reloadData];
        }
    }
    
    else if (textField == operationNoTextField){
        
        [[operationNoTextField valueForKey:@"textInputTraits"] setValue:[UIColor clearColor] forKey:@"insertionPointColor"];
        
        [self.dropDownArray addObjectsFromArray:operationNoArray];
        operationNoTextField.inputView = self.dropDownTableView;
        operationNoTextField.inputAccessoryView = self.mypickerToolbar;
        self.dropDownTableView.tag = ORDER_OPERATIONNO;
        [self.dropDownTableView reloadData];
    }

    else if (textField == wcmUsergrouptextField) {
        
        wcmUsergrouptextField.inputView = self.dropDownTableView;
        wcmUsergrouptextField.inputAccessoryView = self.mypickerToolbar;
        
        self.dropDownTableView.tag = ORDER_WCM_USERGROUP;
        [self.dropDownArray addObjectsFromArray:[[DataBase sharedInstance] getWCMAuthorizationGroup]];
        
        [self.dropDownTableView reloadData];
        
    }
    else if (textField == isolationUsergroupTexField) {
        
        isolationUsergroupTexField.inputView = self.dropDownTableView;
        isolationUsergroupTexField.inputAccessoryView = self.mypickerToolbar;
        
        self.dropDownTableView.tag = ORDER_ISOLATION_USERGROUP;
        [self.dropDownArray addObjectsFromArray:[[DataBase sharedInstance] getWCMAuthorizationGroup]];
        
        [self.dropDownTableView reloadData];
        
    }
    
    else if (textField == wcmUsageTextField) {
        
        wcmUsageTextField.inputView = self.dropDownTableView;
        wcmUsageTextField.inputAccessoryView = self.mypickerToolbar;
        self.dropDownTableView.tag = ORDER_WCM_USAGE;
        
        if (addWorkApprovalFlag) {
            
            [self.dropDownArray addObjectsFromArray:[[DataBase sharedInstance] getWCMUsageswithPlantText:plantWorkCenterID forObject:@"WW"]];
        }
        else{
            
            [self.dropDownArray addObjectsFromArray:[[DataBase sharedInstance] getWCMUsageswithPlantText:plantWorkCenterID forObject:@"WA"]];
        }
        
        
        [self.dropDownTableView reloadData];
        
    }
    
    else if (textField == isolationUsageTextfield) {
        
        isolationUsageTextfield.inputView = self.dropDownTableView;
        isolationUsageTextfield.inputAccessoryView = self.mypickerToolbar;
        
        self.dropDownTableView.tag = ORDER_ISOLATION_USAGE;
        
        if ([isolationHeaderLabel.text isEqualToString:@"Operation WCD"]) {
            
            [self.dropDownArray addObjectsFromArray:[[DataBase sharedInstance] getWCMUsageswithPlantText:plantWorkCenterID forObject:@"WD"]];
        }
         else{
            
             [self.dropDownArray addObjectsFromArray:[[DataBase sharedInstance] getWCMUsageswithPlantText:plantWorkCenterID forObject:@"WA"]];
        }
        
          [self.dropDownTableView reloadData];
        
      }
      else{
 
      if (commonlistTableView.tag==0)
       {
            if (createOrderFlag) {
 
               if (headerCommonIndex==0) {
                   
                   [[textField valueForKey:@"textInputTraits"] setValue:[UIColor clearColor] forKey:@"insertionPointColor"];
                   textField.inputView = self.dropDownTableView;
                   textField.inputAccessoryView = self.mypickerToolbar;
                   self.dropDownTableView.tag = ORDER_TYPE;
                   [self.dropDownArray addObjectsFromArray:[[DataBase sharedInstance] getOrderTypes]];
                   [self.dropDownTableView reloadData];
                   
               }
               else if (headerCommonIndex==4){
                   
                   [[textField valueForKey:@"textInputTraits"] setValue:[UIColor clearColor] forKey:@"insertionPointColor"];
                   textField.inputView = self.dropDownTableView;
                   textField.inputAccessoryView = self.mypickerToolbar;
                   self.dropDownTableView.tag = ORDER_PRIORITY;
                   [self.dropDownArray addObjectsFromArray:[[DataBase sharedInstance] getOrderPriorityTypes]];
                   [self.dropDownTableView reloadData];
                   
               }
               else if (headerCommonIndex==5){
                   
                   [[textField valueForKey:@"textInputTraits"] setValue:[UIColor clearColor] forKey:@"insertionPointColor"];
                   
                   textField.inputView = self.dropDownTableView;
                   textField.inputAccessoryView = self.mypickerToolbar;
                   
                   if (iwerkString.length) {
                       
                       [self.dropDownArray addObjectsFromArray:[[DataBase sharedInstance] getPlannerGroupMasterforPlant:iwerkString]];
                   }
                   
                   self.dropDownTableView.tag = ORDER_PLANNERGROUP;
                   [self.dropDownTableView reloadData];
               }
               else if (headerCommonIndex==6){
                   
                   [[textField valueForKey:@"textInputTraits"] setValue:[UIColor clearColor] forKey:@"insertionPointColor"];
                   textField.inputView = self.dropDownTableView;
                   textField.inputAccessoryView = self.mypickerToolbar;
                   if (plantID.length) {
                       
                       [self.dropDownArray addObjectsFromArray:[[DataBase sharedInstance] getPersonResonsibleMasterforPlant:plantID forWorkcenter:@""]];
                   }
                   else{
                       
                       if (!createOrderFlag) {
                           
                           [self.dropDownArray addObjectsFromArray:[[DataBase sharedInstance] getPersonResonsibleMasterforPlant:[[self.detailOrdersArray objectAtIndex:0] objectForKey:@"orderh_plant_id"] forWorkcenter:@""]];
                       }
                       
                   }
                   
                   self.dropDownTableView.tag = PERSON_RESONSIBLE;
                   [self.dropDownTableView reloadData];
               }
               else if (headerCommonIndex==7){
                   
                   [self datePickerForMalFuncStartDate];
                   
                   textField.inputView=self.startMalFunctionDatePicker;
                   textField.inputAccessoryView=myDatePickerToolBar;
                   
               }
               else if (headerCommonIndex==8){
                   
                   [self datePickerForMalFuncStartDate];
                   
                   textField.inputView=self.startMalFunctionDatePicker;
                   textField.inputAccessoryView=myDatePickerToolBar;
                   
               }
               
               else if (headerCommonIndex==10){
                   
                   [[textField valueForKey:@"textInputTraits"] setValue:[UIColor clearColor] forKey:@"insertionPointColor"];
                   textField.inputView = self.dropDownTableView;
                   textField.inputAccessoryView = self.mypickerToolbar;
                   
                   if (plantID.length) {
                       
                       [self.dropDownArray addObjectsFromArray:[[DataBase sharedInstance] getCostCentersList:plantID]];
                   }
                   else{
                       
                       [textField resignFirstResponder];
                       
                       [self showAlertMessageWithTitle:@"Alert" message:@"Please Select Equipment" cancelButtonTitle:@"Ok" withactionType:@"Single" forMethod:nil];
                       
                   }
                   self.dropDownTableView.tag = ORDER_COSTCENTER;
                   [self.dropDownTableView reloadData];
               }
               
               else if (headerCommonIndex==10){
                   
                   [[textField valueForKey:@"textInputTraits"] setValue:[UIColor clearColor] forKey:@"insertionPointColor"];
                   textField.inputView = self.dropDownTableView;
                   textField.inputAccessoryView = self.mypickerToolbar;
                   
                   
                   self.dropDownTableView.tag = ORDER_COSTCENTER;
                   [self.dropDownTableView reloadData];
               }
                else if (headerCommonIndex==11){
                   
                   [self.dropDownArray addObjectsFromArray:[[DataBase sharedInstance] getOrderSystemCondition]];
                   
                   textField.inputView = self.dropDownTableView;
                   textField.inputAccessoryView = self.mypickerToolbar;
                   self.dropDownTableView.tag = ORDER_SYSTEM_CONDITION;
                   [self.dropDownTableView reloadData];
                   
               }
            }
           
            else{
                
                
                if (headerCommonIndex==0) {
                    
                    [[textField valueForKey:@"textInputTraits"] setValue:[UIColor clearColor] forKey:@"insertionPointColor"];
                    textField.inputView = self.dropDownTableView;
                    textField.inputAccessoryView = self.mypickerToolbar;
                    self.dropDownTableView.tag = ORDER_TYPE;
                    [self.dropDownArray addObjectsFromArray:[[DataBase sharedInstance] getOrderTypes]];
                    [self.dropDownTableView reloadData];
                    
                }
                else if (headerCommonIndex==5){
                    
                    [[textField valueForKey:@"textInputTraits"] setValue:[UIColor clearColor] forKey:@"insertionPointColor"];
                    textField.inputView = self.dropDownTableView;
                    textField.inputAccessoryView = self.mypickerToolbar;
                    self.dropDownTableView.tag = ORDER_PRIORITY;
                    [self.dropDownArray addObjectsFromArray:[[DataBase sharedInstance] getOrderPriorityTypes]];
                    [self.dropDownTableView reloadData];
                    
                }
                else if (headerCommonIndex==6){
                    
                    [[textField valueForKey:@"textInputTraits"] setValue:[UIColor clearColor] forKey:@"insertionPointColor"];
                    
                    textField.inputView = self.dropDownTableView;
                    textField.inputAccessoryView = self.mypickerToolbar;
                    
                    if (iwerkString.length) {
                        
                        [self.dropDownArray addObjectsFromArray:[[DataBase sharedInstance] getPlannerGroupMasterforPlant:iwerkString]];
                    }
                    
                    self.dropDownTableView.tag = ORDER_PLANNERGROUP;
                    [self.dropDownTableView reloadData];
                }
                else if (headerCommonIndex==7){
                    
                    [[textField valueForKey:@"textInputTraits"] setValue:[UIColor clearColor] forKey:@"insertionPointColor"];
                    textField.inputView = self.dropDownTableView;
                    textField.inputAccessoryView = self.mypickerToolbar;
                    if (plantID.length) {
                        
                        [self.dropDownArray addObjectsFromArray:[[DataBase sharedInstance] getPersonResonsibleMasterforPlant:plantID forWorkcenter:@""]];
                    }
                    else{
                        
                        if (!createOrderFlag) {
                            
                            [self.dropDownArray addObjectsFromArray:[[DataBase sharedInstance] getPersonResonsibleMasterforPlant:[[self.detailOrdersArray objectAtIndex:0] objectForKey:@"orderh_plant_id"] forWorkcenter:@""]];
                        }
                        
                    }
                    
                    self.dropDownTableView.tag = PERSON_RESONSIBLE;
                    [self.dropDownTableView reloadData];
                }
                else if (headerCommonIndex==8){
                    
                    [self datePickerForMalFuncStartDate];
                    
                    textField.inputView=self.startMalFunctionDatePicker;
                    textField.inputAccessoryView=myDatePickerToolBar;
                    
                }
                else if (headerCommonIndex==9){
                    
                    [self datePickerForMalFuncStartDate];
                    
                    textField.inputView=self.startMalFunctionDatePicker;
                    textField.inputAccessoryView=myDatePickerToolBar;
                    
                }
                
                else if (headerCommonIndex==11){
                    
                    [[textField valueForKey:@"textInputTraits"] setValue:[UIColor clearColor] forKey:@"insertionPointColor"];
                    textField.inputView = self.dropDownTableView;
                    textField.inputAccessoryView = self.mypickerToolbar;
                    
                    if (plantID.length) {
                        
                        [self.dropDownArray addObjectsFromArray:[[DataBase sharedInstance] getCostCentersList:plantID]];
                    }
                    else{
                        
                        [textField resignFirstResponder];
                        
                        [self showAlertMessageWithTitle:@"Alert" message:@"Please Select Equipment" cancelButtonTitle:@"Ok" withactionType:@"Single" forMethod:nil];
                        
                    }
                    self.dropDownTableView.tag = ORDER_COSTCENTER;
                    [self.dropDownTableView reloadData];
                }
                
//                else if (headerCommonIndex==10){
//
//                    [[textField valueForKey:@"textInputTraits"] setValue:[UIColor clearColor] forKey:@"insertionPointColor"];
//                    textField.inputView = self.dropDownTableView;
//                    textField.inputAccessoryView = self.mypickerToolbar;
//
//
//                    self.dropDownTableView.tag = ORDER_COSTCENTER;
//                    [self.dropDownTableView reloadData];
//                }
                
                else if (headerCommonIndex==12){
                    
                    [self.dropDownArray addObjectsFromArray:[[DataBase sharedInstance] getOrderSystemCondition]];
                    textField.inputView = self.dropDownTableView;
                    textField.inputAccessoryView = self.mypickerToolbar;
                    self.dropDownTableView.tag = ORDER_SYSTEM_CONDITION;
                    [self.dropDownTableView reloadData];
                    
                }
            }
        }
     }
 
    return YES;
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    
    headerCommonIndex = (int)textField.superview.tag;
    
    if (commonlistTableView.tag==0) {
        
        if (headerCommonIndex==1) {
            
            [[headerDataArray objectAtIndex:1] replaceObjectAtIndex:2 withObject:textField.text];
            operationTextFieldString=textField.text;
        }
 
    }
    
    
    [commonlistTableView reloadData];
    
     return YES;
}

//operationTextFieldString

- (IBAction)backButtonClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)closeOperationClicked:(id)sender
{
    [addOperationView removeFromSuperview];
    submitResetView.hidden=NO;
    
}



- (IBAction)dismissWorkCenterClicked:(id)sender
{
    [searchDropDownView removeFromSuperview];
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
                                        if ([methodNameString isEqualToString:@"More Materials"])
                                        {
 
                                            [self multiplecomponentsMethod];
                                            operationNoTextField.userInteractionEnabled = NO;

                                         }
                                        else if ([methodNameString isEqualToString:@"Cancel Opeartions"]){
                                            
                                            [self listofOperationsCancel];
                                            
                                        }
                                        
                                        else if ([methodNameString isEqualToString:@"Cancel Parts"]){
                                            
                                            [self listofPartsCancel];
                                            
                                        }
                                        else if ([methodNameString isEqualToString:@"Create Order"]){
 
                                            hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                                            hud.mode = MBProgressHUDAnimationFade;
                                            hud.label.text = @"Creation in progress...";
                                            
                                             [self insertCreateSeviceOrder];
                                            
                                         }
                                        
                                        else if ([methodNameString isEqualToString:@"Change Order"]){
                                            
                                            hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                                            hud.mode = MBProgressHUDAnimationFade;
                                            hud.label.text = @"Changes in progress...";
                                            
                                            [self insertChangeSeviceOrder];
                                            
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
                                       
                                         if ([methodNameString isEqualToString:@"Create Order Sucess"]){
                                           
                                           [self.navigationController popViewControllerAnimated:YES];
                                           
                                       }
                                       
                                     else  if ([methodNameString isEqualToString:@"More Materials"]) {
                                           
                                           [self multiplecomponentsMethod];
                                           
                                           operationNoTextField.userInteractionEnabled = YES;
                                           [addPartsView removeFromSuperview];
                                           commonlistTableView.tag=3;
                                           [commonlistTableView reloadData];
                                           
                                       }
                                       
                                       
                                   }];
        
        [alert addAction:okButton];
        
        [self presentViewController:alert animated:YES completion:nil];
        
    }
}


-(void)insertCreateSeviceOrder
{
    
    if (self.orderHeaderDetails == nil) {
        self.orderHeaderDetails = [[NSMutableDictionary alloc] init];
        [self.orderHeaderDetails setObject:@"" forKey:@"QMNUM"];
    }
    
    [self.orderHeaderDetails setObject:@"" forKey:@"DOCS"];
    
//    [self getAttachedDocuments];
    
    [self.orderHeaderDetails setObject:@"" forKey:@"ID"];
    
    if ([self.orderHeaderDetails objectForKey:@"OBJECTID"]) {
        
    }
    
    if ([[[headerDataArray objectAtIndex:0] objectAtIndex:3] length])
    {
        [self.orderHeaderDetails setObject:[[headerDataArray objectAtIndex:0] objectAtIndex:3] forKey:@"OID"];
    }
    
    [self.orderHeaderDetails setObject:[[headerDataArray objectAtIndex:0] objectAtIndex:2] forKey:@"ONAME"];
    
     [self.orderHeaderDetails setObject:[[headerDataArray objectAtIndex:2] objectAtIndex:3] forKey:@"FID"];
    
    [self.orderHeaderDetails setObject:[[headerDataArray objectAtIndex:2] objectAtIndex:2] forKey:@"FNAME"];
    
    if ([NullChecker isNull:equipmentID])
    {
        equipmentID = [[headerDataArray objectAtIndex:3] objectAtIndex:3];
    }
    
    [self.orderHeaderDetails setObject:[equipmentID copy] forKey:@"EQID"];
    
    [self.orderHeaderDetails setObject:[[headerDataArray objectAtIndex:3] objectAtIndex:2] forKey:@"EQNAME"];
    
    [self.orderHeaderDetails setObject:@"" forKey:@"OPID"];
    [self.orderHeaderDetails setObject:@"" forKey:@"OPNAME"];
    
    if ([[[headerDataArray objectAtIndex:4] objectAtIndex:3] length])
    {
        [self.orderHeaderDetails setObject:[[headerDataArray objectAtIndex:4] objectAtIndex:3] forKey:@"OPID"];
    }
    
    if ([[[headerDataArray objectAtIndex:4] objectAtIndex:2] length])
    {
        [self.orderHeaderDetails setObject:[[headerDataArray objectAtIndex:4] objectAtIndex:2] forKey:@"OPNAME"];
    }
    
    [self.orderHeaderDetails setObject:@"" forKey:@"ACCINCID"];
    [self.orderHeaderDetails setObject:@"" forKey:@"ACCINCNAME"];
    
    [self.orderHeaderDetails setObject:@"New" forKey:@"OSTATUS"];
    [self.orderHeaderDetails setObject:@"Create" forKey:@"OSYNCSTATUS"];
    
    [self.orderHeaderDetails setObject:@"" forKey:@"LATITUDE"];
    [self.orderHeaderDetails setObject:@"" forKey:@"LONGITUDE"];
    [self.orderHeaderDetails setObject:@"" forKey:@"ALTITUDE"];
    
    
        [self.orderHeaderDetails setObject:@"" forKey:@"LATITUDE"];
 
         [self.orderHeaderDetails setObject:@"" forKey:@"LONGITUDE"];
         [self.orderHeaderDetails setObject:@"" forKey:@"ALTITUDE"];
 
    //    @"MMM dd, yyyy hh:mm a"
    
    NSDateFormatter *StartdateFormatter = [[NSDateFormatter alloc] init];
    [StartdateFormatter setDateFormat:@"MMM dd, yyyy hh:mm a"];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMM dd, yyyy"];
    NSDate *startDate = [dateFormatter dateFromString:[[headerDataArray objectAtIndex:7] objectAtIndex:2]];
    
    NSDate *endDate = [dateFormatter dateFromString:[[headerDataArray objectAtIndex:8] objectAtIndex:2]];
    
//    NSDate *startMalfunctionDate = [StartdateFormatter dateFromString:malfunctionStartDateTextField.text];
//    NSDate *endMalfunctionDate = [StartdateFormatter dateFromString:malfunctionEndDateTextField.text];
    
    // Convert date object into desired format
    [dateFormatter setDateFormat:@"yyyyMMdd"];
    
    [StartdateFormatter setDateFormat:@"yyyyMMdd"];
    NSString *convertedStartDateString = [StartdateFormatter stringFromDate:startDate];
    
    if ([NullChecker isNull:convertedStartDateString]) {
        convertedStartDateString = @"";
    }
    
    NSString *convertedEndDateString = [StartdateFormatter stringFromDate:endDate];
    
    if ([NullChecker isNull:convertedEndDateString]) {
        convertedEndDateString = @"";
    }
    
//    NSString *convertedMalStartDateString = [dateFormatter stringFromDate:startMalfunctionDate];
//
//    if ([NullChecker isNull:convertedMalStartDateString]) {
//        convertedMalStartDateString = @"";
//    }
//
//    NSString *convertedMalEndDateString = [dateFormatter stringFromDate:endMalfunctionDate];
//    if ([NullChecker isNull:convertedMalEndDateString]) {
//        convertedMalEndDateString = @"";
//    }
//
    [self.orderHeaderDetails setObject:[NSString stringWithFormat:@"%@",@""] forKey:@"MALFUNCTIONSTARTDATE"];
    [self.orderHeaderDetails setObject:[NSString stringWithFormat:@"%@",@""] forKey:@"MALFUNCTIONENDDATE"];
    
    [self.orderHeaderDetails setObject:[NSString stringWithFormat:@"%@",convertedStartDateString] forKey:@"SDATE"];
    
    [self.orderHeaderDetails setObject:[NSString stringWithFormat:@"%@",convertedEndDateString] forKey:@"EDATE"];
    
    [self.orderHeaderDetails setObject:operationTextFieldString forKey:@"SHORTTEXT"];
    
    [self.orderHeaderDetails setObject:@"" forKey:@"LONGTEXT"];
    
    [self.orderHeaderDetails setObject:@"" forKey:@"BREAKDOWN"];
    
    [self.orderHeaderDetails setObject:decryptedUserName forKey:@"REPORTEDBY"];
    
    [self.orderHeaderDetails setObject:@"" forKey:@"NREPORTEDBY"];
    
    [self.orderHeaderDetails setObject:@"" forKey:@"EFFECTID"];
    
//    if (effectID.length) {
//        [self.orderHeaderDetails setObject:effectID forKey:@"EFFECTID"];
//    }
    
    [self.orderHeaderDetails setObject:@"" forKey:@"EFFECTNAME"];
    
    [self.orderHeaderDetails setObject:@"" forKey:@"SYSTEMCONDITIONID"];
    
    if ([[[headerDataArray objectAtIndex:11] objectAtIndex:3] length]) {
        
        [self.orderHeaderDetails setObject:[[headerDataArray objectAtIndex:11] objectAtIndex:3] forKey:@"SYSTEMCONDITIONID"];
    }
    
    [self.orderHeaderDetails setObject:[[headerDataArray objectAtIndex:11] objectAtIndex:2] forKey:@"SYSTEMCONDITIONTEXT"];
    
    [self.orderHeaderDetails setObject:@"" forKey:@"OBJECTID"];
    
    
    
//    if (!workCenterID.length)
//    {
//        workCenterID = workcenterheaderTextField.text;
//    }
    
//    [[headerDataArray objectAtIndex:9] replaceObjectAtIndex:2 withObject:[[self.dropDownArray objectAtIndex:indexPath.row] objectAtIndex:1]];
//    [[headerDataArray objectAtIndex:9] replaceObjectAtIndex:3 withObject:[[self.dropDownArray objectAtIndex:indexPath.row] objectAtIndex:0]];

    [self.orderHeaderDetails setObject:@"" forKey:@"PLANTID"];

    if (plantID.length) {
        [self.orderHeaderDetails setObject:plantID forKey:@"PLANTID"];
    }

    [self.orderHeaderDetails setObject:@"" forKey:@"PLANTNAME"];

    [self.orderHeaderDetails setObject:@"" forKey:@"WORKCENTERID"];

    if ([[[headerDataArray objectAtIndex:9] objectAtIndex:3] length])
    {
        [self.orderHeaderDetails setObject:[[headerDataArray objectAtIndex:9] objectAtIndex:3] forKey:@"WORKCENTERID"];
    }

    [self.orderHeaderDetails setObject:[[headerDataArray objectAtIndex:9] objectAtIndex:3] forKey:@"WORKCENTERNAME"];

 
    
    [self.orderHeaderDetails setObject:@"" forKey:@"PLANNERGROUP"];
    
    if (plannerGrouplID.length) {
        
        [self.orderHeaderDetails setObject:plannerGrouplID forKey:@"PLANNERGROUP"];
        
    }
    
    [self.orderHeaderDetails setObject:@"" forKey:@"PLANNERGROUPNAME"];
    
    if (plannerGroupNameString.length)
    {
        [self.orderHeaderDetails setObject:plannerGroupNameString forKey:@"PLANNERGROUPNAME"];
        
    }
 
 
    [self.orderHeaderDetails setObject:@"" forKey:@"PARNRID"];
    
    if (personResponisbleID.length) {
        
        [self.orderHeaderDetails setObject:personResponisbleID forKey:@"PARNRID"];
        
    }
    
    [self.orderHeaderDetails setObject:@"" forKey:@"NAMEVW"];
 
    if (personresponsibleNameString.length)
    {
         [self.orderHeaderDetails setObject:personresponsibleNameString forKey:@"NAMEVW"];
        
    }
 
    [self.orderHeaderDetails setObject:@"" forKey:@"workarea"];
    [self.orderHeaderDetails setObject:@"" forKey:@"costcenter"];
    
    
 
    if (headerWorkArea.length) {
        
        [self.orderHeaderDetails setObject:headerWorkArea forKey:@"workarea"];
    }
    
    if ([[[headerDataArray objectAtIndex:10] objectAtIndex:3] length]) {
        
        [self.orderHeaderDetails setObject:[[headerDataArray objectAtIndex:10] objectAtIndex:3] forKey:@"costcenter"];
    }
    
    NSDateFormatter *getDate = [[NSDateFormatter alloc] init];
    [getDate setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSArray *dateTimeArray = [NSArray arrayWithArray:[[getDate stringFromDate:[NSDate date]] componentsSeparatedByString:@" "]];
    
    [self.orderHeaderDetails setObject:[dateTimeArray firstObject] forKey:@"DATE"];
    [self.orderHeaderDetails setObject:[dateTimeArray lastObject] forKey:@"TIME"];
 
    [self.orderHeaderDetails setObject:self.customHeaderDetailsArray forKey:@"CFH"];
    
    [self.orderHeaderDetails setObject:@"" forKey:@"WSM"];
 
    [self.orderHeaderDetails setObject:self.operationDetailsArray forKey:@"ITEMS"];
    [self.orderHeaderDetails setObject:self.workApprovalDetailsArray forKey:@"WCMWORKAPPROVALS"];
    [self.orderHeaderDetails setObject:self.workApplicationDetailsArray forKey:@"WCMWORKAPPlICATIONS"];
    [self.orderHeaderDetails setObject:[NSMutableArray new] forKey:@"WCMISSUEPERMITS"];
    [self.orderHeaderDetails setObject:self.permitsOperationWCD forKey:@"WCMOPERATIONWCD"];
    
    [[DataBase sharedInstance] insertDataIntoOrderHeader:self.orderHeaderDetails withAttachments:self.attachmentArray withPermitWorkApprovalsDetails:self.workApprovalDetailsArray withOperation:self.operationDetailsArray withParts:self.partDetailsArray withWSM:[NSMutableArray array] withObjects:[NSMutableArray array] withSystemStatus:[NSMutableArray array] withPermitsWorkApplications:[NSMutableArray array] withIssuePermits:[NSMutableArray array] withPermitsOperationWCD:[NSMutableArray array] withPermitsOperationWCDTagiingConditions:[NSMutableArray array] withPermitsStandardCheckPoints:[NSMutableArray array] withMeasurementDocs:[NSMutableArray new]];
    
    orderUDID = [self.orderHeaderDetails objectForKey:@"ID"];
    
    if ([[ConnectionManager defaultManager] isConnectionQueueIsActive]) {
        [[ConnectionManager defaultManager] stopCurrentConnetion];
    }
    
    [self.orderHeaderDetails setObject:self.attachmentArray forKey:@"ATTACHMENTS"];
    [self.orderHeaderDetails setObject:self.operationDetailsArray forKey:@"ITEMS"];
    
    if (self.partDetailsArray == nil) {
        self.partDetailsArray = [NSMutableArray new];
    }
    
    [self.orderHeaderDetails setObject:self.partDetailsArray forKey:@"PARTS"];
    
    if (self.permitsDetailsArray == nil) {
        self.permitsDetailsArray = [NSMutableArray new];
    }
    
    [self.orderHeaderDetails setObject:self.permitsDetailsArray forKey:@"PERMITS"];
    
    
    if([[ConnectionManager defaultManager] isReachable])
    {
        NSMutableDictionary *endPointDictionary = [NSMutableDictionary new];
        [endPointDictionary setObject:@"I" forKey:@"ACTIVITY"];
        [endPointDictionary setObject:@"W" forKey:@"DOCTYPE"];
        [endPointDictionary setObject:[defaults objectForKey:@"ENDPOINT"] forKey:@"ENDPOINT"];
        NSArray *endPointArray = [[DataBase sharedInstance] getEndPointURL:endPointDictionary];
        NSLog(@"endPoint :%@",[[endPointArray objectAtIndex:0] objectAtIndex:0]);
        [self.orderHeaderDetails setObject:[[endPointArray objectAtIndex:0] objectAtIndex:0] forKey:@"URL_ENDPOINT"];
        [self.orderHeaderDetails setObject:@"" forKey:@"TRANSMITTYPE"];
        
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"CSRF"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [Request makeWebServiceRequest:ORDER_CREATE parameters:self.orderHeaderDetails delegate:self];
    }
    else
    {
        [MBProgressHUD hideHUDForView:self.view animated:YES];

        if ([[defaults objectForKey:@"ACTIVATELOGS"] isEqualToString:@"X"])
        {
            [[DataBase sharedInstance] writToLogFile:[NSString stringWithFormat:@"#INFO#.com.enstrapp.fieldtekpro#Order #Activity:Create Order #Mode:Offline #Class:Very Important #MUser:%@ #DeviceId:%@",decryptedUserName,[defaults objectForKey:@"edeviceid"]]];
        }
        
        [self.navigationController popViewControllerAnimated:YES];
        
     }
}

-(void)insertChangeSeviceOrder
{
    self.orderHeaderDetails = [[NSMutableDictionary alloc] init];
    
    [self.orderHeaderDetails setObject:[[self.detailOrdersArray objectAtIndex:0] objectForKey:@"orderh_id"] forKey:@"ID"];
    
    [self.orderHeaderDetails setObject:[[self.detailOrdersArray objectAtIndex:0] objectForKey:@"orderh_type_id"] forKey:@"OID"];
    
    [self.orderHeaderDetails setObject:@"" forKey:@"DOCS"];
    
    //    [self getAttachedDocuments];
    
 
    [self.orderHeaderDetails setObject:@"" forKey:@"ID"];
    
    if ([self.orderHeaderDetails objectForKey:@"OBJECTID"]) {
        
    }
    
    if ([[[headerDataArray objectAtIndex:0] objectAtIndex:3] length])
    {
        [self.orderHeaderDetails setObject:[[headerDataArray objectAtIndex:0] objectAtIndex:3] forKey:@"OID"];
    }
    
    [self.orderHeaderDetails setObject:[[headerDataArray objectAtIndex:0] objectAtIndex:2] forKey:@"ONAME"];
    
    [self.orderHeaderDetails setObject:[[headerDataArray objectAtIndex:2] objectAtIndex:3] forKey:@"FID"];
    
    [self.orderHeaderDetails setObject:[[headerDataArray objectAtIndex:2] objectAtIndex:2] forKey:@"FNAME"];
    
    if ([NullChecker isNull:equipmentID])
    {
        equipmentID = [[headerDataArray objectAtIndex:3] objectAtIndex:3];
    }
    
    [self.orderHeaderDetails setObject:[equipmentID copy] forKey:@"EQID"];
    
    [self.orderHeaderDetails setObject:[[headerDataArray objectAtIndex:3] objectAtIndex:2] forKey:@"EQNAME"];
    
    [self.orderHeaderDetails setObject:@"" forKey:@"OPID"];
    [self.orderHeaderDetails setObject:@"" forKey:@"OPNAME"];
    
    if ([[[headerDataArray objectAtIndex:4] objectAtIndex:3] length])
    {
        [self.orderHeaderDetails setObject:[[headerDataArray objectAtIndex:4] objectAtIndex:3] forKey:@"OPID"];
    }
    
    if ([[[headerDataArray objectAtIndex:4] objectAtIndex:2] length])
    {
        [self.orderHeaderDetails setObject:[[headerDataArray objectAtIndex:4] objectAtIndex:2] forKey:@"OPNAME"];
    }
    
    [self.orderHeaderDetails setObject:@"" forKey:@"ACCINCID"];
    [self.orderHeaderDetails setObject:@"" forKey:@"ACCINCNAME"];
    
    [self.orderHeaderDetails setObject:@"New" forKey:@"OSTATUS"];
    [self.orderHeaderDetails setObject:@"Create" forKey:@"OSYNCSTATUS"];
    
    [self.orderHeaderDetails setObject:@"" forKey:@"LATITUDE"];
    [self.orderHeaderDetails setObject:@"" forKey:@"LONGITUDE"];
    [self.orderHeaderDetails setObject:@"" forKey:@"ALTITUDE"];
    
    
    [self.orderHeaderDetails setObject:@"" forKey:@"LATITUDE"];
    
    [self.orderHeaderDetails setObject:@"" forKey:@"LONGITUDE"];
    [self.orderHeaderDetails setObject:@"" forKey:@"ALTITUDE"];
    
    //    @"MMM dd, yyyy hh:mm a"
    
    NSDateFormatter *StartdateFormatter = [[NSDateFormatter alloc] init];
    [StartdateFormatter setDateFormat:@"MMM dd, yyyy hh:mm a"];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMM dd, yyyy"];
    NSDate *startDate = [dateFormatter dateFromString:[[headerDataArray objectAtIndex:7] objectAtIndex:2]];
    
    NSDate *endDate = [dateFormatter dateFromString:[[headerDataArray objectAtIndex:8] objectAtIndex:2]];
    
    //    NSDate *startMalfunctionDate = [StartdateFormatter dateFromString:malfunctionStartDateTextField.text];
    //    NSDate *endMalfunctionDate = [StartdateFormatter dateFromString:malfunctionEndDateTextField.text];
    
    // Convert date object into desired format
    [dateFormatter setDateFormat:@"yyyyMMdd"];
    
    [StartdateFormatter setDateFormat:@"yyyyMMdd"];
    NSString *convertedStartDateString = [StartdateFormatter stringFromDate:startDate];
    
    if ([NullChecker isNull:convertedStartDateString]) {
        convertedStartDateString = @"";
    }
    
    NSString *convertedEndDateString = [StartdateFormatter stringFromDate:endDate];
    
    if ([NullChecker isNull:convertedEndDateString]) {
        convertedEndDateString = @"";
    }
    
    //    NSString *convertedMalStartDateString = [dateFormatter stringFromDate:startMalfunctionDate];
    //
    //    if ([NullChecker isNull:convertedMalStartDateString]) {
    //        convertedMalStartDateString = @"";
    //    }
    //
    //    NSString *convertedMalEndDateString = [dateFormatter stringFromDate:endMalfunctionDate];
    //    if ([NullChecker isNull:convertedMalEndDateString]) {
    //        convertedMalEndDateString = @"";
    //    }
    //
     [self.orderHeaderDetails setObject:[NSString stringWithFormat:@"%@",@""] forKey:@"MALFUNCTIONSTARTDATE"];
     [self.orderHeaderDetails setObject:[NSString stringWithFormat:@"%@",@""] forKey:@"MALFUNCTIONENDDATE"];
     [self.orderHeaderDetails setObject:[NSString stringWithFormat:@"%@",convertedStartDateString] forKey:@"SDATE"];
     [self.orderHeaderDetails setObject:[NSString stringWithFormat:@"%@",convertedEndDateString] forKey:@"EDATE"];
 
     if (operationTextFieldString.length) {
        
        [self.orderHeaderDetails setObject:operationTextFieldString forKey:@"SHORTTEXT"];

     }
      else{
         
         [self.orderHeaderDetails setObject:[[self.detailOrdersArray objectAtIndex:0] objectForKey:@"orderh_shorttext"] forKey:@"SHORTTEXT"];
      }
    
      [self.orderHeaderDetails setObject:@"" forKey:@"LONGTEXT"];
    
     [self.orderHeaderDetails setObject:@"" forKey:@"BREAKDOWN"];
    
    [self.orderHeaderDetails setObject:decryptedUserName forKey:@"REPORTEDBY"];
    
    [self.orderHeaderDetails setObject:@"" forKey:@"NREPORTEDBY"];
    
    [self.orderHeaderDetails setObject:@"" forKey:@"EFFECTID"];
    
    //    if (effectID.length) {
    //        [self.orderHeaderDetails setObject:effectID forKey:@"EFFECTID"];
    //    }
    
    [self.orderHeaderDetails setObject:@"" forKey:@"EFFECTNAME"];
    
    [self.orderHeaderDetails setObject:@"" forKey:@"SYSTEMCONDITIONID"];
    
    if ([[[headerDataArray objectAtIndex:11] objectAtIndex:3] length]) {
        
        [self.orderHeaderDetails setObject:[[headerDataArray objectAtIndex:11] objectAtIndex:3] forKey:@"SYSTEMCONDITIONID"];
    }
    
    [self.orderHeaderDetails setObject:[[headerDataArray objectAtIndex:11] objectAtIndex:2] forKey:@"SYSTEMCONDITIONTEXT"];
    
    [self.orderHeaderDetails setObject:[[self.detailOrdersArray objectAtIndex:0] objectForKey:@"oh_objectID"] forKey:@"OBJECTID"];
    
 
    //    if (!workCenterID.length)
    //    {
    //        workCenterID = workcenterheaderTextField.text;
    //    }
    
    //    [[headerDataArray objectAtIndex:9] replaceObjectAtIndex:2 withObject:[[self.dropDownArray objectAtIndex:indexPath.row] objectAtIndex:1]];
    //    [[headerDataArray objectAtIndex:9] replaceObjectAtIndex:3 withObject:[[self.dropDownArray objectAtIndex:indexPath.row] objectAtIndex:0]];
    
    [self.orderHeaderDetails setObject:@"" forKey:@"PLANTID"];
    
    if (plantID.length) {
        [self.orderHeaderDetails setObject:plantID forKey:@"PLANTID"];
    }
    
    [self.orderHeaderDetails setObject:@"" forKey:@"PLANTNAME"];
    
    [self.orderHeaderDetails setObject:@"" forKey:@"WORKCENTERID"];
    
    if ([[[headerDataArray objectAtIndex:9] objectAtIndex:3] length])
    {
        [self.orderHeaderDetails setObject:[[headerDataArray objectAtIndex:9] objectAtIndex:3] forKey:@"WORKCENTERID"];
    }
    
    [self.orderHeaderDetails setObject:[[headerDataArray objectAtIndex:9] objectAtIndex:3] forKey:@"WORKCENTERNAME"];
    
 
    [self.orderHeaderDetails setObject:@"" forKey:@"PLANNERGROUP"];
    
    if (plannerGrouplID.length) {
        
        [self.orderHeaderDetails setObject:plannerGrouplID forKey:@"PLANNERGROUP"];
        
    }
    
    [self.orderHeaderDetails setObject:@"" forKey:@"PLANNERGROUPNAME"];
    
    if (plannerGroupNameString.length)
    {
        [self.orderHeaderDetails setObject:plannerGroupNameString forKey:@"PLANNERGROUPNAME"];
        
    }
    
    
    [self.orderHeaderDetails setObject:@"" forKey:@"PARNRID"];
    
    if (personResponisbleID.length) {
        
        [self.orderHeaderDetails setObject:personResponisbleID forKey:@"PARNRID"];
        
    }
    
    [self.orderHeaderDetails setObject:@"" forKey:@"NAMEVW"];
    
    if (personresponsibleNameString.length)
    {
        [self.orderHeaderDetails setObject:personresponsibleNameString forKey:@"NAMEVW"];
        
    }
    
    [self.orderHeaderDetails setObject:@"" forKey:@"workarea"];
    [self.orderHeaderDetails setObject:@"" forKey:@"costcenter"];
    
    
    
    if (headerWorkArea.length) {
        
        [self.orderHeaderDetails setObject:headerWorkArea forKey:@"workarea"];
    }
    
    if ([[[headerDataArray objectAtIndex:10] objectAtIndex:3] length]) {
        
        [self.orderHeaderDetails setObject:[[headerDataArray objectAtIndex:10] objectAtIndex:3] forKey:@"costcenter"];
    }
    
    NSDateFormatter *getDate = [[NSDateFormatter alloc] init];
    [getDate setDateFormat:@"yyyyMMdd HH:mm:ss"];
    NSArray *dateTimeArray = [NSArray arrayWithArray:[[getDate stringFromDate:[NSDate date]] componentsSeparatedByString:@" "]];
    
    [self.orderHeaderDetails setObject:[dateTimeArray firstObject] forKey:@"DATE"];
    [self.orderHeaderDetails setObject:[dateTimeArray lastObject] forKey:@"TIME"];
    
    [self.orderHeaderDetails setObject:self.customHeaderDetailsArray forKey:@"CFH"];

 
    if (headerWorkArea.length) {
        
        int valuekoklString = [headerWorkArea intValue];
        NSString *koklString=[NSString stringWithFormat:@"%d",valuekoklString];
        [self.orderHeaderDetails setObject:koklString forKey:@"workarea"];
    }
    
    if (headerCostCenter.length) {
        
        int valueKOkrs = [headerCostCenter intValue];
        NSString *kokrsString=[NSString stringWithFormat:@"%d",valueKOkrs];
        [self.orderHeaderDetails setObject:kokrsString forKey:@"costcenter"];
        
    }
    
    if ([self.attachmentArray count]) {
        [self.orderHeaderDetails setObject:@"X" forKey:@"DOCS"];
    }
    else{
        [self.orderHeaderDetails setObject:@"" forKey:@"DOCS"];
    }
    
    [self.orderHeaderDetails setObject:[[self.detailOrdersArray objectAtIndex:0] objectForKey:@"orderh_qmnum"] forKey:@"QMNUM"];
    
    if (self.partDetailsArray == nil) {
        self.partDetailsArray = [NSMutableArray new];
    }
    
    
 //   [self getAttachedDocuments];
    
    [self.operationDetailsArray addObjectsFromArray:self.operationDetailDeleteArray];
    [self.permitsDetailsArray addObjectsFromArray:self.permitsDetailDeleteArray];
    
    [self.partDetailsArray addObjectsFromArray:self.componentDetailDeleteArray];
    
    
    if (!orderNoString.length) {
        [[DataBase sharedInstance] deleteRecordinOrderForUUID:orderUDID ObjectcID:orderNoString ReportedBY:decryptedUserName];
    }
    
    [self.orderHeaderDetails setObject:self.customHeaderDetailsArray forKey:@"CFH"];
    
    [self.orderHeaderDetails setObject:self.partDetailsArray forKey:@"PARTS"];
    
    
    // [[DataBase sharedInstance] insertDataIntoOrderHeader:self.orderHeaderDetails withAttachments:self.attachmentArray withPermits:self.permitsDetailsArray withTransaction:self.operationDetailsArray];
    
    
    [self.orderHeaderDetails setObject:@"" forKey:@"WSM"];
   
    
    [self.orderHeaderDetails setObject:@"" forKey:@"WCM"];
    
    NSMutableArray *temporderSystemStatusArray = [NSMutableArray new];
    
    if ([orderSystemStatusArray count])
    {
        [temporderSystemStatusArray addObjectsFromArray:[[orderSystemStatusArray objectAtIndex:0] firstObject]];
        [temporderSystemStatusArray addObjectsFromArray:[[orderSystemStatusArray objectAtIndex:1] firstObject]];
    }
    
    [[DataBase sharedInstance] insertDataIntoOrderHeader:self.orderHeaderDetails withAttachments:self.attachmentArray withPermitWorkApprovalsDetails:self.workApprovalDetailsArray withOperation:self.operationDetailsArray withParts:self.partDetailsArray withWSM:[NSMutableArray array] withObjects:[NSMutableArray array] withSystemStatus:temporderSystemStatusArray withPermitsWorkApplications:[NSMutableArray array] withIssuePermits:[NSMutableArray array] withPermitsOperationWCD:[NSMutableArray array] withPermitsOperationWCDTagiingConditions:[NSMutableArray array] withPermitsStandardCheckPoints:[NSMutableArray array] withMeasurementDocs:[NSMutableArray new]];
    
    if ([[ConnectionManager defaultManager] isConnectionQueueIsActive]) {
        [[ConnectionManager defaultManager] stopCurrentConnetion];
    }
    
    [self.orderHeaderDetails setObject:self.operationDetailsArray forKey:@"ITEMS"];
    [self.orderHeaderDetails setObject:self.workApprovalDetailsArray forKey:@"WCMWORKAPPROVALS"];
    [self.orderHeaderDetails setObject:self.workApplicationDetailsArray forKey:@"WCMWORKAPPlICATIONS"];
    [self.orderHeaderDetails setObject:self.issuePermitsDetailArray forKey:@"WCMISSUEPERMITS"];
    [self.orderHeaderDetails setObject:self.permitsOperationWCD forKey:@"WCMOPERATIONWCD"];
    //    [self.orderHeaderDetails setObject:self.permitsDetailsArray forKey:@"PERMITS"];
    [self.orderHeaderDetails setObject:self.attachmentArray forKey:@"ATTACHMENTS"];
    
    [self.orderHeaderDetails setObject:[NSMutableArray array] forKey:@"WSMTRANSACTIONS"];
    
    [self.orderHeaderDetails setObject:temporderSystemStatusArray forKey:@"SYSTEMSTATUS"];
    
    if([[ConnectionManager defaultManager] isReachable] &&[[[self.detailOrdersArray objectAtIndex:0] objectForKey:@"oh_objectID"]length])

    {
        NSMutableDictionary *endPointDictionary = [NSMutableDictionary new];
        [endPointDictionary setObject:@"U" forKey:@"ACTIVITY"];
        [endPointDictionary setObject:@"W" forKey:@"DOCTYPE"];
        [endPointDictionary setObject:[defaults objectForKey:@"ENDPOINT"] forKey:@"ENDPOINT"];
        NSArray *endPointArray = [[DataBase sharedInstance] getEndPointURL:endPointDictionary];
        NSLog(@"endPoint :%@",[[endPointArray objectAtIndex:0] objectAtIndex:0]);
        [self.orderHeaderDetails setObject:[[endPointArray objectAtIndex:0] objectAtIndex:0] forKey:@"URL_ENDPOINT"];
        [self.orderHeaderDetails setObject:@"" forKey:@"TRANSMITTYPE"];
        
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"CSRF"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [Request makeWebServiceRequest:ORDER_CHANGE parameters:self.orderHeaderDetails delegate:self];
    }
    else if([[ConnectionManager defaultManager] isReachable] && ![[self.orderHeaderDetails objectForKey:@"OBJECTID"] length])
    {
        NSMutableDictionary *endPointDictionary = [NSMutableDictionary new];
        [endPointDictionary setObject:@"I" forKey:@"ACTIVITY"];
        [endPointDictionary setObject:@"W" forKey:@"DOCTYPE"];
        [endPointDictionary setObject:[defaults objectForKey:@"ENDPOINT"] forKey:@"ENDPOINT"];
        NSArray *endPointArray = [[DataBase sharedInstance] getEndPointURL:endPointDictionary];
        NSLog(@"endPoint :%@",[[endPointArray objectAtIndex:0] objectAtIndex:0]);
        [self.orderHeaderDetails setObject:[[endPointArray objectAtIndex:0] objectAtIndex:0] forKey:@"URL_ENDPOINT"];
         [self.orderHeaderDetails setObject:@"" forKey:@"TRANSMITTYPE"];
         [Request makeWebServiceRequest:ORDER_CREATE parameters:self.orderHeaderDetails delegate:self];
    }
    else
    {
        [[DataBase sharedInstance] updateOrderStatus:orderUDID :@"Changed"];
        
        if ([[defaults objectForKey:@"ACTIVATELOGS"] isEqualToString:@"X"])
        {
            [[DataBase sharedInstance] writToLogFile:[NSString stringWithFormat:@"#INFO#.com.enstrapp.fieldtekpro#Order #OrderNo:%@ #Activity:Change Order #Mode:Offline #Class:Very Important #MUser:%@ #DeviceId:%@",orderNoString,decryptedUserName,[defaults objectForKey:@"edeviceid"]]];
        }
        
//        if ([(MyOrdersViewController *)self.delegate respondsToSelector:@selector(dismissMyordersViewController)]) {
//            [(MyOrdersViewController *)self.delegate dismissMyordersViewController];
//        }
//
       // [ActivityView dismiss];
    }
    
    return;
}


-(IBAction)systemStatusBackButton:(id)sender
{
    [orderSystemStatusView removeFromSuperview];
    
}

-(IBAction)systemStatusButton:(id)sender
{
    
    if (orderSystemStatusArray == nil)
    {
        orderSystemStatusArray = [NSMutableArray new];
         [orderSystemStatusArray addObjectsFromArray:[[DataBase sharedInstance] fetchOrderSystemStatus :orderUDID]];
         orderSystemStatusTableView.tag = 0;
    }
    
    [orderSystemStatusTableView reloadData];
    
    [orderSystemStatusView setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    
    [self.view addSubview:orderSystemStatusView];
}

-(IBAction)orderSystemStatusValueChanged:(id)sender
{
    
    orderSystemStatusSegmentControl = (UISegmentedControl *)sender;
    int clickedSegment=(int)[orderSystemStatusSegmentControl selectedSegmentIndex];
    
    switch (clickedSegment)
    {
         case 0:
            
            orderSystemStatusTableView.tag=0;
             break;
            
         case 1:
            
            orderSystemStatusTableView.tag=1;
            break;
            
        case 2:
            
            orderSystemStatusTableView.tag=2;
            
            break;
            
        default:break;
    }
    
    [orderSystemStatusTableView reloadData];
    
}



-(void)multiplecomponentsMethod{
    
     if (self.partDetailsArray == nil) {
        self.partDetailsArray = [NSMutableArray new];
    }
    
    /*
     CREATE TABLE "ORDER_PARTS_COPY" ("ordert_header_id" VARCHAR, "ordert_vornr_operation" VARCHAR, "ordert_quantity" INTEGER, "ordert_lgort" VARCHAR, "ordert_lgorttext" VARCHAR, "ordert_matnr" VARCHAR, "ordert_matnrtext" VARCHAR, "ordert_meins" VARCHAR, "ordert_posnr" VARCHAR, "ordert_postp" VARCHAR, "ordert_postptext" VARCHAR, "ordert_rsnum" VARCHAR, "ordert_rspos" VARCHAR, "ordert_werks" VARCHAR, "ordert_werkstext" VARCHAR, "ordert_componentaction" VARCHAR)
     
     [self.partDetailsArray addObject:[NSArray arrayWithObjects:[NSArray arrayWithObjects:@"",[operationNoString copy],[quantityTextField.text copy],[storageLocationID copy],[storageLocationComponentTextField.text copy],[componentID copy],[componentTextField.text copy],"",[vornrComponentID copy],"","","","",[plantID copy],[plantComponentTextField.text copy], nil],[NSArray arrayWithObjects:[defaults objectForKey:@"tempCustomComponent"], nil], nil]];
     */
    
    NSMutableDictionary *addPartsDictionary = [NSMutableDictionary new];
 
    vornrComponentID =[NSString stringWithFormat:@"%04i",VornrComponent];
 
    [addPartsDictionary setObject:[orderUDID copy] forKey:@"ID"];
    [addPartsDictionary setObject:[operationNoString copy] forKey:@"OPERATIONKEY"];
    [addPartsDictionary setObject:[quantityTextField.text copy] forKey:@"QUANTITYTEXT"];
    [addPartsDictionary setObject:[storageLocationID copy] forKey:@"STORAGELOCATIONID"];
    
    [addPartsDictionary setObject:[storageLocationComponentTextField.text copy] forKey:@"STORAGELOCATIONTEXT"];
    [addPartsDictionary setObject:[componentID copy] forKey:@"COMPONENTID"];
    
    [addPartsDictionary setObject:[componentTextField.text copy] forKey:@"COMPONENTTEXT"];
    [addPartsDictionary setObject:[vornrComponentID copy] forKey:@"POSNR"];
    [addPartsDictionary setObject:[plantID copy] forKey:@"PLANTCOMPONENTID"];
    [addPartsDictionary setObject:[plantComponentTextField.text copy] forKey:@"PLANTCOMPONENTTEXT"];
    
    [addPartsDictionary setObject:receiptTetxField.text forKey:@"RECEIPT"];
    [addPartsDictionary setObject:unLoadingTextField.text forKey:@"UNLOADING"];
    
    [addPartsDictionary setObject:@"A" forKey:@"COMPONENTACTION"];
    
    [addPartsDictionary setObject:[NSArray arrayWithObjects:[defaults objectForKey:@"tempCustomComponent"], nil]  forKey:@"CUSTOM"];
    
    [[DataBase sharedInstance] insertOrderPartDetails:addPartsDictionary];
    
    [self.partDetailsArray removeAllObjects];
    
    [self.partDetailsArray addObjectsFromArray:[[DataBase sharedInstance] fetchOrderPartDetailsForUUID:[orderUDID copy]]];
    
    //        for (int i=0; i<[self.partDetailsArray count]; i++) {
    //
    //            if ([[[[self.operationDetailsArray objectAtIndex:i] firstObject] objectAtIndex:9] isEqualToString:@"D"]){
    //
    //                [self.operationDetailDeleteArray addObject:[NSMutableArray arrayWithArray:[self.operationDetailsArray objectAtIndex:i]]];
    //                [self.operationDetailsArray removeObjectAtIndex:i];
    //                --i;
    //            }
    //        }
    
 
    VornrComponent = VornrComponent +10;
 
    for (int  i =0; i<[self.customComponentsDetailsArray count]; i++) {
        
        [[self.customComponentsDetailsArray  objectAtIndex:i] replaceObjectAtIndex:4 withObject:@""];
    }
    
    [defaults setObject:self.customComponentsDetailsArray forKey:@"tempCustomComponent"];
    
    [defaults synchronize];
    
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
    
    [commonlistTableView endEditing:YES];
    
}




#pragma mark-
#pragma mark-Date Picker for Text Field

//for Datepicker.
-(void)datePickerForMalFuncStartDate
{
    
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

-(void)pickerDoneStartDateClicked
{
    if (commonlistTableView.tag==0) {
        
        if (headerCommonIndex==7) {
            
            self.minStartDate =[self.startMalFunctionDatePicker date];
            
            NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
            [dateFormat setDateFormat:@"MMM dd, yyyy"];
            
            [[headerDataArray objectAtIndex:7] replaceObjectAtIndex:2 withObject:[dateFormat stringFromDate:self.minStartDate]];
 
             if (![[[headerDataArray objectAtIndex:8] objectAtIndex:2] isEqual:@""]) {
                 
              //   dateFlag = YES;
                 
                self.minEndDate = [dateFormat dateFromString:[[headerDataArray objectAtIndex:8] objectAtIndex:2]];
                NSInteger comparisionResult = [AppDelegate daysBetweenDate:self.minStartDate andDate:self.minEndDate];
                
                NSLog(@"%i",(int)comparisionResult);
                NSString *comparisionString = [NSString stringWithFormat:@"%i",(int)comparisionResult];
                 
                if ([[comparisionString substringToIndex:1] isEqualToString:@"-"]) {
 
                    [[headerDataArray objectAtIndex:7] replaceObjectAtIndex:2 withObject:@""];
 
                    [self showAlertMessageWithTitle:@"Alert" message:@"Start Date has to be earlier than End Date" cancelButtonTitle:@"Ok" withactionType:@"Single" forMethod:nil];
                    
                }
            }
            
        }
        else if (headerCommonIndex==8){
 
            self.minEndDate =[self.startMalFunctionDatePicker date];
            
            NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
            [dateFormat setDateFormat:@"MMM dd, yyyy"];
            
            [[headerDataArray objectAtIndex:8] replaceObjectAtIndex:2 withObject:[dateFormat stringFromDate:self.minEndDate]];
 
             if (![[[headerDataArray objectAtIndex:7] objectAtIndex:2] isEqual:@""]) {
              //  dateFlag = YES;
                 
                self.minStartDate = [dateFormat dateFromString:[[headerDataArray objectAtIndex:7] objectAtIndex:2]];
                 
                NSInteger comparisionResult = [AppDelegate daysBetweenDate:self.minStartDate andDate:self.minEndDate];
                
                NSLog(@"%i",(int)comparisionResult);
                NSString *comparisionString = [NSString stringWithFormat:@"%i",(int)comparisionResult];
                if ([[comparisionString substringToIndex:1] isEqualToString:@"-"]) {
                    
                [[headerDataArray objectAtIndex:8] replaceObjectAtIndex:2 withObject:@""];
 
                [self showAlertMessageWithTitle:@"Alert" message:@"End Date has to be Later than Start Date" cancelButtonTitle:@"Ok" withactionType:@"Single" forMethod:nil];
 
                }
            }
          }
        
        [commonlistTableView reloadData];
     }
 }

-(void)pickerCancelClicked
{
    
}

//for MeasurementDatepicker.
-(void)datePickerForMeasurementDocument{
    
    self.measurementDocDatePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, 250, 0, 0)];
    
    self.measurementDocDatePicker.datePickerMode = UIDatePickerModeDate;
    
     wcmFromDateTextfield.inputView=self.measurementDocDatePicker;
    wcmToDateTextfield.inputView=self.measurementDocDatePicker;
    isolationFromDateTextfield.inputView=self.measurementDocDatePicker;
    isolationToDateTextfield.inputView=self.measurementDocDatePicker;
    
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
    
    wcmFromDateTextfield.inputAccessoryView = myDatePickerToolBar;
    wcmToDateTextfield.inputAccessoryView = myDatePickerToolBar;
    isolationFromDateTextfield.inputAccessoryView = myDatePickerToolBar;
    isolationToDateTextfield.inputAccessoryView = myDatePickerToolBar;
    
    
}

-(void)measurementDocCancelClicked
{
    
     [wcmFromDateTextfield resignFirstResponder];
    [wcmToDateTextfield resignFirstResponder];
    [isolationToDateTextfield resignFirstResponder];
    [isolationFromDateTextfield resignFirstResponder];
    
}

-(void)measurementDocDoneClicked
{
    self.measureMentDocumentDate =[self.measurementDocDatePicker date];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"MMM dd, yyyy"];
    
    
    if (tag==60) {
        wcmFromDateTextfield.text = [dateFormat stringFromDate:self.measureMentDocumentDate];
    }
    
    else if (tag==61){
        wcmToDateTextfield.text = [dateFormat stringFromDate:self.measureMentDocumentDate];
    }
    
    else if (tag==64){
        isolationFromDateTextfield.text = [dateFormat stringFromDate:self.measureMentDocumentDate];
    }
    else if (tag==65){
        isolationToDateTextfield.text = [dateFormat stringFromDate:self.measureMentDocumentDate];
    }
    
    
     [wcmFromDateTextfield resignFirstResponder];
    [wcmToDateTextfield resignFirstResponder];
    [isolationToDateTextfield resignFirstResponder];
    [isolationFromDateTextfield resignFirstResponder];
    
}


//for MeasurementDatepicker.
-(void)datePickerForMeasurementTime{
    
    self.measurementDocTimePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, 250, 0, 0)];
    
    self.measurementDocTimePicker.datePickerMode = UIDatePickerModeTime;
    
     wcmFromTimeTextfield.inputView =self.measurementDocTimePicker;
    wcmToTimeTextfield.inputView =self.measurementDocTimePicker;
    isolationFromTimeTextfield.inputView =self.measurementDocTimePicker;
    isolationToTimeTextfield.inputView =self.measurementDocTimePicker;
    
    
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
    
     wcmFromTimeTextfield.inputAccessoryView = myDatePickerToolBar;
    wcmToTimeTextfield.inputAccessoryView = myDatePickerToolBar;
    isolationFromTimeTextfield.inputAccessoryView = myDatePickerToolBar;
    isolationToTimeTextfield.inputAccessoryView = myDatePickerToolBar;
}

-(void)measurementTimeCancelClicked
{
    
     [wcmFromTimeTextfield resignFirstResponder];
    [wcmToTimeTextfield resignFirstResponder];
    [isolationFromTimeTextfield resignFirstResponder];
    [isolationToTimeTextfield resignFirstResponder];
}

-(void)measurementTimeDoneClicked
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    if (tag==62) {
        [dateFormatter setDateFormat:@"HH:MM:SS"];
        wcmFromTimeTextfield.text = [dateFormatter stringFromDate:self.measurementDocTimePicker.date];
        wcmToTimeTextfield.text = [dateFormatter stringFromDate:self.measurementDocTimePicker.date];
    }
    
    else if (tag==63){
        [dateFormatter setDateFormat:@"HH:MM:SS"];
        
        wcmFromTimeTextfield.text = [dateFormatter stringFromDate:self.measurementDocTimePicker.date];
        wcmToTimeTextfield.text = [dateFormatter stringFromDate:self.measurementDocTimePicker.date];
    }
    else if (tag==66){
        [dateFormatter setDateFormat:@"HH:MM:SS"];
        isolationFromTimeTextfield.text = [dateFormatter stringFromDate:self.measurementDocTimePicker.date];
    }
    else if (tag==67){
        [dateFormatter setDateFormat:@"HH:MM:SS"];
        
        isolationToTimeTextfield.text = [dateFormatter stringFromDate:self.measurementDocTimePicker.date];
    }
    else{
        [dateFormatter setDateFormat:@"hh:mm a"];
     }
    
     [wcmFromTimeTextfield resignFirstResponder];
    [wcmToTimeTextfield resignFirstResponder];
    [isolationFromTimeTextfield resignFirstResponder];
    [isolationToTimeTextfield resignFirstResponder];
}


-(void)loadHeaderData
{
 
    createOrderFlag=YES;
 
    commonlistTableView.tag=0;
    
    [headerDataArray addObject:[NSMutableArray arrayWithObjects:@"Order Type",@"Select Order Type",@"",@"", nil]];
    
    [headerDataArray addObject:[NSMutableArray arrayWithObjects:@"Order Text",@"Enter Order text",@"",@"", nil]];
    
    [headerDataArray addObject:[NSMutableArray arrayWithObjects:@"Function Location",@"Search or Enter Function Location ",@"",@"", nil]];
    
    [headerDataArray addObject:[NSMutableArray arrayWithObjects:@"Equipment Number",@"Search or Scan Equipment Number ",@"",@"", nil]];
    
    [headerDataArray addObject:[NSMutableArray arrayWithObjects:@"Priority",@"Select priority",@"",@"", nil]];
    
    [headerDataArray addObject:[NSMutableArray arrayWithObjects:@"Planner group",@"Select Planner Group",@"",@"", nil]];
    
     [headerDataArray addObject:[NSMutableArray arrayWithObjects:@"Person Responsible",@"Select Person Responsible",@"",@"", nil]];
    
    [headerDataArray addObject:[NSMutableArray arrayWithObjects:@"Basic Start Date & Time",@"",@"",@"", nil]];
    
    [headerDataArray addObject:[NSMutableArray arrayWithObjects:@"Basic  End Date & Time",@"",@"",@"", nil]];
    
    [headerDataArray addObject:[NSMutableArray arrayWithObjects:@"Work Center",@"Search Work Center",@"",@"", nil]];
    
    [headerDataArray addObject:[NSMutableArray arrayWithObjects:@"Resp Cost Center",@"",@"",@"", nil]];
 
    [headerDataArray addObject:[NSMutableArray arrayWithObjects:@"System Conditions",@"",@"",@"", nil]];
 
    [commonlistTableView registerNib:[UINib nibWithNibName:@"InputDropDownTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"InputDropDownCell"];
    
    [commonlistTableView registerNib:[UINib nibWithNibName:@"SearchInputDropdownTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"SearchInputDropDownCell"];
    
 
 }

-(void)loadNotifScreenData
{
    
     [notificationsArray addObject:[NSMutableArray arrayWithObjects:@"Notification No",@"",@"",@"", nil]];
    
//    [notificationsArray addObject:[NSMutableArray arrayWithObjects:@"Break Down",@"",@"",@"", nil]];
//
//    [notificationsArray addObject:[NSMutableArray arrayWithObjects:@"Malfunction Start Date",@"Select Date",@"",@"", nil]];
//
//    [notificationsArray addObject:[NSMutableArray arrayWithObjects:@"Malfunction End Date",@"Select End Date",@"",@"", nil]];
//
//    [notificationsArray addObject:[NSMutableArray arrayWithObjects:@"Reported By",@"",@"",@"", nil]];
//
//    [notificationsArray addObject:[NSMutableArray arrayWithObjects:@"Effect",@"Select Effect",@"",@"", nil]];
//
//    [commonlistTableView registerNib:[UINib nibWithNibName:@"BreakDownTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"BreakDownCell"];
//
 
}

-(void)loadNotifChangeScreenData
{
    
     [notificationsArray addObject:[NSMutableArray arrayWithObjects:@"Notification No",@"",[[self.detailOrdersArray objectAtIndex:0] objectForKey:@"orderh_qmnum"],@"", nil]];
    
//    [notificationsArray addObject:[NSMutableArray arrayWithObjects:@"Break Down",@"",@"",@"", nil]];
//
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//
//     [dateFormatter setDateFormat:@"yyyy-MM-dd "];
//
//    if ([[[self.detailOrdersArray objectAtIndex:0] objectForKey:@"orderh_malf_sdate"] length]) {
//
//        NSDate *endDate = [dateFormatter dateFromString:[[self.detailOrdersArray objectAtIndex:0] objectForKey:@"orderh_malf_sdate"]];
//
//        if (![NullChecker isNull:endDate]) {
//
//            [dateFormatter setDateFormat:@"MMM dd, yyyy"];
//
//            NSString *convertedMalfunctionStartDateString = [dateFormatter stringFromDate:endDate];
//
//            [notificationsArray addObject:[NSMutableArray arrayWithObjects:@"Malfunction Start Date",@"Select Date",convertedMalfunctionStartDateString,@"", nil]];
//
//        }
//
//        else{
//
//             [notificationsArray addObject:[NSMutableArray arrayWithObjects:@"Malfunction Start Date",@"Select Date",@"",@"", nil]];
//        }
//    }
//
//    [dateFormatter setDateFormat:@"yyyy-MM-dd "];
//
//    if ([[[self.detailOrdersArray objectAtIndex:0] objectForKey:@"orderh_malf_edate"] length]) {
//
//        NSDate *endDate = [dateFormatter dateFromString:[[self.detailOrdersArray objectAtIndex:0] objectForKey:@"orderh_malf_edate"]];
//
//        if (![NullChecker isNull:endDate]) {
//
//            [dateFormatter setDateFormat:@"MMM dd, yyyy"];
//
//            NSString *convertedMalfunctionEndDateString = [dateFormatter stringFromDate:endDate];
//
//            // malfunctionEndDateTextField.text =convertedMalfunctionStartDateString;
//
//            [notificationsArray addObject:[NSMutableArray arrayWithObjects:@"Malfunction End Date",@"Select End Date",convertedMalfunctionEndDateString,@"", nil]];
//        }
//        else{
//
//              [notificationsArray addObject:[NSMutableArray arrayWithObjects:@"Malfunction End Date",@"Select End Date",@"",@"", nil]];
//        }
//
//    }
//
//    [notificationsArray addObject:[NSMutableArray arrayWithObjects:@"Reported By",@"",[[self.detailOrdersArray objectAtIndex:0] objectForKey:@"orderh_reported_by"],@"", nil]];
//
//    [notificationsArray addObject:[NSMutableArray arrayWithObjects:@"Effect",@"Select Effect",[[self.detailOrdersArray objectAtIndex:0] objectForKey:@"orderh_effect_name"],[[self.detailOrdersArray objectAtIndex:0] objectForKey:@"orderh_effect_id"], nil]];
//
 
}

-(void)loadNotificationHeaderDetailsData{
    
    commonlistTableView.tag=0;
    
    //    [defaults setObject:@"DETAILSCREEN" forKey:@"DETAILSCREEN"];
    //    [defaults synchronize];
    
    createOrderFlag=NO;
    equipmentFlag=NO;
    
    [orderSystemStatusTableView registerNib:[UINib nibWithNibName:@"OrderSystemStatusTableViewCell~iPhone5" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"Cell"];
    
    //    [commonlistTableView setUserInteractionEnabled:NO];
    
    //    orderTypeBackGroundImage.hidden = YES;
    //    orderTypeTextField.userInteractionEnabled = NO;
    
    //    CREATE TABLE "ORDER_HEADER" ("orderh_id" VARCHAR,"orderh_type_id" VARCHAR,"orderh_type_name" VARCHAR,"orderh_shorttext" VARCHAR,"orderh_longtext" VARCHAR,"orderh_funcloc_id" VARCHAR,"orderh_funcloc_name" VARCHAR,"orderh_euipno_id" VARCHAR,"orderh_euipno_name" VARCHAR,"orderh_accindicator_id" VARCHAR,"orderh_accindicator_name" VARCHAR,"orderh_priority_id" VARCHAR,"orderh_priority_name" VARCHAR,"orderh_startdate" DATETIME,"orderh_enddate" DATETIME,"orderh_plant_id" VARCHAR,"orderh_plant_name" VARCHAR,"orderh_workcenter_id" VARCHAR,"orderh_workcenter_name" VARCHAR,"orderh_latitudes" VARCHAR,"orderh_longitudes" VARCHAR,"orderh_altitudes" VARCHAR,"orderh_reported_by" VARCHAR,"orderh_status" VARCHAR,"oh_objectID" VARCHAR,"oh_upadated_Date" DATETIME,"oh_docs" VARCHAR,"oh_sync_status" VARCHAR,"orderh_kokrs" VARCHAR,"orderh_kostl" VARCHAR,"orderh_qmnum" VARCHAR,"orderh_malf_sdate" VARCHAR,"orderh_malf_edate" VARCHAR,"orderh_effect_id" VARCHAR DEFAULT (null) ,"orderh_msaus" VARCHAR,"orderh_Nreported_by" VARCHAR,"orderh_effect_name" VARCHAR,"orderh_systemcondition_id" VARCHAR,"orderh_systemcondition_text" VARCHAR, "orderh_wsm" VARCHAR, "orderh_wcm" VARCHAR, "orderh_user01" VARCHAR, "orderh_user02" VARCHAR, "orderh_user03" VARCHAR, "orderh_user04" VARCHAR, "orderh_user05" VARCHAR, "orderh_personresponsible_id" VARCHAR, "orderh_personresponsible_text" VARCHAR, "orderh_ingrp" VARCHAR, "orderh_ingrp_name" VARCHAR)
    
   // orderUDID=[[self.loadNotificationDetailsArray objectAtIndex:0] objectForKey:@"orderh_id"];
    
    [headerDataArray addObject:[NSMutableArray arrayWithObjects:@"Order Type",@"Select Order Type",@"",@"", nil]];
    
    [headerDataArray addObject:[NSMutableArray arrayWithObjects:@"Order Text",@"Enter Order text",[[self.loadNotificationDetailsArray objectAtIndex:0] objectForKey:@"notificationh_shorttext"],@"", nil]];
    
    operationTextFieldString=[[self.loadNotificationDetailsArray objectAtIndex:0] objectForKey:@"notificationh_shorttext"];
    
    [headerDataArray addObject:[NSMutableArray arrayWithObjects:@"Function Location",@"Search or Enter Function Location ",[[self.loadNotificationDetailsArray objectAtIndex:0] objectForKey:@"notificationh_funcloc_name"],[[self.loadNotificationDetailsArray objectAtIndex:0] objectForKey:@"notificationh_funcloc_id"], nil]];
    
    funcLocName=[[self.loadNotificationDetailsArray objectAtIndex:0] objectForKey:@"notificationh_funcloc_name"];
    
    funcLocnId=[[self.loadNotificationDetailsArray objectAtIndex:0] objectForKey:@"notificationh_funcloc_id"];
    
    [headerDataArray addObject:[NSMutableArray arrayWithObjects:@"Equipment Number",@"Search or Scan Equipment Number ",[[self.loadNotificationDetailsArray objectAtIndex:0] objectForKey:@"notificationh_equip_name"],[[self.loadNotificationDetailsArray objectAtIndex:0] objectForKey:@"notificationh_equip_id"], nil]];
    
    plantID=[[self.loadNotificationDetailsArray objectAtIndex:0] objectForKey:@"orderh_plant_id"];
    
    plantWorkCenterID = [[self.loadNotificationDetailsArray objectAtIndex:0] objectForKey:@"notificationh_plantid"];
    
    plantComponentTextField.text = [[self.loadNotificationDetailsArray objectAtIndex:0] objectForKey:@"notificationh_plantname"];
    
    [headerDataArray addObject:[NSMutableArray arrayWithObjects:@"Priority",@"Select priority",[[self.loadNotificationDetailsArray objectAtIndex:0] objectForKey:@"notificationh_priority_name"],[[self.loadNotificationDetailsArray objectAtIndex:0] objectForKey:@"notificationh_priorityid"], nil]];
    
    [headerDataArray addObject:[NSMutableArray arrayWithObjects:@"Planner group",@"Select Planner Group",[[self.loadNotificationDetailsArray objectAtIndex:0] objectForKey:@"notificationh_ingrp_name"],[[self.loadNotificationDetailsArray objectAtIndex:0] objectForKey:@"notificationh_ingrp"], nil]];
    
    
    //  [headerDataArray addObject:[NSMutableArray arrayWithObjects:@"Reported By",@"Enter Reported By",[[self.detailOrdersArray objectAtIndex:0] objectForKey:@"orderh_reported_by"],@"", nil]];
    
    [headerDataArray addObject:[NSMutableArray arrayWithObjects:@"Person Responsible",@"Select Person Responsible",[[self.loadNotificationDetailsArray objectAtIndex:0] objectForKey:@"notificationh_personresponsible_text"],[[self.loadNotificationDetailsArray objectAtIndex:0] objectForKey:@"notificationh_personresponsible_id"], nil]];
    
    NSDateFormatter *dateformatter=[[NSDateFormatter alloc]init];
    [dateformatter setDateFormat:@"MMM dd, yyyy hh:mm a"];
    
     [headerDataArray addObject:[NSMutableArray arrayWithObjects:@"Basic Start Date & Time",@"",[dateformatter stringFromDate:[NSDate date]],@"", nil]];
 
    [headerDataArray addObject:[NSMutableArray arrayWithObjects:@"Basic  End Date & Time",@"",[dateformatter stringFromDate:[NSDate date]],@"", nil]];
 
    [headerDataArray addObject:[NSMutableArray arrayWithObjects:@"Work Center",@"",[[self.loadNotificationDetailsArray objectAtIndex:0] objectForKey:@"notificationh_workcentername"],[[self.loadNotificationDetailsArray objectAtIndex:0] objectForKey:@"notificationh_workcenterid"], nil]];
    
    [headerDataArray addObject:[NSMutableArray arrayWithObjects:@"Resp Cost Center",@"",@"",@"", nil]];
    
    [headerDataArray addObject:[NSMutableArray arrayWithObjects:@"System Condition",@"",@"",@"", nil]];
    
    [commonlistTableView registerNib:[UINib nibWithNibName:@"InputDropDownTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"InputDropDownCell"];
    
    [commonlistTableView registerNib:[UINib nibWithNibName:@"SearchInputDropdownTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"SearchInputDropDownCell"];
    
    [commonlistTableView registerNib:[UINib nibWithNibName:@"ObjectTableViewCell_IPhone5" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"Cell"];
    
    
    if (self.attachmentArray == nil) {
        self.attachmentArray = [NSMutableArray new];
    }
    
    [self.attachmentArray removeAllObjects];
    
    if (self.causeDetailDeleteArray) {
        [self.causeDetailDeleteArray removeAllObjects];
    }
    else
    {
        self.causeDetailDeleteArray = [NSMutableArray new];
    }
    
    if (self.permitsDetailsArray == nil) {
        self.permitsDetailsArray = [NSMutableArray new];
    }
    else{
        [self.permitsDetailsArray removeAllObjects];
    }
    
    if (self.permitsDetailDeleteArray == nil) {
        self.permitsDetailDeleteArray = [NSMutableArray new];
    }
    else{
        [self.permitsDetailDeleteArray removeAllObjects];
    }
    
    if (self.operationDetailDeleteArray == nil) {
        self.operationDetailDeleteArray = [NSMutableArray new];
    }
    else{
        [self.operationDetailDeleteArray removeAllObjects];
    }
 
    if (self.componentDetailDeleteArray == nil) {
        self.componentDetailDeleteArray = [NSMutableArray new];
    }
    else{
        [self.componentDetailDeleteArray removeAllObjects];
    }
    
    self.orderHeaderDetails = [NSMutableDictionary new];
    
    [self.orderHeaderDetails removeAllObjects];
    
    if (self.operationDetailsArray == nil) {
        self.operationDetailsArray = [NSMutableArray new];
    }
    else{
        [self.operationDetailsArray removeAllObjects];
    }
    
    if (self.partDetailsArray == nil) {
        self.partDetailsArray = [NSMutableArray new];
    }
    else{
        [self.partDetailsArray removeAllObjects];
    }
    
    
    if (_workApprovalDetailsArray == nil) {
        _workApprovalDetailsArray = [NSMutableArray new];
    }
    else{
        [_workApprovalDetailsArray removeAllObjects];
    }
    
    if (_workApplicationDetailsArray == nil) {
        _workApplicationDetailsArray = [NSMutableArray new];
    }
    else{
        [_workApplicationDetailsArray removeAllObjects];
    }
    
    if (_issuePermitsDetailArray == nil) {
        _issuePermitsDetailArray = [NSMutableArray new];
    }
    else{
        [_issuePermitsDetailArray removeAllObjects];
    }
    
    if (self.objectDetailsArray == nil) {
        self.objectDetailsArray = [NSMutableArray new];
    }
    else{
        
        [self.objectDetailsArray removeAllObjects];
    }
    
    if (self.permitsOperationWCD == nil) {
        self.permitsOperationWCD = [NSMutableArray new];
    }
    else{
        
        [self.permitsOperationWCD removeAllObjects];
    }
    
    NSMutableArray *tempworkSafetyPlansArray = [NSMutableArray new];
    
    [[DataBase sharedInstance] getinsertDetailOrderDetailstoDictionary:self.orderHeaderDetails withAttachments:self.attachmentArray withPermitWorkApprovals:self.workApprovalDetailsArray withPermitWorkApplications:self.workApplicationDetailsArray withIssuePermits:self.issuePermitsDetailArray withPermitsOperationWCD:self.permitsOperationWCD withTransaction:self.operationDetailsArray withParts:self.partDetailsArray withActivity:@"" withWsmDetails:tempworkSafetyPlansArray withObjectDetails:self.objectDetailsArray ForUUID:[[self.detailOrdersArray objectAtIndex:0] objectForKey:@"orderh_id"]];
    
    
    [[DataBase sharedInstance] insertOrderTranscationDetails:self.operationDetailsArray :self.partDetailsArray :[[[self.detailOrdersArray objectAtIndex:0] objectForKey:@"orderh_id"] copy]];
    
    if (operationNoArray == nil)
    {
        operationNoArray = [NSMutableArray new];
    }
    else{
        
        [operationNoArray removeAllObjects];
    }
    
    for (int i = 0; i<[self.operationDetailsArray count]; i++) {
        
        [operationNoArray addObject:[NSArray arrayWithObjects:[[[self.operationDetailsArray objectAtIndex:i] firstObject] objectAtIndex:1],[[[self.operationDetailsArray objectAtIndex:i] firstObject] objectAtIndex:2], nil]];
    }
    
    
    
    if (self.operationDetailDeleteArray == nil) {
        self.operationDetailDeleteArray = [NSMutableArray new];
    }
    else{
        [self.operationDetailDeleteArray removeAllObjects];
    }
    
    VornrOperation = 0;
    
    VornrComponent = 10;
    
    NSMutableArray *temparray=[NSMutableArray new];
    
    for (int i=0; i<[self.operationDetailsArray count]; i++) {
        
        if ([[[[self.operationDetailsArray objectAtIndex:i] firstObject] objectAtIndex:18] isEqualToString:@"D"]){
            [self.operationDetailDeleteArray addObject:[NSMutableArray arrayWithArray:[self.operationDetailsArray objectAtIndex:i]]];
            [self.operationDetailsArray removeObjectAtIndex:i];
            [temparray addObject:[self.operationDetailsArray objectAtIndex:i]];
            --i;
        }
        
        if (i==-1)
        {
            i=0;
        }
        
        vornrOperationID = [[[self.operationDetailsArray  objectAtIndex:i] firstObject]  objectAtIndex:1];
        
    }
    
    if ([temparray count]) {
        for (int k=0; k<[self.self.operationDetailsArray count]; k++) {
            if ([[[[self.operationDetailsArray  objectAtIndex:k] firstObject]  objectAtIndex:18] isEqualToString:[[[temparray objectAtIndex:k] firstObject]  objectAtIndex:18]]) {
                
                [self.operationDetailsArray removeObjectAtIndex:k];
            }
            
        }
    }
    
    VornrOperation = [vornrOperationID intValue];
    VornrOperation = VornrOperation +10;
    vornrOperationID =[NSString stringWithFormat:@"%04i",VornrOperation];
    
    //    [backButton setTitle:orderObject.orderNoString forState:UIControlStateNormal];
    //
    //    resetAllInputsBtn.titleLabel.text=@"";
    //
    //    plantComponentsLabelid.hidden = YES;
    //    plantComponentTextField.hidden = YES;
    //    storageLocComponentsLabelid.hidden = YES;
    //    storageLocationComponentTextField.hidden = YES;
    //    plantComponentSeperator.hidden = YES;
    
    if (self.customHeaderDetailsArray == nil) {
        self.customHeaderDetailsArray = [NSMutableArray new];
    }
    else{
        
        [self.customHeaderDetailsArray removeAllObjects];
    }
    
    self.customHeaderDetailsArray = [self.orderHeaderDetails objectForKey:@"CFH"];
    //    [self customFieldsOperationMethod];
    //    [self customFieldsComponentMethod];
    
    // operationSelectedFlag = NO;
    
    editBtnSelected= NO;
    
    //    if ([OstatusLabel isEqualToString:@"PCNF"]||[OstatusLabel isEqualToString:@"CNF"])
    //    {
    //        operationsTableView.userInteractionEnabled=NO;
    //        deleteOperationsBtn.hidden=YES;
    //    }
    
    
    [commonlistTableView registerNib:[UINib nibWithNibName:@"NotifOrderTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"NotifOrderCell"];
    
    
    if (self.addedOperationsWcdArray ==nil) {
        self.addedOperationsWcdArray = [NSMutableArray new];
    }else{
        [self.addedOperationsWcdArray removeAllObjects];
    }
    
    segmentControl.buttons = @[@"Header",@"Malfunction", @"Operations", @"materials",@"Objects",@"Permits"];
 
}

-(void)loadChangeOrderHeaderData
{
    
    commonlistTableView.tag=0;
    
//    [defaults setObject:@"DETAILSCREEN" forKey:@"DETAILSCREEN"];
//    [defaults synchronize];
    
       createOrderFlag=NO;
       equipmentFlag=NO;
 
      [orderSystemStatusTableView registerNib:[UINib nibWithNibName:@"OrderSystemStatusTableViewCell~iPhone5" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"Cell"];

//    [commonlistTableView setUserInteractionEnabled:NO];
    
//    orderTypeBackGroundImage.hidden = YES;
//    orderTypeTextField.userInteractionEnabled = NO;
    
    //    CREATE TABLE "ORDER_HEADER" ("orderh_id" VARCHAR,"orderh_type_id" VARCHAR,"orderh_type_name" VARCHAR,"orderh_shorttext" VARCHAR,"orderh_longtext" VARCHAR,"orderh_funcloc_id" VARCHAR,"orderh_funcloc_name" VARCHAR,"orderh_euipno_id" VARCHAR,"orderh_euipno_name" VARCHAR,"orderh_accindicator_id" VARCHAR,"orderh_accindicator_name" VARCHAR,"orderh_priority_id" VARCHAR,"orderh_priority_name" VARCHAR,"orderh_startdate" DATETIME,"orderh_enddate" DATETIME,"orderh_plant_id" VARCHAR,"orderh_plant_name" VARCHAR,"orderh_workcenter_id" VARCHAR,"orderh_workcenter_name" VARCHAR,"orderh_latitudes" VARCHAR,"orderh_longitudes" VARCHAR,"orderh_altitudes" VARCHAR,"orderh_reported_by" VARCHAR,"orderh_status" VARCHAR,"oh_objectID" VARCHAR,"oh_upadated_Date" DATETIME,"oh_docs" VARCHAR,"oh_sync_status" VARCHAR,"orderh_kokrs" VARCHAR,"orderh_kostl" VARCHAR,"orderh_qmnum" VARCHAR,"orderh_malf_sdate" VARCHAR,"orderh_malf_edate" VARCHAR,"orderh_effect_id" VARCHAR DEFAULT (null) ,"orderh_msaus" VARCHAR,"orderh_Nreported_by" VARCHAR,"orderh_effect_name" VARCHAR,"orderh_systemcondition_id" VARCHAR,"orderh_systemcondition_text" VARCHAR, "orderh_wsm" VARCHAR, "orderh_wcm" VARCHAR, "orderh_user01" VARCHAR, "orderh_user02" VARCHAR, "orderh_user03" VARCHAR, "orderh_user04" VARCHAR, "orderh_user05" VARCHAR, "orderh_personresponsible_id" VARCHAR, "orderh_personresponsible_text" VARCHAR, "orderh_ingrp" VARCHAR, "orderh_ingrp_name" VARCHAR)
    
    orderUDID=[[self.detailOrdersArray objectAtIndex:0] objectForKey:@"orderh_id"];
    
 
    [headerDataArray addObject:[NSMutableArray arrayWithObjects:@"Order Type",@"Select Order Type",[[self.detailOrdersArray objectAtIndex:0] objectForKey:@"orderh_type_name"],[[self.detailOrdersArray objectAtIndex:0] objectForKey:@"orderh_type_id"], nil]];
    
    [headerDataArray addObject:[NSMutableArray arrayWithObjects:@"Order Text",@"Enter Order text",[[self.detailOrdersArray objectAtIndex:0] objectForKey:@"orderh_shorttext"],@"", nil]];
    
    [headerDataArray addObject:[NSMutableArray arrayWithObjects:@"Notification No",@"",[[self.detailOrdersArray objectAtIndex:0] objectForKey:@"orderh_qmnum"],@"", nil]];

    
    [headerDataArray addObject:[NSMutableArray arrayWithObjects:@"Function Location",@"Search or Enter Function Location ",[[self.detailOrdersArray objectAtIndex:0] objectForKey:@"orderh_funcloc_name"],[[self.detailOrdersArray objectAtIndex:0] objectForKey:@"orderh_funcloc_id"], nil]];
    
    funcLocName=[[self.detailOrdersArray objectAtIndex:0] objectForKey:@"orderh_funcloc_name"];
    
    funcLocnId=[[self.detailOrdersArray objectAtIndex:0] objectForKey:@"orderh_funcloc_id"];
 
    [headerDataArray addObject:[NSMutableArray arrayWithObjects:@"Equipment Number",@"Search or Scan Equipment Number ",[[self.detailOrdersArray objectAtIndex:0] objectForKey:@"orderh_euipno_name"],[[self.detailOrdersArray objectAtIndex:0] objectForKey:@"orderh_euipno_id"], nil]];
    
   self.equipmentsDetailsArray=[NSMutableArray new];
    
    [self.equipmentsDetailsArray addObjectsFromArray:[[DataBase sharedInstance] getiWerksForequipment:[[self.detailOrdersArray objectAtIndex:0] objectForKey:@"orderh_euipno_id"]]];
    
     plantID=[[self.detailOrdersArray objectAtIndex:0] objectForKey:@"orderh_plant_id"];
    
     plantWorkCenterID = [[self.detailOrdersArray objectAtIndex:0] objectForKey:@"orderh_plant_id"];
    
     plantComponentTextField.text = [[self.detailOrdersArray objectAtIndex:0] objectForKey:@"orderh_plant_id"];
 
    [headerDataArray addObject:[NSMutableArray arrayWithObjects:@"Priority",@"Select priority",[[self.detailOrdersArray objectAtIndex:0] objectForKey:@"orderh_priority_name"],[[self.detailOrdersArray objectAtIndex:0] objectForKey:@"orderh_priority_id"], nil]];
    
    [headerDataArray addObject:[NSMutableArray arrayWithObjects:@"Planner group",@"Select Planner Group",[[self.detailOrdersArray objectAtIndex:0] objectForKey:@"orderh_ingrp_name"],[[self.detailOrdersArray objectAtIndex:0] objectForKey:@"orderh_ingrp"], nil]];
    
    
  //  [headerDataArray addObject:[NSMutableArray arrayWithObjects:@"Reported By",@"Enter Reported By",[[self.detailOrdersArray objectAtIndex:0] objectForKey:@"orderh_reported_by"],@"", nil]];
    
    [headerDataArray addObject:[NSMutableArray arrayWithObjects:@"Person Responsible",@"Select Person Responsible",[[self.detailOrdersArray objectAtIndex:0] objectForKey:@"orderh_personresponsible_text"],[[self.detailOrdersArray objectAtIndex:0] objectForKey:@"orderh_personresponsible_id"], nil]];
    
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"yyyyMMdd "];
    
    if ([[[self.detailOrdersArray objectAtIndex:0] objectForKey:@"orderh_startdate"] length]) {
        
        NSDate *endDate = [dateFormatter dateFromString:[[self.detailOrdersArray objectAtIndex:0] objectForKey:@"orderh_startdate"]];
        
        if (![NullChecker isNull:endDate]) {
            
            [dateFormatter setDateFormat:@"MMM dd, yyyy"];
            
            NSString *convertedMalfunctionStartDateString = [dateFormatter stringFromDate:endDate];
            
             [headerDataArray addObject:[NSMutableArray arrayWithObjects:@"Basic Start Date & Time",@"",convertedMalfunctionStartDateString,@"", nil]];
         }
    }
    
    else{
        
        [headerDataArray addObject:[NSMutableArray arrayWithObjects:@"Basic Start Date & Time",@"",@"",@"", nil]];

    }
    
    
    [dateFormatter setDateFormat:@"yyyyMMdd "];
    
    if ([[[self.detailOrdersArray objectAtIndex:0] objectForKey:@"orderh_enddate"] length]) {
        
        NSDate *endDate = [dateFormatter dateFromString:[[self.detailOrdersArray objectAtIndex:0] objectForKey:@"orderh_enddate"]];
        
        if (![NullChecker isNull:endDate]) {
            
            [dateFormatter setDateFormat:@"MMM dd, yyyy"];
            
            NSString *convertedMalfunctionEndDateString = [dateFormatter stringFromDate:endDate];
            
            // malfunctionEndDateTextField.text =convertedMalfunctionStartDateString;
 
              [headerDataArray addObject:[NSMutableArray arrayWithObjects:@"Basic  End Date & Time",@"",convertedMalfunctionEndDateString,@"", nil]];
         }
    }
     else{
        
         [headerDataArray addObject:[NSMutableArray arrayWithObjects:@"Basic  End Date & Time",@"",@"",@"", nil]];
         
      }
 
    
    if (orderSystemStatusArray == nil) {
        orderSystemStatusArray = [NSMutableArray new];
    }
    else{
        
        [orderSystemStatusArray removeAllObjects];
    }
    
    [orderSystemStatusArray addObjectsFromArray:[[DataBase sharedInstance] fetchOrderSystemStatus:[[self.detailOrdersArray objectAtIndex:0] objectForKey:@"orderh_id"]]];
    
 
    [self loadsystemStatusheaderView];

 
    [headerDataArray addObject:[NSMutableArray arrayWithObjects:@"Work Center",@"",[[self.detailOrdersArray objectAtIndex:0] objectForKey:@"orderh_workcenter_name"],[[self.detailOrdersArray objectAtIndex:0] objectForKey:@"orderh_workcenter_id"], nil]];
    
    [headerDataArray addObject:[NSMutableArray arrayWithObjects:@"Resp Cost Center",@"",[[self.detailOrdersArray objectAtIndex:0] objectForKey:@"orderh_kostl"],@"", nil]];
 
     [headerDataArray addObject:[NSMutableArray arrayWithObjects:@"System Condition",@"",[[self.detailOrdersArray objectAtIndex:0] objectForKey:@"orderh_systemcondition_text"],[[self.detailOrdersArray objectAtIndex:0] objectForKey:@"orderh_systemcondition_id"], nil]];
    
     [commonlistTableView registerNib:[UINib nibWithNibName:@"InputDropDownTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"InputDropDownCell"];
    
     [commonlistTableView registerNib:[UINib nibWithNibName:@"SearchInputDropdownTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"SearchInputDropDownCell"];
    
     [commonlistTableView registerNib:[UINib nibWithNibName:@"ObjectTableViewCell_IPhone5" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"Cell"];
    
    
    if (self.attachmentArray == nil) {
        self.attachmentArray = [NSMutableArray new];
    }
    
    [self.attachmentArray removeAllObjects];
    
    if (self.causeDetailDeleteArray) {
        [self.causeDetailDeleteArray removeAllObjects];
    }
    else
    {
        self.causeDetailDeleteArray = [NSMutableArray new];
    }
    
    if (self.permitsDetailsArray == nil) {
        self.permitsDetailsArray = [NSMutableArray new];
    }
    else{
        [self.permitsDetailsArray removeAllObjects];
    }
    
    if (self.permitsDetailDeleteArray == nil) {
        self.permitsDetailDeleteArray = [NSMutableArray new];
    }
    else{
        [self.permitsDetailDeleteArray removeAllObjects];
    }
    
    if (self.operationDetailDeleteArray == nil) {
        self.operationDetailDeleteArray = [NSMutableArray new];
    }
    else{
        [self.operationDetailDeleteArray removeAllObjects];
    }
    
    
    if (self.componentDetailDeleteArray == nil) {
        self.componentDetailDeleteArray = [NSMutableArray new];
    }
    else{
        [self.componentDetailDeleteArray removeAllObjects];
    }
    
    self.orderHeaderDetails = [NSMutableDictionary new];
    
    [self.orderHeaderDetails removeAllObjects];
    
    if (self.operationDetailsArray == nil) {
        self.operationDetailsArray = [NSMutableArray new];
    }
    else{
        [self.operationDetailsArray removeAllObjects];
    }
    
    if (self.partDetailsArray == nil) {
        self.partDetailsArray = [NSMutableArray new];
    }
    else{
        [self.partDetailsArray removeAllObjects];
    }
    
 
    if (_workApprovalDetailsArray == nil) {
        _workApprovalDetailsArray = [NSMutableArray new];
    }
    else{
        [_workApprovalDetailsArray removeAllObjects];
    }
    
    if (_workApplicationDetailsArray == nil) {
        _workApplicationDetailsArray = [NSMutableArray new];
    }
    else{
        [_workApplicationDetailsArray removeAllObjects];
    }
    
    if (_issuePermitsDetailArray == nil) {
        _issuePermitsDetailArray = [NSMutableArray new];
    }
    else{
        [_issuePermitsDetailArray removeAllObjects];
    }
    
    if (self.objectDetailsArray == nil) {
        self.objectDetailsArray = [NSMutableArray new];
    }
    else{
        
        [self.objectDetailsArray removeAllObjects];
    }
    
    if (self.permitsOperationWCD == nil) {
        self.permitsOperationWCD = [NSMutableArray new];
    }
    else{
        
        [self.permitsOperationWCD removeAllObjects];
    }
    
    
    
    NSMutableArray *tempworkSafetyPlansArray = [NSMutableArray new];
    
    [[DataBase sharedInstance] getinsertDetailOrderDetailstoDictionary:self.orderHeaderDetails withAttachments:self.attachmentArray withPermitWorkApprovals:self.workApprovalDetailsArray withPermitWorkApplications:self.workApplicationDetailsArray withIssuePermits:self.issuePermitsDetailArray withPermitsOperationWCD:self.permitsOperationWCD withTransaction:self.operationDetailsArray withParts:self.partDetailsArray withActivity:@"" withWsmDetails:tempworkSafetyPlansArray withObjectDetails:self.objectDetailsArray ForUUID:[[self.detailOrdersArray objectAtIndex:0] objectForKey:@"orderh_id"]];
 
 
    [[DataBase sharedInstance] insertOrderTranscationDetails:self.operationDetailsArray :self.partDetailsArray :[[[self.detailOrdersArray objectAtIndex:0] objectForKey:@"orderh_id"] copy]];
    
    if (operationNoArray == nil)
    {
        operationNoArray = [NSMutableArray new];
    }
    else{
        
        [operationNoArray removeAllObjects];
    }
    
    for (int i = 0; i<[self.operationDetailsArray count]; i++) {
        
        [operationNoArray addObject:[NSArray arrayWithObjects:[[[self.operationDetailsArray objectAtIndex:i] firstObject] objectAtIndex:1],[[[self.operationDetailsArray objectAtIndex:i] firstObject] objectAtIndex:2], nil]];
    }
    
     
    
    if (self.operationDetailDeleteArray == nil) {
        self.operationDetailDeleteArray = [NSMutableArray new];
    }
    else{
        [self.operationDetailDeleteArray removeAllObjects];
    }
    
    VornrOperation = 0;
    
    VornrComponent = 10;
    
    NSMutableArray *temparray=[NSMutableArray new];
    
    for (int i=0; i<[self.operationDetailsArray count]; i++) {
        
        if ([[[[self.operationDetailsArray objectAtIndex:i] firstObject] objectAtIndex:18] isEqualToString:@"D"]){
            [self.operationDetailDeleteArray addObject:[NSMutableArray arrayWithArray:[self.operationDetailsArray objectAtIndex:i]]];
            [self.operationDetailsArray removeObjectAtIndex:i];
            [temparray addObject:[self.operationDetailsArray objectAtIndex:i]];
            --i;
        }
        
        if (i==-1)
        {
            i=0;
        }
        
        vornrOperationID = [[[self.operationDetailsArray  objectAtIndex:i] firstObject]  objectAtIndex:1];
 
    }
    
    if ([temparray count]) {
        for (int k=0; k<[self.self.operationDetailsArray count]; k++) {
            if ([[[[self.operationDetailsArray  objectAtIndex:k] firstObject]  objectAtIndex:18] isEqualToString:[[[temparray objectAtIndex:k] firstObject]  objectAtIndex:18]]) {
                
                [self.operationDetailsArray removeObjectAtIndex:k];
            }
            
        }
    }
    
    VornrOperation = [vornrOperationID intValue];
    VornrOperation = VornrOperation +10;
    vornrOperationID =[NSString stringWithFormat:@"%04i",VornrOperation];
    
//    [backButton setTitle:orderObject.orderNoString forState:UIControlStateNormal];
//
//    resetAllInputsBtn.titleLabel.text=@"";
//
//    plantComponentsLabelid.hidden = YES;
//    plantComponentTextField.hidden = YES;
//    storageLocComponentsLabelid.hidden = YES;
//    storageLocationComponentTextField.hidden = YES;
//    plantComponentSeperator.hidden = YES;
    
    if (self.customHeaderDetailsArray == nil) {
        self.customHeaderDetailsArray = [NSMutableArray new];
    }
    else{
        
        [self.customHeaderDetailsArray removeAllObjects];
    }
    
    self.customHeaderDetailsArray = [self.orderHeaderDetails objectForKey:@"CFH"];
//    [self customFieldsOperationMethod];
//    [self customFieldsComponentMethod];
    
   // operationSelectedFlag = NO;
    
    editBtnSelected= NO;
    
//    if ([OstatusLabel isEqualToString:@"PCNF"]||[OstatusLabel isEqualToString:@"CNF"])
//    {
//        operationsTableView.userInteractionEnabled=NO;
//        deleteOperationsBtn.hidden=YES;
//    }
    
    
     [commonlistTableView registerNib:[UINib nibWithNibName:@"NotifOrderTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"NotifOrderCell"];
    
    
    if (self.addedOperationsWcdArray ==nil) {
        self.addedOperationsWcdArray = [NSMutableArray new];
    }else{
        [self.addedOperationsWcdArray removeAllObjects];
    }
    
    segmentControl.buttons = @[@"Header",@"Malfunction", @"Operations", @"materials",@"Objects",@"Permits"];
 
}

-(void)loadsystemStatusheaderView
{
    
    UIView *systemstatusHeaderView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, commonlistTableView.frame.size.width, 60)];

    UITextField *systemLabel=[[UITextField alloc] initWithFrame:CGRectMake(15, 15, systemstatusHeaderView.frame.size.width-40, 30)];

    systemLabel.textColor=[UIColor blueColor];

    systemLabel.userInteractionEnabled=NO;

    systemLabel.borderStyle=UITextBorderStyleNone;

    [systemLabel setBackgroundColor:[UIColor whiteColor]];
 
    NSString *txt30StatusNumString,*txt30WOStatusNumberString;
    
 
    if (!orderheaderStatusString.length) {
        
        for (int i=0; i<[[[orderSystemStatusArray objectAtIndex:0] firstObject] count]; i++) {
            
            if ([[[[[orderSystemStatusArray objectAtIndex:0] firstObject] objectAtIndex:i] objectForKey:@"orders_act"] isEqualToString:@"X"]) {
 
                txt30StatusNumString=[[[[orderSystemStatusArray objectAtIndex:0] firstObject] objectAtIndex:i] objectForKey:@"orders_txt04"];
                
            }
         }

         for (int j=0; j<[[[orderSystemStatusArray objectAtIndex:2] firstObject] count]; j++) {
            
            if ([[[[[orderSystemStatusArray objectAtIndex:2] firstObject] objectAtIndex:j] objectForKey:@"orders_act"] isEqualToString:@"X"]) {
                
                 txt30WOStatusNumberString=[[[[orderSystemStatusArray objectAtIndex:2] firstObject] objectAtIndex:j] objectForKey:@"orders_txt04"];
            }
         }

 
        if ([NullChecker isNull:txt30StatusNumString]) {

            txt30StatusNumString=@"";
         }

        if ([NullChecker isNull:txt30WOStatusNumberString]) {

            txt30StatusNumString=@"";

        }

        orderheaderStatusString=[NSString stringWithFormat:@"%@ %@",txt30StatusNumString,txt30WOStatusNumberString];

    }

    systemLabel.text=orderheaderStatusString;

    [systemstatusHeaderView setBackgroundColor:UIColorFromRGB(246, 241, 247)];

    [systemstatusHeaderView addSubview:systemLabel];

 
    [commonlistTableView setTableHeaderView:systemstatusHeaderView];
    
  }

-(void)addOperationsData{
 
    [addOperationView setFrame:CGRectMake(0, 0, commonlistTableView.frame.size.width, commonlistTableView.frame.size.height)];
    
    submitResetView.hidden=YES;
    
    [commonlistTableView addSubview:addOperationView];
    
}

-(void)loadOperationsScreen{
 
 [commonlistTableView registerNib:[UINib nibWithNibName:@"OperationTableViewCell-iPhone" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"OperationCell"];
    
}

-(void)loadPartsScreen
{
    
     [commonlistTableView registerNib:[UINib nibWithNibName:@"PartTableViewCell~iPhone" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"partCell"];
    
}

-(void)loadWorkApprovalScreen
{
      [commonlistTableView registerNib:[UINib nibWithNibName:@"WorkApprovalTableViewCell_Iphone5" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"Cell"];
}

-(IBAction)commonAddButtonClicked:(id)sender{
    
    if (commonlistTableView.tag==2) {
        
        [self addOperationsData];
    }
    
    else if (commonlistTableView.tag==3){
        
         [addPartsView setFrame:CGRectMake(0, 0, commonlistTableView.frame.size.width, commonlistTableView.frame.size.height)];
        
        if (isiPhone5) {
            
            partsScrollView.contentInset=UIEdgeInsetsMake(0.0,0.0,400,0.0);
         }
        
        else{
            
            partsScrollView.contentInset=UIEdgeInsetsMake(0.0,0.0,150,0.0);
         }
 
         updateComponent.hidden = YES;
         addComponentButton.hidden = NO;
        rsNuMLabel.hidden=YES;
        
        partHeaderLabel.text = @"New Material";
        operationNoTextField.userInteractionEnabled = YES;
        
        // submitResetView.hidden=YES;
        
        [commonlistTableView addSubview:addPartsView];
    }
    
    else if (commonlistTableView.tag==5)
    {
 
        [workApprovalHeaderView setFrame:CGRectMake(0, 0, commonlistTableView.frame.size.width, commonlistTableView.frame.size.height)];
        
        wcmScrollView.contentInset=UIEdgeInsetsMake(0.0,0.0,400,0.0);
        
        // submitResetView.hidden=YES;
        
        [commonlistTableView addSubview:workApprovalHeaderView];
        
     }
  }

- (IBAction)applicationClicked:(id)sender
{
    
    [applicationTypeTableView registerNib:[UINib nibWithNibName:@"ApplicationTableViewCell_Iphone5" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"Cell"];
    
    standardCheckPointBtn.hidden=YES;
    addWorkApprovalFlag=NO;

    [self newApplicationTypeMethod];

    [workApprovalHeaderView removeFromSuperview];

    [applicationTypeTableView reloadData];
    
    [applicationTypeView setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    
     [self.view addSubview:applicationTypeView];
 }



-(void)newApplicationTypeMethod{
    
    VornrWApprovalId=VornrWApprovalId+01;
    VornrWApprovalString =[NSString stringWithFormat:@"%04i",VornrWApprovalId];
    
    
    if (self.workApprovalDetailsCopyArray == nil) {
        self.workApprovalDetailsCopyArray=[NSMutableArray new];
    }
    
    [self.workApprovalDetailsCopyArray addObject:@""];//headerID
    [self.workApprovalDetailsCopyArray addObject:@"WW"];
    
    [self.workApprovalDetailsCopyArray addObject:[NSString stringWithFormat:@"WW%@",VornrWApprovalString]];//applicationID
    
    [self.workApprovalDetailsCopyArray addObject:plantWorkCenterID];
    [self.workApprovalDetailsCopyArray addObject:@""];//objtype
    
    if (wcmUsageID.length) {
        
        [self.workApprovalDetailsCopyArray addObject:wcmUsageID];//usage
    }
    else{
        
        [self.workApprovalDetailsCopyArray addObject:@""];//usage
    }
    
    [self.workApprovalDetailsCopyArray addObject:wcmUsageTextField.text];//usagex
    
    
    [self.workApprovalDetailsCopyArray addObject:@""];//train
    [self.workApprovalDetailsCopyArray addObject:@""];//trainx
    [self.workApprovalDetailsCopyArray addObject:@""];//anizu
    [self.workApprovalDetailsCopyArray addObject:@""];//anizux
    [self.workApprovalDetailsCopyArray addObject:@""];//etape
    [self.workApprovalDetailsCopyArray addObject:@""];//etapex
    [self.workApprovalDetailsCopyArray addObject:wcmShortTextField.text];//stext
    
    [self.workApprovalDetailsCopyArray addObject:wcmFromDateTextfield.text];//FromDate
    [self.workApprovalDetailsCopyArray addObject:wcmFromTimeTextfield.text];//FromTime
    [self.workApprovalDetailsCopyArray addObject:wcmToDateTextfield.text];//ToDate
    [self.workApprovalDetailsCopyArray addObject:wcmToTimeTextfield.text];//ToTime
    
    if (wcmPriorityId.length) {
        [self.workApprovalDetailsCopyArray addObject:wcmPriorityId];//priorityId
    }
    else{
        [self.workApprovalDetailsCopyArray addObject:@""];
    }
    
    [self.workApprovalDetailsCopyArray addObject:wcmPriorityTextfield.text];//PriorityText
    
    [self.workApprovalDetailsCopyArray addObject:@""];//rctime
    [self.workApprovalDetailsCopyArray addObject:@""];//rcunit
    [self.workApprovalDetailsCopyArray addObject:@""];//objnr
    [self.workApprovalDetailsCopyArray addObject:@""];//refobjnr
    [self.workApprovalDetailsCopyArray addObject:@""];//created
 
    if (setPreparedString.length) {
        [self.workApprovalDetailsCopyArray addObject:setPreparedString];//prep
    }
    else{
        [self.workApprovalDetailsCopyArray addObject:@""];
    }
    
    [self.workApprovalDetailsCopyArray addObject:@""];//comp
    [self.workApprovalDetailsCopyArray addObject:@""];//appr
    [self.workApprovalDetailsCopyArray addObject:@"I"];
    
    
    if (wcmUserGroupID.length) {
        
        [self.workApprovalDetailsCopyArray addObject:wcmUserGroupID];//begru
    }
    else{
        
        [self.workApprovalDetailsCopyArray addObject:@""];//begru
    }
    
    [self.workApprovalDetailsCopyArray addObject:wcmUsergrouptextField.text];//begrutx
    
}

-(void)customCreateSegmentController
{
   
     [segmentControl removeFromSuperview];
     segmentControl = [[YAScrollSegmentControl alloc] initWithFrame:CGRectMake(0, 0, commonlistTableView.frame.size.width, 30)];
     segmentControl.buttons = @[@"Header",@"Malfunction", @"Operations", @"Materials",@"Permits"];
     segmentControl.delegate = self;
     [segmentControl setFont:[UIFont fontWithName:@"Helvetica" size:14.0]];
      [segmentControl setTitleColor:[UIColor whiteColor]  forState:UIControlStateSelected];
     segmentControl.gradientColor =  [UIColor whiteColor]; // Purposely set strange gradient color to demonstrate the effect
     segmentControl.tintColor=[UIColor whiteColor];
     [segmentView addSubview:segmentControl];
    
}


- (void)didSelectItemAtIndex:(NSInteger)index
{
    switch (index)
    {
        case 0:
            
            [addPartsView removeFromSuperview];
            [addOperationView removeFromSuperview];
            
            if (createOrderFlag) {
                [commonlistTableView setTableHeaderView:nil];
             }
             commonlistTableView.tag=0;
            [commonlistTableView reloadData];
 
            break;
            
          case 1:
            
             [addPartsView removeFromSuperview];
             [addOperationView removeFromSuperview];
             [commonlistTableView setTableHeaderView:nil];
              commonlistTableView.tag=1;
             [commonlistTableView reloadData];
 
            break;
          case 2:
            
            [addPartsView removeFromSuperview];
            [addCustomHeaderView setFrame:CGRectMake(0, 0, commonlistTableView.frame.size.width, 50)];
            [commonlistTableView setTableHeaderView:addCustomHeaderView];
            
            if (![self.operationDetailsArray count]) {
                [self addOperationDetailsBydefault];
            }
            [self loadOperationsScreen];
            commonlistTableView.tag=2;
            [commonlistTableView reloadData];
 
         break;

        case 3:
            
             [addOperationView removeFromSuperview];
             [addCustomHeaderView setFrame:CGRectMake(0, 0, commonlistTableView.frame.size.width, 50)];
             [commonlistTableView setTableHeaderView:addCustomHeaderView];
             [self loadPartsScreen];
             commonlistTableView.tag=3;
             [commonlistTableView reloadData];
       
         break;
            
         case 4:
 
            [addOperationView removeFromSuperview];
             [commonlistTableView setTableHeaderView:nil];
            commonlistTableView.tag=4;
            [commonlistTableView reloadData];
 
          break;
        
            case 5:
            
            [addPartsView removeFromSuperview];
            [addOperationView removeFromSuperview];
            
//            if (![self.workApplicationDetailsArray count])
//            {
//                 [addCustomHeaderView setFrame:CGRectMake(0, 0, commonlistTableView.frame.size.width, 50)];
//                 [commonlistTableView setTableHeaderView:addCustomHeaderView];
//             }
//            else{
//
//                [commonlistTableView setTableHeaderView:nil];
//
//            }
//             [self loadWorkApprovalScreen];
            
            [self loadApplicationScreen];
            
//             commonlistTableView.tag=5;
//            [commonlistTableView reloadData];
            
            break;
        default:break;
    }
 }


-(void)loadApplicationScreen
{
    
    [applicationTypeTableView registerNib:[UINib nibWithNibName:@"ApplicationTableViewCell_Iphone5" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"Cell"];
    
    standardCheckPointBtn.hidden=YES;
    addWorkApprovalFlag=NO;

    [applicationTypeTableView reloadData];
    
    [applicationTypeView setFrame:CGRectMake(0, 0, commonlistTableView.frame.size.width, commonlistTableView.frame.size.height)];
    
    [commonlistTableView addSubview:applicationTypeView];
    
}

- (IBAction)addApplicationTypesClicked:(id)sender
{
    
     ApllicationsDropDownViewController *appVc = [self.storyboard instantiateViewControllerWithIdentifier:@"addApplicationVC"];
    
       appVc.delegate=self;
    
    if (!createOrderFlag) {
        
        if ([self.equipmentsDetailsArray count]) {
            
            appVc.plantWorkCenterID=[[self.equipmentsDetailsArray objectAtIndex:0] objectForKey:@"iwerks"];

        }
     }
    else{
        
         appVc.plantWorkCenterID=plantWorkCenterID;
      }
    
     [self showViewController:appVc sender:self];
    
}

-(void)addOperationDetailsBydefault{
    
    if (operationTextFieldString.length) {
        
         vornrOperationID =[NSString stringWithFormat:@"%04i",VornrOperation];
        
        if (operationNoArray == nil) {
            operationNoArray = [NSMutableArray new];
        }
        
        [operationNoArray addObject:[NSArray arrayWithObjects:vornrOperationID,operationTextFieldString, nil]];
        
        NSMutableDictionary *addOperationsDictionary = [NSMutableDictionary new];
        
        [addOperationsDictionary setObject:[orderUDID copy] forKey:@"ID"];
        [addOperationsDictionary setObject:[vornrOperationID copy] forKey:@"OPERATIONKEY"];
        [addOperationsDictionary setObject:operationTextFieldString forKey:@"OPERATIONTEXT"];
 
        [addOperationsDictionary setObject:[operationTextFieldString copy] forKey:@"OPERATIONLONGTEXT"];
        
        [addOperationsDictionary setObject:@"" forKey:@"DURATIONTEXTINPUT"];
        [addOperationsDictionary setObject:@"" forKey:@"DURATIONTEXT"];
        
        if (plantWorkCenterOperatonID.length) {
            
            [addOperationsDictionary setObject:[plantWorkCenterOperatonID copy] forKey:@"OPERATIONPLANTID"];
        }
        else{
            
            [addOperationsDictionary setObject:@"" forKey:@"OPERATIONPLANTID"];
        }
        
        if (workCenterOperationID.length) {
            
            [addOperationsDictionary setObject:[workCenterOperationID copy] forKey:@"OPERATIONWORKCENTERID"];
        }
        else{
            
            [addOperationsDictionary setObject:@"" forKey:@"OPERATIONWORKCENTERID"];
            
        }
        
        [addOperationsDictionary setObject:[operationPlanttextField.text copy] forKey:@"OPERATIONPLANTTEXT"];
        
        [addOperationsDictionary setObject:[operationWkcenterTextfield.text copy] forKey:@"OPERATIONWORKCENTERTEXT"];
        
        [addOperationsDictionary setObject:@"" forKey:@"CONTROLKEYID"];
        [addOperationsDictionary setObject:@"" forKey:@"CONTROLKEYTEXT"];
        
        [addOperationsDictionary setObject:[NSArray arrayWithObjects:[defaults objectForKey:@"tempCustomOperation"], nil]  forKey:@"CUSTOM"];
        
        [[DataBase sharedInstance] insertOrderTranscationDetails:addOperationsDictionary];
        
        [self.operationDetailsArray removeAllObjects];
        
        [self.operationDetailsArray addObjectsFromArray:[[DataBase sharedInstance] fetchOrderTransactionDetailsForUUID:[orderUDID copy]]];
        
        for (int i=0; i<[self.operationDetailsArray count]; i++) {
            
            if ([[[[self.operationDetailsArray objectAtIndex:i] firstObject] objectAtIndex:9] isEqualToString:@"D"]){
                
                [self.operationDetailDeleteArray addObject:[NSMutableArray arrayWithArray:[self.operationDetailsArray objectAtIndex:i]]];
                [self.operationDetailsArray removeObjectAtIndex:i];
                --i;
            }
        }
        
        
        VornrOperation = VornrOperation+10;
        
        //        [self componentsDisabling];
        [self partialConfirmationEnabling];
        
        durationTextField.userInteractionEnabled = YES;
        durationInputTextField.userInteractionEnabled = YES;
        operationPlanttextField.userInteractionEnabled = YES;
        operationWkcenterTextfield.userInteractionEnabled = YES;
        operationControlKeyTextfield.userInteractionEnabled = YES;
        
        plantComponentsLabelid.hidden = YES;
        plantComponentTextField.hidden = YES;
        plantComponentSeperator.hidden = YES;
        
        plantComponentTextField.text = @"";
        storageLocationComponentTextField.text = @"";
        storageLocComponentsLabelid.hidden = YES;
        plantComponentSeperator.hidden=YES;
        //storageLocationComponentTextField.hidden = YES;
        
        deleteOperationsBtn.hidden=NO;
        
        for (int  i =0; i<[self.customOperationDetailsArray count]; i++) {
            
            [[self.customOperationDetailsArray objectAtIndex:i] replaceObjectAtIndex:4 withObject:@""];
        }
        
        [defaults setObject:self.customOperationDetailsArray forKey:@"tempCustomOperation"];
        
        [defaults synchronize];
        
        [commonlistTableView reloadData];
        
        [addOperationView removeFromSuperview];
     }
}



-(IBAction)addComponentsDetails:(id)sender{
    
    if (![JEValidator validateTextValue:operationNoTextField.text]) {
        
         [self showAlertMessageWithTitle:@"Information" message:@"Please select operation #" cancelButtonTitle:@"Okay" withactionType:@"Single" forMethod:nil];
        
    }
    else if (![JEValidator validateTextValue:componentTextField.text])
    {
        
        [self showAlertMessageWithTitle:@"Information" message:@"Please select component" cancelButtonTitle:@"Ok" withactionType:@"Single" forMethod:nil];
        
    }
    else{
        
        serachMaterialAvailabiltyFlag=NO;
        [self materialAvailability];
        
    }
}


-(IBAction)f4HelpListOfComponents:(id)sender
{
    ComponentViewController *compVc = [self.storyboard instantiateViewControllerWithIdentifier:@"compViewID"];
    compVc.delegate=self;
     if (createOrderFlag) {
        compVc.equipmentIdString=equipmentID;
     }
    else{
         compVc.equipmentIdString=[[self.detailOrdersArray objectAtIndex:0] objectForKey:@"orderh_euipno_id"];
    }
     compVc.plantIDString=plantID;
    [self showViewController:compVc sender:self];
 }

//For Operations

-(IBAction)f4HelpMaterialCheckAvailabilty:(id)sender{
    
     serachMaterialAvailabiltyFlag=YES;
    
     [self materialAvailability];
    
 }

-(void)materialAvailability{
    
    if (componentTextField.text && componentTextField.text.length && quantityTextField.text.length) {
        if (!componentID.length) {
            componentID=componentTextField.text;
        }
        
        NSMutableDictionary *dictionarySearch = [[NSMutableDictionary alloc]init];
        
        if (plantID.length) {
            [dictionarySearch setObject:[plantComponentTextField.text copy] forKey:@"PLANT"];
        }
        else{
            [dictionarySearch setObject:@"" forKey:@"PLANT"];
        }
        
        if (storageLocationID.length) {
            [dictionarySearch setObject:[storageLocationID copy] forKey:@"STORAGELOCATION"];
        }
        else{
            [dictionarySearch setObject:@"" forKey:@"STORAGELOCATION"];
        }
        [dictionarySearch setObject:[componentID copy] forKey:@"MATERIAL"];
        
        [dictionarySearch setObject:[quantityTextField.text copy] forKey:@"QUANTITY"];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MMM dd, yyyy"];
        NSDate *startDate = [dateFormatter dateFromString:[[headerDataArray objectAtIndex:7] objectAtIndex:2]];
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
 
            [dictionarySearch setObject:@"MC" forKey:@"ACTIVITY"];
            [dictionarySearch setObject:@"C6" forKey:@"DOCTYPE"];
            [dictionarySearch setObject:[defaults objectForKey:@"ENDPOINT"] forKey:@"ENDPOINT"];
            NSArray *endPointArray = [[DataBase sharedInstance] getEndPointURL:dictionarySearch];
            NSLog(@"endPoint :%@",[[endPointArray objectAtIndex:0] objectAtIndex:0]);
            [dictionarySearch setObject:[[endPointArray objectAtIndex:0] objectAtIndex:0] forKey:@"URL_ENDPOINT"];
            [dictionarySearch setObject:decryptedUserName forKey:@"REPORTEDBY"];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"CSRF"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [Request makeWebServiceRequest:GET_MATERIAL_AVAILABILITY_CHECK parameters:dictionarySearch delegate:self];
        }
        else
        {
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];

            vornrComponentID =[NSString stringWithFormat:@"%04i",VornrComponent];
            
            if ([NullChecker isNull:componentTextField.text]) {
                componentTextField.text = @"";
                componentID=@"";
                VornrComponent=0;
            }
            
            if ([NullChecker isNull:quantityTextField.text]) {
                quantityTextField.text = @"";
            }
 
            [self showAlertMessageWithTitle:@"Information" message:@"Would you like to add another component for this operation?" cancelButtonTitle:@"No" withactionType:@"Multiple" forMethod:@"More Components"];
          }
    }
    else if ([quantityTextField.text isEqualToString:@""]){
        
         [self showAlertMessageWithTitle:@"Information" message:@"Zero quantity is not allowed for availability check" cancelButtonTitle:@"Ok" withactionType:@"Single" forMethod:nil];
        
    }
    else if([componentTextField.text isEqualToString:@""]) {
 
        [self showAlertMessageWithTitle:@"Information" message:@"No Material Component is selected!" cancelButtonTitle:@"Ok" withactionType:@"Single" forMethod:nil];
    }
}

-(IBAction)createOrderBtn:(id)sender{
    
    CreateOrderViewController *createVc = [self.storyboard instantiateViewControllerWithIdentifier:@"CreateOrderVC"];
    
    [self showViewController:createVc sender:self];
}



-(void)trafficSignalforWorkApproval{
    
    NSMutableArray * workApprovalIssuepemitsArray=[NSMutableArray new];
    
    for (int i =0; i<[self.issuePermitsDetailArray count]; i++) {
        
        if ([[[self.issuePermitsDetailArray objectAtIndex:i] objectAtIndex:5] isEqualToString:@"WW"]) {
            
            [workApprovalIssuepemitsArray  addObject:[self.issuePermitsDetailArray objectAtIndex:i]];
            
        }
    }
    
    NSMutableArray *workApprovalTrafficArray=[NSMutableArray new];
    
    for (int k=0; k<[workApprovalIssuepemitsArray count]; k++) {
        
        if ([[[workApprovalIssuepemitsArray objectAtIndex:k] objectAtIndex:9] isEqualToString:@""]) {
            
            [workApprovalTrafficArray addObject:[NSNumber numberWithInteger:k]];
        }
    }
    
    if (![workApprovalTrafficArray count]) {
        
        issuepermitImage.image=[UIImage imageNamed:@"red_traffic.png"];
        
    }
    else if ([workApprovalTrafficArray count] == [workApprovalIssuepemitsArray count]) {
        
        issuepermitImage.image=[UIImage imageNamed:@"green_traffic.png"];
    }
    else{
        
        issuepermitImage.image=[UIImage imageNamed:@"yellow_traffic.png"];
    }
    
}

- (IBAction)setPreparedClicked:(id)sender{
    
    if (addWorkApprovalFlag) {
 
        if (![self.applicationDetailsArray count]){
            
            UIAlertView *failureAlertView = [[UIAlertView alloc]initWithTitle:@"Information" message:@"Please Select 'Set Prepared' status at Application Level" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            
            [failureAlertView show];
            
        }
        else if (applicationSetPreparedFlag && setPreparedIsolationFlag){
            
            if (!setPreparedFlag) {
                
                UIAlertView *failureAlertView = [[UIAlertView alloc]initWithTitle:@"Information" message:@"Please Select 'Set Prepared' status at Application Level" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                
                [failureAlertView show];
                
            }
            
        }
        
        
        else {
            
            if (!setPreparedFlag) {
                [setPreparedBtn setImage:[UIImage imageNamed:@"set_prepared_enable_icon"] forState:UIControlStateNormal];
                setPreparedString=@"X";
                setPreparedFlag=YES;
                tagBtn.hidden=NO;
            }
            else
            {
                [setPreparedBtn setImage:[UIImage imageNamed:@"set_prepared_disable_icon"] forState:UIControlStateNormal];
                setPreparedString=@"";
                setPreparedFlag=NO;
                tagBtn.hidden=YES;
                taggedBtn.hidden=YES;
                
                unTagBtn.hidden=YES;
                unTaggedBtn.hidden=YES;
                
            }
        }
 
    }
    else{
        
        if (!setPreparedFlag) {
            [setPreparedBtn setImage:[UIImage imageNamed:@"set_prepared_enable_icon"] forState:UIControlStateNormal];
            setPreparedString=@"X";
            setPreparedFlag=YES;
            applicationSetPreparedFlag=YES;
            tagBtn.hidden=NO;
        }
        else
        {
            [setPreparedBtn setImage:[UIImage imageNamed:@"set_prepared_disable_icon"] forState:UIControlStateNormal];
            setPreparedString=@"";
            setPreparedFlag=NO;
            applicationSetPreparedFlag=NO;
            tagBtn.hidden=YES;
            taggedBtn.hidden=YES;
            unTagBtn.hidden=YES;
            unTaggedBtn.hidden=YES;
         }
     }
 }

- (IBAction)setPreparedIsolationClicked:(id)sender{
 
    if (!taggingConditionsFlag) {
        
        if (!opWCDSetpreparedFlag){
            
            UIAlertView *failureAlertView = [[UIAlertView alloc]initWithTitle:@"Information" message:@"Please activate 'Set Prepared'  at Tagging Conditions " delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            
            [failureAlertView show];
            
        }
        else{
            
            if (!setPreparedIsolationFlag) {
                [isolationSetPreparedBtn setImage:[UIImage imageNamed:@"set_prepared_enable_icon"] forState:UIControlStateNormal];
                isolationSetPreparedString=@"X";
                setPreparedIsolationFlag=YES;
                opWCDSetpreparedFlag=YES;
                tagBtn.hidden=NO;
            }
            else
            {
                [isolationSetPreparedBtn setImage:[UIImage imageNamed:@"set_prepared_disable_icon"] forState:UIControlStateNormal];
                isolationSetPreparedString=@"";
                setPreparedIsolationFlag=NO;
                opWCDSetpreparedFlag=NO;
                tagBtn.hidden=YES;
                taggedBtn.hidden=YES;
                unTagBtn.hidden=YES;
                unTaggedBtn.hidden=YES;
            }
        }
        
    }
    
    else{
        
        if (!setPreparedIsolationFlag) {
            [isolationSetPreparedBtn setImage:[UIImage imageNamed:@"set_prepared_enable_icon"] forState:UIControlStateNormal];
            isolationSetPreparedString=@"X";
            setPreparedIsolationFlag=YES;
            opWCDSetpreparedFlag=YES;
            tagBtn.hidden=NO;
        }
        else
        {
            [isolationSetPreparedBtn setImage:[UIImage imageNamed:@"set_prepared_disable_icon"] forState:UIControlStateNormal];
            isolationSetPreparedString=@"";
            setPreparedIsolationFlag=NO;
            opWCDSetpreparedFlag=NO;
            tagBtn.hidden=YES;
            taggedBtn.hidden=YES;
            unTagBtn.hidden=YES;
            unTaggedBtn.hidden=YES;
        }
    }
    
}


- (IBAction)addSelectedApprovalsClicked:(id)sender{
    
    [workApprovalHeaderView removeFromSuperview];
   // [self.operatioNoView removeFromSuperview];
    [opWCDListView removeFromSuperview];
    [opWCDHeaderView removeFromSuperview];
    [taggingConditionsView removeFromSuperview];
    [checkPointView removeFromSuperview];
    [opWCDView removeFromSuperview];
    [isolationHeaderView removeFromSuperview];
    [operationWCDHeaderView removeFromSuperview];
    
    //CREATE TABLE "ORDER_WCM_WORKAPPROVALS" ("orderwcm_header_id" VARCHAR,"orderwcm_objart" VARCHAR,"orderwcm_wapnr" VARCHAR,"orderwcm_iwerk" VARCHAR,"orderwcm_objtyp" VARCHAR,"orderwcm_usage" VARCHAR,"orderwcm_usagex" VARCHAR,"orderwcm_train" VARCHAR,"orderwcm_trainx" VARCHAR,"orderwcm_anlzu" VARCHAR,"orderwcm_anlzux" VARCHAR,"orderwcm_etape" VARCHAR,"orderwcm_etapex" VARCHAR,"orderwcm_stxt" VARCHAR,"orderwcm_datefr" VARCHAR,"orderwcm_timefr" VARCHAR,"orderwcm_dateto" VARCHAR,"orderwcm_timeto" VARCHAR,"orderwcm_priok" VARCHAR,"orderwcm_priokx" VARCHAR,"orderwcm_rctime" VARCHAR,"orderwcm_rcunit" VARCHAR,"orderwcm_objnr" VARCHAR,"orderwcm_refobj" VARCHAR,"orderwcm_crea" VARCHAR,"orderwcm_prep" VARCHAR,"orderwcm_comp" VARCHAR,"orderwcm_appr" VARCHAR, "orderwcm_pappr" VARCHAR, "orderwcm_action" VARCHAR)
    
    if (addWorkApprovalFlag) {
        
        NSMutableArray *tempArray=[NSMutableArray new];
        
        [tempArray addObject:@""];//headerID
        [tempArray addObject:@"WW"];
        
        if (workApprovalObjArt.length) {
            
            [tempArray addObject:workApprovalObjArt];//applicationID
            
        }
        else{
            
            [tempArray addObject:[NSString stringWithFormat:@"WW0001"]];//applicationID
            
        }
        
        [tempArray addObject:plantWorkCenterID];
        
        if (wcmUsageID.length) {
            
            [tempArray addObject:wcmUsageID];//usage
            
        }
        else{
            
            [tempArray addObject:@""];//usage
            
        }
        [tempArray addObject:wcmUsageTextField.text];//usageX
        
        [tempArray addObject:@""];//train
        [tempArray addObject:@""];//trainx
        [tempArray addObject:@""];//anizu
        [tempArray addObject:@""];//anizux
        [tempArray addObject:@""];//etape
        [tempArray addObject:@""];//etapex
        [tempArray addObject:wcmShortTextField.text];//stext
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MMM dd, yyyy"];
        NSDate *startDate = [dateFormatter dateFromString:wcmFromDateTextfield.text];
        NSDate *endDate = [dateFormatter dateFromString:wcmToDateTextfield.text];
        // Convert date object into desired format
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        
        NSString *convertedStartDateString = [dateFormatter stringFromDate:startDate];
        
        if (![NullChecker isNull:convertedStartDateString]) {
            
            [tempArray addObject:convertedStartDateString];//DateFr
            
        }
        else{
            
            [tempArray addObject:@""];
            
        }
        
        
        [tempArray addObject:wcmFromTimeTextfield.text];//TimeFr
        
        
        NSString *convertedEndDateString = [dateFormatter stringFromDate:endDate];
        
        if (![NullChecker isNull:convertedEndDateString]) {
            [tempArray addObject:convertedEndDateString];//DateTo
        }
        else{
            
            [tempArray addObject:@""];
            
        }
        
        [tempArray addObject:wcmToTimeTextfield.text];//TimeTo
        
        
        if (wcmPriorityId.length) {
            
            [tempArray addObject:wcmPriorityId];//priorityId
        }
        else{
            
            [tempArray addObject:@""];
        }
        
        [tempArray addObject:wcmPriorityTextfield.text];//PriorityText
        
        [tempArray addObject:@""];//rctime
        [tempArray addObject:@""];//rcunit
        [tempArray addObject:@""];//objnr
        [tempArray addObject:@""];//refobjnr
        [tempArray addObject:@""];//created
        
        if (setPreparedString.length) {
            [tempArray addObject:setPreparedString];//prep
        }
        else{
            [tempArray addObject:@""];
        }
        
        [tempArray addObject:@""];//comp
        
        if (!changeWorkApprovalFlag) {
            
            [tempArray addObject:@""];//appr
            
        }
        else{
            
            NSMutableArray * workApprovalIssuepemitsArray=[NSMutableArray new];
            
            for (int i =0; i<[self.issuePermitsDetailArray count]; i++) {
                
                [workApprovalIssuepemitsArray  addObject:[self.issuePermitsDetailArray objectAtIndex:i]];
                
            }
            
            NSMutableArray *workApprovalTrafficArray=[NSMutableArray new];
            
            for (int k=0; k<[workApprovalIssuepemitsArray count]; k++) {
                
                if ([[[workApprovalIssuepemitsArray objectAtIndex:k] objectAtIndex:9] isEqualToString:@""]) {
                    
                    [workApprovalTrafficArray addObject:[NSNumber numberWithInteger:k]];
                }
            }
            
            if (![workApprovalTrafficArray count]) {
                
                [tempArray addObject:@"R"]; //appr
                
            }
            else if ([self.issuePermitsDetailArray count] == [workApprovalTrafficArray count]){
                
                [tempArray addObject:@"G"]; //appr
                
            }
            else {
                
                [tempArray addObject:@"Y"]; //appr
                
            }
            
        }
        
        
        [tempArray addObject:@""];//pappr
        
        if (workApprovalObjArt.length) {
            
            [tempArray addObject:@"U"];//action
            
        }
        else{
            
            [tempArray addObject:@"I"];//action
            
        }
        
        if (wcmUserGroupID.length) {
            
            [tempArray addObject:wcmUserGroupID];//Begru
            
        }
        
        else{
            
            [tempArray addObject:@""];//Begru
            
        }
        
        [tempArray addObject:wcmUsergrouptextField.text];//Begrutxt
        
        
        if (![self.workApplicationDetailsArray count]){
            
            UIAlertView *failureAlertView = [[UIAlertView alloc]initWithTitle:@"Information" message:@"Please Add Atleast One Application" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            
            [failureAlertView show];
            
            [self.view addSubview:workApprovalHeaderView];
            
        }
        else{
            
            if (!([self.workApprovalDetailsArray count])){
                
                [self.workApprovalDetailsArray addObject:tempArray];
            }
            else{
                
                [self.workApprovalDetailsArray replaceObjectAtIndex:0 withObject:tempArray];
                
            }
            
            [workApprovalTableView reloadData];
            
        }
        
    }
    
    else
    {
        
        
        NSMutableArray *tempArray=[NSMutableArray new];
        
        [tempArray addObject:@""];//headerID
        [tempArray addObject:@"WA"];
        
        if (!changeWorkApprovalFlag) {
            
            [tempArray addObject:[NSString stringWithFormat:@"WA%@",vornrApplicationString]];//applicationID
            
            [tempArray addObject:plantWorkCenterID];
            
            [tempArray addObject:[[self.applicationTypesArray objectAtIndex:applicationSelectedIndex] objectAtIndex:4]];//objtype
        }
        else{
            [tempArray addObject:applicationObjArt];//applicationID
            
            [tempArray addObject:plantWorkCenterID];
            
            [tempArray addObject:applicationTypeString];
        }
        
        
        if (wcmUsageID.length) {
            
            [tempArray addObject:wcmUsageID];//usage
            
        }
        else{
            
            [tempArray addObject:@""];//usage
            
        }
        
        [tempArray addObject:wcmUsageTextField.text];//usageX
        
        [tempArray addObject:@""];//train
        [tempArray addObject:@""];//trainx
        [tempArray addObject:@""];//anizu
        [tempArray addObject:@""];//anizux
        [tempArray addObject:@""];//etape
        [tempArray addObject:@""];//etapex
        [tempArray addObject:wcmShortTextField.text];//stext
        
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MMM dd, yyyy"];
        NSDate *startDate = [dateFormatter dateFromString:wcmFromDateTextfield.text];
        NSDate *endDate = [dateFormatter dateFromString:wcmToDateTextfield.text];
        // Convert date object into desired format
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        
        NSString *convertedStartDateString = [dateFormatter stringFromDate:startDate];
        
        if (![NullChecker isNull:convertedStartDateString]) {
            
            [tempArray addObject:convertedStartDateString];
            
        }
        else{
            
            [tempArray addObject:@""];
        }
        
        [tempArray addObject:wcmFromTimeTextfield.text];
        
        NSString *convertedEndDateString = [dateFormatter stringFromDate:endDate];
        
        if (![NullChecker isNull:convertedEndDateString]) {
            [tempArray addObject:convertedEndDateString];
        }
        else{
            
            [tempArray addObject:@""];
            
        }
        
        [tempArray addObject:wcmToTimeTextfield.text];
        
        
        if (wcmPriorityId.length) {
            [tempArray addObject:wcmPriorityId];//priorityId
        }
        else{
            [tempArray addObject:@""];
        }
        
        [tempArray addObject:wcmPriorityTextfield.text];//PriorityText
        
        [tempArray addObject:@""];//rctime
        [tempArray addObject:@""];//rcunit
        
        
        if (!changeApplicationFlag) {
            
            [tempArray addObject:@""];//objnr
            [tempArray addObject:@"WW0001"];//refobj
            
        }
        else{
            
            [tempArray addObject:objnrIdPosition];//objnr
            
            [tempArray addObject:refObjString];//refobj
            
            
        }
        
        [tempArray addObject:@""];//created
        
        if (setPreparedString.length) {
            [tempArray addObject:setPreparedString];//prep
        }
        else{
            [tempArray addObject:@""];
        }
        
        [tempArray addObject:@""];//comp
        
        
        if (!changeApplicationFlag) {
            
            [tempArray addObject:@""];//appr
            
        }
        else{
            
            NSMutableArray *issuedApplicationsArray=[NSMutableArray new];
            
            for (int j=0; j<[self.workApplicationDetailsArray count]; j++) {
                
                if ([[[[self.workApplicationDetailsArray objectAtIndex:j] firstObject] objectAtIndex:27] isEqualToString:@"G"]) {
                    [issuedApplicationsArray addObject:[NSNumber numberWithInteger:j]];
                }
                
            }
            if ([issuedApplicationsArray count]==[self.workApplicationDetailsArray count]) {
                
                [tempArray addObject:@"G"];//appr
                
            }
            else{
                
                NSMutableArray * workApplicationpemitsArray=[NSMutableArray new];
                
                for (int i =0; i<[self.issuePermitsDetailArray count]; i++) {
                    
                    if ([[[self.issuePermitsDetailArray objectAtIndex:i] objectAtIndex:5] isEqualToString:@"WA"]&&![[[self.issuePermitsDetailArray objectAtIndex:i] objectAtIndex:6] isEqualToString:@"1"]) {
                        
                        [workApplicationpemitsArray  addObject:[self.issuePermitsDetailArray objectAtIndex:i]];
                        
                    }
                }
                
                NSMutableArray *workApplicationTrafficArray=[NSMutableArray new];
                
                for (int k=0; k<[workApplicationpemitsArray count]; k++) {
                    
                    if ([[[workApplicationpemitsArray objectAtIndex:k] objectAtIndex:9] isEqualToString:@""]) {
                        
                        [workApplicationTrafficArray addObject:[NSNumber numberWithInteger:k]];
                    }
                }
                
                if (![workApplicationTrafficArray count]) {
                    
                    [tempArray addObject:@"R"]; //appr
                    
                }
                else if ([workApplicationpemitsArray count] == [workApplicationTrafficArray count]){
                    
                    [tempArray addObject:@"G"]; //appr
                    
                }
                else {
                    
                    [tempArray addObject:@"Y"]; //appr
                    
                }
            }
            
        }
        
        
        if (!changeWorkApprovalFlag) {
            [tempArray addObject:@"I"];//action
            
        }
        else{
            
            [tempArray addObject:@"U"];//action
            
        }
        
        
        if (wcmUserGroupID.length) {
            
            [tempArray addObject:wcmUserGroupID];//Begru
            
        }
        
        else{
            
            [tempArray addObject:@""];//Begru
            
        }
        
        [tempArray addObject:wcmUsergrouptextField.text];//Begrutxt
        
        
        NSString *hazardFlag;
        NSString *controlFlag;
        
        for (int i=0; i<[[self.hazardsControlSCheckpointsArray firstObject] count]; i++) { //hazard loop
            
            if ([[[[self.hazardsControlSCheckpointsArray firstObject] objectAtIndex:i] objectAtIndex:5] isEqualToString:@"Y"]) {
                hazardFlag=@"X";
            }
        }
        
        for (int i=0; i<[[self.hazardsControlSCheckpointsArray lastObject] count]; i++) { //control loop
            
            
            if ([[[[self.hazardsControlSCheckpointsArray lastObject] objectAtIndex:i] objectAtIndex:5] isEqualToString:@"Y"]) {
                
                controlFlag=@"X";
            }
        }
        
        
        if (![self.hazardsControlSCheckpointsArray count]) {
            
            UIAlertView *failureAlertView = [[UIAlertView alloc]initWithTitle:@"Information" message:@"Please select standard  checkpoints " delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            [failureAlertView show];
            
            [self.view addSubview:workApprovalHeaderView];
            
        }
        
        else  if (![hazardFlag isEqualToString:@"X"]) {
            
            UIAlertView *failureAlertView = [[UIAlertView alloc]initWithTitle:@"Information" message:@"Please select atleast one 'Work'" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            [failureAlertView show];
            
            [self.view addSubview:workApprovalHeaderView];
            
        }
        else if (![controlFlag isEqualToString:@"X"]) {
            
            UIAlertView *failureAlertView = [[UIAlertView alloc]initWithTitle:@"Information" message:@"Please select atleast one 'Requirement'" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            [failureAlertView show];
            
            [self.view addSubview:workApprovalHeaderView];
            
            
        }
        
        else{
            
            addWorkApprovalFlag=YES;
            
            for (int i=0; i<[[self.hazardsControlSCheckpointsArray objectAtIndex:0] count]; i++) {
                
                if (!changeWorkApprovalFlag) {
                    
                    [[[self.hazardsControlSCheckpointsArray objectAtIndex:0] objectAtIndex:i] replaceObjectAtIndex:0 withObject:[NSString stringWithFormat:@"WA%@",vornrApplicationString]];
                    
                    [[[self.hazardsControlSCheckpointsArray objectAtIndex:0] objectAtIndex:i] replaceObjectAtIndex:1 withObject:applicationTypeString];
                }
                else{
                    
                    [[[self.hazardsControlSCheckpointsArray objectAtIndex:0] objectAtIndex:i] replaceObjectAtIndex:0 withObject:applicationObjArt];
                    
                    [[[self.hazardsControlSCheckpointsArray objectAtIndex:0] objectAtIndex:i] replaceObjectAtIndex:1 withObject:applicationTypeString];
                }
                
            }
            
            for (int i=0; i<[[self.hazardsControlSCheckpointsArray objectAtIndex:1] count]; i++) {
                
                if (!changeWorkApprovalFlag) {
                    
                    [[[self.hazardsControlSCheckpointsArray objectAtIndex:1] objectAtIndex:i] replaceObjectAtIndex:0 withObject:[NSString stringWithFormat:@"WA%@",vornrApplicationString]];
                    
                    [[[self.hazardsControlSCheckpointsArray objectAtIndex:1] objectAtIndex:i] replaceObjectAtIndex:1 withObject:applicationTypeString];
                }
                else{
                    
                    [[[self.hazardsControlSCheckpointsArray objectAtIndex:1] objectAtIndex:i] replaceObjectAtIndex:0 withObject:applicationObjArt];
                    
                    [[[self.hazardsControlSCheckpointsArray objectAtIndex:1] objectAtIndex:i] replaceObjectAtIndex:1 withObject:applicationTypeString];
                }
                
            }
            
            if (!changeWorkApprovalFlag) {
                
                NSMutableArray *tempApplicationDetailsarray=[NSMutableArray new];
                [tempApplicationDetailsarray addObject:@""];
                [tempApplicationDetailsarray addObject:[NSString stringWithFormat:@"%@%@",[[self.applicationTypesArray objectAtIndex:applicationSelectedIndex] objectAtIndex:2],vornrApplicationString]];
                [tempApplicationDetailsarray addObject:[[self.applicationTypesArray objectAtIndex:applicationSelectedIndex] objectAtIndex:4]];
                [tempApplicationDetailsarray addObject:[[self.applicationTypesArray objectAtIndex:applicationSelectedIndex] objectAtIndex:3]];
                [tempApplicationDetailsarray addObject:@""];
                [self.applicationDetailsArray addObject:tempApplicationDetailsarray];
                //  [self.applicationHeaderDetailsArray addObject:tempArray];
                
                [[self.workApplicationDetailsArray objectAtIndex:checkPointSelectedIndex] replaceObjectAtIndex:0 withObject:tempArray];
                
            }
            else{
                
                
                NSMutableArray *tempApplicationDetailsarray=[NSMutableArray new];
                [tempApplicationDetailsarray addObject:@""];
                
                if (applicationObjArt.length) {
                    
                    [tempApplicationDetailsarray addObject:applicationObjArt];
                }
                else{
                    [tempApplicationDetailsarray addObject:[NSString stringWithFormat:@"%@%@",[[self.applicationTypesArray objectAtIndex:applicationSelectedIndex] objectAtIndex:2],vornrApplicationString]];
                }
                [tempApplicationDetailsarray addObject:[[[self.workApplicationDetailsArray objectAtIndex:waSelectedIndex] firstObject] objectAtIndex:4]];
                [tempApplicationDetailsarray addObject:[[[self.workApplicationDetailsArray objectAtIndex:waSelectedIndex] firstObject] objectAtIndex:3]];
                [tempApplicationDetailsarray addObject:@""];
                
                [self.applicationDetailsArray addObject:tempApplicationDetailsarray];
                [self.applicationHeaderDetailsArray addObject:tempArray];
                
                [[self.workApplicationDetailsArray objectAtIndex:workApplicationSelectedIndex] replaceObjectAtIndex:0 withObject:tempArray];
                
            }
            
            [applicationTypeTableView reloadData];
            [self.view addSubview:applicationTypeView];
        }
    }
}


-(void)trafficSignalforIsolationWApplication{
    
    NSMutableArray * workApplicationsIssuepemitsArray=[NSMutableArray new];
    NSMutableArray * workApplicationsIsolationIssuepemitsArray=[NSMutableArray new];
    
    for (int i =0; i<[self.issuePermitsDetailArray count]; i++) {
        
        if ([[[self.issuePermitsDetailArray objectAtIndex:i] objectAtIndex:5] isEqualToString:@"WA"]&&[[[self.issuePermitsDetailArray objectAtIndex:i] objectAtIndex:6] isEqualToString:@"1"]) {
            
            [workApplicationsIsolationIssuepemitsArray  addObject:[self.issuePermitsDetailArray objectAtIndex:i]];
        }
        
        else if ([[[self.issuePermitsDetailArray objectAtIndex:i] objectAtIndex:5] isEqualToString:@"WA"]&&![[[self.issuePermitsDetailArray objectAtIndex:i] objectAtIndex:6] isEqualToString:@"1"])
        {
            
            [workApplicationsIssuepemitsArray  addObject:[self.issuePermitsDetailArray objectAtIndex:i]];
        }
        
    }
    
    NSMutableArray *workApplicationTrafficArray=[NSMutableArray new];
    NSMutableArray *workApplicationIsolationTrafficArray=[NSMutableArray new];
    
    if ([applicationTypeString isEqualToString:@"1"]) {
        
        for (int k=0; k<[workApplicationsIsolationIssuepemitsArray count]; k++) {
            
            if ([[[workApplicationsIsolationIssuepemitsArray objectAtIndex:k] objectAtIndex:9] isEqualToString:@""]) {
                
                [workApplicationIsolationTrafficArray addObject:[NSNumber numberWithInteger:k]];
            }
        }
    }
    else{
        
        for (int k=0; k<[workApplicationsIssuepemitsArray count]; k++) {
            
            if ([[[workApplicationsIssuepemitsArray objectAtIndex:k] objectAtIndex:9] isEqualToString:@""]) {
                
                [workApplicationTrafficArray addObject:[NSNumber numberWithInteger:k]];
            }
        }
    }
    
    if ([applicationTypeString isEqualToString:@"1"]) {
        
        if (![workApplicationIsolationTrafficArray count]) {
            
            isolationPermitImage.image=[UIImage imageNamed:@"red_traffic.png"];
        }
        
        else  if ([workApplicationIsolationTrafficArray count] == [workApplicationsIsolationIssuepemitsArray count]) {
            
            isolationPermitImage.image=[UIImage imageNamed:@"green_traffic.png"];
        }
        
        else  if ([workApplicationIsolationTrafficArray count] >= [workApplicationsIsolationIssuepemitsArray count]) {
            
            isolationPermitImage.image=[UIImage imageNamed:@"yellow_traffic.png"];
        }
        
    }
    
    else{
        
        if (![workApplicationTrafficArray count]) {
            
            issuepermitImage.image=[UIImage imageNamed:@"red_traffic.png"];
        }
        
        else  if ([workApplicationTrafficArray count] == [workApplicationsIssuepemitsArray count]) {
            
            issuepermitImage.image=[UIImage imageNamed:@"green_traffic.png"];
            
        }
        else{
            
            issuepermitImage.image=[UIImage imageNamed:@"yellow_traffic.png"];
            
        }
    }
    
}

-(void)trafficSignalForOpwcdScreen{
    
    NSMutableArray *opwcdIssuepemitsArray=[NSMutableArray new];
    
    for (int i =0; i<[self.issuePermitsDetailArray count]; i++) {
        
        
        if ([[[self.issuePermitsDetailArray objectAtIndex:i] objectAtIndex:5] isEqualToString:@"WD"]) {
            
            [opwcdIssuepemitsArray  addObject:[self.issuePermitsDetailArray objectAtIndex:i]];
        }
    }
    
    NSMutableArray *operationWCDTrafficArray=[NSMutableArray new];
    
    for (int k=0; k<[opwcdIssuepemitsArray count]; k++) {
        
        if ([[[opwcdIssuepemitsArray objectAtIndex:k] objectAtIndex:9] isEqualToString:@""]) {
            
            [operationWCDTrafficArray addObject:[NSNumber numberWithInteger:k]];
        }
    }
    
    if (![operationWCDTrafficArray count]) {
        
        isolationPermitImage.image=[UIImage imageNamed:@"red_traffic.png"];
        
    }
    
    else if ([opwcdIssuepemitsArray count] == [operationWCDTrafficArray count]) {
        
        isolationPermitImage.image=[UIImage imageNamed:@"green_traffic.png"];
        
    }
    
    else{
        
        isolationPermitImage.image=[UIImage imageNamed:@"yellow_traffic.png"];
    }
}

-(void)checkpointValidation{
    
    self.checkPointSegmentControl.selectedSegmentIndex=0;
 
    if (self.hazardsControlSCheckpointsArray == nil) {
        self.hazardsControlSCheckpointsArray=[NSMutableArray new];
    }
    else
    {
        [self.hazardsControlSCheckpointsArray removeAllObjects];
    }
    
    
    if (!changeApplicationFlag) {
        
        [self.hazardsControlSCheckpointsArray addObjectsFromArray:[[DataBase sharedInstance] fetchWCMRequestsforCreateApplicationType:plantWorkCenterID forUsage:wcmUsageID]];
    }
    else{
        
        [self.hazardsControlSCheckpointsArray addObjectsFromArray:[NSMutableArray arrayWithObjects:[[self.workApplicationDetailsArray objectAtIndex:waSelectedIndex] objectAtIndex:1],[[self.workApplicationDetailsArray objectAtIndex:waSelectedIndex] objectAtIndex:2], nil]];
    }
    
    checkPointTableView.tag=0;
    [checkPointTableView reloadData];
    
    [checkPointView setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    
    [self.view  addSubview:checkPointView];
}


-(IBAction)addNewOperaionClicked:(id)sender
{
    updateOperationsBtn.hidden = YES;
    
    addOperationsBtn.hidden= NO;
 
    if (!durationTextField.text.length) {
        
        durationID = @"HR";
        
        durationTextField.text = durationID;
    }
    
    addOperationHeaderLabel.text=@"New Operation";
    
    operationTextFieldString = @"";
 
    durationTextField.text = @"";
 
}

-(IBAction)addNewPartClicked:(id)sender
{
    updateComponent.hidden = YES;
    
    addComponentButton.hidden = NO;
    
    rsNuMLabel.hidden=YES;
    
    partHeaderLabel.text = @"New Component";
    operationNoTextField.userInteractionEnabled = YES;
    
}


-(IBAction)checkPointSegmentController:(id)sender{
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.75];
    
    self.wsmSegmentControl = (UISegmentedControl *)sender;
    int clickedSegment=(int)[self.checkPointSegmentControl selectedSegmentIndex];
 
    switch (clickedSegment)
    {
        case 0:
            
            [UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:checkPointTableView cache:NO];
            
            checkPointTableView.tag=0;
            [checkPointTableView reloadData];
 
            break;
            
        case 1:
            
            [UIView setAnimationTransition:UIViewAnimationTransitionCurlDown forView:checkPointTableView cache:NO];
            
            checkPointTableView.tag=1;
            [checkPointTableView reloadData];
            
            break;
            
        default:break;
    }
    
     [UIView commitAnimations];
}

- (IBAction)CheckPointOkClicked:(id)sender{
    
    NSString *hazardFlag;
    NSString *controlFlag;
    
    for (int i=0; i<[[self.hazardsControlSCheckpointsArray firstObject] count]; i++) { //hazard loop
        
        if ([[[[self.hazardsControlSCheckpointsArray firstObject] objectAtIndex:i] objectAtIndex:5] isEqualToString:@"Y"]) {
            hazardFlag=@"X";
        }
        
        if ([[[[self.hazardsControlSCheckpointsArray firstObject] objectAtIndex:i] objectAtIndex:13] isEqualToString:@"X"]){
            
            [[[self.hazardsControlSCheckpointsArray firstObject] objectAtIndex:i] replaceObjectAtIndex:5 withObject:@"Y"];
            
         }
     }
    
    for (int i=0; i<[[self.hazardsControlSCheckpointsArray lastObject] count]; i++) { //control loop
        
        
        if ([[[[self.hazardsControlSCheckpointsArray lastObject] objectAtIndex:i] objectAtIndex:5] isEqualToString:@"Y"]) {
            
            controlFlag=@"X";
        }
        
        if ([[[[self.hazardsControlSCheckpointsArray lastObject] objectAtIndex:i] objectAtIndex:13] isEqualToString:@"X"]){
            
            [[[self.hazardsControlSCheckpointsArray lastObject] objectAtIndex:i] replaceObjectAtIndex:5 withObject:@"Y"];
        }
    }
    
    if (![hazardFlag isEqualToString:@"X"]) {
        
        UIAlertView *failureAlertView = [[UIAlertView alloc]initWithTitle:@"Information" message:@"Please select atleast one 'Work'" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [failureAlertView show];
    }
    else if (![controlFlag isEqualToString:@"X"]) {
        
        UIAlertView *failureAlertView = [[UIAlertView alloc]initWithTitle:@"Information" message:@"Please select atleast one 'Requirement'" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [failureAlertView show];
        
    }
    else{
        
        if (!changeApplicationFlag) {
            
            [self newWorkApplicationDetailsMethod];
            
            //            [self.checkPointTypeApplicationHeaderDetailsArray addObject:[self.hazardsControlSCheckpointsArray firstObject]];
            //            [self.checkPointTypeApplicationHeaderDetailsArray addObject:[self.hazardsControlSCheckpointsArray lastObject]];
            
            
            [[self.workApplicationDetailsArray objectAtIndex:checkPointSelectedIndex]  addObject:[self.hazardsControlSCheckpointsArray firstObject]];
            [[self.workApplicationDetailsArray objectAtIndex:checkPointSelectedIndex] addObject:[self.hazardsControlSCheckpointsArray lastObject]];
            
        }
        else
        {
            
            [[self.workApplicationDetailsArray objectAtIndex:waSelectedIndex] replaceObjectAtIndex:1 withObject:[self.hazardsControlSCheckpointsArray firstObject]];
            
            [[self.workApplicationDetailsArray objectAtIndex:waSelectedIndex] replaceObjectAtIndex:2 withObject:[self.hazardsControlSCheckpointsArray lastObject]];
            
        }
        
        
        //        [self.finalCheckPointsArray addObject:self.hazardsControlSCheckpointsArray];
        [checkPointView removeFromSuperview];
    }
 }



-(void)newWorkApplicationDetailsMethod{
    
 
    checkPointSelectedIndex=0;
    
    VornrWApprovalId=0;
    VornrApplicationId=VornrApplicationId+01;
    
    vornrApplicationString =[NSString stringWithFormat:@"%04i",VornrApplicationId];
    
    
    NSMutableArray *tempArray=[NSMutableArray new];
    
    [tempArray addObject:@""];//headerID
    [tempArray addObject:@"WA"];
    
    [tempArray addObject:[NSString stringWithFormat:@"WA%@",vornrApplicationString]];//applicationID
    
    [tempArray addObject:plantWorkCenterID];
    [tempArray addObject:[[self.applicationTypesArray objectAtIndex:applicationSelectedIndex] objectAtIndex:4]];//objtype
    
    
    if (wcmUsageID.length) {
        [tempArray addObject:wcmUsageID];//usage
    }
    
    else{
        [tempArray addObject:@""];//usage
    }
    
    [tempArray addObject:wcmUsageTextField.text];//usagex
    
    
    [tempArray addObject:@""];//train
    [tempArray addObject:@""];//trainx
    [tempArray addObject:@""];//anizu
    [tempArray addObject:@""];//anizux
    [tempArray addObject:@""];//etape
    [tempArray addObject:@""];//etapex
    [tempArray addObject:wcmShortTextField.text];//stext
    
    //    [tempArray addObject:wcmFromDateTextfield.text];//FromDate
    //    [tempArray addObject:wcmFromTimeTextfield.text];//FromTime
    //    [tempArray addObject:wcmToDateTextfield.text];//ToDate
    //    [tempArray addObject:wcmToTimeTextfield.text];//ToTime
    
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMM dd, yyyy"];
    NSDate *startDate = [dateFormatter dateFromString:wcmFromDateTextfield.text];
    NSDate *endDate = [dateFormatter dateFromString:wcmToDateTextfield.text];
    // Convert date object into desired format
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    
    NSString *convertedStartDateString = [dateFormatter stringFromDate:startDate];
    
    if (![NullChecker isNull:convertedStartDateString]) {
        
        [tempArray addObject:convertedStartDateString];
        
    }
    else{
        
        [tempArray addObject:@""];
        
    }
    
    
    [tempArray addObject:wcmFromTimeTextfield.text];
    
    
    NSString *convertedEndDateString = [dateFormatter stringFromDate:endDate];
    
    if (![NullChecker isNull:convertedEndDateString]) {
        [tempArray addObject:convertedEndDateString];
    }
    else{
        
        [tempArray addObject:@""];
        
    }
    
    [tempArray addObject:wcmToTimeTextfield.text];
    
    
    
    if (wcmPriorityId.length) {
        [tempArray addObject:wcmPriorityId];//priorityId
    }
    else{
        [tempArray addObject:@""];
    }
    
    [tempArray addObject:wcmPriorityTextfield.text];//PriorityText
    
    [tempArray addObject:@""];//rctime
    [tempArray addObject:@""];//rcunit
    [tempArray addObject:@""];//objnr
    [tempArray addObject:@""];//refobjnr
    [tempArray addObject:@""];//created
    
    
    if (setPreparedString.length) {
        [tempArray addObject:setPreparedString];//prep
    }
    else{
        [tempArray addObject:@""];
    }
    
    [tempArray addObject:@""];//comp
    [tempArray addObject:@""];//appr
    [tempArray addObject:@"I"];
    
    
    if (wcmUserGroupID.length) {
        [tempArray addObject:wcmUserGroupID];//Begru
    }
    
    else{
        [tempArray addObject:@""];//Begru
    }
    
    [tempArray addObject:wcmUsergrouptextField.text];//Begrux
    
    [self.workApplicationDetailsArray addObject:[NSMutableArray array]];
    
    for (int i=0; i<[self.workApplicationDetailsArray count]; i++) {
        
        checkPointSelectedIndex=i;
    }
    
    [[self.workApplicationDetailsArray objectAtIndex:checkPointSelectedIndex] addObject:tempArray];
    
    // [self.checkPointTypeApplicationHeaderDetailsArray addObject:tempArray];
    
}

-(IBAction)addOperationDetails:(id)sender{
    
    if(![JEValidator validateTextValue:operationLongTextView.text])
    {
 
        [self showAlertMessageWithTitle:@"" message:@"Please enter operation text" cancelButtonTitle:@"Ok" withactionType:@"Single" forMethod:nil];
        
     }
    else if ([NullChecker isNull:operationTextFieldString]){
        
         [self showAlertMessageWithTitle:@"" message:@"Please enter Short text" cancelButtonTitle:@"Ok" withactionType:@"Single" forMethod:nil];
    }
   
    else{
        
        updateOperationsBtn.hidden = YES;
        vornrOperationID =[NSString stringWithFormat:@"%04i",VornrOperation];
        
        if (operationNoArray == nil) {
            operationNoArray = [NSMutableArray new];
        }
        
        [operationNoArray addObject:[NSArray arrayWithObjects:vornrOperationID,operationTextFieldString, nil]];
        
        if ([NullChecker isNull:operationLongTextView.text]) {
            operationLongTextView.text = @"";
        }
        
        if ([NullChecker isNull:plantWorkCenterOperatonID]) {
            plantWorkCenterOperatonID = @"";
        }
        
        if ([NullChecker isNull:workCenterOperationID]) {
            workCenterOperationID = @"";
        }
        
        if ([NullChecker isNull:controlKeyId]) {
            controlKeyId = @"";
        }
        
        if ([NullChecker isNull:str_OperationLongText])
        {
            str_OperationLongText = @"";
        }
        
        /*
         CREATE TABLE "ORDER_TRANSACTION" ("ordert_header_id" VARCHAR,"ordert_vornr_operation" VARCHAR,"ordert_operation_name" VARCHAR,"ordert_duration_name" VARCHAR,"ordert_duration_id" VARCHAR,"ordert_fsavd" VARCHAR,"ordert_ssedd" VARCHAR,"ordert_rueck" VARCHAR,"ordert_aueru" VARCHAR,"ordert_operation_action" VARCHAR,"ordert_status" VARCHAR,"ordert_conftext" VARCHAR,"ordert_actwork" VARCHAR,"ordert_unwork" VARCHAR,"ordert_larnt" VARCHAR,"ordert_pernr" VARCHAR,"ordert_plnal" VARCHAR,"ordert_plnnr" VARCHAR,"ordert_plnty" VARCHAR,"ordert_steus" VARCHAR,"ordert_operationlongtext" VARCHAR,"usr01" VARCHAR,"bemot" VARCHAR,"grund" VARCHAR,"learr" VARCHAR,"leknw" VARCHAR,"operation_plantid" VARCHAR,"operation_plantname" VARCHAR,"operation_workcenterid" VARCHAR,"operation_workcentertext" VARCHAR,"ordert_steustext" VARCHAR)
         
         [self.operationDetailsArray addObject:[NSArray arrayWithObjects:[NSArray arrayWithObjects:[orderUDID copy],[vornrOperationID copy],[operationTextField.text copy],[durationInputTextField.text copy],[durationTextField.text copy],"","","","","A","","","","","","","","","","",[operationLongTextView.text copy],"","","","","",[plantWorkCenterOperatonID copy],[operationPlanttextField.text copy],[plantWorkCenterOperatonID copy],[operationWkcenterTextfield.text copy],[operationControlKeyTextfield.text copy], nil],[NSArray arrayWithObjects:[defaults objectForKey:@"tempCustomOperation"], nil], nil]];
         
         */
        
        NSMutableDictionary *addOperationsDictionary = [NSMutableDictionary new];
        
        [addOperationsDictionary setObject:[orderUDID copy] forKey:@"ID"];
        [addOperationsDictionary setObject:[vornrOperationID copy] forKey:@"OPERATIONKEY"];
 
        [addOperationsDictionary setObject:operationTextFieldString forKey:@"OPERATIONTEXT"];
        [addOperationsDictionary setObject:[operationLongTextView.text copy] forKey:@"OPERATIONLONGTEXT"];
        
        [addOperationsDictionary setObject:[durationInputTextField.text copy] forKey:@"DURATIONTEXTINPUT"];
        [addOperationsDictionary setObject:[durationTextField.text copy] forKey:@"DURATIONTEXT"];
         [addOperationsDictionary setObject:[plantWorkCenterOperatonID copy] forKey:@"OPERATIONPLANTID"];
        [addOperationsDictionary setObject:[operationPlanttextField.text copy] forKey:@"OPERATIONPLANTTEXT"];
        [addOperationsDictionary setObject:[workCenterOperationID copy] forKey:@"OPERATIONWORKCENTERID"];
        [addOperationsDictionary setObject:[operationWkcenterTextfield.text copy] forKey:@"OPERATIONWORKCENTERTEXT"];
         [addOperationsDictionary setObject:@"" forKey:@"CONTROLKEYID"];
        [addOperationsDictionary setObject:@"" forKey:@"CONTROLKEYTEXT"];
        
        [addOperationsDictionary setObject:[NSArray arrayWithObjects:[defaults objectForKey:@"tempCustomOperation"], nil]  forKey:@"CUSTOM"];
 
        [[DataBase sharedInstance] insertOrderTranscationDetails:addOperationsDictionary];
        
        [self.operationDetailsArray removeAllObjects];
        
        [self.operationDetailsArray addObjectsFromArray:[[DataBase sharedInstance] fetchOrderTransactionDetailsForUUID:[orderUDID copy]]];
        
        for (int i=0; i<[self.operationDetailsArray count]; i++) {
            
            if ([[[[self.operationDetailsArray objectAtIndex:i] firstObject] objectAtIndex:9] isEqualToString:@"D"]){
                
                [self.operationDetailDeleteArray addObject:[NSMutableArray arrayWithArray:[self.operationDetailsArray objectAtIndex:i]]];
                [self.operationDetailsArray removeObjectAtIndex:i];
                --i;
            }
        }
        
        operationTextFieldString = @"";
        operationLongTextView.text = @"";
        durationInputTextField.text =@"";
        durationTextField.text = @"";
        durationID = @"";
        
        controlKeyId = @"";
        str_OperationLongText = @"";
        
        operationControlKeyTextfield.text = @"";
        
        updateOperationsBtn.hidden = YES;
        
        VornrOperation = VornrOperation+10;
        
        //        [self componentsDisabling];
        [self partialConfirmationEnabling];
        
        durationTextField.userInteractionEnabled = YES;
        durationInputTextField.userInteractionEnabled = YES;
        operationPlanttextField.userInteractionEnabled = YES;
        operationWkcenterTextfield.userInteractionEnabled = YES;
        operationControlKeyTextfield.userInteractionEnabled = YES;
        
        plantComponentsLabelid.hidden = YES;
        plantComponentTextField.hidden = YES;
        plantComponentSeperator.hidden = YES;
        
        plantComponentTextField.text = @"";
        storageLocationComponentTextField.text = @"";
        storageLocComponentsLabelid.hidden = YES;
        plantComponentSeperator.hidden=YES;
        storageLocationComponentTextField.hidden = YES;
        
        for (int  i =0; i<[self.customOperationDetailsArray count]; i++) {
            
            [[self.customOperationDetailsArray objectAtIndex:i] replaceObjectAtIndex:4 withObject:@""];
        }
        
        [defaults setObject:self.customOperationDetailsArray forKey:@"tempCustomOperation"];
        
        [defaults synchronize];
        
        commonlistTableView.tag=1;
        
        [commonlistTableView reloadData];
        
        [addOperationView removeFromSuperview];
    }
}





-(IBAction)updateOperationDetails:(id)sender{
    
    operationSelectedFlag = NO;
    
     if(![JEValidator validateTextValue:operationLongTextView.text])
    {
 
        [self showAlertMessageWithTitle:@"" message:@"Please enter operation text" cancelButtonTitle:@"Ok" withactionType:@"Single" forMethod:nil];
        
    }
    else{
        
        NSMutableDictionary *updateOperationsDictionary = [NSMutableDictionary new];
        
        [updateOperationsDictionary setObject:[orderUDID copy] forKey:@"ID"];
        
        [updateOperationsDictionary setObject:[[[self.self.operationDetailsArray objectAtIndex:currentOperationItemIndex] firstObject] objectAtIndex:1] forKey:@"OPERATIONKEY"];
        
        
        [updateOperationsDictionary setObject:operationTextFieldString forKey:@"OPERATIONTEXT"];
        [updateOperationsDictionary setObject:[operationLongTextView.text copy] forKey:@"OPERATIONLONGTEXT"];
        
        [updateOperationsDictionary setObject:[durationInputTextField.text copy] forKey:@"DURATIONTEXTINPUT"];
        [updateOperationsDictionary setObject:[durationTextField.text copy] forKey:@"DURATIONTEXT"];
        
        [updateOperationsDictionary setObject:[plantWorkCenterOperatonID copy] forKey:@"OPERATIONPLANTID"];
        [updateOperationsDictionary setObject:[operationPlanttextField.text copy] forKey:@"OPERATIONPLANTTEXT"];
        [updateOperationsDictionary setObject:[workCenterOperationID copy] forKey:@"OPERATIONWORKCENTERID"];
        [updateOperationsDictionary setObject:[operationWkcenterTextfield.text copy] forKey:@"OPERATIONWORKCENTERTEXT"];
        
        [updateOperationsDictionary setObject:@"" forKey:@"CONTROLKEYID"];
        [updateOperationsDictionary setObject:@"" forKey:@"CONTROLKEYTEXT"];
        
        [updateOperationsDictionary setObject:[NSArray arrayWithObjects:[defaults objectForKey:@"tempCustomOperation"],[defaults objectForKey:@"tempCustomComponent"], nil]  forKey:@"CUSTOM"];
        
        [[DataBase sharedInstance] updateOrderTransactions:updateOperationsDictionary];
        
        for (int i =0; i<[operationNoArray count]; i++) {
            if ([[[operationNoArray objectAtIndex:i] objectAtIndex:0] isEqual:vornrOperationID]) {
                [operationNoArray replaceObjectAtIndex:i withObject:[NSArray arrayWithObjects:vornrOperationID,operationTextFieldString, nil]];
            }
        }
        
        
        [self.operationDetailsArray removeAllObjects];
        
        [self.operationDetailsArray addObjectsFromArray:[[DataBase sharedInstance] fetchOrderTransactionDetailsForUUID:orderUDID]];
        
        if (self.operationDetailDeleteArray == nil) {
            self.operationDetailDeleteArray = [NSMutableArray new];
        }
        else{
            [self.operationDetailDeleteArray removeAllObjects];
        }
        
        VornrOperation = 0;
        VornrComponent = 10;
        
        for (int i=0; i<[self.operationDetailsArray count]; i++) {
            if ([[[[self.operationDetailsArray objectAtIndex:i] firstObject] objectAtIndex:18] isEqualToString:@"D"]){
                [self.operationDetailDeleteArray addObject:[NSMutableArray arrayWithArray:[self.operationDetailsArray objectAtIndex:i]]];
                [self.operationDetailsArray removeObjectAtIndex:i];
                --i;
            }
            
            vornrOperationID = [[[self.operationDetailsArray  objectAtIndex:i] firstObject]  objectAtIndex:1];
        }
        
        VornrOperation = [vornrOperationID intValue];
        
        VornrOperation = VornrOperation +10;
        
        vornrOperationID =[NSString stringWithFormat:@"%04i",VornrOperation];
        
 
        for (int  i =0; i<[self.customOperationDetailsArray count]; i++) {
            
            [[self.customOperationDetailsArray objectAtIndex:i] replaceObjectAtIndex:4 withObject:@""];
        }
        
        for (int  i =0; i<[self.customComponentsDetailsArray count]; i++) {
            
            [[self.customComponentsDetailsArray  objectAtIndex:i] replaceObjectAtIndex:4 withObject:@""];
        }
        
        [defaults setObject:self.customOperationDetailsArray forKey:@"tempCustomOperation"];
        [defaults setObject:self.customComponentsDetailsArray forKey:@"tempCustomComponent"];
        [defaults synchronize];
        
        commonlistTableView.tag=2;
        [commonlistTableView reloadData];
        
         updateOperationsBtn.hidden = YES;
        operationTextFieldString=@"";
        operationLongTextView.text = @"";
        durationTextField.text=@"";
        durationInputTextField.text=@"";
        componentTextField.text=@"";
        quantityTextField.text=@"";
        componentID = @"";
        plantID = @"";
        plantComponentTextField.text = @"";
        storageLocationID = @"";
      //  storageLocationTextField.text = @"";
        controlKeyId = @"";
        //    plantWorkCenterOperatonID = @"";
        //operationPlanttextField.text = @"";
        //    workCenterOperationID = @"";
        //operationWkcenterTextfield.text = @"";
        operationControlKeyTextfield.text = @"";
        //    [self componentsDisabling];
        addOperationsBtn.hidden=NO;
        plantComponentsLabelid.hidden = YES;
        plantComponentTextField.hidden = YES;
        storageLocComponentsLabelid.hidden = YES;
        storageLocationComponentTextField.hidden = YES;
        plantComponentSeperator.hidden = YES;
        
        submitResetView.hidden=NO;
        
//        customComponentFlag = YES;
//        customOperationFlag = YES;
        
        [addOperationView removeFromSuperview];
    }
}


-(void)partialConfirmationEnabling
{
    componentTextField.userInteractionEnabled=YES;
    durationInputTextField.userInteractionEnabled=YES;
    durationTextField.userInteractionEnabled=YES;
    quantityTextField.userInteractionEnabled=YES;
    operationWkcenterTextfield.userInteractionEnabled=YES;
    operationPlanttextField.userInteractionEnabled=YES;
    controlKeyTextField.userInteractionEnabled=YES;
    operationControlKeyTextfield.userInteractionEnabled = YES;
    
    componentTextField.backgroundColor=[UIColor clearColor];
    durationTextField.backgroundColor=[UIColor clearColor];
    durationInputTextField.backgroundColor=[UIColor clearColor];
    quantityTextField.backgroundColor=[UIColor clearColor];
    operationWkcenterTextfield.backgroundColor=[UIColor clearColor];
    
    operationPlanttextField.backgroundColor=[UIColor clearColor];
    operationPlanttextField.backgroundColor=[UIColor clearColor];
    controlKeyTextField.backgroundColor=[UIColor clearColor];
    operationControlKeyTextfield.backgroundColor=[UIColor clearColor];
    operationLongTextView.backgroundColor=[UIColor clearColor];
    
    updateOperationsBtn.hidden=YES;
    deleteOperationsBtn.hidden=YES;
}

-(void)functionLocationSearchAction:(id)sender
{
    
     NSIndexPath *ip = [self GetCellFromTableView:commonlistTableView Sender:sender];
     NSInteger i = ip.row;
    
     if (commonlistTableView.tag==0) {
        
        if (i==2) {
            
            FunctionLocationViewController *funcVc = [self.storyboard instantiateViewControllerWithIdentifier:@"FunctionLocationView"];
             funcVc.delegate=self;
             funcVc.searchString=@"X";
             [self showViewController:funcVc sender:self];
            
        }
        else if (i==3){
            
            EquipmentNumberViewController *equipVc = [self.storyboard instantiateViewControllerWithIdentifier:@"EquipIdentifier"];
             equipVc.functionLocationString =loactionId;
             equipVc.searchString=@"Y";
             equipVc.delegate=self;
 
            [self showViewController:equipVc sender:self];
          }
        
        else if (i==9){
            
            
            [self.dropDownArray removeAllObjects];
            
            [self.dropDownArray addObjectsFromArray:[[DataBase sharedInstance] getListOfWorkCenter]];
            
            funcLocnHeaderLabel.text = [NSString stringWithFormat:@"Work Center (%lu)",(unsigned long)[self.dropDownArray count]];
 
            [seachDropdownTableView registerNib:[UINib nibWithNibName:@"WorkcenterTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"WorkcenterCell"];
            
            [searchDropDownView setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
 
            [seachDropdownTableView reloadData];
            
            [self.view addSubview:searchDropDownView];
            
         }
            
       }
 }

-(void)dismissfunctionLocationView
{
    if ([res_obj.functionLocationArray count])
    {
        if ([[res_obj.functionLocationArray objectAtIndex:0] objectForKey:@"locationid"]) {
            
            [[headerDataArray objectAtIndex:2] replaceObjectAtIndex:3 withObject:[[res_obj.functionLocationArray objectAtIndex:0] objectForKey:@"locationid"]];
            
            loactionId=[[res_obj.functionLocationArray objectAtIndex:0] objectForKey:@"locationid"];
            
        }
        else if ([[res_obj.functionLocationArray objectAtIndex:0] objectForKey:@"locationName"]){
            
              [[headerDataArray objectAtIndex:2] replaceObjectAtIndex:2 withObject:[[res_obj.functionLocationArray objectAtIndex:0] objectForKey:@"locationName"]];
         }
    }
    
     
    commonlistTableView.tag=0;
    [commonlistTableView reloadData];
    
    [self.navigationController popViewControllerAnimated:YES];
    
 }


-(void)dismissComponentsSearchView
{
     if ([res_obj.materialsSearchListArray count]) {
        
        if ([[res_obj.materialsSearchListArray objectAtIndex:0] objectForKey:@"bomcomponent"]) {
            
            componentTextField.text=[[res_obj.materialsSearchListArray objectAtIndex:0] objectForKey:@"comptext"];
            
            componentID=[[res_obj.materialsSearchListArray objectAtIndex:0] objectForKey:@"bomcomponent"];
            
         NSArray   *labstArray=[[DataBase sharedInstance] fetchStocksDataFromBomItem:[[res_obj.materialsSearchListArray objectAtIndex:0] objectForKey:@"bomcomponent"]];
            
            if ([labstArray count]) {
                
                storageLocationID=[[labstArray objectAtIndex:0] objectForKey:@"lgort"];
 
            }
            
           // plantID = [[res_obj.materialsSearchListArray objectAtIndex:0] objectForKey:@"werks"];
 
            storageLocationComponentTextField.text = storageLocationID;
        }
        else{
            
            componentTextField.text=[[res_obj.materialsSearchListArray objectAtIndex:0] objectForKey:@"maktx"];
            
            componentID=[[res_obj.materialsSearchListArray objectAtIndex:0] objectForKey:@"matnr"];
            
            plantID = [[res_obj.materialsSearchListArray objectAtIndex:0] objectForKey:@"werks"];
            
            plantComponentTextField.text = plantID;
            
            storageLocationID =  [[res_obj.materialsSearchListArray objectAtIndex:0] objectForKey:@"lgort"];
            
            storageLocationComponentTextField.text = storageLocationID;
        }
        
        plantComponentTextField.hidden = NO;
        storageLocationComponentTextField.hidden = NO;
        plantComponentTextField.userInteractionEnabled=NO;
        plantComponentTextField.userInteractionEnabled=NO;
 
     }
    
    [self.navigationController popViewControllerAnimated:YES];
 }

-(void)addWorkApprovaslDataClicked
{
    
 
        wcmShortTextField.text=[[headerDataArray objectAtIndex:1] objectAtIndex:2];
        wcmFunctionLocationTextfield.text=[[headerDataArray objectAtIndex:2] objectAtIndex:3];
        NSDateFormatter *dateformatter=[[NSDateFormatter alloc]init];
        [dateformatter setDateFormat:@"MMM dd, yyyy"];
        wcmFromDateTextfield.text = [dateformatter stringFromDate:[NSDate date]];
        wcmToDateTextfield.text = [dateformatter stringFromDate:[NSDate date]];
        standardCheckPointBtn.hidden=YES;
        opWCDBtn.hidden=YES;
        applicationBtn.hidden=NO;
        switchingScreenBtn.hidden=YES;
 
        NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:[NSDate date]];
        NSInteger currentHour = [components hour];
        NSInteger currentMinute = [components minute];
        NSInteger currentSecond = [components second];
 
    
        if ((currentHour < 14 && (currentMinute >=0 || currentSecond >= 0)) || ((currentHour == 14) && (currentMinute ==0 && currentSecond == 0)))
        {
            if (currentHour > 6 && (currentMinute >=0 || currentSecond >=0))
            {
                wcmFromTimeTextfield.text=@"6:00:00";
                wcmToTimeTextfield.text=@"14:00:00";
                NSLog(@"Shift A");
            }
            else
            {
                wcmFromTimeTextfield.text=@"22:00:00";
                wcmToTimeTextfield.text=@"6:00:00";
                NSLog(@"Shift C");
            }
        }
        else if (currentHour >14 && (currentMinute >=0 || currentSecond >=0))
        {
            if ((currentHour < 22 && (currentMinute >=0 || currentSecond >= 0)) || (currentHour == 22 && (currentMinute == 0 && currentSecond == 0)))
            {
                wcmFromTimeTextfield.text=@"14:00:00";
                wcmToTimeTextfield.text=@"22:00:00";
                NSLog(@"Shift B");
            }
            else
            {
                wcmFromTimeTextfield.text=@"22:00:00";
                wcmToTimeTextfield.text=@"6:00:00";
                NSLog(@"Shift C");
                
            }
        }
    
      wcmPriorityTextfield.text=[[headerDataArray objectAtIndex:4] objectAtIndex:2];
    
 }
 
-(void)dismissApplicationTypesClicked
{
    applicationBtn.hidden=YES;
    
     applicationTypeString=res_obj.applicationTypeString;
    
     applicationObjArt=[[self.applicationTypesArray objectAtIndex:res_obj.selectedIndex] objectAtIndex:2];
    
     wcmScrollView.contentInset=UIEdgeInsetsMake(0.0,0.0,400,0.0);
 
     [self addWorkApprovaslDataClicked];
    
    if ([applicationTypeString isEqualToString:@"1"])
    {
       
        standardCheckPointBtn.hidden=YES;
        opWCDBtn.hidden=NO;
 
        [workApprovalHeaderView setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        
         [self.view addSubview:workApprovalHeaderView];
        
      }
     else
     {
        opWCDBtn.hidden=YES;
        standardCheckPointBtn.hidden=NO;
        wcmUsergrouptextField.text=@"";
        wcmUsageTextField.text=@"";
         [workApprovalHeaderView setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        [self.view addSubview:workApprovalHeaderView];
     }
    
    issueApprovalsBtn.hidden=YES;
    isolationIssueApprovalBtn.hidden=YES;
    
    issuepermitImage.hidden=YES;
    issuePermitLabel.hidden=YES;
    isolationPermitLabel.hidden=YES;
    isolationPermitImage.hidden=YES;
    
    changeWorkApprovalFlag=NO;
    addWorkApprovalFlag=NO;
    headerWorkApprovalLabel.text=[[self.applicationTypesArray objectAtIndex:res_obj.selectedIndex] objectAtIndex:3];
 
     [self.navigationController popViewControllerAnimated:YES];
    
 
 }

   -(void)dismissequipmentNumberView
    {
    
        if (res_obj.idString) {
        
             [[headerDataArray objectAtIndex:3] replaceObjectAtIndex:2 withObject:res_obj.nameString];
             [[headerDataArray objectAtIndex:3] replaceObjectAtIndex:3 withObject:res_obj.idString];
            
            equipmentID=res_obj.idString;
            
            if (res_obj.workcenterString) {
                
                [[headerDataArray objectAtIndex:9] replaceObjectAtIndex:2 withObject:res_obj.workcenterString];
                
            }
            
            NSArray *plannerGroupDetails=[[DataBase sharedInstance] fetchPlannerGrpForequipIngrp:res_obj.ingrpString];
            
                plannerGrouplID=[NSMutableString new];
        
                 iwerkString=[NSMutableString new];
 
                [iwerkString setString:res_obj.iwerkString];
        
                plantID=res_obj.plantIdString;
            
                plantComponentTextField.text = plantID;

            
            plantworkcenterTextField.text=[NSString stringWithFormat:@"%@-%@",plantID,res_obj.workcenterString];
            
            if ([plannerGroupDetails count]) {
                
                [plannerGrouplID setString:[[plannerGroupDetails objectAtIndex:0] objectAtIndex:1]];
                
                plannerGroupNameString=[[plannerGroupDetails objectAtIndex:0] objectAtIndex:2];
 
                [[headerDataArray objectAtIndex:5] replaceObjectAtIndex:2 withObject:[NSString stringWithFormat:@"%@-%@",[[plannerGroupDetails objectAtIndex:0] objectAtIndex:1],[[plannerGroupDetails objectAtIndex:0] objectAtIndex:2]]];
            }
            
            if (res_obj.catalogProfileIdstring.length)
            {
                catalogProfileID=[NSMutableString new];
                [catalogProfileID setString:[res_obj.catalogProfileIdstring copy]];
 
            }
         }
        
        
        if (res_obj.equipFunLocString.length) {
 
            NSArray *tempArray=[[DataBase sharedInstance] fetchNotificationLocationName:res_obj.equipFunLocString];
            
            [[headerDataArray objectAtIndex:2] replaceObjectAtIndex:3 withObject:res_obj.equipFunLocString];
            
            functionalLocationID=res_obj.equipFunLocString;
            
            if ([tempArray count]) {
                
                [[headerDataArray objectAtIndex:2] replaceObjectAtIndex:2 withObject:[[tempArray objectAtIndex:0] objectForKey:@"locationName"]];
             }
            
        }
    
        operationWkcenterTextfield.text = workCenterOperationID;
        operationPlanttextField.text = plantWorkCenterOperatonID;
        operationWkcenterTextfield.userInteractionEnabled=NO;
        operationPlanttextField.userInteractionEnabled=NO;

 
        commonlistTableView.tag=0;
        [commonlistTableView reloadData];
    
    [self.navigationController popViewControllerAnimated:YES];

}


-(IBAction)deleteListofOperations:(id)sender
{
     if (commonlistTableView.tag==2) {
        
        if (![self.selectedCheckBoxArray count])
        {
            
            [self showAlertMessageWithTitle:@"Information" message:@"No Operation selected" cancelButtonTitle:@"Ok" withactionType:@"Single" forMethod:nil];
        }
        else
        {
            
            [self showAlertMessageWithTitle:@"Alert" message:@"The selected operations and all components will be deleted. \n Do you want to continue?" cancelButtonTitle:@"No" withactionType:@"Multiple" forMethod:@"Cancel Opeartions"];
        }
    }
    
     else if (commonlistTableView.tag==3){
         
         if (![self.selectedPartsArray count])
         {
              [self showAlertMessageWithTitle:@"Information" message:@"No Parts selected" cancelButtonTitle:@"Ok" withactionType:@"Single" forMethod:nil];
          }
         else{
             
              [self showAlertMessageWithTitle:@"Alert" message:@"The selected Parts will be deleted. \n Do you want to continue?" cancelButtonTitle:@"No" withactionType:@"Multiple" forMethod:@"Cancel Parts"];
         }
     }
 
}

-(void)listofOperationsCancel{
    
    NSMutableIndexSet *indexesToDelete = [NSMutableIndexSet indexSet];
    
    for (id obj in self.selectedCheckBoxArray) {
        //do stuff with obj
        
        if (obj) {
            [indexesToDelete addIndex:[obj intValue]];
        }
        NSMutableDictionary *tempDeleteSlectedRow = [NSMutableDictionary new];
        [tempDeleteSlectedRow setObject:[orderUDID copy] forKey:@"ID"];
        [tempDeleteSlectedRow setObject:[[[self.operationDetailsArray objectAtIndex:[obj intValue]] firstObject] objectAtIndex:1] forKey:@"OPERATIONKEY"];
        
        if ([[[[self.operationDetailsArray objectAtIndex:[obj intValue]] firstObject] objectAtIndex:9] isEqualToString:@"A"]){
            //            [self.operationDetailsArray removeObjectAtIndex:[obj intValue]];
            
            [[DataBase sharedInstance] deleteOrderTransactions:tempDeleteSlectedRow];
        }
        else if ([[[[self.operationDetailsArray objectAtIndex:[obj intValue]] firstObject] objectAtIndex:9] isEqualToString:@""] || [[[[self.operationDetailsArray objectAtIndex:[obj intValue]] firstObject] objectAtIndex:9] isEqualToString:@"U"]){
            //            [[[self.operationDetailsArray objectAtIndex:[obj intValue]] firstObject] replaceObjectAtIndex:18 withObject:@"D"];
            //            [self.operationDetailDeleteArray addObject:[NSMutableArray arrayWithArray:[self.operationDetailsArray objectAtIndex:[obj intValue]]]];
            
            [[DataBase sharedInstance] updateDeletedOrderTransactionsDetails:tempDeleteSlectedRow];
        }
    }
    
    if (indexesToDelete) {
        
        [self.operationDetailsArray removeAllObjects];
        
        [self.operationDetailsArray addObjectsFromArray:[[DataBase sharedInstance] fetchOrderTransactionDetailsForUUID:orderUDID]];
        
        //[self.operationDetailsArray removeObjectsAtIndexes:indexesToDelete];
    }
    
    VornrOperation = 0;
    vornrOperationID = @"";
    VornrComponent = 10;
    
    for (int i=0; i<[self.operationDetailsArray count]; i++) {
        
        vornrOperationID = [[[self.operationDetailsArray  objectAtIndex:i] firstObject]  objectAtIndex:1];
        
        if ([[[[self.operationDetailsArray objectAtIndex:i] firstObject] objectAtIndex:9] isEqualToString:@"D"]){
            
            [self.operationDetailDeleteArray addObject:[NSMutableArray arrayWithArray:[self.operationDetailsArray objectAtIndex:i]]];
            [self.operationDetailsArray removeObjectAtIndex:i];
            --i;
        }
    }
    
    VornrOperation = [vornrOperationID intValue];
    
    VornrOperation = VornrOperation +10;
    
    [self.selectedCheckBoxArray removeAllObjects];
    
    operationSelectedFlag = NO;
    
    updateOperationsBtn.hidden = YES;
    commonlistTableView.tag=2;
    [commonlistTableView reloadData];
    
}


-(IBAction)deleteListofParts:(id)sender{
    
    
    
}

-(void)listofPartsCancel{
    
    NSMutableIndexSet *indexesToDelete = [NSMutableIndexSet indexSet];
    
    //self.partDetailsArray
    
    for (id obj in self.selectedPartsArray) {
        //do stuff with obj
        
        if (obj) {
            [indexesToDelete addIndex:[obj intValue]];
        }
        NSMutableDictionary *tempDeleteSlectedRow = [NSMutableDictionary new];
        [tempDeleteSlectedRow setObject:[orderUDID copy] forKey:@"ID"];
        [tempDeleteSlectedRow setObject:[[[self.partDetailsArray objectAtIndex:[obj intValue]] firstObject] objectAtIndex:8] forKey:@"COMPONENETKEY"];
        
        [tempDeleteSlectedRow setObject:[[[self.partDetailsArray objectAtIndex:[obj intValue]] firstObject] objectAtIndex:1] forKey:@"OPERATIONKEY"];
        
        if ([[[[self.partDetailsArray objectAtIndex:[obj intValue]] firstObject] objectAtIndex:15] isEqualToString:@"A"]){
            //            [self.operationDetailsArray removeObjectAtIndex:[obj intValue]];
            
            [[DataBase sharedInstance] deletePartsTransactions:tempDeleteSlectedRow];
        }
        else if ([[[[self.partDetailsArray objectAtIndex:[obj intValue]] firstObject] objectAtIndex:15] isEqualToString:@""] || [[[[self.partDetailsArray objectAtIndex:[obj intValue]] firstObject] objectAtIndex:15] isEqualToString:@"U"]){
            
            [[DataBase sharedInstance] updateDeletedPartsTransactionsDetails:tempDeleteSlectedRow];
        }
    }
    
    
    
    if (indexesToDelete) {
        
        [self.partDetailsArray removeAllObjects];
        
        [self.partDetailsArray addObjectsFromArray:[[DataBase sharedInstance] fetchOrderPartDetailsForUUID:orderUDID]];
        
        //[self.operationDetailsArray removeObjectsAtIndexes:indexesToDelete];
    }
    
    VornrComponent = 0;
    vornrComponentID = @"";
    //VornrComponent = 10;
    
    for (int i=0; i<[self.partDetailsArray count]; i++) {
        
        vornrComponentID = [[[self.partDetailsArray  objectAtIndex:i] firstObject]  objectAtIndex:1];
        
        if ([[[[self.partDetailsArray objectAtIndex:i] firstObject] objectAtIndex:15] isEqualToString:@"D"]){
            
            [self.componentDetailDeleteArray addObject:[NSMutableArray arrayWithArray:[self.partDetailsArray objectAtIndex:i]]];
            [self.partDetailsArray removeObjectAtIndex:i];
            --i;
        }
    }
    
    VornrComponent = [vornrComponentID intValue];
    
    VornrComponent = VornrComponent +10;
    
    [self.selectedPartsArray removeAllObjects];
    
    //operationSelectedFlag = NO;
    
    updateComponent.hidden = YES;
    
    commonlistTableView.tag=3;
    [commonlistTableView reloadData];
    
}


-(IBAction)createOrder:(id)sender{
    
    if(![JEValidator validateTextValue:[[headerDataArray objectAtIndex:0] objectAtIndex:2]])
    {
 
        [self showAlertMessageWithTitle:@"Information" message:@"Please Enter Order Type" cancelButtonTitle:@"Ok" withactionType:@"Single" forMethod:nil];
        
    }
    else if(![JEValidator validateTextValue:[[headerDataArray objectAtIndex:1] objectAtIndex:2]])
    {
 
         [self showAlertMessageWithTitle:@"Information" message:@"Please Enter Order Long Text" cancelButtonTitle:@"Ok" withactionType:@"Single" forMethod:nil];
        
    }
    else if(![JEValidator validateTextValue:[[headerDataArray objectAtIndex:3] objectAtIndex:2]])
    {
 
        [self showAlertMessageWithTitle:@"Information" message:@"Please Enter Equipment Number" cancelButtonTitle:@"Ok" withactionType:@"Single" forMethod:nil];
        
    }
    else if(![JEValidator validateTextValue:[[headerDataArray objectAtIndex:5] objectAtIndex:2]])
    {
        
        [self showAlertMessageWithTitle:@"Information" message:@"Please Select Planner group" cancelButtonTitle:@"Ok" withactionType:@"Single" forMethod:nil];
        
    }
    else if(![JEValidator validateTextValue:[[headerDataArray objectAtIndex:8] objectAtIndex:2]])
    {
 
      [self showAlertMessageWithTitle:@"Information" message:@"Please Enter Basic Start Date" cancelButtonTitle:@"Ok" withactionType:@"Single" forMethod:nil];
        
    }
    else if(![JEValidator validateTextValue:[[headerDataArray objectAtIndex:9] objectAtIndex:2]])
    {
           [self showAlertMessageWithTitle:@"Information" message:@"Please Enter Basic End Date" cancelButtonTitle:@"Ok" withactionType:@"Single" forMethod:nil];
    }
    else if(![JEValidator validateTextValue:[[headerDataArray objectAtIndex:10] objectAtIndex:2]])
    {
        [self showAlertMessageWithTitle:@"Information" message:@"Please Select Cost Center" cancelButtonTitle:@"Ok" withactionType:@"Single" forMethod:nil];
    }
 
    else
    {
        if (createOrderFlag) {
            
            if(![self.operationDetailsArray count])
            {
                  [self showAlertMessageWithTitle:@"Information" message:@"Please enter at least 1 operation for order creation" cancelButtonTitle:@"Ok" withactionType:@"Single" forMethod:nil];
            }
             else
            {
 
                [self showAlertMessageWithTitle:@"Decision" message:@"Do you want to submit for Order creation?" cancelButtonTitle:@"No" withactionType:@"Multiple" forMethod:@"Create Order"];
             }
          }
        
        else{
            
             [self showAlertMessageWithTitle:@"Decision" message:@"Do you want to submit for Change Order?" cancelButtonTitle:@"No" withactionType:@"Multiple" forMethod:@"Change Order"];
         }
     }
}



- (IBAction)standardCheckPointClicked:(id)sender{
    
    if(![JEValidator validateTextValue:wcmUsageTextField.text])
    {
 
        [self showAlertMessageWithTitle:@"Information" message:@"Please Select Usage field" cancelButtonTitle:@"Ok" withactionType:@"Single" forMethod:nil];
    }
    
    else{
        
        [self checkpointValidation];
        
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
    
    if (tableView==commonlistTableView) {
        
        if (commonlistTableView.tag==0) {
             return [headerDataArray count];
         }
        else if (commonlistTableView.tag==1){
            
            return [notificationsArray count];
         }
        else if (commonlistTableView.tag==2){
            
            return [self.operationDetailsArray count];
         }
        else if (commonlistTableView.tag==3){
            
            return [self.partDetailsArray count];
         }
         else if (commonlistTableView.tag==4) {
             
             return [self.objectDetailsArray count];

         }
         else if (commonlistTableView.tag==5) {

             return [self.workApprovalDetailsArray count];
         }
       }
    
    else if (tableView==applicationTypeTableView){
        
        return [self.workApplicationDetailsArray count];
        
     }
    
    else if (tableView == seachDropdownTableView)
    {
        return [self.dropDownArray count];
    }
    
   else if (tableView == self.dropDownTableView) {
        
        return [self.dropDownArray count];
    }
    
   else if (tableView==orderSystemStatusTableView){
       
       if (orderSystemStatusTableView.tag == 0) {
           
           return [[[orderSystemStatusArray objectAtIndex:0] firstObject] count];
       }
       else if (orderSystemStatusTableView.tag == 1){
           
           return [[[orderSystemStatusArray objectAtIndex:1] firstObject] count];
       }
       else{
           
           return [[[orderSystemStatusArray objectAtIndex:2] firstObject] count];
       }
   }
    
   else if (tableView==checkPointTableView){
       
       if (checkPointTableView.tag==0) {
           
           return[[self.hazardsControlSCheckpointsArray firstObject] count];
       }
       else if (checkPointTableView.tag==1){
           
           return [[self.hazardsControlSCheckpointsArray lastObject] count];
       }
    }
     return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
            if (tableView == commonlistTableView)
             {
                  if (commonlistTableView.tag==0) {
                      
                      if (createOrderFlag) {
 
                      if (indexPath.row==2||indexPath.row==3||indexPath.row==9) {
                         
                         static NSString *CellIdentifier = @"SearchInputDropDownCell";
                         
                         SearchInputDropdownTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                         
                         if (cell==nil) {
                             cell=[[SearchInputDropdownTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                         }
                         
                         
                         cell.selectionStyle = UITableViewCellSelectionStyleNone;

                         cell.notifView.layer.cornerRadius = 2.0f;
                         cell.notifView.layer.masksToBounds = YES;
                         cell.notifView.layer.borderColor = [[UIColor darkGrayColor] CGColor];
                         cell.notifView.layer.borderWidth = 1.0f;
                         
                         cell.madatoryLabel.hidden=YES;
                        cell.InputTextField.superview.tag = indexPath.row;
                         cell.InputTextField.delegate = self;
 
                         cell.scanBtn.hidden=NO;
                         cell.historyBtn.hidden=NO;
                         cell.scanLabel.hidden=NO;
                         
                         if (indexPath.row==2||indexPath.row==9) {
                             cell.scanBtn.hidden=YES;
                             cell.historyBtn.hidden=YES;
                             cell.scanLabel.hidden=YES;
                         }
                         
                        [cell.searchBtn addTarget:self action:@selector(functionLocationSearchAction:) forControlEvents:UIControlEventTouchUpInside];
                         
                         cell.titleLabel.text=[[headerDataArray objectAtIndex:indexPath.row] objectAtIndex:0];
                         
                         cell.InputTextField.placeholder=[[headerDataArray objectAtIndex:indexPath.row] objectAtIndex:1];
                         
 
                         if (indexPath.row==9) {
                             
                             cell.InputTextField.text=[[headerDataArray objectAtIndex:indexPath.row] objectAtIndex:2];
                             
                         }
                         
                         else{
                             
                             cell.InputTextField.text=[[headerDataArray objectAtIndex:indexPath.row] objectAtIndex:3];
                             cell.namelabel.text=[[headerDataArray objectAtIndex:indexPath.row] objectAtIndex:2];
                             
                         }
                         
                         return cell;
                         
                     }
 
                     else{
                         
                         static NSString *CellIdentifier = @"InputDropDownCell";
                         
                         InputDropDownTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                         
                         if (cell==nil) {
                             cell=[[InputDropDownTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                         }
                         
                         cell.selectionStyle = UITableViewCellSelectionStyleNone;

                         
                         cell.InputTextField.superview.tag = indexPath.row;
                         cell.InputTextField.delegate = self;
                         
                         cell.dropDownImageView.hidden=NO;
                         
                         cell.notifView.layer.cornerRadius = 2.0f;
                         cell.notifView.layer.masksToBounds = YES;
                         cell.notifView.layer.borderColor = [[UIColor darkGrayColor] CGColor];
                         cell.notifView.layer.borderWidth = 1.0f;
                         
                         [cell.dropDownImageView setImage:[UIImage imageNamed:@"dropdown"]];
                         
                        if (indexPath.row==1)
                         {
                              cell.dropDownImageView.hidden=YES;
                             
                         }
                         
                         cell.madatoryLabel.hidden=NO;

                         
                         if (indexPath.row==4||indexPath.row==6||indexPath.row==11) {
                             
                             cell.madatoryLabel.hidden=YES;
                             
                         }
                         
                         cell.longTextBtn.hidden=YES;

                         
                         if (indexPath.row==1) {
                             cell.longTextBtn.hidden=NO;
                         }
                         
                          else if (indexPath.row==7||indexPath.row==8){
                             
                             cell.dropDownImageView.hidden=NO;
                             
                             [cell.dropDownImageView setImage:[UIImage imageNamed:@"calendar"]];
                             
                         }
 
                         cell.titleLabel.text=[[headerDataArray objectAtIndex:indexPath.row] objectAtIndex:0];
                         
                         cell.InputTextField.placeholder=[[headerDataArray objectAtIndex:indexPath.row] objectAtIndex:1];
                         
                         cell.InputTextField.text=[[headerDataArray objectAtIndex:indexPath.row] objectAtIndex:2];
                         
                         return cell;
                     }
                   }
                      
                else{
                          
                    if (indexPath.row==3||indexPath.row==4||indexPath.row==10) {
                        
                        static NSString *CellIdentifier = @"SearchInputDropDownCell";
                        
                        SearchInputDropdownTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                        
                        if (cell==nil) {
                            cell=[[SearchInputDropdownTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                        }
                        
                        
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        
                        cell.notifView.layer.cornerRadius = 2.0f;
                        cell.notifView.layer.masksToBounds = YES;
                        cell.notifView.layer.borderColor = [[UIColor darkGrayColor] CGColor];
                        cell.notifView.layer.borderWidth = 1.0f;
                        
                        cell.madatoryLabel.hidden=YES;
                        cell.InputTextField.superview.tag = indexPath.row;
                        cell.InputTextField.delegate = self;
                        
                        cell.scanBtn.hidden=NO;
                        cell.historyBtn.hidden=NO;
                        cell.scanLabel.hidden=NO;
                        
                        if (indexPath.row==2||indexPath.row==10) {
                            cell.scanBtn.hidden=YES;
                            cell.historyBtn.hidden=YES;
                            cell.scanLabel.hidden=YES;
                        }
                        
                        [cell.searchBtn addTarget:self action:@selector(functionLocationSearchAction:) forControlEvents:UIControlEventTouchUpInside];
                        
                        cell.titleLabel.text=[[headerDataArray objectAtIndex:indexPath.row] objectAtIndex:0];
                        
                        cell.InputTextField.placeholder=[[headerDataArray objectAtIndex:indexPath.row] objectAtIndex:1];
                        
                        
                        if (indexPath.row==10) {
                            
                            cell.InputTextField.text=[[headerDataArray objectAtIndex:indexPath.row] objectAtIndex:2];
                            
                        }
                        
                        else{
                            
                            cell.InputTextField.text=[[headerDataArray objectAtIndex:indexPath.row] objectAtIndex:3];
                            cell.namelabel.text=[[headerDataArray objectAtIndex:indexPath.row] objectAtIndex:2];
                            
                        }
                        
                        return cell;
                        
                    }
                    
                    else if (indexPath.row==2){
                        
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
                        
                        [cell.notifOrderBtn addTarget:self action:@selector(notiNoButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
                        
                        return cell;
                    }
                    
                    else{
                        
                        static NSString *CellIdentifier = @"InputDropDownCell";
                        
                        InputDropDownTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                        
                        if (cell==nil) {
                            cell=[[InputDropDownTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                        }
                        
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        
                        
                        cell.InputTextField.superview.tag = indexPath.row;
                        cell.InputTextField.delegate = self;
                        
                        cell.dropDownImageView.hidden=NO;
                        
                        cell.notifView.layer.cornerRadius = 2.0f;
                        cell.notifView.layer.masksToBounds = YES;
                        cell.notifView.layer.borderColor = [[UIColor darkGrayColor] CGColor];
                        cell.notifView.layer.borderWidth = 1.0f;
                        
                        [cell.dropDownImageView setImage:[UIImage imageNamed:@"dropdown"]];
                        
                        if (indexPath.row==1)
                        {
                            cell.dropDownImageView.hidden=YES;
                            
                        }
                        
                        cell.madatoryLabel.hidden=NO;
                        
                        
                        if (indexPath.row==5||indexPath.row==7||indexPath.row==12) {
                            
                            cell.madatoryLabel.hidden=YES;
                            
                        }
                        
                        cell.longTextBtn.hidden=YES;
                        
                        
                        if (indexPath.row==1) {
                            cell.longTextBtn.hidden=NO;
                        }
                        
                        else if (indexPath.row==8||indexPath.row==9){
                            
                            cell.dropDownImageView.hidden=NO;
                            
                            [cell.dropDownImageView setImage:[UIImage imageNamed:@"calendar"]];
                            
                        }
                        
                        cell.titleLabel.text=[[headerDataArray objectAtIndex:indexPath.row] objectAtIndex:0];
                        
                        cell.InputTextField.placeholder=[[headerDataArray objectAtIndex:indexPath.row] objectAtIndex:1];
                        
                        cell.InputTextField.text=[[headerDataArray objectAtIndex:indexPath.row] objectAtIndex:2];
                        
                        return cell;
                    }
                    
                }
                      
            }
 
         else if (commonlistTableView.tag==1) {
            
//             if (indexPath.row==1){
//
//                 static NSString *CellIdentifier = @"BreakDownCell";
//
//                 BreakDownTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//
//                 if (cell==nil) {
//                     cell=[[BreakDownTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
//                 }
//
//                 cell.titleLabel.text=[[notificationsArray objectAtIndex:indexPath.row] objectAtIndex:0];
//
//                 if ([[[notificationsArray objectAtIndex:indexPath.row] objectAtIndex:2] isEqualToString:@"X"]){
//
//                     [cell.breakDownBtn setImage:[UIImage imageNamed:@"CheckBoxSelection"] forState:UIControlStateNormal];
//                 }
//                 else{
//
//                     [cell.breakDownBtn setImage:[UIImage imageNamed:@"checkBoxUnSelection"] forState:UIControlStateNormal];
//                 }
//
//                 return cell;
//            }
//
//             else{
//
//                 static NSString *CellIdentifier = @"InputDropDownCell";
//
//                 InputDropDownTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//
//                 if (cell==nil) {
//                     cell=[[InputDropDownTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
//                 }
//
//                 cell.dropDownImageView.hidden=NO;
//
//                 [cell.dropDownImageView setImage:[UIImage imageNamed:@"dropdown"]];
//
//                 cell.InputTextField.textColor=[UIColor blackColor];
//
//                 cell.longTextBtn.hidden=YES;
//
//                 if (indexPath.row==1) {
//                      cell.longTextBtn.hidden=NO;
//                  }
//
//                 if (indexPath.row==0)
//                 {
//                      cell.dropDownImageView.hidden=YES;
//                      cell.InputTextField.textColor=[UIColor blueColor];
//                 }
//
//                 if (indexPath.row==2||indexPath.row==3) {
//
//                     cell.dropDownImageView.hidden=NO;
//                     [cell.dropDownImageView setImage:[UIImage imageNamed:@"calendar"]];
//                  }
//
//                  cell.InputTextField.superview.tag = indexPath.row;
//                  cell.InputTextField.delegate = self;
//
//                  cell.titleLabel.text=[[notificationsArray objectAtIndex:indexPath.row] objectAtIndex:0];
//                  cell.InputTextField.placeholder=[[notificationsArray objectAtIndex:indexPath.row] objectAtIndex:1];
//                  cell.InputTextField.text=[[notificationsArray objectAtIndex:indexPath.row] objectAtIndex:2];
//
//                 return cell;
//             }
             
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
             
             
             [cell.notifOrderBtn addTarget:self action:@selector(notiNoButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
             
             return cell;
             
             
         }
        
         else if (commonlistTableView.tag==2){
             
             static NSString *CellIdentifier = @"OperationCell";
             
           OperationTableViewCell   *operationCell =[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
             
             if (operationCell==nil) {
                 operationCell=[[OperationTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
             }
             operationCell.accessoryType = UITableViewCellAccessoryNone;
             
             if (indexPath.row % 2 == 0){
                 operationCell.backgroundColor =UIColorFromRGB(249, 249, 249);
             }
             else {
                 operationCell.backgroundColor =[UIColor whiteColor];
             }
             
             static NSInteger checkboxTag = 123;
             NSInteger x,y;x = 8.0; y = 9.0;
             
             UIButton *checkboxSelect = (UIButton *) [operationCell.contentView viewWithTag:checkboxTag];
             
             if (!checkboxSelect)
             {
                 checkboxSelect = [[UIButton alloc] initWithFrame:(CGRectMake(x,y,25.0,25.0))];
                 checkboxSelect.tag = checkboxTag;
                 [operationCell.contentView addSubview:checkboxSelect];
             }
             
             [checkboxSelect setImage:[UIImage imageNamed:@"radiounselection.png"]   forState:UIControlStateNormal];
             
             operationCell.operationContentView.layer.cornerRadius = 2.0f;
             operationCell.operationContentView.layer.masksToBounds = YES;
             operationCell.operationContentView.layer.borderColor = [[UIColor darkGrayColor] CGColor];
             operationCell.operationContentView.layer.borderWidth = 1.0f;
             
             checkboxSelect.adjustsImageWhenHighlighted = YES;
             [checkboxSelect addTarget:self action:@selector(operationcheckBoxClicked:)   forControlEvents:UIControlEventTouchDown];
             
             operationCell.operationTextLabel.text=[NSString stringWithFormat:@"%@",[[[self.operationDetailsArray objectAtIndex:indexPath.row] firstObject] objectAtIndex:2]];
             
             operationCell.durationLabel.text=[NSString stringWithFormat:@"%@ %@",[[[self.operationDetailsArray  objectAtIndex:indexPath.row] firstObject] objectAtIndex:4],[[[self.operationDetailsArray  objectAtIndex:indexPath.row] firstObject] objectAtIndex:3]];
             
             operationCell.operationCountLabel.text=[NSString stringWithFormat:@"%@",[[[self.operationDetailsArray  objectAtIndex:indexPath.row] firstObject] objectAtIndex:1]];
             
             if ([[[[self.operationDetailsArray objectAtIndex:indexPath.row] firstObject] objectAtIndex:10] isEqualToString:@""]) {
                 operationCell.operationsStatusImageView.hidden = NO;
                 
                 CALayer *layer = [operationCell.operationsStatusImageView layer];
                 [layer setMasksToBounds:YES];
                 [layer setCornerRadius:operationCell.operationsStatusImageView.frame.size.width / 2];
                 
                 if ([[[[self.operationDetailsArray objectAtIndex:indexPath.row] firstObject] objectAtIndex:8] isEqualToString:@"X"])
                 {
                     operationCell.operationsStatusImageView.backgroundColor = [UIColor greenColor];
                 }
                 else if ([[[[self.operationDetailsArray objectAtIndex:indexPath.row] firstObject] objectAtIndex:8] isEqualToString:@"Y"])
                 {
                     operationCell.operationsStatusImageView.backgroundColor = [UIColor orangeColor];
                 }
                 else if ([[[[self.operationDetailsArray objectAtIndex:indexPath.row] firstObject] objectAtIndex:8] isEqualToString:@"Z"])
                 {
                     operationCell.operationsStatusImageView.backgroundColor = UIColorFromRGB(0, 100, 0);
                 }
                 else if ([[[[self.operationDetailsArray objectAtIndex:indexPath.row] firstObject] objectAtIndex:8] isEqualToString:@"S"])
                 {
                     operationCell.operationsStatusImageView.backgroundColor = [UIColor yellowColor];
                 }
                 else if ([[[[self.operationDetailsArray objectAtIndex:indexPath.row] firstObject] objectAtIndex:8] isEqualToString:@"P"])
                 {
                     operationCell.operationsStatusImageView.backgroundColor = [UIColor purpleColor];
                 }
                 else
                 {
                     operationCell.operationsStatusImageView.backgroundColor = UIColorFromRGB(38, 85, 153);
                 }
                 
                 operationCell.operationCountLabel.textColor=UIColorFromRGB(38, 85, 153);
             }
             else{
                 operationCell.operationsStatusImageView.hidden = YES;
                 operationCell.operationCountLabel.textColor=[UIColor blackColor];
             }
             
             if (!createOrderFlag)
             {
 
                 if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
                 {
                     //for detail view
                     static NSInteger detailCheckBoxTag = 500;
                     NSInteger i,j;i = 278.0; j = 5.0;
                     
                     UIButton *detailCheckBoxSelect = (UIButton *) [operationCell.contentView viewWithTag:detailCheckBoxTag];
                     
                     if (!detailCheckBoxSelect)
                     {
                         detailCheckBoxSelect = [[UIButton alloc] initWithFrame:(CGRectMake(i,j,30,30))];
                         detailCheckBoxSelect.tag = detailCheckBoxTag;
                         [operationCell.contentView addSubview:detailCheckBoxSelect];
                     }
                     
                     [detailCheckBoxSelect setImage:[UIImage imageNamed:@"More-icon"] forState:UIControlStateNormal];
                     
                     detailCheckBoxSelect.adjustsImageWhenHighlighted = YES;
                     
                     [detailCheckBoxSelect addTarget:self action:@selector(detailOperationCheckBoxSelected:) forControlEvents:UIControlEventTouchDown];
 
                 }
             }
             
             return operationCell;
         }
        
         else if (commonlistTableView.tag==3){
             
             static NSString *CellIdentifier = @"partCell";
             
        PartTableViewCell    *partCell =[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
             
             if (partCell==nil) {
                 partCell=[[PartTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
             }
             partCell.accessoryType = UITableViewCellAccessoryNone;
             
             if (indexPath.row % 2 == 0){
                 partCell.backgroundColor =UIColorFromRGB(249, 249, 249);
             }
             else {
                 partCell.backgroundColor =[UIColor whiteColor];
             }
             
             static NSInteger checkboxTag = 123;
             NSInteger x,y;x = 8.0; y = 9.0;
             
             UIButton *checkboxSelect = (UIButton *) [partCell.contentView viewWithTag:checkboxTag];
             
             if (!checkboxSelect)
             {
                 checkboxSelect = [[UIButton alloc] initWithFrame:(CGRectMake(x,y,25.0,25.0))];
                 checkboxSelect.tag = checkboxTag;
                 [partCell.contentView addSubview:checkboxSelect];
             }
             
             [checkboxSelect setImage:[UIImage imageNamed:@"radiounselection.png"]   forState:UIControlStateNormal];
             
             checkboxSelect.adjustsImageWhenHighlighted = YES;
             [checkboxSelect addTarget:self action:@selector(componentCheckBoxClicked:)   forControlEvents:UIControlEventTouchDown];
             
             partCell.operationCountLabel.text = [[[self.partDetailsArray  objectAtIndex:indexPath.row] firstObject] objectAtIndex:1];
             
             partCell.componentLabel.text=[NSString stringWithFormat:@"%@",[[[self.partDetailsArray  objectAtIndex:indexPath.row] firstObject]  objectAtIndex:6]];
             
             partCell.quantityLabel.text=[NSString stringWithFormat:@"%@",[[[self.partDetailsArray  objectAtIndex:indexPath.row] firstObject] objectAtIndex:2]];
 
             return partCell;
         }
                 
         else if (commonlistTableView.tag==4){
 
             static NSString *CellIdentifier = @"Cell";
             
             ObjectTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
             
             
             if (cell==nil) {
                 cell=[[ObjectTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
             }
             
             cell.accessoryType = UITableViewCellAccessoryNone;
             
             if (indexPath.row % 2 == 0){
                 cell.backgroundColor =UIColorFromRGB(249, 249, 249);
             }
             else {
                 cell.backgroundColor =[UIColor whiteColor];
             }
             
             cell.notifText.text = [[self.objectDetailsArray objectAtIndex:indexPath.row] objectAtIndex:4];
             
             cell.equipmentText.text = [[self.objectDetailsArray objectAtIndex:indexPath.row] objectAtIndex:5];
             
             cell.descriptionText.text = [[self.objectDetailsArray objectAtIndex:indexPath.row] objectAtIndex:11];
             
             return cell;
             
         }
                 
          else if (commonlistTableView.tag==5)
         {
 
             static NSString *CellIdentifier = @"Cell";
             
             WorkApprovalTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
 
             if (cell==nil) {
                 cell=[[WorkApprovalTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
             }
             
             cell.accessoryType = UITableViewCellAccessoryNone;
             cell.selectionStyle=UITableViewCellSelectionStyleNone;
             
             if ([[[self.workApprovalDetailsArray objectAtIndex:indexPath.row] objectAtIndex:26] isEqualToString:@"G"])
             {
                 
                 [cell.trafficSignalImageview setImage:[UIImage imageNamed:@"green_traffic.png"]];
             }
             else if ([[[self.workApprovalDetailsArray objectAtIndex:indexPath.row] objectAtIndex:26] isEqualToString:@"Y"]){
                 
                 [cell.trafficSignalImageview setImage:[UIImage imageNamed:@"yellow_traffic.png"]];
             }
             else{
                 
                 [cell.trafficSignalImageview setImage:[UIImage imageNamed:@"red_traffic.png"]];
             }
             
             if ([[[self.workApprovalDetailsArray objectAtIndex:indexPath.row] objectAtIndex:24] isEqualToString:@"X"]){
                 
                 [cell.permitStatusImageview setImage:[UIImage imageNamed:@"cr_sp_co22.png"]];
             }
             else if ([[[self.workApprovalDetailsArray objectAtIndex:indexPath.row] objectAtIndex:25] isEqualToString:@"X"]){
                 
                 [cell.permitStatusImageview setImage:[UIImage imageNamed:@"cr_sp_co33.png"]];
             }
             else{
                 
                 [cell.permitStatusImageview setImage:[UIImage imageNamed:@"cr_sp_co11.png"]];
             }
             
             cell.workApprovalIDLabel.text=[[self.workApprovalDetailsArray objectAtIndex:indexPath.row] objectAtIndex:2];
             
             cell.shortTextLabel.text=[[self.workApprovalDetailsArray objectAtIndex:indexPath.row] objectAtIndex:12];
             
             return cell;
         }
                 
        }
            else if (tableView==applicationTypeTableView)
            {
                if (applicationTypeTableView.contentSize.height < applicationTypeTableView.frame.size.height) {
                    applicationTypeTableView.scrollEnabled = NO;
                }
                else
                    applicationTypeTableView.scrollEnabled = YES;
                
                static NSString *CellIdentifier = @"Cell";
                
                ApplicationTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                
                
                if (cell==nil) {
                    cell=[[ApplicationTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                }
                
                cell.accessoryType = UITableViewCellAccessoryNone;
                cell.selectionStyle=UITableViewCellSelectionStyleNone;
                
                if (indexPath.row % 2 == 0){
                    cell.backgroundColor =UIColorFromRGB(249, 249, 249);
                }
                else {
                    cell.backgroundColor =[UIColor whiteColor];
                }
                
                if ([[[[self.workApplicationDetailsArray objectAtIndex:indexPath.row] firstObject] objectAtIndex:27] isEqualToString:@"G"]) {
                    [cell.trafficSignalImageview setImage:[UIImage imageNamed:@"green_traffic.png"]];
                }
                else if ([[[[self.workApplicationDetailsArray objectAtIndex:indexPath.row] firstObject] objectAtIndex:27] isEqualToString:@"Y"]){

                    [cell.trafficSignalImageview setImage:[UIImage imageNamed:@"yellow_traffic.png"]];
                }
                else{

                    [cell.trafficSignalImageview setImage:[UIImage imageNamed:@"red_traffic.png"]];
                }

                if ([[[[self.workApplicationDetailsArray objectAtIndex:indexPath.row] firstObject] objectAtIndex:26] isEqualToString:@"X"]){

                    [cell.permitStatusImageview setImage:[UIImage imageNamed:@"cr_sp_co33.png"]];

                }
                else if ([[[[self.workApplicationDetailsArray objectAtIndex:indexPath.row] firstObject] objectAtIndex:25] isEqualToString:@"X"]){


                    [cell.permitStatusImageview setImage:[UIImage imageNamed:@"cr_sp_co22.png"]];

                }
                else{

                    [cell.permitStatusImageview setImage:[UIImage imageNamed:@"cr_sp_co11.png"]];
                }


                cell.appIDLabel.text=[[[self.workApplicationDetailsArray objectAtIndex:indexPath.row] firstObject] objectAtIndex:2];
                NSMutableDictionary *fetchData = [NSMutableDictionary new];
                [fetchData setObject:[[[self.workApplicationDetailsArray objectAtIndex:indexPath.row] firstObject] objectAtIndex:4] forKey:@"ObjTypeID"];

                [fetchData setObject:plantWorkCenterID forKey:@"PlantID"];


                NSArray *objTypeTextArray = [[DataBase sharedInstance] getApplicationNameForObjType:fetchData];

                if ([objTypeTextArray count]) {
                    cell.applicationNameLabel.text = [objTypeTextArray objectAtIndex:0];
                }
                else{

                    cell.applicationNameLabel.text = [[[self.workApplicationDetailsArray objectAtIndex:indexPath.row] firstObject] objectAtIndex:6];
                }
                
                return cell;
            }
 
     else  if (tableView == self.dropDownTableView) {
        
        static NSString *CellIdentifier = @"Cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell==nil) {
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        cell.accessoryType=UITableViewCellAccessoryNone;
        
        if ([[self.dropDownArray objectAtIndex:indexPath.row] count] == 2)
        {
            cell.textLabel.text = [NSString stringWithFormat:@"%@-%@",[[self.dropDownArray objectAtIndex:indexPath.row] objectAtIndex:ID_INDEX],[[self.dropDownArray objectAtIndex:indexPath.row] objectAtIndex:NAME_INDEX]];
            
            
        }
        else if ([[self.dropDownArray objectAtIndex:indexPath.row] count] == 1)
        {
            cell.textLabel.text = [NSString stringWithFormat:@"%@",[[self.dropDownArray objectAtIndex:indexPath.row] objectAtIndex:ID_INDEX]];
            
        }
        else if ([[self.dropDownArray objectAtIndex:indexPath.row] count] == 4) {
            
            switch ([self.dropDownTableView tag]) {
                    
                case ORDER_WCM_USAGE:
                    
                    cell.textLabel.text = [NSString stringWithFormat:@"%@-%@",[[self.dropDownArray objectAtIndex:indexPath.row] objectAtIndex:2],[[self.dropDownArray objectAtIndex:indexPath.row] objectAtIndex:3]];
                    
                    break;
                    
                case ORDER_ISOLATION_USAGE:
                    
                    cell.textLabel.text = [NSString stringWithFormat:@"%@-%@",[[self.dropDownArray objectAtIndex:indexPath.row] objectAtIndex:2],[[self.dropDownArray objectAtIndex:indexPath.row] objectAtIndex:3]];
                    
                    break;
                    
                default :
                    
                    cell.textLabel.text = [NSString stringWithFormat:@"%@-%@",[[self.dropDownArray objectAtIndex:indexPath.row] objectAtIndex:ID_INDEX],[[self.dropDownArray objectAtIndex:indexPath.row] objectAtIndex:NAME_INDEX]];
                    
                    break;
                    
            }
            
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
         
            static NSString *CellIdentifier = @"WorkcenterCell";
             
             WorkcenterTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
         
              cell.accessoryType = UITableViewCellAccessoryNone;

             
             if (cell==nil) {
                 cell=[[WorkcenterTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
             }
             cell.accessoryType = UITableViewCellAccessoryNone;
             
             cell.idLabel.text=[[self.dropDownArray objectAtIndex:indexPath.row] objectAtIndex:2];
             
             cell.textLabel.text=[[self.dropDownArray objectAtIndex:indexPath.row] objectAtIndex:3];
             
             return cell;
 
          }
 
      else if (tableView==orderSystemStatusTableView){
         
         if (orderSystemStatusTableView.contentSize.height < orderSystemStatusTableView.frame.size.height) {
             orderSystemStatusTableView.scrollEnabled = NO;
         }
         else
             orderSystemStatusTableView.scrollEnabled = YES;
         
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
         
//         static NSInteger checkboxTag = 123;
//         NSInteger x,y;x = 8.0; y = 14.0;
//
//         UIButton *checkBoxNRadioButtonSelectionForSystemStatusButton = (UIButton *) [cell.contentView viewWithTag:checkboxTag];
//
//         if (!checkBoxNRadioButtonSelectionForSystemStatusButton)
//         {
//             checkBoxNRadioButtonSelectionForSystemStatusButton = [[UIButton alloc] initWithFrame:(CGRectMake(x,y,20,20))];
//             checkBoxNRadioButtonSelectionForSystemStatusButton.tag = checkboxTag;
//             [cell.contentView addSubview:checkBoxNRadioButtonSelectionForSystemStatusButton];
//         }
          
          cell.checkBoxNRadioButtonSelectionForSystemStatusButton.adjustsImageWhenHighlighted = YES;
          cell.accessoryType = UITableViewCellAccessoryNone;
          
          [cell.checkBoxNRadioButtonSelectionForSystemStatusButton addTarget:self action:@selector(checkBoxNRadioButtonSelectionForSystemStatus:)   forControlEvents:UIControlEventTouchDown];
         
         cell.checkBoxNRadioButtonSelectionForSystemStatusButton.adjustsImageWhenHighlighted = YES;
         cell.accessoryType = UITableViewCellAccessoryNone;
         
         [cell.checkBoxNRadioButtonSelectionForSystemStatusButton addTarget:self action:@selector(checkBoxNRadioButtonSelectionForSystemStatus:)   forControlEvents:UIControlEventTouchDown];
         
         if (orderSystemStatusTableView.tag == 0) {
             
             cell.txt04.text=[[[[orderSystemStatusArray objectAtIndex:0] firstObject] objectAtIndex:indexPath.row] objectForKey:@"orders_txt04"];
             cell.Txt30.text=[[[[orderSystemStatusArray objectAtIndex:0] firstObject] objectAtIndex:indexPath.row] objectForKey:@"orders_txt30"];
             
             if ([[[[[orderSystemStatusArray objectAtIndex:0] firstObject] objectAtIndex:indexPath.row] objectForKey:@"orders_act"] isEqualToString:@"X"]) {
                 
                 [cell.checkBoxNRadioButtonSelectionForSystemStatusButton  setImage:[UIImage imageNamed:@"radioselection.png"]   forState:UIControlStateNormal];
             }
             else{
                 
                 [cell.checkBoxNRadioButtonSelectionForSystemStatusButton  setImage:[UIImage imageNamed:@"radiounselection.png"]   forState:UIControlStateNormal];
             }
         }
         else if (orderSystemStatusTableView.tag == 1){
             
             cell.txt04.text=[[[[orderSystemStatusArray objectAtIndex:1] firstObject] objectAtIndex:indexPath.row] objectForKey:@"orders_txt04"];
             cell.Txt30.text=[[[[orderSystemStatusArray objectAtIndex:1] firstObject] objectAtIndex:indexPath.row] objectForKey:@"orders_txt30"];
             
             if ([[[[[orderSystemStatusArray objectAtIndex:1] firstObject] objectAtIndex:indexPath.row] objectForKey:@"orders_act"] isEqualToString:@"X"]) {
                 
                 [cell.checkBoxNRadioButtonSelectionForSystemStatusButton  setImage:[UIImage imageNamed:@"radioselection.png"]   forState:UIControlStateNormal];
             }
             else{
                 
                 [cell.checkBoxNRadioButtonSelectionForSystemStatusButton  setImage:[UIImage imageNamed:@"radiounselection.png"]   forState:UIControlStateNormal];
             }
         }
         else if (orderSystemStatusTableView.tag == 2){
             
             cell.txt04.text=[[[[orderSystemStatusArray objectAtIndex:2] firstObject] objectAtIndex:indexPath.row] objectForKey:@"orders_txt04"];
             cell.Txt30.text=[[[[orderSystemStatusArray objectAtIndex:2] firstObject] objectAtIndex:indexPath.row] objectForKey:@"orders_txt30"];
             
             if ([[[[[orderSystemStatusArray objectAtIndex:2] firstObject] objectAtIndex:indexPath.row] objectForKey:@"orders_act"] isEqualToString:@"X"]) {
                 
                 [cell.checkBoxNRadioButtonSelectionForSystemStatusButton  setImage:[UIImage imageNamed:@"radioselection.png"]   forState:UIControlStateNormal];
             }
             else{
                 
                 [cell.checkBoxNRadioButtonSelectionForSystemStatusButton  setImage:[UIImage imageNamed:@"radiounselection.png"]   forState:UIControlStateNormal];
             }
         }
         
         return cell;
     }
      else if (tableView==checkPointTableView)
      {
          if (checkPointTableView.contentSize.height < checkPointTableView.frame.size.height) {
              checkPointTableView.scrollEnabled = NO;
          }
          else
              checkPointTableView.scrollEnabled = YES;
          
          static NSString *CellIdentifier = @"Cell";
          
          StandardCheckPointTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
          
          if (cell==nil) {
              cell=[[StandardCheckPointTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
          }
          
          cell.accessoryType = UITableViewCellAccessoryNone;
          cell.selectionStyle=UITableViewCellSelectionStyleNone;
          
          [cell.yesBtn addTarget:self action:@selector(radioBoxYesClicked:)   forControlEvents:UIControlEventTouchDown];
          
          [cell.noBtn addTarget:self action:@selector(radioBoxNoClicked:)   forControlEvents:UIControlEventTouchDown];
          
          [cell.naBtn addTarget:self action:@selector(radioBoxNAClicked:)   forControlEvents:UIControlEventTouchDown];
          
          if (indexPath.row % 2 == 0){
              cell.backgroundColor =UIColorFromRGB(249, 249, 249);
          }
          else {
              cell.backgroundColor =[UIColor whiteColor];
          }
          
 
          [cell.yesBtn setUserInteractionEnabled:YES];
          [cell.noBtn setUserInteractionEnabled:YES];
          
          
          if (checkPointTableView.tag==0) {
              
              cell.checkPointLabel.text=[[[self.hazardsControlSCheckpointsArray firstObject] objectAtIndex:indexPath.row] objectAtIndex:6];
              
              if ([[[[self.hazardsControlSCheckpointsArray firstObject] objectAtIndex:indexPath.row] objectAtIndex:5] isEqualToString:@"Y"]) {
                  
                  [cell.yesBtn  setImage:[UIImage imageNamed:@"radioselection.png"]   forState:UIControlStateNormal];
                  
                  [cell.noBtn  setImage:[UIImage imageNamed:@"radiounselection.png"]   forState:UIControlStateNormal];
                  
                  //  [cell.naBtn  setImage:[UIImage imageNamed:@"checkbox_unselected.png"]   forState:UIControlStateNormal];
              }
              else if ([[[[self.hazardsControlSCheckpointsArray firstObject] objectAtIndex:indexPath.row] objectAtIndex:5] isEqualToString:@"N"]) {
                  
                  [cell.noBtn  setImage:[UIImage imageNamed:@"radioselection.png"]   forState:UIControlStateNormal];
                  
                  [cell.yesBtn  setImage:[UIImage imageNamed:@"radiounselection.png"]   forState:UIControlStateNormal];
                  
                  //  [cell.naBtn  setImage:[UIImage imageNamed:@"checkbox_unselected.png"]   forState:UIControlStateNormal];
              }
              else{
                  
                  //  [cell.naBtn  setImage:[UIImage imageNamed:@"checkbox_selected.png"]   forState:UIControlStateNormal];
                  
                  [cell.yesBtn  setImage:[UIImage imageNamed:@"radiounselection.png"]   forState:UIControlStateNormal];
                  
                  [cell.noBtn  setImage:[UIImage imageNamed:@"radiounselection.png"]   forState:UIControlStateNormal];
              }
              
              if ([[[[self.hazardsControlSCheckpointsArray firstObject] objectAtIndex:indexPath.row] objectAtIndex:14] isEqualToString:@""]) {
                  
                  [cell.yesBtn setUserInteractionEnabled:NO];
                  [cell.noBtn setUserInteractionEnabled:NO];
                  
              }
          }
          else if (checkPointTableView.tag==1){
              
              cell.checkPointLabel.text=[[[self.hazardsControlSCheckpointsArray lastObject] objectAtIndex:indexPath.row] objectAtIndex:6];
              
              if ([[[[self.hazardsControlSCheckpointsArray lastObject] objectAtIndex:indexPath.row] objectAtIndex:5] isEqualToString:@"Y"]||[[[[self.hazardsControlSCheckpointsArray lastObject] objectAtIndex:indexPath.row] objectAtIndex:13] isEqualToString:@"X"]) {
                  
                  [cell.yesBtn  setImage:[UIImage imageNamed:@"radioselection.png"]   forState:UIControlStateNormal];
                  
                  [cell.noBtn  setImage:[UIImage imageNamed:@"radiounselection.png"]   forState:UIControlStateNormal];
                  
                  // [cell.naBtn  setImage:[UIImage imageNamed:@"checkbox_unselected.png"]   forState:UIControlStateNormal];
              }
              else if ([[[[self.hazardsControlSCheckpointsArray lastObject] objectAtIndex:indexPath.row] objectAtIndex:5] isEqualToString:@"N"]||[[[[self.hazardsControlSCheckpointsArray lastObject] objectAtIndex:indexPath.row] objectAtIndex:13] isEqualToString:@"X"]) {
                  
                  [cell.noBtn  setImage:[UIImage imageNamed:@"radioselection.png"]   forState:UIControlStateNormal];
                  
                  [cell.yesBtn  setImage:[UIImage imageNamed:@"radiounselection.png"]   forState:UIControlStateNormal];
                  
                  //  [cell.naBtn  setImage:[UIImage imageNamed:@"checkbox_unselected.png"]   forState:UIControlStateNormal];
              }
              else{
                  
                  //  [cell.naBtn  setImage:[UIImage imageNamed:@"checkbox_selected.png"]   forState:UIControlStateNormal];
                  
                  [cell.yesBtn  setImage:[UIImage imageNamed:@"radiounselection.png"]   forState:UIControlStateNormal];
                  
                  [cell.noBtn  setImage:[UIImage imageNamed:@"radiounselection.png"]   forState:UIControlStateNormal];
              }
              
              if ([[[[self.hazardsControlSCheckpointsArray lastObject] objectAtIndex:indexPath.row] objectAtIndex:14] isEqualToString:@""]) {
                  
                  [cell.yesBtn setUserInteractionEnabled:NO];
                  [cell.noBtn setUserInteractionEnabled:NO];
                  
              }
          }
          
          return cell;
      }
 
     return nil;
 }

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView ==commonlistTableView)
    {
 
        if (commonlistTableView.tag==2) {
 
            operationSelectedFlag = YES;
            
            if (createOrderFlag) {
                updateOperationsBtn.hidden = NO;
                addOperationsBtn.hidden=YES;
            }
            else{
                
                updateOperationsBtn.hidden = NO;
                addOperationsBtn.hidden=YES;
            }
            
            currentOperationItemIndex=  (int)indexPath.row;
            
            operationTextFieldString = [NSString stringWithFormat:@"%@",[[[self.operationDetailsArray objectAtIndex:indexPath.row] firstObject] objectAtIndex:2]];
            
            vornrOperationID =[NSString stringWithFormat:@"%@",[[[self.operationDetailsArray objectAtIndex:indexPath.row] firstObject] objectAtIndex:1]];
            
            VornrOperation = [vornrOperationID intValue];
            
            operationLongTextView.text = [NSString stringWithFormat:@"%@",[[[self.operationDetailsArray objectAtIndex:indexPath.row] firstObject] objectAtIndex:20]];
            
            durationInputTextField.text = [NSString stringWithFormat:@"%@",[[[self.operationDetailsArray objectAtIndex:indexPath.row] firstObject] objectAtIndex:3]];
            durationID=[NSString stringWithFormat:@"%@",[[[self.operationDetailsArray objectAtIndex:indexPath.row] firstObject] objectAtIndex:4]];
            durationTextField.text = [NSString stringWithFormat:@"%@",[[[self.operationDetailsArray objectAtIndex:indexPath.row] firstObject] objectAtIndex:4]];
            
            plantWorkCenterOperatonID= [NSString stringWithFormat:@"%@",[[[self.operationDetailsArray objectAtIndex:indexPath.row] firstObject]  objectAtIndex:26]];
            
            operationPlanttextField.text = [NSString stringWithFormat:@"%@",[[[self.operationDetailsArray objectAtIndex:indexPath.row] firstObject]  objectAtIndex:27]];
            
            workCenterOperationID = [NSString stringWithFormat:@"%@",[[[self.operationDetailsArray objectAtIndex:indexPath.row] firstObject]  objectAtIndex:28]];
            
            operationWkcenterTextfield.text = [NSString stringWithFormat:@"%@",[[[self.operationDetailsArray objectAtIndex:indexPath.row] firstObject]  objectAtIndex:29]];
            
            controlKeyId = [NSString stringWithFormat:@"%@",[[[self.operationDetailsArray objectAtIndex:indexPath.row] firstObject]  objectAtIndex:19]];
            operationControlKeyTextfield.text = [NSString stringWithFormat:@"%@",[[[self.operationDetailsArray objectAtIndex:indexPath.row] firstObject]  objectAtIndex:30]];
            
            if ([[[self.operationDetailsArray objectAtIndex:indexPath.row] objectAtIndex:1] count] ==[self.customComponentsDetailsArray count])
            {
                for (int i =0; i <[[[self.operationDetailsArray objectAtIndex:indexPath.row] objectAtIndex:1] count]; i++)
                {
                    [[self.customOperationDetailsArray objectAtIndex:i] replaceObjectAtIndex:4 withObject:[[[[self.operationDetailsArray objectAtIndex:indexPath.row] objectAtIndex:1] objectAtIndex:i] objectAtIndex:4]];
                    
                }
            }
            else
            {
                NSInteger countValue=[self.customComponentsDetailsArray count];
                if ([[[self.operationDetailsArray objectAtIndex:indexPath.row] objectAtIndex:1] count]) {
                    for (int j=0; j<countValue; j++) {
                        [[self.customOperationDetailsArray objectAtIndex:j] replaceObjectAtIndex:4 withObject:[[[[self.operationDetailsArray objectAtIndex:indexPath.row] objectAtIndex:1] objectAtIndex:j] objectAtIndex:4]];
                    }
                }
            }
            
 
            
            [defaults setObject:[[self.operationDetailsArray objectAtIndex:indexPath.row] objectAtIndex:1] forKey:@"tempCustomOperation"];
            [defaults synchronize];
            
            if (!componentTextField.text.length && !quantityTextField.text.length) {
                plantID = @"";
                plantComponentTextField.text = plantID;
                storageLocationID = @"";
                storageLocationComponentTextField.text = storageLocationID;
            }
            
            plantComponentsLabelid.hidden = NO;
            plantComponentTextField.hidden = NO;
            storageLocComponentsLabelid.hidden = NO;
            storageLocationComponentTextField.hidden = NO;
            plantComponentSeperator.hidden=NO;
            
            submitResetView.hidden=YES;
            
            updateOperationsBtn.userInteractionEnabled=YES;
            
       // .contentInset=UIEdgeInsetsMake(0.0,0.0,400,0.0);

 
            [addOperationView setFrame:CGRectMake(0, 0, commonlistTableView.frame.size.width, commonlistTableView.frame.size.height)];
            
            [commonlistTableView addSubview:addOperationView];
 
            customOperationFlag = NO;
            customComponentFlag = NO;
        }
        
        else if (commonlistTableView.tag==3){
            
        {
                
                operationSelectedFlag = YES;
                
             //   [self componentsEnabling];
                
                if (createOrderFlag) {
                    updateOperationsBtn.hidden = NO;
                    addOperationsBtn.hidden=NO;
                }
                else{
                    
                    if (editBtnSelected) {
                        updateOperationsBtn.hidden = NO;
                        addOperationsBtn.hidden=NO;
//                        if ([OstatusLabel isEqualToString:@"Partially Confirmed"]||[OstatusLabel isEqualToString:@"Confirmed"])
//                        {
//                            [self partialConfirmationDisabling];
//                        }
                    }
                    else{
                        updateOperationsBtn.hidden = YES;
                        addOperationsBtn.hidden=YES;
                    }
                }
                
                partHeaderLabel.text = @"Update Component";
                updateComponent.hidden = NO;
                addComponentButton.hidden = YES;
                currentOperationItemIndex=  (int)indexPath.row;
                
                operationNoTextField.text = [NSString stringWithFormat:@"%@",[[[self.partDetailsArray objectAtIndex:indexPath.row] firstObject] objectAtIndex:1]];
                operationNoTextField.userInteractionEnabled = NO;
                
                operationNoString = [NSString stringWithFormat:@"%@",[[[self.partDetailsArray objectAtIndex:indexPath.row] firstObject] objectAtIndex:1]];
                
                componentTextField.text = [NSString stringWithFormat:@"%@",[[[self.partDetailsArray objectAtIndex:indexPath.row] firstObject] objectAtIndex:6]];
                ;
                componentID=[NSString stringWithFormat:@"%@",[[[self.partDetailsArray objectAtIndex:indexPath.row] firstObject] objectAtIndex:5]];
                quantityTextField.text = [NSString stringWithFormat:@"%@",[[[self.partDetailsArray objectAtIndex:indexPath.row] firstObject] objectAtIndex:2]];
                
                plantID=[NSString stringWithFormat:@"%@",[[[self.partDetailsArray objectAtIndex:indexPath.row] firstObject] objectAtIndex:13]];
                plantComponentTextField.text = [NSString stringWithFormat:@"%@",[[[self.partDetailsArray objectAtIndex:indexPath.row] firstObject] objectAtIndex:14]];
                
                storageLocationID=[NSString stringWithFormat:@"%@",[[[self.partDetailsArray objectAtIndex:indexPath.row] firstObject]  objectAtIndex:3]];
                storageLocationComponentTextField.text = [NSString stringWithFormat:@"%@",[[[self.partDetailsArray objectAtIndex:indexPath.row] firstObject]  objectAtIndex:4]];
                
                vornrComponentID=[NSString stringWithFormat:@"%@",[[[self.partDetailsArray objectAtIndex:indexPath.row] firstObject] objectAtIndex:8]];
                
                if (![[[[self.partDetailsArray objectAtIndex:indexPath.row] firstObject] objectAtIndex:11] isEqualToString:@""]) {
                    
                    
                    rsNuMLabel.hidden=NO;
                    rsNuMLabel.text=[NSString stringWithFormat:@"RsNum# :%@",[[[self.partDetailsArray objectAtIndex:indexPath.row] firstObject] objectAtIndex:11]];
                    
                }
                
                VornrComponent = [vornrComponentID intValue];
                
                VornrComponent = VornrComponent+10;
                
                if ([[[self.partDetailsArray objectAtIndex:indexPath.row] lastObject] count]) {
                    
                    for (int i =0; i <[[[self.partDetailsArray objectAtIndex:indexPath.row] lastObject] count]; i++) {
                        
                        if ([[self.customComponentsDetailsArray objectAtIndex:i] count]) {
                            [[self.customComponentsDetailsArray objectAtIndex:i] replaceObjectAtIndex:4 withObject:[[[[self.partDetailsArray objectAtIndex:indexPath.row] lastObject] objectAtIndex:i] objectAtIndex:4]];
                        }
                    }
                    
                    [defaults setObject:[[self.partDetailsArray objectAtIndex:indexPath.row] lastObject] forKey:@"tempCustomComponent"];
                }
                else{
                    
                    [defaults setObject:self.customComponentsDetailsArray forKey:@"tempCustomComponent"];
                }
                
                [defaults synchronize];
                
                if (!componentTextField.text.length && !quantityTextField.text.length) {
                    plantID = @"";
                    plantComponentTextField.text = plantID;
                    storageLocationID = @"";
                    storageLocationComponentTextField.text = storageLocationID;
                }
                
                plantComponentsLabelid.hidden = NO;
                plantComponentTextField.hidden = NO;
                storageLocComponentsLabelid.hidden = NO;
                storageLocationComponentTextField.hidden = NO;
                plantComponentSeperator.hidden=NO;
                
                //customOperationFlag = NO;
//                customComponentFlag = NO;
//
            
            [addPartsView setFrame:CGRectMake(0, 0, commonlistTableView.frame.size.width, commonlistTableView.frame.size.height)];
            
            partsScrollView.contentInset=UIEdgeInsetsMake(0.0,0.0,400,0.0);
            
            updateComponent.hidden = NO;
            addComponentButton.hidden = YES;
            rsNuMLabel.hidden=YES;
            
            partHeaderLabel.text = @"Update Material";
            operationNoTextField.userInteractionEnabled = YES;
            
             submitResetView.hidden=YES;
            
            [commonlistTableView addSubview:addPartsView];
            
            }
         }
        
       else   if (commonlistTableView.tag==5) {
 
            [workApprovalHeaderView setFrame:CGRectMake(0, 0, commonlistTableView.frame.size.width, commonlistTableView.frame.size.height)];
            
            wcmScrollView.contentInset=UIEdgeInsetsMake(0.0,0.0,400,0.0);
            
            // submitResetView.hidden=YES;
            
//            issuePermitsPosition = @"WW";
//            objnrIdPosition = @"";
            
            workApprovalObjArt=[[self.workApprovalDetailsArray objectAtIndex:indexPath.row] objectAtIndex:2];
            
            
            wcmShortTextField.text=[[self.workApprovalDetailsArray objectAtIndex:indexPath.row] objectAtIndex:12];
 
            wcmFunctionLocationTextfield.text= funcLocName;
            
            wcmFunctionLocationTextfield.userInteractionEnabled = NO;
            
            wcmPriorityId=[[self.workApprovalDetailsArray objectAtIndex:indexPath.row] objectAtIndex:17];
            wcmPriorityTextfield.text=[[self.workApprovalDetailsArray objectAtIndex:indexPath.row] objectAtIndex:18];
            
            wcmUsageID=[[self.workApprovalDetailsArray objectAtIndex:indexPath.row] objectAtIndex:4];
            wcmUsageTextField.text=[[self.workApprovalDetailsArray objectAtIndex:indexPath.row] objectAtIndex:5];
            
            wcmUserGroupID=[[self.workApprovalDetailsArray objectAtIndex:indexPath.row] objectAtIndex:29];
            wcmUsergrouptextField.text=[[self.workApprovalDetailsArray objectAtIndex:indexPath.row] objectAtIndex:30];
            
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd"];
            
            NSDate *startDate = [dateFormatter dateFromString:[[self.workApprovalDetailsArray objectAtIndex:indexPath.row] objectAtIndex:13]];
            NSDate *endDate = [dateFormatter dateFromString:[[self.workApprovalDetailsArray objectAtIndex:indexPath.row] objectAtIndex:15]];
            // Convert date object into desired format
            
            [dateFormatter setDateFormat:@"MMM dd, yyyy"];
            
            
            NSString *convertedStartDateString = [dateFormatter stringFromDate:startDate];
            
            if (![NullChecker isNull:convertedStartDateString]) {
                
                
                wcmFromDateTextfield.text=convertedStartDateString;
                
            }
            else{
                
                wcmFromDateTextfield.text=@"";
                
            }
            
            
            wcmFromTimeTextfield.text=[[self.workApprovalDetailsArray objectAtIndex:indexPath.row] objectAtIndex:14];
            
            
            NSString *convertedEndDateString = [dateFormatter stringFromDate:endDate];
            
            if (![NullChecker isNull:convertedEndDateString]) {
                
                wcmToDateTextfield.text=convertedEndDateString;
            }
            else{
                
                wcmToDateTextfield.text=@"";
                
            }
            
            wcmToTimeTextfield.text=[[self.workApprovalDetailsArray objectAtIndex:indexPath.row] objectAtIndex:16];
            
            
            if ([[[self.workApprovalDetailsArray objectAtIndex:indexPath.row] objectAtIndex:24] isEqualToString:@"X"]) {
                
                [setPreparedBtn setImage:[UIImage imageNamed:@"set_prepared_enable_icon"] forState:UIControlStateNormal];
                setPreparedFlag=YES;
                setPreparedString=@"X";
                
                issueApprovalsBtn.hidden=NO;
                
                isolationIssueApprovalBtn.hidden=NO;
 
                issuepermitImage.hidden=NO;
                 issuePermitLabel.hidden=NO;
                
                isolationPermitLabel.hidden=NO;
                isolationPermitImage.hidden=NO;
                
                if ([[[self.workApprovalDetailsArray objectAtIndex:indexPath.row] objectAtIndex:26] isEqualToString:@"G"]) {
                    [issuepermitImage setImage:[UIImage imageNamed:@"traffic_green_icon"]];
                }
                else{
                    [issuepermitImage setImage:[UIImage imageNamed:@"traffic_red_icon"]];
                }
                
                wcmShortTextField.userInteractionEnabled = NO;
                wcmFromDateTextfield.userInteractionEnabled = NO;
                wcmFromTimeTextfield.userInteractionEnabled = NO;
                wcmToDateTextfield.userInteractionEnabled = NO;
                wcmToTimeTextfield.userInteractionEnabled = NO;
                wcmPriorityTextfield.userInteractionEnabled = NO;
                issuepermitImage.userInteractionEnabled = NO;
                wcmUsergrouptextField.userInteractionEnabled=NO;
                wcmUsageTextField.userInteractionEnabled=NO;
                
            }
            else{
                
                [setPreparedBtn setImage:[UIImage imageNamed:@"set_prepared_disable_icon"] forState:UIControlStateNormal];
                setPreparedFlag=NO;
                setPreparedString=@"";
                
                issueApprovalsBtn.hidden=YES;
                isolationIssueApprovalBtn.hidden=YES;
                
                issuepermitImage.hidden=YES;
                issuePermitLabel.hidden=YES;
                isolationPermitLabel.hidden=YES;
                isolationPermitImage.hidden=YES;
                
                wcmShortTextField.userInteractionEnabled = YES;
                wcmFromDateTextfield.userInteractionEnabled = YES;
                wcmFromTimeTextfield.userInteractionEnabled = YES;
                wcmToDateTextfield.userInteractionEnabled = YES;
                wcmToTimeTextfield.userInteractionEnabled = YES;
                wcmPriorityTextfield.userInteractionEnabled = YES;
                issuepermitImage.userInteractionEnabled = YES;
                wcmUsergrouptextField.userInteractionEnabled=YES;
                wcmUsageTextField.userInteractionEnabled=YES;
                
            }
            
            applicationBtn.hidden=NO;
            standardCheckPointBtn.hidden=YES;
            opWCDBtn.hidden=YES;
            switchingScreenBtn.hidden=NO;
            changeWorkApprovalFlag=YES;
            
 
            [self trafficSignalforWorkApproval];
            
            headerWorkApprovalLabel.text=@"Change Work Approval";
            
             [commonlistTableView addSubview:workApprovalHeaderView];
            
        }
    }
 
    else if (tableView==applicationTypeTableView){
        
        issuePermitsPosition = @"WA";
        
        objnrIdPosition = [[[self.workApplicationDetailsArray objectAtIndex:indexPath.row] firstObject] objectAtIndex:22];
        
        refObjString=[[[self.workApplicationDetailsArray objectAtIndex:indexPath.row] firstObject] objectAtIndex:23];
        
        WARefobj=[[[self.workApplicationDetailsArray objectAtIndex:indexPath.row] firstObject] objectAtIndex:22];
        
        waSelectedIndex=(int)indexPath.row;
        workApplicationSelectedIndex=(int)indexPath.row;
        
        isolationlistBtn.hidden=YES;
        
        changeApplicationFlag=YES;
        applicationObjArt=[[[self.workApplicationDetailsArray objectAtIndex:indexPath.row] firstObject] objectAtIndex:2];
        
        applicationTypeString= [[[self.workApplicationDetailsArray objectAtIndex:indexPath.row] firstObject] objectAtIndex:4];
        
        if ([[[[self.workApplicationDetailsArray objectAtIndex:indexPath.row] firstObject] objectAtIndex:4] isEqualToString:@"1"]) {
            
            
            NSMutableDictionary *fetchData = [NSMutableDictionary new];
            [fetchData setObject:[[[self.workApplicationDetailsArray objectAtIndex:indexPath.row] firstObject] objectAtIndex:4] forKey:@"ObjTypeID"];
            [fetchData setObject:plantWorkCenterID forKey:@"PlantID"];
            
            
            NSArray *objTypeTextArray = [[DataBase sharedInstance] getApplicationNameForObjType:fetchData];
            
            if ([objTypeTextArray count]) {
                isolationHeaderLabel.text = [objTypeTextArray objectAtIndex:0];
            }
            else{
                
                isolationHeaderLabel.text = [[[self.workApplicationDetailsArray objectAtIndex:indexPath.row] firstObject] objectAtIndex:4];
            }
            
            wcmIsolationText=isolationHeaderLabel.text;
            
            
            standardCheckPointBtn.hidden=YES;
            isolationShortTextField.text=[[[self.workApplicationDetailsArray objectAtIndex:indexPath.row] firstObject] objectAtIndex:13];
            
            isolationFunctionLocationTextfield.text= funcLocName;
            
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd"];
            
            NSDate *startDate = [dateFormatter dateFromString:[[[self.workApplicationDetailsArray objectAtIndex:indexPath.row] firstObject] objectAtIndex:14]];
            NSDate *endDate = [dateFormatter dateFromString:[[[self.workApplicationDetailsArray objectAtIndex:indexPath.row] firstObject] objectAtIndex:16]];
            // Convert date object into desired format
            
            [dateFormatter setDateFormat:@"MMM dd, yyyy"];
            
            
            NSString *convertedStartDateString = [dateFormatter stringFromDate:startDate];
            
            if (![NullChecker isNull:convertedStartDateString]) {
                isolationFromDateTextfield.text=convertedStartDateString;
                
            }
            else{
                
                isolationFromDateTextfield.text=@"";
            }
            
            additionalTextBtn.hidden=YES;
            
            isolationFromTimeTextfield.text=[[[self.workApplicationDetailsArray objectAtIndex:indexPath.row] firstObject] objectAtIndex:15];
            
            NSString *convertedEndDateString = [dateFormatter stringFromDate:endDate];
            
            if (![NullChecker isNull:convertedEndDateString]) {
                
                isolationToDateTextfield.text=convertedEndDateString;
            }
            else{
                
                isolationToDateTextfield.text=@"";
                
            }
            
            isolationToTimeTextfield.text=[[[self.workApplicationDetailsArray objectAtIndex:indexPath.row] firstObject] objectAtIndex:17];
            
            if ([[[[self.workApplicationDetailsArray objectAtIndex:indexPath.row] firstObject] objectAtIndex:25] isEqualToString:@"X"]) {
                
                [isolationSetPreparedBtn setImage:[UIImage imageNamed:@"set_prepared_enable_icon"] forState:UIControlStateNormal];
                
                setPreparedIsolationFlag=YES;
                isolationSetPreparedString=@"X";
            }
            else{
                
                [isolationSetPreparedBtn setImage:[UIImage imageNamed:@"set_prepared_disable_icon"] forState:UIControlStateNormal];
                setPreparedIsolationFlag=NO;
                isolationSetPreparedString=@"";
            }
            
            
            isolationUsageID=[[[self.workApplicationDetailsArray objectAtIndex:indexPath.row] firstObject] objectAtIndex:5];
            isolationUsageTextfield.text=[[[self.workApplicationDetailsArray objectAtIndex:indexPath.row] firstObject] objectAtIndex:6];
            
            isolationUserGroupID=[[[self.workApplicationDetailsArray objectAtIndex:indexPath.row] firstObject] objectAtIndex:29];
            isolationUsergroupTexField.text=[[[self.workApplicationDetailsArray objectAtIndex:indexPath.row] firstObject] objectAtIndex:30];
            
            isolationPriorityId = [[[self.workApplicationDetailsArray objectAtIndex:indexPath.row] firstObject] objectAtIndex:18];
            isolationPriorityTextfield.text=[[[self.workApplicationDetailsArray objectAtIndex:indexPath.row] firstObject] objectAtIndex:19];
            
            // opwcdRefObj=[[[self.workApplicationDetailsArray objectAtIndex:indexPath.row] firstObject] objectAtIndex:22];
            
            switchingScreenBtn.hidden=YES;
            
            isolationFunctionLocationTextfield.userInteractionEnabled = NO;
            
            if ([[[[self.workApplicationDetailsArray objectAtIndex:indexPath.row] firstObject] objectAtIndex:25] isEqualToString:@"X"]) {
                
                isolationShortTextField.userInteractionEnabled = NO;
                isolationFromDateTextfield.userInteractionEnabled = NO;
                isolationFromTimeTextfield.userInteractionEnabled = NO;
                isolationToDateTextfield.userInteractionEnabled = NO;
                isolationToTimeTextfield.userInteractionEnabled = NO;
                isolationPriorityTextfield.userInteractionEnabled = NO;
                isolationUsergroupTexField.userInteractionEnabled=NO;
                isolationUsageTextfield.userInteractionEnabled=NO;
            }
            else{
                
                isolationShortTextField.userInteractionEnabled = YES;
                isolationFromDateTextfield.userInteractionEnabled = YES;
                isolationFromTimeTextfield.userInteractionEnabled = YES;
                isolationToDateTextfield.userInteractionEnabled = YES;
                isolationToTimeTextfield.userInteractionEnabled = YES;
                isolationPriorityTextfield.userInteractionEnabled = YES;
                isolationUsergroupTexField.userInteractionEnabled=YES;
                isolationUsageTextfield.userInteractionEnabled=YES;
                
            }
            
            [self trafficSignalforIsolationWApplication];
            
            [self.view addSubview:isolationHeaderView];
            
        }
        else {
            
            standardCheckPointBtn.hidden=NO;
            switchingScreenBtn.hidden=YES;
            
            wcmShortTextField.text=[[[self.workApplicationDetailsArray objectAtIndex:indexPath.row] firstObject] objectAtIndex:13];
            wcmFunctionLocationTextfield.text=funcLocName;
            
            wcmFunctionLocationTextfield.userInteractionEnabled = NO;
            
            wcmFromDateTextfield.text=[[[self.workApplicationDetailsArray objectAtIndex:indexPath.row] firstObject] objectAtIndex:14];
            wcmFromTimeTextfield.text=[[[self.workApplicationDetailsArray objectAtIndex:indexPath.row] firstObject] objectAtIndex:15];
            wcmToDateTextfield.text=[[[self.workApplicationDetailsArray objectAtIndex:indexPath.row] firstObject] objectAtIndex:16];
            wcmToTimeTextfield.text=[[[self.workApplicationDetailsArray objectAtIndex:indexPath.row] firstObject] objectAtIndex:17];
            wcmUsageID=[[[self.workApplicationDetailsArray objectAtIndex:indexPath.row] firstObject] objectAtIndex:5];
             wcmUsageTextField.text=[[[self.workApplicationDetailsArray objectAtIndex:indexPath.row] firstObject] objectAtIndex:6];
             wcmUserGroupID=[[[self.workApplicationDetailsArray objectAtIndex:indexPath.row] firstObject] objectAtIndex:29];
             wcmUsergrouptextField.text=[[[self.workApplicationDetailsArray objectAtIndex:indexPath.row] firstObject] objectAtIndex:30];
           
            [self checkpointValidation];
 
            if ([[[[self.workApplicationDetailsArray objectAtIndex:indexPath.row] firstObject] objectAtIndex:25] isEqualToString:@"X"]) {
                
                setPreparedFlag=YES;
                setPreparedString=@"X";
                [setPreparedBtn setImage:[UIImage imageNamed:@"set_prepared_enable_icon"] forState:UIControlStateNormal];
            }
            else{
                
                setPreparedFlag=NO;
                setPreparedString=@"";
                [setPreparedBtn setImage:[UIImage imageNamed:@"set_prepared_disable_icon"] forState:UIControlStateNormal];
            }
            
            wcmPriorityId = [[[self.workApplicationDetailsArray objectAtIndex:indexPath.row] firstObject] objectAtIndex:18];
            
            wcmPriorityTextfield.text = [[[self.workApplicationDetailsArray objectAtIndex:indexPath.row] firstObject] objectAtIndex:19];
            
            if ([[[[self.workApplicationDetailsArray objectAtIndex:indexPath.row] firstObject] objectAtIndex:27] isEqualToString:@"G"]) {
                
                issuepermitImage.image=[UIImage imageNamed:@"green_traffic.png"];
            }
            else if ([[[[self.workApplicationDetailsArray objectAtIndex:indexPath.row] firstObject] objectAtIndex:27] isEqualToString:@"Y"]){
                
                issuepermitImage.image=[UIImage imageNamed:@"yellow_traffic.png"];
                
            }
            else{
                
                [self trafficSignalforIsolationWApplication];
             }
            
            [self.view addSubview:workApprovalHeaderView];
            
         }
        applicationBtn.hidden=YES;
        opWCDBtn.hidden=NO;
        changeWorkApprovalFlag=YES;
    }
    
    else if (tableView == self.dropDownTableView) {

        switch ([self.dropDownTableView tag]) {

            case ORDER_TYPE:
 
              
                    [[headerDataArray objectAtIndex:0] replaceObjectAtIndex:2 withObject:[[self.dropDownArray objectAtIndex:indexPath.row] objectAtIndex:NAME_INDEX]];
                    [[headerDataArray objectAtIndex:0] replaceObjectAtIndex:3 withObject:[[self.dropDownArray objectAtIndex:indexPath.row] objectAtIndex:ID_INDEX]];
               
                 [commonlistTableView endEditing:YES];
                [commonlistTableView reloadData];

                break;

            case ORDER_COSTCENTER:

                if (createOrderFlag) {
                    
                    [[headerDataArray objectAtIndex:10] replaceObjectAtIndex:2 withObject:[[self.dropDownArray objectAtIndex:indexPath.row] objectAtIndex:NAME_INDEX]];
                    [[headerDataArray objectAtIndex:10] replaceObjectAtIndex:3 withObject:[[self.dropDownArray objectAtIndex:indexPath.row] objectAtIndex:ID_INDEX]];
                }
                else{
                    
                    [[headerDataArray objectAtIndex:11] replaceObjectAtIndex:2 withObject:[[self.dropDownArray objectAtIndex:indexPath.row] objectAtIndex:NAME_INDEX]];
                    [[headerDataArray objectAtIndex:11] replaceObjectAtIndex:3 withObject:[[self.dropDownArray objectAtIndex:indexPath.row] objectAtIndex:ID_INDEX]];
                }
              
                
                [commonlistTableView endEditing:YES];
                [commonlistTableView reloadData];

                break;

            case ORDER_PRIORITY:

                if (wcmPriorityFlag) {

                    if (tag==200)
                    {
                         isolationPriorityId = [NSString stringWithFormat:@"%@",[[self.dropDownArray objectAtIndex:indexPath.row] objectAtIndex:ID_INDEX]];

                        isolationPriorityTextfield.text = [NSString stringWithFormat:@"%@",[[self.dropDownArray objectAtIndex:indexPath.row] objectAtIndex:NAME_INDEX]];

                        [isolationPriorityTextfield resignFirstResponder];
                        [isolationScrollView setContentOffset:CGPointMake(0, 0)];
                    }
                    else{

                        wcmPriorityId = [NSString stringWithFormat:@"%@",[[self.dropDownArray objectAtIndex:indexPath.row] objectAtIndex:ID_INDEX]];

                        wcmPriorityTextfield.text = [NSString stringWithFormat:@"%@",[[self.dropDownArray objectAtIndex:indexPath.row] objectAtIndex:NAME_INDEX]];

                        [wcmPriorityTextfield resignFirstResponder];
                        [wcmScrollView setContentOffset:CGPointMake(0, 0)];
                    }
                }
                else
                {
                    if (createOrderFlag) {
                        
                        [[headerDataArray objectAtIndex:4] replaceObjectAtIndex:2 withObject:[[self.dropDownArray objectAtIndex:indexPath.row] objectAtIndex:NAME_INDEX]];
                        [[headerDataArray objectAtIndex:4] replaceObjectAtIndex:3 withObject:[[self.dropDownArray objectAtIndex:indexPath.row] objectAtIndex:ID_INDEX]];
                    }
                    else{
                        
                        [[headerDataArray objectAtIndex:5] replaceObjectAtIndex:2 withObject:[[self.dropDownArray objectAtIndex:indexPath.row] objectAtIndex:NAME_INDEX]];
                        [[headerDataArray objectAtIndex:5] replaceObjectAtIndex:3 withObject:[[self.dropDownArray objectAtIndex:indexPath.row] objectAtIndex:ID_INDEX]];
                    }
 
                    [commonlistTableView endEditing:YES];
                    [commonlistTableView reloadData];

                }

                break;

            case EFFECT:

//                effectTextfield.text = [NSString stringWithFormat:@"%@",[[self.dropDownArray objectAtIndex:indexPath.row] objectAtIndex:NAME_INDEX]];
//
//                effectID =[[self.dropDownArray objectAtIndex:indexPath.row] objectAtIndex:ID_INDEX];
//
//                [notifScrollView setContentOffset:CGPointMake(0,0) animated:YES];
//
//                [effectTextfield resignFirstResponder];

                break;

            case ORDER_SYSTEM_CONDITION:

                if (createOrderFlag) {
                    
                    [[headerDataArray objectAtIndex:11] replaceObjectAtIndex:2 withObject:[[self.dropDownArray objectAtIndex:indexPath.row] objectAtIndex:NAME_INDEX]];
                    [[headerDataArray objectAtIndex:11] replaceObjectAtIndex:3 withObject:[[self.dropDownArray objectAtIndex:indexPath.row] objectAtIndex:ID_INDEX]];
                }else{
                    
                    [[headerDataArray objectAtIndex:12] replaceObjectAtIndex:2 withObject:[[self.dropDownArray objectAtIndex:indexPath.row] objectAtIndex:NAME_INDEX]];
                    [[headerDataArray objectAtIndex:12] replaceObjectAtIndex:3 withObject:[[self.dropDownArray objectAtIndex:indexPath.row] objectAtIndex:ID_INDEX]];
                }
              
                
                [commonlistTableView endEditing:YES];
                [commonlistTableView reloadData];
 
                break;

            case ORDER_DURATION:

                durationID =[NSString stringWithFormat:@"%@",[[self.dropDownArray objectAtIndex:indexPath.row] objectAtIndex:ID_INDEX]];

                if (tag==1)
                {
                    durationTextField.text = durationID; //for Operation  screen
                }
//                else if (tag==2)
//                {
//                    actualWorkUnitIDTextField.text=durationID;  //for final confirmation screen
//                }

                [durationTextField resignFirstResponder];
              //  [actualWorkUnitIDTextField resignFirstResponder];

                break;

//            case ORDER_PLANT:
//
//                plantID= [NSString stringWithFormat:@"%@",[[self.dropDownArray objectAtIndex:indexPath.row] objectAtIndex:ID_INDEX]];
//
//                plantTextField.text = [NSString stringWithFormat:@"%@",[[self.dropDownArray objectAtIndex:indexPath.row] objectAtIndex:NAME_INDEX]];
//
//                plantIdHeaderTextField.text = [NSString stringWithFormat:@"%@",[[self.dropDownArray objectAtIndex:indexPath.row] objectAtIndex:NAME_INDEX]];
//
//                [plantTextField resignFirstResponder];
//
//                [plantIdHeaderTextField resignFirstResponder];
//
//                break;
//
//            case ORDER_COMPONENT:
//
//                componentID= [NSString stringWithFormat:@"%@",[[self.dropDownArray objectAtIndex:indexPath.row] objectAtIndex:ID_INDEX]];
//
//                componentTextField.text = [NSString stringWithFormat:@"%@",[[self.dropDownArray objectAtIndex:indexPath.row] objectAtIndex:NAME_INDEX]];
//
//                [componentTextField resignFirstResponder];
//
//                break;
//
//            case ORDER_CONTROLKEYS:
//
//                controlKeyId= [NSString stringWithFormat:@"%@",[[self.dropDownArray objectAtIndex:indexPath.row] objectAtIndex:ID_INDEX]];
//
//                controlKeyTextField.text = [NSString stringWithFormat:@"%@",[[self.dropDownArray objectAtIndex:indexPath.row] objectAtIndex:NAME_INDEX]];
//                operationControlKeyTextfield.text = [NSString stringWithFormat:@"%@",[[self.dropDownArray objectAtIndex:indexPath.row] objectAtIndex:NAME_INDEX]];
//
//                [operationControlKeyTextfield resignFirstResponder];
//                [controlKeyTextField resignFirstResponder];
//
//                break;
//
            case ORDER_OPERATIONNO:

                operationNoTextField.text = [[self.dropDownArray objectAtIndex:indexPath.row] objectAtIndex:NAME_INDEX];

                operationNoString = [[self.dropDownArray objectAtIndex:indexPath.row] objectAtIndex:ID_INDEX];

                [operationNoTextField resignFirstResponder];

                break;

//            case ORDER_ACTIVITYTYPE:
//
//                activityId= [NSString stringWithFormat:@"%@",[[self.dropDownArray objectAtIndex:indexPath.row] objectAtIndex:2]];
//
//                confirActivityTextField.text = [NSString stringWithFormat:@"%@",[[self.dropDownArray objectAtIndex:indexPath.row] objectAtIndex:3]];
//
//                [confirActivityTextField resignFirstResponder];
//
//                break;
//
//            case ORDER_REASONS:
//
//                reasonId= [NSString stringWithFormat:@"%@",[[self.dropDownArray objectAtIndex:indexPath.row] objectAtIndex:0]];
//
//                reasonTextField.text = [NSString stringWithFormat:@"%@",[[self.dropDownArray objectAtIndex:indexPath.row] objectAtIndex:1]];
//
//                [reasonTextField resignFirstResponder];
//
//                break;

            case ORDER_WCM_TYPE:

                opWcdTypeTexfield.text = [NSString stringWithFormat:@"%@",[[self.dropDownArray objectAtIndex:indexPath.row] objectAtIndex:1]];

                opWCDObjectID=[NSString stringWithFormat:@"%@",[[self.dropDownArray objectAtIndex:indexPath.row] objectAtIndex:0]];

                taggedBarcodeBtn.hidden=YES;


                if ([opWCDObjectID isEqualToString:@"E"]) {

                    opWcdObjectTextField.text=equipmentID;
                    taggedBarcodeBtn.hidden=NO;
                    scanFlag=YES;

                }
                else if ([opWCDObjectID isEqualToString:@"F"]){
                    opWcdObjectTextField.text=functionalLocationID;
                }

                [opWcdTypeTexfield resignFirstResponder];

                break;
            case PERSON_RESONSIBLE:

                if (createOrderFlag) {
                    
                    [personResponisbleID setString:[[self.dropDownArray objectAtIndex:indexPath.row] objectAtIndex:2]];
                    personresponsibleNameString=[[self.dropDownArray objectAtIndex:indexPath.row] objectAtIndex:4];
                    
                    [[headerDataArray objectAtIndex:6] replaceObjectAtIndex:2 withObject:[NSString stringWithFormat:@"%@-%@-%@",[[self.dropDownArray objectAtIndex:indexPath.row] objectAtIndex:2],[[self.dropDownArray objectAtIndex:indexPath.row] objectAtIndex:4],[[self.dropDownArray objectAtIndex:indexPath.row] objectAtIndex:3]]];
                }
                 else{
                    
                    [personResponisbleID setString:[[self.dropDownArray objectAtIndex:indexPath.row] objectAtIndex:2]];
                    personresponsibleNameString=[[self.dropDownArray objectAtIndex:indexPath.row] objectAtIndex:4];
                    [[headerDataArray objectAtIndex:7] replaceObjectAtIndex:2 withObject:[NSString stringWithFormat:@"%@-%@-%@",[[self.dropDownArray objectAtIndex:indexPath.row] objectAtIndex:2],[[self.dropDownArray objectAtIndex:indexPath.row] objectAtIndex:4],[[self.dropDownArray objectAtIndex:indexPath.row] objectAtIndex:3]]];
                }
              
 
                [commonlistTableView endEditing:YES];
                [commonlistTableView reloadData];
 
                break;

            case PLANNER_GROUP:

                if (createOrderFlag) {
                    
                    [[headerDataArray objectAtIndex:5] replaceObjectAtIndex:2 withObject:[[self.dropDownArray objectAtIndex:indexPath.row] objectAtIndex:NAME_INDEX]];
                    [[headerDataArray objectAtIndex:5] replaceObjectAtIndex:3 withObject:[[self.dropDownArray objectAtIndex:indexPath.row] objectAtIndex:ID_INDEX]];
                }
                else{
                    
                    [[headerDataArray objectAtIndex:6] replaceObjectAtIndex:2 withObject:[[self.dropDownArray objectAtIndex:indexPath.row] objectAtIndex:NAME_INDEX]];
                    [[headerDataArray objectAtIndex:6] replaceObjectAtIndex:3 withObject:[[self.dropDownArray objectAtIndex:indexPath.row] objectAtIndex:ID_INDEX]];
                }
 
                [commonlistTableView endEditing:YES];
                [commonlistTableView reloadData];

                break;
 
            case ORDER_WCM_USERGROUP:

                wcmUsergrouptextField.text = [NSString stringWithFormat:@"%@",[[self.dropDownArray objectAtIndex:indexPath.row] objectAtIndex:NAME_INDEX]];

                wcmUserGroupID =[[self.dropDownArray objectAtIndex:indexPath.row] objectAtIndex:ID_INDEX];


                [wcmUsergrouptextField resignFirstResponder];

                break;

            case ORDER_WCM_USAGE:

                wcmUsageTextField.text = [NSString stringWithFormat:@"%@",[[self.dropDownArray objectAtIndex:indexPath.row] objectAtIndex:3]];

                wcmUsageID =[[self.dropDownArray objectAtIndex:indexPath.row] objectAtIndex:2];

                [wcmUsageTextField resignFirstResponder];

                break;


            case ORDER_ISOLATION_USERGROUP:

                isolationUsergroupTexField.text = [NSString stringWithFormat:@"%@",[[self.dropDownArray objectAtIndex:indexPath.row] objectAtIndex:NAME_INDEX]];

                isolationUserGroupID =[[self.dropDownArray objectAtIndex:indexPath.row] objectAtIndex:ID_INDEX];

                [isolationUsergroupTexField resignFirstResponder];

                break;

            case ORDER_ISOLATION_USAGE:

                isolationUsageTextfield.text = [NSString stringWithFormat:@"%@",[[self.dropDownArray objectAtIndex:indexPath.row] objectAtIndex:3]];

                isolationUsageID =[[self.dropDownArray objectAtIndex:indexPath.row] objectAtIndex:2];

                [isolationUsageTextfield resignFirstResponder];

                break;
 
            default:
                break;
        }
    }
   else if (tableView==seachDropdownTableView)
   {
 
        [[headerDataArray objectAtIndex:9] replaceObjectAtIndex:2 withObject:[[self.dropDownArray objectAtIndex:indexPath.row] objectAtIndex:1]];
        [[headerDataArray objectAtIndex:9] replaceObjectAtIndex:3 withObject:[[self.dropDownArray objectAtIndex:indexPath.row] objectAtIndex:0]];
       
       [commonlistTableView reloadData];
 
       [searchDropDownView removeFromSuperview];
    }
    
   else if (tableView == commonlistTableView){
       
       if (commonlistTableView.tag==1) {
        
       operationSelectedFlag = YES;
       
       if (createOrderFlag) {
           updateOperationsBtn.hidden = NO;
           addOperationsBtn.hidden=YES;
       }
       else{
           
           if (editBtnSelected) {
               updateOperationsBtn.hidden = NO;
               addOperationsBtn.hidden=YES;
               
//               if ([OstatusLabel isEqualToString:@"Partially Confirmed"]||[OstatusLabel isEqualToString:@"Confirmed"])
//               {
//                   [self partialConfirmationDisabling];
//               }
               
           }
           else{
               updateOperationsBtn.hidden = YES;
               addOperationsBtn.hidden=YES;
               
           }
       }
       
       currentOperationItemIndex=  (int)indexPath.row;
       
       operationTextFieldString = [NSString stringWithFormat:@"%@",[[[self.operationDetailsArray objectAtIndex:indexPath.row] firstObject] objectAtIndex:2]];
       
       vornrOperationID =[NSString stringWithFormat:@"%@",[[[self.operationDetailsArray objectAtIndex:indexPath.row] firstObject] objectAtIndex:1]];
       
       VornrOperation = [vornrOperationID intValue];
       
       operationLongTextView.text = [NSString stringWithFormat:@"%@",[[[self.operationDetailsArray objectAtIndex:indexPath.row] firstObject] objectAtIndex:20]];
       
       durationInputTextField.text = [NSString stringWithFormat:@"%@",[[[self.operationDetailsArray objectAtIndex:indexPath.row] firstObject] objectAtIndex:3]];
       durationID=[NSString stringWithFormat:@"%@",[[[self.operationDetailsArray objectAtIndex:indexPath.row] firstObject] objectAtIndex:4]];
       durationTextField.text = [NSString stringWithFormat:@"%@",[[[self.operationDetailsArray objectAtIndex:indexPath.row] firstObject] objectAtIndex:4]];
       
       plantWorkCenterOperatonID= [NSString stringWithFormat:@"%@",[[[self.operationDetailsArray objectAtIndex:indexPath.row] firstObject]  objectAtIndex:26]];
       operationPlanttextField.text = [NSString stringWithFormat:@"%@",[[[self.operationDetailsArray objectAtIndex:indexPath.row] firstObject]  objectAtIndex:27]];
       
       workCenterOperationID = [NSString stringWithFormat:@"%@",[[[self.operationDetailsArray objectAtIndex:indexPath.row] firstObject]  objectAtIndex:28]];
       
       operationWkcenterTextfield.text = [NSString stringWithFormat:@"%@",[[[self.operationDetailsArray objectAtIndex:indexPath.row] firstObject]  objectAtIndex:29]];
       
       controlKeyId = [NSString stringWithFormat:@"%@",[[[self.operationDetailsArray objectAtIndex:indexPath.row] firstObject]  objectAtIndex:19]];
       operationControlKeyTextfield.text = [NSString stringWithFormat:@"%@",[[[self.operationDetailsArray objectAtIndex:indexPath.row] firstObject]  objectAtIndex:30]];
       
       if ([[[self.operationDetailsArray objectAtIndex:indexPath.row] objectAtIndex:1] count] ==[self.customComponentsDetailsArray count])
       {
           for (int i =0; i <[[[self.operationDetailsArray objectAtIndex:indexPath.row] objectAtIndex:1] count]; i++)
           {
               [[self.customOperationDetailsArray objectAtIndex:i] replaceObjectAtIndex:4 withObject:[[[[self.operationDetailsArray objectAtIndex:indexPath.row] objectAtIndex:1] objectAtIndex:i] objectAtIndex:4]];
               
           }
       }
       else
       {
           NSInteger countValue=[self.customComponentsDetailsArray count];
           if ([[[self.operationDetailsArray objectAtIndex:indexPath.row] objectAtIndex:1] count]) {
               for (int j=0; j<countValue; j++) {
                   [[self.customOperationDetailsArray objectAtIndex:j] replaceObjectAtIndex:4 withObject:[[[[self.operationDetailsArray objectAtIndex:indexPath.row] objectAtIndex:1] objectAtIndex:j] objectAtIndex:4]];
               }
           }
       }
       
       //        for (int i =0; i <[[self.customOperationDetailsArray objectAtIndex:i] count]; i++) {
       //            [[self.customOperationDetailsArray objectAtIndex:i] replaceObjectAtIndex:4 withObject:[[[[self.operationDetailsArray objectAtIndex:indexPath.row] objectAtIndex:1] objectAtIndex:i] objectAtIndex:4]];
       //        }
       
       
       [defaults setObject:[[self.operationDetailsArray objectAtIndex:indexPath.row] objectAtIndex:1] forKey:@"tempCustomOperation"];
       [defaults synchronize];
       
       if (!componentTextField.text.length && !quantityTextField.text.length) {
           plantID = @"";
           plantComponentTextField.text = plantID;
           storageLocationID = @"";
           storageLocationComponentTextField.text = storageLocationID;
       }
 
       plantComponentsLabelid.hidden = NO;
       plantComponentTextField.hidden = NO;
       storageLocComponentsLabelid.hidden = NO;
       storageLocationComponentTextField.hidden = NO;
       plantComponentSeperator.hidden=NO;
       
//       customOperationFlag = NO;
//       customComponentFlag = NO;
           
       }
   }
 }

-(NSIndexPath *) GetCellFromTableView: (UITableView *)tableView Sender:(id)sender
{
    CGPoint position = [sender convertPoint:CGPointZero toView:tableView];
    NSIndexPath *indexPath = [tableView indexPathForRowAtPoint:position];
    return indexPath;//[tableView cellForRowAtIndexPath:indexPath];
}


-(void)notiNoButtonClicked:(id)sender{
    
    CreateNotificationViewController *createVc = [self.storyboard instantiateViewControllerWithIdentifier:@"CreateNotifIdentifier"];
    
    NSMutableArray *tempArray=[NSMutableArray new];
    
    [tempArray addObjectsFromArray:[[DataBase sharedInstance] getNotificationHeaderForNotificationId:[[self.detailOrdersArray objectAtIndex:0] objectForKey:@"orderh_qmnum"]]];
 
    if (![tempArray count]) {
        
        [self showAlertMessageWithTitle:@"Info" message:@"No Data Found" cancelButtonTitle:@"Ok" withactionType:@"Single" forMethod:nil];
    }
    else{
          createVc.detailNotificationArray=[tempArray copy];
         [self showViewController:createVc sender:self];

      }
 
    
}

-(void)radioBoxYesClicked:(id)sender{
    
    NSIndexPath *ip = [self GetCellFromTableView:checkPointTableView Sender:sender];
    NSInteger i = ip.row;
    
    //    UIButton *tappedButton = (UIButton*)sender;
    //
    //    if([tappedButton.currentImage isEqual:[UIImage imageNamed:@"checkbox_unselected.png"]]) {
    //        [sender  setImage:[UIImage imageNamed: @"checkbox_selected.png"] forState:UIControlStateNormal];
    //
    //    }
    //    else
    //    {
    //        [sender setImage:[UIImage imageNamed:@"checkbox_unselected.png"]forState:UIControlStateNormal];
    //
    //    }
    
    if (checkPointTableView.tag==0) {
        
        checkPointFlag=YES;
        
        [[[self.hazardsControlSCheckpointsArray firstObject] objectAtIndex:i] replaceObjectAtIndex:5 withObject:@"Y"];
    }
    else if (checkPointTableView.tag==1){
        
        checkPointFlag=NO;
        
        [[[self.hazardsControlSCheckpointsArray lastObject] objectAtIndex:i] replaceObjectAtIndex:5 withObject:@"Y"];
    }
    
    [checkPointTableView reloadData];
    
}

-(void)radioBoxNoClicked:(id)sender{
    
    NSIndexPath *ip = [self GetCellFromTableView:checkPointTableView Sender:sender];
    NSInteger i = ip.row;
    
    if (checkPointTableView.tag==0) {
        
        checkPointFlag=YES;
        
        [[[self.hazardsControlSCheckpointsArray firstObject] objectAtIndex:i] replaceObjectAtIndex:5 withObject:@"N"];
    }
    else if (checkPointTableView.tag==1){
        
        checkPointFlag=NO;
        
        [[[self.hazardsControlSCheckpointsArray lastObject] objectAtIndex:i] replaceObjectAtIndex:5 withObject:@"N"];
    }
    
    [checkPointTableView reloadData];
}

-(void)radioBoxNAClicked:(id)sender{
    
    NSIndexPath *ip = [self GetCellFromTableView:checkPointTableView Sender:sender];
    NSInteger i = ip.row;
    
    if (checkPointTableView.tag==0) {
        
        checkPointFlag=YES;
        
        [[[self.hazardsControlSCheckpointsArray firstObject] objectAtIndex:i] replaceObjectAtIndex:5 withObject:@"NA"];
        
    }
    else if (checkPointTableView.tag==1){
        
        checkPointFlag=NO;
        
        [[[self.hazardsControlSCheckpointsArray lastObject] objectAtIndex:i] replaceObjectAtIndex:5 withObject:@"NA"];
    }
    
    [checkPointTableView reloadData];
}

-(void)checkBoxNRadioButtonSelectionForSystemStatus:(id)sender{
    
    NSIndexPath *ip = [self GetCellFromTableView:orderSystemStatusTableView Sender:sender];
    
    UIButton *tappedButton = (UIButton*)sender;
    
    if (orderSystemStatusTableView.tag == 1) {
        
        if ([[[[[orderSystemStatusArray objectAtIndex:1] firstObject] objectAtIndex:ip.row] objectForKey:@"orders_act"] isEqualToString:@"X"]) {
            
            if (![[[[[orderSystemStatusArray objectAtIndex:1] firstObject] objectAtIndex:ip.row] objectForKey:@"orders_selected"] isEqualToString:@"X"]) {
                
                NSMutableDictionary *newDict = [[NSMutableDictionary alloc] init];
                NSDictionary *oldDict = (NSDictionary *)[[[orderSystemStatusArray objectAtIndex:1] firstObject] objectAtIndex:ip.row];
                [newDict addEntriesFromDictionary:oldDict];
                
                [newDict setObject:@"" forKey:@"orders_act"];
                
                [[[orderSystemStatusArray objectAtIndex:1] firstObject] replaceObjectAtIndex:ip.row withObject:newDict];
            }
        }
        else
        {
            if (![[[[[orderSystemStatusArray objectAtIndex:1] firstObject] objectAtIndex:ip.row] objectForKey:@"orders_selected"] isEqualToString:@"Y"]) {
                
                for (int i =0; i<[[[orderSystemStatusArray objectAtIndex:1] firstObject] count]; i++) {
                    NSMutableDictionary *newDict = [[NSMutableDictionary alloc] init];
                    
                    NSDictionary *oldDict = (NSDictionary *)[[[orderSystemStatusArray objectAtIndex:1] firstObject] objectAtIndex:i];
                    
                    [newDict addEntriesFromDictionary:oldDict];
                    
                    [newDict setObject:@"" forKey:@"orders_act"];
                    
                    [[[orderSystemStatusArray objectAtIndex:1] firstObject] replaceObjectAtIndex:i withObject:newDict];
                }
                
                NSMutableDictionary *newDict = [[NSMutableDictionary alloc] init];
                
                NSDictionary *oldDict = (NSDictionary *)[[[orderSystemStatusArray objectAtIndex:1] firstObject] objectAtIndex:ip.row];
                [newDict addEntriesFromDictionary:oldDict];
                
                [newDict setObject:@"X" forKey:@"orders_act"];
                
                [[[orderSystemStatusArray objectAtIndex:1] firstObject] replaceObjectAtIndex:ip.row withObject:newDict];
            }
        }
        
        [orderSystemStatusTableView reloadData];
    }
    else if (orderSystemStatusTableView.tag == 2) {
        
        NSMutableDictionary *newDict = [[NSMutableDictionary alloc] init];
        NSDictionary *oldDict = (NSDictionary *)[[[orderSystemStatusArray objectAtIndex:2] firstObject] objectAtIndex:ip.row];
        [newDict addEntriesFromDictionary:oldDict];
        
        if([tappedButton.currentImage isEqual:[UIImage imageNamed:@"radiounselection.png"]]) {
            [sender  setImage:[UIImage imageNamed: @"radioselection.png"] forState:UIControlStateNormal];
            
            [newDict setObject:@"X" forKey:@"orders_act"];
        }
        else{
            [sender setImage:[UIImage imageNamed:@"radiounselection.png"]forState:UIControlStateNormal];
            
            [newDict setObject:@"" forKey:@"orders_act"];
        }
        
        [[[orderSystemStatusArray objectAtIndex:2] firstObject] replaceObjectAtIndex:ip.row withObject:newDict];
    }
}


-(void)operationcheckBoxClicked:(id)sender{
    
    NSIndexPath *ip = [self GetCellFromTableView:commonlistTableView Sender:sender];
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

-(void)componentCheckBoxClicked:(id)sender{
    
    NSIndexPath *ip = [self GetCellFromTableView:commonlistTableView Sender:sender];
    NSInteger i = ip.row;
    
    UIButton *tappedButton = (UIButton*)sender;
    
    if([tappedButton.currentImage isEqual:[UIImage imageNamed:@"radiounselection.png"]]) {
        [sender  setImage:[UIImage imageNamed: @"radioselection.png"] forState:UIControlStateNormal];
        [self.selectedPartsArray addObject:[NSNumber numberWithInteger:i]];
    }
    else{
        [self.selectedPartsArray removeObject:[NSNumber numberWithInteger:i]];
        
        [sender setImage:[UIImage imageNamed:@"radiounselection.png"]forState:UIControlStateNormal];
    }
}


#pragma mark- request Delegate

- (void)resultData:(NSDictionary *)resultData withErrorDescription:(NSString *)errorDescription requestID:(WebServiceRequest)requestID :(int)statusCode
{
    switch (requestID) {
 
        case GET_MATERIAL_AVAILABILITY_CHECK:
            
            if (statusCode == 401) {
                
                [MBProgressHUD hideHUDForView:self.view animated:YES];
 
                [self showAlertMessageWithTitle:@"Authentication Failed!!" message:(NSString *)@"kindly check your password" cancelButtonTitle:@"OK" withactionType:@"Single" forMethod:nil];
 
                 return;
            }
 
            if (!errorDescription.length) {
                
                 NSMutableDictionary *parsedDictionary = [[Response sharedInstance] parseForMaterialCheckAvailability:resultData];
 
                 if ([parsedDictionary objectForKey:@"Message"]) {
                    
                    if ([[[parsedDictionary objectForKey:@"Message"] substringToIndex:1] isEqualToString:@"S"]) {
                        
                        if (serachMaterialAvailabiltyFlag) {
 
                          [self showAlertMessageWithTitle:@"Information" message:(NSString *)[parsedDictionary objectForKey:@"Message"] cancelButtonTitle:@"OK" withactionType:@"Single" forMethod:nil];
                            
                        }
                         else{
                            
                          [self showAlertMessageWithTitle:@"Information" message:(NSString *)[parsedDictionary objectForKey:@"Message"] cancelButtonTitle:@"OK" withactionType:@"Single" forMethod:@"More Materials"];
                            
                         vornrComponentID =[NSString stringWithFormat:@"%04i",VornrComponent];
                            
                            if ([NullChecker isNull:componentTextField.text]) {
                                componentTextField.text = @"";
                                componentID=@"";
                            }
                            
                            if ([NullChecker isNull:quantityTextField.text]) {
                                quantityTextField.text = @"";
                            }
                        }
 
                    }
                    else if ([[[parsedDictionary objectForKey:@"Message"] substringToIndex:1] isEqualToString:@"E"]) {
                        
                        [self showAlertMessageWithTitle:@"Information" message:[[parsedDictionary objectForKey:@"Message"] substringFromIndex:1] cancelButtonTitle:@"OK" withactionType:@"Single" forMethod:nil];
                    }
                 }
                else if ([parsedDictionary objectForKey:@"ERROR"]){
 
                    [self showAlertMessageWithTitle:@"Information" message:(NSString *)[parsedDictionary objectForKey:@"ERROR"] cancelButtonTitle:@"OK" withactionType:@"Single" forMethod:nil];
                 }
            }
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
 
            break;
 
        case ORDER_CREATE:
            
            if (statusCode == 401) {
                
                [MBProgressHUD hideHUDForView:self.view animated:YES];
 
                [self showAlertMessageWithTitle:@"Authentication Failed!!" message:@"kindly check your password" cancelButtonTitle:@"Ok" withactionType:@"Single" forMethod:nil];
                
                
                return;
            }
            
            if (!errorDescription.length) {
                
                NSMutableDictionary *parsedDictionary = [[Response sharedInstance] parseForCreateOrder:resultData];
                
                if ([parsedDictionary objectForKey:@"OBJECTID"]) {
                    
                    [[DataBase sharedInstance] deleteOrderTransactions];
                    
                    NSString *objectId=[parsedDictionary objectForKey:@"OBJECTID"];
                    
                    if ([[parsedDictionary objectForKey:@"OBJECTID"] isKindOfClass:[NSArray class]]) {
                        
                        objectId=[[parsedDictionary objectForKey:@"OBJECTID"] objectAtIndex:0];

                    }
                    
                    if([[DataBase sharedInstance] updateOrderWithObjectid:objectId forHeaderID:[self.orderHeaderDetails objectForKey:@"ID"]])
                    {
                        [[DataBase sharedInstance] updateSyncLogForCategory:@"Order" action:@"Create" objectid:objectId UUID:[self.orderHeaderDetails objectForKey:@"ID"]];
                        
                        if ([[defaults objectForKey:@"ACTIVATELOGS"] isEqualToString:@"X"])
                        {
                            [[DataBase sharedInstance] writToLogFile:[NSString stringWithFormat:@"#INFO#.com.enstrapp.fieldtekpro#Order #Activity:Create Order #Orderno:%@ #Mode:Online #Class:Very Important #MUser:%@ #DeviceId:%@",[parsedDictionary objectForKey:@"OBJECTID"],decryptedUserName,[defaults objectForKey:@"edeviceid"]]];
                        }
                        
                     //   [self resetAllValues];
                        
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
                                    
                                    //                                    if ([headerDictionary objectForKey:@"Fields"]) {
                                    //                                        NSMutableArray *fieldsMutArray = [NSMutableArray new];
                                    //                                        NSArray *fieldsArray = [[headerDictionary objectForKey:@"Fields"] objectForKey:@"item"];
                                    //                                        for (int i =0; i<[fieldsArray count]; i++) {
                                    //                                            NSString *fieldValue,*fieldName,*fLabel,*tabName,*dataType,*sequence,*length;
                                    //                                            if ([NullChecker isNull:[[fieldsArray objectAtIndex:i] objectForKey:@"Fieldname"]]) {
                                    //                                                fieldName = @"";
                                    //                                            }
                                    //                                            else{
                                    //                                                fieldName = [[fieldsArray objectAtIndex:i] objectForKey:@"Fieldname"];
                                    //                                            }
                                    //
                                    //                                            if ([NullChecker isNull:[[fieldsArray objectAtIndex:i] objectForKey:@"Flabel"]]) {
                                    //                                                fLabel = @"";
                                    //                                            }
                                    //                                            else{
                                    //                                                fLabel = [[fieldsArray objectAtIndex:i] objectForKey:@"Flabel"];
                                    //                                            }
                                    //
                                    //                                            if ([NullChecker isNull:[[fieldsArray objectAtIndex:i] objectForKey:@"Tabname"]]) {
                                    //                                                tabName = @"";
                                    //                                            }
                                    //                                            else{
                                    //                                                tabName = [[fieldsArray objectAtIndex:i] objectForKey:@"Tabname"];
                                    //                                            }
                                    //
                                    //                                            if ([NullChecker isNull:[[fieldsArray objectAtIndex:i] objectForKey:@"Value"]]) {
                                    //                                                fieldValue = @"";
                                    //                                            }
                                    //                                            else{
                                    //                                                fieldValue = [[fieldsArray objectAtIndex:i] objectForKey:@"Value"];
                                    //                                            }
                                    //
                                    //                                            if ([NullChecker isNull:[[fieldsArray objectAtIndex:i] objectForKey:@"Datatype"]]) {
                                    //                                                dataType = @"";
                                    //                                            }
                                    //                                            else{
                                    //                                                dataType = [[fieldsArray objectAtIndex:i] objectForKey:@"Datatype"];
                                    //                                            }
                                    //
                                    //                                            if ([NullChecker isNull:[[fieldsArray objectAtIndex:i] objectForKey:@"Sequence"]]) {
                                    //                                                sequence = @"";
                                    //                                            }
                                    //                                            else{
                                    //                                                sequence = [[fieldsArray objectAtIndex:i] objectForKey:@"Sequence"];
                                    //                                            }
                                    //
                                    //                                            if ([NullChecker isNull:[[fieldsArray objectAtIndex:i] objectForKey:@"Length"]]) {
                                    //                                                length = @"";
                                    //                                            }
                                    //                                            else{
                                    //                                                length = [[fieldsArray objectAtIndex:i] objectForKey:@"Length"];
                                    //                                            }
                                    //
                                    //
                                    //                                            [fieldsMutArray addObject:[NSMutableArray arrayWithObjects:@"W",@"WH",tabName,fieldName,fieldValue,fLabel,dataType,sequence,length, nil]];
                                    //                                        }
                                    //
                                    //                                        [currentHeaderDictionary setObject:fieldsMutArray forKey:@"CFH"];
                                    //                                    }
                                    
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
                                
                                if ([NullChecker isNull:[tempDictionary objectForKey:@"ChkPointType"]]) {
                                    [orderDetailWCMStandardCheckPointsArray addObject:@""];
                                }
                                else{
                                    [orderDetailWCMStandardCheckPointsArray addObject:[tempDictionary objectForKey:@"ChkPointType"]];
                                }
                                
                                if ([NullChecker isNull:[tempDictionary objectForKey:@"Desctext"]]) {
                                    [orderDetailWCMStandardCheckPointsArray addObject:@""];
                                }
                                else{
                                    [orderDetailWCMStandardCheckPointsArray addObject:[tempDictionary objectForKey:@"Desctext"]];
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
                                    
                                    if ([NullChecker isNull:[tempDictionary objectForKey:@"Begru"]]) {
                                        [orderDetailWCMWorkApplicationListArray addObject:@""];//UserGroup id
                                    }
                                    else{
                                        [orderDetailWCMWorkApplicationListArray addObject:[tempDictionary objectForKey:@"Begru"]];
                                    }
                                    
                                    if ([NullChecker isNull:[tempDictionary objectForKey:@"Begtx"]]) {
                                        [orderDetailWCMWorkApplicationListArray addObject:@""];//UserGroup text
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
                                        [orderDetailWCMOperationWCDListArray addObject:@""];//UserGroup id
                                    }
                                    else{
                                        [orderDetailWCMOperationWCDListArray addObject:[tempDictionary objectForKey:@"Begru"]];
                                    }
                                    
                                    if ([NullChecker isNull:[tempDictionary objectForKey:@"Begtx"]]) {
                                        [orderDetailWCMOperationWCDListArray addObject:@""];//UserGroup text
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
                                        [orderDetailWCMWorkApprovalListArray addObject:@""];//UserGroup id
                                    }
                                    else{
                                        [orderDetailWCMWorkApprovalListArray addObject:[tempDictionary objectForKey:@"Begru"]];
                                    }
                                    
                                    if ([NullChecker isNull:[tempDictionary objectForKey:@"Begtx"]]) {
                                        [orderDetailWCMWorkApprovalListArray addObject:@""];//UserGroup text
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
                            
                              //  [self showAlertMessageWithTitle:@"Success" message:[NSString stringWithFormat:@"%@ Order is created successfully",[parsedDictionary objectForKey:@"OBJECTID"]] cancelButtonTitle:@"OK" withactionType:@"Single" forMethod:@"Create Order Sucess"];
                            
                            if ([[[parsedDictionary objectForKey:@"MESSAGE"] substringToIndex:1] isEqualToString:@"S"]) {
                                
                                [self showAlertMessageWithTitle:@"Success" message:[[parsedDictionary objectForKey:@"MESSAGE"] substringFromIndex:1] cancelButtonTitle:@"Ok" withactionType:@"Single" forMethod:@"Create Order Sucess"];
                                
                            }
                            else{
                                
                                [self showAlertMessageWithTitle:@"Error" message:[[parsedDictionary objectForKey:@"MESSAGE"] substringFromIndex:1] cancelButtonTitle:@"Ok" withactionType:@"Single" forMethod:@"Create Order Sucess"];
                            }
                            
                          }
                    }
                }
                else if ([parsedDictionary objectForKey:@"ERROR"] || [parsedDictionary objectForKey:@"Message"]){
                    
                    //
                    //                    [[DataBase sharedInstance] updateSyncLogErrorForCategory:@"Order" action:@"Create" objectid:@"" UUID:[self.orderHeaderDetails objectForKey:@"ID"] message:[[parsedDictionary objectForKey:@"Message"] substringFromIndex:1]];
                    
                    [[DataBase sharedInstance] updateSyncLogErrorForCategory:@"Order" action:@"Create" objectid:@"" UUID:[self.orderHeaderDetails objectForKey:@"ID"] message:[[parsedDictionary objectForKey:@"Message"] substringFromIndex:1] Date:[self.orderHeaderDetails objectForKey:@"DATE"] timestamp:[self.orderHeaderDetails objectForKey:@"TIME"]];
                    
                    
                    //                    for (int i=0; i<[self.operationDetailsArray count];  i++)
                    //                    {
                    //                        NSMutableDictionary *addOperationsDictionary = [NSMutableDictionary new];
                    //
                    //                        [addOperationsDictionary setObject:[orderUDID copy] forKey:@"ID"];
                    //                        [addOperationsDictionary setObject:[[[self.self.operationDetailsArray objectAtIndex:i] firstObject] objectAtIndex:1] forKey:@"OPERATIONKEY"];
                    //                        [addOperationsDictionary setObject:[[[self.operationDetailsArray objectAtIndex:i] firstObject] objectAtIndex:2] forKey:@"OPERATIONTEXT"];
                    //                        [addOperationsDictionary setObject:[[[self.operationDetailsArray objectAtIndex:i] firstObject] objectAtIndex:31] forKey:@"OPERATIONLONGTEXT"];
                    //
                    //                        [addOperationsDictionary setObject:[[[self.operationDetailsArray objectAtIndex:i] firstObject] objectAtIndex:3] forKey:@"DURATIONTEXTINPUT"];
                    //                        [addOperationsDictionary setObject:[[[self.operationDetailsArray objectAtIndex:i] firstObject] objectAtIndex:4] forKey:@"DURATIONTEXT"];
                    //
                    //                        [addOperationsDictionary setObject:@"" forKey:@"COMPONENTID"];
                    //                        [addOperationsDictionary setObject:@"" forKey:@"COMPONENTTEXT"];
                    //                        [addOperationsDictionary setObject:@"" forKey:@"QUANTITYTEXT"];
                    //
                    //                        [addOperationsDictionary setObject:@"" forKey:@"COMPONENTPLANTID"];
                    //                        [addOperationsDictionary setObject:@"" forKey:@"COMPONENTSTORAGELOCATIONID"];
                    //
                    //                        [addOperationsDictionary setObject:@"" forKey:@"COMPONENTKEY"];
                    //
                    //                        [addOperationsDictionary setObject:[[[self.operationDetailsArray objectAtIndex:i] firstObject] objectAtIndex:37] forKey:@"OPERATIONPLANTID"];
                    //                        [addOperationsDictionary setObject:[[[self.operationDetailsArray objectAtIndex:i] firstObject] objectAtIndex:38] forKey:@"OPERATIONPLANTTEXT"];
                    //                        [addOperationsDictionary setObject:[[[self.operationDetailsArray objectAtIndex:i] firstObject] objectAtIndex:39] forKey:@"OPERATIONWORKCENTERID"];
                    //                        [addOperationsDictionary setObject:[[[self.operationDetailsArray objectAtIndex:i] firstObject] objectAtIndex:40] forKey:@"OPERATIONWORKCENTERTEXT"];
                    //
                    //                        [addOperationsDictionary setObject:[[[self.operationDetailsArray objectAtIndex:i] firstObject] objectAtIndex:30] forKey:@"CONTROLKEYID"];
                    //                        [addOperationsDictionary setObject:[[[self.operationDetailsArray objectAtIndex:i] firstObject] objectAtIndex:41] forKey:@"CONTROLKEYTEXT"];
                    //
                    //                        [addOperationsDictionary setObject:[NSArray arrayWithObjects:[defaults objectForKey:@"tempCustomOperation"],[defaults objectForKey:@"tempCustomComponent"], nil]  forKey:@"CUSTOM"];
                    //
                    //                        [[DataBase sharedInstance] insertOrderTranscationDetails:addOperationsDictionary];
                    //
                    //                    }
                    
                    
                    if ([parsedDictionary objectForKey:@"Message"])
                    {
                      
                        [self showAlertMessageWithTitle:@"Order is not Created" message:[[parsedDictionary objectForKey:@"Message"] substringFromIndex:1] cancelButtonTitle:@"OK" withactionType:@"Single" forMethod:nil];
                    }
                    else{
                     
                         [self showAlertMessageWithTitle:@"Order is not Created" message:[parsedDictionary objectForKey:@"ERROR"] cancelButtonTitle:@"OK" withactionType:@"Single" forMethod:nil];
                    }
                    }
                
                   [MBProgressHUD hideHUDForView:self.view animated:YES];

                  }
                else
                {
                    [[DataBase sharedInstance] updateSyncLogErrorForCategory:@"Order" action:@"Create" objectid:@"" UUID:[self.orderHeaderDetails objectForKey:@"ID"] message:NSLocalizedString(@"ErrorMessage", nil) Date:[self.orderHeaderDetails objectForKey:@"DATE"] timestamp:[self.orderHeaderDetails objectForKey:@"TIME"]];
 
                    
                    [self showAlertMessageWithTitle:@"Information" message:[NSString stringWithFormat:NSLocalizedString(@"ErrorMessage", nil)] cancelButtonTitle:@"OK" withactionType:@"Single" forMethod:nil];
                    
                    [MBProgressHUD hideHUDForView:self.view animated:YES];

                 }
            
        case ORDER_CHANGE:
            
            if (statusCode == 401) {
                
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                
                [self showAlertMessageWithTitle:@"Authentication Failed!!" message:@"kindly check your password" cancelButtonTitle:@"Ok" withactionType:@"Single" forMethod:nil];
 
                return;
            }
            
            if (!errorDescription.length) {
                
                NSMutableDictionary *parsedDictionary = [[Response sharedInstance] parseForChangeOrder:resultData];
                
                if ([parsedDictionary objectForKey:@"Message"]) {
                    
                    [[DataBase sharedInstance] deleteOrderTransactions];
                    
                    // NSArray *messageArray = [[parsedDictionary objectForKey:@"Message"] componentsSeparatedByString:@" "];
                    
                    if ([[[parsedDictionary objectForKey:@"Message"] substringToIndex:1] isEqualToString:@"S"]) {
                        
                        [[DataBase sharedInstance] updateForChangeOrder:[self.orderHeaderDetails objectForKey:@"ID"]];
                        
                        [[DataBase sharedInstance] updateSyncLogForCategory:@"Order" action:@"Change" objectid:[parsedDictionary objectForKey:@"OBJECTID"] UUID:[self.orderHeaderDetails objectForKey:@"ID"]];
                        
                        if ([[defaults objectForKey:@"ACTIVATELOGS"] isEqualToString:@"X"])
                        {
                            [[DataBase sharedInstance] writToLogFile:[NSString stringWithFormat:@"#INFO#.com.enstrapp.fieldtekpro#Order #Activity:Change Order #Orderno:%@ #Mode:Online #Class:Very Important #MUser:%@ #DeviceId:%@",[parsedDictionary objectForKey:@"OBJECTID"],decryptedUserName,[defaults objectForKey:@"edeviceid"]]];
                            
                        }
                        
                        //   [self resetAllValues];
                        
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
                                    
                                    //                                    if ([headerDictionary objectForKey:@"Fields"]) {
                                    //                                        NSMutableArray *fieldsMutArray = [NSMutableArray new];
                                    //                                        NSArray *fieldsArray = [[headerDictionary objectForKey:@"Fields"] objectForKey:@"item"];
                                    //                                        for (int i =0; i<[fieldsArray count]; i++) {
                                    //                                            NSString *fieldValue,*fieldName,*fLabel,*tabName,*dataType,*sequence,*length;
                                    //                                            if ([NullChecker isNull:[[fieldsArray objectAtIndex:i] objectForKey:@"Fieldname"]]) {
                                    //                                                fieldName = @"";
                                    //                                            }
                                    //                                            else{
                                    //                                                fieldName = [[fieldsArray objectAtIndex:i] objectForKey:@"Fieldname"];
                                    //                                            }
                                    //
                                    //                                            if ([NullChecker isNull:[[fieldsArray objectAtIndex:i] objectForKey:@"Flabel"]]) {
                                    //                                                fLabel = @"";
                                    //                                            }
                                    //                                            else{
                                    //                                                fLabel = [[fieldsArray objectAtIndex:i] objectForKey:@"Flabel"];
                                    //                                            }
                                    //
                                    //                                            if ([NullChecker isNull:[[fieldsArray objectAtIndex:i] objectForKey:@"Tabname"]]) {
                                    //                                                tabName = @"";
                                    //                                            }
                                    //                                            else{
                                    //                                                tabName = [[fieldsArray objectAtIndex:i] objectForKey:@"Tabname"];
                                    //                                            }
                                    //
                                    //                                            if ([NullChecker isNull:[[fieldsArray objectAtIndex:i] objectForKey:@"Value"]]) {
                                    //                                                fieldValue = @"";
                                    //                                            }
                                    //                                            else{
                                    //                                                fieldValue = [[fieldsArray objectAtIndex:i] objectForKey:@"Value"];
                                    //                                            }
                                    //
                                    //                                            if ([NullChecker isNull:[[fieldsArray objectAtIndex:i] objectForKey:@"Datatype"]]) {
                                    //                                                dataType = @"";
                                    //                                            }
                                    //                                            else{
                                    //                                                dataType = [[fieldsArray objectAtIndex:i] objectForKey:@"Datatype"];
                                    //                                            }
                                    //
                                    //                                            if ([NullChecker isNull:[[fieldsArray objectAtIndex:i] objectForKey:@"Sequence"]]) {
                                    //                                                sequence = @"";
                                    //                                            }
                                    //                                            else{
                                    //                                                sequence = [[fieldsArray objectAtIndex:i] objectForKey:@"Sequence"];
                                    //                                            }
                                    //
                                    //                                            if ([NullChecker isNull:[[fieldsArray objectAtIndex:i] objectForKey:@"Length"]]) {
                                    //                                                length = @"";
                                    //                                            }
                                    //                                            else{
                                    //                                                length = [[fieldsArray objectAtIndex:i] objectForKey:@"Length"];
                                    //                                            }
                                    //
                                    //
                                    //                                            [fieldsMutArray addObject:[NSMutableArray arrayWithObjects:@"W",@"WH",tabName,fieldName,fieldValue,fLabel,dataType,sequence,length, nil]];
                                    //                                        }
                                    //
                                    //                                        [currentHeaderDictionary setObject:fieldsMutArray forKey:@"CFH"];
                                    //                                    }
                                    
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
                                
                                if ([NullChecker isNull:[tempDictionary objectForKey:@"ChkPointType"]]) {
                                    [orderDetailWCMStandardCheckPointsArray addObject:@""];
                                }
                                else{
                                    [orderDetailWCMStandardCheckPointsArray addObject:[tempDictionary objectForKey:@"ChkPointType"]];
                                }
                                
                                if ([NullChecker isNull:[tempDictionary objectForKey:@"Desctext"]]) {
                                    [orderDetailWCMStandardCheckPointsArray addObject:@""];
                                }
                                else{
                                    [orderDetailWCMStandardCheckPointsArray addObject:[tempDictionary objectForKey:@"Desctext"]];
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
                                    
                                    if ([NullChecker isNull:[tempDictionary objectForKey:@"Begru"]]) {
                                        [orderDetailWCMWorkApplicationListArray addObject:@""];//UserGroup id
                                    }
                                    else{
                                        [orderDetailWCMWorkApplicationListArray addObject:[tempDictionary objectForKey:@"Begru"]];
                                    }
                                    
                                    if ([NullChecker isNull:[tempDictionary objectForKey:@"Begtx"]]) {
                                        [orderDetailWCMWorkApplicationListArray addObject:@""];//UserGroup text
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
                                        [orderDetailWCMOperationWCDListArray addObject:@""];//UserGroup id
                                    }
                                    else{
                                        [orderDetailWCMOperationWCDListArray addObject:[tempDictionary objectForKey:@"Begru"]];
                                    }
                                    
                                    if ([NullChecker isNull:[tempDictionary objectForKey:@"Begtx"]]) {
                                        [orderDetailWCMOperationWCDListArray addObject:@""];//UserGroup text
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
                                        [orderDetailWCMWorkApprovalListArray addObject:@""];//UserGroup id
                                    }
                                    else{
                                        [orderDetailWCMWorkApprovalListArray addObject:[tempDictionary objectForKey:@"Begru"]];
                                    }
                                    
                                    if ([NullChecker isNull:[tempDictionary objectForKey:@"Begtx"]]) {
                                        [orderDetailWCMWorkApprovalListArray addObject:@""];//UserGroup text
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
                            
                            //  [self showAlertMessageWithTitle:@"Success" message:[NSString stringWithFormat:@"%@ Order is created successfully",[parsedDictionary objectForKey:@"OBJECTID"]] cancelButtonTitle:@"OK" withactionType:@"Single" forMethod:@"Create Order Sucess"];
                            
                            if ([[[parsedDictionary objectForKey:@"Message"] substringToIndex:1] isEqualToString:@"S"]) {
                                
                                [self showAlertMessageWithTitle:@"Success" message:[[parsedDictionary objectForKey:@"Message"] substringFromIndex:1] cancelButtonTitle:@"Ok" withactionType:@"Single" forMethod:@"Create Order Sucess"];
                                
                            }
                            else{
                                
                                [self showAlertMessageWithTitle:@"Error" message:[[parsedDictionary objectForKey:@"MESSAGE"] substringFromIndex:1] cancelButtonTitle:@"Ok" withactionType:@"Single" forMethod:@"Create Order Sucess"];
                            }
                            
                        }
                    }
                }
                else if ([parsedDictionary objectForKey:@"ERROR"] || [parsedDictionary objectForKey:@"Message"]){
                    
                    //
                    //                    [[DataBase sharedInstance] updateSyncLogErrorForCategory:@"Order" action:@"Create" objectid:@"" UUID:[self.orderHeaderDetails objectForKey:@"ID"] message:[[parsedDictionary objectForKey:@"Message"] substringFromIndex:1]];
                    
                    [[DataBase sharedInstance] updateSyncLogErrorForCategory:@"Order" action:@"Create" objectid:@"" UUID:[self.orderHeaderDetails objectForKey:@"ID"] message:[[parsedDictionary objectForKey:@"Message"] substringFromIndex:1] Date:[self.orderHeaderDetails objectForKey:@"DATE"] timestamp:[self.orderHeaderDetails objectForKey:@"TIME"]];
                    
                    
                    //                    for (int i=0; i<[self.operationDetailsArray count];  i++)
                    //                    {
                    //                        NSMutableDictionary *addOperationsDictionary = [NSMutableDictionary new];
                    //
                    //                        [addOperationsDictionary setObject:[orderUDID copy] forKey:@"ID"];
                    //                        [addOperationsDictionary setObject:[[[self.self.operationDetailsArray objectAtIndex:i] firstObject] objectAtIndex:1] forKey:@"OPERATIONKEY"];
                    //                        [addOperationsDictionary setObject:[[[self.operationDetailsArray objectAtIndex:i] firstObject] objectAtIndex:2] forKey:@"OPERATIONTEXT"];
                    //                        [addOperationsDictionary setObject:[[[self.operationDetailsArray objectAtIndex:i] firstObject] objectAtIndex:31] forKey:@"OPERATIONLONGTEXT"];
                    //
                    //                        [addOperationsDictionary setObject:[[[self.operationDetailsArray objectAtIndex:i] firstObject] objectAtIndex:3] forKey:@"DURATIONTEXTINPUT"];
                    //                        [addOperationsDictionary setObject:[[[self.operationDetailsArray objectAtIndex:i] firstObject] objectAtIndex:4] forKey:@"DURATIONTEXT"];
                    //
                    //                        [addOperationsDictionary setObject:@"" forKey:@"COMPONENTID"];
                    //                        [addOperationsDictionary setObject:@"" forKey:@"COMPONENTTEXT"];
                    //                        [addOperationsDictionary setObject:@"" forKey:@"QUANTITYTEXT"];
                    //
                    //                        [addOperationsDictionary setObject:@"" forKey:@"COMPONENTPLANTID"];
                    //                        [addOperationsDictionary setObject:@"" forKey:@"COMPONENTSTORAGELOCATIONID"];
                    //
                    //                        [addOperationsDictionary setObject:@"" forKey:@"COMPONENTKEY"];
                    //
                    //                        [addOperationsDictionary setObject:[[[self.operationDetailsArray objectAtIndex:i] firstObject] objectAtIndex:37] forKey:@"OPERATIONPLANTID"];
                    //                        [addOperationsDictionary setObject:[[[self.operationDetailsArray objectAtIndex:i] firstObject] objectAtIndex:38] forKey:@"OPERATIONPLANTTEXT"];
                    //                        [addOperationsDictionary setObject:[[[self.operationDetailsArray objectAtIndex:i] firstObject] objectAtIndex:39] forKey:@"OPERATIONWORKCENTERID"];
                    //                        [addOperationsDictionary setObject:[[[self.operationDetailsArray objectAtIndex:i] firstObject] objectAtIndex:40] forKey:@"OPERATIONWORKCENTERTEXT"];
                    //
                    //                        [addOperationsDictionary setObject:[[[self.operationDetailsArray objectAtIndex:i] firstObject] objectAtIndex:30] forKey:@"CONTROLKEYID"];
                    //                        [addOperationsDictionary setObject:[[[self.operationDetailsArray objectAtIndex:i] firstObject] objectAtIndex:41] forKey:@"CONTROLKEYTEXT"];
                    //
                    //                        [addOperationsDictionary setObject:[NSArray arrayWithObjects:[defaults objectForKey:@"tempCustomOperation"],[defaults objectForKey:@"tempCustomComponent"], nil]  forKey:@"CUSTOM"];
                    //
                    //                        [[DataBase sharedInstance] insertOrderTranscationDetails:addOperationsDictionary];
                    //
                    //                    }
                    
                    
                    if ([parsedDictionary objectForKey:@"Message"])
                    {
                        
                        [self showAlertMessageWithTitle:@"Order is not Created" message:[[parsedDictionary objectForKey:@"Message"] substringFromIndex:1] cancelButtonTitle:@"OK" withactionType:@"Single" forMethod:nil];
                    }
                    else{
                        
                        [self showAlertMessageWithTitle:@"Order is not Created" message:[parsedDictionary objectForKey:@"ERROR"] cancelButtonTitle:@"OK" withactionType:@"Single" forMethod:nil];
                    }
                }
                
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                
            }
            else
            {
                [[DataBase sharedInstance] updateSyncLogErrorForCategory:@"Order" action:@"Create" objectid:@"" UUID:[self.orderHeaderDetails objectForKey:@"ID"] message:NSLocalizedString(@"ErrorMessage", nil) Date:[self.orderHeaderDetails objectForKey:@"DATE"] timestamp:[self.orderHeaderDetails objectForKey:@"TIME"]];
                
                
                [self showAlertMessageWithTitle:@"Information" message:[NSString stringWithFormat:NSLocalizedString(@"ErrorMessage", nil)] cancelButtonTitle:@"OK" withactionType:@"Single" forMethod:nil];
                
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                
            }
            
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
