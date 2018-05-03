//
//  NotificationObjects.h
//  Fieldtekpro
//
//  Created by Enstrapp Bangalore on 10/08/15.
//  Copyright (c) 2015 Enstrapp IT Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NotificationObjects : NSObject

@property(nonatomic, retain) NSString *notificationUUID,*notificationTypeID,*notificationTypeText,*notificationShortText,*notificationLongText,*funcLocID,*funcLocText,*equipNoID,*equipNoText,*priorityID,*priorityText,*startMalFuncDate,*endMalfuncDate,*breakDownCheck,*notificationNumber,*notificationStatus,*notificationHeaderPlantID,*notificationHeaderWorkCenterID,*reportedBy,*reqStartDate,*reqEndDate,*shiftType,*noofperson,*effectID,*effectText,*parnrID,*parnrText,*aufnr,*notificationDate,*plannerGroupID,*plannerGroupName;

@property(nonatomic, retain) NSArray *notifCausecodesArray,*notifAttachmentsArray,*notifCustomHeaderDetailsArray;

@end
