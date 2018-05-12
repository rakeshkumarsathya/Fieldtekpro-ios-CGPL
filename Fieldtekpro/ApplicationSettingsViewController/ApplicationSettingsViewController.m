//
//  ApplicationSettingsViewController.m
//  PMCockpit
//
//  Created by Enstrapp on 24/03/15.
//  Copyright (c) 2015 Enstrapp IT Solutions. All rights reserved.
//

#import "ApplicationSettingsViewController.h"
#import "DashBoardViewController.h"
#import "ViewController.h"
#import "ConnectionManager.h"

#import <QuartzCore/QuartzCore.h>

#define NUMBERS_ONLY @"1234567890"
#define CHARACTER_LIMIT_SYNC_COUNT 3
#define CHARACTER_LIMIT_DELETE_LOGS 2

#define isiPhone5  ([[UIScreen mainScreen] bounds].size.height == 568)?TRUE:FALSE
#define isiPhone6 ( [[UIScreen mainScreen] bounds].size.height == 667)?TRUE:FALSE
#define IS_IPHONE_6_PLUS ([[UIScreen mainScreen] bounds].size.height == 736.0)?TRUE:FALSE
#define IS_IPAD ([[UIScreen mainScreen] bounds].size.height == 1024.0)?TRUE:FALSE

@interface ApplicationSettingsViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    
    NSUserDefaults *defaults;
   
}
@end

@implementation ApplicationSettingsViewController

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    defaults = [NSUserDefaults standardUserDefaults];
    
    
    self.dropDownArray = [NSMutableArray new];
    if ([defaults objectForKey:@"PushInterval"])
    {
        self.pushIntervalTextField.text = [defaults objectForKey:@"PushInterval"];
        [defaults synchronize];
    }
    else
    {
        self.pushIntervalTextField.text = @"30";
    }

    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
       
        if (isiPhone5||isiPhone6||IS_IPHONE_6_PLUS) {
            
        }
        else
        {
            applicationsSettingsScrollView.contentInset=UIEdgeInsetsMake(0.0,0.0,130.0,0.0);
        }
    }

 
    emailLogs.layer.cornerRadius = 8.0f;
    
    sapUserCheckbox.userInteractionEnabled=NO;
    
    intialdataLoadCheckBoxSeleted = NO;
    
    refreshCheckBoxSeleted = NO;
    
    
    [self defaultApplicationSettingsData];
}

-(void)defaultApplicationSettingsData{
 
    intialdataLoadCheckBoxSeleted=NO;
    refreshCheckBoxSeleted=NO;

    
    if ([[defaults objectForKey:@"Intial_Data_Load_Check"] isEqualToString:@"X"]) {
        
        intialdataLoadCheckBoxSeleted = YES;

        [intialdataLoadCheck setImage:[UIImage imageNamed:@"CheckBoxSelection"] forState:UIControlStateNormal];
    }
    
    if ([[defaults objectForKey:@"Refresh_Check"] isEqualToString:@"X"]) {
        
        refreshCheckBoxSeleted=NO;
        [refreshCheck setImage:[UIImage imageNamed:@"CheckBoxSelection"] forState:UIControlStateNormal];
    }
    
    if ([defaults objectForKey:@"PushInterval"]) {
        
        self.pushIntervalTextField.text=[defaults objectForKey:@"PushInterval"];

    }
    
    else{
        
        self.pushIntervalTextField.text=@"30";
        
         [defaults setObject:@"30" forKey:@"PushInterval"];

    }
    
    
}

-(IBAction)segmentAction:(id)sender{
    
    segmentController=(UISegmentedControl *)sender;
    clickedSegment=(int)[segmentController selectedSegmentIndex];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)activelogsCheckMarkBtn:(id)sender
{
    [self activeLogsCheckMark];
}

-(IBAction)geoCoordinatesCheckMarkBtn:(id)sender
{
    [self geoCoordinatesCheckMark];
}

-(IBAction)sapUserCheckMarkBtn:(id)sender
{
    [self sapUserCheckMark];
}

-(IBAction)initialDataLoadCheckMarkBtn:(id)sender{
    
    [self initialDataLoadCheckMark];
}

-(IBAction)refreshCheckMarkBtn:(id)sender{
    
    [self refrshLoadCheckMark];
}

