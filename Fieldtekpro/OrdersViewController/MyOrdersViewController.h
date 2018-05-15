//
//  MyOrdersViewController.h
//  Fieldtekpro
//
//  Created by Enstrapp on 07/08/15.
//  Copyright (c) 2015 Enstrapp IT Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

//#import "ScanBarcodeViewController.h"
//#import "EquipMptt.h"
//#import "EquipmentMonitorViewController.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "AppDelegate.h"
#import "JEValidator.h"
#import "CreateOrderViewController.h"
#import "MBProgressHUD.h"

//for uploading attachments
#import "ELCImagePickerController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "WorkcenterViewController.h"


typedef enum ORDERHEADERDETAILSMAPPING{
    ORDERUUID =0,
    ORDERTYPEID = 1,
    ORDERTYPETEXTFIELD = 2,
    ORDERSHORTTEXTFIELD = 3,
    ORDERLONGTEXTFILED =4,
    ORDERFUNCTIONALLOCATIONID = 5,
    ORDERFUNCTIONALLOCATIONTEXTFIELD = 6,
    ORDEREQUIPMENTID = 7,
    ORDEREQUIPMENTTEXTFIELD = 8,
    ORDERACCOUNTINGINDICATORID=9,
    ORDERACCOUNTINGINDICATORTEXT=10,
    ORDERPRIORITYID = 11,
    ORDERPRIORITYTEXTFIELD = 12,
    ORDERSTARTDATE = 13,
    ORDERENDDATE = 14,
    ORDERHEADERPLANTID = 15,
    ORDERHEADERPLANTNAME = 16,
    ORDERHEADERWORKCENTERID = 17,
    ORDERHEADERWORKCENTERNAME = 18,
    ORDERSTATUS = 23,
    ORDERNO=24,
    ORDERHEADERWORKAREA = 26,
    ORDERHEADERCOSTCENTER = 27,
    ORDERHEADERNOTIFICATIONNUMBER = 28,
    ORDERHEADERMALFUNCSTARTDATE = 29,
    ORDERHEADERMALFUNCENDDATE = 30,
    ORDERHEADEREFFECTID = 31,
    ORDERHEADERBREADDOWN = 32,
    ORDERHEADERNREPORTEDBY = 33,
    ORDERHEADEREFFECTTEXT = 34,
    ORDERHEADERSYSTEMCONDITIONID = 35,
    ORDERHEADERSYSTEMCONDITIONTEXT = 36,
    ORDERHEADERUSER02 = 37,
    ORDERHEADERPERSONRESPONSIBLEID =38,
    ORDERHEADERPERSONRESPONSIBLETEXT =39,
    ORDERHEADERPLANNERGROUPID =40,
    ORDERHEADERPLANNERGROUPNAME =41,
    ORDER_MPOINT =42,
    ORDER_MVALUATION =43
    
}ORDERHEADERDETAILSMAPPING;

@interface MyOrdersViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,UITextFieldDelegate,MKMapViewDelegate,CLLocationManagerDelegate,UIDocumentPickerDelegate, UIDocumentMenuDelegate,UIImagePickerControllerDelegate,ELCImagePickerControllerDelegate>
{
    NSMutableArray *selectedCheckBoxArray,*selectedFilterSortCheckBoxArray,*syncMapDataMutableArray;
    
    BOOL orderNoSortSelected,statusSortSelected,shortTextSortSelected,prioritySortSelected,malFuncStartDateSortSelected;
    IBOutlet UILabel *myOrdersCountLabel,*headerFilterlabel,*filterByLabel,*infoFilterLabel,*myOrderHeaderLabel;
    
    NSMutableDictionary *inputsDictionary;
    IBOutlet UIButton *remainWorkCheckBoxBtn,*finalCheckBoxBtn;
    
    NSString *remainingWorkCheckString,*finalCheckString,*aueruid,*noremainingWork;;
    
