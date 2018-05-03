//
//  MISViewController.h
//  Fieldtekpro
//
//  Created by Enstrapp Bangalore on 03/01/17.
//  Copyright © 2017 Enstrapp IT Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DLPieChart.h"
#import "SimpleBarChart.h"

#import "FunctionalLocation.h"
#import "Equipment.h"
#import "FunctionalLocationTableViewCell.h"
#import "DetailFunctionLocationTableViewCell.h"
#import "PermitTableViewCell.h"
#import "FilterTableViewCell.h"
#import "NotifDescriptionTableViewCell.h"
#import "AvailabilityFunctionalLocationTableViewCell.h"
#import "EquipNumberTableViewCell.h"
#import "BrkDownDetailsTableViewCell.h"

#import "MBProgressHUD.h"


#import "FilterSortTableViewCell.h"
#import "PNChartDelegate.h"
#import "PNChart.h"


@import Charts;


@interface MISViewController : UIViewController<UITextFieldDelegate,UITextViewDelegate,NSURLSessionDelegate,UIAlertViewDelegate,UIGestureRecognizerDelegate,UITableViewDelegate,UITableViewDataSource,SimpleBarChartDataSource,SimpleBarChartDelegate,UIPickerViewDelegate,UIPickerViewDataSource,UISearchBarDelegate,ChartViewDelegate,IChartAxisValueFormatter,PNChartDelegate>
{
    IBOutlet UIView *notificationView,*brkDownView,*notifdetailView;
    
    NSString *selectedFlag;
    NSString *eDate,*sDate;
    UIDatePicker *datePicker;
    NSDate *date;
    NSDateFormatter *dateFormat;
    NSString *decryptedUserName;
    UIView    *dropDownview,*blackView;
    
    BOOL InitialFlag;
    
    NSMutableDictionary *tempDict;
    NSInteger buttonSelected;
    
    NSString *plantID,*workCenterID,*workCenterEndID;
    NSString *endDateString,*startDateString,*year;
    NSString *availabilityString,*summaryString,*MonthId;
    
    NSMutableArray *YearArray;
    
      MBProgressHUD *hud;
    
    //for Functional Location tableview
//    IBOutlet UIView *functionalLocationView,*functionalLocationHeaderView;
//    IBOutlet UITableView *functionalLocationTableView;
//    IBOutlet UISearchBar *functionalLocationsearch;
    
    IBOutlet UIView *funcLocationView;
    IBOutlet UISearchBar *funcLocationSearch;
    IBOutlet UITableView *funcLocationTableView;
    //for Equipment Number tableview
    IBOutlet UIView *equipmentNumberView,*equipmentNumberHeaderView;
    IBOutlet UITableView *equipmentNumberTableView;
    IBOutlet UISearchBar *equipmentNumbersearch;
    
    FunctionalLocation *location;
    NSMutableArray *functionDetails;
    NSMutableArray *equipmentDetails;
    Equipment *currentEquipment;
    NSString *equipmentID,*equipEndID;
    NSString *functionalLocationID,*functionalLocationEndID;
    
    NSString *startDate,*endDate;
    
    NSMutableArray *firstObjectArray,*secondObjectArray,*thirdObjectArray,*fourthObjectArray,*fifthObjectArray,*sixthObjectArray,*seventhObjectArray, *validFromArray, *validToArray,*firstFilterObjectArray,*secondFilterObjectArray,*thirdFilterObjectArray,*fourthFilterObjectArray,*fifthFilterObjectArray,*sixthFilterObjectArray,*seventhFilterObjectArray;
    
    
    NSArray *_values;
    
    SimpleBarChart *_chart;
    
    NSMutableArray *_barColors;
    NSInteger _currentBarColor;
    
    FunctionalLocation *funLocation;
    Equipment *equipment;
    NSMutableArray *AvailabilityfunctionDetails;
    BOOL equipmentFlag;
    NSString *workCenterOperationID, *plantWorkCenterOperatonID,*plantWorkCenterID,*catalogProfileID,*plantWorkCenterEndID;

}


@property (nonatomic, strong) IBOutlet BarChartView *barChartView;
@property (nonatomic, strong) IBOutlet UISlider *sliderX;
@property (nonatomic, strong) IBOutlet UISlider *sliderY;
@property (nonatomic, strong) IBOutlet UITextField *sliderTextX;
@property (nonatomic, strong) IBOutlet UITextField *sliderTextY;
@property (nonatomic, strong) IBOutlet NSArray *options;

