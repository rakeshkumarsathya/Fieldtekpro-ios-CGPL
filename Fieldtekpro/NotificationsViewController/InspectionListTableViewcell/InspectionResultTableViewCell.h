//
//  InspectionResultTableViewCell.h
//  Fieldtekpro
//
//  Created by Enstrapp Bangalore on 14/06/17.
//  Copyright © 2017 Enstrapp IT Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InspectionResultTableViewCell : UITableViewCell

@property (nonatomic, retain) IBOutlet UILabel *measurementDocumentLabel,*pointLabel,*descLabel,*dateLabel,*readingLabel,*targetLabel,*unitLabel,*personLabel,*resultLabel,*notesLabel;

@end
