//
//  MISSelectionViewController.h
//  Fieldtekpro
//
//  Created by Enstrapp Bangalore on 17/01/18.
//  Copyright © 2018 Enstrapp Bangalore. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MISCollectionViewCell.h"
#import "MISViewController.h"

@interface MISSelectionViewController : UIViewController

{
    NSMutableArray *misListArray;
    
    IBOutlet UICollectionView *collectionViewVc;
    
}
@property (nonatomic, strong) NSUserDefaults *defaults;

@property(nonatomic,strong) UIViewController *currentController;


@end
