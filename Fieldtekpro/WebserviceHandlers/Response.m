//
//  Response.m
//  PMCockpit
//
//  Created by Shyam Chandar on 14/03/15.
//  Copyright (c) 2015 Enstrapp IT Solutions. All rights reserved.
//

#import "Response.h"
 
#import "AppDelegate.h"
 #import "ResponseODATA.h"

@implementation Response
static Response *sharedInstance = nil;

@synthesize defaults,idString,nameString,workcenterString,plantIdString,catalogProfileIdstring;

//static dispatch_once_t onceTokenResponse;
+ (id)sharedInstance
{
    if (sharedInstance == nil)
    {
 
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        
        if ([[defaults objectForKey:@"ENDPOINT"] isEqual:@"SOAP"])
        {
            sharedInstance = [[Response alloc] init];
            
        }
        else{
             sharedInstance = [[ResponseODATA alloc] init];
         }
        
     }
     return sharedInstance;
}

+ (void)clearSharedInstance
{
    sharedInstance = nil;
}

+ (NSString *)actionWithWebServiceResponse:(WebServiceRequest)requestId{
    switch (requestId) {
            
        case LOGIN:
            return @"n0:ZemtPmAuthnticateLoginDataResponse";
            break;
        case GET_ACTIVITY_TYPE:
            return @"n0:ZemtPmGetActivityTypeResponse";
            break;
        case GET_SYNC_MAP_DATA:
            return @"n0:ZemtPmGetSyncMapDataResponse";
            break;
        case GET_APP_SETTINGS:
            return @"n0:ZemtPmGetAppSettingsResponse";
            break;
        case NOTIFICATION_TYPES:
            return @"n0:ZemtPmGetNotifTypesResponse";
            break;
        case NOTIFICATION_PRIORITY_TYPES:
            return @"n0:ZemtPmGetNotifPriorityResponse";
            break;
        case ORDER_PRIORITY_TYPES:
            return @"n0:ZemtPmGetOrdPriorityResponse";
            break;
        case ORDER_TYPES:
            return @"n0:ZemtPmGetOrdTypesResponse";
            break;
        case ACCIND_TYPES:
            return @"n0:ZemtPmGetOrdAccIndResponse";
            break;
        case GET_UNITS:
            return @"n0:ZemtPmGetUnitsResponse";
            break;
        case COSTCENTER_LIST:
            return @"n0:ZemtPmListCostCenterResponse";
            break;
        case ALLNOTIFICATION_CODES:
            return @"n0:ZemtPmGetNotifCodesAllResponse";
            break;
        case USER_DATA:
            return @"n0:ZemtPmGetUserDataResponse";
            break;
        case USER_FUNCTION:
            return @"n0:ZemtPmGetUserFunctionResponse";
            break;
        case GET_LIST_OF_PLANTS:
            return @"n0:ZemtPmGetPlantsResponse";
            break;
        case GET_LIST_OF_STORAGELOCATION:
            return @"n0:ZemtPmGetSlocResponse";
            break;
        case FUNCTIONLOC_COSTCENTER:
            return @"n0:ZemtPmSearchFlocResponse";
            break;
        case FUNCTIONLOC_EQUIPMENT:
            return @"pmGetFlocFromEquiResponse";
            break;
        case EQUIPMENT_COSTCENTER:
            return @"n0:ZemtPmSearchEquipResponse";
            break;
        case EQUIPMENT_FUNCLOC:
            return @"pmGetEquiinsFromFlocResponse";
            break;
        case SEARCH_FUNCLOC_EQUIPMENTS:
            return @"n0:ZemtPmSearchFlocEquipResponse";
            break;
        case GET_LIST_OF_COMPONENTS:
            return @"n0:ZemtPmListOfComponentsResponse";
            break;
        case GET_LIST_OF_MOVEMENTTYPES:
            return @"n0:ZemtPmListMovementTypesResponse";
            break;
        case GET_LIST_OF_WORKCENTER:
            return @"n0:ZemtPmGetWkctrResponse";
            break;
        case NOTIFICATION_CREATE:
            return @"n0:ZemtPmCreateNotificationResponse";
            break;
        case GET_LIST_OF_NOTIFICATIONS:
            return @"n0:ZemtPmListNotificationResponse";
            break;
        case GET_LIST_OF_OPEN_NOTIFICATIONS:
            return @"n0:ZemtPmListOpenNotificationResponse";
            break;
        case GET_LIST_OF_DUE_NOTIFICATIONS:
            return @"n0:ZemtPmDueNotificationResponse";
            break;
        case NOTIFICATION_CHANGE:
            return @"n0:ZemtPmChangeNotificationResponse";
            break;
        case NOTIFICATION_CANCEL:
            return @"n0:ZemtPmCancelNotificationResponse";
            break;
        case NOTIFICATION_COMPLETE:
            return @"n0:ZemtPmNotifCompleteResponse";
            break;
        case ORDER_CREATE:
            return @"n0:ZemtPmCreateServiceOrdResponse";
            break;
        case GET_LIST_OF_ORDERS:
            return @"n0:ZemtPmListOfOrderResponse";
            break;
        case GET_LIST_OF_OPEN_ORDERS:
            return @"n0:ZemtPmSearchOpenOrdersResponse";
            break;
        case GET_LIST_OF_DUE_ORDERS:
            return @"n0:ZemtPmDueOrdersResponse";
            break;
        case ORDER_CHANGE:
            return @"n0:ZemtPmChangeServiceOrdResponse";
            break;
        case ORDER_CANCEL:
            return @"n0:ZemtPmCancelServiceOrdResponse";
            break;
        case ORDER_CONFIRM:
            return @"n0:ZemtPmConfirmOrderResponse";
            break;
        case GET_LIST_OF_PM_BOMS:
            return @"n0:ZemtPmListOfEqbomsResponse";
            break;
        case UTILITY_RESERVE:
            return @"n0:ZemtPmReservBomCompResponse";
            break;
        case GET_STOCK_DATA:
            return @"n0:ZemtPmGetStockDataResponse";
            break;
        case GET_LOG_DATA:
            return @"n0:ZemtPmGetLogDataResponse";
            break;
        case GET_MATERIAL_AVAILABILITY_CHECK:
            return @"n0:ZemtPmMatAvailCheckResponse";
            break;
        case GET_PERMITS_DATA:
            return @"n0:ZemtPm_GET_PERMITS_ALLResponse";
            break;
        case GET_CUSTOM_FIELDS:
            return @"n0:ZemtPmGetCustomFieldsResponse";
            break;
        case GET_CONFRIM_REASON:
            return @"n0:ZemtPmGetConfReasonResponse";
            break;
        case GET_VALUE_HELPS:
            return @"n0:ZemtPmGetVhlpDataResponse";
            break;
        case GET_LOAD_SETTINGS:
            return @"n0:ZemtPmGetLoadSettingsResponse";
            break;
        case GET_DOCUMENTS:
            return @"n0:ZemtPmGetDocUrlResponse";
            break;
        case GET_NOTIFICATIONNO_DETAILS:
            return @"n0:ZemtPmNotifGetDetailMResponse";
            break;
        case GET_ORDERNO_DETAILS:
            return @"n0:ZemtPmOrderGetDetailMResponse";
            break;
        case CREATE_NOTIF_ORDER:
            return @"n0:ZemtPmCreateNotifOrderResponse";
            break;
        case GET_AUTH_DATA:
            return @"n0:ZemtPmGetAuthDataResponse";
            break;
        case GET_SETTINGS_DATA:
            return @"n0:ZemtPmGetSettingsDataResponse";
            break;
        case SEARCH_PLANTMAINT:
            return @"n0:ZemtPmGetMsoDataResponse";
            break;
        case ORDER_COLLECTIVE_CONFIRMATION:
            return @"n0:ZemtPmConfirmOrderCollResponse";
            break;
        case GET_WSM_MASTERDATA:
            return @"n0:ZemtPmWsmGetMasterDataResponse";
            break;
        case MAINTAINANCE_SET_CHECK_LIST:
            return @"n0:ZemtPmappSetMchkListResponse";
            break;
        case MAINTAINANCE_GET_CHECK_LIST:
            return @"n0:ZemtPmappGetMchkListResponse";
            break;
        case GET_NFC_SETTINGS:
            return @"n0:ZemtPmGetNfcSettingsResponse";
            break;
        case MONITOR_EQUIP_HISTORY:
            return @"n0:ZemtPmGetEquiHistoryResponse";
            break;
            
        case MONITOR_GET_EQUIP_MDOCS:
            return @"n0:ZemtPmGetMeasdocEquiResponse";
            break;
            
        case MONITOR_SET_EQUIP_MDOCS:
            return @"n0:ZemtPmMeasdocProcessResponse";
            break;
            
        case NOTIFICATION_RELEASE:
            return @"n0:ZemtPmNotifReleaseResponse";
            break;
            
        case ORDER_RELEASE:
            return @"n0:ZemtPmOrderReleaseResponse";
            break;
            
        case ORDER_MDOCS:
            return @"n0:ZemtPmSearchImpttResponse";
            break;
            
        case INSPECTION_MPLAN:
            return @"n0:ZemtPmGetEquiMsoDataResponse";
            break;
            
        case DEVICE_TOKEN:
            return @"n0:ZemtMsGetDeviceTokenResponse";
            break;
            
        default:
            return @"";
            break;
    }
}

#pragma - Response for different Functions

- (NSMutableDictionary *)parseForLogin:(NSDictionary *)resultDictionary
{
    NSMutableDictionary *xmlDoc = [NSMutableDictionary dictionary];
    NSDictionary *parseDictionary;
    if ([resultDictionary objectForKey:@"env:Body"]) {
        
        parseDictionary = [resultDictionary objectForKey:@"env:Body"];
        
        if ([parseDictionary objectForKey:[Response actionWithWebServiceResponse:LOGIN]]) {
            parseDictionary = [parseDictionary objectForKey:[Response actionWithWebServiceResponse:LOGIN]];
            
            if ([parseDictionary objectForKey:@"EvFailed"]) {
                [xmlDoc setObject:[parseDictionary objectForKey:@"EvFailed"] forKey:@"FAILED"];
            }
            if ([parseDictionary objectForKey:@"EvMessage"]) {
                parseDictionary = [parseDictionary objectForKey:@"EvMessage"];
                if ([parseDictionary objectForKey:@"Message"]) {
                    [xmlDoc setObject:[parseDictionary objectForKey:@"Message"] forKey:@"message"];
                }
            }
        }
        return xmlDoc;
    }
    return [NSMutableDictionary dictionary];
}

- (NSMutableDictionary *)parseForSyncMapData:(NSDictionary *)resultDictionary
{
    NSMutableDictionary *xmlDoc = [NSMutableDictionary dictionary];
    NSDictionary *parseDictionary;
    if ([resultDictionary objectForKey:@"env:Body"]) {
        
        parseDictionary = [resultDictionary objectForKey:@"env:Body"];
        if ([parseDictionary objectForKey:[Response actionWithWebServiceResponse:GET_SYNC_MAP_DATA]]) {
            parseDictionary = [parseDictionary objectForKey:[Response actionWithWebServiceResponse:GET_SYNC_MAP_DATA]];
            
            if ([parseDictionary objectForKey:@"EtSyncMap"]) {
                parseDictionary = [parseDictionary objectForKey:@"EtSyncMap"];
                if ([parseDictionary objectForKey:@"item"]) {
                    parseDictionary = [parseDictionary objectForKey:@"item"];
                    if ([parseDictionary isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parseDictionary] forKey:@"result"];
                    }
                    else if([parseDictionary isKindOfClass:[NSArray class]])
                    {
                        id result = parseDictionary;
                        
                        [[DataBase sharedInstance] deleteSyncMapData];
                        
                        for (int i =0; i<[result count]; i++) {
                            NSString *endPointString = [[result objectAtIndex:i] objectForKey:@"Endpoint"];
                            
                            id tempResult = [[result objectAtIndex:i] objectForKey:@"EndpointDetails"];
                            
                            if ([tempResult objectForKey:@"item"]) {
                                tempResult = [tempResult objectForKey:@"item"];
                            }
                            
                            [[DataBase sharedInstance] insertSyncMapData:tempResult :[endPointString uppercaseString]];
                        }
                    }
                }
            }
        }
    }
    
    return [NSMutableDictionary dictionary];
}

- (NSMutableDictionary *)parseForLoadSettings:(NSDictionary *)resultDictionary
{
    NSMutableDictionary *xmlDoc = [NSMutableDictionary dictionary];
    NSDictionary *parseDictionary;
    if ([resultDictionary objectForKey:@"env:Body"]) {
        
        parseDictionary = [resultDictionary objectForKey:@"env:Body"];
        if ([parseDictionary objectForKey:[Response actionWithWebServiceResponse:GET_LOAD_SETTINGS]]) {
            parseDictionary = [parseDictionary objectForKey:[Response actionWithWebServiceResponse:GET_LOAD_SETTINGS]];
            if ([parseDictionary objectForKey:@"EsIload"]) {
                if ([[parseDictionary objectForKey:@"EsIload"] isKindOfClass:[NSDictionary class]]) {
                    [xmlDoc setObject:[NSMutableArray arrayWithObject:[parseDictionary objectForKey:@"EsIload"]] forKey:@"resultILoad"];
                }
                else if([[parseDictionary objectForKey:@"EsIload"] isKindOfClass:[NSArray class]])
                {
                    [xmlDoc setObject:[parseDictionary objectForKey:@"EsIload"] forKey:@"resultILoad"];
                }
            }
            
            if ([parseDictionary objectForKey:@"EsRefresh"]) {
                if ([[parseDictionary objectForKey:@"EsRefresh"] isKindOfClass:[NSDictionary class]]) {
                    [xmlDoc setObject:[NSMutableArray arrayWithObject:[parseDictionary objectForKey:@"EsRefresh"]] forKey:@"resultRefresh"];
                }
                else if([[parseDictionary objectForKey:@"EsRefresh"] isKindOfClass:[NSArray class]])
                {
                    [xmlDoc setObject:[parseDictionary objectForKey:@"EsRefresh"] forKey:@"resultRefresh"];
                }
            }
            
            return xmlDoc;
        }
    }
    
    return [NSMutableDictionary dictionary];
}

- (NSMutableDictionary *)parseForValueHelps:(NSDictionary *)resultDictionary
{
    NSMutableDictionary *xmlDoc = [NSMutableDictionary dictionary];
    NSDictionary *parseDictionary;
    if ([resultDictionary objectForKey:@"env:Body"]) {
        
        parseDictionary = [resultDictionary objectForKey:@"env:Body"];
        if ([parseDictionary objectForKey:[Response actionWithWebServiceResponse:GET_VALUE_HELPS]]) {
            parseDictionary = [parseDictionary objectForKey:[Response actionWithWebServiceResponse:GET_VALUE_HELPS]];
            ///// Removed form this
            
            ////////////////
            
            if ([parseDictionary objectForKey:@"EsWsmObjavail"]) {
                if ([[parseDictionary objectForKey:@"EsWsmObjavail"] isKindOfClass:[NSDictionary class]]) {
                    [xmlDoc setObject:[NSMutableArray arrayWithObject:[parseDictionary objectForKey:@"EsWsmObjavail"]] forKey:@"resultWSMObjAvail"];
                }
                else if ([[parseDictionary objectForKey:@"EsWsmObjavail"] isKindOfClass:[NSArray class]]){
                    
                    [xmlDoc setObject:[parseDictionary objectForKey:@"EsWsmObjavail"] forKey:@"resultWSMObjAvail"];
                }
            }
            
            if ([parseDictionary objectForKey:@"EtWsmDocument"]) {
                if ([[parseDictionary objectForKey:@"EtWsmDocument"] isKindOfClass:[NSDictionary class]]) {
                    [xmlDoc setObject:[NSMutableArray arrayWithObject:[parseDictionary objectForKey:@"EtWsmDocument"]] forKey:@"resultWSMDocument"];
                }
                else if ([[parseDictionary objectForKey:@"EtWsmDocument"] isKindOfClass:[NSArray class]]){
                    
                    [xmlDoc setObject:[parseDictionary objectForKey:@"EtWsmDocument"] forKey:@"resultWSMDocument"];
                }
            }
            
            
            if ([parseDictionary objectForKey:@"EtWsmEqui"]) {
                if ([[parseDictionary objectForKey:@"EtWsmEqui"] isKindOfClass:[NSDictionary class]]) {
                    [xmlDoc setObject:[NSMutableArray arrayWithObject:[parseDictionary objectForKey:@"EtWsmEqui"]] forKey:@"resultWSMEqui"];
                }
                else if ([[parseDictionary objectForKey:@"EtWsmEqui"] isKindOfClass:[NSArray class]]){
                    
                    [xmlDoc setObject:[parseDictionary objectForKey:@"EtWsmEqui"] forKey:@"resultWSMEqui"];
                }
            }
            
            
            if ([parseDictionary objectForKey:@"EtWsmMaterial"]) {
                if ([[parseDictionary objectForKey:@"EtWsmMaterial"] isKindOfClass:[NSDictionary class]]) {
                    [xmlDoc setObject:[NSMutableArray arrayWithObject:[parseDictionary objectForKey:@"EtWsmMaterial"]] forKey:@"resultWSMMaterial"];
                }
                else if ([[parseDictionary objectForKey:@"EtWsmMaterial"] isKindOfClass:[NSArray class]]){
                    
                    [xmlDoc setObject:[parseDictionary objectForKey:@"EtWsmMaterial"] forKey:@"resultWSMMaterial"];
                }
            }
            
            if ([parseDictionary objectForKey:@"EtWsmPermit"]) {
                if ([[parseDictionary objectForKey:@"EtWsmPermit"] isKindOfClass:[NSDictionary class]]) {
                    [xmlDoc setObject:[NSMutableArray arrayWithObject:[parseDictionary objectForKey:@"EtWsmPermit"]] forKey:@"resultWSMPermit"];
                }
                else if ([[parseDictionary objectForKey:@"EtWsmPermit"] isKindOfClass:[NSArray class]]){
                    
                    [xmlDoc setObject:[parseDictionary objectForKey:@"EtWsmPermit"] forKey:@"resultWSMPermit"];
                }
            }
            
            if ([parseDictionary objectForKey:@"EtWsmPlants"]) {
                if ([[parseDictionary objectForKey:@"EtWsmPlants"] isKindOfClass:[NSDictionary class]]) {
                    [xmlDoc setObject:[NSMutableArray arrayWithObject:[parseDictionary objectForKey:@"EtWsmPlants"]] forKey:@"resultWSMPlants"];
                }
                else if ([[parseDictionary objectForKey:@"EtWsmPlants"] isKindOfClass:[NSArray class]]){
                    
                    [xmlDoc setObject:[parseDictionary objectForKey:@"EtWsmPlants"] forKey:@"resultWSMPlants"];
                }
            }
            
            
            if ([parseDictionary objectForKey:@"EtWsmResponses"]) {
                if ([[parseDictionary objectForKey:@"EtWsmResponses"] isKindOfClass:[NSDictionary class]]) {
                    [xmlDoc setObject:[NSMutableArray arrayWithObject:[parseDictionary objectForKey:@"EtWsmResponses"]] forKey:@"resultWSMResponses"];
                }
                else if ([[parseDictionary objectForKey:@"EtWsmResponses"] isKindOfClass:[NSArray class]]){
                    
                    [xmlDoc setObject:[parseDictionary objectForKey:@"EtWsmResponses"] forKey:@"resultWSMResponses"];
                }
            }
            
            
            if ([parseDictionary objectForKey:@"EtWsmRisks"]) {
                if ([[parseDictionary objectForKey:@"EtWsmRisks"] isKindOfClass:[NSDictionary class]]) {
                    [xmlDoc setObject:[NSMutableArray arrayWithObject:[parseDictionary objectForKey:@"EtWsmRisks"]] forKey:@"resultWSMRisks"];
                }
                else if ([[parseDictionary objectForKey:@"EtWsmRisks"] isKindOfClass:[NSArray class]]){
                    
                    [xmlDoc setObject:[parseDictionary objectForKey:@"EtWsmRisks"] forKey:@"resultWSMRisks"];
                }
            }
            
            if ([parseDictionary objectForKey:@"EtWsmSafetymeas"]) {
                if ([[parseDictionary objectForKey:@"EtWsmSafetymeas"] isKindOfClass:[NSDictionary class]]) {
                    [xmlDoc setObject:[NSMutableArray arrayWithObject:[parseDictionary objectForKey:@"EtWsmSafetymeas"]] forKey:@"resultWSMSafetymeas"];
                }
                else if ([[parseDictionary objectForKey:@"EtWsmRisks"] isKindOfClass:[NSArray class]]){
                    
                    [xmlDoc setObject:[parseDictionary objectForKey:@"EtWsmSafetymeas"] forKey:@"resultWSMSafetymeas"];
                }
            }
            
            if ([parseDictionary objectForKey:@"EtWsmWcmr"]) {
                if ([[parseDictionary objectForKey:@"EtWsmWcmr"] isKindOfClass:[NSDictionary class]]) {
                    [xmlDoc setObject:[NSMutableArray arrayWithObject:[parseDictionary objectForKey:@"EtWsmWcmr"]] forKey:@"resultWSMWcmr"];
                }
                else if ([[parseDictionary objectForKey:@"EtWsmWcmr"] isKindOfClass:[NSArray class]]){
                    
                    [xmlDoc setObject:[parseDictionary objectForKey:@"EtWsmWcmr"] forKey:@"resultWSMWcmr"];
                }
            }
            
            ///////////////////
            
            if ([parseDictionary objectForKey:@"EsIload"]) {
                if ([[parseDictionary objectForKey:@"EsIload"] isKindOfClass:[NSDictionary class]]) {
                    [xmlDoc setObject:[NSMutableArray arrayWithObject:[parseDictionary objectForKey:@"EsIload"]] forKey:@"resultIOrder"];
                }
                else if([[parseDictionary objectForKey:@"EsIload"] isKindOfClass:[NSArray class]])
                {
                    [xmlDoc setObject:[parseDictionary objectForKey:@"EsIload"] forKey:@"resultIOrder"];
                }
            }
            
            if ([parseDictionary objectForKey:@"EsRefresh"]) {
                if ([[parseDictionary objectForKey:@"EsRefresh"] isKindOfClass:[NSDictionary class]]) {
                    [xmlDoc setObject:[NSMutableArray arrayWithObject:[parseDictionary objectForKey:@"EsRefresh"]] forKey:@"resultRefresh"];
                }
                else if([[parseDictionary objectForKey:@"EsRefresh"] isKindOfClass:[NSArray class]])
                {
                    [xmlDoc setObject:[parseDictionary objectForKey:@"EsRefresh"] forKey:@"resultRefresh"];
                }
            }
            ///////// till this?////////
            
            if ([parseDictionary objectForKey:@"EtLstar"]) {
                if ([[parseDictionary objectForKey:@"EtLstar"] objectForKey:@"item"]) {
                    if ([[[parseDictionary objectForKey:@"EtLstar"] objectForKey:@"item"] isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:[[parseDictionary objectForKey:@"EtLstar"] objectForKey:@"item"]] forKey:@"resultLstar"];
                    }
                    else if([[[parseDictionary objectForKey:@"EtLstar"] objectForKey:@"item"] isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:[[parseDictionary objectForKey:@"EtLstar"] objectForKey:@"item"] forKey:@"resultLstar"];
                    }
                }
            }
            
            if ([parseDictionary objectForKey:@"EtNotifEffect"]) {
                if ([[parseDictionary objectForKey:@"EtNotifEffect"] objectForKey:@"item"]) {
                    if ([[[parseDictionary objectForKey:@"EtNotifEffect"] objectForKey:@"item"] isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:[[parseDictionary objectForKey:@"EtNotifEffect"] objectForKey:@"item"]] forKey:@"resultNotifEffect"];
                    }
                    else if([[[parseDictionary objectForKey:@"EtNotifEffect"] objectForKey:@"item"] isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:[[parseDictionary objectForKey:@"EtNotifEffect"] objectForKey:@"item"] forKey:@"resultNotifEffect"];
                    }
                }
            }
            
            if ([parseDictionary objectForKey:@"EtNotifTypes"]) {
                if ([[parseDictionary objectForKey:@"EtNotifTypes"] objectForKey:@"item"]) {
                    if ([[[parseDictionary objectForKey:@"EtNotifTypes"] objectForKey:@"item"] isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:[[parseDictionary objectForKey:@"EtNotifTypes"] objectForKey:@"item"]] forKey:@"resultNotifTypes"];
                    }
                    else if([[[parseDictionary objectForKey:@"EtNotifTypes"] objectForKey:@"item"] isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:[[parseDictionary objectForKey:@"EtNotifTypes"] objectForKey:@"item"] forKey:@"resultNotifTypes"];
                    }
                }
            }
            
            if ([parseDictionary objectForKey:@"EtNotifPriority"]) {
                if ([[parseDictionary objectForKey:@"EtNotifPriority"] objectForKey:@"item"]) {
                    if ([[[parseDictionary objectForKey:@"EtNotifPriority"] objectForKey:@"item"] isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:[[parseDictionary objectForKey:@"EtNotifPriority"] objectForKey:@"item"]] forKey:@"resultNotifPriority"];
                    }
                    else if([[[parseDictionary objectForKey:@"EtNotifPriority"] objectForKey:@"item"] isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:[[parseDictionary objectForKey:@"EtNotifPriority"] objectForKey:@"item"] forKey:@"resultNotifPriority"];
                    }
                }
            }
            
            if ([parseDictionary objectForKey:@"EtOrdPriority"]) {
                if ([[parseDictionary objectForKey:@"EtOrdPriority"] objectForKey:@"item"]) {
                    if ([[[parseDictionary objectForKey:@"EtOrdPriority"] objectForKey:@"item"] isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:[[parseDictionary objectForKey:@"EtOrdPriority"] objectForKey:@"item"]] forKey:@"resultOrderPriority"];
                    }
                    else if([[[parseDictionary objectForKey:@"EtOrdPriority"] objectForKey:@"item"] isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:[[parseDictionary objectForKey:@"EtOrdPriority"] objectForKey:@"item"] forKey:@"resultOrderPriority"];
                    }
                }
            }
            
            if ([parseDictionary objectForKey:@"EtOrdSyscond"]) {
                if ([[parseDictionary objectForKey:@"EtOrdSyscond"] objectForKey:@"item"]) {
                    if ([[[parseDictionary objectForKey:@"EtOrdSyscond"] objectForKey:@"item"] isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:[[parseDictionary objectForKey:@"EtOrdSyscond"] objectForKey:@"item"]] forKey:@"resultOrderSystemCondition"];
                    }
                    else if([[[parseDictionary objectForKey:@"EtOrdSyscond"] objectForKey:@"item"] isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:[[parseDictionary objectForKey:@"EtOrdSyscond"] objectForKey:@"item"] forKey:@"resultOrderSystemCondition"];
                    }
                }
            }
            
            if ([parseDictionary objectForKey:@"EtOrdTypes"]) {
                if ([[parseDictionary objectForKey:@"EtOrdTypes"] objectForKey:@"item"]) {
                    if ([[[parseDictionary objectForKey:@"EtOrdTypes"] objectForKey:@"item"] isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:[[parseDictionary objectForKey:@"EtOrdTypes"] objectForKey:@"item"]] forKey:@"resultOrderTypes"];
                    }
                    else if([[[parseDictionary objectForKey:@"EtOrdTypes"] objectForKey:@"item"] isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:[[parseDictionary objectForKey:@"EtOrdTypes"] objectForKey:@"item"] forKey:@"resultOrderTypes"];
                    }
                }
            }
            
            if ([parseDictionary objectForKey:@"EtUnits"]) {
                if ([[parseDictionary objectForKey:@"EtUnits"] objectForKey:@"item"]) {
                    if ([[[parseDictionary objectForKey:@"EtUnits"] objectForKey:@"item"] isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:[[parseDictionary objectForKey:@"EtUnits"] objectForKey:@"item"]] forKey:@"resultUnits"];
                    }
                    else if([[[parseDictionary objectForKey:@"EtUnits"] objectForKey:@"item"] isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:[[parseDictionary objectForKey:@"EtUnits"] objectForKey:@"item"] forKey:@"resultUnits"];
                    }
                }
            }
            
            if ([parseDictionary objectForKey:@"EtKostl"]) {
                if ([[parseDictionary objectForKey:@"EtKostl"] objectForKey:@"item"]) {
                    if ([[[parseDictionary objectForKey:@"EtKostl"] objectForKey:@"item"] isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:[[parseDictionary objectForKey:@"EtKostl"] objectForKey:@"item"]] forKey:@"resultKostl"];
                    }
                    else if([[[parseDictionary objectForKey:@"EtKostl"] objectForKey:@"item"] isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:[[parseDictionary objectForKey:@"EtKostl"] objectForKey:@"item"] forKey:@"resultKostl"];
                    }
                }
            }
            
            if ([parseDictionary objectForKey:@"EtBemot"]) {
                if ([[parseDictionary objectForKey:@"EtBemot"] objectForKey:@"item"]) {
                    if ([[[parseDictionary objectForKey:@"EtBemot"] objectForKey:@"item"] isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:[[parseDictionary objectForKey:@"EtBemot"] objectForKey:@"item"]] forKey:@"resultBemot"];
                    }
                    else if([[[parseDictionary objectForKey:@"EtBemot"] objectForKey:@"item"] isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:[[parseDictionary objectForKey:@"EtBemot"] objectForKey:@"item"] forKey:@"resultBemot"];
                    }
                }
            }
            
            if ([parseDictionary objectForKey:@"EtNotifCodes"]) {
                if ([[parseDictionary objectForKey:@"EtNotifCodes"] objectForKey:@"item"]) {
                    if ([[[parseDictionary objectForKey:@"EtNotifCodes"] objectForKey:@"item"] isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:[[parseDictionary objectForKey:@"EtNotifCodes"] objectForKey:@"item"]] forKey:@"resultNotifCodes"];
                    }
                    else if([[[parseDictionary objectForKey:@"EtNotifCodes"] objectForKey:@"item"] isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:[[parseDictionary objectForKey:@"EtNotifCodes"] objectForKey:@"item"] forKey:@"resultNotifCodes"];
                    }
                }
            }
            
            
            if ([parseDictionary objectForKey:@"EtConfReason"]) {
                if ([[parseDictionary objectForKey:@"EtConfReason"] objectForKey:@"item"]) {
                    if ([[[parseDictionary objectForKey:@"EtConfReason"] objectForKey:@"item"] isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:[[parseDictionary objectForKey:@"EtConfReason"] objectForKey:@"item"]] forKey:@"resultConfReason"];
                    }
                    else if([[[parseDictionary objectForKey:@"EtConfReason"] objectForKey:@"item"] isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:[[parseDictionary objectForKey:@"EtConfReason"] objectForKey:@"item"] forKey:@"resultConfReason"];
                    }
                }
            }
            
            
            if ([parseDictionary objectForKey:@"EtPlants"]) {
                if ([[parseDictionary objectForKey:@"EtPlants"] objectForKey:@"item"]) {
                    if ([[[parseDictionary objectForKey:@"EtPlants"] objectForKey:@"item"] isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:[[parseDictionary objectForKey:@"EtPlants"] objectForKey:@"item"]] forKey:@"resultPlants"];
                    }
                    else if([[[parseDictionary objectForKey:@"EtPlants"] objectForKey:@"item"] isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:[[parseDictionary objectForKey:@"EtPlants"] objectForKey:@"item"] forKey:@"resultPlants"];
                    }
                }
            }
            
            if ([parseDictionary objectForKey:@"EtStloc"]) {
                if ([[parseDictionary objectForKey:@"EtStloc"] objectForKey:@"item"]) {
                    if ([[[parseDictionary objectForKey:@"EtStloc"] objectForKey:@"item"] isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:[[parseDictionary objectForKey:@"EtStloc"] objectForKey:@"item"]] forKey:@"resultStloc"];
                    }
                    else if([[[parseDictionary objectForKey:@"EtStloc"] objectForKey:@"item"] isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:[[parseDictionary objectForKey:@"EtStloc"] objectForKey:@"item"] forKey:@"resultStloc"];
                    }
                }
            }
            
            if ([parseDictionary objectForKey:@"EtMovementTypes"]) {
                if ([[parseDictionary objectForKey:@"EtMovementTypes"] objectForKey:@"item"]) {
                    if ([[[parseDictionary objectForKey:@"EtMovementTypes"] objectForKey:@"item"] isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:[[parseDictionary objectForKey:@"EtMovementTypes"] objectForKey:@"item"]] forKey:@"resultMovementTypes"];
                    }
                    else if([[[parseDictionary objectForKey:@"EtMovementTypes"] objectForKey:@"item"] isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:[[parseDictionary objectForKey:@"EtMovementTypes"] objectForKey:@"item"] forKey:@"resultMovementTypes"];
                    }
                }
            }
            
            if ([parseDictionary objectForKey:@"EtWkctrPlant"]) {
                if ([[parseDictionary objectForKey:@"EtWkctrPlant"] objectForKey:@"item"]) {
                    if ([[[parseDictionary objectForKey:@"EtWkctrPlant"] objectForKey:@"item"] isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:[[parseDictionary objectForKey:@"EtWkctrPlant"] objectForKey:@"item"]] forKey:@"resultWkctrPlant"];
                    }
                    else if([[[parseDictionary objectForKey:@"EtWkctrPlant"] objectForKey:@"item"] isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:[[parseDictionary objectForKey:@"EtWkctrPlant"] objectForKey:@"item"] forKey:@"resultWkctrPlant"];
                    }
                }
            }
            
            if ([parseDictionary objectForKey:@"EtPermits"]) {
                if ([[parseDictionary objectForKey:@"EtPermits"] objectForKey:@"item"]) {
                    if ([[[parseDictionary objectForKey:@"EtPermits"] objectForKey:@"item"] isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:[[parseDictionary objectForKey:@"EtPermits"] objectForKey:@"item"]] forKey:@"resultPermits"];
                    }
                    else if([[[parseDictionary objectForKey:@"EtPermits"] objectForKey:@"item"] isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:[[parseDictionary objectForKey:@"EtPermits"] objectForKey:@"item"] forKey:@"resultPermits"];
                    }
                }
            }
            
            if ([parseDictionary objectForKey:@"EtFields"]) {
                if ([[parseDictionary objectForKey:@"EtFields"] objectForKey:@"item"]) {
                    if ([[[parseDictionary objectForKey:@"EtFields"] objectForKey:@"item"] isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:[[parseDictionary objectForKey:@"EtFields"] objectForKey:@"item"]] forKey:@"CustomFields"];
                    }
                    else if([[[parseDictionary objectForKey:@"EtFields"] objectForKey:@"item"] isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:[[parseDictionary objectForKey:@"EtFields"] objectForKey:@"item"] forKey:@"CustomFields"];
                    }
                }
            }
            
            if ([parseDictionary objectForKey:@"EtSteus"]) {
                if ([[parseDictionary objectForKey:@"EtSteus"] objectForKey:@"item"]) {
                    if ([[[parseDictionary objectForKey:@"EtSteus"] objectForKey:@"item"] isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:[[parseDictionary objectForKey:@"EtSteus"] objectForKey:@"item"]] forKey:@"resultControlKeys"];
                    }
                    else if([[[parseDictionary objectForKey:@"EtSteus"] objectForKey:@"item"] isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:[[parseDictionary objectForKey:@"EtSteus"] objectForKey:@"item"] forKey:@"resultControlKeys"];
                    }
                }
            }
            
            if ([parseDictionary objectForKey:@"EtTq80"]) {
                
                if ([[parseDictionary objectForKey:@"EtTq80"] objectForKey:@"item"]) {
                    if ([[[parseDictionary objectForKey:@"EtTq80"] objectForKey:@"item"] isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:[[parseDictionary objectForKey:@"EtTq80"] objectForKey:@"item"]] forKey:@"resultEtTq80"];
                    }
                    else if([[[parseDictionary objectForKey:@"EtTq80"] objectForKey:@"item"] isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:[[parseDictionary objectForKey:@"EtTq80"] objectForKey:@"item"] forKey:@"resultEtTq80"];
                    }
                }
            }
            
            ////wcm
            if ([parseDictionary objectForKey:@"EtWcmChkReq"]) {
                if ([[parseDictionary objectForKey:@"EtWcmChkReq"] objectForKey:@"item"]) {
                    if ([[[parseDictionary objectForKey:@"EtWcmChkReq"] objectForKey:@"item"] isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:[[parseDictionary objectForKey:@"EtWcmChkReq"] objectForKey:@"item"]] forKey:@"resultChkRequests"];
                    }
                    else if([[[parseDictionary objectForKey:@"EtWcmChkReq"] objectForKey:@"item"] isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:[[parseDictionary objectForKey:@"EtWcmChkReq"] objectForKey:@"item"] forKey:@"resultChkRequests"];
                    }
                }
            }
            
            
            if ([parseDictionary objectForKey:@"EtWcmTgtyp"]) {
                if ([[parseDictionary objectForKey:@"EtWcmTgtyp"] objectForKey:@"item"]) {
                    if ([[[parseDictionary objectForKey:@"EtWcmTgtyp"] objectForKey:@"item"] isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:[[parseDictionary objectForKey:@"EtWcmTgtyp"] objectForKey:@"item"]] forKey:@"resultWcmTgTypes"];
                    }
                    else if([[[parseDictionary objectForKey:@"EtWcmTgtyp"] objectForKey:@"item"] isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:[[parseDictionary objectForKey:@"EtWcmTgtyp"] objectForKey:@"item"] forKey:@"resultWcmTgTypes"];
                    }
                }
            }
            
            
            
            if ([parseDictionary objectForKey:@"EtWcmWcvp6"]) {
                if ([[parseDictionary objectForKey:@"EtWcmWcvp6"] objectForKey:@"item"]) {
                    if ([[[parseDictionary objectForKey:@"EtWcmWcvp6"] objectForKey:@"item"] isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:[[parseDictionary objectForKey:@"EtWcmWcvp6"] objectForKey:@"item"]] forKey:@"resultWcmWcvp6"];
                    }
                    else if([[[parseDictionary objectForKey:@"EtWcmWcvp6"] objectForKey:@"item"] isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:[[parseDictionary objectForKey:@"EtWcmWcvp6"] objectForKey:@"item"] forKey:@"resultWcmWcvp6"];
                    }
                }
            }
            
            if ([parseDictionary objectForKey:@"EtWcmTypes"]) {
                if ([[parseDictionary objectForKey:@"EtWcmTypes"] objectForKey:@"item"]) {
                    if ([[[parseDictionary objectForKey:@"EtWcmTypes"] objectForKey:@"item"] isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:[[parseDictionary objectForKey:@"EtWcmTypes"] objectForKey:@"item"]] forKey:@"resultWcmTypes"];
                    }
                    else if([[[parseDictionary objectForKey:@"EtWcmTypes"] objectForKey:@"item"] isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:[[parseDictionary objectForKey:@"EtWcmTypes"] objectForKey:@"item"] forKey:@"resultWcmTypes"];
                    }
                }
            }
            
            
            if ([parseDictionary objectForKey:@"EtIngrp"]) {
                if ([[parseDictionary objectForKey:@"EtIngrp"] objectForKey:@"item"]) {
                    if ([[[parseDictionary objectForKey:@"EtIngrp"] objectForKey:@"item"] isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:[[parseDictionary objectForKey:@"EtIngrp"] objectForKey:@"item"]] forKey:@"resultInGrp"];
                    }
                    else if([[[parseDictionary objectForKey:@"EtIngrp"] objectForKey:@"item"] isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:[[parseDictionary objectForKey:@"EtIngrp"] objectForKey:@"item"] forKey:@"resultInGrp"];
                    }
                }
            }
            
            
            
            if ([parseDictionary objectForKey:@"EtPernr"]) {
                if ([[parseDictionary objectForKey:@"EtPernr"] objectForKey:@"item"]) {
                    if ([[[parseDictionary objectForKey:@"EtPernr"] objectForKey:@"item"] isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:[[parseDictionary objectForKey:@"EtPernr"] objectForKey:@"item"]] forKey:@"resultPernr"];
                    }
                    else if([[[parseDictionary objectForKey:@"EtPernr"] objectForKey:@"item"] isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:[[parseDictionary objectForKey:@"EtPernr"] objectForKey:@"item"] forKey:@"resultPernr"];
                    }
                }
            }
            
            if ([parseDictionary objectForKey:@"EtWcmBegru"]) {
                if ([[parseDictionary objectForKey:@"EtWcmBegru"] objectForKey:@"item"]) {
                    if ([[[parseDictionary objectForKey:@"EtWcmBegru"] objectForKey:@"item"] isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:[[parseDictionary objectForKey:@"EtWcmBegru"] objectForKey:@"item"]] forKey:@"resultAuthorizationGroups"];
                    }
                    else if([[[parseDictionary objectForKey:@"EtWcmBegru"] objectForKey:@"item"] isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:[[parseDictionary objectForKey:@"EtWcmBegru"] objectForKey:@"item"] forKey:@"resultAuthorizationGroups"];
                    }
                }
            }
            
            
            
            if ([parseDictionary objectForKey:@"EtWcmUsages"]) {
                if ([[parseDictionary objectForKey:@"EtWcmUsages"] objectForKey:@"item"]) {
                    if ([[[parseDictionary objectForKey:@"EtWcmUsages"] objectForKey:@"item"] isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:[[parseDictionary objectForKey:@"EtWcmUsages"] objectForKey:@"item"]] forKey:@"resultUsages"];
                    }
                    else if([[[parseDictionary objectForKey:@"EtWcmUsages"] objectForKey:@"item"] isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:[[parseDictionary objectForKey:@"EtWcmUsages"] objectForKey:@"item"] forKey:@"resultUsages"];
                    }
                }
            }
            
            
            
            if ([parseDictionary objectForKey:@"EtWcmWork"]) {
                if ([[parseDictionary objectForKey:@"EtWcmWork"] objectForKey:@"item"]) {
                    if ([[[parseDictionary objectForKey:@"EtWcmWork"] objectForKey:@"item"] isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:[[parseDictionary objectForKey:@"EtWcmWork"] objectForKey:@"item"]] forKey:@"resultWcmWork"];
                    }
                    else if([[[parseDictionary objectForKey:@"EtWcmWork"] objectForKey:@"item"] isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:[[parseDictionary objectForKey:@"EtWcmWork"] objectForKey:@"item"] forKey:@"resultWcmWork"];
                    }
                }
            }
            
            
            
            if ([parseDictionary objectForKey:@"EtWcmReqm"]) {
                if ([[parseDictionary objectForKey:@"EtWcmReqm"] objectForKey:@"item"]) {
                    if ([[[parseDictionary objectForKey:@"EtWcmReqm"] objectForKey:@"item"] isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:[[parseDictionary objectForKey:@"EtWcmReqm"] objectForKey:@"item"]] forKey:@"resultWcmRequirements"];
                    }
                    else if([[[parseDictionary objectForKey:@"EtWcmReqm"] objectForKey:@"item"] isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:[[parseDictionary objectForKey:@"EtWcmReqm"] objectForKey:@"item"] forKey:@"resultWcmRequirements"];
                    }
                }
            }
            
            
            if ([parseDictionary objectForKey:@"EtUsers"]) {
                if ([[parseDictionary objectForKey:@"EtUsers"] objectForKey:@"item"]) {
                    if ([[[parseDictionary objectForKey:@"EtUsers"] objectForKey:@"item"] isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:[[parseDictionary objectForKey:@"EtUsers"] objectForKey:@"item"]] forKey:@"resultEtUserTokenId"];
                    }
                    else if([[[parseDictionary objectForKey:@"EtUsers"] objectForKey:@"item"] isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:[[parseDictionary objectForKey:@"EtUsers"] objectForKey:@"item"] forKey:@"resultEtUserTokenId"];
                    }
                }
            }
            
            
            
            if ([parseDictionary objectForKey:@"EtMeasCodes"]) {
                if ([[parseDictionary objectForKey:@"EtMeasCodes"] objectForKey:@"item"]) {
                    if ([[[parseDictionary objectForKey:@"EtMeasCodes"] objectForKey:@"item"] isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:[[parseDictionary objectForKey:@"EtMeasCodes"] objectForKey:@"item"]] forKey:@"resultInpectionmeasDocs"];
                    }
                    else if([[[parseDictionary objectForKey:@"EtMeasCodes"] objectForKey:@"item"] isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:[[parseDictionary objectForKey:@"EtMeasCodes"] objectForKey:@"item"] forKey:@"resultInpectionmeasDocs"];
                    }
                }
            }
            
        }
        
        return xmlDoc;
    }
    return [NSMutableDictionary dictionary];
}


