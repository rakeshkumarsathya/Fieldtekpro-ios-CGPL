//
//  PermitViewController.m
//  Fieldtekpro
//
//  Created by Sathya Rakesh Kumar on 23/05/18.
//  Copyright © 2018 Enstrapp Bangalore. All rights reserved.
//

#import "PermitViewController.h"

@interface PermitViewController ()<UITableViewDataSource,UITableViewDelegate,UIPopoverPresentationControllerDelegate>
@property (weak, nonatomic) IBOutlet UINavigationBar *barButton;

@end

@implementation PermitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
 
    self.dropDownArray=[NSMutableArray new];
    
    self.workApplicationDetailsArray=[NSMutableArray new];
    self.workApprovalDetailsArray=[NSMutableArray new];
    
    NSString *str_UserNameDep = [[NSUserDefaults standardUserDefaults] objectForKey:@"userName"];
     decryptedUserName = [str_UserNameDep AES128DecryptWithKey:@""];
    
    
    taggingTextView.layer.cornerRadius = 8.0f;
    taggingTextView.layer.masksToBounds = YES;
    taggingTextView.layer.borderColor = [[UIColor darkGrayColor] CGColor];
    taggingTextView.layer.borderWidth = 1.0f;
    
    untaggingTextView.layer.cornerRadius = 8.0f;
    untaggingTextView.layer.masksToBounds = YES;
    untaggingTextView.layer.borderColor = [[UIColor darkGrayColor] CGColor];
    untaggingTextView.layer.borderWidth = 1.0f;
    
    self.view.backgroundColor = [UIColor whiteColor];
 
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tableDidSelected:) name:@"click" object:nil];
 
     [checkPointTableView registerNib:[UINib nibWithNibName:@"StandardCheckPointTableViewCell_Iphone5" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"Cell"];

    [operationWCDTableView registerNib:[UINib nibWithNibName:@"OperationWCDTableViewCell_Iphone6" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"Cell"];
    
    [taggingConditionsTableView registerNib:[UINib nibWithNibName:@"TaggingConditionTableViewCell_Iphone5" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"Cell"];
    
    [opWCDListTableView registerNib:[UINib nibWithNibName:@"OpWCDListTableViewCell_Iphone5" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"Cell"];
    
    self.workApprovalDetailsArray=[[NSMutableArray alloc] initWithCapacity:1];
    self.operationWCDSubmittedDetailsArray=[NSMutableArray new];
    self.selectedWorkApprovalArray=[NSMutableArray new];
    self.selectedApplicationCheckBoxesArray=[NSMutableArray new];
    self.applicationHeaderDetailsArray=[NSMutableArray new];
    self.selectedOperationWCDCheckBoxArray=[NSMutableArray new];
    self.selectedOpWCDDetailsArray=[NSMutableArray new];
    self.finalCheckPointsArray=[NSMutableArray new];
    self.permitsOperationWCD = [NSMutableArray new];
    self.workApplicationDetailsArray=[NSMutableArray new];
    self.opWCDListDetailsArray =[NSMutableArray new];
    self.addedOperationsWcdArray = [NSMutableArray new];
    
   // [approvalsTableView registerNib:[UINib nibWithNibName:@"IssueApprovalTableViewCell_iPhone5" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"Cell"];
    
    [self uiPickerTableViewForDropDownSelection];
    
     [self loadApplicationTypeview];
   
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
                                        if ([methodNameString isEqualToString:@"Tagged Conditions"])
                                        {
                                             btgString=@"X";
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
                                       
                                     
                                       
                                       
                                   }];
        
        [alert addAction:okButton];
        
        [self presentViewController:alert animated:YES completion:nil];
        
    }
}


- (IBAction)backButtonClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)dismissCheckpointClicked:(id)sender{
    
    [checkPointView removeFromSuperview];
    
}

-(IBAction)dismissIsolationList:(id)sender{
    
    [isolationsListView removeFromSuperview];
    
}

-(IBAction)menuButtonClicked:(id)sender{
    
    if ([NullChecker isNull:wcmUsageTextField.text]) {
        
        [self showAlertMessageWithTitle:@"Alert" message:@"Please Select Usage" cancelButtonTitle:@"OK" withactionType:@"Single" forMethod:nil];
    }
    
    else{
        
        self.buttonPopVC = [[PopoverViewController alloc] init];
        self.buttonPopVC.modalPresentationStyle = UIModalPresentationPopover;
        self.buttonPopVC.popoverPresentationController.sourceView = menuButton;  //rect参数是以view的左上角为坐标原点（0，0）
        self.buttonPopVC.popoverPresentationController.sourceRect = menuButton.bounds; //指定箭头所指区域的矩形框范围（位置和尺寸），以view的左上角为坐标原点
        self.buttonPopVC.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionUp; //箭头方向
        self.buttonPopVC.popoverPresentationController.delegate = self;
        [self presentViewController:self.buttonPopVC animated:YES completion:nil];
        
        popUpEnabled=YES;
    }
 
  }


//处理popover上的talbe的cell点击
- (void)tableDidSelected:(NSNotification *)notification {
    NSIndexPath *indexpath = (NSIndexPath *)notification.object;
    switch (indexpath.row) {
        case 0:

            isolationShortTextField.text=wcmShortTextField.text;
            isolationFromDateTextfield.text=wcmFromDateTextfield.text;
            isolationToDateTextfield.text=wcmToDateTextfield.text;
            isolationFromTimeTextfield.text=wcmFromTimeTextfield.text;
            isolationToTimeTextfield.text=wcmFromTimeTextfield.text;
            isolationFunctionLocationTextfield.text=wcmFunctionLocationTextfield.text;
            isolationPriorityId=wcmPriorityId;
            isolationPriorityTextfield.text=wcmPriorityTextfield.text;
            
            [isolationsListView setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
            [isolationHeaderView setFrame:CGRectMake(0, 0, subView.frame.size.width, subView.frame.size.height)];
             isolationScrollView.contentInset=UIEdgeInsetsMake(0.0,0.0,350,0.0);
             [workApprovalHeaderView addSubview:isolationsListView];
            
            [subView addSubview:isolationHeaderView];
            
            break;
        case 1:
 
            [self navigateJSAViewcontroller];
            
            break;
      
    }
    if (self.buttonPopVC) {
        [self.buttonPopVC dismissViewControllerAnimated:YES completion:nil];    //我暂时使用这个方法让popover消失，但我觉得应该有更好的方法，因为这个方法并不会调用popover消失的时候会执行的回调。
        self.buttonPopVC = nil;
        
    }else{
        [self.itemPopVC dismissViewControllerAnimated:YES completion:nil];
        self.itemPopVC = nil;
    }
}


- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller{
    return UIModalPresentationNone;
}

- (BOOL)popoverPresentationControllerShouldDismissPopover:(UIPopoverPresentationController *)popoverPresentationController{
    
     popUpEnabled=NO;

    
    return YES;   //点击蒙版popover不消失， 默认yes
}

-(void)navigateJSAViewcontroller{
    
    JSAViewController *createVc = [self.storyboard instantiateViewControllerWithIdentifier:@"JSAVc"];
    
    [self showViewController:createVc sender:self];
    
}

- (IBAction)dismissWorkApprovalClicked:(id)sender{
    
    [workApprovalHeaderView removeFromSuperview];
    
}

#pragma marks-TextView Delegate Methods

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    textView.textColor = [UIColor blackColor];
 
      if (textView == taggingTextView)
    {
        tag=109;
        
    }
    else if (textView == untaggingTextView)
    {
        tag=110;
        
    }
    
   //  [self numberpad];
    
    return YES;
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
    else if (textField == isolationPriorityTextfield)
    {
        
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
            
            [self showAlertMessageWithTitle:@"Information" message:@"Please select 'Type' field" cancelButtonTitle:@"Ok" withactionType:@"Single" forMethod:nil];
            
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
                
                [self.dropDownArray addObjectsFromArray:[[DataBase sharedInstance] getWCMUsageswithPlantText:self.iwerkString forObject:@"WW"]];
            }
            else{
                
                [self.dropDownArray addObjectsFromArray:[[DataBase sharedInstance] getWCMUsageswithPlantText:self.iwerkString forObject:@"WA"]];
            }
          
            [self.dropDownTableView reloadData];
     }
    
    else if (textField == isolationUsageTextfield) {
        
        isolationUsageTextfield.inputView = self.dropDownTableView;
        isolationUsageTextfield.inputAccessoryView = self.mypickerToolbar;
        
        self.dropDownTableView.tag = ORDER_ISOLATION_USAGE;
        
        if ([isolationHeaderLabel.text isEqualToString:@"Operation WCD"])
        {
             [self.dropDownArray addObjectsFromArray:[[DataBase sharedInstance] getWCMUsageswithPlantText:self.iwerkString forObject:@"WD"]];
        }
        else{
            
            [self.dropDownArray addObjectsFromArray:[[DataBase sharedInstance] getWCMUsageswithPlantText:self.iwerkString forObject:@"WA"]];
        }
        
        [self.dropDownTableView reloadData];
     }
 
    return YES;
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
    
    [wcmUsageTextField resignFirstResponder];
    [wcmUsergrouptextField resignFirstResponder];
    
    [isolationUsageTextfield resignFirstResponder];
    [isolationUsergroupTexField resignFirstResponder];

    [wcmPriorityTextfield resignFirstResponder];
    [isolationPriorityTextfield resignFirstResponder];
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


