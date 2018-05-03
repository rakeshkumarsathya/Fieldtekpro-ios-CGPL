//
//  UrlConstraints.m
//  PlantMaintenance
//
//  Created by Enstrapp on 16/02/15.
//  Copyright (c) 2015 Enstrapp IT Solutions. All rights reserved.
//

#import "UrlConstraints.h"

@implementation UrlConstraints

 
//NSString* const URL_HOST = @"https://tpcecd.tpc.co.in";
//NSString* const URL_PORT = @"1443";
//
//NSString* const URL_PATH = @"/sap/bc/srt/pm/sap/";

NSString* const URL_HOST = @"http://172.16.213.16";
NSString* const URL_PORT = @"8000";

NSString* const URL_PATH = @"/sap/bc/srt/pm/sap/";

//NSString* const URL_LOGIN = @"pm_ws_authnticate_login/800/zemt_pm_ws_authnticate_login/zemt_pm_ws_authnticate_login_binding";

NSString* const URL_LOGIN = @"zemt_pm_ws_authnticate_login/240/local/zftekp_profile/1/binding_t_https_a_http_zemt_pm_ws_authnticate_login_zftekp_profile_l";

NSString* const URL_GET_SYNC_MAP_DATA = @"zemt_pm_ws_get_sync_map_data/240/local/zftekp_profile/1/binding_t_https_a_http_zemt_pm_ws_get_sync_map_data_zftekp_profile_l";

NSString* const URL_APP_SETTINGS = @"pm_ws_get_app_settings/800/zemt_pm_ws_get_app_settings/zemt_pm_ws_get_app_settings_binding";

NSString* const URL_GET_NOTIFTYPE = @"pm_ws_get_notif_types/800/zemt_pm_ws_get_notif_types/zemt_pm_ws_get_notif_types_binding";

NSString* const URL_GET_NOTIF_PRIORITY = @"pm_ws_get_notif_priority/800/zemt_pm_ws_get_notif_priority/zemt_pm_ws_get_notif_priority_binding";

NSString* const URL_GET_ORDER_PRIORITY = @"pm_ws_get_ord_prioroty/800/zemt_pm_ws_get_ord_priority/zemt_pm_ws_get_ord_priority_binding";

NSString* const URL_GET_COSTCENTERLIST = @"pm_ws_list_cost_center/800/zemt_pm_ws_list_cost_center/zemt_pm_ws_list_cost_center_binding";

NSString* const URL_GET_USER_DATA = @"pm_ws_get_user_data/800/zemt_pm_ws_get_uesr_data/zemt_pm_ws_get_uesr_data_binding";

NSString* const URL_GET_USER_FUNCTION = @"pm_ws_get_user_function/800/zemt_pm_ws_get_user_function/zemt_pm_ws_get_user_function_binding";

NSString* const URL_GET_ALLNOTIFCODES = @"pm_ws_get_notif_codes_all/800/zemt_pm_ws_get_notif_codes_all/zemt_pm_ws_get_notif_codes_all_binding";

NSString* const URL_GET_ORDERTYPE = @"pm_ws_get_ord_types/800/zemt_pm_ws_get_ord_types/zemt_pm_ws_get_ord_types_binding";

NSString* const URL_GET_ACCINDICATOR = @"pm_ws_get_ord_acc_ind/800/zemt_pm_ws_get_ord_acc_ind/zemt_pm_ws_get_ord_acc_ind_binding";

NSString* const URL_GET_UNITS = @"pm_ws_get_units/800/zemt_pm_ws_get_units/zemt_pm_ws_get_units_binding";

NSString* const URL_GET_FUNCLOC_COSTCENTER = @"pm_ws_search_floc/800/zemt_pm_ws_search_floc/zemt_pm_ws_search_floc_binding";

NSString* const URL_GET_FUNCLOC_EQUIPMENT = @"pm_ws_get_floc_from_equi/800/zemt_pm_ws_get_floc_from_equi/zemt_pm_ws_get_floc_from_equi_binding";

NSString* const URL_GET_EQUIPNO_COSTCENTER = @"pm_ws_search_equip/800/zemt_pm_ws_search_equip/zemt_pm_ws_search_equip_binding";

