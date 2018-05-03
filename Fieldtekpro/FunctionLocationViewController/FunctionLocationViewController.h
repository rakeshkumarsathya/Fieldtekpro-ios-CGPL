//
//  FunctionLocationViewController.h
//  Fieldtekpro
//
//  Created by Enstrapp Bangalore on 12/12/17.
//  Copyright © 2017 Enstrapp Bangalore. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataBase.h"
#import "ConnectionManager.h"
#import "FunctionalLocationTableViewCell.h"
#import "FunctionalLocation.h"
#import "EquipmentNumberViewController.h"
#import "Response.h"
#import "CreateNotificationViewController.h"
#import "CreateOrderViewController.h"
#import "InspectionChecklistViewController.h"
#import "EquipmentFncLocDetailsViewController.h"
 
@interface FunctionLocationViewController : UIViewController
{
    IBOutlet UITableView *functionalLocationTableView;
    
    IBOutlet UISearchBar *functionalLocationsearch;
     BOOL islevelEnabled;
    
    NSUInteger selectedInspectionIndex,funcLocTag,selectedDismissFlocIndex,selectedDropwnTag;

    IBOutlet UILabel *equipmentHistoryHeaderLabel,*funcLocnHeaderLabel;
     NSString *locationId;
     NSMutableArray *locationIdArray;
     IBOutlet UIView *searchView;
     int count;
}

@property (nonatomic, retain) NSString *data;
@property (nonatomic, retain) NSArray *filteredArray;
@property (nonatomic, retain) NSString *searchString;
@property (nonatomic,weak)id delegate;


@property (nonatomic, retain) NSMutableArray *dropDownArray,*measurementPointsArray,*equipmentHierarchyDetailsArrayLevel1,*equipmentHierarchyDetailsArrayLevel2,*equipmentHierarchyDetailsArrayLevel3,*equipmentHierarchyDetailsArrayLevel4,*equipmentHistoryDataArray,*mesurementDocumentArray,*selectedMeasureDocsCheckBoxArray,*inspectionCheckListDataArray,*functionLocationArray,*functionLocationHierarchyArray;


@end