    NSString *headerWorkArea,*headerCostCenter,*plantWorkCenterID,*accIndicatorIDHeader,
    *activityId,*reasonId;
    
    BOOL remainingWorkFlag,finalFlag,collectiveFlag,attachmentsFlag;
    
    IBOutlet UIScrollView *confirmScrollview,*addMDocScrollview;
 
    UIDocumentPickerViewController *docPicker;
    UIImagePickerController *imagePicker;
    NSMutableArray *arrimg;
    
    NSString * UploadType;
    NSURL * PDFUrl;
    
    
    int tag;
    NSInteger selectedIndexpath,wocoSelectedIndex;
    
    BOOL dateFlag,monitorEquipFlag;
    
    OperationTableViewCell *operationCell;
 
    UIAlertView *alertAttachmentItemType;
    
    IBOutlet UITextView *confirmationTextview;
    
    IBOutlet UITextField *activityTextField,*accountingIndicatorTextField,*reasonTextField,*startDateTextField,*endDatetTextfield,*startTimeTetxfield,*endTimeTextField,*employeeTextField;
    
 
    IBOutlet UIButton *orderNoSortBtn,*statusSortBtn,*shortTextSortBtn,*prioritySortBtn,*malFuncStartDateSortBtn,*checkBoxHeaderBtn,*filterBackgroundClicked,*cancelButton,*createButton,*confirmButton,*releaseButton,*taskSelectedBtn,*normalBtn,*alarmBtn,*criticalBtn;
    
    IBOutlet UIView *MyOrdresListHeaderView,*myOrdersHeaderView,*headerView_iPhone,*filterView,*filteredHeaderView,*confirmationView,*imageContainer,*attachView,*searchView;
    
    UIAlertView *cancelAlertView,*cancelResponseAlertView,*refreshAlert,*confirmAlert,*alert_finalConfirm,*responseAlertView,*releaseAlertView,*authenticationFailedAlert,*releaseResponseAlertView,*wocoAlertResponseView,*wocoResponseAlertView;
    
    NSUserDefaults *defaults;
    NSString *decryptedUserName;
    
    //For Barcode Scan
   // ScanBarcodeViewController *scanView;
    
    //collectiveConfirmation
    IBOutlet UITableView *operationsTableView,*measurementDocTableView,*attachmentsTableView;
    
    
    IBOutlet UIButton *selectedAllChekBoxButton,*saveOperationDetailsButton;
    
    //measurementDocuments
    IBOutlet UITextField *measurementPointTextField,*measurementDescriptionTextField,*raedingTextField,*measurementDateTextField,*measurementTimeTextField;
    IBOutlet UIScrollView *measurementDocScrollView;
    IBOutlet UIView *confirmOperationsView,*measurementDetailsView,*measurementDocumentView,*blackView;
    NSString *measurementTaskCheckString,*wocoOrderNoString,*resultString;
    
    BOOL measurementTaskCheckBoxFlag,criticalFlag,normalFlag,alarmFlag;
    
    UIAlertView *alertRemoveMeasureDocs;
    
   // EquipMptt *measurementPointDropDown;
    
    //collectiveConfirmation
    IBOutlet UIView *dropDownView;
    IBOutlet UITableView *dropDownSearchTableview;
    
    IBOutlet UIView *systemStatusView;
    
    IBOutlet UITableView *systemStatusTableView;
    NSMutableArray *orderSystemStatusArray;
    
    NSArray *filteredArray;
    
    NSMutableArray *permitsWocoDetailsArray,*permitsWocoDetailDeleteArray,*operationWococDetailDeleteArray,*partWocoDetailsArray,*workWocoSafetyPlansArray,*workApprovalWocoDetailsArray,*workApplicationWocoDetailsArray,*issuePermitsWocoDetailArray,*objectWocoDetailsArray,*permitsWocoOperationWCD;
    