@property (nonatomic, assign) BOOL shouldHideData;
- (void)updateChartData;

@property (strong, nonatomic) IBOutlet UIView *availabilityView;

//- (IBAction)backButtonClicked:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *manualyButton;
- (IBAction)availabilityButtonClicked:(id)sender;
- (IBAction)availabilityClicked:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *halfYearlyButton;
@property (strong, nonatomic) IBOutlet UIButton *monthlyButton;
@property (strong, nonatomic) IBOutlet UITextField *monthTextField;
@property (strong, nonatomic) IBOutlet UITextField *yearTextField;
- (IBAction)startButtonClicked:(id)sender;

- (IBAction)availabilitBbackClicked:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *malfunctionStartTextField;
@property (strong, nonatomic) IBOutlet UITextField *malfunctionEndTextField;
@property (strong, nonatomic) IBOutlet UITextField *functionalLocationStartTextField;
@property (strong, nonatomic) IBOutlet UITextField *functionalLocationEndTextField;
@property (strong, nonatomic) IBOutlet UITextField *equipmentStartTextField;
@property (strong, nonatomic) IBOutlet UITextField *equipmentEndTextField;
@property (strong, nonatomic) IBOutlet UITextField *plantStartTextField;
@property (strong, nonatomic) IBOutlet UITextField *plantEndTextField;
@property (strong, nonatomic) IBOutlet UITextField *workCenterStartTextField;
@property (strong, nonatomic) IBOutlet UITextField *workCenterEndTextField,*notifMonthTextField;
- (IBAction)detailsClicked:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *detailButton;
@property (strong, nonatomic) IBOutlet UIButton *summaryButton;
- (IBAction)runClicked:(id)sender;
- (IBAction)functionalLocationSerach:(id)sender;
- (IBAction)equipmentSearch:(id)sender;
- (IBAction)plantSearch:(id)sender;
- (IBAction)workCenterSearch:(id)sender;
@property (strong, nonatomic) IBOutlet UIView *avalibilityDetailsView;
@property (strong, nonatomic) IBOutlet UIImageView *dropdownImage;

@property (nonatomic, retain) NSMutableArray *equipmentHierarchyDetailsArray;
@property (nonatomic, retain) NSArray *filteredArray,*seachFilterArray,*scFilteredArray,*filterdTableArray,*detailFilteredArray,*searchInitialArray,*seachDescArray,*availabilitySearchArray,*brkFilterdArray,*brkSearchArray,*permitFilteredArray,*workApprovalFilteredArray,*permitSearchArray,*permitDetailFilerArray,*workApprovalDetailFilterArray;
@property (strong, nonatomic) IBOutlet UIButton *funcStartButton;
@property (strong, nonatomic) IBOutlet UIButton *funcEndButton;

- (void)handleTapGesture:(UITapGestureRecognizer *)sender;
+ (void)handleTapGesture:(UIButton *)sender;

@property (strong, nonatomic) IBOutlet UILabel *headerLabel;
@property (strong, nonatomic) IBOutlet UILabel *notifTitle;
@property (strong, nonatomic) IBOutlet UILabel *statusTitle;
@property (strong, nonatomic) IBOutlet UILabel *textTitle;
@property (strong, nonatomic) IBOutlet UILabel *equipmentTitle;

@property (strong,nonatomic)NSArray *notifDetailsArray;
@property (strong,nonatomic)NSString *headerString;

@property (strong, nonatomic) IBOutlet UITableView *notifTableView,*listofPlantsTableView;


@property (nonatomic, retain) IBOutlet DLPieChart *pieNotifChartView,*pieBrkDownChartView;
@property (strong, nonatomic) IBOutlet UITextField *startDateTextField;
@property (strong, nonatomic) IBOutlet UITextField *endDateTextField;

@property (nonatomic, strong) UIToolbar*  mypickerToolbar;

- (IBAction)refreshClicked:(id)sender;
@property (strong, nonatomic) IBOutlet DLPieChart *descNotifPieChartView,*descBrkDownChartView;
@property (strong, nonatomic) IBOutlet UIButton *closeButton;
@property (strong, nonatomic) IBOutlet UIButton *notifCloseButton;

