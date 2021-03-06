//
//  StockOverViewController.m
//  Fieldtekpro
//
//  Created by Sathya Rakesh Kumar on 06/12/17.
//  Copyright © 2017 Enstrapp Bangalore. All rights reserved.
//

#import "StockOverViewController.h"

@interface StockOverViewController ()

@end

@implementation StockOverViewController
@synthesize defaults;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.structuredFilterSortedArray = [NSMutableArray new];
    
    defaults=[NSUserDefaults standardUserDefaults];
 
    inputsDictionary = [NSMutableDictionary new];

    [self searchForstockOverviewLook:nil];
 
    NSString *key = @"";
    NSString *str_UserNameDep = [defaults objectForKey:@"userName"];
     decryptedUserName = [str_UserNameDep AES128DecryptWithKey:key];
    
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
    
    searchBtn.imageEdgeInsets = UIEdgeInsetsMake(-0,10, 10, 0);
    searchBtn.titleEdgeInsets = UIEdgeInsetsMake(30, -40, 0, 0);
    
    sortBtn.imageEdgeInsets = UIEdgeInsetsMake(-10,10,5, 15);
    sortBtn.titleEdgeInsets = UIEdgeInsetsMake(30,-15, 0, 0);
    
    refreshBtn.imageEdgeInsets = UIEdgeInsetsMake(-10,20, 10, 0);
    refreshBtn.titleEdgeInsets = UIEdgeInsetsMake(30, -20, 0, 0);
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(IBAction)searchCloseButtonClicked:(id)sender{
    
    [stockTableview setTableHeaderView:nil];
    
}

-(IBAction)searchButtonClicked:(id)sender{
    
    [searchView setFrame:CGRectMake(0, 0, stockTableview.frame.size.width, 44)];
    [stockTableview setTableHeaderView:searchView];
}

 -(IBAction)clearAllButtonClicked:(id)sender{
     [blackView removeFromSuperview];
    [sortView removeFromSuperview];
 }

-(IBAction)submitSortButtonClicked:(id)sender{
    [blackView removeFromSuperview];
    [sortView removeFromSuperview];
}

-(IBAction)cancelSortButtonClicked:(id)sender{
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
            
            [self performSelectorOnMainThread:@selector(getLoadSettings) withObject:nil waitUntilDone:YES];
            
        }
    }
}

