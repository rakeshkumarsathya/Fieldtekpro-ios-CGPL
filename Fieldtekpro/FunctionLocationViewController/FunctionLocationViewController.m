//
//  FunctionLocationViewController.m
//  Fieldtekpro
//
//  Created by Enstrapp Bangalore on 12/12/17.
//  Copyright © 2017 Enstrapp Bangalore. All rights reserved.
//

#import "FunctionLocationViewController.h"

@interface FunctionLocationViewController ()

{
    Response *res_obj;
    
}
@end

@implementation FunctionLocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    count=0;
 
     res_obj=[Response sharedInstance];
    
     locationIdArray=[NSMutableArray new];
    
    // Get the instance of the UITextField of the search bar
    UITextField *searchField = [functionalLocationsearch valueForKey:@"_searchField"];
    // Change search bar text color
    searchField.textColor = [UIColor blueColor];
    
    // Change the search bar placeholder text color
    [searchField setValue:[UIColor blueColor] forKeyPath:@"_placeholderLabel.textColor"];
    
     [functionalLocationTableView registerNib:[UINib nibWithNibName:@"FunctionalLocationTableViewCell_iPhone" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"Cell"];
    
    [functionalLocationTableView setTableHeaderView:searchView];
    
    [self fetchFunctionLocations];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

 

#pragma mark-
#pragma mark- Search Predicate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (searchBar==functionalLocationsearch) {
        
        if ([searchText isEqualToString:@""]) {
            
            islevelEnabled=NO;
            
            if (functionalLocationTableView.tag==1) {
                
                  funcLocnHeaderLabel.text = [NSString stringWithFormat:@"Function Location (%lu)",(unsigned long)[self.functionLocationHierarchyArray count]];
            }
            else{
                
                  funcLocnHeaderLabel.text = [NSString stringWithFormat:@"Function Location (%lu)",(unsigned long)[self.functionLocationArray count]];
            }
            
        }
        else{
            
            NSPredicate *bPredicate = [NSPredicate predicateWithFormat:@"locationid contains[c] %@ OR locationName contains[c] %@ OR plantName contains[c] %@ OR workStation contains[c] %@ OR costCenter contains[c] %@ OR plannerGroup contains[c] %@",searchText,searchText,searchText,searchText,searchText,searchText];
            
            if (self.filteredArray == nil) {
                self.filteredArray = [[NSArray alloc]init];
            }
            
            if (functionalLocationTableView.tag==1) {
                
                self.filteredArray = [self.functionLocationHierarchyArray filteredArrayUsingPredicate:bPredicate];
                
            }
            else{
                
                self.filteredArray = [self.functionLocationArray filteredArrayUsingPredicate:bPredicate];

            }
            
            funcLocnHeaderLabel.text = [NSString stringWithFormat:@"Function Location (%lu)",(unsigned long)[self.filteredArray count]];
 
            islevelEnabled=YES;
        }
        
        [functionalLocationTableView reloadData];
        
    }
    
    
    //[self.dropDownArray addObjectsFromArray:[[DataBase sharedInstance] getEquipments:searchText]];
}


