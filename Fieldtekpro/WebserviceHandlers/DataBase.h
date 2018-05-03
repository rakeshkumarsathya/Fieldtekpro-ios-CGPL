//  DataBase.h
//  DataBase
//
//  Created by Deepak Gantala on 09/10/13.
//  Copyright (c) 2013 Enstrapp IT Solutions . All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "ModelClass.h"
 #import "Request.h"
#import "Response.h"

@interface DataBase  : NSObject
{
    NSString *databaseFilePath;
    sqlite3 *dataBase;
    sqlite3_stmt *query_stment;
    NSOutputStream *dataToFileStream;
    NSDateFormatter *logEntryFormatter;
    NSMutableDictionary *objectHeaderID;
}

@property(nonatomic)int imagecaputreTag;
+ (id)sharedInstance;
- (NSString *)deviceUUID;
- (BOOL)connectDatabase;
- (BOOL)closeDatabase;
- (BOOL)checkDatabaseFileAvailablity;
- (BOOL)set_query:(NSString *)queryString;
- (NSMutableArray *)run_Queries_WITHDATA;
- (NSMutableArray *)run_Queries_WITHDICTIONARY;
- (BOOL)run_Queries_NODATA;
- (NSMutableArray *)run_Queries_WITHDATA_singleArray;
- (NSString*)createUniqueIdfortable:(NSString*)tblname;

#pragma mark-
#pragma mark - Insert Methods

- (NSArray *)getOnlyDistinctEquipments:(NSDictionary *)distinctRecords;

-(BOOL)insertSyncMapData:(NSMutableArray *)syncMapData :(NSString *)endPoint;
-(BOOL)insertintoAppSettingsMaster :(NSArray *)arr_AppSettings;
-(BOOL)insertintoActivityTypeData:(NSArray *)activityTypesData;
-(BOOL)insertintoNotificationType :(NSArray *)notifTypes;
//-(BOOL)insertintoNotificationType :(NSArray *)arr_Qmart :(NSArray *)arr_Qmartx;
//-(BOOL)insertintoNotifPriority :(NSArray *)arr_Priok :(NSArray *)arr_Priokx;
-(BOOL)insertintoNotifPriority :(NSMutableArray *)notificationPriority;
-(BOOL)insertintoOrderPriority:(NSArray *)orderPriority;
//-(BOOL)insertintoOrderPriority :(NSArray *)arr_Priok :(NSArray *)arr_Priokx;
-(BOOL)insertintoCostCenter:(NSArray *)costCenterArray;
//-(BOOL)insertintoCostCenter :(NSArray *)arr_Kostl :(NSArray *)arr_Ktext;
-(BOOL)insertintoUserData :(NSArray *)arr_UserData;
-(BOOL)insertintoNotifItemCodes :(NSArray *)arr_ItemCodegruppe :(NSArray *)arr_ItemKurztext :(NSString *)str_NotificationType :(NSString *)str_CatalogProfile;
- (NSMutableArray *)getBOMForSearchDescription:(NSDictionary *)descriptionDictionary;
- (NSMutableArray *)getStockDataForSearchDescription:(NSDictionary *)plantDictionary;
-(BOOL)insertintoConfirmReason :(NSArray *)resultData;

- (BOOL)insertGeoTagFields:(NSMutableArray *)geoTagFieldsArray;

-(NSMutableArray *)insertetMeasDocs :(NSMutableArray *)measDocsArray;


//BOM Sort
- (NSArray *)getBOMSortedList:(NSString *)getSortedList;
- (NSArray *)getAllBOMComponents;

//Stocks sort
- (NSArray *)getMaterialSortedList:(NSString *)getSortedList;
- (NSArray *)getAllMaterials;

- (BOOL)deleteRecordinOrderForUUID:(NSString *)orderH_ID ObjectcID:(NSString *)objectID ReportedBY:(NSString *)reportedPerson;
- (BOOL)deleteRecordinNotificationForUUID:(NSString *)notificationH_ID ObjectcID:(NSString *)objectID ReportedBY:(NSString *)reportedPerson;

#pragma mark-
#pragma mark - Fetch Methods

- (NSMutableArray *)getSyncMapData :(NSString *)endPoint;
- (NSMutableArray *)getEndPointURL:(NSDictionary *)endPoint;

//CoreData
- (NSArray *)getFuncLoc:(NSString *)locationID;
//- (NSArray *)getEquipments:(NSString *)locationID;
- (NSArray *)getMapAllData;



-(NSMutableArray *)insertUserChatHistory :(NSString *)usersChatName withMessage:(NSString *)message;

- (NSArray *)getuserChatHistoryforUser:(NSString *)userName;

-(NSMutableArray *)updateTokenIdforUser:(NSString *)userName withTokenId:(NSString *)tokenId;

- (NSMutableArray *)getCustomFields:(NSDictionary *)searchCriteria;

- (NSMutableArray *)getTaksCustomFields:(NSDictionary *)searchCriteria;

 

- (NSMutableArray *)updateOrderTranscationDetails:(NSArray *)transactionArrayDetails;

- (void)getinsertDetailNotificationwithOrderDetailstoDictionary:(NSMutableDictionary *)headerDetails withAttachments:(NSMutableArray *)attachmentDetails withTransaction:(NSMutableArray *)transactionDetails alongwithOrderAttachment:(NSMutableArray *)orderattachmentDetails withPermits:(NSMutableArray *)permitDetails withOrderTransaction:(NSMutableArray *)ordertransactionDetails forAction:(NSString *)activity ForUUID:(NSString *)uuid;

