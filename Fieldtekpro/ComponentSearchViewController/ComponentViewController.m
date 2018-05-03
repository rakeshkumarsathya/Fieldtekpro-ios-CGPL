//
//  ComponentViewController.m
//  Fieldtekpro
//
//  Created by Enstrapp Bangalore on 11/01/18.
//  Copyright © 2018 Enstrapp Bangalore. All rights reserved.
//

#import "ComponentViewController.h"

@interface ComponentViewController ()

@end

@implementation ComponentViewController
@synthesize defaults;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    defaults=[NSUserDefaults standardUserDefaults];
    res_obj=[Response sharedInstance];
    

    [componentsListTableView registerNib:[UINib nibWithNibName:@"DetailBomTableviewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"detailBomCell"];
    
    [componentsListTableView registerNib:[UINib nibWithNibName:@"ComponentTableViewCell-iPhone" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"Cell"];
    
 
    NSString *str_UserNameDep = [defaults objectForKey:@"userName"];
     decryptedUserName = [str_UserNameDep AES128DecryptWithKey:@""];
    
 
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    
    self.componentsListArray=[NSMutableArray new];

    if (self.equipmentIdString.length)
    {
        [self fetchDataFromLDB_BomLookup_EtComponents];
        [self f4HelpListOfComponents];
     }
    
    isCompSelected=NO;

}

-(IBAction)backButtonClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)componentValueChanged:(id)sender{
    
    componentSegmentControl = (UISegmentedControl *)sender;
    
    int clickedSegment=(int)[componentSegmentControl selectedSegmentIndex];
    
    switch (clickedSegment)
    {
        case 0:
 
            componentsListTableView.tag=0;
 
        break;
            
        case 1:
            
            componentsListTableView.tag=1;


        break;
        
        default:break;
    }
    
    [componentsListTableView reloadData];
    
}

-(void)showAlertMessageWithTitle:(NSString*)title message:(NSString*)message cancelButtonTitle:(NSString *)cancelBtnTitle withactionType:(NSString *)actionString forMethod:(NSString *)methodNameString
{
    
    
    
    UIAlertController * alert=[UIAlertController alertControllerWithTitle:title
                                                                  message:message
                                                           preferredStyle:UIAlertControllerStyleAlert];
    
    if ([actionString isEqualToString:@"Multiple"]) {
        
        
        UIAlertAction* yesButton = [UIAlertAction actionWithTitle:@"Yes"
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action)
                                    {
                                        if ([methodNameString isEqualToString:@"Attachments"]) {
                                            
                                            
                                        }
                                        
 
                                        // call method whatever u need
                                    }];
        
        UIAlertAction* noButton = [UIAlertAction actionWithTitle:cancelBtnTitle
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * action)
                                   {
                                       
                                       
                                   }];
        
        [alert addAction:noButton];
        [alert addAction:yesButton];
        
        [self presentViewController:alert animated:YES completion:nil];
    }
    
    else{
        
        UIAlertAction* okButton = [UIAlertAction actionWithTitle:cancelBtnTitle
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * action)
                                   {
                                       
                                       [alert dismissViewControllerAnimated:YES completion:nil];
                                       
                                       if ([methodNameString isEqualToString:@"Notif Success"]) {
                                           
                                           [self.navigationController popViewControllerAnimated:YES];
                                           
                                       }
                                       
                                       
                                   }];
        
        [alert addAction:okButton];
        
        [self presentViewController:alert animated:YES completion:nil];
        
    }
}


#pragma mark-
#pragma mark- Fetching From LDB

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
 
    [actions setObject:self.equipmentIdString forKey:@"BOM"];
        
     [self.bomDetailListArray addObjectsFromArray:[[DataBase sharedInstance] getBOMForSearchDescription:actions]];
    
 
    if (![self.bomDetailListArray count]) {
        
        hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDAnimationFade;
        hud.label.text = @"Fetching Bom Items...";
        
         [self performSelectorOnMainThread:@selector(getBOMItemsFromBom) withObject:nil waitUntilDone:YES];
    }
    else{
        // bomValueString
        
       [componentSegmentControl setTitle:[NSString stringWithFormat:@"%@(%lu)",@"Bom",(unsigned long)[self.bomDetailListArray count]] forSegmentAtIndex:0];
        
        [componentsListTableView scrollRectToVisible:CGRectMake(0, 0, 0, 0) animated:YES];
        componentsListTableView.tag=0;
        [componentsListTableView reloadData];
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
    [dataDictionary setObject:self.equipmentIdString forKey:@"EQUIPNO"];
    [dataDictionary setObject:@"LOAD" forKey:@"TRANSMITTYPE"];
    [Request makeWebServiceRequest:GET_LIST_OF_PM_BOMS parameters:dataDictionary delegate:self];
    
}

