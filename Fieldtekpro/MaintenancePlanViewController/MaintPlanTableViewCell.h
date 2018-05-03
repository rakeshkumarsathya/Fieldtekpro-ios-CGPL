//
//  MaintPlanTableViewCell.h
//  Fieldtekpro
//
//  Created by Enstrapp Bangalore on 25/04/16.
//  Copyright © 2016 Enstrapp IT Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MaintPlanTableViewCell : UITableViewCell

@property(nonatomic, retain) IBOutlet UILabel *orderNumberTextLabel,*equipmentTextLabel,*maintenancePlanTextLabel,*maintenanceItemTextLabel,*maintenanceItemText_textLabel,*startDateTextLabel;

@property(nonatomic, retain) IBOutlet UIButton *orderNumberTextBtn;


@end
