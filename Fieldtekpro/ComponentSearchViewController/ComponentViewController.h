//
//  ComponentViewController.h
//  Fieldtekpro
//
//  Created by Enstrapp Bangalore on 11/01/18.
//  Copyright © 2018 Enstrapp Bangalore. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ComponentTableViewCell.h"
#import "BOMOverViewTableViewCell.h"
#import "Material.h"
#import "DataBase.h"
#import "MBProgressHUD.h"
#import "AppDelegate.h"
#import "CreateOrderViewController.h"

#import "Response.h"


#define UIColorFromRGB(r, g, b)  [UIColor colorWithRed:((r) / 255.0) green:((g) / 255.0) blue:((b) / 255.0) alpha:1.0]


@interface ComponentViewController : UIViewController
{
    IBOutlet UIView *searchView;
    
    IBOutlet UITableView *componentsListTableView;
   
    Material *materialDetail;
    
    BOOL isLevelEnabled,isCompSelected;
    
    MBProgressHUD *hud;
    NSString *decryptedUserName;
    
    IBOutlet UISegmentedControl *componentSegmentControl;

    UISearchBar *bomSearchBar;
    
    Response *res_obj;
    
 
}

@property (nonatomic, retain) NSArray *filteredArray;

@property (nonatomic, retain) NSMutableArray *bomDetailListArray,*componentsListArray;

@property (nonatomic, retain) NSString *equipmentIdString,*plantIDString;

@property (nonatomic, strong) NSUserDefaults *defaults;

@property (nonatomic,weak)id delegate;


 
@end
