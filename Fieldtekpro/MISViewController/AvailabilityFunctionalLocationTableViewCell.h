//
//  AvailabilityFunctionalLocationTableViewCell.h
//  Fieldtekpro
//
//  Created by enstrapp on 07/03/17.
//  Copyright © 2017 Enstrapp IT Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AvailabilityFunctionalLocationTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *funcLocationId;
@property (strong, nonatomic) IBOutlet UILabel *funcLocationDescription;
@property (strong, nonatomic) IBOutlet UIButton *detailButton;
@property (strong, nonatomic) IBOutlet UIImageView *rightArrowImage;

@end