NSString* const URL_GET_EQUIPNO_FUNCLOC = @"pm_ws_get_equns_from_floc/800/zemt_pm_ws_get_equns_from_floc/zemt_pm_ws_get_equns_from_floc_binding";

NSString* const URL_SEARCH_FUNCLOC_EQUIPMENT = @"pm_ws_search_floc_equip/800/zemt_pm_ws_search_floc_equip/zemt_pm_ws_search_floc_equip_binding";

NSString* const URL_GET_LIST_OF_COMPONENTS = @"pm_ws_list_of_components/800/zemt_pm_ws_list_of_components/zemt_pm_ws_list_of_components_binding";

NSString* const URL_GET_LIST_OF_NOTIFICATIONS = @"pm_ws_list_notification/800/zemt_pm_ws_list_notification/zemt_pm_ws_list_notification_binding";

NSString* const URL_GET_LIST_OF_OPEN_NOTIFICATIONS = @"pm_ws_list_open_notifi/800/zemt_pm_ws_list_open_notif/zemt_pm_ws_list_open_notif_binding";

NSString* const URL_GET_LIST_OF_ORDERS = @"pm_ws_list_order/800/zemt_pm_ws_list_order/zemt_pm_ws_list_order_binding";

NSString* const URL_GET_LIST_OF_OPEN_ORDERS = @"pm_ws_search_open_ordrs/800/zemt_pm_ws_open_orders/zemt_pm_ws_open_orders_binding";

NSString* const URL_CREATE_NOTIFICATION = @"pm_ws_create_notifcation/800/zemt_pm_ws_create_notif/zemt_pm_ws_create_notif_binding";

NSString* const URL_CHANGE_NOTIFICATION = @"pm_ws_change_notifcation/800/zemt_pm_ws_change_notif/zemt_pm_ws_change_notif_binding";

NSString* const URL_CANCEL_NOTIFICATION = @"pm_ws_cancel_notifcation/800/zemt_pm_ws_cancel_notification/zemt_pm_ws_cancel_notification_binding";

NSString* const URL_COMPLETE_NOTIFICATION = @"pm_ws_complete_notif/800/zemt_pm_ws_complete_notif/zemt_pm_ws_complete_notif_binding";

NSString* const URL_DUE_NOTIFICATION = @"pm_ws_due_notification/800/zemt_pm_ws_due_notification/zemt_pm_ws_due_notification_binding";

NSString* const URL_CREATE_ORDER = @"pm_ws_create_sorder/800/zemt_pm_ws_create_sorder/zemt_pm_ws_create_sorder_binding";

NSString* const URL_CHANGE_ORDER =@"pm_ws_change_service_ord/800/zemt_pm_ws_change_service_order/zemt_pm_ws_change_service_order_binding";

NSString* const URL_CANCEL_ORDER = @"pm_ws_cancel_order/800/zemt_pm_ws_cancel_order/zemt_pm_ws_cancel_order_binding";

NSString* const URL_CONFIRM_ORDER = @"pm_ws_confirm_ord/800/zemt_pm_ws_confirm_ord/zemt_pm_ws_confirm_ord_binding";

NSString* const URL_COLLECTIVE_CONFIRM_ORDER = @"pm_ws_confirm_order_coll/800/confirm_order_coll/binding";

NSString* const URL_DUE_ORDER = @"pm_ws_due_orders/800/zemt_pm_ws_due_orders/zemt_pm_ws_due_orders_binding";

NSString* const URL_GET_LIST_OF_PM_BOMS = @"pm_ws_list_of_eqboms/800/zemt_pm_ws_list_of_eqboms/zemt_pm_ws_list_of_eqboms_binding";

NSString* const URL_RESERVE_UTILITY = @"pm_ws_reserv_bom_comps/800/zemt_pm_ws_reserv_bom_comps/zemt_pm_ws_reserv_bom_comps_binding";

NSString* const URL_GET_STOCK_DATA = @"pm_ws_get_stock_data/800/zemt_pm_ws_get_stock_data/zemt_pm_ws_get_stock_data_binding";