- (void)getinsertDetailNotificationDetailstoDictionary:(NSMutableDictionary *)headerDetails withAttachments:(NSMutableArray *)attachmentDetails withTransaction:(NSMutableArray *)transactionDetails withTasks:(NSMutableArray *)taskDetails withNotifStatus:(NSMutableArray *)notifStatus forAction:(NSString *)activity ForUUID:(NSString *)uuid;

- (void)getinsertDetailOrderDetailstoDictionary:(NSMutableDictionary *)headerDetails withAttachments:(NSMutableArray *)attachmentDetails withPermitWorkApprovals:(NSMutableArray *)PermitWorkApprovals withPermitWorkApplications:(NSMutableArray *)PermitWorkApplications withIssuePermits:(NSMutableArray *)issuePermits withPermitsOperationWCD:(NSMutableArray *)permitsOperationWCD withTransaction:(NSMutableArray *)transactionDetails withParts:(NSMutableArray *)partDetails withActivity:(NSString *)activityType withWsmDetails:(NSMutableArray *)wsmDetails withObjectDetails:(NSMutableArray *)objectDetails ForUUID:(NSString *)uuid;

- (void)getinsertDetailCollectiveConfirmationOrderDetailstoDictionary:(NSMutableDictionary *)headerDetails ForUUID:(NSString *)uuid;

-(NSMutableArray *)fetchIsolationPermitDetails:(NSString *)uuid;

- (NSString*)readStringFromFile;
- (void)writeStringToFile:(NSString*)aString;

#pragma mark-
#pragma mark- Delete Methods

-(BOOL)deleteSyncMapData;
-(BOOL)deleteAppSettingsData;
-(BOOL)deleteActivityTypeData;
-(BOOL)deleteNotificationType;
-(BOOL)deleteNotificationPrioirty;
-(BOOL)deleteCostCenter;
-(BOOL)deleteUserData;
-(BOOL)deleteNOTIFICATION_CAUSEGROUPMASTER;
-(BOOL)deleteNOTIFICATION_CGROUP_CAUSECODEMASTER;
-(BOOL)deleteNOTIFICATION_COMPONENTMASTER;
-(BOOL)deleteNOTIFICATION_COMPONENT_PROBLEMMASTER;
-(BOOL)deleteNOTIFICATION_TASKMASTER;
-(BOOL)deleteNOTIFICATION_TASK_TASKGROUPMASTER;
-(BOOL)deleteNOTIFICATION_OBJECTMASTER;
-(BOOL)deleteNOTIFICATION_OBJECT_OBJECTGROUPMASTER;

-(BOOL)deleteCONFIRMREASONMASTER;
-(BOOL)deleteControlKeys;
-(BOOL)deleteGeoTagFields;

-(void)deleteNotificationHeader:(NSString *)notifUidiString;


#pragma mark - Create notification methods
-(NSMutableArray *)getUserDataMasterinSingleArray;
- (NSMutableArray *)getAppSettingsData;
- (NSMutableArray *)getNotificationTypes;
- (NSMutableArray *)getNotificationEffect;
-(NSMutableArray *)getNotificationTypesinSingleArray;
- (NSMutableArray *)getNotifPriorityTypes;
-(NSMutableArray *)getNotificationPriorityinSingleArray;
-(NSMutableArray *)getOrderPriorityinSingleArray;
- (NSMutableArray *)getOrderPriorityTypes;
- (NSMutableArray *)getUserData:(NSString *)str_userName;
- (NSMutableArray *)getCostCentersList:(NSString *)plant_id;
- (NSMutableArray *)getAllNotifCodes;
-(NSMutableArray *)getOrderTypesinSingleArray;
- (NSMutableArray *)getOrderTypes;
- (NSMutableArray *)getOrderSystemCondition;
- (NSMutableArray *)getAccIndicator;
- (NSMutableArray *)getUnits:(NSString *)str_UnitType;
- (NSMutableArray *)getSyncLogsDetails:(NSString *)userName;
- (NSMutableArray *)getListOfControlKeys;
- (NSMutableArray *)getPersonResonsibleMaster;

//- (NSMutableArray *)getPersonResonsibleMasterforPlant:(NSString *)plantID;

- (NSMutableArray *)getPersonResonsibleMasterforPlant:(NSString *)plantID forWorkcenter:(NSString *)workcenterid;

-(NSMutableArray *)fetchNotificationLocationName:(NSString *)funcLocationId;
- (NSMutableArray *)getPlannerGroupMasterforPlant:(NSString *)plantID;
- (NSMutableArray *)getInspectionResultforEquipment:(NSString *)equipmentID;
- (NSMutableArray *)getWCMUsageswithPlantText:(NSString *)plantID forObject:(NSString *)objArt;
- (NSMutableArray *)getWCMAuthorizationGroup;

- (NSString *)getImageDirectory;
//- (void)clearAllSubviewsForView:(UIView*)view;
- (BOOL)completeNotificationForUUID:(NSString *)notificationH_ID ObjectcID:(NSString *)objectID ReportedBY:(NSString *)reportedPerson;
- (NSArray *)getfunctionalLocationsforCostCenter:(NSString *)costCenterID withMatchString:(NSString *)searchString;