- (NSMutableDictionary *)parseForActivityType:(NSDictionary *)resultDictionary
{
    NSMutableDictionary *xmlDoc = [NSMutableDictionary dictionary];
    NSDictionary *parseDictionary;
    if ([resultDictionary objectForKey:@"env:Body"]) {
        
        parseDictionary = [resultDictionary objectForKey:@"env:Body"];
        if ([parseDictionary objectForKey:[Response actionWithWebServiceResponse:GET_VALUE_HELPS]]) {
            parseDictionary = [parseDictionary objectForKey:[Response actionWithWebServiceResponse:GET_VALUE_HELPS]];
            
            if ([parseDictionary objectForKey:@"EtLstar"]) {
                parseDictionary = [parseDictionary objectForKey:@"EtLstar"];
                if ([parseDictionary objectForKey:@"item"]) {
                    parseDictionary = [parseDictionary objectForKey:@"item"];
                    if ([parseDictionary isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parseDictionary] forKey:@"result"];
                    }
                    else if([parseDictionary isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parseDictionary forKey:@"result"];
                    }
                }
                
                return xmlDoc;
            }
        }
        
        return xmlDoc;
    }
    
    return [NSMutableDictionary dictionary];
}

- (NSMutableDictionary *)parseForAppSettings:(NSDictionary *)resultDictionary
{
    NSMutableDictionary *xmlDoc = [NSMutableDictionary dictionary];
    NSDictionary *parseDictionary;
    if ([resultDictionary objectForKey:@"env:Body"]) {
        
        parseDictionary = [resultDictionary objectForKey:@"env:Body"];
        if ([parseDictionary objectForKey:[Response actionWithWebServiceResponse:GET_APP_SETTINGS]]) {
            parseDictionary = [parseDictionary objectForKey:[Response actionWithWebServiceResponse:GET_APP_SETTINGS]];
            
            if ([parseDictionary objectForKey:@"EsAppData"]) {
                parseDictionary = [parseDictionary objectForKey:@"EsAppData"];
                if ([parseDictionary isKindOfClass:[NSDictionary class]]) {
                    [xmlDoc setObject:[NSMutableArray arrayWithObject:parseDictionary] forKey:@"resultAppData"];
                }
                else if([parseDictionary isKindOfClass:[NSArray class]])
                {
                    [xmlDoc setObject:parseDictionary forKey:@"resultAppData"];
                }
                return xmlDoc;
            }
        }
        
        return xmlDoc;
    }
    
    return [NSMutableDictionary dictionary];
}

- (NSMutableDictionary *)parseForNFCSettings:(NSDictionary *)resultDictionary
{
    NSMutableDictionary *xmlDoc = [NSMutableDictionary dictionary];
    NSDictionary *parseDictionary;
    if ([resultDictionary objectForKey:@"env:Body"]) {
        
        parseDictionary = [resultDictionary objectForKey:@"env:Body"];
        if ([parseDictionary objectForKey:[Response actionWithWebServiceResponse:GET_NFC_SETTINGS]]) {
            parseDictionary = [parseDictionary objectForKey:[Response actionWithWebServiceResponse:GET_NFC_SETTINGS]];
            
            if ([parseDictionary objectForKey:@"EtNfc"]) {
                parseDictionary = [parseDictionary objectForKey:@"EtNfc"];
                if ([parseDictionary objectForKey:@"item"]) {
                    parseDictionary = [parseDictionary objectForKey:@"item"];
                    if ([parseDictionary isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parseDictionary] forKey:@"resultNFC"];
                    }
                    else if([parseDictionary isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parseDictionary forKey:@"resultNFC"];
                    }
                }
                
                return xmlDoc;
            }
        }
    }
    return [NSMutableDictionary dictionary];
}


-(NSMutableDictionary *)parseForDeviceToken:(NSDictionary *)resultDictionary{
    
    NSMutableDictionary *xmlDoc = [NSMutableDictionary dictionary];
    NSDictionary *parseDictionary;
    if ([resultDictionary objectForKey:@"env:Body"]) {
        
        parseDictionary = [resultDictionary objectForKey:@"env:Body"];
        if ([parseDictionary objectForKey:[Response actionWithWebServiceResponse:DEVICE_TOKEN]]) {
            parseDictionary = [parseDictionary objectForKey:[Response actionWithWebServiceResponse:DEVICE_TOKEN]];
            
            if ([parseDictionary objectForKey:@"EtNfc"]) {
                parseDictionary = [parseDictionary objectForKey:@"EtNfc"];
                if ([parseDictionary objectForKey:@"item"]) {
                    parseDictionary = [parseDictionary objectForKey:@"item"];
                    if ([parseDictionary isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parseDictionary] forKey:@"resultNFC"];
                    }
                    else if([parseDictionary isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parseDictionary forKey:@"resultNFC"];
                    }
                }
                
                return xmlDoc;
            }
        }
    }
    return [NSMutableDictionary dictionary];
    
}


- (NSMutableDictionary *)parseForNotifTypes:(NSDictionary *)resultDictionary
{
    NSMutableDictionary *xmlDoc = [NSMutableDictionary dictionary];
    NSDictionary *parseDictionary;
    if ([resultDictionary objectForKey:@"env:Body"]) {
        
        parseDictionary = [resultDictionary objectForKey:@"env:Body"];
        if ([parseDictionary objectForKey:[Response actionWithWebServiceResponse:GET_VALUE_HELPS]]) {
            parseDictionary = [parseDictionary objectForKey:[Response actionWithWebServiceResponse:GET_VALUE_HELPS]];
            
            if ([parseDictionary objectForKey:@"EtNotifTypes"]) {
                parseDictionary = [parseDictionary objectForKey:@"EtNotifTypes"];
                if ([parseDictionary objectForKey:@"item"]) {
                    parseDictionary = [parseDictionary objectForKey:@"item"];
                    if ([parseDictionary isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parseDictionary] forKey:@"result"];
                    }
                    else if([parseDictionary isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parseDictionary forKey:@"result"];
                    }
                }
                return xmlDoc;
            }
        }
    }
    return [NSMutableDictionary dictionary];
}

- (NSMutableDictionary *)parseForNotifPriorityTypes:(NSDictionary *)resultDictionary
{
    NSMutableDictionary *xmlDoc = [NSMutableDictionary dictionary];
    NSDictionary *parseDictionary;
    if ([resultDictionary objectForKey:@"env:Body"]) {
        
        parseDictionary = [resultDictionary objectForKey:@"env:Body"];
        if ([parseDictionary objectForKey:[Response actionWithWebServiceResponse:GET_VALUE_HELPS]]) {
            parseDictionary = [parseDictionary objectForKey:[Response actionWithWebServiceResponse:GET_VALUE_HELPS]];
            if ([parseDictionary objectForKey:@"EtNotifPriority"]) {
                parseDictionary = [parseDictionary objectForKey:@"EtNotifPriority"];
                if ([parseDictionary objectForKey:@"item"]) {
                    parseDictionary = [parseDictionary objectForKey:@"item"];
                    if ([parseDictionary isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parseDictionary] forKey:@"result"];
                    }
                    else if([parseDictionary isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parseDictionary forKey:@"result"];
                    }
                }
                return xmlDoc;
            }
        }
    }
    return [NSMutableDictionary dictionary];
}

- (NSMutableDictionary *)parseForOrderPriorityTypes:(NSDictionary *)resultDictionary
{
    NSMutableDictionary *xmlDoc = [NSMutableDictionary dictionary];
    NSDictionary *parseDictionary;
    if ([resultDictionary objectForKey:@"env:Body"]) {
        
        parseDictionary = [resultDictionary objectForKey:@"env:Body"];
        if ([parseDictionary objectForKey:[Response actionWithWebServiceResponse:GET_VALUE_HELPS]]) {
            parseDictionary = [parseDictionary objectForKey:[Response actionWithWebServiceResponse:GET_VALUE_HELPS]];
            if ([parseDictionary objectForKey:@"EtOrdPriority"]) {
                parseDictionary = [parseDictionary objectForKey:@"EtOrdPriority"];
                if ([parseDictionary objectForKey:@"item"]) {
                    parseDictionary = [parseDictionary objectForKey:@"item"];
                    if ([parseDictionary isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parseDictionary] forKey:@"result"];
                    }
                    else if([parseDictionary isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parseDictionary forKey:@"result"];
                    }
                }
                return xmlDoc;
            }
        }
    }
    return [NSMutableDictionary dictionary];
}

- (NSMutableDictionary *)parseForOrderTypes:(NSDictionary *)resultDictionary
{
    NSMutableDictionary *xmlDoc = [NSMutableDictionary dictionary];
    NSDictionary *parseDictionary;
    if ([resultDictionary objectForKey:@"env:Body"]) {
        
        parseDictionary = [resultDictionary objectForKey:@"env:Body"];
        if ([parseDictionary objectForKey:[Response actionWithWebServiceResponse:GET_VALUE_HELPS]]) {
            parseDictionary = [parseDictionary objectForKey:[Response actionWithWebServiceResponse:GET_VALUE_HELPS]];
            if ([parseDictionary objectForKey:@"EtOrdTypes"]) {
                parseDictionary = [parseDictionary objectForKey:@"EtOrdTypes"];
                if ([parseDictionary objectForKey:@"item"]) {
                    parseDictionary = [parseDictionary objectForKey:@"item"];
                    if ([parseDictionary isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parseDictionary] forKey:@"result"];
                    }
                    else if([parseDictionary isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parseDictionary forKey:@"result"];
                    }
                }
                return xmlDoc;
            }
        }
    }
    return [NSMutableDictionary dictionary];
}

- (NSMutableDictionary *)parseForGetUnits:(NSDictionary *)resultDictionary
{
    NSMutableDictionary *xmlDoc = [NSMutableDictionary dictionary];
    NSDictionary *parseDictionary;
    if ([resultDictionary objectForKey:@"env:Body"]) {
        
        parseDictionary = [resultDictionary objectForKey:@"env:Body"];
        if ([parseDictionary objectForKey:[Response actionWithWebServiceResponse:GET_VALUE_HELPS]]) {
            parseDictionary = [parseDictionary objectForKey:[Response actionWithWebServiceResponse:GET_VALUE_HELPS]];
            if ([parseDictionary objectForKey:@"EtUnits"]) {
                parseDictionary = [parseDictionary objectForKey:@"EtUnits"];
                if ([parseDictionary objectForKey:@"item"]) {
                    parseDictionary = [parseDictionary objectForKey:@"item"];
                    if ([parseDictionary isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parseDictionary] forKey:@"result"];
                    }
                    else if([parseDictionary isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parseDictionary forKey:@"result"];
                    }
                }
                return xmlDoc;
            }
        }
    }
    return [NSMutableDictionary dictionary];
}

- (NSMutableDictionary *)parseForCostCenterList:(NSDictionary *)resultDictionary
{
    NSMutableDictionary *xmlDoc = [NSMutableDictionary dictionary];
    NSDictionary *parseDictionary;
    
    parseDictionary = [resultDictionary objectForKey:@"env:Body"];
    
    if ([parseDictionary objectForKey:[Response actionWithWebServiceResponse:GET_VALUE_HELPS]]) {
        parseDictionary = [parseDictionary objectForKey:[Response actionWithWebServiceResponse:GET_VALUE_HELPS]];
        if ([parseDictionary objectForKey:@"EtKostl"]) {
            parseDictionary = [parseDictionary objectForKey:@"EtKostl"];
            if ([parseDictionary objectForKey:@"item"]) {
                parseDictionary = [parseDictionary objectForKey:@"item"];
                if ([parseDictionary isKindOfClass:[NSDictionary class]]) {
                    [xmlDoc setObject:[NSMutableArray arrayWithObject:parseDictionary] forKey:@"result"];
                }
                else if([parseDictionary isKindOfClass:[NSArray class]])
                {
                    [xmlDoc setObject:parseDictionary forKey:@"result"];
                }
            }
            return xmlDoc;
        }
    }
    return [NSMutableDictionary dictionary];
}

- (NSMutableDictionary *)parseForAccIndicator:(NSDictionary *)resultDictionary
{
    NSMutableDictionary *xmlDoc = [NSMutableDictionary dictionary];
    NSDictionary *parseDictionary;
    if ([resultDictionary objectForKey:@"env:Body"]) {
        
        parseDictionary = [resultDictionary objectForKey:@"env:Body"];
        if ([parseDictionary objectForKey:[Response actionWithWebServiceResponse:GET_VALUE_HELPS]]) {
            parseDictionary = [parseDictionary objectForKey:[Response actionWithWebServiceResponse:GET_VALUE_HELPS]];
            
            if ([parseDictionary objectForKey:@"EtBemot"]) {
                parseDictionary = [parseDictionary objectForKey:@"EtBemot"];
                if ([parseDictionary objectForKey:@"item"]) {
                    parseDictionary = [parseDictionary objectForKey:@"item"];
                    if ([parseDictionary isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parseDictionary] forKey:@"result"];
                    }
                    else if([parseDictionary isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parseDictionary forKey:@"result"];
                    }
                }
                return xmlDoc;
            }
        }
    }
    return [NSMutableDictionary dictionary];
}

- (NSMutableDictionary *)parseForALLNotifTypes:(NSDictionary *)resultDictionary
{
    NSMutableDictionary *xmlDoc = [NSMutableDictionary dictionary];
    NSDictionary *parseDictionary;
    if ([resultDictionary objectForKey:@"env:Body"]) {
        
        parseDictionary = [resultDictionary objectForKey:@"env:Body"];
        if ([parseDictionary objectForKey:[Response actionWithWebServiceResponse:GET_VALUE_HELPS]]) {
            parseDictionary = [parseDictionary objectForKey:[Response actionWithWebServiceResponse:GET_VALUE_HELPS]];
            
            if ([parseDictionary objectForKey:@"EtNotifCodes"]) {
                parseDictionary = [parseDictionary objectForKey:@"EtNotifCodes"];
                if ([parseDictionary objectForKey:@"item"]) {
                    parseDictionary = [parseDictionary objectForKey:@"item"];
                    if ([parseDictionary isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parseDictionary] forKey:@"result"];
                    }
                    else if([parseDictionary isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parseDictionary forKey:@"result"];
                    }
                }
                return xmlDoc;
            }
        }
    }
    return [NSMutableDictionary dictionary];
}

- (NSMutableDictionary *)parseForUserData:(NSDictionary *)resultDictionary
{
    NSMutableDictionary *xmlDoc = [NSMutableDictionary dictionary];
    NSDictionary *parseDictionary;
    if ([resultDictionary objectForKey:@"env:Body"]) {
        
        parseDictionary = [resultDictionary objectForKey:@"env:Body"];
        if ([parseDictionary objectForKey:[Response actionWithWebServiceResponse:GET_VALUE_HELPS]]) {
            parseDictionary = [parseDictionary objectForKey:[Response actionWithWebServiceResponse:GET_VALUE_HELPS]];
            
            if ([parseDictionary objectForKey:@"EsUser"]) {
                parseDictionary = [parseDictionary objectForKey:@"EsUser"];
                if ([parseDictionary isKindOfClass:[NSDictionary class]]) {
                    [xmlDoc setObject:[NSMutableArray arrayWithObject:parseDictionary] forKey:@"resultUser"];
                }
                else if([parseDictionary isKindOfClass:[NSArray class]])
                {
                    [xmlDoc setObject:parseDictionary forKey:@"resultUser"];
                }
                return xmlDoc;
            }
        }
    }
    return [NSMutableDictionary dictionary];
}

- (NSMutableDictionary *)parseForConfirmReason:(NSDictionary *)resultDictionary
{
    NSMutableDictionary *xmlDoc = [NSMutableDictionary dictionary];
    NSDictionary *parseDictionary;
    if ([resultDictionary objectForKey:@"env:Body"]) {
        
        parseDictionary = [resultDictionary objectForKey:@"env:Body"];
        if ([parseDictionary objectForKey:[Response actionWithWebServiceResponse:GET_VALUE_HELPS]]) {
            parseDictionary = [parseDictionary objectForKey:[Response actionWithWebServiceResponse:GET_VALUE_HELPS]];
            
            if ([parseDictionary objectForKey:@"EtConfReason"]) {
                parseDictionary = [parseDictionary objectForKey:@"EtConfReason"];
                if ([parseDictionary objectForKey:@"item"]) {
                    parseDictionary = [parseDictionary objectForKey:@"item"];
                    if ([parseDictionary isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parseDictionary] forKey:@"result"];
                    }
                    else if([parseDictionary isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parseDictionary forKey:@"result"];
                    }
                }
                return xmlDoc;
            }
        }
    }
    return [NSMutableDictionary dictionary];
}

- (NSMutableDictionary *)parseForUserFunction:(NSDictionary *)resultDictionary
{
    NSMutableDictionary *xmlDoc = [NSMutableDictionary dictionary];
    NSDictionary *parseDictionary;
    if ([resultDictionary objectForKey:@"env:Body"]) {
        
        parseDictionary = [resultDictionary objectForKey:@"env:Body"];
        if ([parseDictionary objectForKey:[Response actionWithWebServiceResponse:GET_VALUE_HELPS]]) {
            parseDictionary = [parseDictionary objectForKey:[Response actionWithWebServiceResponse:GET_VALUE_HELPS]];
            
            if ([parseDictionary objectForKey:@"EtMusrf"]) {
                parseDictionary = [parseDictionary objectForKey:@"EtMusrf"];
                if ([parseDictionary isKindOfClass:[NSDictionary class]]) {
                    [xmlDoc setObject:[NSMutableArray arrayWithObject:parseDictionary] forKey:@"MUserresult"];
                }
                else if([parseDictionary isKindOfClass:[NSArray class]])
                {
                    [xmlDoc setObject:parseDictionary forKey:@"MUserresult"];
                }
            }
            if ([parseDictionary objectForKey:@"EtScrf"]) {
                parseDictionary = [parseDictionary objectForKey:@"EtScrf"];
                if ([parseDictionary isKindOfClass:[NSDictionary class]]) {
                    [xmlDoc setObject:[NSMutableArray arrayWithObject:parseDictionary] forKey:@"Scrfresult"];
                }
                else if([parseDictionary isKindOfClass:[NSArray class]])
                {
                    [xmlDoc setObject:parseDictionary forKey:@"Scrfresult"];
                }
            }
            if ([parseDictionary objectForKey:@"EtUsrf"]) {
                parseDictionary = [parseDictionary objectForKey:@"EtUsrf"];
                if ([parseDictionary isKindOfClass:[NSDictionary class]]) {
                    [xmlDoc setObject:[NSMutableArray arrayWithObject:parseDictionary] forKey:@"Usrfresult"];
                }
                else if([parseDictionary isKindOfClass:[NSArray class]])
                {
                    [xmlDoc setObject:parseDictionary forKey:@"Usrfresult"];
                }
            }
            
            return xmlDoc;
        }
    }
    
    return [NSMutableDictionary dictionary];
}

- (NSMutableDictionary *)parseForListOfPlants:(NSDictionary *)resultDictionary
{
    NSMutableDictionary *xmlDoc = [NSMutableDictionary dictionary];
    NSDictionary *parseDictionary;
    if ([resultDictionary objectForKey:@"env:Body"]) {
        
        parseDictionary = [resultDictionary objectForKey:@"env:Body"];
        if ([parseDictionary objectForKey:[Response actionWithWebServiceResponse:GET_VALUE_HELPS]]) {
            parseDictionary = [parseDictionary objectForKey:[Response actionWithWebServiceResponse:GET_VALUE_HELPS]];
            
            if ([parseDictionary objectForKey:@"EtPlants"]) {
                parseDictionary = [parseDictionary objectForKey:@"EtPlants"];
                if ([parseDictionary objectForKey:@"item"]) {
                    parseDictionary = [parseDictionary objectForKey:@"item"];
                    if ([parseDictionary isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parseDictionary] forKey:@"result"];
                    }
                    else if([parseDictionary isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parseDictionary forKey:@"result"];
                    }
                    return xmlDoc;
                }
            }
        }
    }
    return [NSMutableDictionary dictionary];
}

- (NSMutableDictionary *)parseForListOfStorageLocation:(NSDictionary *)resultDictionary
{
    NSMutableDictionary *xmlDoc = [NSMutableDictionary dictionary];
    NSDictionary *parseDictionary;
    if ([resultDictionary objectForKey:@"env:Body"]) {
        
        parseDictionary = [resultDictionary objectForKey:@"env:Body"];
        if ([parseDictionary objectForKey:[Response actionWithWebServiceResponse:GET_VALUE_HELPS]]) {
            parseDictionary = [parseDictionary objectForKey:[Response actionWithWebServiceResponse:GET_VALUE_HELPS]];
            
            if ([parseDictionary objectForKey:@"EtStloc"]) {
                parseDictionary = [parseDictionary objectForKey:@"EtStloc"];
                if ([parseDictionary objectForKey:@"item"]) {
                    parseDictionary = [parseDictionary objectForKey:@"item"];
                    if ([parseDictionary isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parseDictionary] forKey:@"result"];
                    }
                    else if([parseDictionary isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parseDictionary forKey:@"result"];
                    }
                    return xmlDoc;
                }
            }
        }
    }
    
    return [NSMutableDictionary dictionary];
}

- (NSMutableDictionary *)parseForFuncLocCostCenter:(NSDictionary *)resultDictionary
{
    NSMutableDictionary *xmlDoc = [NSMutableDictionary dictionary];
    NSDictionary *parseDictionary;
    if ([resultDictionary objectForKey:@"env:Body"]) {
        
        parseDictionary = [resultDictionary objectForKey:@"env:Body"];
        if ([parseDictionary objectForKey:[Response actionWithWebServiceResponse:GET_VALUE_HELPS]]) {
            parseDictionary = [parseDictionary objectForKey:[Response actionWithWebServiceResponse:GET_VALUE_HELPS]];
            if ([parseDictionary objectForKey:@"EtFuncloc"]) {
                parseDictionary = [parseDictionary objectForKey:@"EtFuncloc"];
                if ([parseDictionary objectForKey:@"item"]) {
                    parseDictionary = [parseDictionary objectForKey:@"item"];
                    if ([parseDictionary isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parseDictionary] forKey:@"result"];
                    }
                    else if([parseDictionary isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parseDictionary forKey:@"result"];
                    }
                }
                return xmlDoc;
            }
        }
    }
    return [NSMutableDictionary dictionary];
}

