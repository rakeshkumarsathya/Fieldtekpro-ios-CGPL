//
//  MaintenacePlanViewController.h
//  Fieldtekpro
//
//  Created by Sathya Rakesh Kumar on 08/12/17.
//  Copyright © 2017 Enstrapp Bangalore. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FilterSortTableViewCell.h"
#import "MaintPlanTableViewCell.h"
#import "DetailMaintenancePlantTableViewCell.h"
#import "ConnectionManager.h"
#import "DataBase.h"
#import "MBProgressHUD.h"


@interface MaintenacePlanViewController : UIViewController
{
    IBOutlet UITableView *myMaintPlansTableView,*detailPlantMainTableView,*sortTableview;
    IBOutlet UIView *maintainancePlanView,*detailPlantMaintainanceView,*filterView,*searchView,*blackView;;
    
    NSMutableArray *structuredFilterSortedArray;
     NSString *startDate,*endDate;
    
    int selectedIndexPath;
    
    NSString *decryptedUserName;

    MBProgressHUD *hud;

    IBOutlet UILabel *myMaintPlantLabel;

 }

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) NSUserDefaults *defaults;

@property (weak, nonatomic) IBOutlet UISearchBar *maintenancePlanSearchBar;
 
@property (nonatomic, retain) NSMutableArray *maintPlantsArray;

@property(nonatomic, retain) NSArray *filteredArray;
//Assigning Date Pickers
@property (nonatomic, retain) UIDatePicker *startDatePicker,*EndDatePicker;
@property (nonatomic, retain) NSDate *minStartDate,*minEndDate;

@property(nonatomic,strong) NSString *equipmentNumberString;


@end
