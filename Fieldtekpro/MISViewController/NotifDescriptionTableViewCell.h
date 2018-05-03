//
//  NotifDescriptionTableViewCell.h
//  Fieldtekpro
//
//  Created by enstrapp on 02/03/17.
//  Copyright © 2017 Enstrapp IT Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NotifDescriptionTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *notificationNum;
@property (strong, nonatomic) IBOutlet UILabel *equipmentNum;
@property (strong, nonatomic) IBOutlet UILabel *equipmentDesc;
@property (weak, nonatomic) IBOutlet UILabel *notifCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *notifNumLabel;

@end
