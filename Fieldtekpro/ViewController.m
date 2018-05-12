//
//  ViewController.m
//  Fieldtekpro
//
//  Created by Enstrapp Bangalore on 09/10/17.
//  Copyright © 2017 Enstrapp Bangalore. All rights reserved.
//

#import "ViewController.h"
#import "DashBoardViewController.h"

@interface ViewController ()
{
    UIImageView  *arrow;
}
@end

@implementation ViewController

@synthesize defaults;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view, typically from a nib.
     defaults=[NSUserDefaults standardUserDefaults];
    
  //  [systemstatusHeaderView setBackgroundColor:UIColorFromRGB(246, 241, 247)];
 
    [self setStatusBarBackgroundColor:[UIColor colorWithRed:38.0/255.0 green:85.0/255.0 blue:153.0/255.0 alpha:1.0]];
    
//    NSArray *tempArray=[[DataBase sharedInstance] testEntityData:@""];
//    NSLog(@"test data is %@",tempArray);
    
      [self.navigationController setNavigationBarHidden:YES animated:YES];
      [self setRightView:userNameTextField withImage:@"username"];
      [self setRightView:passwordTextField withImage:@"password"];
  }
 
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [userNameTextField resignFirstResponder];
    [passwordTextField resignFirstResponder];
    
    
    if ([defaults objectForKey:@"userName"] ==nil || [defaults objectForKey:@"password"] == nil ) {
        userNameTextField.text = @"";
        passwordTextField.text = @"";
    }
    else
    {
        NSString *decryptedUserNameString = [defaults objectForKey:@"userName"];
        userNameTextField.text = [[NSString alloc] initWithString:[decryptedUserNameString AES128DecryptWithKey:@""]];
        NSString *decryptedPasswordString = [defaults objectForKey:@"password"];
        passwordTextField.text = [[NSString alloc] initWithString:[decryptedPasswordString AES128DecryptWithKey:@""]];
     }
    if ([[defaults objectForKey:@"rememberCheck"] isEqualToString:@"X"])
    {
        rememberMeCheckBoxSeleted=YES;
        [_rememberButton setImage:[UIImage imageNamed:@"CheckBoxSelection"] forState:UIControlStateNormal];
     }
    else
    {
        userNameTextField.text = @"";
        passwordTextField.text = @"";
        [_rememberButton setImage:[UIImage imageNamed:@"checkBoxUnSelection"] forState:UIControlStateNormal];
        rememberMeCheckBoxSeleted=NO;
    }
    if ([[defaults objectForKey:@"Refresh_Check"] isEqualToString:@"X"])
    {
        
    }
 }

- (void)setStatusBarBackgroundColor:(UIColor *)color {
    
    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    
    if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
        statusBar.backgroundColor = color;
    }
}

-(void)setRightView:(UITextField *)textField withImage:(NSString *)imageview
{
     arrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",imageview]]];
     arrow.frame = CGRectMake(0.0, 0.0, arrow.image.size.width+10.0, arrow.image.size.height);
     arrow.contentMode = UIViewContentModeCenter;
    
     textField.leftView = arrow;
     textField.leftViewMode = UITextFieldViewModeAlways;
}

-(IBAction)loginBtn:(id)sender
{
    [self loginFunction];
}

-(void)loginCredentialsResponse{
    
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDAnimationFade;
    hud.label.text = @"Signing in....";
    
    [defaults setObject:[defaults objectForKey:@"ENDPOINT"] forKey:@"ENDPOINT"];
    [defaults synchronize];
    
    NSMutableDictionary *loginID = [[NSMutableDictionary alloc]init];
    [loginID setObject:@"EN" forKey:@"LANGUAGE"];
    [loginID setObject:[userNameTextField.text copy] forKey:@"USERNAME"];
    
    NSData *passwordData = [passwordTextField.text dataUsingEncoding:NSUTF8StringEncoding];
    NSString *passwordString = [passwordData base64Encoding];
    [loginID setObject:passwordString forKey:@"PASSWORD"];
    [Request makeWebServiceRequest:LOGIN parameters:loginID delegate:self];
    
}

#pragma mark-
#pragma mark- Validator Methods


