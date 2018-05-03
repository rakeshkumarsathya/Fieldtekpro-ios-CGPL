//
//  HistoryTableViewCell.h
//  Fieldtekpro
//
//  Created by Enstrapp on 10/08/15.
//  Copyright (c) 2015 Enstrapp IT Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HistoryTableViewCell : UITableViewCell
@property (nonatomic, retain) IBOutlet UILabel *dateLabel,*timeLabel,*activityLabel,*objectTypeLabel,*documentTypeLabel,*countLabel;
@property (nonatomic, retain) IBOutlet UIImageView *gradientImage;

@property IBOutlet UIView *historyContentView;

@end
