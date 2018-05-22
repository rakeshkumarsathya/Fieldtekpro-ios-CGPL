//
//  OperationTableViewCell.h
//  Fieldtekpro
//
//  Created by Deepak Gantala on 11/08/15.
//  Copyright (c) 2015 Enstrapp IT Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OperationTableViewCell : UITableViewCell
@property(nonatomic, retain) IBOutlet UILabel *operationTextLabel,*durationLabel;
@property (nonatomic,strong) IBOutlet UIImageView *operationsStatusImageView,*trafficImage;
@property (nonatomic,strong) UIView *bottomLineView;
@property (nonatomic,strong) IBOutlet UILabel *operationCountLabel;
@property (nonatomic, strong) IBOutlet UIImageView *trafficSymbolImageView;

@property IBOutlet UIView *operationContentView;

@end