NSString* const URL_GET_LIST_OF_MOVEMENT_TYPES = @"pm_ws_list_movement_types/800/zemt_pm_ws_list_movement_types/zemt_pm_ws_list_movement_types_binding";

NSString* const URL_GET_LOG_DATA = @"pm_ws_get_log_data/800/zemt_pm_ws_get_log_data/zemt_pm_ws_get_log_data_binding";

NSString* const URL_GET_PERMITS_DATA = @"pm_ws_get_permits_all/800/zemt_pm_ws_get_permits_all/zemt_pm_ws_get_permits_all_binding";

NSString* const URL_GET_MATERIAL_AVAILABILITY = @"pm_ws_mat_avail_check/800/zemt_pm_ws_mat_avail_check/zemt_pm_ws_mat_avail_check_binding";

NSString* const URL_GET_PLANTS = @"pm_ws_get_plants/800/zemt_pm_ws_get_plants/zemt_pm_ws_get_plants_binding";

NSString* const URL_GET_STORAGELOCATION = @"pm_ws_get_sloc/800/zemt_pm_ws_get_sloc/zemt_pm_ws_get_sloc_binding";

NSString* const URL_GET_WORKCENTER = @"pm_ws_get_wkctr/800/zemt_pm_ws_get_wkctr/zemt_pm_ws_get_wkctr_binding";

NSString* const URL_GET_CUSTOMFIELDS = @"pm_ws_get_custom_fields/800/zemt_pm_ws_get_custom_fields/zemt_pm_ws_get_custom_fields_binding";

//https://vjddev.valjha.vedantaresource.local:1443/sap/bc/srt/pm/sap/zemt_pmapp_ws_bi_bkdn_stat/400/local/zemt_ftekpro/1/binding_t_https_a_http_zemt_pmapp_ws_bi_bkdn_stat_zemt_ftekpro_l

NSString* const URL_BREAKDOWN_STATISTICS = @"zemt_pmapp_ws_bi_bkdn_stat/400/local/zemt_ftekpro/1/binding_t_http_a_http_zemt_pmapp_ws_bi_bkdn_stat_zemt_ftekpro_l";

//NSString* const URL_NOTIFICATIONS_REPORT = @"zemt_pmapp_bi_notif_rep/400/local/zemt_ftekpro/1/binding_t_http_a_http_zemt_pmapp_bi_notif_rep_zemt_ftekpro_l";

NSString* const URL_GET_MCKLST = @"zemt_pmapp_ws_get_mchk_list/400/local/zemt_ftekpro/1/binding_t_http_a_http_zemt_pmapp_ws_get_mchk_list_zemt_ftekpro_l";

NSString* const URL_SET_MCKLST = @"zemt_pmapp_ws_set_mchk_list/400/local/zemt_ftekpro/1/binding_t_http_a_http_zemt_pmapp_ws_set_mchk_list_zemt_ftekpro_l";

//NSString* const URL_PERMIT_REPORT = @"zemt_pmapp_bi_permit_rep/400/local/zemt_ftekpro/1/binding_t_http_a_http_zemt_pmapp_bi_permit_rep_zemt_ftekpro_l";

NSString* const URL_GET_INITIAL_ZIP = @"";

NSString* const URL_AVAILABILITY_REPORT = @"zemt_pmapp_bi_pmavr_rep/400/local/zemt_ftekpro/1/binding_t_http_a_http_zemt_pmapp_bi_pmavr_rep_zemt_ftekpro_l";

NSString* const  URL_EQUIPMENT_BREAKDOWN = @"zemt_pmapp_ws_bi_eqbk_stat/800/local/zemt_ftekpro/1/binding_t_http_a_http_zemt_pmapp_ws_bi_eqbk_stat_zemt_ftekpro_l";

NSString* const URL_NOTIFICATIONS_REPORT = @"zemt_pmapp_ws_bi_notif_rep/800/bi_notif_rep/binding";

NSString* const URL_PERMIT_REPORT = @"zemt_pmapp_ws_bi_permit_rep/800/bi_permit_rep/binding";

