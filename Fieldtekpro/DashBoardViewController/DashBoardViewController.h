//
//  DashBoardViewController.h
//  Fieldtekpro
//
//  Created by Enstrapp Bangalore on 09/10/17.
//  Copyright © 2017 Enstrapp Bangalore. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewHistoryViewController.h"
#import "Request.h"
#import "Response.h"
#import "JEValidator.h"
#import "NSData+AESCrypt.h"
#import "NSData+AESCrypt.h"
#import "NSString+AESCrypt.h"
#import <CommonCrypto/CommonCrypto.h>
#import "DataBase.h"
#import "ConnectionManager.h"
#import "MBProgressHUD.h"
#import "AppDelegate.h"
#import "FunctionLocationViewController.h"
#import "IsolationViewController.h"
#import "AppDelegate.h"

@interface DashBoardViewController : UIViewController
{
    IBOutlet UICollectionView *collectionViewVc;
    
    IBOutlet UIView *dashBoardView,*blackView;
      NSMutableArray *imagesArray,*textArray;
    
    BOOL isRefresh,stockDeleted;
    
    NSMutableArray *syncMapDataMutableArray;

    MBProgressHUD *hud;

    NSMutableArray *busfResultArray,*mUserFResultArray,*screenUserresultArray;
    
 
 
 }

@property (strong, nonatomic) UIWindow *window;


@property (nonatomic, strong) NSUserDefaults *defaults;
@property(nonatomic,retain) NSString *userNameString;


@end
