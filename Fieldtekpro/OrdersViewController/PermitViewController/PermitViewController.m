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
    
 
        self.buttonPopVC = [[PopoverViewController alloc] init];
        self.buttonPopVC.modalPresentationStyle = UIModalPresentationPopover;
        self.buttonPopVC.popoverPresentationController.sourceView = menuButton;  //rect参数是以view的左上角为坐标原点（0，0）
        self.buttonPopVC.popoverPresentationController.sourceRect = menuButton.bounds; //指定箭头所指区域的矩形框范围（位置和尺寸），以view的左上角为坐标原点
        self.buttonPopVC.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionUp; //箭头方向
        self.buttonPopVC.popoverPresentationController.delegate = self;
        [self presentViewController:self.buttonPopVC animated:YES completion:nil];
        
        popUpEnabled=YES;
    
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
            self.view.backgroundColor = [UIColor grayColor];
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
            
            [self.delegate addItemsViewController:self workApprovalsData:self.workApprovalDetailsArray withWorkApplicationsArray:self.workApplicationDetailsArray withIsolationsData:[NSMutableArray new]];
            
            [workApprovalHeaderView removeFromSuperview];
            
            [self.navigationController popViewControllerAnimated:YES];

            
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
            
            [tempOPWCDDetailsarray addObject:@""];//rctime
            
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
            
            [tempIsolationDetailsarray addObject:@""];//rctime
            
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
            
            [tempOPWCDDetailsarray addObject:@""];//rctime
            
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
        
        [self addWorkApprovaslDataClicked];
        
        if ([applicationTypeString isEqualToString:@"1"])
        {
            
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
            
            opWCDBtn.hidden=YES;
            standardCheckPointBtn.hidden=NO;
            wcmUsergrouptextField.text=@"";
             menuButton.hidden=YES;
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

    wcmShortTextField.text=[[self.headerDetailsArray objectAtIndex:1] objectAtIndex:2];
    wcmFunctionLocationTextfield.text=[[self.headerDetailsArray objectAtIndex:2] objectAtIndex:3];
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
    
    wcmPriorityTextfield.text=[[self.headerDetailsArray objectAtIndex:4] objectAtIndex:2];
 
//    if (equipmentEnableFlag) {
//
//        wcmPriorityTextfield.text=[[self.headerDetailsArray objectAtIndex:3] objectAtIndex:2];
//
//    }
//
//    else{
//
//        wcmPriorityTextfield.text=[[self.headerDetailsArray objectAtIndex:4] objectAtIndex:2];
//
//    }
    
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
