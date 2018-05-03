//
//  BOMOverViewTableViewCell.h
//  Fieldtekpro
//
//  Created by Enstrapp Bangalore on 07/08/15.
//  Copyright (c) 2015 Enstrapp IT Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BOMOverViewTableViewCell : UITableViewCell

@property (nonatomic, retain) IBOutlet UILabel *EquipmentBOMLabel,*EquipmentDescriptionLabel,*plantLabel,*countLabel;

@property (nonatomic, retain) IBOutlet UILabel *bomLabel,*componentLabel,*componentTextLabel,*quantityLabel,*unitLabel;

@property (nonatomic, retain) IBOutlet UIButton *EquipmentBOMButton,*equipmentComponentButton;

@property IBOutlet UIView *bomContentView;

@end