NSString* const URL_ORDER_REPORT = @"zemt_pmapp_ws_bi_ord_rep/800/bi_ord_rep/binding";

//http://172.16.213.16:8000/sap/opu/odata/sap/ZEMT_PMAPP_SRV/AuthLoginDataSet?$filter=IvUsername eq 'enst-kamal' and IvPassword eq 'enst-2017' and IvLanguage eq 'EN' and Muser eq 'KAMAL' and Deviceid eq '12345' and Devicesno eq '93490' and Udid eq '94343'

#pragma mark - odata details
///sap/opu/odata/EMT/PMAPP_SRV/
NSString* const URL_PATH_ODATA = @"/sap/opu/odata/sap/ZEMT_PMAPP_SRV";
NSString* const URL_GET_SYNC_MAP_ODATA = @"ServiceEndPointSet";
NSString* const URL_APP_SETTINGS_ODATA = @"AppSettingsCollection";
NSString* const URL_GET_NOTIFTYPE_ODATA = @"NotificationTypeCollection";
NSString* const URL_GET_NOTIF_PRIORITY_ODATA = @"NotificationPriorityCollection";
NSString* const URL_GET_ORDER_PRIORITY_ODATA = @"OrderPriorityCollection";
NSString* const URL_GET_ORDERTYPE_ODATA = @"OrderTypesCollection";
NSString* const URL_GET_UNITS_ODATA = @"UnitsCollection";
NSString* const URL_GET_ACCINDICATOR_ODATA = @"AccountingIndicatorsCollection";
NSString* const URL_GET_COSTCENTERLIST_ODATA = @"CostCenterCollection";
NSString* const URL_GET_USER_DATA_ODATA = @"UserDataCollection";
NSString* const URL_LOGIN_ODATA = @"AuthLoginDataSet";
NSString* const URL_GET_FUNCLOC_COSTCENTER_ODATA = @"GetFunctionloc";
NSString* const URL_GET_EQUIPNO_COSTCENTER_ODATA = @"GetEqupiment";
NSString* const URL_GET_EQUIPNO_FUNCLOC_ODATA = @"GetEqupiment";
NSString* const URL_FETCH_SESSION_ODATA = @"";
NSString* const URL_CREATE_NOTIFICATION_ODATA = @"NotificationHeaderCollection";
NSString* const URL_GET_LISTOFCOMPONENTS_ODATA = @"ListComponentsCollection";
NSString* const URL_GET_LISTOFMOVEMENTTYPES_ODATA = @"MovementTypesCollection";
NSString* const URL_GET_ALLNOTIFCODES_ODATA = @"NotifCodesHeaderCollection";
NSString* const URL_GET_LIST_OF_NOTIFICATIONS_ODATA = @"NotificationHeaderCollection";
NSString* const URL_GET_LIST_OF_ORDERS_ODATA = @"OrderHeaderCollection";
NSString* const URL_GET_LIST_OF_OPEN_ORDERS_ODATA = @"OrderHeaderCollection";
NSString* const URL_CANCEL_NOTIFICATION_ODATA = @"CompleteNotification";
NSString* const URL_COMPLETE_NOTIFICATION_ODATA = @"CompleteNotification";
NSString* const URL_GET_LIST_OF_PM_BOMS_ODATA = @"EquipmentHeaderCollection";

NSString* const URL_CREATE_ORDER_ODATA = @"OrderHeaderCollection";
NSString* const URL_CHANGE_ORDER_ODATA = @"OrderHeaderCollection";
NSString* const URL_CANCEL_ORDER_ODATA = @"OrderComplete";
NSString* const URL_CONFIRM_ORDER_ODATA = @"ConfirmOrder";
NSString* const URL_GET_LOG_DATA_ODATA = @"GetLogDataCollection";
NSString* const URL_RESERVE_UTILITY_ODATA = @"ReservationHeaderCollection";
NSString* const URL_GET_STOCK_DATA_ODATA = @"StockDataCollection";

NSString* const URL_GET_MATERIAL_AVAILABILITY_ODATA = @"AvailabilityCheck";
NSString* const URL_GET_PERMITS_DATA_ODATA = @"MasterPermitsCollection";

@end

