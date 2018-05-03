//
//  EquipNumberTableViewCell.h
//  Fieldtekpro
//
//  Created by enstrapp on 07/03/17.
//  Copyright © 2017 Enstrapp IT Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EquipNumberTableViewCell : UITableViewCell

//@property (nonatomic, retain) IBOutlet UILabel *equipmentNumberLabel,*equipmentDescriptionLabel,*fLocDescription,*workCenterLabel,*plantLabel,*catalogProfileLabel;
@property (strong, nonatomic) IBOutlet UIButton *equipmentDetailButton;
@property (strong, nonatomic) IBOutlet UILabel *equipNumberLabel;
@property (strong, nonatomic) IBOutlet UILabel *equipmentDescLabel;

@end
