//
//  CreateOrderViewController.h
//  Fieldtekpro
//
//  Created by Enstrapp Bangalore on 28/12/17.
//  Copyright © 2017 Enstrapp Bangalore. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "InputDropDownTableViewCell.h"
#import "SearchInputDropdownTableViewCell.h"
#import "DateandTimeTableViewCell.h"
#import "CreateOrderViewController.h"
#import "BreakDownTableViewCell.h"
#import <YAScrollSegmentControl/YAScrollSegmentControl.h>
#import "OperationTableViewCell.h"
#import "PartTableViewCell.h"
#import "WorkApprovalTableViewCell.h"
#import "ApplicationTableViewCell.h"
#import "DataBase.h"
#import "ObjectTableViewCell.h"
#import "CreateNotificationViewController.h"
#import "Response.h"
#import "ComponentViewController.h"
#import "OrderSystemStatusTableViewCell.h"
#import "MBProgressHUD.h"
#import "JEValidator.h"
#import "ApllicationsDropDownViewController.h"
#import "StandardCheckPointTableViewCell.h"

#import "DetailOrderConfirmationViewController.h"

#define ID_INDEX 0
#define NAME_INDEX 1

typedef enum SelectedDropDownInOrders{
    
    ORDER_TYPE = 0,
    ORDER_PRIORITY = 1,
    ORDER_FUNCTIONALLOCATION = 2,
    ORDER_EQUIPMENT = 3,
    ORDER_ACCOUNTINGINDICATOR=4,
    ORDER_COSTCENTER = 5,
    ORDER_PERMITS = 6,
    ORDER_DURATION=7,
    ORDER_STORAGELOCATION=8,
    ORDER_COMPONENT=9,
    ORDER_PLANT=10,
    ORDER_WORKCENTER=11,
    ORDER_ACTIVITYTYPE=12,
    ORDER_REASONS=13,
    ORDER_CONTROLKEYS=14,
    ORDER_OPERATIONNO = 15,
    ORDER_SYSTEM_CONDITION =16,
    ORDER_WCM_TYPE =17,
    ORDER_DISMISS_TAG=18,
    ORDER_WCM_USERGROUP=19,
    ORDER_WCM_USAGE=20,
    ORDER_ISOLATION_USERGROUP=41,
    ORDER_ISOLATION_USAGE=42,
    ORDER_PLANNERGROUP=43
    
}SelectedDropDownInOrders;


@interface CreateOrderViewController : UIViewController<YAScrollSegmentControlDelegate>
{
    IBOutlet UITableView *commonlistTableView;
    
    NSMutableArray *headerDataArray,*addCauseCodeDataArray,*addTaskCodeDataArray,*notifInspectionArray,*notificationsArray;

    YAScrollSegmentControl *segmentControl;
    
    BOOL FlagFuncLoc,flagUnits,FlagEquip,FlagComponents,createOrderFlag,editBtnSelected,breakDownCheckBoxFlag,equipmentRefreshButtonSelected;
    
    NSString *funcLocnId,*funcLocName;
    
    Response *res_obj;
    
    IBOutlet UIView *commonAddView,*addCustomHeaderView,*addOperationView,*addPartsView,*componentView,*segmentView;
    IBOutlet UITableView *commonAddTableView,*seachDropdownTableView;
    
    IBOutlet UIButton *finishBtn,*addComponentButton,*updateComponent;
    IBOutlet UILabel *notificationNoLabel,*orderHeaderNoLabel,*partHeaderLabel;

    
    IBOutlet UIView *workApprovalHeaderView,*applicationTypeView,*checkPointView,*opWCDView,*opWCDHeaderView,*taggingConditionsView,*opWCDListView,*isolationHeaderView,*operationWCDHeaderView,*addOpwcdBtn,*additionaltextView,*submitResetView,*searchDropDownView,*orderSystemStatusView;
    
     IBOutlet UIScrollView *wcmScrollView,*opWCDScrollView,*isolationScrollView,*operationWCDScrollView;
    
    IBOutlet UIButton *setPreparedBtn,*applicationBtn,*standardCheckPointBtn,*opWCDBtn,*switchingScreenBtn,*tagBtn,*unTagBtn,*taggedBtn,*unTaggedBtn,*aapWorkApprovalBtn,*isolationSetPreparedBtn,*selectAllOpwcdBtn,*taggedBarcodeBtn,*additionalTextBtn;

    IBOutlet UITableView *workApprovalTableView,*applicationTypeTableView,*checkPointTableView,*operationWCDTableView,*taggingConditionsTableView,*opWCDListTableView,*orderSystemStatusTableView;
    
    int VornrApplicationId,applicationSelectedIndex,VornrWApprovalId,VornrOpWCDId,waSelectedIndex,OPWCDSelectedIndex,taggingConditionsSelectedIndex,checkPointSelectedIndex,workApplicationSelectedIndex,headerCommonIndex;
    
    NSMutableArray *addOperationsArray,*addPartsArray;
    