-(void)f4HelpListOfComponents{
    
    if (!self.equipmentIdString.length) {
        
        [self showAlertMessageWithTitle:@"Information" message:@"Please select or scan equipment number" cancelButtonTitle:@"OK" withactionType:@"Single" forMethod:nil];
     }
    else{
        
        // componentSearch.text = @"";
        
        [self.componentsListArray removeAllObjects];
        
        [self.componentsListArray addObjectsFromArray:[[DataBase sharedInstance] getComponentForMaterialId:self.plantIDString]];
        
         if (![self.componentsListArray count]) {
             
             NSMutableDictionary *searcDictionary=[NSMutableDictionary new];
             
             [searcDictionary setObject:self.plantIDString forKey:@"PlantID"];
            
            [self.componentsListArray addObjectsFromArray:[[DataBase sharedInstance] getStockDataForSearchDescription:searcDictionary]];
            
            if (![self.componentsListArray count]) {
                
              [componentSegmentControl setTitle:[NSString stringWithFormat:@"%@(%lu)",@"General",(unsigned long)[self.componentsListArray count]] forSegmentAtIndex:1];
                
             //   [self showAlertMessageWithTitle:@"Information" message:@"No Components are Available" cancelButtonTitle:@"OK" withactionType:@"Single" forMethod:nil];
                
            }
            else{
 
                [componentSegmentControl setTitle:[NSString stringWithFormat:@"%@(%lu)",@"General",(unsigned long)[self.componentsListArray count]] forSegmentAtIndex:1];
               
            }
        }
        else{
            
 
            [self showAlertMessageWithTitle:@"Information" message:@"No Data Found" cancelButtonTitle:@"OK" withactionType:@"Single" forMethod:nil];
            
        }
    }
}




