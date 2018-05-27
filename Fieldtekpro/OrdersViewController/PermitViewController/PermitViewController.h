//
//  PermitViewController.h
//  Fieldtekpro
//
//  Created by Sathya Rakesh Kumar on 23/05/18.
//  Copyright © 2018 Enstrapp Bangalore. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataBase.h"
#import "CreateOrderViewController.h"
#import "Response.h"
#import "PopoverViewController.h"
#import "OperationWCDTableViewCell.h"
#import "TaggingConditionTableViewCell.h"
#import "ConnectionManager.h"
#import "MBProgressHUD.h"
#import "JSAViewController.h"

@class PermitViewController;


@protocol ViewControllerBDelegate <NSObject>

- (void)addItemsViewController:(PermitViewController *)controller workApprovalsData:(NSMutableArray *)item withWorkApplicationsArray:(NSMutableArray *)workApplications withIsolationsData:(NSMutableArray *)isolationsData;


@end

@interface PermitViewController : UIViewController
{
    NSString *applicationTypeString,*applicationObjArt;
    IBOutlet UITableView *applicationsTableview;
     Response *res_obj;
    
    IBOutlet UIView *applicationTypeView,*subView,*isolationsListView;
    
    IBOutlet UIScrollView *wcmScrollView,*opWCDScrollView,*isolationScrollView,*operationWCDScrollView;
    
    IBOutlet UIButton *setPreparedBtn,*applicationBtn,*standardCheckPointBtn,*opWCDBtn,*switchingScreenBtn,*tagBtn,*unTagBtn,*taggedBtn,*unTaggedBtn,*aapWorkApprovalBtn,*isolationSetPreparedBtn,*selectAllOpwcdBtn,*taggedBarcodeBtn,*additionalTextBtn,*isolationlistBtn;
    
    IBOutlet UITableView *workApprovalTableView,*applicationTypeTableView,*checkPointTableView,*operationWCDTableView,*taggingConditionsTableView,*opWCDListTableView,*orderSystemStatusTableView;
    
    int VornrApplicationId,applicationSelectedIndex,VornrWApprovalId,VornrOpWCDId,waSelectedIndex,OPWCDSelectedIndex,taggingConditionsSelectedIndex,checkPointSelectedIndex,workApplicationSelectedIndex,headerCommonIndex,tagSelectedIndex;
    
    IBOutlet UIView *workApprovalHeaderView,*checkPointView,*opWCDView,*opWCDHeaderView,*taggingConditionsView,*opWCDListView,*isolationHeaderView,*operationWCDHeaderView,*addOpwcdBtn,*additionaltextView;

    
    //WCM
    IBOutlet UITextField *wcmShortTextField,*wcmFunctionLocationTextfield,*wcmFromDateTextfield,*wcmFromTimeTextfield,*wcmToDateTextfield,*wcmToTimeTextfield,*wcmPriorityTextfield,*opWcdStextTexField,*opWcdTypeTexfield,*opWcdObjectTextField,*opWCDTagTextfield,*opWcdUnTagTextfield,*opWCDLockTextField,*wcmUsergrouptextField,*wcmUsageTextField,*isolationUsergroupTexField,*isolationUsageTextfield,*tagTextfield,*untagTextfield;
 
    IBOutlet UIButton *issueApprovalsBtn,*isolationIssueApprovalBtn,*notifNoBtn,*removeTaggingConditionsButton,*plusTaggingConditionsBtn;
    
    IBOutlet UIImageView *issuepermitImage,*isolationPermitImage;
    IBOutlet UILabel *selectAllLabel,*issuePermitLabel,*isolationPermitLabel,*rsNuMLabel;
    
    BOOL changeWorkApprovalFlag,changeApplicationFlag,changeTaggingCondsFlag,filterSearch,checkPointFlag,selectAllOpwcdFlag,scanFlag,applicationSetPreparedFlag,opWCDSetpreparedFlag,taggingConditionsFlag,linkDismissFlag,addWorkApplicationFlag;
    
     BOOL wcmPriorityFlag,setPreparedFlag,addWorkApprovalFlag,setPreparedIsolationFlag,popUpEnabled,createOrderFlag;
    
    NSString *wcmPriorityId,*setPreparedString,*vornrApprovalId,*vornrApplicationString,*VornrOpWCDString,*VornrWApprovalString,*opWCDObjectID,*oGstring,*isolationPriorityId,*isolationSetPreparedString,*tgTypString,*unTypString,*phblghbString,*refObjString;
    
