//
//  MyNotificationsListTableViewCell.h
//  Fieldtekpro
//
//  Created by Enstrapp on 27/07/15.
//  Copyright (c) 2015 Enstrapp IT Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyNotificationsListTableViewCell : UITableViewCell

@property (nonatomic, retain) IBOutlet UILabel *notificationNoLabel,*notificationTextLabel,*priorityLabel,*startDateLabel,*statusCodeLabel;
@property (nonatomic, strong) IBOutlet UIImageView *attachmentImage,*statusCodeImage;

@property (nonatomic, strong) IBOutlet UIButton *statusButton,*changeNotificationButton,*systemStatusButton;


@property  IBOutlet UIView *notifView;


@end
