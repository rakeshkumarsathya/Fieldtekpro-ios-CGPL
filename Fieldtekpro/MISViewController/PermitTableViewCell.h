//
//  PermitTableViewCell.h
//  Fieldtekpro
//
//  Created by enstrapp on 16/02/17.
//  Copyright © 2017 Enstrapp IT Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PermitTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *wcnrIdText;
@property (strong, nonatomic) IBOutlet UILabel *nameText;
@property (strong, nonatomic) IBOutlet UILabel *orderText;
@property (strong, nonatomic) IBOutlet UILabel *funcLocationText;
@property (strong, nonatomic) IBOutlet UILabel *dateFromText;
@property (strong, nonatomic) IBOutlet UILabel *dateToText;
@property (strong, nonatomic) IBOutlet UILabel *permitCountLabel;

@end