    //Assigning Strings for Header details
    NSString *orderID,*orderTypeID,*priorityID,*priorityName,*orderUniqueID,*orderStatus,*functionalLocationID,*functionalLocationName,*equipmentID,*equipmentName,*accIndicatorID,*accIndicatorIDHeader,*accIndicatorName,*durationID,*quantityID,*componentID,*componentName,*storageLocationID,*plantID,*plantWorkCenterID,*workCenterID,*orderUDID,*malfuncStartDate,*malfunEndDate,*activityId,*reasonId,*controlKeyId,*plantWorkCenterOperatonID,*workCenterOperationID,*headerCostCenter,*headerWorkArea,*effectID,*systemConditionID,*wcmUserGroupID,*wcmUsageID,*isolationUserGroupID,*isolationUsageID;
    
   IBOutlet  UIScrollView *partsScrollView;
    
    BOOL equipmentFlag;
    
    int VornrOperation,VornrComponent;
    
    NSString *vornrOperationID,*vornrComponentID,*applicationObjArt,*workApprovalObjArt,*opwcdRefObj,*wcdObjritem;
 
   NSMutableArray *operationNoArray,*riskStructuredArray,*safetyPlanArray,*safetyPlanDeleteArray;
    
    NSString *issuePermitsPosition,*objnrIdPosition;
    
    NSString *vornrItemID,*vornrCauseCodeID,*decryptedUserName,*costCenterID,*filteredCostCenterDescriptionString,*breakDownCheckString,*orderNoString,*notificationNoString,*refObjString,*WARefobj;
   
    //WCM
    IBOutlet UITextField *wcmShortTextField,*wcmFunctionLocationTextfield,*wcmFromDateTextfield,*wcmFromTimeTextfield,*wcmToDateTextfield,*wcmToTimeTextfield,*wcmPriorityTextfield,*opWcdStextTexField,*opWcdTypeTexfield,*opWcdObjectTextField,*opWCDTagTextfield,*opWcdUnTagTextfield,*opWCDLockTextField,*wcmUsergrouptextField,*wcmUsageTextField,*isolationUsergroupTexField,*isolationUsageTextfield;
    
    BOOL wcmPriorityFlag,setPreparedFlag,addWorkApprovalFlag,setPreparedIsolationFlag;
    NSString *wcmPriorityId,*setPreparedString,*applicationTypeString,*vornrApprovalId,*vornrApplicationString,*VornrOpWCDString,*VornrWApprovalString,*opWCDObjectID,*oGstring,*isolationPriorityId,*isolationSetPreparedString,*tgTypString,*unTypString,*phblghbString;
    
      IBOutlet UIButton *issueApprovalsBtn,*isolationIssueApprovalBtn,*notifNoBtn,*removeTaggingConditionsButton;
 
    IBOutlet UIImageView *issuepermitImage,*isolationPermitImage;
    IBOutlet UILabel *selectAllLabel,*issuePermitLabel,*isolationPermitLabel,*rsNuMLabel;

        BOOL changeWorkApprovalFlag,changeApplicationFlag,changeTaggingCondsFlag,filterSearch,checkPointFlag,selectAllOpwcdFlag,scanFlag,applicationSetPreparedFlag,opWCDSetpreparedFlag,taggingConditionsFlag,linkDismissFlag,addWorkApplicationFlag;
    
    IBOutlet UILabel *headerWorkApprovalLabel,*isolationHeaderLabel;
    
    NSString *operationShortTextFieldString,*wcmIsolationText,*plannerGroupNameString,*personresponsibleNameString,*orderheaderStatusString;

    //isoalation headerfields
    IBOutlet UITextField *isolationShortTextField,*isolationFunctionLocationTextfield,*isolationFromDateTextfield,*isolationFromTimeTextfield,*isolationToDateTextfield,*isolationToTimeTextfield,*isolationPriorityTextfield;
    
    //operationWcd headerfields
    IBOutlet UITextField *opWCDShortTextField,*opWCDFunctionLocationTextfield,*opWCDFromDateTextfield,*opWCDFromTimeTextfield,*opWCDToDateTextfield,*opWCDToTimeTextfield,*opWCDPriorityTextfield;
 
    UIToolbar *myDatePickerToolBar;
    
    NSString *loactionId;

    int tag;
    
    NSMutableString *personResponisbleID,*plannerGrouplID,*iwerkString,*primaryPersonResonsibleID,*catalogProfileID;
    
    IBOutlet UILabel *equipmentHistoryHeaderLabel,*funcLocnHeaderLabel,*notifNoLabel;
    
    //Assigning Text Fields
   IBOutlet UITextField *durationTextField,*componentTextField,*durationInputTextField,*quantityTextField,*plantHeaderTextField,*receiptTetxField,*unLoadingTextField;
    
     IBOutlet UIButton *updateOperationsBtn,*addOperationsBtn,*deleteOperationsBtn,*resetAllInputsBtn;
 
     IBOutlet UITextField *operationPlanttextField,*operationWkcenterTextfield,*controlKeyTextField;
    