-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (tableView == componentsListTableView) {
        
        if (componentsListTableView.tag==0) {
            
            return [self.bomDetailListArray count];
        }
        else if (componentsListTableView.tag==1){
            
            return [self.componentsListArray count];

        }
      }
    
    return 1;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.accessoryType=UITableViewCellAccessoryNone;
    
 
    if (tableView == componentsListTableView)
    {
 
        if (componentsListTableView.tag == 0) {
            
            static NSString *CellIdentifier = @"detailBomCell";
            
            BOMOverViewTableViewCell *bomCell =[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if (bomCell==nil) {
                
                bomCell=[[BOMOverViewTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            
            bomCell.selectionStyle = UITableViewCellSelectionStyleNone;
 
            if (!isLevelEnabled) {
                
                [bomCell.EquipmentBOMButton addTarget:self action:@selector(detailCheckBoxSelected:) forControlEvents:UIControlEventTouchDown];
 
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
            
            else{
 
                [bomCell.equipmentComponentButton setTitle:[NSString stringWithFormat:@"%@",[[self.filteredArray objectAtIndex:indexPath.row] objectForKey:@"bomcomponent"]] forState:UIControlStateNormal];
                
                if ([[[self.filteredArray objectAtIndex:indexPath.row] objectForKey:@"stlkz"] isEqualToString:@"X"]) {
                    
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
                
                bomCell.componentLabel.text = [NSString stringWithFormat:@"%@",[[self.filteredArray objectAtIndex:indexPath.row] objectForKey:@"bomcomponent"]];
                bomCell.componentTextLabel.text = [NSString stringWithFormat:@"%@",[[self.filteredArray objectAtIndex:indexPath.row] objectForKey:@"comptext"]];
                bomCell.quantityLabel.text = [NSString stringWithFormat:@"%@",[[self.filteredArray objectAtIndex:indexPath.row] objectForKey:@"quantity"]];
                bomCell.unitLabel.text = [NSString stringWithFormat:@"%@",[[self.filteredArray objectAtIndex:indexPath.row] objectForKey:@"unit"]];
                
               }
 
               return bomCell;
           }
        else if (componentsListTableView.tag == 1) {
 
            static NSString *CellIdentifier = @"Cell";
            
            ComponentTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if (cell==nil) {
                cell=[[ComponentTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            
            cell.accessoryType = UITableViewCellAccessoryNone;
            
            if (indexPath.row % 2 == 0)
            {
                cell.backgroundColor =UIColorFromRGB(249, 249, 249);
                
            }
            else {
                cell.backgroundColor =[UIColor whiteColor];
            }
            
            cell.materialIdLabel.text= [NSString stringWithFormat:@"%@ / %@",[[self.componentsListArray objectAtIndex:indexPath.row] objectForKey:@"matnr"],[[self.componentsListArray objectAtIndex:indexPath.row] objectForKey:@"maktx"]];
            
             cell.plantLabel.text= [NSString stringWithFormat:@"%@ / %@",[[self.componentsListArray objectAtIndex:indexPath.row] objectForKey:@"werks"],[[self.componentsListArray objectAtIndex:indexPath.row] objectForKey:@"lgort"]];
            
            return cell;

         }
        else{
            
            
            static NSString *CellIdentifier = @"Cell";
            
            ComponentTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if (cell==nil) {
                cell=[[ComponentTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            
            cell.accessoryType = UITableViewCellAccessoryNone;
            
            if (indexPath.row % 2 == 0)
            {
                cell.backgroundColor =UIColorFromRGB(249, 249, 249);
                
            }
            else {
                cell.backgroundColor =[UIColor whiteColor];
            }
            materialDetail = [self.componentsListArray objectAtIndex:indexPath.row];
            
            cell.materialIdLabel.text= [NSString stringWithFormat:@"%@ / %@",materialDetail.matnr,materialDetail.maktx];
            cell.plantLabel.text= [NSString stringWithFormat:@"%@ / %@",materialDetail.werks,materialDetail.lgort];
            
            return cell;
            
        }
        
    }
 
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==componentsListTableView)
    {
        NSMutableArray *tempArray=[NSMutableArray new];

        if (componentsListTableView.tag==1) {
            
            [tempArray addObject:[self.componentsListArray objectAtIndex:indexPath.row]];

        }
        else
        {
            [tempArray addObject:[self.bomDetailListArray objectAtIndex:indexPath.row]];

          }
 
        res_obj.materialsSearchListArray=[tempArray copy];
 
        if ([(CreateOrderViewController *)self.delegate respondsToSelector:@selector(dismissComponentsSearchView)]) {
            
            [(CreateOrderViewController *)self.delegate dismissComponentsSearchView];
        }
     }
 }

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==componentsListTableView) {
        
        if (componentsListTableView.tag==0) {
            
            return 121;
        }
        
        else if (componentsListTableView.tag==1){
            
            return 78;

        }
     }
    
    return 40;
}

#pragma mark- result data

-(void)resultData:(NSDictionary *)resultData withErrorDescription:(NSString *)errorDescription requestID:(WebServiceRequest)requestID :(int)statusCode
{
    switch (requestID) {
            
 
        case GET_LIST_OF_PM_BOMS:
            
            if (statusCode == 401) {
                
                componentsListTableView.tag=0;
                [componentsListTableView reloadData];
                
                [MBProgressHUD hideHUDForView:self.view animated:YES];
 
                [self showAlertMessageWithTitle:@"Authentication Failed!!" message:@"kindly check your password" cancelButtonTitle:@"Ok" withactionType:@"Single" forMethod:nil];
                
                
                return;
            }
            
            if (!errorDescription.length) {
 
                if ([resultData count])
                {
                        AppDelegate *tempDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                        [tempDelegate.coreDataControlObject removeContextForEquipmentBOM:@""];
                }
                
           NSMutableDictionary *tempDictionary=[[Response sharedInstance] parseForListOfPMBOMSItemData:resultData];
                
                if (!isCompSelected) {
                    
                    if ([tempDictionary count]) {
                        
                        [self fetchDataFromLDB_BomLookup_EtComponents];
                    }
                    else{
                        
                        [componentSegmentControl setTitle:[NSString stringWithFormat:@"%@(%lu)",@"Bom",(unsigned long)[self.bomDetailListArray count]] forSegmentAtIndex:0];
                        
                        [componentsListTableView scrollRectToVisible:CGRectMake(0, 0, 0, 0) animated:YES];
                        
                        [componentsListTableView reloadData];
                        
                          [self showAlertMessageWithTitle:@"Info" message:@"No suitable data found for the selected criteria!" cancelButtonTitle:@"Ok" withactionType:@"Single" forMethod:nil];
                        
                    }
                }
                
                else{
                    
                    if ([resultData count]) {
                        
                        [[DataBase sharedInstance] deleteSqliteFile_BomLookup_ETComponents:bomSearchBar.text];
                        
                        NSMutableDictionary *parsedDictionary = [[Response sharedInstance] parseForListOfPMBOMS:resultData];
                        
                        [MBProgressHUD hideHUDForView:self.view animated:YES];
                        
                        if ([parsedDictionary objectForKey:@"ERROR"])
                        {
                            
                            [self showAlertMessageWithTitle:@"" message:[parsedDictionary objectForKey:@"ERROR"] cancelButtonTitle:@"Ok" withactionType:@"Single" forMethod:nil];
                        }
                    }
                    
                    else{
                        
                        [self showAlertMessageWithTitle:@"Info" message:@"No suitable data found for the selected criteria!" cancelButtonTitle:@"Ok" withactionType:@"Single" forMethod:nil];
                    }
                  }
 
                  [MBProgressHUD hideHUDForView:self.view animated:YES];
             }
            
            else{
                
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
