//
//  MeasurementDocumentViewController.h
//  Fieldtekpro
//
//  Created by Enstrapp Bangalore on 16/01/18.
//  Copyright © 2018 Enstrapp Bangalore. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MeasureMentDocumentTableViewCell.h"
#import "NullChecker.h"
#import "ConnectionManager.h"
#import "StartInspectionTableViewCell.h"

#import "MBProgressHUD.h"


@interface MeasurementDocumentViewController : UIViewController

{
    MBProgressHUD *hud;
    
     IBOutlet UITextField *measurementPointTextField,*measurementDescriptionTextField,*raedingTextField,*measurementDateTextField,*measurementTimeTextField,*dateTexField,*timeTextField;
    
    //for Functional Location tableview
    IBOutlet UIView *startInspectionView;
    IBOutlet UITableView *inspectionCheckListTableView;
    
    NSString *decryptedUserName;
    
    int textfieldTag,tag,currentFlocTag;
    
    BOOL measurementTaskCheckBoxFlag,dropDowndismissFlag;

    
    NSUInteger selectedInspectionIndex,funcLocTag,selectedDismissFlocIndex,selectedDropwnTag;
 
}

@property (nonatomic, retain) IBOutlet UITableView *measurementDocTableView;

//Assigning Date Pickers
@property (nonatomic, retain) UIDatePicker *startDatePicker,*EndDatePicker,*measurementDocDatePicker,*measurementDocTimePicker;
@property (nonatomic, retain) NSDate *measureMentDocumentTime,*measureMentDocumentDate;

@property (nonatomic, retain) NSMutableArray *mesurementDocumentArray,*selectedMeasureDocsCheckBoxArray,*inspectionCheckListDataArray,*dropDownArray;

@property (nonatomic, retain) IBOutlet NSString *equipmentId;
@property (weak, nonatomic) IBOutlet UILabel *shiftTitleText;

@property (nonatomic, strong) UIToolbar*  mypickerToolbar,*numberToolBar;

@property (nonatomic, strong) UITableView *dropDownTableView;





@end
