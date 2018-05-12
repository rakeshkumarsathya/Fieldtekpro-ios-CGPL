//
//  InspectionChecklistViewController.h
//  Fieldtekpro
//
//  Created by Sathya Rakesh Kumar on 10/03/18.
//  Copyright © 2018 Enstrapp Bangalore. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CollectionViewCell.h"
#import "FunctionLocationViewController.h"
#import "Response.h"
#import "MyOrdersViewController.h"

@interface InspectionChecklistViewController : UIViewController
{
    
    UIImageView  *arrow;
    
    NSMutableArray *imagesArray;

    IBOutlet UITextField *funcLocnTextfield,*equipmentTextfield;
    
    IBOutlet UICollectionView *collectionViewVc;
    
    NSString *equipmentid;
    
    NSMutableArray *equipmentNumberdetailsArray;
    
    Response *res_obj;
    
    NSString   *functionalLocationID;
}
    
-(void)dismissToCheckListView;
-(void)dismissNumberView;

@end
