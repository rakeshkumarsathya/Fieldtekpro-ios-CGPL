//
//  StockOverViewTableViewCell.h
//  Fieldtekpro
//
//  Created by Enstrapp on 06/08/15.
//  Copyright (c) 2015 Enstrapp IT Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StockOverViewTableViewCell : UITableViewCell

@property (nonatomic, retain) IBOutlet UILabel *materialLabel,*descriptionLabel,*plantLabel,*StorlocnLabel,*StatusCodeLabel,*unresrictedLabel,*blockedstockLabel,*storagebinLabel,*countLabel;


@property IBOutlet UIView *stockContentView;

@end
