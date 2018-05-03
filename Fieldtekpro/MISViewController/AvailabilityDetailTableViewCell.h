//
//  AvailabilityDetailTableViewCell.h
//  Fieldtekpro
//
//  Created by enstrapp on 27/02/17.
//  Copyright © 2017 Enstrapp IT Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AvailabilityDetailTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *notifTextLabel;
@property (strong, nonatomic) IBOutlet UILabel *equipmentTextLabel;
@property (strong, nonatomic) IBOutlet UILabel *descriptionTextLabel;
@property (strong, nonatomic) IBOutlet UILabel *startDateText;

@end
