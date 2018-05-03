//
//  Equipment.h
//  PMCockpit
//
//  Created by Shyam Chandar on 08/03/15.
//  Copyright (c) 2015 Enstrapp IT Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class FunctionalLocation;

@interface Equipment : NSManagedObject

@property (nonatomic, retain) NSString * catalogProfileID;
@property (nonatomic, retain) NSString * equipmentName;
@property (nonatomic, retain) NSString * equipmentID,*equipmentHID,*sequip,*level;
@property (nonatomic, retain) NSString * plantName;
@property (nonatomic, retain) NSString * workStation;
@property (nonatomic, retain) NSString *costCenter;//Kostl

@property (nonatomic, retain) NSString *tplnr,*pltxt;

@property (nonatomic, retain) NSString *herst,*mapar,*serge,*typbz,*anlnr,*anlun,*ivdat,*invzu,*iwerks,*ingrp,*eqart;


@property (nonatomic, retain) FunctionalLocation *location;

@end
