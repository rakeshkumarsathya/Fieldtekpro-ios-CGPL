//
//  MaintenacePlanViewController.m
//  Fieldtekpro
//
//  Created by Sathya Rakesh Kumar on 08/12/17.
//  Copyright © 2017 Enstrapp Bangalore. All rights reserved.
//

#import "MaintenacePlanViewController.h"

#define UIColorFromRGB(r, g, b)  [UIColor colorWithRed:((r) / 255.0) green:((g) / 255.0) blue:((b) / 255.0) alpha:1.0]

@interface MaintenacePlanViewController ()<UITextFieldDelegate>

@end

@implementation MaintenacePlanViewController
@synthesize defaults;

- (void)viewDidLoad {
    [super viewDidLoad];
    
     defaults = [NSUserDefaults standardUserDefaults];
     NSString *str_UserNameDep = [defaults objectForKey:@"userName"];
     decryptedUserName = [[NSString alloc] initWithString:[str_UserNameDep AES128DecryptWithKey:@""]];
 
    structuredFilterSortedArray = [[NSMutableArray alloc]init];
    
    
    if (self.equipmentNumberString.length) {
        
        [self monitorMplanDataforequipment:self.equipmentNumberString];
    }
    else{
        
        [self fetchingUserPlantandWorkCenterForMaintenancePlan:@"Searching..."];

    }
    
 
    NSMutableArray *dateArray=[NSMutableArray new];
    
    [dateArray addObject:[NSMutableArray arrayWithObjects:@"Request Date",@"X",nil]];
    [dateArray addObject:[NSMutableArray arrayWithObjects:@"Start Date",@"",nil]];
    
    [dateArray addObject:[NSMutableArray arrayWithObjects:@"From Date",@"",nil]];//for input field
    [dateArray addObject:[NSMutableArray arrayWithObjects:@"To Date",@"",nil]];//for input field
    
    [structuredFilterSortedArray addObject:[NSMutableArray arrayWithObjects:dateArray, nil]];
    
    [detailPlantMainTableView registerNib:[UINib nibWithNibName:@"DetailMaintenancePlantTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"Cell"];
    
 
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)monitorMplanDataforequipment:(NSString *)equipmentId
{
    
    if (equipmentId.length) {
        
        NSMutableDictionary *maintPlantDictionary = [NSMutableDictionary new];
        
        [maintPlantDictionary setObject:[decryptedUserName copy] forKey:@"REPORTEDBY"];
        
 
        hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeIndeterminate;
        hud.label.text =@"loading...";
        
        NSMutableDictionary *endPointDictionary = [NSMutableDictionary new];
        [endPointDictionary setObject:@"RD" forKey:@"ACTIVITY"];
        [endPointDictionary setObject:@"C4" forKey:@"DOCTYPE"];
        [endPointDictionary setObject:@"REST" forKey:@"ENDPOINT"];
        
        [maintPlantDictionary setObject:equipmentId forKey:@"EQUIP_NUMBER"];
        
        NSArray *endPointArray = [[DataBase sharedInstance] getEndPointURL:endPointDictionary];
        NSLog(@"endPoint :%@",[[endPointArray objectAtIndex:0] objectAtIndex:0]);
        
        [maintPlantDictionary setObject:[[endPointArray objectAtIndex:0] objectAtIndex:0] forKey:@"URL_ENDPOINT"];
        [maintPlantDictionary setObject:@"" forKey:@"TRANSMITTYPE"];
        
        [Request makeWebServiceRequest:INSPECTION_MPLAN parameters:maintPlantDictionary delegate:self];
        
        
    }
}

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

#pragma mark-
#pragma mark- Void Methods

-(void)fetchingUserPlantandWorkCenterForMaintenancePlan:(NSString *)activityText{
    
    //NSArray *plantNWorkCenter = [[DataBase sharedInstance] getUserDataMasterinSingleArray];
    
    //if ([plantNWorkCenter count]) {
    
    //        plantIDString = [plantNWorkCenter objectAtIndex:ID_INDEX];
    //        workCenterIDString = [plantNWorkCenter objectAtIndex:NAME_INDEX];
    
    if([[ConnectionManager defaultManager] isReachable]){
        
        hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeIndeterminate;
        hud.label.text = activityText;
        
        [self searchForPlantandWorkCenter];
    }
    else
    {
           [self showAlertMessageWithTitle:@"Information" message:@"Network not available. Online search is not possible" cancelButtonTitle:@"Ok"];
     }
 }

-(void)searchForPlantandWorkCenter
{
    NSMutableDictionary *maintPlantDictionary = [NSMutableDictionary new];
    
    [maintPlantDictionary setObject:[decryptedUserName copy] forKey:@"REPORTEDBY"];
    
    NSMutableDictionary *endPointDictionary = [NSMutableDictionary new];
    [endPointDictionary setObject:@"MS" forKey:@"ACTIVITY"];
    [endPointDictionary setObject:@"C3" forKey:@"DOCTYPE"];
    [endPointDictionary setObject:@"SOAP" forKey:@"ENDPOINT"];
    NSArray *endPointArray = [[DataBase sharedInstance] getEndPointURL:endPointDictionary];
    NSLog(@"endPoint :%@",[[endPointArray objectAtIndex:0] objectAtIndex:0]);
    
    [maintPlantDictionary setObject:[[endPointArray objectAtIndex:0] objectAtIndex:0] forKey:@"URL_ENDPOINT"];
    [maintPlantDictionary setObject:@"" forKey:@"TRANSMITTYPE"];
    
    [Request makeWebServiceRequest:SEARCH_PLANTMAINT parameters:maintPlantDictionary delegate:self];
}


#pragma mark-
#pragma mark- Search Delegate Method

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    
    if (searchText.length) {
        
        myMaintPlansTableView.tag = 1;
        
        NSPredicate *bPredicate = [NSPredicate predicateWithFormat:@"ABNUM contains[c] %@ OR EQUNR contains[c] %@ OR WARPL contains[c] %@ OR WAPOS contains[c] %@ OR PSTXT contains[c] %@ OR GSTRP contains[c] %@",searchText,searchText,searchText,searchText,searchText,searchText];
        
        self.filteredArray = [self.maintPlantsArray filteredArrayUsingPredicate:bPredicate];
        
        myMaintPlantLabel.text = [NSString stringWithFormat:@"My Maintenance Plan (%i)",(int)self.filteredArray.count];
        
    }
    else{
        
        myMaintPlansTableView.tag = 0;
        
        myMaintPlantLabel.text = [NSString stringWithFormat:@"Maintenance Plan (%i)",(int)self.maintPlantsArray.count];
    }
    
    [myMaintPlansTableView reloadData];
}

-(IBAction)detailBackButtonClicked:(id)sender
{
    [detailPlantMaintainanceView removeFromSuperview];
}

-(IBAction)backButtonClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)searchCloseButtonClicked:(id)sender{
    
    [myMaintPlansTableView setTableHeaderView:nil];
 }

