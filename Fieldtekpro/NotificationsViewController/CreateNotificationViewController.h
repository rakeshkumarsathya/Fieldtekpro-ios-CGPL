//
//  CreateNotificationViewController.h
//  Fieldtekpro
//
//  Created by Enstrapp Bangalore on 09/10/17.
//  Copyright © 2017 Enstrapp Bangalore. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <YAScrollSegmentControl/YAScrollSegmentControl.h>
#import "InputDropDownTableViewCell.h"
#import "SearchInputDropdownTableViewCell.h"
#import "DateandTimeTableViewCell.h"
#import "BreakDownTableViewCell.h"
#import "ListofCauseCodesTableViewCell.h"
#import "CustomInputDorpdownTableViewCell.h"
#import "TaskCodeTableViewCell.h"
#import "NullChecker.h"
#import "DataBase.h"
#import "ListOfAttachmentsCustomTableViewCell.h"
#import "ConnectionManager.h"
#import "InspectionResultTableViewCell.h"
#import "DuplicateNotificationTableViewCell.h"
#import "JEValidator.h"
#import "AppDelegate.h"
#import "FunctionLocationViewController.h"
#import "Response.h"
#import "NotifOrderTableViewCell.h"
#import "WorkcenterTableViewCell.h"
#import "OrderSystemStatusTableViewCell.h"
#import "CreateOrderViewController.h"
#import "ActivityTableViewCell.h"
#import "LongtextViewController.h"
#import "AttachmentsTableViewCell.h"

//For Activity Indicator
#import "MBProgressHUD.h"

//For QR Code Scan
#import "ScanBarcodeViewController.h"
 
//Required for Attachments
 #import "ELCImagePickerHeader.h"
#import <MobileCoreServices/MobileCoreServices.h>


typedef enum SelectedDropDown{
    
    NOTIFICATIONTYPE = 0,
    PRIORITY = 1,
    DAMAGE = 2,
    DAMAGECODE = 3,
    CAUSE = 4,
    CAUSECODE = 5,
    FUNCTIONALLOCATION = 6,
    EQUIPMENT = 7,
    OBJECTPARTGROUP=8,
    OBJECTPART=9,
    MEASURENTPOINT=10,
    EFFECT=11,
    SHIFT=12,
    TASKCODEGROUP=13,
    TASKGROUP=14,
    TASK_PROCESSOR=15,
    TASK_PLANNED_STIME=16,
    TASK_PLANNED_FTIME=17,
    TASK_COMPLETION_DATE=18,
    TASK_COMPLETION_TIME =19,
    DISMISS_ALERT_TAG =20,
    PERSON_RESONSIBLE =21,
    PLANNER_GROUP =22,
    PRIMARY_USER_RESPONSIBLE =23,
    ACTIVITY_ITEM_KEY=24,
    ACTIVITY_CODEGROUP=25,
    ACTIVITY_CODE=26
    
}SelectedDropDown;


 @interface CreateNotificationViewController : UIViewController<YAScrollSegmentControlDelegate,ELCImagePickerControllerDelegate,AVAudioPlayerDelegate,AVCaptureMetadataOutputObjectsDelegate,UIImagePickerControllerDelegate>
{
    YAScrollSegmentControl *segmentControl;
    
    IBOutlet UITableView *commomlistListTableview,*commonAddTableView,*duplicateNotificationTableView,*seachDropdownTableView,*notifSystemStatusTableView,*attachmentsTableview;
    
    NSMutableArray *headerDataArray,*addCauseCodeDataArray,*addTaskCodeDataArray,*notifInspectionArray,*addActivityArray;
    
    IBOutlet UIView *addCauseTaskView,*customHeaderView,*containerView,*submitResetView,*downloadsView,*duplicateNotificationView,*searchDropDownView;
    
    BOOL isCausecodeSelected,attachmentsFlag;
    
    //For Attachments
    NSMutableArray *arr_images,*arr_imagesDocType,*arr_onScreenImages,*arr_onScreenImagesDocType,*headerLabelsArray;
    int ySpace;
    int iSpace;
    UIView *viewImage;
    UIImageView *imageView;
    UIButton *cancelImage;    int xSpace;
    
     UIAlertView *alertPopConfirmation,*alertAttachmentItemType,*authenticationFailedAlert,*alertMonitorPopConfirmAlert;
    
    BOOL cameraFlag,imageNameFlag;
    UIAlertView *alert_Description,*alert_fail;
    UIActionSheet *uploadAction;
    NSData* pictureData;
    int imageSize,tag;
    NSString *contentData;
    NSString *str_ImageType,*notifNoString;
    
    //AttachmentItemType
    NSString *attachmentAlertTypeString;
    
    //For detailed View
    
    IBOutlet UIButton *cancelBtn,*completeBtn,*backBtn,*takeAPictureBtn,*takeAPictureTextBtn,*chooseFromGalleryBtn,*chooseFromGalleryTextBtn,*functionalLocationSeachBtn,*equipmentNoSearchBtn,*barCodeScannerBtn,*deleteCauseCodesBtn,*deleteImagesBtn,*viewAttachmentsBtn,*viewAttachmentsTextBtn,*createOrderBtn,*statusButton,*orderNoBtn,*notificationStatusBtn;
    
    int VornrItem,VornrCauseCode,VornrTaskCode,attachmentCurrentIndex,headerCommonIndex;
    
