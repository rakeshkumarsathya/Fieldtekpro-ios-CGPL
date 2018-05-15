//
//  InspectionChecklistViewController.m
//  Fieldtekpro
//
//  Created by Sathya Rakesh Kumar on 10/03/18.
//  Copyright © 2018 Enstrapp Bangalore. All rights reserved.
//

#import "InspectionChecklistViewController.h"

@interface InspectionChecklistViewController ()

@end

@implementation InspectionChecklistViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setRightView:funcLocnTextfield withImage:@"dropdown"];
    [self setRightView:equipmentTextfield withImage:@"dropdown"];
 
    imagesArray=[NSMutableArray new];
 
    collectionViewVc.layer.borderColor=[[UIColor grayColor]CGColor];
    collectionViewVc.layer.borderWidth=2;
    
    collectionViewVc.hidden=YES;
    
    [self loadFunctionsModule];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
 
}
 
-(void)loadFunctionsModule{
        
    [imagesArray addObject:[NSArray arrayWithObjects:@"monitor_notification",@"Notification", nil]];
    [imagesArray addObject:[NSArray arrayWithObjects:@"monitor_orders",@"Orders", nil]];
    [imagesArray addObject:[NSArray arrayWithObjects:@"monitor_statistics",@"Statistics", nil]];
    [imagesArray addObject:[NSArray arrayWithObjects:@"monitor_time",@"History", nil]];
    [imagesArray addObject:[NSArray arrayWithObjects:@"monitor_mesuredoc",@"Inspection Checklist", nil]];
        
}

    
-(void)setRightView:(UITextField *)textField withImage:(NSString *)imageview
{
        arrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",imageview]]];
        arrow.frame = CGRectMake(0.0, 0.0, arrow.image.size.width+10.0, arrow.image.size.height);
        arrow.contentMode = UIViewContentModeCenter;
        
        textField.rightView = arrow;
        textField.rightViewMode = UITextFieldViewModeAlways;
}

- (IBAction)backButtonClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)functionLocnClicked:(id)sender{
    
    FunctionLocationViewController *funcVc = [self.storyboard instantiateViewControllerWithIdentifier:@"FunctionLocationView"];
    
    funcVc.searchString=@"";
    
    funcVc.delegate=self;
    
    [self showViewController:funcVc sender:self];
}

-(IBAction)equipmentClicked:(id)sender{
 
    EquipmentNumberViewController *equipVc = [self.storyboard instantiateViewControllerWithIdentifier:@"EquipIdentifier"];
    
    if (funcLocnTextfield.text.length) {
        
        equipVc.functionLocationString=funcLocnTextfield.text;
    }
     equipVc.searchString=@"X";
     equipVc.delegate=self;
     [self showViewController:equipVc sender:self];
    
  }

 -(void)dismissToCheckListView
{
     res_obj=[Response sharedInstance];
    
    if ([res_obj.functionLocationArray count])
    {
        if ([[res_obj.functionLocationArray objectAtIndex:0] objectForKey:@"locationid"])
        {
            funcLocnTextfield.text=[[res_obj.functionLocationArray objectAtIndex:0] objectForKey:@"locationid"];
        }
     }
    
     equipmentTextfield.text=@"";
     [self.navigationController popViewControllerAnimated:YES];
  }

-(void)dismissNumberView
{
    res_obj=[Response sharedInstance];

    if (res_obj.idString) {
        
        equipmentTextfield.text=[res_obj.idString copy];
        
        equipmentid=[res_obj.idString copy];
        
        equipmentNumberdetailsArray=[NSMutableArray new];
        
         [equipmentNumberdetailsArray addObject:res_obj.idString];
        
        [equipmentNumberdetailsArray addObject:res_obj.nameString];
        
        [equipmentNumberdetailsArray addObject:res_obj.ingrpString];

        [equipmentNumberdetailsArray addObject:res_obj.workcenterString];

        [equipmentNumberdetailsArray addObject:res_obj.plantIdString];

        [equipmentNumberdetailsArray addObject:res_obj.iwerkString];
        
        [equipmentNumberdetailsArray addObject:res_obj.catalogProfileIdstring];
        
         funcLocnTextfield.text=res_obj.equipFunLocString;

 
//            NSArray *tempArray=[[DataBase sharedInstance] fetchNotificationLocationName:res_obj.equipFunLocString];
//
//            functionalLocationID =res_obj.equipFunLocString;
//
//              if ([tempArray count]) {
//
//                funcLocnTextfield.text=[[tempArray objectAtIndex:0] objectForKey:@"locationName"];
//
//               }
 
            collectionViewVc.hidden=NO;

      }
    
    [self.navigationController popViewControllerAnimated:YES];
}

 
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
     return [imagesArray count];
        
}
 
    // The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
    {
        static NSString *identifier = @"Cell";
        
        CollectionViewCell *cell = (CollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
 
        cell.imageView.image=[UIImage imageNamed:[[imagesArray objectAtIndex:indexPath.row] objectAtIndex:0]];
        cell.textLabel.text=[[imagesArray objectAtIndex:indexPath.row] objectAtIndex:1];
        
        return cell;
    }

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[[imagesArray objectAtIndex:indexPath.row] objectAtIndex:1] isEqualToString:@"Maintenance Plan"]) {
        
        MaintenacePlanViewController *maintenanceVc = [self.storyboard instantiateViewControllerWithIdentifier:@"MaintPlanView"];
        
        if (equipmentid.length) {
            maintenanceVc.equipmentNumberString = equipmentid;
        }
        
        [self showViewController:maintenanceVc sender:self];
    }
    
    else if ([[[imagesArray objectAtIndex:indexPath.row] objectAtIndex:1] isEqualToString:@"History"])
    {
        EquipmentHistoryViewController *equipNumVc = [self.storyboard instantiateViewControllerWithIdentifier:@"EquipmentHistoryId"];
        
        if (equipmentid.length)
        {
            equipNumVc.equipmentNumberString = equipmentid;
        }
        
        [self showViewController:equipNumVc sender:self];
    }
    
    else if ([[[imagesArray objectAtIndex:indexPath.row] objectAtIndex:1] isEqualToString:@"Inspection Checklist"]){
        
        MeasurementDocumentViewController *measVc = [self.storyboard instantiateViewControllerWithIdentifier:@"MeasDocVC"];
        
        if (equipmentid.length) {
            measVc.equipmentId = equipmentid;
        }
        
        [self showViewController:measVc sender:self];
     }
    
    else if ([[[imagesArray objectAtIndex:indexPath.row] objectAtIndex:1] isEqualToString:@"Notification"]){
        
        CreateNotificationViewController *createVc = [self.storyboard instantiateViewControllerWithIdentifier:@"CreateNotifIdentifier"];
        
        createVc.inspectionEquipmentArray=[equipmentNumberdetailsArray copy];
        createVc.checkListFuncLocidString=funcLocnTextfield.text;
 
        [self showViewController:createVc sender:self];
    }
    
    else if ([[[imagesArray objectAtIndex:indexPath.row] objectAtIndex:1] isEqualToString:@"Orders"]){
        
         MyOrdersViewController *createVc = [self.storyboard instantiateViewControllerWithIdentifier:@"myOrdersVC"];
 
        if (equipmentid.length) {
            createVc.inspectionEquipmentId=equipmentid;
        }
        
         [self showViewController:createVc sender:self];
        
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