- (BOOL)cancelNotificationForUUID:(NSString *)notificationH_ID ObjectcID:(NSString *)objectID ReportedBY:(NSString *)reportedPerson;
- (BOOL)releaseNotificationForUUID:(NSString *)notificationH_ID ObjectcID:(NSString *)objectID ReportedBY:(NSString *)reportedPerson;

 - (BOOL)postPoneNotificationForUUID:(NSString *)notificationH_ID ObjectcID:(NSString *)objectID ReportedBY:(NSString *)reportedPerson;
 
- (BOOL)cancelOrderForUUID:(NSString *)orderH_ID ObjectcID:(NSString *)objectID ReportedBY:(NSString *)reportedPerson;
- (BOOL)confirmOrderForUUID:(NSDictionary *)orderObjects ObjectcID:(NSString *)objectID ReportedBY:(NSString *)reportedPerson;
 - (BOOL)releaseOrderForUUID:(NSString *)orderH_ID ObjectcID:(NSString *)objectID ReportedBY:(NSString *)reportedPerson;


- (BOOL)insertStockOverviewData:(NSMutableArray *)stockData;

- (void)insertMaterialsToCoreDataFromArray:(NSMutableArray *)materialsArray;

- (void)insertMaterialsToCoreDataFromBomItemsArray:(NSDictionary *)materialsDictionary;
- (void)insertStocksToCoreDataFromBomItemsArray:(NSDictionary *)materialsDictionary;
- (NSMutableArray *)fetchStocksDataFromBomItem:(NSString *)bomItem;


- (NSMutableArray *)searchMaterialsForPlant:(NSString *)plantName StorageLocation:(NSString *)storageName MaterialDescription:(NSString *)materialName;

- (NSMutableArray *)getFunctionalLocationForCostCenter:(NSString *)costCenter searchString:(NSString *)searchString;
- (NSArray *)getEquipmentsForCostCenter:(NSString *)costCenterID withMatchString:(NSString *)searchString;
- (NSArray *)getPlantNames;
- (NSArray *)getEquipmentsForlocationID:(NSString *)locationID;
- (NSArray *)getFuncLocForEquipID:(NSString *)locationID;
- (NSArray *)getComponentForMaterialId:(NSString *)materialID;
- (NSMutableArray *)getPlantWorkForOrders:(NSMutableDictionary *)orderDictionary;
-(NSMutableArray *)fetchNotificationEquipmentHistoryForUUID:(NSString *)uuid;
- (NSMutableArray *)testEntityData:(NSString *)incidentId;
- (NSArray *)getEquipmentsForEquipIDforIwerkString:(NSString *)equipmentID;


//WSM
-(NSMutableArray *)insertWorksafetyTransactions:(NSMutableDictionary *)transactionDetailsDictionary withSafetyMesures:(NSMutableArray *)safetyMeasures;
-(NSMutableArray *)fetchWSMTransactionDetailsForUUID:(NSString *)uuid;
-(NSMutableArray *)fetchWSMTransactionDetails;

-(void)deleteWSMTransactionDEtailswithSafetyMeasures;
-(void)deleteWSMTransactions:(NSMutableArray *)transactionDetailsArray;


//MeasurementDocuments
- (NSArray *)getMeasurementDocumentPoints:(NSString *)locationID;


-(BOOL)insertWorkOrderTimerOperationStatus:(NSDictionary *)workOrderOperatusStatus;

- (BOOL)updateOrderStatus:(NSString *)headerID :(NSString *)status;

- (BOOL)updateNotificationWithObjectid:(NSString *)objectId forHeaderID:(NSString *)headerID;
- (BOOL)updateOrderWithObjectid:(NSString *)objectId forHeaderID:(NSString *)headerID;
- (BOOL)updateSynclogobjectID:(NSString *)objectID forUUID:(NSString *)uuidString;
- (void)refreshCoreDataContext;
//- (void)insertFromServer:(NSMutableDictionary *)headerDictionary withCausecodeDetail:(NSMutableArray *)causecodeDetailArray;
- (NSString *)fetchNameForIDKey:(NSString *)keyName forValue:(NSString *)keyValue;
- (NSString *)fetchNameForIDKeyM:(NSString *)keyName forValue:(NSMutableArray *)keyValue;
- (NSMutableArray *)fetchColumn:(NSString *)columnName fromTabe:(NSString *)tableName condtionColumn:(NSString *)conditionColumn conditionvalue:(NSString *)value;
- (NSMutableArray *)fetchColumnM:(NSString *)columnName fromTabe:(NSString *)tableName condtionColumn:(NSArray *)conditionColumn conditionvalue:(NSMutableArray *)value;
- (BOOL)updateSyncLogForCategory:(NSString *)cateGory action:(NSString *)actionString objectid:(NSString *)objectID UUID:(NSString *)headerID;

- (BOOL)updateSyncLogForCategory:(NSString *)cateGory action:(NSString *)actionString objectid:(NSString *)objectID UUID:(NSString *)headerID  date:(NSString *)dateValue timestamp:(NSString *)timestampvalue;

- (BOOL)updateForChangeNotification:(NSString *)headerID;
- (BOOL)updateSyncLogErrorForCategory:(NSString *)cateGory action:(NSString *)actionString objectid:(NSString *)objectID UUID:(NSString *)headerID message:(NSString *)message;

