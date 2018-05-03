//
//  MISSelectionViewController.m
//  Fieldtekpro
//
//  Created by Enstrapp Bangalore on 17/01/18.
//  Copyright © 2018 Enstrapp Bangalore. All rights reserved.
//

#import "MISSelectionViewController.h"

@interface MISSelectionViewController ()

@end

@implementation MISSelectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    misListArray=[NSMutableArray new];
    
    [self containsAllFunctionsMethod];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)containsAllFunctionsMethod
{
    [misListArray addObject:[NSArray arrayWithObjects:@"PermitReport.png",@"Permit report", nil]];
    
     [misListArray addObject:[NSArray arrayWithObjects:@"NotificationReport.png",@"Notification Analysis", nil]];
    
    [misListArray addObject:[NSArray arrayWithObjects:@"Breakdown.png",@"Breakdown Statistics", nil]];
    
    [misListArray addObject:[NSArray arrayWithObjects:@"Inventory-Management.png",@"Order Analysis", nil]];
    
}



- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [misListArray count];
    
}


// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"Cell";
    
    MISCollectionViewCell *cell = (MISCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    cell.iconView.image=[UIImage imageNamed:[[misListArray objectAtIndex:indexPath.row] objectAtIndex:0]];
    
    cell.titleLabel.text=[[misListArray objectAtIndex:indexPath.row] objectAtIndex:1];
    
    [cell.titleLabel sizeToFit];
    
    return cell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
  
  
    MISViewController *misVC  = [[MISViewController alloc]initWithNibName:@"MISViewController_iPhone5" bundle:nil];
    
 
 
    if (indexPath.row==0)
    {
        misVC.selectedValue=@"Permit Report";
    }
    else if (indexPath.row==1){
        
        misVC.selectedValue=@"Notif Analysis";
     }
    
    else if (indexPath.row==3){
        
        misVC.selectedValue=@"Order Analysis";
    }
    
    
    [self.navigationController pushViewController:misVC animated:YES];
    
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