-(void)showAlertMessageWithTitle:(NSString*)title message:(NSString*)message cancelButtonTitle:(NSString *)cancelBtnTitle{
    
    UIAlertController * alert=[UIAlertController alertControllerWithTitle:title
                                                                  message:message
                                                           preferredStyle:UIAlertControllerStyleAlert];
    
    //    UIAlertAction* yesButton = [UIAlertAction actionWithTitle:@"Yes, please"
    //                                                        style:UIAlertActionStyleDefault
    //                                                      handler:^(UIAlertAction * action)
    //                                {
    //                                    /** What we write here???????? **/
    //                                    NSLog(@"you pressed Yes, please button");
    //
    //                                    // call method whatever u need
    //                                }];
    
    UIAlertAction* okButton = [UIAlertAction actionWithTitle:cancelBtnTitle
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * action)
                               {
                                   /** What we write here???????? **/
                                   NSLog(@"you pressed No, thanks button");
                                   // call method whatever u need
                                   [alert dismissViewControllerAnimated:YES completion:nil];
                                   
                               }];
    
    // [alert addAction:yesButton];
    [alert addAction:okButton];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}

#pragma mark- request Delegate

- (void)resultData:(NSDictionary *)resultData withErrorDescription:(NSString *)errorDescription requestID:(WebServiceRequest)requestID :(int)statusCode
{
    switch (requestID) {
            
        case LOGIN:
            
            if (!errorDescription.length) {
                
                // NSMutableDictionary *parsedDictionary = [[Response sharedInstance] parseForLogin:resultData];
                
              //  [ActivityView dismiss];
                
                if (statusCode == 401) {
                    
                     [defaults removeObjectForKey:@"password"];
                     [defaults removeObjectForKey:@"userName"];
                     [defaults removeObjectForKey:@"INITIAL"];
 
                    
                     if ([resultData objectForKey:@"message"]) {
                        
                        [self showAlertMessageWithTitle:@"Failed" message:[resultData objectForKey:@"message"] cancelButtonTitle:@"Ok"];

                    }
                    else if (![resultData count]){
 
                        [self showAlertMessageWithTitle:@"Login Failed" message:@"Try Again" cancelButtonTitle:@"Ok"];
 
                    }
                    else{
 
                        [self showAlertMessageWithTitle:@"Failed" message:@"Please Check your Login Credentials" cancelButtonTitle:@"Ok"];
                     }
                  }
                else
                {
                    if (statusCode==200) {
                        
                        [self setUserDefaultValues];
                        
                         if ([[defaults objectForKey:@"ACTIVATELOGS"] isEqualToString:@"X"])
                        {
                            [[DataBase sharedInstance] writToLogFile:[NSString stringWithFormat:@"#INFO#.com.enstrapp.fieldtekpro# #Activity:Login Successfull #Username:%@ #DeviceId:%@",userNameTextField.text,[defaults objectForKey:@"edeviceid"]]];
                        }
                        
                        
                        [[NSUserDefaults standardUserDefaults] setObject:@"ODATA" forKey:@"ENDPOINT"];
                        
                        [[DataBase sharedInstance] writToLogFile:[NSString stringWithFormat:@"Login Successfull user name : %@",userNameTextField.text]];
                        
                        [self navigateToDashboardViewController];
                    }
                    else{
                        
                        
                         [self showAlertMessageWithTitle:@"Failed" message:[resultData objectForKey:@"message"] cancelButtonTitle:@"Ok"];
 
                    }
                }
            }
            else{
                
                [defaults removeObjectForKey:@"password"];
                [defaults removeObjectForKey:@"userName"];
                [defaults removeObjectForKey:@"INITIAL"];
                
                [self showAlertMessageWithTitle:@"Error!" message:errorDescription cancelButtonTitle:@"Ok"];
 
            }
            
            [defaults synchronize];
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];

            break;
            
        default: break;
    }
}

-(void)navigateToDashboardViewController
{
    
    DashBoardViewController *dashVc = [self.storyboard instantiateViewControllerWithIdentifier:@"DashIdentifier"];
    dashVc.userNameString = userNameTextField.text;
    [self showViewController:dashVc sender:self];
    
    
}

