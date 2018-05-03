//
//  Response.h
//  PMCockpit
//
//  Created by Shyam Chandar on 14/03/15.
//  Copyright (c) 2015 Enstrapp IT Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Request.h"
#import "DataBase.h"
#import "NullChecker.h"

@interface Response : NSObject

+ (id)sharedInstance;
+ (void)clearSharedInstance;

+ (NSString *)actionWithWebServiceResponse:(WebServiceRequest)requestId;

- (NSMutableDictionary *)parseForLogin:(NSDictionary *)resultDictionary;
- (NSMutableDictionary *)parseForSyncMapData:(NSDictionary *)resultDictionary;

- (NSMutableDictionary *)parseForLoadSettings:(NSDictionary *)resultDictionary;
- (NSMutableDictionary *)parseForValueHelps:(NSDictionary *)resultDictionary;

- (NSMutableDictionary *)parseForActivityType:(NSDictionary *)resultDictionary;
- (NSMutableDictionary *)parseForAppSettings:(NSDictionary *)resultDictionary;
- (NSMutableDictionary *)parseForNFCSettings:(NSDictionary *)resultDictionary;
- (NSMutableDictionary *)parseForNotifTypes:(NSDictionary *)resultDictionary;
- (NSMutableDictionary *)parseForOrderTypes:(NSDictionary *)resultDictionary;
- (NSMutableDictionary *)parseForNotifPriorityTypes:(NSDictionary *)resultDictionary;
- (NSMutableDictionary *)parseForOrderPriorityTypes:(NSDictionary *)resultDictionary;
- (NSMutableDictionary *)parseForGetUnits:(NSDictionary *)resultDictionary;
- (NSMutableDictionary *)parseForCostCenterList:(NSDictionary *)resultDictionary;
- (NSMutableDictionary *)parseForAccIndicator:(NSDictionary *)resultDictionary;
- (NSMutableDictionary *)parseForUserData:(NSDictionary *)resultDictionary;
- (NSMutableDictionary *)parseForUserFunction:(NSDictionary *)resultDictionary;
- (NSMutableDictionary *)parseForFuncLocCostCenter:(NSDictionary *)resultDictionary;
- (NSMutableDictionary *)parseForFuncLocFromEquipment:(NSDictionary *)resultDictionary;
- (NSMutableDictionary *)parseForEquipCostCenter:(NSDictionary *)resultDictionary;
- (NSMutableDictionary *)parseForEquipFromFuncLoc:(NSDictionary *)resultDictionary;
- (NSMutableDictionary *)parseForSearchFunclocEquipments:(NSDictionary *)resultDictionary;
- (NSMutableDictionary *)parseForListOfComponents:(NSDictionary *)resultDictionary;
- (NSMutableDictionary *)parseForALLNotifTypes:(NSDictionary *)resultDictionary;
- (NSMutableDictionary *)parseForListOFMovementTypes:(NSDictionary *)resultDictionary;
- (NSMutableDictionary *)parseForListOfPermits:(NSDictionary *)resultDictionary;

- (NSMutableDictionary *)parseForGetNotificationNoDetails:(NSDictionary *)resultDictionary;

- (NSMutableDictionary *)parseForCreateNotificationOrder:(NSDictionary *)resultDictionary;
- (NSMutableDictionary *)parseForCreateNotification:(NSDictionary *)resultDictionary;
//- (NSMutableDictionary *)parseForListOfNotification:(NSDictionary *)resultDictionary;
//- (NSMutableDictionary *)parseForListOfOpenNotification:(NSDictionary *)resultDictionary;
- (NSMutableDictionary *)parseForListOfDueNotification:(NSDictionary *)resultDictionary;
- (NSMutableDictionary *)parseForChangeNotification:(NSDictionary *)resultDictionary;
- (NSMutableDictionary *)parseForCancelNotification:(NSDictionary *)resultDictionary;
- (NSMutableDictionary *)parseForReleaseNotification:(NSDictionary *)resultDictionary;
- (NSMutableDictionary *)parseForCompleteNotification:(NSDictionary *)resultDictionary;

- (NSMutableDictionary *)parseForGetOrderDetails:(NSDictionary *)resultDictionary;
- (NSMutableDictionary *)parseForCreateOrder:(NSDictionary *)resultDictionary;
//- (NSMutableDictionary *)parseForListOfOrders:(NSDictionary *)resultDictionary;