    NSString *vornrOperationID,*vornrComponentID,*workApprovalObjArt,*opwcdRefObj,*wcdObjritem;

    //Assigning Strings for Header details
    NSString *orderID,*orderTypeID,*priorityID,*priorityName,*orderUniqueID,*orderStatus,*functionalLocationID,*functionalLocationName,*equipmentID,*equipmentName,*accIndicatorID,*accIndicatorIDHeader,*accIndicatorName,*durationID,*quantityID,*componentID,*componentName,*storageLocationID,*plantID,*plantWorkCenterID,*workCenterID,*orderUDID,*malfuncStartDate,*malfunEndDate,*activityId,*reasonId,*controlKeyId,*plantWorkCenterOperatonID,*workCenterOperationID,*headerCostCenter,*headerWorkArea,*effectID,*systemConditionID,*wcmUserGroupID,*wcmUsageID,*isolationUserGroupID,*isolationUsageID;
    
     NSString *issuePermitsPosition,*objnrIdPosition;
    
      int tag;

    //isoalation headerfields
    IBOutlet UITextField *isolationShortTextField,*isolationFunctionLocationTextfield,*isolationFromDateTextfield,*isolationFromTimeTextfield,*isolationToDateTextfield,*isolationToTimeTextfield,*isolationPriorityTextfield;
    
    //operationWcd headerfields
    IBOutlet UITextField *opWCDShortTextField,*opWCDFunctionLocationTextfield,*opWCDFromDateTextfield,*opWCDFromTimeTextfield,*opWCDToDateTextfield,*opWCDToTimeTextfield,*opWCDPriorityTextfield;
    
    IBOutlet UILabel *headerWorkApprovalLabel,*isolationHeaderLabel;
    IBOutlet UIButton *menuButton;
    NSString *isolationHeaderString,*btgString,*etgString,*bugString,*eugString,*WARefobj;
    IBOutlet UITextView *taggingTextView,*untaggingTextView;
 
    NSString *decryptedUserName;
    
    MBProgressHUD *hud;

 }

@property (nonatomic ,retain) NSMutableDictionary *orderHeaderDetails;

@property (strong, nonatomic) UIButton *button;
@property (strong, nonatomic) PopoverViewController *buttonPopVC;
@property (strong, nonatomic) PopoverViewController *itemPopVC;
@property (strong, nonatomic) NSString *currentPop;


//Assigning Date Pickers
@property (nonatomic, retain) UIDatePicker *startMalFunctionDatePicker,*EndMalFunctionDatePicker,*measurementDocDatePicker,*measurementDocTimePicker;

@property (nonatomic, retain) NSDate *minStartDate,*minEndDate,*measureMentDocumentTime,*measureMentDocumentDate;

@property (nonatomic, retain) NSString *plantWorkCenterID,*iwerkString,*createOrderString,*equpmentEnableString,*orderNumberString;

@property (nonatomic, weak) id <ViewControllerBDelegate> delegate;

 
@property(nonatomic,retain) NSArray *headerDetailsArray;

@property (nonatomic, retain) NSMutableArray *dropDownArray;

@property (nonatomic, strong) IBOutlet UISegmentedControl *wsmSegmentControl,*checkPointSegmentControl,*isolationSegmentControl;

@property (nonatomic, strong) UITableView *dropDownTableView;
@property (nonatomic, strong) UIToolbar*  mypickerToolbar,*numberToolBar;

@property (nonatomic, retain) NSMutableArray  *workSafetyPlanOperationArray,*worksafetySelectedRadioBoxArray,*objAvailRadioBoxArray,*addRisksCheckBoxArray,*applicationDetailsArray,*workApprovalDetailsArray,*hazardsControlSCheckpointsArray,*taggingConditionsDetailsArray,*operationWCDSubmittedDetailsArray,*selectedOpWCDDetailsArray,*opWCDListDetailsArray,*selectedWorkApprovalArray,*selectedApplicationCheckBoxesArray,*workApprovalDetailsCopyArray,*selectedOperationWCDCheckBoxArray,*opWCDHeadrDetailsArray,*applicationHeaderDetailsArray,*applicationTypesArray,*finalCheckPointsArray,*workApplicationDetailsArray,*issuePermitsDetailArray,*permitsOperationWCD,*addedOperationsWcdArray,*checkPointTypeApplicationHeaderDetailsArray,*equipmentsDetailsArray;



@end
