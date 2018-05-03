//
//  UtilitiesViewController.h
//  Fieldtekpro
//
//  Created by Sathya Rakesh Kumar on 06/12/17.
//  Copyright © 2017 Enstrapp Bangalore. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UtilitiesViewController : UIViewController
{
    UISegmentedControl *segmentcontrol;
    UIButton *selectedSegment;
    IBOutlet UIView *bomView;
}

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) UIViewController *currentViewController;
@end
