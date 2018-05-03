//
//  LongtextViewController.h
//  Fieldtekpro
//
//  Created by Sathya Rakesh Kumar on 22/03/18.
//  Copyright © 2018 Enstrapp Bangalore. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Response.h"
@interface LongtextViewController : UIViewController
{
    IBOutlet UITextView *editableTextview,*nonEditableTextview;
    
    Response *res_obj;
    
}

@property (nonatomic,weak)id delegate;

@property (nonatomic, retain) NSString *editableString,*nonEditableString;


@end
