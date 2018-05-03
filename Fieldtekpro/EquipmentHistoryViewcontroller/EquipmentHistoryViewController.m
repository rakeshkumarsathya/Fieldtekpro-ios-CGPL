//
//  EquipmentHistoryViewController.m
//  Fieldtekpro
//
//  Created by Sathya Rakesh Kumar on 15/12/17.
//  Copyright © 2017 Enstrapp Bangalore. All rights reserved.
//

#import "EquipmentHistoryViewController.h"

@interface EquipmentHistoryViewController ()

@end

@implementation EquipmentHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    defaults = [NSUserDefaults standardUserDefaults];
    
    self.equipmentHistoryDataArray=[NSMutableArray new];
 
    NSString *str_UserNameDep = [defaults objectForKey:@"userName"];
    decryptedUserName = [[NSString alloc] initWithString:[str_UserNameDep AES128DecryptWithKey:@""]];
    
    
    if (self.equipmentNumberString.length)
    {
        [self monitorEquipHistoryDataforequipment:self.equipmentNumberString];
        
    }
    
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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



-(IBAction)backButtonClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)monitorEquipHistoryDataforequipment:(NSString *)equipmentId
{
    if ([[ConnectionManager defaultManager] isReachable]) {
        
        hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeIndeterminate;
        hud.label.text =@"loading...";
        
        NSMutableDictionary *equipmentHistoryDetailsHistory = [[NSMutableDictionary alloc]init];
        
        [equipmentHistoryDetailsHistory setObject:@"RD" forKey:@"ACTIVITY"];
        [equipmentHistoryDetailsHistory setObject:@"EH" forKey:@"DOCTYPE"];
        [equipmentHistoryDetailsHistory setObject:[defaults objectForKey:@"ENDPOINT"] forKey:@"ENDPOINT"];
        
        NSArray *endPointArray = [[DataBase sharedInstance] getEndPointURL:equipmentHistoryDetailsHistory];
        NSLog(@"endPoint :%@",[[endPointArray objectAtIndex:0] objectAtIndex:0]);
        [equipmentHistoryDetailsHistory setObject:[[endPointArray objectAtIndex:0] objectAtIndex:0] forKey:@"URL_ENDPOINT"];
        
        [equipmentHistoryDetailsHistory setObject:[equipmentId copy] forKey:@"EQUINR"];
        [equipmentHistoryDetailsHistory setObject:@"LOAD" forKey:@"TRANSMITTYPE"];
        [equipmentHistoryDetailsHistory setObject:[decryptedUserName copy] forKey:@"REPORTEDBY"];
        
        [Request makeWebServiceRequest:MONITOR_EQUIP_HISTORY parameters:equipmentHistoryDetailsHistory delegate:self];
        
    }
    else
    {
        
        [self showAlertMessageWithTitle:@"No Network Available" message:@"Please check your internet connection" cancelButtonTitle:@"Ok"];
        
    }
}

