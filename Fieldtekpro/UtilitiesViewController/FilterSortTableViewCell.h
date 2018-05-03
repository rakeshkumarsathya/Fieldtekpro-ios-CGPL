//
//  FilterSortTableViewCell.h
//  Fieldtekpro
//
//  Created by Enstrapp Bangalore on 10/03/16.
//  Copyright © 2016 Enstrapp IT Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FilterSortTableViewCell : UITableViewCell

@property (nonatomic, retain) IBOutlet UILabel *headerLabel,*headerlabelValue;

@property (nonatomic, retain) IBOutlet UIButton *filterSortCheckBoxButton;

@property (nonatomic, retain) IBOutlet UIImageView *dateImageView;

@property (nonatomic, strong) IBOutlet UITextField *dateTextfield;

@end
