//
//  EquipmentNumberViewController.m
//  Fieldtekpro
//
//  Created by Enstrapp Bangalore on 15/12/17.
//  Copyright © 2017 Enstrapp Bangalore. All rights reserved.
//

#import "EquipmentNumberViewController.h"
#define UIColorFromRGB(r, g, b)  [UIColor colorWithRed:((r) / 255.0) green:((g) / 255.0) blue:((b) / 255.0) alpha:1.0]

@interface EquipmentNumberViewController ()

@end

@implementation EquipmentNumberViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    count=0;
    
    locationIdArray=[NSMutableArray new];
    equipmentDetails=[NSMutableArray new];
    
    popUpDataArray=[NSMutableArray new];
    
    res_obj=[Response sharedInstance];
    
    [equipmentNumberTableView setTableHeaderView:searchView];
    
    islevelEnabled=NO;
    
    // Get the instance of the UITextField of the search bar
    UITextField *searchField = [equipmentNumberSearch valueForKey:@"_searchField"];
    // Change search bar text color
    searchField.textColor = [UIColor blueColor];
    
    // Change the search bar placeholder text color
    [searchField setValue:[UIColor blueColor] forKeyPath:@"_placeholderLabel.textColor"];
    
    [popUpDataArray addObject:[NSArray arrayWithObjects:@"monitor_notification",@"Notification", nil]];
    [popUpDataArray addObject:[NSArray arrayWithObjects:@"monitor_orders",@"Orders", nil]];
    [popUpDataArray addObject:[NSArray arrayWithObjects:@"monitor_statistics",@"Statistics", nil]];
    [popUpDataArray addObject:[NSArray arrayWithObjects:@"monitor_time",@"History", nil]];
    [popUpDataArray addObject:[NSArray arrayWithObjects:@"monitor_mesuredoc",@"Inspection Checklist", nil]];
    //    [popUpDataArray addObject:[NSArray arrayWithObjects:@"Maintenance-Plan",@"Maintenance Plan", nil]];
    //    [popUpDataArray addObject:[NSArray arrayWithObjects:@"Notification",@"Maps", nil]];
    
    [equipmentNumberTableView registerNib:[UINib nibWithNibName:@"EquipmentNumberTableViewCell-iPhone" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"Cell"];
    
    [equipmentNumberTableView setTableHeaderView:searchView];
    
    if (self.functionLocationString.length)
    {
        [self fetchequipmentsfor:self.functionLocationString];
    }
    
    else{
        
        [self fetchequipmentsfor:self.functionLocationString];
        
    }
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)backButtonClicked:(id)sender
{
    if (count==0)
    {
        [self.navigationController popViewControllerAnimated:YES];
        
    }
    else
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
            
            if (self.equipmentNumberHierarchyArray == nil) {
                self.equipmentNumberHierarchyArray = [NSMutableArray new];
            }
            else{
                
                [self.equipmentNumberHierarchyArray removeAllObjects];
            }
            
            [self.equipmentNumberHierarchyArray addObjectsFromArray:[[DataBase sharedInstance] getFunctionLocations:inputParameters]];
            
            equipmentHeaderlabel.text = [NSString stringWithFormat:@"Equipment Number (%lu)",(unsigned long)[self.equipmentNumberHierarchyArray count]];
            
        }
        else
        {
            
            NSMutableDictionary *inputParameters = [NSMutableDictionary new];
            
            [inputParameters setObject:[locationIdArray objectAtIndex:count-1] forKey:@"functionLocationHID"];
            
            [locationIdArray removeObjectAtIndex:[locationIdArray count]-1];
            
            [self.equipmentNumberHierarchyArray addObjectsFromArray:[[DataBase sharedInstance] getFunctionLocations:inputParameters]];
            
            equipmentHeaderlabel.text = [NSString stringWithFormat:@"Equipment Number (%lu)",(unsigned long)[self.equipmentNumberHierarchyArray count]];
            
        }
        
        count=count-1;
        
        [equipmentNumberTableView reloadData];
    }
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    
    if ([searchText isEqualToString:@""]) {
        
    }
    else{
        
        NSPredicate *bPredicate = [NSPredicate predicateWithFormat:@"equipmentID contains[c] %@ OR equipmentHID contains[c] %@ OR equipmentName contains[c] %@ OR plantName contains[c] %@ OR workStation contains[c] %@",searchText,searchText,searchText,searchText,searchText];
        
        if (self.filteredArray == nil) {
            self.filteredArray = [[NSArray alloc]init];
        }
        
        islevelEnabled=YES;
        
        self.filteredArray = [self.equipmentNumberHierarchyArray filteredArrayUsingPredicate:bPredicate];
        
    }
    
    
    [equipmentNumberTableView reloadData];
}

