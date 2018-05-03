//
//  TaskCodeTableViewCell.h
//  Fieldtekpro
//
//  Created by Enstrapp Bangalore on 26/12/16.
//  Copyright © 2016 Enstrapp IT Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TaskCodeTableViewCell : UITableViewCell
@property (nonatomic, retain) IBOutlet UILabel *taskCodeLabel,*taskDescriptionLabel,*taskProcessorLabel,*sDateLabel;
@property (nonatomic, retain) IBOutlet UIImageView *taskReleaseImageView,*taskCompleteImageView,*taskSuccessImageView;


@end
