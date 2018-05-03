//
//  ModelClass.h
//  DataBase
//
//  Created by Deepak Gantala on 09/10/13.
//  Copyright (c) 2013 Enstrapp IT Solutions . All rights reserved.
//


#import <Foundation/Foundation.h>

@interface ModelClass : NSObject
{
    
}
//CodeGroup
@property (nonatomic, retain) NSString *str_CAUSEGRP,*str_CGRPTEXT,*str_CAUSE,*str_CAUSETEXT;

//CauseCode
@property (nonatomic, retain) NSString *str_CODEGRUPPE,*str_KURZTEXT,*str_CODE,*str_KURZTEXT1;

//NotifType
@property(nonatomic, retain) NSString *str_QMART,*str_QMARTX;

//OrderType
@property(nonatomic, retain) NSString *str_Auart,*str_Txt;

//Priority
@property(nonatomic, retain) NSString *str_Priok,*str_Priokx;

//PersonReprting
@property (nonatomic, retain) NSString *str_KUNNR,*str_NAMES1;

@property (nonatomic, retain) NSString *str_Component,*str_Problem,*str_Text,*str_CauseGroup,*str_CauseCode,*str_Text1,*str_InsertID;
@property (nonatomic, retain) NSString *str_LongQmnum,*str_LongTextLine;

@property (nonatomic, retain) NSString *str_BRKDWN_FLG,*str_CUSTOMER,*str_EQUIPMENT,*str_FUN_LOC,*str_MALF_START,*str_MALF_END,*str_item_COMPONENT,*str_ITEM_PROBLEM,*str_ITEM_FREETEXT1,*str_ITEM_CAUSEGRP,*str_ITEM_CAUSE,*str_ITEM_FREETEXT2,*str_NOTIFY_TEXT,*str_NOTIFY_TYPE,*str_STATUS,*str_ID,*str_NOTIF_NO,*str_MESSAGE,*str_MALF_STARTTime;
//Functional Location
@property (nonatomic, retain) NSString *str_Pltxt,*str_Tplnr,*str_WerksFuncLoc,*str_Arbpl;
@property (nonatomic, retain) NSString *str_Iwerk;
//Equipment Number
@property (nonatomic, retain) NSString *str_Equnr,*str_Eqktx;

//Acc Indicator
@property (nonatomic, retain) NSString *str_Bemot,*str_BemotText;

//For ETNotifHeader
@property (nonatomic, retain) NSString *str_Qmnum,*str_NotifType,*str_NotifShorttxt,*str_FunctionLoc,*str_Equipment,*str_MalfuncStdate,*str_MalfuncEddate,*str_ReportedBy,*str_BreakdownInd,*str_Closed,*str_Completed;


//For ETNotifItems
@property (nonatomic, retain) NSString *str_CauseCod,*str_CauseGrp,*str_CauseKey,*str_CauseShtxt,*str_ItemKey,*str_ItemdefectCod,*str_ItemdefectGrp,*str_ItemdefectShtxt,*str_Action,*str_NotifItemID;
//For ETOperations
@property (nonatomic, retain) NSString *str_Aufnr,*str_Daune,*str_Dauno,*str_Fsavd,*str_Ltxa1,*str_Rueck,*str_Ssedd,*str_Vornr,*str_OperationsID;

//For ETComponents
@property(nonatomic, retain) NSString *str_AufnrComp,*str_Bdmng,*str_Lgort,*str_Matnr,*str_Meins,*str_Posnr,*str_Rsnum,*str_Rspos,*str_VornrComp,*str_Werks,*str_CompID;

@property (nonatomic, retain) NSString *str_BomComp,*str_CompText,*str_Quantity,*str_Unit,*str_BomID,*str_Strlkz;

@property (nonatomic, retain) NSString *str_LongActivity,*str_LongTextLineID;

@property (nonatomic, retain) NSString *str_Kostl,*str_Ktext;

@property (nonatomic, retain) NSString *str_MatnrListOfComponents,*str_MaktxListOfComponents;

@property (nonatomic, retain) NSString *str_UnitTypeGetUnitType,*str_MeinsGetUnits;

@property (nonatomic, retain) NSString *str_Btext,*str_Bwart;

@property (nonatomic, retain) NSString *str_CCenter;

@property (nonatomic, retain) NSString *str_Date,*str_Time,*str_DocumentCategory,*str_ActivityType,*str_User,*str_ObjectId,*str_Status,*str_GUID,*str_Message;

// NSString *astr_Auart,*astr_Aufnr,*astr_Erdat,*astr_Ernam,*astr_Gltrp,*astr_Gstrp,*astr_Ktext,*astr_Completed,*astr_Closed,*astr_Priok,*astr_Strno,*astr_TplnrInt,*astr_Vaplz,*astr_Werks,*astr_ID;
@property (nonatomic, retain) NSString *str_Erdat,*str_Ernam,*str_Gltrp,*str_Gstrp,*str_Strno,*str_TplnrInt,*str_Vaplz;
@end