- (NSMutableDictionary *)parseForFuncLocFromEquipment:(NSDictionary *)resultDictionary
{
    NSMutableDictionary *xmlDoc = [NSMutableDictionary dictionary];
    NSDictionary *parseDictionary;
    if ([resultDictionary objectForKey:@"env:Body"]) {
        
        parseDictionary = [resultDictionary objectForKey:@"env:Body"];
        if ([parseDictionary objectForKey:[Response actionWithWebServiceResponse:FUNCTIONLOC_EQUIPMENT]]) {
            parseDictionary = [parseDictionary objectForKey:[Response actionWithWebServiceResponse:FUNCTIONLOC_EQUIPMENT]];
            if ([parseDictionary objectForKey:@"EtFuncloc"]) {
                parseDictionary = [parseDictionary objectForKey:@"EtFuncloc"];
                if ([parseDictionary objectForKey:@"item"]) {
                    parseDictionary = [parseDictionary objectForKey:@"item"];
                    if ([parseDictionary isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parseDictionary] forKey:@"result"];
                    }
                    else if([parseDictionary isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parseDictionary forKey:@"result"];
                    }
                }
                return xmlDoc;
            }
        }
    }
    
    return [NSMutableDictionary dictionary];
}

- (NSMutableDictionary *)parseForSearchFunclocEquipments:(NSDictionary *)resultDictionary
{
    NSMutableDictionary *xmlDoc = [NSMutableDictionary dictionary];
    NSDictionary *parseDictionary,*parseDictionary_Equip;
    
    if ([resultDictionary objectForKey:@"env:Body"]) {
        
        parseDictionary = [resultDictionary objectForKey:@"env:Body"];
        if ([parseDictionary objectForKey:[Response actionWithWebServiceResponse:SEARCH_FUNCLOC_EQUIPMENTS]]) {
            
            parseDictionary = [parseDictionary objectForKey:[Response actionWithWebServiceResponse:SEARCH_FUNCLOC_EQUIPMENTS]];
            
            if ([parseDictionary objectForKey:@"EtEqui"]) {
                
                parseDictionary_Equip = [parseDictionary objectForKey:@"EtEqui"];
                
                if ([parseDictionary_Equip objectForKey:@"item"]) {
                    parseDictionary_Equip = [parseDictionary_Equip objectForKey:@"item"];
                    
                    if ([parseDictionary_Equip isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parseDictionary_Equip] forKey:@"resultEquip"];
                    }
                    else if([parseDictionary_Equip isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parseDictionary_Equip forKey:@"resultEquip"];
                    }
                }
            }
            
            if ([parseDictionary objectForKey:@"EtFuncEquip"]) {
                parseDictionary = [parseDictionary objectForKey:@"EtFuncEquip"];
                if ([parseDictionary objectForKey:@"item"]) {
                    parseDictionary = [parseDictionary objectForKey:@"item"];
                    if ([parseDictionary isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parseDictionary] forKey:@"resultFloc"];
                    }
                    else if([parseDictionary isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parseDictionary forKey:@"resultFloc"];
                    }
                }
            }
            
            return xmlDoc;
        }
    }
    return [NSMutableDictionary dictionary];
}

- (NSMutableDictionary *)parseForListOfComponents:(NSDictionary *)resultDictionary
{
    NSMutableDictionary *xmlDoc = [NSMutableDictionary dictionary];
    NSDictionary *parseDictionary;
    if ([resultDictionary objectForKey:@"env:Body"]) {
        
        parseDictionary = [resultDictionary objectForKey:@"env:Body"];
        if ([parseDictionary objectForKey:[Response actionWithWebServiceResponse:GET_LIST_OF_COMPONENTS]]) {
            parseDictionary = [parseDictionary objectForKey:[Response actionWithWebServiceResponse:GET_LIST_OF_COMPONENTS]];
            if ([parseDictionary objectForKey:@"EtMaterial"]) {
                parseDictionary = [parseDictionary objectForKey:@"EtMaterial"];
                if ([parseDictionary objectForKey:@"item"]) {
                    parseDictionary = [parseDictionary objectForKey:@"item"];
                    if ([parseDictionary isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parseDictionary] forKey:@"result"];
                    }
                    else if([parseDictionary isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parseDictionary forKey:@"result"];
                    }
                }
                return xmlDoc;
            }
        }
    }
    return [NSMutableDictionary dictionary];
}

- (NSMutableDictionary *)parseForEquipCostCenter:(NSDictionary *)resultDictionary
{
    NSMutableDictionary *xmlDoc = [NSMutableDictionary dictionary];
    NSDictionary *parseDictionary;
    if ([resultDictionary objectForKey:@"env:Body"]) {
        
        parseDictionary = [resultDictionary objectForKey:@"env:Body"];
        if ([parseDictionary objectForKey:[Response actionWithWebServiceResponse:EQUIPMENT_COSTCENTER]]) {
            parseDictionary = [parseDictionary objectForKey:[Response actionWithWebServiceResponse:EQUIPMENT_COSTCENTER]];
            if ([parseDictionary objectForKey:@"EtEquip"]) {
                parseDictionary = [parseDictionary objectForKey:@"EtEquip"];
                if ([parseDictionary objectForKey:@"item"]) {
                    parseDictionary = [parseDictionary objectForKey:@"item"];
                    if ([parseDictionary isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parseDictionary] forKey:@"result"];
                    }
                    else if([parseDictionary isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parseDictionary forKey:@"result"];
                    }
                }
                return xmlDoc;
            }
        }
    }
    return [NSMutableDictionary dictionary];
}

- (NSMutableDictionary *)parseForEquipFromFuncLoc:(NSDictionary *)resultDictionary
{
    NSMutableDictionary *xmlDoc = [NSMutableDictionary dictionary];
    NSDictionary *parseDictionary;
    if ([resultDictionary objectForKey:@"env:Body"]) {
        
        parseDictionary = [resultDictionary objectForKey:@"env:Body"];
        if ([parseDictionary objectForKey:[Response actionWithWebServiceResponse:EQUIPMENT_FUNCLOC]]) {
            parseDictionary = [parseDictionary objectForKey:[Response actionWithWebServiceResponse:EQUIPMENT_FUNCLOC]];
            if ([parseDictionary objectForKey:@"EtEquip"]) {
                parseDictionary = [parseDictionary objectForKey:@"EtEquip"];
                if ([parseDictionary objectForKey:@"item"]) {
                    parseDictionary = [parseDictionary objectForKey:@"item"];
                    if ([parseDictionary isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parseDictionary] forKey:@"result"];
                    }
                    else if([parseDictionary isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parseDictionary forKey:@"result"];
                    }
                }
                return xmlDoc;
            }
        }
    }
    return [NSMutableDictionary dictionary];
}

- (NSMutableDictionary *)parseForListOFMovementTypes:(NSDictionary *)resultDictionary
{
    NSMutableDictionary *xmlDoc = [NSMutableDictionary dictionary];
    NSDictionary *parseDictionary;
    if ([resultDictionary objectForKey:@"env:Body"]) {
        
        parseDictionary = [resultDictionary objectForKey:@"env:Body"];
        if ([parseDictionary objectForKey:[Response actionWithWebServiceResponse:GET_VALUE_HELPS]]) {
            parseDictionary = [parseDictionary objectForKey:[Response actionWithWebServiceResponse:GET_VALUE_HELPS]];
            if ([parseDictionary objectForKey:@"EtMovementTypes"]) {
                parseDictionary = [parseDictionary objectForKey:@"EtMovementTypes"];
                if ([parseDictionary objectForKey:@"item"]) {
                    parseDictionary = [parseDictionary objectForKey:@"item"];
                    if ([parseDictionary isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parseDictionary] forKey:@"result"];
                    }
                    else if([parseDictionary isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parseDictionary forKey:@"result"];
                    }
                }
                return xmlDoc;
            }
        }
    }
    return [NSMutableDictionary dictionary];
}

- (NSMutableDictionary *)parseForListOfWorkCenter:(NSDictionary *)resultDictionary
{
    NSMutableDictionary *xmlDoc = [NSMutableDictionary dictionary];
    NSDictionary *parseDictionary;
    if ([resultDictionary objectForKey:@"env:Body"]) {
        
        parseDictionary = [resultDictionary objectForKey:@"env:Body"];
        if ([parseDictionary objectForKey:[Response actionWithWebServiceResponse:GET_VALUE_HELPS]]) {
            parseDictionary = [parseDictionary objectForKey:[Response actionWithWebServiceResponse:GET_VALUE_HELPS]];
            if ([parseDictionary objectForKey:@"EtWkctrPlant"]) {
                parseDictionary = [parseDictionary objectForKey:@"EtWkctrPlant"];
                if ([parseDictionary objectForKey:@"item"]) {
                    parseDictionary = [parseDictionary objectForKey:@"item"];
                    if ([parseDictionary isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parseDictionary] forKey:@"result"];
                    }
                    else if([parseDictionary isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parseDictionary forKey:@"result"];
                    }
                }
                return xmlDoc;
            }
        }
    }
    return [NSMutableDictionary dictionary];
}


- (NSMutableDictionary *)parseForListOfPermits:(NSDictionary *)resultDictionary
{
    NSMutableDictionary *xmlDoc = [NSMutableDictionary dictionary];
    NSDictionary *parseDictionary;
    if ([resultDictionary objectForKey:@"env:Body"]) {
        
        parseDictionary = [resultDictionary objectForKey:@"env:Body"];
        if ([parseDictionary objectForKey:[Response actionWithWebServiceResponse:GET_VALUE_HELPS]]) {
            parseDictionary = [parseDictionary objectForKey:[Response actionWithWebServiceResponse:GET_VALUE_HELPS]];
            if ([parseDictionary objectForKey:@"EtPermits"]) {
                parseDictionary = [parseDictionary objectForKey:@"EtPermits"];
                if ([parseDictionary objectForKey:@"item"]) {
                    parseDictionary = [parseDictionary objectForKey:@"item"];
                    if ([parseDictionary isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parseDictionary] forKey:@"result"];
                    }
                    else if([parseDictionary isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parseDictionary forKey:@"result"];
                    }
                }
                return xmlDoc;
            }
        }
    }
    
    return [NSMutableDictionary dictionary];
}

- (NSMutableDictionary *)parseForGetNotificationNoDetails:(NSDictionary *)resultDictionary
{
    NSMutableDictionary *xmlDoc = [NSMutableDictionary dictionary];
    id parseDictionary,parseNotifHeader,parseDictionaryTransaction,parseDictionaryLongText,parseDictionaryDocs;
    if ([resultDictionary objectForKey:@"env:Body"]) {
        
        parseDictionary = [resultDictionary objectForKey:@"env:Body"];
        if ([parseDictionary objectForKey:[Response actionWithWebServiceResponse:GET_NOTIFICATIONNO_DETAILS]]) {
            parseDictionary = [parseDictionary objectForKey:[Response actionWithWebServiceResponse:GET_NOTIFICATIONNO_DETAILS]];
            
            parseNotifHeader= parseDictionary;
            parseDictionaryTransaction=parseDictionary;
            parseDictionaryLongText=parseDictionary;
            parseDictionaryDocs=parseDictionary;
            
            if ([parseNotifHeader objectForKey:@"EtNotifHeader"]) {
                parseNotifHeader = [parseNotifHeader objectForKey:@"EtNotifHeader"];
                if ([parseNotifHeader objectForKey:@"item"]) {
                    parseNotifHeader = [parseNotifHeader objectForKey:@"item"];
                    if ([parseNotifHeader isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parseNotifHeader] forKey:@"resultHeader"];
                    }
                    else if([parseNotifHeader isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parseNotifHeader forKey:@"resultHeader"];
                    }
                }
            }
            
            if ([parseDictionaryTransaction objectForKey:@"EtNotifItems"]) {
                parseDictionaryTransaction = [parseDictionaryTransaction objectForKey:@"EtNotifItems"];
                if ([parseDictionaryTransaction objectForKey:@"item"]) {
                    parseDictionaryTransaction = [parseDictionaryTransaction objectForKey:@"item"];
                    if ([parseDictionaryTransaction isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parseDictionaryTransaction] forKey:@"resultTransactions"];
                    }
                    else if([parseDictionaryTransaction isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parseDictionaryTransaction forKey:@"resultTransactions"];
                    }
                }
            }
            
            
            if ([parseDictionaryLongText objectForKey:@"EtNotifLongtext"]) {
                parseDictionaryLongText = [parseDictionaryLongText objectForKey:@"EtNotifLongtext"];
                if ([parseDictionaryLongText objectForKey:@"item"]) {
                    parseDictionaryLongText = [parseDictionaryLongText objectForKey:@"item"];
                    if ([parseDictionaryLongText isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parseDictionaryLongText] forKey:@"resultLongText"];
                    }
                    else if([parseDictionaryLongText isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parseDictionaryLongText forKey:@"resultLongText"];
                    }
                }
            }
            
            
            if ([parseDictionaryDocs objectForKey:@"EtDocs"]) {
                parseDictionaryDocs = [parseDictionaryDocs objectForKey:@"EtDocs"];
                if ([parseDictionaryDocs objectForKey:@"item"]) {
                    parseDictionaryDocs = [parseDictionaryDocs objectForKey:@"item"];
                    if ([parseDictionaryDocs isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parseDictionaryDocs] forKey:@"resultDocs"];
                    }
                    else if([parseDictionaryDocs isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parseDictionaryDocs forKey:@"resultDocs"];
                    }
                }
            }
            
            return xmlDoc;
            
        }
    }
    return [NSMutableDictionary dictionary];
    
    
}


- (NSMutableDictionary *)parseForCreateNotification:(NSDictionary *)resultDictionary
{
    NSMutableDictionary *xmlDoc = [NSMutableDictionary dictionary];
    id parseDictionary,parseNotifHeader,parseDictionaryTransaction,parseDictionaryLongText,parseDictionaryDocs,parseDictionaryTasks;
    
    
    if ([resultDictionary objectForKey:@"env:Body"]) {
        
        parseDictionary = [resultDictionary objectForKey:@"env:Body"];
        if ([parseDictionary objectForKey:[Response actionWithWebServiceResponse:NOTIFICATION_CREATE]]) {
            parseDictionary = [parseDictionary objectForKey:[Response actionWithWebServiceResponse:NOTIFICATION_CREATE]];
            
            if ([parseDictionary objectForKey:@"EtNotifDup"]) {
                parseDictionary = [parseDictionary objectForKey:@"EtNotifDup"];
                
                if ([parseDictionary objectForKey:@"item"]) {
                    
                    parseDictionary = [parseDictionary objectForKey:@"item"];
                    
                    if ([parseDictionary isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parseDictionary] forKey:@"resultDuplicates"];
                    }
                    else if([parseDictionary isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parseDictionary forKey:@"resultDuplicates"];
                    }
                    
                    return xmlDoc;
                }
            }
            
            parseNotifHeader= parseDictionary;
            parseDictionaryTransaction=parseDictionary;
            parseDictionaryLongText=parseDictionary;
            parseDictionaryDocs=parseDictionary;
            parseDictionaryTasks = parseDictionary;
            
            
            if ([parseDictionary objectForKey:@"EvNotifNum"]) {
                [xmlDoc setObject:[parseDictionary objectForKey:@"EvNotifNum"] forKey:@"OBJECTID"];
            }
            
            if([parseDictionary objectForKey:@"EvMessage"]){
                [xmlDoc setObject:[parseDictionary objectForKey:@"EvMessage"] forKey:@"MESSAGE"];
            }
            
            if ([parseNotifHeader objectForKey:@"EtNotifHeader"]) {
                parseNotifHeader = [parseNotifHeader objectForKey:@"EtNotifHeader"];
                if ([parseNotifHeader objectForKey:@"item"]) {
                    parseNotifHeader = [parseNotifHeader objectForKey:@"item"];
                    if ([parseNotifHeader isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parseNotifHeader] forKey:@"resultHeader"];
                    }
                    else if([parseNotifHeader isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parseNotifHeader forKey:@"resultHeader"];
                    }
                }
            }
            
            if ([parseDictionaryTransaction objectForKey:@"EtNotifItems"]) {
                parseDictionaryTransaction = [parseDictionaryTransaction objectForKey:@"EtNotifItems"];
                if ([parseDictionaryTransaction objectForKey:@"item"]) {
                    parseDictionaryTransaction = [parseDictionaryTransaction objectForKey:@"item"];
                    if ([parseDictionaryTransaction isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parseDictionaryTransaction] forKey:@"resultTransactions"];
                    }
                    else if([parseDictionaryTransaction isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parseDictionaryTransaction forKey:@"resultTransactions"];
                    }
                }
            }
            
            
            if ([parseDictionaryLongText objectForKey:@"EtNotifLongtext"]) {
                parseDictionaryLongText = [parseDictionaryLongText objectForKey:@"EtNotifLongtext"];
                if ([parseDictionaryLongText objectForKey:@"item"]) {
                    parseDictionaryLongText = [parseDictionaryLongText objectForKey:@"item"];
                    if ([parseDictionaryLongText isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parseDictionaryLongText] forKey:@"resultLongText"];
                    }
                    else if([parseDictionaryLongText isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parseDictionaryLongText forKey:@"resultLongText"];
                    }
                }
            }
            
            
            if ([parseDictionaryDocs objectForKey:@"EtDocs"]) {
                parseDictionaryDocs = [parseDictionaryDocs objectForKey:@"EtDocs"];
                if ([parseDictionaryDocs objectForKey:@"item"]) {
                    parseDictionaryDocs = [parseDictionaryDocs objectForKey:@"item"];
                    if ([parseDictionaryDocs isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parseDictionaryDocs] forKey:@"resultDocs"];
                    }
                    else if([parseDictionaryDocs isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parseDictionaryDocs forKey:@"resultDocs"];
                    }
                }
            }
            
            if ([parseDictionaryTasks objectForKey:@"EtNotifTasks"]) {
                parseDictionaryTasks = [parseDictionaryTasks objectForKey:@"EtNotifTasks"];
                if ([parseDictionaryTasks objectForKey:@"item"]) {
                    parseDictionaryTasks = [parseDictionaryTasks objectForKey:@"item"];
                    if ([parseDictionaryTasks isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parseDictionaryTasks] forKey:@"resultTasks"];
                    }
                    else if([parseDictionaryTasks isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parseDictionaryTasks forKey:@"resultTasks"];
                    }
                }
            }
            
            return xmlDoc;
            
        }
    }
    return [NSMutableDictionary dictionary];
    
    
}
/*
 - (NSMutableDictionary *)parseForListOfNotification:(NSDictionary *)resultDictionary
 {
 NSMutableDictionary *xmlDoc = [NSMutableDictionary dictionary];
 NSDictionary *parseDictionary,*parseDictionaryTransaction,*parseDictionaryLongText;
 if ([resultDictionary objectForKey:@"env:Body"]) {
 
 parseDictionary = [resultDictionary objectForKey:@"env:Body"];
 if ([parseDictionary objectForKey:[Response actionWithWebServiceResponse:GET_LIST_OF_NOTIFICATIONS]]) {
 parseDictionary = [parseDictionary objectForKey:[Response actionWithWebServiceResponse:GET_LIST_OF_NOTIFICATIONS]];
 parseDictionaryTransaction = parseDictionary;
 parseDictionaryLongText = parseDictionary;
 
 if ([parseDictionary objectForKey:@"EtNotifHeader"]) {
 parseDictionary = [parseDictionary objectForKey:@"EtNotifHeader"];
 if ([parseDictionary objectForKey:@"item"]) {
 parseDictionary = [parseDictionary objectForKey:@"item"];
 if ([parseDictionary isKindOfClass:[NSDictionary class]]) {
 [xmlDoc setObject:[NSMutableArray arrayWithObject:parseDictionary] forKey:@"resultHeader"];
 }
 else if([parseDictionary isKindOfClass:[NSArray class]])
 {
 [xmlDoc setObject:parseDictionary forKey:@"resultHeader"];
 }
 }
 }
 if ([parseDictionaryTransaction objectForKey:@"EtNotifItems"]) {
 parseDictionaryTransaction = [parseDictionaryTransaction objectForKey:@"EtNotifItems"];
 if ([parseDictionaryTransaction objectForKey:@"item"]) {
 parseDictionaryTransaction = [parseDictionaryTransaction objectForKey:@"item"];
 if ([parseDictionaryTransaction isKindOfClass:[NSDictionary class]]) {
 [xmlDoc setObject:[NSMutableArray arrayWithObject:parseDictionaryTransaction] forKey:@"resultTransactions"];
 }
 else if([parseDictionaryTransaction isKindOfClass:[NSArray class]])
 {
 [xmlDoc setObject:parseDictionaryTransaction forKey:@"resultTransactions"];
 }
 }
 }
 
 if ([parseDictionaryLongText objectForKey:@"EtNotifLongtext"]) {
 parseDictionaryLongText = [parseDictionaryLongText objectForKey:@"EtNotifLongtext"];
 if ([parseDictionaryLongText objectForKey:@"item"]) {
 parseDictionaryLongText = [parseDictionaryLongText objectForKey:@"item"];
 if ([parseDictionaryLongText isKindOfClass:[NSDictionary class]]) {
 [xmlDoc setObject:[NSMutableArray arrayWithObject:parseDictionaryLongText] forKey:@"resultLongText"];
 }
 else if([parseDictionaryLongText isKindOfClass:[NSArray class]])
 {
 [xmlDoc setObject:parseDictionaryLongText forKey:@"resultLongText"];
 }
 }
 }
 
 return xmlDoc;
 
 }
 }
 return [NSMutableDictionary dictionary];
 }*/

- (NSMutableDictionary *)parseForListOfOpenNotification:(NSDictionary *)resultDictionary
{
    NSMutableDictionary *xmlDoc = [NSMutableDictionary dictionary];
    NSDictionary *parseDictionary,*parseDictionaryTransaction,*parseDictionaryLongText,*parseDictionaryDocs;
    if ([resultDictionary objectForKey:@"env:Body"]) {
        
        parseDictionary = [resultDictionary objectForKey:@"env:Body"];
        if ([parseDictionary objectForKey:[Response actionWithWebServiceResponse:GET_LIST_OF_OPEN_NOTIFICATIONS]]) {
            parseDictionary = [parseDictionary objectForKey:[Response actionWithWebServiceResponse:GET_LIST_OF_OPEN_NOTIFICATIONS]];
            parseDictionaryTransaction = parseDictionary;
            parseDictionaryLongText = parseDictionary;
            parseDictionaryDocs = parseDictionary;
            
            if ([parseDictionary objectForKey:@"EtNotifHeader"]) {
                parseDictionary = [parseDictionary objectForKey:@"EtNotifHeader"];
                if ([parseDictionary objectForKey:@"item"]) {
                    parseDictionary = [parseDictionary objectForKey:@"item"];
                    if ([parseDictionary isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parseDictionary] forKey:@"resultHeader"];
                    }
                    else if([parseDictionary isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parseDictionary forKey:@"resultHeader"];
                    }
                }
            }
            if ([parseDictionaryTransaction objectForKey:@"EtNotifItems"]) {
                parseDictionaryTransaction = [parseDictionaryTransaction objectForKey:@"EtNotifItems"];
                if ([parseDictionaryTransaction objectForKey:@"item"]) {
                    parseDictionaryTransaction = [parseDictionaryTransaction objectForKey:@"item"];
                    if ([parseDictionaryTransaction isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parseDictionaryTransaction] forKey:@"resultTransactions"];
                    }
                    else if([parseDictionaryTransaction isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parseDictionaryTransaction forKey:@"resultTransactions"];
                    }
                }
            }
            
            if ([parseDictionaryLongText objectForKey:@"EtNotifLongtext"]) {
                parseDictionaryLongText = [parseDictionaryLongText objectForKey:@"EtNotifLongtext"];
                if ([parseDictionaryLongText objectForKey:@"item"]) {
                    parseDictionaryLongText = [parseDictionaryLongText objectForKey:@"item"];
                    if ([parseDictionaryLongText isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parseDictionaryLongText] forKey:@"resultLongText"];
                    }
                    else if([parseDictionaryLongText isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parseDictionaryLongText forKey:@"resultLongText"];
                    }
                }
            }
            
            if ([parseDictionaryDocs objectForKey:@"EtDocs"]) {
                parseDictionaryDocs = [parseDictionaryDocs objectForKey:@"EtDocs"];
                if ([parseDictionaryDocs objectForKey:@"item"]) {
                    parseDictionaryDocs = [parseDictionaryDocs objectForKey:@"item"];
                    if ([parseDictionaryDocs isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parseDictionaryDocs] forKey:@"resultDocs"];
                    }
                    else if([parseDictionaryDocs isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parseDictionaryDocs forKey:@"resultDocs"];
                    }
                }
            }
            
            return xmlDoc;
        }
    }
    
    return [NSMutableDictionary dictionary];
}

- (NSMutableDictionary *)parseForListOfDueNotification:(NSDictionary *)resultDictionary
{
    NSMutableDictionary *xmlDoc = [NSMutableDictionary dictionary];
    NSDictionary *parseDictionary,*parseDictionaryTransaction,*parseDictionaryLongText,*parseDictionaryDocs,*parseDictionaryTasks,*parseDictionaryNotifStatus,*parseInspectionDictionary;
    
    if ([resultDictionary objectForKey:@"env:Body"]) {
        
        parseDictionary = [resultDictionary objectForKey:@"env:Body"];
        if ([parseDictionary objectForKey:[Response actionWithWebServiceResponse:GET_LIST_OF_DUE_NOTIFICATIONS]]) {
            parseDictionary = [parseDictionary objectForKey:[Response actionWithWebServiceResponse:GET_LIST_OF_DUE_NOTIFICATIONS]];
            parseDictionaryTransaction = parseDictionary;
            parseDictionaryLongText = parseDictionary;
            parseDictionaryDocs = parseDictionary;
            parseDictionaryTasks = parseDictionary;
            parseDictionaryNotifStatus = parseDictionary;
            parseInspectionDictionary = parseDictionary;
            
            if ([parseDictionary objectForKey:@"EtNotifHeader"]) {
                parseDictionary = [parseDictionary objectForKey:@"EtNotifHeader"];
                if ([parseDictionary objectForKey:@"item"]) {
                    parseDictionary = [parseDictionary objectForKey:@"item"];
                    if ([parseDictionary isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parseDictionary] forKey:@"resultHeader"];
                    }
                    else if([parseDictionary isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parseDictionary forKey:@"resultHeader"];
                    }
                }
            }
            
            
            
            if ([parseInspectionDictionary objectForKey:@"EtImrg"]) {
                parseInspectionDictionary = [parseInspectionDictionary objectForKey:@"EtImrg"];
                if ([parseInspectionDictionary objectForKey:@"item"]) {
                    parseInspectionDictionary = [parseInspectionDictionary objectForKey:@"item"];
                    if ([parseInspectionDictionary isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parseInspectionDictionary] forKey:@"resultInspection"];
                    }
                    else if([parseInspectionDictionary isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parseInspectionDictionary forKey:@"resultInspection"];
                    }
                }
            }
            
            
            if ([parseDictionaryTransaction objectForKey:@"EtNotifItems"]) {
                parseDictionaryTransaction = [parseDictionaryTransaction objectForKey:@"EtNotifItems"];
                if ([parseDictionaryTransaction objectForKey:@"item"]) {
                    parseDictionaryTransaction = [parseDictionaryTransaction objectForKey:@"item"];
                    if ([parseDictionaryTransaction isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parseDictionaryTransaction] forKey:@"resultTransactions"];
                    }
                    else if([parseDictionaryTransaction isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parseDictionaryTransaction forKey:@"resultTransactions"];
                    }
                }
            }
            
            if ([parseDictionaryLongText objectForKey:@"EtNotifLongtext"]) {
                parseDictionaryLongText = [parseDictionaryLongText objectForKey:@"EtNotifLongtext"];
                if ([parseDictionaryLongText objectForKey:@"item"]) {
                    parseDictionaryLongText = [parseDictionaryLongText objectForKey:@"item"];
                    if ([parseDictionaryLongText isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parseDictionaryLongText] forKey:@"resultLongText"];
                    }
                    else if([parseDictionaryLongText isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parseDictionaryLongText forKey:@"resultLongText"];
                    }
                }
            }
            
            if ([parseDictionaryDocs objectForKey:@"EtDocs"]) {
                parseDictionaryDocs = [parseDictionaryDocs objectForKey:@"EtDocs"];
                if ([parseDictionaryDocs objectForKey:@"item"]) {
                    parseDictionaryDocs = [parseDictionaryDocs objectForKey:@"item"];
                    if ([parseDictionaryDocs isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parseDictionaryDocs] forKey:@"resultDocs"];
                    }
                    else if([parseDictionaryDocs isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parseDictionaryDocs forKey:@"resultDocs"];
                    }
                }
            }
            
            if ([parseDictionaryTasks objectForKey:@"EtNotifTasks"]) {
                parseDictionaryTasks = [parseDictionaryTasks objectForKey:@"EtNotifTasks"];
                if ([parseDictionaryTasks objectForKey:@"item"]) {
                    parseDictionaryTasks = [parseDictionaryTasks objectForKey:@"item"];
                    if ([parseDictionaryTasks isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parseDictionaryTasks] forKey:@"resultTasks"];
                    }
                    else if([parseDictionaryTasks isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parseDictionaryTasks forKey:@"resultTasks"];
                    }
                }
            }
            
            if ([parseDictionaryNotifStatus objectForKey:@"EtNotifStatus"]) {
                parseDictionaryNotifStatus = [parseDictionaryNotifStatus objectForKey:@"EtNotifStatus"];
                if ([parseDictionaryNotifStatus objectForKey:@"item"]) {
                    parseDictionaryNotifStatus = [parseDictionaryNotifStatus objectForKey:@"item"];
                    if ([parseDictionaryNotifStatus isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parseDictionaryNotifStatus] forKey:@"resultNotifStatus"];
                    }
                    else if([parseDictionaryNotifStatus isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parseDictionaryNotifStatus forKey:@"resultNotifStatus"];
                    }
                }
            }
            
            return xmlDoc;
            
        }
    }
    return [NSMutableDictionary dictionary];
}

- (NSMutableDictionary *)parseForChangeNotification:(NSDictionary *)resultDictionary
{
    NSMutableDictionary *xmlDoc = [NSMutableDictionary dictionary];
    id parseDictionary,parseDictionaryNo,parseNotifHeader,parseDictionaryTransaction,parseDictionaryLongText,parseDictionaryDocs,parseDictionaryTasks;
    if ([resultDictionary objectForKey:@"env:Body"]) {
        
        parseDictionary = [resultDictionary objectForKey:@"env:Body"];
        if ([parseDictionary objectForKey:[Response actionWithWebServiceResponse:NOTIFICATION_CHANGE]]) {
            parseDictionary = [parseDictionary objectForKey:[Response actionWithWebServiceResponse:NOTIFICATION_CHANGE]];
            
            parseDictionaryNo = parseDictionary;
            parseNotifHeader= parseDictionary;
            parseDictionaryTransaction=parseDictionary;
            parseDictionaryLongText=parseDictionary;
            parseDictionaryDocs=parseDictionary;
            parseDictionaryTasks = parseDictionary;
            
            if ([parseDictionary objectForKey:@"EtMessage"]) {
                parseDictionary = [parseDictionary objectForKey:@"EtMessage"];
                if ([parseDictionary objectForKey:@"item"]) {
                    parseDictionary = [parseDictionary objectForKey:@"item"];
                    if ([parseDictionary isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc addEntriesFromDictionary:parseDictionary];
                    }
                    else if([parseDictionary isKindOfClass:[NSArray class]])
                    {
                        NSMutableString *messageString = [[NSMutableString alloc] initWithString:@""];
                        for (int i=0; i<[parseDictionary count]; i++) {
                            [messageString appendFormat:@"%@",[[parseDictionary objectAtIndex:i] objectForKey:@"Message"]];
                            if (i<[parseDictionary count]-1) {
                                [messageString appendFormat:@"\n"];
                            }
                        }
                        [xmlDoc setObject:messageString forKey:@"Message"];
                    }
                }
            }
            if ([parseDictionaryNo objectForKey:@"EvNotifNum"]) {
                parseDictionaryNo = [parseDictionaryNo objectForKey:@"EvNotifNum"];
                
                [xmlDoc setObject:parseDictionaryNo forKey:@"OBJECTID"];
                
            }
            
            if ([parseNotifHeader objectForKey:@"EtNotifHeader"]) {
                parseNotifHeader = [parseNotifHeader objectForKey:@"EtNotifHeader"];
                if ([parseNotifHeader objectForKey:@"item"]) {
                    parseNotifHeader = [parseNotifHeader objectForKey:@"item"];
                    if ([parseNotifHeader isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parseNotifHeader] forKey:@"resultHeader"];
                    }
                    else if([parseNotifHeader isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parseNotifHeader forKey:@"resultHeader"];
                    }
                }
            }
            
            if ([parseDictionaryTransaction objectForKey:@"EtNotifItems"]) {
                parseDictionaryTransaction = [parseDictionaryTransaction objectForKey:@"EtNotifItems"];
                if ([parseDictionaryTransaction objectForKey:@"item"]) {
                    parseDictionaryTransaction = [parseDictionaryTransaction objectForKey:@"item"];
                    if ([parseDictionaryTransaction isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parseDictionaryTransaction] forKey:@"resultTransactions"];
                    }
                    else if([parseDictionaryTransaction isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parseDictionaryTransaction forKey:@"resultTransactions"];
                    }
                }
            }
            
            
            if ([parseDictionaryLongText objectForKey:@"EtNotifLongtext"]) {
                parseDictionaryLongText = [parseDictionaryLongText objectForKey:@"EtNotifLongtext"];
                if ([parseDictionaryLongText objectForKey:@"item"]) {
                    parseDictionaryLongText = [parseDictionaryLongText objectForKey:@"item"];
                    if ([parseDictionaryLongText isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parseDictionaryLongText] forKey:@"resultLongText"];
                    }
                    else if([parseDictionaryLongText isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parseDictionaryLongText forKey:@"resultLongText"];
                    }
                }
            }
            
            
            if ([parseDictionaryDocs objectForKey:@"EtDocs"]) {
                parseDictionaryDocs = [parseDictionaryDocs objectForKey:@"EtDocs"];
                if ([parseDictionaryDocs objectForKey:@"item"]) {
                    parseDictionaryDocs = [parseDictionaryDocs objectForKey:@"item"];
                    if ([parseDictionaryDocs isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parseDictionaryDocs] forKey:@"resultDocs"];
                    }
                    else if([parseDictionaryDocs isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parseDictionaryDocs forKey:@"resultDocs"];
                    }
                }
            }
            
            if ([parseDictionaryTasks objectForKey:@"EtNotifTasks"]) {
                parseDictionaryTasks = [parseDictionaryTasks objectForKey:@"EtNotifTasks"];
                if ([parseDictionaryTasks objectForKey:@"item"]) {
                    parseDictionaryTasks = [parseDictionaryTasks objectForKey:@"item"];
                    if ([parseDictionaryTasks isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parseDictionaryTasks] forKey:@"resultTasks"];
                    }
                    else if([parseDictionaryTasks isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parseDictionaryTasks forKey:@"resultTasks"];
                    }
                }
            }
            
            
            return xmlDoc;
            
        }
    }
    return [NSMutableDictionary dictionary];
    
}