     NSString *vornrItemID,*vornrCauseCodeID,*vornrTaskID,*decryptedUserName,*costCenterID,*equipmentID,*functionalLocationID,*filteredCostCenterDescriptionString,*breakDownCheckString,*notificationNoString,*notificationHeaderPlantID,*notificationHeaderWorkCenterID,*effectIDString,*parnrIDString,*releaseCheckBoxString,*completeCheckBoxString,*suceessCheckBoxString,*transmitTypeString;
    
    UIToolbar *myDatePickerToolBar;

    NSMutableArray *searchListArray;

    NSMutableArray *notificatinDuplicateArray;

    //Assigning Strings for Header details
    NSMutableString *notificationTypeID,*priorityID,*catalogProfileID,*damageID,*damageCodeID,*causeID,*causeCodeID,*notificationUDID,*latitudesString,*longitudesString,*altitudesString,*objectPartGroupID,*objectPartID,*effectID,*shiftID,*taskGroupID,*taskCodeID,*taskProcessorID,*aufnrID,*personResponisbleID,*plannerGrouplID,*iwerkString,*primaryPersonResonsibleID;
    
   NSString *dataaArray;
    
    int currentItemIndex,currentTaskIndex;

    
    MBProgressHUD *hud;
    
    IBOutlet UIButton *editBtn,*addCauseTaskBtn,*cancelCauseTaskBtn,*xStatusBtn;
    
    BOOL customHeaderFieldFlag,customDamageFieldFlag,customCauseFieldFlag,customHeaderFieldFlagSelected,customDamageFieldFlagSelected,customCauseFieldFlagSelected,itemSelectedFlag,taskSelectedFlag,notificationTypeMFFlag,changeSegmentFlag;
    
     BOOL dateFlag,requireddateFlag,equipFlag,funcLocFlag,costCenterFuncLocFlag,breakDownCheckBoxFlag,createNotificationFlag,editBtnSelected,taskPlanDate,releaseCheckBoxFlag,completeCheckBoxFlag,succesCheckBoxFlag,monitorEquipmentFlag,equipmentRefreshButtonSelected,islevelEnabled,updateFlag;
    
    Response *res_obj;
    
    IBOutlet UISearchBar *dropDownSearchBar;

    IBOutlet UILabel *equipmentHistoryHeaderLabel,*funcLocnHeaderLabel,*notifNoLabel;
    
    int count;
    
    NSUInteger selectedInspectionIndex,funcLocTag,selectedDismissFlocIndex,selectedDropwnTag;
 
    NSMutableArray *locationIdArray;
    
    NSString *locationId,*plantID,*notifheaderStatusString,*plannerGroupNameString,*personresponsibleNameString,*primaryPersonResonsibleNameString;
    NSString *NstatusLabel;
    
    IBOutlet UIImageView *statusCodeImage;
    BOOL clearCuaseFields,equipmentFlag;
    
    NSString *activityCodegroupString,*activityCodeString;
    
    //For ActivityString
    NSString *objectPartIDString,*objectPartNameString,*damageCodeIdString,*damageNameString,*activityKeyString;
    
    BOOL updateActivityFlag;
    
    
 
}


@property (nonatomic,weak)id delegate;
-(void)dismissScanView;
-(void)dismissequipmentNumberView;

@property (weak, nonatomic) IBOutlet UIView *notifStatusView,*imageContainer,*attachmentsView,*segmentView;
@property (weak, nonatomic) UIViewController *currentViewController;
@property (weak, nonatomic) IBOutlet UIButton *statusHeaderButton;
 @property (nonatomic ,retain) NSMutableDictionary *notificationHeaderDetails;

@property (nonatomic ,retain) NSMutableDictionary *getDocumentsHeaderDetails;

@property (nonatomic, retain) UIDatePicker *startMalFunctionDatePicker,*EndMalFunctionDatePicker,*plannedDatePicker;
@property (nonatomic, retain) NSDate *minStartDate,*minEndDate;

@property (nonatomic, retain) NSArray *filteredArray;

@property (nonatomic, retain) NSString *checkListFuncLocidString,*checkListequipidString;

 
@property (nonatomic, retain) NSMutableArray *causeCodeDetailsArray,*dropDownArray,*selectedCheckBoxArray,*fileNameArray,*attachmentArray,*selectedCheckBoxImageArray,*causeCodeDetailDeleteArray,*customHeaderDetailsArray,*customDamageDetailsArray,*customCauseDetailsArray,*selectedMeasureDocsCheckBoxArray,*notifTaskCodesDetailsArray,*selectedTaskCheckBoxArray,*taskCodesDeleteDetailsArray,*equipmentHierarchyDetailsArrayLevel1,*equipmentHierarchyDetailsArrayLevel2,*equipmentHierarchyDetailsArrayLevel3,*equipmentHierarchyDetailsArrayLevel4,*notifSystemStatusArray,*customTasksDetailsArray,*functionLocationHierarchyLevel1,*functionLocationHierarchyLevel2,*functionLocationHierarchyLevel3,*functionLocationArray,*functionLocationHierarchyArray,*notifActivityDetailsArray,*itemKeyDetailsArray,*inspectionEquipmentArray;

@property (nonatomic, strong) UITableView *dropDownTableView;
@property (nonatomic, strong) UIToolbar*  mypickerToolbar,*numberToolBar;

@property (weak, nonatomic) IBOutlet UILabel *statusHeaderNumber;

@property (nonatomic, strong) IBOutlet UISegmentedControl *sysytemStatusSegmentControl;

@property(nonatomic,retain) NSArray *detailNotificationArray;

@property (nonatomic, strong) NSUserDefaults *defaults;



@end
