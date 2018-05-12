//
//  WorkcenterViewController.h
//  Fieldtekpro
//
//  Created by Sathya Rakesh Kumar on 12/05/18.
//  Copyright © 2018 Enstrapp Bangalore. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FilterWorkcenterTableViewCell.h"
#import "MyNotifcationsViewController.h"
#import "Response.h"

@interface WorkcenterViewController : UIViewController
{
    IBOutlet UITableView *wrkCenterTableview;
     NSMutableArray *workcenterArray,*checkBoxSelectedArray;
    
    Response *res_obj;
    
    IBOutlet UILabel *headerTitleLabel;
 }

@property (nonatomic,weak)id delegate;

@property (nonatomic, retain) NSArray *filteredArray;


@end