- (IBAction)closeButtonClicked:(id)sender;
@property (strong, nonatomic) IBOutlet UITextView *descTextView;
@property (strong, nonatomic) IBOutlet UIButton *refreshButton;

@property (nonatomic,assign) int newTag;

@property (strong, nonatomic) IBOutlet UILabel *detailsText,*descBrkdwnLbl;
@property (strong, nonatomic) IBOutlet UITextField *daysTextField,*plantTextField;
- (IBAction)backClicked:(id)sender;
- (IBAction)notifReportBackClicked:(id)sender;
-(void)singleTap;

@property(nonatomic, retain) NSMutableArray *dropDownArray,*funcDropDownArray;
@property (nonatomic ,retain) IBOutlet UIView *listofPlantsView;

@property (nonatomic, strong) UITableView *dropDownTableView;
@property (strong, nonatomic) IBOutlet UILabel *notifHeaderTitle;
@property (strong, nonatomic) IBOutlet DLPieChart *availabilityPiechartView;
@property (strong, nonatomic) IBOutlet UITableView *availabilityDetailTableView;
- (IBAction)availabilityBackButtonClicked:(id)sender;
- (IBAction)availabityDetailBackButtonClicked:(id)sender;
@property (strong, nonatomic) IBOutlet UIView *availabilityReportView;
@property (strong, nonatomic) IBOutlet UITableView *availabilityReportTableView;
- (IBAction)availabilityReportSelected:(id)sender;
@property (strong, nonatomic) IBOutlet UIView *detailView;
@property (strong, nonatomic) IBOutlet UIView *availabilityDetailView;
@property (strong, nonatomic) IBOutlet UIView *availabilityDescriptionView;
- (IBAction)availabilityDescriptionBackButtonClicked:(id)sender;
- (IBAction)permitReportClicked:(id)sender;

@property (strong, nonatomic) IBOutlet UIView *permitView;
@property (strong, nonatomic) IBOutlet UITextField *permitWorkcenterTextField;
@property (strong, nonatomic) IBOutlet DLPieChart *permitPiechartView;
@property (strong, nonatomic) IBOutlet DLPieChart *permitDescriptionPiechartView;
@property (strong, nonatomic) IBOutlet DLPieChart *workApprovalPiechartView;
@property (strong, nonatomic) IBOutlet UITextField *permitPlantTextField;
- (IBAction)permitBackButtonClicked:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *dropDownHeaderTitle;
@property (strong, nonatomic) IBOutlet UIView *permitDetailView;
- (IBAction)permitDetailBackButtonClicked:(id)sender;
@property (strong, nonatomic) IBOutlet UITableView *permitDetailTableView;

@property (strong, nonatomic) IBOutlet UIButton *permitCloseButton;
@property (strong, nonatomic) IBOutlet UILabel *permitDetailText;

@property (strong, nonatomic) IBOutlet UIView *barchartView;
- (IBAction)barchartBackClicked:(id)sender;

@property (strong, nonatomic) IBOutlet UILabel *notifNumText;
@property (strong, nonatomic) IBOutlet UILabel *startDateText;
@property (strong, nonatomic) IBOutlet UILabel *endDateText;
@property (strong, nonatomic) IBOutlet UILabel *notifTypeText;
@property (strong, nonatomic) IBOutlet UILabel *mttrText;
@property (strong, nonatomic) IBOutlet UILabel *totakBrkdwnText;
@property (strong, nonatomic) IBOutlet UILabel *availabilityText;
@property (strong, nonatomic) IBOutlet UILabel *offlineTime;
@property (strong, nonatomic) IBOutlet UIImageView *doubleArraowImg;
@property (strong, nonatomic) IBOutlet UIButton *doubleArrowButton;
@property (strong, nonatomic) IBOutlet UILabel *availabilityPlantText;
@property (strong, nonatomic) IBOutlet UILabel *availabilityWorkcenter;
@property (strong, nonatomic) IBOutlet UILabel *availabilityStartDateText;
@property (strong, nonatomic) IBOutlet UILabel *availabilityEndDateText;
- (IBAction)plantFilterSelected:(id)sender;
@property (strong, nonatomic) IBOutlet UIView *filterView;
@property (strong, nonatomic) IBOutlet UITableView *filterTableView;
@property (nonatomic, retain) NSMutableArray *plantListArray;
- (IBAction)clearFilterClicked:(id)sender;