-(IBAction)searchButtonClicked:(id)sender{
    
    [searchView setFrame:CGRectMake(0, 0, myMaintPlansTableView.frame.size.width, 44)];
    [myMaintPlansTableView setTableHeaderView:searchView];
}


-(IBAction)clearAllButtonClicked:(id)sender{
    [blackView removeFromSuperview];

    [filterView removeFromSuperview];
}

-(IBAction)submitSortButtonClicked:(id)sender{
    [blackView removeFromSuperview];
    [filterView removeFromSuperview];
}

-(IBAction)cancelSortButtonClicked:(id)sender{
    [blackView removeFromSuperview];
    [filterView removeFromSuperview];
}


-(IBAction)sortButtonClicked:(id)sender
{
    self.window = [UIApplication sharedApplication].keyWindow;
    blackView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.window.frame.size.height)];
    [blackView setBackgroundColor:[UIColor blackColor]];
    [blackView setAlpha:0.8];
    [self.window addSubview:blackView];
    [filterView setFrame:CGRectMake(blackView.frame.size.width-260, 57, 260, self.window.frame.size.height-57)];
    [self.window addSubview:filterView];
}


#pragma mark
#pragma mark - TableView Delegate Methods

//table view methods strats here

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;              // Default is 1 if not implemented
{
      return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (tableView == myMaintPlansTableView) {
        
        if (myMaintPlansTableView.tag == 0)
        {
            return [self.maintPlantsArray  count];
        }
        else if (myMaintPlansTableView.tag ==1){
            
            return [self.filteredArray  count];
            
        }
    }
    else if (tableView == detailPlantMainTableView){
        
        return 1;
    }
    else if (tableView== sortTableview)
    {
        return [[[structuredFilterSortedArray firstObject] objectAtIndex:section] count];
    }
    
    return 0;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (tableView== sortTableview)
    {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 18)];
        /* Create custom view to display section header... */
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10,0, tableView.frame.size.width, 18)];
        [label setFont:[UIFont boldSystemFontOfSize:12]];
        /* Section header is in 0th index... */
        [label setText:@"DATE"];
        [view addSubview:label];
        //[view setBackgroundColor:[UIColor colorWithRed:166/255.0 green:177/255.0 blue:186/255.0 alpha:1.0]]; //your background color...
        return view;
    }
    
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
     if (tableView==myMaintPlansTableView) {
        
        static NSString *CellIdentifier = @"CustomCell";
        
        MaintPlanTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell==nil) {
            cell=[[MaintPlanTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
 
        if (myMaintPlansTableView.tag == 0 && self.maintPlantsArray.count)
        {
            cell.orderNumberTextLabel.text = [[self.maintPlantsArray objectAtIndex:indexPath.row] objectForKey:@"Aufnr"];
            cell.equipmentTextLabel.text = [[self.maintPlantsArray objectAtIndex:indexPath.row] objectForKey:@"Equnr"];
            cell.maintenancePlanTextLabel.text =[[self.maintPlantsArray objectAtIndex:indexPath.row] objectForKey:@"Warpl"];
            cell.maintenanceItemTextLabel.text =[NSString stringWithFormat:@"%@",[[self.maintPlantsArray objectAtIndex:indexPath.row] objectForKey:@"Wapos"]];
            cell.maintenanceItemText_textLabel.text =[NSString stringWithFormat:@"%@",[[self.maintPlantsArray objectAtIndex:indexPath.row] objectForKey:@"Pstxt"]];
            
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd"];
            NSDate *requiredstartDate = [dateFormatter dateFromString:[NSString stringWithFormat:@"%@",[[self.maintPlantsArray objectAtIndex:indexPath.row] objectForKey:@"Gstrp"]]];
            // Convert date object into desired format
            [dateFormatter setDateFormat:@"MMM dd, yyyy"];
            NSString *convertedrequiredStartDateString = [dateFormatter stringFromDate:requiredstartDate];
            
            if ([NullChecker isNull:convertedrequiredStartDateString]) {
                convertedrequiredStartDateString = @"";
            }
            
            cell.startDateTextLabel.text =convertedrequiredStartDateString;
            
        }
        else if (myMaintPlansTableView.tag == 1 && self.filteredArray.count){
            
            cell.orderNumberTextLabel.text = [[self.filteredArray objectAtIndex:indexPath.row] objectForKey:@"Aufnr"];
            cell.equipmentTextLabel.text = [[self.filteredArray objectAtIndex:indexPath.row] objectForKey:@"Equnr"];
            cell.maintenancePlanTextLabel.text =[[self.filteredArray objectAtIndex:indexPath.row] objectForKey:@"Warpl"];
            cell.maintenanceItemTextLabel.text =[NSString stringWithFormat:@"%@",[[self.filteredArray objectAtIndex:indexPath.section] objectForKey:@"Wapos"]];
            cell.maintenanceItemText_textLabel.text =[NSString stringWithFormat:@"%@",[[self.filteredArray objectAtIndex:indexPath.row] objectForKey:@"Pstxt"]];
            cell.startDateTextLabel.text =[[self.filteredArray objectAtIndex:indexPath.row] objectForKey:@"Gstrp"];
        }
         
        
         return cell;
    }
     else  if(tableView==sortTableview)
    {
        static NSString *CellIdentifier = @"CustomCell";
        
        FilterSortTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
         if (cell==nil) {
            cell=[[FilterSortTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        if (indexPath.row == 2 || indexPath.row == 3)
        {
            cell.headerlabelValue.hidden = YES;
            cell.dateTextfield.hidden = NO;
            cell.dateImageView.hidden = NO;
            cell.filterSortCheckBoxButton.hidden = YES;
            
            cell.dateTextfield.superview.tag = indexPath.row;
            cell.dateTextfield.delegate = self;
            
            cell.dateTextfield.placeholder = [[[[structuredFilterSortedArray firstObject] objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectAtIndex:0];
            cell.dateTextfield.text = @"";
            
            if (indexPath.row == 2) {
                
                [cell.dateTextfield setTag:10];
                
                if (startDate.length) {
                    cell.dateTextfield.text=startDate;
                }
            }
            else if (indexPath.row == 3){
                
                [cell.dateTextfield setTag:20];
                
                if (endDate.length) {
                    cell.dateTextfield.text=endDate;
                }
            }
        }
        else{
            
            cell.headerlabelValue.hidden = NO;
            cell.dateTextfield.hidden = YES;
            cell.dateImageView.hidden = YES;
            cell.filterSortCheckBoxButton.hidden = NO;
            
            cell.filterSortCheckBoxButton.adjustsImageWhenHighlighted = YES;
            
            cell.headerlabelValue.text=[[[[structuredFilterSortedArray firstObject] objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectAtIndex:0];
            
            if ([[[[[structuredFilterSortedArray firstObject] objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectAtIndex:1] isEqualToString:@"X"])
            {
                [cell.filterSortCheckBoxButton setImage:[UIImage imageNamed:@"checkbox_selected.png"]   forState:UIControlStateNormal];
                
                cell.headerlabelValue.textColor= [UIColor colorWithRed:59.0/255.0 green:187.0/255.0 blue:196.0/255.0 alpha:5.0];
            }
            else
            {
                [cell.filterSortCheckBoxButton setImage:[UIImage imageNamed:@"checkbox_unselected.png"]   forState:UIControlStateNormal];
                cell.headerlabelValue.textColor=[UIColor lightGrayColor];
            }
        }
     }
         else if (tableView==detailPlantMainTableView)
        {
            if (detailPlantMainTableView.contentSize.height < detailPlantMainTableView.frame.size.height) {
                detailPlantMainTableView.scrollEnabled = NO;
            }
            else {
                detailPlantMainTableView.scrollEnabled = YES;
            }
            static NSString *CellIdentifier = @"Cell";
            
            DetailMaintenancePlantTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
             if (cell==nil) {
                cell=[[DetailMaintenancePlantTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            
            cell.accessoryType = UITableViewCellAccessoryNone;
            
            if (indexPath.row % 2 == 0){
                cell.backgroundColor =UIColorFromRGB(249, 249, 249);
            }
            else {
                cell.backgroundColor =[UIColor whiteColor];
            }
            
            if (myMaintPlansTableView.tag == 0) {
                
                cell.callNumberTextLabel.text = [NSString stringWithFormat:@"%@",[[self.maintPlantsArray objectAtIndex:selectedIndexPath] objectForKey:@"ABNUM"]];
                
                cell.maintenancePlanLabel.text =[[self.maintPlantsArray objectAtIndex:selectedIndexPath] objectForKey:@"WAPOS"];
                
                cell.maintenancePlanTextLabel.text =[[self.maintPlantsArray objectAtIndex:selectedIndexPath] objectForKey:@"WARPL"];
                
                cell.maintenanceItemTextLabel.text =[NSString stringWithFormat:@"%@",[[self.maintPlantsArray objectAtIndex:selectedIndexPath] objectForKey:@"WAPOS"]];
                
                cell.maintenanceItemText_textLabel.text =[NSString stringWithFormat:@"%@",[[self.maintPlantsArray objectAtIndex:selectedIndexPath] objectForKey:@"PSTXT"]];
                
                cell.maintenanceStrategyLabel.text =@"";
                
                cell.equipmentNoLabel.text = [NSString stringWithFormat:@"%@",[[self.maintPlantsArray objectAtIndex:selectedIndexPath] objectForKey:@"EQUNR"]];
                
                cell.equipmentTextLabel.text = [NSString stringWithFormat:@"%@",[[self.maintPlantsArray objectAtIndex:selectedIndexPath] objectForKey:@"EQUNR"]];
                
                cell.functLocationLabel.text =@"";
                
                cell.maintTypeLabel.text =[NSString stringWithFormat:@"%@",[[self.maintPlantsArray objectAtIndex:selectedIndexPath] objectForKey:@"EQUNR"]];
                cell.plantLabel.text =[NSString stringWithFormat:@"%@",[[self.maintPlantsArray objectAtIndex:selectedIndexPath] objectForKey:@"EQUNR"]];
                cell.workCenterLabel.text =[NSString stringWithFormat:@"%@",[[self.maintPlantsArray objectAtIndex:selectedIndexPath] objectForKey:@"ARBPL"]];
                
                if ([NullChecker isNull:[NSString stringWithFormat:@"%@",[[self.maintPlantsArray objectAtIndex:selectedIndexPath] objectForKey:@"QMNUM"]]]) {
                    
                    cell.notificationNumberLabel.text =@"";
                    
                }
                else{
                    
                    cell.notificationNumberLabel.text =[NSString stringWithFormat:@"%@",[[self.maintPlantsArray objectAtIndex:selectedIndexPath] objectForKey:@"QMNUM"]];
                }
                
                if ([NullChecker isNull:[NSString stringWithFormat:@"%@",[[self.maintPlantsArray objectAtIndex:selectedIndexPath] objectForKey:@"AUFNR"]]]) {
                    
                    cell.orderNoLabel.text =@"";
                    
                }
                else{
                    
                    cell.orderNoLabel.text =[NSString stringWithFormat:@"%@",[[self.maintPlantsArray objectAtIndex:selectedIndexPath] objectForKey:@"AUFNR"]];
                }
                
                
                cell.maintenanceItemTypeLabel.text =[NSString stringWithFormat:@"%@",[[self.maintPlantsArray objectAtIndex:selectedIndexPath] objectForKey:@"MITYP"]];
                
                
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"yyyy-MM-dd"];
                
                NSDate *requiredstartDate = [dateFormatter dateFromString:[NSString stringWithFormat:@"%@",[[self.maintPlantsArray objectAtIndex:selectedIndexPath] objectForKey:@"GSTRP"]]];
                
                NSDate *requiredDate = [dateFormatter dateFromString:[NSString stringWithFormat:@"%@",[[self.maintPlantsArray objectAtIndex:selectedIndexPath] objectForKey:@"ADDAT"]]];
                
                // Convert date object into desired format
                [dateFormatter setDateFormat:@"MMM dd, yyyy"];
                NSString *convertedrequiredStartDateString = [dateFormatter stringFromDate:requiredstartDate];
                
                NSString *convertedrequiDateString = [dateFormatter stringFromDate:requiredDate];
                
                
                if ([NullChecker isNull:convertedrequiredStartDateString]) {
                    convertedrequiredStartDateString = @"";
                }
                
                if ([NullChecker isNull:convertedrequiDateString]) {
                    convertedrequiDateString = @"";
                }
                
                cell.startDateTextLabel.text =convertedrequiredStartDateString;
                
                cell.requestDateLabel.text =convertedrequiDateString;
                
                
                cell.taskListTypeLabel.text =[NSString stringWithFormat:@"%@",[[self.maintPlantsArray objectAtIndex:selectedIndexPath] objectForKey:@"PLNTY"]];
                cell.plannerLabel.text =[NSString stringWithFormat:@"%@",[[self.maintPlantsArray objectAtIndex:selectedIndexPath] objectForKey:@"PLNNR"]];
                
                cell.taskListGroupLabel.text =[NSString stringWithFormat:@"%@",[[self.maintPlantsArray objectAtIndex:selectedIndexPath] objectForKey:@"PLNAL"]];
                
                cell.taskListTextLabel.text =@"";
                
                cell.locationNameLabel.text =[NSString stringWithFormat:@"%@",[[self.maintPlantsArray objectAtIndex:selectedIndexPath] objectForKey:@"STRNO"]];
                
                cell.equipmentShortTextLabel.text =[NSString stringWithFormat:@"%@",[[self.maintPlantsArray objectAtIndex:selectedIndexPath] objectForKey:@"EQKTX"]];
                
                cell.funcLocnDescriptionLabel.text =[NSString stringWithFormat:@"%@",[[self.maintPlantsArray objectAtIndex:selectedIndexPath] objectForKey:@"PLTXT"]];
            }
            else if (myMaintPlansTableView.tag == 1){
                
                cell.callNumberTextLabel.text = [[self.filteredArray objectAtIndex:selectedIndexPath] objectForKey:@"ABNUM"];
                
                cell.maintenancePlanTextLabel.text =[[self.filteredArray objectAtIndex:selectedIndexPath] objectForKey:@"WARPL"];
                cell.maintenanceItemTextLabel.text =[NSString stringWithFormat:@"%@",[[self.filteredArray objectAtIndex:selectedIndexPath] objectForKey:@"WAPOS"]];
                cell.maintenanceItemText_textLabel.text =[NSString stringWithFormat:@"%@",[[self.filteredArray objectAtIndex:selectedIndexPath] objectForKey:@"PSTXT"]];
                
                cell.maintenanceStrategyLabel.text =@"";
                
                cell.equipmentTextLabel.text = [[self.filteredArray objectAtIndex:selectedIndexPath] objectForKey:@"EQUNR"];
                
                cell.functLocationLabel.text =@"";
                cell.maintTypeLabel.text =@"";
                cell.plantLabel.text =[NSString stringWithFormat:@"%@",[[self.filteredArray objectAtIndex:selectedIndexPath] objectForKey:@"IWERK"]];
                
                cell.workCenterLabel.text =[NSString stringWithFormat:@"%@",[[self.filteredArray objectAtIndex:selectedIndexPath] objectForKey:@"ARBPL"]];
                cell.notificationNumberLabel.text =[NSString stringWithFormat:@"%@",[[self.filteredArray objectAtIndex:selectedIndexPath] objectForKey:@"QMNUM"]];
                
                cell.workCenterLabel.text =@"";
                
                cell.notificationNumberLabel.text =@"";
                cell.orderNoLabel.text =[NSString stringWithFormat:@"%@",[[self.filteredArray objectAtIndex:selectedIndexPath] objectForKey:@"LAUFN"]];
                
                cell.startDateTextLabel.text =[[self.filteredArray objectAtIndex:selectedIndexPath] objectForKey:@"Gstrp"];
                
                cell.maintenanceItemTypeLabel.text =[NSString stringWithFormat:@"%@",[[self.filteredArray objectAtIndex:selectedIndexPath] objectForKey:@"MITYP"]];
                
                cell.requestDateLabel.text =[NSString stringWithFormat:@"%@",[[self.filteredArray objectAtIndex:selectedIndexPath] objectForKey:@"ADDAT"]];
                cell.taskListTypeLabel.text =[NSString stringWithFormat:@"%@",[[self.filteredArray objectAtIndex:selectedIndexPath] objectForKey:@"PLNTY"]];
                cell.plannerLabel.text =[NSString stringWithFormat:@"%@",[[self.filteredArray objectAtIndex:selectedIndexPath] objectForKey:@"PLNNR"]];
                
                cell.taskListGroupLabel.text =[NSString stringWithFormat:@"%@",[[self.filteredArray objectAtIndex:selectedIndexPath] objectForKey:@"PLNAL"]];
                cell.taskListTextLabel.text =@"";
                cell.locationNameLabel.text =@"";
                cell.equipmentShortTextLabel.text =@"";
                
                cell.funcLocnDescriptionLabel.text = @"";
                
            }
            
        return  cell;
    }

    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == myMaintPlansTableView)
    {
        [detailPlantMaintainanceView setFrame:CGRectMake(0, 0, self.view.frame.size.height, self.view.frame.size.height)];
        [self.view addSubview:detailPlantMaintainanceView];
        selectedIndexPath = (int)indexPath.row;
        [detailPlantMainTableView reloadData];
    }
    else if (tableView == sortTableview){
        
        if ([[[[[structuredFilterSortedArray firstObject] objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectAtIndex:1] isEqualToString:@"X"])
        {
            [[[[[structuredFilterSortedArray firstObject]objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectAtIndex:1] isEqualToString:@""];
        }
        else{
            
            if(indexPath.row == 0){
                
                [[[[structuredFilterSortedArray firstObject] objectAtIndex:indexPath.section] objectAtIndex:1] replaceObjectAtIndex:1 withObject:@""];
            }
            else if (indexPath.row ==1){
                
                [[[[structuredFilterSortedArray firstObject] objectAtIndex:indexPath.section] objectAtIndex:0] replaceObjectAtIndex:1 withObject:@""];
            }
            
            [[[[structuredFilterSortedArray firstObject] objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] replaceObjectAtIndex:1 withObject:@"X"];
        }
        
        [sortTableview reloadData];
    }
}



#pragma mark-
#pragma mark- result data

-(void)resultData:(NSDictionary *)resultData withErrorDescription:(NSString *)errorDescription requestID:(WebServiceRequest)requestID :(int)statusCode
{
    switch (requestID) {
            
        case SEARCH_PLANTMAINT:
            
            if (statusCode == 401) {
                
                [MBProgressHUD hideHUDForView:self.view animated:YES];
 
                 [self showAlertMessageWithTitle:@"Authentication Failed!!" message:@"kindly check your password" cancelButtonTitle:@"Ok"];
 
                return;
            }
            
            if (!errorDescription.length) {
                
                NSMutableDictionary *parsedDictionary = [[Response sharedInstance] parseForMsonData:resultData];
                
                if (self.maintPlantsArray==nil) {
                    self.maintPlantsArray=[NSMutableArray new];
                }
                else{
                    [self.maintPlantsArray removeAllObjects];
                }
                
                if ([parsedDictionary count])
                {
                    [self.maintPlantsArray addObjectsFromArray:[parsedDictionary objectForKey:@"result"]];
                }
                
                myMaintPlansTableView.tag = 0;
                
                [myMaintPlansTableView reloadData];
                
                myMaintPlansTableView.hidden = NO;
                
                myMaintPlantLabel.text = [NSString stringWithFormat:@"Maintenance Plan (%i)",(int)self.maintPlantsArray.count];
            }
            else{
 
                 [self showAlertMessageWithTitle:@"Failure" message:errorDescription cancelButtonTitle:@"Ok"];
             }
            
            break;
            
        case INSPECTION_MPLAN:
            
            if (statusCode == 401) {
                
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                
                [self showAlertMessageWithTitle:@"Authentication Failed!!" message:@"kindly check your password" cancelButtonTitle:@"Ok"];
                
                return;
            }
            
            if (!errorDescription.length) {
                
                [MBProgressHUD hideHUDForView:self.view animated:YES];

                NSMutableDictionary *parsedDictionary = [[Response sharedInstance] parseForInspectionMsonData:resultData];
                
                if (self.maintPlantsArray==nil) {
                    self.maintPlantsArray=[NSMutableArray new];
                }
                else{
                    [self.maintPlantsArray removeAllObjects];
                }
                
                if ([parsedDictionary count])
                {
                    [self.maintPlantsArray addObjectsFromArray:[parsedDictionary objectForKey:@"result"]];
                }
                
                
                [myMaintPlansTableView reloadData];
                
                 myMaintPlantLabel.text = [NSString stringWithFormat:@"Maintenance Plan (%i)",(int)self.maintPlantsArray.count];
             }
            else{
                
               [self showAlertMessageWithTitle:@"Failure" message:errorDescription cancelButtonTitle:@"Ok"];
            }
            
            break;
 
        default:
            break;
    }
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];

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