-(void)loadApplicationTypeview{
    
    if (self.applicationTypesArray==nil)
    {
        self.applicationTypesArray=[NSMutableArray new];
        
    }
    else
    {
        [self.applicationTypesArray removeAllObjects];
    }
    
    res_obj=[Response sharedInstance];
 
    [self.applicationTypesArray addObjectsFromArray:[[DataBase sharedInstance] fetchWCMTypesforPlantID:self.iwerkString]];
    
    [applicationTypeView setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    
    [self.view addSubview:applicationTypeView];
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
        
        [self.hazardsControlSCheckpointsArray addObjectsFromArray:[[DataBase sharedInstance] fetchWCMRequestsforCreateApplicationType:self.iwerkString forUsage:wcmUsageID]];
 
//        if (createOrderFlag) {
//
//            [self.hazardsControlSCheckpointsArray addObjectsFromArray:[[DataBase sharedInstance] fetchWCMRequestsforCreateApplicationType:iwerkString forUsage:wcmUsageID]];
//        }
//
//        else{
//
//            [self.hazardsControlSCheckpointsArray addObjectsFromArray:[[DataBase sharedInstance] fetchWCMRequestsforCreateApplicationType:iwerkString forUsage:wcmUsageID]];
//        }
     }
    else{
        
        [self.hazardsControlSCheckpointsArray addObjectsFromArray:[NSMutableArray arrayWithObjects:[[self.workApplicationDetailsArray objectAtIndex:waSelectedIndex] objectAtIndex:1],[[self.workApplicationDetailsArray objectAtIndex:waSelectedIndex] objectAtIndex:2], nil]];
    }
    
    checkPointTableView.tag=0;
    [checkPointTableView reloadData];
    [checkPointView setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    
    [self.view  addSubview:checkPointView];
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
        
         [self showAlertMessageWithTitle:@"Information" message:@"Please select atleast one 'Work'" cancelButtonTitle:@"Ok" withactionType:@"Single" forMethod:nil];
        
    }
    else if (![controlFlag isEqualToString:@"X"]) {
        
         [self showAlertMessageWithTitle:@"Information" message:@"Please select atleast one 'Requirement'" cancelButtonTitle:@"Ok" withactionType:@"Single" forMethod:nil];

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
 
    [tempArray addObject:self.iwerkString];

    
    // [tempArray addObject:[[self.applicationTypesArray objectAtIndex:applicationSelectedIndex] objectAtIndex:4]];//objtype
    
    if (res_obj.applicationTypeString.length) {
        
        [tempArray addObject:res_obj.applicationTypeString];//objtype
        
    }
    else{
        
        [tempArray addObject:@""];//objtype
    }
    
    
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
    
    [tempArray addObject:@"0"];//rctime
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

- (IBAction)setPreparedClicked:(id)sender{
    
    if (addWorkApprovalFlag) {
        
        if (![self.applicationDetailsArray count])
        {
 
            [self showAlertMessageWithTitle:@"Information" message:@"Please Select 'Set Prepared' status at Application Level" cancelButtonTitle:@"Ok" withactionType:@"Single" forMethod:nil];
            
        }
        else if (applicationSetPreparedFlag && setPreparedIsolationFlag){
            
            if (!setPreparedFlag) {
                
                 [self showAlertMessageWithTitle:@"Information" message:@"Please Select 'Set Prepared' status at Application Level" cancelButtonTitle:@"Ok" withactionType:@"Single" forMethod:nil];
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


- (IBAction)addSelectedApprovalsClicked:(id)sender{
    
   // [workApprovalHeaderView removeFromSuperview];
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
        
 
    }
    
    else
    {
        
        NSMutableArray *tempArray=[NSMutableArray new];
        
        [tempArray addObject:@""];//headerID
        [tempArray addObject:@"WA"];
        
        if (!changeWorkApprovalFlag) {
            
            [tempArray addObject:[NSString stringWithFormat:@"WA%@",vornrApplicationString]];//applicationID
 
            [tempArray addObject:self.iwerkString];
 
            if (res_obj.applicationTypeString.length) {
                
                [tempArray addObject:res_obj.applicationTypeString];//objtype
            }
            else{
                
                [tempArray addObject:@""];//objtype
            }
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
        [dateFormatter setDateFormat:@"yyyyMMdd"];
        
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
        
        [tempArray addObject:@"0"];//rctime
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
            
            [self showAlertMessageWithTitle:@"Information" message:@"Please select Work Requirements " cancelButtonTitle:@"Ok" withactionType:@"Single" forMethod:nil];
            
            [self.view addSubview:workApprovalHeaderView];
            
        }
        
        else  if (![hazardFlag isEqualToString:@"X"]) {
            
            [self showAlertMessageWithTitle:@"Information" message:@"Please select atleast one 'Work'" cancelButtonTitle:@"Ok" withactionType:@"Single" forMethod:nil];
            
            [self.view addSubview:workApprovalHeaderView];
            
        }
        else if (![controlFlag isEqualToString:@"X"]) {
            
            [self showAlertMessageWithTitle:@"Information" message:@"Please select atleast one 'Requirement'" cancelButtonTitle:@"Ok" withactionType:@"Single" forMethod:nil];
            
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
                [tempApplicationDetailsarray addObject:[NSString stringWithFormat:@"%@%@",[res_obj.applicationTypesArray objectAtIndex:2],vornrApplicationString]];
                [tempApplicationDetailsarray addObject:[self.applicationTypesArray  objectAtIndex:4]];
                [tempApplicationDetailsarray addObject:[self.applicationTypesArray  objectAtIndex:3]];
                [tempApplicationDetailsarray addObject:@""];
                [self.applicationDetailsArray addObject:tempApplicationDetailsarray];
                //  [self.applicationHeaderDetailsArray addObject:tempArray];
                [[self.workApplicationDetailsArray objectAtIndex:checkPointSelectedIndex] replaceObjectAtIndex:0 withObject:tempArray];
            }
            else{
                
                NSMutableArray *tempApplicationDetailsarray=[NSMutableArray new];
                [tempApplicationDetailsarray addObject:@""];
                
                if (res_obj.applicationObjArt.length) {
                    
                    [tempApplicationDetailsarray addObject:applicationObjArt];
                }
                else{
                    
                    [tempApplicationDetailsarray addObject:[NSString stringWithFormat:@"%@%@",[[self.applicationTypesArray objectAtIndex:0] objectAtIndex:2],vornrApplicationString]];
                    
                }
                [tempApplicationDetailsarray addObject:[[[self.workApplicationDetailsArray objectAtIndex:waSelectedIndex] firstObject] objectAtIndex:4]];
                [tempApplicationDetailsarray addObject:[[[self.workApplicationDetailsArray objectAtIndex:waSelectedIndex] firstObject] objectAtIndex:3]];
                [tempApplicationDetailsarray addObject:@""];
                
                [self.applicationDetailsArray addObject:tempApplicationDetailsarray];
                [self.applicationHeaderDetailsArray addObject:tempArray];
                
                [[self.workApplicationDetailsArray objectAtIndex:workApplicationSelectedIndex] replaceObjectAtIndex:0 withObject:tempArray];
                
            }
            
            [self loadWorkApprovalsData];
            
            [applicationTypeTableView reloadData];
            
            if ([self.createOrderString isEqualToString:@"X"]) {
                
                [self.delegate addItemsViewController:self workApprovalsData:self.workApprovalDetailsArray withWorkApplicationsArray:self.workApplicationDetailsArray withIsolationsData:[NSMutableArray new]];
                
                [workApprovalHeaderView removeFromSuperview];
                
                [self.navigationController popViewControllerAnimated:YES];
             }
            
            else{
                
                [self insertCreatePermitsData];

            }
          
         }
    }
}


-(IBAction)popUpClicked:(id)sender{
    
  

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


-(IBAction)isolationSegmentController:(id)sender{
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.75];
    
    self.isolationSegmentControl = (UISegmentedControl *)sender;
    int clickedSegment=(int)[self.isolationSegmentControl selectedSegmentIndex];
    
    UIView *superview;
    
    if ((superview = [isolationHeaderView superview])) {
        [isolationHeaderView removeFromSuperview];
    }
    else if ((superview = [additionaltextView superview])){
        
        [additionaltextView removeFromSuperview];
    }
    else if ((superview = [opWCDView superview])){

        [opWCDView removeFromSuperview];
    }
    
    switch (clickedSegment)
    {
        case 0:
            
            [UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:checkPointTableView cache:NO];
            
            [isolationHeaderView setFrame:CGRectMake(0, 0, subView.frame.size.width, subView.frame.size.height)];
            
            [subView addSubview:isolationHeaderView];
 
            break;
            
        case 1:
            
            [UIView setAnimationTransition:UIViewAnimationTransitionCurlDown forView:checkPointTableView cache:NO];
 
            [additionaltextView setFrame:CGRectMake(0, 0, subView.frame.size.width, subView.frame.size.height)];
            
            [subView addSubview:additionaltextView];
            
            break;
            
        case 2:
            
            [UIView setAnimationTransition:UIViewAnimationTransitionCurlDown forView:checkPointTableView cache:NO];
            
            [opWCDView setFrame:CGRectMake(0, 0, subView.frame.size.width, subView.frame.size.height)];
            [subView addSubview:opWCDView];
            
            [self loadSwitchingScreenData];
            
            break;
            
        default:break;
    }
    
    [UIView commitAnimations];
}

-(IBAction)addOpWCDButtonClicked:(id)sender{
    
     opWCDScrollView.contentInset=UIEdgeInsetsMake(0.0,0.0,400,0.0);

     [opWCDHeaderView setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
      [isolationsListView addSubview:opWCDHeaderView];
    
    
 }


- (IBAction)tagUntagSearchAction:(id)sender{
    
    if (self.taggingConditionsDetailsArray==nil) {
        self.taggingConditionsDetailsArray=[NSMutableArray new];
    }
    else
    {
        [self.taggingConditionsDetailsArray removeAllObjects];
    }
    
    [self.taggingConditionsDetailsArray addObjectsFromArray:[[DataBase sharedInstance] fetchWCMIsloationsData]];
    
    [taggingConditionsView setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];

    [self.view addSubview:taggingConditionsView];
    
}

- (IBAction)addOperationWCDClicked:(id)sender{
    
    if ([opWCDTagTextfield.text isEqualToString:@""]&&[opWcdUnTagTextfield.text isEqualToString:@""]) {
        
        [self showAlertMessageWithTitle:@"Information" message:@"Please Select Tagging Conditions " cancelButtonTitle:@"Ok" withactionType:@"Single" forMethod:nil];
        
    }
    
    else {
        
        if (changeTaggingCondsFlag) {
            
            oGstring=[[self.operationWCDSubmittedDetailsArray objectAtIndex:taggingConditionsSelectedIndex] lastObject];
            
            [self.operationWCDSubmittedDetailsArray removeObjectAtIndex:taggingConditionsSelectedIndex];
            
            //Updating Tagging conditions
            NSMutableArray *tempOPWCDSubmittedDetailsArray=[NSMutableArray new];
 
            [tempOPWCDSubmittedDetailsArray addObject:wcdObjritem];//wcnr
 
            [tempOPWCDSubmittedDetailsArray addObject:applicationTypeString];   //wcitm
            
            //  [tempOPWCDSubmittedDetailsArray addObject:[NSString stringWithFormat:@"WD%@",VornrOpWCDString]];//objnr
            
            if (opWCDObjectID.length) {
                [tempOPWCDSubmittedDetailsArray addObject:opWCDObjectID];
            }
            else{
                
                [tempOPWCDSubmittedDetailsArray addObject:@""];
            }
            
            //  [tempOPWCDSubmittedDetailsArray addObject:@""];//objnr
            [tempOPWCDSubmittedDetailsArray addObject:@""];//itmType
            [tempOPWCDSubmittedDetailsArray addObject:@""];//seq
            [tempOPWCDSubmittedDetailsArray addObject:@""];//pred
            [tempOPWCDSubmittedDetailsArray addObject:@""];//succ
            
            
            [tempOPWCDSubmittedDetailsArray addObject:opWcdObjectTextField.text];//Ccobj
            
            if (opWCDObjectID.length) {
                [tempOPWCDSubmittedDetailsArray addObject:opWCDObjectID]; //Cctyp
            }
            else{
                
                [tempOPWCDSubmittedDetailsArray addObject:@""];
            }    //Ccobj
            
            
            [tempOPWCDSubmittedDetailsArray addObject:opWCDShortTextField.text];//stext
            
            if (![NullChecker isNull:oGstring]) {
                [tempOPWCDSubmittedDetailsArray addObject:oGstring]; //TGgrp
                
            }
            else{
                [tempOPWCDSubmittedDetailsArray addObject:@""];
            }
            
            
            [tempOPWCDSubmittedDetailsArray addObject:@""];//Tggstep
            
            
            [tempOPWCDSubmittedDetailsArray addObject:opWCDTagTextfield.text];  //Tgproc
            
            if (![NullChecker isNull:tgTypString]) {
                [tempOPWCDSubmittedDetailsArray addObject:tgTypString];  //Tgtyp
            }
            
            else{
                [tempOPWCDSubmittedDetailsArray addObject:@""];
            }
            
            
            [tempOPWCDSubmittedDetailsArray addObject:@""];//Tgseq
            
            [tempOPWCDSubmittedDetailsArray addObject:@""];//Tgtxt
            
            [tempOPWCDSubmittedDetailsArray addObject:@""];//Unstep
            
            
            [tempOPWCDSubmittedDetailsArray addObject:opWcdUnTagTextfield.text];//Unproc
            
            
            if (![NullChecker isNull:unTypString]) {
                [tempOPWCDSubmittedDetailsArray addObject:unTypString];  //Untyp
            }
            else{
                [tempOPWCDSubmittedDetailsArray addObject:@""];
            }
            
            [tempOPWCDSubmittedDetailsArray addObject:@""];  //unseq
            
            [tempOPWCDSubmittedDetailsArray addObject:@""];  //untxt
            
            
            if (![NullChecker isNull:phblghbString]) {
                [tempOPWCDSubmittedDetailsArray addObject:phblghbString];  //Phblfg
            }
            else{
                [tempOPWCDSubmittedDetailsArray addObject:@""];
            }
            
            [tempOPWCDSubmittedDetailsArray addObject:@""];  //Phbltyp
            
            
            
            [tempOPWCDSubmittedDetailsArray addObject:opWCDLockTextField.text];  //Phblnr
            
            
            
            [tempOPWCDSubmittedDetailsArray addObject:@""]; //Tgflg
            [tempOPWCDSubmittedDetailsArray addObject:@""];//Tgform
            [tempOPWCDSubmittedDetailsArray addObject:@""];//Tgnr
            [tempOPWCDSubmittedDetailsArray addObject:@""];//Unform
            [tempOPWCDSubmittedDetailsArray addObject:@""];//Unnr
            [tempOPWCDSubmittedDetailsArray addObject:@""];//Control
            [tempOPWCDSubmittedDetailsArray addObject:@""];//Location
            
            
            if (![NullChecker isNull:btgString]) {
                [tempOPWCDSubmittedDetailsArray addObject:btgString];// for Btg
            }
            else{
                [tempOPWCDSubmittedDetailsArray addObject:@""];
            }
            
            if (![NullChecker isNull:etgString]) {
                [tempOPWCDSubmittedDetailsArray addObject:etgString];// for Etg
            }
            else{
                
                [tempOPWCDSubmittedDetailsArray addObject:@""];
                
            }
            
            
            if (![NullChecker isNull:bugString]) {
                [tempOPWCDSubmittedDetailsArray addObject:bugString];// for bug
            }
            else{
                
                [tempOPWCDSubmittedDetailsArray addObject:@""];
                
            }
            
            if (![NullChecker isNull:eugString]) {
                [tempOPWCDSubmittedDetailsArray addObject:eugString];// for bug
            }
            else{
                
                [tempOPWCDSubmittedDetailsArray addObject:@""];
                
            }
            
            
            [tempOPWCDSubmittedDetailsArray addObject:@""];//Refobj
            
            [tempOPWCDSubmittedDetailsArray addObject:@"I"];//ACtion
            
            
            [self.addedOperationsWcdArray addObject:tempOPWCDSubmittedDetailsArray];
            
            [[self.permitsOperationWCD objectAtIndex:waSelectedIndex] replaceObjectAtIndex:2 withObject:self.addedOperationsWcdArray];
            
        }
        else{
            
            
            if (self.addedOperationsWcdArray==nil) {
                self.addedOperationsWcdArray=[NSMutableArray new];
            }
            else{
                
                [self.addedOperationsWcdArray removeAllObjects];
            }
            //Insering Tagging conditions
            
            NSMutableArray *tempOPWCDSubmittedDetailsArray=[NSMutableArray new];
            
            for (int i=0;i<[self.permitsOperationWCD count]; i++) {
                
                //NSLog(@"opwcd headerDetails:%@",self.permitsOperationWCD);
                
                if (![[[[self.permitsOperationWCD objectAtIndex:i] firstObject] objectAtIndex:2] isEqualToString:[NSString stringWithFormat:@"WD%@",VornrOpWCDString]]) {
                    
                    VornrOpWCDId=VornrOpWCDId+01;
                    VornrOpWCDString =[NSString stringWithFormat:@"%04i",VornrOpWCDId];
                    // waSelectedIndex=i;
                }
                
            }
            
            if (!changeApplicationFlag) {
                
                [tempOPWCDSubmittedDetailsArray addObject:@"WD0001"];//wcnr
                
            }
            else{
                
                if (wcdObjritem.length) {
                    
                    [tempOPWCDSubmittedDetailsArray addObject:wcdObjritem];//wcnr
                    
                }else{
                    
                    [tempOPWCDSubmittedDetailsArray addObject:@"WD0001"];//wcnr
                    
                }
                
            }
            
            [tempOPWCDSubmittedDetailsArray addObject:applicationTypeString];   //wcitm
            
            [tempOPWCDSubmittedDetailsArray addObject:@""];//objnr
            
            
            [tempOPWCDSubmittedDetailsArray addObject:@""];//itmType
            [tempOPWCDSubmittedDetailsArray addObject:@""];//seq
            [tempOPWCDSubmittedDetailsArray addObject:@""];//pred
            [tempOPWCDSubmittedDetailsArray addObject:@""];//succ
            
            
            [tempOPWCDSubmittedDetailsArray addObject:opWcdObjectTextField.text];//Ccobj
            
            if (opWCDObjectID.length) {
                [tempOPWCDSubmittedDetailsArray addObject:opWCDObjectID]; //Cctyp
            }
            else{
                
                [tempOPWCDSubmittedDetailsArray addObject:@""];
            }    //Ccobj
            
            
            [tempOPWCDSubmittedDetailsArray addObject:opWCDShortTextField.text];//stext
            
            if (![NullChecker isNull:oGstring]) {
                [tempOPWCDSubmittedDetailsArray addObject:oGstring]; //TGgrp
                
            }
            else{
                [tempOPWCDSubmittedDetailsArray addObject:@""];
            }
            
            
            [tempOPWCDSubmittedDetailsArray addObject:@""];//Tggstep
            
            
            [tempOPWCDSubmittedDetailsArray addObject:opWCDTagTextfield.text];  //Tgproc
            
            if (![NullChecker isNull:tgTypString]) {
                [tempOPWCDSubmittedDetailsArray addObject:tgTypString];  //Tgtyp
            }
            
            else{
                [tempOPWCDSubmittedDetailsArray addObject:@""];
            }
            
            
            [tempOPWCDSubmittedDetailsArray addObject:@""];//Tgseq
            
            [tempOPWCDSubmittedDetailsArray addObject:@""];//Tgtxt
            
            [tempOPWCDSubmittedDetailsArray addObject:@""];//Unstep
            
            
            [tempOPWCDSubmittedDetailsArray addObject:opWcdUnTagTextfield.text];//Unproc
            
            
            if (![NullChecker isNull:unTypString]) {
                [tempOPWCDSubmittedDetailsArray addObject:unTypString];  //Untyp
            }
            else{
                [tempOPWCDSubmittedDetailsArray addObject:@""];
            }
            
            [tempOPWCDSubmittedDetailsArray addObject:@""];  //unseq
            
            [tempOPWCDSubmittedDetailsArray addObject:@""];  //untxt
            
            
            if (![NullChecker isNull:phblghbString]) {
                [tempOPWCDSubmittedDetailsArray addObject:phblghbString];  //Phblfg
            }
            else{
                [tempOPWCDSubmittedDetailsArray addObject:@""];
            }
            
            [tempOPWCDSubmittedDetailsArray addObject:@""];  //Phbltyp
            
            
            
            [tempOPWCDSubmittedDetailsArray addObject:opWCDLockTextField.text];  //Phblnr
            
            
            
            [tempOPWCDSubmittedDetailsArray addObject:@""]; //Tgflg
            [tempOPWCDSubmittedDetailsArray addObject:@""];//Tgform
            [tempOPWCDSubmittedDetailsArray addObject:@""];//Tgnr
            [tempOPWCDSubmittedDetailsArray addObject:@""];//Unform
            [tempOPWCDSubmittedDetailsArray addObject:@""];//Unnr
            [tempOPWCDSubmittedDetailsArray addObject:@""];//Control
            [tempOPWCDSubmittedDetailsArray addObject:@""];//Location
            
            
            if (![NullChecker isNull:btgString]) {
                [tempOPWCDSubmittedDetailsArray addObject:btgString];// for Btg
            }
            else{
                [tempOPWCDSubmittedDetailsArray addObject:@""];
            }
            
            if (![NullChecker isNull:etgString]) {
                [tempOPWCDSubmittedDetailsArray addObject:etgString];// for Etg
            }
            else{
                
                [tempOPWCDSubmittedDetailsArray addObject:@""];
                
            }
            
            if (![NullChecker isNull:bugString]) {
                [tempOPWCDSubmittedDetailsArray addObject:bugString];// for bug
            }
            else{
                
                [tempOPWCDSubmittedDetailsArray addObject:@""];
                
            }
            
            if (![NullChecker isNull:eugString]) {
                [tempOPWCDSubmittedDetailsArray addObject:eugString];// for eug
            }
            else{
                
                [tempOPWCDSubmittedDetailsArray addObject:@""];
                
            }
            
            
            if (!changeApplicationFlag) {
                
                [tempOPWCDSubmittedDetailsArray addObject:@""];//Refobj
                
            }
            else{
                
                if (opwcdRefObj.length) {
                    
                    // [tempOPWCDSubmittedDetailsArray addObject:opwcdRefObj];//Refobj
                    
                    
                    [tempOPWCDSubmittedDetailsArray addObject:@""];//Refobj
                    
                }
                else{
                    
                    [tempOPWCDSubmittedDetailsArray addObject:@""];//Refobj
                    
                }
                
            }
            
            [tempOPWCDSubmittedDetailsArray addObject:@"I"];//ACtion
            
            //  [self.addedOperationsWcdArray  addObject:tempOPWCDSubmittedDetailsArray];
            
            //[self.opWCDListDetailsArray replaceObjectAtIndex:waSelectedIndex withObject:self.opWCDListDetailsArray];
            
            if ([[[self.permitsOperationWCD objectAtIndex:waSelectedIndex] lastObject] count]) {
                
                [self.addedOperationsWcdArray addObjectsFromArray:[[self.permitsOperationWCD objectAtIndex:waSelectedIndex] lastObject]];
            }
            
            
            [self.addedOperationsWcdArray addObject:tempOPWCDSubmittedDetailsArray];
            
            
            [[self.permitsOperationWCD objectAtIndex:waSelectedIndex] replaceObjectAtIndex:1 withObject:[self.addedOperationsWcdArray copy]];
            
        }
        
        [opWCDHeaderView removeFromSuperview];
        
 
        [operationWCDTableView reloadData];
        opWcdTypeTexfield.text=@"";
        opWcdObjectTextField.text=@"";
        opWCDTagTextfield.text=@"";
        opWcdUnTagTextfield.text=@"";
        opWCDLockTextField.text=@"";
        taggedBarcodeBtn.hidden=YES;
    }
}

-(void)loadWorkApprovalsData{
    
    NSMutableArray *tempArray=[NSMutableArray new];
    
    [tempArray addObject:@""];//headerID
    [tempArray addObject:@"WW"];
    
    if (workApprovalObjArt.length) {
        
        [tempArray addObject:workApprovalObjArt];//applicationID
        
    }
    else{
        
        [tempArray addObject:[NSString stringWithFormat:@"WW0001"]];//applicationID
        
    }
    
    if (plantWorkCenterID.length) {
        
        [tempArray addObject:plantWorkCenterID];
    }
    else{
        
        [tempArray addObject:@""];
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
    [dateFormatter setDateFormat:@"yyyyMMdd"];
    
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
    
    [tempArray addObject:@"0"];//rctime
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
        
        
        [self showAlertMessageWithTitle:@"Information" message:@"Please Add Atleast One Application" cancelButtonTitle:@"Ok" withactionType:@"Ok" forMethod:nil];
        
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



- (IBAction)finalIsolationSubmitClicked:(id)sender{
    
    if ([isolationHeaderLabel.text isEqualToString:@"Operation WCD"]) {
        
        if (!setPreparedIsolationFlag) {
            
             [self showAlertMessageWithTitle:@"Information" message:@"Please enable Set Prepared status" cancelButtonTitle:@"Ok" withactionType:@"Single" forMethod:nil];
            
            return;
            
        }
        else if (![[[self.permitsOperationWCD objectAtIndex:0] lastObject] count]){
            
             [self showAlertMessageWithTitle:@"Information" message:@"Please add atleast one tagging condition" cancelButtonTitle:@"Ok" withactionType:@"Single" forMethod:nil];
            
            return;
            
        }
        else  {
            
            
            opWCDBtn.hidden=NO;
            switchingScreenBtn.hidden=YES;
            isolationHeaderLabel.text=isolationHeaderString;
 
            issuePermitsPosition=@"WA";
            
            [self trafficSignalforIsolationWApplication];
            
            NSString *wapinr=@"";
            
            if ([self.permitsOperationWCD count]) {
                
                if (![[[[self.permitsOperationWCD objectAtIndex:waSelectedIndex] firstObject] objectAtIndex:2] isEqualToString:[NSString stringWithFormat:@"WD%@",VornrOpWCDString]]) {
                    
                    VornrOpWCDId=VornrOpWCDId+01;
                    VornrOpWCDString =[NSString stringWithFormat:@"%04i",VornrOpWCDId];
                    
                }
                
                wapinr=[[[self.permitsOperationWCD objectAtIndex:waSelectedIndex] firstObject] objectAtIndex:2];
            }
            
            //Final mapping of Opwcd Header Details
            
            NSMutableArray *tempOPWCDDetailsarray=[NSMutableArray new];
            [tempOPWCDDetailsarray addObject:@""];//header_id
 
            if (!changeWorkApprovalFlag) {
                
                [tempOPWCDDetailsarray addObject:@"WD"];//objart
                
                [tempOPWCDDetailsarray addObject:[NSString stringWithFormat:@"WD0001"]];
                //wapinr
            }
            else{
                
                [tempOPWCDDetailsarray addObject:@""];//objart
                
                [tempOPWCDDetailsarray addObject:wapinr];
                
            }
            
            if (plantWorkCenterID.length) {
                [tempOPWCDDetailsarray addObject:plantWorkCenterID]; //iwerk
                
            }
            else{
                [tempOPWCDDetailsarray addObject:@""];
            }
            
            [tempOPWCDDetailsarray addObject:applicationTypeString];//objttyp
            
            
            if (isolationUsageID.length) {
                
                [tempOPWCDDetailsarray addObject:isolationUsageID];//usage
                
            }
            else{
                
                [tempOPWCDDetailsarray addObject:@""];//usage
                
            }
            
            
            [tempOPWCDDetailsarray addObject:isolationUsageTextfield.text];//usagex
            
            [tempOPWCDDetailsarray addObject:@""];//train
            
            [tempOPWCDDetailsarray addObject:@""];//trainx
            
            [tempOPWCDDetailsarray addObject:@""];//anlzu
            
            [tempOPWCDDetailsarray addObject:@""];//anlzux
            
            [tempOPWCDDetailsarray addObject:@""];//etape
            
            [tempOPWCDDetailsarray addObject:@""];//etapex
            
            
            [tempOPWCDDetailsarray addObject:isolationShortTextField.text];//stext
            
            
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"MMM dd, yyyy"];
            NSDate *startDate = [dateFormatter dateFromString:wcmFromDateTextfield.text];
            NSDate *endDate = [dateFormatter dateFromString:wcmToDateTextfield.text];
            // Convert date object into desired format
            [dateFormatter setDateFormat:@"yyyy-MM-dd"];
            
            
            NSString *convertedStartDateString = [dateFormatter stringFromDate:startDate];
            
            if (![NullChecker isNull:convertedStartDateString]) {
                
                [tempOPWCDDetailsarray addObject:convertedStartDateString];
                
            }
            else{
                
                [tempOPWCDDetailsarray addObject:@""];
                
            }
            
            
            [tempOPWCDDetailsarray addObject:wcmFromTimeTextfield.text];
            
            
            NSString *convertedEndDateString = [dateFormatter stringFromDate:endDate];
            
            if (![NullChecker isNull:convertedEndDateString]) {
                [tempOPWCDDetailsarray addObject:convertedEndDateString];
            }
            else{
                
                [tempOPWCDDetailsarray addObject:@""];
                
            }
            
            [tempOPWCDDetailsarray addObject:wcmToTimeTextfield.text];
            
            
            if (isolationPriorityId.length) {
                [tempOPWCDDetailsarray addObject:isolationPriorityId];//priok
            }
            else{
                [tempOPWCDDetailsarray addObject:@""];
            }
            
            [tempOPWCDDetailsarray addObject:isolationPriorityTextfield.text];//priokx
            
            [tempOPWCDDetailsarray addObject:@"0"];//rctime
            
            [tempOPWCDDetailsarray addObject:@""];//rcunit
            
            
            if (!changeWorkApprovalFlag) {
                
                [tempOPWCDDetailsarray addObject:@""];//objnr
                
                [tempOPWCDDetailsarray addObject:@""];//refobj
                
            }
            else{
                
                if (opwcdRefObj.length) {
                    
                    [tempOPWCDDetailsarray addObject:opwcdRefObj];//objnr
                    [tempOPWCDDetailsarray addObject:WARefobj];//refobj
                    
                }
                else{
                    
                    [tempOPWCDDetailsarray addObject:@""];//objnr
                    [tempOPWCDDetailsarray addObject:@""];//refobj
                    
                    
                }
                
            }
            
            
            [tempOPWCDDetailsarray addObject:@""];//crea
            
            
            if (isolationSetPreparedString.length) {
                [tempOPWCDDetailsarray addObject:isolationSetPreparedString];  //prep
            }
            else{
                [tempOPWCDDetailsarray addObject:@""];
            }
            
            
            [tempOPWCDDetailsarray addObject:@""];//comp
            
            if (!changeApplicationFlag) {
                
                [tempOPWCDDetailsarray addObject:@""];//appr
                
            }
            else{
                
                NSMutableArray * workOpwcdIssuepemitsArray=[NSMutableArray new];
                
                for (int i =0; i<[self.issuePermitsDetailArray count]; i++) {
                    
                    if ([[[self.issuePermitsDetailArray objectAtIndex:i] objectAtIndex:5] isEqualToString:@"WD"]) {
                        
                        [workOpwcdIssuepemitsArray  addObject:[self.issuePermitsDetailArray objectAtIndex:i]];
                        
                    }
                }
                
                NSMutableArray *workOpwcdTrafficArray=[NSMutableArray new];
                
                for (int k=0; k<[workOpwcdIssuepemitsArray count]; k++) {
                    
                    if ([[[workOpwcdIssuepemitsArray objectAtIndex:k] objectAtIndex:9] isEqualToString:@""]) {
                        
                        [workOpwcdTrafficArray addObject:[NSNumber numberWithInteger:k]];
                    }
                }
                
                if (![workOpwcdTrafficArray count]) {
                    
                    [tempOPWCDDetailsarray addObject:@"R"]; //appr
                    
                }
                else if ([workOpwcdIssuepemitsArray count] == [workOpwcdTrafficArray count]){
                    
                    [tempOPWCDDetailsarray addObject:@"G"]; //appr
                    
                }
                else {
                    
                    [tempOPWCDDetailsarray addObject:@"Y"]; //appr
                    
                }
                
            }
            
            
            if (!changeApplicationFlag) {
                [tempOPWCDDetailsarray addObject:@"I"];//action
                
            }
            else{
                [tempOPWCDDetailsarray addObject:@"U"];//action
                
            }
            
            
            if (isolationUserGroupID.length) {
                
                [tempOPWCDDetailsarray addObject:isolationUserGroupID];//begru
                
            }
            else{
                
                [tempOPWCDDetailsarray addObject:@""];//begru
                
            }
            
             [tempOPWCDDetailsarray addObject:isolationUsergroupTexField.text];//begrutx
             [tempOPWCDDetailsarray addObject:taggingTextView.text];//Tagging Text
             [tempOPWCDDetailsarray addObject:untaggingTextView.text];//UnTagging Text
            
             if (changeApplicationFlag) {
                
                [[self.permitsOperationWCD objectAtIndex:waSelectedIndex] replaceObjectAtIndex:0 withObject:tempOPWCDDetailsarray];
                
            }
            
            else{
                
                [[self.permitsOperationWCD objectAtIndex:waSelectedIndex] replaceObjectAtIndex:0 withObject:tempOPWCDDetailsarray];
                
            }
            
            
            //back mapping to previous Isolation HeaderDetails
            isolationShortTextField.text=[[self.opWCDHeadrDetailsArray objectAtIndex:0]  objectAtIndex:13];
            
            isolationFunctionLocationTextfield.text=[[self.headerDetailsArray objectAtIndex:2] objectAtIndex:2];
            
            isolationFromDateTextfield.text=[[self.opWCDHeadrDetailsArray objectAtIndex:0]  objectAtIndex:14];
            isolationFromTimeTextfield.text=[[self.opWCDHeadrDetailsArray objectAtIndex:0]   objectAtIndex:15];
            isolationToDateTextfield.text=[[self.opWCDHeadrDetailsArray objectAtIndex:0]  objectAtIndex:16];
            isolationToTimeTextfield.text=[[self.opWCDHeadrDetailsArray objectAtIndex:0]  objectAtIndex:17];
            
            if ([[[self.opWCDHeadrDetailsArray objectAtIndex:0] objectAtIndex:25] isEqualToString:@"X"]) {
                
                [isolationSetPreparedBtn setImage:[UIImage imageNamed:@"set_prepared_enable_icon"] forState:UIControlStateNormal];
                
                isolationSetPreparedString=@"X";
                
                setPreparedIsolationFlag=YES;
            }
            else{
                
                [isolationSetPreparedBtn setImage:[UIImage imageNamed:@"set_prepared_disable_icon"] forState:UIControlStateNormal];
                
                setPreparedIsolationFlag=NO;
                
                isolationSetPreparedString=@"X";
                
            }
            
            isolationUserGroupID=[[self.opWCDHeadrDetailsArray objectAtIndex:0]  objectAtIndex:29];
            isolationUsergroupTexField.text=[[self.opWCDHeadrDetailsArray objectAtIndex:0]  objectAtIndex:30];
            
            isolationPriorityId=[[self.opWCDHeadrDetailsArray objectAtIndex:0]  objectAtIndex:18];
            isolationPriorityTextfield.text=[[self.opWCDHeadrDetailsArray objectAtIndex:0]  objectAtIndex:19];
            
            isolationUsageID=[[self.opWCDHeadrDetailsArray objectAtIndex:0]  objectAtIndex:5];
            isolationUsageTextfield.text=[[self.opWCDHeadrDetailsArray objectAtIndex:0]  objectAtIndex:6];
            
        }
        
    }
    
    else{
        
        [opWCDListView removeFromSuperview];
        [opWCDHeaderView removeFromSuperview];
        
        
        if (!setPreparedIsolationFlag) {
            
            UIAlertView *failureAlertView = [[UIAlertView alloc]initWithTitle:@"Information" message:@"Please enable Set Prepared status" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            [failureAlertView show];
            
            return;
            
        }
        else{
            
            
            issuePermitsPosition=@"WW";
            
            NSMutableArray *tempIsolationDetailsarray=[NSMutableArray new];
            
            //Insert Isolation Header Details
            
            if (changeApplicationFlag) {
                
                if ([self.applicationDetailsArray count]) {
                    
                    if (![[[self.applicationDetailsArray objectAtIndex:waSelectedIndex] objectAtIndex:1] isEqualToString:[NSString stringWithFormat:@"WA%@",vornrApplicationString]]) {
                        
                        VornrApplicationId=VornrApplicationId+01;
                        vornrApplicationString =[NSString stringWithFormat:@"%04i",VornrApplicationId];
                    }
                }
                
            }
            else
            {
                if ([self.workApplicationDetailsArray count]) {
                    
                    int currentIndex=0;
                    
                    for (int k=0; k<[self.workApplicationDetailsArray count]; k++) {
                        
                        currentIndex=k;
                    }
                    
                    if (!changeApplicationFlag) {
                        
                        if (![self.workApplicationDetailsArray count]) {
                            
                            VornrApplicationId=0;
                        }
                        
                    }
                    else{
                        
                        VornrApplicationId=[[[[[self.workApplicationDetailsArray objectAtIndex:currentIndex] firstObject] objectAtIndex:2] substringFromIndex:4] intValue];
                    }
                    
                    VornrApplicationId=VornrApplicationId+01;
                    vornrApplicationString =[NSString stringWithFormat:@"%04i",VornrApplicationId];
                    
                }
                else{
                    VornrApplicationId=0;
                    VornrApplicationId=VornrApplicationId+01;
                    vornrApplicationString =[NSString stringWithFormat:@"%04i",VornrApplicationId];
                }
                
            }
            
            
            [tempIsolationDetailsarray addObject:@""];//header_id
            
            [tempIsolationDetailsarray addObject:@"WA"];//objart
            
            if (!changeApplicationFlag) {
                
                [tempIsolationDetailsarray addObject:[NSString stringWithFormat:@"WA%@",vornrApplicationString]];//applicationID
            }
            else{
                
                [tempIsolationDetailsarray addObject:applicationObjArt];//wapinr
            }
            
            
            for (int i=0; i<[self.permitsOperationWCD count]; i++) {
                
                if (![[[[self.permitsOperationWCD objectAtIndex:i] firstObject] objectAtIndex:23] isEqualToString:[NSString stringWithFormat:@"WA%@",vornrApplicationString]]) {
                    
                    if ([[[[self.permitsOperationWCD objectAtIndex:i] firstObject] objectAtIndex:23] isEqualToString:@""]) {
                        
                        [[[self.permitsOperationWCD objectAtIndex:i] firstObject] replaceObjectAtIndex:23 withObject:[NSString stringWithFormat:@"WA%@",vornrApplicationString]];  //for OPWCD refobj
                    }
                    
                }
                
            }
            
            if (plantWorkCenterID.length) {
                [tempIsolationDetailsarray addObject:plantWorkCenterID]; //iwerk
                
            }
            else{
                [tempIsolationDetailsarray addObject:@""];
            }
            
            [tempIsolationDetailsarray addObject:applicationTypeString];//objttyp
            
            if (isolationUsageID.length) {
                
                [tempIsolationDetailsarray addObject:isolationUsageID];//usage
                
            }
            else{
                
                [tempIsolationDetailsarray addObject:@""];//usage
                
            }
            
            
            [tempIsolationDetailsarray addObject:isolationUsageTextfield.text];//usagex
            
            
            [tempIsolationDetailsarray addObject:@""];//train
            
            [tempIsolationDetailsarray addObject:@""];//trainx
            
            [tempIsolationDetailsarray addObject:@""];//anlzu
            
            [tempIsolationDetailsarray addObject:@""];//anlzux
            
            [tempIsolationDetailsarray addObject:@""];//etape
            
            [tempIsolationDetailsarray addObject:@""];//etapex
            
            
            [tempIsolationDetailsarray addObject:isolationShortTextField.text];//stext
            
            
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"MMM dd, yyyy"];
            NSDate *startDate = [dateFormatter dateFromString:wcmFromDateTextfield.text];
            NSDate *endDate = [dateFormatter dateFromString:wcmToDateTextfield.text];
            // Convert date object into desired format
            [dateFormatter setDateFormat:@"yyyy-MM-dd"];
            
            
            NSString *convertedStartDateString = [dateFormatter stringFromDate:startDate];
            
            if (![NullChecker isNull:convertedStartDateString]) {
                
                [tempIsolationDetailsarray addObject:convertedStartDateString];
                
            }
            else{
                
                [tempIsolationDetailsarray addObject:@""];
                
            }
            
            
            [tempIsolationDetailsarray addObject:wcmFromTimeTextfield.text];
            
            
            NSString *convertedEndDateString = [dateFormatter stringFromDate:endDate];
            
            if (![NullChecker isNull:convertedEndDateString]) {
                [tempIsolationDetailsarray addObject:convertedEndDateString];
            }
            else{
                
                [tempIsolationDetailsarray addObject:@""];
                
            }
            
            [tempIsolationDetailsarray addObject:wcmToTimeTextfield.text];
            
            
            if (isolationPriorityId.length) {
                [tempIsolationDetailsarray addObject:isolationPriorityId];//priok
            }
            else{
                [tempIsolationDetailsarray addObject:@""];
            }
            
            [tempIsolationDetailsarray addObject:isolationPriorityTextfield.text];//priokx
            
            [tempIsolationDetailsarray addObject:@"0"];//rctime
            
            [tempIsolationDetailsarray addObject:@""];//rcunit
            
            if (!changeApplicationFlag) {
                
                [tempIsolationDetailsarray addObject:@""];//objnr
                [tempIsolationDetailsarray addObject:@"WW0001"];//refobj
                
            }
            else{
                
                [tempIsolationDetailsarray addObject:objnrIdPosition];//objnr
                [tempIsolationDetailsarray addObject:refObjString];//refobj
                
            }
            
            
            [tempIsolationDetailsarray addObject:@""];//crea
            
            
            if (isolationSetPreparedString.length) {
                [tempIsolationDetailsarray addObject:isolationSetPreparedString];  //prep
            }
            else{
                [tempIsolationDetailsarray addObject:@""];
            }
            
            
            [tempIsolationDetailsarray addObject:@""];//comp
            
            
            if (!changeApplicationFlag) {
                
                [tempIsolationDetailsarray addObject:@""];//appr
                
            }
            else{
                
                
                NSMutableArray *issuedApplicationsArray=[NSMutableArray new];
                
                for (int j=0; j<[self.workApplicationDetailsArray count]; j++) {
                    
                    if ([[[[self.workApplicationDetailsArray objectAtIndex:j] firstObject] objectAtIndex:27] isEqualToString:@"G"]&&[applicationTypeString isEqualToString:@"1"]) {
                        [issuedApplicationsArray addObject:[NSNumber numberWithInteger:j]];
                    }
                    
                }
                
                if ([issuedApplicationsArray count]==[self.workApplicationDetailsArray count]) {
                    
                    [tempIsolationDetailsarray addObject:@"G"];//appr
                    
                }
                else{
                    
                    NSMutableArray * workApplicationOpwcdIssuepemitsArray=[NSMutableArray new];
                    
                    for (int i =0; i<[self.issuePermitsDetailArray count]; i++) {
                        
                        if ([[[self.issuePermitsDetailArray objectAtIndex:i] objectAtIndex:5] isEqualToString:@"WA"]&&[[[self.issuePermitsDetailArray objectAtIndex:i] objectAtIndex:6] isEqualToString:@"1"]) {
                            
                            [workApplicationOpwcdIssuepemitsArray  addObject:[self.issuePermitsDetailArray objectAtIndex:i]];
                            
                        }
                        else if ([[[self.issuePermitsDetailArray objectAtIndex:i] objectAtIndex:5] isEqualToString:@"WD"]){
                            
                            [workApplicationOpwcdIssuepemitsArray  addObject:[self.issuePermitsDetailArray objectAtIndex:i]];
                            
                        }
                        
                    }
                    
                    NSMutableArray *workApplicationTrafficArray=[NSMutableArray new];
                    
                    for (int k=0; k<[workApplicationOpwcdIssuepemitsArray count]; k++) {
                        
                        if ([[[workApplicationOpwcdIssuepemitsArray objectAtIndex:k] objectAtIndex:9] isEqualToString:@""]) {
                            
                            [workApplicationTrafficArray addObject:[NSNumber numberWithInteger:k]];
                        }
                    }
                    
                    if (![workApplicationTrafficArray count]) {
                        
                        [tempIsolationDetailsarray addObject:@"R"]; //appr
                        
                    }
                    else if ([workApplicationOpwcdIssuepemitsArray count] == [workApplicationTrafficArray count]){
                        
                        [tempIsolationDetailsarray addObject:@"G"]; //appr
                        
                    }
                    else {
                        
                        [tempIsolationDetailsarray addObject:@"Y"]; //appr
                        
                    }
                    
                }
                
            }
            
            
            if (!changeApplicationFlag) {
                
                [tempIsolationDetailsarray addObject:@"I"];//action
            }
            else{
                
                [tempIsolationDetailsarray addObject:@"U"];//action
                
            }
            
            
            if (isolationUserGroupID.length) {
                
                [tempIsolationDetailsarray addObject:isolationUserGroupID];//begru
                
            }
            else{
                
                [tempIsolationDetailsarray addObject:@""];//begru
                
            }
            
            [tempIsolationDetailsarray addObject:isolationUsergroupTexField.text];//begrutx
            
            
            NSMutableArray *tempApplicationDetailsarray=[NSMutableArray new];
            
            if (changeApplicationFlag) {
                
                //update Application table Details
                
                [tempApplicationDetailsarray addObject:[[[self.workApplicationDetailsArray objectAtIndex:waSelectedIndex] firstObject] objectAtIndex:0]];
                [tempApplicationDetailsarray addObject:[[[self.workApplicationDetailsArray objectAtIndex:waSelectedIndex] firstObject] objectAtIndex:1]];
                [tempApplicationDetailsarray addObject:[[[self.workApplicationDetailsArray objectAtIndex:waSelectedIndex] firstObject] objectAtIndex:2]];
                [tempApplicationDetailsarray addObject:[[[self.workApplicationDetailsArray objectAtIndex:waSelectedIndex] firstObject] objectAtIndex:3]];
                [tempApplicationDetailsarray addObject:[[[self.workApplicationDetailsArray objectAtIndex:waSelectedIndex] firstObject] objectAtIndex:4]];
                
                //   [self.workApplicationDetailsArray removeObjectAtIndex:waSelectedIndex];
                
                //  [self.applicationHeaderDetailsArray addObject:tempIsolationDetailsarray];
                
                [[self.workApplicationDetailsArray objectAtIndex:workApplicationSelectedIndex] replaceObjectAtIndex:0 withObject:tempIsolationDetailsarray];
                
            }
            
            else{
                
                //insert Application table Details
                [tempApplicationDetailsarray addObject:@""];
                [tempApplicationDetailsarray addObject:[NSString stringWithFormat:@"%@%@",[[self.applicationTypesArray objectAtIndex:applicationSelectedIndex] objectAtIndex:2],vornrApplicationString]];
                [tempApplicationDetailsarray addObject:[[self.applicationTypesArray objectAtIndex:applicationSelectedIndex] objectAtIndex:4]];
                [tempApplicationDetailsarray addObject:[[self.applicationTypesArray objectAtIndex:applicationSelectedIndex] objectAtIndex:3]];
                [tempApplicationDetailsarray addObject:@""];
                
                NSMutableArray *tempArray=[NSMutableArray new];
                
                [tempArray addObject:tempIsolationDetailsarray];//Header Details
                [tempArray addObject:[NSMutableArray new]];
                [tempArray addObject:[NSMutableArray new]];
                
                [self.workApplicationDetailsArray addObject:tempArray];
                
                // [[self.workApplicationDetailsArray objectAtIndex:waSelectedIndex] replaceObjectAtIndex:0 withObject:tempArray];
                
            }
            
            
            [self.applicationDetailsArray addObject:tempApplicationDetailsarray];//Application Details
            
            // self.workApplicationDetailsArray
            
            [applicationTypeTableView reloadData];
        }
        
        [self trafficSignalforWorkApproval];
        
        
        [self.view addSubview:applicationTypeView];
        addWorkApprovalFlag=YES;
    }
}

-(void)loadSwitchingScreenData{
    
 
        issuePermitsPosition=@"WD";
        
        if (!changeApplicationFlag) {
            
            if ([etgString isEqualToString:@"X"]) {
                
                selectAllLabel.hidden=YES;
                selectAllOpwcdBtn.hidden=YES;
                addOpwcdBtn.hidden=YES;
                // deleteTaggingBtn.hidden=YES;
            }
            
            opWCDShortTextField.text=wcmShortTextField.text;
            
            VornrOpWCDId=VornrOpWCDId+01;
            VornrOpWCDString =[NSString stringWithFormat:@"%04i",VornrOpWCDId];
            
            NSMutableArray *tempOPWCDDetailsarray=[NSMutableArray new];
            [tempOPWCDDetailsarray addObject:@""];
            
            [tempOPWCDDetailsarray addObject:@"WD"];
            
            [tempOPWCDDetailsarray addObject:[NSString stringWithFormat:@"WD%@",VornrOpWCDString]];
            
            
            [tempOPWCDDetailsarray addObject:isolationShortTextField.text];
            
            if (functionalLocationID.length) {
                [tempOPWCDDetailsarray addObject:functionalLocationID];
            }
            else{
                [tempOPWCDDetailsarray addObject:@""];
            }
            
            [tempOPWCDDetailsarray addObject:isolationFunctionLocationTextfield.text];
            [tempOPWCDDetailsarray addObject:isolationFromDateTextfield.text];
            [tempOPWCDDetailsarray addObject:isolationFromTimeTextfield.text];
            [tempOPWCDDetailsarray addObject:isolationToDateTextfield.text];
            [tempOPWCDDetailsarray addObject:isolationToTimeTextfield.text];
            
            if (isolationPriorityId.length) {
                [tempOPWCDDetailsarray addObject:isolationPriorityId];
            }
            else{
                [tempOPWCDDetailsarray addObject:@""];
            }
            
            [tempOPWCDDetailsarray addObject:isolationPriorityTextfield.text];
            
            
            if (isolationSetPreparedString.length) {
                [tempOPWCDDetailsarray addObject:isolationSetPreparedString];
            }
            else{
                [tempOPWCDDetailsarray addObject:@""];
            }
            
            [tempOPWCDDetailsarray addObject:@""];
            
            //           [self.permitsOperationWCD addObject:[NSMutableArray array]];
            //
            
            if ([self.permitsOperationWCD count]) {
                
                [[self.permitsOperationWCD objectAtIndex:waSelectedIndex] replaceObjectAtIndex:0 withObject:tempOPWCDDetailsarray];
            }
            else{
                
                [self.permitsOperationWCD addObject:[NSMutableArray array]];
                
                for (int i=0; i<[self.permitsOperationWCD count]; i++)
                {
                    waSelectedIndex=i;
                }
                
                [[self.permitsOperationWCD objectAtIndex:waSelectedIndex]  addObject:tempOPWCDDetailsarray];
                
                [[self.permitsOperationWCD objectAtIndex:waSelectedIndex]  addObject:[NSArray array]];
                
            }
            
        }
        
        else
        {
            
            selectAllLabel.hidden=NO;
            selectAllOpwcdBtn.hidden=NO;
            plusTaggingConditionsBtn.hidden=NO;
            
            wcdObjritem=@"";
            
            if ([self.permitsOperationWCD count]) {
                
                if ([[[self.permitsOperationWCD objectAtIndex:waSelectedIndex] lastObject] count]) {
                    
                    if ([[[[[self.permitsOperationWCD objectAtIndex:waSelectedIndex] lastObject] objectAtIndex:0] objectAtIndex:31] isEqualToString:@"X"]) {
                        btgString = @"X";
                      //  [taggingConditionsButton setTitle:@"Tagged" forState:UIControlStateNormal];
                    }
                    else if ([[[[[self.permitsOperationWCD objectAtIndex:waSelectedIndex] lastObject] objectAtIndex:0] objectAtIndex:32] isEqualToString:@"X"]){
                        etgString = @"X";
                      //  [taggingConditionsButton setTitle:@"UnTag" forState:UIControlStateNormal];
                    }
                    else if ([[[[[self.permitsOperationWCD objectAtIndex:waSelectedIndex] lastObject] objectAtIndex:0] objectAtIndex:33] isEqualToString:@"X"]){
                        bugString = @"X";
                       // [taggingConditionsButton setTitle:@"UnTagged" forState:UIControlStateNormal];
                    }
                    else if ([[[[[self.permitsOperationWCD objectAtIndex:waSelectedIndex] lastObject] objectAtIndex:0] objectAtIndex:34] isEqualToString:@"X"]){
                        eugString = @"X";
//                        [taggingConditionsButton setTitle:@"UnTagged" forState:UIControlStateNormal];
//                        [taggingConditionsButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
//                        taggingConditionsButton.userInteractionEnabled = NO;
//                        taggingConditionsButton.titleLabel.textColor = [UIColor lightGrayColor];
//
                        selectAllOpwcdBtn.hidden = YES;
                        selectAllLabel.hidden = YES;
                        removeTaggingConditionsButton.hidden = YES;
                        plusTaggingConditionsBtn.hidden=YES;
                        
                    }
                 }
                
                if ([[[self.permitsOperationWCD objectAtIndex:waSelectedIndex] firstObject] count]) {
                    
                    wcdObjritem=[[[self.permitsOperationWCD objectAtIndex:waSelectedIndex]firstObject]objectAtIndex:2];
                    opwcdRefObj=[[[self.permitsOperationWCD objectAtIndex:waSelectedIndex]firstObject]objectAtIndex:22];
                  }
                
              }
            
            
            opWCDShortTextField.text=wcmShortTextField.text;
            
            VornrOpWCDId=VornrOpWCDId+01;
            VornrOpWCDString =[NSString stringWithFormat:@"%04i",VornrOpWCDId];
            
            
            NSMutableArray *tempOPWCDDetailsarray=[NSMutableArray new];
            [tempOPWCDDetailsarray addObject:@""];//header_id
            
            [tempOPWCDDetailsarray addObject:@"WD"];//objart
            
            if ([wcdObjritem isEqualToString:@""]) {
                [tempOPWCDDetailsarray addObject:[NSString stringWithFormat:@"WD%@",VornrOpWCDString]];
            }
            
            else{
                [tempOPWCDDetailsarray addObject:wcdObjritem];
            }
            
            
            if (plantWorkCenterID.length) {
                [tempOPWCDDetailsarray addObject:plantWorkCenterID]; //iwerk
                
            }
            else{
                [tempOPWCDDetailsarray addObject:@""];
            }
            
            [tempOPWCDDetailsarray addObject:applicationTypeString];//objttyp
            
            
            if (isolationUsageID.length) {
                
                [tempOPWCDDetailsarray addObject:isolationUsageID];//usage
                
            }
            else{
                
                [tempOPWCDDetailsarray addObject:@""];//usage
                
            }
            
            
            [tempOPWCDDetailsarray addObject:isolationUsageTextfield.text];//usagex
            
            [tempOPWCDDetailsarray addObject:@""];//train
            
            [tempOPWCDDetailsarray addObject:@""];//trainx
            
            [tempOPWCDDetailsarray addObject:@""];//anlzu
            
            [tempOPWCDDetailsarray addObject:@""];//anlzux
            
            [tempOPWCDDetailsarray addObject:@""];//etape
            
            [tempOPWCDDetailsarray addObject:@""];//etapex
            
            
            [tempOPWCDDetailsarray addObject:isolationShortTextField.text];//stext
            
            
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"MMM dd, yyyy"];
            NSDate *startDate = [dateFormatter dateFromString:wcmFromDateTextfield.text];
            NSDate *endDate = [dateFormatter dateFromString:wcmToDateTextfield.text];
            // Convert date object into desired format
            [dateFormatter setDateFormat:@"yyyy-MM-dd"];
            
            
            NSString *convertedStartDateString = [dateFormatter stringFromDate:startDate];
            
            if (![NullChecker isNull:convertedStartDateString]) {
                
                [tempOPWCDDetailsarray addObject:convertedStartDateString];
                
            }
            else{
                
                [tempOPWCDDetailsarray addObject:@""];
                
            }
            
            
            [tempOPWCDDetailsarray addObject:wcmFromTimeTextfield.text];
            
            
            NSString *convertedEndDateString = [dateFormatter stringFromDate:endDate];
            
            if (![NullChecker isNull:convertedEndDateString]) {
                [tempOPWCDDetailsarray addObject:convertedEndDateString];
            }
            else{
                
                [tempOPWCDDetailsarray addObject:@""];
                
            }
            
            [tempOPWCDDetailsarray addObject:wcmToTimeTextfield.text];
            
            
            
            if (isolationPriorityId.length) {
                [tempOPWCDDetailsarray addObject:isolationPriorityId];//priok
            }
            else{
                [tempOPWCDDetailsarray addObject:@""];
            }
            
            [tempOPWCDDetailsarray addObject:isolationPriorityTextfield.text];//priokx
            
            [tempOPWCDDetailsarray addObject:@"0"];//rctime
            
            [tempOPWCDDetailsarray addObject:@""];//rcunit
            
            [tempOPWCDDetailsarray addObject:@""];//objnr
            
            if (!changeWorkApprovalFlag) {
                
                [tempOPWCDDetailsarray addObject:@""];//refobj
                
            }
            else{
                
                [tempOPWCDDetailsarray addObject:applicationObjArt];//refobj
                
            }
            
            
            [tempOPWCDDetailsarray addObject:@""];//crea
            
            
            if (isolationSetPreparedString.length) {
                [tempOPWCDDetailsarray addObject:isolationSetPreparedString];  //prep
            }
            else{
                [tempOPWCDDetailsarray addObject:@""];
            }
            
            
            [tempOPWCDDetailsarray addObject:@""];//comp
            
            [tempOPWCDDetailsarray addObject:@""]; //appr
            
            [tempOPWCDDetailsarray addObject:@"I"];//action
            
            
            if (isolationUserGroupID.length) {
                
                [tempOPWCDDetailsarray addObject:isolationUserGroupID];//begru
                
            }
            else{
                
                [tempOPWCDDetailsarray addObject:@""];//begru
                
            }
            
            [tempOPWCDDetailsarray addObject:isolationUsergroupTexField.text];//begrutx
            
            [tempOPWCDDetailsarray addObject:taggingTextView.text];//Tagging Text
            [tempOPWCDDetailsarray addObject:untaggingTextView.text];//UnTagging Text
            
            
            //            for (int i=0; i<[self.permitsOperationWCD count]; i++)
            //            {
            //                waSelectedIndex=i;
            //            }
            
            if ([self.permitsOperationWCD count]) {
                
                [[self.permitsOperationWCD objectAtIndex:waSelectedIndex] replaceObjectAtIndex:0 withObject:tempOPWCDDetailsarray];
            }
            else{
                
                [self.permitsOperationWCD addObject:[NSMutableArray array]];
                
                for (int i=0; i<[self.permitsOperationWCD count]; i++)
                {
                    waSelectedIndex=i;
                }
                
                [[self.permitsOperationWCD objectAtIndex:waSelectedIndex]  addObject:tempOPWCDDetailsarray];
                
                [[self.permitsOperationWCD objectAtIndex:waSelectedIndex]  addObject:[NSArray array]];
                
             }
            
            // [[self.permitsOperationWCD objectAtIndex:waSelectedIndex]  addObject:tempOPWCDDetailsarray];
         }
        
       //  [operationWCDTableView reloadData];
   }



- (IBAction)setPreparedIsolationClicked:(id)sender
{
        if (!setPreparedIsolationFlag) {
            [isolationSetPreparedBtn setImage:[UIImage imageNamed:@"set_prepared_enable_icon"] forState:UIControlStateNormal];
            isolationSetPreparedString=@"X";
 
            setPreparedIsolationFlag=YES;

            tagBtn.hidden=NO;
        }
        else
        {
            [isolationSetPreparedBtn setImage:[UIImage imageNamed:@"set_prepared_disable_icon"] forState:UIControlStateNormal];
            isolationSetPreparedString=@"";
           
            setPreparedIsolationFlag=NO;

            tagBtn.hidden=YES;
            taggedBtn.hidden=YES;
            unTagBtn.hidden=YES;
            unTaggedBtn.hidden=YES;
        }
  }

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (tableView==applicationsTableview) {

        return [self.applicationTypesArray count];

     }
    else if (tableView==checkPointTableView){
        
        if (checkPointTableView.tag==0) {
            
            return[[self.hazardsControlSCheckpointsArray firstObject] count];
        }
        else if (checkPointTableView.tag==1){
            
            return [[self.hazardsControlSCheckpointsArray lastObject] count];
        }
    }
    else if (tableView == self.dropDownTableView) {
        
        return [self.dropDownArray count];
    }
    
    else if (tableView==operationWCDTableView){
        
        if ([self.permitsOperationWCD count]) {
            
            return [[[self.permitsOperationWCD objectAtIndex:waSelectedIndex] lastObject] count];
        }
    }
    
    else if (tableView==taggingConditionsTableView){
        
        return[self.taggingConditionsDetailsArray count];
    }
    
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

     if (tableView==applicationsTableview) {
        
        static NSString *CellIdentifier = @"Cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell==nil) {
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        cell.textLabel.text= cell.textLabel.text = [NSString stringWithFormat:@"%@-%@",[[self.applicationTypesArray objectAtIndex:indexPath.row] objectAtIndex:4],[[self.applicationTypesArray objectAtIndex:indexPath.row] objectAtIndex:3]];
        
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
         
         //          [cell.noBtn addTarget:self action:@selector(radioBoxNoClicked:)   forControlEvents:UIControlEventTouchDown];
         //
         //          [cell.naBtn addTarget:self action:@selector(radioBoxNAClicked:)   forControlEvents:UIControlEventTouchDown];
         
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
                 
                 [cell.yesBtn  setImage:[UIImage imageNamed:@"CheckBoxSelection"]   forState:UIControlStateNormal];
                 
                 //  [cell.noBtn  setImage:[UIImage imageNamed:@"radiounselection.png"]   forState:UIControlStateNormal];
                 
             }
             else if ([[[[self.hazardsControlSCheckpointsArray firstObject] objectAtIndex:indexPath.row] objectAtIndex:5] isEqualToString:@"N"]) {
                 
                 //  [cell.noBtn  setImage:[UIImage imageNamed:@"radioselection.png"]   forState:UIControlStateNormal];
                 
                 [cell.yesBtn  setImage:[UIImage imageNamed:@"checkBoxUnSelection"]   forState:UIControlStateNormal];
                 
             }
             else{
                 
                 
                 [cell.yesBtn  setImage:[UIImage imageNamed:@"checkBoxUnSelection"]   forState:UIControlStateNormal];
                 
                 //   [cell.noBtn  setImage:[UIImage imageNamed:@"radiounselection.png"]   forState:UIControlStateNormal];
             }
             
             if ([[[[self.hazardsControlSCheckpointsArray firstObject] objectAtIndex:indexPath.row] objectAtIndex:14] isEqualToString:@""]) {
                 
                 [cell.yesBtn setUserInteractionEnabled:NO];
                 [cell.noBtn setUserInteractionEnabled:NO];
                 
             }
         }
         else if (checkPointTableView.tag==1){
             
             cell.checkPointLabel.text=[[[self.hazardsControlSCheckpointsArray lastObject] objectAtIndex:indexPath.row] objectAtIndex:6];
             
             if ([[[[self.hazardsControlSCheckpointsArray lastObject] objectAtIndex:indexPath.row] objectAtIndex:5] isEqualToString:@"Y"]||[[[[self.hazardsControlSCheckpointsArray lastObject] objectAtIndex:indexPath.row] objectAtIndex:13] isEqualToString:@"X"]) {
                 
                 [cell.yesBtn  setImage:[UIImage imageNamed:@"CheckBoxSelection"]   forState:UIControlStateNormal];
                 
                 //  [cell.noBtn  setImage:[UIImage imageNamed:@"radiounselection.png"]   forState:UIControlStateNormal];
                 
                 // [cell.naBtn  setImage:[UIImage imageNamed:@"checkbox_unselected.png"]   forState:UIControlStateNormal];
             }
             else if ([[[[self.hazardsControlSCheckpointsArray lastObject] objectAtIndex:indexPath.row] objectAtIndex:5] isEqualToString:@"N"]||[[[[self.hazardsControlSCheckpointsArray lastObject] objectAtIndex:indexPath.row] objectAtIndex:13] isEqualToString:@"X"]) {
                 
                 //   [cell.noBtn  setImage:[UIImage imageNamed:@"radioselection.png"]   forState:UIControlStateNormal];
                 
                 [cell.yesBtn  setImage:[UIImage imageNamed:@"checkBoxUnSelection"]   forState:UIControlStateNormal];
                 
                 //  [cell.naBtn  setImage:[UIImage imageNamed:@"checkbox_unselected.png"]   forState:UIControlStateNormal];
             }
             else{
                 
                 //  [cell.naBtn  setImage:[UIImage imageNamed:@"checkbox_selected.png"]   forState:UIControlStateNormal];
                 
                 [cell.yesBtn  setImage:[UIImage imageNamed:@"checkBoxUnSelection"]   forState:UIControlStateNormal];
                 
                 // [cell.noBtn  setImage:[UIImage imageNamed:@"radiounselection.png"]   forState:UIControlStateNormal];
             }
             
             if ([[[[self.hazardsControlSCheckpointsArray lastObject] objectAtIndex:indexPath.row] objectAtIndex:14] isEqualToString:@""]) {
                 
                 [cell.yesBtn setUserInteractionEnabled:NO];
                 [cell.noBtn setUserInteractionEnabled:NO];
                 
             }
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
    
      else if (tableView==operationWCDTableView){
          
          if (operationWCDTableView.contentSize.height < operationWCDTableView.frame.size.height) {
              operationWCDTableView.scrollEnabled = NO;
          }
          else
              operationWCDTableView.scrollEnabled = YES;
          
          static NSString *CellIdentifier = @"Cell";
          
          OperationWCDTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
          
          
          if (cell==nil) {
              cell=[[OperationWCDTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
          }
          
          cell.accessoryType = UITableViewCellAccessoryNone;
          
          if (indexPath.row % 2 == 0){
              cell.backgroundColor =UIColorFromRGB(249, 249, 249);
          }
          else {
              cell.backgroundColor =[UIColor whiteColor];
          }
          
          cell.selectionStyle=UITableViewCellSelectionStyleNone;
 
          cell.accessoryType = UITableViewCellAccessoryNone;
          
          [cell.tagBtn addTarget:self action:@selector(checkBoxOperationWCDClicked:)   forControlEvents:UIControlEventTouchDown];
          
          cell.opwcdContentView.layer.cornerRadius = 2.0f;
          cell.opwcdContentView.layer.masksToBounds = YES;
          cell.opwcdContentView.layer.borderColor = [[UIColor darkGrayColor] CGColor];
          cell.opwcdContentView.layer.borderWidth = 1.0f;
 
          if ([self.permitsOperationWCD count]) {
              
              cell.typeLabel.text=[[[[self.permitsOperationWCD objectAtIndex:waSelectedIndex] lastObject] objectAtIndex:indexPath.row] objectAtIndex:8];
              
              cell.objectLabel.text=[[[[self.permitsOperationWCD objectAtIndex:waSelectedIndex] lastObject] objectAtIndex:indexPath.row] objectAtIndex:7];
              
              cell.OGLabel.text=[[[[self.permitsOperationWCD objectAtIndex:waSelectedIndex] lastObject] objectAtIndex:indexPath.row] objectAtIndex:10];
              
              cell.tagUnLabel.text=[NSString stringWithFormat:@"%@/%@",[[[[self.permitsOperationWCD objectAtIndex:waSelectedIndex] lastObject] objectAtIndex:indexPath.row] objectAtIndex:12],[[[[self.permitsOperationWCD objectAtIndex:waSelectedIndex] lastObject] objectAtIndex:indexPath.row] objectAtIndex:17]];
           }
 
          return cell;
      }
    
    
      else if (tableView==taggingConditionsTableView){
          
          if (taggingConditionsTableView.contentSize.height < taggingConditionsTableView.frame.size.height) {
              taggingConditionsTableView.scrollEnabled = NO;
          }
          else
              taggingConditionsTableView.scrollEnabled = YES;
          
          
          static NSString *CellIdentifier = @"Cell";
          
          TaggingConditionTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
          
          
          if (cell==nil) {
              cell=[[TaggingConditionTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
          }
          
          if (indexPath.row % 2 == 0){
              cell.backgroundColor =UIColorFromRGB(249, 249, 249);
          }
          else {
              cell.backgroundColor =[UIColor whiteColor];
          }
          
          cell.accessoryType = UITableViewCellAccessoryNone;
          cell.selectionStyle=UITableViewCellSelectionStyleNone;
          
          
        
          
          cell.ogLabel.text=[NSString stringWithFormat:@"%@",[[self.taggingConditionsDetailsArray objectAtIndex:indexPath.row] objectAtIndex:1]];
          
          cell.tagLabel.text=[NSString stringWithFormat:@"%@",[[self.taggingConditionsDetailsArray objectAtIndex:indexPath.row] objectAtIndex:2]];
          
          cell.unTagLabel.text=[NSString stringWithFormat:@"%@",[[self.taggingConditionsDetailsArray objectAtIndex:indexPath.row] objectAtIndex:4]];
          
          
          return cell;
          
      }
 
     return nil;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView==applicationsTableview) {
        
//        res_obj.applicationTypeString=[[self.applicationTypesArray objectAtIndex:indexPath.row] objectAtIndex:4];
//        res_obj.applicationObjArt=[[self.applicationTypesArray objectAtIndex:indexPath.row] objectAtIndex:2];
//        res_obj.applicationTypesArray=[NSArray arrayWithArray:[self.applicationTypesArray objectAtIndex:indexPath.row]];
//
 
        applicationBtn.hidden=YES;
        
        applicationTypeString=[[self.applicationTypesArray objectAtIndex:indexPath.row] objectAtIndex:4];
        
        applicationObjArt=[[self.applicationTypesArray objectAtIndex:indexPath.row] objectAtIndex:2];
        
        wcmScrollView.contentInset=UIEdgeInsetsMake(0.0,0.0,400,0.0);
        
        NSArray *wcmUsageId;
        
        if (self.iwerkString.length&&applicationTypeString.length&&applicationObjArt.length) {
            
          wcmUsageId=[[DataBase sharedInstance] fetchWCMCCOData:self.iwerkString forApplicationType:applicationTypeString withObjArt:applicationObjArt];
         }
        
        NSArray *wcmUsagetext;
 
        if ([wcmUsageId count]) {
 
            wcmUsagetext=[[DataBase sharedInstance] getWCMUsageswithPlantTextforId:[[wcmUsageId objectAtIndex:0] objectForKey:@"wcmuse"] withIwerk:self.iwerkString];
         }
        
         if ([wcmUsageId count]&&[wcmUsagetext count]) {
            
            wcmUsageTextField.text=[NSString stringWithFormat:@"%@",[[wcmUsagetext objectAtIndex:0] objectAtIndex:3]];
            wcmUsageID=[[wcmUsageId objectAtIndex:0] objectForKey:@"wcmuse"];
 
        }
        
        setPreparedBtn.hidden=NO;
 
        [self addWorkApprovaslDataClicked];
        
        if ([applicationTypeString isEqualToString:@"1"])
        {
            
            setPreparedBtn.hidden=YES;
            
            standardCheckPointBtn.hidden=NO;
            opWCDBtn.hidden=NO;
            isolationlistBtn.hidden=NO;
            menuButton.hidden=NO;
        //  isolationHeaderLabel.text=[[self.applicationTypesArray objectAtIndex:indexPath.row] objectAtIndex:3];
 
            [workApprovalHeaderView setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
             [self.view addSubview:workApprovalHeaderView];
            
        }
        else
        {
            isolationlistBtn.hidden=YES;
            
            setPreparedBtn.hidden=NO;
 
            opWCDBtn.hidden=YES;
            standardCheckPointBtn.hidden=NO;
             wcmUsergrouptextField.text=@"";
             menuButton.hidden=YES;
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
        
        // headerWorkApprovalLabel.text=[[self.applicationTypesArray objectAtIndex:res_obj.selectedIndex] objectAtIndex:3];
        
        [applicationTypeView removeFromSuperview];
 
         wcmScrollView.contentInset=UIEdgeInsetsMake(0.0,0.0,400,0.0);

        [workApprovalHeaderView setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        
         [self.view addSubview:workApprovalHeaderView];
       }
       else if (tableView == self.dropDownTableView) {
        
        switch ([self.dropDownTableView tag]) {
                
            case ORDER_WCM_TYPE:
                
                opWcdTypeTexfield.text = [NSString stringWithFormat:@"%@",[[self.dropDownArray objectAtIndex:indexPath.row] objectAtIndex:1]];
                
                opWCDObjectID=[NSString stringWithFormat:@"%@",[[self.dropDownArray objectAtIndex:indexPath.row] objectAtIndex:0]];
 
                 taggedBarcodeBtn.hidden=YES;
 
                if ([opWCDObjectID isEqualToString:@"E"]) {
                    
                    opWcdObjectTextField.text=[[self.headerDetailsArray objectAtIndex:3] objectAtIndex:2];
                    taggedBarcodeBtn.hidden=NO;
                    scanFlag=YES;
                    
                }
                else if ([opWCDObjectID isEqualToString:@"F"]){
                    opWcdObjectTextField.text=[[self.headerDetailsArray objectAtIndex:4] objectAtIndex:2];
                }
                
                [opWcdTypeTexfield resignFirstResponder];
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
    
    else if (tableView==taggingConditionsTableView){
        
        opWCDTagTextfield.text=[NSString stringWithFormat:@"%@",[[self.taggingConditionsDetailsArray objectAtIndex:indexPath.row] objectAtIndex:2]];
        
        oGstring=[[self.taggingConditionsDetailsArray objectAtIndex:indexPath.row] objectAtIndex:1];
        
        opWcdUnTagTextfield.text=[NSString stringWithFormat:@"%@",[[self.taggingConditionsDetailsArray objectAtIndex:indexPath.row] objectAtIndex:4]];
        
        tgTypString=[NSString stringWithFormat:@"%@",[[self.taggingConditionsDetailsArray objectAtIndex:indexPath.row] objectAtIndex:3]];
        
        unTypString=[NSString stringWithFormat:@"%@",[[self.taggingConditionsDetailsArray objectAtIndex:indexPath.row] objectAtIndex:5]];
        
        phblghbString=[NSString stringWithFormat:@"%@",[[self.taggingConditionsDetailsArray objectAtIndex:indexPath.row] objectAtIndex:6]];
        
        [taggingConditionsView removeFromSuperview];
    }
   }

-(void)insertCreatePermitsData{
    
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDAnimationFade;
    hud.label.text = @"Permits Creation in progress...";

    
        if (self.orderHeaderDetails == nil) {
            self.orderHeaderDetails = [[NSMutableDictionary alloc] init];
         }
 
        [self.orderHeaderDetails setObject:self.orderNumberString forKey:@"OBJECTID"];
        [self.orderHeaderDetails setObject:self.workApprovalDetailsArray forKey:@"WCMWORKAPPROVALS"];
        [self.orderHeaderDetails setObject:self.workApplicationDetailsArray forKey:@"WCMWORKAPPlICATIONS"];
        [self.orderHeaderDetails setObject:[NSMutableArray new] forKey:@"WCMISSUEPERMITS"];
        [self.orderHeaderDetails setObject:self.permitsOperationWCD forKey:@"WCMOPERATIONWCD"];
    
        [self.orderHeaderDetails setObject:decryptedUserName forKey:@"REPORTEDBY"];


        if([[ConnectionManager defaultManager] isReachable])
        {
            NSMutableDictionary *endPointDictionary = [NSMutableDictionary new];
            [endPointDictionary setObject:@"U" forKey:@"ACTIVITY"];
            [endPointDictionary setObject:@"D8" forKey:@"DOCTYPE"];
            [endPointDictionary setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"ENDPOINT"] forKey:@"ENDPOINT"];
            NSArray *endPointArray = [[DataBase sharedInstance] getEndPointURL:endPointDictionary];
            NSLog(@"endPoint :%@",[[endPointArray objectAtIndex:0] objectAtIndex:0]);
            [self.orderHeaderDetails setObject:[[endPointArray objectAtIndex:0] objectAtIndex:0] forKey:@"URL_ENDPOINT"];
            [self.orderHeaderDetails setObject:@"" forKey:@"TRANSMITTYPE"];

            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"CSRF"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [Request makeWebServiceRequest:PERMIT_CREATE parameters:self.orderHeaderDetails delegate:self];
         }else{
            
         }
  }

-(void)checkBoxOperationWCDClicked:(id)sender{
    
    NSIndexPath *ip = [self GetCellFromTableView:operationWCDTableView Sender:sender];
 //   NSInteger i = ip.row;
    
    tagSelectedIndex=(int)ip.row;
    
 
    UIButton *taggingConditionsButton = (UIButton*)sender;
 
      //  taggingConditionsButton.userInteractionEnabled = YES;
    
       // removeTaggingConditionsButton.hidden = NO;
        plusTaggingConditionsBtn.hidden=NO;
        
        if ([taggingConditionsButton.titleLabel.text isEqualToString:@"Tag"]) {
            
            [taggingConditionsButton setTitle:@"Tagged" forState:UIControlStateNormal];
            
            btgString = @"X";
            etgString = @"";
            bugString = @"";
            eugString = @"";
        }
        else if ([taggingConditionsButton.titleLabel.text isEqualToString:@"Tagged"]) {
            
            if (createOrderFlag) {
                
                [taggingConditionsButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
                
                taggingConditionsButton.userInteractionEnabled = NO;
                
                etgString = @"X";
                bugString = @"";
                eugString = @"";
                
              
//                removeTaggingConditionsButton.hidden = YES;
//                plusTaggingConditionsBtn.hidden=YES;
                
            }
            else{
                
                [taggingConditionsButton setTitle:@"UnTag" forState:UIControlStateNormal];
                
                btgString = @"";
                etgString = @"";
                bugString = @"X";
                eugString = @"";
            }
        }
        else if ([taggingConditionsButton.titleLabel.text isEqualToString:@"UnTag"] ) {
            
            [taggingConditionsButton setTitle:@"UnTagged" forState:UIControlStateNormal];
            
            bugString = @"X";
            eugString = @"";
            
            
        }
        else if ([taggingConditionsButton.titleLabel.text isEqualToString:@"UnTagged"]) {
            
            [taggingConditionsButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            
            taggingConditionsButton.userInteractionEnabled = NO;
            
            btgString = @"";
            etgString = @"X";
            bugString = @"X";
            eugString = @"X";
            
//            removeTaggingConditionsButton.hidden = YES;
//            plusTaggingConditionsBtn.hidden=YES;
            
        }
 
 
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


-(void)addWorkApprovaslDataClicked
{

    if ([self.createOrderString isEqualToString:@"X"]) {
        
        wcmFunctionLocationTextfield.text=[[self.headerDetailsArray objectAtIndex:2] objectAtIndex:3];
        wcmPriorityTextfield.text=[[self.headerDetailsArray objectAtIndex:4] objectAtIndex:2];
        wcmPriorityId=[[self.headerDetailsArray objectAtIndex:4] objectAtIndex:2];

        if ([self.equpmentEnableString isEqualToString:@"X"]) {
            
            wcmPriorityTextfield.text=[[self.headerDetailsArray objectAtIndex:3] objectAtIndex:2];
            wcmPriorityId=[[self.headerDetailsArray objectAtIndex:3] objectAtIndex:3];
          }
        
     }
    
    else{
        
         wcmFunctionLocationTextfield.text=[[self.headerDetailsArray objectAtIndex:3] objectAtIndex:3];
        
         wcmPriorityTextfield.text=[[self.headerDetailsArray objectAtIndex:5] objectAtIndex:2];
         wcmPriorityId=[[self.headerDetailsArray objectAtIndex:5] objectAtIndex:3];
        
        
        if ([self.equpmentEnableString isEqualToString:@"X"]) {
            
            wcmPriorityTextfield.text=[[self.headerDetailsArray objectAtIndex:4] objectAtIndex:2];
            wcmPriorityId=[[self.headerDetailsArray objectAtIndex:4] objectAtIndex:3];
        }
      }
    
    wcmShortTextField.text=[[self.headerDetailsArray objectAtIndex:1] objectAtIndex:2];
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
            wcmFromTimeTextfield.text=@"60000";
            wcmToTimeTextfield.text=@"140000";
            NSLog(@"Shift A");
        }
        else
        {
            wcmFromTimeTextfield.text=@"220000";
            wcmToTimeTextfield.text=@"60000";
            NSLog(@"Shift C");
        }
    }
    else if (currentHour >14 && (currentMinute >=0 || currentSecond >=0))
    {
        if ((currentHour < 22 && (currentMinute >=0 || currentSecond >= 0)) || (currentHour == 22 && (currentMinute == 0 && currentSecond == 0)))
        {
            wcmFromTimeTextfield.text=@"140000";
            wcmToTimeTextfield.text=@"220000";
            NSLog(@"Shift B");
        }
        else
        {
            wcmFromTimeTextfield.text=@"220000";
            wcmToTimeTextfield.text=@"60000";
            NSLog(@"Shift C");
         }
    }
    
}



-(NSIndexPath *) GetCellFromTableView: (UITableView *)tableView Sender:(id)sender
{
    CGPoint position = [sender convertPoint:CGPointZero toView:tableView];
    NSIndexPath *indexPath = [tableView indexPathForRowAtPoint:position];
    return indexPath;//[tableView cellForRowAtIndexPath:indexPath];
}


-(void)radioBoxYesClicked:(id)sender{
    
    NSIndexPath *ip = [self GetCellFromTableView:checkPointTableView Sender:sender];
    NSInteger i = ip.row;
    
    UIButton *tappedButton = (UIButton*)sender;
    
    if([tappedButton.currentImage isEqual:[UIImage imageNamed:@"checkBoxUnSelection"]]) {
        
        // [sender  setImage:[UIImage imageNamed: @"CheckBoxSelection"] forState:UIControlStateNormal];
        
        if (checkPointTableView.tag==0) {
            
            checkPointFlag=YES;
            
            [[[self.hazardsControlSCheckpointsArray firstObject] objectAtIndex:i] replaceObjectAtIndex:5 withObject:@"Y"];
            
        }
        else if (checkPointTableView.tag==1){
            
            checkPointFlag=NO;
            
            [[[self.hazardsControlSCheckpointsArray lastObject] objectAtIndex:i] replaceObjectAtIndex:5 withObject:@"Y"];
        }
        
        
    }
    else
    {
        // [sender setImage:[UIImage imageNamed:@"checkBoxUnSelection"]forState:UIControlStateNormal];
        
        if (checkPointTableView.tag==0) {
            
            checkPointFlag=YES;
            
            [[[self.hazardsControlSCheckpointsArray firstObject] objectAtIndex:i] replaceObjectAtIndex:5 withObject:@""];
            
        }
        else if (checkPointTableView.tag==1){
            
            checkPointFlag=NO;
            
            [[[self.hazardsControlSCheckpointsArray lastObject] objectAtIndex:i] replaceObjectAtIndex:5 withObject:@""];
        }
        
    }
    
     [checkPointTableView reloadData];
 }


#pragma mark-
#pragma mark- result data

-(void)resultData:(NSDictionary *)resultData withErrorDescription:(NSString *)errorDescription requestID:(WebServiceRequest)requestID :(int)statusCode
{
    switch (requestID)
    {
        case PERMIT_CREATE:
 
            if (statusCode == 401) {
                
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                
                [self showAlertMessageWithTitle:@"Authentication Failed!!" message:@"kindly check your password" cancelButtonTitle:@"Ok" withactionType:@"Single" forMethod:nil];
                
                return;
            }
            
            else if (statusCode==400){
                
                [self showAlertMessageWithTitle:@"Error" message:@"Failed to Create Order" cancelButtonTitle:@"Ok" withactionType:@"Single" forMethod:nil];
                
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                
                
            }
            
            if (!errorDescription.length) {
                
                NSMutableDictionary *parsedDictionary = [[Response sharedInstance] parseForCreateOrder:resultData];
                
                if ([parsedDictionary objectForKey:@"OBJECTID"]) {
                    
                    NSString *objectId=[parsedDictionary objectForKey:@"OBJECTID"];
                    
                    if ([[parsedDictionary objectForKey:@"OBJECTID"] isKindOfClass:[NSArray class]]) {
                        
                        objectId=[[parsedDictionary objectForKey:@"OBJECTID"] objectAtIndex:0];
                     }
                    
                    if([[DataBase sharedInstance] updateOrderWithObjectid:objectId forHeaderID:[self.orderHeaderDetails objectForKey:@"ID"]])
                    {
                        [[DataBase sharedInstance] updateSyncLogForCategory:@"Order" action:@"Create" objectid:objectId UUID:[self.orderHeaderDetails objectForKey:@"ID"]];
                        
 
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
                            [dateFormate setDateFormat:@"yyyyMMdd"];
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
                                    
                                    [currentHeaderDictionary setObject:@"" forKey:@"POSID"];
                                    if ([headerDictionary objectForKey:@"Posid"]) {
                                        
                                        [currentHeaderDictionary setObject:[headerDictionary objectForKey:@"Posid"] forKey:@"POSID"];
                                    }
                                    
                                    [currentHeaderDictionary setObject:@"" forKey:@"REVNR"];
                                    if ([headerDictionary objectForKey:@"REVNR"]) {
                                        
                                        [currentHeaderDictionary setObject:[headerDictionary objectForKey:@"REVNR"] forKey:@"REVNR"];
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
                            
 
                            for (int i=0; i<[objectIds count]; i++) {
                                
                                if (i ==1) {
                                    
                                    [orderWcmOperationWCDTaggingConditionsArray removeAllObjects];
                                    [orderWcmPermitsStandardCheckPoints removeAllObjects];
                                }
                                
                                [[DataBase sharedInstance] insertDataIntoOrderHeader:[[orderDetailDictionary objectForKey:[objectIds objectAtIndex:i]] firstObject] withAttachments:[[orderDetailDictionary objectForKey:[objectIds objectAtIndex:i]] objectAtIndex:2] withPermitWorkApprovalsDetails:[[orderDetailDictionary objectForKey:[objectIds objectAtIndex:i]] objectAtIndex:1] withOperation:[[orderDetailDictionary objectForKey:[objectIds objectAtIndex:i]] objectAtIndex:3] withParts:[[orderDetailDictionary objectForKey:[objectIds objectAtIndex:i]] objectAtIndex:4] withWSM:[[orderDetailDictionary objectForKey:[objectIds objectAtIndex:i]] objectAtIndex:5] withObjects:[[orderDetailDictionary objectForKey:[objectIds objectAtIndex:i]] objectAtIndex:7] withSystemStatus:[[orderDetailDictionary objectForKey:[objectIds objectAtIndex:i]] objectAtIndex:6] withPermitsWorkApplications:[[orderDetailDictionary objectForKey:[objectIds objectAtIndex:i]] objectAtIndex:8] withIssuePermits:[[orderDetailDictionary objectForKey:[objectIds objectAtIndex:i]] objectAtIndex:9] withPermitsOperationWCD:[[orderDetailDictionary objectForKey:[objectIds objectAtIndex:i]] objectAtIndex:10] withPermitsOperationWCDTagiingConditions:orderWcmOperationWCDTaggingConditionsArray withPermitsStandardCheckPoints:orderWcmPermitsStandardCheckPoints withMeasurementDocs:[[orderDetailDictionary objectForKey:[objectIds objectAtIndex:i]] objectAtIndex:11]];
                            }
                            
 
                            if ([[[parsedDictionary objectForKey:@"MESSAGE"] substringToIndex:1] isEqualToString:@"S"]) {
                                
                                [self showAlertMessageWithTitle:@"Success" message:[[parsedDictionary objectForKey:@"MESSAGE"] substringFromIndex:1] cancelButtonTitle:@"Ok" withactionType:@"Single" forMethod:@"Create Order Sucess"];
                                
                            }
                            else{
                                
                                [self showAlertMessageWithTitle:@"Error" message:[[parsedDictionary objectForKey:@"MESSAGE"] substringFromIndex:1] cancelButtonTitle:@"Ok" withactionType:@"Single" forMethod:@"Create Order Sucess"];
                            }
                        }
                        
                    }
                }
                else if ([parsedDictionary objectForKey:@"ERROR"] || [parsedDictionary objectForKey:@"MESSAGE"]){
                    
                   // [[DataBase sharedInstance] updateSyncLogErrorForCategory:@"Order" action:@"Create" objectid:@"" UUID:[self.orderHeaderDetails objectForKey:@"ID"] message:[[parsedDictionary objectForKey:@"MESSAGE"] substringFromIndex:1] Date:[self.orderHeaderDetails objectForKey:@"DATE"] timestamp:[self.orderHeaderDetails objectForKey:@"TIME"]];
                    
                    if ([parsedDictionary objectForKey:@"MESSAGE"])
                    {
                        
                        [self showAlertMessageWithTitle:@"Order is not Created" message:[[parsedDictionary objectForKey:@"MESSAGE"] substringFromIndex:1] cancelButtonTitle:@"OK" withactionType:@"Single" forMethod:nil];
                    }
                    else{
                        
                        [self showAlertMessageWithTitle:@"Order is not Created" message:[parsedDictionary objectForKey:@"ERROR"] cancelButtonTitle:@"OK" withactionType:@"Single" forMethod:nil];
                    }
                }
                
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            }
            
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
