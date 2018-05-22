//
//  ApllicationsDropDownViewController.h
//  Fieldtekpro
//
//  Created by Enstrapp Bangalore on 24/01/18.
//  Copyright © 2018 Enstrapp Bangalore. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataBase.h"
#import "CreateOrderViewController.h"

#import "Response.h"

@interface ApllicationsDropDownViewController : UIViewController
{
    NSString *applicationTypeString,*applicationObjArt;
    
    IBOutlet UITableView *applicationsTableview;
    
    Response *res_obj;
    
    
}
@property (nonatomic, retain) NSMutableArray *applicationTypesArray;
@property (nonatomic, retain) NSString *plantWorkCenterID;
@property (nonatomic,weak)id delegate;


@end
