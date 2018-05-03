//
//  MeasureMentDocumentTableViewCell.h
//  Fieldtekpro
//
//  Created by Enstrapp Bangalore on 11/11/16.
//  Copyright © 2016 Enstrapp IT Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MeasureMentDocumentTableViewCell : UITableViewCell
@property (nonatomic, retain) IBOutlet UILabel *measurementPointValueLabel,*measurementDescriptionLabel,*readValueLabel,*timeDateLabel,*mDocLabel,*targetLabel,*unitLabel,*personLabel,*resultLabel,*notesLabel;

@property (nonatomic, retain) IBOutlet UIButton *checkBoxButton;

@property  IBOutlet UIView *mDocsContentView;


@end
