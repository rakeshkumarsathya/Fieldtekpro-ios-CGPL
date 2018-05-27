//
//  CreateJSAViewController.m
//  Fieldtekpro
//
//  Created by Sathya Rakesh Kumar on 26/05/18.
//  Copyright © 2018 Enstrapp Bangalore. All rights reserved.
//

#import "CreateJSAViewController.h"

@interface CreateJSAViewController ()<UITextFieldDelegate>

@end

@implementation CreateJSAViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
     [self customCreateSegmentController];
     [basicInfoview setFrame:CGRectMake(0, 0, subView.frame.size.width, subView.frame.size.height)];
     [subView addSubview:basicInfoview];
    
     jobStepArray=[NSMutableArray new];
     hazardsDataArray=[NSMutableArray new];
     impactsControlDataArray=[NSMutableArray new];
    
    commonAddtableview.tag=0;

    [commonListTableview registerNib:[UINib nibWithNibName:@"JobStepTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"jobStepTablecell"];
    
    [commonListTableview registerNib:[UINib nibWithNibName:@"HazardsTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"hazardTableviewcell"];

    [commonListTableview registerNib:[UINib nibWithNibName:@"ImpactControlsTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"impactTableviewcell"];
    
    [commonAddtableview registerNib:[UINib nibWithNibName:@"InputDropDownTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"InputDropDownCell"];
    
    


    
    [self loadJobStepData];
    [self loadHazardsData];
    [self loadImpactsData];
    
 
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

-(void)loadJobStepData{
    
    [jobStepArray addObject:[NSMutableArray arrayWithObjects:@"Step No.",@"",@"",@"", nil]];
    
    [jobStepArray addObject:[NSMutableArray arrayWithObjects:@"Job Step",@"Enter text",@"",@"", nil]];
    
    [jobStepArray addObject:[NSMutableArray arrayWithObjects:@"Person Responsoble",@"Enter text",@"",@"", nil]];

}

-(void)loadHazardsData{
    
     [hazardsDataArray addObject:[NSMutableArray arrayWithObjects:@"Job Step",@"Select Job Step",@"",@"", nil]];
    
    [hazardsDataArray addObject:[NSMutableArray arrayWithObjects:@"Hazard category",@" Select Hazard category",@"",@"", nil]];

    [hazardsDataArray addObject:[NSMutableArray arrayWithObjects:@"Hazard",@"Select Hazard",@"",@"", nil]];
 }

-(void)loadImpactsData{
    
    [impactsControlDataArray addObject:[NSMutableArray arrayWithObjects:@"Hazard",@"Select Hazard",@"",@"", nil]];
    
    [impactsControlDataArray addObject:[NSMutableArray arrayWithObjects:@"Impacts",@" Select Impacts",@"",@"", nil]];
    
    [impactsControlDataArray addObject:[NSMutableArray arrayWithObjects:@"Controls",@"Select Controls",@"",@"", nil]];
}

- (void)didSelectItemAtIndex:(NSInteger)index
{
    UIView *superview;
    
    if ((superview = [basicInfoview superview])) {
        [basicInfoview removeFromSuperview];
    }
    else if ((superview = [assessmentView superview])){
        
        [assessmentView removeFromSuperview];
    }
    
    else if ((superview = [jobLocationView superview])){
        
        [jobLocationView removeFromSuperview];
    }
    
    else if ((superview = [commonListView superview])){
        
        [commonListView removeFromSuperview];
    }
    
    switch (index)
    {
        case 0:
            
            [basicInfoview setFrame:CGRectMake(0, 0, subView.frame.size.width, subView.frame.size.height)];
            [subView addSubview:basicInfoview];

        break;
            
        case 1:
            
            [assessmentView setFrame:CGRectMake(0, 0, subView.frame.size.width, subView.frame.size.height)];
            [subView addSubview:assessmentView];

            break;
            
        case 2:
            
            [jobLocationView setFrame:CGRectMake(0, 0, subView.frame.size.width, subView.frame.size.height)];
            [subView addSubview:jobLocationView];
          
        break;
            
        case 3:
            
            commonListTableview.tag=0;
            commonAddtableview.tag=0;
            [commonListView setFrame:CGRectMake(0, 0, subView.frame.size.width, subView.frame.size.height)];
            [subView addSubview:commonListView];
            [commonListTableview reloadData];
            
        break;
         case 4:
            
            commonListTableview.tag=1;
            commonAddtableview.tag=1;
            [commonListView setFrame:CGRectMake(0, 0, subView.frame.size.width, subView.frame.size.height)];
            [subView addSubview:commonListView];
            [commonListTableview reloadData];
 
        break;
        case 5:
            
            commonListTableview.tag=2;
            commonAddtableview.tag=2;
              [commonListView setFrame:CGRectMake(0, 0, subView.frame.size.width, subView.frame.size.height)];
            [subView addSubview:commonListView];
            [commonListTableview reloadData];
         break;
            
        default:break;
    
      }
 }


-(void)customCreateSegmentController
{
     [segmentControl removeFromSuperview];
     segmentControl = [[YAScrollSegmentControl alloc] initWithFrame:CGRectMake(0,0, subView.frame.size.width, 30)];
    segmentControl.buttons = @[@"Basic Info", @"Assessment Team", @"Job Location",@"Job Step",@"Hazards",@"Impacts & Controls"];
     segmentControl.delegate = self;
    [segmentControl setFont:[UIFont fontWithName:@"Helvetica" size:14.0]];
    [segmentControl setTitleColor:[UIColor whiteColor]  forState:UIControlStateSelected];
    segmentControl.gradientColor =  [UIColor whiteColor]; // Purposely set strange gradient color to demonstrate the effect
    segmentControl.tintColor=[UIColor whiteColor];
    [segmentView addSubview:segmentControl];
 }

-(IBAction)commonAddClicked:(id)sender
{
    [commonAddview setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
     [self.view addSubview:commonAddview];
    [commonAddtableview reloadData];
    
}

-(IBAction)dsimissCommonClicked:(id)sender
{
     [commonAddview removeFromSuperview];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;              // Default is 1 if not implemented
{
    
    return 1;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (tableView == commonAddtableview)
    {
        if (commonAddtableview.tag==0) {
            
            return [jobStepArray count];
        }
        
        else if (commonAddtableview.tag==1){
            
            return [hazardsDataArray count];
        }
        else if (commonAddtableview.tag==2){
            
            return [impactsControlDataArray count];
         }
    }
    
    else if (tableView==commonListTableview){
        
        return 1;
    }
    
    return 1;;
}



-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == commonAddtableview)
    {
        
        static NSString *CellIdentifier = @"InputDropDownCell";
        
        InputDropDownTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
 
        if (cell==nil) {
            cell=[[InputDropDownTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
 
        cell.InputTextField.superview.tag = indexPath.row;
        cell.InputTextField.delegate = self;
        cell.dropDownImageView.hidden=NO;
        cell.InputTextField.userInteractionEnabled=YES;
 
        if (indexPath.row==0) {
            
            cell.InputTextField.userInteractionEnabled=NO;
        }
        
        cell.notifView.layer.cornerRadius = 2.0f;
        cell.notifView.layer.masksToBounds = YES;
        cell.notifView.layer.borderColor = [[UIColor darkGrayColor] CGColor];
        cell.notifView.layer.borderWidth = 1.0f;
        
        [cell.dropDownImageView setImage:[UIImage imageNamed:@"dropdown"]];
        
        if (indexPath.row==1)
        {
            cell.dropDownImageView.hidden=YES;
            
        }
        
        cell.madatoryLabel.hidden=NO;
        cell.longTextBtn.hidden=YES;
        cell.dropDownImageView.hidden=NO;
            
        if (commonAddtableview.tag==0) {
            
            cell.titleLabel.text=[[jobStepArray objectAtIndex:indexPath.row] objectAtIndex:0];
            cell.InputTextField.placeholder=[[jobStepArray objectAtIndex:indexPath.row] objectAtIndex:1];
            cell.InputTextField.text=[[jobStepArray objectAtIndex:indexPath.row] objectAtIndex:2];
        }
        else  if (commonAddtableview.tag==1) {
            
            cell.titleLabel.text=[[hazardsDataArray objectAtIndex:indexPath.row] objectAtIndex:0];
            cell.InputTextField.placeholder=[[hazardsDataArray objectAtIndex:indexPath.row] objectAtIndex:1];
            cell.InputTextField.text=[[hazardsDataArray objectAtIndex:indexPath.row] objectAtIndex:2];
        }
        
        else  if (commonAddtableview.tag==2) {
            
            cell.titleLabel.text=[[impactsControlDataArray objectAtIndex:indexPath.row] objectAtIndex:0];
            cell.InputTextField.placeholder=[[impactsControlDataArray objectAtIndex:indexPath.row] objectAtIndex:1];
            cell.InputTextField.text=[[impactsControlDataArray objectAtIndex:indexPath.row] objectAtIndex:2];
        }
 
        return cell;
    }
    
    else if (tableView==commonListTableview){
        
         if (commonListTableview.tag==0) {
            
            static NSString *CellIdentifier = @"jobStepTablecell";
            
            JobStepTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
 
            if (cell==nil) {
                cell=[[JobStepTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            
            cell.jobStepContentView.layer.cornerRadius = 2.0f;
            cell.jobStepContentView.layer.masksToBounds = YES;
            cell.jobStepContentView.layer.borderColor = [[UIColor darkGrayColor] CGColor];
            cell.jobStepContentView.layer.borderWidth = 1.0f;
            
            return cell;
        }
        
        else if (commonListTableview.tag==1){
            
            
            static NSString *CellIdentifier = @"hazardTableviewcell";
            
            HazardsTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if (cell==nil) {
                cell=[[HazardsTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            
            cell.hazardContentView.layer.cornerRadius = 2.0f;
            cell.hazardContentView.layer.masksToBounds = YES;
            cell.hazardContentView.layer.borderColor = [[UIColor darkGrayColor] CGColor];
            cell.hazardContentView.layer.borderWidth = 1.0f;
            
            return cell;
        }
        
        else if (commonListTableview.tag==2){
            
            
            static NSString *CellIdentifier = @"impactTableviewcell";
            
            ImpactControlsTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if (cell==nil) {
                cell=[[ImpactControlsTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            
            cell.impactContentView.layer.cornerRadius = 2.0f;
            cell.impactContentView.layer.masksToBounds = YES;
            cell.impactContentView.layer.borderColor = [[UIColor darkGrayColor] CGColor];
            cell.impactContentView.layer.borderWidth = 1.0f;
            
            return cell;
        }
    }
    
    return nil;
    
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