- (BOOL)updateSyncLogErrorForCategory:(NSString *)cateGory action:(NSString *)actionString objectid:(NSString *)objectID UUID:(NSString *)headerID message:(NSString *)message Date:(NSString *)date timestamp:(NSString *)timestampvalue; // synclog for timestamp

- (BOOL)insertUtilityReserveDetail:(NSDictionary *)headerDictionary withTransactions:(NSMutableArray *)transactions;
- (NSMutableDictionary *)getReserveUtilityFor:(NSString *)reserveHID;

- (BOOL)insertInspectionCheckListDetailwithTransactions:(NSMutableDictionary *)transactionsDictionary;
- (NSMutableDictionary *)getInspectionCheckListFor:(NSString *)inspectHID;


- (void)insertFuncLocEquimentsToCoreDataFromArray:(NSArray *)functionalLocationArray;
- (void)insertEquipMpttToCoreDataFromArray:(NSArray *)EquipMpttArray;
- (void)insertFlocMpttToCoreDataFromArray:(NSArray *)FlocMpttArray;
- (void)importLocalDataIntoCoreData;
- (BOOL)deleteCompletedTasksForRefresh;

- (NSMutableArray *)getNotificationCustomFields:(NSString *)headerID;
- (NSMutableArray *)getNotificationTransactionCustomFields:(NSString *)headerID;

- (NSMutableArray *)getComponentsForNotificationID:(NSString *)notificationID;
- (NSMutableArray *)getCaseGroupForNotificationID:(NSString *)notificationID;
- (NSMutableArray *)getObjectGroupForNotificationID:(NSString *)notificationID;
- (NSMutableArray *)getProblemDetailsForComponentID:(NSString *)componentID :(NSString *)notificationTypeId :(NSString *)catalogprofileId
;
- (NSMutableArray *)getObjectGroupDetailsForObjectGroupID:(NSString *)objectGroupID :(NSString *)notificationTypeId :(NSString *)catalogprofileId;
- (NSMutableArray *)getCauseCodeForCaseGroupID:(NSString *)caseGroupID :(NSString *)notificationTypeId :(NSString *)catalogprofileId;
- (NSMutableArray *)getNotificationTransactionsForNotificationHeaderID:(NSString *)headerID;
- (NSMutableArray *)getLocalNotificationForCondition:(NSMutableDictionary *)conditionDictionary;
- (NSMutableArray *)getLocalOrderForCondition:(NSMutableDictionary *)conditionDictionary;
- (NSMutableArray *)getComponentsForMaterails:(NSMutableDictionary *)conditionDictionary;
- (NSMutableArray *)getListOfMovementTypes;
- (NSMutableArray *)getListOfActivityTypes:(NSDictionary *)getHeaderRelated;
- (NSMutableArray *)getListOfReasons :(NSString *)plantString;
- (NSMutableArray *)getNotificationHeaderForNotificationId:(NSString *)qmnumId;

//for Activity

- (NSMutableArray *)getActivityCodeGroups:(NSString *)catalogProfileid;
- (NSMutableArray *)getActivityCodes:(NSString *)codeGroupID;



//for filters

- (NSArray *)getPriorityList:(NSString *)getFilteredList;
- (NSArray *)getAllNotifications;

//for sort
- (NSArray *)getSortedList:(NSString *)getSortedList;

//Order Filters & Sort
- (NSArray *)getPriorityListOrders:(NSString *)getFilteredList;
- (NSArray *)getSortedListOrders:(NSString *)getSortedList;
- (NSArray *)getAllOrders;

- (NSMutableArray *)getUUIDForObjectID:(NSString *)objectID;

- (NSString *)insertDataIntoNotificationHeader:(NSDictionary *)notificationHeaderDetails withAttachments:(NSMutableArray *)attachments withTransaction:(NSMutableArray *)notificationTransactionDetails alongwithOrder:(NSDictionary *)orderHeaderDetails withAttachments:(NSMutableArray *)attachmentDetails withPermits:(NSMutableArray *)permitDetails withTransaction:(NSMutableArray *)orderTransactionDetails;

- (NSString *)insertDataIntoNotificationHeader:(NSDictionary *)headerDetails withAttachments:(NSMutableArray *)attachments withTransaction:(NSMutableArray *)transactionDetails withActivityCodes:(NSMutableArray *)activityDetails withTaskcodes:(NSMutableArray *)taskCodeDetails withInspectionResult:(NSMutableArray *)inspectionResultArray withNotifStatusCode:(NSMutableArray *)notifStatus;

- (NSString *)insertDataIntoOrderHeader:(NSDictionary *)headerDetails withAttachments:(NSMutableArray *)attachmentDetails withPermitWorkApprovalsDetails:(NSMutableArray *)permitWorkApprovalsDetails withOperation:(NSMutableArray *)transactionDetails withParts:(NSMutableArray *)partsDetails withWSM:(NSMutableArray *)wsmDetails withObjects:(NSMutableArray *)objectDetails withSystemStatus:(NSMutableArray *)systemStatus withPermitsWorkApplications:(NSMutableArray *)permitWorkApplicationDetails withIssuePermits:(NSMutableArray *)issuePermits withPermitsOperationWCD:(NSMutableArray *)operationWCDPermits withPermitsOperationWCDTagiingConditions:(NSMutableArray *)operationWCDTaggingConditionsPermits withPermitsStandardCheckPoints:(NSMutableArray *)permitsStandardCheckPoints withMeasurementDocs:(NSMutableArray *)measurementDocs;