    //For Attachments
    NSMutableArray *arr_images,*arr_imagesDocType,*arr_onScreenImages,*arr_onScreenImagesDocType,*headerLabelsArray;
    int xSpace;
    int ySpace;
    int iSpace;
    UIView *viewImage;
    UIImageView *imageView;
    UIButton *cancelImage;
    BOOL cameraFlag,imageNameFlag;
    UIAlertView *alert_Description,*alert_fail;
    UIActionSheet *uploadAction;
    NSData* pictureData;
    int imageSize;
    NSString *contentData;
    NSString *str_ImageType,*notifNoString;
    
    //AttachmentItemType
    NSString *attachmentAlertTypeString;
    
    CLLocationManager *locationManager;
    float lat;
    float longi;
    MKAnnotationView* annotationView2;
    NSMutableArray *arraAnn;
    MBProgressHUD *hud;

    IBOutlet UIButton *searchBtn,*filterBtn,*sortBtn,*refreshBtn;
    
    int selectedRow,attachmentCurrentIndex;
    
    IBOutlet UITextField *mPointTextField,*mreadingTextField,*mDatetextfield,*mTimetextField,*mvaluationTextField,*mNotesTextField;
    
    IBOutlet UIView *mPointView,*mreadingView,*mDateView,*mTimeView,*mvaluationView,*mresultView,*mNotesView;
    
    UIImageView  *arrow;

    Response *res_obj;

}

+ (id)sharedInstance;

@property (weak, nonatomic) IBOutlet UIView *notifStatusView,*imageContainer,*attachmentsView;

@property (nonatomic ,retain) NSMutableDictionary *getDocumentsHeaderDetails;

@property (weak, nonatomic) IBOutlet UISearchBar *measurementDocumentSearchBar;
//measurementDocuments
@property (nonatomic, retain) NSMutableArray *mesurementDocumentArray,*selectedMeasureDocsCheckBoxArray;
@property (nonatomic, strong) IBOutlet UIButton *measurementTask,*addMeasurementDocsButton,*cancelMeasurementDocsButton;

-(void)dismissScanView;

@property (nonatomic, retain) NSMutableArray *selectedOperationsCheckBoxArray,*selectedOperationsArray,*selectedCheckBoxImageArray,*attachmentArray;

@property (nonatomic, strong) UITableView *dropDownTableView;
@property (nonatomic, strong) UIToolbar*  mypickerToolbar;
@property (nonatomic, retain) NSMutableArray *dropDownArray,*fileNameArray;

@property (nonatomic, retain) NSMutableArray *OrderListArray,*operationDetailsArray;
@property (nonatomic, strong) IBOutlet UIImageView *attachmentImage,*statusCodeImage;
@property (weak, nonatomic) IBOutlet UISearchBar *orderSearchBar;
@property (nonatomic, retain) NSMutableDictionary *orderHeaderDetails;

- (void)dismissMyordersViewController;
-(void)poptoMyOrdersViewController;


//Assigning Date Pickers
@property (nonatomic, retain) UIDatePicker *startDatePicker,*EndDatePicker,*measurementDocDatePicker,*measurementDocTimePicker;;

@property (nonatomic, retain) UIDatePicker *startMalFunctionDatePicker,*EndMalFunctionDatePicker;
@property (nonatomic, retain) NSDate *minStartDate,*minEndDate,*measureMentDocumentTime,*measureMentDocumentDate;

@property(nonatomic,strong) UIViewController *currentController;

@property(nonatomic,retain) NSString *inspectionEquipmentId;


@property (nonatomic,weak)id delegate;

- (IBAction)mapBtnClicked:(id)sender;

@property (strong, nonatomic) IBOutlet UIView *mapHeaderView,*addMeasurePointView;
- (IBAction)mapBackBtnClicked:(id)sender;
@property (strong, nonatomic) IBOutlet MKMapView *orderMapView;
    
@property (strong, nonatomic) UIWindow *window;

-(void)dismissWorkcenterView ;


@end