-(void)getLoadSettings{
    
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

-(void)getStockData{
    NSMutableDictionary *searchDictionary = [[NSMutableDictionary alloc]init];
    [searchDictionary setObject:decryptedUserName forKey:@"REPORTEDBY"];
    [searchDictionary setObject:@"" forKey:@"MATERIAL"];
    [searchDictionary setObject:@"" forKey:@"PLANTFROM"];
    [searchDictionary setObject:@"" forKey:@"PLANTTO"];
    [searchDictionary setObject:@"" forKey:@"STORAGELOCFROM"];
    [searchDictionary setObject:@"" forKey:@"STORAGELOCTO"];
    [searchDictionary setObject:@"" forKey:@"MATERIALDESC"];
    NSMutableDictionary *endPointDictionary = [NSMutableDictionary new];
    [endPointDictionary setObject:@"SD" forKey:@"ACTIVITY"];
    [endPointDictionary setObject:@"C8" forKey:@"DOCTYPE"];
    [endPointDictionary setObject:@"SOAP" forKey:@"ENDPOINT"];
    NSArray *endPointArray = [[DataBase sharedInstance] getEndPointURL:endPointDictionary];
    
    [searchDictionary setObject:[[endPointArray objectAtIndex:0] objectAtIndex:0] forKey:@"URL_ENDPOINT"];
    [Request makeWebServiceRequest:GET_STOCK_DATA parameters:searchDictionary delegate:self];
    
    if ([[defaults objectForKey:@"STOCK_REFRESH"] isEqualToString:@"X"]) {
        [searchDictionary setObject:@"REFR" forKey:@"TRANSMITTYPE"];
        [Request makeWebServiceRequest:GET_STOCK_DATA parameters:searchDictionary delegate:self];
    }
}

#pragma mark-
#pragma mark- Sort Options

-(IBAction)MaterialSelected:(id)sender
{
    if (materialSortSelected) {
        
        [MaterialSortBtn setImage:[UIImage imageNamed:@"SortUp.png"] forState:UIControlStateNormal];
        
        [inputsDictionary setObject:@"ASC" forKey:@"SORT"];
        
        materialSortSelected = NO;
    }
    else{
        [MaterialSortBtn setImage:[UIImage imageNamed:@"SortDown.png"] forState:UIControlStateNormal];
        [inputsDictionary setObject:@"DESC" forKey:@"SORT"];
        materialSortSelected = YES;
    }
    
    [inputsDictionary setObject:@"Labst" forKey:@"COLOUMN"];
    
    [self searchForstockOverviewLook:inputsDictionary];
    
    
}

-(IBAction)DescriptionSelected:(id)sender
{
    if (descriptionSortSelected) {
        [DescriptionSortBtn setImage:[UIImage imageNamed:@"SortUp.png"] forState:UIControlStateNormal];
        [inputsDictionary setObject:@"ASC" forKey:@"SORT"];
        descriptionSortSelected = NO;
    }
    else{
        [DescriptionSortBtn setImage:[UIImage imageNamed:@"SortDown.png"] forState:UIControlStateNormal];
        [inputsDictionary setObject:@"DESC" forKey:@"SORT"];
        descriptionSortSelected = YES;
    }
    
    [inputsDictionary setObject:@"Lgort" forKey:@"COLOUMN"];
    
    [self searchForstockOverviewLook:inputsDictionary];
    
    
}

-(IBAction)PlantSelected:(id)sender
{
    if (plantSortSelected) {
        [PlantSortBtn setImage:[UIImage imageNamed:@"SortUp.png"] forState:UIControlStateNormal];
        [inputsDictionary setObject:@"ASC" forKey:@"SORT"];
        plantSortSelected = NO;
    }
    else{
        [PlantSortBtn setImage:[UIImage imageNamed:@"SortDown.png"] forState:UIControlStateNormal];
        [inputsDictionary setObject:@"DESC" forKey:@"SORT"];
        plantSortSelected = YES;
    }
    
    [inputsDictionary setObject:@"Lgpbe" forKey:@"COLOUMN"];
    
    [self searchForstockOverviewLook:inputsDictionary];
    
    
}

-(IBAction)storLocnSelected:(id)sender
{
    if (storLocnSortSelected) {
        [storLocnBtnSortBtn setImage:[UIImage imageNamed:@"SortUp.png"] forState:UIControlStateNormal];
        [inputsDictionary setObject:@"ASC" forKey:@"SORT"];
        storLocnSortSelected = NO;
    }
    else{
        [storLocnBtnSortBtn setImage:[UIImage imageNamed:@"SortDown.png"] forState:UIControlStateNormal];
        [inputsDictionary setObject:@"DESC" forKey:@"SORT"];
        storLocnSortSelected = YES;
    }
    
    [inputsDictionary setObject:@"Maktx" forKey:@"COLOUMN"];
    
    [self searchForstockOverviewLook:inputsDictionary];
    
    
}

-(IBAction)UnrestrictedSelected:(id)sender
{
    if (unrestrictedSortSelected) {
        [UnrestrictedSortBtn setImage:[UIImage imageNamed:@"SortUp.png"] forState:UIControlStateNormal];
        [inputsDictionary setObject:@"ASC" forKey:@"SORT"];
        unrestrictedSortSelected = NO;
    }
    else{
        [UnrestrictedSortBtn setImage:[UIImage imageNamed:@"SortDown.png"] forState:UIControlStateNormal];
        [inputsDictionary setObject:@"DESC" forKey:@"SORT"];
        unrestrictedSortSelected = YES;
    }
    
    [inputsDictionary setObject:@"Matnr" forKey:@"COLOUMN"];
    
    [self searchForstockOverviewLook:inputsDictionary];
    
    
}

-(IBAction)BlockedStockBtn:(id)sender{
    
    if (blockedStockSelected) {
        [BlockedStockSortBtn setImage:[UIImage imageNamed:@"SortUp.png"] forState:UIControlStateNormal];
        [inputsDictionary setObject:@"ASC" forKey:@"SORT"];
        blockedStockSelected = NO;
    }
    else{
        [BlockedStockSortBtn setImage:[UIImage imageNamed:@"SortDown.png"] forState:UIControlStateNormal];
        [inputsDictionary setObject:@"DESC" forKey:@"SORT"];
        blockedStockSelected = YES;
    }
    
    [inputsDictionary setObject:@"Speme" forKey:@"COLOUMN"];
    
    [self searchForstockOverviewLook:inputsDictionary];
}

-(IBAction)StorageBinBtn:(id)sender{
    
    if (storageBinselected) {
        
        [StorageBinSortBtn setImage:[UIImage imageNamed:@"SortUp.png"] forState:UIControlStateNormal];
        [inputsDictionary setObject:@"ASC" forKey:@"SORT"];
        storageBinselected = NO;
    }
    else{
        
        [StorageBinSortBtn setImage:[UIImage imageNamed:@"SortDown.png"] forState:UIControlStateNormal];
        [inputsDictionary setObject:@"DESC" forKey:@"SORT"];
        storageBinselected = YES;
    }
    
    [inputsDictionary setObject:@"Werks" forKey:@"COLOUMN"];
    
    [self searchForstockOverviewLook:inputsDictionary];
}

-(void)searchForstockOverviewLook :(NSMutableDictionary *)actions{
    
    if (self.stockListArray == nil) {
        
        
        self.stockListArray = [NSMutableArray new];
    }
    else{
        
        [self.stockListArray removeAllObjects];
    }
    
    [self.stockListArray addObjectsFromArray:[[DataBase sharedInstance] getStockDataForSearchDescription:actions]];
    
    stockOverviewCountLabel.text = [NSString stringWithFormat:@"My Stocks (%i)",(int)[self.stockListArray count]];
    
    [stockTableview scrollRectToVisible:CGRectMake(0, 0, 0, 0) animated:YES];
    
    [stockTableview reloadData];
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    
    if (searchText.length) {
        
        NSPredicate *bPredicate = [NSPredicate predicateWithFormat:@"matnr contains[c] %@ or maktx contains[c] %@",searchText,searchText];
        
        filterArray = [self.stockListArray filteredArrayUsingPredicate:bPredicate];
        
        
        stockOverviewCountLabel.text = [NSString stringWithFormat:@"My Stock (%i)",(int)[filterArray count]];
        
        [stockTableview scrollRectToVisible:CGRectMake(0, 0, 0, 0) animated:YES];
        
        [stockTableview setTag:1];
    }
    else{
        
        [stockTableview setTag:0];
        
        stockOverviewCountLabel.text = [NSString stringWithFormat:@"My Stock (%i)",(int)[self.stockListArray count]];
    }
    
    [stockTableview reloadData];
    
    //    NSString *filterString = [NSString stringWithFormat:@"Labst like '%@%%' or Lgort like '%@%%' or Lgpbe like '%@%%' or Maktx like '%@%%' or Matnr like '%@%%' or Speme like '%@%%' or Werks like '%@%%'",searchText,searchText,searchText,searchText,searchText,searchText,searchText];
    //
    //    [inputsDictionary removeObjectForKey:@"COLOUMN"];
    //    [inputsDictionary setObject:filterString forKey:@"FILTER"];
    //
    //    [self searchForstockOverviewLook:inputsDictionary];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    stockOverviewCountLabel.text = [NSString stringWithFormat:@"My Stock (%i)",(int)[filterArray count]];
    [self.StockSearchBar resignFirstResponder];
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
    
    if (tableView ==stockTableview)
    {
         if (stockTableview.tag == 1)
        {
            return filterArray.count;
        }
        else{
            
            return [self.stockListArray count];
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
            [label setText:@"Material"];
            
        }
        [view addSubview:label];
        
        return view;
    }
    
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView==stockTableview) {
        
        static NSString *CellIdentifier = @"CustomCell";
        
        StockOverViewTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell==nil) {
            cell=[[StockOverViewTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        cell.countLabel.text = [NSString stringWithFormat:@"%i)",(int)[indexPath row]+1];
        
        cell.stockContentView.layer.cornerRadius = 2.0f;
        cell.stockContentView.layer.masksToBounds = YES;
        cell.stockContentView.layer.borderColor = [[UIColor darkGrayColor] CGColor];
        cell.stockContentView.layer.borderWidth = 1.0f;
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
 
        if (stockTableview.tag == 1) {
            
            cell.materialLabel.text=[[filterArray objectAtIndex:indexPath.row]objectForKey:@"matnr"];
            cell.descriptionLabel.text=[[filterArray objectAtIndex:indexPath.row]objectForKey:@"maktx"];
            cell.plantLabel.text=[NSString stringWithFormat:@"%@/%@",[[filterArray objectAtIndex:indexPath.row]objectForKey:@"werks"],[[filterArray objectAtIndex:indexPath.row]objectForKey:@"lgort"]];
            
            cell.StorlocnLabel.text=[[filterArray objectAtIndex:indexPath.row]objectForKey:@"lgort"];
            cell.unresrictedLabel.text=[[filterArray objectAtIndex:indexPath.row]objectForKey:@"labst"];
            cell.blockedstockLabel.text=[[filterArray objectAtIndex:indexPath.row]objectForKey:@"speme"];
            cell.storagebinLabel.text=[[filterArray objectAtIndex:indexPath.row]objectForKey:@"lgpbe"];
            
        }
        else{
            
            cell.materialLabel.text=[[self.stockListArray objectAtIndex:indexPath.row]objectForKey:@"matnr"];
            
            cell.descriptionLabel.text=[[self.stockListArray objectAtIndex:indexPath.row]objectForKey:@"maktx"];
            
            cell.plantLabel.text=[NSString stringWithFormat:@"%@/%@",[[self.stockListArray objectAtIndex:indexPath.row]objectForKey:@"werks"],[[self.stockListArray objectAtIndex:indexPath.row]objectForKey:@"lgort"]];
            
            cell.StorlocnLabel.text=[[self.stockListArray objectAtIndex:indexPath.row]objectForKey:@"lgort"];
            
            cell.unresrictedLabel.text=[[self.stockListArray objectAtIndex:indexPath.row]objectForKey:@"labst"];
            
            cell.blockedstockLabel.text=[[self.stockListArray objectAtIndex:indexPath.row]objectForKey:@"speme"];
            
            cell.storagebinLabel.text=[[self.stockListArray objectAtIndex:indexPath.row]objectForKey:@"lgpbe"];
            
        }
        
        return cell;
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
            
            cell.headerlabelValue.textColor= [UIColor colorWithRed:59.0/255.0 green:187.0/255.0 blue:196.0/255.0 alpha:5.0];
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


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    ReservationViewController *resVc = [self.storyboard instantiateViewControllerWithIdentifier:@"ReserveView"];
    
    NSMutableArray *tempArray=[NSMutableArray new];
    
    if (stockTableview.tag==1)
    {
        [tempArray addObject:[filterArray objectAtIndex:indexPath.row]];
        
        resVc.plantValueString=[[filterArray objectAtIndex:indexPath.row] objectForKey:@"werks"];

    }
    else{
        
        [tempArray addObject:[self.stockListArray objectAtIndex:indexPath.row]];
        
        resVc.plantValueString=[[self.stockListArray objectAtIndex:indexPath.row] objectForKey:@"werks"];
 
    }
    
    resVc.stockSelectedString=@"X";
    
    resVc.detailBomDetailsArray=[tempArray copy];
 
    [self showViewController:resVc sender:self];
    
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
