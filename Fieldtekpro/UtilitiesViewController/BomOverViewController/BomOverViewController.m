//
//  BomOverViewController.m
//  Fieldtekpro
//
//  Created by Sathya Rakesh Kumar on 06/12/17.
//  Copyright © 2017 Enstrapp Bangalore. All rights reserved.
//

#import "BomOverViewController.h"
#import "ReservationViewController.h"

#define UIColorFromRGB(r, g, b)  [UIColor colorWithRed:((r) / 255.0) green:((g) / 255.0) blue:((b) / 255.0) alpha:1.0]


@interface BomOverViewController ()

@end

@implementation BomOverViewController
@synthesize defaults;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    bomTableview.tag=0;
    
    self.bomHeaderArray = [NSMutableArray new];
    
    defaults=[NSUserDefaults standardUserDefaults];

    inputsDictionary = [NSMutableDictionary new];
 
    NSString *key = @"";
    NSString *str_UserNameDep = [defaults objectForKey:@"userName"];
    decryptedUserName = [str_UserNameDep AES128DecryptWithKey:key];
    
    isRefresh=NO;
    
    [detailBomtableview registerNib:[UINib nibWithNibName:@"DetailBomTableviewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"detailBomCell"];
    
    searchBtn.imageEdgeInsets = UIEdgeInsetsMake(-0,10, 10, 0);
    searchBtn.titleEdgeInsets = UIEdgeInsetsMake(30, -40, 0, 0);
    
    sortBtn.imageEdgeInsets = UIEdgeInsetsMake(-10,10,5, 15);
    sortBtn.titleEdgeInsets = UIEdgeInsetsMake(30,-15, 0, 0);
    
    refreshBtn.imageEdgeInsets = UIEdgeInsetsMake(-10,20, 10, 0);
    refreshBtn.titleEdgeInsets = UIEdgeInsetsMake(30, -20, 0, 0);
    
 
    self.structuredFilterSortedArray = [NSMutableArray new];
 
    NSMutableArray *tempSortDescriptionTexts=[NSMutableArray new];
    [tempSortDescriptionTexts addObject:[NSMutableArray arrayWithObjects:@"SORT A-Z",@"SORT Z-A", nil]];
    [tempSortDescriptionTexts addObject:[NSMutableArray arrayWithObjects:@"",@"", nil]];
    
    NSMutableArray *tempSortStatusTexts=[NSMutableArray new];
    [tempSortStatusTexts addObject:[NSMutableArray arrayWithObjects:@"Ascending 1-9",@"Descending 9-1", nil]];
    [tempSortStatusTexts addObject:[NSMutableArray arrayWithObjects:@"",@"", nil]];
    
    NSMutableArray *tempSortMalFuncStartDate=[NSMutableArray new];
    [tempSortMalFuncStartDate addObject:[NSMutableArray arrayWithObjects:@"Ascending 1-9",@"Descending 9-1", nil]];
    [tempSortMalFuncStartDate addObject:[NSMutableArray arrayWithObjects:@"",@"", nil]];
    
    [self.structuredFilterSortedArray addObject:[NSArray arrayWithObjects:tempSortDescriptionTexts,tempSortStatusTexts,tempSortMalFuncStartDate, nil]];
    
    [self searchForBOMOverviewLook:nil];
    
    selectedBOM = NO;
 
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark-
#pragma mark- Search Predicate

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    
    if (searchBar == _bomListViewSearchBar) {
        
        if (!searchText.length) {
            
            detailBomtableview.tag = 0;
        }
        else{
            
            NSPredicate *bPredicate = [NSPredicate predicateWithFormat:@"bomcomponent contains[c] %@ or comptext contains[c] %@",searchText,searchText];
            
            filterArray = [self.bomDetailListArray filteredArrayUsingPredicate:bPredicate];
 
            detailBomtableview.tag = 1;
        }
        
        [detailBomtableview reloadData];
    }
    else{
        
        if (searchText.length) {
            
            NSPredicate *bPredicate = [NSPredicate predicateWithFormat:@"bomheader contains[c] %@",searchText];
            
            filterArray = [self.bomHeaderArray filteredArrayUsingPredicate:bPredicate];
            
            if ([filterArray count]) {
                
                bomEquipmentOnlineSearchBtn.hidden = YES;
            }
            else{
                
                bomEquipmentOnlineSearchBtn.hidden = NO;
            }
            
            bomLookupCountLabel.text = [NSString stringWithFormat:@"My BOM (%i)",(int)[filterArray count]];
            
            [bomTableview scrollRectToVisible:CGRectMake(0, 0, 0, 0) animated:YES];
            
            [bomTableview setTag:1];
        }
        else{
            
            [bomTableview setTag:0];
            
            bomLookupCountLabel.text = [NSString stringWithFormat:@"My BOM (%i)",(int)[self.bomHeaderArray count]];
        }
        
        [bomTableview reloadData];
        
    }
    //    NSString *filterString = [NSString stringWithFormat:@"Bom LIKE '%@%%' or BomDesc LIKE '%@%%' or Plant LIKE '%@%%' ",searchText,searchText,searchText];
    //
    //    [inputsDictionary removeObjectForKey:@"COLOUMN"];
    //    [inputsDictionary setObject:filterString forKey:@"FILTER"];
    //
    //    [self searchForBOMOverviewLook:inputsDictionary];
}


-(void)searchForBOMOverviewLook :(NSMutableDictionary *)actions{
    
    [self.bomHeaderArray removeAllObjects];
    [self.bomHeaderArray addObjectsFromArray:[[DataBase sharedInstance] getBOMForSearchDescription:actions]];
    
    if ([self.bomHeaderArray count] ==0) {
        
        bomEquipmentOnlineSearchBtn.hidden = NO;
     }
    else{
        
        bomEquipmentOnlineSearchBtn.hidden = YES;
     }
    
    bomLookupCountLabel.text = [NSString stringWithFormat:@"My BOM (%i)",(int)[self.bomHeaderArray count]];
    [bomTableview scrollRectToVisible:CGRectMake(0, 0, 0, 0) animated:YES];
    [bomTableview reloadData];
    
}

-(void)fetchDataFromLDB_BomLookup_EtComponents
{
    if (self.bomDetailListArray == nil) {
        
        self.bomDetailListArray = [NSMutableArray new];
    }
    else{
        
        [self.bomDetailListArray removeAllObjects];
    }
    
    NSMutableDictionary *actions = [NSMutableDictionary new];
    [actions setObject:@"" forKey:@"BOMTransaction"];
    
    if (componentHighlighted)
    {
        [actions setObject:bomValueHighlighted forKey:@"BOM"];
        //        [self.bomDetailListArray addObjectsFromArray:[[DataBase sharedInstance] readSqliteFile_BomLookup_EtComponents:bomValueHighlighted]];
    }
    else{
        
        [actions setObject:bomValueString forKey:@"BOM"];
        
        // [self.bomDetailListArray addObjectsFromArray:[[DataBase sharedInstance] getBOMForSearchDescription:actions]];
        
        // [self.bomDetailListArray addObjectsFromArray:[[DataBase sharedInstance] readSqliteFile_BomLookup_EtComponents:bomValueString]];
    }
    
    [self.bomDetailListArray addObjectsFromArray:[[DataBase sharedInstance] getBOMForSearchDescription:actions]];
    
    reserveBtn.hidden = NO;
    
    if (![self.bomDetailListArray count] && !selectedBOM) {
        
       // [ActivityView show:@"Fetching Bom Items..."];
        
        hud = [MBProgressHUD showHUDAddedTo:bomDetailView animated:YES];
        hud.mode = MBProgressHUDModeIndeterminate;
        hud.label.text = @"Fetching Bom Items...";
        
        reserveBtn.hidden = YES;
        [self performSelectorOnMainThread:@selector(getBOMItemsFromBom) withObject:nil waitUntilDone:YES];
    }
    else{
        // bomValueString
        
        componentsHeaderLabel.text=[NSString stringWithFormat:@"%@(%lu)",bomValueString,(unsigned long)[self.bomDetailListArray count]];
        
        [detailBomtableview scrollRectToVisible:CGRectMake(0, 0, 0, 0) animated:YES];
        
        [detailBomtableview reloadData];
    }
}


-(void)getBOMItemsFromBom{
    
    NSMutableDictionary *dataDictionary = [[NSMutableDictionary alloc]init];
    [dataDictionary setObject:decryptedUserName forKey:@"REPORTEDBY"];
    
    NSMutableDictionary *endPointDictionary = [NSMutableDictionary new];
    [endPointDictionary setObject:@"EQ" forKey:@"ACTIVITY"];
    [endPointDictionary setObject:@"C5" forKey:@"DOCTYPE"];
    [endPointDictionary setObject:[defaults objectForKey:@"ENDPOINT"] forKey:@"ENDPOINT"];
    NSArray *endPointArray = [[DataBase sharedInstance] getEndPointURL:endPointDictionary];
    NSLog(@"endPoint :%@",[[endPointArray objectAtIndex:0] objectAtIndex:0]);
    [dataDictionary setObject:[[endPointArray objectAtIndex:0] objectAtIndex:0] forKey:@"URL_ENDPOINT"];
    
    [dataDictionary setObject:@"" forKey:@"EQUIPDESCRIP"];
    
    [dataDictionary setObject:bomValueString forKey:@"EQUIPNO"];
    [dataDictionary setObject:@"LOAD" forKey:@"TRANSMITTYPE"];
    
    selectedBOM = YES;
    isRefresh = NO;
    
    
    [Request makeWebServiceRequest:GET_LIST_OF_PM_BOMS parameters:dataDictionary delegate:self];
}

-(IBAction)reservationClicked:(id)sender{
    
    ReservationViewController *resVc = [self.storyboard instantiateViewControllerWithIdentifier:@"ReserveView"];
    [self showViewController:resVc sender:self];
    
}

-(IBAction)dismissDetailclicked:(id)sender{
    
    [bomDetailView removeFromSuperview];
    
}

-(IBAction)searchCloseButtonClicked:(id)sender{

    [bomTableview setTableHeaderView:nil];

}

-(IBAction)searchButtonClicked:(id)sender{
 
    [searchView setFrame:CGRectMake(0, 0, bomTableview.frame.size.width, 44)];
    [bomTableview setTableHeaderView:searchView];
 }

-(IBAction)clearAllButtonClicked:(id)sender{

    [blackView removeFromSuperview];
    [sortView removeFromSuperview];
    
}

-(IBAction)sortButtonClicked:(id)sender
{
    self.window = [UIApplication sharedApplication].keyWindow;
     blackView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.window.frame.size.height)];
    [blackView setBackgroundColor:[UIColor blackColor]];
    [blackView setAlpha:0.8];
    [self.window addSubview:blackView];
    [sortView setFrame:CGRectMake(blackView.frame.size.width-260, 57, 260, self.window.frame.size.height-57)];
    [self.window addSubview:sortView];
 }


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;              // Default is 1 if not implemented
{
    if (tableView==sortTableView)
    {
        return 3;
    }
    return 1;
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (tableView==bomTableview) {
        
        if (bomTableview.tag == 1) {
 
            return [filterArray count];
           
        }
        else{
             return  [self.bomHeaderArray count];
         }
    }
    
  else  if (tableView==detailBomtableview) {
        
      if (detailBomtableview.tag == 1) {
 
        return [filterArray count];
          
      }
      else{
            return [self.bomDetailListArray count];
          
      }
    }
    
  else  if (tableView==sortTableView) {
 
          return [[[[self.structuredFilterSortedArray objectAtIndex:0] objectAtIndex:0] objectAtIndex:0] count];
      
   }
      return 1;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (tableView== sortTableView)
    {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 18)];
        /* Create custom view to display section header... */
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10,0, tableView.frame.size.width, 18)];
        [label setFont:[UIFont boldSystemFontOfSize:12]];
        /* Section header is in 0th index... */
        if (section==0)
        {
            [label setText:@"Description"];
            
        }
        else if (section==1)
        {
            [label setText:@"Plant"];
            
        }
        else
        {
            [label setText:@"BOM #"];
            
        }
        [view addSubview:label];
        
        return view;
        
    }
    
    return 0;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView==bomTableview) {
        
        static NSString *CellIdentifier = @"CustomCell";
        
        BOMOverViewTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell==nil) {
            cell=[[BOMOverViewTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
 
        cell.bomContentView.layer.cornerRadius = 2.0f;
        cell.bomContentView.layer.masksToBounds = YES;
        cell.bomContentView.layer.borderColor = [[UIColor darkGrayColor] CGColor];
        cell.bomContentView.layer.borderWidth = 1.0f;
        
        if (bomTableview.tag ==1) {
            
            cell.EquipmentBOMLabel.text =[NSString stringWithFormat:@"%@",[[filterArray objectAtIndex:indexPath.row] objectForKey:@"bomheader"]];
 
            cell.EquipmentDescriptionLabel.text = [NSString stringWithFormat:@"%@",[[filterArray objectAtIndex:indexPath.row] objectForKey:@"bomdesc"]];
            
            cell.plantLabel.text = [NSString stringWithFormat:@"%@",[[filterArray objectAtIndex:indexPath.row] objectForKey:@"plant"]];
            
            [cell.EquipmentBOMButton setTitle:[NSString stringWithFormat:@"%@",[[filterArray objectAtIndex:indexPath.row] objectForKey:@"bomheader"]] forState:UIControlStateNormal];
        }
        else{
            
            cell.EquipmentBOMLabel.text =[NSString stringWithFormat:@"%@",[[self.bomHeaderArray objectAtIndex:indexPath.row] objectForKey:@"bomheader"]];
            
            cell.EquipmentDescriptionLabel.text = [NSString stringWithFormat:@"%@",[[self.bomHeaderArray objectAtIndex:indexPath.row] objectForKey:@"bomdesc"]];
            
            cell.plantLabel.text = [NSString stringWithFormat:@"%@",[[self.bomHeaderArray objectAtIndex:indexPath.row] objectForKey:@"plant"]];
            
            [cell.EquipmentBOMButton setTitle:[NSString stringWithFormat:@"%@",[[self.bomHeaderArray objectAtIndex:indexPath.row] objectForKey:@"bomheader"]] forState:UIControlStateNormal];
        }
        
 
       // [cell.EquipmentBOMButton addTarget:self action:@selector(detailCheckBoxSelected:) forControlEvents:UIControlEventTouchDown];
        
        return cell;
    }
    
    else if (tableView==detailBomtableview){
        
        static NSString *CellIdentifier = @"detailBomCell";
        
        BOMOverViewTableViewCell *bomCell =[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (bomCell==nil) {
            bomCell=[[BOMOverViewTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        bomCell.selectionStyle = UITableViewCellSelectionStyleNone;

        bomCell.bomContentView.layer.cornerRadius = 2.0f;
        bomCell.bomContentView.layer.masksToBounds = YES;
        bomCell.bomContentView.layer.borderColor = [[UIColor darkGrayColor] CGColor];
        bomCell.bomContentView.layer.borderWidth = 1.0f;
        
       // [bomCell.EquipmentBOMButton addTarget:self action:@selector(detailCheckBoxSelected:) forControlEvents:UIControlEventTouchDown];
        
        if (detailBomtableview.tag == 1) {
            
            [bomCell.equipmentComponentButton setTitle:[NSString stringWithFormat:@"%@",[[filterArray objectAtIndex:indexPath.row] objectForKey:@"bomcomponent"]] forState:UIControlStateNormal];
            
            if ([[[filterArray objectAtIndex:indexPath.row] objectForKey:@"stlkz"] isEqualToString:@"X"]) {
                
                bomCell.layer.borderWidth = 2.0;
                bomCell.layer.borderColor = [UIColor redColor].CGColor;
                
                [bomCell.equipmentComponentButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
                
                bomCell.equipmentComponentButton.tag = indexPath.row;
                
                [bomCell.equipmentComponentButton addTarget:self action:@selector(componentHighlighted:) forControlEvents:UIControlEventTouchDown];
 
                [bomCell.contentView addSubview:bomCell.equipmentComponentButton];
            }
            else{
                
                bomCell.layer.borderWidth = 0;
                bomCell.layer.borderColor = [UIColor clearColor].CGColor;
                [bomCell.equipmentComponentButton setTitleColor:UIColorFromRGB(59, 187, 196) forState:UIControlStateNormal];
            }
            
            bomCell.componentLabel.text = [NSString stringWithFormat:@"%@",[[filterArray objectAtIndex:indexPath.row] objectForKey:@"bomcomponent"]];
            bomCell.componentTextLabel.text = [NSString stringWithFormat:@"%@",[[filterArray objectAtIndex:indexPath.row] objectForKey:@"comptext"]];
            bomCell.quantityLabel.text = [NSString stringWithFormat:@"%@",[[filterArray objectAtIndex:indexPath.row] objectForKey:@"quantity"]];
            bomCell.unitLabel.text = [NSString stringWithFormat:@"%@",[[filterArray objectAtIndex:indexPath.row] objectForKey:@"unit"]];
            
        }
        else{
            
            [bomCell.equipmentComponentButton setTitle:[NSString stringWithFormat:@"%@",[[self.bomDetailListArray objectAtIndex:indexPath.row] objectForKey:@"bomcomponent"]] forState:UIControlStateNormal];
            
            if ([[[self.bomDetailListArray objectAtIndex:indexPath.row] objectForKey:@"stlkz"] isEqualToString:@"X"]) {
                
                bomCell.layer.borderWidth = 2.0;
                bomCell.layer.borderColor = [UIColor redColor].CGColor;
                
                [bomCell.equipmentComponentButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
                
                bomCell.equipmentComponentButton.tag = indexPath.row;
                
                [bomCell.equipmentComponentButton addTarget:self action:@selector(componentHighlighted:) forControlEvents:UIControlEventTouchDown];
                
                [bomCell.contentView addSubview:bomCell.equipmentComponentButton];
            }
            else{
                
                bomCell.layer.borderWidth = 0;
                bomCell.layer.borderColor = [UIColor clearColor].CGColor;
                [bomCell.equipmentComponentButton setTitleColor:UIColorFromRGB(38, 85, 153) forState:UIControlStateNormal];
            }
            
            bomCell.componentLabel.text = [NSString stringWithFormat:@"%@",[[self.bomDetailListArray objectAtIndex:indexPath.row] objectForKey:@"bomcomponent"]];
            bomCell.componentTextLabel.text = [NSString stringWithFormat:@"%@",[[self.bomDetailListArray objectAtIndex:indexPath.row] objectForKey:@"comptext"]];
            bomCell.quantityLabel.text = [NSString stringWithFormat:@"%@",[[self.bomDetailListArray objectAtIndex:indexPath.row] objectForKey:@"quantity"]];
            bomCell.unitLabel.text = [NSString stringWithFormat:@"%@",[[self.bomDetailListArray objectAtIndex:indexPath.row] objectForKey:@"unit"]];
            
        }
        
        
        return bomCell;
    }
    
    else if (tableView==sortTableView){
        
        static NSString *CellIdentifier = @"CustomCell";
        
        FilterSortTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell==nil) {
            cell=[[FilterSortTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        cell.headerlabelValue.hidden = NO;
        cell.dateTextfield.hidden = YES;
        cell.dateImageView.hidden = YES;
        cell.filterSortCheckBoxButton.hidden = NO;
        
        cell.filterSortCheckBoxButton.adjustsImageWhenHighlighted = YES;
        
        cell.headerlabelValue.text=[[[[self.structuredFilterSortedArray objectAtIndex:0]objectAtIndex:indexPath.section] objectAtIndex:0] objectAtIndex:indexPath.row];
        
        if ([[[[[self.structuredFilterSortedArray objectAtIndex:0] objectAtIndex:indexPath.section] objectAtIndex:1] objectAtIndex:indexPath.row] isEqualToString:@"X"])
        {
            
            [cell.filterSortCheckBoxButton setImage:[UIImage imageNamed:@"CheckBoxSelection"]   forState:UIControlStateNormal];
            
            cell.headerlabelValue.textColor= [UIColor colorWithRed:38.0/255.0 green:85.0/255.0 blue:153.0/255.0 alpha:5.0];
        }
        else
        {
            [cell.filterSortCheckBoxButton setImage:[UIImage imageNamed:@"checkBoxUnSelection"]   forState:UIControlStateNormal];
            cell.headerlabelValue.textColor=[UIColor lightGrayColor];
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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==detailBomtableview) {
        
         ReservationViewController *resVc = [self.storyboard instantiateViewControllerWithIdentifier:@"ReserveView"];
        
        NSMutableArray *tempArray=[NSMutableArray new];
        
         if (detailBomtableview.tag==1)
         {
             [tempArray addObject:[filterArray objectAtIndex:indexPath.row]];
         }
         else{
 
             [tempArray addObject:[self.bomDetailListArray objectAtIndex:indexPath.row]];

         }
        
        resVc.detailBomDetailsArray=[tempArray copy];
 
        resVc.plantValueString=plantValueString;
        
        [self showViewController:resVc sender:self];
     }
    else if (tableView==bomTableview) {
        
        componentHighlighted = NO;
   
     if (bomTableview.tag == 1) {
        
        bomValueString =[[filterArray objectAtIndex:indexPath.row] objectForKey:@"bomheader"];
        plantValueString =[[filterArray objectAtIndex:indexPath.row] objectForKey:@"plant"];
        bomHeaderLabel.text = [[filterArray objectAtIndex:indexPath.row] objectForKey:@"bomheader"];
        detailBomCountlabel.text=[NSString stringWithFormat:@"%@-%@",bomValueString,[[filterArray objectAtIndex:indexPath.row] objectForKey:@"bomdesc"]];
     }
    else{
        
        bomValueString = [[self.bomHeaderArray objectAtIndex:indexPath.row] objectForKey:@"bomheader"];
        plantValueString = [[self.bomHeaderArray objectAtIndex:indexPath.row] objectForKey:@"plant"];
        bomHeaderLabel.text = [[self.bomHeaderArray objectAtIndex:indexPath.row] objectForKey:@"bomheader"];
        detailBomCountlabel.text=[NSString stringWithFormat:@"%@-%@",bomValueString,[[self.bomHeaderArray objectAtIndex:indexPath.row] objectForKey:@"bomdesc"]];
    }
    
    detailBomCountlabel.adjustsFontSizeToFitWidth = YES;
    [self fetchDataFromLDB_BomLookup_EtComponents];
    [bomDetailView setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [self.view addSubview:bomDetailView];
    
    }
}

-(void)detailCheckBoxSelected:(id)sender
 {
      componentHighlighted = NO;
      NSIndexPath *ip = [self GetCellFromTableView:bomTableview Sender:sender];
      NSInteger i = ip.row;
    
    if (bomTableview.tag == 1) {
        
        bomValueString =[[filterArray objectAtIndex:i] objectForKey:@"bomheader"];
        plantValueString =[[filterArray objectAtIndex:i] objectForKey:@"plant"];
        bomHeaderLabel.text = [[filterArray objectAtIndex:i] objectForKey:@"bomheader"];
        detailBomCountlabel.text=[NSString stringWithFormat:@"%@-%@",bomValueString,[[filterArray objectAtIndex:i] objectForKey:@"bomdesc"]];
        
    }
    else{
        
        bomValueString = [[self.bomHeaderArray objectAtIndex:i] objectForKey:@"bomheader"];
        plantValueString = [[self.bomHeaderArray objectAtIndex:i] objectForKey:@"plant"];
        bomHeaderLabel.text = [[self.bomHeaderArray objectAtIndex:i] objectForKey:@"bomheader"];
        detailBomCountlabel.text=[NSString stringWithFormat:@"%@-%@",bomValueString,[[self.bomHeaderArray objectAtIndex:i] objectForKey:@"bomdesc"]];
    }
     
     detailBomCountlabel.adjustsFontSizeToFitWidth = YES;

      [self fetchDataFromLDB_BomLookup_EtComponents];
     [bomDetailView setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
     [self.view addSubview:bomDetailView];
 
}


#pragma mark-
#pragma mark- Void Methods

-(void)functionForSyncMapData{
    
    if (syncMapDataMutableArray == nil) {
        syncMapDataMutableArray = [NSMutableArray new];
    }
    
    else{
        [syncMapDataMutableArray removeAllObjects];
    }
    
    [syncMapDataMutableArray addObjectsFromArray:[[DataBase sharedInstance] getSyncMapData:@"SOAP"]];
    
    if ([syncMapDataMutableArray count]) {
        
        if ([[ConnectionManager defaultManager] isReachable]) {
            
            if (!isRefresh) {
                
                [self performSelectorOnMainThread:@selector(getlistofBoms) withObject:nil waitUntilDone:YES];
            }
            else{
                
                [self performSelectorOnMainThread:@selector(getLoadSettings) withObject:nil waitUntilDone:YES];
            }
        }
    }
}

-(void)getLoadSettings{
    
    //    NSMutableDictionary *dataDictionary = [[NSMutableDictionary alloc]init];
    //    [dataDictionary setObject:decryptedUserName forKey:@"REPORTEDBY"];
    //    [dataDictionary setObject:[[syncMapDataMutableArray objectAtIndex:10] objectAtIndex:3] forKey:@"URL_ENDPOINT"];
    //    [dataDictionary setObject:@"REFR" forKey:@"TRANSMITTYPE"];
    //    [Request makeWebServiceRequest:GET_LOAD_SETTINGS parameters:dataDictionary delegate:self];
    
    NSMutableDictionary *dataDictionary = [[NSMutableDictionary alloc]init];
    NSMutableDictionary *endPointDictionary = [NSMutableDictionary new];
    [endPointDictionary setObject:@"F4" forKey:@"ACTIVITY"];
    [endPointDictionary setObject:@"D1" forKey:@"DOCTYPE"];
    [endPointDictionary setObject:@"SOAP" forKey:@"ENDPOINT"];
    NSArray *endPointArray = [[DataBase sharedInstance] getEndPointURL:endPointDictionary];
    NSLog(@"endPoint :%@",[[endPointArray objectAtIndex:0] objectAtIndex:0]);
    [dataDictionary setObject:[[endPointArray objectAtIndex:0] objectAtIndex:0] forKey:@"URL_ENDPOINT"];
    [dataDictionary setObject:decryptedUserName forKey:@"REPORTEDBY"];
    [dataDictionary setObject:@"REFR" forKey:@"TRANSMITTYPE"];
    [Request makeWebServiceRequest:GET_LOAD_SETTINGS parameters:dataDictionary delegate:self];
    
    
}


-(void)getlistofBomsLoad{
    
    NSMutableDictionary *dataDictionary = [[NSMutableDictionary alloc]init];
    [dataDictionary setObject:decryptedUserName forKey:@"REPORTEDBY"];
    
    NSMutableDictionary *endPointDictionary = [NSMutableDictionary new];
    [endPointDictionary setObject:@"EQ" forKey:@"ACTIVITY"];
    [endPointDictionary setObject:@"C5" forKey:@"DOCTYPE"];
    [endPointDictionary setObject:@"SOAP" forKey:@"ENDPOINT"];
    
    NSArray *endPointArray = [[DataBase sharedInstance] getEndPointURL:endPointDictionary];
    NSLog(@"endPoint :%@",[[endPointArray objectAtIndex:0] objectAtIndex:0]);
    [dataDictionary setObject:[[endPointArray objectAtIndex:0] objectAtIndex:0] forKey:@"URL_ENDPOINT"];
    [dataDictionary setObject:@"" forKey:@"EQUIPDESCRIP"];
    
    [dataDictionary setObject:@"" forKey:@"EQUIPNO"];
    [dataDictionary setObject:@"LOAD" forKey:@"TRANSMITTYPE"];
    
    [Request makeWebServiceRequest:GET_LIST_OF_PM_BOMS parameters:dataDictionary delegate:self];
}


-(void)getlistofBoms{
    
    NSMutableDictionary *dataDictionary = [[NSMutableDictionary alloc]init];
    [dataDictionary setObject:decryptedUserName forKey:@"REPORTEDBY"];
    [dataDictionary setObject:[[syncMapDataMutableArray objectAtIndex:5] objectAtIndex:3] forKey:@"URL_ENDPOINT"];
    [dataDictionary setObject:@"" forKey:@"EQUIPDESCRIP"];
    
    if (!isRefresh) {
        [dataDictionary setObject:_bomSearchBar.text forKey:@"EQUIPNO"];
        [dataDictionary setObject:@"LOAD" forKey:@"TRANSMITTYPE"];
    }
    else
    {
        [dataDictionary setObject:@"" forKey:@"EQUIPNO"];
        [dataDictionary setObject:@"REFR" forKey:@"TRANSMITTYPE"];
    }
    
    [Request makeWebServiceRequest:GET_LIST_OF_PM_BOMS parameters:dataDictionary delegate:self];
}


#pragma mark- result data

-(void)resultData:(NSDictionary *)resultData withErrorDescription:(NSString *)errorDescription requestID:(WebServiceRequest)requestID :(int)statusCode
{
    switch (requestID) {
            
            searchListArray = nil;
            searchListArray = [[NSMutableArray alloc]init];
            
        case GET_MATERIAL_AVAILABILITY_CHECK:
            
            if (statusCode == 401) {
                
                [MBProgressHUD hideHUDForView:self.view animated:YES];

                UIAlertView *authenticationFailedAlert = [[UIAlertView alloc] initWithTitle:@"Authentication Failed!!" message:@"kindly check your password" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                
                [authenticationFailedAlert show];
                
                return;
            }
            
            if (!errorDescription.length) {
                
                NSMutableDictionary *parsedDictionary = [[Response sharedInstance] parseForMaterialCheckAvailability:resultData];
                
                if ([[parsedDictionary objectForKey:@"Message"] objectAtIndex:0]) {
                    parsedDictionary = [[parsedDictionary objectForKey:@"Message"] objectAtIndex:0];
                    
                    if ([[[parsedDictionary objectForKey:@"Message"] substringToIndex:1] isEqualToString:@"S"]) {
                        
                       // [self submitReserve];
                    }
                    else if ([[[parsedDictionary objectForKey:@"Message"] substringToIndex:1] isEqualToString:@"E"]) {
                        
                        UIAlertView *alert =[[UIAlertView alloc] initWithTitle:@"Information" message:[[parsedDictionary objectForKey:@"Message"] substringFromIndex:1] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                        [alert show];
                    }
                }
                else if ([parsedDictionary objectForKey:@"ERROR"]){
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Information" message:[parsedDictionary objectForKey:@"ERROR"] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                    [alert show];
                    
 
                }
            }
            
            break;
            
        case GET_LIST_OF_PM_BOMS:
            
            if (statusCode == 401) {
                
                [MBProgressHUD hideHUDForView:bomDetailView animated:YES];

                 [detailBomtableview reloadData];
                
                UIAlertView *authenticationFailedAlert = [[UIAlertView alloc] initWithTitle:@"Authentication Failed!!" message:@"kindly check your password" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                
                [authenticationFailedAlert show];
                
                return;
            }
            
            if (!errorDescription.length) {
                
                if (isRefresh) {
                    
                    if ([resultData count]) {
                        
                        AppDelegate *tempDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
 
                        [tempDelegate.coreDataControlObject removeContextForEquipmentBOM:@""];
                        
                        //                        [[DataBase sharedInstance] deleteSqliteFile_BomLookup_ETComponents :@""];
                    }
                    
                    [[Response sharedInstance] parseForListOfPMBOMS:resultData];
                }
                else if (selectedBOM){
                    
                    if ([resultData count]) {
                        
                        [[Response sharedInstance] parseForListOfPMBOMSItemData:resultData];
                        
                        [self fetchDataFromLDB_BomLookup_EtComponents];
                    }
                    else{
                        
                        componentsHeaderLabel.text=[NSString stringWithFormat:@"%@(%lu)",bomValueString,(unsigned long)[self.bomDetailListArray count]];
 
                        [detailBomtableview scrollRectToVisible:CGRectMake(0, 0, 0, 0) animated:YES];
                        
                        [detailBomtableview reloadData];
                    }
                }
                else
                {
                    if ([resultData count]) {
                        
                        [[DataBase sharedInstance] deleteSqliteFile_BomLookup_ETComponents:_bomSearchBar.text];
                        
                        NSMutableDictionary *parsedDictionary = [[Response sharedInstance] parseForListOfPMBOMS:resultData];
                        
                        [MBProgressHUD hideHUDForView:self.view animated:YES];

                        if ([parsedDictionary objectForKey:@"ERROR"]) {
                            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:[parsedDictionary objectForKey:@"ERROR"] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                            [alert show];
                        }
                        else{
                            
                            NSString *filterString = [NSString stringWithFormat:@"Bom LIKE '%@%%'",_bomSearchBar.text];
                            
                            if (isRefresh) {
                                
                                [[Response sharedInstance] parseForListOfPMBOMS:resultData];
                            }
                            
                            [inputsDictionary removeObjectForKey:@"COLOUMN"];
                            [inputsDictionary setObject:filterString forKey:@"FILTER"];
                            
                            [self searchForBOMOverviewLook:inputsDictionary];
                        }
                    }
                    else{
                        
                        UIAlertView *alertListOfOpenBOMLookup= [[UIAlertView alloc]initWithTitle:@"Info" message:@"No suitable data found for the selected criteria!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                        [alertListOfOpenBOMLookup show];
                    }
                }
                
                [MBProgressHUD hideHUDForView:bomDetailView animated:YES];
            }
            else{
                
                [MBProgressHUD hideHUDForView:bomDetailView animated:YES];
            }
            
            break;
            
        case GET_SYNC_MAP_DATA:
            
            if (statusCode == 401) {
                
                [MBProgressHUD hideHUDForView:self.view animated:YES];

              //  [reserveView removeFromSuperview];
                [detailBomtableview reloadData];
                
                UIAlertView *authenticationFailedAlert = [[UIAlertView alloc] initWithTitle:@"Authentication Failed!!" message:@"kindly check your password" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                
                [authenticationFailedAlert show];
                
                return;
            }
            
            if (!errorDescription.length) {
                
                [[Response sharedInstance] parseForSyncMapData:resultData];
                
                [self functionForSyncMapData];
            }
            else{
                
                [MBProgressHUD hideHUDForView:self.view animated:YES];

                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"FieldTekPro" message:errorDescription delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                
                [alert show];
            }
            
            break;
            
        case GET_LOAD_SETTINGS:
            
            if (statusCode == 401) {
                
                [MBProgressHUD hideHUDForView:self.view animated:YES];

               // [reserveView removeFromSuperview];
                
                [detailBomtableview reloadData];
                
                UIAlertView *authenticationFailedAlert = [[UIAlertView alloc] initWithTitle:@"Authentication Failed!!" message:@"kindly check your password" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                
                [authenticationFailedAlert show];
                
                return;
            }
            
            if (!errorDescription.length) {
                
                NSMutableDictionary *parsedDictionary = [[Response sharedInstance] parseForLoadSettings:resultData];
                
                [self getlistofBomsLoad];
                
                if ([parsedDictionary objectForKey:@"resultRefresh"]) {
                    if ([[parsedDictionary objectForKey:@"resultRefresh"] isKindOfClass:[NSArray class]]) {
                        if ([[parsedDictionary objectForKey:@"resultRefresh"] objectAtIndex:0]) {
                            
                            if ([[[parsedDictionary objectForKey:@"resultRefresh"] objectAtIndex:0] objectForKey:@"Ebom"]) {
                                if ([[[[parsedDictionary objectForKey:@"resultRefresh"] objectAtIndex:0] objectForKey:@"Ebom"] isEqualToString:@"X"]) {
                                    [self getlistofBoms];
                                }
                                else{
                                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                                    UIAlertView *noChangesalert = [[UIAlertView alloc]initWithTitle:@"Info" message:@"No changes for you." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                                    [noChangesalert show];
                                }
                            }
                        }
                    }
                    else if ([[parsedDictionary objectForKey:@"resultRefresh"] isKindOfClass:[NSDictionary class]]){
                        
                        if ([[parsedDictionary objectForKey:@"resultRefresh"] objectForKey:@"Ebom"]) {
                            if ([[[parsedDictionary objectForKey:@"resultRefresh"] objectForKey:@"Ebom"] isEqualToString:@"X"]) {
                                
                                [self getlistofBoms];
                            }
                            else{
                                [MBProgressHUD hideHUDForView:self.view animated:YES];

                                UIAlertView *noChangesalert = [[UIAlertView alloc]initWithTitle:@"Info" message:@"No changes for you." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                                [noChangesalert show];
                            }
                        }
                    }
                }
            }
            else{
                
                [MBProgressHUD hideHUDForView:self.view animated:YES];

                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"FieldTekPro" message:errorDescription delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                
                [alert show];
                
            }
            
            break;
            
        case GET_LIST_OF_MOVEMENTTYPES:
            
            if (statusCode == 401) {
                
                [MBProgressHUD hideHUDForView:self.view animated:YES];

               // [reserveView removeFromSuperview];
                [detailBomtableview reloadData];
                
                UIAlertView *authenticationFailedAlert = [[UIAlertView alloc] initWithTitle:@"Authentication Failed!!" message:@"kindly check your password" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                
                [authenticationFailedAlert show];
                
                return;
            }
            
            if (!errorDescription.length) {
                NSMutableDictionary *parsedDictionary = [[Response sharedInstance] parseForFuncLocCostCenter:resultData];
                
                if ([parsedDictionary objectForKey:@"result"]) {
                    
                    NSArray *listOfMovementTypesArray = [parsedDictionary objectForKey:@"result"];
                    
                    [searchListArray removeAllObjects];
                    
                    for (int i =0; i< [listOfMovementTypesArray count]; i++) {
                        
                        NSString *str_Btext = [[listOfMovementTypesArray objectAtIndex:i] objectForKey:@"Btext"];
                        NSString *str_Bwart = [[listOfMovementTypesArray objectAtIndex:i] objectForKey:@"Bwart"];
                        
                        if ([NullChecker isNull:str_Btext]) {
                            str_Btext = @"";
                        }
                        
                        if ([NullChecker isNull:str_Bwart]) {
                            str_Bwart = @"";
                        }
                        
                        [searchListArray addObject:[NSMutableArray arrayWithObjects:[str_Btext copy],[str_Bwart copy], nil]];
                    }
                    
                    //  [[DataBase sharedInstance] insert_ListOfMovementTypes];
                }
                
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            }
            else
            {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            }
            
            break;
            
       
            
        default:
            break;
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
