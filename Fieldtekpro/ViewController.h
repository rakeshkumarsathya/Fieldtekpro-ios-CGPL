//
//  ViewController.h
//  Fieldtekpro
//
//  Created by Enstrapp Bangalore on 09/10/17.
//  Copyright © 2017 Enstrapp Bangalore. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Request.h"
#import "Response.h"
#import "JEValidator.h"
 //For Encryption
#import "NSData+AESCrypt.h"
#import "NSData+AESCrypt.h"
#import "NSString+AESCrypt.h"
#import <CommonCrypto/CommonCrypto.h>
#import "DataBase.h"
#import "ConnectionManager.h"
#import "MBProgressHUD.h"


@interface ViewController : UIViewController
{

     IBOutlet UITextField *userNameTextField,*passwordTextField;

     BOOL invalidCredentailsCheck;
     BOOL rememberMeCheckBoxSeleted;
     NSString *rememberMeCheckBoxString;
     MBProgressHUD *hud;
 
}

@property (nonatomic, strong) NSUserDefaults *defaults;
@property (weak, nonatomic) IBOutlet UIButton *rememberButton;


@end

