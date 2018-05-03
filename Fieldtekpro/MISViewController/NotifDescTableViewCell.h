//
//  NotifDescTableViewCell.h
//  PieChartTest
//
//  Created by enstrapp on 06/01/17.
//  Copyright © 2017 Dilip Lilaramani. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NotifDescTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *notifDetails;
@property (strong, nonatomic) IBOutlet UILabel *statusDetails;
@property (strong, nonatomic) IBOutlet UILabel *textDetails;
@property (strong, nonatomic) IBOutlet UILabel *equipmentDetails;
@property (strong, nonatomic) IBOutlet UIImageView *statusImage;
@property (weak, nonatomic) IBOutlet UILabel *notifCountLabel;

@end