- (NSMutableDictionary *)parseForCancelNotification:(NSDictionary *)resultDictionary{
    
    NSMutableDictionary *xmlDoc = [NSMutableDictionary dictionary];
    id parseDictionary,parseDictionaryNumber;
    if ([resultDictionary objectForKey:@"env:Body"]) {
        
        parseDictionary = [resultDictionary objectForKey:@"env:Body"];
        if ([parseDictionary objectForKey:[Response actionWithWebServiceResponse:NOTIFICATION_CANCEL]]) {
            parseDictionary = [parseDictionary objectForKey:[Response actionWithWebServiceResponse:NOTIFICATION_CANCEL]];
            parseDictionaryNumber = parseDictionary;
            if ([parseDictionary objectForKey:@"EtMessage"]) {
                parseDictionary = [parseDictionary objectForKey:@"EtMessage"];
                if ([parseDictionary objectForKey:@"item"]) {
                    parseDictionary = [parseDictionary objectForKey:@"item"];
                    if ([parseDictionary isKindOfClass:[NSDictionary class]]) {
                        if ([parseDictionary objectForKey:@"Message"]) {
                            [xmlDoc setObject:[NSMutableArray arrayWithObject:[parseDictionary objectForKey:@"Message"]] forKey:@"Message"];
                        }
                    }
                    else if([parseDictionary isKindOfClass:[NSArray class]])
                    {
                        NSMutableArray *messageArray = [NSMutableArray new];
                        for (int i=0; i<[parseDictionary count]; i++) {
                            [messageArray addObject:[NSString stringWithString:[[parseDictionary objectAtIndex:i] objectForKey:@"Message"]]];
                        }
                        [xmlDoc setObject:messageArray forKey:@"Message"];
                    }
                }
            }
            if ([parseDictionaryNumber objectForKey:@"EvNotifNum"]) {
                [xmlDoc setObject:[parseDictionaryNumber objectForKey:@"EvNotifNum"] forKey:@"OBJECTID"];
            }
            
            return xmlDoc;
        }
    }
    return [NSMutableDictionary dictionary];
}

- (NSMutableDictionary *)parseForCompleteNotification:(NSDictionary *)resultDictionary
{
    NSMutableDictionary *xmlDoc = [NSMutableDictionary dictionary];
    
    id parseDictionary,parseDictionaryNumber;
    if ([resultDictionary objectForKey:@"env:Body"]) {
        
        parseDictionary = [resultDictionary objectForKey:@"env:Body"];
        if ([parseDictionary objectForKey:[Response actionWithWebServiceResponse:NOTIFICATION_COMPLETE]]) {
            parseDictionary = [parseDictionary objectForKey:[Response actionWithWebServiceResponse:NOTIFICATION_COMPLETE]];
            parseDictionaryNumber = parseDictionary;
            if ([parseDictionary objectForKey:@"EtMessage"]) {
                parseDictionary = [parseDictionary objectForKey:@"EtMessage"];
                if ([parseDictionary objectForKey:@"item"]) {
                    parseDictionary = [parseDictionary objectForKey:@"item"];
                    if ([parseDictionary isKindOfClass:[NSDictionary class]]) {
                        if ([parseDictionary objectForKey:@"Message"]) {
                            [xmlDoc setObject:[NSMutableArray arrayWithObject:[parseDictionary objectForKey:@"Message"]] forKey:@"Message"];
                        }
                    }
                    else if([parseDictionary isKindOfClass:[NSArray class]])
                    {
                        NSMutableArray *messageArray = [NSMutableArray new];
                        for (int i=0; i<[parseDictionary count]; i++) {
                            [messageArray addObject:[NSString stringWithString:[[parseDictionary objectAtIndex:i] objectForKey:@"Message"]]];
                        }
                        [xmlDoc setObject:messageArray forKey:@"Message"];
                    }
                }
            }
            if ([parseDictionaryNumber objectForKey:@"EvNotifNum"]) {
                [xmlDoc setObject:[parseDictionaryNumber objectForKey:@"EvNotifNum"] forKey:@"OBJECTID"];
            }
            return xmlDoc;
        }
    }
    return [NSMutableDictionary dictionary];
}
/*- (NSMutableDictionary *)parseForCancelNotification:(NSDictionary *)resultDictionary{
 
 NSMutableDictionary *xmlDoc = [NSMutableDictionary dictionary];
 id parseDictionary,parseDictionaryNo;
 if ([resultDictionary objectForKey:@"env:Body"]) {
 
 parseDictionary = [resultDictionary objectForKey:@"env:Body"];
 if ([parseDictionary objectForKey:[Response actionWithWebServiceResponse:NOTIFICATION_CANCEL]]) {
 parseDictionary = [parseDictionary objectForKey:[Response actionWithWebServiceResponse:NOTIFICATION_CANCEL]];
 
 parseDictionaryNo = parseDictionary;
 
 if ([parseDictionary objectForKey:@"EtMessage"]) {
 parseDictionary = [parseDictionary objectForKey:@"EtMessage"];
 if ([parseDictionary objectForKey:@"item"]) {
 parseDictionary = [parseDictionary objectForKey:@"item"];
 if ([parseDictionary isKindOfClass:[NSDictionary class]]) {
 [xmlDoc addEntriesFromDictionary:parseDictionary];
 }
 else if([parseDictionary isKindOfClass:[NSArray class]])
 {
 NSMutableString *messageString = [[NSMutableString alloc] initWithString:@""];
 for (int i=0; i<[parseDictionary count]; i++) {
 [messageString appendFormat:@"%@",[[parseDictionary objectAtIndex:i] objectForKey:@"Message"]];
 if (i<[parseDictionary count]-1) {
 [messageString appendFormat:@"\n"];
 }
 }
 [xmlDoc setObject:messageString forKey:@"Message"];
 }
 }
 }
 if ([parseDictionaryNo objectForKey:@"EvNotifNum"]) {
 parseDictionaryNo = [parseDictionaryNo objectForKey:@"EvNotifNum"];
 
 [xmlDoc setObject:parseDictionaryNo forKey:@"OBJECTID"];
 
 }
 
 return xmlDoc;
 
 }
 }
 return [NSMutableDictionary dictionary];
 }
 
 - (NSMutableDictionary *)parseForCompleteNotification:(NSDictionary *)resultDictionary
 {
 NSMutableDictionary *xmlDoc = [NSMutableDictionary dictionary];
 id parseDictionary,parseDictionaryNo;
 if ([resultDictionary objectForKey:@"env:Body"]) {
 
 parseDictionary = [resultDictionary objectForKey:@"env:Body"];
 if ([parseDictionary objectForKey:[Response actionWithWebServiceResponse:NOTIFICATION_COMPLETE]]) {
 parseDictionary = [parseDictionary objectForKey:[Response actionWithWebServiceResponse:NOTIFICATION_COMPLETE]];
 
 parseDictionaryNo = parseDictionary;
 
 if ([parseDictionary objectForKey:@"EtMessage"]) {
 parseDictionary = [parseDictionary objectForKey:@"EtMessage"];
 if ([parseDictionary objectForKey:@"item"]) {
 parseDictionary = [parseDictionary objectForKey:@"item"];
 if ([parseDictionary isKindOfClass:[NSDictionary class]]) {
 [xmlDoc addEntriesFromDictionary:parseDictionary];
 }
 else if([parseDictionary isKindOfClass:[NSArray class]])
 {
 NSMutableString *messageString = [[NSMutableString alloc] initWithString:@""];
 for (int i=0; i<[parseDictionary count]; i++) {
 [messageString appendFormat:@"%@",[[parseDictionary objectAtIndex:i] objectForKey:@"Message"]];
 if (i<[parseDictionary count]-1) {
 [messageString appendFormat:@"\n"];
 }
 }
 [xmlDoc setObject:messageString forKey:@"Message"];
 }
 }
 }
 if ([parseDictionaryNo objectForKey:@"EvNotifNum"]) {
 parseDictionaryNo = [parseDictionaryNo objectForKey:@"EvNotifNum"];
 
 [xmlDoc setObject:parseDictionaryNo forKey:@"OBJECTID"];
 
 }
 
 return xmlDoc;
 
 }
 }
 return [NSMutableDictionary dictionary];
 }*/

- (NSMutableDictionary *)parseForGetOrderDetails:(NSDictionary *)resultDictionary
{
    NSMutableDictionary *xmlDoc = [NSMutableDictionary dictionary];
    NSDictionary *parseDictionary;
    
    id  parseDictionaryHeader,parseDictionaryHeaderPermits,parseDictionaryOperationTransaction,parseDictionaryComponentsTransaction,parseDictionaryLongText,parseDictionaryDocs;
    
    if ([resultDictionary objectForKey:@"env:Body"]) {
        
        parseDictionary = [resultDictionary objectForKey:@"env:Body"];
        if ([parseDictionary objectForKey:[Response actionWithWebServiceResponse:GET_ORDERNO_DETAILS]]) {
            parseDictionary = [parseDictionary objectForKey:[Response actionWithWebServiceResponse:GET_ORDERNO_DETAILS]];
            
            parseDictionaryHeader=parseDictionary;
            parseDictionaryHeaderPermits = parseDictionary;
            parseDictionaryOperationTransaction = parseDictionary;
            parseDictionaryComponentsTransaction = parseDictionary;
            parseDictionaryLongText = parseDictionary;
            parseDictionaryDocs = parseDictionary;
            
            if ([parseDictionaryHeader objectForKey:@"EtOrderHeader"]) {
                parseDictionaryHeader = [parseDictionaryHeader objectForKey:@"EtOrderHeader"];
                if ([parseDictionaryHeader objectForKey:@"item"]) {
                    parseDictionaryHeader = [parseDictionaryHeader objectForKey:@"item"];
                    if ([parseDictionaryHeader isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parseDictionaryHeader] forKey:@"resultHeader"];
                    }
                    else if([parseDictionaryHeader isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parseDictionaryHeader forKey:@"resultHeader"];
                    }
                }
            }
            
            if ([parseDictionaryHeaderPermits objectForKey:@"EtOrderPermits"]) {
                parseDictionaryHeaderPermits = [parseDictionaryHeaderPermits objectForKey:@"EtOrderPermits"];
                if ([parseDictionaryHeaderPermits objectForKey:@"item"]) {
                    parseDictionaryHeaderPermits = [parseDictionaryHeaderPermits objectForKey:@"item"];
                    if ([parseDictionaryHeaderPermits isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parseDictionaryHeaderPermits] forKey:@"resultHeaderPermits"];
                    }
                    else if([parseDictionaryHeaderPermits isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parseDictionaryHeaderPermits forKey:@"resultHeaderPermits"];
                    }
                }
            }
            
            if ([parseDictionaryOperationTransaction objectForKey:@"EtOrderOperations"]) {
                parseDictionaryOperationTransaction = [parseDictionaryOperationTransaction objectForKey:@"EtOrderOperations"];
                if ([parseDictionaryOperationTransaction objectForKey:@"item"]) {
                    parseDictionaryOperationTransaction = [parseDictionaryOperationTransaction objectForKey:@"item"];
                    if ([parseDictionaryOperationTransaction isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parseDictionaryOperationTransaction] forKey:@"resultOperationsTransactions"];
                    }
                    else if([parseDictionaryOperationTransaction isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parseDictionaryOperationTransaction forKey:@"resultOperationsTransactions"];
                    }
                }
            }
            
            if ([parseDictionaryComponentsTransaction objectForKey:@"EtOrderComponents"]) {
                parseDictionaryComponentsTransaction = [parseDictionaryComponentsTransaction objectForKey:@"EtOrderComponents"];
                if ([parseDictionaryComponentsTransaction objectForKey:@"item"]) {
                    parseDictionaryComponentsTransaction = [parseDictionaryComponentsTransaction objectForKey:@"item"];
                    if ([parseDictionaryComponentsTransaction isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parseDictionaryComponentsTransaction] forKey:@"resultComponentsTransactions"];
                    }
                    else if([parseDictionaryComponentsTransaction isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parseDictionaryComponentsTransaction forKey:@"resultComponentsTransactions"];
                    }
                }
            }
            
            if ([parseDictionaryLongText objectForKey:@"EtOrderLongtext"]) {
                parseDictionaryLongText = [parseDictionaryLongText objectForKey:@"EtOrderLongtext"];
                if ([parseDictionaryLongText objectForKey:@"item"]) {
                    parseDictionaryLongText = [parseDictionaryLongText objectForKey:@"item"];
                    if ([parseDictionaryLongText isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parseDictionaryLongText] forKey:@"resultLongText"];
                    }
                    else if([parseDictionaryLongText isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parseDictionaryLongText forKey:@"resultLongText"];
                    }
                }
            }
            
            if ([parseDictionaryDocs objectForKey:@"EtDocs"]) {
                parseDictionaryDocs = [parseDictionaryDocs objectForKey:@"EtDocs"];
                if ([parseDictionaryDocs objectForKey:@"item"]) {
                    parseDictionaryDocs = [parseDictionaryDocs objectForKey:@"item"];
                    if ([parseDictionaryDocs isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parseDictionaryDocs] forKey:@"resultDocs"];
                    }
                    else if([parseDictionaryDocs isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parseDictionaryDocs forKey:@"resultDocs"];
                    }
                }
            }
            
            
            return xmlDoc;
            
        }
    }
    return [NSMutableDictionary dictionary];
}


- (NSMutableDictionary *)parseForCreateOrder:(NSDictionary *)resultDictionary
{
    NSMutableDictionary *xmlDoc = [NSMutableDictionary dictionary];
    NSDictionary *parseDictionary;
    
    id parseDictionaryHeader,parseDictionaryHeaderPermits,parseDictionaryOperationTransaction,parseDictionaryComponentsTransaction,parseDictionaryLongText,parseDictionaryDocs,parsedDictionaryCheckPointsparsedDictionaryWorkApplications,parsedDictionaryCheckPoints,parsedDictionaryWorkApplications,parsedDictionaryWcagns,parsedDictionaryOpWCDDetails,parsedDictionaryOpWCDItemDetails,parsedDictionaryWorkApprovalDetails,parsedDictionaryMeasurementDocuments;
    
    if ([resultDictionary objectForKey:@"env:Body"]) {
        
        parseDictionary = [resultDictionary objectForKey:@"env:Body"];
        if ([parseDictionary objectForKey:[Response actionWithWebServiceResponse:ORDER_CREATE]]) {
            
            parseDictionary = [parseDictionary objectForKey:[Response actionWithWebServiceResponse:ORDER_CREATE]];
            
            parseDictionaryHeader=parseDictionary;
            parseDictionaryHeaderPermits = parseDictionary;
            parseDictionaryOperationTransaction = parseDictionary;
            parseDictionaryComponentsTransaction = parseDictionary;
            parseDictionaryLongText = parseDictionary;
            parseDictionaryDocs = parseDictionary;
            parsedDictionaryCheckPoints = parseDictionary;
            parsedDictionaryWorkApplications = parseDictionary;
            parsedDictionaryWcagns = parseDictionary;
            parsedDictionaryOpWCDDetails = parseDictionary;
            parsedDictionaryOpWCDItemDetails = parseDictionary;
            parsedDictionaryWorkApprovalDetails = parseDictionary;
            parsedDictionaryMeasurementDocuments = parseDictionary;
            
            
            if ([parseDictionary objectForKey:@"EvMessage"]) {
                [xmlDoc setObject:[parseDictionary objectForKey:@"EvMessage"] forKey:@"Message"];
            }
            
            if([parseDictionary objectForKey:@"EvAufnr"]){
                [xmlDoc setObject:[parseDictionary objectForKey:@"EvAufnr"] forKey:@"OBJECTID"];
            }
            
            if ([parseDictionaryHeader objectForKey:@"EtOrderHeader"]) {
                parseDictionaryHeader = [parseDictionaryHeader objectForKey:@"EtOrderHeader"];
                if ([parseDictionaryHeader objectForKey:@"item"]) {
                    parseDictionaryHeader = [parseDictionaryHeader objectForKey:@"item"];
                    if ([parseDictionaryHeader isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parseDictionaryHeader] forKey:@"resultHeader"];
                    }
                    else if([parseDictionaryHeader isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parseDictionaryHeader forKey:@"resultHeader"];
                    }
                }
            }
            
            if ([parseDictionaryHeaderPermits objectForKey:@"EtOrderPermits"]) {
                parseDictionaryHeaderPermits = [parseDictionaryHeaderPermits objectForKey:@"EtOrderPermits"];
                if ([parseDictionaryHeaderPermits objectForKey:@"item"]) {
                    parseDictionaryHeaderPermits = [parseDictionaryHeaderPermits objectForKey:@"item"];
                    if ([parseDictionaryHeaderPermits isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parseDictionaryHeaderPermits] forKey:@"resultHeaderPermits"];
                    }
                    else if([parseDictionaryHeaderPermits isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parseDictionaryHeaderPermits forKey:@"resultHeaderPermits"];
                    }
                }
            }
            
            if ([parseDictionaryOperationTransaction objectForKey:@"EtOrderOperations"]) {
                parseDictionaryOperationTransaction = [parseDictionaryOperationTransaction objectForKey:@"EtOrderOperations"];
                if ([parseDictionaryOperationTransaction objectForKey:@"item"]) {
                    parseDictionaryOperationTransaction = [parseDictionaryOperationTransaction objectForKey:@"item"];
                    if ([parseDictionaryOperationTransaction isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parseDictionaryOperationTransaction] forKey:@"resultOperationsTransactions"];
                    }
                    else if([parseDictionaryOperationTransaction isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parseDictionaryOperationTransaction forKey:@"resultOperationsTransactions"];
                    }
                }
            }
            
            if ([parseDictionaryComponentsTransaction objectForKey:@"EtOrderComponents"]) {
                parseDictionaryComponentsTransaction = [parseDictionaryComponentsTransaction objectForKey:@"EtOrderComponents"];
                if ([parseDictionaryComponentsTransaction objectForKey:@"item"]) {
                    parseDictionaryComponentsTransaction = [parseDictionaryComponentsTransaction objectForKey:@"item"];
                    if ([parseDictionaryComponentsTransaction isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parseDictionaryComponentsTransaction] forKey:@"resultComponentsTransactions"];
                    }
                    else if([parseDictionaryComponentsTransaction isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parseDictionaryComponentsTransaction forKey:@"resultComponentsTransactions"];
                    }
                }
            }
            
            if ([parseDictionaryLongText objectForKey:@"EtOrderLongtext"]) {
                parseDictionaryLongText = [parseDictionaryLongText objectForKey:@"EtOrderLongtext"];
                if ([parseDictionaryLongText objectForKey:@"item"]) {
                    parseDictionaryLongText = [parseDictionaryLongText objectForKey:@"item"];
                    if ([parseDictionaryLongText isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parseDictionaryLongText] forKey:@"resultLongText"];
                    }
                    else if([parseDictionaryLongText isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parseDictionaryLongText forKey:@"resultLongText"];
                    }
                }
            }
            
            if ([parseDictionaryDocs objectForKey:@"EtDocs"]) {
                parseDictionaryDocs = [parseDictionaryDocs objectForKey:@"EtDocs"];
                if ([parseDictionaryDocs objectForKey:@"item"]) {
                    parseDictionaryDocs = [parseDictionaryDocs objectForKey:@"item"];
                    if ([parseDictionaryDocs isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parseDictionaryDocs] forKey:@"resultDocs"];
                    }
                    else if([parseDictionaryDocs isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parseDictionaryDocs forKey:@"resultDocs"];
                    }
                }
            }
            
            
            //WCM
            if ([parsedDictionaryCheckPoints objectForKey:@"EtWcmWaChkReq"]) {
                parsedDictionaryCheckPoints = [parsedDictionaryCheckPoints objectForKey:@"EtWcmWaChkReq"];
                if ([parsedDictionaryCheckPoints objectForKey:@"item"]) {
                    parsedDictionaryCheckPoints = [parsedDictionaryCheckPoints objectForKey:@"item"];
                    if ([parsedDictionaryCheckPoints isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parsedDictionaryCheckPoints] forKey:@"resultStandardCheckPoints"];
                    }
                    else if([parsedDictionaryCheckPoints isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parsedDictionaryCheckPoints forKey:@"resultStandardCheckPoints"];
                    }
                }
            }
            
            if ([parsedDictionaryWorkApplications objectForKey:@"EtWcmWaData"]) {
                parsedDictionaryWorkApplications = [parsedDictionaryWorkApplications objectForKey:@"EtWcmWaData"];
                if ([parsedDictionaryWorkApplications objectForKey:@"item"]) {
                    parsedDictionaryWorkApplications = [parsedDictionaryWorkApplications objectForKey:@"item"];
                    if ([parsedDictionaryWorkApplications isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parsedDictionaryWorkApplications] forKey:@"resultWorkApplicationData"];
                    }
                    else if([parsedDictionaryWorkApplications isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parsedDictionaryWorkApplications forKey:@"resultWorkApplicationData"];
                    }
                }
            }
            
            if ([parsedDictionaryWcagns objectForKey:@"EtWcmWcagns"]) {
                parsedDictionaryWcagns = [parsedDictionaryWcagns objectForKey:@"EtWcmWcagns"];
                if ([parsedDictionaryWcagns objectForKey:@"item"]) {
                    parsedDictionaryWcagns = [parsedDictionaryWcagns objectForKey:@"item"];
                    if ([parsedDictionaryWcagns isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parsedDictionaryWcagns] forKey:@"resultIssuePermits"];//issue permits
                    }
                    else if([parsedDictionaryWcagns isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parsedDictionaryWcagns forKey:@"resultIssuePermits"];//issue permits
                    }
                }
            }
            
            if ([parsedDictionaryOpWCDDetails objectForKey:@"EtWcmWdData"]) {
                parsedDictionaryOpWCDDetails = [parsedDictionaryOpWCDDetails objectForKey:@"EtWcmWdData"];
                if ([parsedDictionaryOpWCDDetails objectForKey:@"item"]) {
                    parsedDictionaryOpWCDDetails = [parsedDictionaryOpWCDDetails objectForKey:@"item"];
                    if ([parsedDictionaryOpWCDDetails isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parsedDictionaryOpWCDDetails] forKey:@"resultOperationWCDData"];//isolation
                    }
                    else if([parsedDictionaryOpWCDDetails isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parsedDictionaryOpWCDDetails forKey:@"resultOperationWCDData"];//isolation
                    }
                }
            }
            
            if ([parsedDictionaryOpWCDItemDetails objectForKey:@"EtWcmWdItemData"]) {
                parsedDictionaryOpWCDItemDetails = [parsedDictionaryOpWCDItemDetails objectForKey:@"EtWcmWdItemData"];
                if ([parsedDictionaryOpWCDItemDetails objectForKey:@"item"]) {
                    parsedDictionaryOpWCDItemDetails = [parsedDictionaryOpWCDItemDetails objectForKey:@"item"];
                    if ([parsedDictionaryOpWCDItemDetails isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parsedDictionaryOpWCDItemDetails] forKey:@"resultOperationWCDItemData"];//tagging conditions
                    }
                    else if([parsedDictionaryOpWCDItemDetails isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parsedDictionaryOpWCDItemDetails forKey:@"resultOperationWCDItemData"];//tagging conditions
                    }
                }
            }
            
            if ([parsedDictionaryWorkApprovalDetails objectForKey:@"EtWcmWwData"]) {
                parsedDictionaryWorkApprovalDetails = [parsedDictionaryWorkApprovalDetails objectForKey:@"EtWcmWwData"];
                if ([parsedDictionaryWorkApprovalDetails objectForKey:@"item"]) {
                    parsedDictionaryWorkApprovalDetails = [parsedDictionaryWorkApprovalDetails objectForKey:@"item"];
                    if ([parsedDictionaryWorkApprovalDetails isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parsedDictionaryWorkApprovalDetails] forKey:@"resultWorkApprovalsData"];
                    }
                    else if([parsedDictionaryWorkApprovalDetails isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parsedDictionaryWorkApprovalDetails forKey:@"resultWorkApprovalsData"];
                    }
                }
            }
            
            
            
            return xmlDoc;
            
        }
    }
    return [NSMutableDictionary dictionary];
}

- (NSMutableDictionary *)parseForCreateNotificationOrder:(NSDictionary *)resultDictionary
{
    NSMutableDictionary *xmlDoc = [NSMutableDictionary dictionary];
    NSDictionary *parseDictionary;
    
    id  parseDictionaryHeader,parseDictionaryHeaderPermits,parseDictionaryOperationTransaction,parseDictionaryComponentsTransaction,parseDictionaryLongText,parseDictionaryDocs,parsedDictionaryOrderStatus,parseDictionaryWSM;
    
    id parseNotifHeader,parseDictionaryNotifTransaction,parseDictionaryNotifLongText;
    
    if ([resultDictionary objectForKey:@"env:Body"]) {
        
        parseDictionary = [resultDictionary objectForKey:@"env:Body"];
        if ([parseDictionary objectForKey:[Response actionWithWebServiceResponse:CREATE_NOTIF_ORDER]]) {
            parseDictionary = [parseDictionary objectForKey:[Response actionWithWebServiceResponse:CREATE_NOTIF_ORDER]];
            
            parseNotifHeader= parseDictionary;
            parseDictionaryNotifTransaction=parseDictionary;
            parseDictionaryNotifLongText=parseDictionary;
            
            parseDictionaryHeader=parseDictionary;
            parseDictionaryHeaderPermits = parseDictionary;
            parseDictionaryOperationTransaction = parseDictionary;
            parseDictionaryComponentsTransaction = parseDictionary;
            parseDictionaryLongText = parseDictionary;
            parseDictionaryDocs = parseDictionary;
            parsedDictionaryOrderStatus = parseDictionary;
            parseDictionaryWSM = parseDictionary;
            
            if ([parseDictionary objectForKey:@"EvAufnr"]) {
                [xmlDoc setObject:[parseDictionary objectForKey:@"EvAufnr"] forKey:@"OOBJECTID"];
            }
            if([parseDictionary objectForKey:@"EvQmnum"]){
                [xmlDoc setObject:[parseDictionary objectForKey:@"EvQmnum"] forKey:@"NOBJECTID"];
            }
            
            if([parseDictionary objectForKey:@"EvMessage"]){
                [xmlDoc setObject:[parseDictionary objectForKey:@"EvMessage"] forKey:@"MESSAGE"];
            }
            
            if ([parseNotifHeader objectForKey:@"EtNotifHeader"]) {
                parseNotifHeader = [parseNotifHeader objectForKey:@"EtNotifHeader"];
                if ([parseNotifHeader objectForKey:@"item"]) {
                    parseNotifHeader = [parseNotifHeader objectForKey:@"item"];
                    if ([parseNotifHeader isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parseNotifHeader] forKey:@"resultNotifHeader"];
                    }
                    else if([parseNotifHeader isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parseNotifHeader forKey:@"resultNotifHeader"];
                    }
                }
            }
            
            if ([parseDictionaryNotifTransaction objectForKey:@"EtNotifItems"]) {
                parseDictionaryNotifTransaction = [parseDictionaryNotifTransaction objectForKey:@"EtNotifItems"];
                if ([parseDictionaryNotifTransaction objectForKey:@"item"]) {
                    parseDictionaryNotifTransaction = [parseDictionaryNotifTransaction objectForKey:@"item"];
                    if ([parseDictionaryNotifTransaction isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parseDictionaryNotifTransaction] forKey:@"resultNotifTransactions"];
                    }
                    else if([parseDictionaryNotifTransaction isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parseDictionaryNotifTransaction forKey:@"resultNotifTransactions"];
                    }
                }
            }
            
            if ([parseDictionaryNotifLongText objectForKey:@"EtNotifLongtext"]) {
                parseDictionaryNotifLongText = [parseDictionaryNotifLongText objectForKey:@"EtNotifLongtext"];
                if ([parseDictionaryNotifLongText objectForKey:@"item"]) {
                    parseDictionaryNotifLongText = [parseDictionaryNotifLongText objectForKey:@"item"];
                    if ([parseDictionaryNotifLongText isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parseDictionaryNotifLongText] forKey:@"resultNotifLongText"];
                    }
                    else if([parseDictionaryNotifLongText isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parseDictionaryNotifLongText forKey:@"resultNotifLongText"];
                    }
                }
            }
            
            if ([parseDictionaryDocs objectForKey:@"EtDocs"]) {
                parseDictionaryDocs = [parseDictionaryDocs objectForKey:@"EtDocs"];
                if ([parseDictionaryDocs objectForKey:@"item"]) {
                    parseDictionaryDocs = [parseDictionaryDocs objectForKey:@"item"];
                    if ([parseDictionaryDocs isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parseDictionaryDocs] forKey:@"resultDocs"];
                    }
                    else if([parseDictionaryDocs isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parseDictionaryDocs forKey:@"resultDocs"];
                    }
                }
            }
            
            if ([parseDictionaryHeader objectForKey:@"EtOrderHeader"]) {
                parseDictionaryHeader = [parseDictionaryHeader objectForKey:@"EtOrderHeader"];
                if ([parseDictionaryHeader objectForKey:@"item"]) {
                    parseDictionaryHeader = [parseDictionaryHeader objectForKey:@"item"];
                    if ([parseDictionaryHeader isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parseDictionaryHeader] forKey:@"resultHeader"];
                    }
                    else if([parseDictionaryHeader isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parseDictionaryHeader forKey:@"resultHeader"];
                    }
                }
            }
            
            if ([parseDictionaryHeaderPermits objectForKey:@"EtOrderPermits"]) {
                parseDictionaryHeaderPermits = [parseDictionaryHeaderPermits objectForKey:@"EtOrderPermits"];
                if ([parseDictionaryHeaderPermits objectForKey:@"item"]) {
                    parseDictionaryHeaderPermits = [parseDictionaryHeaderPermits objectForKey:@"item"];
                    if ([parseDictionaryHeaderPermits isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parseDictionaryHeaderPermits] forKey:@"resultHeaderPermits"];
                    }
                    else if([parseDictionaryHeaderPermits isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parseDictionaryHeaderPermits forKey:@"resultHeaderPermits"];
                    }
                }
            }
            
            if ([parseDictionaryOperationTransaction objectForKey:@"EtOrderOperations"]) {
                parseDictionaryOperationTransaction = [parseDictionaryOperationTransaction objectForKey:@"EtOrderOperations"];
                if ([parseDictionaryOperationTransaction objectForKey:@"item"]) {
                    parseDictionaryOperationTransaction = [parseDictionaryOperationTransaction objectForKey:@"item"];
                    if ([parseDictionaryOperationTransaction isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parseDictionaryOperationTransaction] forKey:@"resultOperationsTransactions"];
                    }
                    else if([parseDictionaryOperationTransaction isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parseDictionaryOperationTransaction forKey:@"resultOperationsTransactions"];
                    }
                }
            }
            
            if ([parseDictionaryComponentsTransaction objectForKey:@"EtOrderComponents"]) {
                parseDictionaryComponentsTransaction = [parseDictionaryComponentsTransaction objectForKey:@"EtOrderComponents"];
                if ([parseDictionaryComponentsTransaction objectForKey:@"item"]) {
                    parseDictionaryComponentsTransaction = [parseDictionaryComponentsTransaction objectForKey:@"item"];
                    if ([parseDictionaryComponentsTransaction isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parseDictionaryComponentsTransaction] forKey:@"resultComponentsTransactions"];
                    }
                    else if([parseDictionaryComponentsTransaction isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parseDictionaryComponentsTransaction forKey:@"resultComponentsTransactions"];
                    }
                }
            }
            
            if ([parseDictionaryLongText objectForKey:@"EtOrderLongtext"]) {
                parseDictionaryLongText = [parseDictionaryLongText objectForKey:@"EtOrderLongtext"];
                if ([parseDictionaryLongText objectForKey:@"item"]) {
                    parseDictionaryLongText = [parseDictionaryLongText objectForKey:@"item"];
                    if ([parseDictionaryLongText isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parseDictionaryLongText] forKey:@"resultLongText"];
                    }
                    else if([parseDictionaryLongText isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parseDictionaryLongText forKey:@"resultLongText"];
                    }
                }
            }
            
            if ([parseDictionaryWSM objectForKey:@"EtWsmOrdSafemeas"]) {
                parseDictionaryWSM = [parseDictionaryWSM objectForKey:@"EtWsmOrdSafemeas"];
                if ([parseDictionaryWSM objectForKey:@"item"]) {
                    parseDictionaryWSM = [parseDictionaryWSM objectForKey:@"item"];
                    if ([parseDictionaryWSM isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parseDictionaryWSM] forKey:@"resultWSMSafetyMeasures"];
                    }
                    else if([parseDictionaryWSM isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parseDictionaryWSM forKey:@"resultWSMSafetyMeasures"];
                    }
                }
            }
            
            if ([parsedDictionaryOrderStatus objectForKey:@"EtOrderStatus"]) {
                parsedDictionaryOrderStatus = [parsedDictionaryOrderStatus objectForKey:@"EtOrderStatus"];
                if ([parsedDictionaryOrderStatus objectForKey:@"item"]) {
                    parsedDictionaryOrderStatus = [parsedDictionaryOrderStatus objectForKey:@"item"];
                    if ([parsedDictionaryOrderStatus isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parsedDictionaryOrderStatus] forKey:@"resultOrderStatus"];
                    }
                    else if([parsedDictionaryOrderStatus isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parsedDictionaryOrderStatus forKey:@"resultOrderStatus"];
                    }
                }
            }
            
            
            
            
            
            return xmlDoc;
        }
    }
    return [NSMutableDictionary dictionary];
}

