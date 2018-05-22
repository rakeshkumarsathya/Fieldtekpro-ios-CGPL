//
//  DetailOrderConfirmationViewController.h
//  Fieldtekpro
//
//  Created by Sathya Rakesh Kumar on 10/05/18.
//  Copyright © 2018 Enstrapp Bangalore. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "InputDropDownTableViewCell.h"
#import "BreakDownTableViewCell.h"
#import "DurationTableViewCell.h"
#import "ConfirmationTableViewCell.h"
#import "FinalConfirmationTableViewCell.h"
#import "DataBase.h"
#import "MBProgressHUD.h"


@interface DetailOrderConfirmationViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    IBOutlet UITableView *commonListTableview,*finalConfirmTableview;
    
    NSMutableArray *headerDataArray,*finalHeaderDataArray;
    
    IBOutlet UIButton *startBtn,*stopBtn,*finishBtn;
     BOOL startFlag;
     NSMutableArray *pcnfResetTimerArray;
     IBOutlet UILabel *confirmOrderStatusLabel,*confirmOrderStatusLabelinFinish,*confirmOperationStatusLabel;
     NSString *aueruid,*noremainingWork;
     IBOutlet UIView *finalConfirmView;
     int headerCommonIndex,headerFinalConfirmIndex,tag;
 
    BOOL finalFlag;
    
    MBProgressHUD *hud;
    
    NSMutableDictionary *orderHeaderDetails;

    NSString *decryptedUserName;
    
    NSString * finalworkunitString;

}

@property (nonatomic, strong) UITableView *dropDownTableView;
@property (nonatomic, strong) UIToolbar*  mypickerToolbar,*numberToolBar;

@property (nonatomic, retain) NSMutableArray *dropDownArray;

//Assigning Date Pickers
@property (nonatomic, retain) UIDatePicker *startMalFunctionDatePicker,*EndMalFunctionDatePicker,*measurementDocDatePicker,*measurementDocTimePicker;

@property (nonatomic, retain) NSDate *minStartDate,*minEndDate,*measureMentDocumentTime,*measureMentDocumentDate;

@property(nonatomic,retain) NSArray *detailOperationsArray,*headerDetailsArray;

@property(nonatomic,retain) NSString *orderNuber,*statusString,*udidString;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorView;


@end
