//
//  ViewHistoryViewController.h
//  Fieldtekpro
//
//  Created by Sathya Rakesh Kumar on 10/12/17.
//  Copyright © 2017 Enstrapp Bangalore. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HistoryTableViewCell.h"
#import "FilterSortTableViewCell.h"
#import "DataBase.h"
#import "ConnectionManager.h"
#import "MBProgressHUD.h"
#import "Reachability.h"


@interface ViewHistoryViewController : UIViewController
{
    IBOutlet UITableView *historyTableview,*sortTableView;
    
    NSMutableArray *structuredFilterSortedArray;

    IBOutlet UIView *searchView,*sortView,*blackView;
    
     UIAlertView *deleteLogsResponseAlertView,*retryResponseAlertView,*createNotificationResponseAlertView,*cancelResponseAlertView,*completeResponseAlerView,*alert_ReserveSuccess,*createResponseAlertView,*alert_ChangeOrder,*responseAlertView,*releaseResponseAlertView,*monitorSetMDocsResponseAlertView;
    
    NSUserDefaults *defaults;
    NSString *decryptedUserName;
    IBOutlet UILabel *myTransactionsCountLabel,*newTransactionsCountLabel,*successTransactionsCountLabel,*errorTransactionsCountLabel,*headerLabel;
    IBOutlet UIButton *checkBoxHeaderBtn;
    NSMutableArray *selectedCheckBoxArray;
    
    IBOutlet UIButton *deleteImageBtn,*retryBtn;
    BOOL fromUserTransactionTable;
    
    IBOutlet UIButton *filterBackgroundClicked,*searchBtn,*filterBtn,*refreshBtn;
     IBOutlet UILabel *filterByLabel;
    IBOutlet UIView *filterView,*historyView,*alertLogSubView;
    
    MBProgressHUD *hud;
    
    IBOutlet UIButton *sortBtn;

 }

@property (strong, nonatomic) UIWindow *window;

@property (weak, nonatomic) IBOutlet UISearchBar *historySearchBar;

@property (weak, nonatomic) IBOutlet UITableView *filterSortTableView;
@property(nonatomic, retain) NSArray *filteredArray;

@property (nonatomic, retain) NSMutableArray *historyListArray;



@end
