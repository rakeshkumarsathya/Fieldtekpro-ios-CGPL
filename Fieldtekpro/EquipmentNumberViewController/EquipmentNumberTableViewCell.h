//
//  EquipmentNumberTableViewCell.h
//  Fieldtekpro
//
//  Created by Deepak Gantala on 18/08/15.
//  Copyright (c) 2015 Enstrapp IT Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EquipmentNumberTableViewCell : UITableViewCell

@property (nonatomic, retain) IBOutlet UILabel *equipmentNumberLabel,*equipmentDescriptionLabel,*fLocDescription,*workCenterLabel,*plantLabel,*catalogProfileLabel,*tplnrLabel,*equartlabel;

@property (strong, nonatomic) IBOutlet UIButton *equipmentDetailButton,*equipmentHDetailButton,*monitorNotifBtn,*monitorStatisticsBtn,*monitorTimeBtn,*monitorOrdersBtn,*monitorMdocBtn,*monitorMPlan,*menuBtn;

@property  IBOutlet UIView *equipContentView;

@end