-(BOOL)insertOrderCollectiveDetails:(NSMutableDictionary *) collectiveConfirmationDetails;

-(NSMutableArray *)insertNotificationTransactionsDetails :(NSString *)uuid withTransactionDetailsCopy:(NSArray *)transactionDetails withActivityDetailsArray:(NSArray *)activityDetails withTaskCodeDetailsCopy:(NSArray *)taskCodeDetails;


-(NSMutableArray *)insertNotificationTransactions:(NSDictionary *)transactionDetails;
-(NSMutableArray *)insertNotificationActivities:(NSDictionary *)activityDetails;

- (NSMutableArray *)updateNotificationTransactions:(NSDictionary *)transactionDetails;
-(NSMutableArray *)fetchNotificationLastCauseFromItemKey:(NSString *)itemKey;
- (NSMutableArray *)fetchNotificationTransactionDetailsForUUID:(NSString *)uuid;
- (BOOL)updateDeletedNotificationTransactionsDetails:(NSDictionary *)notificationTransactionDetails;
- (BOOL)updateDeletedNotificationTasksDetails:(NSDictionary *)notificationTaskDetails;
-(void)deleteNotificationTasks;
-(void)deleteNotificationTransactions;
-(void)deleteNotificationTransactions:(NSDictionary *)transactionDetails;

-(NSMutableArray *)fetchNotificationActivityItemKey:(NSString *)notifUdidString;


-(void)deleteNotificationActivities;

//for Activities
-(NSMutableArray *)fetchNotificationActivitiesForUUID:(NSString *)uuid;
-(NSMutableArray *)updateNotificationActivities:(NSDictionary *)activityDetails;



-(NSMutableArray *)insertOrderTranscationDetails:(NSDictionary *)transactionDetails;
-(NSMutableArray *)insertOrderPartDetails:(NSDictionary *)partDetails;
-(NSMutableArray *)updateOrderPartDetails:(NSDictionary *)partDetails;
//-(NSMutableArray *)insertOrderTranscationDetails:(NSMutableArray *)transactionDetails :(NSString *)uuid;
-(NSMutableArray *)insertOrderTranscationDetails:(NSMutableArray *)transactionDetails :(NSMutableArray *)partDetails :(NSString *)uuid;

-(BOOL)insertConfirmOrderWorkTimer:(NSDictionary *)workOrderTimingDetails;
-(NSMutableArray *)fetchLastRecordConfirmWorkOrderTimer:(NSDictionary *)workOrderTimingDetails;
-(NSMutableArray *)fetchLastRecordConfirmWorkOrderTimerSelected:(NSDictionary *)workOrderTimingDetails;

- (NSMutableArray *)updateOrderTransactions:(NSDictionary *)transactionDetails;
- (NSMutableArray *)fetchOrderTransactionDetailsForUUID:(NSString *)uuid;
-(NSMutableArray *)fetchOrderPartDetailsForUUID:(NSString *)uuid;
-(NSMutableArray *)fetchOrderTransactionDetailsForUUIDCopy:(NSString *)uuid;//tempmethod


- (NSMutableArray *)fetchOrderLastComponentFromOperationKey:(NSString *)operationKey;
-(NSMutableArray *)fetchTotalDurationWorkOrderTimer:(NSDictionary *)workOrderDetails;

- (BOOL)updateDeletedOrderTransactionsDetails:(NSDictionary *)orderTransactionDetails;

-(void)deleteOrderTransactions:(NSDictionary *)transactionDetails;
-(void)deleteOrderTransactions;
-(void)deleteConfirmWorkOrderTimer:(NSString *)transactionId;

- (BOOL)updateDeletedPartsTransactionsDetails:(NSDictionary *)orderPartsDetails;
-(void)deletePartsTransactions:(NSDictionary *)partsDetails;

-(void)deleteConfirmWorkOrderTimerForPCNF:(NSString *)transactionId; //to delete pcnf

////////////
//- (void)getinsertDetailOrderDetailstoDictionary:(NSMutableDictionary *)headerDetails withAttachments:(NSMutableArray *)attachmentDetails withCustomHeaderFields:(NSMutableArray *)customHeaderDetails withTransaction:(NSMutableArray *)transactionDetails withCustomTransactionFields:(NSMutableArray *)customComponentDetails ForUUID:(NSString *)uuid;

- (NSMutableArray *)getAllPendingSyncLogs;
- (NSMutableDictionary *)getDataForSyncLog:(NSMutableArray *)dataArray;

- (void)openLogFile;
- (void)writToLogFile:(NSString *)content;
- (void)closeLogfile;

- (NSMutableArray *)deleteinsertedDataForTheSelectedCriteria:(NSDictionary *)selectedCriteriaDictionary;

- (NSMutableArray *)deleteinsertDataIntoHeader:(NSString *)headerIDType;

- (NSMutableArray *)getListOfWorkCenter;
- (NSMutableArray *)getListOfWorkCenter:(NSString *)SelectedPlant;

- (BOOL)insertintoListOfWorkCenter :(NSArray *)arr_WorkCenterData;

- (NSMutableArray *)getNotificationTextforId:(NSString *)notificationTypeString;
- (NSMutableArray *)getPriorityTextforId:(NSString *)priorityTypeString;
- (NSMutableArray *)getPlannerGroupTextforId:(NSString *)locationID ForplantId:(NSString *)plantID;