/*
 - (NSMutableDictionary *)parseForListOfOrders:(NSDictionary *)resultDictionary
 {
 NSMutableDictionary *xmlDoc = [NSMutableDictionary dictionary];
 NSDictionary *parseDictionary,*parseDictionaryHeaderPermits,*parseDictionaryOperationTransaction,*parseDictionaryComponentsTransaction,*parseDictionaryLongText;
 if ([resultDictionary objectForKey:@"env:Body"]) {
 
 parseDictionary = [resultDictionary objectForKey:@"env:Body"];
 if ([parseDictionary objectForKey:[Response actionWithWebServiceResponse:GET_LIST_OF_ORDERS]]) {
 parseDictionary = [parseDictionary objectForKey:[Response actionWithWebServiceResponse:GET_LIST_OF_ORDERS]];
 parseDictionaryHeaderPermits = parseDictionary;
 parseDictionaryOperationTransaction = parseDictionary;
 parseDictionaryComponentsTransaction = parseDictionary;
 parseDictionaryLongText = parseDictionary;
 
 if ([parseDictionary objectForKey:@"EtOrderHeader"]) {
 parseDictionary = [parseDictionary objectForKey:@"EtOrderHeader"];
 if ([parseDictionary objectForKey:@"item"]) {
 parseDictionary = [parseDictionary objectForKey:@"item"];
 if ([parseDictionary isKindOfClass:[NSDictionary class]]) {
 [xmlDoc setObject:[NSMutableArray arrayWithObject:parseDictionary] forKey:@"resultHeader"];
 }
 else if([parseDictionary isKindOfClass:[NSArray class]])
 {
 [xmlDoc setObject:parseDictionary forKey:@"resultHeader"];
 }
 }
 }
 
 if ([parseDictionaryHeaderPermits objectForKey:@"EtOrderPermits"]) {
 parseDictionaryHeaderPermits = [parseDictionaryHeaderPermits objectForKey:@"EtOrderPermits"];
 if ([parseDictionaryHeaderPermits objectForKey:@"item"]) {
 parseDictionaryHeaderPermits = [parseDictionaryHeaderPermits objectForKey:@"item"];
 if ([parseDictionaryHeaderPermits isKindOfClass:[NSDictionary class]]) {
 [xmlDoc setObject:[NSMutableArray arrayWithObject:parseDictionaryHeaderPermits] forKey:@"resultHeaderPermits"];
 }
 else if([parseDictionaryHeaderPermits isKindOfClass:[NSArray class]])
 {
 [xmlDoc setObject:parseDictionaryHeaderPermits forKey:@"resultHeaderPermits"];
 }
 }
 }
 
 if ([parseDictionaryOperationTransaction objectForKey:@"EtOrderOperations"]) {
 parseDictionaryOperationTransaction = [parseDictionaryOperationTransaction objectForKey:@"EtOrderOperations"];
 if ([parseDictionaryOperationTransaction objectForKey:@"item"]) {
 parseDictionaryOperationTransaction = [parseDictionaryOperationTransaction objectForKey:@"item"];
 if ([parseDictionaryOperationTransaction isKindOfClass:[NSDictionary class]]) {
 [xmlDoc setObject:[NSMutableArray arrayWithObject:parseDictionaryOperationTransaction] forKey:@"resultOperationsTransactions"];
 }
 else if([parseDictionaryOperationTransaction isKindOfClass:[NSArray class]])
 {
 [xmlDoc setObject:parseDictionaryOperationTransaction forKey:@"resultOperationsTransactions"];
 }
 }
 }
 
 if ([parseDictionaryComponentsTransaction objectForKey:@"EtOrderComponents"]) {
 parseDictionaryComponentsTransaction = [parseDictionaryComponentsTransaction objectForKey:@"EtOrderComponents"];
 if ([parseDictionaryComponentsTransaction objectForKey:@"item"]) {
 parseDictionaryComponentsTransaction = [parseDictionaryComponentsTransaction objectForKey:@"item"];
 if ([parseDictionaryComponentsTransaction isKindOfClass:[NSDictionary class]]) {
 [xmlDoc setObject:[NSMutableArray arrayWithObject:parseDictionaryComponentsTransaction] forKey:@"resultComponentsTransactions"];
 }
 else if([parseDictionaryComponentsTransaction isKindOfClass:[NSArray class]])
 {
 [xmlDoc setObject:parseDictionaryComponentsTransaction forKey:@"resultComponentsTransactions"];
 }
 }
 }
 
 if ([parseDictionaryLongText objectForKey:@"EtOrderLongtext"]) {
 parseDictionaryLongText = [parseDictionaryLongText objectForKey:@"EtOrderLongtext"];
 if ([parseDictionaryLongText objectForKey:@"item"]) {
 parseDictionaryLongText = [parseDictionaryLongText objectForKey:@"item"];
 if ([parseDictionaryLongText isKindOfClass:[NSDictionary class]]) {
 [xmlDoc setObject:[NSMutableArray arrayWithObject:parseDictionaryLongText] forKey:@"resultLongText"];
 }
 else if([parseDictionaryLongText isKindOfClass:[NSArray class]])
 {
 [xmlDoc setObject:parseDictionaryLongText forKey:@"resultLongText"];
 }
 }
 }
 
 return xmlDoc;
 
 }
 }
 return [NSMutableDictionary dictionary];
 }
 */

- (NSMutableDictionary *)parseForListOfDueOrders:(NSDictionary *)resultDictionary
{
    NSMutableDictionary *xmlDoc = [NSMutableDictionary dictionary];
    
    NSDictionary *parseDictionary,*parseDictionaryHeaderPermits,*parseDictionaryOperationTransaction,*parseDictionaryComponentsTransaction,*parseDictionaryLongText,*parseDictionaryDocs,*parseDictionaryWSM,*parseDictionaryObjects,*parsedDictionaryOrderStatus,*parsedDictionaryOrderOlist,*parsedDictionaryCheckPoints,*parsedDictionaryWorkApplications,*parsedDictionaryWcagns,*parsedDictionaryOpWCDDetails,*parsedDictionaryOpWCDItemDetails,*parsedDictionaryWorkApprovalDetails,*parsedDictionaryMeasurementDocuments;
    
    if ([resultDictionary objectForKey:@"env:Body"]) {
        
        parseDictionary = [resultDictionary objectForKey:@"env:Body"];
        if ([parseDictionary objectForKey:[Response actionWithWebServiceResponse:GET_LIST_OF_DUE_ORDERS]]) {
            parseDictionary = [parseDictionary objectForKey:[Response actionWithWebServiceResponse:GET_LIST_OF_DUE_ORDERS]];
            parseDictionaryHeaderPermits = parseDictionary;
            parseDictionaryOperationTransaction = parseDictionary;
            parseDictionaryComponentsTransaction = parseDictionary;
            parseDictionaryLongText = parseDictionary;
            parseDictionaryDocs = parseDictionary;
            parseDictionaryWSM = parseDictionary;
            parseDictionaryObjects = parseDictionary;
            parsedDictionaryOrderStatus = parseDictionary;
            parsedDictionaryOrderOlist = parseDictionary;
            parsedDictionaryCheckPoints = parseDictionary;
            parsedDictionaryWorkApplications = parseDictionary;
            parsedDictionaryWcagns = parseDictionary;
            parsedDictionaryOpWCDDetails = parseDictionary;
            parsedDictionaryOpWCDItemDetails = parseDictionary;
            parsedDictionaryWorkApprovalDetails = parseDictionary;
            parsedDictionaryMeasurementDocuments = parseDictionary;
            
            if ([parseDictionary objectForKey:@"EtOrderHeader"]) {
                parseDictionary = [parseDictionary objectForKey:@"EtOrderHeader"];
                if ([parseDictionary objectForKey:@"item"]) {
                    parseDictionary = [parseDictionary objectForKey:@"item"];
                    if ([parseDictionary isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parseDictionary] forKey:@"resultHeader"];
                    }
                    else if([parseDictionary isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parseDictionary forKey:@"resultHeader"];
                    }
                }
            }
            
            if ([parseDictionaryObjects objectForKey:@"EtOrderOlist"]) {
                parseDictionaryObjects = [parseDictionaryObjects objectForKey:@"EtOrderOlist"];
                if ([parseDictionaryObjects objectForKey:@"item"]) {
                    parseDictionaryObjects = [parseDictionaryObjects objectForKey:@"item"];
                    if ([parseDictionaryObjects isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parseDictionaryObjects] forKey:@"resultHeaderObjects"];
                    }
                    else if([parseDictionaryObjects isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parseDictionaryObjects forKey:@"resultHeaderObjects"];
                    }
                }
            }
            
            if ([parsedDictionaryMeasurementDocuments objectForKey:@"EtImrg"]) {
                parsedDictionaryMeasurementDocuments = [parsedDictionaryMeasurementDocuments objectForKey:@"EtImrg"];
                if ([parsedDictionaryMeasurementDocuments objectForKey:@"item"]) {
                    parsedDictionaryMeasurementDocuments = [parsedDictionaryMeasurementDocuments objectForKey:@"item"];
                    if ([parsedDictionaryMeasurementDocuments isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parsedDictionaryMeasurementDocuments] forKey:@"resultMeasurementDocuments"];
                    }
                    else if([parsedDictionaryMeasurementDocuments isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parsedDictionaryMeasurementDocuments forKey:@"resultMeasurementDocuments"];
                    }
                }
            }
            
            if ([parseDictionaryHeaderPermits objectForKey:@"EtOrderPermits"]) {
                parseDictionaryHeaderPermits = [parseDictionaryHeaderPermits objectForKey:@"EtOrderPermits"];
                if ([parseDictionaryHeaderPermits objectForKey:@"item"]) {
                    parseDictionaryHeaderPermits = [parseDictionaryHeaderPermits objectForKey:@"item"];
                    if ([parseDictionaryHeaderPermits isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parseDictionaryHeaderPermits] forKey:@"resultHeaderPermits"];
                    }
                    else if([parseDictionaryHeaderPermits isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parseDictionaryHeaderPermits forKey:@"resultHeaderPermits"];
                    }
                }
            }
            
            if ([parseDictionaryOperationTransaction objectForKey:@"EtOrderOperations"]) {
                parseDictionaryOperationTransaction = [parseDictionaryOperationTransaction objectForKey:@"EtOrderOperations"];
                if ([parseDictionaryOperationTransaction objectForKey:@"item"]) {
                    parseDictionaryOperationTransaction = [parseDictionaryOperationTransaction objectForKey:@"item"];
                    if ([parseDictionaryOperationTransaction isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parseDictionaryOperationTransaction] forKey:@"resultOperationsTransactions"];
                    }
                    else if([parseDictionaryOperationTransaction isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parseDictionaryOperationTransaction forKey:@"resultOperationsTransactions"];
                    }
                }
            }
            
            if ([parseDictionaryComponentsTransaction objectForKey:@"EtOrderComponents"]) {
                parseDictionaryComponentsTransaction = [parseDictionaryComponentsTransaction objectForKey:@"EtOrderComponents"];
                if ([parseDictionaryComponentsTransaction objectForKey:@"item"]) {
                    parseDictionaryComponentsTransaction = [parseDictionaryComponentsTransaction objectForKey:@"item"];
                    if ([parseDictionaryComponentsTransaction isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parseDictionaryComponentsTransaction] forKey:@"resultComponentsTransactions"];
                    }
                    else if([parseDictionaryComponentsTransaction isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parseDictionaryComponentsTransaction forKey:@"resultComponentsTransactions"];
                    }
                }
            }
            
            if ([parseDictionaryLongText objectForKey:@"EtOrderLongtext"]) {
                parseDictionaryLongText = [parseDictionaryLongText objectForKey:@"EtOrderLongtext"];
                if ([parseDictionaryLongText objectForKey:@"item"]) {
                    parseDictionaryLongText = [parseDictionaryLongText objectForKey:@"item"];
                    if ([parseDictionaryLongText isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parseDictionaryLongText] forKey:@"resultLongText"];
                    }
                    else if([parseDictionaryLongText isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parseDictionaryLongText forKey:@"resultLongText"];
                    }
                }
            }
            
            if ([parseDictionaryDocs objectForKey:@"EtDocs"]) {
                parseDictionaryDocs = [parseDictionaryDocs objectForKey:@"EtDocs"];
                if ([parseDictionaryDocs objectForKey:@"item"]) {
                    parseDictionaryDocs = [parseDictionaryDocs objectForKey:@"item"];
                    if ([parseDictionaryDocs isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parseDictionaryDocs] forKey:@"resultDocs"];
                    }
                    else if([parseDictionaryDocs isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parseDictionaryDocs forKey:@"resultDocs"];
                    }
                }
            }
            
            if ([parseDictionaryWSM objectForKey:@"EtWsmOrdSafemeas"]) {
                parseDictionaryWSM = [parseDictionaryWSM objectForKey:@"EtWsmOrdSafemeas"];
                if ([parseDictionaryWSM objectForKey:@"item"]) {
                    parseDictionaryWSM = [parseDictionaryWSM objectForKey:@"item"];
                    if ([parseDictionaryWSM isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parseDictionaryWSM] forKey:@"resultWSMSafetyMeasures"];
                    }
                    else if([parseDictionaryWSM isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parseDictionaryWSM forKey:@"resultWSMSafetyMeasures"];
                    }
                }
            }
            
            if ([parsedDictionaryOrderStatus objectForKey:@"EtOrderStatus"]) {
                parsedDictionaryOrderStatus = [parsedDictionaryOrderStatus objectForKey:@"EtOrderStatus"];
                if ([parsedDictionaryOrderStatus objectForKey:@"item"]) {
                    parsedDictionaryOrderStatus = [parsedDictionaryOrderStatus objectForKey:@"item"];
                    if ([parsedDictionaryOrderStatus isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parsedDictionaryOrderStatus] forKey:@"resultOrderStatus"];
                    }
                    else if([parsedDictionaryOrderStatus isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parsedDictionaryOrderStatus forKey:@"resultOrderStatus"];
                    }
                }
            }
            
            if ([parsedDictionaryOrderOlist objectForKey:@"EtOrderOlist"]) {
                parsedDictionaryOrderOlist = [parsedDictionaryOrderOlist objectForKey:@"EtOrderOlist"];
                if ([parsedDictionaryOrderOlist objectForKey:@"item"]) {
                    parsedDictionaryOrderOlist = [parsedDictionaryOrderOlist objectForKey:@"item"];
                    if ([parsedDictionaryOrderOlist isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parsedDictionaryOrderOlist] forKey:@"resultOrderOlist"];
                    }
                    else if([parsedDictionaryOrderOlist isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parsedDictionaryOrderOlist forKey:@"resultOrderOlist"];
                    }
                }
            }
            
            //WCM
            if ([parsedDictionaryCheckPoints objectForKey:@"EtWcmWaChkReq"]) {
                parsedDictionaryCheckPoints = [parsedDictionaryCheckPoints objectForKey:@"EtWcmWaChkReq"];
                if ([parsedDictionaryCheckPoints objectForKey:@"item"]) {
                    parsedDictionaryCheckPoints = [parsedDictionaryCheckPoints objectForKey:@"item"];
                    if ([parsedDictionaryCheckPoints isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parsedDictionaryCheckPoints] forKey:@"resultStandardCheckPoints"];
                    }
                    else if([parsedDictionaryCheckPoints isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parsedDictionaryCheckPoints forKey:@"resultStandardCheckPoints"];
                    }
                }
            }
            
            if ([parsedDictionaryWorkApplications objectForKey:@"EtWcmWaData"]) {
                parsedDictionaryWorkApplications = [parsedDictionaryWorkApplications objectForKey:@"EtWcmWaData"];
                if ([parsedDictionaryWorkApplications objectForKey:@"item"]) {
                    parsedDictionaryWorkApplications = [parsedDictionaryWorkApplications objectForKey:@"item"];
                    if ([parsedDictionaryWorkApplications isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parsedDictionaryWorkApplications] forKey:@"resultWorkApplicationData"];
                    }
                    else if([parsedDictionaryWorkApplications isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parsedDictionaryWorkApplications forKey:@"resultWorkApplicationData"];
                    }
                }
            }
            
            if ([parsedDictionaryWcagns objectForKey:@"EtWcmWcagns"]) {
                parsedDictionaryWcagns = [parsedDictionaryWcagns objectForKey:@"EtWcmWcagns"];
                if ([parsedDictionaryWcagns objectForKey:@"item"]) {
                    parsedDictionaryWcagns = [parsedDictionaryWcagns objectForKey:@"item"];
                    if ([parsedDictionaryWcagns isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parsedDictionaryWcagns] forKey:@"resultIssuePermits"];//issue permits
                    }
                    else if([parsedDictionaryWcagns isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parsedDictionaryWcagns forKey:@"resultIssuePermits"];//issue permits
                    }
                }
            }
            
            if ([parsedDictionaryOpWCDDetails objectForKey:@"EtWcmWdData"]) {
                parsedDictionaryOpWCDDetails = [parsedDictionaryOpWCDDetails objectForKey:@"EtWcmWdData"];
                if ([parsedDictionaryOpWCDDetails objectForKey:@"item"]) {
                    parsedDictionaryOpWCDDetails = [parsedDictionaryOpWCDDetails objectForKey:@"item"];
                    if ([parsedDictionaryOpWCDDetails isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parsedDictionaryOpWCDDetails] forKey:@"resultOperationWCDData"];//isolation
                    }
                    else if([parsedDictionaryOpWCDDetails isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parsedDictionaryOpWCDDetails forKey:@"resultOperationWCDData"];//isolation
                    }
                }
            }
            
            if ([parsedDictionaryOpWCDItemDetails objectForKey:@"EtWcmWdItemData"]) {
                parsedDictionaryOpWCDItemDetails = [parsedDictionaryOpWCDItemDetails objectForKey:@"EtWcmWdItemData"];
                if ([parsedDictionaryOpWCDItemDetails objectForKey:@"item"]) {
                    parsedDictionaryOpWCDItemDetails = [parsedDictionaryOpWCDItemDetails objectForKey:@"item"];
                    if ([parsedDictionaryOpWCDItemDetails isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parsedDictionaryOpWCDItemDetails] forKey:@"resultOperationWCDItemData"];//tagging conditions
                    }
                    else if([parsedDictionaryOpWCDItemDetails isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parsedDictionaryOpWCDItemDetails forKey:@"resultOperationWCDItemData"];//tagging conditions
                    }
                }
            }
            
            if ([parsedDictionaryWorkApprovalDetails objectForKey:@"EtWcmWwData"]) {
                parsedDictionaryWorkApprovalDetails = [parsedDictionaryWorkApprovalDetails objectForKey:@"EtWcmWwData"];
                if ([parsedDictionaryWorkApprovalDetails objectForKey:@"item"]) {
                    parsedDictionaryWorkApprovalDetails = [parsedDictionaryWorkApprovalDetails objectForKey:@"item"];
                    if ([parsedDictionaryWorkApprovalDetails isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parsedDictionaryWorkApprovalDetails] forKey:@"resultWorkApprovalsData"];
                    }
                    else if([parsedDictionaryWorkApprovalDetails isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parsedDictionaryWorkApprovalDetails forKey:@"resultWorkApprovalsData"];
                    }
                }
            }
            
            return xmlDoc;
        }
    }
    
    return [NSMutableDictionary dictionary];
}

- (NSMutableDictionary *)parseForChangeOrder:(NSDictionary *)resultDictionary
{
    NSMutableDictionary *xmlDoc = [NSMutableDictionary dictionary];
    id parseDictionary,parseDictionaryNo,parseDictionaryHeader,parseDictionaryHeaderPermits,parseDictionaryOperationTransaction,parseDictionaryComponentsTransaction,parseDictionaryLongText,parseDictionaryDocs,parseDictionaryWSM,parsedDictionaryOrderStatus,parsedDictionaryCheckPoints,parsedDictionaryWorkApplications,parsedDictionaryWcagns,parsedDictionaryOpWCDDetails,parsedDictionaryOpWCDItemDetails,parsedDictionaryWorkApprovalDetails,parsedDictionaryMeasurementDocuments;
    
    if ([resultDictionary objectForKey:@"env:Body"]) {
        
        parseDictionary = [resultDictionary objectForKey:@"env:Body"];
        if ([parseDictionary objectForKey:[Response actionWithWebServiceResponse:ORDER_CHANGE]]) {
            parseDictionary = [parseDictionary objectForKey:[Response actionWithWebServiceResponse:ORDER_CHANGE]];
            
            parseDictionaryNo = parseDictionary;
            parseDictionaryHeader=parseDictionary;
            parseDictionaryHeaderPermits = parseDictionary;
            parseDictionaryOperationTransaction = parseDictionary;
            parseDictionaryComponentsTransaction = parseDictionary;
            parseDictionaryLongText = parseDictionary;
            parseDictionaryDocs = parseDictionary;
            parseDictionaryWSM = parseDictionary;
            parsedDictionaryOrderStatus = parseDictionary;
            
            parsedDictionaryCheckPoints = parseDictionary;
            parsedDictionaryWorkApplications = parseDictionary;
            parsedDictionaryWcagns = parseDictionary;
            parsedDictionaryOpWCDDetails = parseDictionary;
            parsedDictionaryOpWCDItemDetails = parseDictionary;
            parsedDictionaryWorkApprovalDetails = parseDictionary;
            parsedDictionaryMeasurementDocuments = parseDictionary;
            
            if ([parseDictionary objectForKey:@"EtMessage"]) {
                parseDictionary = [parseDictionary objectForKey:@"EtMessage"];
                if ([parseDictionary objectForKey:@"item"]) {
                    parseDictionary = [parseDictionary objectForKey:@"item"];
                    if ([parseDictionary isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc addEntriesFromDictionary:parseDictionary];
                    }
                    else if([parseDictionary isKindOfClass:[NSArray class]])
                    {
                        NSMutableString *messageString = [[NSMutableString alloc] initWithString:@""];
                        
                        for (int i=0; i<[parseDictionary count]; i++) {
                            [messageString appendFormat:@"%@",[[parseDictionary objectAtIndex:i] objectForKey:@"Message"]];
                            if (i<[parseDictionary count]-1) {
                                [messageString appendFormat:@"\n"];
                            }
                        }
                        
                        [xmlDoc setObject:messageString forKey:@"Message"];
                    }
                }
            }
            
            if ([parseDictionaryNo objectForKey:@"EvOrderNo"]) {
                
                parseDictionaryNo = [parseDictionaryNo objectForKey:@"EvOrderNo"];
                
                [xmlDoc setObject:parseDictionaryNo forKey:@"OBJECTID"];
            }
            
            if ([parseDictionaryHeader objectForKey:@"EtOrderHeader"]) {
                parseDictionaryHeader = [parseDictionaryHeader objectForKey:@"EtOrderHeader"];
                if ([parseDictionaryHeader objectForKey:@"item"]) {
                    parseDictionaryHeader = [parseDictionaryHeader objectForKey:@"item"];
                    if ([parseDictionaryHeader isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parseDictionaryHeader] forKey:@"resultHeader"];
                    }
                    else if([parseDictionaryHeader isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parseDictionaryHeader forKey:@"resultHeader"];
                    }
                }
            }
            
            if ([parseDictionaryHeaderPermits objectForKey:@"EtOrderPermits"]) {
                parseDictionaryHeaderPermits = [parseDictionaryHeaderPermits objectForKey:@"EtOrderPermits"];
                if ([parseDictionaryHeaderPermits objectForKey:@"item"]) {
                    parseDictionaryHeaderPermits = [parseDictionaryHeaderPermits objectForKey:@"item"];
                    if ([parseDictionaryHeaderPermits isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parseDictionaryHeaderPermits] forKey:@"resultHeaderPermits"];
                    }
                    else if([parseDictionaryHeaderPermits isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parseDictionaryHeaderPermits forKey:@"resultHeaderPermits"];
                    }
                }
            }
            
            if ([parseDictionaryOperationTransaction objectForKey:@"EtOrderOperations"]) {
                parseDictionaryOperationTransaction = [parseDictionaryOperationTransaction objectForKey:@"EtOrderOperations"];
                if ([parseDictionaryOperationTransaction objectForKey:@"item"]) {
                    parseDictionaryOperationTransaction = [parseDictionaryOperationTransaction objectForKey:@"item"];
                    if ([parseDictionaryOperationTransaction isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parseDictionaryOperationTransaction] forKey:@"resultOperationsTransactions"];
                    }
                    else if([parseDictionaryOperationTransaction isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parseDictionaryOperationTransaction forKey:@"resultOperationsTransactions"];
                    }
                }
            }
            
            if ([parseDictionaryComponentsTransaction objectForKey:@"EtOrderComponents"]) {
                parseDictionaryComponentsTransaction = [parseDictionaryComponentsTransaction objectForKey:@"EtOrderComponents"];
                if ([parseDictionaryComponentsTransaction objectForKey:@"item"]) {
                    parseDictionaryComponentsTransaction = [parseDictionaryComponentsTransaction objectForKey:@"item"];
                    if ([parseDictionaryComponentsTransaction isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parseDictionaryComponentsTransaction] forKey:@"resultComponentsTransactions"];
                    }
                    else if([parseDictionaryComponentsTransaction isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parseDictionaryComponentsTransaction forKey:@"resultComponentsTransactions"];
                    }
                }
            }
            
            if ([parseDictionaryLongText objectForKey:@"EtOrderLongtext"]) {
                parseDictionaryLongText = [parseDictionaryLongText objectForKey:@"EtOrderLongtext"];
                if ([parseDictionaryLongText objectForKey:@"item"]) {
                    parseDictionaryLongText = [parseDictionaryLongText objectForKey:@"item"];
                    if ([parseDictionaryLongText isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parseDictionaryLongText] forKey:@"resultLongText"];
                    }
                    else if([parseDictionaryLongText isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parseDictionaryLongText forKey:@"resultLongText"];
                    }
                }
            }
            
            if ([parseDictionaryDocs objectForKey:@"EtDocs"]) {
                parseDictionaryDocs = [parseDictionaryDocs objectForKey:@"EtDocs"];
                if ([parseDictionaryDocs objectForKey:@"item"]) {
                    parseDictionaryDocs = [parseDictionaryDocs objectForKey:@"item"];
                    if ([parseDictionaryDocs isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parseDictionaryDocs] forKey:@"resultDocs"];
                    }
                    else if([parseDictionaryDocs isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parseDictionaryDocs forKey:@"resultDocs"];
                    }
                }
            }
            
            if ([parseDictionaryWSM objectForKey:@"EtWsmOrdSafemeas"]) {
                parseDictionaryWSM = [parseDictionaryWSM objectForKey:@"EtWsmOrdSafemeas"];
                if ([parseDictionaryWSM objectForKey:@"item"]) {
                    parseDictionaryWSM = [parseDictionaryWSM objectForKey:@"item"];
                    if ([parseDictionaryWSM isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parseDictionaryWSM] forKey:@"resultWSMSafetyMeasures"];
                    }
                    else if([parseDictionaryWSM isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parseDictionaryWSM forKey:@"resultWSMSafetyMeasures"];
                    }
                }
            }
            
            if ([parsedDictionaryOrderStatus objectForKey:@"EtOrderStatus"]) {
                parsedDictionaryOrderStatus = [parsedDictionaryOrderStatus objectForKey:@"EtOrderStatus"];
                if ([parsedDictionaryOrderStatus objectForKey:@"item"]) {
                    parsedDictionaryOrderStatus = [parsedDictionaryOrderStatus objectForKey:@"item"];
                    if ([parsedDictionaryOrderStatus isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parsedDictionaryOrderStatus] forKey:@"resultOrderStatus"];
                    }
                    else if([parsedDictionaryOrderStatus isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parsedDictionaryOrderStatus forKey:@"resultOrderStatus"];
                    }
                }
            }
            
            
            //WCM
            if ([parsedDictionaryCheckPoints objectForKey:@"EtWcmWaChkReq"]) {
                parsedDictionaryCheckPoints = [parsedDictionaryCheckPoints objectForKey:@"EtWcmWaChkReq"];
                if ([parsedDictionaryCheckPoints objectForKey:@"item"]) {
                    parsedDictionaryCheckPoints = [parsedDictionaryCheckPoints objectForKey:@"item"];
                    if ([parsedDictionaryCheckPoints isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parsedDictionaryCheckPoints] forKey:@"resultStandardCheckPoints"];
                    }
                    else if([parsedDictionaryCheckPoints isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parsedDictionaryCheckPoints forKey:@"resultStandardCheckPoints"];
                    }
                }
            }
            
            if ([parsedDictionaryWorkApplications objectForKey:@"EtWcmWaData"]) {
                parsedDictionaryWorkApplications = [parsedDictionaryWorkApplications objectForKey:@"EtWcmWaData"];
                if ([parsedDictionaryWorkApplications objectForKey:@"item"]) {
                    parsedDictionaryWorkApplications = [parsedDictionaryWorkApplications objectForKey:@"item"];
                    if ([parsedDictionaryWorkApplications isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parsedDictionaryWorkApplications] forKey:@"resultWorkApplicationData"];
                    }
                    else if([parsedDictionaryWorkApplications isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parsedDictionaryWorkApplications forKey:@"resultWorkApplicationData"];
                    }
                }
            }
            
            if ([parsedDictionaryWcagns objectForKey:@"EtWcmWcagns"]) {
                parsedDictionaryWcagns = [parsedDictionaryWcagns objectForKey:@"EtWcmWcagns"];
                if ([parsedDictionaryWcagns objectForKey:@"item"]) {
                    parsedDictionaryWcagns = [parsedDictionaryWcagns objectForKey:@"item"];
                    if ([parsedDictionaryWcagns isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parsedDictionaryWcagns] forKey:@"resultIssuePermits"];//issue permits
                    }
                    else if([parsedDictionaryWcagns isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parsedDictionaryWcagns forKey:@"resultIssuePermits"];//issue permits
                    }
                }
            }
            
            if ([parsedDictionaryOpWCDDetails objectForKey:@"EtWcmWdData"]) {
                parsedDictionaryOpWCDDetails = [parsedDictionaryOpWCDDetails objectForKey:@"EtWcmWdData"];
                if ([parsedDictionaryOpWCDDetails objectForKey:@"item"]) {
                    parsedDictionaryOpWCDDetails = [parsedDictionaryOpWCDDetails objectForKey:@"item"];
                    if ([parsedDictionaryOpWCDDetails isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parsedDictionaryOpWCDDetails] forKey:@"resultOperationWCDData"];//isolation
                    }
                    else if([parsedDictionaryOpWCDDetails isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parsedDictionaryOpWCDDetails forKey:@"resultOperationWCDData"];//isolation
                    }
                }
            }
            
            if ([parsedDictionaryOpWCDItemDetails objectForKey:@"EtWcmWdItemData"]) {
                parsedDictionaryOpWCDItemDetails = [parsedDictionaryOpWCDItemDetails objectForKey:@"EtWcmWdItemData"];
                if ([parsedDictionaryOpWCDItemDetails objectForKey:@"item"]) {
                    parsedDictionaryOpWCDItemDetails = [parsedDictionaryOpWCDItemDetails objectForKey:@"item"];
                    if ([parsedDictionaryOpWCDItemDetails isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parsedDictionaryOpWCDItemDetails] forKey:@"resultOperationWCDItemData"];//tagging conditions
                    }
                    else if([parsedDictionaryOpWCDItemDetails isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parsedDictionaryOpWCDItemDetails forKey:@"resultOperationWCDItemData"];//tagging conditions
                    }
                }
            }
            
            if ([parsedDictionaryWorkApprovalDetails objectForKey:@"EtWcmWwData"]) {
                parsedDictionaryWorkApprovalDetails = [parsedDictionaryWorkApprovalDetails objectForKey:@"EtWcmWwData"];
                if ([parsedDictionaryWorkApprovalDetails objectForKey:@"item"]) {
                    parsedDictionaryWorkApprovalDetails = [parsedDictionaryWorkApprovalDetails objectForKey:@"item"];
                    if ([parsedDictionaryWorkApprovalDetails isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parsedDictionaryWorkApprovalDetails] forKey:@"resultWorkApprovalsData"];
                    }
                    else if([parsedDictionaryWorkApprovalDetails isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parsedDictionaryWorkApprovalDetails forKey:@"resultWorkApprovalsData"];
                    }
                }
            }
            
            
            return xmlDoc;
            
        }
    }
    return [NSMutableDictionary dictionary];
    
}

