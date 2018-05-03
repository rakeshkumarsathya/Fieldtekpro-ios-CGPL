//
//  IsolationViewController.h
//  Fieldtekpro
//
//  Created by Enstrapp Bangalore on 02/02/18.
//  Copyright © 2018 Enstrapp Bangalore. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IsolationListTableViewCell.h"
#import "DataBase.h"

@interface IsolationViewController : UIViewController
{
    IBOutlet UITableView *approvalsTableView;
     NSString *decryptedUserName;
    
}

@property (nonatomic, retain) NSMutableArray *tempIsolationHeaderDetailsArray,*issueApprovalDetailsArray;

@property (nonatomic, strong) NSUserDefaults *defaults;

@property (nonatomic, strong) NSString *isIsolation;


@end
