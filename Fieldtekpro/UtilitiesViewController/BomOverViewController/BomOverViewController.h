//
//  BomOverViewController.h
//  Fieldtekpro
//
//  Created by Sathya Rakesh Kumar on 06/12/17.
//  Copyright © 2017 Enstrapp Bangalore. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BOMOverViewTableViewCell.h"
#import "FilterSortTableViewCell.h"
#import "DataBase.h"
#import "MBProgressHUD.h"
#import "AppDelegate.h"
#import "ConnectionManager.h"


@interface BomOverViewController : UIViewController
{
    IBOutlet UITableView *bomTableview,*detailBomtableview,*sortTableView;
    
    IBOutlet UIView *bomDetailView,*searchView,*sortView,*blackView;
    
    IBOutlet UIButton *checkBoxHeaderBtn,*reserveBtn,*bomEquipmentOnlineSearchBtn;
    
    NSString *bomValueString,*bomValueHighlighted,*plantValueString,*storageLocationString;

    IBOutlet UILabel *orderNumberLabel,*costCenterLabel,*bomHeaderLabel,*componentsHeaderLabel;
 
     NSArray *filterArray;
    
    NSMutableArray *searchListArray,*syncMapDataMutableArray;

    
    BOOL dateFlag,componentHighlighted,selectedBOM,isRefresh;
    
     MBProgressHUD *hud;
    
    NSString *decryptedUserName;
    
    NSMutableDictionary *inputsDictionary;
    
    IBOutlet UILabel *bomLookupCountLabel,*detailBomCountlabel;

    IBOutlet UIButton *searchBtn,*sortBtn,*refreshBtn;

}

@property (nonatomic, strong) NSUserDefaults *defaults;

@property (weak, nonatomic) IBOutlet UISearchBar *bomSearchBar,*bomListViewSearchBar;


@property (nonatomic, retain) NSMutableArray *bomHeaderArray,*bomDetailListArray;
 @property (nonatomic,retain) NSMutableArray *structuredFilterSortedArray;

@property (strong, nonatomic) UIWindow *window;

@end
