//
//  DetailOrderConfirmationViewController.m
//  Fieldtekpro
//
//  Created by Sathya Rakesh Kumar on 10/05/18.
//  Copyright © 2018 Enstrapp Bangalore. All rights reserved.
//

#import "DetailOrderConfirmationViewController.h"
#import "CreateOrderViewController.h"

@interface DetailOrderConfirmationViewController ()

@end

@implementation DetailOrderConfirmationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    headerDataArray=[NSMutableArray new];
    
 //   NSLog(@"poertaion details are %@",self.detailOperationsArray);
    
    [commonListTableview registerNib:[UINib nibWithNibName:@"InputDropDownTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"InputDropDownCell"];
    
    [self loadTechnicalConfirmationdata];

 
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


-(void)loadTechnicalConfirmationdata
{
    
    [headerDataArray addObject:[NSMutableArray arrayWithObjects:@"Order # :",@"",[[[self.detailOperationsArray objectAtIndex:0] firstObject] objectAtIndex:1],@"", nil]];
    
    [headerDataArray addObject:[NSMutableArray arrayWithObjects:@"Operation# :",@"",[[[self.detailOperationsArray objectAtIndex:0] firstObject] objectAtIndex:1],@"", nil]];
    
    [headerDataArray addObject:[NSMutableArray arrayWithObjects:@"Operation text :",@"",[[[self.detailOperationsArray objectAtIndex:0] firstObject] objectAtIndex:2],@"", nil]];
    
    [headerDataArray addObject:[NSMutableArray arrayWithObjects:@"Operation LongText :",@"",[[[self.detailOperationsArray objectAtIndex:0] firstObject] objectAtIndex:20],@"", nil]];
 
    [headerDataArray addObject:[NSMutableArray arrayWithObjects:@"Control Key :",@"",[[[self.detailOperationsArray objectAtIndex:0] firstObject] objectAtIndex:30],@"", nil]];
 
    [headerDataArray addObject:[NSMutableArray arrayWithObjects:@"Plant/WorkCenter :",@"",[NSString stringWithFormat:@"%@/%@",[[[self.detailOperationsArray objectAtIndex:0] firstObject] objectAtIndex:27],[[[self.detailOperationsArray objectAtIndex:0] firstObject] objectAtIndex:29]],@"", nil]];
    
    [headerDataArray addObject:[NSMutableArray arrayWithObjects:@"Activity Type :",@"",[[[self.detailOperationsArray objectAtIndex:0] firstObject] objectAtIndex:14],@"", nil]];
    
    [headerDataArray addObject:[NSMutableArray arrayWithObjects:@"Planned Work/Unit :",@"",[[[self.detailOperationsArray objectAtIndex:0] firstObject] objectAtIndex:21],@"", nil]];
    
    [headerDataArray addObject:[NSMutableArray arrayWithObjects:@"Confirmed Work/Unit :",@"",[[[self.detailOperationsArray objectAtIndex:0] firstObject] objectAtIndex:3],@"", nil]];
 
}




#pragma mark
#pragma mark - TableView Delegate Methods
//table view methods strats here

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;              // Default is 1 if not implemented
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [headerDataArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"InputDropDownCell";
    
    InputDropDownTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell==nil) {
        cell=[[InputDropDownTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UIImageView *statusImageView=[[UIImageView alloc] init];

    CALayer *orderStatusLayerinFinish = [statusImageView layer];
    [orderStatusLayerinFinish setMasksToBounds:YES];
    [orderStatusLayerinFinish setCornerRadius:8.0];
    
      NSString  *aueruid=[[[self.detailOperationsArray objectAtIndex:0] firstObject] objectAtIndex:8];

      if (indexPath.row==0) {
 
          if ([aueruid isEqualToString:@"X"])
          {
              statusImageView.backgroundColor=[UIColor greenColor];
              
               startBtn.hidden=YES;
               finishBtn.hidden=YES;
              
          }
          else if ([aueruid isEqualToString:@"Y"])
          {
              statusImageView.backgroundColor=[UIColor orangeColor];
              
                startBtn.hidden=NO;
               finishBtn.hidden=NO;
//              [[DataBase sharedInstance] deleteConfirmWorkOrderTimerForPCNF:orderObject.orderUUID];
              
          }
          else if ([aueruid isEqualToString:@"Z"])
          {
              statusImageView.backgroundColor=UIColorFromRGB(0, 100, 0);
 
              startBtn.hidden=YES;
              finishBtn.hidden=YES;
              
          }
          else if ([aueruid isEqualToString:@"S"])
          {
              statusImageView.backgroundColor=[UIColor yellowColor];
              startBtn.hidden=NO;
              finishBtn.hidden=NO;
              self.activityIndicatorView.hidden=NO;
              [self.activityIndicatorView startAnimating];
              [startBtn setImage:[UIImage imageNamed:@"Pause-icon"] forState:UIControlStateNormal];
              startFlag = YES;
              
          }
          else if ([aueruid isEqualToString:@"P"])
          {
              statusImageView.backgroundColor=[UIColor purpleColor];

              [startBtn setImage:[UIImage imageNamed:@"Start-icon"] forState:UIControlStateNormal];
              startBtn.hidden=NO;
              finishBtn.hidden=YES;
              
              self.activityIndicatorView.hidden=NO;
              [self.activityIndicatorView stopAnimating];
             
              startFlag = NO;
              
          }
          else
          {
               statusImageView.backgroundColor=UIColorFromRGB(39, 171, 226);
               startBtn.hidden=NO;
          }
      
      }
    
    cell.longTextBtn.hidden=YES;
    cell.dropDownImageView.hidden=YES;
    cell.madatoryLabel.hidden=YES;
    
    cell.notifView.layer.cornerRadius = 2.0f;
    cell.notifView.layer.masksToBounds = YES;
    cell.notifView.layer.borderColor = [[UIColor darkGrayColor] CGColor];
    cell.notifView.layer.borderWidth = 1.0f;
    
    cell.titleLabel.text=[[headerDataArray objectAtIndex:indexPath.row] objectAtIndex:0];
    cell.InputTextField.placeholder=[[headerDataArray objectAtIndex:indexPath.row] objectAtIndex:1];
    cell.InputTextField.text=[[headerDataArray objectAtIndex:indexPath.row] objectAtIndex:2];
    
    
    return cell;
    
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
