//
//  ReservationViewController.h
//  Fieldtekpro
//
//  Created by Sathya Rakesh Kumar on 07/12/17.
//  Copyright © 2017 Enstrapp Bangalore. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Request.h"
#import "NullChecker.h"
#import "DataBase.h"
#import "ConnectionManager.h"
#import "MBProgressHUD.h"
#import "JEValidator.h"

typedef enum BomSelectedDropDown{
    BOMMOVEMENTTYPE = 0,
    BOMCOSTCENTER = 1
    
}BomSelectedDropDown;

#define ID_INDEX 0
#define NAME_INDEX 1

@interface ReservationViewController : UIViewController
{
    UIImageView  *arrow;
    
    IBOutlet UITextField *plantTextfield,*requirementDateTextfield,*movementTypeTextfield,*orderNumberTextfield,*costCenterTextfield,*quantityTextField;
    
    NSMutableDictionary *reserveHeaderDictionary;

    NSMutableString *movementTypeID,*costCenterID;
    
    NSString *decryptedUserName,*storageLocationString;
    
    MBProgressHUD *hud;

 
    NSString *plantValueString;
    
    IBOutlet UILabel *orderNumberLabel;
    
      BOOL dateFlag,componentHighlighted;
    
    NSMutableDictionary *reserveStockHeaderDictionary;

    
    
    IBOutlet UIView *orderNumberView;
 
 }

@property (nonatomic, strong) NSUserDefaults *defaults;
 @property(nonatomic,retain) NSArray *detailBomDetailsArray;

//Assigning Date Pickers
@property (nonatomic, retain) UIDatePicker *requirementDatePicker;
@property (nonatomic, retain) NSDate *minStartDate,*minEndDate;

@property (nonatomic, strong) UITableView *dropDownTableView;
@property (nonatomic, strong) UIToolbar*  mypickerToolbar;
@property (nonatomic, retain) NSMutableArray  *dropDownArray;

@property (nonatomic, retain) NSString  *plantValueString,*stockSelectedString;


@end
