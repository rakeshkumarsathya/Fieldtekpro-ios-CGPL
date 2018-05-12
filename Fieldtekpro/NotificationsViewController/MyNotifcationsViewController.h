//
//  MyNotifcationsViewController.h
//  Fieldtekpro
//
//  Created by Deepak Gantala on 25/07/15.
//  Copyright (c) 2015 Enstrapp IT Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CreateNotificationViewController.h"
#import "NotificationObjects.h"
#import "MBProgressHUD.h"
#import "FilterWorkcenterTableViewCell.h"
#import "WorkcenterViewController.h"

//#import "ScanBarcodeViewController.h"

typedef enum HEADERDETAILSMAPPING{
    NOTIFICATIONUUID =0,
    NOTIFICATIONTYPEID = 1,
    NOTIFICATIONTYPETEXTFIELD = 2,
    NOTIFICATIONSHORTTEXTFIELD = 3,
    NOTIFICATIONLONGTEXTFILED =4,
    FUNCTIONALLOCATIONID = 5,
    FUNCTIONALLOCATIONTEXTFIELD = 6,
    EQUIPMENTID = 7,
    EQUIPMENTTEXTFIELD = 8,
    PRIORITYID = 9,
    PRIORITYTEXTFIELD = 10,
    MALFUNCTIONSTARTDATE = 11,
    MALFUNCTIONENDDATE = 12,
    BREAKDOWNCHECK = 13,
    NOTIFICATIONHEADERPLANTID = 14,
    NOTIFICATIONHEADERWORKCENTERID = 16,
    NOTIFICATIONSTATUS = 21,
    NOTIFICATIONNO =23,
    REQSTARTDATE = 25,
    REQENDDATE = 26,
    SHIFTTYPE = 27,
    NOOFPERSON = 28,
    EFFECTID = 29,
    EFFECTTEXT = 30,
    PARNRID = 31,
    PARNRTEXT = 32,
    AUFNR = 33,
    NREPORTEDBY = 34,
    PLANNERGROUPID =35,
    PLANNERGROUPNAME =36
    
}HEADERDETAILSMAPPING;

@interface MyNotifcationsViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,UIAlertViewDelegate,UITextFieldDelegate>
{
    CreateNotificationViewController *createNotification;
    
    MyNotifcationsViewController *myNotifications;
    
    IBOutlet UIView *myNotificationsHeaderView,*myNotificationsTableHeaderView,*searchBarView,*headerView_iPhone,*filterView,*sortView,*filteredHeaderView,*filterSubView;
    IBOutlet UITableView *myNotificationsTableView,*filterSortTableView;
    NSMutableArray *selectedCheckBoxArray,*filteredDataArray,*sortedDataArray,*selectedFilterSortCheckBoxArray,*syncMapDataMutableArray,*notificationSystemStatusArray;
    IBOutlet UILabel *myNotificationsCountLabel,*headerFilterlabel,*filterByLabel,*infoFilterLabel;
    BOOL notifNoSortSelected,statusSortSelected,shortTextSortSelected,prioritySortSelected,malFuncStartDateSortSelected;
    NSMutableDictionary *inputsDictionary;
    IBOutlet UIButton *notifNoSortBtn,*statusSortBtn,*shortTextSortBtn,*prioritySortBtn,*malFuncStartDateSortBtn,*checkBoxHeaderBtn,*filterBackgroundClicked,*cancelButton,*completeButton,*releaseBtn;
    
    UIAlertView *cancelAlertView,*cancelResponseAlertView,*completeAlertView,*completeResponseAlerView,*refreshAlert,*authenticationFailedAlert,*releaseAlertView,*releaseResponseAlertView;
    
    NSUserDefaults *defaults;
    NSString *decryptedUserName;
    NSUInteger releaseIndex;
    
    //Scanning
   // ScanBarcodeViewController *scanView;
    
    IBOutlet UIButton *searchBtn,*filterBtn,*sortBtn,*refreshBtn;
 
    int selectedRow;
    
    IBOutlet UIView *systemStatusView,*blackView;
    IBOutlet UITableView *systemStatusTableView;
    MBProgressHUD *hud;
    IBOutlet UIView *searchView;
    NSArray *filteredArray;
    
    NSString *aufnrString;

}

@property (nonatomic,weak)id delegate;


-(void)dismissScanView;

//Assigning Date Pickers
@property (nonatomic, retain) UIDatePicker *startDatePicker,*EndDatePicker;
@property (nonatomic, retain) NSDate *minStartDate,*minEndDate;


@property (weak, nonatomic) IBOutlet UISearchBar *notificationSearchBar;
@property (nonatomic, retain) NSMutableArray *notificationListArray;
@property (nonatomic, retain) NSMutableDictionary *notificationHeaderDetails;

@property (strong, nonatomic) UIWindow *window;


-(void)poptoMyNotificationsViewController;
-(void)dismissMyNotificationsViewController;
-(void)dismissWorkcenterView;

@end