-(void)activeLogsCheckMark{
    if (activelogsCheckBoxSelected == NO)
    {
        activelogsCheckBoxSelected = YES;
        activelogsCheckBoxString = @"X";
        [activelogsCheckbox setImage:nil forState:UIControlStateNormal];
        [activelogsCheckbox setImage:[UIImage imageNamed:@"radioselection.png"] forState:UIControlStateNormal];
    }
    else
    {
        activelogsCheckBoxString = @" ";
        [activelogsCheckbox setImage:nil forState:UIControlStateSelected];
        [activelogsCheckbox setImage:[UIImage imageNamed:@"radiounselection.png"] forState:UIControlStateNormal];
        activelogsCheckBoxSelected = NO;
    }
}

-(void)geoCoordinatesCheckMark{
    if (geoCoordinatesCheckBoxSelected == NO)
    {
        geoCoordinatesCheckBoxSelected = YES;
        geoCoordinatesCheckBoxString = @"X";
        [geoCordinatesCheckbox setImage:nil forState:UIControlStateNormal];
        [geoCordinatesCheckbox setImage:[UIImage imageNamed:@"radioselection.png"] forState:UIControlStateNormal];
    }
    else
    {
        geoCoordinatesCheckBoxString = @" ";
        [geoCordinatesCheckbox setImage:nil forState:UIControlStateSelected];
        [geoCordinatesCheckbox setImage:[UIImage imageNamed:@"radiounselection.png"] forState:UIControlStateNormal];
        geoCoordinatesCheckBoxSelected = NO;
    }
 
}

-(void)sapUserCheckMark{
    
    if (sapUserCheckBoxSelected == NO)
    {
        sapUserCheckBoxSelected = YES;
        sapUserCheckBoxString = @"X";
        [sapUserCheckbox setImage:nil forState:UIControlStateNormal];
        [sapUserCheckbox setImage:[UIImage imageNamed:@"radioselection.png"] forState:UIControlStateNormal];
    }
    else
    {
        sapUserCheckBoxString = @" ";
        [sapUserCheckbox setImage:nil forState:UIControlStateSelected];
        [sapUserCheckbox setImage:[UIImage imageNamed:@"radiounselection.png"] forState:UIControlStateNormal];
        sapUserCheckBoxSelected = NO;
    }
}

-(void)initialDataLoadCheckMark{
    
    if (intialdataLoadCheckBoxSeleted == NO)
    {
        intialdataLoadCheckBoxSeleted = YES;
        intialdataLoadCheckBoxString = @"X";
        [intialdataLoadCheck setImage:nil forState:UIControlStateNormal];
        [intialdataLoadCheck setImage:[UIImage imageNamed:@"CheckBoxSelection"] forState:UIControlStateNormal];
    }
    else
    {
        intialdataLoadCheckBoxString = @" ";
        [intialdataLoadCheck setImage:nil forState:UIControlStateSelected];
        [intialdataLoadCheck setImage:[UIImage imageNamed:@"checkBoxUnSelection"] forState:UIControlStateNormal];
        intialdataLoadCheckBoxSeleted = NO;
    }
   
}

-(void)refrshLoadCheckMark{
    
    
    
    
    if (refreshCheckBoxSeleted == NO)
    {
        refreshCheckBoxSeleted = YES;
        refreshCheckBoxString = @"X";
        [refreshCheck setImage:nil forState:UIControlStateNormal];
        [refreshCheck setImage:[UIImage imageNamed:@"CheckBoxSelection"] forState:UIControlStateNormal];
    }
    else
    {
        refreshCheckBoxString = @" ";
        [refreshCheck setImage:nil forState:UIControlStateSelected];
        [refreshCheck setImage:[UIImage imageNamed:@"checkBoxUnSelection"] forState:UIControlStateNormal];
        refreshCheckBoxSeleted = NO;
    }
}