- (NSMutableDictionary *)parseForCancelOrder:(NSDictionary *)resultDictionary
{
    NSMutableDictionary *xmlDoc = [NSMutableDictionary dictionary];
    id parseDictionary,parseDictionaryNo;
    if ([resultDictionary objectForKey:@"env:Body"]) {
        
        parseDictionary = [resultDictionary objectForKey:@"env:Body"];
        if ([parseDictionary objectForKey:[Response actionWithWebServiceResponse:ORDER_CANCEL]]) {
            parseDictionary = [parseDictionary objectForKey:[Response actionWithWebServiceResponse:ORDER_CANCEL]];
            
            parseDictionaryNo = parseDictionary;
            
            if ([parseDictionary objectForKey:@"EtMessage"]) {
                parseDictionary = [parseDictionary objectForKey:@"EtMessage"];
                if ([parseDictionary objectForKey:@"item"]) {
                    parseDictionary = [parseDictionary objectForKey:@"item"];
                    if ([parseDictionary isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:[parseDictionary objectForKey:@"Message"]] forKey:@"Message"];
                    }
                    else if([parseDictionary isKindOfClass:[NSArray class]])
                    {
                        NSMutableArray *messageID = [[NSMutableArray alloc]init];
                        for (int i=0; i<[parseDictionary count]; i++) {
                            [messageID addObject:[[parseDictionary objectAtIndex:i] objectForKey:@"Message"]];
                        }
                        [xmlDoc setObject:messageID forKey:@"Message"];
                    }
                }
            }
            if ([parseDictionaryNo objectForKey:@"EvOrderNo"]) {
                parseDictionaryNo = [parseDictionaryNo objectForKey:@"EvOrderNo"];
                
                [xmlDoc setObject:parseDictionaryNo forKey:@"OBJECTID"];
                
            }
            
            return xmlDoc;
            
        }
    }
    
    return [NSMutableDictionary dictionary];
}

- (NSMutableDictionary *)parseForConfirmOrder:(NSDictionary *)resultDictionary
{
    NSMutableDictionary *xmlDoc = [NSMutableDictionary dictionary];
    id parseDictionary,parseDictionaryNo,parseDictionaryHeader,parseDictionaryHeaderPermits,parseDictionaryOperationTransaction,parseDictionaryComponentsTransaction,parseDictionaryLongText,parseDictionaryDocs;
    
    if ([resultDictionary objectForKey:@"env:Body"]) {
        
        parseDictionary = [resultDictionary objectForKey:@"env:Body"];
        if ([parseDictionary objectForKey:[Response actionWithWebServiceResponse:ORDER_CONFIRM]]) {
            parseDictionary = [parseDictionary objectForKey:[Response actionWithWebServiceResponse:ORDER_CONFIRM]];
            
            parseDictionaryNo = parseDictionary;
            parseDictionaryHeader=parseDictionary;
            parseDictionaryHeaderPermits = parseDictionary;
            parseDictionaryOperationTransaction = parseDictionary;
            parseDictionaryComponentsTransaction = parseDictionary;
            parseDictionaryLongText = parseDictionary;
            parseDictionaryDocs = parseDictionary;
            
            if ([parseDictionary objectForKey:@"EtMessage"]) {
                parseDictionary = [parseDictionary objectForKey:@"EtMessage"];
                if ([parseDictionary objectForKey:@"item"]) {
                    parseDictionary = [parseDictionary objectForKey:@"item"];
                    if ([parseDictionary isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSArray arrayWithObjects:[parseDictionary objectForKey:@"Message"], nil] forKey:@"Message"];
                    }
                    else if([parseDictionary isKindOfClass:[NSArray class]])
                    {
                        NSMutableArray *messageID = [[NSMutableArray alloc]init];
                        for (int i=0; i<[parseDictionary count]; i++) {
                            [messageID addObject:[[parseDictionary objectAtIndex:i] objectForKey:@"Message"]];
                        }
                        [xmlDoc setObject:messageID forKey:@"Message"];
                    }
                }
            }
            if ([parseDictionaryNo objectForKey:@"EvOrderNo"]) {
                parseDictionaryNo = [parseDictionaryNo objectForKey:@"EvOrderNo"];
                
                [xmlDoc setObject:parseDictionaryNo forKey:@"OBJECTID"];
                
            }
            
            if ([parseDictionaryHeader objectForKey:@"EtOrderHeader"]) {
                parseDictionaryHeader = [parseDictionaryHeader objectForKey:@"EtOrderHeader"];
                if ([parseDictionaryHeader objectForKey:@"item"]) {
                    parseDictionaryHeader = [parseDictionaryHeader objectForKey:@"item"];
                    if ([parseDictionaryHeader isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parseDictionaryHeader] forKey:@"resultHeader"];
                    }
                    else if([parseDictionaryHeader isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parseDictionaryHeader forKey:@"resultHeader"];
                    }
                }
            }
            
            if ([parseDictionaryHeaderPermits objectForKey:@"EtOrderPermits"]) {
                parseDictionaryHeaderPermits = [parseDictionaryHeaderPermits objectForKey:@"EtOrderPermits"];
                if ([parseDictionaryHeaderPermits objectForKey:@"item"]) {
                    parseDictionaryHeaderPermits = [parseDictionaryHeaderPermits objectForKey:@"item"];
                    if ([parseDictionaryHeaderPermits isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parseDictionaryHeaderPermits] forKey:@"resultHeaderPermits"];
                    }
                    else if([parseDictionaryHeaderPermits isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parseDictionaryHeaderPermits forKey:@"resultHeaderPermits"];
                    }
                }
            }
            
            if ([parseDictionaryOperationTransaction objectForKey:@"EtOrderOperations"]) {
                parseDictionaryOperationTransaction = [parseDictionaryOperationTransaction objectForKey:@"EtOrderOperations"];
                if ([parseDictionaryOperationTransaction objectForKey:@"item"]) {
                    parseDictionaryOperationTransaction = [parseDictionaryOperationTransaction objectForKey:@"item"];
                    if ([parseDictionaryOperationTransaction isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parseDictionaryOperationTransaction] forKey:@"resultOperationsTransactions"];
                    }
                    else if([parseDictionaryOperationTransaction isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parseDictionaryOperationTransaction forKey:@"resultOperationsTransactions"];
                    }
                }
            }
            
            if ([parseDictionaryComponentsTransaction objectForKey:@"EtOrderComponents"]) {
                parseDictionaryComponentsTransaction = [parseDictionaryComponentsTransaction objectForKey:@"EtOrderComponents"];
                if ([parseDictionaryComponentsTransaction objectForKey:@"item"]) {
                    parseDictionaryComponentsTransaction = [parseDictionaryComponentsTransaction objectForKey:@"item"];
                    if ([parseDictionaryComponentsTransaction isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parseDictionaryComponentsTransaction] forKey:@"resultComponentsTransactions"];
                    }
                    else if([parseDictionaryComponentsTransaction isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parseDictionaryComponentsTransaction forKey:@"resultComponentsTransactions"];
                    }
                }
            }
            
            if ([parseDictionaryLongText objectForKey:@"EtOrderLongtext"]) {
                parseDictionaryLongText = [parseDictionaryLongText objectForKey:@"EtOrderLongtext"];
                if ([parseDictionaryLongText objectForKey:@"item"]) {
                    parseDictionaryLongText = [parseDictionaryLongText objectForKey:@"item"];
                    if ([parseDictionaryLongText isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parseDictionaryLongText] forKey:@"resultLongText"];
                    }
                    else if([parseDictionaryLongText isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parseDictionaryLongText forKey:@"resultLongText"];
                    }
                }
            }
            
            if ([parseDictionaryDocs objectForKey:@"EtDocs"]) {
                parseDictionaryDocs = [parseDictionaryDocs objectForKey:@"EtDocs"];
                if ([parseDictionaryDocs objectForKey:@"item"]) {
                    parseDictionaryDocs = [parseDictionaryDocs objectForKey:@"item"];
                    if ([parseDictionaryDocs isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parseDictionaryDocs] forKey:@"resultDocs"];
                    }
                    else if([parseDictionaryDocs isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parseDictionaryDocs forKey:@"resultDocs"];
                    }
                }
            }
            
            return xmlDoc;
            
        }
    }
    
    return [NSMutableDictionary dictionary];
}

- (NSMutableDictionary *)parseForColletctiveConfirmOrder:(NSDictionary *)resultDictionary
{
    NSMutableDictionary *xmlDoc = [NSMutableDictionary dictionary];
    id parseDictionary,parseDictionaryNo,parseDictionaryHeader,parseDictionaryHeaderPermits,parseDictionaryOperationTransaction,parseDictionaryComponentsTransaction,parseDictionaryLongText,parseDictionaryDocs;
    
    if ([resultDictionary objectForKey:@"env:Body"]) {
        
        parseDictionary = [resultDictionary objectForKey:@"env:Body"];
        if ([parseDictionary objectForKey:[Response actionWithWebServiceResponse:ORDER_COLLECTIVE_CONFIRMATION]]) {
            parseDictionary = [parseDictionary objectForKey:[Response actionWithWebServiceResponse:ORDER_COLLECTIVE_CONFIRMATION]];
            
            parseDictionaryNo = parseDictionary;
            parseDictionaryHeader=parseDictionary;
            parseDictionaryHeaderPermits = parseDictionary;
            parseDictionaryOperationTransaction = parseDictionary;
            parseDictionaryComponentsTransaction = parseDictionary;
            parseDictionaryLongText = parseDictionary;
            parseDictionaryDocs = parseDictionary;
            
            if ([parseDictionary objectForKey:@"EtMessage"]) {
                parseDictionary = [parseDictionary objectForKey:@"EtMessage"];
                if ([parseDictionary objectForKey:@"item"]) {
                    parseDictionary = [parseDictionary objectForKey:@"item"];
                    if ([parseDictionary isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSArray arrayWithObjects:[parseDictionary objectForKey:@"Message"], nil] forKey:@"Message"];
                    }
                    else if([parseDictionary isKindOfClass:[NSArray class]])
                    {
                        NSMutableArray *messageID = [[NSMutableArray alloc]init];
                        for (int i=0; i<[parseDictionary count]; i++) {
                            [messageID addObject:[[parseDictionary objectAtIndex:i] objectForKey:@"Message"]];
                        }
                        [xmlDoc setObject:messageID forKey:@"Message"];
                    }
                }
            }
            if ([parseDictionaryNo objectForKey:@"EvOrderNo"]) {
                parseDictionaryNo = [parseDictionaryNo objectForKey:@"EvOrderNo"];
                
                [xmlDoc setObject:parseDictionaryNo forKey:@"OBJECTID"];
                
            }
            
            if ([parseDictionaryHeader objectForKey:@"EtOrderHeader"]) {
                parseDictionaryHeader = [parseDictionaryHeader objectForKey:@"EtOrderHeader"];
                if ([parseDictionaryHeader objectForKey:@"item"]) {
                    parseDictionaryHeader = [parseDictionaryHeader objectForKey:@"item"];
                    if ([parseDictionaryHeader isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parseDictionaryHeader] forKey:@"resultHeader"];
                    }
                    else if([parseDictionaryHeader isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parseDictionaryHeader forKey:@"resultHeader"];
                    }
                }
            }
            
            if ([parseDictionaryHeaderPermits objectForKey:@"EtOrderPermits"]) {
                parseDictionaryHeaderPermits = [parseDictionaryHeaderPermits objectForKey:@"EtOrderPermits"];
                if ([parseDictionaryHeaderPermits objectForKey:@"item"]) {
                    parseDictionaryHeaderPermits = [parseDictionaryHeaderPermits objectForKey:@"item"];
                    if ([parseDictionaryHeaderPermits isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parseDictionaryHeaderPermits] forKey:@"resultHeaderPermits"];
                    }
                    else if([parseDictionaryHeaderPermits isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parseDictionaryHeaderPermits forKey:@"resultHeaderPermits"];
                    }
                }
            }
            
            if ([parseDictionaryOperationTransaction objectForKey:@"EtOrderOperations"]) {
                parseDictionaryOperationTransaction = [parseDictionaryOperationTransaction objectForKey:@"EtOrderOperations"];
                if ([parseDictionaryOperationTransaction objectForKey:@"item"]) {
                    parseDictionaryOperationTransaction = [parseDictionaryOperationTransaction objectForKey:@"item"];
                    if ([parseDictionaryOperationTransaction isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parseDictionaryOperationTransaction] forKey:@"resultOperationsTransactions"];
                    }
                    else if([parseDictionaryOperationTransaction isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parseDictionaryOperationTransaction forKey:@"resultOperationsTransactions"];
                    }
                }
            }
            
            if ([parseDictionaryComponentsTransaction objectForKey:@"EtOrderComponents"]) {
                parseDictionaryComponentsTransaction = [parseDictionaryComponentsTransaction objectForKey:@"EtOrderComponents"];
                if ([parseDictionaryComponentsTransaction objectForKey:@"item"]) {
                    parseDictionaryComponentsTransaction = [parseDictionaryComponentsTransaction objectForKey:@"item"];
                    if ([parseDictionaryComponentsTransaction isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parseDictionaryComponentsTransaction] forKey:@"resultComponentsTransactions"];
                    }
                    else if([parseDictionaryComponentsTransaction isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parseDictionaryComponentsTransaction forKey:@"resultComponentsTransactions"];
                    }
                }
            }
            
            if ([parseDictionaryLongText objectForKey:@"EtOrderLongtext"]) {
                parseDictionaryLongText = [parseDictionaryLongText objectForKey:@"EtOrderLongtext"];
                if ([parseDictionaryLongText objectForKey:@"item"]) {
                    parseDictionaryLongText = [parseDictionaryLongText objectForKey:@"item"];
                    if ([parseDictionaryLongText isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parseDictionaryLongText] forKey:@"resultLongText"];
                    }
                    else if([parseDictionaryLongText isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parseDictionaryLongText forKey:@"resultLongText"];
                    }
                }
            }
            
            if ([parseDictionaryDocs objectForKey:@"EtDocs"]) {
                parseDictionaryDocs = [parseDictionaryDocs objectForKey:@"EtDocs"];
                if ([parseDictionaryDocs objectForKey:@"item"]) {
                    parseDictionaryDocs = [parseDictionaryDocs objectForKey:@"item"];
                    if ([parseDictionaryDocs isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parseDictionaryDocs] forKey:@"resultDocs"];
                    }
                    else if([parseDictionaryDocs isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parseDictionaryDocs forKey:@"resultDocs"];
                    }
                }
            }
            
            return xmlDoc;
            
        }
    }
    
    return [NSMutableDictionary dictionary];
}

- (NSMutableDictionary *)parseForListOfPMBOMSItemData:(NSDictionary *)resultDictionary
{
    NSMutableDictionary *xmlDoc = [NSMutableDictionary dictionary];
    NSDictionary *parseDictionary,*parseMatnrDictionary,*parseStockDictionary;
    
    if ([resultDictionary objectForKey:@"env:Body"]) {
        
        parseDictionary = [resultDictionary objectForKey:@"env:Body"];
        if ([parseDictionary objectForKey:[Response actionWithWebServiceResponse:GET_LIST_OF_PM_BOMS]]) {
            parseDictionary = [parseDictionary objectForKey:[Response actionWithWebServiceResponse:GET_LIST_OF_PM_BOMS]];
            
            parseMatnrDictionary=parseDictionary;
            parseStockDictionary=parseDictionary;
            
            if ([parseDictionary objectForKey:@"EtBomItem"]) {
                parseDictionary = [parseDictionary objectForKey:@"EtBomItem"];
                if ([parseDictionary objectForKey:@"item"]) {
                    parseDictionary = [parseDictionary objectForKey:@"item"];
                    if ([parseDictionary isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parseDictionary] forKey:@"resultTransaction"];
                    }
                    else if([parseDictionary isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parseDictionary forKey:@"resultTransaction"];
                    }
                }
            }
            
            
            if ([parseMatnrDictionary objectForKey:@"EtMaterial"]) {
                parseMatnrDictionary = [parseMatnrDictionary objectForKey:@"EtMaterial"];
                if ([parseMatnrDictionary objectForKey:@"item"]) {
                    parseMatnrDictionary = [parseMatnrDictionary objectForKey:@"item"];
                    if ([parseMatnrDictionary isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parseMatnrDictionary] forKey:@"resultMaterial"];
                    }
                    else if([parseMatnrDictionary isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parseMatnrDictionary forKey:@"resultMaterial"];
                    }
                }
            }
            
            
            if ([parseStockDictionary objectForKey:@"EtStock"]) {
                parseStockDictionary = [parseStockDictionary objectForKey:@"EtStock"];
                if ([parseStockDictionary objectForKey:@"item"]) {
                    parseStockDictionary = [parseStockDictionary objectForKey:@"item"];
                    if ([parseStockDictionary isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parseStockDictionary] forKey:@"resultStock"];
                    }
                    else if([parseStockDictionary isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parseStockDictionary forKey:@"resultStock"];
                    }
                }
            }
            
            
            NSMutableDictionary *equipmentBOM = [NSMutableDictionary new];
            
            
            if([xmlDoc objectForKey:@"resultTransaction"]){
                
                [equipmentBOM setObject:[xmlDoc objectForKey:@"resultTransaction"] forKey:@"BOMTransaction"];
                
                [[DataBase sharedInstance] insertEquipmentBOMToCoreDataFromArray:equipmentBOM];
            }
            
            NSMutableDictionary *materialBOM = [NSMutableDictionary new];
            
            
            if([xmlDoc objectForKey:@"resultMaterial"]){
                
                [materialBOM setObject:[xmlDoc objectForKey:@"resultMaterial"] forKey:@"Material"];
                
                [[DataBase sharedInstance] insertMaterialsToCoreDataFromBomItemsArray:materialBOM];
                
                
            }
            
            NSMutableDictionary *stockOverView = [NSMutableDictionary new];
            
            if([xmlDoc objectForKey:@"resultStock"]){
                
                [stockOverView setObject:[xmlDoc objectForKey:@"resultStock"] forKey:@"StocKView"];
                
                [[DataBase sharedInstance] insertStocksToCoreDataFromBomItemsArray:stockOverView];
                
            }
            
        }
    }
    
    return [NSMutableDictionary dictionary];
}

- (NSMutableDictionary *)parseForListOfPMBOMS:(NSDictionary *)resultDictionary
{
    NSMutableDictionary *xmlDoc = [NSMutableDictionary dictionary];
    NSDictionary *parseDictionary,*parseTransactionDictionary,*parseDictionary_Stock;
    
     if ([resultDictionary objectForKey:@"env:Body"]) {
 
        parseDictionary = [resultDictionary objectForKey:@"env:Body"];
        if ([parseDictionary objectForKey:[Response actionWithWebServiceResponse:GET_LIST_OF_PM_BOMS]]) {
            parseDictionary = [parseDictionary objectForKey:[Response actionWithWebServiceResponse:GET_LIST_OF_PM_BOMS]];
            
             parseTransactionDictionary = parseDictionary;
            //parseDictionary_Component = parseDictionary;
            parseDictionary_Stock = parseDictionary;
            
            
            if ([parseDictionary objectForKey:@"EtBomHeader"]) {
                parseDictionary = [parseDictionary objectForKey:@"EtBomHeader"];
                if ([parseDictionary objectForKey:@"item"]) {
                    parseDictionary = [parseDictionary objectForKey:@"item"];
                    if ([parseDictionary isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parseDictionary] forKey:@"resultHeader"];
                    }
                    else if([parseDictionary isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parseDictionary forKey:@"resultHeader"];
                    }
                }
            }
            
            
            NSMutableDictionary *equipmentBOM = [NSMutableDictionary new];
            [equipmentBOM setObject:[xmlDoc objectForKey:@"resultHeader"] forKey:@"BOMHeader"];
 
            [[DataBase sharedInstance] insertEquipmentBOMToCoreDataFromArray:equipmentBOM];
            
            
            if ([parseDictionary_Stock objectForKey:@"EtStock"]) {
                parseDictionary_Stock = [parseDictionary_Stock objectForKey:@"EtStock"];
                if ([parseDictionary_Stock objectForKey:@"item"]) {
                    parseDictionary_Stock = [parseDictionary_Stock objectForKey:@"item"];
                    if ([parseDictionary_Stock isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parseDictionary_Stock] forKey:@"resultStock"];
                    }
                    else if([parseDictionary_Stock isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parseDictionary_Stock forKey:@"resultStock"];
                    }
                }
                
                
                if ([xmlDoc objectForKey:@"resultStock"])
                {
                    if ([[defaults objectForKey:@"ACTIVATELOGS"] isEqualToString:@"X"])
                    {
                        [[DataBase sharedInstance] writToLogFile:[NSString stringWithFormat:@"#INFO#.com.enstrapp.fieldtekpro#Stock Data received"]];
                    }
                    
                    
                    NSMutableArray *stockMasterDataArray = [NSMutableArray new];
                    
                    
                    [stockMasterDataArray addObjectsFromArray:[xmlDoc objectForKey:@"resultStock"]];
                    
                    
                    AppDelegate *tempDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                    
                    
                    [tempDelegate.coreDataControlObject removeContextForStockOverView:@""];
                    
                    
                    [[DataBase sharedInstance] insertStockOverViewToCoreDataFromArray:stockMasterDataArray];
                }
            }
        }
    }
    return [NSMutableDictionary dictionary];
}


- (NSMutableDictionary *)parseForUtilityReserve:(NSMutableDictionary *)resultDictionary
{
    NSMutableDictionary *xmlDoc = [NSMutableDictionary dictionary];
    id parseDictionary,parseDictionary1;
    if ([resultDictionary objectForKey:@"env:Body"]) {
        
        parseDictionary = [resultDictionary objectForKey:@"env:Body"];
        if ([parseDictionary objectForKey:[Response actionWithWebServiceResponse:UTILITY_RESERVE]]) {
            parseDictionary = [parseDictionary objectForKey:[Response actionWithWebServiceResponse:UTILITY_RESERVE]];
            parseDictionary1 = parseDictionary;
            if ([parseDictionary objectForKey:@"EtMessage"]) {
                parseDictionary = [parseDictionary objectForKey:@"EtMessage"];
                if ([parseDictionary objectForKey:@"item"]) {
                    parseDictionary = [parseDictionary objectForKey:@"item"];
                    if ([parseDictionary isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:[[parseDictionary objectForKey:@"Message"] copy]] forKey:@"Message"];
                    }
                    else if([parseDictionary isKindOfClass:[NSArray class]])
                    {
                        NSMutableArray *messageArray = [NSMutableArray new];
                        for (int i=0; i<[parseDictionary count]; i++) {
                            [messageArray addObject:[NSString stringWithString:[[parseDictionary objectAtIndex:i] objectForKey:@"Message"]]];
                        }
                        
                        [xmlDoc setObject:messageArray forKey:@"Message"];
                    }
                }
            }
            if ([parseDictionary1 objectForKey:@"EvResnum"]) {
                parseDictionary1 = [parseDictionary1 objectForKey:@"EvResnum"];
                if (![parseDictionary1 isEqualToString:@"0000000000"]) {
                    parseDictionary1 = [NSString stringWithFormat:@"%lld",[parseDictionary1  longLongValue]];
                    [xmlDoc setObject:[NSMutableArray arrayWithObject:[NSString stringWithFormat:@"%@",parseDictionary1]] forKey:@"RESNUM"];
                }
            }
            
            return xmlDoc;
        }
    }
    
    return [NSMutableDictionary dictionary];
}

- (NSMutableDictionary *)parseForStockOverView:(NSDictionary *)resultDictionary
{
    NSMutableDictionary *xmlDoc = [NSMutableDictionary dictionary];
    NSDictionary *parseDictionary;
    if ([resultDictionary objectForKey:@"env:Body"]) {
        
        parseDictionary = [resultDictionary objectForKey:@"env:Body"];
        if ([parseDictionary objectForKey:[Response actionWithWebServiceResponse:GET_STOCK_DATA]]) {
            parseDictionary = [parseDictionary objectForKey:[Response actionWithWebServiceResponse:GET_STOCK_DATA]];
            
            if ([parseDictionary objectForKey:@"EtStock"]) {
                parseDictionary = [parseDictionary objectForKey:@"EtStock"];
                if ([parseDictionary objectForKey:@"item"]) {
                    parseDictionary = [parseDictionary objectForKey:@"item"];
                    if ([parseDictionary isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parseDictionary] forKey:@"result"];
                    }
                    else if([parseDictionary isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parseDictionary forKey:@"result"];
                    }
                }
                return xmlDoc;
            }
        }
    }
    return [NSMutableDictionary dictionary];
}

- (NSMutableDictionary *)parseForLogData:(NSDictionary *)resultDictionary
{
    NSMutableDictionary *xmlDoc = [NSMutableDictionary dictionary];
    NSDictionary *parseDictionary;
    if ([resultDictionary objectForKey:@"env:Body"]) {
        
        parseDictionary = [resultDictionary objectForKey:@"env:Body"];
        if ([parseDictionary objectForKey:[Response actionWithWebServiceResponse:GET_LOG_DATA]]) {
            parseDictionary = [parseDictionary objectForKey:[Response actionWithWebServiceResponse:GET_LOG_DATA]];
            
            if ([parseDictionary objectForKey:@"EtUserHistory"]) {
                parseDictionary = [parseDictionary objectForKey:@"EtUserHistory"];
                if ([parseDictionary objectForKey:@"item"]) {
                    parseDictionary = [parseDictionary objectForKey:@"item"];
                    if ([parseDictionary isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parseDictionary] forKey:@"result"];
                    }
                    else if([parseDictionary isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parseDictionary forKey:@"result"];
                    }
                }
                return xmlDoc;
            }
        }
    }
    return [NSMutableDictionary dictionary];
}

- (NSMutableDictionary *)parseForMaterialCheckAvailability:(NSDictionary *)resultDictionary
{
    NSMutableDictionary *xmlDoc = [NSMutableDictionary dictionary];
    NSDictionary *parseDictionary;
    if ([resultDictionary objectForKey:@"env:Body"]) {
        
        parseDictionary = [resultDictionary objectForKey:@"env:Body"];
        if ([parseDictionary objectForKey:[Response actionWithWebServiceResponse:GET_MATERIAL_AVAILABILITY_CHECK]]) {
            parseDictionary = [parseDictionary objectForKey:[Response actionWithWebServiceResponse:GET_MATERIAL_AVAILABILITY_CHECK]];
            
            if ([parseDictionary objectForKey:@"EtMessage"]) {
                parseDictionary = [parseDictionary objectForKey:@"EtMessage"];
                if ([parseDictionary objectForKey:@"item"]) {
                    parseDictionary = [parseDictionary objectForKey:@"item"];
                    if ([parseDictionary isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parseDictionary] forKey:@"Message"];
                    }
                    else if([parseDictionary isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parseDictionary forKey:@"Message"];
                    }
                }
            }
            //            if ([parseDictionary objectForKey:@"EvAvailable"]) {
            //                parseDictionary = [parseDictionary objectForKey:@"EvAvailable"];
            //
            //                    if ([parseDictionary isKindOfClass:[NSDictionary class]]) {
            //                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parseDictionary] forKey:@"Message"];
            //                    }
            //                    else if([parseDictionary isKindOfClass:[NSArray class]])
            //                    {
            //                        [xmlDoc setObject:parseDictionary forKey:@"Message"];
            //                    }
            //            }
            else{
                [xmlDoc setObject:parseDictionary forKey:@"Message"];
            }
            return xmlDoc;
            
        }
    }
    return [NSMutableDictionary dictionary];
}

-(NSMutableDictionary *)parseForCustomFields:(NSDictionary *)resultDictionary{
    
    NSMutableDictionary *xmlDoc = [NSMutableDictionary dictionary];
    NSDictionary *parseDictionary;
    
    if ([resultDictionary objectForKey:@"env:Body"]) {
        
        parseDictionary = [resultDictionary objectForKey:@"env:Body"];
        if ([parseDictionary objectForKey:[Response actionWithWebServiceResponse:GET_VALUE_HELPS]]) {
            parseDictionary = [parseDictionary objectForKey:[Response actionWithWebServiceResponse:GET_VALUE_HELPS]];
            
            if ([parseDictionary objectForKey:@"EtFields"]) {
                parseDictionary = [parseDictionary objectForKey:@"EtFields"];
                if ([parseDictionary objectForKey:@"item"]) {
                    parseDictionary = [parseDictionary objectForKey:@"item"];
                    if ([parseDictionary isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parseDictionary] forKey:@"Message"];
                    }
                    else if([parseDictionary isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parseDictionary forKey:@"Message"];
                    }
                }
            }
            else{
                [xmlDoc setObject:parseDictionary forKey:@"Message"];
            }
            return xmlDoc;
            
        }
    }
    
    return [NSMutableDictionary dictionary];
}

-(NSMutableDictionary *)parseForGetDocuments:(NSDictionary *)resultDictionary{
    
    NSMutableDictionary *xmlDoc = [NSMutableDictionary dictionary];
    NSDictionary *parseDictionary;
    if ([resultDictionary objectForKey:@"env:Body"]) {
        
        parseDictionary = [resultDictionary objectForKey:@"env:Body"];
        if ([parseDictionary objectForKey:[Response actionWithWebServiceResponse:GET_DOCUMENTS]]) {
            parseDictionary = [parseDictionary objectForKey:[Response actionWithWebServiceResponse:GET_DOCUMENTS]];
            
            if ([parseDictionary objectForKey:@"EsUri"])
            {
                parseDictionary = [parseDictionary objectForKey:@"EsUri"];
                
                [xmlDoc setObject:parseDictionary forKey:@"URL"];
            }
            
            return xmlDoc;
            
        }
    }
    
    return [NSMutableDictionary dictionary];
}

-(NSMutableDictionary *)parseForAuthData:(NSDictionary *)resultDictionary{
    
    NSMutableDictionary *xmlDoc = [NSMutableDictionary dictionary];
    NSDictionary *parseDictionary;
    if ([resultDictionary objectForKey:@"env:Body"]) {
        
        parseDictionary = [resultDictionary objectForKey:@"env:Body"];
        if ([parseDictionary objectForKey:[Response actionWithWebServiceResponse:GET_AUTH_DATA]]) {
            parseDictionary = [parseDictionary objectForKey:[Response actionWithWebServiceResponse:GET_AUTH_DATA]];
            
            if ([parseDictionary objectForKey:@"EsUser"]) {
                if ([[parseDictionary objectForKey:@"EsUser"] isKindOfClass:[NSDictionary class]]) {
                    [xmlDoc setObject:[NSMutableArray arrayWithObject:[parseDictionary objectForKey:@"EsUser"]] forKey:@"resultUser"];
                }
                else if([[parseDictionary objectForKey:@"EsUser"] isKindOfClass:[NSArray class]])
                {
                    [xmlDoc setObject:[parseDictionary objectForKey:@"EsUser"] forKey:@"resultUser"];
                }
            }
            
            if ([parseDictionary objectForKey:@"EtBusf"]) {
                if ([[parseDictionary objectForKey:@"EtBusf"] isKindOfClass:[NSDictionary class]]) {
                    [xmlDoc setObject:[NSMutableArray arrayWithObject:[parseDictionary objectForKey:@"EtBusf"]] forKey:@"Busfresult"];
                }
                else if([[parseDictionary objectForKey:@"EtBusf"] isKindOfClass:[NSArray class]])
                {
                    [xmlDoc setObject:[parseDictionary objectForKey:@"EtBusf"] forKey:@"Busfresult"];
                }
            }
            
            if ([parseDictionary objectForKey:@"EtMusrf"]) {
                if ([[parseDictionary objectForKey:@"EtMusrf"] isKindOfClass:[NSDictionary class]]) {
                    [xmlDoc setObject:[NSMutableArray arrayWithObject:[parseDictionary objectForKey:@"EtMusrf"]] forKey:@"MUserresult"];
                }
                else if([[parseDictionary objectForKey:@"EtMusrf"] isKindOfClass:[NSArray class]])
                {
                    [xmlDoc setObject:[parseDictionary objectForKey:@"EtMusrf"] forKey:@"MUserresult"];
                }
            }
            
            if ([parseDictionary objectForKey:@"EtScrf"]) {
                if ([[parseDictionary objectForKey:@"EtScrf"] isKindOfClass:[NSDictionary class]]) {
                    [xmlDoc setObject:[NSMutableArray arrayWithObject:[parseDictionary objectForKey:@"EtScrf"]] forKey:@"Scrfresult"];
                }
                else if([[parseDictionary objectForKey:@"EtScrf"] isKindOfClass:[NSArray class]])
                {
                    [xmlDoc setObject:[parseDictionary objectForKey:@"EtScrf"] forKey:@"Scrfresult"];
                }
            }
            
            if ([parseDictionary objectForKey:@"EtUsrf"]) {
                
                if ([[parseDictionary objectForKey:@"EtUsrf"] isKindOfClass:[NSDictionary class]]) {
                    [xmlDoc setObject:[NSMutableArray arrayWithObject:[parseDictionary objectForKey:@"EtUsrf"]] forKey:@"Usrfresult"];
                }
                else if([[parseDictionary objectForKey:@"EtUsrf"] isKindOfClass:[NSArray class]])
                {
                    [xmlDoc setObject:[parseDictionary objectForKey:@"EtUsrf"] forKey:@"Usrfresult"];
                }
            }
            
            return xmlDoc;
            
        }
    }
    
    return [NSMutableDictionary dictionary];
}

