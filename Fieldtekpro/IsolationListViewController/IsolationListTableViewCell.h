//
//  IsolationListTableViewCell.h
//  Fieldtekpro
//
//  Created by Sathya Rakesh Kumar on 02/02/18.
//  Copyright © 2018 Enstrapp Bangalore. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IsolationListTableViewCell : UITableViewCell

@property(nonatomic, retain) IBOutlet UILabel *permitLabel,*permittextLabel;

@property(nonatomic, retain) IBOutlet UITextField *approvedByTextField;

@property(nonatomic, retain) IBOutlet UIButton *ordernoBtn;


@end
