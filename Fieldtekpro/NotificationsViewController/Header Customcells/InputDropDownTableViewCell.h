//
//  InputDropDownTableViewCell.h
//  Fieldtekpro
//
//  Created by Enstrapp Bangalore on 10/10/17.
//  Copyright © 2017 Enstrapp Bangalore. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InputDropDownTableViewCell : UITableViewCell

@property (nonatomic, retain) IBOutlet UILabel *titleLabel,*madatoryLabel;

@property (nonatomic, retain) IBOutlet UITextField *InputTextField;

@property (nonatomic, retain) IBOutlet UIImageView *dropDownImageView;

@property (nonatomic, retain) IBOutlet UIButton *longTextBtn;

@property  IBOutlet UIView *notifView;


@end