- (NSMutableDictionary *)parseForListOfDueOrders:(NSDictionary *)resultDictionary;
- (NSMutableDictionary *)parseForChangeOrder:(NSDictionary *)resultDictionary;
- (NSMutableDictionary *)parseForCancelOrder:(NSDictionary *)resultDictionary;
- (NSMutableDictionary *)parseForConfirmOrder:(NSDictionary *)resultDictionary;
- (NSMutableDictionary *)parseForReleaseOrder:(NSDictionary *)resultDictionary;
- (NSMutableDictionary *)parseForColletctiveConfirmOrder:(NSDictionary *)resultDictionary;

- (NSMutableDictionary *)parseForListOfPMBOMS:(NSDictionary *)resultDictionary;
- (NSMutableDictionary *)parseForUtilityReserve:(NSMutableDictionary *)resultDictionary;

- (NSMutableDictionary *)parseForStockOverView:(NSDictionary *)resultDictionary;
- (NSMutableDictionary *)parseForLogData:(NSDictionary *)resultDictionary;

- (NSMutableDictionary *)parseForMaterialCheckAvailability:(NSDictionary *)resultDictionary;
- (NSMutableDictionary *)parseForListOfPlants:(NSDictionary *)resultDictionary;
- (NSMutableDictionary *)parseForListOfStorageLocation:(NSDictionary *)resultDictionary;
- (NSMutableDictionary *)parseForListOfWorkCenter:(NSDictionary *)resultDictionary;

-(NSMutableDictionary *)parseForCustomFields:(NSDictionary *)resultDictionary;
- (NSMutableDictionary *)parseForConfirmReason:(NSDictionary *)resultDictionary;
-(NSMutableDictionary *)parseForGetDocuments:(NSDictionary *)resultDictionary;

- (NSMutableDictionary *)parseForAuthData:(NSDictionary *)resultDictionary;
-(NSMutableDictionary *)parseForSettingsData:(NSDictionary *)resultDictionary;

//Maint Plan
-(NSMutableDictionary *)parseForMsonData:(NSDictionary *)resultDictionary;
-(NSMutableDictionary *)parseForInspectionMsonData:(NSDictionary *)resultDictionary;

-(NSMutableDictionary *)parseForDeviceToken:(NSDictionary *)resultDictionary;


//WSM Master Data
- (NSMutableDictionary *)parseForWSMMasterData:(NSDictionary *)resultDictionary;

- (NSMutableDictionary *)parseForBreakDownData:(NSDictionary *)resultDictionary;
- (NSMutableDictionary *)parseForNotificationData:(NSDictionary *)resultDictionary;
- (NSMutableDictionary *)parseForEquipmentBreakdownData:(NSDictionary *)resultDictionary;

-(NSMutableDictionary *)parseForGetMchklist:(NSDictionary *)resultDictionary;
-(NSMutableDictionary *)parseForSetMchklist:(NSDictionary *)resultDictionary;

- (NSMutableDictionary *)parseForPermitData:(NSDictionary *)resultDictionary;
- (NSMutableDictionary *)parseForAvailabilityData:(NSDictionary *)resultDictionary;
- (NSMutableDictionary *)parseForMonitorEquipmentHistory:(NSDictionary *)resultDictionary;
- (NSMutableDictionary *)parseForMonitorMeasurementDocs:(NSDictionary *)resultDictionary;
-(NSMutableDictionary *)parseForSetMonitorMeasurementDocs:(NSDictionary *)resultDictionary;

- (NSMutableDictionary *)parseForOrderData:(NSDictionary *)resultDictionary;
 - (NSMutableDictionary *)parseForgetTokenId:(NSDictionary *)resultDictionary;

- (NSMutableDictionary *)parseForWCMValueHelps:(NSDictionary *)resultDictionary;
- (NSMutableDictionary *)parseForJSAValueHelps:(NSDictionary *)resultDictionary;



@property (nonatomic, retain) NSString *idString,*nameString,*ingrpString,*workcenterString,*plantIdString,*iwerkString,*catalogProfileIdstring,*applicationTypeString,*applicationObjArt,*equipFunLocString,*longTextString;

@property (nonatomic) int selectedIndex;

@property (nonatomic, strong) NSUserDefaults *defaults;
@property (nonatomic, retain)  NSArray *myArray,*permitTextArray,*permitSecondTextArray,*notifHeaderArray,*notifTypeArray,*functionLocationArray,*materialsSearchListArray;
@property (nonatomic, retain) NSDictionary *misDictionary;

- (NSMutableDictionary *)parseForMeasurementDocs:(NSDictionary *)resultDictionary;

@end


