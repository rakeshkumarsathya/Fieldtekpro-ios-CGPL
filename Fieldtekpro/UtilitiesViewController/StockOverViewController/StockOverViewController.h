//
//  StockOverViewController.h
//  Fieldtekpro
//
//  Created by Sathya Rakesh Kumar on 06/12/17.
//  Copyright © 2017 Enstrapp Bangalore. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StockOverViewTableViewCell.h"
#import "FilterSortTableViewCell.h"
#import "ReservationViewController.h"
#import "ConnectionManager.h"
#import "DataBase.h"

@interface StockOverViewController : UIViewController
{
    IBOutlet UITableView *stockTableview,*sortTableView;
    
    IBOutlet UIView *searchView,*sortView,*blackView;
    
    NSMutableArray *syncMapDataMutableArray;
    NSString *decryptedUserName;

        BOOL materialSortSelected,descriptionSortSelected,plantSortSelected,storLocnSortSelected,unrestrictedSortSelected,blockedStockSelected,storageBinselected;
    
    IBOutlet UIButton *MaterialSortBtn,*DescriptionSortBtn,*PlantSortBtn,*storLocnBtnSortBtn,*UnrestrictedSortBtn,*BlockedStockSortBtn,*StorageBinSortBtn;
    
    NSMutableDictionary *inputsDictionary;
    
    NSArray *filterArray;
    
    IBOutlet UILabel *stockOverviewCountLabel;
    
    IBOutlet UIButton *searchBtn,*sortBtn,*refreshBtn;

 
 }

@property (weak, nonatomic) IBOutlet UISearchBar *StockSearchBar;
@property (nonatomic,retain) NSMutableArray *structuredFilterSortedArray;
@property (nonatomic, retain) NSMutableArray *stockListArray;
@property (strong, nonatomic) IBOutlet UIView *stockReserveView;
@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, strong) NSUserDefaults *defaults;


@end
