//
//  Request.h
//  eCollection
//
//  Created by Harish Kishenchand on 26/11/12.
//  Copyright (c) 2012 HTC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMLDictionary.h"

#import "NSData+AESCrypt.h"
#import "NSString+AESCrypt.h"
#import "UrlConstraints.h"
#import <UIKit/UIKit.h>


typedef enum WebServiceRequest{
    
    NOTIFICATION_CREATE = 0,
    NOTIFICATION_CHANGE = 1,
    NOTIFICATION_CANCEL = 2,
    NOTIFICATION_COMPLETE = 3,
    ORDER_CREATE = 4,
    ORDER_CHANGE = 5,
    ORDER_CANCEL = 6,
    ORDER_CONFIRM = 7,
    UTILITY_RESERVE = 8,
    NOTIFICATION_TYPES = 9,
    NOTIFICATION_PRIORITY_TYPES = 10,
    ORDER_TYPES = 11,
    ACCIND_TYPES = 12,
    GET_UNITS = 13,
    USER_DATA = 14,
    COSTCENTER_LIST = 15,
    ALLNOTIFICATION_CODES = 16,
    FUNCTIONLOC_COSTCENTER = 17,
    EQUIPMENT_COSTCENTER = 18,
    FUNCTIONLOC_EQUIPMENT = 19,
    EQUIPMENT_FUNCLOC = 20,
    LOGIN = 21,
    GET_LIST_OF_COMPONENTS = 22,
    GET_LIST_OF_MOVEMENTTYPES = 23,
    GET_LIST_OF_NOTIFICATIONS = 24,
    GET_LIST_OF_OPEN_NOTIFICATIONS = 25,
    GET_LIST_OF_ORDERS = 26,
    GET_LIST_OF_OPEN_ORDERS = 27,
    GET_LIST_OF_PM_BOMS = 28,
    GET_STOCK_DATA = 29,
    GET_LOG_DATA = 30,
    GET_MATERIAL_AVAILABILITY_CHECK = 31,
    GET_APP_SETTINGS = 32,
    GET_PERMITS_DATA = 33,
    ORDER_PRIORITY_TYPES = 34,
    GET_LIST_OF_DUE_NOTIFICATIONS = 35,
    GET_LIST_OF_DUE_ORDERS = 36,
    SEARCH_FUNCLOC_EQUIPMENTS = 37,
    GET_LIST_OF_PLANTS = 38,
    GET_LIST_OF_STORAGELOCATION = 39,
    GET_LIST_OF_WORKCENTER = 40,
    GET_CUSTOM_FIELDS = 41,
    GET_SYNC_MAP_DATA = 42,
    GET_ACTIVITY_TYPE = 43,
    USER_FUNCTION = 44,
    GET_CONFRIM_REASON = 45,
    GET_VALUE_HELPS = 46,
    GET_LOAD_SETTINGS = 47,
    GET_DOCUMENTS = 48,
    CREATE_NOTIF_ORDER = 49,
    GET_NOTIFICATIONNO_DETAILS = 50,
    GET_ORDERNO_DETAILS = 51,
    GET_AUTH_DATA = 52,
    GET_SETTINGS_DATA = 53,
    SEARCH_PLANTMAINT=54,
    ORDER_COLLECTIVE_CONFIRMATION=55,
    GET_WSM_MASTERDATA=56,
    BREAKDOWN_STATISTICS = 57,
    NOTIFICATION_ANALYSIS = 58,
    MAINTAINANCE_SET_CHECK_LIST= 59,
    MAINTAINANCE_GET_CHECK_LIST= 60,
    GET_NFC_SETTINGS = 61,
    PERMIT_REPORT = 62,
    GET_INITIAL_ZIP = 63,
    AVAILABILITY_REPORT = 64,
    ORDER_WOCO = 65,
    MONITOR_EQUIP_HISTORY =66,
    MONITOR_GET_EQUIP_MDOCS =67,
    MONITOR_SET_EQUIP_MDOCS =68,
    NOTIFICATION_RELEASE =69 ,
    ORDER_RELEASE =70,
    ORDER_MDOCS = 71,
    EQUIPMENT_BREAKDOWN = 72,
    INSPECTION_MPLAN =73,
    ORDER_ANALYSIS = 74,
    DEVICE_TOKEN =75,
    SET_DEVICETOKENID =76,
    GEOTAG_SYNCALL = 77,
    WCM_VALUE_HELPS =78,
    JSA_VALUE_HELPS =79,
    NOTIFICATION_POSTPONE =80,
    GET_ORDERS =81
    
}WebServiceRequest;

typedef enum RequestDataType
{
    NORMAL_DATA = 0,
    LARGE_DATA = 1
}RequestDataType;

@protocol requestDelegate <NSObject>

@optional
- (void)resultData:(NSDictionary *)resultData withErrorDescription:(NSString *)errorDescription requestID:(WebServiceRequest)requestID :(int)statusCode;

@end

@interface Request : NSObject
{
    NSMutableData *receivedData;
    NSInputStream *myInputStream;
    NSOutputStream *dataToFileStream;
    NSString *filepathString;
    NSUserDefaults *defaults;
    BOOL invalidCredentailsCheck;
    NSString *userName,*passWord;
    
    NSString *strErdat,*strNotifNo,*strFuncLoc,*strEquipNo,*strPriok,*str_Plant,*str_StorageLocation,*str_Material,*strOrderNo,*customFieldsString,*workCenterString;
    
    NSString *reqStartDate;
    NSString *reqStartTime;
    NSString *reqEndDate;
    NSString *reqEndTime;
    NSString *reqMStartDate;
    NSString *reqMStartTime;
    NSString *reqMEndDate;
    NSString *reqMEndTime;
    NSString *checkPointDescriptionString;
    
    NSMutableString *notifCauses,*feildCauses,*notifActvs,*feildActvs,*notifTasks,*feildTasks,*orderComponents,*feildComponents,*feildOperations,*orderPermits,*feildPermits,*attachDocs,*customHeaderItemFieldsString;
    int responseStatusCode;
    
    NSString *decryptedUserName,*decryptedPassword;
    
}

@property(readonly) BOOL hasBytesAvailable;
@property (nonatomic, strong)NSURLConnection *connection;
@property (nonatomic,weak)id<requestDelegate> resultDelegate;
@property (nonatomic)RequestDataType dataType;
@property (nonatomic)WebServiceRequest requestType;

@property (nonatomic, strong)NSMutableURLRequest *connectionRequest;

+(NSString*)encodeToPercentEscapeString:(NSString *)string;
+ (NSString*)decodeFromPercentEscapeString:(NSString *)string;
+ (void)stopRequest;
- (void)startConnection;
//- (void)stopConnection;
+ (void)makeWebServiceRequest:(WebServiceRequest)requestId parameters:(NSDictionary *)parameters delegate:(id)delegate;
- (void)makeWebServiceRequest:(WebServiceRequest)requestId parameters:(NSDictionary *)parameters delegate:(id)delegate;

//+ (void)seltLocalID:(NSString *)localID serverID:(NSString *)serverID;
@end