-(NSMutableDictionary *)parseForSettingsData:(NSDictionary *)resultDictionary{
    
    NSMutableDictionary *xmlDoc = [NSMutableDictionary dictionary];
    NSDictionary *parseDictionary;
    if ([resultDictionary objectForKey:@"env:Body"]) {
        
        parseDictionary = [resultDictionary objectForKey:@"env:Body"];
        if ([parseDictionary objectForKey:[Response actionWithWebServiceResponse:GET_SETTINGS_DATA]]) {
            parseDictionary = [parseDictionary objectForKey:[Response actionWithWebServiceResponse:GET_SETTINGS_DATA]];
            
            if ([parseDictionary objectForKey:@"EsAppData"]) {
                if ([[parseDictionary objectForKey:@"EsAppData"] isKindOfClass:[NSDictionary class]]) {
                    [xmlDoc setObject:[NSMutableArray arrayWithObject:[parseDictionary objectForKey:@"EsAppData"]] forKey:@"resultAppData"];
                }
                else if([[parseDictionary objectForKey:@"EsAppData"] isKindOfClass:[NSArray class]])
                {
                    [xmlDoc setObject:[parseDictionary objectForKey:@"EsAppData"] forKey:@"resultAppData"];
                }
            }
            
            if ([parseDictionary objectForKey:@"EsAsmntNotif"]) {
                if ([[parseDictionary objectForKey:@"EsAsmntNotif"] isKindOfClass:[NSDictionary class]]) {
                    [xmlDoc setObject:[NSMutableArray arrayWithObject:[parseDictionary objectForKey:@"EsAsmntNotif"]] forKey:@"resultAsmntNotif"];
                }
                else if([[parseDictionary objectForKey:@"EsAsmntNotif"] isKindOfClass:[NSArray class]])
                {
                    [xmlDoc setObject:[parseDictionary objectForKey:@"EsAsmntNotif"] forKey:@"resultAsmntNotif"];
                }
            }
            
            if ([parseDictionary objectForKey:@"EsAsmntOrder"]) {
                if ([[parseDictionary objectForKey:@"EsAsmntOrder"] isKindOfClass:[NSDictionary class]]) {
                    [xmlDoc setObject:[NSMutableArray arrayWithObject:[parseDictionary objectForKey:@"EsAsmntOrder"]] forKey:@"resultAsmntOrder"];
                }
                else if([[parseDictionary objectForKey:@"EsAsmntOrder"] isKindOfClass:[NSArray class]])
                {
                    [xmlDoc setObject:[parseDictionary objectForKey:@"EsAsmntOrder"] forKey:@"resultAsmntOrder"];
                }
            }
            
            if ([parseDictionary objectForKey:@"EsNotif"]) {
                if ([[parseDictionary objectForKey:@"EsNotif"] isKindOfClass:[NSDictionary class]]) {
                    [xmlDoc setObject:[NSMutableArray arrayWithObject:[parseDictionary objectForKey:@"EsNotif"]] forKey:@"resultNotifSettings"];
                }
                else if([[parseDictionary objectForKey:@"EsNotif"] isKindOfClass:[NSArray class]])
                {
                    [xmlDoc setObject:[parseDictionary objectForKey:@"EsNotif"] forKey:@"resultNotifSettings"];
                }
            }
            
            return xmlDoc;
        }
    }
    
    return [NSMutableDictionary dictionary];
}


-(NSMutableDictionary *)parseForMsonData:(NSDictionary *)resultDictionary{
    
    NSMutableDictionary *xmlDoc = [NSMutableDictionary dictionary];
    NSDictionary *parseDictionary;
    if ([resultDictionary objectForKey:@"env:Body"]) {
        
        parseDictionary = [resultDictionary objectForKey:@"env:Body"];
        if ([parseDictionary objectForKey:[Response actionWithWebServiceResponse:SEARCH_PLANTMAINT]]) {
            parseDictionary = [parseDictionary objectForKey:[Response actionWithWebServiceResponse:SEARCH_PLANTMAINT]];
            
            if ([parseDictionary objectForKey:@"EtMsoh"]) {
                parseDictionary = [parseDictionary objectForKey:@"EtMsoh"];
                if ([parseDictionary objectForKey:@"item"]) {
                    parseDictionary = [parseDictionary objectForKey:@"item"];
                    if ([parseDictionary isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parseDictionary] forKey:@"result"];
                    }
                    else if([parseDictionary isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parseDictionary forKey:@"result"];
                    }
                    
                    return xmlDoc;
                }
            }
            
            
            
        }
    }
    return [NSMutableDictionary dictionary];
    
}

-(NSMutableDictionary *)parseForInspectionMsonData:(NSDictionary *)resultDictionary;
{
    
    NSMutableDictionary *xmlDoc = [NSMutableDictionary dictionary];
    NSDictionary *parseDictionary;
    if ([resultDictionary objectForKey:@"env:Body"]) {
        
        parseDictionary = [resultDictionary objectForKey:@"env:Body"];
        if ([parseDictionary objectForKey:[Response actionWithWebServiceResponse:INSPECTION_MPLAN]]) {
            parseDictionary = [parseDictionary objectForKey:[Response actionWithWebServiceResponse:INSPECTION_MPLAN]];
            
            if ([parseDictionary objectForKey:@"EtMsoh"]) {
                parseDictionary = [parseDictionary objectForKey:@"EtMsoh"];
                if ([parseDictionary objectForKey:@"item"]) {
                    parseDictionary = [parseDictionary objectForKey:@"item"];
                    if ([parseDictionary isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parseDictionary] forKey:@"result"];
                    }
                    else if([parseDictionary isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parseDictionary forKey:@"result"];
                    }
                    
                    return xmlDoc;
                }
            }
            
        }
    }
    return [NSMutableDictionary dictionary];
    
}


- (NSMutableDictionary *)parseForWSMMasterData:(NSDictionary *)resultDictionary
{
    NSMutableDictionary *xmlDoc = [NSMutableDictionary dictionary];
    NSDictionary *parseDictionary;
    if ([resultDictionary objectForKey:@"env:Body"]) {
        
        parseDictionary = [resultDictionary objectForKey:@"env:Body"];
        if ([parseDictionary objectForKey:[Response actionWithWebServiceResponse:GET_WSM_MASTERDATA]]) {
            parseDictionary = [parseDictionary objectForKey:[Response actionWithWebServiceResponse:GET_WSM_MASTERDATA]];
            
            if ([parseDictionary objectForKey:@"EsWsmObjAvail"]) {
                if ([[parseDictionary objectForKey:@"EsWsmObjAvail"] isKindOfClass:[NSDictionary class]]) {
                    [xmlDoc setObject:[NSMutableArray arrayWithObject:[parseDictionary objectForKey:@"EsWsmObjAvail"]] forKey:@"resultWSMObjAvail"];
                }
                else if ([[parseDictionary objectForKey:@"EsWsmObjAvail"] isKindOfClass:[NSArray class]]){
                    
                    [xmlDoc setObject:[parseDictionary objectForKey:@"EsWsmObjAvail"] forKey:@"resultWSMObjAvail"];
                }
            }
            
            
            if ([parseDictionary objectForKey:@"EtWsmDocument"]) {
                if ([[parseDictionary objectForKey:@"EtWsmDocument"] isKindOfClass:[NSDictionary class]]) {
                    [xmlDoc setObject:[NSMutableArray arrayWithObject:[parseDictionary objectForKey:@"EtWsmDocument"]] forKey:@"resultWSMDocument"];
                }
                else if ([[parseDictionary objectForKey:@"EtWsmDocument"] isKindOfClass:[NSArray class]]){
                    
                    [xmlDoc setObject:[parseDictionary objectForKey:@"EtWsmDocument"] forKey:@"resultWSMDocument"];
                }
            }
            
            
            if ([parseDictionary objectForKey:@"EtWsmEqui"]) {
                if ([[parseDictionary objectForKey:@"EtWsmEqui"] isKindOfClass:[NSDictionary class]]) {
                    [xmlDoc setObject:[NSMutableArray arrayWithObject:[parseDictionary objectForKey:@"EtWsmEqui"]] forKey:@"resultWSMEqui"];
                }
                else if ([[parseDictionary objectForKey:@"EtWsmEqui"] isKindOfClass:[NSArray class]]){
                    
                    [xmlDoc setObject:[parseDictionary objectForKey:@"EtWsmEqui"] forKey:@"resultWSMEqui"];
                }
            }
            
            
            if ([parseDictionary objectForKey:@"EtWsmMaterial"]) {
                if ([[parseDictionary objectForKey:@"EtWsmMaterial"] isKindOfClass:[NSDictionary class]]) {
                    [xmlDoc setObject:[NSMutableArray arrayWithObject:[parseDictionary objectForKey:@"EtWsmMaterial"]] forKey:@"resultWSMMaterial"];
                }
                else if ([[parseDictionary objectForKey:@"EtWsmMaterial"] isKindOfClass:[NSArray class]]){
                    
                    [xmlDoc setObject:[parseDictionary objectForKey:@"EtWsmMaterial"] forKey:@"resultWSMMaterial"];
                }
            }
            
            
            
            if ([parseDictionary objectForKey:@"EtWsmPermit"]) {
                if ([[parseDictionary objectForKey:@"EtWsmPermit"] isKindOfClass:[NSDictionary class]]) {
                    [xmlDoc setObject:[NSMutableArray arrayWithObject:[parseDictionary objectForKey:@"EtWsmPermit"]] forKey:@"resultWSMPermit"];
                }
                else if ([[parseDictionary objectForKey:@"EtWsmPermit"] isKindOfClass:[NSArray class]]){
                    
                    [xmlDoc setObject:[parseDictionary objectForKey:@"EtWsmPermit"] forKey:@"resultWSMPermit"];
                }
            }
            
            
            if ([parseDictionary objectForKey:@"EtWsmPlants"]) {
                if ([[parseDictionary objectForKey:@"EtWsmPlants"] isKindOfClass:[NSDictionary class]]) {
                    [xmlDoc setObject:[NSMutableArray arrayWithObject:[parseDictionary objectForKey:@"EtWsmPlants"]] forKey:@"resultWSMPlants"];
                }
                else if ([[parseDictionary objectForKey:@"EtWsmPlants"] isKindOfClass:[NSArray class]]){
                    
                    [xmlDoc setObject:[parseDictionary objectForKey:@"EtWsmPlants"] forKey:@"resultWSMPlants"];
                }
            }
            
            
            if ([parseDictionary objectForKey:@"EtWsmResponses"]) {
                if ([[parseDictionary objectForKey:@"EtWsmResponses"] isKindOfClass:[NSDictionary class]]) {
                    [xmlDoc setObject:[NSMutableArray arrayWithObject:[parseDictionary objectForKey:@"EtWsmResponses"]] forKey:@"resultWSMResponses"];
                }
                else if ([[parseDictionary objectForKey:@"EtWsmResponses"] isKindOfClass:[NSArray class]]){
                    
                    [xmlDoc setObject:[parseDictionary objectForKey:@"EtWsmResponses"] forKey:@"resultWSMResponses"];
                }
            }
            
            
            if ([parseDictionary objectForKey:@"EtWsmRisks"]) {
                if ([[parseDictionary objectForKey:@"EtWsmRisks"] isKindOfClass:[NSDictionary class]]) {
                    [xmlDoc setObject:[NSMutableArray arrayWithObject:[parseDictionary objectForKey:@"EtWsmRisks"]] forKey:@"resultWSMRisks"];
                }
                else if ([[parseDictionary objectForKey:@"EtWsmRisks"] isKindOfClass:[NSArray class]]){
                    
                    [xmlDoc setObject:[parseDictionary objectForKey:@"EtWsmRisks"] forKey:@"resultWSMRisks"];
                }
            }
            
            if ([parseDictionary objectForKey:@"EtWsmSafetymeas"]) {
                if ([[parseDictionary objectForKey:@"EtWsmSafetymeas"] isKindOfClass:[NSDictionary class]]) {
                    [xmlDoc setObject:[NSMutableArray arrayWithObject:[parseDictionary objectForKey:@"EtWsmSafetymeas"]] forKey:@"resultWSMSafetymeas"];
                }
                else if ([[parseDictionary objectForKey:@"EtWsmRisks"] isKindOfClass:[NSArray class]]){
                    
                    [xmlDoc setObject:[parseDictionary objectForKey:@"EtWsmSafetymeas"] forKey:@"resultWSMSafetymeas"];
                }
            }
            
            if ([parseDictionary objectForKey:@"EtWsmWcmr"]) {
                if ([[parseDictionary objectForKey:@"EtWsmWcmr"] isKindOfClass:[NSDictionary class]]) {
                    [xmlDoc setObject:[NSMutableArray arrayWithObject:[parseDictionary objectForKey:@"EtWsmWcmr"]] forKey:@"resultWSMWcmr"];
                }
                else if ([[parseDictionary objectForKey:@"EtWsmWcmr"] isKindOfClass:[NSArray class]]){
                    
                    [xmlDoc setObject:[parseDictionary objectForKey:@"EtWsmWcmr"] forKey:@"resultWSMWcmr"];
                }
            }
            
            
            return xmlDoc;
        }
    }
    
    return [NSMutableDictionary dictionary];
}


- (NSMutableDictionary *)parseForBreakDownData:(NSDictionary *)resultDictionary
{
    NSMutableDictionary *xmlDoc = [NSMutableDictionary dictionary];
    NSDictionary *parseDictionary,*parseDetailDictionary,*parseBreakDownPlantsDictionary,*parseBreakDownGraphMonthDictionary;
    if ([resultDictionary objectForKey:@"env:Body"]) {
        parseDictionary = [resultDictionary objectForKey:@"env:Body"];
        if ([parseDictionary objectForKey:@"n0:ZemtPmappBiBkdnStatResponse"])
        {
            parseDictionary = [parseDictionary objectForKey:@"n0:ZemtPmappBiBkdnStatResponse"];
            parseDetailDictionary = parseDictionary;
            parseBreakDownPlantsDictionary = parseDetailDictionary;
            parseBreakDownGraphMonthDictionary = parseBreakDownPlantsDictionary;
            if ([parseDictionary objectForKey:@"EsBkdnTotal"]) {
                parseDictionary = [parseDictionary objectForKey:@"EsBkdnTotal"];
                
                if ([parseDictionary isKindOfClass:[NSDictionary class]]) {
                    [xmlDoc setObject:[NSMutableArray arrayWithObject:parseDictionary] forKey:@"result"];
                }
                else if([parseDictionary isKindOfClass:[NSArray class]])
                {
                    id result = parseDictionary;
                    
                    [xmlDoc setObject:[NSMutableArray arrayWithObject:result] forKey:@"result"];
                    
                }
                
            }
            
            if ([parseDetailDictionary objectForKey:@"EtBkdnMonthTotal"])
            {
                parseDetailDictionary = [parseDetailDictionary objectForKey:@"EtBkdnMonthTotal"];
                
                if ([parseDetailDictionary objectForKey:@"item"]) {
                    
                    parseDetailDictionary = [parseDetailDictionary objectForKey:@"item"];
                    if ([parseDetailDictionary isKindOfClass:[NSDictionary class]])
                    {
                        
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parseDetailDictionary] forKey:@"CurrentMonth"];
                    }
                    else if ([parseDetailDictionary isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parseDetailDictionary forKey:@"CurrentMonth"];
                        
                    }
                }
            }
            
            if ([parseBreakDownPlantsDictionary objectForKey:@"EtBkdnPlantTotal"])
            {
                parseBreakDownPlantsDictionary = [parseBreakDownPlantsDictionary objectForKey:@"EtBkdnPlantTotal"];
                
                if ([parseBreakDownPlantsDictionary objectForKey:@"item"]) {
                    
                    parseBreakDownPlantsDictionary = [parseBreakDownPlantsDictionary objectForKey:@"item"];
                    if ([parseBreakDownPlantsDictionary isKindOfClass:[NSDictionary class]])
                    {
                        
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parseBreakDownPlantsDictionary] forKey:@"BreakDownPlants"];
                    }
                    else if ([parseBreakDownPlantsDictionary isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parseBreakDownPlantsDictionary forKey:@"BreakDownPlants"];
                        
                    }
                }
            }
            
            if ([parseBreakDownGraphMonthDictionary objectForKey:@"EtBkdnPmonthTotal"])
            {
                parseBreakDownGraphMonthDictionary = [parseBreakDownGraphMonthDictionary objectForKey:@"EtBkdnPmonthTotal"];
                
                if ([parseBreakDownGraphMonthDictionary objectForKey:@"item"]) {
                    
                    parseBreakDownGraphMonthDictionary = [parseBreakDownGraphMonthDictionary objectForKey:@"item"];
                    if ([parseBreakDownGraphMonthDictionary isKindOfClass:[NSDictionary class]])
                    {
                        
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parseBreakDownGraphMonthDictionary] forKey:@"BreakDownBarGraphMonthTotal"];
                    }
                    else if ([parseBreakDownGraphMonthDictionary isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parseBreakDownGraphMonthDictionary forKey:@"BreakDownBarGraphMonthTotal"];
                        
                    }
                }
            }
        }
        
        return xmlDoc;
    }
    
    return [NSMutableDictionary dictionary];
}

- (NSMutableDictionary *)parseForNotificationData:(NSDictionary *)resultDictionary
{
    NSMutableDictionary *xmlDoc = [NSMutableDictionary dictionary];
    NSDictionary *parseDictionary,*parseDetailDictionary,*parseDescriptionDictionary,*parsePlantDescDictionary,*parseNotifWorkCenterDictionary;
    if ([resultDictionary objectForKey:@"env:Body"]) {
        parseDictionary = [resultDictionary objectForKey:@"env:Body"];
        if ([parseDictionary objectForKey:@"n0:ZemtPmappBiNotifRepResponse"])
        {
            parseDictionary = [parseDictionary objectForKey:@"n0:ZemtPmappBiNotifRepResponse"];
            parseDetailDictionary = parseDictionary;
            parseDescriptionDictionary = parseDetailDictionary;
            parsePlantDescDictionary = parseDescriptionDictionary;
            parseNotifWorkCenterDictionary = parsePlantDescDictionary;
            if ([parseDictionary objectForKey:@"EsNotifTotal"]) {
                parseDictionary = [parseDictionary objectForKey:@"EsNotifTotal"];
                
                if ([parseDictionary isKindOfClass:[NSDictionary class]]) {
                    [xmlDoc setObject:[NSMutableArray arrayWithObject:parseDictionary] forKey:@"result"];
                }
                else if([parseDictionary isKindOfClass:[NSArray class]])
                {
                    id result = parseDictionary;
                    
                    [xmlDoc setObject:[NSMutableArray arrayWithObject:result] forKey:@"result"];
                }
            }
            
            if ([parseDescriptionDictionary objectForKey:@"EtNotifRep"])
            {
                parseDescriptionDictionary = [parseDescriptionDictionary objectForKey:@"EtNotifRep"];
                
                if ([parseDescriptionDictionary objectForKey:@"item"]) {
                    
                    parseDescriptionDictionary = [parseDescriptionDictionary objectForKey:@"item"];
                    
                    if ([parseDescriptionDictionary isKindOfClass:[NSDictionary class]])
                    {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parseDescriptionDictionary] forKey:@"Description"];
                    }
                    else if ([parseDescriptionDictionary isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parseDescriptionDictionary forKey:@"Description"];
                        
                    }
                }
            }
            
            if ([parseDetailDictionary objectForKey:@"EtNotifTypeTotal"])
            {
                parseDetailDictionary = [parseDetailDictionary objectForKey:@"EtNotifTypeTotal"];
                
                if ([parseDetailDictionary objectForKey:@"item"]) {
                    
                    parseDetailDictionary = [parseDetailDictionary objectForKey:@"item"];
                    
                    if ([parseDetailDictionary isKindOfClass:[NSDictionary class]])
                    {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parseDetailDictionary] forKey:@"Details"];
                    }
                    else if ([parseDetailDictionary isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parseDetailDictionary forKey:@"Details"];
                        
                    }
                }
            }
            
            if ([parsePlantDescDictionary objectForKey:@"EtNotifPlantTotal"])
            {
                parsePlantDescDictionary = [parsePlantDescDictionary objectForKey:@"EtNotifPlantTotal"];
                
                if ([parsePlantDescDictionary objectForKey:@"item"]) {
                    
                    parsePlantDescDictionary = [parsePlantDescDictionary objectForKey:@"item"];
                    
                    if ([parsePlantDescDictionary isKindOfClass:[NSDictionary class]])
                    {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parsePlantDescDictionary] forKey:@"NotifPlants"];
                    }
                    else if ([parsePlantDescDictionary isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parsePlantDescDictionary forKey:@"NotifPlants"];
                        
                    }
                }
            }
            if ([parseNotifWorkCenterDictionary objectForKey:@"EtNotifArbplTotal"])
            {
                parseNotifWorkCenterDictionary = [parseNotifWorkCenterDictionary objectForKey:@"EtNotifArbplTotal"];
                
                if ([parseNotifWorkCenterDictionary objectForKey:@"item"]) {
                    
                    parseNotifWorkCenterDictionary = [parseNotifWorkCenterDictionary objectForKey:@"item"];
                    
                    if ([parseNotifWorkCenterDictionary isKindOfClass:[NSDictionary class]])
                    {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parseNotifWorkCenterDictionary] forKey:@"NotifWorkCenter"];
                    }
                    else if ([parseNotifWorkCenterDictionary isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parseNotifWorkCenterDictionary forKey:@"NotifWorkCenter"];
                        
                    }
                }
            }
            
            
        }
        
        return xmlDoc;
        
    }
    
    return [NSMutableDictionary dictionary];
}

- (NSMutableDictionary *)parseForOrderData:(NSDictionary *)resultDictionary
{
    NSMutableDictionary *xmlDoc = [NSMutableDictionary dictionary];
    NSDictionary *parseDictionary,*parseDetailDictionary,*parseDescriptionDictionary,*parsePlantDescDictionary,*parseNotifWorkCenterDictionary;
    if ([resultDictionary objectForKey:@"env:Body"]) {
        parseDictionary = [resultDictionary objectForKey:@"env:Body"];
        if ([parseDictionary objectForKey:@"n0:ZemtPmappBiOrdRepResponse"])
        {
            parseDictionary = [parseDictionary objectForKey:@"n0:ZemtPmappBiOrdRepResponse"];
            parseDetailDictionary = parseDictionary;
            parseDescriptionDictionary = parseDetailDictionary;
            parsePlantDescDictionary = parseDescriptionDictionary;
            parseNotifWorkCenterDictionary = parsePlantDescDictionary;
            if ([parseDictionary objectForKey:@"EsOrdTotal"]) {
                parseDictionary = [parseDictionary objectForKey:@"EsOrdTotal"];
                
                if ([parseDictionary isKindOfClass:[NSDictionary class]]) {
                    [xmlDoc setObject:[NSMutableArray arrayWithObject:parseDictionary] forKey:@"result"];
                }
                else if([parseDictionary isKindOfClass:[NSArray class]])
                {
                    id result = parseDictionary;
                    
                    [xmlDoc setObject:[NSMutableArray arrayWithObject:result] forKey:@"result"];
                }
            }
            
            if ([parseDescriptionDictionary objectForKey:@"EtOrdRep"])
            {
                parseDescriptionDictionary = [parseDescriptionDictionary objectForKey:@"EtOrdRep"];
                
                if ([parseDescriptionDictionary objectForKey:@"item"]) {
                    
                    parseDescriptionDictionary = [parseDescriptionDictionary objectForKey:@"item"];
                    
                    if ([parseDescriptionDictionary isKindOfClass:[NSDictionary class]])
                    {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parseDescriptionDictionary] forKey:@"Description"];
                    }
                    else if ([parseDescriptionDictionary isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parseDescriptionDictionary forKey:@"Description"];
                        
                    }
                }
            }
            
            if ([parseDetailDictionary objectForKey:@"EtOrdTypeTotal"])
            {
                parseDetailDictionary = [parseDetailDictionary objectForKey:@"EtOrdTypeTotal"];
                
                if ([parseDetailDictionary objectForKey:@"item"]) {
                    
                    parseDetailDictionary = [parseDetailDictionary objectForKey:@"item"];
                    
                    if ([parseDetailDictionary isKindOfClass:[NSDictionary class]])
                    {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parseDetailDictionary] forKey:@"Details"];
                    }
                    else if ([parseDetailDictionary isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parseDetailDictionary forKey:@"Details"];
                        
                    }
                }
            }
            
            if ([parsePlantDescDictionary objectForKey:@"EtOrdPlantTotal"])
            {
                parsePlantDescDictionary = [parsePlantDescDictionary objectForKey:@"EtOrdPlantTotal"];
                
                if ([parsePlantDescDictionary objectForKey:@"item"]) {
                    
                    parsePlantDescDictionary = [parsePlantDescDictionary objectForKey:@"item"];
                    
                    if ([parsePlantDescDictionary isKindOfClass:[NSDictionary class]])
                    {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parsePlantDescDictionary] forKey:@"OrderPlants"];
                    }
                    else if ([parsePlantDescDictionary isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parsePlantDescDictionary forKey:@"OrderPlants"];
                        
                    }
                }
            }
            if ([parseNotifWorkCenterDictionary objectForKey:@"EtOrdArbplTotal"])
            {
                parseNotifWorkCenterDictionary = [parseNotifWorkCenterDictionary objectForKey:@"EtOrdArbplTotal"];
                
                if ([parseNotifWorkCenterDictionary objectForKey:@"item"]) {
                    
                    parseNotifWorkCenterDictionary = [parseNotifWorkCenterDictionary objectForKey:@"item"];
                    
                    if ([parseNotifWorkCenterDictionary isKindOfClass:[NSDictionary class]])
                    {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parseNotifWorkCenterDictionary] forKey:@"OrderWorkCenter"];
                    }
                    else if ([parseNotifWorkCenterDictionary isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parseNotifWorkCenterDictionary forKey:@"OrderWorkCenter"];
                        
                    }
                }
            }
            
            
        }
        
        return xmlDoc;
        
    }
    
    return [NSMutableDictionary dictionary];
}

-(NSMutableDictionary *)parseForGetMchklist:(NSDictionary *)resultDictionary{
    
    NSMutableDictionary *xmlDoc = [NSMutableDictionary dictionary];
    NSDictionary *parseDictionary;
    
    NSDictionary *parseMSCklDictionary;
    
    
    if ([resultDictionary objectForKey:@"env:Body"]) {
        
        parseDictionary = [resultDictionary objectForKey:@"env:Body"];
        if ([parseDictionary objectForKey:[Response actionWithWebServiceResponse:MAINTAINANCE_GET_CHECK_LIST]]) {
            parseDictionary = [parseDictionary objectForKey:[Response actionWithWebServiceResponse:MAINTAINANCE_GET_CHECK_LIST]];
            parseMSCklDictionary=parseDictionary;
            
            if ([parseDictionary objectForKey:@"EtMchkl"]) {
                parseDictionary = [parseDictionary objectForKey:@"EtMchkl"];
                if ([parseDictionary objectForKey:@"item"]) {
                    parseDictionary = [parseDictionary objectForKey:@"item"];
                    if ([parseDictionary isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parseDictionary] forKey:@"result"];
                    }
                    else if([parseDictionary isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parseDictionary forKey:@"result"];
                    }
                    
                }
            }
            
            if ([parseMSCklDictionary objectForKey:@"EsMchklHdr"]) {
                parseMSCklDictionary = [parseMSCklDictionary objectForKey:@"EsMchklHdr"];
                if ([parseMSCklDictionary isKindOfClass:[NSDictionary class]]) {
                    [xmlDoc setObject:[NSMutableArray arrayWithObject:parseMSCklDictionary] forKey:@"resultEsMchklHdr"];
                }
                else if([parseMSCklDictionary isKindOfClass:[NSArray class]])
                {
                    [xmlDoc setObject:parseMSCklDictionary forKey:@"resultEsMchklHdr"];
                }
                
                return xmlDoc;
            }
            
            
        }
    }
    
    return [NSMutableDictionary dictionary];
}

-(NSMutableDictionary *)parseForSetMchklist:(NSDictionary *)resultDictionary{
    
    NSMutableDictionary *xmlDoc = [NSMutableDictionary dictionary];
    NSDictionary *parseDictionary;
    if ([resultDictionary objectForKey:@"env:Body"]) {
        
        parseDictionary = [resultDictionary objectForKey:@"env:Body"];
        if ([parseDictionary objectForKey:[Response actionWithWebServiceResponse:MAINTAINANCE_SET_CHECK_LIST]]) {
            parseDictionary = [parseDictionary objectForKey:[Response actionWithWebServiceResponse:MAINTAINANCE_SET_CHECK_LIST]];
            
            if ([parseDictionary objectForKey:@"EsMchklHdr"]) {
                parseDictionary = [parseDictionary objectForKey:@"EsMchklHdr"];
                if ([parseDictionary isKindOfClass:[NSDictionary class]]) {
                    [xmlDoc setObject:[NSMutableArray arrayWithObject:parseDictionary] forKey:@"resultEsMchklHdr"];
                }
                else if([parseDictionary isKindOfClass:[NSArray class]])
                {
                    [xmlDoc setObject:parseDictionary forKey:@"resultEsMchklHdr"];
                }
                
            }
            
            
            if ([parseDictionary objectForKey:@"EtMchkl"]) {
                parseDictionary = [parseDictionary objectForKey:@"EtMchkl"];
                if ([parseDictionary objectForKey:@"item"]) {
                    parseDictionary = [parseDictionary objectForKey:@"item"];
                    if ([parseDictionary isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parseDictionary] forKey:@"result"];
                    }
                    else if([parseDictionary isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parseDictionary forKey:@"result"];
                    }
                    
                }
            }
            
            
            return xmlDoc;
            
            
        }
    }
    
    return [NSMutableDictionary dictionary];
    
}