- (BOOL)insertintoNotifCodesGroup :(NSArray *)arr_ItemCodegruppe :(NSArray *)arr_ItemKurztext :(NSString *)str_NotificationType :(NSString *)str_CatalogProfile;

-(BOOL)insertItemCodeDetails :(NSMutableArray *)itemCodeDetails;
-(BOOL)insertCuaseCodeDetails :(NSMutableArray *)causeCodeDetails;
-(BOOL)insertTaskCodeDetails :(NSMutableArray *)taskCodeDetails;
-(BOOL)insertObjectCodeDetails :(NSMutableArray *)objectCodeDetails;
-(BOOL)insertActCodeDetails :(NSMutableArray *)actCodeDetails;

-(BOOL)deleteAllNotifCodesMasters;

-(NSMutableArray *)insertMeascodes :(NSMutableArray *)measCodesArray;
-(NSArray *)getMeasCodes:(NSString *)fetchRequestString;


//- (BOOL)insertintoNotifItemCodesProblem :(NSArray *)arr_ItemCode :(NSArray *)arr_ItemKurztext :(NSArray *)arr_ComponentId :(NSString *)str_ComponentNotifId :(NSString *)str_CatalogProfileId;

- (BOOL)insertintoNotifCodes :(NSArray *)arr_ItemCode :(NSArray *)arr_ItemKurztext :(NSArray *)arr_ComponentId :(NSString *)str_CauseCodeNotifId :(NSString *)str_CatalogProfileId;

- (BOOL)insertintoNotifCodesTaskGroup :(NSArray *)arr_taskCodegruppe :(NSArray *)arr_taskKurztext :(NSString *)str_NotificationType :(NSString *)str_CatalogProfile;

- (BOOL)insertintoNotifTaskCodes :(NSArray *)arr_taskCode :(NSArray *)arr_taskKurztext :(NSArray *)arr_ComponentId :(NSString *)str_CauseCodeNotifId :(NSString *)str_CatalogProfileId;

- (BOOL)insertintoNotifCodesObjectGroup :(NSArray *)arr_objectCodegruppe :(NSArray *)arr_objectKurztext :(NSString *)str_NotificationType :(NSString *)str_CatalogProfile;

- (BOOL)insertintoActivityCodesGroup :(NSArray *)arr_ActCodegruppe :(NSArray *)arr_ActKurztext :(NSString *)str_NotificationType :(NSString *)str_CatalogProfile;


- (BOOL)insertintoNotifObjectCodes :(NSArray *)arr_objectCode :(NSArray *)arr_objectKurztext :(NSArray *)arr_ComponentId :(NSString *)str_CauseCodeNotifId :(NSString *)str_CatalogProfileId;

- (NSMutableArray *)updateNotificationTasks:(NSDictionary *)taskDetails;

- (NSMutableArray *)getTaskGroupForCatalogID:(NSString *)catalogID;
- (NSMutableArray *)getTaskGroupDetailsForTaskCodeID:(NSString *)taskGroupID :(NSString *)notificationTypeId :(NSString *)catalogprofileId;
#pragma mark -
//Inserting

-(NSMutableArray *)insertNotificationTasks:(NSDictionary *)taskDetails;

-(NSMutableArray *)insertNotificationTasks:(NSDictionary *)taskDetails withCustomFields:(NSMutableArray *)customFields;

- (BOOL)insertintoOrderType:(NSArray *)orderTypeArray;
//- (BOOL)insertintoOrderType :(NSArray *)arr_Auart :(NSArray *)arr_Txt;
- (BOOL)insertintoAccIndicator:(NSArray *)accoutingIndicator;
//- (BOOL)insertintoAccIndicator :(NSArray *)arr_Bemot :(NSArray *)arr_BemotTxt;
//- (BOOL)insertintoGetUnits :(NSArray *)arr_Meins :(NSArray *)arr_UnitType;
- (BOOL)insertintoGetUnits:(NSArray *)unitTypeArray;

- (BOOL)insertintoFuncLocFromCostCenter :(NSArray *)arr_Tplnr :(NSArray *)arr_Pltxt :(NSArray *)arr_Arbpl :(NSArray *)arr_Werks :(NSString *)str_CostCenter;
- (BOOL)insertintoEuipNoFromCostCenter :(NSArray *)arr_Arbpl :(NSArray *)arr_Eqktx :(NSArray *)arr_Equnr :(NSArray *)arr_Werks :(NSArray *)arr_Spras :(NSArray *)arr_Pltxt :(NSArray *)arr_Tplnr :(NSString *)str_CostCenter;

- (BOOL)insertintoListOfMovementTypes:(NSArray *)movementTypeArray;
//- (BOOL)insertintoListOfMovementTypes :(NSArray *)arr_Btext :(NSArray *)arr_Bwart;

- (BOOL)insertintoBOMComponents :(NSArray *)arr_Header :(NSArray *)arr_Transaction;

- (BOOL)insertCustomFields:(NSMutableArray *)customFieldsArray;
- (BOOL)insertControlKeys:(NSMutableArray *)controlKeysArray;

-(BOOL)insertintoNotifEffect :(NSArray *)arr_NotifEffectData;
-(BOOL)insertintoOrderSystemCondition :(NSArray *)arr_OrderSystemConditionData;

