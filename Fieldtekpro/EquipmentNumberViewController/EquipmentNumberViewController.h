//
//  EquipmentNumberViewController.h
//  Fieldtekpro
//
//  Created by Enstrapp Bangalore on 15/12/17.
//  Copyright © 2017 Enstrapp Bangalore. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EquipmentNumberTableViewCell.h"
#import "DataBase.h"
#import "ConnectionManager.h"
#import "FunctionalLocation.h"
#import "popUpTableViewCell.h"
#import "MaintenacePlanViewController.h"
#import "EquipmentHistoryViewController.h"
#import "Response.h"
#import "CreateNotificationViewController.h"
#import "MeasureMentDocumentTableViewCell.h"
#import "MeasurementDocumentViewController.h"
#import "InspectionChecklistViewController.h"

@interface EquipmentNumberViewController : UIViewController
{
    IBOutlet UITableView *equipmentNumberTableView,*popUpTableView;
    
    NSMutableArray *locationIdArray,*popUpDataArray;
    
    FunctionalLocation *location;
    IBOutlet UIView *searchView;
    BOOL islevelEnabled;
    
    NSMutableArray *equipmentDetails,*maintPlantsArray;
    int count;
    
    NSUInteger selectedOperationIndex;
    
    NSString *equipmentId;
    
    BOOL isExpand;
    
    IBOutlet UIView *popUpView;
    
    IBOutlet  UILabel *equipmentHeaderlabel;
    
    IBOutlet UISearchBar *equipmentNumberSearch;
    
    
    Response *res_obj;
}
@property (nonatomic, retain) NSArray *filteredArray;

@property(nonatomic,strong) NSString *functionLocationString;

@property (nonatomic, retain) NSString *searchCondition;

@property (nonatomic,weak)id delegate;

@property (nonatomic, retain) IBOutlet UITableView *measurementDocTableView;

@property (nonatomic, retain) NSString *searchString;


@property (nonatomic, retain) NSMutableArray *dropDownArray,*measurementPointsArray,*equipmentHierarchyDetailsArrayLevel1,*equipmentHierarchyDetailsArrayLevel2,*equipmentHierarchyDetailsArrayLevel3,*equipmentHierarchyDetailsArrayLevel4,*equipmentHistoryDataArray,*mesurementDocumentArray,*selectedMeasureDocsCheckBoxArray,*inspectionCheckListDataArray,*functionLocationArray,*equipmentNumberHierarchyArray;

@end

