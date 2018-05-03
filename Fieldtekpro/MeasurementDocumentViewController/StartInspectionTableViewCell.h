//
//  StartInspectionTableViewCell.h
//  Fieldtekpro
//
//  Created by Enstrapp Bangalore on 14/06/17.
//  Copyright © 2017 Enstrapp IT Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StartInspectionTableViewCell : UITableViewCell

@property(nonatomic, retain) IBOutlet UILabel *inspectionLabel,*descriptionlabel,*unitsValueLabel;

@property(nonatomic, retain) IBOutlet UITextField *readingTextfield,*notesTextfield,*valuvationTextField;

@property(nonatomic, retain) IBOutlet UIButton *createdTaskBtn,*normalBtn,*alarmBtn,*criticalBtn;

@property  IBOutlet UIView *inspectionContentView;


@end
