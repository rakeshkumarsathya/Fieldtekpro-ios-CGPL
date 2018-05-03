//
//  LongtextViewController.m
//  Fieldtekpro
//
//  Created by Sathya Rakesh Kumar on 22/03/18.
//  Copyright © 2018 Enstrapp Bangalore. All rights reserved.
//

#import "LongtextViewController.h"

@interface LongtextViewController ()

@end

@implementation LongtextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    res_obj=[Response sharedInstance];
    
    if (self.nonEditableString.length) {
        
        nonEditableTextview.text=self.nonEditableString;
        editableTextview.text=@"";
        
    }
    
    if (self.editableString.length) {
        
        nonEditableTextview.text=@"";
        editableTextview.text=self.editableString;
        
    }
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([editableTextview.text isEqualToString:@"Enter text here"]) {
        editableTextview.text = @"";
        editableTextview.textColor = [UIColor blackColor]; //optional
    }
    
}
- (void)textViewDidEndEditing:(UITextView *)textView
{
    if (textView==editableTextview) {
        if ([editableTextview.text isEqualToString:@"Enter text here"]) {
            editableTextview.text = @"";
            editableTextview.textColor = [UIColor lightGrayColor]; //optional
        }
        
        [editableTextview resignFirstResponder];
    }
 }


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (textView==editableTextview) {
        
        if ([text isEqualToString:@""])
        {
            
        }
    }
    
    return YES;
}


-(IBAction)addButtonClicked:(id)sender
{
    res_obj.longTextString=editableTextview.text;
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)backButtonClicked:(id)sender
{
   [self.navigationController popViewControllerAnimated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
