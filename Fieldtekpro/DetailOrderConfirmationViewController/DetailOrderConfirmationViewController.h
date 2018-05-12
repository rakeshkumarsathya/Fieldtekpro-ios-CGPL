//
//  DetailOrderConfirmationViewController.h
//  Fieldtekpro
//
//  Created by Sathya Rakesh Kumar on 10/05/18.
//  Copyright © 2018 Enstrapp Bangalore. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "InputDropDownTableViewCell.h"

@interface DetailOrderConfirmationViewController : UIViewController
{
    IBOutlet UITableView *commonListTableview;
    
    NSMutableArray *headerDataArray;
    
    IBOutlet UIButton *startBtn,*stopBtn,*finishBtn;
    
    BOOL startFlag;
}

@property(nonatomic,retain) NSArray *detailOperationsArray;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorView;


@end
