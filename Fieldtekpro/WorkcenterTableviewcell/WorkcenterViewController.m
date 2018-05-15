//
//  WorkcenterViewController.m
//  Fieldtekpro
//
//  Created by Sathya Rakesh Kumar on 12/05/18.
//  Copyright © 2018 Enstrapp Bangalore. All rights reserved.
//

#import "WorkcenterViewController.h"
#import "DataBase.h"

@interface WorkcenterViewController ()

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@end

@implementation WorkcenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
     workcenterArray=[NSMutableArray new];
    
     checkBoxSelectedArray=[NSMutableArray new];
    
      res_obj=[Response sharedInstance];
 
     [workcenterArray addObjectsFromArray:[[DataBase sharedInstance] getListOfWorkCenterwithKeys]];
    
     headerTitleLabel.text = [NSString stringWithFormat:@"Work Center (%i)",(int)workcenterArray.count];

      wrkCenterTableview.tag=0;
 
     [wrkCenterTableview registerNib:[UINib nibWithNibName:@"FilterWorkcenterTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"WorkcenterCell"];
    
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
 
    if ([res_obj.selectedindexesArray count]) {
        
        [checkBoxSelectedArray addObjectsFromArray:[res_obj.selectedindexesArray copy]];
      }
    
 }

#pragma mark-
#pragma mark- Search Predicate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
 
    if (searchText.length) {
        
        wrkCenterTableview.tag = 1;
        
       NSPredicate *bPredicate = [NSPredicate predicateWithFormat:@" workcenter_text  contains[c] %@ or workcenter_id  contains[c] %@ ",searchText,searchText];

        self.filteredArray = [workcenterArray filteredArrayUsingPredicate:bPredicate];
        
        [checkBoxSelectedArray removeAllObjects];

        headerTitleLabel.text = [NSString stringWithFormat:@"Workcenter (%i)",(int)self.filteredArray.count];
    }
    else{
        
        wrkCenterTableview.tag = 0;
        
        headerTitleLabel.text = [NSString stringWithFormat:@"Workcenter (%i)",(int)workcenterArray.count];
    }

    
    
    [wrkCenterTableview reloadData];
 }

-(IBAction)backButton:(id)sender{
    
    NSMutableArray *selectedIdsArray=[NSMutableArray new];

     if ([checkBoxSelectedArray count]) {
         
         for (id obj in checkBoxSelectedArray) {
             //do stuff with obj
              if (obj) {
                  [selectedIdsArray  addObject:[[workcenterArray objectAtIndex:[obj intValue]] objectForKey:@"workcenter_id"]];
               }
           }
         }
    
    if ([selectedIdsArray count]) {
        
        res_obj.workcenterArray=[selectedIdsArray copy];
        
        res_obj.selectedindexesArray=[checkBoxSelectedArray copy];
    }
 
    if ([self.selectedClass isEqualToString:@"Orders"]) {
        
        if ([(MyOrdersViewController *)self.delegate respondsToSelector:@selector(dismissWorkcenterView)]) {
            
            [(MyOrdersViewController *)self.delegate dismissWorkcenterView];
            
        }
    }
    else{
        
        if ([(MyNotifcationsViewController *)self.delegate respondsToSelector:@selector(dismissWorkcenterView)]) {
            
            [(MyNotifcationsViewController *)self.delegate dismissWorkcenterView];
        }
    }
 
 }


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;              // Default is 1 if not implemented
{
    
    return 1;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (tableView == wrkCenterTableview)
    {
        if (wrkCenterTableview.tag==0) {
             return  [workcenterArray count];
         }
        
        else if (wrkCenterTableview.tag==1){
            
            return  [self.filteredArray count];

        }
    }
    
    return 1;;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == wrkCenterTableview)
    {
        return 64;
    }
    
    return 40;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == wrkCenterTableview)
    {
        
        static NSString *CellIdentifier = @"WorkcenterCell";
        
        FilterWorkcenterTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell==nil) {
            cell=[[FilterWorkcenterTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        cell.accessoryType = UITableViewCellAccessoryNone;
        
        cell.wrkCenterView.layer.cornerRadius = 2.0f;
        cell.wrkCenterView.layer.masksToBounds = YES;
        cell.wrkCenterView.layer.borderColor = [[UIColor darkGrayColor] CGColor];
        cell.wrkCenterView.layer.borderWidth = 1.0f;
        
        if (wrkCenterTableview.tag==0) {
            
             cell.titleLabel.text=[[workcenterArray objectAtIndex:indexPath.row] objectForKey:@"workcenter_id"];
            cell.textValue.text=[[workcenterArray objectAtIndex:indexPath.row] objectForKey:@"workcenter_text"];
        }
        
        else if (wrkCenterTableview.tag==1){
            
             cell.titleLabel.text=[[self.filteredArray objectAtIndex:indexPath.row] objectForKey:@"workcenter_id"];
            cell.textValue.text=[[self.filteredArray objectAtIndex:indexPath.row] objectForKey:@"workcenter_text"];
        }
        
        
         [cell.checkBoxBtn addTarget:self action:@selector(wrkCenterCheckboxClicked:) forControlEvents:UIControlEventTouchDown];
        
 
             if ([checkBoxSelectedArray containsObject:[NSNumber numberWithInteger:indexPath.row]])
            {
                [cell.checkBoxBtn setImage:[UIImage imageNamed:@"CheckBoxSelection"]   forState:UIControlStateNormal];
                
            }
            else
            {
                [cell.checkBoxBtn setImage:[UIImage imageNamed:@"checkBoxUnSelection"]   forState:UIControlStateNormal];
            }
 
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


-(void)wrkCenterCheckboxClicked:(id)sender
{
    NSIndexPath *ip = [self GetCellFromTableView:wrkCenterTableview Sender:sender];
    NSInteger i = ip.row;
    
    UIButton *tappedButton = (UIButton*)sender;
    
    if([tappedButton.currentImage isEqual:[UIImage imageNamed:@"CheckBoxSelection"]])
    {
        [checkBoxSelectedArray removeObject:[NSNumber numberWithInteger:i]];

    }
    else{
        
        [checkBoxSelectedArray addObject:[NSNumber numberWithInteger:i]];
     }
 
    [wrkCenterTableview reloadData];
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
