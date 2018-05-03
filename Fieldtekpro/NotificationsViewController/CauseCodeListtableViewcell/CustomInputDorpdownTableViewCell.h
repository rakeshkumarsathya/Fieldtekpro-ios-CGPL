//
//  CustomInputDorpdownTableViewCell.h
//  Fieldtekpro
//
//  Created by Sathya Rakesh Kumar on 11/10/17.
//  Copyright © 2017 Enstrapp Bangalore. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomInputDorpdownTableViewCell : UITableViewCell

@property (nonatomic, retain) IBOutlet UILabel *titleLabel,*mandatoryLabel;

@property (nonatomic, retain) IBOutlet UITextField *InputTextField;

@property (nonatomic, retain) IBOutlet UIButton *additionalDatabtn;

@property (nonatomic, retain) IBOutlet UIImageView *dropDownImageView;

@property (nonatomic, retain) IBOutlet UIButton *releaseBtn,*successBtn,*completeBtn;

@property  IBOutlet UIView *notifView;


@end