@property (strong, nonatomic) IBOutlet UISearchBar *notifSearch;
@property (strong, nonatomic) IBOutlet UIView *notifDescription;
@property (strong, nonatomic) IBOutlet UITableView *notifDescTableView;
@property (strong, nonatomic) IBOutlet UIView *descriptionView;
- (IBAction)descriptionBackClicked:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *notifNumberLabel;
@property (strong, nonatomic) IBOutlet UILabel *equipNumberLabel;
@property (strong, nonatomic) IBOutlet UILabel *equipDescriptionLabel;
@property (strong, nonatomic) IBOutlet UILabel *notifDescriptionLabel;
@property (strong, nonatomic) IBOutlet UILabel *plantLabel;
@property (strong, nonatomic) IBOutlet UILabel *workCenterLabel;
- (IBAction)notifDetailsBackClicked:(id)sender;
- (IBAction)secondPiechartFielter:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *filterButton;
- (IBAction)filterClicked:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *plantLabelText;
@property (strong, nonatomic) IBOutlet UIButton *detailFilter;
@property (strong, nonatomic) IBOutlet UILabel *plantHeader;
@property (strong, nonatomic) IBOutlet UILabel *notifDescPlantLabelText;
@property (strong, nonatomic) IBOutlet UILabel *detailPlantHeader;
@property (strong, nonatomic) IBOutlet UILabel *detailSelectedPlantText;
@property (strong, nonatomic) IBOutlet UILabel *descPlantHeader;
@property (strong, nonatomic) IBOutlet UISearchBar *availabilitySearch;
- (IBAction)detailsButtonClicked:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *objectNumText;
@property (strong, nonatomic) IBOutlet UILabel *availabilityPlantHeader;
@property (strong, nonatomic) IBOutlet UILabel *availabilityPlantDetailText;
- (IBAction)availabilityFilterClicked:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *notifPhaseText;
@property (strong, nonatomic) IBOutlet UILabel *notifTypeTxtDesc;
@property (strong, nonatomic) IBOutlet UILabel *notifCreatedBy;
@property (strong, nonatomic) IBOutlet UILabel *notifStartDate;
@property (strong, nonatomic) IBOutlet UILabel *notifFuncLocation;
@property (strong, nonatomic) IBOutlet UILabel *notifEndDate;
@property (strong, nonatomic) IBOutlet UIImageView *notifBrkImage;
@property (strong, nonatomic) IBOutlet UILabel *notifBrkTitle;
@property (strong, nonatomic) IBOutlet UILabel *priorityText;
@property (strong, nonatomic) IBOutlet UILabel *sysConditionText;
@property (strong, nonatomic) IBOutlet UILabel *sysStartDateText;
@property (strong, nonatomic) IBOutlet UILabel *sysEndDateText;
- (IBAction)breakdownFilterClicked:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *brkPlantText;
@property (strong, nonatomic) IBOutlet UILabel *brkPlantTitle;
@property (strong, nonatomic) IBOutlet UIView *brkdownDetailsView;
@property (strong, nonatomic) IBOutlet UISearchBar *brkdownSearchBar;
@property (strong, nonatomic) IBOutlet UITableView *brkdownTableView;
@property (strong, nonatomic) IBOutlet UIView *brkdownDescriptionView;
- (IBAction)brkdownDescBackClicked:(id)sender;
- (IBAction)brkdownDetailsSelected:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *brkNotifNumText;
@property (strong, nonatomic) IBOutlet UILabel *brkEquipNumText;
@property (strong, nonatomic) IBOutlet UILabel *brkEquipDescText;
@property (strong, nonatomic) IBOutlet UILabel *brkNotifDescText;
@property (strong, nonatomic) IBOutlet UILabel *brkWrkCenterText;
@property (strong, nonatomic) IBOutlet UILabel *brkPlantDescText;
@property (strong, nonatomic) IBOutlet UILabel *brkNotifTypeText;
@property (strong, nonatomic) IBOutlet UILabel *brkFuncLocationText;
@property (strong, nonatomic) IBOutlet UILabel *brkSysStartDateText;
@property (strong, nonatomic) IBOutlet UILabel *brkSysEndDateText;
- (IBAction)brkDetailBackClicked:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *permitPlantTitle;
@property (strong, nonatomic) IBOutlet UILabel *permitPlantText;
@property (strong, nonatomic) IBOutlet UILabel *workApprovalPlantTitle;
@property (strong, nonatomic) IBOutlet UILabel *wrkApprovalPlantText;
@property (strong, nonatomic) IBOutlet UIView *permitDescriptionView;
- (IBAction)permitFilterClicked:(id)sender;
- (IBAction)wrkApprovalFilterClicked:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *permitDescHeaderTitle;
- (IBAction)permitDescBackClicked:(id)sender;
- (IBAction)permitDetailFilterClicked:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *permitDetailPlantTitle;
@property (strong, nonatomic) IBOutlet UILabel *permitDetailPlantText;
@property (strong, nonatomic) IBOutlet UIButton *permitDetailFilter;
@property (strong, nonatomic) IBOutlet UISearchBar *permitSearchBar;
@property (strong, nonatomic) IBOutlet UIImageView *startDateImage;
@property (strong, nonatomic) IBOutlet UIImageView *endDateImage;
@property (strong, nonatomic) IBOutlet UILabel *malfunLabel;
@property (strong, nonatomic) IBOutlet UILabel *mandatoryImage;
@property (strong, nonatomic) IBOutlet UILabel *availabilityNotifLbel;
@property (strong, nonatomic) IBOutlet UILabel *availabilityNotifNumLabel;
@property (strong, nonatomic) IBOutlet UILabel *availabilityFunLocLabel;
@property (strong, nonatomic) IBOutlet UILabel *availabilityEquipNumLabel;
@property (strong, nonatomic) IBOutlet UILabel *availabilityEquipTextLabel;
@property (strong, nonatomic) IBOutlet UILabel *availabilityMalFuncLabel;
@property (strong, nonatomic) IBOutlet UILabel *availabilityMalFuncEndDateLabel;
@property (strong, nonatomic) IBOutlet UILabel *availabilityEndTimeLabel;
@property (strong, nonatomic) IBOutlet UILabel *availabilityFrequencyLabel;
@property (strong, nonatomic) IBOutlet UILabel *availabilityPlantLabel;
@property (strong, nonatomic) IBOutlet UILabel *availabilityStartTimeLabel;
@property (strong, nonatomic) IBOutlet UILabel *availabilityOfflineLabel;
@property (strong, nonatomic) IBOutlet UILabel *availabilityBrkdownTimeLabel;
@property (strong, nonatomic) IBOutlet UILabel *availabilityPercentLabel;
@property (strong, nonatomic) IBOutlet UILabel *mtbrMinLabel;
@property (strong, nonatomic) IBOutlet UILabel *minLabel;
@property (strong, nonatomic) IBOutlet UILabel *mtbrHourLabel;
@property (strong, nonatomic) IBOutlet UILabel *hoursLabel;
@property (strong, nonatomic) IBOutlet UILabel *availabilityLabel;
@property (strong, nonatomic) IBOutlet UILabel *mtbrPMLabel;
@property (strong, nonatomic) IBOutlet UILabel *mtbrMinPMLabel;
@property (strong, nonatomic) IBOutlet UILabel *radioLabel;
@property (strong, nonatomic) IBOutlet UIView *misFilterView;
@property (strong, nonatomic) IBOutlet UILabel *misFilterByLabel;
@property (strong, nonatomic) IBOutlet UITableView *misFilterTableView;
@property (strong, nonatomic) IBOutlet UILabel *misInfoFilterLabel;
@property (strong, nonatomic) IBOutlet UIButton *misFilterBackground;
- (IBAction)misFilterBackgroundClicked:(id)sender;
- (IBAction)misClearAllFilterClicked:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *applicationFilterBackground;
@property (strong, nonatomic) IBOutlet UIView *permitDetailDescView;
@property (strong, nonatomic) IBOutlet UILabel *permitNameTextLabel;
@property (strong, nonatomic) IBOutlet UILabel *permitEquipTextLabel;
@property (strong, nonatomic) IBOutlet UILabel *permitOrderTextLabel;
@property (strong, nonatomic) IBOutlet UILabel *permitFuncLocationTextLabel;
@property (strong, nonatomic) IBOutlet UILabel *permitEquipmentText;
@property (strong, nonatomic) IBOutlet UILabel *permitPriorityTextLabel;
@property (strong, nonatomic) IBOutlet UILabel *permitWcnrTextLabel;
@property (strong, nonatomic) IBOutlet UILabel *permitToDateTextLabel;
@property (strong, nonatomic) IBOutlet UILabel *permitFromDateTextLabel;
@property (strong, nonatomic) IBOutlet UILabel *permitFromTimeTextLabel;
@property (strong, nonatomic) IBOutlet UILabel *permitToTimeTextLabel;
- (IBAction)permitDetailDescBackClicked:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *notifFilterBackGround;
@property (strong, nonatomic) IBOutlet UILabel *currentMonthHeader;
@property (weak, nonatomic) IBOutlet UILabel *monthlyTrendHeader;
@property (weak, nonatomic) IBOutlet UIButton *notifDetailBackground;
@property (weak, nonatomic) IBOutlet UILabel *notifDetailsHeaderText;
@property (strong, nonatomic) IBOutlet UIView *secondLevelNotifView;
- (IBAction)secondLevelNotifBackClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *secondLevelNotifBackground;
@property (weak, nonatomic) IBOutlet UIImageView *secondLevelNotifFilterImage;
@property (weak, nonatomic) IBOutlet UIImageView *detailFilterImage;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
- (IBAction)segmentedControlClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *permitTimePeriodTextField;
@property (weak, nonatomic) IBOutlet UILabel *applicationHeaderText;
@property (weak, nonatomic) IBOutlet UILabel *permitCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *applicationTotalCount;
- (IBAction)breakDownFilterClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *brkDownFilterBackground;
@property (weak, nonatomic) IBOutlet UILabel *brkDownPlantText;
@property (weak, nonatomic) IBOutlet UILabel *monthlyTrendText;
- (IBAction)calenderClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *calenderButton;
- (IBAction)notifSegmentedControlClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UISegmentedControl *notifSegmentedControl;
@property (weak, nonatomic) IBOutlet UIView *notifBarchartView;
@property (weak, nonatomic) IBOutlet UIButton *notifBarBackground;
@property (strong, nonatomic) IBOutlet UIView *backgroundView;
@property (weak, nonatomic) IBOutlet UIView *notifSubView;
@property (strong, nonatomic) IBOutlet UIView *analysisView;
@property (weak, nonatomic) IBOutlet UILabel *notifBarchartTimePeriod;
@property (weak, nonatomic) IBOutlet UIView *complianceBarChart;
@property (weak, nonatomic) IBOutlet UIScrollView *notifScrollView;

