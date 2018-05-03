//
//  StandardCheckPointTableViewCell.h
//  Fieldtekpro
//
//  Created by Enstrapp Bangalore on 27/01/17.
//  Copyright © 2017 Enstrapp IT Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StandardCheckPointTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *checkPointLabel;

@property (strong, nonatomic) IBOutlet UIButton *yesBtn,*noBtn,*naBtn;

@end
