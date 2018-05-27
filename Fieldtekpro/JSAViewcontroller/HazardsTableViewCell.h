//
//  HazardsTableViewCell.h
//  Fieldtekpro
//
//  Created by Sathya Rakesh Kumar on 27/05/18.
//  Copyright © 2018 Enstrapp Bangalore. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HazardsTableViewCell : UITableViewCell

@property IBOutlet UIView *hazardContentView;

@property (nonatomic, retain) IBOutlet UILabel *jobStepValue,*hazardcategoryValue,*hazardValue;
@end
