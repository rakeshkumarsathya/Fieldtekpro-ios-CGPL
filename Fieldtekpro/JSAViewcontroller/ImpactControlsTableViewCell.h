//
//  ImpactControlsTableViewCell.h
//  Fieldtekpro
//
//  Created by Sathya Rakesh Kumar on 27/05/18.
//  Copyright © 2018 Enstrapp Bangalore. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImpactControlsTableViewCell : UITableViewCell

@property (nonatomic, retain) IBOutlet UILabel *hazardsValue,*impactsValue,*controlsValue;

@property IBOutlet UIView *impactContentView;



@end