//Fetching
-(void)deleteNotificationTasks:(NSDictionary *)taskDetails;
- (NSMutableArray *)fetchNotificationTaskDetailsForUUID:(NSString *)uuid;
- (NSArray *)getSearchMeasureDoc:(NSString *)searchString;

- (NSMutableArray *)readSqliteFile_BomLookup_EtComponents:(NSString *)str_Bom;

-(BOOL)deleteNotificationDetails:(NSString *)headerID;
-(BOOL)deleteOrderDetails:(NSString *)headerID;

- (BOOL)updateNotificationStatus:(NSString *)headerID :(NSString *)status;
- (BOOL)updateOrderStatus:(NSString *)headerID;
- (NSMutableArray *)getComponentsForCatalogID:(NSString *)catalogID;
- (NSMutableArray *)getCaseGroupForCatalogID:(NSString *)catalogID;
- (NSMutableArray *)getObjectGroupForCatalogID:(NSString *)catalogID;
- (NSMutableArray *)getListOfPlants;
- (NSMutableArray *)getListOfStorageLocation:(NSString *)plantID;

- (BOOL)insertintoPlantsMaster :(NSArray *)arr_Werks;

- (BOOL)insertintoStorageLocationMaster :(NSArray *)arr_Lgort;

//Deleting
-(BOOL)deleteCustomFields;
- (BOOL)deleteStockOverView:(NSString *)descriptionString searID:(NSString *)idString :(NSMutableDictionary *)plantDictionary;
- (BOOL)deleteComponentsForMaterial:(NSMutableDictionary *)componentsDictionary;

//update order
- (BOOL)updateForChangeOrder:(NSString *)headerID;
-(BOOL)deleteSyncLogs;

-(BOOL)deletesynclog:(NSMutableArray *)getdeleteObjectIds;

@property (nonatomic, strong) NSUserDefaults *defaults;

@property (nonatomic, strong) NSMutableDictionary *orderDetails;
@property (nonatomic, strong) NSMutableDictionary *notifDetails;

#pragma mark-
#pragma mar- WSM

- (BOOL)insertWsmWcmr:(NSMutableArray *)wcmrArray;
- (BOOL)insertWsmPermit:(NSMutableArray *)permitArray;
- (BOOL)insertWsmEqui:(NSMutableArray *)equipArray;
- (BOOL)insertWsmDocument:(NSMutableArray *)documentArray;
- (BOOL)insertWsmMaterial:(NSMutableArray *)materialArray;
- (BOOL)insertWsmObjAvail:(NSMutableArray *)objAvailArray;
- (BOOL)insertWsmResponses:(NSMutableArray *)responseMasterArray;
- (BOOL)insertWsmRisks:(NSMutableArray *)riskMasterArray;
- (BOOL)insertWsmplants:(NSMutableArray *)plantsArray;

- (NSMutableArray *)getrisksListNAll;
- (NSMutableArray *)getSafetyPlanNAll;
-(NSMutableArray *)getSafetyMeasures:(NSString *)tableCall;

- (NSMutableArray *)getSelectedrisksListNAll:(NSString *)selectedRisksforOrder;

- (NSMutableArray *)deleteSqliteFile_BomLookup_ETComponents :(NSString *)BOMEquip;

- (BOOL)updateOrderNoinNotification:(NSDictionary *)inputParameters;

//Header Planner groupFetch
-(NSMutableArray *)fetchPlannerGrpForequipIngrp:(NSString *)IngrpID;


//MeasurementDocuments
- (NSMutableArray *)getAllOperationsForUUID:(NSString *)uuid;
-(NSMutableArray *)insertMeasurementDocs:(NSDictionary *)MdocsDetails;
-(NSMutableArray *)fetchOrderMDocumentsForUUID:(NSString *)aufnrId;
-(NSMutableArray *)fetchMeasurementDocumentsForUUID:(NSString *)uuid;
-(void)deleteMeasurementDocuments;
-(BOOL)insertOrderCollectiveDetails:(NSMutableDictionary *) collectiveConfirmationDetails  withMeasurementDocuments:(NSMutableArray *)measurementDocsDetails;

- (NSArray *)getSortedListOrdersfor:(NSString *)equipmentId;
- (NSArray *)getOrderforMplan:(NSString *)objectId;

-(NSArray *)getdistinctValuesfromCoreData:(NSDictionary *)inputParameters;

//New Authorization tables
-(BOOL)insertintoMUserData :(NSArray *)arr_MUserData;
-(BOOL)insertintoScreenUserData :(NSArray *)arr_ScreenUserData;
-(BOOL)insertintoUserFunctionData :(NSArray *)arr_UserFunctionData;
-(void)fetchAuthorizationData;
//New Authorization
-(BOOL)deleteUserAuthorizationData;
-(BOOL)insertintoNFCSettingsMaster:(NSArray *)arr_NFCSettings;

-(BOOL)insertintoEtTq80 :(NSArray *)arr_EtTq80Data;
- (NSMutableArray *)getOrderTypeFromNotificationType:(NSString *)notificationTypeID;
- (NSMutableArray *)getPlantText :(NSString *)plantID;
-(BOOL)insertintoInGrp :(NSArray *)arr_InGrpData;//Planner Group
-(BOOL)insertintoPernr :(NSArray *)arr_PernrData;//Person Responsible
-(BOOL)insertintoAuthorizationGroup :(NSArray *)arr_AuthorizationData;//WCM AuthorizationGroup
-(BOOL)insertintoUsages :(NSArray *)arr_UsageData;//WCM USAGES
-(BOOL)insertintoWCMWorks :(NSArray *)arr_WcmWorkData;//WCM  WORKS
-(BOOL)insertintoWCMRequirements :(NSArray *)arr_WcmRequirementsData;//WCM REQUIREMENTS


