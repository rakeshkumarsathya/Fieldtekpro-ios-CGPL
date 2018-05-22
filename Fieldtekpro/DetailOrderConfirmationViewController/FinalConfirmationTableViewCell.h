//
//  FinalConfirmationTableViewCell.h
//  Fieldtekpro
//
//  Created by Sathya Rakesh Kumar on 17/05/18.
//  Copyright © 2018 Enstrapp Bangalore. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FinalConfirmationTableViewCell : UITableViewCell

@property (nonatomic, retain) IBOutlet UILabel *titleLabel,*madatoryLabel;

@property (nonatomic, retain) IBOutlet UITextView *confirmTextview;



@end
