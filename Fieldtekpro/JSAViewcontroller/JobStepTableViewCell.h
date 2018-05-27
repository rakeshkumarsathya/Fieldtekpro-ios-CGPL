//
//  JobStepTableViewCell.h
//  Fieldtekpro
//
//  Created by Sathya Rakesh Kumar on 26/05/18.
//  Copyright © 2018 Enstrapp Bangalore. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JobStepTableViewCell : UITableViewCell

 @property IBOutlet UIView *jobStepContentView;

@property (nonatomic, retain) IBOutlet UILabel *stepNoValue,*jobStepvalue,*personResponsibleValue;



@end