//WCM
-(NSMutableArray *)insertWCMTypes :(NSMutableArray *)wcmTypesArray;
-(NSMutableArray *)insertWCMIsolation :(NSMutableArray *)wcmIsloationArray;
-(NSMutableArray *)insertWCMCheckRequest :(NSMutableArray *)wcmChequeRequestArray;
-(NSMutableArray *)fetchWCMTypesforPlantID:(NSString *)plantIDString;
-(NSMutableArray *)fetchWCMRequests;
-(NSMutableArray *)fetchWCMIsloationsData;
-(NSMutableArray *)insertWorkApprovalHeaderDetails:(NSMutableArray *)workApprovalDetails;
-(NSMutableArray *)WorkApprovalHeaderDetails;
-(NSMutableArray *)fetchWCMRequestsforCreateApplicationType:(NSString *)wapId forUsage:(NSString *)usageID;


//JSA
-(NSMutableArray *)insertJSA :(NSMutableArray *)jsaSopstatArray;
-(NSMutableArray *)insertJSAShacat:(NSMutableArray *)jsaShazcatArray;
-(NSMutableArray *)insertJSASHazard:(NSMutableArray *)jsaShazardArray;
-(NSMutableArray *)insertJSASHazimp:(NSMutableArray *)jsaSHazimpArray;
-(NSMutableArray *)insertJSASHazctrl:(NSMutableArray *)jsaSHactrlArray;
-(NSMutableArray *)insertJSASLocTyp:(NSMutableArray *)jsaLocTypArray;
-(NSMutableArray *)insertJSASSLocRev:(NSMutableArray *)jsaSLocRevArray;
-(NSMutableArray *)insertJSASJobTyp:(NSMutableArray *)jsaSJobTypArray;
-(NSMutableArray *)insertJSASReason:(NSMutableArray *)jsaSReasonArray;
-(NSMutableArray *)insertJSASRastep:(NSMutableArray *)jsaSRastepArray;
-(NSMutableArray *)insertJSASRasrole:(NSMutableArray *)jsaSRasroleArray;

//fetch Details
-(NSMutableArray *)getOpstatDetails:(NSString *)materialNo;


-(NSMutableArray *)insertetUsersTokenId :(NSMutableArray *)usersTokenIdArray;
- (NSMutableArray *)getUserTokenDataArray;
- (NSMutableArray *)getInspectionMeasDocsforCodegroup:(NSString *)codeGroupId;

-(NSMutableArray *)fetchNotifSystemStatus :(NSString *)uuidString;
-(NSMutableArray *)fetchOrderSystemStatus :(NSString *)uuidString;
-(NSMutableArray *)fetchOrderSystemStatusOnly :(NSString *)uuidString;
-(NSMutableArray *)fetchNotificationSystemStatusOnly :(NSString *)uuidString;

-(NSMutableArray *)getApplicationNameForObjType:(NSDictionary *)objTypeDictionary;

-(BOOL)fetchOrderStatforOrderCompletion :(NSString *)uuidString;
-(NSMutableArray *)fetchWCMRequestsforApplicationType:(NSString *)wapId;

//NFC
-(NSMutableArray *)fetchNFCSettingsForPlantId:(NSString *)PlantID;

-(NSArray *)getEquipments:(NSDictionary *)fetchRequest;
-(NSArray *)getFunctionLocations:(NSDictionary *)fetchRequest;
- (NSArray *)getMapData:(NSString *)OrderId;
-(NSArray *)getiWerksForequipment:(NSString *)equipmentId;


//MIS
-(NSMutableArray *)fetchWCMTypesforPermitReport:(NSMutableArray *)objectTypeID;

/////
- (NSMutableArray *)fetchOrderDetailsForOrderNo:(NSString *) OrderNo;
- (NSMutableArray *)fetchNotificationDetailsForNotifNo:(NSString *) NotifNo;
-(NSMutableArray *)fetchGeoTagHeader;


-(NSMutableArray *)getPriorityDescriptionForPermitReport:(NSString *)priorityID;
-(NSMutableArray *)getPriorityDescForNotificationReport:(NSString *)notifPriorityID;

-(NSMutableArray *)getWOCOStatus:(NSString *)uuid;

- (void)insertEquipmentBOMToCoreDataFromArray:(NSDictionary *)EquipmentBOMDictionary;
- (void)insertStockOverViewToCoreDataFromArray:(NSArray *)StockOverViewArray;
-(NSMutableArray *)fetchWCMTypesforPermitReport:(NSMutableArray *)objectTypeID forPlant:(NSString *)plantID;

-(void)insertFunctionalocationToCoreData:(NSArray *)functionalLocationArray;
-(void)insertEquipmentToCoreData:(NSArray *)equipmentArray;

- (NSMutableDictionary *)parseForListOfPMBOMSItemData:(NSDictionary *)resultDictionary;
-(NSMutableArray *)getStorageLocationFromMaterialNo:(NSString *)materialNo;

@end

