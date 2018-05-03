//
//  AttachmentsTableViewCell.h
//  IncidentManagement
//
//  Created by Sathya Rakesh Kumar on 23/02/18.
//  Copyright © 2018 Rakesh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AttachmentsTableViewCell : UITableViewCell

@property (nonatomic, retain) IBOutlet UILabel *idLabel,*createdDateLabel,*uploadedLabel;

@property (nonatomic, retain) IBOutlet UIImageView *attachmentImage;



@end
