//
//  UrlConstraints.h
//  PlantMaintenance
//
//  Created by Enstrapp on 16/02/15.
//  Copyright (c) 2015 Enstrapp IT Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UrlConstraints : NSObject

//extern NSString* const HOST_URL;
//extern NSString* const PORT_NUMBER;

#pragma SOAP+XML details
extern NSString* const URL_APP_SETTINGS;
extern NSString* const URL_HOST;
extern NSString* const URL_PORT;
extern NSString* const URL_PATH;
extern NSString* const URL_LOGIN;
extern NSString* const URL_GET_SYNC_MAP_DATA;
extern NSString* const URL_GET_NOTIFTYPE;
extern NSString* const URL_GET_NOTIF_PRIORITY;
extern NSString* const URL_GET_ORDER_PRIORITY;
extern NSString* const URL_GET_COSTCENTERLIST;
extern NSString* const URL_GET_USER_DATA;
extern NSString* const URL_GET_ALLNOTIFCODES;
extern NSString* const URL_GET_FUNCLOC_EQUIPMENT;
extern NSString* const URL_GET_EQUIPNO_FUNCLOC;
extern NSString* const URL_SEARCH_FUNCLOC_EQUIPMENT;
extern NSString* const URL_GET_ORDERTYPE;
extern NSString* const URL_GET_ACCINDICATOR;
extern NSString* const URL_GET_UNITS;
extern NSString* const URL_GET_USER_FUNCTION;

extern NSString* const URL_GET_FUNCLOC_COSTCENTER;
extern NSString* const URL_GET_EQUIPNO_COSTCENTER;

extern NSString* const URL_GET_LIST_OF_COMPONENTS;
extern NSString* const URL_GET_LIST_OF_MOVEMENT_TYPES;

extern NSString* const URL_GET_LIST_OF_NOTIFICATIONS;
extern NSString* const URL_GET_LIST_OF_OPEN_NOTIFICATIONS;
extern NSString* const URL_GET_LIST_OF_ORDERS;
extern NSString* const URL_GET_LIST_OF_OPEN_ORDERS;

extern NSString* const URL_CREATE_NOTIFICATION;
extern NSString* const URL_CREATE_NOTIFICATION_RESPONSE;
extern NSString* const URL_CHANGE_NOTIFICATION;
extern NSString* const URL_CANCEL_NOTIFICATION;
extern NSString* const URL_COMPLETE_NOTIFICATION;
extern NSString* const URL_DUE_NOTIFICATION;

extern NSString* const URL_CREATE_ORDER;
extern NSString* const URL_CHANGE_ORDER;
extern NSString* const URL_CANCEL_ORDER;
extern NSString* const URL_CONFIRM_ORDER;
extern NSString* const URL_COLLECTIVE_CONFIRM_ORDER;
extern NSString* const URL_DUE_ORDER;

extern NSString* const URL_GET_LIST_OF_PM_BOMS;
extern NSString* const URL_RESERVE_UTILITY;
extern NSString* const URL_GET_STOCK_DATA;
extern NSString* const URL_GET_LOG_DATA;
extern NSString* const URL_GET_PERMITS_DATA;
extern NSString* const URL_GET_MATERIAL_AVAILABILITY;
extern NSString* const URL_GET_PLANTS;
extern NSString* const URL_GET_STORAGELOCATION;
extern NSString* const URL_GET_WORKCENTER;
extern NSString* const URL_GET_CUSTOMFIELDS;

extern NSString* const URL_BREAKDOWN_STATISTICS;
extern NSString* const URL_NOTIFICATIONS_REPORT;

extern NSString* const URL_GET_MCKLST;
extern NSString* const URL_SET_MCKLST;

extern NSString* const URL_PERMIT_REPORT;
extern NSString* const URL_GET_INITIAL_ZIP;
extern NSString* const URL_AVAILABILITY_REPORT;
extern NSString* const URL_EQUIPMENT_BREAKDOWN;
extern NSString* const URL_ORDER_REPORT;


#pragma mark - odata details

extern NSString* const URL_PATH_ODATA;
extern NSString* const URL_LOGIN_ODATA;
extern NSString* const URL_GET_SYNC_MAP_ODATA;
extern NSString* const URL_APP_SETTINGS_ODATA;
extern NSString* const URL_GET_NOTIFTYPE_ODATA;
extern NSString* const URL_GET_NOTIF_PRIORITY_ODATA;
extern NSString* const URL_GET_ORDER_PRIORITY_ODATA;
extern NSString* const URL_GET_COSTCENTERLIST_ODATA;
extern NSString* const URL_GET_USER_DATA_ODATA;
extern NSString* const URL_GET_ALLNOTIFCODES_ODATA;
extern NSString* const URL_GET_FUNCLOC_EQUIPMENT_ODATA;
extern NSString* const URL_GET_EQUIPNO_FUNCLOC_ODATA;
extern NSString* const URL_GET_ORDERTYPE_ODATA;
extern NSString* const URL_GET_ACCINDICATOR_ODATA;
extern NSString* const URL_GET_UNITS_ODATA;

extern NSString* const URL_GET_FUNCLOC_COSTCENTER_ODATA;
extern NSString* const URL_GET_EQUIPNO_COSTCENTER_ODATA;

extern NSString* const URL_GET_LISTOFCOMPONENTS_ODATA;
extern NSString* const URL_GET_LISTOFMOVEMENTTYPES_ODATA;

extern NSString* const URL_CREATE_NOTIFICATION_ODATA;
extern NSString* const URL_CREATE_NOTIFICATION_RESPONSE_ODATA;
extern NSString* const URL_CHANGE_NOTIFICATION_ODATA;
extern NSString* const URL_CANCEL_NOTIFICATION_ODATA;
extern NSString* const URL_COMPLETE_NOTIFICATION_ODATA;

extern NSString* const URL_CREATE_ORDER_ODATA;
extern NSString* const URL_CHANGE_ORDER_ODATA;
extern NSString* const URL_CANCEL_ORDER_ODATA;
extern NSString* const URL_CONFIRM_ORDER_ODATA;

extern NSString* const URL_RESERVE_UTILITY_ODATA;
extern NSString* const URL_FETCH_SESSION_ODATA;

extern NSString* const URL_GET_LIST_OF_NOTIFICATIONS_ODATA;
extern NSString* const URL_GET_LIST_OF_OPEN_NOTIFICATIONS_ODATA;
extern NSString* const URL_GET_LIST_OF_ORDERS_ODATA;
extern NSString* const URL_GET_LIST_OF_OPEN_ORDERS_ODATA;

extern NSString* const URL_GET_LIST_OF_PM_BOMS_ODATA;
extern NSString* const URL_GET_STOCK_DATA_ODATA;

extern NSString* const URL_GET_LOG_DATA_ODATA;

extern NSString* const URL_GET_MATERIAL_AVAILABILITY_ODATA;
extern NSString* const URL_GET_PERMITS_DATA_ODATA;



@end
