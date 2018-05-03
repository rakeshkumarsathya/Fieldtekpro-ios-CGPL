//
//  DateandTimeTableViewCell.h
//  Fieldtekpro
//
//  Created by Enstrapp Bangalore on 10/10/17.
//  Copyright © 2017 Enstrapp Bangalore. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DateandTimeTableViewCell : UITableViewCell

@property (nonatomic, retain) IBOutlet UILabel *titleLabel;
@property (nonatomic, retain) IBOutlet UITextField *dateTextField,*timeTextField;

@end
