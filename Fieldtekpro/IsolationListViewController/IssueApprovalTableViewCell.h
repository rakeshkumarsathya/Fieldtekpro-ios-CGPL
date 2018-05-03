//
//  IssueApprovalTableViewCell.h
//  Fieldtekpro
//
//  Created by Enstrapp Bangalore on 15/02/17.
//  Copyright © 2017 Enstrapp IT Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IssueApprovalTableViewCell : UITableViewCell

@property(nonatomic, retain) IBOutlet UILabel *permitLabel,*permittextLabel;

@property(nonatomic, retain) IBOutlet UITextField *approvedByTextField;

 
@end
