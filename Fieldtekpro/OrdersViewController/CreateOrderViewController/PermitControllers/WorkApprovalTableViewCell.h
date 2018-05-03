//
//  WorkApprovalTableViewCell.h
//  Fieldtekpro
//
//  Created by Enstrapp Bangalore on 27/01/17.
//  Copyright © 2017 Enstrapp IT Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WorkApprovalTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *workApprovalIDLabel,*shortTextLabel;
@property (strong, nonatomic) IBOutlet UIImageView *trafficSignalImageview ,*permitStatusImageview;

@end