-(IBAction)backButtonClicked:(id)sender
{
    if (count==0)
    {
         [self.navigationController popViewControllerAnimated:YES];

    }
    else
    {
         if (functionalLocationTableView.tag==1)
        {
            if (!islevelEnabled) {
                
                NSMutableDictionary *inputParameters = [NSMutableDictionary new];
                
                 if (count==1)
                 {
                     [locationIdArray removeAllObjects];
                  
                     [inputParameters setObject:@"" forKey:@"functionLocationHID"];

                 }
                
                else
                {
                     [locationIdArray removeObjectAtIndex:[locationIdArray count]-1];
                     [inputParameters setObject:[locationIdArray objectAtIndex:count-2] forKey:@"functionLocationHID"];
                 }
 
                 if (self.functionLocationHierarchyArray == nil) {
                    self.functionLocationHierarchyArray = [NSMutableArray new];
                }
                 else{
                    
                    [self.functionLocationHierarchyArray removeAllObjects];
                 }
 
                [self.functionLocationHierarchyArray addObjectsFromArray:[[DataBase sharedInstance] getFunctionLocations:inputParameters]];
                
                funcLocnHeaderLabel.text = [NSString stringWithFormat:@"Function Location (%lu)",(unsigned long)[self.functionLocationHierarchyArray count]];

            }
            else
            {
                
                NSMutableDictionary *inputParameters = [NSMutableDictionary new];
                
                [inputParameters setObject:[locationIdArray objectAtIndex:count-1] forKey:@"functionLocationHID"];
                
                [locationIdArray removeObjectAtIndex:[locationIdArray count]-1];
 
                [self.functionLocationHierarchyArray addObjectsFromArray:[[DataBase sharedInstance] getFunctionLocations:inputParameters]];
                
                funcLocnHeaderLabel.text = [NSString stringWithFormat:@"Function Location (%lu)",(unsigned long)[self.functionLocationHierarchyArray count]];
 
              }
           }
        
        count=count-1;
        
        if (count==0)
        {
             functionalLocationTableView.tag=0;
 
            NSMutableDictionary *inputParameters = [NSMutableDictionary new];
            
            [inputParameters setObject:@"" forKey:@"functionLocationHID"];
            
            [self.functionLocationHierarchyArray addObjectsFromArray:[[DataBase sharedInstance] getFunctionLocations:inputParameters]];
            
            funcLocnHeaderLabel.text = [NSString stringWithFormat:@"Function Location (%lu)",(unsigned long)[self.functionLocationArray count]];
         }
        
          [functionalLocationTableView reloadData];
    }
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


-(void)fetchFunctionLocations{
    
    if (self.functionLocationArray == nil) {
        self.functionLocationArray = [NSMutableArray new];
        
    }
    else{
        [self.functionLocationArray removeAllObjects];
    }
 
        [self.functionLocationArray addObjectsFromArray:[[DataBase sharedInstance] getFuncLoc:@"*"]];

        funcLocnHeaderLabel.text = [NSString stringWithFormat:@"Function Location (%lu)",(unsigned long)[self.functionLocationArray count]];
        
        if (![self.functionLocationArray count])
        {
            
            [self showAlertMessageWithTitle:@"Inforamtion" message:@"No Functional Location Available" cancelButtonTitle:@"Ok"];
            
        }
        else{
            
            functionalLocationsearch.tag = 1;
            [functionalLocationTableView reloadData];
            islevelEnabled=NO;
        }
 
 }

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;              // Default is 1 if not implemented
{
    
    return 1;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (tableView == functionalLocationTableView)
    {
        if (functionalLocationTableView.tag==1)
        {
            if (!islevelEnabled) {
                return [self.functionLocationHierarchyArray count];
             }
            
            else{
                
                return [self.filteredArray count];
            }
        }
        else
        {
            if (!islevelEnabled)
            {
                return [self.functionLocationArray count];
            }
             else{
                
                return [self.filteredArray count];
            }
        }
    }
    
    return 1;;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == functionalLocationTableView)
    {
        return 70;
    }
    
    return 40;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == functionalLocationTableView)
    {
 
        static NSString *CellIdentifier = @"Cell";
        
        FunctionalLocationTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell==nil) {
            cell=[[FunctionalLocationTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        cell.accessoryType = UITableViewCellAccessoryNone;
        
        [cell.detailButton addTarget:self action:@selector(detailButtonClicked:) forControlEvents:UIControlEventTouchDown];
 
        if (functionalLocationTableView.tag==1) {
            
             if ([[[self.functionLocationHierarchyArray objectAtIndex:indexPath.row] objectForKey:@"stplnr"] isEqualToString:@"X"]) {
                
                [cell.funcLocBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
               
                 cell.funcLocContentView.layer.cornerRadius = 2.0f;
                 cell.funcLocContentView.layer.masksToBounds = YES;
                 cell.funcLocContentView.layer.borderColor = [[UIColor redColor] CGColor];
                 cell.funcLocContentView.layer.borderWidth = 1.0f;
                
                [cell.funcLocBtn setUserInteractionEnabled:YES];
 
                 [cell.funcLocBtn addTarget:self action:@selector(fLocationHDetailButtonClicked:) forControlEvents:UIControlEventTouchDown];
 
             }
            
            else
            {
                 [cell.funcLocBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                
                cell.funcLocContentView.layer.cornerRadius =0.0f;
                cell.funcLocContentView.layer.masksToBounds = YES;
                cell.funcLocContentView.layer.borderColor = nil;
                cell.funcLocContentView.layer.borderWidth = 0.0f;
                [cell.funcLocBtn setUserInteractionEnabled:NO];
            }
 
 
            if (!islevelEnabled)
            {
                
                [cell.funcLocBtn setTitle:[[self.functionLocationHierarchyArray objectAtIndex:indexPath.row] objectForKey:@"locationid"] forState:UIControlStateNormal];
                cell.funcLocationDescriptionLabel.text =[[self.functionLocationHierarchyArray objectAtIndex:indexPath.row] objectForKey:@"locationName"];
            }
            else{
                
                [cell.funcLocBtn setTitle:[[self.filteredArray objectAtIndex:indexPath.row] objectForKey:@"locationid"] forState:UIControlStateNormal];
                
                cell.funcLocationDescriptionLabel.text =[[self.filteredArray objectAtIndex:indexPath.row] objectForKey:@"locationName"];
            }
            
            return cell;
        }
        else{
            
 
            [cell.funcLocBtn addTarget:self action:@selector(fLocationHDetailButtonClicked:) forControlEvents:UIControlEventTouchDown];
            
            cell.funcLocationIdLabel.textColor = [UIColor redColor];
            
            cell.funcLocContentView.layer.cornerRadius = 2.0f;
            cell.funcLocContentView.layer.masksToBounds = YES;
            cell.funcLocContentView.layer.borderColor = [[UIColor redColor] CGColor];
            cell.funcLocContentView.layer.borderWidth = 1.0f;
            
            
            [cell.funcLocBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            
            if (!islevelEnabled)
            {
                
                [cell.funcLocBtn setTitle:[[self.functionLocationArray objectAtIndex:indexPath.row] objectForKey:@"locationid"] forState:UIControlStateNormal];
                
                cell.funcLocationDescriptionLabel.text =[[self.functionLocationArray objectAtIndex:indexPath.row] objectForKey:@"locationName"];
            }
            else{
                
                [cell.funcLocBtn setTitle:[[self.filteredArray objectAtIndex:indexPath.row] objectForKey:@"locationid"] forState:UIControlStateNormal];
                
                cell.funcLocationDescriptionLabel.text =[[self.filteredArray objectAtIndex:indexPath.row] objectForKey:@"locationName"];
            }
 
            return cell;
        }
     }
    
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == functionalLocationTableView) {
        
        if (functionalLocationTableView.tag==1) {
            
            NSMutableArray *tempArray=[NSMutableArray new];
            
            if (islevelEnabled) {
                
                [tempArray addObject:[self.filteredArray objectAtIndex:indexPath.row]];
                res_obj.functionLocationArray=[tempArray copy];
            }
            
            else{
                
                [tempArray addObject:[self.functionLocationHierarchyArray objectAtIndex:indexPath.row]];
                
                res_obj.functionLocationArray=[tempArray copy];
            }
            
            
            if ([self.searchString isEqualToString:@"X"]) {
                
                if ([(CreateOrderViewController *)self.delegate respondsToSelector:@selector(dismissfunctionLocationView)]) {
                    
                    [(CreateOrderViewController *)self.delegate dismissfunctionLocationView];
                }
             }
            
            else{
                
                if ([(InspectionChecklistViewController *)self.delegate respondsToSelector:@selector(dismissToCheckListView)]) {
                    
                    [(InspectionChecklistViewController *)self.delegate dismissToCheckListView];
                    
                }
            }
         }
        else{
            
                 NSMutableArray *tempArray=[NSMutableArray new];
                
                if (islevelEnabled) {
                    
                    [tempArray addObject:[self.filteredArray objectAtIndex:indexPath.row]];
                    res_obj.functionLocationArray=[tempArray copy];
                }
                
                else{
                    
                    [tempArray addObject:[self.functionLocationArray objectAtIndex:indexPath.row]];
                    
                    res_obj.functionLocationArray=[tempArray copy];
                    
                }
            
            if ([self.searchString isEqualToString:@"X"]) {

                if ([(CreateOrderViewController *)self.delegate respondsToSelector:@selector(dismissfunctionLocationView)]) {
                    
                    [(CreateOrderViewController *)self.delegate dismissfunctionLocationView];
                }
             }
            
            else{
                
                if ([(InspectionChecklistViewController *)self.delegate respondsToSelector:@selector(dismissToCheckListView)]) {
                    
                    [(InspectionChecklistViewController *)self.delegate dismissToCheckListView];
                    
                }
            }
           }
         }
    }

-(NSIndexPath *) GetCellFromTableView: (UITableView *)tableView Sender:(id)sender
{
    CGPoint position = [sender convertPoint:CGPointZero toView:tableView];
    NSIndexPath *indexPath = [tableView indexPathForRowAtPoint:position];
    return indexPath;//[tableView cellForRowAtIndexPath:indexPath];
}

-(void)fLocationHDetailButtonClicked:(id)sender
{
     NSIndexPath *ip = [self GetCellFromTableView:functionalLocationTableView Sender:sender];
     NSMutableDictionary *inputParameters = [NSMutableDictionary new];
     selectedDismissFlocIndex=(int)ip.row;
    
     count=count+1;
 
    if (functionalLocationTableView.tag == 1)
     {
         if (!islevelEnabled)
         {
             [inputParameters setObject:[[self.functionLocationHierarchyArray objectAtIndex:ip.row] objectForKey:@"locationid"] forKey:@"functionLocationHID"];
 
             [locationIdArray addObject:[[self.functionLocationHierarchyArray objectAtIndex:ip.row] objectForKey:@"locationid"]];
             
            if (self.functionLocationHierarchyArray == nil) {
                self.functionLocationHierarchyArray = [NSMutableArray new];
            }
            else{
                
                [self.functionLocationHierarchyArray removeAllObjects];
            }
            
             [self.functionLocationHierarchyArray addObjectsFromArray:[[DataBase sharedInstance] getFunctionLocations:inputParameters]];
 
            funcLocnHeaderLabel.text = [NSString stringWithFormat:@"Function Location (%lu)",(unsigned long)[self.functionLocationHierarchyArray count]];
            
        }
        else{
            
            functionalLocationsearch.text=@"";
            
            [inputParameters setObject:[[self.filteredArray objectAtIndex:ip.row] objectForKey:@"locationid"] forKey:@"functionLocationHID"];
 
            [locationIdArray addObject:[[self.filteredArray objectAtIndex:ip.row] objectForKey:@"locationid"]];
            
            if (self.functionLocationHierarchyArray == nil) {
                self.functionLocationHierarchyArray = [NSMutableArray new];
            }
            else{
                
                [self.functionLocationHierarchyArray removeAllObjects];
            }
            
            islevelEnabled=NO;
 
              [self.functionLocationHierarchyArray addObjectsFromArray:[[DataBase sharedInstance] getFunctionLocations:inputParameters]];
            
            funcLocnHeaderLabel.text = [NSString stringWithFormat:@"Function Location (%lu)",(unsigned long)[self.functionLocationHierarchyArray count]];
        }
 
        [functionalLocationTableView reloadData];
    }
    
    else{
        
        if (!islevelEnabled) {
            
            if (self.functionLocationHierarchyArray == nil) {
                self.functionLocationHierarchyArray = [NSMutableArray new];
            }
            else{
                
                [self.functionLocationHierarchyArray removeAllObjects];
            }
            
            [inputParameters setObject:[[self.functionLocationArray objectAtIndex:ip.row] objectForKey:@"locationid"] forKey:@"functionLocationHID"];
            
            [locationIdArray addObject:[[self.functionLocationArray objectAtIndex:ip.row] objectForKey:@"locationid"]];
            
            [self.functionLocationHierarchyArray addObjectsFromArray:[[DataBase sharedInstance] getFunctionLocations:inputParameters]];
            
 
            funcLocnHeaderLabel.text = [NSString stringWithFormat:@"Function Location (%lu)",(unsigned long)[self.functionLocationHierarchyArray count]];
 
        }
        
        else{
            
            functionalLocationsearch.text=@"";

             [inputParameters setObject:[[self.filteredArray objectAtIndex:ip.row] objectForKey:@"locationid"] forKey:@"functionLocationHID"];
            
            [locationIdArray addObject:[[self.filteredArray objectAtIndex:ip.row] objectForKey:@"locationid"]];
            
            if (self.functionLocationHierarchyArray == nil) {
                self.functionLocationHierarchyArray = [NSMutableArray new];
            }
            else{
                
                [self.functionLocationHierarchyArray removeAllObjects];
            }
            
              [self.functionLocationHierarchyArray addObjectsFromArray:[[DataBase sharedInstance] getFunctionLocations:inputParameters]];
            
            islevelEnabled=NO;
            
            funcLocnHeaderLabel.text = [NSString stringWithFormat:@"Function Location (%lu)",(unsigned long)[self.functionLocationHierarchyArray count]];
            
        }
        
        functionalLocationTableView.tag=1;
        [functionalLocationTableView reloadData];
 
    }
    
}


-(void)detailButtonClicked:(id)sender
{
    NSIndexPath *ip = [self GetCellFromTableView:functionalLocationTableView Sender:sender];

      EquipmentFncLocDetailsViewController *equipVC = [self.storyboard instantiateViewControllerWithIdentifier:@"detailVC"];
 
    if (functionalLocationTableView.tag==1) {
        
        if (!islevelEnabled) {
            
            NSMutableArray *tempArray=[NSMutableArray new];
            
            [tempArray addObject:[self.functionLocationHierarchyArray objectAtIndex:ip.row]];
            
            if ([tempArray count]) {
                equipVC.selectedDetailsArray=[tempArray copy];
            }
        }
        else{
            
            NSMutableArray *tempArray=[NSMutableArray new];
            
            [tempArray addObject:[self.filteredArray objectAtIndex:ip.row]];
            
            if ([tempArray count]) {
                equipVC.selectedDetailsArray=[tempArray copy];
            }
        }
     }
    else{
 
        if (!islevelEnabled) {
            
            NSMutableArray *tempArray=[NSMutableArray new];
            
            [tempArray addObject:[self.functionLocationArray objectAtIndex:ip.row]];
            
            if ([tempArray count]) {
                equipVC.selectedDetailsArray=[tempArray copy];
            }
            
        }
        else{
            
            NSMutableArray *tempArray=[NSMutableArray new];
            
            [tempArray addObject:[self.filteredArray objectAtIndex:ip.row]];
            
            if ([tempArray count]) {
                equipVC.selectedDetailsArray=[tempArray copy];
            }
         }
     }
 
     [self showViewController:equipVC sender:self];
 
 }
   



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
   
    
}


@end
