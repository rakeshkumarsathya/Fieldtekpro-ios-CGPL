//
//  EquipmentHistoryViewController.h
//  Fieldtekpro
//
//  Created by Sathya Rakesh Kumar on 15/12/17.
//  Copyright © 2017 Enstrapp Bangalore. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EquipmentHistoryTableViewCell.h"
#import "NullChecker.h"
#import "DataBase.h"
#import "ConnectionManager.h"
#import "MBProgressHUD.h"


@interface EquipmentHistoryViewController : UIViewController
{
    IBOutlet UITableView *equipmentHistoryTableView;
    NSUserDefaults *defaults;

    NSString *decryptedUserName;
    
    MBProgressHUD *hud;

    IBOutlet UILabel *equipmentHistoryHeaderLabel;
    
}

@property (nonatomic, retain) NSMutableArray *equipmentHistoryDataArray;
@property(nonatomic,strong) NSString *equipmentNumberString;




@end
