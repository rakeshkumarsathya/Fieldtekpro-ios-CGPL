//
//  FunctionalLocationTableViewCell.h
//  Fieldtekpro
//
//  Created by Deepak Gantala on 18/08/15.
//  Copyright (c) 2015 Enstrapp IT Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FunctionalLocationTableViewCell : UITableViewCell
@property (nonatomic, retain) IBOutlet UILabel *funcLocationIdLabel,*funcLocationDescriptionLabel,*plantLabel,*workCenterLabel,*costCenterLabel,*categoryLabel,*plannerGroupLabel;

@property (strong, nonatomic) IBOutlet UIButton *detailButton,*funcLocBtn;

@property (strong,nonatomic) IBOutlet UIImageView *rightArrowImageview;

@property  IBOutlet UIView *funcLocContentView;



@end
