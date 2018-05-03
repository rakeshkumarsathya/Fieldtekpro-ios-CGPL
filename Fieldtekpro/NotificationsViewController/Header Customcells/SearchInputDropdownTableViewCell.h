//
//  SearchInputDropdownTableViewCell.h
//  Fieldtekpro
//
//  Created by Enstrapp Bangalore on 10/10/17.
//  Copyright © 2017 Enstrapp Bangalore. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchInputDropdownTableViewCell : UITableViewCell

@property (nonatomic, retain) IBOutlet UILabel *titleLabel,*scanLabel,*namelabel,*madatoryLabel;
@property (nonatomic, retain) IBOutlet UITextField *InputTextField;

@property (nonatomic, retain) IBOutlet UIButton *searchBtn,*scanBtn,*historyBtn;

@property  IBOutlet UIView *notifView;


@end