    IBOutlet UITextView *orderLongTextView,*operationLongTextView;
    
     IBOutlet UILabel *orLabel,*seperatorLabel,*riskLabel,*riskSeperator,*safetyMeasureLabel,*safetyMeasureSeperator,*addOperationHeaderLabel,*orderHeaderLabel,*chooseRisksLabel,*statusLabel;
    
    NSString *orderShortTextFieldString,*operationTextFieldString;

    NSString *str_LongText,*str_OperationLongText,*str_Units;

    IBOutlet UITextField *operationStatusTextField,*operationNumberTextField,*operationLongTextField,*operationControlKeyTextfield,*plantworkcenterTextField,*activityTextField,*plannedWorkTextField;

     IBOutlet UILabel *plantComponentsLabelid,*storageLocComponentsLabelid,*plantComponentSeperator;
    
     IBOutlet UITextField *plantComponentTextField,*storageLocationComponentTextField,*operationNoTextField;
    
    int currentOperationItemIndex,headerIndexPathRow,currentFlocTag;

        BOOL dateFlag,equipFlag,funcLocFlag,costCenterFuncLocFlag,operationSelectedFlag,serachMaterialAvailabiltyFlag;
    
    MBProgressHUD *hud;
    
    
    IBOutlet UISearchBar *componentSearch;
    IBOutlet UITableView *componentTableView;

    NSString *operationNoString;
    
    BOOL customOperationFlag,customComponentFlag;

    NSMutableArray *orderSystemStatusArray;
    
    IBOutlet UISegmentedControl *orderSystemStatusSegmentControl;

//border shapes
    IBOutlet UIView *opTxtView,*durationView,*plantWkctrView,*unloadView,*receiptView,*opPartsview,*componentContentView,*plantStgLocnview,*quantityContentView;
    
    IBOutlet UIButton *isolationlistBtn;
    
}

@property (nonatomic, strong) UITableView *dropDownTableView;
@property (nonatomic, strong) UIToolbar*  mypickerToolbar,*numberToolBar;

//Assigning Date Pickers
@property (nonatomic, retain) UIDatePicker *startMalFunctionDatePicker,*EndMalFunctionDatePicker,*measurementDocDatePicker,*measurementDocTimePicker;
@property (nonatomic, retain) NSDate *minStartDate,*minEndDate,*measureMentDocumentTime,*measureMentDocumentDate;
 
@property (nonatomic ,retain) NSMutableDictionary *orderHeaderDetails;

@property (nonatomic, retain) NSMutableArray *dropDownArray,*selectedCheckBoxArray,*fileNameArray,*attachmentArray,*selectedCheckBoxImageArray,*causeDetailDeleteArray,*operationDetailsArray,*partDetailsArray,*operationDetailDeleteArray,*permitsDetailsArray,*permitsDetailDeleteArray,*customHeaderDetailsArray,*customOperationDetailsArray,*customComponentsDetailsArray,*selectedMeasureDocsCheckBoxArray,*equipmentHierarchyDetailsArrayLevel1,*equipmentHierarchyDetailsArrayLevel2,*equipmentHierarchyDetailsArrayLevel3,*equipmentHierarchyDetailsArrayLevel4,*objectDetailsArray,*selectedPartsArray,*componentDetailDeleteArray,*functionLocationHierarchyLevel1,*functionLocationHierarchyLevel2,*functionLocationHierarchyLevel3,*functionLocationArray;

@property (nonatomic, retain) NSMutableArray  *workSafetyPlanOperationArray,*worksafetySelectedRadioBoxArray,*objAvailRadioBoxArray,*addRisksCheckBoxArray,*applicationDetailsArray,*workApprovalDetailsArray,*hazardsControlSCheckpointsArray,*taggingConditionsDetailsArray,*operationWCDSubmittedDetailsArray,*selectedOpWCDDetailsArray,*opWCDListDetailsArray,*selectedWorkApprovalArray,*selectedApplicationCheckBoxesArray,*workApprovalDetailsCopyArray,*selectedOperationWCDCheckBoxArray,*opWCDHeadrDetailsArray,*applicationHeaderDetailsArray,*applicationTypesArray,*finalCheckPointsArray,*workApplicationDetailsArray,*issuePermitsDetailArray,*permitsOperationWCD,*addedOperationsWcdArray,*checkPointTypeApplicationHeaderDetailsArray,*equipmentsDetailsArray;

@property (nonatomic, retain) NSMutableArray *loadNotificationDetailsArray;

@property(nonatomic,retain) NSArray *detailOrdersArray;

//WCM
@property (nonatomic, strong) IBOutlet UISegmentedControl *wsmSegmentControl,*checkPointSegmentControl;

-(void)dismissfunctionLocationView;
-(void)dismissComponentsSearchView;
-(void)dismissApplicationTypesClicked;
-(void)dismissequipmentNumberView;

@property (nonatomic, strong) NSUserDefaults *defaults;



@end