-(IBAction)resetSettingsToServer:(id)sender{
    
    refreshCheckBoxSeleted=NO;
    refreshCheckBoxString=@"";
    [refreshCheck setImage:[UIImage imageNamed:@"checkBoxUnSelection"] forState:UIControlStateNormal];

    intialdataLoadCheckBoxString = @" ";
    [intialdataLoadCheck setImage:[UIImage imageNamed:@"checkBoxUnSelection"] forState:UIControlStateNormal];
    intialdataLoadCheckBoxSeleted = NO;
    
    _pushIntervalTextField.text=@"30";
    
    [defaults removeObjectForKey:@"Intial_Data_Load_Check"];
    [defaults removeObjectForKey:@"Refresh_Check"];
    [defaults removeObjectForKey:@"PushInterval"];

      [defaults synchronize];

 
     settingsUpdateAlert = [[UIAlertView alloc]initWithTitle:@"Information" message:@"Application Settings has been Updated" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [settingsUpdateAlert show];
    
//    intialdataLoadCheckBoxSeleted = YES;
//    [self initialDataLoadCheckMark];
//
//    refreshCheckBoxSeleted = YES;
//    [self refrshLoadCheckMark];
//
//    appSetttingsArray = nil;
//    appSetttingsArray = [[NSMutableArray alloc]init];
//    [appSetttingsArray addObjectsFromArray:[[DataBase sharedInstance] getAppSettingsData]];
//
//    [defaults synchronize];
//
//    [self defaultApplicationSettingsData];


}

-(IBAction)submitSettingsToServer:(id)sender{
    
    if ([intialdataLoadCheckBoxString isEqualToString:@"X"]) {
        intialdataLoadCheckBoxSeleted = YES;
    }
    else if ([intialdataLoadCheckBoxString isEqualToString:@" "]){
        intialdataLoadCheckBoxSeleted = NO;
    }
   

    [defaults setObject:intialdataLoadCheckBoxString forKey:@"Intial_Data_Load_Check"];
    
    [defaults setObject:refreshCheckBoxString forKey:@"Refresh_Check"];
    
    [defaults setObject:_pushIntervalTextField.text forKey:@"PushInterval"];
 
    
    if ([[defaults objectForKey:@"ACTIVATELOGS"] isEqualToString:@"X"])
    {
        [[DataBase sharedInstance] writToLogFile:[NSString stringWithFormat:@"#INFO#.com.enstrapp.fieldtekpro #Activity:Application Settings  #Class:Very Important #MUser:%@  #DeviceId:%@",decryptedUserName,[defaults objectForKey:@"edeviceid"]]];
    }
    
    [defaults synchronize];
    [Response clearSharedInstance];
    
    [[DataBase sharedInstance] openLogFile];
    
    settingsUpdateAlert = [[UIAlertView alloc]initWithTitle:@"Information" message:@"Application Settings has been Updated" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [settingsUpdateAlert show];
    
}

-(IBAction)dismissView:(id)sender
{
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        
        [self.navigationController popViewControllerAnimated:YES];
    }
    else if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
    {
        [self.navigationController popViewControllerAnimated:YES];

    }
    
    else
    {
        
    }
}

-(IBAction)deviceLogs:(id)sender
{
    if([[ConnectionManager defaultManager] isReachable])
    {
        [self displayComposerSheet];
    }
    else
    {
        UIAlertView *logFileAlert=[[UIAlertView alloc]initWithTitle:@"Information" message:@"Network not available.\n Email of logs is not possible" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        
        [logFileAlert show];
    }
}

-(void)displayComposerSheet
{
    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
    
    picker.mailComposeDelegate = self;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMM dd, yyyy HH:mm:ss"];
    [dateFormatter stringFromDate:[NSDate date]];
    NSString *currentDate=[NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:[NSDate date]]];
    
    [picker setSubject:[NSString stringWithFormat:@"%@ (%@)",@"FieldTekPro Log File",currentDate]];
    
    // Set up the recipients.
    
    NSArray *toRecipients = [NSArray arrayWithObjects:@"",
                             nil];
    
    NSArray *ccRecipients = [NSArray arrayWithObjects:@"", nil];
    
    NSArray *bccRecipients = [NSArray arrayWithObjects:@"",
                              
                              nil];
    
    [picker setToRecipients:toRecipients];
    
    [picker setCcRecipients:ccRecipients];
    
    [picker setBccRecipients:bccRecipients];
    
    // Attach device Logs
    NSString *searchFilename = @"FTEKPLOG.txt";
    // Determine the file name and extension
    NSArray *filepart = [searchFilename componentsSeparatedByString:@"."];
    //NSString *filename = [filepart objectAtIndex:0];
    NSString *extension = [filepart objectAtIndex:1];
    
    // Get the resource path and read the file using NSData
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:searchFilename];
    
    if ([filePath length]) {
        
        NSData *fileData = [NSData dataWithContentsOfFile:filePath];
        
        // Determine the MIME type
        NSString *mimeType;
        if ([extension isEqualToString:@"jpg"]) {
            mimeType = @"image/jpeg";
        } else if ([extension isEqualToString:@"png"]) {
            mimeType = @"image/png";
        } else if ([extension isEqualToString:@"doc"]) {
            mimeType = @"application/msword";
        } else if ([extension isEqualToString:@"ppt"]) {
            mimeType = @"application/vnd.ms-powerpoint";
        } else if ([extension isEqualToString:@"txt"]) {
            mimeType = @"text/rtf";
        } else if ([extension isEqualToString:@"pdf"]) {
            mimeType = @"application/pdf";
        }
        
        // Add attachment
        [picker addAttachmentData:fileData mimeType:mimeType fileName:searchFilename];
        
        [picker setMessageBody:@"FieldTekPro Log File" isHTML:NO];
        
        // Present the mail composition interface.
        [self.navigationController presentViewController:picker animated:YES completion:nil];
    }
}

