//
//  MyOrdersTableViewCell.h
//  Fieldtekpro
//
//  Created by Enstrapp on 07/08/15.
//  Copyright (c) 2015 Enstrapp IT Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyOrdersTableViewCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UIImageView *attachmentImage,*statusCodeImage;

@property (nonatomic, retain) IBOutlet UILabel *orderNoLabel,*orderTextLabel,*priorityLabel,*startDateLabel,*statusCodeLabel;

@property (nonatomic, strong) IBOutlet UIButton *statusButton,*changeOrderButton,*systemStatusButton,*wocoButton;

@property IBOutlet UIView *orderContentView;

@end
