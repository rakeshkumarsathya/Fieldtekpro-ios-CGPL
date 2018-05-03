//
//  ApplicationTableViewCell.h
//  Fieldtekpro
//
//  Created by Enstrapp Bangalore on 27/01/17.
//  Copyright © 2017 Enstrapp IT Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ApplicationTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *appIDLabel,*applicationNameLabel;

@property (strong, nonatomic) IBOutlet UIImageView *trafficSignalImageview,*permitStatusImageview;


@end
