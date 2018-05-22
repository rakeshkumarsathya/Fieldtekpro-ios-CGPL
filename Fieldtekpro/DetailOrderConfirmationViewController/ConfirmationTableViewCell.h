//
//  ConfirmationTableViewCell.h
//  Fieldtekpro
//
//  Created by Sathya Rakesh Kumar on 17/05/18.
//  Copyright © 2018 Enstrapp Bangalore. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ConfirmationTableViewCell : UITableViewCell

@property (nonatomic, retain) IBOutlet UILabel *titleLabel,*madatoryLabel;
@property (nonatomic, retain) IBOutlet UITextField *InputTextField;

@property (nonatomic, retain) IBOutlet UIImageView *dropDownImageView,*statusImageview;


@property  IBOutlet UIView *confirmContentView;

@end
