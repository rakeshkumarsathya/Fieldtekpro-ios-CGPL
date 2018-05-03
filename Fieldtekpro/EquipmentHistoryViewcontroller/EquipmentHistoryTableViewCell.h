//
//  EquipmentHistoryTableViewCell.h
//  Fieldtekpro
//
//  Created by Deepak Gantala on 14/08/15.
//  Copyright (c) 2015 Enstrapp IT Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EquipmentHistoryTableViewCell : UITableViewCell
@property (nonatomic, retain) IBOutlet UILabel *typeLabel,*shortTextLabel,*notificationNumberLabel,*priorityLabel,*startDateLabel,*endDateLabel,*orderNoLabel;

@property (nonatomic,retain) IBOutlet UIImageView *breakdownCheck;

@property  IBOutlet UIView *historyView;


@end
