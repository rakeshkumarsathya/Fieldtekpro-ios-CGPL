//
//  UtilitiesViewController.m
//  Fieldtekpro
//
//  Created by Sathya Rakesh Kumar on 06/12/17.
//  Copyright © 2017 Enstrapp Bangalore. All rights reserved.
//

#import "UtilitiesViewController.h"

@interface UtilitiesViewController ()

@end

@implementation UtilitiesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)backButtonClicked:(id)sender
{
     [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)changeSegment:(id)sender
{
    
    selectedSegment = sender;
    segmentcontrol=(UISegmentedControl *)selectedSegment;
    
     int clickedSegment=(int)[segmentcontrol selectedSegmentIndex];
    
        if (clickedSegment == 0)
        {
            [self bomScreen];
        }
        else if (clickedSegment==1){
            
            [self stockScreen];
        }
   }


-(void)bomScreen{
    
    UIViewController *newViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"BomView"];
    newViewController.view.translatesAutoresizingMaskIntoConstraints = NO;
    [self cycleFromViewController:self.currentViewController toViewController:newViewController];
    self.currentViewController = newViewController;
    
}

-(void)stockScreen{
    
    UIViewController *newViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"StockView"];
    newViewController.view.translatesAutoresizingMaskIntoConstraints = NO;
    [self cycleFromViewController:self.currentViewController toViewController:newViewController];
    self.currentViewController = newViewController;
    
}

- (void)cycleFromViewController:(UIViewController*) oldViewController
               toViewController:(UIViewController*) newViewController {
    [oldViewController willMoveToParentViewController:nil];
    [self addChildViewController:newViewController];
    [self addSubview:newViewController.view toView:self.containerView];
    newViewController.view.alpha = 0;
    [newViewController.view layoutIfNeeded];
    
    [UIView animateWithDuration:0.5
                     animations:^{
                         newViewController.view.alpha = 1;
                         oldViewController.view.alpha = 0;
                     }
                     completion:^(BOOL finished) {
                         [oldViewController.view removeFromSuperview];
                         [oldViewController removeFromParentViewController];
                         [newViewController didMoveToParentViewController:self];
                     }];
}

- (void)addSubview:(UIView *)subView toView:(UIView*)parentView {
    
    [parentView addSubview:subView];
    NSDictionary * views = @{@"subView" : subView,};
    NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[subView]|"
                                                                   options:0
                                                                   metrics:0
                                                                     views:views];
    [parentView addConstraints:constraints];
    constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[subView]|"
                                                          options:0
                                                          metrics:0
                                                            views:views];
    [parentView addConstraints:constraints];
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
