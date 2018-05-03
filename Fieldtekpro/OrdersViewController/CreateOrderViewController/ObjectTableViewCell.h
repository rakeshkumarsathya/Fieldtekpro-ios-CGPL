//
//  ObjectTableViewCell.h
//  Fieldtekpro
//
//  Created by Enstrapp Bangalore on 23/01/17.
//  Copyright © 2017 Enstrapp IT Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ObjectTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *notifText;
@property (strong, nonatomic) IBOutlet UILabel *equipmentText;
@property (strong, nonatomic) IBOutlet UILabel *descriptionText;

@end