#pragma mark
#pragma mark - TableView Delegate Methods
//table view methods strats here

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;              // Default is 1 if not implemented
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView ==equipmentHistoryTableView)
    {
        return [self.equipmentHistoryDataArray  count];
        
    }
    
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == equipmentHistoryTableView)
    {
        
        return 220;
        
    }
    return 40;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView==equipmentHistoryTableView){
        
        static NSString *CellIdentifier = @"CustomCell";
        
        EquipmentHistoryTableViewCell   *cell =[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell==nil) {
            cell=[[EquipmentHistoryTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        
        cell.historyView.layer.cornerRadius = 2.0f;
        cell.historyView.layer.masksToBounds = YES;
        cell.historyView.layer.borderColor = [[UIColor darkGrayColor] CGColor];
        cell.historyView.layer.borderWidth = 1.0f;
        
        
        if ([NullChecker isNull:[NSString stringWithFormat:@"%@",[[self.equipmentHistoryDataArray  objectAtIndex:indexPath.row] objectAtIndex:10]]]) {
            cell.typeLabel.text = @"";
        }
        else{
            
            NSArray *notificationtextArray=[[DataBase sharedInstance] getNotificationTextforId:[[self.equipmentHistoryDataArray  objectAtIndex:indexPath.row] objectAtIndex:10]];
            
            cell.typeLabel.text = [NSString stringWithFormat:@"%@-%@",[[self.equipmentHistoryDataArray  objectAtIndex:indexPath.row] objectAtIndex:10],[[notificationtextArray objectAtIndex:0] firstObject]];
            
        }
        
        if ([NullChecker isNull:[NSString stringWithFormat:@"%@",[[self.equipmentHistoryDataArray  objectAtIndex:indexPath.row] objectAtIndex:14]]]) {
            cell.shortTextLabel.text = @"";
        }
        else{
            cell.shortTextLabel.text = [NSString stringWithFormat:@"%@",[[self.equipmentHistoryDataArray  objectAtIndex:indexPath.row] objectAtIndex:14]];
        }
        
        if ([NullChecker isNull:[NSString stringWithFormat:@"%@",[[self.equipmentHistoryDataArray  objectAtIndex:indexPath.row] objectAtIndex:13]]]) {
            cell.notificationNumberLabel.text = @"";
        }
        else{
            cell.notificationNumberLabel.text = [NSString stringWithFormat:@"%@",[[self.equipmentHistoryDataArray  objectAtIndex:indexPath.row] objectAtIndex:13]];
        }
        
        if ([NullChecker isNull:[NSString stringWithFormat:@"%@",[[self.equipmentHistoryDataArray  objectAtIndex:indexPath.row] objectAtIndex:9]]]) {
            cell.priorityLabel.text = @"";
        }
        else{
            
            NSArray *priorityTextArray=[[DataBase sharedInstance] getPriorityTextforId:[[self.equipmentHistoryDataArray  objectAtIndex:indexPath.row] objectAtIndex:9]];
            
            
            cell.priorityLabel.text = [NSString stringWithFormat:@"%@-%@",[[self.equipmentHistoryDataArray  objectAtIndex:indexPath.row] objectAtIndex:9],[[priorityTextArray objectAtIndex:0] firstObject]];
        }
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSDate *startDate = [dateFormatter dateFromString:[NSString stringWithFormat:@"%@",[[self.equipmentHistoryDataArray  objectAtIndex:indexPath.row] objectAtIndex:4]]];
        NSDate *endDate = [dateFormatter dateFromString:[NSString stringWithFormat:@"%@",[[self.equipmentHistoryDataArray  objectAtIndex:indexPath.row] objectAtIndex:3]]];
        // Convert date object into desired format
        [dateFormatter setDateFormat:@"MMM dd, yyyy"];
        NSString *convertedStartDateString = [dateFormatter stringFromDate:startDate];
        
        if ([NullChecker isNull:convertedStartDateString])
        {
            convertedStartDateString = @"";
        }
        cell.startDateLabel.text = [NSString stringWithFormat:@"%@",convertedStartDateString];
        
        NSString *convertedEndDateString = [dateFormatter stringFromDate:endDate];
        
        if ([NullChecker isNull:convertedEndDateString]) {
            convertedEndDateString = @"";
        }
        cell.endDateLabel.text = [NSString stringWithFormat:@"%@",convertedEndDateString];
        
        if ([NullChecker isNull:[NSString stringWithFormat:@"%@",[[self.equipmentHistoryDataArray  objectAtIndex:indexPath.row] objectAtIndex:20]]]) {
            cell.orderNoLabel.text =  @"";
        }
        else{
            cell.orderNoLabel.text = [NSString stringWithFormat:@"%@",[[self.equipmentHistoryDataArray  objectAtIndex:indexPath.row] objectAtIndex:20]];
        }
        
        if ([[[self.equipmentHistoryDataArray objectAtIndex:indexPath.row] objectAtIndex:8] isEqualToString:@"X"]) {
            
            [cell.breakdownCheck setImage:[UIImage imageNamed:@"checkbox_selected.png"]];
        }
        else{
            
            [cell.breakdownCheck setImage:[UIImage imageNamed:@"checkbox_unselected.png"]];
            
        }
        
        return cell;
    }
    
    return nil;
}

#pragma mark-
#pragma mark- result data

-(void)resultData:(NSDictionary *)resultData withErrorDescription:(NSString *)errorDescription requestID:(WebServiceRequest)requestID :(int)statusCode
{
    switch (requestID)
    {
        case MONITOR_EQUIP_HISTORY:
            
            if (!errorDescription.length) {
                
                NSMutableDictionary *parsedDictionary =  [[Response sharedInstance] parseForMonitorEquipmentHistory:resultData];
                
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                
                if ([parsedDictionary objectForKey:@"resultEquipmentHistory"]) {
                    
                    NSMutableArray *parsedArray=[NSMutableArray new];
                    
                    [parsedArray addObjectsFromArray:[parsedDictionary objectForKey:@"resultEquipmentHistory"]];
                    
                    if (self.equipmentHistoryDataArray==nil) {
                        
                        self.equipmentHistoryDataArray=[NSMutableArray new];
                    }
                    else{
                        [self.equipmentHistoryDataArray removeAllObjects];
                    }
                    
                    for (int i=0; i<[parsedArray count]; i++)
                    {
                        NSMutableArray *tempArray=[NSMutableArray new];
                        
                        [tempArray addObject:@""];
                        
                        if (![NullChecker isNull:[[parsedArray objectAtIndex:i] objectForKey:@"Arbpl"]])
                        {
                            [tempArray addObject:[NSString stringWithFormat:@"%@",[[parsedArray objectAtIndex:i] objectForKey:@"Arbpl"]]];//0vornr
                        }
                        else
                        {
                            [tempArray addObject:@""];//0vornr
                            
                        }
                        
                        
                        if (![NullChecker isNull:[[parsedArray objectAtIndex:i] objectForKey:@"Arbplwerk"]])
                        {
                            
                            [tempArray addObject:[NSString stringWithFormat:@"%@",[[parsedArray objectAtIndex:i] objectForKey:@"Arbplwerk"]]];
                            
                        }
                        else
                        {
                            [tempArray addObject:@""];
                            
                        }
                        
                        
                        if (![NullChecker isNull:[[parsedArray objectAtIndex:i] objectForKey:@"Ausbs"]])
                        {
                            [tempArray addObject:[NSString stringWithFormat:@"%@",[[parsedArray objectAtIndex:i] objectForKey:@"Ausbs"]]];
                        }
                        else
                        {
                            [tempArray addObject:@""];
                            
                        }
                        
                        if (![NullChecker isNull:[[parsedArray objectAtIndex:i] objectForKey:@"Ausvn"]])
                        {
                            [tempArray addObject:[NSString stringWithFormat:@"%@",[[parsedArray objectAtIndex:i] objectForKey:@"Ausvn"]]];
                        }
                        else
                        {
                            [tempArray addObject:@""];
                            
                        }
                        
                        if (![NullChecker isNull:[[parsedArray objectAtIndex:i] objectForKey:@"Equnr"]])
                        {
                            [tempArray addObject:[NSString stringWithFormat:@"%@",[[parsedArray objectAtIndex:i] objectForKey:@"Equnr"]]];
                        }
                        else
                        {
                            [tempArray addObject:@""];
                        }
                        
                        if (![NullChecker isNull:[[parsedArray objectAtIndex:i] objectForKey:@"Ingrp"]])
                        {
                            [tempArray addObject:[NSString stringWithFormat:@"%@",[[parsedArray objectAtIndex:i] objectForKey:@"Ingrp"]]];
                        }
                        else
                        {
                            [tempArray addObject:@""];
                        }
                        
                        if (![NullChecker isNull:[[parsedArray objectAtIndex:i] objectForKey:@"Iwerk"]])
                        {
                            [tempArray addObject:[NSString stringWithFormat:@"%@",[[parsedArray objectAtIndex:i] objectForKey:@"Iwerk"]]];
                        }
                        else
                        {
                            [tempArray addObject:@""];
                        }
                        
                        if (![NullChecker isNull:[[parsedArray objectAtIndex:i] objectForKey:@"Msaus"]])
                        {
                            [tempArray addObject:[NSString stringWithFormat:@"%@",[[parsedArray objectAtIndex:i] objectForKey:@"Msaus"]]];
                        }
                        else
                        {
                            [tempArray addObject:@""];
                            
                        }
                        
                        if (![NullChecker isNull:[[parsedArray objectAtIndex:i] objectForKey:@"Priok"]])
                        {
                            [tempArray addObject:[NSString stringWithFormat:@"%@",[[parsedArray objectAtIndex:i] objectForKey:@"Priok"]]];
                        }
                        else
                        {
                            [tempArray addObject:@""];
                            
                        }
                        
                        if (![NullChecker isNull:[[parsedArray objectAtIndex:i] objectForKey:@"Qmart"]])
                        {
                            [tempArray addObject:[NSString stringWithFormat:@"%@",[[parsedArray objectAtIndex:i] objectForKey:@"Qmart"]]];
                        }
                        else
                        {
                            [tempArray addObject:@""];
                            
                        }
                        
                        if (![NullChecker isNull:[[parsedArray objectAtIndex:i] objectForKey:@"Qmdab"]])
                        {
                            [tempArray addObject:[NSString stringWithFormat:@"%@",[[parsedArray objectAtIndex:i] objectForKey:@"Qmdab"]]];
                        }
                        else
                        {
                            [tempArray addObject:@""];
                            
                        }
                        
                        if (![NullChecker isNull:[[parsedArray objectAtIndex:i] objectForKey:@"Qmnam"]])
                        {
                            [tempArray addObject:[NSString stringWithFormat:@"%@",[[parsedArray objectAtIndex:i] objectForKey:@"Qmnam"]]];
                        }
                        else
                        {
                            [tempArray addObject:@""];
                            
                        }
                        
                        if (![NullChecker isNull:[[parsedArray objectAtIndex:i] objectForKey:@"Qmnum"]])
                        {
                            [tempArray addObject:[NSString stringWithFormat:@"%@",[[parsedArray objectAtIndex:i] objectForKey:@"Qmnum"]]];
                        }
                        else
                        {
                            [tempArray addObject:@""];
                            
                        }
                        
                        if (![NullChecker isNull:[[parsedArray objectAtIndex:i] objectForKey:@"Qmtxt"]])
                        {
                            [tempArray addObject:[NSString stringWithFormat:@"%@",[[parsedArray objectAtIndex:i] objectForKey:@"Qmtxt"]]];
                        }
                        else
                        {
                            [tempArray addObject:@""];
                            
                        }
                        
                        if (![NullChecker isNull:[[parsedArray objectAtIndex:i] objectForKey:@"Mdtxt"]])
                        {
                            [tempArray addObject:[NSString stringWithFormat:@"%@",[[parsedArray objectAtIndex:i] objectForKey:@"Mdtxt"]]];
                        }
                        else
                        {
                            [tempArray addObject:@""];
                            
                        }
                        
                        if (![NullChecker isNull:[[parsedArray objectAtIndex:i] objectForKey:@"Codct"]])
                        {
                            [tempArray addObject:[NSString stringWithFormat:@"%@",[[parsedArray objectAtIndex:i] objectForKey:@"Codct"]]];
                        }
                        else
                        {
                            [tempArray addObject:@""];
                            
                        }
                        
                        if (![NullChecker isNull:[[parsedArray objectAtIndex:i] objectForKey:@"Codgr"]])
                        {
                            [tempArray addObject:[NSString stringWithFormat:@"%@",[[parsedArray objectAtIndex:i] objectForKey:@"Codgr"]]];
                        }
                        else
                        {
                            [tempArray addObject:@""];
                            
                        }
                        
                        
                        if (![NullChecker isNull:[[parsedArray objectAtIndex:i] objectForKey:@"Vlcod"]])
                        {
                            [tempArray addObject:[NSString stringWithFormat:@"%@",[[parsedArray objectAtIndex:i] objectForKey:@"Vlcod"]]];
                        }
                        else
                        {
                            [tempArray addObject:@""];
                            
                        }
                        
                        if (![NullChecker isNull:[[parsedArray objectAtIndex:i] objectForKey:@"Tplnr"]])
                        {
                            [tempArray addObject:[NSString stringWithFormat:@"%@",[[parsedArray objectAtIndex:i] objectForKey:@"Tplnr"]]];
                        }
                        else
                        {
                            [tempArray addObject:@""];
                            
                        }
                        
                        if (![NullChecker isNull:[[parsedArray objectAtIndex:i] objectForKey:@"Aufnr"]])
                        {
                            [tempArray addObject:[NSString stringWithFormat:@"%@",[[parsedArray objectAtIndex:i] objectForKey:@"Aufnr"]]];
                        }
                        else
                        {
                            [tempArray addObject:@""];
                        }
                        
                        [self.equipmentHistoryDataArray addObject:tempArray];
                    }
                }
                
                else{
                    
                    [self showAlertMessageWithTitle:@"info" message:@"No Data Found" cancelButtonTitle:@"Ok"];
                    
                    if (self.equipmentHistoryDataArray==nil) {
                        
                        self.equipmentHistoryDataArray=[NSMutableArray new];
                    }
                    else{
                        [self.equipmentHistoryDataArray removeAllObjects];
                        
                    }
                }
                
                  equipmentHistoryHeaderLabel.text=[NSString stringWithFormat:@"Equipment History(%lu)",[self.equipmentHistoryDataArray count]];
                
                
                [equipmentHistoryTableView reloadData];
                
                break;
                
            }
            
        default: break;
            
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