// The mail compose view controller delegate method

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField==deleteLogsID)
    {
        [applicationsSettingsScrollView setContentOffset:CGPointMake(0, 120)];
    }
    else if (textField == _pushIntervalTextField)
    {
        [self numberPad];
    }
      return  YES;
}// return NO to disallow editing.


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    [textField resignFirstResponder];
    [applicationsSettingsScrollView setContentOffset:CGPointMake(0,0)];
    
    return  YES;
}


-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    /*
     // Prevent crashing undo bug – see note below.
     if(range.length + range.location > textField.text.length)
     {
     return NO;
     }
     
     NSUInteger newLength = [textField.text length] + [string length] - range.length;
     return (newLength > 2) ? NO : YES;
     
     */
    if ([textField isEqual:deleteLogsID]){
        NSUInteger newLength = [textField.text length] + [string length] - range.length;
        NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:NUMBERS_ONLY] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        return (([string isEqualToString:filtered])&&(newLength <= CHARACTER_LIMIT_DELETE_LOGS));
    }
    
    return TRUE;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [applicationsSettingsScrollView setContentOffset:CGPointMake(0,0) animated:YES];
    [deleteLogsID resignFirstResponder];
    
    
    // [self.view endEditing:YES];
}

-(void)numberPad
{
    UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    numberToolbar.barStyle = UIBarStyleBlackTranslucent;
    numberToolbar.items = @[[[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelNumberPad)],
                            [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                            [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneWithNumberPad)]];
    [numberToolbar sizeToFit];
    _pushIntervalTextField.inputAccessoryView = numberToolbar;
}
-(void)cancelNumberPad{
    [_pushIntervalTextField resignFirstResponder];
    _pushIntervalTextField.text = @"30";
}

-(void)doneWithNumberPad{
    //    NSString *numberFromTheKeyboard = _pushIntervalTextField.text;
    [_pushIntervalTextField resignFirstResponder];
}

#pragma mark-
#pragma mark- UIPicker Table View Method

-(void)uiPickerTableViewForDropDownSelection{
    
    self.dropDownTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 50, 250, 300)];
    
    self.dropDownTableView.delegate=self;
    self.dropDownTableView.dataSource=self;
    
    // Create done button in UIPickerView
    
    self.mypickerToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 100, 320, 56)];
    
    self.mypickerToolbar.barStyle = UIBarStyleBlackOpaque;
    
    [self.mypickerToolbar sizeToFit];
    
    NSMutableArray *barItems = [[NSMutableArray alloc] init];
    
     UIBarButtonItem *cancelBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(pickerTableViewCancelClicked)];
    [barItems addObject:cancelBtn];

    
    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    [barItems addObject:flexSpace];
    
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(pickerTableViewdoneClicked)];
    
    [barItems addObject:doneBtn];
    
    [self.mypickerToolbar setItems:barItems animated:YES];
    
}

-(void)pickerTableViewCancelClicked
{
    [hostID resignFirstResponder];
    hostID.text=@"";
   
}

-(void)pickerTableViewdoneClicked
{
    [hostID resignFirstResponder];
    
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