-(void)fetchequipmentsfor:(NSString *)functionalLocationID{
    
    if (self.equipmentNumberHierarchyArray == nil) {
        self.equipmentNumberHierarchyArray = [NSMutableArray new];
    }
    else{
        [self.equipmentNumberHierarchyArray removeAllObjects];
    }
    
    if (!functionalLocationID.length) {
        
        [self.equipmentNumberHierarchyArray addObjectsFromArray:[[DataBase sharedInstance] getEquipments:nil]];
        
    }
    else{
        
        NSMutableDictionary *fetchRequest = [NSMutableDictionary new];
        
        [fetchRequest setObject:functionalLocationID forKey:@"locationID"];
        
        [self.equipmentNumberHierarchyArray addObjectsFromArray:[[DataBase sharedInstance] getEquipments:fetchRequest]];
        
    }
    
    equipmentHeaderlabel.text = [NSString stringWithFormat:@"Equipment Number (%lu)",(unsigned long)[self.equipmentNumberHierarchyArray count]];
    
    
    if (![self.equipmentNumberHierarchyArray count]) {
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Information" message:@"No Equipments Available" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        
        [alert show];
        
        return;
    }
    else{
        
        [equipmentNumberTableView reloadData];
        
    }
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;              // Default is 1 if not implemented
{
    
    return 1;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (tableView == equipmentNumberTableView)
    {
        if (!islevelEnabled)
        {
            return [self.equipmentNumberHierarchyArray count];
        }
        
        else{
            
            return [self.filteredArray count];
        }
    }
    else if (tableView==popUpTableView){
        
        return [popUpDataArray count];
        
    }
    
    return 1;;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == equipmentNumberTableView)
    {
        if (isExpand){
            
            if (indexPath.row==selectedOperationIndex)
            {
                return 210;
            }
            else
            {
                return 89;
            }
        }
        else
        {
            return 89;
        }
    }
 
    return 40;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == equipmentNumberTableView)
    {
        static NSString *CellIdentifier = @"Cell";
        
        EquipmentNumberTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell==nil) {
            cell=[[EquipmentNumberTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            
        }
        cell.accessoryType = UITableViewCellAccessoryNone;
        
        cell.menuBtn.hidden=NO;
        
        if ([self.searchCondition isEqualToString:@"X"]) {
            
            cell.menuBtn.hidden=YES;
        }
        
        if (!islevelEnabled) {
            
            if ([[[self.equipmentNumberHierarchyArray objectAtIndex:indexPath.row] objectForKey:@"sequip"] isEqualToString:@"X"]) {
                
                cell.equipmentNumberLabel.textColor = [UIColor redColor];
                
                cell.equipContentView.layer.cornerRadius = 2.0f;
                cell.equipContentView.layer.masksToBounds = YES;
                cell.equipContentView.layer.borderColor = [[UIColor redColor] CGColor];
                cell.equipContentView.layer.borderWidth = 1.0f;
                
                cell.equipmentHDetailButton.hidden = NO;
                [cell.equipmentHDetailButton addTarget:self action:@selector(equipmentHDetailButtonClicked:) forControlEvents:UIControlEventTouchDown];
            }
            else
            {
                cell.equipmentHDetailButton.hidden = YES;
                
                cell.equipContentView.layer.cornerRadius = 2.0f;
                cell.equipContentView.layer.masksToBounds = YES;
                cell.equipContentView.layer.borderColor = [[UIColor grayColor] CGColor];
                cell.equipContentView.layer.borderWidth = 1.0f;
                
                cell.equipmentNumberLabel.textColor = [UIColor blackColor];
            }
            
            cell.equipmentNumberLabel.text = [[self.equipmentNumberHierarchyArray objectAtIndex:indexPath.row] objectForKey:@"equipmentID"];
            cell.equipmentDescriptionLabel.text = [[self.equipmentNumberHierarchyArray objectAtIndex:indexPath.row] objectForKey:@"equipmentName"];
            
            cell.tplnrLabel.text = [[self.equipmentNumberHierarchyArray objectAtIndex:indexPath.row] objectForKey:@"tplnr"];
            
            cell.equartlabel.text = [[self.equipmentNumberHierarchyArray objectAtIndex:indexPath.row] objectForKey:@"eqart"];

        }
        else{
            
            if ([[[self.filteredArray objectAtIndex:indexPath.row] objectForKey:@"sequip"] isEqualToString:@"X"]) {
                
                cell.equipmentNumberLabel.textColor = [UIColor redColor];
                
                cell.equipContentView.layer.borderColor = [UIColor redColor].CGColor;
                cell.equipContentView.layer.cornerRadius = 8.0f;
                cell.equipContentView.layer.borderWidth = 3.0f;
                cell.equipmentHDetailButton.hidden = NO;
                [cell.equipmentHDetailButton addTarget:self action:@selector(equipmentHDetailButtonClicked:) forControlEvents:UIControlEventTouchDown];
            }
            else
            {
                cell.equipmentHDetailButton.hidden = YES;
                
                cell.equipContentView.layer.cornerRadius = 2.0f;
                cell.equipContentView.layer.masksToBounds = YES;
                cell.equipContentView.layer.borderColor = [[UIColor grayColor] CGColor];
                cell.equipContentView.layer.borderWidth = 1.0f;
                
                cell.equipmentNumberLabel.textColor = [UIColor blackColor];
            }
            
            cell.equipmentNumberLabel.text = [[self.filteredArray objectAtIndex:indexPath.row] objectForKey:@"equipmentID"];
            cell.equipmentDescriptionLabel.text = [[self.filteredArray objectAtIndex:indexPath.row] objectForKey:@"equipmentName"];
            
            cell.tplnrLabel.text = [[self.filteredArray objectAtIndex:indexPath.row] objectForKey:@"tplnr"];
 
            cell.equartlabel.text = [[self.filteredArray objectAtIndex:indexPath.row] objectForKey:@"eqart"];

            
            
        }
        
        return cell;
    }
    else if (tableView==popUpTableView){
        
        static NSString *CellIdentifier = @"CustomCell";
        
        popUpTableViewCell   *cell =[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell==nil) {
            cell=[[popUpTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        cell.popupTitleLabel.text=[[popUpDataArray objectAtIndex:indexPath.row] objectAtIndex:1];
        
        cell.popupImageView.image=[UIImage imageNamed:[[popUpDataArray objectAtIndex:indexPath.row] objectAtIndex:0]];
        
        return cell;
        
    }
    
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==popUpTableView)
    {
        if ([[[popUpDataArray objectAtIndex:indexPath.row] objectAtIndex:1] isEqualToString:@"Maintenance Plan"]) {
            
            MaintenacePlanViewController *maintenanceVc = [self.storyboard instantiateViewControllerWithIdentifier:@"MaintPlanView"];
            
            if (equipmentId.length) {
                maintenanceVc.equipmentNumberString = equipmentId;
            }
            
            [self showViewController:maintenanceVc sender:self];
        }
        
        else if ([[[popUpDataArray objectAtIndex:indexPath.row] objectAtIndex:1] isEqualToString:@"History"])
        {
            EquipmentHistoryViewController *equipNumVc = [self.storyboard instantiateViewControllerWithIdentifier:@"EquipmentHistoryId"];
            
            if (equipmentId.length) {
                equipNumVc.equipmentNumberString = equipmentId;
            }
            
            [self showViewController:equipNumVc sender:self];
        }
        
        else if ([[[popUpDataArray objectAtIndex:indexPath.row] objectAtIndex:1] isEqualToString:@"Inspection Checklist"]){
            
            MeasurementDocumentViewController *measVc = [self.storyboard instantiateViewControllerWithIdentifier:@"MeasDocVC"];
            
            if (equipmentId.length) {
                measVc.equipmentId = equipmentId;
            }
            
            [self showViewController:measVc sender:self];
            
        }
        
    }
    else if (tableView==equipmentNumberTableView)
    {
        if (islevelEnabled) {
            
            res_obj.idString=[[self.filteredArray objectAtIndex:indexPath.row] objectForKey:@"equipmentID"];
            
            res_obj.nameString=[[self.filteredArray objectAtIndex:indexPath.row] objectForKey:@"equipmentName"];
            
            res_obj.ingrpString=[[self.filteredArray objectAtIndex:indexPath.row] objectForKey:@"ingrp"];
            
            res_obj.workcenterString=[[self.filteredArray objectAtIndex:indexPath.row] objectForKey:@"workStation"];
            
            res_obj.plantIdString=[[self.filteredArray objectAtIndex:indexPath.row] objectForKey:@"plantName"];
            
            res_obj.iwerkString=[[self.filteredArray objectAtIndex:indexPath.row] objectForKey:@"iwerks"];
            
            res_obj.catalogProfileIdstring=[[self.filteredArray objectAtIndex:indexPath.row] objectForKey:@"catalogProfileID"];
            
            res_obj.equipFunLocString=[[self.filteredArray objectAtIndex:indexPath.row] objectForKey:@"tplnr"];
            
        }
        
        else{
            
            res_obj.idString=[[self.equipmentNumberHierarchyArray objectAtIndex:indexPath.row] objectForKey:@"equipmentID"];
            
            res_obj.nameString=[[self.equipmentNumberHierarchyArray objectAtIndex:indexPath.row] objectForKey:@"equipmentName"];
            
            res_obj.ingrpString=[[self.equipmentNumberHierarchyArray objectAtIndex:indexPath.row] objectForKey:@"ingrp"];
            
            res_obj.workcenterString=[[self.equipmentNumberHierarchyArray objectAtIndex:indexPath.row] objectForKey:@"workStation"];
            
            res_obj.plantIdString=[[self.equipmentNumberHierarchyArray objectAtIndex:indexPath.row] objectForKey:@"plantName"];
            
            res_obj.iwerkString=[[self.equipmentNumberHierarchyArray objectAtIndex:indexPath.row] objectForKey:@"iwerks"];
            
            res_obj.catalogProfileIdstring=[[self.equipmentNumberHierarchyArray objectAtIndex:indexPath.row] objectForKey:@"catalogProfileID"];
            
            res_obj.equipFunLocString=[[self.equipmentNumberHierarchyArray objectAtIndex:indexPath.row] objectForKey:@"tplnr"];

        }
        
        
        if ([self.searchString isEqualToString:@"X"]){
            
            if ([(InspectionChecklistViewController *)self.delegate respondsToSelector:@selector(dismissNumberView)]) {
                
                [(InspectionChecklistViewController *)self.delegate dismissNumberView];
             }
        }
        if ([self.searchString isEqualToString:@"Y"]){
            
            if ([(CreateOrderViewController *)self.delegate respondsToSelector:@selector(dismissequipmentNumberView)]) {
                
                 [(CreateOrderViewController *)self.delegate dismissequipmentNumberView];
            }
        }
        else{
            
            if ([(CreateNotificationViewController *)self.delegate respondsToSelector:@selector(dismissequipmentNumberView)]) {
                
                [(CreateNotificationViewController *)self.delegate dismissequipmentNumberView];
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

-(void)equipmentHDetailButtonClicked:(id)sender
{
    NSIndexPath *ip = [self GetCellFromTableView:equipmentNumberTableView Sender:sender];
    
    NSMutableDictionary *inputParameters = [NSMutableDictionary new];
    
    [equipmentNumberTableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
    
    [inputParameters setObject:[[self.equipmentNumberHierarchyArray objectAtIndex:ip.row] objectForKey:@"equipmentID"] forKey:@"equipmentHID"];
    
    if (!islevelEnabled) {
        
        if (self.equipmentNumberHierarchyArray == nil) {
            self.equipmentNumberHierarchyArray = [NSMutableArray new];
        }
        else{
            
            [self.equipmentNumberHierarchyArray removeAllObjects];
        }
        
        islevelEnabled=NO;
        
        [self.equipmentNumberHierarchyArray addObjectsFromArray:[[DataBase sharedInstance] getEquipments:inputParameters]];
    }
    else{
        
        [inputParameters setObject:[[self.filteredArray objectAtIndex:ip.row] objectForKey:@"equipmentID"] forKey:@"equipmentHID"];
        
        self.filteredArray=[[DataBase sharedInstance] getEquipments:inputParameters];
        
    }
    
    [equipmentNumberTableView reloadData];
}

-(void)menuButtonClicked:(UIButton *)button
{
    if (!isExpand) {
        
        CGPoint location = [button.superview convertPoint:button.center toView:equipmentNumberTableView];
        NSIndexPath *indexPath = [equipmentNumberTableView indexPathForRowAtPoint:location];
        // [self doSomethingWithRowAtIndexPath:indexPath];
        selectedOperationIndex=indexPath.row;
        isExpand=YES;
        [popUpView setFrame:CGRectMake(equipmentNumberTableView.frame.size.width-240, 20, equipmentNumberTableView.frame.size.width, 210)];
        [button.superview addSubview:popUpView];
        if (!islevelEnabled) {
            
            equipmentId=[[self.equipmentNumberHierarchyArray objectAtIndex:indexPath.row] objectForKey:@"equipmentID"];
            
        }
        else{
            
            equipmentId=[[self.filteredArray objectAtIndex:indexPath.row] objectForKey:@"equipmentID"];
        }
        
    }
    else{
        
        isExpand=NO;
        [popUpView removeFromSuperview];
    }
    
    [equipmentNumberTableView reloadData];
}

-(void)equipmentDetailButtonClicked:(id)sender
{
    NSIndexPath *ip = [self GetCellFromTableView:equipmentNumberTableView Sender:sender];
    
    [equipmentDetails removeAllObjects];
    
    NSString *workStation = @"";
    NSString *plantName = @"";
    
    //    currentEquipment = [self.dropDownArray objectAtIndex:ip.row];
    
    if ([[self.filteredArray objectAtIndex:ip.row] objectForKey:@"workStation"]) {
        
        workStation = [[self.filteredArray objectAtIndex:ip.row] objectForKey:@"workStation"];
    }
    
    if([[self.filteredArray objectAtIndex:ip.row] objectForKey:@"plantName"]){
        
        plantName = [[self.filteredArray objectAtIndex:ip.row] objectForKey:@"plantName"];
    }
    
    NSArray *functionalLocation = [[DataBase sharedInstance] getFuncLocForEquipID:[[self.filteredArray objectAtIndex:ip.row] objectForKey:@"equipmentID"]];
    
    if ([functionalLocation count])
    {
        
        location = [functionalLocation objectAtIndex:0];
        [equipmentDetails addObject:[NSArray arrayWithObjects:[[self.filteredArray objectAtIndex:ip.row] objectForKey:@"equipmentID"],[[self.filteredArray objectAtIndex:ip.row] objectForKey:@"equipmentName"],location,workStation,plantName,[[self.filteredArray objectAtIndex:ip.row] objectForKey:@"catalogProfileID"], nil]];
    }
    else{
        
        [equipmentDetails addObject:[NSArray arrayWithObjects:[[self.filteredArray objectAtIndex:ip.row] objectForKey:@"equipmentID"],[[self.filteredArray objectAtIndex:ip.row] objectForKey:@"equipmentName"],@"",workStation,plantName,[[self.filteredArray objectAtIndex:ip.row] objectForKey:@"catalogProfileID"], nil]];
    }
    
    [equipmentNumberTableView reloadData];
}

-(void)checkBoxMeasureDocsClicked:(id)sender{
    
    NSIndexPath *ip = [self GetCellFromTableView:self.measurementDocTableView Sender:sender];
    NSInteger i = ip.row;
    
    UIButton *tappedButton = (UIButton*)sender;
    
    if([tappedButton.currentImage isEqual:[UIImage imageNamed:@"checkbox_unselected.png"]]) {
        [sender  setImage:[UIImage imageNamed: @"checkbox_selected.png"] forState:UIControlStateNormal];
        // [[self.mesurementDocumentArray objectAtIndex:i] replaceObjectAtIndex:22 withObject:@"X"];
        [self.selectedMeasureDocsCheckBoxArray addObject:[NSNumber numberWithInteger:i]];
        
    }
    else
    {
        [sender setImage:[UIImage imageNamed:@"checkbox_unselected.png"]forState:UIControlStateNormal];
        // [[self.mesurementDocumentArray objectAtIndex:i] replaceObjectAtIndex:22 withObject:@""];
        [self.selectedMeasureDocsCheckBoxArray removeObject:[NSNumber numberWithInteger:i]];
        
    }
}


//-(void)createdTaskClicked:(id)sender{
//
//    NSIndexPath *ip = [self GetCellFromTableView:inspectionCheckListTableView Sender:sender];
//    NSInteger i = ip.row;
//
//    if(![[[self.inspectionCheckListDataArray objectAtIndex:i] objectForKey:@"task"] isEqualToString:@"X"])  {
//
//        NSMutableDictionary *tempInspectionDictionary = [NSMutableDictionary new];
//
//        [tempInspectionDictionary addEntriesFromDictionary:[self.inspectionCheckListDataArray objectAtIndex:i]];
//
//        NSMutableDictionary *tempDictionary=[NSMutableDictionary new];
//
//        [tempDictionary setObject:@"X" forKey:@"task"];
//
//        [tempInspectionDictionary addEntriesFromDictionary:tempDictionary];
//
//        [self.inspectionCheckListDataArray replaceObjectAtIndex:i withObject:tempInspectionDictionary];
//
//    }
//    else
//    {
//        NSMutableDictionary *tempInspectionDictionary = [NSMutableDictionary new];
//
//        [tempInspectionDictionary addEntriesFromDictionary:[self.inspectionCheckListDataArray objectAtIndex:i]];
//
//        NSMutableDictionary *tempDictionary=[NSMutableDictionary new];
//
//        [tempDictionary setObject:@"" forKey:@"task"];
//
//        [tempInspectionDictionary addEntriesFromDictionary:tempDictionary];
//
//        [self.inspectionCheckListDataArray replaceObjectAtIndex:i withObject:tempInspectionDictionary];
//
//    }
//
//    [inspectionCheckListTableView reloadData];
//}
//
//-(void)normalBtnClicked:(id)sender{
//
//    NSIndexPath *ip = [self GetCellFromTableView:inspectionCheckListTableView Sender:sender];
//
//    NSInteger i = ip.row;
//
//    if(![[[self.inspectionCheckListDataArray objectAtIndex:i] objectForKey:@"normal"] isEqualToString:@"X"]) {
//
//        NSMutableDictionary *tempInspectionDictionary = [NSMutableDictionary new];
//
//        [tempInspectionDictionary addEntriesFromDictionary:[self.inspectionCheckListDataArray objectAtIndex:i]];
//
//        NSMutableDictionary *tempDictionary=[NSMutableDictionary new];
//
//        [tempDictionary setObject:@"" forKey:@"critical"];
//        [tempDictionary setObject:@"X" forKey:@"normal"];
//        [tempDictionary setObject:@"" forKey:@"alarm"];
//
//        [tempInspectionDictionary addEntriesFromDictionary:tempDictionary];
//
//        [self.inspectionCheckListDataArray replaceObjectAtIndex:i withObject:tempInspectionDictionary];
//    }
//
//    [inspectionCheckListTableView reloadData];
//
//}
//
//-(void)alarmBtnClicked:(id)sender{
//
//    NSIndexPath *ip = [self GetCellFromTableView:inspectionCheckListTableView Sender:sender];
//
//    NSInteger i = ip.row;
//
//    if(![[[self.inspectionCheckListDataArray objectAtIndex:i] objectForKey:@"alarm"] isEqualToString:@"X"]) {
//
//        NSMutableDictionary *tempInspectionDictionary = [NSMutableDictionary new];
//
//        [tempInspectionDictionary addEntriesFromDictionary:[self.inspectionCheckListDataArray objectAtIndex:i]];
//
//        NSMutableDictionary *tempDictionary=[NSMutableDictionary new];
//
//        [tempDictionary setObject:@"" forKey:@"critical"];
//        [tempDictionary setObject:@"" forKey:@"normal"];
//        [tempDictionary setObject:@"X" forKey:@"alarm"];
//
//        [tempInspectionDictionary addEntriesFromDictionary:tempDictionary];
//
//        [self.inspectionCheckListDataArray replaceObjectAtIndex:i withObject:tempInspectionDictionary];
//
//    }
//
//    [inspectionCheckListTableView reloadData];
//}
//
//-(void)criticalBtnClicked:(id)sender{
//
//    NSIndexPath *ip = [self GetCellFromTableView:inspectionCheckListTableView Sender:sender];
//
//    NSInteger i = ip.row;
//
//    if(![[[self.inspectionCheckListDataArray objectAtIndex:i] objectForKey:@"critical"] isEqualToString:@"X"]) {
//
//        NSMutableDictionary *tempInspectionDictionary = [NSMutableDictionary new];
//
//        [tempInspectionDictionary addEntriesFromDictionary:[self.inspectionCheckListDataArray objectAtIndex:i]];
//
//        NSMutableDictionary *tempDictionary=[NSMutableDictionary new];
//
//        [tempDictionary setObject:@"X" forKey:@"critical"];
//        [tempDictionary setObject:@"" forKey:@"normal"];
//        [tempDictionary setObject:@"" forKey:@"alarm"];
//
//        [tempInspectionDictionary addEntriesFromDictionary:tempDictionary];
//
//        [self.inspectionCheckListDataArray replaceObjectAtIndex:i withObject:tempInspectionDictionary];
//    }
//
//    [inspectionCheckListTableView reloadData];
//}


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end