- (IBAction)orderReportClicked:(id)sender;
@property (strong, nonatomic) IBOutlet UIView *orderView;
- (IBAction)orderBackClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UISegmentedControl *orderSegmentController;
- (IBAction)orderSegmentSelected:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *orderSubView;
@property (weak, nonatomic) IBOutlet UIButton *orderbackGround;
@property (weak, nonatomic) IBOutlet UIButton *orderFilterClicked;
@property (strong, nonatomic) IBOutlet UIView *orderDescriptionView;
@property (weak, nonatomic) IBOutlet DLPieChart *orderDescpnPieChartView;
@property (weak, nonatomic) IBOutlet UIButton *orderDescpnBackGround;
- (IBAction)orderDescpnBaclClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *misHeaderLabel;
@property (weak, nonatomic) IBOutlet UILabel *misDescrpnHeader;

@property (weak, nonatomic) IBOutlet UILabel *orderNumText;
@property (weak, nonatomic) IBOutlet UILabel *orderEquipNumText;
@property (weak, nonatomic) IBOutlet UILabel *orderEquipDescrpnText;
@property (weak, nonatomic) IBOutlet UILabel *orderDescpnText;
@property (weak, nonatomic) IBOutlet UILabel *orderWorkCenter;
@property (weak, nonatomic) IBOutlet UILabel *orderPhase;
@property (weak, nonatomic) IBOutlet UILabel *orderPlant;
@property (weak, nonatomic) IBOutlet UILabel *orderStartDateText;
@property (weak, nonatomic) IBOutlet UILabel *orderCreatedByText;
@property (weak, nonatomic) IBOutlet UILabel *orderEndDateText;
@property (weak, nonatomic) IBOutlet UILabel *orderTypeText;
@property (weak, nonatomic) IBOutlet UILabel *orderFunLocationText;
@property (weak, nonatomic) IBOutlet UILabel *orderPriorityText;

@property (strong, nonatomic) IBOutlet NSString *selectedValue;


@end