-(void)loginFunction
{
    if(![JEValidator validateTextValue:userNameTextField.text])
    {
        [self showAlertMessageWithTitle:@"Failure" message:@"Please Enter User Name" cancelButtonTitle:@"Ok"];
    }
    else if(![JEValidator validateTextValue:passwordTextField.text])
    {
        [self showAlertMessageWithTitle:@"Failure" message:@"Please Enter Password" cancelButtonTitle:@"Ok"];
    }
    else{
        
        if ([self.defaults objectForKey:@"userName"] ==nil || [self.defaults objectForKey:@"password"] == nil ) {
            
            if ([[ConnectionManager defaultManager] isReachable]) {
                 [self loginCredentialsResponse];
            }
            else
            {
                
                [self showAlertMessageWithTitle:@"No Network Available" message:@"Please check your internet connection" cancelButtonTitle:@"Ok"];
             }
        }
        else{
            
            [self validateUserWithLocal];
        }
    }
}

-(IBAction)login:(id)sender
{
 
    DashBoardViewController *dashVc = [self.storyboard instantiateViewControllerWithIdentifier:@"DashIdentifier"];
    dashVc.userNameString = userNameTextField.text;
    [self showViewController:dashVc sender:self];
    
   // [self loginFunction];
}

-(void)setUserDefaultValues{
    
    NSString *key = @"";
    
    invalidCredentailsCheck = NO;
    
    NSString *username=userNameTextField.text;
    NSString *password=passwordTextField.text;
    
    NSString *encryptedUsername = [username AES128EncryptWithKey:key];
    NSLog( @"Encrypted username: %@\n", encryptedUsername );
    
    [defaults setObject:encryptedUsername forKey:@"userName"];
    
    NSString *encryptedPassword = [password AES128EncryptWithKey:key];
    NSLog( @"Encrypted password: %@\n", encryptedPassword );
    
    [defaults setObject:encryptedPassword forKey:@"password"];
    
    //    [defaults setObject:userNameTextField.text forKey:@"userName"];
    //    [defaults setObject:passwordTextField.text forKey:@"password"];
    
    
    if (![defaults objectForKey:@"INITIAL"]) {
        [defaults setObject:@"INITIAL" forKey:@"INITIAL"];
    }
    
    [defaults synchronize];
    
    return;
}

- (BOOL)validateUserWithLocal
{
    //NSString *key = @"";
    NSString *userNameStr = [defaults objectForKey:@"userName"];
    NSString *passwordStr = [defaults objectForKey:@"password"];
    
    if ([defaults objectForKey:@"userName"] && [defaults objectForKey:@"password"]) {
        if ([[defaults objectForKey:@"userName"] isEqualToString:userNameStr] && [[defaults objectForKey:@"password"] isEqualToString:passwordStr]) {
            
            [defaults removeObjectForKey:@"INITIAL"];
            [defaults synchronize];
             [self navigateToDashboardViewController];
            return YES;
        }
        else if ([[defaults objectForKey:@"userName"] isEqualToString:userNameStr]){
        }
        else{
            [defaults removeObjectForKey:@"INITIAL"];
            [defaults synchronize];
        }
        
        if ([[ConnectionManager defaultManager] isReachable]) {
           // [ActivityView show:@"Signing in..."];
            [self loginCredentialsResponse];
        }
        else{
            
            [self showAlertMessageWithTitle:@"Failed" message:@"Please Check your Login Credentials" cancelButtonTitle:@"Ok"];
         }
    }
    
    return NO;
}


-(IBAction)settingsClicked:(id)sender{
    
    UIViewController *dashVc = [self.storyboard instantiateViewControllerWithIdentifier:@"AppSettingsVC"];
    
    [self showViewController:dashVc sender:self];
 }


- (IBAction)rememberSelected:(id)sender
{
    [self rememberMeCheckMark];
}

-(void)rememberMeCheckMark
{

    if (rememberMeCheckBoxSeleted == NO)
    {
        rememberMeCheckBoxSeleted = YES;
        rememberMeCheckBoxString = @"X";
        [defaults setObject:@"X" forKey:@"rememberCheck"];
        [defaults synchronize];
        
        [_rememberButton setImage:[UIImage imageNamed:@"CheckBoxSelection"] forState:UIControlStateNormal];
    }
    else
    {
        rememberMeCheckBoxString = @" ";
        [_rememberButton setImage:[UIImage imageNamed:@"checkBoxUnSelection"] forState:UIControlStateNormal];
        rememberMeCheckBoxSeleted = NO;
        
        [defaults setObject:@"" forKey:@"rememberCheck"];
        [defaults synchronize];
    }
    
}




@end
