//
//  IsolationViewController.m
//  Fieldtekpro
//
//  Created by Enstrapp Bangalore on 02/02/18.
//  Copyright © 2018 Enstrapp Bangalore. All rights reserved.
//

#import "IsolationViewController.h"
#import "CreateOrderViewController.h"

#define UIColorFromRGB(r, g, b)  [UIColor colorWithRed:((r) / 255.0) green:((g) / 255.0) blue:((b) / 255.0) alpha:1.0]


@interface IsolationViewController ()<UITextFieldDelegate>

@end


@implementation IsolationViewController

@synthesize defaults;

- (void)viewDidLoad {
    [super viewDidLoad];
    
     NSString *str_UserNameDep = [defaults objectForKey:@"userName"];
     decryptedUserName = [str_UserNameDep AES128DecryptWithKey:@""];
 
     [approvalsTableView registerNib:[UINib nibWithNibName:@"IsolationListTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"Cell"];
    
     [self loadPermitsList];

 
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(IBAction)backButtonClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)loadPermitsList{
    
    if (self.issueApprovalDetailsArray ==nil) {
          self.issueApprovalDetailsArray=[NSMutableArray new];
     }
    else{
         [self.issueApprovalDetailsArray removeAllObjects];
    }
    
    [self.issueApprovalDetailsArray addObjectsFromArray:[[DataBase sharedInstance] fetchIsolationPermitDetails:self.isIsolation]];
 
    [approvalsTableView reloadData];
    
}

#pragma mark
#pragma mark - TableView Delegate Methods
//table view methods strats here

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;              // Default is 1 if not implemented
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
      if (tableView==approvalsTableView){
        
        return [self.issueApprovalDetailsArray count];
    }
    
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
 
      if (tableView==approvalsTableView){
        
        if (approvalsTableView.contentSize.height < approvalsTableView.frame.size.height) {
            approvalsTableView.scrollEnabled = NO;
        }
        else
            approvalsTableView.scrollEnabled = YES;
        
        static NSString *CellIdentifier = @"Cell";
        
        IsolationListTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
 
        if (cell==nil) {
            cell=[[IsolationListTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        if (indexPath.row % 2 == 0){
            cell.backgroundColor =UIColorFromRGB(249, 249, 249);
        }
        else {
            cell.backgroundColor =[UIColor whiteColor];
        }
        
        static NSInteger checkboxTag = 123;
        NSInteger x,y;x = 129.0; y = 91.0;
        
        UIButton *permitIssuedButton = (UIButton *) [cell.contentView viewWithTag:checkboxTag];
        
        if (!permitIssuedButton)
        {
            permitIssuedButton = [[UIButton alloc] initWithFrame:(CGRectMake(x,y,233,28))];
            permitIssuedButton.tag = checkboxTag;
            [cell.contentView addSubview:permitIssuedButton];
        }
        
        permitIssuedButton.adjustsImageWhenHighlighted = YES;
        cell.accessoryType = UITableViewCellAccessoryNone;
        
        [permitIssuedButton addTarget:self action:@selector(revokeButtonClicked:) forControlEvents:UIControlEventTouchDown];
        
         [cell.approvedByTextField setTag:500];
        cell.approvedByTextField.delegate=self;
        
        cell.permitLabel.text=[[self.issueApprovalDetailsArray objectAtIndex:indexPath.row] objectAtIndex:7];
        cell.permittextLabel.text=[[self.issueApprovalDetailsArray objectAtIndex:indexPath.row] objectAtIndex:8];
        
        if ([[[self.issueApprovalDetailsArray objectAtIndex:indexPath.row] objectAtIndex:9] isEqualToString:@"X"]) {//if Geniakt == X(show Revoke)
            
            [permitIssuedButton setImage:[UIImage imageNamed:@"no_icon.png"] forState:UIControlStateNormal];
        }
        else{
            
            [permitIssuedButton setImage:[UIImage imageNamed:@"yes_icon.png"] forState:UIControlStateNormal];
        }
        
        cell.approvedByTextField.text=[[self.issueApprovalDetailsArray objectAtIndex:indexPath.row] objectAtIndex:10];
          
        [cell.ordernoBtn setTitle:[[self.issueApprovalDetailsArray objectAtIndex:indexPath.row] objectAtIndex:24] forState:UIControlStateNormal];
          
        
        return cell;
    }
    
    return nil;
}


-(NSIndexPath *) GetCellFromTableView: (UITableView *)tableView Sender:(id)sender
{
    CGPoint position = [sender convertPoint:CGPointZero toView:tableView];
    NSIndexPath *indexPath = [tableView indexPathForRowAtPoint:position];
    return indexPath;//[tableView cellForRowAtIndexPath:indexPath];
}



- (void)revokeButtonClicked:(id)sender {
    
    NSIndexPath *ip = [self GetCellFromTableView:approvalsTableView Sender:sender];
    NSInteger i = ip.row;
    
    //    if ([[[[self.issueApprovalDetailsArray objectAtIndex:i] objectAtIndex:4] uppercaseString] isEqual:[decryptedUserName uppercaseString]]) {
    //
    //        UIAlertView *alertMessage = [[UIAlertView alloc] initWithTitle:@"Info!!" message:@"Permit issuer & receiver cannot be same" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
    //
    //        [alertMessage show];
    //    }
    //    else{
    //
    //        if ([[[self.issueApprovalDetailsArray objectAtIndex:i] objectAtIndex:9] isEqualToString:@"X"]){
    //
    //            [[self.issueApprovalDetailsArray objectAtIndex:i] replaceObjectAtIndex:9 withObject:@""];
    //        }
    //        else{
    //            [[self.issueApprovalDetailsArray objectAtIndex:i] replaceObjectAtIndex:9 withObject:@"X"];
    //        }
    //
    //        [approvalsTableView reloadData];
    //    }
    
    if ([[[self.issueApprovalDetailsArray objectAtIndex:i] objectAtIndex:9] isEqualToString:@"X"]){
        
        [[self.issueApprovalDetailsArray objectAtIndex:i] replaceObjectAtIndex:9 withObject:@""];
        
        [[self.issueApprovalDetailsArray objectAtIndex:i] replaceObjectAtIndex:10 withObject:decryptedUserName];
        
     }
    else{
        
        [[self.issueApprovalDetailsArray objectAtIndex:i] replaceObjectAtIndex:9 withObject:@"X"];
        
        [[self.issueApprovalDetailsArray objectAtIndex:i] replaceObjectAtIndex:10 withObject:@""];
        
    }
    
    [approvalsTableView reloadData];
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
