//
//  OperationWCDTableViewCell.h
//  Fieldtekpro
//
//  Created by Enstrapp Bangalore on 28/01/17.
//  Copyright © 2017 Enstrapp IT Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OperationWCDTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *typeLabel,*objectLabel,*OGLabel,*tagUnLabel;

@property IBOutlet UIView *opwcdContentView;

@property (strong, nonatomic) IBOutlet UIButton *deleteBtn,*tagBtn;



@end
