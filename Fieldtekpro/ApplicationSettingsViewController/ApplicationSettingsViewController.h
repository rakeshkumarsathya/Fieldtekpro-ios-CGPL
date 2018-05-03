//
//  ApplicationSettingsViewController.h
//  PMCockpit
//
//  Created by Enstrapp on 24/03/15.
//  Copyright (c) 2015 Enstrapp IT Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <MessageUI/MessageUI.h>

@interface ApplicationSettingsViewController : UIViewController<UITextFieldDelegate,MFMailComposeViewControllerDelegate>
{
    BOOL activelogsCheckBoxSelected,geoCoordinatesCheckBoxSelected,sapUserCheckBoxSelected,intialdataLoadCheckBoxSeleted,refreshCheckBoxSeleted;
    NSString *activelogsCheckBoxString,*geoCoordinatesCheckBoxString,*sapUserCheckBoxString,*intialdataLoadCheckBoxString,*refreshCheckBoxString;
    IBOutlet UIButton *activelogsCheckbox,*geoCordinatesCheckbox,*sapUserCheckbox,*emailLogs,*intialdataLoadCheck,*refreshCheck;
    IBOutlet UISegmentedControl *segmentController;
    IBOutlet UITextField *hostID,*portID,*dataSourceID,*endPointID,*deleteLogsID;
    int clickedSegment;
    
    NSMutableArray *appSetttingsArray;
    IBOutlet UIScrollView *applicationsSettingsScrollView;
    
    IBOutlet UITableView *applicationsSettingsTableView;

    
    NSString  *decryptedUserName;
    UIAlertView *settingsUpdateAlert;
    
    
}
@property (nonatomic,weak)id delegate;
-(IBAction)dismissView:(id)sender;
@property (nonatomic, retain) NSMutableArray *dropDownArray,*appSettingsDataArray;
@property (nonatomic, strong) UITableView *dropDownTableView;
@property (nonatomic, strong) UIToolbar*  mypickerToolbar;

@property (weak, nonatomic) IBOutlet UITextField *pushIntervalTextField;


@end
