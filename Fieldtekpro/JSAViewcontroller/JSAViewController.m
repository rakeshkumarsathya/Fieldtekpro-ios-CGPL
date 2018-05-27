//
//  JSAViewController.m
//  Fieldtekpro
//
//  Created by Sathya Rakesh Kumar on 26/05/18.
//  Copyright © 2018 Enstrapp Bangalore. All rights reserved.
//

#import "JSAViewController.h"

#import "JSAListTableViewCell.h"

@interface JSAViewController ()

@end

@implementation JSAViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(IBAction)createJSAClicked:(id)sender{
    
    CreateJSAViewController *createVc = [self.storyboard instantiateViewControllerWithIdentifier:@"createJSAVc"];
    
    [self showViewController:createVc sender:self];
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;              // Default is 1 if not implemented
{
    
    return 1;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (tableView == jsaListTableView)
    {
        return 1;
        
    }
    
    return 1;;
}



-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == jsaListTableView)
    {
        
        static NSString *CellIdentifier = @"Customcell";
        
        JSAListTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell==nil) {
            cell=[[JSAListTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        cell.accessoryType = UITableViewCellAccessoryNone;
        
        return cell;
        
    }
    
    return nil;
    
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
