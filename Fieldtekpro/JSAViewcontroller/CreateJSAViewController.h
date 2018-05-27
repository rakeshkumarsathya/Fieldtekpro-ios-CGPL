//
//  CreateJSAViewController.h
//  Fieldtekpro
//
//  Created by Sathya Rakesh Kumar on 26/05/18.
//  Copyright © 2018 Enstrapp Bangalore. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <YAScrollSegmentControl/YAScrollSegmentControl.h>
#import "InputDropDownTableViewCell.h"
#import "JobStepTableViewCell.h"
#import "HazardsTableViewCell.h"
#import "ImpactControlsTableViewCell.h"

@interface CreateJSAViewController : UIViewController<YAScrollSegmentControlDelegate>
{
    IBOutlet UITextField *titleTextField,*remarksTextField,*jobTextField;
    
    IBOutlet UILabel *orderNumberlabel;
    
    IBOutlet UIView *basicInfoview,*assessmentView,*jobLocationView,*jobStepview,*commonListView,*commonAddview,*subView,*segmentView;
    
    YAScrollSegmentControl *segmentControl;
    
    IBOutlet UITableView *commonAddtableview,*commonListTableview;
    
    NSMutableArray *jobStepArray,*hazardsDataArray,*impactsControlDataArray;

}
@end