- (NSMutableDictionary *)parseForPermitData:(NSDictionary *)resultDictionary
{
    NSMutableDictionary *xmlDoc = [NSMutableDictionary dictionary];
    NSDictionary *parseDictionary,*parseDescriptionDictionary,*workApprovalPlantDictionary,*permitPlantDictionary,*parsePermitDescDictionary,*parsePermitDetailDictionary,*parseWorkCenterDictionary,*parseTotalWorkCenterDictionary,*permitDetailDescpnDictionary;
    if ([resultDictionary objectForKey:@"env:Body"]) {
        parseDictionary = [resultDictionary objectForKey:@"env:Body"];
        if ([parseDictionary objectForKey:@"n0:ZemtPmappBiPermitRepResponse"])
        {
            parseDictionary = [parseDictionary objectForKey:@"n0:ZemtPmappBiPermitRepResponse"];
            parseDescriptionDictionary = parseDictionary;
            workApprovalPlantDictionary = parseDescriptionDictionary;
            permitPlantDictionary = workApprovalPlantDictionary;
            parsePermitDescDictionary = permitPlantDictionary;
            parsePermitDetailDictionary = parsePermitDescDictionary;
            parseWorkCenterDictionary = parsePermitDetailDictionary;
            parseTotalWorkCenterDictionary = parseWorkCenterDictionary;
            permitDetailDescpnDictionary = parseTotalWorkCenterDictionary;
            if ([parseDictionary objectForKey:@"EsPermitTotal"]) {
                parseDictionary = [parseDictionary objectForKey:@"EsPermitTotal"];
                
                if ([parseDictionary isKindOfClass:[NSDictionary class]]) {
                    [xmlDoc setObject:[NSMutableArray arrayWithObject:parseDictionary] forKey:@"permit"];
                }
                else if([parseDictionary isKindOfClass:[NSArray class]])
                {
                    id result = parseDictionary;
                    
                    [xmlDoc setObject:[NSMutableArray arrayWithObject:result] forKey:@"result"];
                }
            }
            
            if ([parseDescriptionDictionary objectForKey:@"EsPermitAppr"])
            {
                parseDescriptionDictionary = [parseDescriptionDictionary objectForKey:@"EsPermitAppr"];
                
                if ([parseDescriptionDictionary isKindOfClass:[NSDictionary class]])
                {
                    [xmlDoc setObject:[NSMutableArray arrayWithObject:parseDescriptionDictionary] forKey:@"WorkApproval"];
                }
                else if ([parseDescriptionDictionary isKindOfClass:[NSArray class]])
                {
                    [xmlDoc setObject:parseDescriptionDictionary forKey:@"Description"];
                }
            }
            
            if ([workApprovalPlantDictionary objectForKey:@"EtPermitApprWerks"])
            {
                workApprovalPlantDictionary = [workApprovalPlantDictionary objectForKey:@"EtPermitApprWerks"];
                
                if ([workApprovalPlantDictionary objectForKey:@"item"]) {
                    
                    workApprovalPlantDictionary = [workApprovalPlantDictionary objectForKey:@"item"];
                    
                    if ([workApprovalPlantDictionary isKindOfClass:[NSDictionary class]])
                    {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:workApprovalPlantDictionary] forKey:@"PermitPlants"];
                    }
                    else if ([workApprovalPlantDictionary isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:workApprovalPlantDictionary forKey:@"PermitPlants"];
                    }
                }
            }
            
            if ([permitPlantDictionary objectForKey:@"EtPermitTotalWerks"])
            {
                permitPlantDictionary = [permitPlantDictionary objectForKey:@"EtPermitTotalWerks"];
                
                if ([permitPlantDictionary objectForKey:@"item"]) {
                    
                    permitPlantDictionary = [permitPlantDictionary objectForKey:@"item"];
                    
                    if ([permitPlantDictionary isKindOfClass:[NSDictionary class]])
                    {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:permitPlantDictionary] forKey:@"PermitTotalPlants"];
                    }
                    else if ([permitPlantDictionary isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:permitPlantDictionary forKey:@"PermitTotalPlants"];
                    }
                }
            }
            
            if ([parsePermitDescDictionary objectForKey:@"EtPermitWa"])
            {
                parsePermitDescDictionary = [parsePermitDescDictionary objectForKey:@"EtPermitWa"];
                
                if ([parsePermitDescDictionary objectForKey:@"item"]) {
                    
                    parsePermitDescDictionary = [parsePermitDescDictionary objectForKey:@"item"];
                    
                    if ([parsePermitDescDictionary isKindOfClass:[NSDictionary class]])
                    {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parsePermitDescDictionary] forKey:@"PermitDescription"];
                    }
                    else if ([parsePermitDescDictionary isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parsePermitDescDictionary forKey:@"PermitDescription"];
                    }
                }
            }
            
            if ([parsePermitDetailDictionary objectForKey:@"EtPermitWd"])
            {
                parsePermitDetailDictionary = [parsePermitDetailDictionary objectForKey:@"EtPermitWd"];
                
                if ([parsePermitDetailDictionary objectForKey:@"item"]) {
                    
                    parsePermitDetailDictionary = [parsePermitDetailDictionary objectForKey:@"item"];
                    
                    if ([parsePermitDetailDictionary isKindOfClass:[NSDictionary class]])
                    {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parsePermitDetailDictionary] forKey:@"PermitDetail"];
                    }
                    else if ([parsePermitDetailDictionary isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parsePermitDetailDictionary forKey:@"PermitDetail"];
                    }
                }
            }
            
            if ([parseWorkCenterDictionary objectForKey:@"EtPermitApprArbpl"])
            {
                parseWorkCenterDictionary = [parseWorkCenterDictionary objectForKey:@"EtPermitApprArbpl"];
                
                if ([parseWorkCenterDictionary objectForKey:@"item"]) {
                    
                    parseWorkCenterDictionary = [parseWorkCenterDictionary objectForKey:@"item"];
                    
                    if ([parseWorkCenterDictionary isKindOfClass:[NSDictionary class]])
                    {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parseWorkCenterDictionary] forKey:@"WorkCenter"];
                    }
                    else if ([parseWorkCenterDictionary isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parseWorkCenterDictionary forKey:@"WorkCenter"];
                    }
                }
            }
            
            if ([parseTotalWorkCenterDictionary objectForKey:@"EtPermitTotalArbpl"])
            {
                parseTotalWorkCenterDictionary = [parseTotalWorkCenterDictionary objectForKey:@"EtPermitTotalArbpl"];
                
                if ([parseTotalWorkCenterDictionary objectForKey:@"item"]) {
                    
                    parseTotalWorkCenterDictionary = [parseTotalWorkCenterDictionary objectForKey:@"item"];
                    
                    if ([parseTotalWorkCenterDictionary isKindOfClass:[NSDictionary class]])
                    {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parseTotalWorkCenterDictionary] forKey:@"TotalWorkCenter"];
                    }
                    else if ([parseTotalWorkCenterDictionary isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parseTotalWorkCenterDictionary forKey:@"TotalWorkCenter"];
                    }
                }
            }
            if ([permitDetailDescpnDictionary objectForKey:@"EtPermitWw"])
            {
                permitDetailDescpnDictionary = [permitDetailDescpnDictionary objectForKey:@"EtPermitWw"];
                
                if ([permitDetailDescpnDictionary objectForKey:@"item"]) {
                    
                    permitDetailDescpnDictionary = [permitDetailDescpnDictionary objectForKey:@"item"];
                    
                    if ([permitDetailDescpnDictionary isKindOfClass:[NSDictionary class]])
                    {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:permitDetailDescpnDictionary] forKey:@"PermitDetailDescription"];
                    }
                    else if ([permitDetailDescpnDictionary isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:permitDetailDescpnDictionary forKey:@"PermitDetailDescription"];
                    }
                }
            }
            
            
        }
        
        return xmlDoc;
    }
    return [NSMutableDictionary dictionary];
}

- (NSMutableDictionary *)parseForAvailabilityData:(NSDictionary *)resultDictionary
{
    NSMutableDictionary *xmlDoc = [NSMutableDictionary dictionary];
    NSDictionary *parseDictionary,*parseDetailDictionary;
    if ([resultDictionary objectForKey:@"env:Body"]) {
        parseDictionary = [resultDictionary objectForKey:@"env:Body"];
        if ([parseDictionary objectForKey:@"n0:ZemtPmappBiPmavrRepResponse"])
        {
            parseDictionary = [parseDictionary objectForKey:@"n0:ZemtPmappBiPmavrRepResponse"];
            parseDetailDictionary = parseDictionary;
            
            if ([parseDictionary objectForKey:@"EtDetail"])
            {
                parseDictionary = [parseDictionary objectForKey:@"EtDetail"];
                
                if ([parseDictionary objectForKey:@"item"]) {
                    
                    parseDictionary = [parseDictionary objectForKey:@"item"];
                    
                    if ([parseDictionary isKindOfClass:[NSDictionary class]])
                    {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parseDictionary] forKey:@"Detail"];
                    }
                    else if ([parseDictionary isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parseDictionary forKey:@"Detail"];
                    }
                }
            }
            
            if ([parseDetailDictionary objectForKey:@"EtSummary"])
            {
                parseDetailDictionary = [parseDetailDictionary objectForKey:@"EtSummary"];
                
                if ([parseDetailDictionary objectForKey:@"item"]) {
                    
                    parseDetailDictionary = [parseDetailDictionary objectForKey:@"item"];
                    
                    if ([parseDetailDictionary isKindOfClass:[NSDictionary class]])
                    {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parseDetailDictionary] forKey:@"Summary"];
                    }
                    else if ([parseDetailDictionary isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parseDetailDictionary forKey:@"Summary"];
                    }
                }
            }
        }
        
        return xmlDoc;
    }
    return [NSMutableDictionary dictionary];
    
}


- (NSMutableDictionary *)parseForMonitorEquipmentHistory:(NSDictionary *)resultDictionary
{
    
    NSMutableDictionary *xmlDoc = [NSMutableDictionary dictionary];
    NSDictionary *parseDictionary,*parseDetailDictionary;
    if ([resultDictionary objectForKey:@"env:Body"]) {
        parseDictionary = [resultDictionary objectForKey:@"env:Body"];
        if ([parseDictionary objectForKey:[Response actionWithWebServiceResponse:MONITOR_EQUIP_HISTORY]])
        {
            parseDictionary = [parseDictionary objectForKey:[Response actionWithWebServiceResponse:MONITOR_EQUIP_HISTORY]];
            parseDetailDictionary = parseDictionary;
            
            if ([parseDictionary objectForKey:@"EtEquiNotif"])
            {
                parseDictionary = [parseDictionary objectForKey:@"EtEquiNotif"];
                
                if ([parseDictionary objectForKey:@"item"]) {
                    
                    parseDictionary = [parseDictionary objectForKey:@"item"];
                    
                    if ([parseDictionary isKindOfClass:[NSDictionary class]])
                    {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parseDictionary] forKey:@"resultEquipmentHistory"];
                    }
                    else if ([parseDictionary isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parseDictionary forKey:@"resultEquipmentHistory"];
                    }
                }
            }
            
        }
        
        return xmlDoc;
    }
    return [NSMutableDictionary dictionary];
    
}

- (NSMutableDictionary *)parseForMonitorMeasurementDocs:(NSDictionary *)resultDictionary
{
    
    NSMutableDictionary *xmlDoc = [NSMutableDictionary dictionary];
    NSDictionary *parseDictionary,*parseDetailDictionary;
    if ([resultDictionary objectForKey:@"env:Body"]) {
        parseDictionary = [resultDictionary objectForKey:@"env:Body"];
        if ([parseDictionary objectForKey:[Response actionWithWebServiceResponse:MONITOR_GET_EQUIP_MDOCS]])
        {
            parseDictionary = [parseDictionary objectForKey:[Response actionWithWebServiceResponse:MONITOR_GET_EQUIP_MDOCS]];
            parseDetailDictionary = parseDictionary;
            
            if ([parseDictionary objectForKey:@"EtImrg"])
            {
                parseDictionary = [parseDictionary objectForKey:@"EtImrg"];
                
                if ([parseDictionary objectForKey:@"item"]) {
                    
                    parseDictionary = [parseDictionary objectForKey:@"item"];
                    
                    if ([parseDictionary isKindOfClass:[NSDictionary class]])
                    {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parseDictionary] forKey:@"resultMonitorMdocs"];
                    }
                    else if ([parseDictionary isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parseDictionary forKey:@"resultMonitorMdocs"];
                    }
                }
            }
            
        }
        
        return xmlDoc;
    }
    return [NSMutableDictionary dictionary];
    
}


-(NSMutableDictionary *)parseForSetMonitorMeasurementDocs:(NSDictionary *)resultDictionary{
    
    NSMutableDictionary *xmlDoc = [NSMutableDictionary dictionary];
    NSDictionary *parseDictionary,*parseMessageDictionary;
    if ([resultDictionary objectForKey:@"env:Body"]) {
        
        parseDictionary = [resultDictionary objectForKey:@"env:Body"];
        if ([parseDictionary objectForKey:[Response actionWithWebServiceResponse:MONITOR_SET_EQUIP_MDOCS]]) {
            parseDictionary = [parseDictionary objectForKey:[Response actionWithWebServiceResponse:MONITOR_SET_EQUIP_MDOCS]];
            
            parseMessageDictionary=parseDictionary;
            
            if ([parseDictionary objectForKey:@"EtImrg"])
            {
                parseDictionary = [parseDictionary objectForKey:@"EtImrg"];
                
                if ([parseDictionary objectForKey:@"item"]) {
                    
                    parseDictionary = [parseDictionary objectForKey:@"item"];
                    
                    if ([parseDictionary isKindOfClass:[NSDictionary class]])
                    {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parseDictionary] forKey:@"resultMonitorMdocs"];
                    }
                    else if ([parseDictionary isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parseDictionary forKey:@"resultMdocs"];
                    }
                }
            }
            
            if([parseMessageDictionary objectForKey:@"EvMessage"]){
                [xmlDoc setObject:[parseMessageDictionary objectForKey:@"EvMessage"] forKey:@"MESSAGE"];
            }
            
            //            if ([parseDictionary objectForKey:@"EtReturn"])
            //            {
            //                parseDictionary = [parseDictionary objectForKey:@"EtReturn"];
            //
            //                if ([parseDictionary objectForKey:@"item"]) {
            //
            //                    parseDictionary = [parseDictionary objectForKey:@"item"];
            //
            //                    if ([parseDictionary isKindOfClass:[NSDictionary class]])
            //                    {
            //                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parseDictionary] forKey:@"resultReturnItem"];
            //                    }
            //                    else if ([parseDictionary isKindOfClass:[NSArray class]])
            //                    {
            //                        [xmlDoc setObject:parseDictionary forKey:@"resultReturnItem"];
            //                    }
            //                }
            //            }
            
            return xmlDoc;
            
        }
    }
    
    return [NSMutableDictionary dictionary];
    
}


- (NSMutableDictionary *)parseForReleaseNotification:(NSDictionary *)resultDictionary{
    
    NSMutableDictionary *xmlDoc = [NSMutableDictionary dictionary];
    id parseDictionary,parseNotifHeader,parseDictionaryTransaction,parseDictionaryLongText,parseDictionaryDocs,parseDictionaryTasks;
    
    
    if ([resultDictionary objectForKey:@"env:Body"]) {
        
        parseDictionary = [resultDictionary objectForKey:@"env:Body"];
        if ([parseDictionary objectForKey:[Response actionWithWebServiceResponse:NOTIFICATION_RELEASE]]) {
            parseDictionary = [parseDictionary objectForKey:[Response actionWithWebServiceResponse:NOTIFICATION_RELEASE]];
            
            //            if ([parseDictionary objectForKey:@"EtNotifDup"]) {
            //                parseDictionary = [parseDictionary objectForKey:@"EtNotifDup"];
            //
            //                if ([parseDictionary objectForKey:@"item"]) {
            //
            //                    parseDictionary = [parseDictionary objectForKey:@"item"];
            //
            //                    if ([parseDictionary isKindOfClass:[NSDictionary class]]) {
            //                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parseDictionary] forKey:@"resultDuplicates"];
            //                    }
            //                    else if([parseDictionary isKindOfClass:[NSArray class]])
            //                    {
            //                        [xmlDoc setObject:parseDictionary forKey:@"resultDuplicates"];
            //                    }
            //
            //                    return xmlDoc;
            //                }
            //            }
            
            parseNotifHeader= parseDictionary;
            parseDictionaryTransaction=parseDictionary;
            parseDictionaryLongText=parseDictionary;
            parseDictionaryDocs=parseDictionary;
            parseDictionaryTasks = parseDictionary;
            
            
            if ([parseDictionary objectForKey:@"EvNotifNum"]) {
                [xmlDoc setObject:[parseDictionary objectForKey:@"EvNotifNum"] forKey:@"OBJECTID"];
            }
            
            if([parseDictionary objectForKey:@"EvMessage"]){
                [xmlDoc setObject:[parseDictionary objectForKey:@"EvMessage"] forKey:@"MESSAGE"];
            }
            
            if ([parseNotifHeader objectForKey:@"EtNotifHeader"]) {
                parseNotifHeader = [parseNotifHeader objectForKey:@"EtNotifHeader"];
                if ([parseNotifHeader objectForKey:@"item"]) {
                    parseNotifHeader = [parseNotifHeader objectForKey:@"item"];
                    if ([parseNotifHeader isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parseNotifHeader] forKey:@"resultHeader"];
                    }
                    else if([parseNotifHeader isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parseNotifHeader forKey:@"resultHeader"];
                    }
                }
            }
            
            if ([parseDictionaryTransaction objectForKey:@"EtNotifItems"]) {
                parseDictionaryTransaction = [parseDictionaryTransaction objectForKey:@"EtNotifItems"];
                if ([parseDictionaryTransaction objectForKey:@"item"]) {
                    parseDictionaryTransaction = [parseDictionaryTransaction objectForKey:@"item"];
                    if ([parseDictionaryTransaction isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parseDictionaryTransaction] forKey:@"resultTransactions"];
                    }
                    else if([parseDictionaryTransaction isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parseDictionaryTransaction forKey:@"resultTransactions"];
                    }
                }
            }
            
            
            if ([parseDictionaryLongText objectForKey:@"EtNotifLongtext"]) {
                parseDictionaryLongText = [parseDictionaryLongText objectForKey:@"EtNotifLongtext"];
                if ([parseDictionaryLongText objectForKey:@"item"]) {
                    parseDictionaryLongText = [parseDictionaryLongText objectForKey:@"item"];
                    if ([parseDictionaryLongText isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parseDictionaryLongText] forKey:@"resultLongText"];
                    }
                    else if([parseDictionaryLongText isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parseDictionaryLongText forKey:@"resultLongText"];
                    }
                }
            }
            
            
            if ([parseDictionaryDocs objectForKey:@"EtDocs"]) {
                parseDictionaryDocs = [parseDictionaryDocs objectForKey:@"EtDocs"];
                if ([parseDictionaryDocs objectForKey:@"item"]) {
                    parseDictionaryDocs = [parseDictionaryDocs objectForKey:@"item"];
                    if ([parseDictionaryDocs isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parseDictionaryDocs] forKey:@"resultDocs"];
                    }
                    else if([parseDictionaryDocs isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parseDictionaryDocs forKey:@"resultDocs"];
                    }
                }
            }
            
            if ([parseDictionaryTasks objectForKey:@"EtNotifTasks"]) {
                parseDictionaryTasks = [parseDictionaryTasks objectForKey:@"EtNotifTasks"];
                if ([parseDictionaryTasks objectForKey:@"item"]) {
                    parseDictionaryTasks = [parseDictionaryTasks objectForKey:@"item"];
                    if ([parseDictionaryTasks isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parseDictionaryTasks] forKey:@"resultTasks"];
                    }
                    else if([parseDictionaryTasks isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parseDictionaryTasks forKey:@"resultTasks"];
                    }
                }
            }
            
            return xmlDoc;
            
        }
    }
    return [NSMutableDictionary dictionary];
}


- (NSMutableDictionary *)parseForReleaseOrder:(NSDictionary *)resultDictionary{
    
    NSMutableDictionary *xmlDoc = [NSMutableDictionary dictionary];
    NSDictionary *parseDictionary;
    
    id parseDictionaryHeader,parseDictionaryHeaderPermits,parseDictionaryOperationTransaction,parseDictionaryComponentsTransaction,parseDictionaryLongText,parseDictionaryDocs,parsedDictionaryCheckPoints,parsedDictionaryWorkApplications,parsedDictionaryWcagns,parsedDictionaryOpWCDDetails,parsedDictionaryOpWCDItemDetails,parsedDictionaryWorkApprovalDetails,parsedDictionaryMeasurementDocuments;
    
    if ([resultDictionary objectForKey:@"env:Body"]) {
        
        parseDictionary = [resultDictionary objectForKey:@"env:Body"];
        if ([parseDictionary objectForKey:[Response actionWithWebServiceResponse:ORDER_RELEASE]]) {
            
            parseDictionary = [parseDictionary objectForKey:[Response actionWithWebServiceResponse:ORDER_RELEASE]];
            
            parseDictionaryHeader=parseDictionary;
            parseDictionaryHeaderPermits = parseDictionary;
            parseDictionaryOperationTransaction = parseDictionary;
            parseDictionaryComponentsTransaction = parseDictionary;
            parseDictionaryLongText = parseDictionary;
            parseDictionaryDocs = parseDictionary;
            parsedDictionaryCheckPoints = parseDictionary;
            parsedDictionaryWorkApplications = parseDictionary;
            parsedDictionaryWcagns = parseDictionary;
            parsedDictionaryOpWCDDetails = parseDictionary;
            parsedDictionaryOpWCDItemDetails = parseDictionary;
            parsedDictionaryWorkApprovalDetails = parseDictionary;
            parsedDictionaryMeasurementDocuments = parseDictionary;
            
            if ([parseDictionary objectForKey:@"EvMessage"]) {
                [xmlDoc setObject:[parseDictionary objectForKey:@"EvMessage"] forKey:@"Message"];
            }
            
            if([parseDictionary objectForKey:@"EvAufnr"]){
                [xmlDoc setObject:[parseDictionary objectForKey:@"EvAufnr"] forKey:@"OBJECTID"];
            }
            
            if ([parseDictionaryHeader objectForKey:@"EtOrderHeader"]) {
                parseDictionaryHeader = [parseDictionaryHeader objectForKey:@"EtOrderHeader"];
                if ([parseDictionaryHeader objectForKey:@"item"]) {
                    parseDictionaryHeader = [parseDictionaryHeader objectForKey:@"item"];
                    if ([parseDictionaryHeader isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parseDictionaryHeader] forKey:@"resultHeader"];
                    }
                    else if([parseDictionaryHeader isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parseDictionaryHeader forKey:@"resultHeader"];
                    }
                }
            }
            
            if ([parseDictionaryHeaderPermits objectForKey:@"EtOrderPermits"]) {
                parseDictionaryHeaderPermits = [parseDictionaryHeaderPermits objectForKey:@"EtOrderPermits"];
                if ([parseDictionaryHeaderPermits objectForKey:@"item"]) {
                    parseDictionaryHeaderPermits = [parseDictionaryHeaderPermits objectForKey:@"item"];
                    if ([parseDictionaryHeaderPermits isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parseDictionaryHeaderPermits] forKey:@"resultHeaderPermits"];
                    }
                    else if([parseDictionaryHeaderPermits isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parseDictionaryHeaderPermits forKey:@"resultHeaderPermits"];
                    }
                }
            }
            
            if ([parseDictionaryOperationTransaction objectForKey:@"EtOrderOperations"]) {
                parseDictionaryOperationTransaction = [parseDictionaryOperationTransaction objectForKey:@"EtOrderOperations"];
                if ([parseDictionaryOperationTransaction objectForKey:@"item"]) {
                    parseDictionaryOperationTransaction = [parseDictionaryOperationTransaction objectForKey:@"item"];
                    if ([parseDictionaryOperationTransaction isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parseDictionaryOperationTransaction] forKey:@"resultOperationsTransactions"];
                    }
                    else if([parseDictionaryOperationTransaction isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parseDictionaryOperationTransaction forKey:@"resultOperationsTransactions"];
                    }
                }
            }
            
            if ([parseDictionaryComponentsTransaction objectForKey:@"EtOrderComponents"]) {
                parseDictionaryComponentsTransaction = [parseDictionaryComponentsTransaction objectForKey:@"EtOrderComponents"];
                if ([parseDictionaryComponentsTransaction objectForKey:@"item"]) {
                    parseDictionaryComponentsTransaction = [parseDictionaryComponentsTransaction objectForKey:@"item"];
                    if ([parseDictionaryComponentsTransaction isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parseDictionaryComponentsTransaction] forKey:@"resultComponentsTransactions"];
                    }
                    else if([parseDictionaryComponentsTransaction isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parseDictionaryComponentsTransaction forKey:@"resultComponentsTransactions"];
                    }
                }
            }
            
            if ([parseDictionaryLongText objectForKey:@"EtOrderLongtext"]) {
                parseDictionaryLongText = [parseDictionaryLongText objectForKey:@"EtOrderLongtext"];
                if ([parseDictionaryLongText objectForKey:@"item"]) {
                    parseDictionaryLongText = [parseDictionaryLongText objectForKey:@"item"];
                    if ([parseDictionaryLongText isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parseDictionaryLongText] forKey:@"resultLongText"];
                    }
                    else if([parseDictionaryLongText isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parseDictionaryLongText forKey:@"resultLongText"];
                    }
                }
            }
            
            if ([parseDictionaryDocs objectForKey:@"EtDocs"]) {
                parseDictionaryDocs = [parseDictionaryDocs objectForKey:@"EtDocs"];
                if ([parseDictionaryDocs objectForKey:@"item"]) {
                    parseDictionaryDocs = [parseDictionaryDocs objectForKey:@"item"];
                    if ([parseDictionaryDocs isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parseDictionaryDocs] forKey:@"resultDocs"];
                    }
                    else if([parseDictionaryDocs isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parseDictionaryDocs forKey:@"resultDocs"];
                    }
                }
            }
            
            
            //WCM
            if ([parsedDictionaryCheckPoints objectForKey:@"EtWcmWaChkReq"]) {
                parsedDictionaryCheckPoints = [parsedDictionaryCheckPoints objectForKey:@"EtWcmWaChkReq"];
                if ([parsedDictionaryCheckPoints objectForKey:@"item"]) {
                    parsedDictionaryCheckPoints = [parsedDictionaryCheckPoints objectForKey:@"item"];
                    if ([parsedDictionaryCheckPoints isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parsedDictionaryCheckPoints] forKey:@"resultStandardCheckPoints"];
                    }
                    else if([parsedDictionaryCheckPoints isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parsedDictionaryCheckPoints forKey:@"resultStandardCheckPoints"];
                    }
                }
            }
            
            if ([parsedDictionaryWorkApplications objectForKey:@"EtWcmWaData"]) {
                parsedDictionaryWorkApplications = [parsedDictionaryWorkApplications objectForKey:@"EtWcmWaData"];
                if ([parsedDictionaryWorkApplications objectForKey:@"item"]) {
                    parsedDictionaryWorkApplications = [parsedDictionaryWorkApplications objectForKey:@"item"];
                    if ([parsedDictionaryWorkApplications isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parsedDictionaryWorkApplications] forKey:@"resultWorkApplicationData"];
                    }
                    else if([parsedDictionaryWorkApplications isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parsedDictionaryWorkApplications forKey:@"resultWorkApplicationData"];
                    }
                }
            }
            
            if ([parsedDictionaryWcagns objectForKey:@"EtWcmWcagns"]) {
                parsedDictionaryWcagns = [parsedDictionaryWcagns objectForKey:@"EtWcmWcagns"];
                if ([parsedDictionaryWcagns objectForKey:@"item"]) {
                    parsedDictionaryWcagns = [parsedDictionaryWcagns objectForKey:@"item"];
                    if ([parsedDictionaryWcagns isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parsedDictionaryWcagns] forKey:@"resultIssuePermits"];//issue permits
                    }
                    else if([parsedDictionaryWcagns isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parsedDictionaryWcagns forKey:@"resultIssuePermits"];//issue permits
                    }
                }
            }
            
            if ([parsedDictionaryOpWCDDetails objectForKey:@"EtWcmWdData"]) {
                parsedDictionaryOpWCDDetails = [parsedDictionaryOpWCDDetails objectForKey:@"EtWcmWdData"];
                if ([parsedDictionaryOpWCDDetails objectForKey:@"item"]) {
                    parsedDictionaryOpWCDDetails = [parsedDictionaryOpWCDDetails objectForKey:@"item"];
                    if ([parsedDictionaryOpWCDDetails isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parsedDictionaryOpWCDDetails] forKey:@"resultOperationWCDData"];//isolation
                    }
                    else if([parsedDictionaryOpWCDDetails isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parsedDictionaryOpWCDDetails forKey:@"resultOperationWCDData"];//isolation
                    }
                }
            }
            
            if ([parsedDictionaryOpWCDItemDetails objectForKey:@"EtWcmWdItemData"]) {
                parsedDictionaryOpWCDItemDetails = [parsedDictionaryOpWCDItemDetails objectForKey:@"EtWcmWdItemData"];
                if ([parsedDictionaryOpWCDItemDetails objectForKey:@"item"]) {
                    parsedDictionaryOpWCDItemDetails = [parsedDictionaryOpWCDItemDetails objectForKey:@"item"];
                    if ([parsedDictionaryOpWCDItemDetails isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parsedDictionaryOpWCDItemDetails] forKey:@"resultOperationWCDItemData"];//tagging conditions
                    }
                    else if([parsedDictionaryOpWCDItemDetails isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parsedDictionaryOpWCDItemDetails forKey:@"resultOperationWCDItemData"];//tagging conditions
                    }
                }
            }
            
            if ([parsedDictionaryWorkApprovalDetails objectForKey:@"EtWcmWwData"]) {
                parsedDictionaryWorkApprovalDetails = [parsedDictionaryWorkApprovalDetails objectForKey:@"EtWcmWwData"];
                if ([parsedDictionaryWorkApprovalDetails objectForKey:@"item"]) {
                    parsedDictionaryWorkApprovalDetails = [parsedDictionaryWorkApprovalDetails objectForKey:@"item"];
                    if ([parsedDictionaryWorkApprovalDetails isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parsedDictionaryWorkApprovalDetails] forKey:@"resultWorkApprovalsData"];
                    }
                    else if([parsedDictionaryWorkApprovalDetails isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parsedDictionaryWorkApprovalDetails forKey:@"resultWorkApprovalsData"];
                    }
                }
            }
            
            
            
            return xmlDoc;
            
        }
    }
    
    return [NSMutableDictionary dictionary];
}

- (NSMutableDictionary *)parseForMeasurementDocs:(NSDictionary *)resultDictionary
{
    NSMutableDictionary *xmlDoc = [NSMutableDictionary dictionary];
    NSDictionary *parseDictionary;
    if ([resultDictionary objectForKey:@"env:Body"]) {
        
        parseDictionary = [resultDictionary objectForKey:@"env:Body"];
        if ([parseDictionary objectForKey:[Response actionWithWebServiceResponse:ORDER_MDOCS]]) {
            parseDictionary = [parseDictionary objectForKey:[Response actionWithWebServiceResponse:ORDER_MDOCS]];
            
            if ([parseDictionary objectForKey:@"EtEquiMptt"]) {
                if ([[parseDictionary objectForKey:@"EtEquiMptt"] isKindOfClass:[NSDictionary class]]) {
                    [xmlDoc setObject:[NSMutableArray arrayWithObject:[parseDictionary objectForKey:@"EtEquiMptt"]] forKey:@"resultMDocs"];
                }
                else if ([[parseDictionary objectForKey:@"EtEquiMptt"] isKindOfClass:[NSArray class]]){
                    
                    [xmlDoc setObject:[parseDictionary objectForKey:@"EtEquiMptt"] forKey:@"resultMDocs"];
                }
            }
            
            return xmlDoc;
        }
    }
    
    return [NSMutableDictionary dictionary];
}

- (NSMutableDictionary *)parseForEquipmentBreakdownData:(NSDictionary *)resultDictionary
{
    NSMutableDictionary *xmlDoc = [NSMutableDictionary dictionary];
    NSDictionary *parseDictionary,*parseDescriptionDictionary;
    if ([resultDictionary objectForKey:@"env:Body"]) {
        parseDictionary = [resultDictionary objectForKey:@"env:Body"];
        if ([parseDictionary objectForKey:@"n0:ZemtPmappBiEqbkStatResponse"])
        {
            parseDictionary = [parseDictionary objectForKey:@"n0:ZemtPmappBiEqbkStatResponse"];
            parseDescriptionDictionary = parseDictionary;
            
            if ([parseDictionary objectForKey:@"EsBkdnTotal"]) {
                parseDictionary = [parseDictionary objectForKey:@"EsBkdnTotal"];
                
                if ([parseDictionary isKindOfClass:[NSDictionary class]]) {
                    [xmlDoc setObject:[NSMutableArray arrayWithObject:parseDictionary] forKey:@"result"];
                }
                else if([parseDictionary isKindOfClass:[NSArray class]])
                {
                    id result = parseDictionary;
                    
                    [xmlDoc setObject:[NSMutableArray arrayWithObject:result] forKey:@"result"];
                }
            }
            
            if ([parseDescriptionDictionary objectForKey:@"EtBkdnMonthTotal"])
            {
                parseDescriptionDictionary = [parseDescriptionDictionary objectForKey:@"EtBkdnMonthTotal"];
                
                if ([parseDescriptionDictionary objectForKey:@"item"]) {
                    
                    parseDescriptionDictionary = [parseDescriptionDictionary objectForKey:@"item"];
                    
                    if ([parseDescriptionDictionary isKindOfClass:[NSDictionary class]])
                    {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parseDescriptionDictionary] forKey:@"Description"];
                    }
                    else if ([parseDescriptionDictionary isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parseDescriptionDictionary forKey:@"Description"];
                        
                    }
                }
            }
            
        }
        
        return xmlDoc;
        
    }
    
    return [NSMutableDictionary dictionary];
}


- (NSMutableDictionary *)parseForgetTokenId:(NSDictionary *)resultDictionary
{
    NSMutableDictionary *xmlDoc = [NSMutableDictionary dictionary];
    NSDictionary *parseDictionary;
    if ([resultDictionary objectForKey:@"env:Body"]) {
        
        parseDictionary = [resultDictionary objectForKey:@"env:Body"];
        
        if ([parseDictionary objectForKey:[Response actionWithWebServiceResponse:DEVICE_TOKEN]]) {
            parseDictionary = [parseDictionary objectForKey:[Response actionWithWebServiceResponse:DEVICE_TOKEN]];
            
            if ([parseDictionary objectForKey:@"EvTokenid"]) {
                if ([parseDictionary objectForKey:@"EvTokenid"]) {
                    [xmlDoc setObject:[parseDictionary objectForKey:@"EvTokenid"] forKey:@"TokenId"];
                }
            }
        }
        return xmlDoc;
    }
    return [NSMutableDictionary dictionary];
}


@end


