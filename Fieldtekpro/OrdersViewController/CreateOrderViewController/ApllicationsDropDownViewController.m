//
//  ApllicationsDropDownViewController.m
//  Fieldtekpro
//
//  Created by Enstrapp Bangalore on 24/01/18.
//  Copyright © 2018 Enstrapp Bangalore. All rights reserved.
//

#import "ApllicationsDropDownViewController.h"

@interface ApllicationsDropDownViewController ()

@end

@implementation ApllicationsDropDownViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (self.applicationTypesArray==nil)
    {
        self.applicationTypesArray=[NSMutableArray new];
    }
    else
    {
        [self.applicationTypesArray removeAllObjects];
    }
    
 
    [self.applicationTypesArray addObjectsFromArray:[[DataBase sharedInstance] fetchWCMTypesforPlantID:self.plantWorkCenterID]];
    
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backButtonClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
 
    return [self.applicationTypesArray count];
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
        cell.textLabel.text= cell.textLabel.text = [NSString stringWithFormat:@"%@-%@",[[self.applicationTypesArray objectAtIndex:indexPath.row] objectAtIndex:4],[[self.applicationTypesArray objectAtIndex:indexPath.row] objectAtIndex:3]];
    
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    applicationTypeString=[[self.applicationTypesArray objectAtIndex:indexPath.row] objectAtIndex:4];
    
    applicationObjArt=[[self.applicationTypesArray objectAtIndex:indexPath.row] objectAtIndex:2];
    
    if ([(CreateOrderViewController *)self.delegate respondsToSelector:@selector(dismissApplicationTypesClicked)])
    {
         [(CreateOrderViewController *)self.delegate dismissApplicationTypesClicked];
    }
    
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
